// Edit this file to re-label the entire site. Header, Footer, the homepage
// and SEO defaults all read from here instead of hardcoding copy.
export const SITE = {
  name: 'Winson Ho',
  role: 'Information Security Student',
  email: 'your@email.com',
  tagline: 'Learning by building.',
  description:
    'Studying cybersecurity, building things, and learning that the answers always hide in the details.',
  status: 'Singapore',
  social: [
    { label: 'GitHub', href: 'https://github.com/' },
    { label: 'LinkedIn', href: 'https://linkedin.com/' },
  ],
  locale: 'en',
} as const;

export const NAV_LINKS = [
  { label: 'Work', href: '/work' },
  { label: 'About', href: '/about' },
] as const;