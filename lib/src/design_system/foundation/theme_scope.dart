/// The scope layer: who holds the theme, and how a `.type-*` class reaches the
/// screen.
///
/// The reference does both of these in the platform. `next-themes` writes
/// `class="light"`/`class="dark"` onto `<html>` and every token re-resolves by
/// cascade; a `.type-label` element inherits its colour from whatever surface
/// it lands on. Flutter has neither a cascade nor inheritance, so both jobs
/// become explicit: [ThemeScope] is the cascade, [StyledText] is the class.
///
/// Nothing here restates a token — every value comes from
/// `lib/src/foundation/`.
library;

import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Icon,
        OverlayPortal,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;

import './theme.dart';
import './typography.dart';
import './text_layout.dart';

/// The three-way choice the toggle offers — `next-themes` with `enableSystem`.
///
/// Ordered light → system → dark, which is the order the segmented control
/// paints them (the lineage theme-toggle source).
enum ColorMode {
  /// Force `.light`.
  light,

  /// Follow the OS.
  system,

  /// Force `.dark`.
  dark,
}

/// Holds the chosen [ColorMode] and tells the tree when it changes.
///
/// A [ChangeNotifier] rather than app state so the mode can live above the
/// router and outlive any page. `defaultTheme="dark"` in the reference's
/// `ThemeProvider`, so [ColorMode.dark] is the default here too.
class ThemeController extends ChangeNotifier {
  // A private field cannot be a named initialising formal, and the parameter
  // has to stay named `mode` for call sites to read.
  // ignore: prefer_initializing_formals
  ThemeController({ColorMode mode = ColorMode.dark}) : _mode = mode;

  ColorMode _mode;

  /// The mode the user chose — not necessarily the theme being rendered; see
  /// [resolve].
  ColorMode get mode => _mode;

  /// Switches mode, notifying only when something actually changed.
  ///
  /// The guard matters: the toggle's three options all call this, including
  /// the one already selected, and a notification there would re-run every
  /// dependent build for nothing.
  void setMode(ColorMode value) {
    if (value == _mode) return;
    _mode = value;
    notifyListeners();
  }

  /// The theme that should actually paint, given what the platform reports.
  ///
  /// [platformBrightness] is consulted only in [ColorMode.system]; the two
  /// explicit modes ignore it, exactly as a forced `.light`/`.dark` class
  /// ignores `prefers-color-scheme`.
  ResolvedColorMode resolve(Brightness platformBrightness) => switch (_mode) {
    ColorMode.light => ResolvedColorMode.light,
    ColorMode.dark => ResolvedColorMode.dark,
    ColorMode.system =>
      platformBrightness == Brightness.dark
          ? ResolvedColorMode.dark
          : ResolvedColorMode.light,
  };
}

/// The cascade: puts a [ThemeController] over a subtree so every descendant
/// can resolve tokens against the live theme.
///
/// An [InheritedNotifier] rather than a plain [InheritedWidget] so a mode
/// change rebuilds dependents without the app having to hold and lift state.
class ThemeScope extends InheritedNotifier<ThemeController> {
  const ThemeScope({
    super.key,
    required ThemeController controller,
    required super.child,
  }) : super(notifier: controller);

  /// The resolved token set for [context] — the call every widget makes.
  ///
  /// Subscribes to both inputs that can change it: the controller (mode) and,
  /// in [ColorMode.system], the platform brightness.
  static ThemeTokens of(BuildContext context) => switch (kindOf(context)) {
    ResolvedColorMode.light => ThemeTokens.light,
    ResolvedColorMode.dark => ThemeTokens.dark,
  };

  /// Which of the two theme blocks is live for [context].
  static ResolvedColorMode kindOf(BuildContext context) {
    final ThemeController controller = controllerOf(context);
    if (controller.mode != ColorMode.system) {
      // The argument is ignored in the explicit modes, so do not create a
      // dependency on platform brightness that would rebuild for nothing.
      return controller.resolve(Brightness.dark);
    }
    return controller.resolve(_platformBrightnessOf(context));
  }

  /// The controller governing [context], subscribing to its changes.
  ///
  /// The theme toggle needs this: it renders the chosen [mode], not the
  /// resolved [ResolvedColorMode] — `system` has to look selected even when it is
  /// currently painting dark.
  static ThemeController controllerOf(BuildContext context) {
    final ThemeScope? scope = context
        .dependOnInheritedWidgetOfExactType<ThemeScope>();
    assert(
      scope != null,
      'No ThemeScope found above this widget. Wrap the app in a ThemeScope with a '
      'ThemeController — it is the port of ThemeProvider on <html>.',
    );
    return scope!.notifier!;
  }

  /// The chosen mode for [context], subscribing to its changes.
  static ColorMode modeOf(BuildContext context) => controllerOf(context).mode;

  /// `prefers-color-scheme`, or the platform's own answer when no
  /// [MediaQuery] is in scope (a bare `runApp`, or a widget test that did not
  /// bother to install one).
  static Brightness _platformBrightnessOf(BuildContext context) =>
      MediaQuery.maybePlatformBrightnessOf(context) ??
      WidgetsBinding.instance.platformDispatcher.platformBrightness;
}

/// The two `clamp()` type sizes, measured against the live viewport.
///
/// CSS resolves `4.4vw` continuously against the viewport width; Flutter has
/// to be told to look. These are the only two classes that need it, so they
/// get named accessors rather than a general mechanism.
class Fluid {
  const Fluid._();

  /// `.type-display` — `clamp(2.75rem, 4.4vw, 4rem)`.
  static double display(BuildContext context) =>
      TextStyles.displaySize(MediaQuery.sizeOf(context).width);

  /// `.type-h1` — `clamp(2rem, 2.8vw, 2.5rem)`.
  static double h1(BuildContext context) =>
      TextStyles.h1Size(MediaQuery.sizeOf(context).width);
}

/// Renders one `.type-*` class.
///
/// The class decides everything the CSS class decides — family, size, leading,
/// weight, tracking, tabular figures, `text-transform`, and the colour the
/// class sets **on itself**. The call site decides only what the markup
/// decides: the string, and any override the surface applies.
///
/// Colour resolution mirrors the cascade, in order:
/// 1. an explicit [color] (the `text-*` utility on the element);
/// 2. the class's own `color` declaration ([TextStyleToken.defaultColor]);
/// 3. inheritance — the nearest [DefaultTextStyle], falling back to
///    `--foreground`, which is what `<body>` sets.
class StyledText extends StatelessWidget {
  const StyledText(
    this.text,
    this.spec, {
    super.key,
    this.color,
    this.fontSize,
    this.align,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.textDirection,
    this.inline = false,
  });

  /// The string as authored. Any `text-transform` is applied at paint time,
  /// never to the source — the same as CSS, and it keeps copy greppable.
  final String text;

  /// The `.type-*` class to render.
  final TextStyleToken spec;

  /// Overrides the colour the class would resolve to.
  final Color? color;

  /// The resolved px size.
  ///
  /// Required for the classes whose size is not a constant — `.type-display`
  /// and `.type-h1` (see [Fluid]) and `.type-accent` (see
  /// [TextStyles.accentSize]); an override for every other class.
  final double? fontSize;

  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final TextDirection? textDirection;

  /// Renders the class as a CSS **inline** box rather than a block one — the
  /// `<code>` chip, whose own box is glyph-tall and whose `line-height` shapes
  /// only the sentence around it. See [TextStyleToken.resolveInline].
  final bool inline;

  /// The [TextStyle] [spec] resolves to in [context].
  ///
  /// Exposed for the places a widget is not enough: an [InlineSpan] inside a
  /// `Text.rich`, a [DefaultTextStyle] wrapping a subtree, a `.type-code` chip
  /// spliced into a sentence.
  static TextStyle styleOf(
    BuildContext context,
    TextStyleToken spec, {
    Color? color,
    double? fontSize,
    bool inline = false,
  }) {
    final double? size = fontSize ?? spec.size;
    assert(
      size != null,
      'This class has no intrinsic size — pass fontSize. '
      '.type-display and .type-h1 take Fluid.display/h1(context); '
      '.type-accent takes TextStyles.accentSize(inheritedSize).',
    );
    final Color ink = color ?? _colorOf(context, spec);
    return inline ? spec.resolveInline(size!, ink) : spec.resolve(size!, ink);
  }

  static Color _colorOf(BuildContext context, TextStyleToken spec) {
    final ThemeTokens theme = ThemeScope.of(context);
    return switch (spec.defaultColor) {
      TextColorRole.foreground => theme.foreground,
      TextColorRole.muted => theme.mutedForeground,
      // No `color` declaration: inherit, then fall back to what `<body>` sets.
      TextColorRole.none =>
        DefaultTextStyle.of(context).style.color ?? theme.foreground,
    };
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle style = styleOf(
      context,
      spec,
      color: color,
      fontSize: fontSize,
      inline: inline,
    );
    final Widget paragraph = Text(
      spec.uppercase ? text.toUpperCase() : text,
      style: style,
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      textDirection: textDirection,
    );
    return LineBox(
      style: style,
      // An inline box is measured by the font's content area rather than by
      // any line box — see [contentAreaHeight].
      lineHeight: inline ? contentAreaHeight(style) : null,
      child: paragraph,
    );
  }
}

/// [StyledText] for a span tree — a sentence carrying code chips, an emphasis, a
/// second colour — rather than one flat string.
///
/// The class states the paragraph's own style, exactly as the element's
/// `.type-*` class does in the reference; the spans below it override only
/// what the markup overrides.
class RichText extends StatelessWidget {
  const RichText(
    this.span,
    this.spec, {
    super.key,
    this.color,
    this.fontSize,
    this.align,
    this.maxLines,
    this.overflow,
    this.textDirection,
  });

  final InlineSpan span;

  /// The `.type-*` class the paragraph itself carries.
  final TextStyleToken spec;

  final Color? color;
  final double? fontSize;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    final TextStyle style = StyledText.styleOf(
      context,
      spec,
      color: color,
      fontSize: fontSize,
    );
    return LineBox(
      style: style,
      child: Text.rich(
        // Inline boxes reach the line breaker as a breakable-anywhere object;
        // CSS treats them as the text they hold. See [glueInlineBoxes].
        glueInlineBoxes(span, style),
        style: style,
        textAlign: align,
        maxLines: maxLines,
        overflow: overflow,
        textDirection: textDirection,
      ),
    );
  }
}

/// [duration], or nothing at all when the platform asks for reduced motion.
///
/// Design spec §5: `MediaQuery.disableAnimations` is the port of
/// `prefers-reduced-motion`. Every animated widget in this package routes its
/// durations through here, so one OS switch stills the whole system.
Duration effectiveMotionDuration(BuildContext context, Duration duration) =>
    MediaQuery.maybeDisableAnimationsOf(context) ?? false
    ? Duration.zero
    : duration;
