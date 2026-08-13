# Flutter Foundation Phase 1 (overview · colors · typography · spacing) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Recreate the web design system docs app (shell + overview/colors/typography/spacing) as Flutter package `elattar_design_system` + example app, 1:1 with the reference, from a single token source of truth.

**Architecture:** Package layers `foundation/` (only literals) → `effects/`+`motion/` → `components/`; example app carries nav data, shell, kit, token-swatch engine, 4 pages. Verification = tests + rendered side-by-side vs the Next.js reference.

**Tech Stack:** Flutter 3.44.8 stable, Dart. No third-party UI packages. Fonts: reference's own binaries (Inter variable, Geist Mono variable, Redaction 35).

## Global Constraints

- Reference repo: `D:\DESIGN\Design-System-2026-8\design-system`. Its `app/globals.css` is the ONLY token truth; RULES.md is the law.
- **Mandatory reading per task**: `docs/superpowers/specs/2026-08-14-foundation-4pages-design.md` + the research maps named in the task (under `docs/superpowers/research/`). Maps carry verbatim copy, exact metrics, and drift registers — copy is rendered VERBATIM including typos ("in the same same row") and drift (copy says "Space Grotesk"/"1320px" while tokens render Inter/1200).
- Literals (colors, px, ms, curves) are allowed ONLY in `lib/src/foundation/*.dart`. Everywhere else consumes tokens. Escape hatch: line comment `// allow-hardcoded: <reason>`.
- 1 CSS `rem` = 16px. Tailwind `--spacing` unit = 4px. Breakpoints: sm 640 / md 768 / lg 1024 / xl 1280.
- Default theme dark; three-way mode light/system/dark; `.light`/`.dark` equivalents are `DsThemeData.light/.dark`.
- Fonts follow tokens, not prose: families `InterLocal`, `GeistMono`, `Redaction35`.
- Commit after each task with a conventional message ending `Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>`.
- Run `flutter analyze` and `flutter test` before every commit; both must be clean (warnings in generated scaffolding may be fixed or ignored only if pre-existing).

## API Contract (all tasks code against this; implementers of a type may extend but not rename)

```dart
// foundation/colors.dart
Color dsHsl(double h, double s, double l, [double a = 1]);       // exact CSS hsl() conversion
class DsOklab { static Color mix(Color a, Color b, double tA);    // oklab interpolation
                static Color fromOklchRelative(...); }            // chroma-reduction gamut mapping
class DsPalette {  // raw ramps + state — theme-independent, from globals.css @theme static
  static final Color actionBright, action, actionDark;            // hsl(213 94% 78%) / (217 91% 53%) / (224 76% 33%)
  static final Color valueBright, value, valueDark;               // #d9f99d / #a3e635 / #4d7c0f
  static final Color valueForeground;                             // hsl(240 10% 8%)
  static final Color success, warning, info;                      // #10b981 / #fbbf24 / #22d3ee
  static final Color successDeep, warningDeep, infoDeep;          // #047857 / #b45309 / #0e7490
  static final Color destructiveLifted, destructiveDeep;          // #f87171 / hsl(0 72.2% 46%)
}
const Color dsTransparent = Color(0x00000000);

// foundation/theme.dart
enum DsThemeKind { light, dark }
class DsThemeData {
  final DsThemeKind kind;
  final Color background, foreground, card, cardForeground, popover, popoverForeground,
    secondary, secondaryForeground, muted, mutedForeground, accent, accentForeground,
    border, input, pageGlow, primary, primaryForeground, ring,
    actionInk, valueInk, successInk, warningInk, infoInk, destructiveInk,
    destructive, destructiveForeground, scrim;
  final Color ink1, ink2, ink3, ink4, rim, rimStrong, wall;       // shadow ink family
  static final DsThemeData light, dark;                            // values = globals.css theme blocks
}

// foundation/spacing.dart
double ds(num n);                       // n * 4.0  (Tailwind spacing unit)
class DsWidths { static const double shell=1680, content=1080, page=1200, prose=720,
  rail=240, sidebar=256, sidebarIcon=48, sidebarMobile=288, siteHeader=64, scrollOffset=96; }
class DsRadii { static const double xs=2, sm=6, md=10, lg=12, xl=16, xl2=20, xl3=24, xl4=32, pill=999; }
class DsBreakpoints { static const double sm=640, md=768, lg=1024, xl=1280; }

// foundation/typography.dart
class DsFonts { static const String sans='InterLocal', mono='GeistMono', accent='Redaction35'; }
enum DsTypeColor { none, foreground, muted }   // the class's own color, per globals.css
class DsTypeSpec {
  final String family; final double? size; final double height;   // height = CSS line-height ratio
  final FontWeight weight; final List<FontVariation> variations;  // e.g. wght 650 for h2
  final double? tracking;                                          // em value; resolved vs size
  final bool uppercase, tabular; final DsTypeColor defaultColor; final FontStyle fontStyle;
  TextStyle resolve(double fontSize, Color color);                // resolved TextStyle
}
class DsType {   // one spec per web .type-* class — values from globals-map §5
  static double displaySize(double vw);   // clamp(44, 4.4vw, 64)
  static double h1Size(double vw);        // clamp(32, 2.8vw, 40)
  static final DsTypeSpec display, h1, h2, h3, h4, lead, body, small, nav, navSm, chip,
    caption, code, label, section, wordmark, serial, micro, tag, badge, accent,
    numXs, numSm, numBase /* .type-num */, numMd, numLg, numXl;
}

// foundation/shadows.dart
class DsShadowLayer { final double dx, dy, blur, spread; final bool inset;
  final Color Function(DsThemeData) color; }
class DsShadowSpec { final List<DsShadowLayer> layers;
  List<BoxShadow> outerShadows(DsThemeData t);  bool get hasInset; }
class DsShadows { static final DsShadowSpec e1, e2, e3, e4, key, keyDown, pressed,
  btn, btnPrimary, btnValue, btnDown, chip, glowAction, glowValue; }

// foundation/motion.dart
class DsDurations { static const Duration tick=..80ms, fast=150, base=250, slow=400,
  overlay=320, jelly=420, reward=550, bloom=1000; }
class DsCurves { static const Cubic spring=Cubic(.34,1.56,.64,1), out=Cubic(.22,1,.36,1),
  curveIn=Cubic(.7,0,.84,0), inOut=Cubic(.65,0,.35,1), settle=Cubic(.16,1,.3,1),
  standard=Cubic(.4,0,.2,1), outFlex=Cubic(.05,.6,.4,.9); }

// theme_scope.dart
enum DsThemeMode { light, system, dark }
class DsThemeController extends ChangeNotifier {
  DsThemeMode mode; void setMode(DsThemeMode m);
  DsThemeKind resolve(Brightness platformBrightness); }
class DsTheme extends InheritedNotifier<DsThemeController> {
  static DsThemeData of(BuildContext c);          // resolved current theme (subscribes)
  static DsThemeController controllerOf(BuildContext c); }
class DsText extends StatelessWidget {            // renders a DsTypeSpec; uppercases when flagged
  DsText(String text, DsTypeSpec spec, {Color? color, double? fontSize, TextAlign? align,
    int? maxLines, TextOverflow? overflow}); }

// effects/
class DsPageGlow extends StatelessWidget {}       // radial-gradient(120% 90% at 62% 34%, pageGlow, transparent 64%)
class DsMachineSurface extends StatelessWidget {  // paints DsShadowSpec incl. inset layers around/inside child
  DsMachineSurface({required DsShadowSpec spec, required BorderRadius radius,
    Color? fill, BoxBorder? border, required Widget child}); }

// motion/
class DsPress extends StatefulWidget {            // 40ms scale-in on press, base/spring back
  DsPress({double scale = 0.94, required Widget child, VoidCallback? onTap}); }
class DsLift extends StatefulWidget {             // hover: translateY(-3), e3 shadow, border color swap
  DsLift({required Widget Function(BuildContext, bool hovered) builder}); }
class DsSlidingPill { /* see Task 4: DsSlidingPillGroup */ }

// components/
enum DsIconGlyph { menu, x, sun, monitor, moon, arrowLeft, arrowRight, check }
enum DsIconSize { xs, sm, md, lg, xl, xl2, xl3 }  // 12/14/16/20/24/32/40 px
enum DsIconTone { normal, muted, subtle, action, value, success, warning, info, error, inherit }
class DsIcon extends StatelessWidget {
  DsIcon(DsIconGlyph g, {DsIconSize size=DsIconSize.md, DsIconTone tone=DsIconTone.inherit,
    double? sizePx, double? strokeOverride}); } // strokeWidth = clamp web formula (2.4/2.4/2.4/2.4/2.0/1.5/1.6)
enum DsButtonVariant { outline, ghost }           // phase-1 subset; API open for the other 5
enum DsButtonSize { sm, md, icon, iconSm }
class DsButton extends StatelessWidget {
  DsButton({required Widget child, DsButtonVariant variant, DsButtonSize size, VoidCallback? onPressed}); }
class DsSheet { static Future<void> showLeft(BuildContext c, {required WidgetBuilder builder,
  double width}); } // overlay background@15% + blur 4, panel slide-from-left + fade, 320ms/out

// example/lib/nav.dart — verbatim port of lib/ds/nav.ts
class DsCategory { final String slug, title, blurb; final List<String> contents; }
class DsGroup { final String id, title, href, blurb; final List<DsCategory> categories; }
final List<DsGroup> dsGroups;                     // foundations/base/agent/site — ALL entries verbatim
String categoryHref(DsGroup g, DsCategory c);
({({String title, String href})? prev, ({String title, String href})? next}) siblings(String groupId, String slug);

// example/lib/shell.dart
class DocsShell extends StatefulWidget { DocsShell({required String route, required Widget child}); }
// header 64px sticky blurred; sidebar 240 ≥1024px; main px-24 py-48 (lg px-48); content max 1080 centered.
// Owns: Logo, version pill, tagline, ThemeToggle, NavTree, DsSheet mobile nav, page glow, thin scrollbar,
// route -> page switching via simple Navigator/ValueNotifier<String> currentRoute.

// example/lib/kit.dart — anatomy per shared-map.md §2
class DsPageHeader { (eyebrow, title, blurb, contents?) }
class DsSection { (id, title, description?, child) }         // registers anchor key for #prose scroll
class DsPanel { (label?, note?, child, flush=false, bodyPadding?) }
class DsMeta { (items: List<(String k, InlineSpan v)>) }
class DsCode { (String text) }                                // inline code chip
class DsDoDont { (dos: List<String>, donts: List<String>) }
class DsNote { (tone: action|value|error, title?, child) }    // title ALWAYS renders mutedForeground
class DsIndexGrid/DsIndexCard { (href, title, blurb, contents) }
class DsPageFootNav { (groupId, slug) }

// example/lib/token_swatch.dart
class DsTokenRegistry { static Color resolve(String cssName, DsThemeData t); static String printedValue(String cssName, DsThemeKind k); }
double dsContrastRatio(Color fg, Color bg);                   // WCAG, alpha-composited, 0.03928 threshold
class DsContrastBadge { (String token, {String against = '--background'}) }  // "Contrast X.X:1 · VERDICT"
class DsTokenSwatch { (token, name, use, measure=true) }  class DsTokenSwatchList { (rows) }
```

---

### Task 1: Scaffold package, fonts, guard test

**Files:** Create `pubspec.yaml`, `analysis_options.yaml`, `lib/elattar_design_system.dart`, `example/pubspec.yaml`, `example/lib/main.dart` (temporary placeholder), `assets/fonts/*.ttf`, `test/token_guard_test.dart`, `test/assets_test.dart`, `.gitignore`.
**Interfaces:** Produces the repo layout in the spec §3; fonts registered as families `InterLocal`, `GeistMono`, `Redaction35`.

- [ ] Step 1: `flutter create --template=package .` in the repo root (name `elattar_design_system`), then `flutter create --platforms=windows,web example` (org `com.elattar`). Remove generated boilerplate lib/test content.
- [ ] Step 2: Convert fonts with python fontTools (installed): woff2→TTF for `design-system/public/fonts/inter-variable.woff2` → `assets/fonts/InterVariable.ttf` and `redaction-35-italic.woff2` → `assets/fonts/Redaction35-Italic.ttf` (`from fontTools.ttLib import TTFont; f=TTFont(src); f.flavor=None; f.save(dst)`); copy `design-system/node_modules/geist/dist/fonts/geist-mono/GeistMono-Variable.ttf` → `assets/fonts/GeistMono-Variable.ttf`. Register all three in the PACKAGE pubspec under families `InterLocal` (weight axis variable), `GeistMono`, `Redaction35` (style italic).
- [ ] Step 3: Write `test/assets_test.dart` asserting the three TTFs exist and pubspec.yaml mentions each family name. Write `test/token_guard_test.dart`: recursively scan `lib/` and `example/lib` for `RegExp` violations outside `lib/src/foundation/`: `Color\(0x`, `Color\.from`, `fontSize:\s*\d`, `letterSpacing:\s*-?\d`, `FontWeight\.w\d`, `Curves\.`, `Duration\((milli|micro)seconds:\s*\d`, `BorderRadius\.circular\(\d`, `BoxShadow\(`; a line containing `allow-hardcoded:` is exempt; bare `0`/`0.0` and `dsTransparent` legal. Guard must PASS on the scaffold (nothing to violate yet) — it is the standing contract.
- [ ] Step 4: `flutter analyze` + `flutter test` green (guard + assets). Commit `feat: scaffold package, reference fonts, token guard`.

### Task 2: Foundation — colors, theme blocks, spacing, radii

**Files:** Create `lib/src/foundation/colors.dart`, `theme.dart`, `spacing.dart`; Test `test/foundation_colors_test.dart`.
**Interfaces:** Produces `dsHsl`, `DsOklab`, `DsPalette`, `DsThemeData.light/.dark`, `ds()`, `DsWidths`, `DsRadii`, `DsBreakpoints` exactly as the API Contract. Values: `globals-map.md` §3a/3c/3d/3h/3i (read it in full).
**Steps:**
- [ ] Failing tests first: `dsHsl(213,94,78)` == `Color(0xFF92C2FC)`; `dsHsl(217,91,53)` == `0xFF1A6EF4`; `dsHsl(224,76,33)` == `0xFF143694` (documented rasterizations); `DsThemeData.dark.background == dsHsl(240,10,3.9)`; `DsThemeData.light.mutedForeground == dsHsl(240,4,40)`; dark `actionInk == DsPalette.actionBright`; light `actionInk == DsPalette.actionDark`; dark `ink2` == black 50%; light `ink2` == `dsHsl(240,20,20,0.07)`; `ds(6) == 24`; `DsRadii.xl == 16`.
- [ ] Implement every token from the maps (ALL of §3h/§3i incl. pageGlow, ring per theme, scrim, chart tokens may be omitted this phase — but sidebar aliases, bubbleTinted via `DsOklab` relative-color math ARE included). Run tests → pass. Commit `feat(foundation): color ramps, theme blocks, spacing, radii`.

### Task 3: Foundation — typography, motion, shadows

**Files:** Create `lib/src/foundation/typography.dart`, `motion.dart`, `shadows.dart`; Test `test/foundation_type_motion_test.dart`.
**Interfaces:** Produces `DsFonts`, `DsTypeSpec`, `DsType.*`, `DsDurations`, `DsCurves`, `DsShadowLayer/Spec`, `DsShadows.*` per API Contract. Values: `globals-map.md` §3b/3e/3f/§5 (every .type-* row), `shared-map.md` §7.
**Steps:**
- [ ] Failing tests: `DsType.h2.weight` renders wght 650 via `variations`; `DsType.numSm` → mono 12px height 1.2 weight 600 tabular tracking −0.01em; `DsType.label.uppercase == true` && size 11 && tracking 0.16; `DsType.displaySize(1000) == 44` (4.4vw of 1000 = 44 → min edge), `DsType.displaySize(1600) == 64` (70.4 clamped to 64), `DsType.h1Size(1440) == 40*…` (2.8vw of 1440 = 40.32 → clamp 40); `DsDurations.base == 250ms`; `DsCurves.spring == Cubic(.34,1.56,.64,1)`; `DsShadows.e3` layer values (0,2,4 ink2 + 0,14,28,−8 ink3); `DsShadows.btn.hasInset == true`; `DsShadows.glowAction` = 0 0 0 1 actionBright@45% + 0 10 34 −8 action@60%.
- [ ] Implement (line-heights as ratios; per-class defaultColor per globals-map §5: lead/small/label/micro/section muted). Run → pass. Commit `feat(foundation): typography specs, motion tokens, shadow specs`.

### Task 4: Theme scope, DsText, effects, motion widgets

**Files:** Create `lib/src/theme_scope.dart`, `lib/src/effects/page_glow.dart`, `lib/src/effects/machine_surface.dart`, `lib/src/motion/press.dart`, `lib/src/motion/lift.dart`, `lib/src/motion/sliding_pill.dart`; Test `test/theme_scope_test.dart`, `test/machine_surface_test.dart`.
**Interfaces:** Consumes Tasks 2–3. Produces `DsTheme`, `DsThemeController`, `DsThemeMode`, `DsText`, `DsPageGlow`, `DsMachineSurface`, `DsPress`, `DsLift`, and `DsSlidingPillGroup`:
```dart
class DsSlidingPillGroup extends StatefulWidget {
  // children laid out in a row; activeIndex drives one travelling pill behind them.
  // Travel: position/size 250ms DsCurves.spring, opacity 150ms out; hidden until first layout;
  // first placement without animation; every arrival replays jelly:
  // TweenSequence scale (x,y): (1,1)→30%(1.18,0.82)→45%(0.88,1.12)→60%(1.06,0.94)→78%(0.98,1.02)→100%(1,1), 600ms, DsCurves.out.
  DsSlidingPillGroup({required int activeIndex, required Widget pill, required List<Widget> children,
    EdgeInsets padding, double gap});
}
```
**Steps:**
- [ ] Failing widget tests: `DsTheme` with mode dark resolves `DsThemeData.dark`; `setMode(light)` notifies and rebuilds a dependent; `DsText('Remaining supply', DsType.label)` renders `REMAINING SUPPLY` uppercase; system mode follows `MediaQuery.platformBrightness`. MachineSurface golden-lite: paints without error for `DsShadows.btn` (inset) and e3 (outer) inside a 100×40 RRect.
- [ ] Implement. DsMachineSurface: outer layers via BoxShadow list; inset layers painted in a CustomPainter clipped to the RRect using difference-path ring + MaskFilter blur with `Shadow.convertRadiusToSigma` (recorded decision). DsPress: Listener down → AnimatedScale 40ms linear to scale; up/cancel → 250ms spring back. DsLift: MouseRegion hover flag; builder decides transform/shadow/border (250ms out for transform+shadow, 250ms standard for border per `lift` utility). Run → pass. Commit `feat: theme scope, DsText, page glow, machine surface, press/lift/sliding pill`.

### Task 5: DsIcon (embedded Lucide), DsButton, DsSheet

**Files:** Create `lib/src/components/icon.dart`, `lib/src/components/icon_paths.dart`, `lib/src/components/button.dart`, `lib/src/components/sheet.dart`; Test `test/components_test.dart`.
**Interfaces:** Consumes Tasks 2–4. Produces `DsIcon`, `DsIconGlyph/Size/Tone`, `DsButton`, `DsButtonVariant/Size`, `DsSheet` per API Contract.
**Steps:**
- [ ] Extract exact SVG geometry for the 8 glyphs from the reference's `node_modules/lucide-react/dist/esm/icons/{menu,x,sun,monitor,moon,arrow-left,arrow-right,check}.js` (each is a list of SVG elements: paths/lines/circles/rects on a 24×24 grid). Embed as const data in `icon_paths.dart` with the lucide version noted. Paint via CustomPainter: stroke only, round caps/joins, strokeWidth from the web formula `48/px` clamped (>2.6→2.4, <1.5→1.6).
- [ ] Failing tests: DsIcon md renders 16×16; stroke for `DsIconSize.xl` == 2.0 and `xl2` == 1.5; tone muted resolves `mutedForeground`.
- [ ] DsButton per `shared-map.md` §5 Button: pill radius, border transparent default; outline = border input + card fill + `DsShadows.btn` (MachineSurface) + hover muted; ghost = mutedForeground text, hover secondary bg + foreground text; sizes sm h-32 / md h-40 / icon 40×40 / icon-sm 32×32; press feel = DsPress at 0.95 + 80ms active transitions (btn-spring). DsSheet.showLeft: barrier `background@15%` + BackdropFilter blur 4 (blur-xs), panel width param, slide-in-from-left 40px + fade 320ms `DsCurves.out`, dismiss reverses faster (250ms inOut).
- [ ] Run tests → pass. Commit `feat(components): DsIcon with embedded lucide paths, DsButton outline/ghost, DsSheet`.

### Task 6: Example app — nav data, shell, theme toggle, routing

**Files:** Create `example/lib/nav.dart`, `example/lib/shell.dart`, `example/lib/logo.dart`, `example/lib/theme_toggle.dart`, `example/lib/pages/placeholder.dart`, rewrite `example/lib/main.dart`; Test `example/test/shell_test.dart`.
**Interfaces:** Consumes package API. Produces `dsGroups`/`siblings`/`categoryHref` (verbatim from `design-system/lib/ds/nav.ts` — read the file itself, lines 32–583, ALL blurbs/contents), `DocsShell`, `AppRouter` (`ValueNotifier<String> route` + `navigate(String href)`), `Logo`, `ThemeToggle`, `PlaceholderPage(title)`.
Reference: `shell-map.md` §3–4, `shared-map.md` §1, `overview-map.md` §0.
**Steps:**
- [ ] nav.dart first + test: foundations order colors→typography→spacing→shadows→motion→icons; `siblings('foundations','colors')` == (prev null, next Typography `/design-system/typography`); base group has 14 categories.
- [ ] Shell per maps: 64px sticky header (85% bg + blur 24 over content), Logo (28px action tile, chevron `M6 15.5 12 6l6 9.5` primaryForeground stroke 2.4 square caps + underline `M6 19h12` valueBright, wordmark `ELATTAR` + `.DS` valueInk, press effect), version pill `Design System v0.1` (micro, pill border, px-10 py-4; ≥640 only), tagline `Desktop-first · 1440 frame · Light & dark` (micro; ≥768 only), ThemeToggle (radiogroup: muted pill container p-2 gap-1px; 3 options 28×28, icons 14px stroke 2 — direct, not DsIcon formula; DsSlidingPillGroup pill = card bg + e1); sidebar 240px ≥1024 (border-r, px-24 pt-40, NavTree: group label `type-label`, active group actionInk; items `type-nav` py-8 pl-16 border-l, active = action border + action@12% bg + foreground; hover border input + foreground); burger <1024 opens DsSheet 288px with Logo header + NavTree; main px-24 py-48 (≥1024 px-48) with centered 1080 column; DsPageGlow behind everything; thin scrollbar; shell width cap 1680 centered.
- [ ] main.dart: DsTheme root (default dark), WidgetsApp/MaterialApp(debug banner off, DefaultSelectionStyle selection action@35%), route switching: known routes → pages (placeholder for all but the 4), title `Elattar's Design System`.
- [ ] Widget test: shell renders header texts; sidebar shows all 4 group titles and 32 category labels at 1440 width; navigating to `/design-system/colors` marks that item active. Run → pass. Commit `feat(example): nav data, docs shell, theme toggle, routing`.

### Task 7: Example — kit + token swatch engine

**Files:** Create `example/lib/kit.dart`, `example/lib/token_swatch.dart`; Test `example/test/kit_test.dart`, `example/test/contrast_test.dart`.
**Interfaces:** Consumes package API + nav. Produces every kit widget + swatch API from the API Contract. Anatomy source: `shared-map.md` §2–3 (exact paddings, radii, type classes, colors per widget — implement ALL listed details: header mb-56 pb-40 border-b; section mb-80, h2=type-h3, desc small mt-8 max-w-672; Panel xl radius card bg + muted header strip px-20 py-12 + background body p-24; Note lg radius p-20 tone washes 8%/30% border, title label mb-8 ALWAYS mutedForeground; Meta dl rows grid 208px key col, divide-y; Code chip: code style, sm radius, card bg, border, px-6 py-2, mutedForeground; DoDont value/destructive 6% washes, 25% borders, Check/X sm icons value/error tones; IndexCard xl radius card p-20 lift hover border action@45, arrow md muted → translate-x-2 + actionInk 150ms; group variant p-28; PageFootNav mt-32 pt-32 border-t, press cards px-20 py-16 lg radius hover border-input, micro caption + small title).
**Steps:**
- [ ] Contrast engine failing tests: `dsContrastRatio(white, dsHsl(240,10,3.9))` ≈ 19.0 (±0.15); `DsThemeData.dark`: mutedForeground vs background ≈ 13.5; light valueDark vs white ≈ 5.0; light action vs white ≈ 4.6; badge strings: `Contrast 13.5:1 · AAA`, `Contrast 4.0:1 · AA large / UI only` for dark valueDark (raw 3.98), `Contrast 1.9:1 · Fails` for light actionBright. Verdict thresholds ≥7/≥4.5/≥3 on the RAW ratio; printed number `toStringAsFixed(1)`.
- [ ] `DsTokenRegistry.printedValue` returns the raw CSS text exactly as the web page shows (`hsl(240 10% 3.9%)`, `#a3e635`, `hsl(0 72.2% 50.6%)`) — table in `colors-map.md` §5–8.
- [ ] Implement kit; widget tests for DsNote title color (muted in all tones) and DsSection anatomy. Run → pass. Commit `feat(example): docs kit + live contrast token swatches`.

### Task 8: Overview page

**Files:** Create `example/lib/pages/overview.dart`; Test `example/test/overview_test.dart`.
**Interfaces:** Consumes kit + nav. Route `/design-system`. Content contract: `overview-map.md` §1–5 VERBATIM (header eyebrow `Elattar's Design System`, h1 `Design System`, lead blurb; #foundations: IndexGrid 6 cards from nav data (1/2/3 cols at <640/≥640/≥1280, gap 16); #components: 3 group cards grid md:2 (p-28 variant, `N sets` labels 14/6/6, arrow 20px quirk kept); #rules: 6 rows ol card, num-sm actionInk `01`–`06`, strong foreground lead + small muted detail; closing value Note `Scope of this phase`).
**Steps:** failing test asserting presence of 6 card titles + `14 sets` + rule 4 text `Two faces only.` → implement → pass → commit `feat(example): overview page`.

### Task 9: Colors page

**Files:** Create `example/lib/pages/colors.dart`; Test `example/test/colors_page_test.dart`.
**Interfaces:** Consumes kit + swatches. Route `/design-system/colors`. Content: `colors-map.md` §2–10 VERBATIM — header + 5 chips; lead action Note `Measured, not asserted` (with Code chips `app/globals.css`, `RULES.md`); #monochrome 6 swatches (measure off for background/card/muted/accent) + value Note `The one step that is not a mirror`; #action 4 rows + action Note; #value 4 rows (order ink, mid, bright, dark); #state 4 rows + value Note (typo `in the same same row` kept); #beyond 2 Panels `Texture`/`Meaning` (em italics + Code chips); foot-nav (prev spacer, next Typography).
**Steps:** failing test asserting swatch count (18 rows), badge string `Contrast 13.5:1 · AAA` under dark default, and the typo string → implement → pass → commit `feat(example): colors page with live measurement`.

### Task 10: Typography page

**Files:** Create `example/lib/pages/typography.dart`; Test `example/test/typography_page_test.dart`.
**Interfaces:** Consumes kit. Route `/design-system/typography`. Content: `typography-map.md` §1–8 VERBATIM — header + 7 chips; #rule 2 panels (`Aa` display specimen; `0123` numXl valueInk) + action Note `The rule`; #words 10 Spec rows (local Spec widget: 240px left col ≥1024, `.class` code actionInk + use small; sample right); #numbers 5 rows + `Why tabular matters` Panel (note `font-variant-numeric: tabular-nums`; left tabular list vs right `type-section` proportional list with the 4 money values); #pairing 3 cards; #prose full prose demo inside Panel `Long-form content` (note `max-w-(--width-prose) · 720px`, body p-24/≥640 p-40): h2/h3/h4-as-label/p/links(#prose scroll)/nested ul/blockquote/ol/hr/table with th muted band — implement a small `Prose` widget set locally with the globals-map §6 rhythm values; 6-item Meta; error Note `Two mechanisms that do not work`; #rules DoDont (4+4 verbatim); foot-nav Colors ↔ Spacing & Layout.
**Steps:** failing test asserting all 10 Spec class names, sample `Pull something legendary`, Meta key `--width-prose` → implement → pass → commit `feat(example): typography page`.

### Task 11: Spacing page

**Files:** Create `example/lib/pages/spacing.dart`; Test `example/test/spacing_page_test.dart`.
**Interfaces:** Consumes kit. Route `/design-system/spacing`. Content: `spacing-map.md` §1–8 VERBATIM — header + 6 chips; #scale 10 rows (cols 64/80/flex ≥640; `h-3 rounded-sm bg-action` bar exactly N px wide) + error Note `The only spacing rule`; #radius Panel `Seven steps` (7 boxes 144w/96h muted fill input border, radius = value, `999` special-case) ; #elevation Panel `Neutral depth` (4 boxes e1–e4) + Panel `Rationed glow` note `Selected · rare · premium only` (glow-action box border action@40, glow-value box, em italics in captions); #grid Meta 8 rows (`--width-page` copy 1320 kept vs token 1200) + Panel `12 columns · 24px gutters` (12 cells h-80 action@12% radius sm, numerals 1–12 num-sm actionInk); #breakpoints Meta 5 rows + action Note `Why the scale was not overridden` (3 Code chips); #rules DoDont; foot-nav Typography ↔ Shadows.
**Steps:** failing test asserting bar widths list `4,8,12,16,24,32,40,48,64,80`, the `1320px` copy, and radius `999` cell → implement → pass → commit `feat(example): spacing page`.

### Task 12: Full gate

**Files:** none new (fixes only).
- [ ] `flutter analyze` (package + example) clean; `flutter test` + `example: flutter test` all green; guard passes over the full tree.
- [ ] `cd example && flutter build web --release` succeeds.
- [ ] Commit `chore: phase-1 gate — analyze/test/build green`.

### Task 13: Rendered side-by-side verification (main session drives)

- [ ] Start reference `npm run dev` (web repo) and `flutter run -d web-server` (example).
- [ ] In-app browser, 1440-wide: per page (overview, colors, typography, spacing) × theme (dark, light): screenshot reference vs port at matching scroll offsets; compare section by section (layout metrics, type, colors, badges, copy). Log every mismatch as a fix item; dispatch fix agents; re-verify.
- [ ] Interaction checks: lift hover, press, pill travel + jelly, sidebar active, prose link.
- [ ] Only after zero visible diffs: final commit + honest report (measured vs looked-at).
