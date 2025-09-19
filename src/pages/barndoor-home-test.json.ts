import { getCollection } from 'astro:content';
export const GET = async () => {
  const entries = await getCollection('notes');
  const entry =
    entries.find(e => e.slug === 'barndoor-home-test') ||
    entries.find(e => e.id.endsWith('/barndoor-home-test.md'));
  if (!entry) return new Response('Not found', { status: 404 });
  return new Response(JSON.stringify({
    title: entry.data.title,
    canonical: entry.data.canonical,
    description: entry.data.description,
    source_markdown: '/md/barndoor-home-test.md',
    faq: entry.data.faq || []
  }, null, 2), { headers: { 'content-type': 'application/json; charset=utf-8' } });
};
