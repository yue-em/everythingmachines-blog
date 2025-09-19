import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';

export default defineConfig({
  site: 'https://everythingmachines.blog',
  integrations: [sitemap()],
  server: {
    host: true
  },
  markdown: {
    shikiConfig: {
      theme: 'github-light',
      wrap: true
    }
  }
});
