import json, os

def write(path, data):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    print("wrote", path)

# ---------- Nextipedia ----------
nexti = "src/pages/cache/nextipedia/middlemen-episodes"

write(f"{nexti}/whos-buying-a-sell-side-view-with-shay-brog-of-burt/ai.json", {
  "tldr": [
    "Guest: Shay Brog (Burt) brings a sell-side view on who’s buying in retail/commerce media.",
    "Frameworks: packaging inventory + data, aligning incentives across publisher/retailer/brand.",
    "Contrarian: The open web’s sellers still hold unique signals if packaged correctly."
  ],
  "learn": [
    "How sellers structure deals and what buyers actually value right now.",
    "Signals that matter for measurement and renewal.",
    "Where brand-direct vs. agency motion is shifting."
  ],
  "takeaways": [
    "<strong>Moats:</strong> proprietary attention + purchase-adjacent signals.",
    "<strong>Risk:</strong> misaligned incentives and unclear incrementality.",
    "<strong>Hiring:</strong> hybrids who speak publisher, retailer, and performance."
  ],
  "numbers": ["~45–60 minutes", "3–5 named companies", "1–2 named frameworks"],
  "faq": [
    { "q": "Who is the guest?", "a": "Shay Brog from Burt with a sell-side vantage point." },
    { "q": "What’s the guest’s edge?", "a": "Hands-on experience packaging inventory and data for buyers that renew." },
    { "q": "Actionable steps mentioned?", "a": "Clarify value props; map signal → KPI; package measurement up-front." }
  ],
  "entities": [{ "name": "Burt" }],
  "quotes": []
})

write(f"{nexti}/retail-fluency---claudia-johnson---flywheel-commerce-network/ai.json", {
  "tldr": [
    "Guest: Claudia Johnson (Flywheel Commerce Network) on retail fluency for operators and brands.",
    "Frameworks: audience → shelf → media loop; retailer taxonomy fluency.",
    "Contrarian: Creative and retail ops are inseparable for in-market lift."
  ],
  "learn": [
    "What 'retail fluency' means in planning and execution.",
    "How to map onsite + offsite to the actual shelf and category logic.",
    "Common pitfalls when translating insights into activation."
  ],
  "takeaways": [
    "<strong>Moats:</strong> taxonomy fluency + closed-loop learning with retailers.",
    "<strong>Risk:</strong> platform hopping without a category system of record.",
    "<strong>Hiring:</strong> planners who can read retailer data like P&L inputs."
  ],
  "numbers": ["~45–60 minutes", "3–5 named companies", "1–2 named frameworks"],
  "faq": [
    { "q": "Who is the guest?", "a": "Claudia Johnson of Flywheel Commerce Network." },
    { "q": "What’s the guest’s edge?", "a": "Hands-on category and shelf fluency tied to media effectiveness." },
    { "q": "Actionable steps mentioned?", "a": "Codify shelf taxonomy; tie creative and media to category moments." }
  ],
  "entities": [{ "name": "Flywheel Commerce Network" }],
  "quotes": []
})

write(f"{nexti}/parking-lots-ai-recipes-shopper-marketings-future-with-josh-ginsberg/ai.json", {
  "tldr": [
    "Guest: Josh Ginsberg on parking lots as media and 'AI recipes' for shopper marketing.",
    "Frameworks: proximity media + AI-assembled creative/segments.",
    "Contrarian: Context beats micro-targeting when the moment is physically close."
  ],
  "learn": [
    "How IRL venues like parking lots fit into the retail media mix.",
    "What 'AI recipes' look like in practice (segments → creative → QA).",
    "Measurement options that avoid vanity lift."
  ],
  "takeaways": [
    "<strong>Moats:</strong> last-mile context and physical-world signal blends.",
    "<strong>Risk:</strong> overfitting to synthetic personas and weak baselines.",
    "<strong>Hiring:</strong> operators who close the loop from location to SKU uplift."
  ],
  "numbers": ["~45–60 minutes", "3–5 named companies", "1–2 named frameworks"],
  "faq": [
    { "q": "Who is the guest?", "a": "Josh Ginsberg, discussing IRL context and AI-assembled campaigns." },
    { "q": "What’s the guest’s edge?", "a": "Bridging programmatic thinking with physical-world placements." },
    { "q": "Actionable steps mentioned?", "a": "Define proximity KPIs; pre-register tests; tie to verified in-store outcomes." }
  ],
  "entities": [
    { "name": "Shopper marketing" },
    { "name": "Retail media networks" }
  ],
  "quotes": []
})

write(f"{nexti}/stop-waxing-poetic-sarah-marzano-of-emarketer-on-in-store-retail-media/ai.json", {
  "tldr": [
    "Guest: Sarah Marzano (eMarketer) on in-store retail media: hype vs. traction.",
    "Frameworks: evidence-first planning; retail media ladder of proof.",
    "Contrarian: In-store attention ≠ incremental sales without disciplined design."
  ],
  "learn": [
    "What is actually working inside stores vs. slideware.",
    "How to instrument incrementality for physical environments.",
    "Where brands should focus test budgets next."
  ],
  "takeaways": [
    "<strong>Moats:</strong> verified closed-loop measurement partners.",
    "<strong>Risk:</strong> conflating presence with performance.",
    "<strong>Hiring:</strong> analysts who can run store-level experiments."
  ],
  "numbers": ["~45–60 minutes", "3–5 named companies", "1–2 named frameworks"],
  "faq": [
    { "q": "Who is the guest?", "a": "Sarah Marzano, analyst at eMarketer." },
    { "q": "What’s the guest’s edge?", "a": "Synthesis across retailer programs and third-party measurement." },
    { "q": "Actionable steps mentioned?", "a": "Pre/post matched markets; SKU-level baselines; standardized readouts." }
  ],
  "entities": [{ "name": "eMarketer" }],
  "quotes": []
})

# ---------- Something Ventured ----------
sv = "src/pages/cache/somethingventured/episodes"

write(f"{sv}/frank-rotman-the-midas-list-veteran-on-building-fintech-empires-at-capital-one-and-qed-investors/ai.json", {
  "tldr": [
    "Guest: Frank Rotman (QED, ex-Capital One) on building durable fintech empires.",
    "Frameworks: unit-economics first; 'earned secrets' through credit cycles.",
    "Contrarian: Growth without hard credit chops is borrowed time."
  ],
  "learn": [
    "How Capital One-style rigor translates to modern fintech.",
    "Signals investors watch beyond top-line growth.",
    "Portfolio construction when cycles turn."
  ],
  "takeaways": [
    "<strong>Moats:</strong> proprietary data and disciplined underwriting.",
    "<strong>Risk:</strong> chasing valuation heat during easy-money periods.",
    "<strong>Hiring:</strong> operators fluent in risk, collections, and product."
  ],
  "numbers": ["~45–70 minutes", "3–6 named companies", "1–2 named frameworks"],
  "faq": [
    { "q": "Who is the guest?", "a": "Frank Rotman, cofounder of QED Investors; early Capital One operator." },
    { "q": "What’s the guest’s edge?", "a": "Decades of cycle-tested credit and growth pattern recognition." },
    { "q": "Actionable steps mentioned?", "a": "Codify risk taxonomies; instrument leading indicators; price risk precisely." }
  ],
  "entities": [{ "name": "QED Investors", "url": "https://qedinvestors.com/" }]
})

write(f"{sv}/eric-ries-the-lean-startup-revolution-in-an-ai-driven-world/ai.json", {
  "tldr": [
    "Guest: Eric Ries on Lean Startup in an AI-native world.",
    "Frameworks: build-measure-learn with model loops; hypothesis as prompts.",
    "Contrarian: 'Ship the model' ≠ value unless it closes a real loop."
  ],
  "learn": [
    "How to adapt MVPs when AI generates behavior.",
    "Measuring learning when performance drifts.",
    "Ethics and guardrails as part of product spec."
  ],
  "takeaways": [
    "<strong>Moats:</strong> proprietary data + feedback channels.",
    "<strong>Risk:</strong> model brittleness and evaluation theater.",
    "<strong>Hiring:</strong> PMs who can frame testable model hypotheses."
  ],
  "numbers": ["~45–60 minutes", "3–5 named companies", "1–2 named frameworks"],
  "faq": [
    { "q": "Who is the guest?", "a": "Eric Ries, author of The Lean Startup." },
    { "q": "What’s the guest’s edge?", "a": "Operational discipline for learning speed and capital efficiency." },
    { "q": "Actionable steps mentioned?", "a": "Define success metrics per loop; automate evaluation; retire flaky KPIs." }
  ],
  "entities": [{ "name": "The Lean Startup" }]
})

write(f"{sv}/kobie-fuller-upfront-ventures-partners-high-speed-sprint-from-track-star-to-venture-capital-powerhouse/ai.json", {
  "tldr": [
    "Guest: Kobie Fuller (Upfront Ventures) on speed, conviction, and pattern-building.",
    "Frameworks: funnel instrumentation; founder-market fit at sprint pace.",
    "Contrarian: Speed is a moat when paired with debrief discipline."
  ],
  "learn": [
    "Balancing speed with signal quality in sourcing.",
    "Structuring conviction frameworks pre-investment.",
    "Post-investment playbooks for compounding."
  ],
  "takeaways": [
    "<strong>Moats:</strong> proprietary network density + disciplined process.",
    "<strong>Risk:</strong> chasing heat without conviction frameworks.",
    "<strong>Hiring:</strong> athletes of execution who can systematize learning."
  ],
  "numbers": ["~45–60 minutes", "3–5 named companies", "1–2 named frameworks"],
  "faq": [
    { "q": "Who is the guest?", "a": "Kobie Fuller, General Partner at Upfront Ventures." },
    { "q": "What’s the guest’s edge?", "a": "Blends high-speed execution with structured pattern recognition." },
    { "q": "Actionable steps mentioned?", "a": "Codify sourcing funnels; define conviction tests; build post-investment playbooks." }
  ],
  "entities": [{ "name": "Upfront Ventures", "url": "https://upfront.com/" }],
  "quotes": []
})

