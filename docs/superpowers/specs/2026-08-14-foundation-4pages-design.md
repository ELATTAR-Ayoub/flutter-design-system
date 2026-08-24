# Design: Flutter 1:1 port — foundation, phase 1 (overview · colors · typography · spacing)

Date: 2026-08-14. Status: approved by standing instruction ("make the spec and the plan, then start"). Reference: `D:\DESIGN\Design-System-2026-8\design-system` (Next.js/Tailwind). Research maps: `docs/superpowers/research/*.md` (globals, rules, shell, overview, colors, typography, spacing, shared, assets) — these are the authoritative extraction of the reference and MUST be read by every implementer.

## 1. Goal and fidelity bar

Recreate the web design system's docs app in Flutter, starting with the shell plus four foundation pages: `/design-system` (overview), `/colors`, `/typography`, `/spacing`. The port is a reusable package (`elattar_design_system`) + an example docs app, mirroring the web architecture: **one token source of truth, nothing hardcoded outside it** — no hardcoded components, typography, colors, or motion anywhere else.

Fidelity bar (from the user, twice enforced): **1:1 — "the same in every fucking thing", "not a pixel difference."** Concretely:
- Definition layer value-for-value (every token, shadow layer, keyframe, easing, gradient stop from `globals.css`).
- Showcase pages section-for-section with **verbatim copy** (including typos: "in the same same row"), same layout metrics, same live measurement, same interactions.
- The reference's own internal drift ships as-is (copy says "Space Grotesk"/"1320px"; tokens render Inter/1200 — keep both sides).
- **Definition of done is rendered, not asserted**: the 2026-08-13 build was deleted despite code-level fidelity claims. This build is done only after the Next.js app and the Flutter app run side by side and section-by-section screenshots match in BOTH themes at the 1440 frame.

## 2. Scope

**In scope**
- Package layers: `foundation/` (all tokens), `effects/` (only what these surfaces need: machine shadows incl. inset, glows, page glow), `motion/` (press, lift, slide-pill + jelly, curves), `components/` (ElIcon, ElButton outline/ghost variants, ElSheet for mobile nav).
- Docs shell: sticky blurred header (logo, version pill, tagline, 3-way theme toggle with travelling jelly pill), 240px sidebar with the **full 4-group nav tree** (all 32 links, verbatim), responsive (<1024px: burger + left sheet), page glow, thin scrollbars, focus/selection styling.
- Pages: overview, colors (live-measured contrast), typography (full specimen incl. prose demo), spacing. PageFootNav between them.
- Routes referenced by nav/foot-nav but out of scope (shadows, motion, icons, component families) render a minimal placeholder using the same shell (header eyebrow "Foundations" + title + "Not ported yet" in type-small) — links must not dead-end.
- Guard-as-test: `token_guard_test.dart` (regex scan: literals only in `lib/src/foundation/`), asset-existence test, contrast unit tests, type/spacing scale tests.
- Rendered verification harness (see §7).

**Out of scope**: shadows/motion/icons pages' real content, base/agent/site families, foil/sheen/bloom-cosmic/starfield effects (not rendered by these four pages — foil/bloom/sheen are only *named in copy* on colors §beyond), toasts, landing site.

## 3. Architecture

```
flutter-design-system/               (git repo, package elattar_design_system)
  pubspec.yaml                       (fonts registered here)
  assets/fonts/InterVariable.ttf     (converted from reference woff2 — lossless)
  assets/fonts/Redaction35-Italic.ttf
  assets/fonts/GeistMono-Variable.ttf (copied from reference node_modules)
  lib/elattar_design_system.dart     (single export barrel)
  lib/src/foundation/                ← ONLY place literals are allowed
    colors.dart        raw ramps + state palette (ElPalette; theme-independent)
    theme.dart         ElThemeData: every semantic token per theme (light/dark blocks of globals.css)
    typography.dart    ElType: every .type-* class as a TextStyle factory (incl. clamp() rules)
    spacing.dart       ds4 unit + scale, widths (shell/content/page/prose...), radii
    shadows.dart       ElShadowSpec (layers w/ inset flag) e1–e4, key, pressed, btn*, chip, glows + per-theme inks
    motion.dart        durations (tick..bloom), curves (spring/out/in/inOut/settle/standard/outFlex as cubic-beziers)
  lib/src/effects/
    machine_surface.dart   ElMachineSurface — paints ElShadowSpec incl. inset layers (clip RRect, difference ring, MaskFilter)
    page_glow.dart         fixed-viewport radial gradient behind scroll content
  lib/src/motion/
    press.dart         ElPress: 40ms scale-in (0.94 default), 250ms spring-back
    lift.dart          ElLift: hover translateY(-3) + e3 + border-color, 250ms out/standard
    sliding_pill.dart  ElSlidingPill + jelly replay (yuki-jelly keyframes as TweenSequence)
  lib/src/components/
    icon.dart          ElIcon: 8 embedded Lucide 1.28.0 paths (Menu, X, Sun, Monitor, Moon, ArrowLeft, ArrowRight, Check),
                       size ladder 12/14/16/20/24/32/40, stroke 2.4/2.4/2.4/2.4/2/1.5/1.6 (web-computed), tones
    button.dart        ElButton: outline/ghost + icon sizes used by the shell (API shaped for all 7 variants later)
    sheet.dart         ElSheet: left sheet (overlay bg-background/15 + blur-xs, panel slide+fade 320ms/out)
  lib/src/theme_scope.dart  ElTheme InheritedWidget + ElThemeMode (light/system/dark) controller
  example/                     (the docs app)
    lib/main.dart              MaterialApp-free custom WidgetsApp/Router or minimal MaterialApp with ElTheme
    lib/nav.dart               EL_GROUPS verbatim port of lib/el/nav.ts (all groups/categories/blurbs/contents)
    lib/shell.dart             header + sidebar + content frame (1680/240/1080, px-6 py-12 lg:px-12)
    lib/kit.dart               ElPageHeader, ElSection, Panel, Meta, Code, DoDont, Note, IndexGrid/IndexCard, PageFootNav
    lib/token_swatch.dart      TokenSwatch/TokenSwatchList/TokenValue/ContrastBadge + live contrast engine
    lib/pages/{overview,colors,typography,spacing,placeholder}.dart
  test/                        guard + contract tests
  docs/superpowers/{specs,plans,research}/
```

Key contracts:
- `ElThemeData` exposes every semantic token (`background, card, muted, accent, foreground, mutedForeground, border, input, primary, ring, actionInk, valueInk, successInk/…, pageGlow, ink1..4, rim, rimStrong, wall`) resolved per theme; raw ramps live on `ElPalette` and never flip.
- `ElType` styles carry family/size/height/weight/tracking/uppercase-flag/tabular exactly as the web classes; call sites never restate numbers. `typeDisplay(context)`/`typeH1(context)` compute clamp() from viewport width.
- Colors with CSS `color-mix(in oklab, X n%, transparent)` resolve to X at n% alpha (mixing toward transparent preserves hue in premultiplied oklab); genuine two-color oklab mixes use an OKLab implementation in foundation (`ElOklab.mix`). OKLCH relative-color tokens (`--bubble-tinted`) are computed, not hardcoded, with chroma-reduction gamut mapping (recorded decision).
- Fonts follow tokens, not prose (recorded decision): Inter Local (variable TTF from the reference's own binary), Geist Mono (reference's TTF), Redaction 35. Weight 650 via `FontVariation('wght', 650)`; tabular via `FontFeature.tabularFigures()`.

## 4. The four pages — content contract

Each page implements its research map section-for-section (maps carry verbatim copy, exact classes, layout grids, and drift registers): `overview-map.md` (header, #foundations 6 IndexCards, #components 3 group cards, #rules 6-item list, closing value Note), `colors-map.md` (header+chips, lead Note, #monochrome 6 swatches + Note, #action 4 + Note, #value 4, #state 4 + Note, #beyond 2 Panels, foot-nav; ContrastBadge math per §1 of that map — including the muted "Note title renders muted-foreground in every tone" rendering fact), `typography-map.md` (#rule 2 Panels + Note, #words 10 Spec rows, #numbers 5 rows + tabular Panel, #pairing 3 cards, #prose full prose demo + 6-item Meta + error Note, #rules DoDont, foot-nav), `spacing-map.md` (#scale 10 bars, #radius 7 boxes, #elevation e1–e4 + glows, #grid Meta + 12-col demo, #breakpoints Meta + Note, #rules DoDont, foot-nav).

## 5. Web→Flutter mechanics (the hard parts, decided)

| Web mechanism | Flutter port |
|---|---|
| body fixed radial page glow | `PageGlow` paints gradient in shell Stack behind scrollable; does not scroll |
| header `bg-background/85 backdrop-blur-xl` | ClipRect+BackdropFilter(blur 24) over scroll content, header painted 85% background |
| inset/mixed box-shadows (shadow-btn on outline button) | ElMachineSurface custom painter |
| `lift` hover | MouseRegion + AnimatedContainer-equivalent (transform/box-shadow 250ms out, border 250ms standard) |
| `press` active | Listener: 40ms scale to 0.94 on down, 250ms `--ease-spring` back on up |
| theme-toggle travelling pill + jelly | measured target rects; position/size 250ms spring, opacity 150ms out; on arrival replay yuki-jelly TweenSequence (0.6s ease-out; scale x/y per keyframes); hidden before first measurement, first move without transition |
| live contrast measurement | port of useContrast: resolve token → composite alpha over bg → WCAG luminance (0.03928 threshold) → ratio; re-computed on theme change; badge verdicts ≥7 AAA / ≥4.5 AA / ≥3 AA large / Fails |
| smooth anchor scroll + 96px offset | ScrollController.animateTo(target − 96) for the one in-page link (#prose); scroll padding elsewhere n/a |
| thin scrollbars | RawScrollbar 8px, thumb border-color, pill radius (hover color best-effort) |
| ::selection | DefaultSelectionStyle(background action 35%, SelectionArea over page content) |
| clamp() fluid type | linear interpolation vs viewport width between min/max (display 44→64 via 4.4vw; h1 32→40 via 2.8vw) |
| `hover:border-action/45`, `bg-action/12` washes | color.withValues(alpha:) over the raw ramp color |
| reduced motion | honored via MediaQuery.disableAnimations → durations to ~0 |

Breakpoints: Tailwind stock sm 640 / md 768 / lg 1024 / xl 1280 mapped by viewport width (MediaQuery). Desktop-first; sidebar ≥1024.

## 6. What the guard enforces

`test/token_guard_test.dart` regex-scans `lib/` + `example/lib/`: `Color(0x…)`, `Color.fromRGBO/fromARGB`, `fontSize:`, `letterSpacing:`, `FontWeight.w…`, `Duration(milliseconds: <literal>)`, `Curves.` (must use ElMotion curves), `BorderRadius.circular(<literal>)`, raw `BoxShadow(` outside foundation/effects — allowed only under `lib/src/foundation/`; escape hatch comment `allow-hardcoded: <reason>`. `elTransparent` and bare `0` legal. Asset test asserts the three font files exist and are registered.

## 7. Verification protocol (the definition of done)

1. `flutter analyze` + `flutter test` green.
2. Reference up: `npm run dev` in the web repo (port noted at runtime). Flutter app built for web (`flutter run -d web-server`) — same engine text stack as the comparisons demand; also runs on Windows desktop.
3. In-app browser at **1440-wide viewport**: for each page × {dark, light}: screenshot the reference and the port at the same scroll positions, section by section (header, each ElSection, foot-nav). Compare: layout metrics, type sizes/weights/tracking, colors, borders, shadows, badge values ("Contrast 13.5:1 · AAA" strings must match), copy verbatim.
4. Interactions checked live: card lift hover, press scale, theme-toggle pill travel + jelly, sidebar active states, prose link underline fade.
5. Fix → re-screenshot until no visible difference; only then report done, with the screenshot evidence named honestly (measured vs looked-at).

## 8. Risks / accepted deviations (recorded, not papered over)

- Font rasterization differs slightly between browser and Flutter engine (hinting/antialiasing) — the bar is metric identity (size/leading/tracking/weight) and indistinguishable-at-a-glance rendering; glyph-level AA differences are noted, not "fixed" by changing tokens.
- Lucide stroke retuning is portable here (we paint paths, not font glyphs) — better than the last build.
- Scrollbar hover color and OS-level `color-scheme` behaviors are best-effort (RULES §5-known limits list in RULES.md port).
- `.type-accent`/Redaction renders on none of the four pages; the face ships in the token set regardless.
