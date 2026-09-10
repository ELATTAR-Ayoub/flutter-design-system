/// The type system: seventeen roles, resolved for the width they render at.
///
/// A role states **shape and rhythm** — face, size, line height, weight,
/// tracking, and numeric features. It never states ink. Colour is chosen by the
/// component or the semantic surface the text sits on, through `ThemeScope`, so
/// the same role reads correctly on a card, inside an alert, and on an inverted
/// banner without a second token.
///
/// Sizes are logical pixels, and every role carries a line height in logical
/// pixels rather than a ratio: leading is a spatial decision, and stating it in
/// the same unit as the size is what makes the vertical rhythm legible in this
/// file. [TextStyleToken.resolveWidth] converts to Flutter's ratio.
///
/// Ten of the seventeen roles are one size at every width. Headings and the two
/// largest metrics step up at [Breakpoints.md] and [Breakpoints.lg], because a
/// 64px display line that is right on a desktop column is wrong on a phone.
/// Viewport steps are a layout decision and are **not** a substitute for
/// accessibility text scaling: Flutter's text scaler applies on top of whatever
/// step is resolved, and every text-bearing component must survive 200%.
///
/// This file is inside `lib/src/design_system/foundation/`, the one place
/// numeric literals live.
library;

import 'package:flutter/painting.dart';

import './spacing.dart';

/// The two faces the system ships.
class Fonts {
  const Fonts._();

  /// Words: headings, reading copy, navigation, labels.
  static const String sans = 'InterLocal';

  /// Code, identifiers, and every numeric role — the faces that need an even
  /// advance width so digits and paths line up column to column.
  static const String mono = 'GeistMono';

  /// The name of this package, threaded into every [TextStyle] this file
  /// builds.
  ///
  /// The faces are declared in the PACKAGE pubspec, so `flutter_tools` bundles
  /// them for every dependent app under the prefixed family
  /// `packages/elattar_design_system/<Family>`. `TextStyle(package: …)` applies
  /// exactly that prefix, which is why [TextStyleToken.family] stays the bare
  /// family name and the resolvers pass this: call sites never think about
  /// prefixing.
  static const String package = 'elattar_design_system';
}

/// The three groups the catalog is presented in, in order.
enum TypeGroup {
  /// Headings, reading copy, and interface words.
  words('Words'),

  /// Fixed-advance text that must be read character by character.
  code('Code and identifiers'),

  /// Metrics and figures, all tabular.
  numerics('Numerics');

  const TypeGroup(this.label);

  /// The heading this group is published under.
  final String label;
}

/// One resolved step of a role: a size and its line height, both in logical
/// pixels.
class TypeStep {
  const TypeStep(this.size, this.leading);

  /// `font-size` in logical pixels.
  final double size;

  /// The line box height in logical pixels.
  final double leading;

  /// The line height as Flutter's unitless multiplier of [size].
  double get ratio => leading / size;

  @override
  bool operator ==(Object other) =>
      other is TypeStep && other.size == size && other.leading == leading;

  @override
  int get hashCode => Object.hash(size, leading);

  @override
  String toString() => '$size/$leading';
}

/// One public type role.
///
/// A role owns [mobile] and, when it responds to width, [tablet] and [desktop].
/// A role that reads the same at every width declares only [mobile]; the
/// resolver falls back through the steps it has.
class TextStyleToken {
  /// Records one role. Pass [wght] rather than a [FontWeight]: it drives both
  /// the variable-font axis and the static fallback, so the two cannot drift.
  TextStyleToken({
    required this.name,
    required this.group,
    required this.family,
    required this.mobile,
    TypeStep? tablet,
    TypeStep? desktop,
    required this.wght,
    this.tracking,
    this.tabular = false,
    this.fontStyle = FontStyle.normal,
  }) : tablet = tablet ?? mobile,
       desktop = desktop ?? tablet ?? mobile,
       weight = _staticFallback(wght),
       variations = <FontVariation>[FontVariation(_wghtAxis, wght)];

  /// The variable-weight axis both faces expose.
  static const String _wghtAxis = 'wght';

  /// Inter Variable's optical-size axis, and the range it covers.
  ///
  /// Optical sizing keeps the face's stroke contrast and spacing correct as the
  /// size changes — without it every Inter glyph renders at the axis default
  /// and small copy sits too tight while a display line sits too loose.
  static const String _opszAxis = 'opsz';
  static const double _opszMin = 14;
  static const double _opszMax = 32;

  /// The nearest static [FontWeight] at or below a `wght` axis value, for the
  /// case where the variable axis is unavailable.
  ///
  /// `h2` asks for 650, which no [FontWeight] names; flooring to the 100-step
  /// below gives `w600`. Every other role lands on an exact step.
  static FontWeight _staticFallback(double wght) =>
      FontWeight.values[(wght ~/ 100) - 1];

  /// The public role name, as the catalog and the documentation publish it.
  final String name;

  /// Which catalog group the role belongs to.
  final TypeGroup group;

  /// The face — [Fonts.sans] or [Fonts.mono].
  final String family;

  /// Below [Breakpoints.md].
  final TypeStep mobile;

  /// [Breakpoints.md] up to [Breakpoints.lg].
  final TypeStep tablet;

  /// [Breakpoints.lg] and wider.
  final TypeStep desktop;

  /// The weight on the variable axis.
  final double wght;

  /// The static weight step, derived from [wght].
  final FontWeight weight;

  /// The variable-font axis settings — `wght` at the exact declared value.
  final List<FontVariation> variations;

  /// Letter spacing in **em**; the resolvers multiply it by the resolved size.
  /// Null when the role tracks naturally.
  final double? tracking;

  /// Tabular figures — every numeric role, so columns of digits align.
  final bool tabular;

  /// Slant. No public role is italic; component anatomy that needs emphasis —
  /// rendered markdown, a quotation — derives it.
  final FontStyle fontStyle;

  /// True when the role reads the same at every width.
  bool get isStatic => mobile == tablet && tablet == desktop;

  /// The single step of a role that does not respond to width.
  ///
  /// For the places that must know a line box before there is a
  /// [BuildContext] to resolve against — overlay placement that counts rows
  /// before the menu is laid out. A responsive role has no such answer, so
  /// asking one for it is a programming error: resolve it with
  /// `StyledText.stepOf(context, role)` instead.
  TypeStep get step {
    assert(
      isStatic,
      'Role "$name" resolves differently by width. Use '
      'StyledText.stepOf(context, role) or stepFor(width).',
    );
    return mobile;
  }

  static const List<FontFeature> _tabularFigures = <FontFeature>[
    FontFeature.tabularFigures(),
  ];

  /// The step this role uses at [width] logical pixels of available space.
  TypeStep stepFor(double width) {
    if (width >= Breakpoints.lg) return desktop;
    if (width >= Breakpoints.md) return tablet;
    return mobile;
  }

  /// The [TextStyle] for this role at [width], in [color].
  ///
  /// [fontSize] overrides the resolved size while keeping the step's leading
  /// ratio, for the rare anatomy that must size text to a container it shares
  /// with something else.
  TextStyle resolveWidth(double width, Color color, {double? fontSize}) =>
      resolveStep(stepFor(width), color, fontSize: fontSize);

  /// The [TextStyle] for an explicit [step].
  TextStyle resolveStep(TypeStep step, Color color, {double? fontSize}) =>
      _style(fontSize ?? step.size, color, step.ratio);

  /// The role as an **inline** box: the same glyphs with no line height of its
  /// own, so a code chip spliced into a sentence contributes its content area
  /// and lets the surrounding paragraph own the line.
  TextStyle resolveInline(double width, Color color, {double? fontSize}) =>
      _style(fontSize ?? stepFor(width).size, color, null, inherit: false);

  /// A component-internal variation of this role.
  ///
  /// Anatomy sometimes needs one property changed — a button label at medium
  /// weight, a metric that should not be tabular. Deriving keeps the size,
  /// leading, and responsive behaviour of the public role while letting the
  /// component state the difference. It creates no new public role: the result
  /// is private to the component that derives it, and [name] records where it
  /// came from.
  TextStyleToken derive({
    String? name,
    double? wght,
    double? tracking,
    bool? tabular,
    String? family,
    FontStyle? fontStyle,
  }) => TextStyleToken(
    name: name ?? this.name,
    group: group,
    family: family ?? this.family,
    mobile: mobile,
    tablet: tablet,
    desktop: desktop,
    wght: wght ?? this.wght,
    tracking: tracking ?? this.tracking,
    tabular: tabular ?? this.tabular,
    fontStyle: fontStyle ?? this.fontStyle,
  );

  TextStyle _style(
    double fontSize,
    Color color,
    double? lineHeight, {
    bool inherit = true,
  }) {
    final double? em = tracking;
    return TextStyle(
      // A null `height` means "no line height of my own", and `Text` merges an
      // ambient [DefaultTextStyle] into whatever it is given — so an inline box
      // would silently pick the surrounding paragraph's ratio back up. Standing
      // outside inheritance is the only way to say nothing at all.
      inherit: inherit,
      color: color,
      fontFamily: family,
      package: Fonts.package,
      fontSize: fontSize,
      height: lineHeight,
      // Split the leading evenly above and below the glyphs rather than in the
      // ratio of the face's ascent to its descent. Even leading is what keeps a
      // line centred in the box the role declares, which is what makes the
      // stated line heights above mean what they say.
      leadingDistribution: TextLeadingDistribution.even,
      fontWeight: weight,
      fontStyle: fontStyle,
      fontVariations: _variationsFor(fontSize),
      letterSpacing: em == null ? null : em * fontSize,
      fontFeatures: tabular ? _tabularFigures : null,
    );
  }

  List<FontVariation> _variationsFor(double fontSize) {
    if (family != Fonts.sans) return variations;
    return <FontVariation>[
      ...variations,
      FontVariation(_opszAxis, fontSize.clamp(_opszMin, _opszMax)),
    ];
  }
}

/// The seventeen public type roles.
///
/// Ten Words, two Code and identifiers, five Numerics. There is no role for a
/// label, a chip, an eyebrow, a caption, a tag, or a wordmark: those are
/// component anatomy, and a component derives what it needs from the role
/// closest to its meaning rather than adding a size to this scale.
class TextStyles {
  const TextStyles._();

  // ── Words ────────────────────────────────────────────────────────────────

  /// The one line that opens a page or a marketing surface. At most one per
  /// screen.
  static final TextStyleToken display = TextStyleToken(
    name: 'display',
    group: TypeGroup.words,
    family: Fonts.sans,
    mobile: const TypeStep(44, 48),
    tablet: const TypeStep(52, 56),
    desktop: const TypeStep(64, 68),
    wght: 600,
    tracking: -0.03,
  );

  /// The page title.
  static final TextStyleToken h1 = TextStyleToken(
    name: 'h1',
    group: TypeGroup.words,
    family: Fonts.sans,
    mobile: const TypeStep(36, 40),
    tablet: const TypeStep(40, 44),
    desktop: const TypeStep(48, 52),
    wght: 700,
    tracking: -0.02,
  );

  /// A major section heading.
  static final TextStyleToken h2 = TextStyleToken(
    name: 'h2',
    group: TypeGroup.words,
    family: Fonts.sans,
    mobile: const TypeStep(30, 36),
    tablet: const TypeStep(32, 38),
    desktop: const TypeStep(36, 42),
    wght: 650,
    tracking: -0.015,
  );

  /// A subsection heading.
  static final TextStyleToken h3 = TextStyleToken(
    name: 'h3',
    group: TypeGroup.words,
    family: Fonts.sans,
    mobile: const TypeStep(24, 30),
    tablet: const TypeStep(26, 32),
    desktop: const TypeStep(28, 36),
    wght: 600,
    tracking: -0.01,
  );

  /// The smallest heading — a card title, an alert title, an accordion trigger.
  static final TextStyleToken h4 = TextStyleToken(
    name: 'h4',
    group: TypeGroup.words,
    family: Fonts.sans,
    mobile: const TypeStep(20, 26),
    tablet: const TypeStep(22, 28),
    desktop: const TypeStep(24, 30),
    wght: 600,
  );

  /// The standfirst under a title: one paragraph, larger than body.
  static final TextStyleToken lead = TextStyleToken(
    name: 'lead',
    group: TypeGroup.words,
    family: Fonts.sans,
    mobile: const TypeStep(18, 28),
    tablet: const TypeStep(20, 30),
    desktop: const TypeStep(20, 30),
    wght: 400,
  );

  /// Reading copy. The default for anything a person reads in sentences.
  static final TextStyleToken body = TextStyleToken(
    name: 'body',
    group: TypeGroup.words,
    family: Fonts.sans,
    mobile: const TypeStep(16, 24),
    wght: 400,
  );

  /// Supporting copy beside body: a field description, a row's second line, a
  /// timestamp. It is a size, not a colour — pass muted ink when the copy is
  /// genuinely secondary.
  static final TextStyleToken small = TextStyleToken(
    name: 'small',
    group: TypeGroup.words,
    family: Fonts.sans,
    mobile: const TypeStep(14, 20),
    wght: 400,
  );

  /// Interface words that are targets rather than prose: navigation rows, tabs,
  /// menu items, button labels.
  static final TextStyleToken nav = TextStyleToken(
    name: 'nav',
    group: TypeGroup.words,
    family: Fonts.sans,
    mobile: const TypeStep(16, 20),
    wght: 500,
  );

  /// The short status word inside a `Badge`. Owned by that component's anatomy;
  /// nothing else should reach for it.
  static final TextStyleToken badge = TextStyleToken(
    name: 'badge',
    group: TypeGroup.words,
    family: Fonts.sans,
    mobile: const TypeStep(14, 18),
    wght: 600,
  );

  // ── Code and identifiers ─────────────────────────────────────────────────

  /// Code: a snippet, a command, a shortcut, an inline chip in a sentence.
  static final TextStyleToken code = TextStyleToken(
    name: 'code',
    group: TypeGroup.code,
    family: Fonts.mono,
    mobile: const TypeStep(14, 20),
    wght: 400,
  );

  /// An identifier a person must read exactly: a path, a key, an order number,
  /// a hash.
  static final TextStyleToken identifier = TextStyleToken(
    name: 'identifier',
    group: TypeGroup.code,
    family: Fonts.mono,
    mobile: const TypeStep(16, 24),
    wght: 400,
    tracking: -0.01,
  );

  // ── Numerics ─────────────────────────────────────────────────────────────

  /// A figure inside dense furniture: a count on a menu row, a page number.
  static final TextStyleToken numberSm = TextStyleToken(
    name: 'numberSm',
    group: TypeGroup.numerics,
    family: Fonts.mono,
    mobile: const TypeStep(14, 18),
    wght: 600,
    tracking: -0.01,
    tabular: true,
  );

  /// A figure in a line of text or a table cell.
  static final TextStyleToken numberBase = TextStyleToken(
    name: 'numberBase',
    group: TypeGroup.numerics,
    family: Fonts.mono,
    mobile: const TypeStep(16, 20),
    wght: 600,
    tracking: -0.01,
    tabular: true,
  );

  /// A stat inside a card.
  static final TextStyleToken numberMd = TextStyleToken(
    name: 'numberMd',
    group: TypeGroup.numerics,
    family: Fonts.mono,
    mobile: const TypeStep(24, 28),
    tablet: const TypeStep(26, 30),
    desktop: const TypeStep(28, 32),
    wght: 600,
    tracking: -0.01,
    tabular: true,
  );

  /// The headline metric of a section.
  static final TextStyleToken numberLg = TextStyleToken(
    name: 'numberLg',
    group: TypeGroup.numerics,
    family: Fonts.mono,
    mobile: const TypeStep(32, 36),
    tablet: const TypeStep(36, 40),
    desktop: const TypeStep(40, 44),
    wght: 600,
    tracking: -0.01,
    tabular: true,
  );

  /// The single number a dashboard exists to show.
  static final TextStyleToken numberXl = TextStyleToken(
    name: 'numberXl',
    group: TypeGroup.numerics,
    family: Fonts.mono,
    mobile: const TypeStep(40, 44),
    tablet: const TypeStep(48, 52),
    desktop: const TypeStep(56, 60),
    wght: 600,
    tracking: -0.02,
    tabular: true,
  );

  // ── The typeset, as sets ─────────────────────────────────────────────────
  // A caller that wants a group asks for the set by name. Nothing outside this
  // file needs to hold a `TypeGroup` to read the catalog: the enum stays on the
  // role so a token can say what it is, and the sets are the surface.

  /// Headings, reading copy, and the interface words, in catalog order.
  static final List<TextStyleToken> wordRoles =
      List<TextStyleToken>.unmodifiable(<TextStyleToken>[
        display,
        h1,
        h2,
        h3,
        h4,
        lead,
        body,
        small,
        nav,
        badge,
      ]);

  /// The two fixed-advance roles, in catalog order.
  static final List<TextStyleToken> codeRoles =
      List<TextStyleToken>.unmodifiable(<TextStyleToken>[code, identifier]);

  /// The five tabular numeric steps, in catalog order.
  static final List<TextStyleToken> numericRoles =
      List<TextStyleToken>.unmodifiable(<TextStyleToken>[
        numberSm,
        numberBase,
        numberMd,
        numberLg,
        numberXl,
      ]);

  /// Every public role once, in catalog order: [wordRoles], then [codeRoles],
  /// then [numericRoles].
  ///
  /// Composed from the three sets rather than relisted, so a role can only ever
  /// be in the catalog by being in exactly one of them. The documentation and
  /// the guards read this list rather than restating it.
  static final List<TextStyleToken> all = List<TextStyleToken>.unmodifiable(
    <TextStyleToken>[...wordRoles, ...codeRoles, ...numericRoles],
  );
}
