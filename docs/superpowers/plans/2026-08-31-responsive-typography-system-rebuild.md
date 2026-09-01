# Responsive Typography System Rebuild Plan

> **Master-plan note:** this plan is now the typography portion of Workstream 1 in
> `2026-08-31-native-flutter-system-architecture.md`. Execute it through that
> dependency order so shared interaction, component geometry, documentation,
> and registry changes are migrated coherently. Do not run it as an isolated
> typography-only rewrite.

> **For Cloud:** use `superpowers:executing-plans` when that skill is
> available. Before changing Flutter UI, read `AGENTS.md` and use
> `skills/elattar-flutter-ui-director/SKILL.md` in repository mode. Execute
> this plan task by task, keep evidence for every gate, and stop before any
> publish, tag, push, deploy, or destructive migration.

**Goal:** Replace the current 27-role typeset with a small, readable,
responsive public type system; migrate every product and documentation call
site to it; remove the unused accent face and “Labels and furniture” family;
and prove the package, examples, docs, registry, and release artifacts still
work at normal and 200% text scale.

**Why this execution order is deliberately token- and compile-efficient:**
Flutter compilation is the expensive gate. Search and source migration are
cheap. Do one broad inventory, make coherent batches of changes, run only the
focused tests that can identify the current batch's failures, and run the full
root/example/build/release ladder once after the tree has stabilized. Do not
re-run `flutter test`, `flutter build web`, or registry generation after every
file.

## Final public contract

The public catalog contains exactly these three groups and seventeen roles.
There is no “Labels and furniture” group and no accent type role.

| Group | Public role | Mobile `<768` | Tablet `768–1023` | Desktop `>=1024` | Weight | Face |
|---|---|---:|---:|---:|---:|---|
| Words | `display` | 44/48 | 52/56 | 64/68 | 600 | Inter |
| Words | `h1` | 36/40 | 40/44 | 48/52 | 700 | Inter |
| Words | `h2` | 30/36 | 32/38 | 36/42 | 650 | Inter |
| Words | `h3` | 24/30 | 26/32 | 28/36 | 600 | Inter |
| Words | `h4` | 20/26 | 22/28 | 24/30 | 600 | Inter |
| Words | `lead` | 18/28 | 20/30 | 20/30 | 400 | Inter |
| Words | `body` | 16/24 | 16/24 | 16/24 | 400 | Inter |
| Words | `small` | 14/20 | 14/20 | 14/20 | 400 | Inter |
| Words | `nav` | 16/20 | 16/20 | 16/20 | 500 | Inter |
| Words | `badge` | 14/18 | 14/18 | 14/18 | 600 | Inter |
| Code and identifiers | `code` | 14/20 | 14/20 | 14/20 | 400 | Geist Mono |
| Code and identifiers | `identifier` | 16/24 | 16/24 | 16/24 | 400 | Geist Mono |
| Numerics | `numberSm` | 14/18 | 14/18 | 14/18 | 600 | Geist Mono |
| Numerics | `numberBase` | 16/20 | 16/20 | 16/20 | 600 | Geist Mono |
| Numerics | `numberMd` | 24/28 | 26/30 | 28/32 | 600 | Geist Mono |
| Numerics | `numberLg` | 32/36 | 36/40 | 40/44 | 600 | Geist Mono |
| Numerics | `numberXl` | 40/44 | 48/52 | 56/60 | 600 | Geist Mono |

The table has ten Words roles, two Code and identifiers roles, and five
Numerics roles. Tests and documentation must assert **17**.

The slash values are font size/line height in logical pixels. `body`, `small`,
`nav`, `badge`, `code`, `identifier`, `numberSm`, and `numberBase` remain stable
across viewport widths; headings and large metrics respond at the existing
`Breakpoints.md` (768) and `Breakpoints.lg` (1024) boundaries. Typography must
also respond correctly to Flutter text scaling; viewport breakpoints never
replace accessibility scaling.

## Non-negotiable migration rules

1. Remove the public roles `navSm`, `eyebrow`, `section`, `chip`, `caption`,
   `eyebrowSmall`, `tag`, `wordmark`, `accent`, and `numberXs`, plus any other
   current catalog role not present in the final table.
2. Do not keep retired public aliases “for compatibility.” This is a deliberate
   pre-release API correction. All repository call sites must migrate in the
   same change.
3. Do not confuse the removed **typographic** `TextStyles.accent` and
   `Fonts.accent` with semantic color tokens such as `theme.accent`,
   `accentForeground`, or agent accent colors. Those color APIs remain.
4. Remove the Redaction 35 font asset, family declaration, distribution
   manifest entry, and license copy only after a search proves the removed
   type role was its sole use. Keep any legally required attribution if the
   asset remains distributed for another verified reason.
5. Use the public design-system APIs and foundation tokens. Do not hardcode
   replacement `TextStyle`, font, color, spacing, radius, duration, or
   breakpoint literals in components or documentation.
6. Component-specific typography may derive from a core role internally when
   anatomy requires a weight/color variation, but it must not introduce a new
   public semantic role or an independent size below this scale. Prefer direct
   core roles where semantics fit.
7. At 200% text scale, text must wrap or layouts must grow. Do not “fix” an
   overflow by clipping, shrinking text, reducing the system text scale,
   hiding content, or adding `maxLines` without a content-valid reason.
8. Keep `/docs/typeset` and existing navigation routes stable. This work
   changes the content and source of truth, not the site's information
   architecture.
9. Typography roles do not own semantic color. Every public role inherits the
   surrounding foreground by default. Muted, destructive, success, link, and
   inverse ink come from the component/surface or an explicit semantic color
   at the call site. In particular, `lead` and `small` must not silently become
   `mutedForeground`, and the Typeset preview must not assign decorative or
   pastel colors to distinguish roles.

## Task 1 — Gate the release state before editing artifacts

**Inspect**

- `packages/elattar_cli/pubspec.yaml`
- `example/lib/docs_pages/release_facts.dart`
- `registry/generated/latest/`
- local and remote `main`/`v0.0.1` refs
- pub.dev's current `elattar_cli` package record

**Steps**

1. Record whether `elattar_cli 0.0.1` has already been published and whether
   `v0.0.1` is already a public release ref.
2. If `0.0.1` is published, this typography change is `0.0.2` work. Never
   overwrite the published package, move `v0.0.1`, or mutate a versioned
   `registry/.../0.0.1/` artifact in place. Prepare new version metadata only
   when the owner separately authorizes release preparation.
3. If `0.0.1` is still unpublished, the source change may remain a pre-release
   correction, but Cloud still must not publish, tag, push, or deploy.
4. Put the result in the final handoff. Do not spend further tokens repeatedly
   checking release state during implementation.

## Task 2 — Build one complete migration inventory

**Primary source files**

- `lib/src/design_system/foundation/typography.dart`
- `lib/src/design_system/foundation/theme_scope.dart`
- `lib/elattar_design_system.dart`
- `pubspec.yaml`
- `test/foundation_type_motion_test.dart`
- `test/text_layout_test.dart`
- `example/lib/docs_pages/typeset_page.dart`
- `example/lib/docs_pages/typeset_catalog.dart`
- `example/test/typeset_docs_test.dart`

**Steps**

1. In one batched `rg` pass across `lib/`, `example/lib/`, `test/`,
   `example/test/`, `packages/`, `skills/`, root Markdown, `pubspec.yaml`, and
   registry sources, find:

   - every `TextStyles.*` and `Fonts.*` reference;
   - `TextStyles.all`, catalog/group declarations, and hardcoded role counts;
   - each retired role name;
   - “Labels and furniture,” “Accent,” “Redaction,” “27 roles,” and prose that
     lists or describes the type system;
   - direct `TextStyle`/font-size declarations in UI and docs that may bypass
     the foundation;
   - generated registry copies, manifests, asset maps, and license records.

2. Produce a compact migration ledger with columns: old role, intended new
   role, call-site count, affected tests/docs, and any call site requiring
   human review. Do not edit generated registry output directly.
3. Use these default semantic mappings, then review exceptions in context:

   | Old meaning | New destination |
   |---|---|
   | display and page titles | `display`, `h1`, `h2`, `h3`, or `h4` by hierarchy |
   | paragraph/body copy | `body` |
   | secondary supporting copy | `small` |
   | navigation and sidebar labels | `nav` |
   | badges/tags/chips | `Badge`, which owns `badge` |
   | inline code/commands | `code` |
   | identifiers/paths/keys | `identifier` |
   | tiny numeric role | `numberSm` |
   | logo wordmark | private `Logo` anatomy; no public type role |
   | accent serif | remove; use the surrounding semantic heading role |

4. Commit nothing and run no full suite yet. The output of this task should be
   one source-of-truth list used by all later batches.

## Task 3 — Replace the foundation contract and write its focused tests

**Files**

- `lib/src/design_system/foundation/typography.dart`
- `lib/src/design_system/foundation/theme_scope.dart`
- public barrel only if its exports change
- `test/foundation_type_motion_test.dart`
- `test/text_layout_test.dart`
- `test/theme_scope_test.dart`
- `test/token_guard_test.dart`

**Steps**

1. Add or revise breakpoint-aware resolution so the final table is the sole
   size/line-height source. Reuse `Breakpoints.md` and `Breakpoints.lg`; do not
   define a second breakpoint system.
2. Make `TextStyles.all` contain the 17 final roles exactly once, in catalog
   order. Preserve a stable, documented resolution API that consumers can use
   without knowing viewport arithmetic.
3. Keep font features appropriate to the role: proportional Inter for words,
   Geist Mono for code/identifiers/numerics, and tabular figures for every
   numeric role. Do not apply uppercase transformations as a hidden style
   behavior.
4. Remove `defaultColor` from the public typography contract and migrate its
   uses. Delete `TextColorRole` if a repository-wide search proves nothing
   legitimate still requires it; otherwise keep it outside public type roles.
   A component such as Badge, Alert, Toaster, or a link selects semantic ink
   explicitly from `ThemeScope` instead of obtaining color from its font role.
5. Delete accent-size inheritance and all old CSS-lineage comments that no
   longer describe the Flutter system. Comments must explain the current API,
   not the former web implementation.
6. Rewrite foundation tests to assert the exact role names, order, face,
   weight, size, line height, breakpoint behavior, tabular numerics, and the
   absence of every retired role. Assert that all public roles inherit color.
7. Add boundary tests at widths 767/768 and 1023/1024, plus text-scale tests at
   1.0 and 2.0. Assert logical sizes and layout outcomes rather than screenshots
   alone.

**Focused gate — run once after this batch**

```powershell
flutter test test/foundation_type_motion_test.dart test/text_layout_test.dart test/theme_scope_test.dart test/token_guard_test.dart
```

Format the changed foundation/test files together before running the gate.

## Task 4 — Migrate all product components in coherent batches

**Required first batch**

- `lib/src/components/ui/accordion.dart`
- `lib/src/components/ui/alert.dart`
- `lib/src/components/ui/attachment.dart`
- `lib/src/components/ui/badge.dart`
- `lib/src/components/ui/button.dart`
- `lib/src/components/ui/sidebar.dart`
- their root and example tests/docs

**Known mappings to implement and verify**

1. `Accordion`: trigger hierarchy uses `h4`; content uses `body` or `small`
   according to whether it is primary or supporting copy. Increase anatomy as
   needed instead of squeezing 20px text into a 13px-era row.
2. `Alert`: title uses `h4`; description uses `body`, with `small` allowed only
   for genuinely secondary metadata. Validate compact and multiline alerts.
3. `Attachment`: normal title uses `body`; compact title and description use
   `small`. Grow compact geometry to fit 14px text at 200% scaling.
4. `Badge`: its label uses the new `badge` role at 14/18 and retains semantic
   padding/tap behavior. Do not add a separate chip/tag type role.
5. `Button`: remove the public `buttonLabel*` family. `xs` and `sm` labels
   derive from `small` at 14/20; `md`, `lg`, and `xl` labels derive from `body`
   at 16/24. The component may apply its existing medium weight internally,
   but it must not create a new public typography role. `caps` keeps its
   visual transform and accessible authored label, derives size/leading from
   the current rung, and never shrinks to 12px. Icon-only rungs own no text
   role. Reconcile visual bounds and effective hit testing so every interactive
   target remains at least 44×44 even when the named visual size is compact.
6. `Sidebar`: remove `navSm`, use `nav`, and ensure interactive rows meet the
   repository accessibility target (44 logical pixels minimum where the row is
   an interactive target).
7. `AspectRatio`: do not add typography. It is a geometry container with no
   owned text; its child owns any type role.

**Repository-wide continuation**

8. Migrate every other component, block, logo, shell, home card, example, and
   test found in Task 2. Do not stop after the five named components.
9. Review resulting density deliberately. A semantic mapping is not complete
   if it creates overflow, broken intrinsic height, clipped baseline, or a tap
   target regression.
10. If broad mechanical replacement is substantial, use one deterministic
   migration tool under `tool/migration/` with dry-run, apply, and idempotence
   modes. Otherwise use grouped patches. Do not perform repeated one-file
   search/replace passes.
11. Add a guard that fails if any retired `TextStyles` member is reintroduced
    in authored source. Exclude generated files from the authored-source scan;
    generated output is validated separately after regeneration.

**Focused gate — run once after product migration**

Run the existing component tests matching the changed call sites. At minimum:

```powershell
flutter test test/sidebar_test.dart test/components_test.dart
Push-Location example
flutter test test/components_docs/accordion_test.dart test/components_docs/alert_test.dart test/components_docs/aspect_ratio_test.dart test/components_docs/attachment_test.dart test/components_docs/badge_test.dart test/components_docs/button_test.dart
Pop-Location
```

If a smaller root test file directly owns a changed component, add it to this
single focused invocation. For perpetual spinners/skeletons, pump a fixed frame
duration; do not use `pumpAndSettle`.

## Task 5 — Remove the unused accent font safely

**Files likely affected**

- `pubspec.yaml`
- `README.md`, `CHANGELOG.md`, `CONTRIBUTING.md`
- font/asset and distribution tests
- source-foundation registry item inputs and license manifests
- any test font-loader helpers

**Steps**

1. Re-run a narrowly scoped search for `Redaction35`, the font asset filename,
   `Fonts.accent`, and `TextStyles.accent` after the call-site migration.
2. If there are no legitimate remaining uses, remove the font registration and
   packaged asset, update the face count from three to two, and remove its
   distribution/license entries from authored manifests. Do not delete a
   license while the corresponding asset is still shipped anywhere.
3. Preserve every semantic color occurrence of “accent.” Review matches by
   qualified symbol/path, not by blind word replacement.
4. Update asset and license tests to assert the final distributed files.

**Focused gate**

```powershell
flutter test test/assets_test.dart test/license_distribution_test.dart
```

## Task 6 — Rebuild the Typeset documentation from the real roles

**Files**

- `example/lib/docs_pages/typeset_page.dart`
- `example/lib/docs_pages/typeset_catalog.dart`
- any shared typography preview primitive already used by the page
- `example/test/typeset_docs_test.dart`

**Steps**

1. Keep the continuous preview before the per-role reference. It must render
   all 17 actual `TypesetRole.spec` objects, once each, in this order:
   Words, Code and identifiers, Numerics.
2. Remove the Labels and furniture and Accent groups completely. Do not retain
   empty headings, compatibility notes, or prose advertising deleted roles.
3. Show each role's name, responsive size/line-height values, weight, face, and
   one realistic specimen. Keep explanations short and task-oriented.
   Render every specimen with the same inherited foreground; do not use color
   to manufacture hierarchy between type roles.
4. Explain the color rule once: typography defines shape and rhythm, while the
   component or semantic surface defines ink. If the page demonstrates muted
   text, show it as a separate contextual usage example, not as the default
   appearance of `lead` or `small`.
5. Explain the responsive rule once: headings and large numerics adapt at
   768/1024; reading and UI text stay stable; Flutter text scaling remains
   authoritative.
6. The page must derive its count and specimens from the same catalog/source as
   the runtime contract. Do not hardcode a parallel “17 roles” list in page
   widgets.
7. Reuse `DocsSection`, `DocsShowcaseFrame`, `StyledText`, `TextStyles`, and
   foundation spacing/color tokens. Do not recreate cards, type controls, or
   tables with visual literals.
8. Rewrite `typeset_docs_test.dart` to check exact one-to-one catalog coverage,
   exact group order, no retired roles, breakpoint specimens, narrow wrapping,
   one inherited foreground across the preview, dark/light rendering, and 200%
   text scale through the final numeric role.

**Focused gate**

```powershell
Push-Location example
flutter test test/typeset_docs_test.dart
Pop-Location
```

## Task 7 — Update every documentation owner and cross-reference

**Mandatory search surface**

- all `example/lib/docs_pages/`
- all `example/lib/components_docs/`
- `example/lib/site/`, `example/lib/pages/`, and docs search/catalog metadata
- `README.md`, `CHANGELOG.md`, `CONTRIBUTING.md`
- `packages/elattar_cli/README.md` and package changelogs if they mention
  foundation contents
- `SKILL.md`, `skills/`, plugin metadata, and referenced system maps
- registry item descriptions and source-foundation manifests
- tests that enforce public claims

**Steps**

1. Update every file discovered in Task 2 that lists all roles, states the
   number of roles/faces, shows a typography example, or recommends a retired
   token. “Another documentation file” is in scope even if it is not linked
   from `/docs/typeset`.
2. Keep copy concise: what role to use, where to use it, and the one important
   constraint. Do not repeat implementation history or the research essay in
   public docs.
3. Add a short migration note to the appropriate changelog: the old granular
   labels were consolidated into the 17-role responsive scale, tiny labels
   were raised, and the accent face was removed. If the release gate says
   `0.0.1` is already published, record this under the next unreleased version,
   never retroactively under published `0.0.1`.
4. Update the UI director/system-map instructions if they name retired tokens
   or the old font set. Preserve unrelated skill behavior.
5. Add or update public-claims tests so docs cannot state the old count, old
   groups, retired role names, Redaction face, or an incorrect release version.

**Focused gate**

```powershell
Push-Location example
flutter test test/typeset_docs_test.dart test/public_claims_test.dart test/docs_sidebar_test.dart
Pop-Location
```

Add other focused docs tests to the same invocation only when their page was
actually changed.

## Task 8 — Regenerate registry output once

1. After authored package and docs sources are stable, use the repository's
   existing registry builder. Never patch `registry/generated/` by hand.
2. Respect Task 1's release result. Published version directories are
   immutable; generate the next version when required.
3. Validate that generated foundation sources contain the 17-role system, no
   removed type tokens, and the correct two-font manifest if Redaction was
   removed.
4. Check every generated source link and dependency edge using the existing
   validator/audit tools.

**Focused gate**

```powershell
flutter test test/registry_builder_test.dart test/registry_client_test.dart
```

Use the repository's documented registry validation command after these tests.

## Task 9 — Targeted visual and accessibility review

Render the Typeset page plus every changed component specimen at:

- 390×844, 834×1112, and 1440×900;
- light and dark themes;
- text scale 1.0 and 2.0.

Check, and capture evidence for:

1. complete role order and clear hierarchy;
2. no horizontal clipping, ellipsis of required content, baseline collision,
   or fixed-height overflow;
3. readable code and numerics;
4. Accordion, Alert, Attachment, Badge, Button, Sidebar, and any other migrated
   component at multiline and longest-realistic content;
5. 44×44 interactive targets where applicable;
6. keyboard focus, semantics, contrast, and reduced motion behavior remain
   intact.

Prefer existing screenshot/render harnesses. Do not build a second visual test
framework for this migration.

## Task 10 — Run the expensive verification ladder once

Only after Tasks 3–9 and their focused tests are green, format all changed Dart
files in one batch, then run:

```powershell
flutter analyze
flutter test
Push-Location example
flutter analyze
flutter test
flutter build web --release
Pop-Location
git diff --check
```

Then run the existing registry validation, release audit, and completeness/UI
scanner once. Classify failures as introduced or pre-existing with file/line
evidence. Fix introduced failures; do not silently broaden scope to unrelated
pre-existing issues.

Finally run one negative search over authored sources for every retired role,
`Labels and furniture`, the typographic accent face, old role counts, and
Redaction. Legitimate `theme.accent` color references must remain and must be
reported separately from typography matches.

## Required final handoff from Cloud

Report:

1. files changed, grouped by foundation, components, docs, registry/release,
   and tests;
2. exact final 17-role table and breakpoint behavior;
3. old-to-new migration counts and confirmation that no authored call sites
   retain retired roles;
4. component results for Accordion, Alert, AspectRatio, Attachment, Badge,
   Button, and Sidebar;
5. focused test results, full verification results, build result, registry
   validation, and visual matrix;
6. font/license outcome;
7. release-state finding and any owner-only actions.

Do not publish, tag, push, deploy, or commit unless the owner separately asks
for that exact action after reviewing the completed diff and evidence.
