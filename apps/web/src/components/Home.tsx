import type { Locale } from "@/i18n/config";
import { getDictionary } from "@/i18n/dictionaries";
import { LanguageSwitch } from "./LanguageSwitch";

// Home: real HTML content first; the 3D scene (docs/brand/identity.md) comes
// on top of it later.
export function Home({ locale }: { locale: Locale }) {
  const t = getDictionary(locale);
  return (
    <>
      <header>
        <LanguageSwitch current={locale} labels={t.languageSwitch} />
      </header>
      <main>
        <h1>{t.home.name}</h1>
        <p>{t.home.tagline}</p>
        <p>{t.home.bio}</p>
        <p>{t.home.status}</p>
      </main>
    </>
  );
}
