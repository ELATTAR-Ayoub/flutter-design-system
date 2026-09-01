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
  `node tool/verify/serve-spa.js example/build/web 8321` from the repository
  root). The SPA fallback is required for direct component and docs routes.

## Scripts

| script | job |
|---|---|
| `capture.js <url> <out.png> [--theme t] [--settle ms] [--reduced] [--nav n]` | full-page stitched capture at 1440×900, 810px steps |
| `shot.js <url> <out.png> [w] [h] [settle]` | one viewport at any size, fixed settle, prints console + pending requests |
| `review-batch.js <base-url> <out-dir>` | current-tree smoke captures for typography and the highest-risk public components at mobile, tablet and desktop widths in both themes |
| `diff.js <a.png> <b.png> <out.png>` | pixelmatch diff: raw / AA-aware / half-res %, first divergent + structural rows |
| `locate.js <a.png> <b.png> <y>` | per-band alignment profile (δ∈[−32,32]) around a row |
| `crop.js <in.png> <out.png> <x> <y> <w> <h>` | crop for eyeballing a region |
| `section-oracle.js <route> [theme]` | per-section document geometry from the live reference |
| `run-phase2.ps1` | the phase-2 matrix: shadows/motion/icons × dark/light × both apps |

## Hard-won invariants (do not relearn these)

- **Scroll truth is read, never inferred.** The web capture drives
  `window.scrollTo` and reads `window.scrollY`; the Flutter capture drives
  the gallery's js_interop seam (`__elScrollTo` / `__elScrollY`, installed
  by `example/lib/scroll_bridge*.dart`). Pixel matching cannot recover
  advances — `BackgroundEffect` is viewport-fixed, so scrolled content is never
  a pure translation and SAD has no zero to find. The wheel path in
  `capture.js` survives only as a fallback for bundles without the seam;
  its totals over-append at the bottom clamp.
- **Matching (where still used) sees only the content clip**
  (x∈[248,1424), y≥64): the static rail/header make every offset look
  alike.
- **Startup settle gate:** CanvasKit loads fonts outside `document.fonts`;
  capture polls until two consecutive shots are pixel-stable before frame
  0 counts (~570px of phantom height otherwise).
- **Two pages the stitcher cannot reach on its own.** The documentation
  *error* states render `Alert`, whose `FeedbackSurface` controllers
  `repeat(reverse: true)` forever; the page never goes network-idle and
  `capture.js` dies on its 90s navigation timeout. Pass
  `--nav domcontentloaded`. This is the browser-side twin of the widget-test
  rule that on any page containing `Alert` you `pump()` and never
  `pumpAndSettle()`.
- **Narrow widths are `shot.js`, not `capture.js`.** The matcher's content clip
  (x∈[248,1424), y≥64) is the wide shell's own geometry. Below the sidebar
  breakpoint there is no rail to exclude, so the clip means nothing and the
  stitched advances would be fiction. Capture the first viewport and say that
  is what it is.
- **Serve from a short path on Windows.** A capture root nested under a long
  temp path pushes the deepest bundled assets past MAX_PATH (260): the files
  exist, `os.listdir` lists them, and `os.path.exists` is False — so the static
  server 404s them and the app's console fills with asset failures that have
  nothing to do with the build. `C:/elx/...` is enough.
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
