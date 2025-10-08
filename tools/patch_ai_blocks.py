import sys, io, re, os

SECTION_IDS = ["tldr","learn","takeaways","numbers","quotes","faq","entities"]

HTML = {
  "tldr": """<section class="card" aria-labelledby="tldr"><h2 id="tldr">TL;DR</h2>
{Array.isArray(ai?.tldr) && ai.tldr.length ? <ul>{ai.tldr.map(i => <li set:html={i} />)}</ul> : <ul>
  <li>Who the guest is and why they matter.</li>
  <li>1–2 key frameworks or playbooks.</li>
  <li>One contrarian take or insight.</li>
</ul>}
</section>""",
  "learn": """<section class="card" aria-labelledby="learn"><h2 id="learn">What you’ll learn</h2>
{Array.isArray(ai?.learn) && ai.learn.length ? <ul>{ai.learn.map(i => <li set:html={i} />)}</ul> : <ul>
  <li>Topic A the episode answers.</li>
  <li>Topic B the episode answers.</li>
  <li>Topic C the episode answers.</li>
</ul>}
</section>""",
  "takeaways": """<section class="card" aria-labelledby="takeaways"><h2 id="takeaways">Key takeaways</h2>
{Array.isArray(ai?.takeaways) && ai.takeaways.length ? <ul>{ai.takeaways.map(i => <li set:html={i} />)}</ul> : <ul>
  <li><strong>Moats:</strong> short phrase.</li>
  <li><strong>Risk:</strong> short phrase.</li>
  <li><strong>Hiring:</strong> short phrase.</li>
</ul>}
</section>""",
  "numbers": """<section class="card" aria-labelledby="numbers"><h2 id="numbers">By the numbers</h2>
{Array.isArray(ai?.numbers) && ai.numbers.length ? <ul>{ai.numbers.map(i => <li set:html={i} />)}</ul> : <ul>
  <li>~45–60 minutes</li>
  <li>3–5 named companies</li>
  <li>1–2 named frameworks</li>
</ul>}
</section>""",
  "quotes": """<section class="card" aria-labelledby="quotes"><h2 id="quotes">Quotes</h2>
{Array.isArray(ai?.quotes) && ai.quotes.length
  ? <div>{ai.quotes.map(q => <figure><blockquote>“{q.text}”</blockquote><figcaption>— {q.speaker} {q.time && <time datetime={q.time}>{q.time}</time>}</figcaption></figure>)}</div>
  : <div></div>}
</section>""",
  "faq": """<section class="card" aria-labelledby="faq"><h2 id="faq">FAQ</h2>
{Array.isArray(ai?.faq) && ai.faq.length ? <dl>{ai.faq.map(i => <><dt>{i.q}</dt><dd>{i.a}</dd></>)}</dl> : <dl>
  <dt>Who is the guest?</dt><dd>One-sentence bio.</dd>
  <dt>What’s the guest’s edge?</dt><dd>One-sentence answer.</dd>
  <dt>Actionable steps mentioned?</dt><dd>One-sentence answer.</dd>
</dl>}
</section>""",
  "entities": """<section class="card" aria-labelledby="entities"><h2 id="entities">Entities mentioned</h2>
{Array.isArray(ai?.entities) && ai.entities.length ? <ul>{ai.entities.map(e => <li>{e.url ? <a href={e.url} rel="noopener">{e.name}</a> : e.name}</li>)}</ul> : <ul>
  <li>Entity 1</li>
  <li>Entity 2</li>
</ul>}
</section>"""
}

def ensure_ai_import(src:str)->str:
    if "import ai from './ai.json';" in src:
        return src
    if "import Source from './source.md';" in src:
        return src.replace(
            "import Source from './source.md';",
            "import Source from './source.md';\nimport ai from './ai.json';"
        )
    m = re.search(r"^---[\s\S]*?---", src, flags=re.M)
    if m:
        block = m.group(0)
        if "import ai from './ai.json';" not in block:
            block = block[:-3] + "\nimport ai from './ai.json';\n---"
            src = src[:m.start()] + block + src[m.end():]
    return src

def extract_main(src:str):
    m = re.search(r"<main[^>]*>([\s\S]*?)</main>", src, flags=re.S|re.I)
    return (m, m.group(1) if m else None)

def strip_existing_target_sections(html:str)->str:
    out = html
    for sid in SECTION_IDS:
        out = re.sub(
            rf"<section\b[^>]*id=[\"']{sid}[\"'][\s\S]*?</section>",
            "",
            out, flags=re.I
        )
    return out

def build_blocks()->str:
    return "\n".join(HTML[k] for k in SECTION_IDS) + "\n"

def patch(path):
    with io.open(path, "r", encoding="utf-8") as f:
        src = f.read()

    src = ensure_ai_import(src)

    m, main_html = extract_main(src)
    if not m:
        print("skip (no <main>)", path)
        return

    remainder = strip_existing_target_sections(main_html)
    new_main = build_blocks() + remainder

    new_src = src[:m.start(1)] + new_main + src[m.end(1):]
    with io.open(path, "w", encoding="utf-8") as f:
        f.write(new_src)
    print("patched", path)

if __name__ == "__main__":
    paths = sys.argv[1:]
    if not paths:
        print("usage: python3 tools/patch_ai_blocks.py <file1> <file2> ...")
        sys.exit(1)
    for p in paths:
        if os.path.exists(p):
            patch(p)
        else:
            print("skip (missing)", p)
