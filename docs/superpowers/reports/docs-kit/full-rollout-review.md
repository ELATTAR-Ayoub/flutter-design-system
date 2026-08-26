# Full documentation rollout — review

**Plan:** `docs/superpowers/plans/2026-08-25-full-documentation-rollout.md`
**Branch:** `public-release-v0.0.1`
**Date:** 2026-08-26

## What the rollout was for

The registry ships 99 items. Before this work, 55 of them had a documentation
page and **44 resolved to nothing** — a reader following a dependency list, a
search result or a bare URL landed on the homepage's "not found" fallback,
which is indistinguishable from the item not existing. The 55 that did exist
were 55 hand-composed layouts with no shared shape.

Every one of the 99 now has a page, and every page is the same page.

## Commits

| Commit | What |
| --- | --- |
| `864158f` | The three shell fixes: rail height, rail scrolling, links |
| `523d228` | Per-section stage heights; the 640 default drops to 384 |
| `bbfe1bc` | `DisclosureSection.children`, `EffectSection`, the page-shape guard |
| `9397ff2` | Phase B — controls, text inputs, forms (12 pages) |
| `9904b3f` | Phase B — selection, overlays, menus (12 pages) |
| `2a54424` | Phase B — the last 30 pages |
| `6350e18` | Phase C — the twelve agent-family items |
| `6b8082f` | Phase C — the remaining 32; **all 99 documented** |
| `0e358e9` | Phase D — the seven prose pages |
| `5f0b875` | The cross-reference link sweep, and nine dead links |
| `1b2b39c` | The doubled disclosure heading, and this report |

## The three shell fixes

These were asked for alongside the plan and landed first, because every page
inherits them.

**The rails rest at four fifths of the window.** They used to run the full
height. Both bounds are kept — the fold bound is a correctness rule, since a
row below the fold cannot be clicked, and on a short window it is the tighter
of the two. Applied on the `wide` branch only: below `ElBreakpoints.lg` there
is no rail at all, only the horizontal anchor strip, and a test now pins that
so a later change has to decide the tablet question deliberately rather than
inherit an answer.

**A mouse wheel over either rail glides instead of teleporting.**
`ScrollPosition.pointerScroll` — what `Scrollable` does, and what this
replaced — moves the full notch on the frame the event lands. Next to the
article underneath, whose scroll is a real physics simulation, the two
surfaces visibly disagreed about what scrolling is. `_SmoothRailScroll`
animates to the same destination over `ElDurations.fast`, accumulating the
target so a second notch mid-glide extends the movement rather than
restarting it. It is mounted twice per rail: on the overlay catcher that
answers the escaped band, and *inside* each rail's own `SingleChildScrollView`
— deeper than that view's own `Scrollable`, so it wins the
`PointerSignalResolver` and both halves of one rail behave alike.

**The "ON THIS PAGE" rows are links, in all three registers.** They carried a
pointer cursor and nothing else: no hover feedback, nothing announced. They
now hover, and a screen reader is told they are links. The affordance is
`DocsLink` / `DocsLinkRow`, extracted from the `/components` index's own
private link so an article's cross-references can use the same thing.

## What the kit gained

`ShowcaseSection.minHeight`, and a default that drops from 640 to 384. The
plan left the default as an open decision; the option it recommended was
taken, because a minimum only ever removes empty space — a taller specimen
still outgrows it, which is pinned by a test. The Button page stood 17,925px
tall because sixteen single pills each sat in the middle of a 640 box; it is
now 13,860px, and a section that genuinely needs the room asks for it.

`DisclosureSection.children` — one level of sub-anchors, so an API Reference
holding ten tables is ten destinations in the rail rather than one.

`EffectSection` — the fifth and last case of the sealed model, added
deliberately rather than as a generic escape hatch. Fourteen registry items
have no variants and often no widget of their own; a `ShowcaseSection` would
stage an empty box and call it a preview.

`docs_page_shape_test.dart` — every registered page must declare Preview,
Installation, Usage, then the eight disclosures in order, with exactly one
install section whose command comes from the catalog entry, no duplicate ids,
and a table of contents derived rather than written twice.

## Deviations from the plan

**The spec does not live on `ComponentDocEntry`.** The plan's Task 4 said to
add a `spec` field to the catalog entry and set it in `meta.dart`. That is an
initialisation cycle: a spec's `InstallSection.command` reads the entry's own
`command`, so an entry holding its own spec is a lazy `final` initialising a
lazy `final` that reads it back. The analyzer accepts it and it throws
`CyclicInitializationError` the first time the page is opened. The specs live
in `example/lib/components_docs/specs.dart` instead, at the same cost of one
line per page.

**Phase A's red-test runs were batched**, not run per task. The tests were
written before the implementation in every case, but the "run it and watch it
fail" step was done once for the group rather than four times.

**The plan's per-batch commit granularity was not achievable under
concurrency.** Three workers shared `catalog.dart`, `specs.dart` and
`main.dart`, so committing after each batch would have captured those files
mid-edit. Commits are per phase instead, each verified as a whole.

## What reading the sources turned up

The plan said "this is a re-housing, not a rewrite: every existing string
moves across unchanged." That is right for layout and wrong for claims about
the world, and the difference produced most of the findings below. Once the
first worker checked a claim on its own initiative, every later brief carried
the instruction with a running count.

**Seventeen pages denied their own registry manifest.** They printed "not
available", "unregistered", "no manifest yet" where an install command
belongs, while `registry/components/<name>.json` sat on disk. Several also
claimed their dependency list was "left empty" two lines above a list of
three to seven real dependencies. `sidebar` said it twice, in prose and in
its own install facts. Every one is corrected against the manifest it denied,
in the page and in the `meta.dart` doc comment that repeated it.

**Nine dead cross-reference links**, all the same mistake:
`/components/dropdown_menu` for `/components/dropdown-menu`,
`/components/alert_dialog`, `/components/context_menu`,
`/components/navigation_menu`, `/components/hover_card` — and
`/components/agent-slash-palette`, which fails the other way, that entry
being one of the underscored ones. `ComponentDocEntry.name` is spelled both
ways across the catalog and `route` is `/components/$name` either way, so a
hand-typed path is a coin flip. Every link now reads the catalog entry.

**Four wrong facts on the prose pages.** The CLI page claimed `--registry`
"rejects a URL outright" and that no command makes a network request —
`registry/location.dart` supports `http(s)://` and the CLI falls back to the
public registry over HTTP by default. Its exit-code table claimed to list
every code `ElattarCli.run` can return and was missing 70. The introduction
listed `press-motion` among button's registry dependencies; it is not one.
The installation page called `path: ../flutter-design-system` "the exact form
`example/pubspec.yaml` uses"; that file says `path: ../`.

**Behaviour that contradicted the pattern**, documented as it is rather than
as it reads:

* The slash palette and the attach menu bind no key at all. Both are menus;
  neither inherits arrow-key navigation, and the attach menu's rows carry no
  focus node.
* Markdown links are styled and inert — the inline renderer returns a span
  with an underline and no recognizer. A test walks every span tree looking
  for one.
* Nothing in the corpus consumes `glass` or `media-scrim`.
* Reduced motion differs per effect: the starfield stills to 0°,
  bloom-cosmic's two layers still 4% apart, sheen-action freezes invisible at
  frame 0, page-glow never animated.
* Every submenu renders `subBordered` regardless of parent, contradicting
  `menu.dart`'s own comment table.

**Three real layout bugs**, fixed at the source rather than worked around:

* `DocsDisclosure` put an unconstrained title in a fixed-height row. Every
  page shares that widget, so it was a `RenderFlex overflowed` waiting for
  whichever of the ninety-nine first wrote a heading longer than the reading
  column. One did, at 390px.
* The `card` page's specimens put a `spaceBetween` row inside a fixed 320px
  card and overflowed by 53px — at every viewport, not just narrow ones.
* The `sidebar` page's shell specimen had the same class of bug latent; the
  wider stage the kit gives it tipped a mobile-sheet row from silently
  clamped to genuinely overflowing.

**And one the tests could not see.** `DocsSection` printed its own heading
above a `DocsDisclosure` whose trigger row *is* the heading, so every one of
the eight trailing disclosures on every one of the 99 pages showed its name
twice, stacked. That is 792 doubled headings, and the whole test suite was
green over it. It was found by looking at a rendered capture. Two tests then
failed on the fix, because both had encoded the duplication — one expected
"API Reference" to match exactly twice, the other collected section names by
scanning for a heading that no longer exists. Both now assert the same fact
against the corrected rendering.

## Verification

Every command below was run and its output read.

| Command | Result |
| --- | --- |
| `ft root analyze` | No issues |
| `ft root test` | 1,510 passed |
| `ft example analyze lib test` | No issues |
| `ft example test` | 1,339 passed |
| `ft root test test/token_guard_test.dart` | 8 passed |
| `ft example test test/docs` | 58 passed |
| `ft example test test/components_docs` | 937 passed |
| `flutter build web --release` | Built `build/web`, 52 MB |

`docs_install_test.dart` carries the assertion the whole rollout exists to
satisfy — **every registry item has a documentation page** — asserted in the
direction that can only be satisfied by writing all 44. Its companion, that
no page invents a registry item, was already there.

## Captures

`tool/verify/out/rollout/`, at 1440 dark against the release build served
from `/c/elx/c`:

| Page | Height |
| --- | --- |
| `components/button` | 13,860px (was 17,925) |
| `components/chart` | 7,452px |
| `components/glass` | 5,760px |
| `components/agent-console` | 8,190px |
| `components/menu` | 6,570px |
| `components/keyframes` | 7,380px |
| `components/source_foundation` | 7,380px |
| `docs/installation` | 7,153px |

Plus `button` and `glass` at 390 dark via `shot.js`, and `glass` at 1440
light.

`capture.js --theme light` alone does not light this app: that flag writes
`localStorage('theme')`, which is the DOM reference's own mechanism. The
Flutter app reads `?theme=light`, and it has to be in the URL alongside
`?route=`. A light capture taken without it is a dark capture with a
misleading filename — which is what the first attempt produced.

The glass capture is the one to look at: it shows the effect-page shape
working — an opaque `theme.card` rectangle beside an `ElGlassPanel` over the
same backdrop — the rails resting short of the fold, the nested API
sub-anchors in the rail, and a real `elattar add glass` where the page used to
say the component had no manifest.

## Limitations

**The captures are a sample, not a sweep.** Eight of 106 pages at 1440 dark,
two at 390 dark, one at 1440 light. A visual defect on an uncaptured page
would not have been found — and the doubled-heading bug is the proof that the
test suite does not stand in for looking.

**`ShowcaseSection.description` and its siblings are `String`**, so a "see
also" written in a section description cannot carry a link, while the same
reference in a Dependencies `DocsLinkRow` beside it can. Auto-linkifying is
not the fix: half the component titles are common English words (Button,
Card, Table, Switch, Empty, Item, Rule, Command), so scanning prose for them
would over-link badly. Closing this wants an explicit marker in the string
that a renderer turns into a link. Left as prose, deliberately.

**`DocsTable` cells have the same limit**, for the same reason.

**The prev/next chain is not continuous.** Pages written in Phase C mostly
carry `previous: null, next: null` — there was no established order for a new
category to link into, and inventing one per batch would have produced a
contradictory chain. The pager renders nothing when both are null, so nothing
is broken; it is missing.

**One test was retired rather than retargeted.** `collapsible_test.dart`'s
"the CLI tab is absent from the live preview specimen" asserted a
`DocsCodeExample` property the kit no longer has. And the button page's
prev/next pager, which `component_docs_button_card_test.dart` used to
exercise, is not covered anywhere now that that file is deleted.

**`ElType.micro` is banned under `example/lib/docs/` and
`example/lib/components_docs/` but still in use in `example/lib/pages/`**,
which the guard does not scan. A worker reusing a specimen from there tripped
the guard. Whether the ban is meant to be repo-wide is undecided.

**No page was reviewed for prose quality.** Every claim was checked against
source; none was read as writing.
