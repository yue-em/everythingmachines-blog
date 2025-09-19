# Everything Machines Blog

A modern Astro static site for publishing technical content about AI, machine learning, and automation with full SEO control.

## 🚀 Live Site

Visit the blog at: **[everythingmachines.blog](https://everythingmachines.blog)**

## ✨ Features

- **🔍 SEO Optimized**: Per-page control of title, description, canonical URLs, robots meta, and JSON-LD structured data
- **📝 Obsidian Compatible**: Seamlessly renders markdown files with frontmatter from Obsidian
- **⚡ Static Site Generation**: Fast, secure, and SEO-friendly static site built with Astro
- **🤖 LLM Friendly**: Includes `llms.txt` for optimal AI crawler indexing
- **🌐 Netlify Ready**: Configured for automatic deployment on Netlify

## 🛠️ Development

```bash

```bash
npm install
npm run dev
```


## 🚀 Deployment

The site is configured for automatic deployment on Netlify:

- **Build command**: `npm run build`
- **Publish directory**: `dist`
- **Domain**: `everythingmachines.blog`
- **Auto-deploy**: Enabled on push to `main` branch

## 📝 Adding Content

1. **Create new posts**: Place your Obsidian `.md` files in `src/content/notes/`
2. **Add frontmatter**: Ensure each note has proper SEO frontmatter:
   ```yaml
   ---
   title: "Your Post Title"
   description: "SEO description for search engines"
   updated: 2025-09-19
   canonical: "https://everythingmachines.blog/your-post-slug"
   ---
