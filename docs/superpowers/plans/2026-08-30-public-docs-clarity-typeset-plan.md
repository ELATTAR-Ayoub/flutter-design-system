# Public Documentation Clarity and Typeset Preview Plan

> **For Cloud:** use `superpowers:executing-plans` when that skill is available.
> Work from the Flutter package, CLI source, generated registry, and release
> metadata as the source of truth. Do not reconstruct visual components with
> raw Flutter widgets or literals: compose the existing public design-system
> APIs and the existing `example/lib/docs/` documentation primitives.

**Goal:** Make the public documentation section concise, accurate, and easy to
use for a Flutter developer preparing an Elattar project. Preserve the existing
routes and documentation shell, add a full rendered typeset scale before the
role reference, and make release/API claims unable to drift from the shipped
product.

**Baseline:** repository mode. The documentation routes are `/docs/introduction`,
`/docs/installation`, `/docs/theming`, `/docs/cli`, `/docs/typeset`,
`/docs/registry`, `/docs/changelog`, and `/skills`. The public API is
unprefixed (`Button`, `Card`, `Icon`, `TextStyles`, `space`). `El*` is retired.

## Product and writing contract

1. Write for the developer's immediate task. Each page begins with one
   sentence explaining its job, followed by the next useful decision, command,
   or visual example.
2. Use short, task-named sections. Keep explanations to the minimum needed to
   make the command or choice safe. Move implementation detail behind an
   existing `DocsDisclosure`, into a component page, or into a linked source
   document when the detail is not needed for the primary task.
3. Follow the *documentation behavior* of shadcn/ui—not its branding, copy,
   React examples, CSS, or layouts. In particular: concise introduction,
   decision-first installation, semantic token explanations, command-first CLI
   reference, and visual typeset specimens.
4. State Elattar-specific behavior plainly wherever it differs: Flutter-only
   source ownership, `elattar init --foundation source`, hash-verified
   version-pinned registry, consumer-owned installed files, and the supported
   skill routes.
5. Do not add shadcn features that Elattar does not ship. A visual preset
   builder, registry namespaces/authentication/MCP, and a `view`/`diff` CLI are
   future product work, not claims documentation may make.
6. Preserve every current route, search entry, sidebar placement, breadcrumb,
   table-of-contents anchor, and previous/next relation unless an explicit
   follow-up task changes information architecture.

## UI implementation contract

1. Before editing, read `AGENTS.md` and use
   `skills/elattar-flutter-ui-director/SKILL.md` in repository mode.
2. Inventory the public barrel and existing docs building blocks first:
   `DocsLayout`, `DocsSection`, `DocsSnippet`, `DocsSelectableCodeBlock`,
   `DocsApiTable`, `DocsInstallFacts`, `DocsShowcaseFrame`, `DocsDisclosure`,
   `DocsLink`, `StyledText`, `TextStyles`, `Card`, `Panel`, `Separator`, and
   `space`.
3. Reuse those primitives. Do not implement lookalike buttons, cards, code
   blocks, tables, sidebars, or typography controls in a page with raw
   `Container`, `Text`, colors, dimensions, borders, radii, shadows, or
   `Duration` values.
4. A new page-local composition is allowed only for the full typeset preview;
   it must render the actual `TypesetRole.spec` values through `StyledText`,
   use `DocsSection`/`DocsShowcaseFrame` for framing, and use foundation tokens
   for all layout and color. Promote it to `example/lib/docs/` only if a second
   page genuinely needs the same contract.
5. Keep documentation product composition in `example/lib/`, never in
   `lib/src/components/ui/`. Do not add a public design-system component merely
   to decorate one documentation page.

## Task 1 — Establish the current facts and guard them

**Files to inspect**

- `lib/elattar_design_system.dart`
- `packages/elattar_cli/pubspec.yaml` and `lib/`
- `registry/generated/latest/registry.json`
- `skills/elattar-flutter-ui-director/SKILL.md`
- `.claude-plugin/plugin.json`
- `README.md`, `CHANGELOG.md`, and `packages/elattar_cli/CHANGELOG.md`
- `example/lib/docs_pages/`, `example/lib/skills_docs/`, and `example/lib/site/`

**Implementation**

1. Create a compact current-documentation fact table while auditing. For every
   user-visible claim, record its owning source and the page(s) that repeat it.
   At minimum cover CLI/package version, installation command, foundation mode,
   public API spelling, registry item count/version/schema, release tag, and
   verified skill installation routes.
2. Treat package source and checked command help as authoritative for CLI
   behavior; treat the registry JSON as authoritative for catalog facts; treat
   `SKILL.md` and the plugin manifest as authoritative for skill files and
   routes. Do not copy a fact from another prose document without checking its
   owner.
3. Resolve pre-publish versus published language before changing any public
   copy. If the CLI is published during this work, verify the exact pub.dev
   package/version and then use post-publish language. If it is not, retain one
   clear availability note and never present the command as immediately
   installable.
4. Remove all current-page claims that the public API is `El*`, that the tag is
   absent, or that an already-published CLI is unavailable. Historical release
   records may describe the past, but must be visually separated from current
   instructions.
5. Add a focused current-doc truth test/guard. It must fail for retired public
   API spelling, an invalid installation command, a nonexistent source path,
   or a release statement that conflicts with the selected release state.

## Task 2 — Simplify the shared documentation experience without redesigning it

**Files**

- `example/lib/docs/docs_layout.dart`
- `example/lib/docs/docs_section.dart`
- `example/lib/docs/docs_showcase.dart`
- `example/lib/docs/docs_disclosure.dart`
- existing focused docs-layout and route tests

**Implementation**

1. Audit the shared shell before page edits. Keep the proven sidebar, TOC,
   copyable code, breadcrumbs, and pager behavior.
2. Make the default reading measure, heading rhythm, code treatment, tables,
   disclosure treatment, and narrow layout consistently support short
   decision-first docs. Reuse existing components; change shared behavior only
   where the same issue appears on multiple pages.
3. Ensure TOC anchors have a matching visible section, previous/next controls
   remain keyboard reachable, code copy communicates success, and long commands
   wrap or scroll without clipping at narrow width or 200% text scale.
4. Do not make an async shell depend on every page's content data. Changelog
   loading/failure stays localized to its content region.

## Task 3 — Rewrite Introduction and Installation around the first success

**Files**

- `example/lib/docs_pages/introduction_page.dart`
- `example/lib/docs_pages/installation_page.dart`
- `example/lib/docs_pages/catalog.dart`
- `README.md` where it is public onboarding copy
- focused page tests

**Introduction acceptance**

1. Lead with the source-you-own model and who it is for in one short paragraph.
2. Show the shortest real path: install CLI, initialize source foundation, add
   a component. Each command must be copyable and valid for the selected
   release state.
3. Keep ownership, composition, distribution, and skills as short follow-up
   sections or links. Remove repeated implementation mechanics and retired
   API terms.

**Installation acceptance**

1. Make the published CLI path the recommended path only after publication is
   verified. Otherwise clearly label it as the upcoming path and lead with the
   working contributor/local route.
2. Show only the source-foundation flow that works today. Keep the refused
   package-foundation path as a short constraint with the reason and a next
   step; it must never resemble an alternative setup path.
3. Include exactly what arrives in the app, the one verification step
   (`elattar doctor` when installed), and one concise recovery path for network,
   cache, or overwrite conflicts.
4. Remove duplicate commands and deep registry implementation explanations;
   link to CLI or Registry when that is the user’s next task.

## Task 4 — Make Theming a practical semantic-token guide

**Files**

- `example/lib/docs_pages/theming_page.dart`
- `example/lib/docs_pages/typeset_page.dart` only for cross-links
- foundation sources/tests used to derive token facts
- focused theming page tests

**Implementation**

1. Open with the rule: choose semantic tokens and `ThemeScope`; do not style
   individual widgets or use `Theme.of` as a parallel system.
2. Present a compact, derived token-role table grouped by surface, action,
   status, navigation, and data. Do not hand-copy values that the foundation
   already owns.
3. Give one small source-mode override example and one clear note explaining
   the consumer-installed source difference. Preserve only the package-mode
   content that is genuinely supported.
4. Keep dark mode, contrast, and reduced motion as a concise verification
   checklist. Link typesetting rather than repeating its scale.

## Task 5 — Make CLI and Registry reference task-first

**Files**

- `example/lib/docs_pages/cli_page.dart`
- `example/lib/docs_pages/registry_page.dart`
- `packages/elattar_cli/README.md`
- `packages/elattar_cli/CHANGELOG.md`
- CLI tests and registry-generated artifacts as sources of truth

**CLI implementation**

1. Start with a short invocation and the two commands most readers need:
   `init` and `add`.
2. Give each actual command (`init`, `add`, `list`, `search`, `info`, `doctor`)
   one sentence, one useful example, and only behavior-changing flags. Derive
   names/options from command help or a small shared metadata source; do not
   maintain an independent hand-written command surface in the website.
3. Move exit codes, offline/CI use, output format, and conflict recovery into
   compact secondary sections. Preserve their detail only where it helps a
   developer diagnose an action.
4. Do not document commands Elattar does not implement (`view`, `diff`,
   presets, or framework scaffolding). Record pre-install source preview as a
   separately prioritized product-gap recommendation, not a doc defect.

**Registry implementation**

1. Lead with outcomes: what is installed, where it lands, ownership, and the
   hash verification promise.
2. Retain live derived figures (items, files, dependency edges, notices) and
   their local loading/empty/failure states; do not convert them to stale prose.
3. Put manifest schema, dependency mechanics, hosting/version pinning, and
   cache behavior after the primary installation outcome. Use one short
   example rather than repeating CLI workflows.
4. State clearly that custom remote registry capabilities such as auth,
   namespaces, dynamic search, and MCP are not currently Elattar features.

## Task 6 — Add the full Typeset preview before individual roles

**Files**

- `example/lib/docs_pages/typeset_page.dart`
- `example/lib/docs_pages/typeset_catalog.dart`
- `example/test/typeset_docs_test.dart`
- any focused render/accessibility tests needed

**Implementation**

1. Add the TOC anchor **Full type scale** immediately after the page
   introduction and before **Choosing a role**.
2. Render every entry of `typesetRoles`, once and in catalog reading order,
   using its real `TypesetRole.spec`, sample, font behavior, and fluid-size
   rule. No size, weight, family, tracking, or color may be copied into a
   preview-specific list.
3. Make the overview primarily visual: one continuous, readable vertical scale
   with restrained group dividers. It is a comparison surface, not 27 repeated
   miniature API cards. A concise name/usage cue is acceptable if it improves
   scanning; the detailed role blocks remain the reference below.
4. Preserve the existing per-group role reference, including real metadata and
   pasteable calls. Do not remove it merely because the overview exists.
5. Add tests that the preview covers exactly `TextStyles.all` through the
   catalog, appears before role sections, handles fluid roles, and has no
   overflow at narrow/wide layouts and 200% text scale in either theme.

## Task 7 — Keep Changelog and Skills true, concise, and recoverable

**Files**

- `CHANGELOG.md`
- `example/lib/docs_pages/changelog_page.dart`
- `skills/elattar-flutter-ui-director/SKILL.md`
- `.claude-plugin/plugin.json`
- `example/lib/skills_docs/catalog.dart`
- `example/lib/skills_docs/skills_page.dart`
- focused changelog/skills tests

**Changelog**

1. Keep `CHANGELOG.md` the single release-note source. Shorten the current
   release entry to user-visible changes and facts; move release-process
   narration to contributor/release documentation.
2. Preserve the page’s loading, empty, malformed-document, failure, retry, and
   accessible-announcement behavior. Errors must not expose parser exceptions
   or raw file paths to public readers.

**Skills**

1. Lead with the skill’s job and its verified supported-agent route.
2. Present install/update/inspect/remove only for routes that are actually
   verified and public. Keep pending routes visibly pending, concise, and
   non-actionable.
3. Derive name, version, source paths, and supported-agent claims from the
   skill/plugin source. Remove retired `El*` wording from the catalog and
   rendered page.
4. Keep the full file tree available as a secondary inspection surface rather
   than forcing it ahead of the installation decision.

## Task 8 — Audit and remove documentation duplication

**Roots**

- `README.md`
- `CHANGELOG.md`
- `packages/elattar_cli/README.md`
- `packages/elattar_cli/CHANGELOG.md`
- `example/lib/docs_pages/`
- `example/lib/skills_docs/`
- `example/lib/site/`

**Method**

1. Search current user-facing copy for retired APIs, release-state claims,
   obsolete package/foundation routes, and duplicated CLI options.
2. Correct a fact at its owner, then update consumer pages from that owner or
   reduce the duplicate to a link. Do not blindly replace historical plans or
   reports.
3. Add focused guard assertions for zero current-doc retired references and for
   the expected docs-page/search/sidebar route set.
4. Leave historical reports/plans intact unless a reader is sent to them from a
   current page as active instruction.

## Task 9 — Verification and visual acceptance

Run focused checks while editing, then the full repository-mode ladder once.

```powershell
dart format <changed-dart-files>
flutter test test/skill_package_test.dart
Push-Location example
flutter test test/typeset_docs_test.dart
flutter test test/docs_pages_routing_test.dart
flutter test test/public_pages_test.dart
flutter test test/skills_docs_test.dart
Pop-Location

flutter analyze
flutter test
Push-Location example
flutter analyze
flutter test
flutter build web --release
Pop-Location
dart run tool/release_audit/bin/verify.dart .
git diff --check
```

Also run the UI completeness scanner against changed product/docs surfaces with
appropriate documented exclusions for intentionally inert demonstrations:

```powershell
dart run skills/elattar-flutter-ui-director/scripts/check_ui_completeness.dart
```

Manually inspect all nine documentation routes in light and dark themes, at
narrow and wide widths, plus Typeset at 200% text scale. Verify readable prose
measure, no clipped headings/commands/tables, visible focus, keyboard-reachable
sidebar/TOC/pager/copy controls, useful empty and error states, and the full
typeset preview’s ordering and actual font rendering.

## Definition of done

- Every public documentation claim is current, sourced, and consistent with
  the shipped CLI, package, registry, skill, and release state.
- Introduction, Installation, Theming, CLI, Typeset, Registry, Changelog, and
  Skills are concise, task-first, readable, and route-stable.
- Typeset shows all catalog roles once in a continuous visual preview before
  the detailed role reference.
- Documentation UI composes existing system and docs primitives; no hardcoded
  lookalike components or visual literals are introduced.
- No user-facing current docs contain retired `El*` API wording.
- Focused and full verification pass, and visual inspection is recorded.
- The plan does not authorize publication, tagging, pushing, or deployment;
  those remain explicit owner actions after verification.
