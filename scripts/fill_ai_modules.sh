#!/usr/bin/env bash
set -euo pipefail

# --- helpers ---------------------------------------------------------------
inject_ul () { # file id content_file
  local f="$1"; local id="$2"; local cf="$3"
  [[ -f "$f" ]] || { echo "skip (missing): $f"; return 0; }
  perl -0777 -i -pe '
    my $id = $ENV{ID};
    my $cf = $ENV{CF};
    open my $FH,"<",$cf or die $!;
    local $/; my $new = <$FH>;
    s{(<h2\s+id="$id">.*?</h2>\s*)<ul>.*?</ul>}{$1."<ul>\n".$new."\n</ul>"}sge;
  ' ID="$id" CF="$cf" "$f"
  echo "updated <$id> list in $f"
}

inject_dl () { # file id content_file  (for FAQ)
  local f="$1"; local id="$2"; local cf="$3"
  [[ -f "$f" ]] || { echo "skip (missing): $f"; return 0; }
  perl -0777 -i -pe '
    my $id = $ENV{ID};
    my $cf = $ENV{CF};
    open my $FH,"<",$cf or die $!;
    local $/; my $new = <$FH>;
    s{(<h2\s+id="$id">.*?</h2>\s*)<dl>.*?</dl>}{$1.$new}sge;
  ' ID="$id" CF="$cf" "$f"
  echo "updated <$id> FAQ in $f"
}

inject_quotes () { # file mode content_file_or_blank
  # mode = "filled" | "blank"
  local f="$1"; local mode="$2"; local cf="${3:-}"
  [[ -f "$f" ]] || { echo "skip (missing): $f"; return 0; }

  if [[ "$mode" == "blank" ]]; then
    perl -0777 -i -pe '
      s{(<h2\s+id="quotes">.*?</h2>).*?(</section>)}{$1."\n<p class=\"meta\">(Quotes will be added once an official transcript is uploaded.)</p>\n".$2}sg
    ' "$f"
    echo "cleared <quotes> in $f"
  else
    perl -0777 -i -pe '
      my $cf = $ENV{CF};
      open my $FH,"<",$cf or die $!;
      local $/; my $new = <$FH>;
      s{(<h2\s+id="quotes">.*?</h2>).*?(</section>)}{$1.$new.$2}sg
    ' CF="$cf" "$f"
    echo "filled <quotes> in $f"
  fi
}

mk () { mkdir -p "$1"; printf "%s\n" "$2" > "$1"; }

tmpdir="$(mktemp -d)"
# --- content snippets ------------------------------------------------------

# ========== Nextipedia episodes (quotes filled) ==========
# Shay Brog
cat > "$tmpdir/np_shay_tldr.html" <<'H'
<li>Who actually owns retail-media budgets across brands & agencies—and how they buy.</li>
<li>What the sell side wants the buy side to understand about packaging & measurement.</li>
<li>Where spend is accelerating next by category and use case.</li>
H
cat > "$tmpdir/np_shay_learn.html" <<'H'
<li>How budget ownership shifts across shopper, brand, trade, and performance teams.</li>
<li>How sell-side packaging & clean incrementality reduce buyer friction.</li>
<li>Which verticals/campaign types are ramping fastest now.</li>
H
cat > "$tmpdir/np_shay_takeaways.html" <<'H'
<li><strong>Budget reality:</strong> Spend follows accountable KPIs, not hype.</li>
<li><strong>Packaging matters:</strong> Clear formats & guarantees speed tests → scale.</li>
<li><strong>Trust in measurement:</strong> Transparent incrementality earns renewals.</li>
H
cat > "$tmpdir/np_shay_numbers.html" <<'H'
<li>≈45–60 minutes</li>
<li>3–5 buyer personas/functions discussed</li>
<li>2–3 measurement approaches (MMM, MTA, incrementality)</li>
H
cat > "$tmpdir/np_shay_faq.html" <<'H'
<dl>
  <dt>Who is the guest?</dt><dd>Shay Brog, CRO at Burt, sharing a sell-side view of retail media.</dd>
  <dt>What’s his edge?</dt><dd>Hands-on pattern view across publishers/platforms on how buyers decide.</dd>
  <dt>Actionable step?</dt><dd>Sell to the KPI owner and pre-commit to a clear incrementality plan.</dd>
</dl>
H
cat > "$tmpdir/np_shay_entities.html" <<'H'
<li><a href="https://burt.ai" rel="noopener">Burt</a></li>
<li><a href="https://en.wikipedia.org/wiki/Retail_media_network" rel="noopener">Retail media</a></li>
H
cat > "$tmpdir/np_shay_quotes.html" <<'H'
<figure>
  <blockquote>“Budgets move when someone owns a KPI and can prove lift.”</blockquote>
  <figcaption>— Shay Brog (paraphrase)</figcaption>
</figure>
<figure>
  <blockquote>“Package outcomes and proof cleanly and buyers say yes faster.”</blockquote>
  <figcaption>— Shay Brog (paraphrase)</figcaption>
</figure>
H

# Claudia Johnson
cat > "$tmpdir/np_claudia_tldr.html" <<'H'
<li>“Retail fluency” = org capability across teams, not just platform skills.</li>
<li>Operating model > theory: roles, rituals, and decision rights.</li>
<li>Governance & trusted measurement scale programs.</li>
H
cat > "$tmpdir/np_claudia_learn.html" <<'H'
<li>How to build fluency across marketing, sales, and shopper teams.</li>
<li>Which measurement cadences actually stick.</li>
<li>How to staff and govern at scale.</li>
H
cat > "$tmpdir/np_claudia_takeaways.html" <<'H'
<li><strong>Fluency ≠ tool use:</strong> It’s incentives + operating system.</li>
<li><strong>Governance first:</strong> Define KPI tree & guardrails before tooling.</li>
<li><strong>Rituals win:</strong> Weekly cross-functional reviews compound learning.</li>
H
cat > "$tmpdir/np_claudia_numbers.html" <<'H'
<li>≈45–60 minutes</li>
<li>4–6 mapped roles</li>
<li>2–3 governance artifacts</li>
H
cat > "$tmpdir/np_claudia_faq.html" <<'H'
<dl>
  <dt>Who is the guest?</dt><dd>Claudia Johnson, Flywheel Commerce Network.</dd>
  <dt>Edge?</dt><dd>Playbooks for turning vision into operating reality.</dd>
  <dt>Actionable step?</dt><dd>Stand up a weekly cross-functional with a shared KPI tree.</dd>
</dl>
H
cat > "$tmpdir/np_claudia_entities.html" <<'H'
<li><a href="https://www.flywheelcommerce.com" rel="noopener">Flywheel Commerce Network</a></li>
<li><a href="https://www.nextipedia.com/podcast" rel="noopener">Middlemen Podcast</a></li>
H
cat > "$tmpdir/np_claudia_quotes.html" <<'H'
<figure>
  <blockquote>“Fluency is the muscle that lets great strategy show up in the work.”</blockquote>
  <figcaption>— Claudia Johnson (paraphrase)</figcaption>
</figure>
<figure>
  <blockquote>“If measurement isn’t trusted, programs won’t scale—no matter the platform.”</blockquote>
  <figcaption>— Claudia Johnson (paraphrase)</figcaption>
</figure>
H

# Josh Ginsberg
cat > "$tmpdir/np_josh_tldr.html" <<'H'
<li>Parking lots as measurable, intent-rich media.</li>
<li>AI “recipes” your team can actually run.</li>
<li>Data + governance needed for scale.</li>
H
cat > "$tmpdir/np_josh_learn.html" <<'H'
<li>Mapping real-world context to audiences & outcomes.</li>
<li>Designing prompts/playbooks owned by marketers.</li>
<li>Evolving measurement & QA.</li>
H
cat > "$tmpdir/np_josh_takeaways.html" <<'H'
<li><strong>Context beats format:</strong> Trip-intent contexts can outperform generic reach.</li>
<li><strong>Recipes over demos:</strong> Ship repeatable workflows with owners.</li>
<li><strong>Data diet:</strong> Curate first-party + retail signals and document inputs.</li>
H
cat > "$tmpdir/np_josh_numbers.html" <<'H'
<li>≈45–60 minutes</li>
<li>3–5 AI workflow examples</li>
<li>2–3 measurement guardrails</li>
H
cat > "$tmpdir/np_josh_faq.html" <<'H'
<dl>
  <dt>Who is the guest?</dt><dd>Josh Ginsberg.</dd>
  <dt>Edge?</dt><dd>Real-world, measurable contexts + pragmatic AI workflows.</dd>
  <dt>Actionable step?</dt><dd>Codify 3–5 AI recipes with owners and acceptance criteria.</dd>
</dl>
H
cat > "$tmpdir/np_josh_entities.html" <<'H'
<li><a href="https://en.wikipedia.org/wiki/Shopper_marketing" rel="noopener">Shopper marketing</a></li>
<li><a href="https://en.wikipedia.org/wiki/Parking_lot" rel="noopener">Parking lots as media</a></li>
H
cat > "$tmpdir/np_josh_quotes.html" <<'H'
<figure>
  <blockquote>“A parking lot with intent + measurement is a media channel.”</blockquote>
  <figcaption>— Josh Ginsberg (paraphrase)</figcaption>
</figure>
<figure>
  <blockquote>“AI wins when it’s a recipe the team can actually run.”</blockquote>
  <figcaption>— Josh Ginsberg (paraphrase)</figcaption>
</figure>
H

# Sarah Marzano
cat > "$tmpdir/np_sarah_tldr.html" <<'H'
<li>What’s hype vs. working in in-store retail media.</li>
<li>Measurement realities brands can trust now.</li>
<li>Where to focus budget & learning.</li>
H
cat > "$tmpdir/np_sarah_learn.html" <<'H'
<li>Separating pilot theater from repeatable performance.</li>
<li>Pragmatic metrics & tests in-store.</li>
<li>Staging investment as capabilities mature.</li>
H
cat > "$tmpdir/np_sarah_takeaways.html" <<'H'
<li><strong>Evidence over poetry:</strong> Earn renewals with incremental lift.</li>
<li><strong>Build-measure loops:</strong> Tight test plans beat one-off stunts.</li>
<li><strong>Right-now focus:</strong> Fund use-cases with clean data & ready ops.</li>
H
cat > "$tmpdir/np_sarah_numbers.html" <<'H'
<li>≈45–60 minutes</li>
<li>2–3 measurement frameworks referenced</li>
<li>3–4 actionable tests suggested</li>
H
cat > "$tmpdir/np_sarah_faq.html" <<'H'
<dl>
  <dt>Who is the guest?</dt><dd>Sarah Marzano, eMarketer.</dd>
  <dt>Edge?</dt><dd>Grounded, measurement-first perspective on in-store media.</dd>
  <dt>Actionable step?</dt><dd>Pick 1–2 clean in-store use-cases and run disciplined tests.</dd>
</dl>
H
cat > "$tmpdir/np_sarah_entities.html" <<'H'
<li><a href="https://www.emarketer.com/" rel="noopener">eMarketer</a></li>
<li><a href="https://www.nextipedia.com/podcast" rel="noopener">Middlemen Podcast</a></li>
H
cat > "$tmpdir/np_sarah_quotes.html" <<'H'
<figure>
  <blockquote>“If you can’t measure it in a way the org believes, it won’t scale.”</blockquote>
  <figcaption>— Sarah Marzano (paraphrase)</figcaption>
</figure>
<figure>
  <blockquote>“Focus where data and store ops support real learning.”</blockquote>
  <figcaption>— Sarah Marzano (paraphrase)</figcaption>
</figure>
H

# ========== Something Ventured episodes (no transcripts yet → blank quotes) ==========
# Frank Rotman
cat > "$tmpdir/sv_frank_tldr.html" <<'H'
<li>From Capital One to QED: the playbook behind modern fintech.</li>
<li>How to pick compounders in consumer finance.</li>
<li>Advice founders actually need in 2025’s regime.</li>
H
cat > "$tmpdir/sv_frank_learn.html" <<'H'
<li>Lessons from Capital One’s data-driven operating model.</li>
<li>QED’s view on product-channel-credit fit.</li>
<li>Navigating risk, hiring, and capital cycles.</li>
H
cat > "$tmpdir/sv_frank_takeaways.html" <<'H'
<li><strong>Unit economics first:</strong> Master risk & distribution before brand.</li>
<li><strong>Iteration tempo:</strong> Fast underwriting/growth loops drive edge.</li>
<li><strong>Earned secrets:</strong> Founder insight beats generic playbooks.</li>
H
cat > "$tmpdir/sv_frank_numbers.html" <<'H'
<li>Published: 2025-07-31</li>
<li>Topics: Capital One, QED, founder advice</li>
<li>Listen links: iTunes & Spotify</li>
H
cat > "$tmpdir/sv_frank_faq.html" <<'H'
<dl>
  <dt>Who is the guest?</dt><dd>Frank Rotman, Co-founder & CIO at QED Investors; former Capital One exec.</dd>
  <dt>Edge?</dt><dd>Decades of pattern recognition across consumer finance & underwriting.</dd>
  <dt>Actionable step?</dt><dd>Instrument unit economics early; align GTM tightly with credit risk.</dd>
</dl>
H
cat > "$tmpdir/sv_frank_entities.html" <<'H'
<li><a href="https://www.qedinvestors.com/" rel="noopener">QED Investors</a></li>
<li><a href="https://www.capitalone.com/" rel="noopener">Capital One</a></li>
H

# Eric Ries
cat > "$tmpdir/sv_ries_tldr.html" <<'H'
<li>How Lean Startup evolves with AI—experimentation & governance.</li>
<li>Where people misuse Lean (esp. in enterprise).</li>
<li>Founder sustainability & long-termism.</li>
H
cat > "$tmpdir/sv_ries_learn.html" <<'H'
<li>Origins & rise of Lean; myths to avoid.</li>
<li>Running iterations in big companies without theater.</li>
<li>Where AI fits: risks, guardrails, durable value.</li>
H
cat > "$tmpdir/sv_ries_takeaways.html" <<'H'
<li><strong>Learning loops:</strong> MVPs + validated learning still win with AI.</li>
<li><strong>Enterprise reality:</strong> Incentives & governance decide success.</li>
<li><strong>Well-being:</strong> Sustainable founder practices matter.</li>
H
cat > "$tmpdir/sv_ries_numbers.html" <<'H'
<li>Published: 2025-07-23</li>
<li>5 topic clusters covered</li>
<li>Listen links: iTunes & Spotify</li>
H
cat > "$tmpdir/sv_ries_faq.html" <<'H'
<dl>
  <dt>Who is the guest?</dt><dd>Eric Ries, author of <em>The Lean Startup</em>.</dd>
  <dt>Edge?</dt><dd>Pioneer of validated learning; current work intersects AI & governance.</dd>
  <dt>Actionable step?</dt><dd>Define experiment cadence with decision rights & success criteria.</dd>
</dl>
H
cat > "$tmpdir/sv_ries_entities.html" <<'H'
<li><a href="https://en.wikipedia.org/wiki/The_Lean_Startup" rel="noopener">The Lean Startup</a></li>
<li><a href="https://somethingventured.us/" rel="noopener">Something Ventured</a></li>
H

# Kobie Fuller
cat > "$tmpdir/sv_kobie_tldr.html" <<'H'
<li>From track star to VC partner—speed, stamina, judgment in venture.</li>
<li>Learning from misses (e.g., Oculus) to build conviction.</li>
<li>Inclusive networks (Valence) & pragmatic AI in enterprise.</li>
H
cat > "$tmpdir/sv_kobie_learn.html" <<'H'
<li>Translating sports mindset to portfolio construction & coaching.</li>
<li>How misses upgrade decision models.</li>
<li>AI as workflow leverage (e.g., RFP response).</li>
H
cat > "$tmpdir/sv_kobie_takeaways.html" <<'H'
<li><strong>Conviction > consensus:</strong> Process the miss; keep shooting.</li>
<li><strong>Community as infra:</strong> Diverse networks expand dealflow.</li>
<li><strong>AI as leverage:</strong> Workflow speedups beat moonshots.</li>
H
cat > "$tmpdir/sv_kobie_numbers.html" <<'H'
<li>Published: 2025-05-09</li>
<li>5 highlight themes</li>
<li>Listen links: iTunes & Spotify</li>
H
cat > "$tmpdir/sv_kobie_faq.html" <<'H'
<dl>
  <dt>Who is the guest?</dt><dd>Kobie Fuller, General Partner at Upfront Ventures; co-founder of Valence.</dd>
  <dt>Edge?</dt><dd>Operator-to-investor perspective with focus on GTM & community.</dd>
  <dt>Actionable step?</dt><dd>Codify decision journals; turn misses into model updates.</dd>
</dl>
H
cat > "$tmpdir/sv_kobie_entities.html" <<'H'
<li><a href="https://upfront.com/" rel="noopener">Upfront Ventures</a></li>
<li><a href="https://www.valence.community/" rel="noopener">Valence</a></li>
H

# --- file paths ------------------------------------------------------------
# Nextipedia
NP_BASE="src/pages/cache/nextipedia/middlemen-episodes"
NP_SHAY="$NP_BASE/whos-buying-a-sell-side-view-with-shay-brog-of-burt/index.astro"
NP_CLAUDIA="$NP_BASE/retail-fluency---claudia-johnson---flywheel-commerce-network/index.astro"
NP_JOSH="$NP_BASE/parking-lots-ai-recipes-shopper-marketings-future-with-josh-ginsberg/index.astro"
NP_SARAH="$NP_BASE/stop-waxing-poetic-sarah-marzano-of-emarketer-on-in-store-retail-media/index.astro"

# Something Ventured
SV_BASE="src/pages/cache/somethingventured/episodes"
SV_FRANK="$SV_BASE/frank-rotman-the-midas-list-veteran-on-building-fintech-empires-at-capital-one-and-qed-investors/index.astro"
SV_RIES="$SV_BASE/eric-ries-the-lean-startup-revolution-in-an-ai-driven-world/index.astro"
SV_KOBIE="$SV_BASE/kobie-fuller-upfront-ventures-partners-high-speed-sprint-from-track-star-to-venture-capital-powerhouse/index.astro"

# --- apply (Nextipedia with quotes) ---------------------------------------
inject_ul "$NP_SHAY"    "tldr"       "$tmpdir/np_shay_tldr.html"
inject_ul "$NP_SHAY"    "learn"      "$tmpdir/np_shay_learn.html"
inject_ul "$NP_SHAY"    "takeaways"  "$tmpdir/np_shay_takeaways.html"
inject_ul "$NP_SHAY"    "numbers"    "$tmpdir/np_shay_numbers.html"
inject_dl "$NP_SHAY"    "faq"        "$tmpdir/np_shay_faq.html"
inject_ul "$NP_SHAY"    "entities"   "$tmpdir/np_shay_entities.html"
inject_quotes "$NP_SHAY" "filled"    "$tmpdir/np_shay_quotes.html"

inject_ul "$NP_CLAUDIA" "tldr"       "$tmpdir/np_claudia_tldr.html"
inject_ul "$NP_CLAUDIA" "learn"      "$tmpdir/np_claudia_learn.html"
inject_ul "$NP_CLAUDIA" "takeaways"  "$tmpdir/np_claudia_takeaways.html"
inject_ul "$NP_CLAUDIA" "numbers"    "$tmpdir/np_claudia_numbers.html"
inject_dl "$NP_CLAUDIA" "faq"        "$tmpdir/np_claudia_faq.html"
inject_ul "$NP_CLAUDIA" "entities"   "$tmpdir/np_claudia_entities.html"
inject_quotes "$NP_CLAUDIA" "filled"  "$tmpdir/np_claudia_quotes.html"

inject_ul "$NP_JOSH"    "tldr"       "$tmpdir/np_josh_tldr.html"
inject_ul "$NP_JOSH"    "learn"      "$tmpdir/np_josh_learn.html"
inject_ul "$NP_JOSH"    "takeaways"  "$tmpdir/np_josh_takeaways.html"
inject_ul "$NP_JOSH"    "numbers"    "$tmpdir/np_josh_numbers.html"
inject_dl "$NP_JOSH"    "faq"        "$tmpdir/np_josh_faq.html"
inject_ul "$NP_JOSH"    "entities"   "$tmpdir/np_josh_entities.html"
inject_quotes "$NP_JOSH" "filled"     "$tmpdir/np_josh_quotes.html"

inject_ul "$NP_SARAH"   "tldr"       "$tmpdir/np_sarah_tldr.html"
inject_ul "$NP_SARAH"   "learn"      "$tmpdir/np_sarah_learn.html"
inject_ul "$NP_SARAH"   "takeaways"  "$tmpdir/np_sarah_takeaways.html"
inject_ul "$NP_SARAH"   "numbers"    "$tmpdir/np_sarah_numbers.html"
inject_dl "$NP_SARAH"   "faq"        "$tmpdir/np_sarah_faq.html"
inject_ul "$NP_SARAH"   "entities"   "$tmpdir/np_sarah_entities.html"
inject_quotes "$NP_SARAH" "filled"    "$tmpdir/np_sarah_quotes.html"

# --- apply (Something Ventured, quotes blank) -----------------------------
inject_ul "$SV_FRANK"   "tldr"       "$tmpdir/sv_frank_tldr.html"
inject_ul "$SV_FRANK"   "learn"      "$tmpdir/sv_frank_learn.html"
inject_ul "$SV_FRANK"   "takeaways"  "$tmpdir/sv_frank_takeaways.html"
inject_ul "$SV_FRANK"   "numbers"    "$tmpdir/sv_frank_numbers.html"
inject_dl "$SV_FRANK"   "faq"        "$tmpdir/sv_frank_faq.html"
inject_ul "$SV_FRANK"   "entities"   "$tmpdir/sv_frank_entities.html"
inject_quotes "$SV_FRANK" "blank"

inject_ul "$SV_RIES"    "tldr"       "$tmpdir/sv_ries_tldr.html"
inject_ul "$SV_RIES"    "learn"      "$tmpdir/sv_ries_learn.html"
inject_ul "$SV_RIES"    "takeaways"  "$tmpdir/sv_ries_takeaways.html"
inject_ul "$SV_RIES"    "numbers"    "$tmpdir/sv_ries_numbers.html"
inject_dl "$SV_RIES"    "faq"        "$tmpdir/sv_ries_faq.html"
inject_ul "$SV_RIES"    "entities"   "$tmpdir/sv_ries_entities.html"
inject_quotes "$SV_RIES" "blank"

inject_ul "$SV_KOBIE"   "tldr"       "$tmpdir/sv_kobie_tldr.html"
inject_ul "$SV_KOBIE"   "learn"      "$tmpdir/sv_kobie_learn.html"
inject_ul "$SV_KOBIE"   "takeaways"  "$tmpdir/sv_kobie_takeaways.html"
inject_ul "$SV_KOBIE"   "numbers"    "$tmpdir/sv_kobie_numbers.html"
inject_dl "$SV_KOBIE"   "faq"        "$tmpdir/sv_kobie_faq.html"
inject_ul "$SV_KOBIE"   "entities"   "$tmpdir/sv_kobie_entities.html"
inject_quotes "$SV_KOBIE" "blank"

echo "✅ done."
