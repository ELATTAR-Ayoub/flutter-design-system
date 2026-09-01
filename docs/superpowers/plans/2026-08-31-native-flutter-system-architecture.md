# Native Flutter Design-System Architecture Plan

> **For Cloud:** use `superpowers:executing-plans` when available. Read
> `AGENTS.md` and `skills/elattar-flutter-ui-director/SKILL.md` completely,
> resolve repository mode, and execute this master plan in order. The existing
> `2026-08-31-responsive-typography-system-rebuild.md` is the typography portion
> of Workstream 1; do not execute it as an independent rewrite. Never publish, tag, push,
> deploy, or commit unless the owner separately requests that exact action
> after reviewing the final diff and evidence.

**Goal:** Make the package a native Flutter design system whose behavior is
owned by Flutter contracts—not by Tailwind utilities, browser cascade,
DOM structure, CVA order, or measured defects from the retired web project.
Correct the type system, interaction infrastructure, components, blocks,
documentation, registry output, and tests while preserving useful Elattar
visual identity and consumer-facing capability.

**Execution principle:** do not rewrite a component merely because its comments
mention CSS. Preserve behavior that is sound in Flutter; replace behavior that
exists only to reproduce a browser accident, unreachable selector, no-op class,
or inaccessible web result. “Matches the old website” is evidence of lineage,
not an acceptance criterion.

## Audited repository baseline

- Repository mode: `lib/elattar_design_system.dart` is present.
- 100 Dart files exist in `lib/src/components/ui/`; generated icon-path files
  and private support files account for the difference from the catalog.
- 99 public documentation/registry entries exist: 67 general components,
  14 effects, 14 agent entries, and 4 chart entries. One is the source
  foundation item and one is the `AgentConsole` block.
- The public barrel exports nearly the entire component tree, including low-
  level motion/effect infrastructure.
- `typography.dart` declares 65 `TextStyleToken` values; 50 declarations use an
  explicit size of 15px or less. The public page currently presents 27 roles.
- Authored `lib/src` contains 308 textual “drift” mentions. This is not a count
  of distinct bugs, but it proves old parity decisions are spread across the
  package rather than isolated in comments.
- The current package constraint combines Dart `^3.12.2` with
  `flutter: ">=1.17.0"`. That Flutter minimum does not honestly describe the
  modern framework APIs in use and must be corrected to the minimum actually
  tested by CI.
- Existing tests are extensive but frequently lock computed web parity rather
  than a native Flutter product contract. Green parity tests are not sufficient
  evidence for accessibility, responsive layout, focus lifecycle, or platform
  behavior.

## Native Flutter architecture contract

### Foundation

1. Foundation APIs use semantic Elattar names. Values may remain numerically
   identical to a useful former value, but public names and documentation must
   not depend on Tailwind utilities or CSS variables.
2. Typography defines family, size, leading, weight, tracking, features, and
   responsive resolution. It never owns semantic color.
3. Color is selected by component/surface meaning through `ThemeScope`.
4. Geometry comes from `space`, `Radii`, `LayoutWidths`, `Containers`, and
   meaningful component contracts. No CSS `rem`, `vw`, or class-order
   arithmetic appears at a call site.
5. Motion comes from `MotionDurations`, `MotionCurves`, and framework animation
   primitives. Every animation respects reduced motion and `TickerMode`.
6. Shadow tokens are semantic elevations/surfaces, not `tailwindSm/Md/Lg/Xl`.
7. Breakpoints choose structure by available constraints. They do not guess a
   device or reproduce one 1440×900 measurement.

### Component boundaries

1. A component receives state and emits events. It does not fetch data, own a
   product request, print backend errors, or show its own global toast.
2. Every public variant has a user/product meaning. Delete web-only variants,
   unreachable branches, and no-op axes after migration evidence proves no
   legitimate consumer needs them.
3. Text-bearing components grow with text. Fixed visual shells may have a
   minimum size, but never a hard height that clips 200% text.
4. Compact visual treatments still provide a 44×44 effective touch target on
   touch platforms.
5. Hover is an enhancement. The same action remains reachable by touch and
   keyboard.
6. Interactive components use Flutter focus, actions/intents, shortcuts,
   semantics, and gesture primitives directly. Do not emulate DOM events or
   CSS pseudo-classes.

### Shared interaction contract

1. Establish one internal control-state model for enabled, hovered,
   focus-visible, pressed, selected/checked, loading, invalid, and read-only as
   applicable. Do not expose a boolean for every visual combination.
2. Clickable surfaces that are not `Button` must still provide semantics,
   keyboard activation, focus indication, pointer cursor, pressed feedback,
   and a labelled effective target. `GestureDetector` plus hover alone is not
   a complete control.
3. Composite controls are one Tab stop with internal arrow navigation.
4. Overlay primitives share a native lifecycle: correct anchor/route choice,
   modal semantics when modal, focus entry/trap, Escape dismissal when
   dismissible, barrier behavior, scroll/inset handling, and focus restoration
   to the exact trigger.
5. Async/busy changes are announced. Spinner has status semantics when it is
   the only busy signal; a loading Button exposes busy state without duplicate
   announcements.

### Compatibility and release policy

1. Preserve a public API when native behavior can be implemented behind it.
2. Removing dead variants or correcting a broken behavioral contract requires
   a changelog migration entry and tests. Do not keep broken aliases merely to
   preserve web parity.
3. Check whether CLI/package `0.0.1` is already published before modifying
   versioned registry artifacts. Published artifacts and tags are immutable;
   use the next version when necessary.
4. Generated registry sources and icon paths are never hand-edited.

## Workstream 0 — Build the evidence ledger once

1. Capture the current Git state and preserve unrelated files, including
   existing untracked verification output.
2. Record Flutter and Dart versions used by local verification and CI. Set the
   package's minimum Flutter version to the oldest version actually tested and
   capable of every required framework API.
3. Derive, in one batched inventory:

   - barrel export → source file → registry item → docs page → root tests →
     example tests;
   - public constructors, enums, callbacks, controllers, and deprecated/dead
     branches;
   - every Tailwind/CSS/CVA/DOM/Preflight dependency in executable behavior;
   - every documented “drift,” no-op, unreachable selector, inherited browser
     default, fixed text height, hover-only action, silent state, and missing
     focus restoration;
   - all direct gesture, mouse, keyboard, focus, overlay, animation, scroll,
     semantics, and sizing primitives;
   - all foundation and visual tokens each component consumes.

4. Create `docs/audits/native_flutter_component_audit.md` from the matrix in
   this plan. Add columns for final disposition, source/test/docs paths,
   acceptance evidence, and status. This ledger—not scattered commentary—is
   the execution source of truth.
5. Classify each recorded legacy behavior as:

   - **keep:** valid Flutter behavior with an Elattar product reason;
   - **translate:** useful intent implemented through native Flutter;
   - **fix:** observable defect or accessibility/responsive failure;
   - **remove:** unreachable/no-op/dead compatibility surface;
   - **document:** unavoidable framework/platform limitation.

Do not run the full Flutter suite during this inventory.

## Workstream 1 — Rebuild the foundations for direct Flutter resolution

### Typography and text layout

Execute the final 17-role contract in
`2026-08-31-responsive-typography-system-rebuild.md`, with these master-plan
clarifications:

- remove public and internal type roles that exist solely to model utility
  combinations;
- component labels derive from the core roles without becoming public
  “Labels and furniture” tokens;
- remove role-owned `defaultColor`; call sites/components select semantic ink;
- resolve responsive sizes from constraints and text scale without CSS cascade;
- remove Redaction/typographic Accent when the final usage audit is empty;
- migrate every component call site in the component matrix below.

### Color, spacing, shadows, breakpoints, and motion

1. Audit semantic color names and contrast in both modes. Preserve the semantic
   color `accent`; it is unrelated to the removed typeface role.
2. Retain the 4px spatial base only as an Elattar spacing decision. Rewrite
   documentation that treats Tailwind as its authority.
3. Replace publicly reachable `tailwind*` shadow names with semantic surface
   roles. Migrate Sheet, Select, chart tooltips, and any other consumers.
4. Keep breakpoint numbers only after narrow/wide/tablet stress tests validate
   the structure they trigger. Prefer `LayoutBuilder` for component regions.
5. Inventory every animation controller and repeating ticker. Require
   `effectiveMotionDuration`, reduced-motion behavior, `TickerMode`, disposal,
   and a stable nonanimated information state.
6. Remove CSS keyframe/cascade APIs that a Flutter consumer should never have
   to understand. Keep reusable Flutter motion primitives only when they have a
   clear public use case, complete tests, and documentation independent of CSS.
7. Rewrite foundation comments and tests around current Flutter behavior.
   Historical web measurements belong in Git history or the audit ledger, not
   as the reason a public token exists.

**Focused foundation gate**

```powershell
flutter test test/foundation_colors_test.dart test/foundation_type_motion_test.dart test/text_layout_test.dart test/theme_scope_test.dart test/motion_test.dart test/token_guard_test.dart
```

## Workstream 2 — Establish native shared primitives before leaf migration

### Activation and control state

1. Refactor `Press`, `HoverBuilder`, `InteractiveCard`, `ActionFeedback`, and
   shared selection/control helpers so leaf components do not each rebuild
   hover, pressed, focus-visible, disabled, and keyboard behavior.
2. A public `onTap` path must be keyboard reachable and semantically labelled.
   `InteractiveCard` currently combines `HoverBuilder` and `GestureDetector`
   without completing that contract; correct it before migrating cards.
3. Preserve pointer-down feedback for touch and mouse, but do not make visual
   transformation the only feedback.
4. Test Enter/Space activation, disabled focus behavior, semantics, 44×44
   targets, touch without hover, and reduced motion once at the shared layer.

### Overlay and focus lifecycle

1. Audit `Dialog`, `AlertDialog`, `Popover`, `Sheet`, `Drawer`, `HoverCard`,
   `Tooltip`, `Menu`, `Menubar`, `DropdownMenu`, `ContextMenu`, `Select`,
   `Combobox`, `Command`, `NativeSelect`, and `NavigationMenu` as one family.
2. Choose Flutter's native `OverlayPortal`/overlay, route, or menu-anchor model
   by behavior. Do not maintain a custom abstraction merely because the web had
   a portal.
3. Centralize focus entry/trap/restore and dismiss intents without forcing
   nonmodal popovers to behave like dialogs.
4. Test nested overlays, scroll/resize repositioning, window focus loss,
   outside click/tap, Escape, trigger disposal, route change, safe areas,
   keyboard insets, screen-reader modal names, and restoration.

### Scrolling, layout, and text stress

1. Remove fixed heights around text. Convert visual heights into minimum
   constraints and let content grow.
2. Keep `ScrollArea` specialized; do not use it as a general page scroller or
   place `LayoutBuilder` below an unconstrained intrinsic-width path.
3. Provide reusable test helpers for 390×844, 834×1112, 1440×900; light/dark;
   text scale 1/2; long localized content; zero/one/many items.

**Focused shared gate**

```powershell
flutter test test/components_test.dart test/effects_test.dart test/feedback_effects_test.dart test/dialogs_test.dart test/menus_test.dart test/navigation_test.dart test/layout_test.dart test/selection_feedback_test.dart
```

## Component-by-component disposition matrix

Every row is mandatory. “Validate” means inspect source, constructor, states,
semantics, focus/keyboard, responsive behavior, themes, motion, docs, registry,
and tests; it never means assume the component is fine.

### General components — content, layout, and feedback

| Entry | Priority | Native Flutter action and acceptance |
|---|---|---|
| `accordion` | P1 | Replace CSS-height/cascade assumptions; semantic expanded state; keyboard activation; content grows at 200%; migrate trigger/body type. |
| `alert` | P1 | Separate semantic status ink from typography; icon/word conveys status; flexible title/body layout; validate contrast and long text. |
| `alert_dialog` | P0 | Rebuild on the shared modal lifecycle; safest initial focus, trap, Escape, focus restore, semantic title/description, growing actions via `Wrap`. Remove reproduced drifts. |
| `attachment` | P1 | Replace 12–13px utility roles, fixed compact geometry, hover-only affordances, and silent loading; validate remove/retry/download semantics and long filenames. |
| `avatar` | P2 | Validate image semantics/fallback initials, loading/error behavior, scalable fallback type, clipping, and decorative usage; remove CSS-only style branches. |
| `badge` | P1 | Use 14/18 Badge-owned role; ensure status never color-only; remove unreachable icon-padding selector behavior; grow for scaled/localized text. |
| `breadcrumb` | P1 | Remove reproduced separator drift and browser list inheritance; semantic navigation/order/current item; wrap at narrow width; links keyboard/touch accessible. |
| `bubble` | P1 | Replace 13px/zero-duration CSS behavior; flexible content, reactions and actions accessible on touch, semantic speaker/order, long code and 200% stress. |
| `button` | P0 | Execute core type migration; minimum/effective targets, loading/busy semantics, no double action, keyboard/focus/press parity, remove dead `iconXs`/web-only branches. |
| `calendar` | P0 | Validate Flutter date/grid semantics, arrow-key model, locale/first-day rules, timezone-safe selection, focus movement, range states, 200% layout, and remove selector-derived quirks. |
| `card` | P2 | Keep as semantic surface; ensure interactive cards go through complete shared activation rather than raw gesture/hover; flexible contents and correct elevations. |
| `carousel` | P1 | Native scroll/page physics, semantic position and actions, arrows/keys/touch, reduced motion, focus retention, resize behavior, and no clipped scaled content. |
| `collapsible` | P1 | Native expanded semantics and keyboard activation; flexible animated size; reduced motion; state ownership and controller lifecycle. |
| `empty` | P2 | Remove old font/cascade assumptions; enforce title/body/one-next-step structure, flexible layout, image semantics, and empty versus no-results documentation. |
| `item` | P1 | Make selectable/actionable rows complete controls; remove no-op transition behavior; flexible leading/trailing slots; target, focus, semantics, and long-text stress. |
| `kbd` | P2 | Raise/readjust typography, expose spoken key names, model platform-specific modifier labels, and grow instead of clipping. Remove Preflight-derived sizing. |
| `marker` | P2 | Validate semantic meaning versus decoration, anchor/layout behavior, token colors, contrast, and scalable labels. |
| `message` | P1 | Semantic author/time/content ordering, scalable body/meta type, status not color-only, long content, copy/select behavior, and explicit action accessibility. |
| `message_scroller` | P0 | Native scroll anchoring, “new messages” announcements, user-versus-programmatic scroll ownership, keyboard access, reduced motion, resize/text-scale stress, and no CSS duration no-ops. |
| `progress` | P1 | Correct determinate/indeterminate semantics and announcements, clamp/NaN handling, status beyond color, reduced motion, and scalable adjacent labels. |
| `questionnaire` | P0 | Treat as a composite form: field labels/errors, focus on invalid, keyboard ordering, submitting/disabled states, no double submit, adaptive structure, and human error copy. |
| `separator` | P3 | Validate horizontal/vertical semantics (decorative by default), hairline rendering at DPRs, and token color; no rewrite if contract passes. |
| `skeleton` | P2 | Preserve footprint ownership, exclude decoration from semantics, respect reduced motion/TickerMode, verify no layout jump and document fixed pumping accurately. |
| `spinner` | P0 | Remove deliberately reproduced silent semantics. Provide contextual status policy, reduced motion/TickerMode, size/stroke consistency, and prevent duplicate announcement inside loading Button. |
| `stat` | P1 | Use final numeric roles, semantic label/value/trend, trend not color-only, locale-safe formatting, long labels, and responsive metric layout. |
| `table` | P0 | Native header/cell semantics, keyboard/action access, sorting announcements, scalable rows, narrow stacked alternative guidance, horizontal scroll without unreachable controls. |
| `toaster` | P0 | One app-level controller/host, live-region announcements, deterministic queue/update/dismiss timers, pause and swipe behavior, keyboard-accessible actions, focus safety, reduced motion, and no clocks expiring while content is invisibly queued. |
| `user_menu` | P1 | Make it a composed Menu contract rather than independent web behavior; trigger label/state, keyboard menu flow, focus restore, account copy, and narrow layout. |

### General components — controls and forms

| Entry | Priority | Native Flutter action and acceptance |
|---|---|---|
| `checkbox` | P0 | Native checked/mixed semantics, Space activation, focus-visible, validation, 44×44 target, disabled/read-only distinction, and reduced motion. |
| `field` | P0 | Visible label, description/error associations, required state, focus/error routing, flexible copy, semantic grouping, and final typography. |
| `form` | P0 | Native form validation/submission ownership, first-invalid focus, submitting lock, async error boundary, announcements, and no CSS layout assumptions. |
| `input` | P0 | TextField-native editing/selection/IME/autofill, visible label via Field, focus/error/read-only/disabled semantics, keyboard inset, scalable minimum geometry. |
| `input_group` | P0 | Preserve one coherent field semantics node while keeping prefix/suffix actions separately operable; flexible slots, focus ring, long/scaled content. |
| `input_otp` | P0 | Native text input/IME/paste/autofill, one logical semantic field, error announcement, focus movement without invisible-web-field assumptions, RTL and 200% stress. |
| `native_select` | P0 | Prove the name: use appropriate Flutter/platform selection semantics; full keyboard model, focus lifecycle, selected announcement, disabled/read-only, long options. |
| `radio` | P0 | One-tab-stop group with arrow navigation, selected semantics, labels/description, focus-visible, 44×44 targets, disabled behavior, and validation. |
| `selection_control` | P0 | Make the shared checkbox/radio/switch activation, target, semantics, focus, and animation contract authoritative; remove selector/cascade artifacts. |
| `slider` | P0 | Adjustable semantics/increase/decrease actions, keyboard increments, RTL, divisions/range edge cases, 44×44 thumb target, labels, focus, reduced motion. |
| `switch` | P0 | Native toggled semantics and Space activation, focus-visible, 44×44 target, label association, disabled/read-only distinction, reduced motion. |
| `textarea` | P0 | Native multiline editing/IME/selection, visible label, error/read-only/disabled states, keyboard inset, min rather than fixed height, 200% stress. |
| `toggle` | P0 | Native selected semantics, Space/Enter, focus/target states, remove CVA/class precedence, final type, and meaningful variants only. |
| `toggle_group` | P0 | One Tab stop, arrow navigation, single/multiple selection semantics, disabled items, roving focus, wrap/overflow behavior, and no per-child Tab stops. |
| `validation_rule` | P2 | Keep as pure validation/domain contract; verify localized human messages, composability, async boundary, and no UI/backend leakage. |

### General components — overlays, menus, and disclosure

| Entry | Priority | Native Flutter action and acceptance |
|---|---|---|
| `combobox` | P0 | Shared overlay lifecycle plus editable text semantics, filtering/result-count announcements, arrows/Enter/Escape, no-results action, IME, focus restore, long options. |
| `command` | P0 | Remove documented no-op filtering/parity defects; native search/list state, one active option, full keyboard map, result announcements, command activation and empty state. |
| `context_menu` | P0 | Native secondary-click/long-press invocation, keyboard alternative, anchor placement, menu semantics, focus entry/restore, and touch reachability. |
| `dialog` | P0 | Shared modal lifecycle, semantic route/name, focus trap/restore, Escape/barrier policy, safe areas, keyboard inset, flexible actions, and reduced motion. |
| `drawer` | P0 | Use route/overlay semantics appropriate to modality; safe areas, drag/keyboard dismissal, focus lifecycle, text scaling, and reduced motion. |
| `dropdown_menu` | P0 | Thin composition over native Menu infrastructure; complete keyboard/submenu/check/radio/disabled semantics and focus restoration. |
| `hover_card` | P0 | Hover may preview but focus/tap must reach identical content; dismissal timing, nonmodal focus behavior, placement/resize, semantic duplication, remove unused fixed width. |
| `menu` | P0 | Authoritative menu engine: roving focus, arrows/Home/End/typeahead, submenu direction/RTL, roles/states, pointer+touch, placement, focus restore; delete zero-duration CSS quirks. |
| `menubar` | P0 | Native composite focus model across top-level menus, arrow switching, Escape hierarchy, mnemonic/typeahead policy, touch alternative, semantics, and nonzero intentional feedback. |
| `popover` | P0 | Shared nonmodal lifecycle: anchor tracking, outside dismissal, Escape, optional focus entry, trigger restoration, scroll/resize and safe-area placement. |
| `select` | P0 | Noneditable select semantics, selected value announcement, complete keys, shared menu/overlay behavior, long option layout, focus restore, remove class-order styling. |
| `sheet` | P0 | Shared modal lifecycle and native route/insets; drag/dismiss policy, focus trap/restore, keyboard and safe area, flexible header/footer, reduced motion. |
| `tooltip` | P0 | Hover/focus/long-press parity, semantic description without duplicate speech, delay/dismiss rules, placement, no interactive content, reduced motion. |

### General components — navigation and layout

| Entry | Priority | Native Flutter action and acceptance |
|---|---|---|
| `aspect_ratio` | P3 | Keep Flutter geometry semantics; validate invalid ratios/constraints and docs. It owns no typography or interaction. |
| `button_group` | P1 | Remove descendant-selector/CVA assumptions; semantic grouping, connected-border geometry, flexible wrapping, keyboard behavior inherited from children, delete unreachable nesting rules. |
| `navigation_menu` | P0 | Replace hover-dominant web navigation with pointer/touch/keyboard paths, correct composite focus, panel semantics, responsive alternative, and remove reproduced drifts. |
| `pagination` | P1 | Navigation semantics/current page, descriptive labels, keyboard/touch targets, compact responsive strategy without tiny type, disabled boundaries, and long page counts. |
| `resizable` | P1 | Native drag plus keyboard resizing, adjustable semantics, min/max constraints, RTL/axis handling, 44px effective handle, pointer cursors, persistence callbacks. |
| `safe_area` | P1 | Validate MediaQuery inset consumption, nested idempotence, keyboard/system gesture insets, edge selection, and page/overlay integration. |
| `scroll_area` | P0 | Clarify specialized contract, native scrollbars/controllers/semantics, keyboard/wheel/touch, nested-scroll rules, no IntrinsicWidth/LayoutBuilder trap, large content. |
| `sidebar` | P0 | Remove reproduced drift register and 11.5px nav; responsive rail/drawer structure, keyboard navigation, current semantics, focus, touch rows, safe area, scaled text, persistence. |
| `tabs` | P0 | One Tab stop with arrows/Home/End, selected/tab-panel semantics, focus/activation policy, scrollable/wrapping narrow behavior, 44px targets, indicator reduced motion. |

### Effects and low-level interaction entries

| Entry | Priority | Native Flutter action and acceptance |
|---|---|---|
| `action_feedback` | P1 | Retain only as reusable pressed/focus feedback; remove pseudo-element/CSS-state modelling, connect to shared control state, reduced motion and repaint isolation. |
| `active_indicator` | P1 | Constraint-based measurement, stable first frame, RTL, resize/reorder handling, reduced motion/TickerMode, semantic state remains on the control—not indicator. |
| `ambient_pattern` | P2 | Decorative-only semantics/IgnorePointer, theme contrast, reduced motion/TickerMode, repaint boundaries, resize and performance; remove selector ancestry assumptions. |
| `background_effect` | P2 | Decorative-only, tokenized and theme-safe, no state meaning, resize/performance/reduced-motion validation; keep API small. |
| `content_change` | P1 | Native keyed content transition, correct identity/state preservation, size changes, focus preservation, reduced motion, and no CSS transition vocabulary in API. |
| `feedback_surface` | P0 | Largest drift concentration: replace pseudo-element and selector parity with explicit Flutter layers/state; theme/repaint/reduced-motion tests; remove unreachable branches. |
| `glass` | P1 | Validate actual BackdropFilter behavior and fallback rather than CSS blur assumptions; contrast in both themes, clipping/performance, no invisible redundant layers. |
| `hover_builder` | P0 | Keep hover reporting separate from activation; ensure consumers cannot accidentally create hover-only controls; lifecycle/cursor tests and touch-neutral behavior. |
| `icon_swap` | P1 | Native transition with stable layout/semantics, correct child identity, reduced motion/TickerMode, no CSS transform assumptions. |
| `keyframes` | P0 | Decide whether public exposure is justified. Prefer typed Flutter animations; remove CSS-keyframe implementation vocabulary, validate interpolation, loops, TickerMode, reduced motion, disposal. |
| `media_scrim` | P3 | Decorative/token surface; validate contrast purpose, IgnorePointer/semantics, clipping and both themes. |
| `premium_surface` | P0 | Replace pseudo-element/hover CSS parity with explicit Flutter composition; effects subordinate to meaning, reduced motion, theme/contrast, performance, remove no-op branches. |
| `press` | P0 | Make visual press a layer of a complete control, or clearly noninteractive when callback absent; keyboard/focus/semantics/target contract, reduced motion and cancellation. |
| `surface` | P2 | Keep as tokenized visual primitive; validate clipping, border/shadow composition, theme changes and semantics neutrality; remove CSS box-model reasoning from public docs. |

### Charts

| Entry | Priority | Native Flutter action and acceptance |
|---|---|---|
| `chart` | P0 | Provide semantic summary/table alternative, series labels beyond color, locale formatting, empty/loading/error states, scale/text/theme/contrast and interaction policy. Remove selector-derived axis behavior. |
| `chart_cartesian` | P1 | Native painters/layout, axis/label collision strategy, touch+keyboard exploration, RTL, resize, large datasets, semantics delegated through chart contract. |
| `chart_geometry` | P2 | Keep pure tested math; property/edge tests for NaN/infinity/zero ranges, precision and bounds; no UI or web-coordinate assumptions leak publicly. |
| `chart_polar` | P1 | Native painter/layout, label collision and tiny-slice policy, noncolor identification, touch+keyboard exploration, resize/RTL and semantic summary. |

### Agent and voice entries

| Entry | Priority | Native Flutter action and acceptance |
|---|---|---|
| `agent_attach_menu` | P0 | Compose corrected Menu/Attachment contracts; keyboard/touch invocation, permissions/errors, focus restore, file-type labels and no hover-only actions. |
| `agent_attachments` | P1 | Responsive list/grid, file semantics, download/remove/retry states, long names, progress announcements, touch targets, and no silent actions. |
| `agent_avatar` | P1 | Decorative versus meaningful semantics, state conveyed beyond color/motion, reduced motion/TickerMode, theme/contrast, sizing and shader/painter performance. |
| `agent_composer` | P0 | Native text editing/IME/keyboard inset, send/stop/attachment focus order, submitting lock, shortcuts without platform conflicts, validation, long text and error announcements. Remove DOM/drop assumptions. |
| `agent_console` | P0 | Block-level regional state contracts, responsive shell, one scroll owner, safe areas/keyboard, focus traversal, loading/empty/error/reconnect, Toaster ownership and 200% stress. |
| `agent_core` | P1 | Keep domain/controller layer UI-free; typed states/errors/events, disposal, cancellation, concurrency and deterministic tests. Remove web-domain naming only where public meaning improves. |
| `agent_face` | P1 | State semantics separate from animation, reduced motion, theme/contrast, painter/shader fallback and performance; decorative internals excluded. |
| `agent_history` | P0 | Native list performance and scroll, rename/delete focus, keyboard/touch actions, confirmation/undo, empty/filter/error states, announcements and responsive structure. |
| `agent_launcher` | P0 | Replace `vw/rem` dialog calculations with constraints/breakpoints; corrected Dialog lifecycle, trigger semantics/focus restore, narrow full-screen form, keyboard/safe-area behavior. |
| `agent_markdown` | P0 | Native selectable rich text, links/code semantics and activation, copy, wrapping/overflow, headings/lists/tables, syntax contrast, large input performance and safe parsing. Remove Preflight assumptions. |
| `agent_slash_palette` | P0 | Compose corrected Command engine; remove documented no-op behavior, native filtering/keys, result announcements, empty state, focus return and IME compatibility. |
| `agent_transcript` | P0 | Semantic message order/live updates, scalable typography, native scrolling/anchoring, tool/error disclosures, copy/actions, long code/media and no CSS type collapse. |
| `voice` | P0 | Explicit permission/device/error/state machine, start/stop keyboard+semantics, announcements, lifecycle/background handling, reduced motion and platform capability fallbacks. |
| `voice_indicator` | P1 | Status expressed in text/semantics rather than orb color/motion, reduced motion/TickerMode, shader fallback/performance, resize/themes and decorative child exclusion. |

### Remaining catalog/support entries

| Entry | Priority | Native Flutter action and acceptance |
|---|---|---|
| `source_foundation` | P1 | Not a widget: regenerate from corrected authored foundation, accurate two-font/type/motion/theme contract, install rehearsal, hashes/licenses and immutable version policy. |
| `icon` | P1 | Meaningful icon requires label; decorative icon excluded; consistent Flutter sizing/stroke/tone, RTL mirroring where appropriate, scalable surrounding target, no DOM prop-loss parity. |
| `icon_paths` | P2 | Keep generated/source ownership explicit, validate every glyph and parser contract, do not expose generated index internals unnecessarily, no manual edits to generated files. |

## Workstream 3 — Migrate by dependency-safe batches

Do not work alphabetically. Use these batches so shared fixes compile once and
leaf components do not implement temporary behavior:

1. **Foundation:** typography/text layout, semantic color separation, shadows,
   motion, constraints, package SDK floor.
2. **Interaction kernel:** `Press`, `HoverBuilder`, activation/focus/semantics,
   selection-control state, overlay lifecycle, motion player.
3. **Simple primitives:** Icon, AspectRatio, Separator, Surface, Card, Marker,
   Avatar, Badge, Alert, Kbd, Progress, Stat, Empty, Skeleton, Spinner.
4. **Actions and selection:** Button, ButtonGroup, Toggle/ToggleGroup,
   Checkbox, Radio, Switch, Slider, Item.
5. **Fields/forms:** Field, Form, Input, Textarea, InputGroup, InputOtp,
   NativeSelect, ValidationRule, Questionnaire.
6. **Overlay/menu family:** Dialog, AlertDialog, Sheet, Drawer, Popover,
   HoverCard, Tooltip, Menu, Menubar, DropdownMenu, ContextMenu, Select,
   Combobox, Command, UserMenu.
7. **Navigation/layout/data:** Accordion, Collapsible, Breadcrumb, Pagination,
   Tabs, NavigationMenu, Sidebar, SafeArea, ScrollArea, Resizable, Carousel,
   Table, Calendar.
8. **Messaging/content:** Attachment, Bubble, Message, MessageScroller,
   AgentMarkdown.
9. **Effects/charts:** effect matrix, Chart core/geometry/cartesian/polar.
10. **Agent/voice:** agent matrix and AgentConsole block.
11. **Docs/distribution:** all 99 pages, source foundation, skills, registry,
    changelog, README, release facts.

For each batch:

1. Update the audit ledger rows to `in progress`.
2. Write/adjust the native component contract before changing implementation.
3. Change all source files in the batch coherently.
4. Format once.
5. Run the smallest root test group that owns the behavior plus the matching
   example component-doc tests in one command.
6. Run `test/token_guard_test.dart` only when visual code/foundation changed.
7. Mark rows complete only with automated and visual evidence.

Do not regenerate the registry or build the web app after each batch.

## Workstream 4 — Replace parity tests with product-contract tests

1. Preserve useful behavioral tests, but remove assertions whose sole reason is
   a measured browser defect, class-order artifact, no-op transition, or
   inaccessible rendered result.
2. Add reusable test harnesses for:

   - focus entry/trap/restore;
   - Enter/Space and composite arrow navigation;
   - semantics label/role/value/state/actions;
   - 44×44 effective targets;
   - long and localized text at scale 1 and 2;
   - light/dark contrast pair selection;
   - reduced motion and `TickerMode`;
   - narrow/tablet/wide structure;
   - overlay placement, resize, insets, and trigger disposal;
   - async announcements and double-submit prevention.

3. Create an authored-source architecture guard that fails for new executable
   dependencies on `CVA`, `tailwind-merge`, Preflight inheritance, DOM
   selectors, web class ordering, and comments that declare a known defect is
   intentionally reproduced. Allow factual migration history only inside the
   audit/changelog.
4. Keep generated icon/registry files out of authored-source scans; validate
   them with their generators and dedicated tests.
5. Correct the Flutter UI director's verification text if it still claims
   Skeleton/Spinner ignore reduced motion after their actual implementations
   prove otherwise.

## Workstream 5 — Documentation and distribution

For every changed component:

1. Update its source doc block with usage, API, variants, states, keyboard,
   semantics, responsive behavior, and theming.
2. Update its `example/lib/components_docs/<name>/` page and metadata. Lead with
   native Flutter usage; remove CSS classes, DOM selectors, and parity drift as
   consumer guidance.
3. Show all meaningful variants/states, narrow and wide behavior, 200% text,
   light/dark, and a pasteable current API example.
4. Update Typeset, Theming, Introduction, CLI/registry installation facts,
   README, CHANGELOG, CONTRIBUTING, and the Flutter UI director skill anywhere
   the old architecture is described.
5. Rebuild registry output once from authored sources after the full source
   tree stabilizes. Validate dependencies, hashes, licenses, source links,
   consumer import rewriting, and a clean CLI install.

## Token- and compile-efficient verification strategy

Flutter compilation is expensive; broad search and coherent editing are cheap.
Use this order:

1. One repository inventory and ledger.
2. One coherent source batch at a time.
3. One focused root test invocation and one focused example invocation per
   batch—not one Flutter process per file.
4. No release web build and no full root/example suite while intermediate
   batches are knowingly broken.
5. One registry regeneration after authored source stabilizes.
6. One final expensive ladder after all focused gates pass.

Avoid `pumpAndSettle` with repeating effects. Pump fixed token durations. Tests
must not disable text scaling or clip content to manufacture a pass.

## Final verification ladder

After every matrix row is complete and focused tests are green:

```powershell
dart format <all changed Dart files in one invocation>
flutter analyze
flutter test
Push-Location example
flutter analyze
flutter test
flutter build web --release
Pop-Location
git diff --check
```

Then run:

1. registry builder/client validation and the release audit;
2. the UI completeness scanner over authored product/docs code;
3. native architecture negative searches;
4. CLI clean-consumer rehearsal: initialize source foundation, install a
   representative dependency-heavy set, analyze, run tests, and run doctor;
5. visual matrix at 390×844, 834×1112, and 1440×900, both themes, text scale 1
   and 2, including overlays, forms, navigation, chart, agent console, and the
   complete Typeset page;
6. pointer, touch-equivalent, keyboard-only, and semantics inspection for all
   interactive families;
7. performance sampling for large lists, markdown, charts, shaders, and
   repeating effects.

## Required Cloud handoff

Report:

1. release state and supported Flutter/Dart floor;
2. audit ledger totals: keep/translate/fix/remove/document and every completed
   component row;
3. foundation/API changes and migrations;
4. native interaction, overlay, focus, semantics, responsive, and motion
   contracts implemented;
5. files changed by batch;
6. focused tests and final ladder results exactly as run;
7. visual/accessibility/performance evidence;
8. registry and clean-consumer install evidence;
9. remaining limitations and owner-only release actions.

Completion means all 99 catalog entries, the AgentConsole block, support files,
foundations, docs, and generated distribution have evidence. A green analyzer
or a visual spot-check of five components is not completion.
