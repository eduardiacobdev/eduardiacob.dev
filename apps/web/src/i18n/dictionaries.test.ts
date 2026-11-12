import { describe, expect, it } from "vitest";
import { languageAlternates, locales } from "./config";
import { getDictionary } from "./dictionaries";

function keys(value: unknown, prefix = ""): string[] {
  if (typeof value !== "object" || value === null) return [prefix];
  return Object.entries(value).flatMap(([k, v]) => keys(v, prefix ? `${prefix}.${k}` : k));
}

describe("dictionaries", () => {
  it("have the same keys in every locale", () => {
    const reference = keys(getDictionary("en")).sort();
    for (const locale of locales) {
      expect(keys(getDictionary(locale)).sort()).toEqual(reference);
    }
  });

  it("have no empty strings", () => {
    for (const locale of locales) {
      const flat = JSON.stringify(getDictionary(locale));
      expect(flat).not.toContain('""');
    }
  });
});

describe("languageAlternates", () => {
  it("lists every locale and x-default", () => {
    expect(languageAlternates()).toEqual({ en: "/en/", it: "/it/", "x-default": "/en/" });
  });
});
