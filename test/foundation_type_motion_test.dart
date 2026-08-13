import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

/// Value-for-value transcript of the reference's type + motion tokens.
///
/// Source of truth: `design-system/app/globals.css`
///   * typography tokens  L169–216
///   * `.type-*` classes  L1018–1292
///   * motion tokens      L395–432
///
/// 1 CSS `rem` = 16px. `tracking` is kept in CSS **em** and multiplied by the
/// resolved font size only inside [DsTypeSpec.resolve].

/// A colour to resolve against; the value is irrelevant to these assertions.
const Color _ink = Color(0xFF92C2FC);

/// Asserts one `.type-*` class field by field.
void expectSpec(
  String css,
  DsTypeSpec spec, {
  required String family,
  required double? size,
  required double? height,
  required FontWeight? weight,
  required double? wght,
  required double? tracking,
  required bool uppercase,
  required bool tabular,
  required DsTypeColor defaultColor,
  FontStyle fontStyle = FontStyle.normal,
}) {
  expect(spec.family, family, reason: '$css font-family');
  expect(spec.size, size, reason: '$css font-size');
  expect(spec.height, height, reason: '$css line-height');
  expect(spec.weight, weight, reason: '$css font-weight');
  expect(
    spec.variations,
    wght == null ? isEmpty : <FontVariation>[FontVariation('wght', wght)],
    reason: '$css wght axis',
  );
  expect(spec.tracking, tracking, reason: '$css letter-spacing (em)');
  expect(spec.uppercase, uppercase, reason: '$css text-transform');
  expect(spec.tabular, tabular, reason: '$css font-variant-numeric');
  expect(spec.defaultColor, defaultColor, reason: '$css color');
  expect(spec.fontStyle, fontStyle, reason: '$css font-style');
}

void main() {
  // ─── typography ──────────────────────────────────────────────────────────

  group('DsFonts — the three faces (globals.css L169–172)', () {
    test('families follow the tokens, not the Space Grotesk prose', () {
      expect(DsFonts.sans, 'InterLocal');
      expect(DsFonts.heading, 'InterLocal');
      expect(DsFonts.mono, 'GeistMono');
      expect(DsFonts.accent, 'Redaction35');
    });

    test('package name is the asset prefix flutter_tools registers', () {
      expect(DsFonts.package, 'elattar_design_system');
    });
  });

  group('DsType — fluid sizes (clamp)', () {
    test('displaySize is clamp(2.75rem, 4.4vw, 4rem) = clamp(44, 4.4vw, 64)', () {
      expect(DsType.displaySize(1000), 44); // 4.4vw of 1000 = 44 — the min edge
      expect(DsType.displaySize(700), 44); // 30.8 → floored at 44
      expect(DsType.displaySize(1280), closeTo(56.32, 1e-9));
      expect(DsType.displaySize(1440), closeTo(63.36, 1e-9));
      expect(DsType.displaySize(1600), 64); // 70.4 → clamped at the 64 max
      expect(DsType.displaySize(2560), 64);
    });

    test('h1Size is clamp(2rem, 2.8vw, 2.5rem) = clamp(32, 2.8vw, 40)', () {
      expect(DsType.h1Size(1440), 40); // 40.32 → clamped at the 40 max
      expect(DsType.h1Size(1000), 32); // 28 → floored at 32
      expect(DsType.h1Size(1280), closeTo(35.84, 1e-9));
      expect(DsType.h1Size(1200), closeTo(33.6, 1e-9));
    });

    test('accentSize is 1.055em — it rides the size it is set inside', () {
      expect(DsType.accentSize(64), closeTo(67.52, 1e-9));
      expect(DsType.accentSize(DsType.displaySize(1000)), closeTo(46.42, 1e-9));
    });
  });

  group('DsType — every .type-* class, value for value (globals.css §5)', () {
    test('.type-display — heading face, clamp 44–64/1, 500, -0.03em (L1019)', () {
      expectSpec(
        '.type-display',
        DsType.display,
        family: 'InterLocal',
        size: null, // clamp() — resolved from the viewport
        height: 1,
        weight: FontWeight.w500,
        wght: 500,
        tracking: -0.03,
        uppercase: false,
        tabular: false,
        defaultColor: DsTypeColor.none,
      );
    });

    test('.type-accent — Redaction 35, 1.055em italic, 400, -0.03em (L1046)', () {
      expectSpec(
        '.type-accent',
        DsType.accent,
        family: 'Redaction35',
        size: null, // 1.055em — relative to the inherited size
        height: null, // no line-height declared: inherits
        weight: FontWeight.w400,
        wght: 400,
        tracking: -0.03,
        uppercase: false,
        tabular: false,
        defaultColor: DsTypeColor.none,
        fontStyle: FontStyle.italic,
      );
    });

    test('.type-h1 — clamp 32–40/1.1, 700, -0.02em (L1070)', () {
      expectSpec(
        '.type-h1',
        DsType.h1,
        family: 'InterLocal',
        size: null, // clamp()
        height: 1.1,
        weight: FontWeight.w700,
        wght: 700,
        tracking: -0.02,
        uppercase: false,
        tabular: false,
        defaultColor: DsTypeColor.none,
      );
    });

    test('.type-h2 — 28/1.2, weight 650 via wght axis, -0.015em (L1077)', () {
      expectSpec(
        '.type-h2',
        DsType.h2,
        family: 'InterLocal',
        size: 28, // 1.75rem
        height: 1.2,
        weight: FontWeight.w600, // non-variable fallback; 650 has no FontWeight
        wght: 650,
        tracking: -0.015,
        uppercase: false,
        tabular: false,
        defaultColor: DsTypeColor.none,
      );
    });

    test('.type-h2 renders wght 650 through variations, not weight', () {
      expect(DsType.h2.variations, hasLength(1));
      expect(DsType.h2.variations.single.axis, 'wght');
      expect(DsType.h2.variations.single.value, 650);
      expect(DsType.h2.resolve(28, _ink).fontVariations,
          <FontVariation>[FontVariation('wght', 650)]);
    });

    test('.type-h3 — 21/1.3, 600, -0.01em (L1084)', () {
      expectSpec(
        '.type-h3',
        DsType.h3,
        family: 'InterLocal',
        size: 21, // 1.3125rem
        height: 1.3,
        weight: FontWeight.w600,
        wght: 600,
        tracking: -0.01,
        uppercase: false,
        tabular: false,
        defaultColor: DsTypeColor.none,
      );
    });

    test('.type-h4 — 17/1.4, 600, no tracking (L1091)', () {
      expectSpec(
        '.type-h4',
        DsType.h4,
        family: 'InterLocal',
        size: 17, // 1.0625rem
        height: 1.4,
        weight: FontWeight.w600,
        wght: 600,
        tracking: null,
        uppercase: false,
        tabular: false,
        defaultColor: DsTypeColor.none,
      );
    });

    test('.type-lead — 17/1.65, 400, muted-foreground (L1099)', () {
      expectSpec(
        '.type-lead',
        DsType.lead,
        family: 'InterLocal',
        size: 17, // 1.0625rem
        height: 1.65,
        weight: FontWeight.w400,
        wght: 400,
        tracking: null,
        uppercase: false,
        tabular: false,
        defaultColor: DsTypeColor.muted,
      );
    });

    test('.type-body — 15/1.6, 400 (L1105)', () {
      expectSpec(
        '.type-body',
        DsType.body,
        family: 'InterLocal',
        size: 15, // --text-body
        height: 1.6,
        weight: FontWeight.w400,
        wght: 400,
        tracking: null,
        uppercase: false,
        tabular: false,
        defaultColor: DsTypeColor.none,
      );
    });

    test('.type-small — 13/1.5, 400, muted-foreground (L1120)', () {
      expectSpec(
        '.type-small',
        DsType.small,
        family: 'InterLocal',
        size: 13, // --text-small
        height: 1.5,
        weight: FontWeight.w400,
        wght: 400,
        tracking: null,
        uppercase: false,
        tabular: false,
        defaultColor: DsTypeColor.muted,
      );
    });

    test('.type-nav — 13.5/1.2, 500 (L1128)', () {
      expectSpec(
        '.type-nav',
        DsType.nav,
        family: 'InterLocal',
        size: 13.5, // --text-nav
        height: 1.2,
        weight: FontWeight.w500,
        wght: 500,
        tracking: null,
        uppercase: false,
        tabular: false,
        defaultColor: DsTypeColor.none,
      );
    });

    test('.type-nav-sm — 11.5/1.2, 500 (L1139)', () {
      expectSpec(
        '.type-nav-sm',
        DsType.navSm,
        family: 'InterLocal',
        size: 11.5, // --text-chip
        height: 1.2,
        weight: FontWeight.w500,
        wght: 500,
        tracking: null,
        uppercase: false,
        tabular: false,
        defaultColor: DsTypeColor.none,
      );
    });

    test('.type-chip — 11.5/1.2, 500 (L1145)', () {
      expectSpec(
        '.type-chip',
        DsType.chip,
        family: 'InterLocal',
        size: 11.5, // --text-chip
        height: 1.2,
        weight: FontWeight.w500,
        wght: 500,
        tracking: null,
        uppercase: false,
        tabular: false,
        defaultColor: DsTypeColor.none,
      );
    });

    test('.type-caption — 10.5/1.35, 500 (L1151)', () {
      expectSpec(
        '.type-caption',
        DsType.caption,
        family: 'InterLocal',
        size: 10.5, // --text-micro
        height: 1.35,
        weight: FontWeight.w500,
        wght: 500,
        tracking: null,
        uppercase: false,
        tabular: false,
        defaultColor: DsTypeColor.none,
      );
    });

    test('.type-code — mono 12.5/1.4, NO font-weight declared (L1157)', () {
      expectSpec(
        '.type-code',
        DsType.code,
        family: 'GeistMono',
        size: 12.5, // --text-code
        height: 1.4,
        weight: null, // inherits — globals.css declares none
        wght: null,
        tracking: null,
        uppercase: false,
        tabular: false,
        defaultColor: DsTypeColor.none,
      );
    });

    test('.type-label — 11/1, 600 uppercase 0.16em muted-foreground (L1164)', () {
      expect(DsType.label.uppercase, isTrue);
      expect(DsType.label.size, 11);
      expect(DsType.label.tracking, 0.16);
      expectSpec(
        '.type-label',
        DsType.label,
        family: 'InterLocal',
        size: 11, // --text-label
        height: 1,
        weight: FontWeight.w600,
        wght: 600,
        tracking: 0.16, // --tracking-label
        uppercase: true,
        tabular: false,
        defaultColor: DsTypeColor.muted,
      );
    });

    test('.type-section — 13/1.4, 600, muted-foreground (L1192)', () {
      expectSpec(
        '.type-section',
        DsType.section,
        family: 'InterLocal',
        size: 13, // --text-small
        height: 1.4,
        weight: FontWeight.w600,
        wght: 600,
        tracking: null,
        uppercase: false,
        tabular: false,
        defaultColor: DsTypeColor.muted,
      );
    });

    test('.type-wordmark — 15/1, 700, -0.01em (L1201)', () {
      expectSpec(
        '.type-wordmark',
        DsType.wordmark,
        family: 'InterLocal',
        size: 15, // --text-body
        height: 1,
        weight: FontWeight.w700,
        wght: 700,
        tracking: -0.01, // --tracking-num
        uppercase: false,
        tabular: false,
        defaultColor: DsTypeColor.none,
      );
    });

    test('.type-serial — mono 15/1.4 uppercase -0.01em, NO weight (L1211)', () {
      expectSpec(
        '.type-serial',
        DsType.serial,
        family: 'GeistMono',
        size: 15, // --text-body
        height: 1.4,
        weight: null, // inherits — globals.css declares none
        wght: null,
        tracking: -0.01, // --tracking-num
        uppercase: true,
        tabular: false, // .type-serial is NOT part of the numeric rule
        defaultColor: DsTypeColor.none,
      );
    });

    test('.type-micro — 10.5/1, 600 uppercase 0.18em muted (L1218)', () {
      expectSpec(
        '.type-micro',
        DsType.micro,
        family: 'InterLocal',
        size: 10.5, // --text-micro
        height: 1,
        weight: FontWeight.w600,
        wght: 600,
        tracking: 0.18, // --tracking-micro
        uppercase: true,
        tabular: false,
        defaultColor: DsTypeColor.muted,
      );
    });

    test('.type-tag — 10/1, 600 uppercase 0.12em (L1238)', () {
      expectSpec(
        '.type-tag',
        DsType.tag,
        family: 'InterLocal',
        size: 10, // --text-tag
        height: 1,
        weight: FontWeight.w600,
        wght: 600,
        tracking: 0.12, // --tracking-tag
        uppercase: true,
        tabular: false,
        defaultColor: DsTypeColor.none,
      );
    });

    test('.type-badge — 11/1, 600 uppercase 0.14em (L1246)', () {
      expectSpec(
        '.type-badge',
        DsType.badge,
        family: 'InterLocal',
        size: 11, // --text-label
        height: 1,
        weight: FontWeight.w600,
        wght: 600,
        tracking: 0.14, // --tracking-badge
        uppercase: true,
        tabular: false,
        defaultColor: DsTypeColor.none,
      );
    });

    test('.type-num-xs — mono 11/1.2, 600 tabular -0.01em (L1267)', () {
      expectSpec(
        '.type-num-xs',
        DsType.numXs,
        family: 'GeistMono',
        size: 11, // --text-label
        height: 1.2,
        weight: FontWeight.w600,
        wght: 600,
        tracking: -0.01, // --tracking-num, from the shared rule L1256–1266
        uppercase: false,
        tabular: true,
        defaultColor: DsTypeColor.none,
      );
    });

    test('.type-num-sm — mono 12/1.2, 600 tabular -0.01em (L1271)', () {
      expect(DsType.numSm.family, DsFonts.mono);
      expect(DsType.numSm.size, 12);
      expect(DsType.numSm.height, 1.2);
      expect(DsType.numSm.weight, FontWeight.w600);
      expect(DsType.numSm.tabular, isTrue);
      expect(DsType.numSm.tracking, -0.01);
      expectSpec(
        '.type-num-sm',
        DsType.numSm,
        family: 'GeistMono',
        size: 12, // --text-num-sm
        height: 1.2,
        weight: FontWeight.w600,
        wght: 600,
        tracking: -0.01,
        uppercase: false,
        tabular: true,
        defaultColor: DsTypeColor.none,
      );
    });

    test('.type-num — mono 15/1.2, 600 tabular -0.01em (L1275)', () {
      expectSpec(
        '.type-num',
        DsType.numBase,
        family: 'GeistMono',
        size: 15, // --text-body
        height: 1.2,
        weight: FontWeight.w600,
        wght: 600,
        tracking: -0.01,
        uppercase: false,
        tabular: true,
        defaultColor: DsTypeColor.none,
      );
    });

    test('.type-num-md — mono 20/1.15, 600 tabular -0.01em (L1279)', () {
      expectSpec(
        '.type-num-md',
        DsType.numMd,
        family: 'GeistMono',
        size: 20, // 1.25rem
        height: 1.15,
        weight: FontWeight.w600,
        wght: 600,
        tracking: -0.01,
        uppercase: false,
        tabular: true,
        defaultColor: DsTypeColor.none,
      );
    });

    test('.type-num-lg — mono 28/1.05, 600 tabular -0.01em (L1283)', () {
      expectSpec(
        '.type-num-lg',
        DsType.numLg,
        family: 'GeistMono',
        size: 28, // 1.75rem
        height: 1.05,
        weight: FontWeight.w600,
        wght: 600,
        tracking: -0.01,
        uppercase: false,
        tabular: true,
        defaultColor: DsTypeColor.none,
      );
    });

    test('.type-num-xl — mono 40/1, 600 tabular, tracking overridden to '
        '-0.025em (L1287)', () {
      expectSpec(
        '.type-num-xl',
        DsType.numXl,
        family: 'GeistMono',
        size: 40, // 2.5rem
        height: 1,
        weight: FontWeight.w600,
        wght: 600,
        tracking: -0.025, // the one numeric that leaves --tracking-num
        uppercase: false,
        tabular: true,
        defaultColor: DsTypeColor.none,
      );
    });
  });

  group('DsType — cross-class invariants', () {
    test('exactly five classes set their own colour, all muted-foreground', () {
      final List<DsTypeSpec> muted = <DsTypeSpec>[
        DsType.lead,
        DsType.small,
        DsType.label,
        DsType.micro,
        DsType.section,
      ];
      for (final DsTypeSpec spec in muted) {
        expect(spec.defaultColor, DsTypeColor.muted);
      }
      expect(DsType.all.where((DsTypeSpec s) => s.defaultColor != DsTypeColor.none),
          hasLength(5));
    });

    test('exactly five classes uppercase: label, serial, micro, tag, badge', () {
      expect(DsType.all.where((DsTypeSpec s) => s.uppercase), hasLength(5));
      for (final DsTypeSpec spec in <DsTypeSpec>[
        DsType.label,
        DsType.serial,
        DsType.micro,
        DsType.tag,
        DsType.badge,
      ]) {
        expect(spec.uppercase, isTrue);
      }
    });

    test('exactly the six .type-num-* classes are tabular, all mono', () {
      final Iterable<DsTypeSpec> tabular =
          DsType.all.where((DsTypeSpec s) => s.tabular);
      expect(tabular, hasLength(6));
      for (final DsTypeSpec spec in tabular) {
        expect(spec.family, DsFonts.mono);
        expect(spec.weight, FontWeight.w600);
      }
    });

    test('the mono face carries the numerics, code and serials only', () {
      expect(DsType.all.where((DsTypeSpec s) => s.family == DsFonts.mono),
          hasLength(8)); // 6 numerics + code + serial
    });

    test('.type-accent is the only class off the two foundation faces', () {
      expect(DsType.all.where((DsTypeSpec s) => s.family == DsFonts.accent),
          <DsTypeSpec>[DsType.accent]);
      expect(DsType.all.where((DsTypeSpec s) => s.fontStyle == FontStyle.italic),
          <DsTypeSpec>[DsType.accent]);
    });

    test('all 27 classes are registered', () {
      expect(DsType.all, hasLength(27));
    });
  });

  group('DsTypeSpec.resolve', () {
    test('prefixes the family with the package so call sites never do', () {
      final TextStyle style = DsType.numSm.resolve(12, _ink);
      expect(style.fontFamily, 'packages/elattar_design_system/GeistMono');
    });

    test('converts em tracking to px letterSpacing against the resolved size',
        () {
      expect(DsType.numSm.resolve(12, _ink).letterSpacing,
          closeTo(-0.12, 1e-9)); // -0.01em × 12
      expect(DsType.label.resolve(11, _ink).letterSpacing,
          closeTo(1.76, 1e-9)); // 0.16em × 11
      expect(DsType.display.resolve(64, _ink).letterSpacing,
          closeTo(-1.92, 1e-9)); // -0.03em × 64
      expect(DsType.numXl.resolve(40, _ink).letterSpacing,
          closeTo(-1, 1e-9)); // -0.025em × 40
    });

    test('a class with no letter-spacing resolves to none', () {
      expect(DsType.body.resolve(15, _ink).letterSpacing, isNull);
      expect(DsType.h4.resolve(17, _ink).letterSpacing, isNull);
    });

    test('a tabular class carries FontFeature.tabularFigures()', () {
      final TextStyle style = DsType.numBase.resolve(15, _ink);
      expect(style.fontFeatures, contains(const FontFeature.tabularFigures()));
      expect(DsType.body.resolve(15, _ink).fontFeatures, anyOf(isNull, isEmpty));
    });

    test('carries size, height, weight, style and colour through', () {
      final TextStyle style = DsType.lead.resolve(17, _ink);
      expect(style.fontSize, 17);
      expect(style.height, 1.65);
      expect(style.fontWeight, FontWeight.w400);
      expect(style.fontStyle, FontStyle.normal);
      expect(style.color, _ink);

      final TextStyle accent = DsType.accent.resolve(67.52, _ink);
      expect(accent.fontStyle, FontStyle.italic);
      expect(accent.height, isNull); // no line-height declared
    });

    test('an inherited font-weight stays unset', () {
      expect(DsType.code.resolve(12.5, _ink).fontWeight, isNull);
      expect(DsType.code.resolve(12.5, _ink).fontVariations, anyOf(isNull, isEmpty));
      expect(DsType.serial.resolve(15, _ink).fontWeight, isNull);
    });

    test('an explicit size overrides a fixed-size class', () {
      expect(DsType.body.size, 15);
      final TextStyle style = DsType.body.resolve(24, _ink);
      expect(style.fontSize, 24);
      expect(DsType.h2.resolve(24, _ink).fontSize, 24);
    });

    test('uppercase is a flag only — resolve applies no transform', () {
      expect(DsType.label.uppercase, isTrue);
      expect(DsType.label.resolve(11, _ink).fontFeatures, anyOf(isNull, isEmpty));
    });

    test('the fluid classes resolve at whatever the viewport hands them', () {
      expect(DsType.display.resolve(DsType.displaySize(1440), _ink).fontSize,
          closeTo(63.36, 1e-9));
      expect(DsType.h1.resolve(DsType.h1Size(1440), _ink).fontSize, 40);
    });
  });

  // ─── motion ──────────────────────────────────────────────────────────────

  group('DsDurations (globals.css L398–418)', () {
    test('every duration token', () {
      expect(DsDurations.tick, const Duration(milliseconds: 80));
      expect(DsDurations.fast, const Duration(milliseconds: 150));
      expect(DsDurations.base, const Duration(milliseconds: 250));
      expect(DsDurations.slow, const Duration(milliseconds: 400));
      expect(DsDurations.overlay, const Duration(milliseconds: 320));
      expect(DsDurations.jelly, const Duration(milliseconds: 420));
      expect(DsDurations.reward, const Duration(milliseconds: 550));
      expect(DsDurations.bloom, const Duration(milliseconds: 1000));
      expect(DsDurations.sway, const Duration(seconds: 44));
      expect(DsDurations.swayAlt, const Duration(seconds: 33));
    });

    test('base is the framework default transition duration (L395)', () {
      expect(DsDurations.base, const Duration(milliseconds: 250));
      expect(DsDurations.base.inMilliseconds, 250);
    });

    test('the two sways are deliberately not multiples of each other', () {
      expect(DsDurations.sway.inSeconds % DsDurations.swayAlt.inSeconds,
          isNot(0));
    });
  });

  group('DsCurves (globals.css L420–432)', () {
    test('--ease-spring: cubic-bezier(0.34, 1.56, 0.64, 1)', () {
      expect(DsCurves.spring, const Cubic(0.34, 1.56, 0.64, 1));
      expect(<double>[
        DsCurves.spring.a,
        DsCurves.spring.b,
        DsCurves.spring.c,
        DsCurves.spring.d,
      ], <double>[0.34, 1.56, 0.64, 1]);
    });

    test('--ease-out: cubic-bezier(0.22, 1, 0.36, 1)', () {
      expect(DsCurves.out, const Cubic(0.22, 1, 0.36, 1));
      expect(<double>[
        DsCurves.out.a,
        DsCurves.out.b,
        DsCurves.out.c,
        DsCurves.out.d,
      ], <double>[0.22, 1, 0.36, 1]);
    });

    test('--ease-in: cubic-bezier(0.7, 0, 0.84, 0) — not Tailwind\'s', () {
      expect(DsCurves.curveIn, const Cubic(0.7, 0, 0.84, 0));
      expect(<double>[
        DsCurves.curveIn.a,
        DsCurves.curveIn.b,
        DsCurves.curveIn.c,
        DsCurves.curveIn.d,
      ], <double>[0.7, 0, 0.84, 0]);
    });

    test('--ease-in-out: cubic-bezier(0.65, 0, 0.35, 1)', () {
      expect(DsCurves.inOut, const Cubic(0.65, 0, 0.35, 1));
      expect(<double>[
        DsCurves.inOut.a,
        DsCurves.inOut.b,
        DsCurves.inOut.c,
        DsCurves.inOut.d,
      ], <double>[0.65, 0, 0.35, 1]);
    });

    test('--ease-settle: cubic-bezier(0.16, 1, 0.3, 1)', () {
      expect(DsCurves.settle, const Cubic(0.16, 1, 0.3, 1));
      expect(<double>[
        DsCurves.settle.a,
        DsCurves.settle.b,
        DsCurves.settle.c,
        DsCurves.settle.d,
      ], <double>[0.16, 1, 0.3, 1]);
    });

    test('--ease-standard: cubic-bezier(0.4, 0, 0.2, 1)', () {
      expect(DsCurves.standard, const Cubic(0.4, 0, 0.2, 1));
      expect(<double>[
        DsCurves.standard.a,
        DsCurves.standard.b,
        DsCurves.standard.c,
        DsCurves.standard.d,
      ], <double>[0.4, 0, 0.2, 1]);
    });

    test('--ease-out-flex: cubic-bezier(0.05, 0.6, 0.4, 0.9)', () {
      expect(DsCurves.outFlex, const Cubic(0.05, 0.6, 0.4, 0.9));
      expect(<double>[
        DsCurves.outFlex.a,
        DsCurves.outFlex.b,
        DsCurves.outFlex.c,
        DsCurves.outFlex.d,
      ], <double>[0.05, 0.6, 0.4, 0.9]);
    });

    test('the spring overshoots past 1 and settles back', () {
      expect(DsCurves.spring.transform(0.5), greaterThan(0.5));
      expect(DsCurves.spring.transform(1), 1);
      expect(DsCurves.spring.transform(0), 0);
    });

    test('all seven easings are registered', () {
      expect(DsCurves.all, hasLength(7));
    });
  });

  // --- shadows (appended by lead) ---

  group('DsShadows — geometry is fixed, ink is themed (globals.css L354–387)', () {
    void expectLayer(
      DsShadowLayer layer,
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
      expect(DsShadows.e1.layers, hasLength(2));
      expectLayer(DsShadows.e1.layers[0], 0, 1, 1, 0);
      expectLayer(DsShadows.e1.layers[1], 0, 1, 3, 0);
      expect(DsShadows.e1.layers[0].color(DsThemeData.dark), DsThemeData.dark.ink2);
      expect(DsShadows.e1.layers[1].color(DsThemeData.dark), DsThemeData.dark.ink1);
      expect(DsShadows.e1.hasInset, isFalse);
    });

    test('e2: 0 1px 2px ink-2, 0 4px 10px -2px ink-2', () {
      expectLayer(DsShadows.e2.layers[0], 0, 1, 2, 0);
      expectLayer(DsShadows.e2.layers[1], 0, 4, 10, -2);
      expect(DsShadows.e2.layers.every((l) => l.color(DsThemeData.light) == DsThemeData.light.ink2), isTrue);
    });

    test('e3: 0 2px 4px ink-2, 0 14px 28px -8px ink-3', () {
      expectLayer(DsShadows.e3.layers[0], 0, 2, 4, 0);
      expectLayer(DsShadows.e3.layers[1], 0, 14, 28, -8);
      expect(DsShadows.e3.layers[0].color(DsThemeData.dark), DsThemeData.dark.ink2);
      expect(DsShadows.e3.layers[1].color(DsThemeData.dark), DsThemeData.dark.ink3);
      expect(DsShadows.e3.hasInset, isFalse);
    });

    test('e4: 0 4px 8px ink-3, 0 28px 56px -14px ink-4', () {
      expectLayer(DsShadows.e4.layers[0], 0, 4, 8, 0);
      expectLayer(DsShadows.e4.layers[1], 0, 28, 56, -14);
      expect(DsShadows.e4.layers[0].color(DsThemeData.light), DsThemeData.light.ink3);
      expect(DsShadows.e4.layers[1].color(DsThemeData.light), DsThemeData.light.ink4);
    });

    test('key / key-down: the wall layer and its socket', () {
      expectLayer(DsShadows.key.layers[0], 0, 4, 0, 0);
      expect(DsShadows.key.layers[0].color(DsThemeData.dark), DsThemeData.dark.wall);
      expectLayer(DsShadows.key.layers[1], 0, 7, 12, 0);
      expect(DsShadows.key.hasInset, isFalse);

      expectLayer(DsShadows.keyDown.layers[0], 0, 1, 0, 0);
      expectLayer(DsShadows.keyDown.layers[1], 0, 2, 5, 0, inset: true);
      expect(DsShadows.keyDown.hasInset, isTrue);
    });

    test('pressed: both layers inset', () {
      expectLayer(DsShadows.pressed.layers[0], 0, 2, 5, 0, inset: true);
      expectLayer(DsShadows.pressed.layers[1], 0, 1, 2, 0, inset: true);
      expect(DsShadows.pressed.hasInset, isTrue);
      expect(DsShadows.pressed.outerShadows(DsThemeData.dark), isEmpty);
    });

    test('btn: rim highlight + inner bottom shade + two outer layers', () {
      expect(DsShadows.btn.layers, hasLength(4));
      expectLayer(DsShadows.btn.layers[0], 0, 1, 0, 0, inset: true);
      expect(DsShadows.btn.layers[0].color(DsThemeData.dark), DsThemeData.dark.rim);
      expectLayer(DsShadows.btn.layers[1], 0, -2, 4, 0, inset: true);
      expectLayer(DsShadows.btn.layers[2], 0, 1, 2, 0);
      expectLayer(DsShadows.btn.layers[3], 0, 3, 8, -2);
      expect(DsShadows.btn.hasInset, isTrue);
      expect(DsShadows.btn.insetLayers, hasLength(2));
      expect(DsShadows.btn.outerShadows(DsThemeData.dark), hasLength(2));
    });

    test('btn-primary: rim-strong + action cast at 55%', () {
      expectLayer(DsShadows.btnPrimary.layers[0], 0, 1, 0, 0, inset: true);
      expect(DsShadows.btnPrimary.layers[0].color(DsThemeData.light),
          DsThemeData.light.rimStrong);
      expectLayer(DsShadows.btnPrimary.layers[1], 0, -2, 5, 0, inset: true);
      expectLayer(DsShadows.btnPrimary.layers[2], 0, 1, 2, 0);
      expectLayer(DsShadows.btnPrimary.layers[3], 0, 4, 10, -2);
      expect(DsShadows.btnPrimary.layers[3].color(DsThemeData.dark),
          DsPalette.action.withValues(alpha: 0.55));
    });

    test('btn-value: ink-1 inner shade + value cast at 45%', () {
      expectLayer(DsShadows.btnValue.layers[1], 0, -2, 5, 0, inset: true);
      expect(DsShadows.btnValue.layers[1].color(DsThemeData.dark), DsThemeData.dark.ink1);
      expect(DsShadows.btnValue.layers[3].color(DsThemeData.dark),
          DsPalette.value.withValues(alpha: 0.45));
    });

    test('btn-down / chip', () {
      expectLayer(DsShadows.btnDown.layers[0], 0, 2, 4, 0, inset: true);
      expectLayer(DsShadows.btnDown.layers[1], 0, 1, 1, 0);
      expectLayer(DsShadows.chip.layers[0], 0, 1, 0, 0, inset: true);
      expectLayer(DsShadows.chip.layers[1], 0, -1, 2, 0, inset: true);
      expectLayer(DsShadows.chip.layers[2], 0, 1, 2, 0);
    });

    test('glow-action: 0 0 0 1px action-bright@45% + 0 10 34 -8 action@60%', () {
      expectLayer(DsShadows.glowAction.layers[0], 0, 0, 0, 1);
      expect(DsShadows.glowAction.layers[0].color(DsThemeData.dark),
          DsPalette.actionBright.withValues(alpha: 0.45));
      expectLayer(DsShadows.glowAction.layers[1], 0, 10, 34, -8);
      expect(DsShadows.glowAction.layers[1].color(DsThemeData.dark),
          DsPalette.action.withValues(alpha: 0.60));
      expect(DsShadows.glowAction.hasInset, isFalse);
    });

    test('glow-value: 0 0 0 1px value@45% + 0 10 34 -8 value@42%', () {
      expectLayer(DsShadows.glowValue.layers[0], 0, 0, 0, 1);
      expect(DsShadows.glowValue.layers[0].color(DsThemeData.light),
          DsPalette.value.withValues(alpha: 0.45));
      expectLayer(DsShadows.glowValue.layers[1], 0, 10, 34, -8);
      expect(DsShadows.glowValue.layers[1].color(DsThemeData.light),
          DsPalette.value.withValues(alpha: 0.42));
    });

    test('ink flips with the theme — same geometry, different colour', () {
      final BoxShadow darkTop = DsShadows.e3.outerShadows(DsThemeData.dark).last;
      final BoxShadow lightTop = DsShadows.e3.outerShadows(DsThemeData.light).last;
      expect(darkTop.offset, lightTop.offset);
      expect(darkTop.blurRadius, lightTop.blurRadius);
      expect(darkTop.color, isNot(lightTop.color));
      expect(darkTop.color, DsThemeData.dark.ink2);
      expect(lightTop.color, DsThemeData.light.ink2);
    });

    test('CSS blur maps to the CSS Gaussian sigma, not Flutter default', () {
      // CSS: sigma = blur / 2. Flutter: sigma = radius * 0.57735 + 0.5.
      const DsShadowLayer layer = DsShadowLayer(0, 28, 56, -14, _dummyInk);
      expect(layer.blurRadius * 0.57735 + 0.5, closeTo(28.0, 0.001));
      // Known limit: sigmas below 0.5 are unreachable, so a 1px CSS blur
      // collapses to a hard edge.
      const DsShadowLayer hairline = DsShadowLayer(0, 1, 1, 0, _dummyInk);
      expect(hairline.blurRadius, 0);
      const DsShadowLayer none = DsShadowLayer(0, 0, 0, 1, _dummyInk);
      expect(none.blurRadius, 0);
    });

    test('outerShadows reverses CSS order so the first layer paints on top', () {
      final List<BoxShadow> shadows = DsShadows.e4.outerShadows(DsThemeData.dark);
      expect(shadows.first.offset.dy, 28); // CSS-last painted first (bottom-most)
      expect(shadows.last.offset.dy, 4); // CSS-first painted last (on top)
    });
  });
}

Color _dummyInk(DsThemeData t) => t.ink2;

