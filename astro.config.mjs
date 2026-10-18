// @ts-check
import { defineConfig, fontProviders } from 'astro/config';
import sitemap from '@astrojs/sitemap';
import tailwindcss from '@tailwindcss/vite';
import mdx from '@astrojs/mdx';

const deployTarget = process.env.DEPLOY_TARGET ?? 'pages';
const isRouterBuild = deployTarget === 'router';

// The temporary Quick Tunnel hostname is not known at build time, so router
// builds intentionally omit absolute canonical metadata and use root paths.
const SITE_URL = isRouterBuild ? undefined : 'https://unablebagel.github.io';
const BASE_PATH = isRouterBuild ? '/' : '/me';

export default defineConfig({
  site: SITE_URL,
  base: BASE_PATH,

  integrations: [...(SITE_URL ? [sitemap()] : []), mdx()],

  // Prefetches internal links on hover/viewport entry for near-instant navigation.
  prefetch: true,

  vite: {
    plugins: [tailwindcss()],
  },

  // Astro's built-in Fonts API: self-hosts and optimizes these at build time
  // (no Google-hosted requests, no extra npm packages, automatic preloading).
  // Each cssVariable below is consumed in src/styles/global.css inside the
  // Tailwind @theme block (--font-display, --font-body, --font-mono).
  fonts: [
    {
      provider: fontProviders.google(),
      name: 'Fraunces',
      cssVariable: '--ff-display',
      weights: ['400', '500', '600'],
      styles: ['normal', 'italic'],
      subsets: ['latin'],
    },
    {
      provider: fontProviders.google(),
      name: 'Inter',
      cssVariable: '--ff-body',
      weights: ['400', '500', '600'],
      subsets: ['latin'],
    },
    {
      provider: fontProviders.google(),
      name: 'Space Mono',
      cssVariable: '--ff-mono',
      weights: ['400', '700'],
      subsets: ['latin'],
    },
  ],
});
