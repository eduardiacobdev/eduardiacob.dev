import Link from "next/link";
import { locales, type Locale } from "@/i18n/config";
import type { Dictionary } from "@/i18n/dictionaries";

type Props = {
  current: Locale;
  labels: Dictionary["languageSwitch"];
};

// Plain links, so the switch works without JavaScript and crawlers see both
// languages. `hrefLang` and `lang` tell assistive tech which language follows.
export function LanguageSwitch({ current, labels }: Props) {
  return (
    <nav aria-label={labels.label}>
      <ul className="language-switch">
        {locales.map((locale) => (
          <li key={locale}>
            <Link
              href={`/${locale}/`}
              hrefLang={locale}
              lang={locale}
              aria-current={locale === current ? "page" : undefined}
            >
              {labels[locale]}
            </Link>
          </li>
        ))}
      </ul>
    </nav>
  );
}
