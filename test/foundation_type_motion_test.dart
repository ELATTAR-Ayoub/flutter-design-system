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
/// resolved font size only inside [ElTypeSpec.resolve].

/// A colour to resolve against; the value is irrelevant to these assertions.
const Color _ink = Color(0xFF92C2FC);

/// Asserts one `.type-*` class field by field.
void expectSpec(
  String css,
  ElTypeSpec spec, {
  required String family,
  required double? size,
  required double? height,
  required FontWeight? weight,
  required double? wght,
  required double? tracking,
  required bool uppercase,
  required bool tabular,
  required ElTypeColor defaultColor,
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

  group('ElFonts — the three faces (globals.css L169–172)', () {
    test('families follow the tokens, not the Space Grotesk prose', () {
      expect(ElFonts.sans, 'InterLocal');
      expect(ElFonts.heading, 'InterLocal');
      expect(ElFonts.mono, 'GeistMono');
      expect(ElFonts.accent, 'Redaction35');
    });

    test('package name is the asset prefix flutter_tools registers', () {
      expect(ElFonts.package, 'elattar_design_system');
    });
  });

  group('ElType — fluid sizes (clamp)', () {
    test(
      'displaySize is clamp(2.75rem, 4.4vw, 4rem) = clamp(44, 4.4vw, 64)',
      () {
        expect(
          ElType.displaySize(1000),
          44,
        ); // 4.4vw of 1000 = 44 — the min edge
        expect(ElType.displaySize(700), 44); // 30.8 → floored at 44
        expect(ElType.displaySize(1280), closeTo(56.32, 1e-9));
        expect(ElType.displaySize(1440), closeTo(63.36, 1e-9));
        expect(ElType.displaySize(1600), 64); // 70.4 → clamped at the 64 max
        expect(ElType.displaySize(2560), 64);
      },
    );

    test('h1Size is clamp(2rem, 2.8vw, 2.5rem) = clamp(32, 2.8vw, 40)', () {
      expect(ElType.h1Size(1440), 40); // 40.32 → clamped at the 40 max
      expect(ElType.h1Size(1000), 32); // 28 → floored at 32
      expect(ElType.h1Size(1280), closeTo(35.84, 1e-9));
      expect(ElType.h1Size(1200), closeTo(33.6, 1e-9));
    });

    test('accentSize is 1.055em — it rides the size it is set inside', () {
      expect(ElType.accentSize(64), closeTo(67.52, 1e-9));
      expect(ElType.accentSize(ElType.displaySize(1000)), closeTo(46.42, 1e-9));
    });
  });

  group('ElType — every .type-* class, value for value (globals.css §5)', () {
    test(
      '.type-display — heading face, clamp 44–64/1, 500, -0.03em (L1019)',
      () {
        expectSpec(
          '.type-display',
          ElType.display,
          family: 'InterLocal',
          size: null, // clamp() — resolved from the viewport
          height: 1,
          weight: FontWeight.w500,
          wght: 500,
          tracking: -0.03,
          uppercase: false,
          tabular: false,
          defaultColor: ElTypeColor.none,
        );
      },
    );

    test(
      '.type-accent — Redaction 35, 1.055em italic, 400, -0.03em (L1046)',
      () {
        expectSpec(
          '.type-accent',
          ElType.accent,
          family: 'Redaction35',
          size: null, // 1.055em — relative to the inherited size
          height: null, // no line-height declared: inherits
          weight: FontWeight.w400,
          wght: 400,
          tracking: -0.03,
          uppercase: false,
          tabular: false,
          defaultColor: ElTypeColor.none,
          fontStyle: FontStyle.italic,
        );
      },
    );

    test('.type-h1 — clamp 32–40/1.1, 700, -0.02em (L1070)', () {
      expectSpec(
        '.type-h1',
        ElType.h1,
        family: 'InterLocal',
        size: null, // clamp()
        height: 1.1,
        weight: FontWeight.w700,
        wght: 700,
        tracking: -0.02,
        uppercase: false,
        tabular: false,
        defaultColor: ElTypeColor.none,
      );
    });

    test('.type-h2 — 28/1.2, weight 650 via wght axis, -0.015em (L1077)', () {
      expectSpec(
        '.type-h2',
        ElType.h2,
        family: 'InterLocal',
        size: 28, // 1.75rem
        height: 1.2,
        weight: FontWeight.w600, // non-variable fallback; 650 has no FontWeight
        wght: 650,
        tracking: -0.015,
        uppercase: false,
        tabular: false,
        defaultColor: ElTypeColor.none,
      );
    });

    test('.type-h2 renders wght 650 through variations, not weight', () {
      expect(ElType.h2.variations, hasLength(1));
      expect(ElType.h2.variations.single.axis, 'wght');
      expect(ElType.h2.variations.single.value, 650);
      // resolve() adds the browser's `font-optical-sizing: auto`: opsz = the
      // CSS px size, clamped to Inter's 14–32 axis range.
      expect(ElType.h2.resolve(28, _ink).fontVariations, <FontVariation>[
        FontVariation('wght', 650),
        FontVariation('opsz', 28),
      ]);
    });

    test('optical sizing mirrors the browser: sans only, clamped 14–32', () {
      // 13px body-adjacent text → opsz 14 (clamped up from 13).
      expect(
        ElType.small.resolve(13, _ink).fontVariations,
        contains(const FontVariation('opsz', 14)),
      );
      // 40px h1 → opsz 32 (clamped down from 40).
      expect(
        ElType.h1.resolve(40, _ink).fontVariations,
        contains(const FontVariation('opsz', 32)),
      );
      // 17px lead → opsz tracks the size exactly inside the range.
      expect(
        ElType.lead.resolve(17, _ink).fontVariations,
        contains(const FontVariation('opsz', 17)),
      );
      // Geist Mono has no opsz axis — mono classes must not carry one.
      final List<FontVariation>? mono = ElType.numSm
          .resolve(12, _ink)
          .fontVariations;
      expect(mono!.where((FontVariation v) => v.axis == 'opsz'), isEmpty);
    });

    test('.type-h3 — 21/1.3, 600, -0.01em (L1084)', () {
      expectSpec(
        '.type-h3',
        ElType.h3,
        family: 'InterLocal',
        size: 21, // 1.3125rem
        height: 1.3,
        weight: FontWeight.w600,
        wght: 600,
        tracking: -0.01,
        uppercase: false,
        tabular: false,
        defaultColor: ElTypeColor.none,
      );
    });

    test('.type-h4 — 17/1.4, 600, no tracking (L1091)', () {
      expectSpec(
        '.type-h4',
        ElType.h4,
        family: 'InterLocal',
        size: 17, // 1.0625rem
        height: 1.4,
        weight: FontWeight.w600,
        wght: 600,
        tracking: null,
        uppercase: false,
        tabular: false,
        defaultColor: ElTypeColor.none,
      );
    });

    test('.type-lead — 17/1.65, 400, muted-foreground (L1099)', () {
      expectSpec(
        '.type-lead',
        ElType.lead,
        family: 'InterLocal',
        size: 17, // 1.0625rem
        height: 1.65,
        weight: FontWeight.w400,
        wght: 400,
        tracking: null,
        uppercase: false,
        tabular: false,
        defaultColor: ElTypeColor.muted,
      );
    });

    test('.type-body — 15/1.6, 400 (L1105)', () {
      expectSpec(
        '.type-body',
        ElType.body,
        family: 'InterLocal',
        size: 15, // --text-body
        height: 1.6,
        weight: FontWeight.w400,
        wght: 400,
        tracking: null,
        uppercase: false,
        tabular: false,
        defaultColor: ElTypeColor.none,
      );
    });

    test('.type-small — 13/1.5, 400, muted-foreground (L1120)', () {
      expectSpec(
        '.type-small',
        ElType.small,
        family: 'InterLocal',
        size: 13, // --text-small
        height: 1.5,
        weight: FontWeight.w400,
        wght: 400,
        tracking: null,
        uppercase: false,
        tabular: false,
        defaultColor: ElTypeColor.muted,
      );
    });

    test('.type-nav — 13.5/1.2, 500 (L1128)', () {
      expectSpec(
        '.type-nav',
        ElType.nav,
        family: 'InterLocal',
        size: 13.5, // --text-nav
        height: 1.2,
        weight: FontWeight.w500,
        wght: 500,
        tracking: null,
        uppercase: false,
        tabular: false,
        defaultColor: ElTypeColor.none,
      );
    });

    test('.type-nav-sm — 11.5/1.2, 500 (L1139)', () {
      expectSpec(
        '.type-nav-sm',
        ElType.navSm,
        family: 'InterLocal',
        size: 11.5, // --text-chip
        height: 1.2,
        weight: FontWeight.w500,
        wght: 500,
        tracking: null,
        uppercase: false,
        tabular: false,
        defaultColor: ElTypeColor.none,
      );
    });

    test('.type-chip — 11.5/1.2, 500 (L1145)', () {
      expectSpec(
        '.type-chip',
        ElType.chip,
        family: 'InterLocal',
        size: 11.5, // --text-chip
        height: 1.2,
        weight: FontWeight.w500,
        wght: 500,
        tracking: null,
        uppercase: false,
        tabular: false,
        defaultColor: ElTypeColor.none,
      );
    });

    test('.type-caption — 10.5/1.35, 500 (L1151)', () {
      expectSpec(
        '.type-caption',
        ElType.caption,
        family: 'InterLocal',
        size: 10.5, // --text-micro
        height: 1.35,
        weight: FontWeight.w500,
        wght: 500,
        tracking: null,
        uppercase: false,
        tabular: false,
        defaultColor: ElTypeColor.none,
      );
    });

    test('.type-code — mono 12.5/1.4, NO font-weight declared (L1157)', () {
      expectSpec(
        '.type-code',
        ElType.code,
        family: 'GeistMono',
        size: 12.5, // --text-code
        height: 1.4,
        weight: null, // inherits — globals.css declares none
        wght: null,
        tracking: null,
        uppercase: false,
        tabular: false,
        defaultColor: ElTypeColor.none,
      );
    });

    test(
      '.type-label — 11/1, 600 uppercase 0.16em muted-foreground (L1164)',
      () {
        expect(ElType.label.uppercase, isTrue);
        expect(ElType.label.size, 11);
        expect(ElType.label.tracking, 0.16);
        expectSpec(
          '.type-label',
          ElType.label,
          family: 'InterLocal',
          size: 11, // --text-label
          height: 1,
          weight: FontWeight.w600,
          wght: 600,
          tracking: 0.16, // --tracking-label
          uppercase: true,
          tabular: false,
          defaultColor: ElTypeColor.muted,
        );
      },
    );

    test('.type-section — 13/1.4, 600, muted-foreground (L1192)', () {
      expectSpec(
        '.type-section',
        ElType.section,
        family: 'InterLocal',
        size: 13, // --text-small
        height: 1.4,
        weight: FontWeight.w600,
        wght: 600,
        tracking: null,
        uppercase: false,
        tabular: false,
        defaultColor: ElTypeColor.muted,
      );
    });

    test('.type-wordmark — 15/1, 700, -0.01em (L1201)', () {
      expectSpec(
        '.type-wordmark',
        ElType.wordmark,
        family: 'InterLocal',
        size: 15, // --text-body
        height: 1,
        weight: FontWeight.w700,
        wght: 700,
        tracking: -0.01, // --tracking-num
        uppercase: false,
        tabular: false,
        defaultColor: ElTypeColor.none,
      );
    });

    test('.type-serial — mono 15/1.4 uppercase -0.01em, NO weight (L1211)', () {
      expectSpec(
        '.type-serial',
        ElType.serial,
        family: 'GeistMono',
        size: 15, // --text-body
        height: 1.4,
        weight: null, // inherits — globals.css declares none
        wght: null,
        tracking: -0.01, // --tracking-num
        uppercase: true,
        tabular: false, // .type-serial is NOT part of the numeric rule
        defaultColor: ElTypeColor.none,
      );
    });

    test('.type-micro — 10.5/1, 600 uppercase 0.18em muted (L1218)', () {
      expectSpec(
        '.type-micro',
        ElType.micro,
        family: 'InterLocal',
        size: 10.5, // --text-micro
        height: 1,
        weight: FontWeight.w600,
        wght: 600,
        tracking: 0.18, // --tracking-micro
        uppercase: true,
        tabular: false,
        defaultColor: ElTypeColor.muted,
      );
    });

    test('.type-tag — 10/1, 600 uppercase 0.12em (L1238)', () {
      expectSpec(
        '.type-tag',
        ElType.tag,
        family: 'InterLocal',
        size: 10, // --text-tag
        height: 1,
        weight: FontWeight.w600,
        wght: 600,
        tracking: 0.12, // --tracking-tag
        uppercase: true,
        tabular: false,
        defaultColor: ElTypeColor.none,
      );
    });

    test('.type-badge — 11/1, 600 uppercase 0.14em (L1246)', () {
      expectSpec(
        '.type-badge',
        ElType.badge,
        family: 'InterLocal',
        size: 11, // --text-label
        height: 1,
        weight: FontWeight.w600,
        wght: 600,
        tracking: 0.14, // --tracking-badge
        uppercase: true,
        tabular: false,
        defaultColor: ElTypeColor.none,
      );
    });

    test('.type-num-xs — mono 11/1.2, 600 tabular -0.01em (L1267)', () {
      expectSpec(
        '.type-num-xs',
        ElType.numXs,
        family: 'GeistMono',
        size: 11, // --text-label
        height: 1.2,
        weight: FontWeight.w600,
        wght: 600,
        tracking: -0.01, // --tracking-num, from the shared rule L1256–1266
        uppercase: false,
        tabular: true,
        defaultColor: ElTypeColor.none,
      );
    });

    test('.type-num-sm — mono 12/1.2, 600 tabular -0.01em (L1271)', () {
      expect(ElType.numSm.family, ElFonts.mono);
      expect(ElType.numSm.size, 12);
      expect(ElType.numSm.height, 1.2);
      expect(ElType.numSm.weight, FontWeight.w600);
      expect(ElType.numSm.tabular, isTrue);
      expect(ElType.numSm.tracking, -0.01);
      expectSpec(
        '.type-num-sm',
        ElType.numSm,
        family: 'GeistMono',
        size: 12, // --text-num-sm
        height: 1.2,
        weight: FontWeight.w600,
        wght: 600,
        tracking: -0.01,
        uppercase: false,
        tabular: true,
        defaultColor: ElTypeColor.none,
      );
    });

    test('.type-num — mono 15/1.2, 600 tabular -0.01em (L1275)', () {
      expectSpec(
        '.type-num',
        ElType.numBase,
        family: 'GeistMono',
        size: 15, // --text-body
        height: 1.2,
        weight: FontWeight.w600,
        wght: 600,
        tracking: -0.01,
        uppercase: false,
        tabular: true,
        defaultColor: ElTypeColor.none,
      );
    });

    test('.type-num-md — mono 20/1.15, 600 tabular -0.01em (L1279)', () {
      expectSpec(
        '.type-num-md',
        ElType.numMd,
        family: 'GeistMono',
        size: 20, // 1.25rem
        height: 1.15,
        weight: FontWeight.w600,
        wght: 600,
        tracking: -0.01,
        uppercase: false,
        tabular: true,
        defaultColor: ElTypeColor.none,
      );
    });

    test('.type-num-lg — mono 28/1.05, 600 tabular -0.01em (L1283)', () {
      expectSpec(
        '.type-num-lg',
        ElType.numLg,
        family: 'GeistMono',
        size: 28, // 1.75rem
        height: 1.05,
        weight: FontWeight.w600,
        wght: 600,
        tracking: -0.01,
        uppercase: false,
        tabular: true,
        defaultColor: ElTypeColor.none,
      );
    });

    test('.type-num-xl — mono 40/1, 600 tabular, tracking overridden to '
        '-0.025em (L1287)', () {
      expectSpec(
        '.type-num-xl',
        ElType.numXl,
        family: 'GeistMono',
        size: 40, // 2.5rem
        height: 1,
        weight: FontWeight.w600,
        wght: 600,
        tracking: -0.025, // the one numeric that leaves --tracking-num
        uppercase: false,
        tabular: true,
        defaultColor: ElTypeColor.none,
      );
    });
  });

  group('ElType — cross-class invariants', () {
    test('exactly five classes set their own colour, all muted-foreground', () {
      final List<ElTypeSpec> muted = <ElTypeSpec>[
        ElType.lead,
        ElType.small,
        ElType.label,
        ElType.micro,
        ElType.section,
      ];
      for (final ElTypeSpec spec in muted) {
        expect(spec.defaultColor, ElTypeColor.muted);
      }
      expect(
        ElType.all.where((ElTypeSpec s) => s.defaultColor != ElTypeColor.none),
        hasLength(5),
      );
    });

    test(
      'exactly five classes uppercase: label, serial, micro, tag, badge',
      () {
        expect(ElType.all.where((ElTypeSpec s) => s.uppercase), hasLength(5));
        for (final ElTypeSpec spec in <ElTypeSpec>[
          ElType.label,
          ElType.serial,
          ElType.micro,
          ElType.tag,
          ElType.badge,
        ]) {
          expect(spec.uppercase, isTrue);
        }
      },
    );

    test('exactly the six .type-num-* classes are tabular, all mono', () {
      final Iterable<ElTypeSpec> tabular = ElType.all.where(
        (ElTypeSpec s) => s.tabular,
      );
      expect(tabular, hasLength(6));
      for (final ElTypeSpec spec in tabular) {
        expect(spec.family, ElFonts.mono);
        expect(spec.weight, FontWeight.w600);
      }
    });

    test('the mono face carries the numerics, code and serials only', () {
      expect(
        ElType.all.where((ElTypeSpec s) => s.family == ElFonts.mono),
        hasLength(8),
      ); // 6 numerics + code + serial
    });

    test('.type-accent is the only class off the two foundation faces', () {
      expect(
        ElType.all.where((ElTypeSpec s) => s.family == ElFonts.accent),
        <ElTypeSpec>[ElType.accent],
      );
      expect(
        ElType.all.where((ElTypeSpec s) => s.fontStyle == FontStyle.italic),
        <ElTypeSpec>[ElType.accent],
      );
    });

    test('all 27 classes are registered', () {
      expect(ElType.all, hasLength(27));
    });
  });

  group('ElTypeSpec.resolve', () {
    test('prefixes the family with the package so call sites never do', () {
      final TextStyle style = ElType.numSm.resolve(12, _ink);
      expect(style.fontFamily, 'packages/elattar_design_system/GeistMono');
    });

    test(
      'converts em tracking to px letterSpacing against the resolved size',
      () {
        expect(
          ElType.numSm.resolve(12, _ink).letterSpacing,
          closeTo(-0.12, 1e-9),
        ); // -0.01em × 12
        expect(
          ElType.label.resolve(11, _ink).letterSpacing,
          closeTo(1.76, 1e-9),
        ); // 0.16em × 11
        expect(
          ElType.display.resolve(64, _ink).letterSpacing,
          closeTo(-1.92, 1e-9),
        ); // -0.03em × 64
        expect(
          ElType.numXl.resolve(40, _ink).letterSpacing,
          closeTo(-1, 1e-9),
        ); // -0.025em × 40
      },
    );

    test('a class with no letter-spacing resolves to none', () {
      expect(ElType.body.resolve(15, _ink).letterSpacing, isNull);
      expect(ElType.h4.resolve(17, _ink).letterSpacing, isNull);
    });

    test('a tabular class carries FontFeature.tabularFigures()', () {
      final TextStyle style = ElType.numBase.resolve(15, _ink);
      expect(style.fontFeatures, contains(const FontFeature.tabularFigures()));
      expect(
        ElType.body.resolve(15, _ink).fontFeatures,
        anyOf(isNull, isEmpty),
      );
    });

    test('carries size, height, weight, style and colour through', () {
      final TextStyle style = ElType.lead.resolve(17, _ink);
      expect(style.fontSize, 17);
      expect(style.height, 1.65);
      expect(style.fontWeight, FontWeight.w400);
      expect(style.fontStyle, FontStyle.normal);
      expect(style.color, _ink);

      final TextStyle accent = ElType.accent.resolve(67.52, _ink);
      expect(accent.fontStyle, FontStyle.italic);
      expect(accent.height, isNull); // no line-height declared
    });

    test('an inherited font-weight stays unset', () {
      expect(ElType.code.resolve(12.5, _ink).fontWeight, isNull);
      expect(
        ElType.code.resolve(12.5, _ink).fontVariations,
        anyOf(isNull, isEmpty),
      );
      expect(ElType.serial.resolve(15, _ink).fontWeight, isNull);
    });

    test('an explicit size overrides a fixed-size class', () {
      expect(ElType.body.size, 15);
      final TextStyle style = ElType.body.resolve(24, _ink);
      expect(style.fontSize, 24);
      expect(ElType.h2.resolve(24, _ink).fontSize, 24);
    });

    test('uppercase is a flag only — resolve applies no transform', () {
      expect(ElType.label.uppercase, isTrue);
      expect(
        ElType.label.resolve(11, _ink).fontFeatures,
        anyOf(isNull, isEmpty),
      );
    });

    test('the fluid classes resolve at whatever the viewport hands them', () {
      expect(
        ElType.display.resolve(ElType.displaySize(1440), _ink).fontSize,
        closeTo(63.36, 1e-9),
      );
      expect(ElType.h1.resolve(ElType.h1Size(1440), _ink).fontSize, 40);
    });
  });

  // ─── motion ──────────────────────────────────────────────────────────────

  group('ElDurations (globals.css L395–418)', () {
    test('every duration token', () {
      expect(ElDurations.tick, const Duration(milliseconds: 80));
      expect(ElDurations.fast, const Duration(milliseconds: 150));
      expect(ElDurations.base, const Duration(milliseconds: 250));
      expect(ElDurations.slow, const Duration(milliseconds: 400));
      expect(ElDurations.overlay, const Duration(milliseconds: 320));
      expect(ElDurations.jelly, const Duration(milliseconds: 420));
      expect(ElDurations.reward, const Duration(milliseconds: 550));
      expect(ElDurations.bloom, const Duration(milliseconds: 1000));
      expect(ElDurations.sway, const Duration(seconds: 44));
      expect(ElDurations.swayAlt, const Duration(seconds: 33));
    });

    test('the framework default transition duration (L395)', () {
      expect(ElDurations.transitionDefault, const Duration(milliseconds: 250));
      expect(ElDurations.transitionDefault.inMilliseconds, 250);
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
      expect(ElDurations.transitionDefault, ElDurations.base);
      expect(ElDurations.transitionDefault, isNot(same(ElDurations.fast)));
      expect(ElDurations.fast, const Duration(milliseconds: 150));
    });

    test('the two sways are deliberately not multiples of each other', () {
      expect(
        ElDurations.sway.inSeconds % ElDurations.swayAlt.inSeconds,
        isNot(0),
      );
    });
  });

  group('ElCurves (globals.css L420–432)', () {
    test('--ease-spring: cubic-bezier(0.34, 1.56, 0.64, 1)', () {
      expect(ElCurves.spring, const Cubic(0.34, 1.56, 0.64, 1));
      expect(
        <double>[
          ElCurves.spring.a,
          ElCurves.spring.b,
          ElCurves.spring.c,
          ElCurves.spring.d,
        ],
        <double>[0.34, 1.56, 0.64, 1],
      );
    });

    test('--ease-out: cubic-bezier(0.22, 1, 0.36, 1)', () {
      expect(ElCurves.out, const Cubic(0.22, 1, 0.36, 1));
      expect(
        <double>[
          ElCurves.out.a,
          ElCurves.out.b,
          ElCurves.out.c,
          ElCurves.out.d,
        ],
        <double>[0.22, 1, 0.36, 1],
      );
    });

    test('--ease-in: cubic-bezier(0.7, 0, 0.84, 0) — not Tailwind\'s', () {
      expect(ElCurves.curveIn, const Cubic(0.7, 0, 0.84, 0));
      expect(
        <double>[
          ElCurves.curveIn.a,
          ElCurves.curveIn.b,
          ElCurves.curveIn.c,
          ElCurves.curveIn.d,
        ],
        <double>[0.7, 0, 0.84, 0],
      );
    });

    test('--ease-in-out: cubic-bezier(0.65, 0, 0.35, 1)', () {
      expect(ElCurves.inOut, const Cubic(0.65, 0, 0.35, 1));
      expect(
        <double>[
          ElCurves.inOut.a,
          ElCurves.inOut.b,
          ElCurves.inOut.c,
          ElCurves.inOut.d,
        ],
        <double>[0.65, 0, 0.35, 1],
      );
    });

    test('--ease-settle: cubic-bezier(0.16, 1, 0.3, 1)', () {
      expect(ElCurves.settle, const Cubic(0.16, 1, 0.3, 1));
      expect(
        <double>[
          ElCurves.settle.a,
          ElCurves.settle.b,
          ElCurves.settle.c,
          ElCurves.settle.d,
        ],
        <double>[0.16, 1, 0.3, 1],
      );
    });

    test('--ease-standard: cubic-bezier(0.4, 0, 0.2, 1)', () {
      expect(ElCurves.standard, const Cubic(0.4, 0, 0.2, 1));
      expect(
        <double>[
          ElCurves.standard.a,
          ElCurves.standard.b,
          ElCurves.standard.c,
          ElCurves.standard.d,
        ],
        <double>[0.4, 0, 0.2, 1],
      );
    });

    test('--ease-out-flex: cubic-bezier(0.05, 0.6, 0.4, 0.9)', () {
      expect(ElCurves.outFlex, const Cubic(0.05, 0.6, 0.4, 0.9));
      expect(
        <double>[
          ElCurves.outFlex.a,
          ElCurves.outFlex.b,
          ElCurves.outFlex.c,
          ElCurves.outFlex.d,
        ],
        <double>[0.05, 0.6, 0.4, 0.9],
      );
    });

    test('the spring overshoots past 1 and settles back', () {
      expect(ElCurves.spring.transform(0.5), greaterThan(0.5));
      expect(ElCurves.spring.transform(1), 1);
      expect(ElCurves.spring.transform(0), 0);
    });

    test('all seven easings are registered', () {
      expect(ElCurves.all, hasLength(7));
    });
  });

  // --- shadows (appended by lead) ---

  group(
    'ElShadows — geometry is fixed, ink is themed (globals.css L354–387)',
    () {
      void expectLayer(
        ElShadowLayer layer,
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
        expect(ElShadows.e1.layers, hasLength(2));
        expectLayer(ElShadows.e1.layers[0], 0, 1, 1, 0);
        expectLayer(ElShadows.e1.layers[1], 0, 1, 3, 0);
        expect(
          ElShadows.e1.layers[0].color(ElThemeData.dark),
          ElThemeData.dark.ink2,
        );
        expect(
          ElShadows.e1.layers[1].color(ElThemeData.dark),
          ElThemeData.dark.ink1,
        );
        expect(ElShadows.e1.hasInset, isFalse);
      });

      test('e2: 0 1px 2px ink-2, 0 4px 10px -2px ink-2', () {
        expectLayer(ElShadows.e2.layers[0], 0, 1, 2, 0);
        expectLayer(ElShadows.e2.layers[1], 0, 4, 10, -2);
        expect(
          ElShadows.e2.layers.every(
            (l) => l.color(ElThemeData.light) == ElThemeData.light.ink2,
          ),
          isTrue,
        );
      });

      test('e3: 0 2px 4px ink-2, 0 14px 28px -8px ink-3', () {
        expectLayer(ElShadows.e3.layers[0], 0, 2, 4, 0);
        expectLayer(ElShadows.e3.layers[1], 0, 14, 28, -8);
        expect(
          ElShadows.e3.layers[0].color(ElThemeData.dark),
          ElThemeData.dark.ink2,
        );
        expect(
          ElShadows.e3.layers[1].color(ElThemeData.dark),
          ElThemeData.dark.ink3,
        );
        expect(ElShadows.e3.hasInset, isFalse);
      });

      test('e4: 0 4px 8px ink-3, 0 28px 56px -14px ink-4', () {
        expectLayer(ElShadows.e4.layers[0], 0, 4, 8, 0);
        expectLayer(ElShadows.e4.layers[1], 0, 28, 56, -14);
        expect(
          ElShadows.e4.layers[0].color(ElThemeData.light),
          ElThemeData.light.ink3,
        );
        expect(
          ElShadows.e4.layers[1].color(ElThemeData.light),
          ElThemeData.light.ink4,
        );
      });

      test('key / key-down: the wall layer and its socket', () {
        expectLayer(ElShadows.key.layers[0], 0, 4, 0, 0);
        expect(
          ElShadows.key.layers[0].color(ElThemeData.dark),
          ElThemeData.dark.wall,
        );
        expectLayer(ElShadows.key.layers[1], 0, 7, 12, 0);
        expect(ElShadows.key.hasInset, isFalse);

        expectLayer(ElShadows.keyDown.layers[0], 0, 1, 0, 0);
        expectLayer(ElShadows.keyDown.layers[1], 0, 2, 5, 0, inset: true);
        expect(ElShadows.keyDown.hasInset, isTrue);
      });

      test('pressed: both layers inset', () {
        expectLayer(ElShadows.pressed.layers[0], 0, 2, 5, 0, inset: true);
        expectLayer(ElShadows.pressed.layers[1], 0, 1, 2, 0, inset: true);
        expect(ElShadows.pressed.hasInset, isTrue);
        expect(ElShadows.pressed.outerShadows(ElThemeData.dark), isEmpty);
      });

      test('btn: rim highlight + inner bottom shade + two outer layers', () {
        expect(ElShadows.btn.layers, hasLength(4));
        expectLayer(ElShadows.btn.layers[0], 0, 1, 0, 0, inset: true);
        expect(
          ElShadows.btn.layers[0].color(ElThemeData.dark),
          ElThemeData.dark.rim,
        );
        expectLayer(ElShadows.btn.layers[1], 0, -2, 4, 0, inset: true);
        expectLayer(ElShadows.btn.layers[2], 0, 1, 2, 0);
        expectLayer(ElShadows.btn.layers[3], 0, 3, 8, -2);
        expect(ElShadows.btn.hasInset, isTrue);
        expect(ElShadows.btn.insetLayers, hasLength(2));
        expect(ElShadows.btn.outerShadows(ElThemeData.dark), hasLength(2));
      });

      test('btn-primary: rim-strong + action cast at 55%', () {
        expectLayer(ElShadows.btnPrimary.layers[0], 0, 1, 0, 0, inset: true);
        expect(
          ElShadows.btnPrimary.layers[0].color(ElThemeData.light),
          ElThemeData.light.rimStrong,
        );
        expectLayer(ElShadows.btnPrimary.layers[1], 0, -2, 5, 0, inset: true);
        expectLayer(ElShadows.btnPrimary.layers[2], 0, 1, 2, 0);
        expectLayer(ElShadows.btnPrimary.layers[3], 0, 4, 10, -2);
        expect(
          ElShadows.btnPrimary.layers[3].color(ElThemeData.dark),
          ElPalette.action.withValues(alpha: 0.55),
        );
      });

      test('btn-value: ink-1 inner shade + value cast at 45%', () {
        expectLayer(ElShadows.btnValue.layers[1], 0, -2, 5, 0, inset: true);
        expect(
          ElShadows.btnValue.layers[1].color(ElThemeData.dark),
          ElThemeData.dark.ink1,
        );
        expect(
          ElShadows.btnValue.layers[3].color(ElThemeData.dark),
          ElPalette.value.withValues(alpha: 0.45),
        );
      });

      test('btn-down / chip', () {
        expectLayer(ElShadows.btnDown.layers[0], 0, 2, 4, 0, inset: true);
        expectLayer(ElShadows.btnDown.layers[1], 0, 1, 1, 0);
        expectLayer(ElShadows.chip.layers[0], 0, 1, 0, 0, inset: true);
        expectLayer(ElShadows.chip.layers[1], 0, -1, 2, 0, inset: true);
        expectLayer(ElShadows.chip.layers[2], 0, 1, 2, 0);
      });

      test(
        'glow-action: 0 0 0 1px action-bright@45% + 0 10 34 -8 action@60%',
        () {
          expectLayer(ElShadows.glowAction.layers[0], 0, 0, 0, 1);
          expect(
            ElShadows.glowAction.layers[0].color(ElThemeData.dark),
            ElPalette.actionBright.withValues(alpha: 0.45),
          );
          expectLayer(ElShadows.glowAction.layers[1], 0, 10, 34, -8);
          expect(
            ElShadows.glowAction.layers[1].color(ElThemeData.dark),
            ElPalette.action.withValues(alpha: 0.60),
          );
          expect(ElShadows.glowAction.hasInset, isFalse);
        },
      );

      test('glow-value: 0 0 0 1px value@45% + 0 10 34 -8 value@42%', () {
        expectLayer(ElShadows.glowValue.layers[0], 0, 0, 0, 1);
        expect(
          ElShadows.glowValue.layers[0].color(ElThemeData.light),
          ElPalette.value.withValues(alpha: 0.45),
        );
        expectLayer(ElShadows.glowValue.layers[1], 0, 10, 34, -8);
        expect(
          ElShadows.glowValue.layers[1].color(ElThemeData.light),
          ElPalette.value.withValues(alpha: 0.42),
        );
      });

      test('ink flips with the theme — same geometry, different colour', () {
        final BoxShadow darkTop = ElShadows.e3
            .outerShadows(ElThemeData.dark)
            .last;
        final BoxShadow lightTop = ElShadows.e3
            .outerShadows(ElThemeData.light)
            .last;
        expect(darkTop.offset, lightTop.offset);
        expect(darkTop.blurRadius, lightTop.blurRadius);
        expect(darkTop.color, isNot(lightTop.color));
        expect(darkTop.color, ElThemeData.dark.ink2);
        expect(lightTop.color, ElThemeData.light.ink2);
      });

      test('CSS blur maps to the CSS Gaussian sigma, not Flutter default', () {
        // CSS: sigma = blur / 2. Flutter: sigma = radius * 0.57735 + 0.5.
        const ElShadowLayer layer = ElShadowLayer(0, 28, 56, -14, _dummyInk);
        expect(layer.blurRadius * 0.57735 + 0.5, closeTo(28.0, 0.001));
        // Known limit: sigmas below 0.5 are unreachable, so a 1px CSS blur
        // collapses to a hard edge.
        const ElShadowLayer hairline = ElShadowLayer(0, 1, 1, 0, _dummyInk);
        expect(hairline.blurRadius, 0);
        const ElShadowLayer none = ElShadowLayer(0, 0, 0, 1, _dummyInk);
        expect(none.blurRadius, 0);
      });

      test(
        'outerShadows reverses CSS order so the first layer paints on top',
        () {
          final List<BoxShadow> shadows = ElShadows.e4.outerShadows(
            ElThemeData.dark,
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

Color _dummyInk(ElThemeData t) => t.ink2;
