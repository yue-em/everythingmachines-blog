# Everything Machines Blog

An Astro static site for publishing Obsidian notes with full SEO control.

## Features

- **SEO Optimized**: Per-page control of title, description, canonical URLs, robots meta, and JSON-LD structured data
- **Obsidian Compatible**: Renders markdown files with frontmatter from Obsidian
- **Static Site Generation**: Fast, secure, and SEO-friendly static site
- **Netlify Ready**: Configured for seamless deployment on Netlify

## Development

```bash
npm install
npm run dev
```

## Deployment

The site is configured for automatic deployment on Netlify:

- Build command: `npm run build`
- Publish directory: `dist`
- Domain: `everythingmachines.blog`

## Adding Content

1. Place your Obsidian `.md` files in `src/content/notes/`
2. Ensure each note has proper frontmatter with SEO fields
3. Commit and push - Netlify will auto-deploy

## SEO Features

- Automatic sitemap generation
- Robots.txt configuration
- OpenGraph and Twitter Card meta tags
- JSON-LD structured data
- Canonical URL management
