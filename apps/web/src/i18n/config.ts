// Languages of the site (docs/brand/brief.md). English is the default and
// also serves `/`; every page exists under /en/ and /it/.
export const locales = ["en", "it"] as const;
export type Locale = (typeof locales)[number];
export const defaultLocale: Locale = "en";

export const siteUrl = "https://eduardiacob.dev";

export function isLocale(value: string): value is Locale {
  return (locales as readonly string[]).includes(value);
}

/** hreflang alternates for a path that exists in every locale ("/" = home). */
export function languageAlternates(path = "/"): Record<string, string> {
  const alternates: Record<string, string> = {};
  for (const locale of locales) {
    alternates[locale] = `/${locale}${path}`;
  }
  alternates["x-default"] = `/${defaultLocale}${path}`;
  return alternates;
}
