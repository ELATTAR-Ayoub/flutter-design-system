# Elattar public website — UI and information architecture plan

**Status:** Proposed implementation specification
**Date:** 2026-08-21
**Reference role:** shadcn/ui supplies information-architecture and code-distribution patterns, not branding or a layout to copy
**Implementation authority:** this Flutter package, its public `El*` APIs, foundations, tests, and specimens

## 1. Decision summary

Build the public website inside the existing `flutter-design-system` repository and publish that repository publicly. Do not create a separate website repository for the first release.

The repository already contains the authoritative Flutter package, documentation application, specimens, tests, verification rig, assets, and future registry/CLI plan. Keeping the website beside those sources allows component code, registry metadata, documentation, screenshots, and releases to change atomically.

The public website has five primary destinations:

1. **Home** — product promise and live proof.
2. **Docs** — installation, concepts, theming, Flutter/Dart, CLI, skills, registry, and complete reference material.
3. **Components** — searchable live component catalog and one detailed page per installable component.
4. **Shots** — complete composed screens and flows, each previewable, inspectable, copyable, and installable.
5. **Skills** — a focused public page for the installable Elattar Flutter UI skill, its behaviors, supported agents, examples, and source.

`Create` is deliberately deferred. Do not place a disabled or “coming soon” Create item in primary navigation at launch.

## 2. Product position

### 2.1 One-sentence concept

**A living Flutter reference manual where every design decision is visible, every component is executable, and every useful artifact can be installed or owned as source.**

### 2.2 Audience

- Flutter developers evaluating the system.
- Product teams installing components into an existing application.
- Designers inspecting foundations, states, and responsive behavior.
- AI-assisted development users installing the repository skill.
- Contributors verifying APIs, specimens, tests, and registry contracts.

### 2.3 Primary action

The primary action throughout the site is context-dependent but singular:

- Home: **Get started**.
- Docs: **Follow the current setup step**.
- Component page: **Install component**.
- Shot page: **Install shot**.
- Skills page: **Install skill**.

GitHub is always visible as a secondary action.

### 2.4 Reference principles extracted from shadcn

Use these principles:

1. A compact global shell leaves most space to live material.
2. Documentation navigation is complete and persistent, not hidden behind marketing cards.
3. A component page moves from definition to proof to installation to usage to variants.
4. Preview and source are adjacent and easy to switch.
5. Installation commands are copyable at the moment they become relevant.
6. The public repository explains the product in a few sentences and sends users to the documentation.

Do not copy:

- shadcn branding, logo, prose, exact layout, or demo content.
- React, Radix, Tailwind, TypeScript, JavaScript, framework-switching, or package-manager UI that has no Flutter equivalent.
- Vercel, v0, sponsorship, framework advertisements, or unrelated directory pages.
- A Create page before Elattar has a real visual preset generator.

### 2.5 Elattar additions beyond the reference

Elattar should document capabilities that the reference does not provide in the same form:

- Source-foundation and package-foundation installation modes.
- The exact local destination `lib/components/ui/`.
- Semantic token ownership and the no-literal guard.
- Light/dark evidence on every relevant specimen.
- Reduced-motion behavior.
- Explicit state and accessibility matrices.
- Flutter platform behavior across mobile, tablet, desktop, and web.
- Asset, font, and shader requirements.
- Agent console, transcript, composer, avatar, and voice families.
- The public Elattar Flutter UI skill.
- Verification status tied to tests and registry versions.

## 3. Site map and routes

```text
/
├── /docs
│   ├── /docs/introduction
│   ├── /docs/installation
│   ├── /docs/configuration
│   ├── /docs/theming
│   ├── /docs/dark-mode
│   ├── /docs/flutter-and-dart
│   ├── /docs/cli
│   ├── /docs/skills
│   ├── /docs/registry
│   ├── /docs/monorepo
│   ├── /docs/accessibility
│   ├── /docs/motion
│   ├── /docs/changelog
│   └── /docs/contributing
├── /components
│   ├── /components/foundations
│   ├── /components/base
│   ├── /components/agent
│   ├── /components/site
│   └── /components/<component-slug>
├── /shots
│   ├── /shots/<shot-slug>
│   └── /shots/<shot-slug>/preview
├── /skills
└── /search
```

### 3.1 Naming ruling: Dart, not TypeScript

The documentation navigation uses **Flutter & Dart**, not TypeScript. A TypeScript page would teach an ecosystem this product does not use. The page should cover Dart language conventions, Flutter imports, widget composition, null safety, callbacks, controllers, async feedback, and source/package foundation imports.

### 3.2 Naming ruling: Shots

Use **Shots** as the Elattar name for composed, installable screens and flows. It performs the role shadcn calls Blocks but has an Elattar-specific identity.

A shot is not a primitive. It is a product-neutral composition made from public components, foundation tokens, and optional mock data. Examples include:

- Dashboard shell.
- Settings profile.
- Authentication flow.
- Data table workspace.
- Chat workspace.
- Agent console.
- Mobile navigation shell.
- Empty-to-success onboarding flow.

## 4. Global shell

### 4.1 Desktop header

The fixed/sticky header contains, left to right:

1. Elattar mark and wordmark linked to Home.
2. Primary navigation: Docs, Components, Shots, Skills.
3. Flexible space.
4. Search trigger with `/` shortcut hint.
5. Version selector or version label.
6. Theme selector.
7. GitHub action with repository label or star count when reliably available.

Header behavior:

- Uses the system SiteHeader/chrome contract when available.
- Remains visually quiet: neutral surface, hairline separation, no large shadow.
- Gains a subtle glass/surface treatment only after content scrolls beneath it.
- Supports visible focus, keyboard traversal, and a skip-to-content link.
- Theme selector offers Light, Dark, and System rather than a destructive binary toggle.
- GitHub opens the public repository in a new browser context and has an accessible label.

### 4.2 Mobile header

The mobile header contains:

- Menu trigger.
- Elattar wordmark.
- Search trigger.
- Theme selector.

GitHub moves into the navigation sheet so the header remains calm. The menu opens a full-height `Sheet` with Docs, Components, Shots, Skills, version, and GitHub. It preserves safe areas and logical focus return.

### 4.3 Search and command palette

Search is global and searches:

- Documentation titles and headings.
- Component names, aliases, descriptions, and APIs.
- Shot names and tags.
- CLI commands.
- Skill topics.

Results are grouped and keyboard navigable. Empty search explains supported queries. Registry/search failure provides Retry and Browse GitHub actions. Recent searches are local-only and optional.

### 4.4 Footer

The footer contains:

- Short open-source statement.
- Docs, components, shots, skills, changelog, contributing, security, and license.
- GitHub and pub.dev links.
- Current site/package version.
- Attribution and asset-license link.

Avoid a promotional mega-footer. The documentation itself is the product.

## 5. Visual direction

### 5.1 Dominant idea

The live component or composed screen is the brightest and largest object. Navigation and prose act as calibrated instruments around it.

### 5.2 Hierarchy

The first three reading steps are:

1. Page title or live specimen.
2. One-sentence purpose and primary install action.
3. Detailed explanation, API, states, or adjacent source.

### 5.3 Color and material

- Neutral background and surfaces organize documentation.
- Action color marks links, active navigation, focus, and primary commands.
- Value color is reserved for valuable outcomes and brand moments, not generic navigation.
- Status colors appear only for status.
- `PageGlow` may provide the site-wide light source.
- Use at most one supporting material effect per page region; do not combine glow, starfield, glass, bloom, foil, and machine surfaces as decoration.
- Component specimens show their own intended material without the docs frame competing.

### 5.4 Typography

- `Text` and `Type` own all interface and article typography.
- Display type appears on the Home hero only.
- Documentation page titles use the page-title role, not display type.
- Code and commands use the system mono role.
- Body copy uses a comfortable article measure.
- Numeric version and metric content uses tabular numeric roles.

### 5.5 Motion

- Home may use one restrained reveal sequence.
- Preview/code switching preserves the specimen frame and swaps content without reflow shock.
- Copy success is immediate and short.
- Sidebar/TOC scroll tracking must not produce constant decorative motion.
- All motion resolves through `Durations`, `Curves`, and existing motion widgets.
- Reduced motion produces an equally legible static result.

## 6. Home page

### 6.1 Purpose

Explain the product in one screen, prove its quality immediately, and direct users to installation or exploration.

### 6.2 Desktop structure

```text
Global header

Hero copy                         Install panel
Title                             $ dart install elattar_cli
Short promise                     $ elattar init
Get started / View components     Copy command

Large living showcase surface spanning the content width

Four principles
Open source / Source owned / Flutter native / AI ready

Foundation strip
Color / Type / Spacing / Motion / Theme

Component families
Base / Agent / Site

Featured shots

Skills feature

Repository and contribution CTA

Footer
```

### 6.3 Hero content

Recommended message structure:

- Eyebrow: `Open source · Open code · Flutter native`
- H1: a short original promise such as `The design system your Flutter app can own.`
- Supporting copy: foundations and selected components install directly into the project, remain coherent, and can be changed safely.
- Primary: **Get started**.
- Secondary: **Browse components**.
- Tertiary inline link: **View on GitHub**.

The copy must not reuse shadcn's signature wording.

### 6.4 Living showcase

The hero showcase is not a random component grid. It is a composed, believable application fragment that demonstrates:

- Sidebar/navigation.
- Data display.
- Forms and feedback.
- One overlay interaction.
- Theme switching.
- Responsive behavior.
- A small agent interaction only if it does not steal the entire narrative.

It should be interactive enough to prove the components but deterministic enough for visual verification. Provide a Reset action. Never rely on a network service.

### 6.5 Home sections

#### How it works

Three steps:

1. Initialize the foundation.
2. Add only the components needed.
3. Edit the source and ship.

Each step shows a command or file destination, not abstract marketing illustration.

#### Foundation proof

A horizontal/stacked specimen showing semantic color, type roles, spacing, surfaces, and motion. Each tile links to its foundation documentation.

#### Component families

Cards for Base, Agent, and Site. Each card states what belongs in the family and links to a filtered catalog.

#### Featured shots

Three strong shots with real screenshots, platform tags, Preview, Code, and Install actions.

#### Skill feature

Demonstrate one natural prompt and the skill's resulting plan or component choice. Link to the dedicated Skills page.

#### Open-source close

Show repository, license, current release, contribution link, and concise command. Do not fabricate stars, download counts, or adopter logos.

### 6.6 Home responsive behavior

- Wide: copy and install panel share the hero row; showcase spans wide.
- Tablet: copy and command panel stack before the showcase.
- Mobile: one primary action, one secondary link, horizontally scrollable foundation strip only if every item remains keyboard reachable; otherwise stack.
- The living showcase becomes a deliberate phone composition, not a scaled desktop canvas.

## 7. Documentation experience

Documentation is the most important surface and receives the densest information architecture.

### 7.1 Desktop documentation shell

```text
Global header
┌────────────────┬─────────────────────────────┬────────────────┐
│ Docs sidebar   │ Article                     │ On this page   │
│ Search/filter  │ Title + description         │ Anchors        │
│ Sections       │ Content                     │ Edit on GitHub │
│ Components     │ Examples / code / tables    │                │
└────────────────┴─────────────────────────────┴────────────────┘
```

- Left sidebar is persistent and independently scrollable.
- Article has a readable maximum measure.
- Right rail appears only when the page has enough headings to justify it.
- Active heading updates accessibly and does not move focus.
- Previous/Next closes every article.

### 7.2 Mobile documentation shell

- Sidebar becomes a navigation sheet.
- “On this page” becomes a compact disclosure beneath the page introduction.
- Article uses the full safe content width.
- Wide tables and code blocks scroll internally with visible affordance.
- A sticky bottom command bar is avoided; it would consume too much reading space.

### 7.3 Documentation sidebar groups

```text
Overview
  Introduction
  Components

Get started
  Installation
  Configuration
  Theming
  Dark mode
  Flutter & Dart
  CLI
  Monorepo
  Skills
  Accessibility
  Motion

Registry
  Introduction
  Registry index
  Registry item
  Dependencies
  Versioning
  Third-party registries

Components
  Foundations
  Base components
  Agent
  Site

Project
  Changelog
  Contributing
  Security
  License & attribution
```

Only routes that exist are registered. Navigation metadata, route mapping, search indexing, and page headers must share one source of truth.

### 7.4 Introduction page

Explain:

- What Elattar is.
- Source-first ownership.
- Composition through public `El*` APIs.
- Registry and CLI distribution.
- Beautiful, coherent defaults.
- Flutter platform support.
- AI-ready skill and open code.
- Package versus CLI ownership.

Use original Elattar language. Include a small comparison table for package, source-foundation, and package-foundation modes.

### 7.5 Installation page

Lead with the recommended existing-project path:

```console
dart install elattar_cli
elattar init
```

Then provide three tabs:

1. Source foundations — recommended/default.
2. Package foundations — compact.
3. Full maintained package.

Each path includes prerequisites, commands, generated files, app integration, verification, and troubleshooting. Manual installation is documented but not promoted above the CLI.

### 7.6 Configuration page

Document `elattar.yaml` field by field with:

- Source/package examples.
- Defaults.
- Valid values.
- Whether changing a field requires migration.
- Path resolution.
- Registry override.
- Non-interactive behavior.

### 7.7 Theming page

Explain semantic roles rather than presenting a palette editor that does not exist. Cover:

- Primitive versus semantic colors.
- Surface/foreground pairs.
- Action versus value.
- Status and `-ink` roles.
- Light/dark resolution.
- Typography selection.
- Radius, surface, shadow, and motion roles.
- Source-mode customization.
- Package-mode theme configuration.
- Contrast and reduced-motion verification.

The page uses live token specimens from the actual theme, not static screenshots.

### 7.8 Flutter & Dart page

Replace the reference's JavaScript/TypeScript material with:

- Import conventions.
- Public barrel versus private `src/`.
- Widget composition.
- Controllers and callbacks.
- Async actions and feedback.
- Null safety.
- Responsive structure.
- Platform adaptation.
- Assets, fonts, and shaders.
- Package mode versus copied-source imports.
- Testing copied components.

### 7.9 CLI page

Render the command reference from the same structured command model used by the CLI, or test documentation against it. Include:

- Synopsis.
- Installation.
- Global options.
- Every command and subcommand.
- Common workflows.
- Exit codes.
- JSON output.
- Offline and CI usage.
- Conflict behavior.
- Recovery and doctor.

### 7.10 Skills docs page

The Skills entry inside Docs is the concise installation and configuration reference. It links to the richer top-level Skills page.

### 7.11 Repository page versus repository link

Do not create a redundant top-level Repository product page. GitHub is a persistent header action, while Docs contains Contributing, Security, License, Registry, and Monorepo pages. This keeps repository information discoverable without adding a sixth primary destination.

## 8. Components catalog

### 8.1 Catalog purpose

Allow users to answer three questions quickly:

1. Does the component exist?
2. Does it behave correctly in my state and form factor?
3. How do I install and use it?

### 8.2 Catalog header

- Title: Components.
- One-sentence description.
- Search field.
- Filters: All, Foundations, Base, Agent, Site.
- Optional filters: Stable, Experimental, Requires asset, Requires shader.
- View control: Grid or compact list, persisted locally.

### 8.3 Component card

Each card contains:

- Component name.
- One-line description.
- Live minimal specimen or stable thumbnail.
- Family and status badges.
- Install command on hover/focus or in a consistent footer.
- Open details action.

Do not put multiple competing copy icons on every card. The primary card action opens the component page; a single command copy action is secondary.

### 8.4 Catalog states

- Loading: skeletons preserve the chosen view.
- Empty filter: explain which filter removed results and offer Clear filters.
- Search no result: show nearby aliases/categories and an issue link for a missing component.
- Registry error: show cached content if available, freshness label, Retry, and GitHub fallback.
- Experimental item: label status and compatibility clearly.

## 9. Component detail page template

Every installable component receives its own route and uses one consistent template.

### 9.1 Page order

1. Breadcrumb and family.
2. Component name.
3. Short description.
4. Expanded purpose and decision guidance.
5. Status/version/platform metadata.
6. Primary live specimen with Preview/Code tabs.
7. Installation with Command/Manual tabs.
8. Usage.
9. API reference.
10. Variants and sizes.
11. States and feedback.
12. Accessibility and keyboard behavior.
13. Responsive/platform behavior.
14. Dependencies, files, assets, fonts, and shaders.
15. Composition examples.
16. Theming notes.
17. Source, tests, report issue, and edit docs.
18. Previous/Next component navigation.

### 9.2 Introduction content contract

Each component has two descriptions:

- **Short description:** one sentence suitable for navigation and search.
- **Expanded description:** what problem it solves, when to use it, and when to choose a neighboring component instead.

The expanded description should answer decisions, not repeat the name.

### 9.3 Primary specimen

The main specimen surface includes:

- Live interactive preview.
- Preview/Code tabs.
- Theme control when theme comparison matters.
- Viewport control for responsive components.
- Reset action for stateful specimens.
- Copy source action.
- Open isolated preview when the specimen needs more room.

The preview frame has a predictable minimum height and does not jump when switching tabs. Code is selectable, horizontally scrollable, and uses the system mono role.

### 9.4 Installation section

Tabs:

#### Command

```console
elattar add button
```

One command, one Copy action, and a note that transitive dependencies are resolved automatically.

#### Manual

Manual installation lists:

1. Files to copy.
2. Registry dependencies.
3. Pub dependencies.
4. Assets/fonts/shaders.
5. Pubspec changes.
6. Barrel export.
7. Format and analyze commands.

For source mode, include View raw source and Copy file. For package-backed components, show the package alternative separately rather than mixing it into manual source steps.

### 9.5 Usage section

Begin with the smallest correct Dart example:

```dart
import 'package:my_app/components/ui/ui.dart';

Button(
  label: 'Continue',
  onPressed: () {},
)
```

Then document meaningful variants. Do not manufacture shadcn examples that the Dart API does not support.

### 9.6 API section

Use structured tables for:

- Constructor property.
- Dart type.
- Default.
- Required/optional.
- Meaning.
- Related semantic or state behavior.

Link class and enum names to generated API documentation when available.

### 9.7 State matrix

Applicable rows:

- Rest.
- Hover.
- Focus-visible.
- Pressed.
- Selected.
- Loading.
- Empty.
- Error.
- Success.
- Disabled.
- Reduced motion.

Each row states visual treatment, semantics, keyboard behavior, and recovery where relevant. Inapplicable rows are omitted or explicitly marked N/A with a reason; do not invent asynchronous behavior for synchronous primitives.

### 9.8 Accessibility section

Include:

- Semantic role.
- Required labels.
- Keyboard interactions.
- Focus behavior.
- Touch target expectations.
- Non-color signals.
- Error wiring.
- Screen-reader announcements.
- Known platform differences.

### 9.9 Elattar-only technical disclosure

Every component page shows an installation facts panel:

```text
Registry item        button
Destination          lib/components/ui/button.dart
Foundation           source or package compatible
Dependencies         icon, press
Assets               none
Shaders              none
Platforms            Android, iOS, Web, macOS, Windows, Linux
Verified             package tests + fixture install + docs specimen
```

This makes source distribution transparent in a way typical component documentation does not.

## 10. Shots page

### 10.1 Index

The Shots index is a visual catalog of complete compositions.

Header controls:

- Search.
- Platform: All, Mobile, Adaptive, Desktop/Web.
- Family/use case: Dashboard, Forms, Data, Navigation, Chat, Agent, Site.
- Status: Stable, Experimental.

Each shot card contains:

- Large verified screenshot.
- Name and use-case description.
- Platform and component-count metadata.
- Preview.
- Code.
- Install command.

### 10.2 Shot detail

```text
Title and description
Install command
Full responsive preview
Preview / Code
Viewport and theme controls
File tree
Selected file code
Included components
Dependencies and assets
Behavior and state walkthrough
Accessibility notes
Customization seams
Source / report issue
```

The file tree distinguishes:

- Product-neutral shot composition.
- Installed `components/ui` dependencies.
- Mock data.
- Optional assets.

### 10.3 Shot installation

```console
elattar add dashboard-overview
```

A shot registry item installs composition files to an explicit application-facing target and resolves its component dependencies into `lib/components/ui/`. It must not place domain-specific screens inside the design-system component directory.

### 10.4 Isolated preview

`/shots/<slug>/preview` removes documentation chrome and renders only the shot. It supports query parameters for theme, viewport, motion, and deterministic clock when applicable. This route serves users, automated screenshots, and visual regression tests.

## 11. Skills page

### 11.1 Purpose

Show developers how the Elattar skill teaches supported coding agents to discover public `El*` APIs, use tokens, install components, compose screens, cover states, and verify Flutter UI correctly.

### 11.2 Page structure

1. Hero: “Give your coding agent the design system's rules.”
2. Supported agents and environments.
3. Install command with copy action.
4. What the skill reads from the project.
5. What knowledge it provides.
6. Before/after workflow example.
7. Prompt gallery.
8. Safety and scope.
9. Skill contents/file tree.
10. Version compatibility.
11. Update/uninstall instructions.
12. View source on GitHub.

### 11.3 Installation command

Do not publish an invented command. The page displays the final command only after the public skill packaging and installer are verified. Candidate distribution routes are:

- A standard skills installer pointed at the GitHub repository.
- An `elattar skill install` command added to the CLI in a later specification.
- Manual copy of the public skill directory.

The page must always provide a manual GitHub route even when an installer exists.

### 11.4 What the skill provides

- Public API discovery instead of guessed widgets.
- Foundation and semantic token rules.
- Correct component placement.
- Full state, feedback, and accessibility expectations.
- Responsive and platform contracts.
- Package versus application composition decisions.
- Test and visual-verification commands.
- Registry and CLI awareness.

### 11.5 Prompt gallery

Use realistic prompts such as:

- “Add a settings screen using Elattar components.”
- “Install a dialog and use it for destructive confirmation.”
- “Build an adaptive dashboard from the dashboard shot.”
- “Review this page for raw visual literals and missing states.”
- “Add loading, empty, error, and retry behavior to this list.”

Each example states what the skill changes in the agent's behavior. Avoid claiming compatibility with an agent until tested.

## 12. Repository recommendation

### 12.1 Use the existing repository

Keep and publish:

```text
https://github.com/ELATTAR-Ayoub/flutter-design-system
```

Recommended monorepo shape:

```text
flutter-design-system/
├── lib/                         # Maintained Flutter package
├── test/
├── example/                     # Public website/docs application
├── packages/
│   ├── elattar_cli/
│   └── elattar_core/            # If package-backed foundations are split
├── registry/
├── skills/
│   └── elattar-flutter-ui/
├── docs/
├── tool/
└── .github/
```

The current internal skill under `.agents/skills/` can remain the working source during development, but the public skill should have an intentional, documented distribution location such as `skills/elattar-flutter-ui/`. Define one source of truth or generate one from the other; do not let two skill copies drift.

### 12.2 Why not split now

A separate website repository would create:

- Documentation/version drift.
- Cross-repository pull requests for one component.
- Harder preview deployments.
- Duplicate source/registry metadata.
- More complicated release coordination.
- A weaker contributor path.

Split only if the website later moves to a fundamentally different stack with an independent team and release lifecycle. Deployment hosting is not sufficient reason to split source ownership.

### 12.3 Public README structure

The repository README should be concise:

1. Product name and one-sentence promise.
2. Website, documentation, pub.dev, and CLI links.
3. Fast start commands.
4. Source versus package mode.
5. Small Flutter usage example.
6. Repository map.
7. Development and verification.
8. Contributing, security, license, and attribution.

Do not duplicate the complete documentation in the README.

### 12.4 GitHub metadata

- Description: Flutter design system and open-code component registry.
- Homepage: deployed documentation URL.
- Topics: `flutter`, `dart`, `design-system`, `components`, `ui`, `cli`, `registry`, `open-source`.
- Discussions for usage and proposals.
- Issue templates for bug, component request, docs, registry, CLI, and accessibility.
- Protected main branch and required CI.

## 13. Content source of truth

Introduce structured website metadata rather than scattering strings across routes.

Each documented item should expose:

```text
slug
name
family
shortDescription
longDescription
status
registryItem
installCommand
sourceFiles
dependencies
assets
shaders
platforms
apiSymbols
specimens
states
accessibility
docsRoute
sourceUrl
testUrls
```

Use this data to generate or validate:

- Navigation.
- Search index.
- Catalog cards.
- Component introductions.
- Install facts.
- Registry links.
- Previous/Next ordering.

The actual Dart examples and live specimens remain authored code because generated generic examples cannot express meaningful component behavior reliably.

## 14. Existing API reuse and additions

### 14.1 Existing system APIs to reuse

The repository already supplies suitable foundations or components for:

- `PageGlow`.
- `SafeArea`.
- `Sidebar` family.
- `NavigationMenu`.
- `Breadcrumb`.
- `Tabs`.
- `Command`.
- `Card` family.
- `Button` and `ButtonGroup`.
- `Input` and input groups.
- `Skeleton`.
- `Empty`.
- `Toaster`.
- Alerts, dialogs, sheets, drawers, popovers, and tooltips.
- Existing documentation `Code` and `CodeBlock` in `example/lib/kit.dart`.
- Existing site-page primitives and reading-navigation contracts documented by the Site group.

Inspect constructors, tests, and examples before using any of them. The plan does not assume an unverified API shape.

### 14.2 Documentation-only compositions

Keep these in `example/lib/` unless they prove reusable beyond the website:

- Component preview frame.
- Command copy panel.
- API table renderer.
- State matrix.
- Install facts panel.
- File tree/code explorer.
- Viewport simulator.
- Catalog filters.
- Documentation navigation model.

Add a package primitive only when it has a reusable, product-neutral contract, public export, focused test, and specimen.

## 15. States and feedback

### 15.1 Copy command/code

- Rest: Copy label/icon.
- Success: accessible “Copied” confirmation and optional toast.
- Error: inline failure with Select manually recovery.
- Repeated action: no unbounded toast stack.

### 15.2 Live preview

- Loading: preserve frame dimensions with skeleton/progress.
- Ready: interactive specimen.
- Error: explain whether the specimen, registry, or asset failed; provide Reset/Retry.
- Reset: restores deterministic initial state.
- Reduced motion: immediate stable state.

### 15.3 Search and filters

- Loading, results, empty query, no result, error, and cached/offline states.
- Selected filters remain visible and removable.
- Clear all is discoverable.

### 15.4 Theme selection

- Light, Dark, and System are distinguishable by label and selected state, not icon color alone.
- Changing theme preserves route, scroll position where practical, and interactive specimen state unless reset is necessary.

### 15.5 External links

GitHub, pub.dev, and raw source failures cannot be controlled by the site; labels must make the destination clear before navigation.

## 16. Responsive contracts

### 16.1 Wide

- Header exposes all primary destinations.
- Docs use sidebar + article + optional TOC.
- Component pages use wide specimens and an article measure beneath/alongside them.
- Shot pages can show file tree and code side by side.

### 16.2 Tablet

- Primary nav may remain visible when it fits; otherwise use the mobile menu.
- Docs sidebar becomes a sheet before the article measure becomes cramped.
- TOC becomes an article disclosure.
- Preview/code stays tabbed.

### 16.3 Mobile

- Header is reduced to menu, brand, search, and theme.
- Installation tabs remain reachable and commands scroll without clipping.
- API tables become horizontal scroll regions or labeled property cards.
- Shot file tree becomes a file selector above code.
- Specimens use mobile-native structure rather than a scaled desktop frame.
- `SafeArea` is applied once at page boundaries.

## 17. Accessibility requirements

- A visible skip link precedes global navigation.
- One H1 per route; heading levels never skip for visual sizing.
- Active navigation uses semantics and more than color.
- All icon-only actions have discoverable labels.
- Focus remains visible in both themes.
- Sidebar, drawers, tabs, code copy, search, and previews are keyboard operable.
- Modal navigation traps and restores focus correctly.
- Code and commands are selectable.
- Status never relies on color alone.
- Live updates announce only consequential changes.
- Touch targets follow the system contract.
- Text scale, long localization, and zoom do not hide actions.
- Reduced motion is tested, not inferred.

## 18. SEO, sharing, and Flutter Web limitations

Because the planned implementation is Flutter Web:

- Give every public route a stable URL and browser title.
- Ensure direct navigation and refresh work under the GitHub Pages base path.
- Provide route-specific metadata through the web shell where Flutter allows it.
- Generate `sitemap.xml`, `robots.txt`, Open Graph images, and `llms.txt` from structured metadata.
- Keep important prose and code discoverability under evaluation; canvas-heavy rendering can be weaker for search, selection, and long-form documentation.
- Establish a performance budget for initial bundle, fonts, images, and shader-backed previews.
- Defer nonessential showcase code or load heavy demonstrations on demand when the app architecture supports it.

If organic documentation search, first load, or code reading fails acceptance criteria, evaluate a static/hybrid documentation frontend in the same monorepo. Do not split repositories merely to change rendering technology.

## 19. Verification plan

### 19.1 Automated

```console
flutter analyze
flutter test
cd example
flutter analyze
flutter test
flutter build web --release
```

Add focused tests for:

- Route/nav/search metadata consistency.
- Every registered page resolving to non-placeholder content.
- Header and navigation in wide/narrow layouts.
- Component page installation tabs and copy feedback.
- Preview/code switching.
- Search loading/empty/error/recovery.
- Theme persistence.
- Reduced motion.
- Shot file tree and isolated preview parameters.
- Skills install content sourced from verified metadata.

### 19.2 Visual

Capture and inspect:

- Home: light/dark × mobile/wide.
- Docs introduction: light/dark × mobile/wide.
- One simple and one complex component page.
- Components catalog with results and no-results state.
- Shots index and shot detail.
- Skills page.
- Navigation sheet, search command, code overflow, long API table, and error states.

### 19.3 Content integrity

- Every install command exists in the CLI command model.
- Every component route maps to a public export or an explicit composition.
- Every registry item link resolves.
- Every source/test link targets the public repository.
- No React, TypeScript, Tailwind, npm, Radix, or shadcn instruction remains unless clearly presented as attributed comparative context.
- No component page promises a state, platform, asset, shader, or manual installation path that is not verified.

## 20. Implementation phases

### Phase A — Shell and content model

- Define top-level routes and structured metadata.
- Build global header, mobile navigation, footer, search entry, theme selector, and GitHub action.
- Separate the public site route model from the current legacy-parity documentation grouping without breaking existing specimens.

**Exit:** Home, Docs, Components, Shots, and Skills routes resolve with complete responsive chrome.

### Phase B — Home

- Build hero, install panel, living showcase, how-it-works, foundations, families, featured shots, skill feature, and open-source close.
- Use only public `El*` APIs and foundation tokens.

**Exit:** the product can be understood and installed from the home page without reading every doc.

### Phase C — Documentation shell and core docs

- Build sidebar/article/TOC structure.
- Ship Introduction, Installation, Configuration, Theming, Flutter & Dart, CLI, Accessibility, Motion, Registry, and Contributing.
- Add Previous/Next and Edit on GitHub.

**Exit:** documentation is sufficient for a clean installation and first component.

### Phase D — Components catalog and template

- Build searchable catalog, filters, cards, states, and component page template.
- Pilot Button, Select, Dialog, Sidebar, Agent Console, and Voice Orb to exercise simple, compound, responsive, agent, asset, and shader cases.

**Exit:** the template handles every known documentation class before bulk migration.

### Phase E — Component migration

- Create one route per installable component.
- Reuse existing specimens while adding installation, usage, API, state, accessibility, dependency, and source sections.
- Keep grouped overview pages as category landing pages rather than deleting their useful matrices.

**Exit:** every stable registry component has an individual public page.

### Phase F — Shots

- Define shot metadata and registry type.
- Build index, detail, preview/code explorer, isolated preview, and first three verified shots.

**Exit:** each published shot is previewable, inspectable, and installable.

### Phase G — Skills

- Establish one public skill source of truth.
- Verify supported installation methods and agents.
- Build Docs summary plus dedicated Skills page.

**Exit:** users can install, understand, update, and inspect the skill without private guidance.

### Phase H — Public polish and release

- Complete metadata, sitemap, social cards, `llms.txt`, performance checks, broken-link checks, visual captures, and GitHub Pages deployment.
- Update README and GitHub metadata.

**Exit:** the website and repository are ready to be the public front door.

## 21. Binding acceptance criteria

1. The existing repository is the public monorepo and documentation source.
2. Primary navigation contains Home, Docs, Components, Shots, Skills, theme, search, and GitHub; Create is absent until real.
3. Documentation is the most complete part of the site and works at mobile and desktop widths.
4. The navigation uses Flutter & Dart rather than TypeScript/JavaScript.
5. Every stable installable component has an individual page.
6. Every component page includes short and expanded descriptions, live preview/code, Command/Manual installation, usage, API, variants, states, accessibility, platform behavior, dependencies, files/assets/shaders, source, and tests where applicable.
7. Components install to `lib/components/ui/` in both foundation modes.
8. Shots are full product-neutral compositions with Preview, Code, file tree, CLI install, dependencies, and isolated preview.
9. Skills has both a Docs entry and a dedicated top-level page, and publishes only verified installation commands.
10. Theme control supports Light, Dark, and System.
11. Search covers docs, components, shots, CLI, and skills.
12. Loading, empty, error, success, disabled, focus, offline/cached, and recovery states are designed where applicable.
13. Public content uses actual `El*` APIs and tokens; the legacy web project remains lineage only.
14. GitHub Pages direct links, browser history, safe areas, keyboard access, reduced motion, and code selection are verified.
15. No shadcn brand, prose, recognizable full layout, or unsupported web-only feature is copied.

## 22. Final recommendation

Publish the existing repository and let one monorepo own package, registry, CLI, skill, documentation, and website. The first public website should feel familiar to developers who understand shadcn's open-code workflow, but unmistakably native to Flutter and Elattar.

The site should communicate this in one flow:

> See the system live.
> Understand the rule behind it.
> Install the exact component or shot.
> Own the source.
> Give the same rules to your coding agent.
