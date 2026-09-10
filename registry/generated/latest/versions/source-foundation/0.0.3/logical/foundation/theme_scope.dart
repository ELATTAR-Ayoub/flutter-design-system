/// The scope layer: who holds the theme, and how a type role reaches the screen.
///
/// [ThemeScope] puts the live token set over a subtree, so every component can
/// ask for colour by semantic role and get the answer for the theme actually
/// painting. [StyledText] renders one type role against that scope and the
/// width in play. [TypeWidthScope] lets a region answer that width question for
/// itself.
///
/// Nothing here restates a token — every value comes from
/// `lib/src/design_system/foundation/`.
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
      'ThemeController — it is what every semantic colour resolves against.',
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

/// Overrides the width type roles resolve their responsive step against.
///
/// A role picks its step from the viewport by default, which is right for page
/// copy. A component rendered into a narrow region of a wide window — a sheet,
/// a side panel, a dashboard column — can put its own measured width in scope
/// so headings inside it step down with the region rather than with the screen.
class TypeWidthScope extends InheritedWidget {
  const TypeWidthScope({super.key, required this.width, required super.child});

  /// The width, in logical pixels, roles below this scope resolve against.
  final double width;

  /// The width in scope for [context], or the viewport width when none is set.
  static double of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<TypeWidthScope>()?.width ??
      MediaQuery.sizeOf(context).width;

  @override
  bool updateShouldNotify(TypeWidthScope oldWidget) => oldWidget.width != width;
}

/// Renders one type role.
///
/// The role decides shape and rhythm — face, size, line height, weight,
/// tracking, and numeric features — resolved for the width in scope. The call
/// site decides the string and the ink.
///
/// Colour resolution, in order:
/// 1. an explicit [color], which is how a component states semantic ink;
/// 2. the nearest [DefaultTextStyle], which is how a surface tints a subtree;
/// 3. the theme's `foreground`.
///
/// No role carries a colour of its own. Muted, destructive, success, link, and
/// inverse ink are chosen by the component or the surface, never by the size of
/// the text.
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

  /// The string as authored.
  final String text;

  /// The type role to render.
  final TextStyleToken spec;

  /// The ink. Omit to inherit from the surrounding [DefaultTextStyle].
  final Color? color;

  /// Overrides the resolved size while keeping the role's leading ratio.
  ///
  /// For anatomy that must size text to a container it shares with something
  /// else. Ordinary call sites leave it null and let the role resolve.
  final double? fontSize;

  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final TextDirection? textDirection;

  /// Renders the role as an **inline** box rather than a block one — a code
  /// chip whose own box is glyph-tall and which lets the sentence around it own
  /// the line. See [TextStyleToken.resolveInline].
  final bool inline;

  /// The [TextStyle] [spec] resolves to in [context].
  ///
  /// Exposed for the places a widget is not enough: an [InlineSpan] inside a
  /// `Text.rich`, a [DefaultTextStyle] wrapping a subtree, a code chip spliced
  /// into a sentence.
  static TextStyle styleOf(
    BuildContext context,
    TextStyleToken spec, {
    Color? color,
    double? fontSize,
    bool inline = false,
  }) {
    final double width = TypeWidthScope.of(context);
    final Color ink = color ?? _inheritedInk(context);
    return inline
        ? spec.resolveInline(width, ink, fontSize: fontSize)
        : spec.resolveWidth(width, ink, fontSize: fontSize);
  }

  /// The step [spec] resolves to in [context] — size and leading in logical
  /// pixels, before any text scaling.
  static TypeStep stepOf(BuildContext context, TextStyleToken spec) =>
      spec.stepFor(TypeWidthScope.of(context));

  /// `WidgetsApp`'s error style: the red, double-underlined, 48px monospace
  /// run it installs at the root for anything that never reaches a `Material`
  /// or `CupertinoTheme`.
  ///
  /// It is a diagnostic, not a colour choice, and a design system that adopted
  /// it as inherited ink would paint whole screens red the moment an app root
  /// forgot its own `DefaultTextStyle`.
  static const Color _frameworkErrorInk = Color(0xD0FF0000);

  /// The ink a role inherits when the call site names none.
  ///
  /// The surrounding [DefaultTextStyle], unless it is the framework's
  /// fallback; then the theme's foreground, which is what the surface would
  /// have said.
  ///
  /// The substitution is a release-mode safety net, not a licence to skip the
  /// root style: in debug it asserts instead, so a missing [DefaultTextStyle]
  /// is loud where it can still be fixed and invisible only where painting a
  /// screen red would help nobody.
  static Color _inheritedInk(BuildContext context) {
    final TextStyle inherited = DefaultTextStyle.of(context).style;
    final Color? color = inherited.color;
    assert(
      color != _frameworkErrorInk,
      'No DefaultTextStyle above this StyledText, so it would inherit '
      "WidgetsApp's red fallback ink. Set one at the app shell, in the "
      'same role the shell reads its own copy in: '
      'DefaultTextStyle(style: StyledText.styleOf(context, TextStyles.body, '
      'color: ThemeScope.of(context).foreground), child: ...). In release '
      'the theme foreground is substituted instead, because painting a '
      'screen red helps nobody there.',
    );
    if (color == null || color == _frameworkErrorInk) {
      return ThemeScope.of(context).foreground;
    }
    return color;
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
      text,
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
/// The role states the paragraph's own style; the spans below it override only
/// what they mean to change.
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

  /// The type role the paragraph itself carries.
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
