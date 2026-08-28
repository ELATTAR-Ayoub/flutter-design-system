# Charts, and the site fixes around them — design

**Date:** 2026-08-26
**Branch:** `main` (release line; `dev` holds other work)
**Status:** design, approved in conversation, not yet planned

## Why this exists

Two things at once, and they are related only in that a reader meets both.

**Charts are documented for the wrong reader.** Four registry items — `chart`,
`chart-cartesian`, `chart-polar`, `chart-geometry` — each got a full house-shape
reference page in the rollout. That is correct for someone extending the chart
engine and wrong for everybody else. The owner's words: *"users dont need to see
the fucking geometry, cartesian, polar and shit like this, they want to copy and
use using our design system."* Four table-heavy pages sit in the component list
where one gallery belongs.

**And a set of defects a reader meets immediately.** A text cursor over every
link and disclosure, an invisible scrollbar in dark mode, footer links that
silently land on the homepage, agent components scattered through an alphabetical
list of 99, and charts that paint their axis labels outside their own box.

## Reference

shadcn's `/charts`, read directly rather than from memory
(`https://ui.shadcn.com/charts/area`):

* Top-level nav item, beside Docs and Components.
* **No left sidebar** on charts pages. Top nav only.
* **Separate routes per family** — `/charts/area`, `/bar`, `/line`, `/pie`,
  `/radar`, `/radial`, `/tooltip`.
* Stacked self-contained cards, one per variant: title, Copy, View Code, chart.
* **No API reference on those pages at all.** They link to
  `/docs/components/chart` for it.
* The `/charts` root is a hero — heading, one line of prose, CTAs, family links.

That last point is the one that matters most here: shadcn already separates
"copy this" from "read this". Adopting the split solves the registry problem
below for free.

---

# Part 1 — Charts

## Routes

| Route | What |
| --- | --- |
| `/charts` | Hero, then the family list |
| `/charts/area` | Area variants |
| `/charts/bar` | Bar variants |
| `/charts/line` | Line variants |
| `/charts/pie` | Pie variants |
| `/charts/radar` | Radar variants |
| `/charts/radial` | Radial variants |

**Charts joins the header nav**, beside Documentation and Components.

**No rails on these routes.** They are not `DocsLayout` pages; they use the
public-page shell, as the home page does. This follows the reference and avoids
a rail whose "ON THIS PAGE" would list six cards.

`/charts/tooltip` is deliberately **not** ported. Tooltip is a chart *feature*
here, not a family — `ChartTooltipSpec` is a parameter, and a family page for
it would document a field. If that proves wrong it is one more route later.

## A family page

A stacked list of self-contained cards. Each card carries a title, a short line
saying what it demonstrates, the live chart, and the source behind a Copy /
View Code control.

Cards are built from the specimens the four existing chart pages already
carry — the fixtures modelled on `example/lib/pages/charts.dart` — so this is
a re-housing of working demos, not new chart authoring. Any card that has no
existing specimen must be written from the component's real source, never
invented.

## The API reference collapses to one page

`/components/chart` becomes the single reference for **all four** registry
items. It keeps the house shape and the shape guard. The other three routes —
`/components/chart_cartesian`, `chart_polar`, `chart_geometry` — redirect to it,
and the left sidebar shows one "Chart" entry instead of four.

**This is load-bearing, not tidying.** `docs_install_test.dart` asserts that
every registry item resolves to a documentation page; that guard is the whole
point of the rollout, and `elattar add chart-polar` is a real command today. So
the guard gains a mapping: several registry names may share one page, and all
four chart names map to `/components/chart`. Deleting the three pages without
that mapping would leave three installable items documented nowhere and force a
guard to be weakened — which is not acceptable.

Each family page links to `/components/chart` for the tables, exactly as
shadcn's gallery links to its own component docs.

## The overflow defect

Reproduced locally at 1600 on `/components/chart_cartesian`: the axis labels
`Apr`, `May`, `Jun`, `Edge`, `Other` paint **outside** the specimen's bordered
stage, and `Jun` lands on top of the "ON THIS PAGE" rail roughly 60px past the
frame. The plot area ends where the frame ends; the labels do not.

**Cause is unknown and must be established before anything is changed.** Two
candidates:

1. the specimen hands the chart an unbounded or over-wide constraint, in which
   case the fix is in `example/lib/`; or
2. `CartesianChart` lays out from an intrinsic width rather than the
   constraint it is given, and does not clip, in which case the fix is in
   `lib/src/components/ui/chart_cartesian.dart` — the package itself, and a
   published registry item.

The rollout's "nothing under `lib/src/`" rule was that plan's constraint, not a
standing one. If the defect is in the package it is fixed in the package.

**The regression test must be width-parameterised.** This is the same class as
the rail defect: correct at one width, broken at another, and invisible to a
capture taken at the width where it happens to work. Assert the painted extent
against the stage's bounds across a range of widths.

---

# Part 2 — The site fixes

Each is small, independent, and carries no design decision. They are listed with
their diagnosis because each was traced to a specific line.

## 1. The cursor over links and disclosures

**Symptom.** Hovering a link, a table-of-contents row or a disclosure trigger
shows a text I-beam rather than a pointer.

**Cause.** `SelectionArea` wraps the whole body (`shell.dart:634` and
`_SiteBody`). Every selectable text beneath it installs its own `MouseRegion`
carrying `SystemMouseCursors.text`. Flutter resolves the cursor from the
**innermost** region in the hit-test path, and that selectable sits *deeper*
than the `MouseRegion(click)` wrapping the control — so the I-beam wins on
proximity. Flutter is not ignoring the pointer cursor; the text's cursor is
nearer the mouse.

This is a genuine Flutter/HTML difference. HTML resolves `cursor` per element,
and a UA stylesheet gives `<a>` a pointer that wins because it is *on* the
element under the mouse.

**Fix.** `SelectionContainer.disabled` inside the gesture detector, wrapping the
visual content. This removes the selectable and its cursor together.

`docs_sidebar.dart:163` already does exactly this, which is why sidebar rows
show a pointer and links do not. Three places lack it:

| Widget | Wrap |
| --- | --- |
| `DocsLink` | the `TweenAnimationBuilder` |
| `_TocRow` (`docs_layout.dart`) | the `Padding` |
| `DocsDisclosure` | the trigger `Row` |

The footer already opts out (`site_shell.dart:637`); its problem is hover, below.

**Accepted trade.** Those labels stop being drag-selectable. That is correct for
a control and is what the sidebar already does, but it is a trade and should be
stated rather than discovered.

**Not changed:** the I-beam over ordinary prose. It is correct, matches HTML,
and means "you can select this."

## 2. The dark-mode scrollbar

**Symptom.** No visible scrollbar while scrolling in dark mode.

**Cause.** `MaterialApp` is constructed with **no `theme:`**
(`main.dart:540`). The app themes everything through `Theme`, but Material's
scrollbar reads `ThemeData`, which therefore defaults to the *light* theme — a
near-black thumb on a near-black page.

**Fix.** A `scrollBehavior` on `MaterialApp` whose scrollbar is themed from
`Theme`, so the thumb follows the live theme. Preferred over passing a Material
`theme:`, which would introduce a second source of truth for colour beside the
token system.

## 3. `source-foundation` moves to Sections

It is the foundation, not a component, and sits in the component list today.
Moves to the "Sections" group in `_defaultSidebarGroups`.

## 4. An "Agent" sidebar group

The twelve agent items are scattered through an alphabetical list of 99. They
get their own "Agent" group between Sections and Components.

Both 3 and 4 are `_defaultSidebarGroups` — one function, one file.

## 5. The footer

**Dead links.** The "Design system" column is built from `elGroups`, whose paths
are `/design-system/…`. Those routes resolve only in `showcase_main.dart`, a
different app entry. The public site calls `publicPageFor`, whose fallback is
`_ => PublicHomePage`. So every one of those links **silently drops a reader on
the homepage** — Overview, Base Components, Agent, Site Pages.

This is the same defect already fixed on the components index, whose comment
reads *"a page a reader cannot open does not belong in an index."* The footer
was missed. It gets real destinations: Documentation, Components, Charts,
Installation, Theming, CLI, Registry, Changelog, Skills.

**No hover.** `_FooterColumn` uses `MouseRegion` + `Press` + `Text` with no
colour change. It moves to `DocsLink`, so the footer, the sidebar, the rail and
the components index all behave alike.

**Credit.** A line reading *"Built by Ayoub Elattar"* with a link to
`github.com/ELATTAR-Ayoub`. **No email address** — it is already public in commit
metadata, and a plain-text address on a documentation site is what scrapers
harvest.

---

# Part 3 — The registry follows the reference: mutable, not pinned

## The decision

`elattar_cli` currently pins `https://flutter.elattar.dev/registry/0.0.1/` and
promises that path never changes. **That promise is dropped.** The CLI will read
a single mutable path — `/registry/latest/` — the way shadcn's does.

Checked against the reference rather than assumed
(`https://ui.shadcn.com/r/styles/new-york/button.json`): shadcn serves its
registry from its own site, with **no version in the path**, the file content
**inline** in the JSON, and **no checksum of any kind**. Their registry is
always-latest and mutable by design, so nothing breaks when it changes.

## Why this is safe here

This is a copy-first system. `elattar add` writes files into a project; it never
updates code already installed. A changed registry therefore cannot alter
anybody's working tree. The only consequence is that two people installing at
different times get different source — which is exactly shadcn's behaviour and
is the normal expectation for this class of tool.

Nothing is published yet, so no promise has been made to anyone. This is the
last moment the decision is free.

**We keep the sha256 verification** even though shadcn has none. It costs
nothing, it is already implemented and tested, and it still does real work:
proving a payload arrived intact. It simply stops being mistaken for a proof
that the version did not change — which it never was.

## What this reverses, deliberately

`stage.dart --alias` exists today to write a mutable `/registry/latest/` **for
browsing**, and its comment says: *"A released CLI must never default to it —
that is the whole distinction this tool exists to keep."* This design makes the
released CLI default to exactly that. The comment is now wrong and must be
rewritten to record the reversal and its reasoning, not silently deleted.

Likewise `identity.dart`'s `defaultRegistryUrl` doc comment, which argues at
length for pinning. It is replaced by the argument above.

## The work

* `defaultRegistryUrl` becomes `$siteOrigin/registry/latest/`. It stops
  composing `cliVersion`.
* `release_audit`'s `registryUrlCompositionFinding` currently requires the URL
  to derive its version from `cliVersion`, and its sibling check extracts the
  version from the URL to prove four spellings of one number agree. Both change:
  the URL no longer carries a version, so the audit must stop demanding one —
  and must not simply be deleted, since the pubspec/`--version`/tag agreement it
  guards is still real.
* `tool/deploy_site` stages `/registry/latest/`.
* The immutability refusal in `stage.dart` no longer applies to `latest`. It
  should refuse loudly if asked to stage a *versioned* path over different
  bytes, since that path keeps its old meaning if anyone uses it.
* Prose: the CLI page, the Registry page, `tool/README.md`, both CHANGELOGs and
  `identity.dart` all currently state the pin. Every one is corrected. This
  codebase has a track record of stale claims outliving the thing they
  described; this is the moment not to add another.

## The risk this accepts

An old CLI and a new registry can disagree. `supportedRegistrySchemaVersion`
already exists and the client validates it, so an incompatible schema change
fails with a clear error rather than installing something wrong. That is the
safety net, and it is adequate — but it means a future breaking schema change
requires a CLI release, not just a redeploy.

---

## Constraints that must survive

* `docs_install_test.dart` — every registry item resolves to a page. Extended
  with a many-names-to-one-page mapping, never weakened.
* `docs_page_shape_test.dart` — every page in `componentDocSpecs` keeps the
  house shape. `/charts/*` are not component doc pages and are not in that map.
* `site_routes_test.dart` — every declared route is reachable. The new
  `/charts/*` routes are covered automatically once declared.
* `token_guard_test.dart` and the uppercase guard — unchanged.
* `docs_rail_bounds_test.dart` — the rails stay inside the boxes that hit-test
  them, at six widths.

## Out of scope

* Re-authoring chart specimens that already work.
* The prev/next chain, and the other open items in the rollout report's
  Limitations section.
* Publishing the CLI. That is sequenced separately and gated on the live
  registry.

## Risks

* **The chart overflow may be in the package.** If so the fix touches a
  published registry item's source and needs its own regression coverage in the
  package suite, not only the example suite.
* **Collapsing four pages into one loses per-item constructor-coverage tests**
  unless the merged page's test asserts the union of all four. It must.
* **`/charts` without rails is a third page shape** on the site, after the
  component pages and the prose pages. Accepted, because it follows the
  reference and because a rail listing six cards would be noise.
