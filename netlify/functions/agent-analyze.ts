import type { Handler } from "@netlify/functions";
import { parse } from "node-html-parser";

// Safer defaults
const MODEL = process.env.CLAUDE_MODEL || "claude-3-5-sonnet-latest";
const MAX_HTML = 180_000; // truncate huge pages to ~180k chars

// Defensive JSON parse (strips fences/whitespace and slices to outermost {...})
function safeParseJSON(s: string) {
  if (!s) throw new Error("empty response");
  let t = s.trim();
  // strip ```json fences if present
  t = t.replace(/^```(?:json)?\s*/i, "").replace(/\s*```$/i, "");
  // grab the first {...} block if model emits extra text
  const start = t.indexOf("{");
  const end = t.lastIndexOf("}");
  if (start === -1 || end === -1 || end <= start) throw new Error("no JSON object found");
  t = t.slice(start, end + 1);
  return JSON.parse(t);
}

export const handler: Handler = async (event) => {
  if (event.httpMethod !== "POST" && event.httpMethod !== "GET") {
    return { statusCode: 405, body: "Method Not Allowed" };
  }
  try {
    const ANTHROPIC_API_KEY = process.env.ANTHROPIC_API_KEY;
    const RUBRIC_JSON = process.env.RUBRIC_JSON;
    if (!ANTHROPIC_API_KEY) return { statusCode: 500, body: "Missing ANTHROPIC_API_KEY" };
    if (!RUBRIC_JSON) return { statusCode: 500, body: "Missing RUBRIC_JSON" };

    // Accept GET ?url=... for quick testing
    const body = event.httpMethod === "GET" ? null : JSON.parse(event.body || "{}");
    const url = (body?.url || new URL(event.rawUrl).searchParams.get("url") || "").trim();
    if (!/^https?:\/\//i.test(url)) return { statusCode: 400, body: "Bad Request: url" };

    // Fetch HTML
    const resp = await fetch(url, { method: "GET", redirect: "follow", headers: { accept: "text/html" } });
    const httpStatus = resp.status;
    let html = await resp.text();
    if (html.length > MAX_HTML) html = html.slice(0, MAX_HTML);

    // Baseline counts (helper only)
    let baseline: { text_chars: number; js_chars: number; text_percent: number } | null = null;
    try {
      const root = parse(html);
      const js = root.querySelectorAll("script").map(s => s.text || "").join("");
      const js_chars = js.length;
      root.querySelectorAll("script,style").forEach(n => n.remove());
      const text = root.text.replace(/\s+/g, " ").trim();
      const text_chars = text.length;
      const denom = Math.max(1, text_chars + js_chars);
      const text_percent = Math.round((text_chars / denom) * 1000) / 10;
      baseline = { text_chars, js_chars, text_percent };
    } catch {
      baseline = null;
    }

    // Prompts
    const system = [
      "You are EverythingScore Agent (Netlify).",
      "",
      "Inputs: url (string), html (string), baseline (object|null), rubric (object).",
      "Return STRICT JSON only (no prose).",
      "",
      "Compute:",
      "- EverythingRatio from html (visible text vs <script> code; 1-decimal).",
      "- Minimal EverythingScore using rubric.minimal (start 100; subtract listed penalties only; clamp).",
      "- Page type from JSON-LD: episode|series|index|generic.",
      "- LLM Visibility v1 ONLY if page_type != generic (use rubric.llm_v1 weights & guardrails); else null.",
      "- Projected: cache_perfect = min(rubric.projection.cache_cap, minimal + sum(cache-fixable deltas)); ideal_perfect = min(rubric.projection.ideal_cap, minimal + sum(all deltas)).",
      "- elements_missing: ONLY from rubric.elements_vocab via rubric.penalty_to_element_map.",
      "- Prefer baseline numbers if present; correct only if html clearly contradicts.",
      "",
      "Schema:",
      '{ "url": "<string>", "http": {"status": <int>}, "ratio": {"text_percent": <number>, "text_chars": <int>, "js_chars": <int>}, "scores": {"everything_minimal": <int>, "llm_visibility_v1": <int|null>}, "projected": {"cache_perfect": <int>, "ideal_perfect": <int>}, "elements_missing": ["WebPage JSON-LD"], "top_issues": ["No WebPage JSON-LD (-15)"], "summary_md": "### Summary\\n- ...\\n- ...\\n- ...\\n", "page_type": "episode|series|index|generic" }'
    ].join("\n");

    const user = [
      `URL: ${url}`,
      "",
      "HTML (raw):",
      html,
      "",
      "Baseline (object or null):",
      JSON.stringify(baseline),
      "",
      "Rubric (JSON):",
      RUBRIC_JSON,
      "",
      "Return STRICT JSON matching the schema in your system prompt. No extra text."
    ].join("\n");

    const msg = await fetch("https://api.anthropic.com/v1/messages", {
      method: "POST",
      headers: {
        "content-type": "application/json",
        "x-api-key": ANTHROPIC_API_KEY,
        "anthropic-version": "2023-06-01"
      },
      body: JSON.stringify({
        model: MODEL,
        max_tokens: 1600,
        temperature: 0.2,
        system,
        // If your Anthropic account supports JSON mode, uncomment:
        // response_format: { type: "json" },
        messages: [{ role: "user", content: user }]
      })
    });

    if (!msg.ok) {
      const err = await msg.text();
      return { statusCode: 502, body: `Claude error: ${err}` };
    }

    const payload = await msg.json() as any;
    const content = Array.isArray(payload?.content) ? payload.content[0]?.text ?? "" : (payload?.content ?? "");
    const json = safeParseJSON(String(content) || "");

    // Attach observed HTTP status
    if (!json.http) json.http = {};
    json.http.status = httpStatus;
    json.url = json.url || url;

    // Optional DB log
    const SUPABASE_URL = process.env.SUPABASE_URL;
    const SUPABASE_KEY = process.env.SUPABASE_SERVICE_KEY;
    if (SUPABASE_URL && SUPABASE_KEY) {
      try {
        await fetch(`${SUPABASE_URL}/rest/v1/reports`, {
          method: "POST",
          headers: { "content-type": "application/json", apikey: SUPABASE_KEY, authorization: `Bearer ${SUPABASE_KEY}` },
          body: JSON.stringify([{
            url: json.url,
            everything_score: json.scores?.everything_minimal,
            llm_v1_score: json.scores?.llm_visibility_v1,
            ratio_text_percent: json.ratio?.text_percent,
            projected_cache: json.projected?.cache_perfect,
            projected_ideal: json.projected?.ideal_perfect,
            elements_missing: json.elements_missing,
            summary_md: json.summary_md,
            email: null
          }])
        });
      } catch { /* non-blocking */ }
    }

    return { statusCode: 200, body: JSON.stringify(json) };
  } catch (e: any) {
    return { statusCode: 500, body: `agent failed: ${e?.message || e}` };
  }
};
