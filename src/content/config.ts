import { defineCollection, z } from 'astro:content';

const notes = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    description: z.string(),
    updated: z.date().optional(),
    canonical: z.string().url().optional(),
    robots: z.string().default('index, follow'),
    image: z.string().optional(),
    lang: z.string().default('en'),
    schema: z.object({
      type: z.string().default('WebPage'),
      author: z.string().optional(),
      datePublished: z.string().optional(),
      dateModified: z.string().optional(),
    }).optional(),
  }),
});

export const collections = {
  notes,
};
