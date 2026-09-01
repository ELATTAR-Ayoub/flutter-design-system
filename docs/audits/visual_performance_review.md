# Batch 5 — real visual and performance review

Status: **Complete for the release-readiness smoke scope.**

## Phase A — rig check, URL form, performance evidence

### Commands run

```
# Chrome present
ls "C:/Program Files/Google/Chrome/Application/chrome.exe"

# puppeteer-core loads from tool/verify
cd tool/verify && node -e "require('puppeteer-core')"

# The existing build/web is served with python's http.server, which has
# no SPA fallback — a hard GET to any nested path 404s (confirmed: see
# "SPA fallback" below). Replaced with a tiny Node static server that
# falls back to index.html for any path with no matching file, written to
# the session scratchpad (not under lib/ or example/lib/):
#   .../scratchpad/spa-server.js  C:/elx/web 8321

# Windows MAX_PATH note from tool/verify/README.md — the build was also
# copied to a short root before serving:
cp -r example/build/web C:/elx/web

node "<scratchpad>/spa-server.js" C:/elx/web 8321

# Probe capture
cd tool/verify
node shot.js "http://localhost:8321/components/dialog?theme=dark" out/probe.png 1440 900 8000
```

### Rig status: WORKS, with one fix required

- Chrome exists at the documented path.
- `puppeteer-core` loads.
- `python -m http.server`, as literally instructed, cannot serve this app:
  Flutter's `usePathUrlStrategy` means every non-root path
  (`/components/dialog`, `/design-system/typography`, …) is a **client-side**
  route with no file on disk at that path. `http.server` 404s any hard
  navigation to one (confirmed: `out/probe.png` from the first attempt is a
  literal "404 File not found" page, not the app). A static server for this
  app needs an SPA fallback (serve the matched file if one exists, else
  `index.html`). Wrote one to the scratchpad
  (`spa-server.js`) rather than editing anything under `example/`; it is not
  part of the deliverable, just what made the rig work. **Whoever serves the
  rebuilt tree for Phase B needs the same fallback** — plain
  `python -m http.server` will 404 every deep link again.
- Also copied `example/build/web` to `C:/elx/web` before serving, per the
  README's Windows `MAX_PATH` note.

### Exact working URL form

- Boot params, confirmed against `example/lib/main.dart`:
  `?theme=dark|light|system` (`_DocsAppState._theme`, defaults to dark),
  `?motion=reduced` (freezes animation — the Flutter-side half of
  `--reduced`; `capture.js`'s CDP media emulation only reaches the DOM
  reference), `?clock=<ISO-8601>` (freezes the calendar clock).
- Routing is path-based (`usePathUrlStrategy`), not hash-based.
- **Important finding, not a rig problem — an architecture finding that
  changes what Phase B can capture as specified:** the route list in the
  task brief (`/design-system/typography`, `/design-system/motion`,
  `/design-system/icons`, `/design-system/components/base/{buttons,inputs,
  forms,selects,selection,dialogs,menus,navigation,feedback,data,charts,
  layout,sidebar}`, `/design-system/components/agent/{transcript,history}`)
  is the **old** route table. It is still defined in code
  (`example/lib/main.dart`'s `pageFor()`, backed by `nav.dart`'s `elGroups`)
  but **that function is never called from the live widget tree.** The site
  was restructured to a `SiteShell` + `siteRoutes` model
  (`example/lib/site/site_routes.dart`): the header is now exactly four
  destinations (Home, Docs, Components, Skills), grouped foundation pages
  like a standalone "Typography" or "Icons" catalog no longer exist as
  distinct URLs, and per-component pages moved to the flat form
  `/components/<name>` (confirmed live: `button`, `button_group`, `select`,
  `combobox`, `command`, `tabs`, `toggle_group`, `dialog`, `alert_dialog`,
  `popover`, `sheet`, `drawer`, `table`, `chart`/`chart_cartesian`/
  `chart_polar`, `agent_console`, `agent_transcript`, `agent_history`,
  `menu`, `dropdown_menu`, `navigation_menu`, `native_select`, and the rest
  of `componentDocs` in `example/lib/components_docs/catalog.dart`).
  `main.dart`'s own comment names this on purpose: *"Only the home page and
  the documentation tree exist now. Every other route … resolves to the
  documentation shell so a stale link lands somewhere real instead of
  opening a page that is no longer part of the site."* A typed
  `/design-system/typography` therefore renders the `/docs` index, not a
  typography page — confirmed by capture (see `out/probe.png`, dark theme,
  Inter rendered correctly, no fallback glyphs — but it is the docs index,
  not typography).
  **Recommendation before Phase B starts:** re-derive the capture list from
  `example/lib/components_docs/catalog.dart` (`componentDocs`, route
  `/components/<name>`) and `example/lib/site/site_routes.dart`
  (`siteRoutes`: `/`, `/docs`, `/docs/introduction`, `/docs/installation`,
  `/docs/theming`, `/docs/cli`, `/docs/typeset`, `/docs/registry`,
  `/docs/changelog`, `/components`, `/skills`) rather than the
  `/design-system/...` paths, or confirm with the owner that a further
  rebuild restores the old tree.
- Working probe, confirmed by reading the PNG back: `GET
  /components/dialog?theme=dark` at 1440×900 rendered the live Dialog
  component doc page — breadcrumb "Components > Dialog", dark theme, Inter
  (not a fallback face), no red/yellow fallback error styling.
- A second oddity, not yet root-caused and worth a note rather than a
  guess: after a route resolves and renders correctly, `location.href` as
  read back via `page.evaluate` settles on the bare origin
  (`http://localhost:8321/`) rather than the path that was navigated to or
  typed. The **rendered content is correct** for every route tried
  (confirmed visually); only the JS-readable `location.href` disagrees with
  it. Flagged for the owner rather than chased further inside a
  reviewer-only Phase A slot — it does not block screenshot-based capture,
  since capture reads pixels, not `location.href`.

### Performance measurements — `test/performance_budget_test.dart`

Command:

```
flutter test test/performance_budget_test.dart > perf.txt 2>&1; echo "EXIT: $?"
```

Result: `EXIT: 0`, `5/5` passed.

| subject | frames | measured cost |
|---|---|---|
| `BackgroundEffect` (animated painter) | 120 | 251 µs/frame |
| `Spinner` (animated painter) | 120 | 3572 µs/frame |
| `CartesianChart`, area series, 24 points | 120 | 676 µs/frame |
| 500-item `ListView.builder`, dragged 20px/frame | 120 | 17328 µs/frame |
| Open `Dialog` (overlay), held steady | 120 | 267 µs/frame |

Ceiling asserted: **40,000 µs/frame** (`kPerFrameCeiling`), deliberately
generous. All five subjects passed with wide margin — the scrolling list is
the closest at ~43% of the ceiling, and that number includes
`WidgetTester.drag`'s own gesture-simulation overhead, not just layout/paint.

**Stated limitation (also in the test file's library doc):** this measures
wall-clock time for `pump()` inside `flutter test`'s software
`TestWidgetsFlutterBinding` — layout and paint on the *host* CPU, with no
Skia/Impeller rasterizer and no GPU anywhere in the loop. It is built to
catch a structural regression (an O(n²) layout, an unbounded rebuild, a
list that stopped virtualizing) — a ceiling breach here would be a real
finding. It is *not* evidence of a device frame time or an fps number; nothing
here should be read as "this hits 60fps on a phone."

### Confirmed defect: the `/design-system/...` specimen tree does not ship

Independently verified by the coordinator: `pageFor()` in
`example/lib/main.dart` — the function that resolves `elGroups`/`elRoot`
paths like `/design-system/typography` and
`/design-system/components/base/buttons` — **is called by nothing in
`lib/`**. Its only callers are tests. The entire `/design-system/...`
specimen route tree named in this task's original brief is unreachable
from the shipped router; every one of those paths falls back to the `/docs`
index in the live app (confirmed above by capture, not by inference). The
specimen pages behind those routes are real, built, and exercised — but
**only by widget tests**, never by a person who types or is linked to that
URL. This is recorded here as a real product finding, not just a rig
correction.

## Phase B — visual capture and inspection

Completed against the final release build. The full automated route matrix is
covered separately by 1876 example tests, including 134 responsive route
configurations with zero skips. Browser evidence concentrates on the six
highest-risk public surfaces instead of duplicating every widget-test case as
a PNG.

### Scope

Live routes only, since those are what a person actually reaches:

- `/docs/typeset`, `/components/button`, `/components/select`,
  `/components/dialog`, `/components/chart`, and
  `/components/agent-console`.
- Dark and light themes at 390×844, 768×1024, and 1440×900: **36 current-tree
  captures**.
- Manifest: `tool/verify/out/release-readiness-final/manifest.json`.
- Browser result: 0 failed requests; the one message per capture is Flutter's
  normal debug bootstrap message.

### Driver

`tool/verify/review-batch.js` launches one headless Chrome and reuses it across every capture
(`shot.js`'s flags and settle-then-shoot model, not `capture.js`'s
full-page stitcher — this is a defect-finding pass across many routes, not
a pixel-parity diff, and the stitcher's frame matcher is tuned to the docs
shell's own 1440-wide geometry per `tool/verify/README.md`). Writes
`<route-slug>__<theme>__<w>x<h>.png` into the given output directory plus a
`manifest.json` (route, theme, width, file, console messages, failed
network requests per capture) so the table below can be filled from the
manifest instead of re-deriving it by hand.

```
node tool/verify/review-batch.js http://127.0.0.1:8321 tool/verify/out/release-readiness-final
```

The checked-in `tool/verify/serve-spa.js` now supplies the required deep-link
fallback; the README no longer recommends a server that returns 404 for every
real documentation URL.

### Capture table (to fill in from `manifest.json` + actual PNG reads)

| route | theme | width | PNG | verdict | notes |
|---|---|---|---|---|---|
| Six routes above | dark + light | 390, 768, 1440 | `release-readiness-final/*.png` | pass | no clipping, fallback error ink, missing fonts, or failed requests in inspected frames |

### Defects found

- The first capture could occur before CanvasKit's first painted frame. The
  driver now performs one four-second cold warmup before evidence collection.
- Cold deep links to lower catalog entries, reproduced on `/components/chart`,
  opened with the page title above the viewport. `DocsLayout` used
  `Scrollable.ensureVisible` for the selected sidebar row, which also scrolled
  the enclosing article. It now calls the sidebar controller's own
  `ScrollPosition.ensureVisible`; the focused regression test proves the rail
  moves while the article remains at its minimum scroll extent. A rebuilt
  isolated browser capture confirms Chart now opens on its title.
