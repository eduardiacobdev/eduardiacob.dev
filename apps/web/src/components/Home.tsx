import type { Locale } from "@/i18n/config";
import { getDictionary } from "@/i18n/dictionaries";
import { LanguageSwitch } from "./LanguageSwitch";

// Placeholder home: real HTML content first, the 3D scene comes on top of it
// after the brand identity (T0.3).
export function Home({ locale }: { locale: Locale }) {
  const t = getDictionary(locale);
  return (
    <>
      <header>
        <LanguageSwitch current={locale} labels={t.languageSwitch} />
      </header>
      <main>
        <h1>{t.home.name}</h1>
        <p>{t.home.status}</p>
      </main>
    </>
  );
}
