# Brand identity

Status: approved by Eduard, 2026-11-12 (TASKS T0.3). Concept **B, Rilievo**, chosen from three options (A Plastico, B Rilievo, C Officina). Built on [`brief.md`](brief.md); the site design and 3D work (T2.2 onwards) follow this file.

## Idea

An island generated from code and read as a topographic map. The first view is a flat map; on the first scroll it tilts and the contour lines rise into terrain. Each section of the portfolio is a place on the island.

Why this one: it is the lightest of the three concepts, has one clear signature moment, and the landscape is generated rather than modelled, which is how the site's infrastructure is built too.

Personality: curious and exploring, but calm. The site always says where you are and where the path leads.

## Name treatment

- Name: **Eduard Iacob**, set in the display face at weight 800 with tight tracking (about `-0.035em`).
- Monogram: lowercase **ei** at the centre of concentric contour lines. It is the favicon, the app icon and the social image mark.
- Caption line in the mono face, like a map legend: `N ↑ · eduardiacob.dev · 1:25 000`.
- Recurring motif: contour lines, used for section dividers, backgrounds and the loading indicator.

## Palette

Dark is the primary theme; light must look as good. Both follow `prefers-color-scheme`, with a manual switch.

| Token | Role | Dark | Light |
|---|---|---|---|
| `bg` | Page background (night / paper) | `#0E1B22` | `#EAF0EE` |
| `surface` | Cards, panels | `#142630` | `#F6F9F8` |
| `text` | Body text (ink) | `#E3ECEE` | `#10232A` |
| `muted` | Secondary text | `#8FA6AC` | `#4E6870` |
| `contour` | Contour lines, decorative only | `#3C7D84` | `#86B3B3` |
| `coast` | Links, focus, primary accent | `#8ED2C6` | `#1F6F73` |
| `signal` | Highlights, markers, the active place | `#F1C04C` | `#8F5E00` |

Contrast (WCAG 2.2, checked on both `bg` and `surface`):

| Pair | Dark | Light | Use |
|---|---|---|---|
| `text` on `bg` / `surface` | 14.6 / 13.0 | 14.0 / 15.3 | Any text |
| `muted` on `bg` / `surface` | 6.9 / 6.1 | 5.1 / 5.6 | Any text |
| `coast` on `bg` / `surface` | 10.2 / 9.0 | 5.1 / 5.5 | Links, focus ring, any text |
| `signal` on `bg` / `surface` | 10.3 / 9.2 | 4.8 / 5.3 | Any text |
| `contour` on `bg` | 3.7 | 2.0 | Decoration only, never the only carrier of meaning |

Light `signal` was darkened from the concept's `#A86F00` (3.7:1) to `#8F5E00` so it passes AA for normal text.

## Type

All three are open-source (SIL OFL), self-hosted as WOFF2 subsets (Latin and Latin Extended for Romanian and Italian names). No font CDN: it keeps the CSP strict and sends no visitor data to a third party.

| Role | Face | Notes |
|---|---|---|
| Display | Bricolage Grotesque, 800 | Variable; optical size high for headings |
| Body | Atkinson Hyperlegible | Designed for low vision: every letter is distinct |
| Details | JetBrains Mono | Captions, coordinates, dates, code |

Budget: display and body fonts together under about 120 KB; mono loads only where used.

## Voice

Clear and oriented. Short sentences, no superlatives, no "hire me" (see the brief). One map metaphor per screen at most; the plain meaning always comes first.

Draft lines, to be finished once the content inventory arrives:

| Place | English | Italian |
|---|---|---|
| Identity | I map hard problems until the way through is plain. | Disegno la mappa dei problemi difficili finché la strada è chiara. |
| Work | Work · the summits | Lavori · le cime |
| Decisions | Trails: how I chose | Sentieri: come ho scelto |
| Contact | Send a signal. I'll answer. | Manda un segnale. Rispondo. |
| 404 | Off the map. | Fuori mappa. |

## The world

| Section | Place | What happens |
|---|---|---|
| Intro | The map from above | The name is written on it like a place name. The first scroll tilts the map into 3D |
| Work | Summits | One peak per project, with a flag. Moving closer opens the project card |
| Decisions | Trails between the summits | Stops along each trail: problem, options, choice |
| About | Base camp | A tent and a lantern. Short bio and experience |
| Contact | The lighthouse on the coast | It flashes when the message is sent |

- **Signature moment:** the flat map tilting into a landscape on the first scroll.
- **Quick view:** a button that is always visible: identity in one line, three projects, contact. For visitors with two minutes.
- **Motion and sound:** a slow flight over the terrain. Low wind and a tone on reaching a summit; sound off by default, with captions and mute.
- **Reduced motion:** the flat map stays, section by section, with no tilt or camera flight.
- **Without WebGL:** the same content as plain HTML over a static map image.

## Technical shape

- Terrain from a height map (about 30 KB) and a shader: computed, not modelled. Estimated 3D weight 0.2–0.35 MB, well inside the 1.5 MB first-view budget.
- Small props (flags, tent, lighthouse) modelled in Blender and compressed with the pipeline in [`docs/runbooks/assets.md`](../runbooks/assets.md).
- Mid-range phones get a coarser terrain mesh and fewer effects, chosen at runtime.
- Main risk: the contour shader must stay sharp at every zoom and pixel density. A spike comes before the full build.
