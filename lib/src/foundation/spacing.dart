/// Distance, measure and corner — the geometry half of the token set.
///
/// Source of truth: `app/globals.css` in the reference repo
/// (`D:/DESIGN/Design-System-2026-8/design-system/app/globals.css`).
/// 1 CSS `rem` = 16px throughout.
library;

/// Tailwind's spacing unit, in logical pixels.
///
/// `--spacing` is never redeclared in `globals.css`, so it keeps Tailwind v4's
/// default `0.25rem` = 4px, and every gap in that file is
/// `calc(var(--spacing) * n)`. [ds] is that multiplication: `ds(6)` is `gap-6`
/// is 24px.
double ds(num n) => n.toDouble() * 4.0;

/// The measures the shell and its pages are built on — globals.css L228–322.
///
/// These are the widths that are neither a component's own size nor a fraction
/// of the viewport; each is a `--width-*` / `--height-*` token in the reference.
class DsWidths {
  /// `--width-shell: 1680px` — globals.css L228. The outer frame the sidebar
  /// and the main column share.
  static const double shell = 1680;

  /// `--width-content: 1080px` — globals.css L229. The documentation reading
  /// column inside the shell, held to roughly 90 characters at body size.
  static const double content = 1080;

  /// `--width-page: 1200px` — globals.css L244. The cap for customer-facing
  /// pages.
  ///
  /// DOCUMENTED DRIFT: `/design-system/spacing` has described this measure in
  /// prose as "1320px" since before the token existed (L230–243). The copy
  /// ships as written and the token renders 1200; both sides are kept.
  static const double page = 1200;

  /// `--width-prose: 720px` — globals.css L245. A column carrying nothing but
  /// sentences. Deliberately not interchangeable with [content].
  static const double prose = 720;

  /// `--width-rail: 15rem` = 240px — globals.css L251. The reading rail: a
  /// table of contents, an anchor list, an article's metadata column.
  static const double rail = 240;

  /// `--width-sidebar: 16rem` = 256px — globals.css L320. The app shell's
  /// navigation panel.
  static const double sidebar = 256;

  /// `--width-sidebar-icon: 3rem` = 48px — globals.css L322. The collapsed
  /// rail; also the hit-target floor.
  static const double sidebarIcon = 48;

  /// `--width-sidebar-mobile: 18rem` = 288px — globals.css L321. Wider than
  /// [sidebar] on purpose: a sheet has no rail beside it competing for the eye.
  static const double sidebarMobile = 288;

  /// `--height-site-header: 4rem` = 64px — globals.css L290.
  static const double siteHeader = 64;

  /// The width Tailwind's bare `border` utility gives an element: 1px.
  ///
  /// Recorded because of `box-sizing: border-box`, which Tailwind sets
  /// globally: a border costs a padded component one pixel of inner width on
  /// each side. `Border.all` defaults to the same 1.0, but a component that
  /// pads inside a border has to add this back or every label sits 1px off.
  static const double hairline = 1;

  /// `--scroll-offset: calc(var(--height-site-header) + var(--spacing) * 8)`
  /// = 96px — globals.css L296. Where an anchored heading comes to rest: clear
  /// of the header, plus one 32px step of air.
  static const double scrollOffset = siteHeader + 32;
}

/// The corner ladder — globals.css L324–339.
///
/// Both theme blocks also set `--radius: 10px` (L605 / L814), which is
/// numerically [md]; it is exposed per theme as `DsThemeData.radius`.
class DsRadii {
  /// `--radius-xs: 2px` — L324. Tips and swatches only: a tooltip arrow, a
  /// chart legend key. Nothing with content in it should be this sharp.
  static const double xs = 2;

  /// `--radius-sm: 6px` — L325.
  static const double sm = 6;

  /// `--radius-md: 10px` — L326.
  static const double md = 10;

  /// `--radius-lg: 12px` — L327.
  static const double lg = 12;

  /// `--radius-xl: 16px` — L328.
  static const double xl = 16;

  /// `--radius-2xl: 20px` — L329.
  static const double xl2 = 20;

  /// `--radius-3xl: 24px` — L330.
  static const double xl3 = 24;

  /// `--radius-4xl: 32px` — L338. The soft-slab step, outside the container
  /// ladder's normal range (L331–337).
  static const double xl4 = 32;

  /// `--radius-pill: 999px` — L339.
  static const double pill = 999;

  /// The `- 3px` in `calc(var(--radius) - 3px)`.
  static const double _addonButtonInset = 3;

  /// `calc(var(--radius) - 3px)` = **7px** — the corner an `InputGroupButton`
  /// wears at its `xs` size (`components/ui/input-group.tsx:73`).
  ///
  /// The only non-pill, non-ladder radius in the system: a 24px control sitting
  /// inside a 999px pill. It is a **derived getter** rather than a ninth rung
  /// because the stylesheet writes arithmetic, and the relationship is the
  /// point — retune `--radius` and the addon button follows, which is exactly
  /// what `calc()` says. A frozen literal would silently stop tracking.
  ///
  /// The base is [md] because `--radius` resolves to 10px in *both* theme
  /// blocks (globals.css L605 / L814) — numerically the same 10 the
  /// `--radius-md` rung carries. [DsThemeData.radius] is the per-theme reading
  /// of `--radius`; if the two themes ever disagree, that is what this should
  /// be derived from instead, and this getter is the one place to change.
  static double get addonButton => md - _addonButtonInset;
}

/// Tailwind's stock blur ladder — the `--blur-*` scale, which `globals.css`
/// never redeclares, so the framework defaults render.
///
/// CSS `filter: blur(<length>)` takes the length as the Gaussian **standard
/// deviation** (Filter Effects §8.4), unlike `box-shadow`, whose blur radius
/// is twice sigma. These values therefore go straight into
/// `ImageFilter.blur(sigmaX:, sigmaY:)` with no conversion.
class DsBlurs {
  const DsBlurs._();

  /// `--blur-xs: 4px` — `backdrop-blur-xs` on the sheet overlay.
  static const double xs = 4;

  /// `--blur-xl: 24px` — `backdrop-blur-xl` on the sticky docs header and on
  /// the `glass-panel` utility.
  static const double xl = 24;
}

/// Tailwind's stock container ladder — the `--container-*` scale, which
/// `globals.css` never redeclares, so the framework defaults render.
///
/// Only the rungs the port actually reaches for are transcribed, on [DsBlurs]'s
/// precedent: a ladder with no consumer is a guess about what the reference
/// will need next.
class DsContainers {
  const DsContainers._();

  /// `--container-sm: 24rem` = **384px** — `max-w-sm`.
  ///
  /// The measure `EmptyHeader` and `EmptyContent` both cap themselves at
  /// (`components/ui/empty.tsx` L20 / L96), which is what keeps an empty
  /// state's title and its description on the same short column while the
  /// panel around them is 482px wide.
  static const double sm = 384;

  /// `--container-xs: 20rem` = **320px** — `max-w-xs`.
  ///
  /// `AlertDialogContent`'s base cap, which `sm:max-w-sm` overrules at every
  /// width the port renders at; `PopoverContent w-80` and `TooltipContent
  /// max-w-xs` both land on the same 320.
  static const double xs = 320;

  /// `--container-md: 28rem` = **448px** — `max-w-md`.
  ///
  /// `DialogContent variant="media"`'s `sm:max-w-md`, and the `max-w-md` the
  /// danger zone's description column is held to.
  static const double md = 448;

  /// `--container-2xl: 42rem` = **672px** — `max-w-2xl`, the settings column
  /// the dialogs page centres its first danger zone in.
  static const double xl2 = 672;
}

/// Tailwind's stock breakpoints, in logical pixels.
///
/// `globals.css` never redeclares `--breakpoint-*`, so the framework defaults
/// stand; the shell is desktop-first and shows its sidebar from [lg] up.
class DsBreakpoints {
  /// 640px.
  static const double sm = 640;

  /// 768px.
  static const double md = 768;

  /// 1024px.
  static const double lg = 1024;

  /// 1280px.
  static const double xl = 1280;
}
