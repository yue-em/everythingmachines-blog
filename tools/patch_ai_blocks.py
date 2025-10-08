import sys, io

REPLACEMENTS = {
  "tldr": """{Array.isArray(ai?.tldr) && ai.tldr.length ? <ul>{ai.tldr.map(i => <li set:html={i} />)}</ul> : <ul>
        <li>Who the guest is and why they matter.</li>
        <li>1–2 key frameworks or playbooks.</li>
        <li>One contrarian take or insight.</li>
      </ul>}""",
  "learn": """{Array.isArray(ai?.learn) && ai.learn.length ? <ul>{ai.learn.map(i => <li set:html={i} />)}</ul> : <ul>
        <li>Topic A the episode answers.</li>
        <li>Topic B the episode answers.</li>
        <li>Topic C the episode answers.</li>
      </ul>}""",
  "takeaways": """{Array.isArray(ai?.takeaways) && ai.takeaways.length ? <ul>{ai.takeaways.map(i => <li set:html={i} />)}</ul> : <ul>
        <li><strong>Moats:</strong> short phrase.</li>
        <li><strong>Risk:</strong> short phrase.</li>
        <li><strong>Hiring:</strong> short phrase.</li>
      </ul>}""",
  "numbers": """{Array.isArray(ai?.numbers) && ai.numbers.length ? <ul>{ai.numbers.map(i => <li set:html={i} />)}</ul> : <ul>
        <li>~45–60 minutes</li>
        <li>3–5 named companies</li>
        <li>1–2 named frameworks</li>
      </ul>}""",
  "faq": """{Array.isArray(ai?.faq) && ai.faq.length ? <dl>{ai.faq.map(i => <><dt>{i.q}</dt><dd>{i.a}</dd></>)}</dl> : <dl>
        <dt>Who is the guest?</dt><dd>One-sentence bio.</dd>
        <dt>What’s the guest’s edge?</dt><dd>One-sentence answer.</dd>
        <dt>Actionable steps mentioned?</dt><dd>One-sentence answer.</dd>
      </dl>}""",
  "entities": """{Array.isArray(ai?.entities) && ai.entities.length ? <ul>{ai.entities.map(e => <li>{e.url ? <a href={e.url} rel="noopener">{e.name}</a> : e.name}</li>)}</ul> : <ul>
        <li>Entity 1</li>
        <li>Entity 2</li>
      </ul>}"""
}

def patch(path):
    t = io.open(path, "r", encoding="utf-8").read()
    if "import ai from './ai.json';" not in t and "import Source from './source.md';" in t:
        t = t.replace("import Source from './source.md';",
                      "import Source from './source.md';\nimport ai from './ai.json';")

    def swap_block(t, sec_id, repl, tag):
        h2 = t.find(f'id="{sec_id}"')
        if h2 == -1: return t
        after = t.find("</h2>", h2)
        if after == -1: return t
        sec_end = t.find("</section>", after)
        if sec_end == -1: sec_end = len(t)
        start = t.find(f"<{tag}", after, sec_end)
        end = t.find(f"</{tag}>", start, sec_end)
        if start == -1 or end == -1: return t
        end += len(f"</{tag}>")
        return t[:start] + repl + t[end:]

    t = swap_block(t, "tldr", REPLACEMENTS["tldr"], "ul")
    t = swap_block(t, "learn", REPLACEMENTS["learn"], "ul")
    t = swap_block(t, "takeaways", REPLACEMENTS["takeaways"], "ul")
    t = swap_block(t, "numbers", REPLACEMENTS["numbers"], "ul")
    t = swap_block(t, "faq", REPLACEMENTS["faq"], "dl")
    t = swap_block(t, "entities", REPLACEMENTS["entities"], "ul")

    io.open(path, "w", encoding="utf-8").write(t)
    print("patched", path)

if __name__ == "__main__":
    for p in sys.argv[1:]:
        patch(p)

