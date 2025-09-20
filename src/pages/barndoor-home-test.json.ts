import { getCollection } from 'astro:content';

export const GET = async () => {
  const entries = await getCollection('notes');
  const entry =
    entries.find((e) => e.slug === 'barndoor-home-test') ||
    entries.find((e) => e.id.endsWith('/barndoor-home-test.md'));

  if (!entry) {
    return new Response('Not found', { status: 404 });
  }

  // Be defensive about optional fields coming from front-matter
  const data: any = entry.data || {};
  const faq = Array.isArray(data.faq) ? data.faq : [];

  const payload = {
    title: data.title ?? 'Barndoor MCP Security',
    canonical: data.canonical ?? 'https://everythingmachines.blog/barndoor-home-test/',
    description: data.description ?? '',
    source_markdown: '/md/barndoor-home-test.md',
    faq
  };

  return new Response(JSON.stringify(payload, null, 2), {
    headers: { 'content-type': 'application/json; charset=utf-8' }
  });
};

