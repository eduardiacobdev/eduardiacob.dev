import type { Metadata } from "next";
import Link from "next/link";
import { getDictionary } from "@/i18n/dictionaries";
import "./globals.css";

// Exported as 404.html; CloudFront serves it for missing paths (T3.5).
// Bilingual, because it cannot know which locale the visitor came from.
const en = getDictionary("en");
const it = getDictionary("it");

export const metadata: Metadata = {
  title: `${en.notFound.title} · ${en.meta.title}`,
};

export default function GlobalNotFound() {
  return (
    <html lang="en">
      <body>
        <header />
        <main>
          <h1>404</h1>
          <p>
            {en.notFound.message} <Link href="/en/">{en.notFound.home}</Link>
          </p>
          <p lang="it">
            {it.notFound.message}{" "}
            <Link href="/it/" hrefLang="it">
              {it.notFound.home}
            </Link>
          </p>
        </main>
      </body>
    </html>
  );
}
