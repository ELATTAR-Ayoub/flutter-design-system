# Semantic Public API Naming Implementation Plan

> **For agentic workers:** use `superpowers:subagent-driven-development` or
> `superpowers:executing-plans` when those skills are available. They were not
> available while this plan was authored, so the repository's established
> Superpowers plan format and `elattar-flutter-ui-director` contract were used
> directly.

**Goal:** Give the Flutter design system an open-code, copy-first API whose
public names are familiar, unbranded, semantic, reusable, and stable when a
consumer changes the visual implementation.

**Architecture:** Freeze the public contract first. Shrink accidental exports,
rename the foundation, replace appearance-shaped motion and effect names with
job-shaped names, remove the `El`/`el` brand prefix, update every registry and
documentation surface, then enforce the result with generated API, usage,
token, collision, and registry tests.

**Authoritative baseline:** local `main` at `f6f51eb` on 2026-08-28. The
Flutter package, registry, tests, and example app are authoritative. The prior
web project is lineage only.

This plan supersedes `2026-08-26-public-api-naming.md` for future
implementation. The older document remains historical context only.

**References:**

- [shadcn/ui introduction](https://ui.shadcn.com/docs): open code,
  composition, flat-file distribution, predictable APIs.
- [shadcn/ui theming](https://ui.shadcn.com/docs/theming): semantic surface /
  foreground pairs, one radius source, replaceable token values.
- [shadcn/ui components](https://ui.shadcn.com/docs/components): familiar
  component nouns such as Button, Card, Dialog, Input, Table, and Tooltip.
- [Dart libraries and imports](https://dart.dev/language/libraries): import
  prefixes and `show` / `hide` resolve unavoidable Flutter name conflicts.

## Structure

### Structural goal

Use shadcn's ownership model in Flutter form:

- `init` installs the complete shared foundation once;
- `add <ui-item>` installs the requested UI file and only its transitive UI
  dependencies;
- `add <block>` installs a complete application composition and its transitive
  UI dependencies;
- installed source belongs to the consumer and remains editable;
- the CLI never silently overwrites consumer changes;
- repository sources, logical registry targets, and consumer destinations have
  a direct, documented mapping.

The **foundation is not the whole design system**. It contains tokens, theme,
and theme delivery. `init` must not install Button, Card, effects, motion
widgets, agent UI, or blocks.

### Repository layout

Move the authoritative package sources to this layout:

```text
lib/
├─ elattar_design_system.dart       # package barrel; product name may remain
└─ src/
   ├─ components/
   │  └─ ui/                        # every reusable installable UI primitive
   │     ├─ button.dart
   │     ├─ card.dart
   │     ├─ active_indicator.dart
   │     ├─ press.dart
   │     ├─ surface.dart
   │     ├─ premium_surface.dart
   │     └─ ...
   ├─ design_system/
   │  └─ foundation/                # shared typed Flutter foundation
   │     ├─ colors.dart
   │     ├─ spacing.dart
   │     ├─ radii.dart
   │     ├─ typography.dart
   │     ├─ shadows.dart
   │     ├─ motion.dart             # values only: durations, curves, transforms
   │     ├─ theme.dart
   │     └─ theme_scope.dart
   ├─ blocks/
   │  └─ agent_console/             # complete opt-in application composition
   │     └─ agent_console.dart
   └─ internal/                     # non-distributed package tooling only
```

Rules:

1. `components/ui/` stays flat, matching shadcn's easy-to-find component
   directory. Use `snake_case.dart`; the main public type uses `UpperCamelCase`.
2. Visual effects and motion widgets are UI primitives. Remove the separate
   `lib/src/components/ui/` and `lib/src/components/ui/` distribution categories.
3. Foundation motion **values** remain in `foundation/motion.dart`; widgets
   such as `Press`, `ContentChange`, and `ActiveIndicator` live in
   `components/ui/`.
4. Move `theme_scope.dart` into foundation. Fold `text_layout.dart` into
   `typography.dart` unless the inventory proves it needs an independently
   editable public contract.
5. A block composes UI primitives but is not exported as a package primitive.
   Installing one small agent primitive must not install AgentConsole.
6. Prefer one source file per registry item. Multiple files are allowed only
   for generated data, shaders, or a block whose pieces are independently
   understandable and editable.

Mechanical path map:

| Current repository path | Future repository path |
| --- | --- |
| `lib/src/components/*.dart` | `lib/src/components/ui/*.dart` |
| `lib/src/components/ui/*.dart` | `lib/src/components/ui/*.dart` |
| `lib/src/components/ui/*.dart` | `lib/src/components/ui/*.dart` |
| `lib/src/foundation/*.dart` | `lib/src/design_system/foundation/*.dart` |
| `lib/src/design_system/foundation/theme_scope.dart` | `lib/src/design_system/foundation/theme_scope.dart` |
| `lib/src/design_system/foundation/text_layout.dart` | merge into `lib/src/design_system/foundation/typography.dart`, unless inventory retains it |
| `lib/src/blocks/agent_console/agent_console.dart` | `lib/src/blocks/agent_console/agent_console.dart` |

Apply semantic filename renames from the API rename map during the same scripted
move only when old and future paths are both explicit. Do not infer filenames
from class names at runtime.

### Consumer layout

After `init` and selected `add` commands, a consumer receives:

```text
elattar.yaml
.elattar/
└─ manifest.json
lib/
├─ components/
│  └─ ui/
│     ├─ ui.dart                    # consumer-owned stable entry point
│     ├─ ui.g.dart                  # CLI-owned generated exports
│     └─ <installed-ui-files>.dart
├─ design_system/
│  ├─ foundation.dart              # consumer-owned stable entry point
│  ├─ foundation.g.dart            # CLI-owned generated exports
│  └─ foundation/
│     ├─ colors.dart
│     ├─ spacing.dart
│     ├─ radii.dart
│     ├─ typography.dart
│     ├─ shadows.dart
│     ├─ motion.dart
│     ├─ theme.dart
│     └─ theme_scope.dart
└─ blocks/
   └─ <installed-block>/
      └─ ...
assets/
└─ ui/                              # only assets required by installed items
shaders/
└─ ui/                              # only shaders required by installed items
LICENSES/                           # standard third-party notices
```

`ui.dart` contains `export 'ui.g.dart';` and may contain consumer exports. The
CLI edits only `ui.g.dart`. Apply the same rule to `foundation.dart` and
`foundation.g.dart`; never parse and reconstruct a consumer-owned barrel.

### Registry routing

| Registry kind | Logical target | Default consumer destination | Meaning |
| --- | --- | --- | --- |
| foundation | `@foundation/` | `lib/design_system/foundation/` | Installed completely by `init` |
| ui | `@ui/` | `lib/components/ui/` | Reusable component, effect, or motion widget |
| block | `@block/` | `lib/blocks/<name>/` | Complete application composition |
| asset | `@asset/` | `assets/ui/` | Item-owned binary/static asset |
| shader | `@shader/` | `shaders/ui/` | Item-owned Flutter shader |
| license | `@license/` | `LICENSES/` | Human- and scanner-readable notice |

Delete `effect`, `motion`, and `shot` as installation kinds. Their replacements
are `ui` and `block`. Registry documentation may still group UI items by
capability, but category labels do not change their install directory.

### Initialization and add behavior

`elattar init` installs exactly:

1. `elattar.yaml` and `.elattar/manifest.json`;
2. the complete foundation source and its generated barrel;
3. foundation fonts and licenses;
4. required `pubspec.yaml` registrations;
5. empty stable UI entry/barrel files.

It installs no UI component or block.

`elattar add button` then installs the Button dependency closure only. Target
closure after the planned consolidation:

| File | Reason |
| --- | --- |
| `button.dart` | Requested component |
| `spinner.dart` | Public reusable loading feedback |
| `surface.dart` | Shared semantic surface renderer |
| `premium_surface.dart` | Required by the `premium` variant |
| `action_feedback.dart` | Required interactive feedback |
| `ui.g.dart` | Regenerated export list; not implementation |

The target is five implementation files plus one generated-barrel update after
`init`. Do not preserve today's nine-file Button closure merely because it
exists: make Spinner independent of the four-file icon catalog unless its
public contract genuinely requires those icons.

Agent installation remains granular:

| Command | Installs |
| --- | --- |
| `add agent-avatar` | AgentAvatar and direct UI dependencies only |
| `add agent-composer` | AgentComposer and direct UI dependencies only |
| `add voice-indicator` | VoiceIndicator plus required asset/shader dependencies |
| `add agent-console` | The AgentConsole block and its complete transitive UI closure |

### Configured paths and ownership

Restore path configuration only when it is real and enforced. `init` writes
the selected project-relative paths; every later command reads them. Defaults:

```yaml
paths:
  ui: lib/components/ui
  foundation: lib/design_system/foundation
  blocks: lib/blocks
  assets: assets/ui
  shaders: shaders/ui
```

Reject absolute paths, traversal, overlapping destinations, Dart destinations
outside `lib/`, and changes that disagree with the installed manifest. Paths
are chosen at `init`; changing them later requires an explicit migration
command, not an ordinary `add`.

`.elattar/manifest.json` remains the ownership ledger. Each record stores the
logical target, resolved destination, registry version, installed hash, and
current ownership state.

### CLI safety contract

| Operation | Required behavior |
| --- | --- |
| `add --dry-run` | Show complete dependency closure and every destination |
| `add` with identical file | No-op |
| `add` with unknown existing file | Stop before any write |
| `add` with consumer-modified managed file | Stop and show conflict |
| `add --overwrite` | Replace only destinations in this command's manifest plan |
| `update` | Update unchanged managed files; report customized files |
| `remove` | Delete only unchanged files owned solely by removed items |
| barrel generation | Edit only `*.g.dart`; preserve consumer entry files |
| failed plan | Perform zero partial writes |

The installer must plan and validate the complete transaction before writing.
Tests must cover path configuration, dependency closure, shared dependencies,
customized-file conflicts, traversal rejection, barrel preservation, atomic
failure, update, and removal.

## Non-negotiable naming contract

1. **No brand prefix in installed UI code.** `Button` becomes `Button`;
   `el(6)` becomes `space(6)`. The package and CLI may retain their product
   names; installed component APIs do not.
2. **Name the enduring job, not today's rendering.** `SlidingPillGroup`
   becomes `ActiveIndicator`; the indicator may later be an underline, border,
   glow, or fill without an API rename.
3. **Use the ordinary component noun.** Follow shadcn where the same concept
   exists: `Button`, `Card`, `Dialog`, `Input`, `Popover`, `Table`, `Tooltip`.
4. **Keep semantic variants.** `ButtonVariant.primary`, `secondary`,
   `outline`, `ghost`, `destructive`, `link`, and the system's `premium`
   remain valid. Do not use `normal` when `primary`, `neutral`, or `default`
   meaning can be stated.
5. **One thing has one name.** Registry item, Dart file, primary class, docs
   directory, route, install command, and generated payload agree.
6. **Do not export transcription debris.** A public symbol must be a usable
   component, model, controller, semantic token, or documented composition
   primitive. Painters, shader programs, measured clocks, and unused keyframe
   tables stay internal.
7. **Every public token has a real consumer.** A token introduced in a task is
   consumed by production code in that task. Tests and docs do not count as
   consumers.
8. **Same value does not mean same contract.** `open` and `expand` may both be
   420 ms today but remain separately named because consumers must be able to
   retune them independently.
9. **No visual literals escape the foundation/effect owner.** Colors,
   typography, spacing, radii, shadows, durations, curves, and transforms are
   token-fed. Effect-specific literals may live in the owning effect file only
   when the token guard records that policy explicitly.
10. **Accessibility is part of the API.** Disabled, focused, selected,
    loading, empty, error, success, reduced-motion, keyboard, and semantic-label
    behavior survive every rename.

## Measured baseline and completion definition

| Fact | Baseline |
| --- | ---: |
| `El*` declarations under `lib/src/` | 574 |
| exports advertised by docs metadata | 579 |
| registry items including foundation | 99 |
| component items | 84 |
| effect items | 9 |
| motion items | 5 |
| direct collisions after blindly stripping `El` | 26 Flutter SDK types |

Completion means:

- no exported identifier starts with `El` or `el`;
- no registry/docs export names a symbol absent from the public contract;
- every public token has at least one non-test, non-doc production consumer;
- every exception to the semantic naming rules is documented in one allowlist;
- package, example, CLI, registry builder, release audit, and generated registry
  are green and reproducible;
- visual review covers light/dark, narrow/wide, focus, disabled, error,
  loading, and reduced motion.

## Exhaustive default rename rule

After the exceptions in this document are applied, **every remaining public
`X` identifier becomes `X` with no other spelling change**. This rule covers
the hundreds of already-good names such as:

| Current | Future |
| --- | --- |
| `Button` | `Button` |
| `ButtonVariant` | `ButtonVariant` |
| `CardHeader` | `CardHeader` |
| `DialogDescription` | `DialogDescription` |
| `InputGroupAddon` | `InputGroupAddon` |
| `SidebarMenuButton` | `SidebarMenuButton` |
| `AgentComposer` | `AgentComposer` |
| `ChartTooltipContent` | `ChartTooltipContent` |

Add a generated `tool/api_inventory/` snapshot before changing names. The
snapshot is the exhaustive ledger: current symbol, future symbol, disposition
(`keep`, `rename`, `merge`, `hide`), owning registry item, and Flutter collision
status. The implementation may not rename a symbol absent from that ledger or
finish with an unresolved row.

## Import and Flutter-collision contract

Normal names are allowed even when Flutter owns the same noun. `Button` has no
Flutter collision in Flutter 3.44.8; `Card`, `Dialog`, `Switch`, `Table`,
`Tooltip`, and others do.

```dart
// No collision: direct and bare.
import 'components/ui/button.dart';

Button(...);

// Collision: qualify only this import.
import 'components/ui/card.dart' as ui;

ui.Card(...);
```

The docs must show both direct and qualified imports. Add a generated collision
test against the installed Flutter SDK so a future Flutter release cannot add a
conflicting type silently. Do not reintroduce a permanent prefix merely to
avoid a local import decision.

## Theme and color contract

### Public theme types

| Current | Future | Decision |
| --- | --- | --- |
| `ThemeData` | `ThemeTokens` | The object is a semantic token set, not Flutter `ThemeData`. |
| `Theme` | `ThemeScope` | It is an inherited scope and avoids Flutter `Theme`. |
| `ThemeController` | `ThemeController` | Controls the user's color-mode choice. |
| `ThemeMode` | `ColorMode` | Values remain `light`, `system`, `dark`; avoids Flutter `ThemeMode`. |
| `ThemeKind` | `ResolvedColorMode` | The resolved result has only `light` and `dark`. |
| `Palette` | `Palette` (internal export) | Raw ramps remain editable source but leave the normal consumer barrel. |
| `Oklab` | `OklabColor` (advanced export) | Accurate color utility; not a theme role. |
| `elHsl(...)` | `hslColor(...)` | Clear constructor helper. |
| `elTransparent` | `transparentColor` | Brandless and explicit. |

### Shadcn-parity theme tokens — keep these spellings

| Surface | Foreground / companion |
| --- | --- |
| `background` | `foreground` |
| `card` | `cardForeground` |
| `popover` | `popoverForeground` |
| `primary` | `primaryForeground` |
| `secondary` | `secondaryForeground` |
| `muted` | `mutedForeground` |
| `accent` | `accentForeground` |
| `destructive` | `destructiveForeground` |
| `sidebar` | `sidebarForeground` |
| `sidebarPrimary` | `sidebarPrimaryForeground` |
| `sidebarAccent` | `sidebarAccentForeground` |

Keep `border`, `input`, `ring`, `chart1`–`chart5`, `sidebarBorder`,
`sidebarRing`, and `radius`.

### Extended semantic tokens

These extend shadcn for this system. They are roles, not fixed colors.

| Current | Future | Meaning |
| --- | --- | --- |
| `actionText` | `actionText` | High-contrast action color used as text/icon on neutral surfaces. |
| `premiumText` | `premiumText` | High-contrast premium/value color on neutral surfaces. |
| `successText` | `successText` | Success text/icon color on neutral surfaces. |
| `warningText` | `warningText` | Warning text/icon color on neutral surfaces. |
| `infoText` | `infoText` | Information text/icon color on neutral surfaces. |
| `destructiveText` | `destructiveText` | Destructive text/icon color on neutral surfaces; distinct from text on a destructive fill. |
| `messageAccent` | `messageAccent` | Accent surface for an emphasized message. |
| `messageAccentHover` | `messageAccentHover` | Hover state of that message surface. |
| `agent` | `agentAccent` | Agent-family accent role. |
| `agentAccentMuted` | `agentAccentMuted` | Quiet agent-family accent role. |
| `scrim` | `scrim` | Generic media/overlay scrim role; already semantic. |

### Remove from the public theme

Move these to their sole owner and exclude them from the barrel:

- `pageGlow` → owned by `BackgroundEffect`;
- `ink1`–`ink4`, `rim`, `rimStrong`, `wall` → owned by shadow recipes;
- `cube` / `AgentCubeTokens` → owned by `AgentAvatar` implementation;
- `bloomVoid`, `bloomL`, `bloomC`, `bloomLift`, `bloomHotC` → owned by
  `FeedbackSurface`;
- `starGlowSize`, `starGlowMix` → owned by `AmbientPattern`.

## Spacing, sizing, radius, and layout contract

### Base spacing

| Current | Future | Meaning |
| --- | --- | --- |
| `el(n)` | `space(n)` | `n × 4` logical pixels; `space(6) == 24`. |

`space()` is the only numeric spacing scale. Semantic component padding may be
derived from it, but must not create a second global scale.

### Split the misleading `Widths` bucket

`Widths` currently contains widths, one height, a border width, and a scroll
offset. Replace it with truthful owners:

| Current | Future |
| --- | --- |
| `Widths.shell` | `LayoutWidths.shell` |
| `content` | `LayoutWidths.content` |
| `page` | `LayoutWidths.page` |
| `prose` | `LayoutWidths.prose` |
| `rail` | `LayoutWidths.rail` |
| `article` | `LayoutWidths.article` |
| `sidebar` | `LayoutWidths.sidebar` |
| `sidebarIcon` | `LayoutWidths.sidebarCollapsed` |
| `sidebarMobile` | `LayoutWidths.sidebarMobile` |
| `siteHeader` | `LayoutHeights.siteHeader` |
| `hairline` | `BorderWidths.hairline` |
| `scrollOffset` | `ScrollOffsets.anchoredHeading` |

### Geometry families

| Current | Future | Member decisions |
| --- | --- | --- |
| `Radii` | `Radii` | Keep `xs`, `sm`, `md`, `lg`, `xl`, `xl2`, `xl3`, `xl4`; `pill` → `full`. |
| `Radii.addonButton` | private derived value | Used by one InputGroup implementation; not a global radius. |
| `Blurs` | `Blurs` | Keep `xs`, `xl` until more real rungs exist. |
| `Containers` | `Containers` | Keep `xs`, `sm`, `md`, `xl2`. |
| `Breakpoints` | `Breakpoints` | Keep `sm`, `md`, `lg`, `xl`. |
| `MediaRatios` | `AspectRatios` | Keep `portrait`; add no unused ratios. |
| `SurfaceOpacity` | internal Glass recipe | `glassPanel` and `navigationGlass` are implementation values, not universal surface roles. |
| `MediaScrimTokens` | internal `MediaScrim` recipe | Its colors/stops belong to that effect. |

`Radii.full` means the maximum rounding available. It does not assume the
active indicator or every control is pill-shaped.

## Typography contract

### Public types

| Current | Future |
| --- | --- |
| `Fonts` | `Fonts` |
| `TypeSpec` | `TextStyleToken` |
| `TypeColor` | `TextColorRole` |
| `Type` + `ComponentType` | one `TextStyles` class |
| `Text` | `StyledText` |
| `CalendarType` | internal Calendar text recipes |

There is one text-style namespace. The current split has 65 styles with no
shared member names and forces users to guess which class owns a role.

### Role renames

Every unlisted typography member keeps its current member name while moving to
`TextStyles`.

| Current member | Future member | Reason |
| --- | --- | --- |
| `label` | `eyebrow` | Section eyebrow role; it may cease being uppercase without a rename. |
| `micro` | `eyebrowSmall` | Smaller rung of the same role. |
| `textSm` | `bodySmall` | Actual job across many components. |
| `sheetBody` | `bodyCompact` | Used by dialogs, selects, inputs, messages, and drawers—not only sheets. |
| `serial` | `identifier` | Identifiers/paths, not necessarily serial numbers. |
| `numXs` | `numberXs` | Expand unclear abbreviation. |
| `numSm` | `numberSm` | Same. |
| `numBase` | `numberBase` | Same. |
| `numMd` | `numberMd` | Same. |
| `numLg` | `numberLg` | Same. |
| `numXl` | `numberXl` | Same. |
| `inputNum` | `inputNumber` | Expand abbreviation. |
| `messageMeta` | `messageMetadata` | Expand abbreviation. |
| `attachmentTitleSm` | `attachmentTitleSmall` | Avoid a one-off size abbreviation in a semantic role. |

Before merging, compare `body` and `bodyCompact`, plus `badge` and
`badgeLabel`. If two recipes are byte-identical and have the same job, retain
one name. If values differ, keep both semantic roles; do not merge merely
because numbers happen to match today.

## Shadow and surface contract

### Shadow types

| Current | Future |
| --- | --- |
| `ShadowLayer` | `ShadowLayer` |
| `ShadowSpec` | `ShadowStyle` |
| `Shadows` | `Shadows` |

### Public shadow recipes

| Current | Future | Meaning |
| --- | --- | --- |
| `none` | `none` | No shadow. |
| `e1` | `sm` | Small elevation. |
| `e2` | `md` | Medium elevation. |
| `e3` | `lg` | Large elevation. |
| `e4` | `xl` | Largest system elevation. |
| `key` | `keyRaised` | Raised keyboard/key surface. |
| `keyDown` | `keyPressed` | Pressed key surface. |
| `pressed` | `inset` | Generic inset/recessed surface. |
| `btn` | `control` | Default interactive-control surface. |
| `btnPrimary` | `controlPrimary` | Primary control surface. |
| `btnValue` | `controlPremium` | Premium control surface. |
| `btnDown` | `controlPressed` | Pressed interactive-control surface. |
| `chip` | `compactControl` | Compact interactive surface. |

`tailwindSm`, `tailwindMd`, `tailwindLg`, and `tailwindXl` are source-lineage
names, not system contracts. Move their exact values to private compatibility
recipes used by the components that currently reproduce them. Move
`glowAction`, `glowValue`, and `pulseLiveRing` to `ActionFeedback`,
`PremiumSurface`, and the live-indicator owner respectively.

### Surface renderer

| Current | Future | Decision |
| --- | --- | --- |
| `MachineSurface` | `Surface` | Paints a supplied fill, border, radius, and `ShadowStyle`, including inset layers. |

Do **not** add a closed `SurfaceVariant` enum. The current renderer has dozens
of legitimate combinations across inputs, dialogs, badges, progress, sliders,
switches, overlays, and effects. Component semantics stay on the component;
`Surface` remains the low-level editable renderer.

## Motion contract

### Public motion namespaces

| Current | Future |
| --- | --- |
| `Durations` | `MotionDurations` |
| `Curves` | `MotionCurves` |
| `Transforms` | `MotionTransforms` |
| `elAnimationDuration(...)` | `effectiveMotionDuration(...)` |

`effectiveMotionDuration` applies `MediaQuery.disableAnimations`. Every
animation component must use it for visual motion; dwell/intent timers are
documented exceptions because removing them changes interaction behavior.

### Duration decisions

| Current | Future disposition | Real consumer |
| --- | --- | --- |
| `tick` | `fast` only if values/uses are consolidated; otherwise private compatibility value | Quick state transitions |
| `fast` | `fast` | General short transition |
| `base` + `transitionDefault` | one public `normal`; preserve separate private provenance only if fidelity requires it | Default component transitions |
| `slow` | `slow` | Deliberate long transition |
| `overlay` | split `overlayEnter`, `overlayExit` | Dialog/sheet/popover overlay directions |
| `jelly` | split `open`, `close`, `expand`, `collapse` | Dialog and Collapsible use their own phase names |
| `drawer` | split `drawerOpen`, `drawerClose` | Drawer directions |
| `tooltipDelay` | `tooltipShowDelay` | Tooltip hover intent |
| `hoverCardOpenDelay` | `hoverCardShowDelay` | HoverCard intent |
| `hoverCardCloseDelay` | `hoverCardHideDelay` | HoverCard exit grace |
| `pressDown` | `pressIn` | Pointer/key goes down |
| `pressSpringUp` | remove; currently has no production call site | None |
| `animJelly` | `stateChange` | ActiveIndicator, Sidebar, IconSwap, Checkbox, Radio |
| `frame` | private `MessageScroller` timing unit | Smooth-scroll distance calculation only |
| `attachmentSaving` | private `Attachment` success-hold duration | Attachment only |
| `reward` | private unless a reusable RewardFeedback component consumes it | No independent public contract |
| `popIn`, `springUp`, `signOn`, `ratchet`, `ratchetStep` | private or remove with unused preset tables | Transcription/demo presets |
| `spin` | private Spinner cycle | Spinner |
| `caret` | private InputOtp caret cycle | InputOtp |
| `checkDraw`, `dashDraw`, `dotPop` | private Checkbox/Radio feedback | Selection controls |
| `shimmer` | `loadingShimmer` only if shared by multiple production components | Skeleton/loading surfaces |
| `shimmerText` | private status-text effect | Agent/Attachment status text |
| `pulseLive` | private live-indicator cycle | Voice/live indicators |
| `bloom`, `sway`, `swayAlt`, `cosmicDriftDeep`, `cosmicDriftNear` | private FeedbackSurface/AmbientPattern clocks | Owning effects |
| `beatHover`, `beatPress` | private ActionFeedback clocks | ActionFeedback |
| `foilDrift`, `glint`, `glintHover` | private PremiumSurface clocks | PremiumSurface |

Do not create `hoverEnter` or `hoverExit` merely for symmetry. Add them only
when two or more production components share those timings, and replace their
existing timing expressions in the same commit.

### Curve decisions

| Current | Future | Job |
| --- | --- | --- |
| `standard` | `standard` | Default state change |
| `spring` | `emphasized` | Deliberate overshoot/response |
| `out` | `enter` | Fast start, gentle arrival |
| `curveIn` | `exit` | Gentle start, fast departure |
| `inOut` | `move` | Positional movement between established states |
| `settle` | `settle` | Non-overshooting arrival |
| `linear` | `linear` | Continuous cycles only |
| `outFlex` | internal unless a second clear role exists | Compatibility curve |
| `cssEase`, `cssEaseOut`, `cssEaseInOut`, `vaul` | private compatibility curves | Source/vendor fidelity, not public vocabulary |

### Transform decisions

Keep public only when consumers need to coordinate separate components:

| Current | Future disposition |
| --- | --- |
| `pressScale` | `MotionTransforms.press` |
| `buttonScale` | `MotionTransforms.buttonPress` |
| `clickSpringScale`, `pressSpringScale` | private in the owner unless a second real role exists |
| `sliderThumbHoverScale` | private Slider recipe |
| `sliderThumbActiveScale` | private Slider recipe |
| `liftY` | private InteractiveCard recipe |
| `keyDownY` | private key/surface recipe |
| `swapRollTravel` | private IconSwap recipe |

## Motion primitives and interaction utilities

| Current | Future | Why |
| --- | --- | --- |
| `Press` | `Press` | The job is pointer/keyboard press feedback; already semantic. |
| `Lift` | `HoverBuilder` | It only reports hover state; it does not itself require lift. |
| `LiftCard` | `InteractiveCard` | Stable role even if hover feedback stops lifting. |
| `SlidingPillGroup` | `ActiveIndicator` | Shows the active item; indicator shape and motion remain replaceable. |
| parameter `pill` | `indicator` | Any widget/shape. |
| `moveDuration` | `moveDuration` | Clear phase name. |
| `SwapIn` | `ContentChange` | Content replaces content in the same slot. |
| `IconSwap` | `IconSwap` | “Swap” is the job, not a visual material. |

`ActiveIndicator` keeps `activeIndex`; it is used by Tabs, ToggleGroup, theme
controls, and chart controls. Its docs must show an underline specimen in
addition to the current rounded fill to prove the API has no pill dependency.

### Keyframe API

Keep and rename the generic construction layer:

| Current | Future |
| --- | --- |
| `Steps` | `StepCurve` |
| `KeyframeFill` | `KeyframeFill` |
| `KeyframeStop<T>` | `KeyframeStop<T>` |
| `Keyframes` | `Keyframes` |
| `KeyframePlayer` | `KeyframePlayer` |

Hide or delete appearance/source-named preset tables unless a production
component needs them publicly: `PopIn`, `Jelly`, `SpringUp`, `JellyIn`,
`Ratchet`, `SignOnFrame`, `SignOn`, `Reveal`, `Shimmer`, `PulseLive`, `Sweep`,
`Travel`, `CheckDraw`, `DashDraw`, `DotPop`, `SwapRoll`. Component owners may
retain private semantic recipes.

Rename `JellyReplay` to a private `_StateChangeFeedback` wrapper inside the
selection-control implementation. The public reusable duration is
`MotionDurations.stateChange`; consumers do not need the old squash table.

## Effects contract

| Current item/class | Future item/class | Scope and variants |
| --- | --- | --- |
| `premium-surface` / `FoilValue` | `premium-surface` / `PremiumSurface` | Premium treatment; implementation may cease to be foil. |
| `action-feedback` / `SheenAction` | `action-feedback` / `ActionFeedback` | Hover/press response for actionable surfaces. |
| `feedback-surface` / `BloomCosmic` | `feedback-surface` / `FeedbackSurface` | `neutral`, `info`, `success`, `warning`, `error`, `loading`. Shared by Alert and Toast. |
| `surface` / `MachineSurface` | `surface` / `Surface` | General fill/border/inset/outer-shadow renderer. |
| `glass` / four classes | `glass` / one `Glass` | Explicit opt-in material with variants below. |
| `background-effect` / `PageGlow` | `background-effect` / `BackgroundEffect` | Page-level ambient treatment; implementation may change. |
| `starfield` / `Starfield` | `ambient-pattern` / `AmbientPattern` | Decorative ambient pattern; implementation may cease to be stars. |
| `voice-indicator` / `VoiceOrb` | `voice-indicator` / `VoiceIndicator` | Voice activity visualization; implementation may cease to be an orb. |
| `media-scrim` / `MediaScrim` | `media-scrim` / `MediaScrim` | Already names the compositing job. |

`FeedbackSurface` variants replace named constructors `action`,
`destructive`, `success`, `warning`, `toastWarning`, `info`, and `loading`.
Remove the alert/toast warning drift: both use `FeedbackVariant.warning` and
the same semantic tokens.

### Glass variants

```dart
Glass(
  variant: GlassVariant.panel,
  child: child,
)
```

| Future variant | Current class | Job |
| --- | --- | --- |
| `panel` | `GlassVariant.panel` | Standard translucent content surface. |
| `navigation` | `GlassVariant.navigation` | Clearer navigation chrome. |
| `prominent` | `GlassVariant.prominent` | Stronger-depth important surface. |
| `control` | `GlassVariant.control` | Compact control treatment without backdrop blur. |

`GlassVariant` is allowed because all four implementations share one contract
and the variants describe use/weight rather than hard-coding four class names.

### Voice indicator

| Current | Future |
| --- | --- |
| `OrbState` | `VoiceIndicatorState` |
| `idle` | `idle` |
| `listening` | `listening` |
| `talking` | `speaking` |
| `thinking` | `processing` |
| `OrbProgram` | private shader loader |

The public state names describe voice/agent behavior, not vendor terminology.

## Component contract

### Shadcn-parity component nouns

Apply the default `X → X` rule and keep the registry item names for the
ordinary shadcn families: Accordion, Alert, AlertDialog, AspectRatio,
Attachment, Avatar, Badge, Breadcrumb, Bubble, Button, ButtonGroup, Calendar,
Card, Carousel, Chart, Checkbox, Collapsible, Combobox, Command, ContextMenu,
Dialog, Drawer, DropdownMenu, Empty, Field, Form, HoverCard, Input, InputGroup,
InputOtp, Item, Kbd, Marker, Menubar, Message, MessageScroller, NativeSelect,
NavigationMenu, Pagination, Popover, Progress, Questionnaire, RadioGroup,
Resizable, ScrollArea, Select, Separator, Sheet, Sidebar, Skeleton, Slider,
Spinner, Switch, Table, Tabs, Textarea, Toast/Toaster, Toggle, ToggleGroup, and
Tooltip.

Keep existing semantic component variants unless an exception below says
otherwise. Button specifically remains:

```dart
ButtonVariant.primary
ButtonVariant.premium
ButtonVariant.secondary
ButtonVariant.outline
ButtonVariant.ghost
ButtonVariant.destructive
ButtonVariant.link
```

### Component exceptions

| Current | Future disposition | Reason |
| --- | --- | --- |
| `Rule<T>` | `ValidationRule<T>` | “Rule” is too broad outside the form context. |
| `Rules` | `Validators` | Collection of validation factories. |
| registry `rule` | `validation-rule` | Match the public job. |
| `NavUser` | `UserMenu` | Account/user actions, not a generic nav abstraction. |
| `NavUserAccount` | `UserMenuAccount` | Same family. |
| `NavUserItem` | `UserMenuItem` | Same family. |
| registry `user-menu` | `user-menu` | Match the primary class. |
| `CalendarSurface` | `CalendarPresentation` | Describes embedded vs overlay presentation, not a material surface. |
| `PopoverOriginModel` | `PopoverAnchorMode` | Describes how placement is anchored. |
| `MenuSurfaceKind` | `MenuSurfaceVariant` | Use the standard `Variant` suffix. |
| `FieldSurface` | hide | Input implementation detail. |
| `ButtonSurface` | hide or `ButtonStyleRecipe` if consumers truly configure it | Current name exposes rendering plumbing. |
| `SelectionControl`, `HitArea` | hide from main barrel | Shared Checkbox/Radio implementation, not product primitives. |
| `ModalCompact` | `CompactDialogLayout` | Layout helper, not a modal component. |
| `ModalPortal` | `OverlayPortal` only if reused outside dialogs; otherwise hide | Scope to measured use. |
| `JellyTransition` | `OpenTransition` | Overlay open/close job. |

### Agent-family cleanup

Keep the stable product nouns after stripping `El`: AgentComposer, AgentFace,
AgentHistory, AgentLauncher, AgentMarkdown, AgentTranscript, AgentAttachment,
AgentMessage, AgentCommand, AgentTransport, ConversationStore, and their
semantic data models. Independently reusable types remain `ui` items.
`AgentConsole` becomes the entry type of the `agent-console` block and is not
exported from the package's primitive barrel; installing the block installs its
complete transitive UI closure.

| Current | Future disposition |
| --- | --- |
| `AgentAttachmentStatusText` | `AgentStatusText` |
| `AttachmentStatusText` in Attachment | `AttachmentStatusText` or hide if not composed externally |
| `CubeAvatar` | `AgentAvatar` high-level API |
| `AgentCube*`, `CubeScene` | hide as the current avatar implementation |
| `BlurSwitch`, `FlipController`, `RowMotion` | hide as history-transition implementation |
| `FadeUp`, `RowIn`, `SpringUpEntrance`, `PopInEntrance` | hide; appearance-shaped transcript internals |

The public `AgentAvatar` API accepts semantic state, size, label, and optional
custom visual builder. Consumers can replace the cube without renaming the
component.

## Registry and documentation contract

For every renamed item:

1. rename source manifest, generated item, docs directory, metadata, page,
   route, install command, source link, and dependency references together;
2. make manifest `exports` mandatory for all 99 items;
3. generate docs export tables from the manifests instead of copying 579 names
   into separate metadata by hand;
4. require every exported type to exist and every public type to belong to one
   manifest or the foundation manifest;
5. change registry dependencies to the future item names in the same commit;
6. rebuild and validate `registry/generated/latest` after every task.

The `Structure` section is authoritative for physical layout and registry
taxonomy. Generated registry payloads must reproduce that mapping exactly.

## Enforcement and no-hardcoding gates

### Public API gates

Create `test/public_api_naming_test.dart`:

- generated inventory has zero unresolved rows;
- no exported symbol begins with `El` or `el`;
- no public name contains banned appearance/source words without an explicit
  rationale: `jelly`, `pill`, `machine`, `cosmic`, `foil`, `sheen`, `bloom`;
- every manifest has a non-empty exports list;
- registry/file/primary-class names agree;
- Flutter collisions are generated and documented;
- deprecated aliases are absent unless publication status requires a separate,
  explicitly approved migration release.

Create `test/public_token_usage_test.dart`:

- every public color, spacing, radius, shadow, typography, duration, curve, and
  transform token has a production reference outside its declaration;
- docs/tests do not satisfy usage;
- effect-private values are not exported;
- new phase tokens (`pressIn`, `pressOut`, `open`, `close`, `expand`,
  `collapse`, `overlayEnter`, `overlayExit`, `stateChange`) are used by their
  named production paths.

### Extend `test/token_guard_test.dart`

Keep every existing exception justified on the exact line. Add coverage for:

| Category | Reject outside allowed owner |
| --- | --- |
| Colors | `Color(...)`, hex colors, `Colors.*`, ad-hoc opacity literals |
| Typography | `TextStyle(...)`, font size, weight, tracking, line height, raw font family |
| Motion | `Duration(...)`, stock `Curves.*`, raw `Cubic`, transform constants |
| Radius/shadow | raw `BorderRadius`, `BoxShadow`, blur/spread literals |
| Spacing/geometry | raw visual EdgeInsets, gaps, component widths/heights, magic offsets |
| Components in product/docs UI | styled stock Button/Card/Input/Snackbar where a system component exists |

Foundation files may own literal token definitions. An effect may own only its
private recipe literals. Components and `example/lib/` consume the public
tokens and semantic components.

### Behavioral and accessibility gates

- press feedback responds to pointer, touch, keyboard activation, cancellation,
  disabled state, and reduced motion;
- hover-only feedback has focus/keyboard parity where it communicates action;
- ActiveIndicator supports no selection, changed selection, arbitrary indicator
  shape, text scaling, RTL, resize, and reduced motion;
- overlays retain focus trapping/return, escape dismissal, barrier semantics,
  safe areas, and open/close direction tests;
- FeedbackSurface never communicates success/warning/error by color alone;
- loading controls prevent duplicate actions and expose semantic progress;
- all components retain labels and logical focus order.

## Implementation sequence

### Low-token execution contract

This is a behavior-preserving migration, not a redesign. Agents must avoid
re-reading the whole repository or re-deciding approved names.

1. Treat this plan and the generated rename/layout maps as authoritative.
2. Use scripts for file moves, exact identifier replacements, registry target
   rewrites, documentation routes, and generated metadata. Do not perform
   hundreds of equivalent hand edits.
3. Keep the rename map machine-readable at
   `tool/migration/public_api_renames.json`; require one old identifier, one
   disposition, and at most one future identifier per record.
4. Implement `tool/migration/apply_public_api_renames.dart` with identifier
   boundaries and a dry-run report. A blind substring replacement is forbidden.
5. Implement `tool/migration/apply_layout.dart` from an explicit old-path to
   new-path manifest. It moves only listed files and fails if a destination
   already exists or source hashes differ from the frozen inventory.
6. Update handwritten authoritative sources only. Rebuild generated registry,
   docs metadata, and barrels; never hand-edit generated copies.
7. Run focused analysis/tests after each task. Run the full matrix only at the
   marked checkpoints and final gate.
8. Do not change rendering, state behavior, accessibility, public defaults, or
   dependency versions unless this plan explicitly requires it.
9. If a current symbol/path has no disposition in the inventory, stop that
   task and record it; do not invent a name during execution.
10. Keep reports short: changed files, script output summary, tests, blocker.

Recommended agent handoff per task: this plan link, task number, rename/layout
map, and the focused verification command only. Do not paste the plan into each
prompt or ask every agent to rediscover the API.

### Task 1 — Freeze the API inventory

- [ ] Generate all 574 declarations and all 579 documented exports.
- [ ] Add disposition and future-name columns.
- [ ] Materialize the approved rows in
      `tool/migration/public_api_renames.json`.
- [ ] Materialize every approved move in `tool/migration/layout.json`.
- [ ] Add the Flutter collision report.
- [ ] Fail on unresolved, duplicate, missing, or undocumented symbols.
- [ ] Commit only inventory/tooling; no renames yet.

### Task 2 — Shrink accidental public surface

- [ ] Hide theme/effect plumbing.
- [ ] Hide unused keyframe presets.
- [ ] Hide component painters, shader loaders, layout probes, and debug-only
      helpers from the main barrel.
- [ ] Make manifest exports authoritative.
- [ ] Run package and example suites; rebuild registry.

**Checkpoint A:** full package and example analyze/test before mechanical moves.

### Task 3 — Apply the structural migration mechanically

- [ ] Add dry-run-tested rename and layout migration scripts.
- [ ] Move reusable components, effects, and motion widgets into
      `lib/src/components/ui/`.
- [ ] Move foundation into `lib/src/design_system/foundation/`.
- [ ] Move ThemeScope into foundation and resolve TextLayout as specified.
- [ ] Create `lib/src/blocks/agent_console/` and keep individual agent UI
      primitives independently installable.
- [ ] Replace registry kinds/targets with `foundation`, `ui`, and `block`.
- [ ] Update package imports through the scripted path map.
- [ ] Analyze package; do not rename public identifiers in this task.

### Task 4 — Rename foundation and top-level helpers

- [ ] `el()` → `space()`.
- [ ] Apply ThemeTokens, TextStyles, geometry-family, shadow, motion, and helper
      mappings in this plan.
- [ ] Replace every call site in package, example, tests, tools, and docs.
- [ ] Add public-token usage enforcement.
- [ ] Rebuild registry.

### Task 5 — Implement semantic motion phases

- [ ] Add and use `pressIn` / `pressOut`.
- [ ] Split open/close, expand/collapse, overlay enter/exit, and drawer phases.
- [ ] Add and use `stateChange`.
- [ ] Make measured/effect clocks private.
- [ ] Prove reduced-motion behavior for every phase.
- [ ] Remove zero-consumer motion names.

### Task 6 — Rename motion utilities

- [ ] `Lift` → `HoverBuilder`; `LiftCard` → `InteractiveCard`.
- [ ] `SlidingPillGroup` → `ActiveIndicator`; rename pill-shaped parameters.
- [ ] `SwapIn` → `ContentChange`.
- [ ] Hide appearance-named keyframe presets.
- [ ] Add underline and square ActiveIndicator specimens.

### Task 7 — Rename and consolidate effects

- [ ] Rename PremiumSurface, ActionFeedback, FeedbackSurface, Surface,
      BackgroundEffect, AmbientPattern, VoiceIndicator.
- [ ] Collapse four Glass classes into `Glass` + `GlassVariant`.
- [ ] Move effect clocks/colors/transforms into their owner.
- [ ] Unify warning feedback semantics between Alert and Toast.
- [ ] Reclassify the renamed effects as `ui` items; rebuild manifests and docs.

### Task 8 — Remove the brand prefix from components

- [ ] Apply the exhaustive `X → X` rule.
- [ ] Apply every component exception in this plan.
- [ ] Update constructors, typedefs, controllers, enums, records, comments,
      examples, test finders, and generated docs.
- [ ] Add direct and `as ui` import examples for collisions.
- [ ] Verify no `El`/`el` public identifier remains.

**Checkpoint B:** full package/example analyze and tests after public renames.

### Task 9 — Registry, CLI, and docs convergence

- [ ] Rename item files and dependencies atomically.
- [ ] Make configured UI/foundation/block/asset/shader paths real and reject
      invalid or post-init path drift.
- [ ] Replace the current effect/motion/shot target mapping with the Structure
      contract.
- [ ] Generate only `ui.g.dart` and `foundation.g.dart`; preserve the
      consumer-owned entry barrels.
- [ ] Make registry exports mandatory and generated docs consume them.
- [ ] Update CLI rewrite/import logic for unprefixed source.
- [ ] Update `AGENTS.md`, the Flutter UI director system map, CLI README, and
      public installation documentation to the new repository/consumer paths.
- [ ] Verify clean init, Button's five-file dependency closure, individual
      agent primitives, complete AgentConsole block, dry-run, conflicts,
      overwrite, update, remove, and atomic failure.
- [ ] Prove generated registry reproducibility.

### Task 10 — Full no-hardcoding and usability gate

- [ ] Extend token guard across package and example.
- [ ] Run public API naming and token-usage tests.
- [ ] Run all accessibility/reduced-motion tests.
- [ ] Analyze/test package, example, CLI, registry builder, release audit.
- [ ] Build web release.
- [ ] Capture light/dark and narrow/wide specimens for foundations, Button,
      Card, ActiveIndicator, Glass, FeedbackSurface, overlays, and agent UI.
- [ ] Record commands, results, collisions, kept names, and limitations.

**Checkpoint C:** run the complete verification matrix once, after generated
artifacts are rebuilt. Do not repeat full-suite work between unchanged tasks.

## Verification commands

Use the repository's supported WSL Flutter helper; Windows Smart App Control
blocks the unsigned test binary.

```bash
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=naming ft root analyze"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=naming ft root test"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=naming ft example analyze lib test"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=naming ft example test"
```

```powershell
dart run tool/registry_builder/bin/build.dart .
dart run tool/registry_builder/bin/validate.dart .
Push-Location packages/elattar_cli
dart analyze
dart test
dart pub publish --dry-run
Pop-Location
Push-Location tool/release_audit
dart analyze
dart test
Pop-Location
git diff --exit-code -- registry/generated/latest
```

Run focused gates throughout:

```bash
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=naming ft root test test/token_guard_test.dart"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=naming ft root test test/public_api_naming_test.dart"
wsl.exe -d Ubuntu-24.04 -- bash -c "FT_ID=naming ft root test test/public_token_usage_test.dart"
```

Build and inspect the documentation app:

```powershell
Push-Location example
flutter build web --release --base-href /flutter-design-system/
Pop-Location
```

## Review checklist before implementation approval

- [ ] Is every exception name understandable without seeing the current visual?
- [ ] Would the name remain true after a redesign?
- [ ] Is it broader than one current host only when real reuse proves that scope?
- [ ] Does each public token have a named production consumer?
- [ ] Are shadcn semantic pairs preserved?
- [ ] Are effect-specific recipes private?
- [ ] Are component variants semantic and consistent?
- [ ] Are Flutter collisions acceptable with direct/qualified import examples?
- [ ] Is the Structure mapping reflected exactly in the layout manifest,
      target mapper, registry validator, installer tests, and system map?
- [ ] Has publication/deprecation policy been explicitly confirmed before
      removing the old API?
