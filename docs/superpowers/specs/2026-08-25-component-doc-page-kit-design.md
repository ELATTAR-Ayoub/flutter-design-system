# Component documentation page kit — design

**Status:** Approved design
**Date:** 2026-08-25
**Repository mode:** design-system repository
**Branch:** `public-release-v0.0.1`
**First page:** `/components/button`

## 1. Goal

Give every component documentation page one shape, built entirely from
components, so that the page a reader lands on is the same page for `button`
as for `agent-console`, and so that the forty-nine registry items with no page
today cost a data declaration rather than a thousand lines of layout.

The Button page is built first, on its own, for review. Nothing else moves
until it is accepted.

## 2. Why now

Two facts make this the right moment.

The Button page already carries the right content in the right order —
Installation, Usage, Size, each variant, Icon, With Icon, Rounded, Spinner,
Disabled, Emphasis, Button Group, API Reference, States, Accessibility,
Responsive, Dependencies, Theming, Source. **This is not a content rewrite.**
It is a re-housing of existing content into components that other pages can
reuse.

And the v0.0.1 verification found that 49 of the 99 registry items publish a
`documentationRoute` the site cannot resolve — every effect, every motion item,
the foundation, and 34 components, including the whole agent family. The reader
is not shown a 404; the router quietly lands them on the documentation index.
A page kit is the only thing that makes closing that gap tractable.

## 3. Locked decisions

| Decision | Resolution |
| --- | --- |
| Uppercase | These pages stop **using** the uppercase type roles. The foundation is not touched. |
| Showcase / code | One frame with a Preview↔Code toggle. Not two stacked blocks, not a third disclosure pattern. |
| Scroll model | The centre column keeps the page scroll it has today. Only the two rails change, and only to fix a real defect. |
| Where the components live | `example/lib/docs/`. Product code, never `lib/src/components/`. |
| Disclosure default | Every text/table section is collapsed by default, API Reference included. |

### 3.1 Uppercase

Uppercase is not a page-level choice in this system. It is a `uppercase: true`
flag on seven foundation type roles — `label`, `micro`, `tag`, `badge`,
`serial`, `inputSerial`, `buttonLabelCaps`. Ordinary `buttonLabel` is already
lowercase, so normal buttons are unaffected.

Documentation pages therefore stop *using* those roles: eyebrows, section
labels and table headers move to `caption`, `small` and `textSm`. A guard test
asserts no uppercase role appears under `example/lib/docs/` or
`example/lib/components_docs/`.

Changing the flag in the foundation was considered and rejected: the
contribution contract forbids editing foundation tokens to solve a page
problem, and it would reach every installed consumer copy.

### 3.2 The scroll model

Today `_SiteBody` wraps the whole page in one `SingleChildScrollView`, and the
two rails are sticky boxes inside it with their own inner scrollers. That model
stays.

The defect is narrower than it looked. `railMaxHeight` is the **full** viewport
height, but each rail begins *below* the 64px sticky header — so the last
~64px of every rail sits past the fold and its final rows cannot be reached.
The fix is the height, not the architecture:

```
railMaxHeight = viewportHeight - ElWidths.siteHeader - el(4)
```

Nothing else about the shell changes. The centre column keeps
`ElWidths.article` (640) and the page scroll.

## 4. Component inventory

Eleven components. Every repeated piece of a page is one of them; a page
composes them and declares nothing else. All live in `example/lib/docs/`.

### 4.1 Code

**`DocsSnippet`** — the single code renderer for the whole documentation
surface.

The docs currently carry their own tokenizer (`_DsCodeTokenKind`,
`DocsSelectableCodeBlock`) which is a second, weaker syntax theme. The agent
family already ships the real one: `ElAgentCodeBlock` over `ElPrismPalette`,
which is VS Code **Dark Plus** as `react-syntax-highlighter` writes it, already
carrying its own `allow-hardcoded` provenance note. `DocsSnippet` renders
through that, and the docs tokenizer is deleted.

Responsibilities: language label, the highlighted body, horizontal overflow
scrolling, a height cap with expansion, and a copy control. Nothing else in the
kit renders code.

**`DocsSnippetOverflow`** — the height cap. Above `maxHeight` the body is
clipped and a "Show more" control unfolds it through `ElUnfold`; the control
reads "Show less" when open. Separate from `DocsSnippet` so the showcase can
cap at 640 while the Usage section does not cap at all.

**`DocsCopyButton`** — `ElButtonVariant.secondary`, `ElButtonSize.iconSm`,
`ElLucide.copy` → `ElLucide.loaderCircle` → `ElLucide.check`. The accessible
name carries the state, because nothing but the glyph distinguishes a copy from
a mis-tap. Used by every snippet and by the install command.

### 4.2 Specimens

**`DocsShowcase`** — the specimen frame, and the component the reader sees most.

- Minimum height `el(160)` = **640**, relaxing to `el(96)` = 384 below
  `ElBreakpoints.md`: 640 is taller than a 390×844 phone viewport minus header
  and toggle, and the title and control must stay on screen.
- A Preview↔Code toggle on `ElToggleGroup`, one item each.
- **Preview** centres the live specimen on a neutral surface.
- **Code** shows the specimen's own source through `DocsSnippet`, capped at the
  same 640 with `DocsSnippetOverflow`.
- The toggle keeps its selection per showcase instance, not per page.

**`DocsShowcaseFrame`** — the neutral surface and centring inside Preview,
separated so a specimen that needs its own alignment (a full-width bar, a
stacked group) can use the frame directly without the toggle.

### 4.3 Disclosure and tables

**`DocsDisclosure`** — every text-or-table section.

`ElCollapsible`, **collapsed by default**. The trigger is a full-width row:
title on the left, `ElLucide.chevronDown` hard right, `space-between`, width
100%, the chevron rotating on open through `ElDurations`/`ElCurves`. The whole
row is the control, with a single focus ring and a keyboard-activatable
semantics node.

Carries: API Reference, States, Accessibility, Keyboard, Responsive,
Dependencies, Theming, Source.

**`DocsTable`** — rewritten on the package's `ElTable` instead of the
hand-rolled `_TableHeader`/`_FactRow` pair in `docs_facts.dart`. Columns are
declared as fractions summing to 1 through `ElTableColumnWidth`, so the table
fills its container with no trailing gap. Horizontal overflow scrolls inside
its own container; the page never scrolls sideways.

**`DocsApiTable`** — `DocsTable` with the API column set (property, type,
default, description) and the `DocsApiFact` model it already has. It is a
configuration of `DocsTable`, not a second table.

### 4.4 Installation

**`DocsInstall`** — CLI↔Manual toggle over `DocsSnippet`, on the same
`ElToggleGroup` as the showcase so there is one toggle pattern on the page.

The CLI command comes from `ComponentDocEntry.command`, which derives it
(`'elattar add ' + name`) rather than restating it. A new test asserts that
every entry's command names an item that exists in
`registry/generated/latest/registry.json`, so a reader cannot copy a command
that fails.

Manual shows the installed file paths and their source, as it does today.

### 4.5 Page

**`ComponentDocPage`** — the page itself, as a component.

It takes a `ComponentDocSpec` and renders it. The spec is a sealed section
model:

```
sealed class DocsSection
  ShowcaseSection    title, description, specimen, code
  SnippetSection     title, description, code            // Usage
  InstallSection     command, manual files
  DisclosureSection  title, prose and/or table
```

A page file becomes a declaration: its intro, its ordered sections, its API
facts. `ComponentDocPage` walks the list, wraps each in the existing
`ElSection` from `example/lib/kit.dart`, and hands `DocsLayout` the table of
contents derived from the same list — so a section can never exist without a
TOC entry, or a TOC entry without a section.

**`DocsPageHeader`** — breadcrumb, title, description. Composed from
`ElBreadcrumb` and `ElText`; supplied by `ComponentDocPage`, not by each page.

## 5. What a Button section looks like

Every showcase section on the page is one declaration:

```
ShowcaseSection(
  title: 'Destructive',
  description: '...',
  specimen: ElButton(
    variant: ElButtonVariant.destructive,
    onPressed: () {},
    child: const Text('Delete'),
  ),
  code: '...',
)
```

Sixteen of those, one `InstallSection`, one `SnippetSection`, and eight
`DisclosureSection`s replace 1,638 lines of hand-composed layout.

## 6. Boundaries

- Nothing under `lib/src/` changes. This is documentation product code.
- No foundation token is added or edited.
- No visual, motion, geometry or colour literal enters `example/lib/`;
  `test/token_guard_test.dart` enforces it.
- Only the Button page is rebuilt. No other component page, and no site page,
  is touched in this pass.
- The 49 missing documentation pages are **not** written here. This work makes
  them cheap; it does not do them.

## 7. Testing

| Subject | Test |
| --- | --- |
| `DocsSnippet` | renders through the Prism palette; copy writes the exact source; overflow expands and collapses |
| `DocsCopyButton` | idle → pending → copied glyphs; accessible name changes with state; disabled while pending |
| `DocsShowcase` | 640 minimum at wide, 384 below `md`; toggle switches panes and keeps per-instance selection; specimen is reachable by keyboard |
| `DocsDisclosure` | closed by default; title row activates by tap and by keyboard; chevron rotates; content is not in the tree when closed |
| `DocsTable` / `DocsApiTable` | fills its width with no trailing gap; overflows inside its own scroller; header is a header to semantics |
| `DocsInstall` | the CLI pane shows `ComponentDocEntry.command` verbatim |
| Command truth | every `ComponentDocEntry.command` names a real registry item |
| No uppercase | no uppercase type role is referenced under the documentation directories |
| Button page | every declared section renders and appears in the TOC; both themes; narrow and wide |

`ElAlert` appears in no part of this kit, so `pumpAndSettle` is safe here — but
any test that pumps a page containing one must use `pump()`.

## 8. Verification

Repository-mode ladder from
`skills/elattar-flutter-ui-director/references/verify.md`: root and example
`flutter analyze` and `flutter test`, the token guard directly while iterating,
and a release web build. Visual review of `/components/button` in both themes
at 1440 and 390 using `tool/verify/capture.js` and `shot.js`.

## 9. Risks

| Risk | Control |
| --- | --- |
| The sealed section model over-abstracts before one page has been seen | The model has four cases and no inheritance. If Button needs a fifth, it is a fifth case, not an escape hatch. |
| Deleting the docs tokenizer changes how existing pages render code | Every docs page moves to `DocsSnippet` in the same commit; the tokenizer has no other caller. |
| 640 showcase plus 640 column reads as a tall empty box for a small specimen | The frame centres and the toggle sits inside it; reviewed on the Button page before rollout. |
| Rail height fix shifts other docs pages | It only extends reachability downward; no page loses content. Verified on a long page. |
