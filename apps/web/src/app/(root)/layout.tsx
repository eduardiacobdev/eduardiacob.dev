import type { Metadata } from "next";
import type { ReactNode } from "react";
import { defaultLocale, languageAlternates, siteUrl } from "@/i18n/config";
import { getDictionary } from "@/i18n/dictionaries";
import "../globals.css";

// `/` serves the default language with no redirect (docs/brand/brief.md).
// The canonical URL is /en/, so search engines index one copy.
const t = getDictionary(defaultLocale);

export const metadata: Metadata = {
  metadataBase: new URL(siteUrl),
  title: t.meta.title,
  description: t.meta.description,
  alternates: { canonical: `/${defaultLocale}/`, languages: languageAlternates() },
};

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang={defaultLocale}>
      <body>{children}</body>
    </html>
  );
}
