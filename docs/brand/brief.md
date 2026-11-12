# Brand brief

Status: approved inputs from Eduard, 2026-11-12 (TASKS T0.2). Feeds the brand identity (T0.3) and the site design (T2.2).

## Purpose

A personal site that builds reputation. It shows how Eduard thinks and builds; it is not a job-search page.

- Reputation first. Client or work enquiries are a side effect, never the goal.
- No "hire me", "available for work", "open to opportunities" or rates. No pricing, no service packages.
- Contact is a quiet "say hello" (the form from T3.7), not a call to action repeated on every screen.
- No employer names, client names or work under NDA. Projects shown are personal or public.

## Audience

| Who | What they look for | What the site gives them |
|---|---|---|
| CTOs and technical leads | Judgment, quality, how problems are approached | Selected work, short write-ups of decisions, the craft of the site itself |
| Recruiters and companies | A quick, memorable sense of who Eduard is | A clear one-line identity, experience in brief, a contact path |

The audience is technical, but the site does not lead with technical detail. Depth is one click away for whoever wants it.

## Experience

An immersive, graphic, 3D portfolio. The site itself is the main proof of skill.

References (inspiration for the level of craft, never to copy their look, scenes or assets):

| Site | What to take from it |
|---|---|
| basement.studio | Confident art direction, bold type, a strong studio personality, 3D used as identity rather than decoration |
| Igloo Inc | One coherent 3D world, scroll-driven storytelling, cinematic transitions, careful sound and motion |
| Bruno Simon | Playful interaction: the visitor explores instead of reading, and remembers the visit |

Direction: one original 3D world built around Eduard's own identity, explored by scroll, with each section of the portfolio as a place in that world. Playful, but quick to read for a recruiter in a hurry.

## Constraints from the platform

These come from the existing decisions and shape the 3D design from the start.

- **Static export, zero cost** (ADR-0005). Next.js `output: 'export'` on CloudFront. All 3D runs in the browser; nothing renders on a server.
- **Weight budget.** First view interactive with at most about 1.5 MB compressed transferred; the 3D scene loads after the HTML and streams in. Compressed models and textures (Draco or Meshopt, KTX2). This also keeps CloudFront well inside the free transfer.
- **HTML first.** Every 3D section has the same content as real HTML text: search engines, AI crawlers (GEO, T4.1) and screen readers read it, and the site works if WebGL fails.
- **Accessibility, WCAG 2.2 AA.** `prefers-reduced-motion` gets a calm, non-animated version; full keyboard navigation; no content only inside the canvas; captions and mute for any sound, with sound off by default.
- **Performance on real devices.** Mid-range phones get a lighter scene (fewer effects, lower resolution) chosen at runtime. Targets: LCP under 2.5 s, INP under 200 ms, CLS under 0.1 on mobile.
- **Security headers** stay strict (CSP without `unsafe-eval`; workers and WASM only where the 3D decoders need them, allowed explicitly).

## Languages

English and Italian, same content in both.

- English at `/en/`, Italian at `/it/`; `/` serves English with a visible language switch.
- `hreflang` for both plus `x-default`; one sitemap with both.
- No automatic redirect by browser language: the visitor chooses, and the choice is remembered.

## Open for T0.3 and content

- Name treatment, palette, type and voice (T0.3, C proposes, Eduard approves).
- Concept for the 3D world: two or three options as sketches before any build.
- Content inventory from Eduard: the projects and stories to show, a short bio, the links to show (GitHub, LinkedIn or others).
