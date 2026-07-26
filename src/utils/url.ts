// Prefixes a root-relative path ("/work", "/#contact", "/images/x.png")
// with the configured `base` so links and assets resolve correctly
// whether the site is deployed at a domain root or a subpath.
export function withBase(path: string): string {
  const base = import.meta.env.BASE_URL.replace(/\/$/, '');
  return path.startsWith('/') ? `${base}${path}` : `${base}/${path}`;
}
