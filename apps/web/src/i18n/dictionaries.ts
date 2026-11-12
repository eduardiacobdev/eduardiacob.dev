import type { Locale } from "./config";

// UI and placeholder copy. Final copy comes with the brand identity (T0.3).
const en = {
  meta: {
    title: "Eduard Iacob",
    description: "Personal site of Eduard Alexandru Iacob.",
  },
  home: {
    name: "Eduard Iacob",
    status: "Something is being built here.",
  },
  notFound: {
    title: "Page not found",
    message: "This page does not exist.",
    home: "Go to the home page",
  },
  languageSwitch: {
    label: "Language",
    en: "English",
    it: "Italiano",
  },
};

export type Dictionary = typeof en;

const it: Dictionary = {
  meta: {
    title: "Eduard Iacob",
    description: "Sito personale di Eduard Alexandru Iacob.",
  },
  home: {
    name: "Eduard Iacob",
    status: "Qui si sta costruendo qualcosa.",
  },
  notFound: {
    title: "Pagina non trovata",
    message: "Questa pagina non esiste.",
    home: "Vai alla home",
  },
  languageSwitch: {
    label: "Lingua",
    en: "English",
    it: "Italiano",
  },
};

const dictionaries: Record<Locale, Dictionary> = { en, it };

export function getDictionary(locale: Locale): Dictionary {
  return dictionaries[locale];
}
