#!/usr/bin/env bash
set -euo pipefail

# ----- CONFIG: paths & slugs -----
SV_DIR_SRC="src/pages/cache/somethingventured/episodes"
SV_DIR_PUB="public/cache/somethingventured/episodes"
SV_EPISODES=(
  "frank-rotman-the-midas-list-veteran-on-building-fintech-empires-at-capital-one-and-qed-investors"
  "eric-ries-the-lean-startup-revolution-in-an-ai-driven-world"
  "kobie-fuller-upfront-ventures-partners-high-speed-sprint-from-track-star-to-venture-capital-powerhouse"
)

NX_DIR_SRC="src/pages/cache/nextipedia/middlemen-episodes"
NX_DIR_PUB="public/cache/nextipedia/middlemen-episodes"
NX_EPISODES=(
  "whos-buying-a-sell-side-view-with-shay-brog-of-burt"
  "retail-fluency---claudia-johnson---flywheel-commerce-network"
  "parking-lots-ai-recipes-shopper-marketings-future-with-josh-ginsberg"
  "stop-waxing-poetic-sarah-marzano-of-emarketer-on-in-store-retail-media"
)

# Series/Index pages (we'll just ensure the transcript alt isn't added to these)
SERIES_INDEX_SRC=(
  "src/pages/cache/somethingventured/podcast/index.astro"
  "src/pages/cache/nextipedia/podcast/index.astro"
  "src/pages/cache/nextipedia/middlemen-episodes/index.astro"
)

# ----- SNIPPET used to replace <main>…</main> on EPISODE pages -----
MAIN_SNIPPET_FILE="scripts/_main_snippet.astrofrag"
cat > "$MAIN_SNIPPET_FILE" <<'ASTRO'
    <!-- Breadcrumb nav -->
    <nav aria-label="Breadcrumb" class="meta" style="margin-bottom:12px">
      <ol style="display:flex;gap:.5rem;list-style:none;padding:0;margin:0">
        <li><a href="https://everythingmachines.blog/">Everything Machines</a></li>
        <li>/</li>
        <li><a href="../">Series / Index</a></li>
        <li>/</li>
        <li aria-current="page">{page.title}</li>
      </ol>
    </nav>

    <section class="card" aria-labelledby="tldr"><h2 id="tldr">TL;DR</h2>
      <ul>
        <li>Who the guest is and why they matter.</li>
        <li>1–2 key frameworks or playbooks.</li>
        <li>One contrarian take or insight.</li>
      </ul>
    </section>

    <section class="card" aria-labelledby="learn"><h2 id="learn">What you’ll learn</h2>
      <ul>
        <li>Topic A the episode answers.</li>
        <li>Topic B the episode answers.</li>
        <li>Topic C the episode answers.</li>
      </ul>
    </section>

    <section class="card" aria-labelledby="takeaways"><h2 id="takeaways">Key takeaways</h2>
      <ul>
        <li><strong>Moats:</strong> short phrase.</li>
        <li><strong>Risk:</strong> short phrase.</li>
        <li><strong>Hiring:</strong> short phrase.</li>
      </ul>
    </section>

    <section class="card" aria-labelledby="numbers"><h2 id="numbers">By the numbers</h2>
      <ul>
        <li>~45–60 minutes</li>
        <li>3–5 named companies</li>
        <li>1–2 named frameworks</li>
      </ul>
    </section>

    <section class="card" aria-labelledby="quotes"><h2 id="quotes">Quotes</h2>
      <figure>
        <blockquote>“Add a short, vivid pull-quote here.”</blockquote>
        <figcaption>— Guest <time datetime="00:12:10">12:10</time></figcaption>
      </figure>
      <figure>
        <blockquote>“Second crisp pull-quote.”</blockquote>
        <figcaption>— Guest <time datetime="00:27:45">27:45</time></figcaption>
      </figure>
    </section>

    <section class="card" aria-labelledby="faq"><h2 id="faq">FAQ</h2>
      <dl>
        <dt>Who is the guest?</dt><dd>One-sentence bio.</dd>
        <dt>What’s the guest’s edge?</dt><dd>One-sentence answer.</dd>
        <dt>Actionable steps mentioned?</dt><dd>One-sentence answer.</dd>
      </dl>
    </section>

    <section class="card" aria-labelledby="entities"><h2 id="entities">Entities mentioned</h2>
      <ul>
        <li><a href="#" rel="noopener">Entity 1</a></li>
        <li><a href="#" rel="noopener">Entity 2</a></li>
      </ul>
    </section>

    <!-- Cached body (ensure first heading in source.md is H2, not H1) -->
    <section class="card" aria-labelledby="overview"><h2 id="overview">Overview</h2>
      <Source />
    </section>

    <section class="card" aria-labelledby="chapters"><h2 id="chapters">Chapters</h2>
      <ol>
        <li><a href="#t=0">00:00 Intro</a></li>
        <li><a href="#t=600">10:00 Topic</a></li>
        <li><a href="#t=1800">30:00 Topic</a></li>
      </ol>
    </section>

    <section class="card" aria-labelledby="transcript"><h2 id="transcript">Transcript</h2>
      <p class="meta">Download (when available): <a href="./transcript.txt" rel="noopener">./transcript.txt</a></p>
    </section>

    <section class="card" aria-labelledby="resources"><h2 id="resources">Resources</h2>
      <ul>
        <li><a href={page.urlOriginal} rel="noopener">Original page</a></li>
        <li><a href="./schema.json">schema.json</a> • <a href="./source.json">source.json</a></li>
      </ul>
    </section>
ASTRO

# ----- helpers -----
demote_first_h1 () {
  local md="$1"
  [[ -f "$md" ]] || return 0
  # change only the FIRST markdown H1 to H2
  awk 'f==0 && /^#[[:space:]]/ { sub(/^#[[:space:]]+/,"## "); f=1 } { print }' "$md" > "$md.__tmp__"
  mv "$md.__tmp__" "$md"
}

add_transcript_alt () {
  local astro="$1"
  [[ -f "$astro" ]] || return 0
  # insert transcript alt AFTER schema.json alt if not present
  perl -0777 -i -pe 'if (!m{rel="alternate"\s+type="text/plain"\s+href="\./transcript\.txt"}) { s{(<link rel="alternate" type="application/ld\+json" href="\./schema\.json" />)}{$1\n  <link rel="alternate" type="text/plain" href="./transcript.txt" />} }' "$astro"
}

replace_main_with_snippet () {
  local astro="$1"
  [[ -f "$astro" ]] || return 0
  python3 - "$astro" "$MAIN_SNIPPET_FILE" <<'PY'
import sys, re, pathlib
page = pathlib.Path(sys.argv[1])
snip = pathlib.Path(sys.argv[2]).read_text()
txt = page.read_text()
txt2 = re.sub(r"<main>.*?</main>", "<main>\n"+snip+"\n</main>", txt, flags=re.S)
page.write_text(txt2)
PY
}

ensure_transcript_placeholder () {
  local pubdir="$1"
  mkdir -p "$pubdir"
  [[ -f "$pubdir/transcript.txt" ]] || printf "Transcript placeholder.\n" > "$pubdir/transcript.txt"
}

patch_schema_transcript () {
  # optional; requires jq
  command -v jq >/dev/null 2>&1 || return 0
  local schema="$1" ; local transcript_url="$2"
  [[ -f "$schema" ]] || return 0
  TMP="$schema.__tmp__"
  TRANSCRIPT="$transcript_url" jq '
    (.["@graph"][] | select(."@type"=="PodcastEpisode") | .audio) //= {"@type":"AudioObject"} |
    (.["@graph"][] | select(."@type"=="PodcastEpisode") | .audio.transcript) = env.TRANSCRIPT
  ' "$schema" > "$TMP" && mv "$TMP" "$schema"
}

# ----- EPISODES: process Something Ventured -----
for slug in "${SV_EPISODES[@]}"; do
  demote_first_h1   "${SV_DIR_SRC}/${slug}/source.md"
  replace_main_with_snippet "${SV_DIR_SRC}/${slug}/index.astro"
  add_transcript_alt "${SV_DIR_SRC}/${slug}/index.astro"
  ensure_transcript_placeholder "${SV_DIR_PUB}/${slug}"
  patch_schema_transcript "public/cache/somethingventured/episodes/${slug}/schema.json" \
    "https://everythingmachines.blog/cache/somethingventured/episodes/${slug}/transcript.txt"
done

# ----- EPISODES: process Nextipedia -----
for slug in "${NX_EPISODES[@]}"; do
  demote_first_h1   "${NX_DIR_SRC}/${slug}/source.md"
  replace_main_with_snippet "${NX_DIR_SRC}/${slug}/index.astro"
  add_transcript_alt "${NX_DIR_SRC}/${slug}/index.astro"
  ensure_transcript_placeholder "${NX_DIR_PUB}/${slug}"
  patch_schema_transcript "public/cache/nextipedia/middlemen-episodes/${slug}/schema.json" \
    "https://everythingmachines.blog/cache/nextipedia/middlemen-episodes/${slug}/transcript.txt"
done

# ----- SERIES/INDEX pages: do NOT add transcript alt; no main replacement here -----
for f in "${SERIES_INDEX_SRC[@]}"; do
  [[ -f "$f" ]] || continue
  # You may later add a simpler nav + ItemList manually for these pages.
  :
done

echo "Done. Now: review diffs, adjust quotes/stats, then commit & push."
