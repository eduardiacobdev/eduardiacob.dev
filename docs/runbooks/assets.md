# Runbook: 3D assets

How 3D models get from Blender to the site. The budget comes from [`docs/brand/brief.md`](../brand/brief.md): first view interactive at about 1.5 MB compressed transferred or less, with compressed meshes and textures.

## Tools

| Tool | Role | Where |
|---|---|---|
| Blender 5.2 LTS | Modelling, materials, export to glTF binary (`.glb`) | `~/Applications/Blender.app`, see [`tooling.md`](tooling.md) |
| KTX-Software 4.4.2 | KTX2 / Basis Universal texture encoder used by gltf-transform | `~/.local/bin/ktx`, see [`tooling.md`](tooling.md) |
| gltf-transform 4.5.1 | Texture and mesh compression, validation, inspection | `tools/assets` workspace package, run with `pnpm assets gltf` |

## Pipeline

Sources (`.blend`) stay out of git until a decision on where to keep them; only optimised `.glb` files go to `apps/web/public/`. The pre-commit hook rejects files over 512 KB, which is also a useful ceiling per model.

1. Export from Blender as glTF binary (`.glb`), Y up, with modifiers applied.
2. Compress textures to KTX2 first. Use `etc1s` for colour maps (small) and `uastc` for normal maps (quality):

   ```bash
   pnpm assets gltf etc1s in.glb tex.glb
   ```

3. Then compress geometry with Meshopt, keeping the KTX2 textures as they are:

   ```bash
   pnpm assets gltf optimize tex.glb out.glb --compress meshopt --texture-compress false
   ```

4. Check the result:

   ```bash
   pnpm assets gltf validate out.glb
   ```

   ```bash
   pnpm assets gltf inspect out.glb
   ```

The order matters: running `etc1s` after Meshopt decodes the geometry again and loses the compression. The validator reports `image/ktx2`, `KHR_texture_basisu` and `EXT_meshopt_compression` as unknown or unsupported; those are warnings from the validator, not errors.

## Runtime

The site decodes these with three.js `MeshoptDecoder` and `KTX2Loader` (Basis transcoder in WASM). Both need the CSP to allow `wasm-unsafe-eval` and same-origin workers for the decoder files (T3.5), never `unsafe-eval`.

## Check on 2026-11-12

A 160 x 160 terrain with a 512 px colour texture, exported from Blender headless: 1.39 MB raw, 91 KB after the pipeline, 47 KB gzip. Validation: no errors.
