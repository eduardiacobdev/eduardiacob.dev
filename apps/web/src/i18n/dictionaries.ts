import type { Locale } from "./config";

// Site copy. Sources: docs/brand/content.md (what) and docs/brand/identity.md (voice).
const en = {
  meta: {
    title: "Eduard Iacob",
    description:
      "Eduard Iacob, full stack developer in Catania. Code is cheap now. Knowing what to build, and keeping it standing, is the work.",
  },
  home: {
    name: "Eduard Iacob",
    tagline: "Code is cheap now. Knowing what to build, and keeping it standing, is the work.",
    bio: "Full stack developer in Catania, Sicily. I build e-learning platforms and European research projects, from the database to the interface. When a production system stops, I'm the one they call: it's the part of the job that has taught me the most.",
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
    description:
      "Eduard Iacob, full stack developer a Catania. Il codice oggi costa poco. Il lavoro è sapere cosa costruire e farlo reggere.",
  },
  home: {
    name: "Eduard Iacob",
    tagline: "Il codice oggi costa poco. Il lavoro è sapere cosa costruire e farlo reggere.",
    bio: "Full stack developer a Catania. Costruisco piattaforme e-learning e progetti di ricerca europei, dal database all'interfaccia. Quando un sistema in produzione si ferma, chiamano me: è la parte del lavoro che mi ha insegnato di più.",
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
