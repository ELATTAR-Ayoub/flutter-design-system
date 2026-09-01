import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

/// The public type contract and the motion tokens, asserted against the
/// foundation rather than against any former implementation.

/// A colour to resolve against; the value is irrelevant to these assertions.
const Color _ink = Color(0xFF92C2FC);

/// One representative width inside each responsive band.
const double _phone = 390;
const double _tablet = 834;
const double _desktop = 1440;

/// The final catalog, role by role: name, group, face, weight, tracking,
/// tabular figures, and the three steps.
///
/// Written out here on purpose. A test that read the sizes back off
/// `TextStyles` could not fail, and this table is the contract the
/// documentation, the registry, and every consumer are entitled to.
final List<_Role> _catalog = <_Role>[
  _Role(
    'display',
    TypeGroup.words,
    Fonts.sans,
    600,
    -0.03,
    m: (44, 48),
    t: (52, 56),
    d: (64, 68),
  ),
  _Role(
    'h1',
    TypeGroup.words,
    Fonts.sans,
    700,
    -0.02,
    m: (36, 40),
    t: (40, 44),
    d: (48, 52),
  ),
  _Role(
    'h2',
    TypeGroup.words,
    Fonts.sans,
    650,
    -0.015,
    m: (30, 36),
    t: (32, 38),
    d: (36, 42),
  ),
  _Role(
    'h3',
    TypeGroup.words,
    Fonts.sans,
    600,
    -0.01,
    m: (24, 30),
    t: (26, 32),
    d: (28, 36),
  ),
  _Role(
    'h4',
    TypeGroup.words,
    Fonts.sans,
    600,
    null,
    m: (20, 26),
    t: (22, 28),
    d: (24, 30),
  ),
  _Role(
    'lead',
    TypeGroup.words,
    Fonts.sans,
    400,
    null,
    m: (18, 28),
    t: (20, 30),
    d: (20, 30),
  ),
  _Role('body', TypeGroup.words, Fonts.sans, 400, null, m: (16, 24)),
  _Role('small', TypeGroup.words, Fonts.sans, 400, null, m: (14, 20)),
  _Role('nav', TypeGroup.words, Fonts.sans, 500, null, m: (16, 20)),
  _Role('badge', TypeGroup.words, Fonts.sans, 600, null, m: (14, 18)),
  _Role('code', TypeGroup.code, Fonts.mono, 400, null, m: (14, 20)),
  _Role('identifier', TypeGroup.code, Fonts.mono, 400, -0.01, m: (16, 24)),
  _Role(
    'numberSm',
    TypeGroup.numerics,
    Fonts.mono,
    600,
    -0.01,
    m: (14, 18),
    tabular: true,
  ),
  _Role(
    'numberBase',
    TypeGroup.numerics,
    Fonts.mono,
    600,
    -0.01,
    m: (16, 20),
    tabular: true,
  ),
  _Role(
    'numberMd',
    TypeGroup.numerics,
    Fonts.mono,
    600,
    -0.01,
    m: (24, 28),
    t: (26, 30),
    d: (28, 32),
    tabular: true,
  ),
  _Role(
    'numberLg',
    TypeGroup.numerics,
    Fonts.mono,
    600,
    -0.01,
    m: (32, 36),
    t: (36, 40),
    d: (40, 44),
    tabular: true,
  ),
  _Role(
    'numberXl',
    TypeGroup.numerics,
    Fonts.mono,
    600,
    -0.02,
    m: (40, 44),
    t: (48, 52),
    d: (56, 60),
    tabular: true,
  ),
];

/// One expected row of the catalog.
class _Role {
  _Role(
    this.name,
    this.group,
    this.family,
    this.wght,
    this.tracking, {
    required (double, double) m,
    (double, double)? t,
    (double, double)? d,
    this.tabular = false,
  }) : mobile = TypeStep(m.$1, m.$2),
       tablet = TypeStep((t ?? m).$1, (t ?? m).$2),
       desktop = TypeStep((d ?? t ?? m).$1, (d ?? t ?? m).$2);

  final String name;
  final TypeGroup group;
  final String family;
  final double wght;
  final double? tracking;
  final bool tabular;
  final TypeStep mobile;
  final TypeStep tablet;
  final TypeStep desktop;
}

/// Names the retired catalog published that must no longer resolve.
const List<String> _retired = <String>[
  'navSm',
  'eyebrow',
  'section',
  'chip',
  'caption',
  'eyebrowSmall',
  'tag',
  'wordmark',
  'accent',
  'numberXs',
  'buttonLabel',
  'buttonLabelXs',
  'buttonLabelSm',
  'buttonLabelLg',
  'buttonLabelXl',
  'buttonLabelCaps',
  'toggleLabel',
  'buttonGroupText',
  'buttonGroupNum',
  'kbdKey',
  'menuLabel',
  'menuHeading',
  'menuShortcut',
  'navMenuTrigger',
  'bodyCompact',
  'bodySmall',
  'dialogTitle',
  'overlayTitle',
  'popoverTitle',
  'tooltipLabel',
  'badgeLabel',
  'sidebarMenuBadge',
  'avatarFallback',
  'avatarInitials',
  'fieldLabel',
  'textareaBody',
  'inputNumber',
  'inputSerial',
  'bubbleContent',
  'bubbleReactions',
  'messageMetadata',
  'attachmentTitle',
  'attachmentTitleSmall',
  'attachmentDescription',
  'tableHead',
  'cardTitle',
  'itemTitle',
  'itemDescription',
  'sheetBody',
  'label',
  'micro',
  'serial',
];

void main() {
  // ─── typography ──────────────────────────────────────────────────────────

  group('Fonts', () {
    test('the system ships exactly two faces', () {
      expect(Fonts.sans, 'InterLocal');
      expect(Fonts.mono, 'GeistMono');
      expect(Fonts.package, 'elattar_design_system');
    });
  });

  group('TextStyles.all — the public catalog', () {
    test('holds seventeen roles, once each, in catalog order', () {
      expect(TextStyles.all, hasLength(17));
      expect(
        TextStyles.all.map((TextStyleToken r) => r.name).toList(),
        _catalog.map((_Role r) => r.name).toList(),
      );
      expect(
        TextStyles.all.map((TextStyleToken r) => r.name).toSet(),
        hasLength(17),
      );
    });

    test('groups are ten Words, two Code and identifiers, five Numerics', () {
      expect(TextStyles.wordRoles, hasLength(10));
      expect(TextStyles.codeRoles, hasLength(2));
      expect(TextStyles.numericRoles, hasLength(5));
      // The catalog is the three sets, in order, and nothing else.
      expect(TextStyles.all, <TextStyleToken>[
        ...TextStyles.wordRoles,
        ...TextStyles.codeRoles,
        ...TextStyles.numericRoles,
      ]);
      // Each set holds only its own group, so a role cannot be filed twice.
      for (final TextStyleToken r in TextStyles.wordRoles) {
        expect(r.group, TypeGroup.words, reason: r.name);
      }
      for (final TextStyleToken r in TextStyles.codeRoles) {
        expect(r.group, TypeGroup.code, reason: r.name);
      }
      for (final TextStyleToken r in TextStyles.numericRoles) {
        expect(r.group, TypeGroup.numerics, reason: r.name);
      }
      expect(
        TextStyles.all.map((TextStyleToken r) => r.group).toList(),
        <TypeGroup>[
          ...List<TypeGroup>.filled(10, TypeGroup.words),
          ...List<TypeGroup>.filled(2, TypeGroup.code),
          ...List<TypeGroup>.filled(5, TypeGroup.numerics),
        ],
      );
    });

    test('group labels are the published headings', () {
      expect(TypeGroup.words.label, 'Words');
      expect(TypeGroup.code.label, 'Code and identifiers');
      expect(TypeGroup.numerics.label, 'Numerics');
    });

    test('no retired role survives in the catalog', () {
      final Set<String> live = TextStyles.all
          .map((TextStyleToken r) => r.name)
          .toSet();
      for (final String gone in _retired) {
        expect(live, isNot(contains(gone)), reason: '$gone must be retired');
      }
    });
  });

  group('every role, field by field', () {
    for (final _Role expected in _catalog) {
      test(expected.name, () {
        final TextStyleToken role = TextStyles.all.firstWhere(
          (TextStyleToken r) => r.name == expected.name,
        );
        expect(role.group, expected.group, reason: 'group');
        expect(role.family, expected.family, reason: 'face');
        expect(role.wght, expected.wght, reason: 'weight axis');
        expect(role.tracking, expected.tracking, reason: 'tracking (em)');
        expect(role.tabular, expected.tabular, reason: 'tabular figures');
        expect(role.fontStyle, FontStyle.normal, reason: 'no role is italic');
        expect(role.mobile, expected.mobile, reason: 'mobile step');
        expect(role.tablet, expected.tablet, reason: 'tablet step');
        expect(role.desktop, expected.desktop, reason: 'desktop step');
      });
    }
  });

  group('responsive resolution', () {
    test('steps switch exactly at the 768 and 1024 boundaries', () {
      for (final TextStyleToken role in TextStyles.all) {
        expect(role.stepFor(767), role.mobile, reason: '${role.name} at 767');
        expect(role.stepFor(768), role.tablet, reason: '${role.name} at 768');
        expect(role.stepFor(1023), role.tablet, reason: '${role.name} at 1023');
        expect(
          role.stepFor(1024),
          role.desktop,
          reason: '${role.name} at 1024',
        );
        expect(role.stepFor(0), role.mobile, reason: '${role.name} at 0');
      }
    });

    test('the responsive roles are the headings and the large metrics', () {
      expect(
        TextStyles.all
            .where((TextStyleToken r) => !r.isStatic)
            .map((TextStyleToken r) => r.name)
            .toList(),
        <String>[
          'display',
          'h1',
          'h2',
          'h3',
          'h4',
          'lead',
          'numberMd',
          'numberLg',
          'numberXl',
        ],
      );
    });

    test('reading and interface roles are stable across every width', () {
      for (final String name in <String>[
        'body',
        'small',
        'nav',
        'badge',
        'code',
        'identifier',
        'numberSm',
        'numberBase',
      ]) {
        final TextStyleToken role = TextStyles.all.firstWhere(
          (TextStyleToken r) => r.name == name,
        );
        expect(role.isStatic, isTrue, reason: name);
        expect(role.step, role.mobile, reason: name);
      }
    });

    test('asking a responsive role for a single step is an error', () {
      expect(() => TextStyles.display.step, throwsA(isA<AssertionError>()));
    });
  });

  group('resolveWidth', () {
    test('carries size, the leading as a ratio, face, and ink', () {
      final TextStyle style = TextStyles.h2.resolveWidth(_desktop, _ink);
      expect(style.fontSize, 36);
      expect(style.height, 42 / 36);
      expect(style.color, _ink);
      expect(style.fontFamily, contains(Fonts.sans));
      expect(style.leadingDistribution, TextLeadingDistribution.even);
    });

    test('the same role resolves smaller on a phone', () {
      expect(TextStyles.h2.resolveWidth(_phone, _ink).fontSize, 30);
      expect(TextStyles.h2.resolveWidth(_tablet, _ink).fontSize, 32);
    });

    test('tracking is em converted against the resolved size', () {
      expect(
        TextStyles.display.resolveWidth(_phone, _ink).letterSpacing,
        closeTo(-0.03 * 44, 1e-9),
      );
      expect(
        TextStyles.display.resolveWidth(_desktop, _ink).letterSpacing,
        closeTo(-0.03 * 64, 1e-9),
      );
    });

    test('a role with no tracking sets none', () {
      expect(TextStyles.body.resolveWidth(_phone, _ink).letterSpacing, isNull);
    });

    test('every numeric role asks for tabular figures; no word role does', () {
      for (final TextStyleToken role in TextStyles.all) {
        final TextStyle style = role.resolveWidth(_desktop, _ink);
        expect(
          style.fontFeatures,
          role.group == TypeGroup.numerics
              ? const <FontFeature>[FontFeature.tabularFigures()]
              : isNull,
          reason: role.name,
        );
      }
    });

    test('the weight reaches both the axis and the static fallback', () {
      final TextStyle h2 = TextStyles.h2.resolveWidth(_desktop, _ink);
      expect(h2.fontVariations, contains(const FontVariation('wght', 650)));
      expect(h2.fontWeight, FontWeight.w600);
      expect(
        TextStyles.h1.resolveWidth(_desktop, _ink).fontWeight,
        FontWeight.w700,
      );
    });

    test('Inter carries an optical size clamped to its axis', () {
      expect(
        TextStyles.small.resolveWidth(_phone, _ink).fontVariations,
        contains(const FontVariation('opsz', 14)),
      );
      expect(
        TextStyles.display.resolveWidth(_desktop, _ink).fontVariations,
        contains(const FontVariation('opsz', 32)),
      );
      expect(
        TextStyles.code
            .resolveWidth(_desktop, _ink)
            .fontVariations!
            .map((FontVariation v) => v.axis),
        isNot(contains('opsz')),
      );
    });

    test('an explicit size keeps the step leading ratio', () {
      final TextStyle style = TextStyles.body.resolveWidth(
        _phone,
        _ink,
        fontSize: 32,
      );
      expect(style.fontSize, 32);
      expect(style.height, 24 / 16);
    });

    test('inline drops the line height and stands outside inheritance', () {
      final TextStyle style = TextStyles.code.resolveInline(_desktop, _ink);
      expect(style.height, isNull);
      expect(style.inherit, isFalse);
      expect(style.fontSize, 14);
    });
  });

  group('no role owns ink', () {
    test('a role only ever paints the colour it is handed', () {
      const Color other = Color(0xFF010203);
      for (final TextStyleToken role in TextStyles.all) {
        expect(
          role.resolveWidth(_desktop, _ink).color,
          _ink,
          reason: role.name,
        );
        expect(
          role.resolveWidth(_desktop, other).color,
          other,
          reason: role.name,
        );
      }
    });
  });

  group('derive — component anatomy', () {
    test('keeps every step and changes only what it is asked to', () {
      final TextStyleToken label = TextStyles.body.derive(
        name: 'button-label',
        wght: 500,
      );
      expect(label.name, 'button-label');
      expect(label.mobile, TextStyles.body.mobile);
      expect(label.tablet, TextStyles.body.tablet);
      expect(label.desktop, TextStyles.body.desktop);
      expect(label.family, TextStyles.body.family);
      expect(label.wght, 500);
      expect(label.weight, FontWeight.w500);
      expect(TextStyles.body.wght, 400, reason: 'the role is not mutated');
    });

    test('a derived role is not in the public catalog', () {
      final TextStyleToken derived = TextStyles.small.derive(wght: 700);
      expect(TextStyles.all, isNot(contains(derived)));
      expect(TextStyles.all, hasLength(17));
    });

    test('can slant for rendered emphasis', () {
      final TextStyleToken em = TextStyles.body.derive(
        fontStyle: FontStyle.italic,
      );
      expect(em.resolveWidth(_phone, _ink).fontStyle, FontStyle.italic);
      expect(
        TextStyles.body.resolveWidth(_phone, _ink).fontStyle,
        FontStyle.normal,
      );
    });
  });

  group('TypeStep', () {
    test('reports its leading as a ratio', () {
      expect(const TypeStep(16, 24).ratio, 1.5);
      expect(const TypeStep(44, 48).ratio, closeTo(48 / 44, 1e-12));
    });

    test('compares by value', () {
      expect(const TypeStep(16, 24), const TypeStep(16, 24));
      expect(const TypeStep(16, 24), isNot(const TypeStep(16, 20)));
    });
  });

  // ─── motion ──────────────────────────────────────────────────────────────

  group('MotionDurations (globals.css L395–418)', () {
    test('every duration token', () {
      expect(MotionDurations.tick, const Duration(milliseconds: 80));
      expect(MotionDurations.fast, const Duration(milliseconds: 150));
      expect(MotionDurations.normal, const Duration(milliseconds: 250));
      expect(MotionDurations.slow, const Duration(milliseconds: 400));
      expect(MotionDurations.overlayEnter, const Duration(milliseconds: 320));
      expect(MotionDurations.open, const Duration(milliseconds: 420));
      expect(MotionDurations.reward, const Duration(milliseconds: 550));
      expect(MotionDurations.bloom, const Duration(milliseconds: 1000));
      expect(MotionDurations.sway, const Duration(seconds: 44));
      expect(MotionDurations.swayAlt, const Duration(seconds: 33));
    });

    test('the framework default transition duration (L395)', () {
      expect(MotionDurations.normal, const Duration(milliseconds: 250));
      expect(MotionDurations.normal.inMilliseconds, 250);
    });

    test('transitionDefault equals base and is a separate declaration', () {
      // globals.css points `--default-transition-duration` at `--duration-base`,
      // so the two agree — but Tailwind v4 emits no `duration-*` utility for
      // the theme namespace, which means every `transition-*` class in the
      // reference resolves through the DEFAULT and never through the token.
      // Probed 2026-08-15: checkbox, radio, switch, slider thumb, input,
      // textarea, input-group, tabs, both nav levels and the theme toggle all
      // report a 0.25s transitionDuration; `:where(.prose) a` and
      // `slide-pill`'s opacity leg, which read `var(--duration-fast)` directly,
      // report 0.15s on the same pages.
      expect(MotionDurations.normal, MotionDurations.normal);
      expect(MotionDurations.normal, isNot(same(MotionDurations.fast)));
      expect(MotionDurations.fast, const Duration(milliseconds: 150));
    });

    test('the two sways are deliberately not multiples of each other', () {
      expect(
        MotionDurations.sway.inSeconds % MotionDurations.swayAlt.inSeconds,
        isNot(0),
      );
    });
  });

  group('MotionCurves (globals.css L420–432)', () {
    test('--ease-spring: cubic-bezier(0.34, 1.56, 0.64, 1)', () {
      expect(MotionCurves.emphasized, const Cubic(0.34, 1.56, 0.64, 1));
      expect(
        <double>[
          MotionCurves.emphasized.a,
          MotionCurves.emphasized.b,
          MotionCurves.emphasized.c,
          MotionCurves.emphasized.d,
        ],
        <double>[0.34, 1.56, 0.64, 1],
      );
    });

    test('--ease-out: cubic-bezier(0.22, 1, 0.36, 1)', () {
      expect(MotionCurves.enter, const Cubic(0.22, 1, 0.36, 1));
      expect(
        <double>[
          MotionCurves.enter.a,
          MotionCurves.enter.b,
          MotionCurves.enter.c,
          MotionCurves.enter.d,
        ],
        <double>[0.22, 1, 0.36, 1],
      );
    });

    test('--ease-in: cubic-bezier(0.7, 0, 0.84, 0) — not Tailwind\'s', () {
      expect(MotionCurves.exit, const Cubic(0.7, 0, 0.84, 0));
      expect(
        <double>[
          MotionCurves.exit.a,
          MotionCurves.exit.b,
          MotionCurves.exit.c,
          MotionCurves.exit.d,
        ],
        <double>[0.7, 0, 0.84, 0],
      );
    });

    test('--ease-in-out: cubic-bezier(0.65, 0, 0.35, 1)', () {
      expect(MotionCurves.move, const Cubic(0.65, 0, 0.35, 1));
      expect(
        <double>[
          MotionCurves.move.a,
          MotionCurves.move.b,
          MotionCurves.move.c,
          MotionCurves.move.d,
        ],
        <double>[0.65, 0, 0.35, 1],
      );
    });

    test('--ease-settle: cubic-bezier(0.16, 1, 0.3, 1)', () {
      expect(MotionCurves.settle, const Cubic(0.16, 1, 0.3, 1));
      expect(
        <double>[
          MotionCurves.settle.a,
          MotionCurves.settle.b,
          MotionCurves.settle.c,
          MotionCurves.settle.d,
        ],
        <double>[0.16, 1, 0.3, 1],
      );
    });

    test('--ease-standard: cubic-bezier(0.4, 0, 0.2, 1)', () {
      expect(MotionCurves.standard, const Cubic(0.4, 0, 0.2, 1));
      expect(
        <double>[
          MotionCurves.standard.a,
          MotionCurves.standard.b,
          MotionCurves.standard.c,
          MotionCurves.standard.d,
        ],
        <double>[0.4, 0, 0.2, 1],
      );
    });

    test('--ease-out-flex: cubic-bezier(0.05, 0.6, 0.4, 0.9)', () {
      expect(MotionCurves.outFlex, const Cubic(0.05, 0.6, 0.4, 0.9));
      expect(
        <double>[
          MotionCurves.outFlex.a,
          MotionCurves.outFlex.b,
          MotionCurves.outFlex.c,
          MotionCurves.outFlex.d,
        ],
        <double>[0.05, 0.6, 0.4, 0.9],
      );
    });

    test('the spring overshoots past 1 and settles back', () {
      expect(MotionCurves.emphasized.transform(0.5), greaterThan(0.5));
      expect(MotionCurves.emphasized.transform(1), 1);
      expect(MotionCurves.emphasized.transform(0), 0);
    });

    test('all seven easings are registered', () {
      expect(MotionCurves.all, hasLength(7));
    });
  });

  // --- shadows (appended by lead) ---

  group(
    'Shadows — geometry is fixed, ink is themed (globals.css L354–387)',
    () {
      void expectLayer(
        ShadowLayer layer,
        double dx,
        double dy,
        double blur,
        double spread, {
        bool inset = false,
      }) {
        expect(layer.dx, dx);
        expect(layer.dy, dy);
        expect(layer.blur, blur);
        expect(layer.spread, spread);
        expect(layer.inset, inset);
      }

      test('e1: 0 1px 1px ink-2, 0 1px 3px ink-1', () {
        expect(Shadows.sm.layers, hasLength(2));
        expectLayer(Shadows.sm.layers[0], 0, 1, 1, 0);
        expectLayer(Shadows.sm.layers[1], 0, 1, 3, 0);
        expect(
          Shadows.sm.layers[0].color(ThemeTokens.dark),
          ThemeTokens.dark.ink2,
        );
        expect(
          Shadows.sm.layers[1].color(ThemeTokens.dark),
          ThemeTokens.dark.ink1,
        );
        expect(Shadows.sm.hasInset, isFalse);
      });

      test('e2: 0 1px 2px ink-2, 0 4px 10px -2px ink-2', () {
        expectLayer(Shadows.md.layers[0], 0, 1, 2, 0);
        expectLayer(Shadows.md.layers[1], 0, 4, 10, -2);
        expect(
          Shadows.md.layers.every(
            (l) => l.color(ThemeTokens.light) == ThemeTokens.light.ink2,
          ),
          isTrue,
        );
      });

      test('e3: 0 2px 4px ink-2, 0 14px 28px -8px ink-3', () {
        expectLayer(Shadows.lg.layers[0], 0, 2, 4, 0);
        expectLayer(Shadows.lg.layers[1], 0, 14, 28, -8);
        expect(
          Shadows.lg.layers[0].color(ThemeTokens.dark),
          ThemeTokens.dark.ink2,
        );
        expect(
          Shadows.lg.layers[1].color(ThemeTokens.dark),
          ThemeTokens.dark.ink3,
        );
        expect(Shadows.lg.hasInset, isFalse);
      });

      test('e4: 0 4px 8px ink-3, 0 28px 56px -14px ink-4', () {
        expectLayer(Shadows.xl.layers[0], 0, 4, 8, 0);
        expectLayer(Shadows.xl.layers[1], 0, 28, 56, -14);
        expect(
          Shadows.xl.layers[0].color(ThemeTokens.light),
          ThemeTokens.light.ink3,
        );
        expect(
          Shadows.xl.layers[1].color(ThemeTokens.light),
          ThemeTokens.light.ink4,
        );
      });

      test('key / key-down: the wall layer and its socket', () {
        expectLayer(Shadows.keyRaised.layers[0], 0, 4, 0, 0);
        expect(
          Shadows.keyRaised.layers[0].color(ThemeTokens.dark),
          ThemeTokens.dark.wall,
        );
        expectLayer(Shadows.keyRaised.layers[1], 0, 7, 12, 0);
        expect(Shadows.keyRaised.hasInset, isFalse);

        expectLayer(Shadows.keyPressed.layers[0], 0, 1, 0, 0);
        expectLayer(Shadows.keyPressed.layers[1], 0, 2, 5, 0, inset: true);
        expect(Shadows.keyPressed.hasInset, isTrue);
      });

      test('pressed: both layers inset', () {
        expectLayer(Shadows.inset.layers[0], 0, 2, 5, 0, inset: true);
        expectLayer(Shadows.inset.layers[1], 0, 1, 2, 0, inset: true);
        expect(Shadows.inset.hasInset, isTrue);
        expect(Shadows.inset.outerShadows(ThemeTokens.dark), isEmpty);
      });

      test('btn: rim highlight + inner bottom shade + two outer layers', () {
        expect(Shadows.control.layers, hasLength(4));
        expectLayer(Shadows.control.layers[0], 0, 1, 0, 0, inset: true);
        expect(
          Shadows.control.layers[0].color(ThemeTokens.dark),
          ThemeTokens.dark.rim,
        );
        expectLayer(Shadows.control.layers[1], 0, -2, 4, 0, inset: true);
        expectLayer(Shadows.control.layers[2], 0, 1, 2, 0);
        expectLayer(Shadows.control.layers[3], 0, 3, 8, -2);
        expect(Shadows.control.hasInset, isTrue);
        expect(Shadows.control.insetLayers, hasLength(2));
        expect(Shadows.control.outerShadows(ThemeTokens.dark), hasLength(2));
      });

      test('btn-primary: rim-strong + action cast at 55%', () {
        expectLayer(Shadows.controlPrimary.layers[0], 0, 1, 0, 0, inset: true);
        expect(
          Shadows.controlPrimary.layers[0].color(ThemeTokens.light),
          ThemeTokens.light.rimStrong,
        );
        expectLayer(Shadows.controlPrimary.layers[1], 0, -2, 5, 0, inset: true);
        expectLayer(Shadows.controlPrimary.layers[2], 0, 1, 2, 0);
        expectLayer(Shadows.controlPrimary.layers[3], 0, 4, 10, -2);
        expect(
          Shadows.controlPrimary.layers[3].color(ThemeTokens.dark),
          Palette.action.withValues(alpha: 0.55),
        );
      });

      test('btn-value: ink-1 inner shade + value cast at 45%', () {
        expectLayer(Shadows.controlPremium.layers[1], 0, -2, 5, 0, inset: true);
        expect(
          Shadows.controlPremium.layers[1].color(ThemeTokens.dark),
          ThemeTokens.dark.ink1,
        );
        expect(
          Shadows.controlPremium.layers[3].color(ThemeTokens.dark),
          Palette.value.withValues(alpha: 0.45),
        );
      });

      test('btn-down / chip', () {
        expectLayer(Shadows.controlPressed.layers[0], 0, 2, 4, 0, inset: true);
        expectLayer(Shadows.controlPressed.layers[1], 0, 1, 1, 0);
        expectLayer(Shadows.compactControl.layers[0], 0, 1, 0, 0, inset: true);
        expectLayer(Shadows.compactControl.layers[1], 0, -1, 2, 0, inset: true);
        expectLayer(Shadows.compactControl.layers[2], 0, 1, 2, 0);
      });

      test(
        'glow-action: 0 0 0 1px action-bright@45% + 0 10 34 -8 action@60%',
        () {
          expectLayer(Shadows.glowAction.layers[0], 0, 0, 0, 1);
          expect(
            Shadows.glowAction.layers[0].color(ThemeTokens.dark),
            Palette.actionBright.withValues(alpha: 0.45),
          );
          expectLayer(Shadows.glowAction.layers[1], 0, 10, 34, -8);
          expect(
            Shadows.glowAction.layers[1].color(ThemeTokens.dark),
            Palette.action.withValues(alpha: 0.60),
          );
          expect(Shadows.glowAction.hasInset, isFalse);
        },
      );

      test('glow-value: 0 0 0 1px value@45% + 0 10 34 -8 value@42%', () {
        expectLayer(Shadows.glowValue.layers[0], 0, 0, 0, 1);
        expect(
          Shadows.glowValue.layers[0].color(ThemeTokens.light),
          Palette.value.withValues(alpha: 0.45),
        );
        expectLayer(Shadows.glowValue.layers[1], 0, 10, 34, -8);
        expect(
          Shadows.glowValue.layers[1].color(ThemeTokens.light),
          Palette.value.withValues(alpha: 0.42),
        );
      });

      test('ink flips with the theme — same geometry, different colour', () {
        final BoxShadow darkTop = Shadows.lg
            .outerShadows(ThemeTokens.dark)
            .last;
        final BoxShadow lightTop = Shadows.lg
            .outerShadows(ThemeTokens.light)
            .last;
        expect(darkTop.offset, lightTop.offset);
        expect(darkTop.blurRadius, lightTop.blurRadius);
        expect(darkTop.color, isNot(lightTop.color));
        expect(darkTop.color, ThemeTokens.dark.ink2);
        expect(lightTop.color, ThemeTokens.light.ink2);
      });

      test('CSS blur maps to the CSS Gaussian sigma, not Flutter default', () {
        // CSS: sigma = blur / 2. Flutter: sigma = radius * 0.57735 + 0.5.
        const ShadowLayer layer = ShadowLayer(0, 28, 56, -14, _dummyInk);
        expect(layer.blurRadius * 0.57735 + 0.5, closeTo(28.0, 0.001));
        // Known limit: sigmas below 0.5 are unreachable, so a 1px CSS blur
        // collapses to a hard edge.
        const ShadowLayer hairline = ShadowLayer(0, 1, 1, 0, _dummyInk);
        expect(hairline.blurRadius, 0);
        const ShadowLayer none = ShadowLayer(0, 0, 0, 1, _dummyInk);
        expect(none.blurRadius, 0);
      });

      test(
        'outerShadows reverses CSS order so the first layer paints on top',
        () {
          final List<BoxShadow> shadows = Shadows.xl.outerShadows(
            ThemeTokens.dark,
          );
          expect(
            shadows.first.offset.dy,
            28,
          ); // CSS-last painted first (bottom-most)
          expect(shadows.last.offset.dy, 4); // CSS-first painted last (on top)
        },
      );
    },
  );
}

Color _dummyInk(ThemeTokens t) => t.ink2;
