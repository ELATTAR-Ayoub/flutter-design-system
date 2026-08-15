# Side-by-side verification rig

Captures the web reference and the Flutter gallery as full-page stitched
PNGs and diffs them pixel-by-pixel. This is the harness behind every
"measured parity" claim in the docs; it lived in a session scratchpad
until phase 3 and moved here so it survives sessions.

## Prerequisites

- Chrome at `C:/Program Files/Google/Chrome/Application/chrome.exe`
  (path constant at the top of `capture.js`)
- `npm i puppeteer-core pngjs pixelmatch` in this directory
- Web reference dev server on `localhost:3000`
  (`npm run dev` in the reference repo)
- Flutter gallery release bundle on `localhost:8321`
  (`flutter build web --release` in `example/`, then
  `python -m http.server 8321` from `example/build/web`)

## Scripts

| script | job |
|---|---|
| `capture.js <url> <out.png> [--theme t] [--settle ms] [--reduced]` | full-page stitched capture at 1440×900, 810px steps |
| `diff.js <a.png> <b.png> <out.png>` | pixelmatch diff: raw / AA-aware / half-res %, first divergent + structural rows |
| `locate.js <a.png> <b.png> <y>` | per-band alignment profile (δ∈[−32,32]) around a row |
| `crop.js <in.png> <out.png> <x> <y> <w> <h>` | crop for eyeballing a region |
| `section-oracle.js <route> [theme]` | per-section document geometry from the live reference |
| `run-phase2.ps1` | the phase-2 matrix: shadows/motion/icons × dark/light × both apps |

## Hard-won invariants (do not relearn these)

- **Scroll truth is read, never inferred.** The web capture drives
  `window.scrollTo` and reads `window.scrollY`; the Flutter capture drives
  the gallery's js_interop seam (`__dsScrollTo` / `__dsScrollY`, installed
  by `example/lib/scroll_bridge*.dart`). Pixel matching cannot recover
  advances — `DsPageGlow` is viewport-fixed, so scrolled content is never
  a pure translation and SAD has no zero to find. The wheel path in
  `capture.js` survives only as a fallback for bundles without the seam;
  its totals over-append at the bottom clamp.
- **Matching (where still used) sees only the content clip**
  (x∈[248,1424), y≥64): the static rail/header make every offset look
  alike.
- **Startup settle gate:** CanvasKit loads fonts outside `document.fonts`;
  capture polls until two consecutive shots are pixel-stable before frame
  0 counts (~570px of phantom height otherwise).
- **Reduced motion needs both channels:** `--reduced` emulates
  `prefers-reduced-motion` (freezes the web CSS only — CDP emulation never
  reaches the Flutter engine); the Flutter app freezes via its
  `?motion=reduced` boot param.
- **Cursor discipline:** wheel over content, park at (8,8) before every
  screenshot — a resting cursor hovers whatever scrolls under it and
  Flutter re-hit-tests on scroll.
- Chrome flags: `--force-color-profile=srgb --force-device-scale-factor=1
  --disable-lcd-text` (grayscale AA on both sides).

## Reading a diff

`dHeight` is the structural verdict (0 = content heights match).
Residual `aaAwarePct` of ~0.7–1.3% at half-res is glyph antialiasing
noise between CanvasKit and DOM text rendering — the floor, not a drift.
Known sanctioned drift: icons page is +21px on the web side (a wrapping
line the reference renders that the port's register documents).
