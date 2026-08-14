/// The scope layer: who holds the theme, and how a `.type-*` class reaches the
/// screen.
///
/// The reference does both of these in the platform. `next-themes` writes
/// `class="light"`/`class="dark"` onto `<html>` and every token re-resolves by
/// cascade; a `.type-label` element inherits its colour from whatever surface
/// it lands on. Flutter has neither a cascade nor inheritance, so both jobs
/// become explicit: [DsTheme] is the cascade, [DsText] is the class.
///
/// Nothing here restates a token — every value comes from
/// `lib/src/foundation/`.
library;

import 'package:flutter/widgets.dart';

import 'foundation/theme.dart';
import 'foundation/typography.dart';
import 'text_layout.dart';

/// The three-way choice the toggle offers — `next-themes` with `enableSystem`.
///
/// Ordered light → system → dark, which is the order the segmented control
/// paints them (`components/ds/theme-toggle.tsx`).
enum DsThemeMode {
  /// Force `.light`.
  light,

  /// Follow the OS.
  system,

  /// Force `.dark`.
  dark,
}

/// Holds the chosen [DsThemeMode] and tells the tree when it changes.
///
/// A [ChangeNotifier] rather than app state so the mode can live above the
/// router and outlive any page. `defaultTheme="dark"` in the reference's
/// `ThemeProvider`, so [DsThemeMode.dark] is the default here too.
class DsThemeController extends ChangeNotifier {
  // A private field cannot be a named initialising formal, and the parameter
  // has to stay named `mode` for call sites to read.
  // ignore: prefer_initializing_formals
  DsThemeController({DsThemeMode mode = DsThemeMode.dark}) : _mode = mode;

  DsThemeMode _mode;

  /// The mode the user chose — not necessarily the theme being rendered; see
  /// [resolve].
  DsThemeMode get mode => _mode;

  /// Switches mode, notifying only when something actually changed.
  ///
  /// The guard matters: the toggle's three options all call this, including
  /// the one already selected, and a notification there would re-run every
  /// dependent build for nothing.
  void setMode(DsThemeMode value) {
    if (value == _mode) return;
    _mode = value;
    notifyListeners();
  }

  /// The theme that should actually paint, given what the platform reports.
  ///
  /// [platformBrightness] is consulted only in [DsThemeMode.system]; the two
  /// explicit modes ignore it, exactly as a forced `.light`/`.dark` class
  /// ignores `prefers-color-scheme`.
  DsThemeKind resolve(Brightness platformBrightness) => switch (_mode) {
        DsThemeMode.light => DsThemeKind.light,
        DsThemeMode.dark => DsThemeKind.dark,
        DsThemeMode.system => platformBrightness == Brightness.dark
            ? DsThemeKind.dark
            : DsThemeKind.light,
      };
}

/// The cascade: puts a [DsThemeController] over a subtree so every descendant
/// can resolve tokens against the live theme.
///
/// An [InheritedNotifier] rather than a plain [InheritedWidget] so a mode
/// change rebuilds dependents without the app having to hold and lift state.
class DsTheme extends InheritedNotifier<DsThemeController> {
  const DsTheme({
    super.key,
    required DsThemeController controller,
    required super.child,
  }) : super(notifier: controller);

  /// The resolved token set for [context] — the call every widget makes.
  ///
  /// Subscribes to both inputs that can change it: the controller (mode) and,
  /// in [DsThemeMode.system], the platform brightness.
  static DsThemeData of(BuildContext context) =>
      switch (kindOf(context)) {
        DsThemeKind.light => DsThemeData.light,
        DsThemeKind.dark => DsThemeData.dark,
      };

  /// Which of the two theme blocks is live for [context].
  static DsThemeKind kindOf(BuildContext context) {
    final DsThemeController controller = controllerOf(context);
    if (controller.mode != DsThemeMode.system) {
      // The argument is ignored in the explicit modes, so do not create a
      // dependency on platform brightness that would rebuild for nothing.
      return controller.resolve(Brightness.dark);
    }
    return controller.resolve(_platformBrightnessOf(context));
  }

  /// The controller governing [context], subscribing to its changes.
  ///
  /// The theme toggle needs this: it renders the chosen [mode], not the
  /// resolved [DsThemeKind] — `system` has to look selected even when it is
  /// currently painting dark.
  static DsThemeController controllerOf(BuildContext context) {
    final DsTheme? scope =
        context.dependOnInheritedWidgetOfExactType<DsTheme>();
    assert(
      scope != null,
      'No DsTheme found above this widget. Wrap the app in a DsTheme with a '
      'DsThemeController — it is the port of ThemeProvider on <html>.',
    );
    return scope!.notifier!;
  }

  /// The chosen mode for [context], subscribing to its changes.
  static DsThemeMode modeOf(BuildContext context) =>
      controllerOf(context).mode;

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
class DsFluid {
  const DsFluid._();

  /// `.type-display` — `clamp(2.75rem, 4.4vw, 4rem)`.
  static double display(BuildContext context) =>
      DsType.displaySize(MediaQuery.sizeOf(context).width);

  /// `.type-h1` — `clamp(2rem, 2.8vw, 2.5rem)`.
  static double h1(BuildContext context) =>
      DsType.h1Size(MediaQuery.sizeOf(context).width);
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
/// 2. the class's own `color` declaration ([DsTypeSpec.defaultColor]);
/// 3. inheritance — the nearest [DefaultTextStyle], falling back to
///    `--foreground`, which is what `<body>` sets.
class DsText extends StatelessWidget {
  const DsText(
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
  final DsTypeSpec spec;

  /// Overrides the colour the class would resolve to.
  final Color? color;

  /// The resolved px size.
  ///
  /// Required for the classes whose size is not a constant — `.type-display`
  /// and `.type-h1` (see [DsFluid]) and `.type-accent` (see
  /// [DsType.accentSize]); an override for every other class.
  final double? fontSize;

  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final TextDirection? textDirection;

  /// Renders the class as a CSS **inline** box rather than a block one — the
  /// `<code>` chip, whose own box is glyph-tall and whose `line-height` shapes
  /// only the sentence around it. See [DsTypeSpec.resolveInline].
  final bool inline;

  /// The [TextStyle] [spec] resolves to in [context].
  ///
  /// Exposed for the places a widget is not enough: an [InlineSpan] inside a
  /// `Text.rich`, a [DefaultTextStyle] wrapping a subtree, a `.type-code` chip
  /// spliced into a sentence.
  static TextStyle styleOf(
    BuildContext context,
    DsTypeSpec spec, {
    Color? color,
    double? fontSize,
    bool inline = false,
  }) {
    final double? size = fontSize ?? spec.size;
    assert(
      size != null,
      'This class has no intrinsic size — pass fontSize. '
      '.type-display and .type-h1 take DsFluid.display/h1(context); '
      '.type-accent takes DsType.accentSize(inheritedSize).',
    );
    final Color ink = color ?? _colorOf(context, spec);
    return inline ? spec.resolveInline(size!, ink) : spec.resolve(size!, ink);
  }

  static Color _colorOf(BuildContext context, DsTypeSpec spec) {
    final DsThemeData theme = DsTheme.of(context);
    return switch (spec.defaultColor) {
      DsTypeColor.foreground => theme.foreground,
      DsTypeColor.muted => theme.mutedForeground,
      // No `color` declaration: inherit, then fall back to what `<body>` sets.
      DsTypeColor.none =>
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
    return DsLineBox(
      style: style,
      // An inline box is measured by the font's content area rather than by
      // any line box — see [dsContentAreaHeight].
      lineHeight: inline ? dsContentAreaHeight(style) : null,
      child: paragraph,
    );
  }
}

/// [DsText] for a span tree — a sentence carrying code chips, an emphasis, a
/// second colour — rather than one flat string.
///
/// The class states the paragraph's own style, exactly as the element's
/// `.type-*` class does in the reference; the spans below it override only
/// what the markup overrides.
class DsRichText extends StatelessWidget {
  const DsRichText(
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
  final DsTypeSpec spec;

  final Color? color;
  final double? fontSize;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    final TextStyle style = DsText.styleOf(
      context,
      spec,
      color: color,
      fontSize: fontSize,
    );
    return DsLineBox(
      style: style,
      child: Text.rich(
        // Inline boxes reach the line breaker as a breakable-anywhere object;
        // CSS treats them as the text they hold. See [dsGlueInlineBoxes].
        dsGlueInlineBoxes(span, style),
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
Duration dsAnimationDuration(BuildContext context, Duration duration) =>
    MediaQuery.maybeDisableAnimationsOf(context) ?? false
        ? Duration.zero
        : duration;
