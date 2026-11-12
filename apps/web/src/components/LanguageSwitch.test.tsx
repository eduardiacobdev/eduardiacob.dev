import { cleanup, render, screen } from "@testing-library/react";
import { afterEach, describe, expect, it } from "vitest";
import { getDictionary } from "@/i18n/dictionaries";
import { LanguageSwitch } from "./LanguageSwitch";

afterEach(cleanup);

describe("LanguageSwitch", () => {
  it("links every language and marks the current one", () => {
    render(<LanguageSwitch current="it" labels={getDictionary("it").languageSwitch} />);

    const english = screen.getByRole("link", { name: "English" });
    const italian = screen.getByRole("link", { name: "Italiano" });

    // next/link adds the trailing slash only in the build (trailingSlash: true).
    expect(english.getAttribute("href")).toMatch(/^\/en\/?$/);
    expect(english.getAttribute("hreflang")).toBe("en");
    expect(english.getAttribute("aria-current")).toBeNull();
    expect(italian.getAttribute("href")).toMatch(/^\/it\/?$/);
    expect(italian.getAttribute("aria-current")).toBe("page");
    expect(screen.getByRole("navigation", { name: "Lingua" })).toBeTruthy();
  });
});
