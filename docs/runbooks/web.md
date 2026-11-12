# Runbook: apps/web

The site front end (TASKS T2.2): Next.js with `output: 'export'`, so `next build` writes plain files to `apps/web/out/` for S3 and CloudFront. Nothing renders on a server (ADR-0005).

## Commands

From the repo root, with pnpm set up as in [`tooling.md`](tooling.md):

```bash
pnpm install
```

```bash
pnpm web dev
```

```bash
pnpm web lint
```

```bash
pnpm web typecheck
```

```bash
pnpm web test
```

```bash
pnpm web build
```

CI runs the same four checks in the `web` job (`docs/runbooks/ci.md`). Set `NEXT_TELEMETRY_DISABLED=1` locally too.

## Routes and languages

From [`docs/brand/brief.md`](../brand/brief.md):

| Path | Content | Canonical |
|---|---|---|
| `/` | English home | `/en/` |
| `/en/` | English | `/en/` |
| `/it/` | Italian | `/it/` |
| any other | One bilingual 404 (`global-not-found.tsx`), `noindex` | — |

- Every page lists `hreflang` for `en`, `it` and `x-default` (English).
- No redirect by browser language. The language switch is plain links.
- Strings live in `src/i18n/dictionaries.ts`; a test fails if the two languages do not have the same keys or a string is empty.

Layout: `src/app/[lang]/` holds the two languages (`generateStaticParams`, `dynamicParams = false`); `src/app/(root)/` holds `/` with its own root layout, so each page gets the right `<html lang>`.

## Static export notes

- `trailingSlash: true`: every page is `<path>/index.html`, which S3 serves without rewrites.
- `images.unoptimized`: no image server. Images are optimised at build time when they arrive.
- Security headers (CSP, HSTS and the rest) come from the CloudFront response headers policy (T3.5): `headers()` in `next.config.ts` does nothing in a static export.
- `next-env.d.ts` is generated (`next typegen` in `typecheck`) and ignored by git.

## Dependencies

Versions are exact. pnpm installs only releases at least 7 days old (`minimumReleaseAge`), and Dependabot opens one grouped PR a week.

Pinned on purpose:

- TypeScript 6.0 and ESLint 9: `eslint-config-next` 16 and its plugins do not support TypeScript 7 or ESLint 10 yet. Bump when their peer ranges do.
