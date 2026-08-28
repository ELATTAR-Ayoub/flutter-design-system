# Phase I — independent audit findings (I2: visual, responsive, accessibility)

> **Historical snapshot.** This report records what was true on the date and
> at the commit named in it. It is kept for the reasoning, not as a statement
> of the current release — several findings below were closed afterwards. For
> what is true now, read
> [`v0.0.1-public-release-baseline.md`](v0.0.1-public-release-baseline.md),
> which classifies every finding here against the commit that fixed it, and
> the root [`CHANGELOG.md`](../../../../CHANGELOG.md).

First human-equivalent eyes on this app. Every prior phase was verified by tests,
analyzer and diffs — all text. Run in a real browser against the release web
build, using the app's own boot parameters (`?route=`, `?theme=`, `?motion=`,
`?clock=`). Auditor edited nothing.

## BLOCKER F1 — the entire public site renders in Flutter's "you forgot a Material" error style

Every `Text` on every public route shows **yellow double underlines**, and
every inherit-colour string renders in **error red** — in both themes, at all
three viewports.

Cause: the public site has no `Material`/`DefaultTextStyle` ancestor, so text
inherits the SDK fallback (`packages/flutter/lib/src/material/app.dart:45-54`):
`color: Color(0xD0FF0000)`, `decoration: underline`,
`decorationColor: Color(0xFFFFFF00)`, `decorationStyle: double`,
`debugLabel: 'fallback style; consider putting your text in a Material'`.
That debugLabel string is present in the shipped `main.dart.js`.

`example/lib/shell.dart:165` neutralises this for the docs shell, and
`example/lib/showcase/showcase_app.dart:151` does the same for the showcase.
`example/lib/site/site_shell.dart` and `example/lib/shots_docs/shot_preview_host.dart`
never got it. `Text` (`lib/src/design_system/foundation/theme_scope.dart:244-262`) builds with
`inherit: true` and never sets `decoration`; its `TypeColor.none` arm (`:238-241`)
resolves colour as `DefaultTextStyle.of(context).style.color ?? theme.foreground`,
so both the underline and the red leak through.

Worst cases: `/components` renders its intro paragraph bright red in both themes.
`/shots/settings-profile/preview` — the flagship composition — renders "Profile",
"Display name", "Email address", "Time zone", "Language" and both input
placeholders in red. `/shots/dashboard-overview/preview` renders all four headline
metrics in red.

Confirmation from the other direction: the dialog on `/components/dialog` is a
pushed route that does not inherit the shell, and its text is clean while the page
behind it is red and underlined. `/design-system/*` is completely unaffected.

**Every public-facing page looks like a broken debug build, including the three
compositions the CLI installs into user projects.**

## BLOCKER F2 — in-page navigation is broken on all nine DocsPageLayout routes

Affects `/skills`, the five `/components/<name>` guides, and the three
`/shots/<slug>` pages.

`example/lib/docs/docs_layout.dart:318` (`_AnchorStrip`) and `:284`
(`_TableOfContents`) both call `onNavigate(entry.anchor)` with a bare anchor id
(`'overview'`, `'files'`). Nothing routes those, so `main.dart` falls through to
the docs-shell placeholder.

At 768x1024 on `/skills`, tapping "Overview" or "Files" replaced the page with
eyebrow "DESIGN SYSTEM", title "Not found", body "No page yet." — and swapped the
public header for the docs header. Reproduced twice, both themes.

At 1440x900 the same entries in the "ON THIS PAGE" rail are simply **inert** —
verified with both a synthetic tap and a real browser click.

`example/lib/kit.dart:161-200` already contains the anchor machinery
(`anchorKey(id)`, scroll-to-anchor) these should be using. The fix is sitting
unused.

## IMPORTANT F3 — the GitHub CTA shows a developer error to the public

Tapping "GitHub" (desktop header, mobile nav sheet, footer) raises a toast
reading "GitHub action not wired / Pass onOpenGitHub to the public site shell
when the repository link is ready." `example/lib/site/site_shell.dart:71-85`;
`onOpenGitHub` is null at every call site, so this is shipped behaviour.

## IMPORTANT F4 — source in the Files viewer is hard-truncated on desktop

`/shots/<slug>` and `/skills` at 1440x900, both themes. Lines cut mid-token with
no ellipsis and no scroll affordance: `class DashboardOverviewShot extends Statefu`,
`# Build a coherent, useful interface from the existing`. The shell-command blocks
in `/skills` do render a scrollbar at tablet width, so the mechanism exists — the
wide code panel clips silently. The source these pages exist to display cannot be
read.

## IMPORTANT F5 — re-tapping a selected Shots filter moves selection to a different segment

`/shots`, 390x844. Tap "Account" -> Account selected. Tap "Account" again -> the
pill jumps to "All". `shots_index_page.dart:115-118` coerces the toggle group's
deselect `null` to index 0.

This is the behaviour a previous fix deliberately introduced and tested. The
auditor's objection stands anyway: a segmented control where tapping the active
segment silently activates a *different* one is surprising. Worth reconsidering
as a design decision, not a defect.

## MINOR

- **F6** ~100px of empty space above the first line in every Shot source viewer.
- **F7** Copy buttons give no visible confirmation — press state only, no toast,
  no label change. The toaster demonstrably works on these routes.
- **F8** Console error on first interaction: `Blocked call to navigator.vibrate
  because user hasn't tapped on the frame yet` — haptics firing on web.
- **F9** Escape did not dismiss the open select menu on `/components/select`;
  tap-outside did.
- **F10** No scroll affordance on the mobile anchor chip strip — 4 of 8 chips
  visible at 390, fifth clipped with no fade.

## What was genuinely fine

- **The preview route contract holds in a real browser.** All three
  `/shots/<slug>/preview` render with no header, footer or search;
  `/shots/<slug>` renders with full chrome. The route-ordering fix works.
- **No overflow anywhere.** Not one Flutter overflow stripe at 390, 768 or 1440
  on any route. Grids collapse 3->2->1 correctly; dashboard stat tiles stack
  cleanly at 390; the footer stacks properly.
- **Themes.** Toggle switches instantly and preserves scroll position. Light-theme
  card and input borders stay visible. No invisible-text or vanished-border cases
  beyond F1's red.
- **Interactions.** Dialog opens centred over a scrim and closes cleanly; select
  menu opens with groups and dismisses on outside tap; mobile nav sheet highlights
  the current route; search overlay lays out correctly; the `/skills` file tree
  switches and all eight skill files load real content.
- **Keyboard.** Tab moves focus, focus rings are clearly visible, focused elements
  scroll into view.

## Accessibility — UNAUDITED, and this remains open

Flutter web keeps semantics disabled until assistive tech activates it.
`read_page` returned only a placeholder `button "Enable accessibility"`, and the
auditor could not flip it — synthetic click, real click, keyboard Enter, and
z-index manipulation all failed.

**The empty tree is Flutter's default, not evidence the app lacks semantics.**
From source the app does disambiguate names (`'View shot: ${entry.title}'`,
`'Open live preview of ${entry.title}'`, `'$label filter'` group wrappers), so the
identical-names hazard appears addressed — but nobody has confirmed it against a
screen reader. Plan §8.4 accessibility review is still not satisfied.

## Coverage gaps, stated honestly

Not reached: light theme at 390 on any route; tablet 768 for any shot route or for
`/`, `/docs`, `/shots`; `/docs` and `/shots` in light at any viewport;
`/components/{button,input,card}` outside 1440 dark. F1 and F2 reproduce
identically across every combination tested, so these gaps are unlikely to hide
anything new — but they are gaps.

## Verdict

**Not publishable as-is.** The underlying engineering is sound — responsiveness is
genuinely good, no overflow anywhere, themes switch cleanly, every interactive
component behaves. But F1 alone makes every page look like a broken build, on the
only pages a public visitor sees.

F1 and F2 share a cause worth naming: the public-site layer (`site_shell.dart`,
`docs_layout.dart`, `shot_preview_host.dart`) is the newest code and the only code
the docs shell's own conventions were never applied to. `shell.dart:165` fixes
F1's cause in one line. `kit.dart:161-200` already holds F2's fix. Both are small.
