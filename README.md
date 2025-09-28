# Everything Machines Blog

This repository powers **[everythingmachines.blog](https://everythingmachines.blog)** — a static site designed to host **content caches** for various external sites.  

The goal is to make content **readable by machines (LLMs, AI crawlers, search engines)** with consistent canonical references, JSON-LD, and SEO metadata. Pages here serve as structured wrappers of original content, enabling both humans and machines to consume the same context while preserving attribution.

---

## 🚀 Live Site
Visit: **[everythingmachines.blog](https://everythingmachines.blog)**

---

## ✨ Purpose & Features

- **🤖 Machine-Readable Caches**  
  Each page mirrors content from an external URL (e.g., product page, blog post) and points canonical/OG/JSON-LD back to the source.

- **🔍 SEO & Crawler Optimized**  
  Supports per-page control of title, description, canonical URL, robots meta, and JSON-LD.  
  Includes `llms.txt` for AI crawler indexing.

- **📝 Markdown + HTML Workflow**  
  Every cached page includes:  
  - `source.md` → body text of the page (markdown)  
  - `_page.yml` → metadata (URL, title, description, lastmod, brand info)  
  - `index.html` → wrapper with SEO + structured data  

- **⚡ Astro + Static Site Generation**  
  Built with Astro for performance, security, and SEO-friendly output.

- **🌐 Netlify Ready**  
  Automatic deployments from GitHub → Netlify on each push.

---

## 🛠️ Development

```bash
npm install
npm run dev
