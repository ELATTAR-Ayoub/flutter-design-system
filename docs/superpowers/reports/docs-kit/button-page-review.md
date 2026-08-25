# Button page rebuilt on the documentation kit — verification report

**Date:** 2026-08-25
**Branch:** `public-release-v0.0.1`
**Head at verification:** `ca3a49d`
**Base:** `5654842` — 18 commits
**Mode:** repository mode (`lib/elattar_design_system.dart` present, no `elattar.yaml`)

This records what was built, what was actually run, and what is still open. It
makes no parity claim against a reference page: this page shape has no reference.

## What was built

Nine kit components in `example/lib/docs/`, then `/components/button` rebuilt on
them. Nothing under `lib/src/` changed; no foundation token was added or edited.

| Component | File |
| --- | --- |
| `DocsCopyButton` | `docs_copy_button.dart` |
| `DocsSnippet`, `DocsSnippetOverflow` | `docs_snippet.dart` |
| `docsTokenise` (Dart grammar) | `docs_syntax.dart` |
| `DocsAnchor`, `DocsSection` | `docs_section.dart` |
| `DocsShowcaseFrame`, `DocsShowcase` | `docs_showcase.dart` |
| `DocsDisclosure` | `docs_disclosure.dart` |
| `DocsTable`, `DocsTableColumn` | `docs_table.dart` |
| `DocsInstall` | `docs_install.dart` |
| sealed section model, `ComponentDocSpec`, `DocsPageHeader`, `ComponentDocPage` | `component_doc_page.dart` |

`ElSection` in `example/lib/kit.dart` became `DocsAnchor` + `DocsSection`
composed, so its 92 call sites were not edited.

## Measured counts

- **16** `DocsShowcase` on the page — Preview, Size, seven variants, Icon, With
  Icon, Rounded, Spinner, Disabled, Emphasis, Button Group.
- **1** `DocsInstall`.
- **8** `DocsDisclosure` — API Reference, States, Accessibility, Keyboard,
  Responsive, Dependencies, Theming, Source.
- **26** table-of-contents entries, derived from the section list via
  `ComponentDocSpec.toc`, wired as `toc: buttonDocSpec.toc`.
- **60** `ElType.label` references replaced with `ElType.section` across 30 files.
- `button/page.dart`: **1,638 -> 1,661 lines** (+23). The page did not shrink.

## Commands actually run, with results

Every Flutter command ran under WSL2 Ubuntu-24.04 with a native Linux Flutter
3.44.8 — the version this repository pins. Windows-side `flutter test` is
blocked by Smart App Control, which began enforcing against the unsigned
`flutter_tester.exe` mid-session; no security setting was changed to work
around it. Runs used an ext4 mirror of the working tree (`/usr/local/bin/ft`)
because DrvFs is too slow for Flutter.

| Command | Result |
| --- | --- |
| `flutter analyze` (root) | No issues found, 64.3s, exit 0 |
| `flutter test` (root) | **1,510 tests, all passed**, exit 0 |
| `flutter analyze lib test` (example) | No issues found, 11.4s, exit 0 |
| `flutter test` (example, full) | **921 tests, all passed**, exit 0 |
| `flutter test test/token_guard_test.dart` | 8 tests, passed — run after every task |
| `flutter test test/components_docs` | 536 tests, passed — run separately during Task 3 |
| `flutter build web --release --base-href /flutter-design-system/` | exit 0, 155.6s |

`flutter analyze` scoped to `lib test` deliberately: run bare from `example/`
it reports ~4,788 errors, all from stale `example/build/web/registry/**`
artifacts of an earlier release build. That is pre-existing and unrelated.

### The full example suite caught two regressions the per-task runs did not

The first full run was **919 tests, 2 failed**. Both were real and both were
fixed, not suppressed:

1. `docs_facts_test.dart` — the reference tables lost text selectability.
   `DocsApiTable` used to render cells through a private `_SelectableFactText`
   wrapping `SelectableText`; the move onto `ElTable` rendered plain `ElText`.
   A reader could no longer select a property name to copy it. Fixed in
   `70f1499`.
2. `button_route_integration_test.dart` — depended on the six nested
   API-Reference table-of-contents children that the flat `ComponentDocSpec.toc`
   drops. The test's real subject is that a TOC entry scrolls rather than
   navigates, so it was retargeted at a surviving anchor with the behavioural
   assertion unchanged. No nested children were reintroduced. Fixed in `ca3a49d`.

The re-run after both fixes is the 921/921 recorded above.

## Captures

Served from `C:/elx/a` (a short path — a capture root under a long temp path
pushes the deepest bundled assets past Windows MAX_PATH and the server 404s
them), `python -m http.server 8331`.

| File | Route | Theme | Dimensions | Tool |
| --- | --- | --- | --- | --- |
| `button-dark-1440.png` | `/components/button` | dark | 1440x17925, 22 frames | `capture.js --settle 2500` |
| `button-light-1440.png` | `/components/button` | light | 1440x17402, 22 frames | `capture.js --settle 2500` |
| `button-dark-390.png` | `/components/button` | dark | 390x844 | `shot.js 390 844 9000` |
| `button-light-390.png` | `/components/button` | light | 390x844 | `shot.js 390 844 9000` |

They live in `tool/verify/out/` and are **not committed** — 26 MB of PNGs.

In the stitched 1440 captures the sidebar and table-of-contents columns repeat
down the image. That is the wheel-stitch rig meeting sticky rails, not a page
defect.

## Open for the owner's decision

**The 640 specimen stage is oversized for a button.** `DocsShowcase.tallMinHeight`
is `el(160)` = 640, a locked decision in the approved design. On this page it
means a single pill floating in a 640-tall box, sixteen times over, and a page
that stands 17,925px tall. The design listed this as the risk to judge at this
gate and it is now judged: it reads as a lot of empty space. Reducing the
minimum, or making it per-section, is a design change and was not made here.

**The page did not shrink.** 1,638 -> 1,661 lines. The sixteen per-specimen
widget classes cost more than the removed anchor plumbing saved. The win is
structural — the table of contents and the sections cannot drift, presentation
is centralised, and the remaining pages become declarations — not fewer lines.
That is the evidence for the rollout decision, and it is weaker than the design
predicted.

## Known limitations

- `DocsCodeFile.title` and `.description` initially rendered nowhere in
  `DocsInstall`, losing the numbered install steps. Restored in `a6df1f5`.
- The old "Manual install facts" block was dropped. Its registry-dependency and
  semantic-dependency facts duplicate the Dependencies disclosure verbatim; the
  one-sentence framing around the manual copy target is genuinely gone, though
  the path itself still appears in the Manual tab.
- The six `api-elbutton*` anchors no longer exist. Any external link to them
  is dead.
- `ComponentDocSpec.toc` is flat. A page wanting a grouped rail needs a change
  to the model.
- `ElTable` exposes no semantics for its header row, so "the header is a header
  to semantics" is asserted nowhere. Adding it would mean editing `lib/src/`.
- `initiallyOpen: true` on `DocsDisclosure` is correct by code trace but
  untested.
- The plan named `ElType.textSm` as a substitution target in two places. It does
  not exist — `textSm` belongs to `ElComponentType`. `ElType.section` was used.

## Scope

Only the Button page was rebuilt. The kit was not rolled out to a second page,
and the 49 registry items with an unresolvable `documentationRoute` were not
written. Nothing was pushed, no tag was created, no release was made, GitHub
Pages was not deployed, and `dart pub publish` was not run.
