import { defineCollection } from 'astro:content';
import { glob } from 'astro/loaders';
import { z } from 'astro/zod';

// "work" entries live in src/content/work/*.md
// Each file's `id` is derived from its filename, e.g. studio-os.md -> "studio-os",
// which becomes the URL at /work/studio-os.
const work = defineCollection({
  loader: glob({ base: './src/content/work', pattern: '**/*.{md,mdx}' }),
  schema: ({ image }) =>
    z.object({
      title: z.string(),
      summary: z.string().max(300),
      role: z.string(),
      date: z.coerce.date(),
      tags: z.array(z.string()).default([]),
      cover: image().optional(),
      url: z.string().optional(),
      repo: z.url().optional(),
      featured: z.boolean().default(false),
      draft: z.boolean().default(false),
    }),
});

// "ctf" entries live in src/content/ctf/*.md and render at /work/ctf-challenges/<id>.
const ctf = defineCollection({
  loader: glob({ base: './src/content/ctf', pattern: '**/*.md' }),
  schema: z.object({
    title: z.string(),
    summary: z.string().max(300),
    category: z.string(),
    event: z.string().optional(),
    tags: z.array(z.string()).default([]),
    order: z.number().default(0),
    // PBKDF2-SHA256 (600k iterations) of the flag; the plaintext flag never ships.
    flagSalt: z.string().optional(),
    flagHash: z.string().optional(),
    flagFormat: z.string().optional(),
  }),
});

export const collections = { work, ctf };
