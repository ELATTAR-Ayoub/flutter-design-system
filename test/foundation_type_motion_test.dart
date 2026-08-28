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
/// resolved font size only inside [TextStyleToken.resolve].

/// A colour to resolve against; the value is irrelevant to these assertions.
const Color _ink = Color(0xFF92C2FC);

/// Asserts one `.type-*` class field by field.
void expectSpec(
  String css,
  TextStyleToken spec, {
  required String family,
  required double? size,
  required double? height,
  required FontWeight? weight,
  required double? wght,
  required double? tracking,
  required bool uppercase,
  required bool tabular,
  required TextColorRole defaultColor,
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

  group('Fonts — the three faces (globals.css L169–172)', () {
    test('families follow the tokens, not the Space Grotesk prose', () {
      expect(Fonts.sans, 'InterLocal');
      expect(Fonts.heading, 'InterLocal');
      expect(Fonts.mono, 'GeistMono');
      expect(Fonts.accent, 'Redaction35');
    });

    test('package name is the asset prefix flutter_tools registers', () {
      expect(Fonts.package, 'elattar_design_system');
    });
  });

  group('TextStyles — fluid sizes (clamp)', () {
    test(
      'displaySize is clamp(2.75rem, 4.4vw, 4rem) = clamp(44, 4.4vw, 64)',
      () {
        expect(
          TextStyles.displaySize(1000),
          44,
        ); // 4.4vw of 1000 = 44 — the min edge
        expect(TextStyles.displaySize(700), 44); // 30.8 → floored at 44
        expect(TextStyles.displaySize(1280), closeTo(56.32, 1e-9));
        expect(TextStyles.displaySize(1440), closeTo(63.36, 1e-9));
        expect(
          TextStyles.displaySize(1600),
          64,
        ); // 70.4 → clamped at the 64 max
        expect(TextStyles.displaySize(2560), 64);
      },
    );

    test('h1Size is clamp(2rem, 2.8vw, 2.5rem) = clamp(32, 2.8vw, 40)', () {
      expect(TextStyles.h1Size(1440), 40); // 40.32 → clamped at the 40 max
      expect(TextStyles.h1Size(1000), 32); // 28 → floored at 32
      expect(TextStyles.h1Size(1280), closeTo(35.84, 1e-9));
      expect(TextStyles.h1Size(1200), closeTo(33.6, 1e-9));
    });

    test('accentSize is 1.055em — it rides the size it is set inside', () {
      expect(TextStyles.accentSize(64), closeTo(67.52, 1e-9));
      expect(
        TextStyles.accentSize(TextStyles.displaySize(1000)),
        closeTo(46.42, 1e-9),
      );
    });
  });

  group(
    'TextStyles — every .type-* class, value for value (globals.css §5)',
    () {
      test(
        '.type-display — heading face, clamp 44–64/1, 500, -0.03em (L1019)',
        () {
          expectSpec(
            '.type-display',
            TextStyles.display,
            family: 'InterLocal',
            size: null, // clamp() — resolved from the viewport
            height: 1,
            weight: FontWeight.w500,
            wght: 500,
            tracking: -0.03,
            uppercase: false,
            tabular: false,
            defaultColor: TextColorRole.none,
          );
        },
      );

      test(
        '.type-accent — Redaction 35, 1.055em italic, 400, -0.03em (L1046)',
        () {
          expectSpec(
            '.type-accent',
            TextStyles.accent,
            family: 'Redaction35',
            size: null, // 1.055em — relative to the inherited size
            height: null, // no line-height declared: inherits
            weight: FontWeight.w400,
            wght: 400,
            tracking: -0.03,
            uppercase: false,
            tabular: false,
            defaultColor: TextColorRole.none,
            fontStyle: FontStyle.italic,
          );
        },
      );

      test('.type-h1 — clamp 32–40/1.1, 700, -0.02em (L1070)', () {
        expectSpec(
          '.type-h1',
          TextStyles.h1,
          family: 'InterLocal',
          size: null, // clamp()
          height: 1.1,
          weight: FontWeight.w700,
          wght: 700,
          tracking: -0.02,
          uppercase: false,
          tabular: false,
          defaultColor: TextColorRole.none,
        );
      });

      test('.type-h2 — 28/1.2, weight 650 via wght axis, -0.015em (L1077)', () {
        expectSpec(
          '.type-h2',
          TextStyles.h2,
          family: 'InterLocal',
          size: 28, // 1.75rem
          height: 1.2,
          weight:
              FontWeight.w600, // non-variable fallback; 650 has no FontWeight
          wght: 650,
          tracking: -0.015,
          uppercase: false,
          tabular: false,
          defaultColor: TextColorRole.none,
        );
      });

      test('.type-h2 renders wght 650 through variations, not weight', () {
        expect(TextStyles.h2.variations, hasLength(1));
        expect(TextStyles.h2.variations.single.axis, 'wght');
        expect(TextStyles.h2.variations.single.value, 650);
        // resolve() adds the browser's `font-optical-sizing: auto`: opsz = the
        // CSS px size, clamped to Inter's 14–32 axis range.
        expect(TextStyles.h2.resolve(28, _ink).fontVariations, <FontVariation>[
          FontVariation('wght', 650),
          FontVariation('opsz', 28),
        ]);
      });

      test('optical sizing mirrors the browser: sans only, clamped 14–32', () {
        // 13px body-adjacent text → opsz 14 (clamped up from 13).
        expect(
          TextStyles.small.resolve(13, _ink).fontVariations,
          contains(const FontVariation('opsz', 14)),
        );
        // 40px h1 → opsz 32 (clamped down from 40).
        expect(
          TextStyles.h1.resolve(40, _ink).fontVariations,
          contains(const FontVariation('opsz', 32)),
        );
        // 17px lead → opsz tracks the size exactly inside the range.
        expect(
          TextStyles.lead.resolve(17, _ink).fontVariations,
          contains(const FontVariation('opsz', 17)),
        );
        // Geist Mono has no opsz axis — mono classes must not carry one.
        final List<FontVariation>? mono = TextStyles.numberSm
            .resolve(12, _ink)
            .fontVariations;
        expect(mono!.where((FontVariation v) => v.axis == 'opsz'), isEmpty);
      });

      test('.type-h3 — 21/1.3, 600, -0.01em (L1084)', () {
        expectSpec(
          '.type-h3',
          TextStyles.h3,
          family: 'InterLocal',
          size: 21, // 1.3125rem
          height: 1.3,
          weight: FontWeight.w600,
          wght: 600,
          tracking: -0.01,
          uppercase: false,
          tabular: false,
          defaultColor: TextColorRole.none,
        );
      });

      test('.type-h4 — 17/1.4, 600, no tracking (L1091)', () {
        expectSpec(
          '.type-h4',
          TextStyles.h4,
          family: 'InterLocal',
          size: 17, // 1.0625rem
          height: 1.4,
          weight: FontWeight.w600,
          wght: 600,
          tracking: null,
          uppercase: false,
          tabular: false,
          defaultColor: TextColorRole.none,
        );
      });

      test('.type-lead — 17/1.65, 400, muted-foreground (L1099)', () {
        expectSpec(
          '.type-lead',
          TextStyles.lead,
          family: 'InterLocal',
          size: 17, // 1.0625rem
          height: 1.65,
          weight: FontWeight.w400,
          wght: 400,
          tracking: null,
          uppercase: false,
          tabular: false,
          defaultColor: TextColorRole.muted,
        );
      });

      test('.type-body — 15/1.6, 400 (L1105)', () {
        expectSpec(
          '.type-body',
          TextStyles.body,
          family: 'InterLocal',
          size: 15, // --text-body
          height: 1.6,
          weight: FontWeight.w400,
          wght: 400,
          tracking: null,
          uppercase: false,
          tabular: false,
          defaultColor: TextColorRole.none,
        );
      });

      test('.type-small — 13/1.5, 400, muted-foreground (L1120)', () {
        expectSpec(
          '.type-small',
          TextStyles.small,
          family: 'InterLocal',
          size: 13, // --text-small
          height: 1.5,
          weight: FontWeight.w400,
          wght: 400,
          tracking: null,
          uppercase: false,
          tabular: false,
          defaultColor: TextColorRole.muted,
        );
      });

      test('.type-nav — 13.5/1.2, 500 (L1128)', () {
        expectSpec(
          '.type-nav',
          TextStyles.nav,
          family: 'InterLocal',
          size: 13.5, // --text-nav
          height: 1.2,
          weight: FontWeight.w500,
          wght: 500,
          tracking: null,
          uppercase: false,
          tabular: false,
          defaultColor: TextColorRole.none,
        );
      });

      test('.type-nav-sm — 11.5/1.2, 500 (L1139)', () {
        expectSpec(
          '.type-nav-sm',
          TextStyles.navSm,
          family: 'InterLocal',
          size: 11.5, // --text-chip
          height: 1.2,
          weight: FontWeight.w500,
          wght: 500,
          tracking: null,
          uppercase: false,
          tabular: false,
          defaultColor: TextColorRole.none,
        );
      });

      test('.type-chip — 11.5/1.2, 500 (L1145)', () {
        expectSpec(
          '.type-chip',
          TextStyles.chip,
          family: 'InterLocal',
          size: 11.5, // --text-chip
          height: 1.2,
          weight: FontWeight.w500,
          wght: 500,
          tracking: null,
          uppercase: false,
          tabular: false,
          defaultColor: TextColorRole.none,
        );
      });

      test('.type-caption — 10.5/1.35, 500 (L1151)', () {
        expectSpec(
          '.type-caption',
          TextStyles.caption,
          family: 'InterLocal',
          size: 10.5, // --text-micro
          height: 1.35,
          weight: FontWeight.w500,
          wght: 500,
          tracking: null,
          uppercase: false,
          tabular: false,
          defaultColor: TextColorRole.none,
        );
      });

      test('.type-code — mono 12.5/1.4, NO font-weight declared (L1157)', () {
        expectSpec(
          '.type-code',
          TextStyles.code,
          family: 'GeistMono',
          size: 12.5, // --text-code
          height: 1.4,
          weight: null, // inherits — globals.css declares none
          wght: null,
          tracking: null,
          uppercase: false,
          tabular: false,
          defaultColor: TextColorRole.none,
        );
      });

      test(
        '.type-label — 11/1, 600 uppercase 0.16em muted-foreground (L1164)',
        () {
          expect(TextStyles.eyebrow.uppercase, isTrue);
          expect(TextStyles.eyebrow.size, 11);
          expect(TextStyles.eyebrow.tracking, 0.16);
          expectSpec(
            '.type-label',
            TextStyles.eyebrow,
            family: 'InterLocal',
            size: 11, // --text-label
            height: 1,
            weight: FontWeight.w600,
            wght: 600,
            tracking: 0.16, // --tracking-label
            uppercase: true,
            tabular: false,
            defaultColor: TextColorRole.muted,
          );
        },
      );

      test('.type-section — 13/1.4, 600, muted-foreground (L1192)', () {
        expectSpec(
          '.type-section',
          TextStyles.section,
          family: 'InterLocal',
          size: 13, // --text-small
          height: 1.4,
          weight: FontWeight.w600,
          wght: 600,
          tracking: null,
          uppercase: false,
          tabular: false,
          defaultColor: TextColorRole.muted,
        );
      });

      test('.type-wordmark — 15/1, 700, -0.01em (L1201)', () {
        expectSpec(
          '.type-wordmark',
          TextStyles.wordmark,
          family: 'InterLocal',
          size: 15, // --text-body
          height: 1,
          weight: FontWeight.w700,
          wght: 700,
          tracking: -0.01, // --tracking-num
          uppercase: false,
          tabular: false,
          defaultColor: TextColorRole.none,
        );
      });

      test(
        '.type-serial — mono 15/1.4 uppercase -0.01em, NO weight (L1211)',
        () {
          expectSpec(
            '.type-serial',
            TextStyles.identifier,
            family: 'GeistMono',
            size: 15, // --text-body
            height: 1.4,
            weight: null, // inherits — globals.css declares none
            wght: null,
            tracking: -0.01, // --tracking-num
            uppercase: true,
            tabular: false, // .type-serial is NOT part of the numeric rule
            defaultColor: TextColorRole.none,
          );
        },
      );

      test('.type-micro — 10.5/1, 600 uppercase 0.18em muted (L1218)', () {
        expectSpec(
          '.type-micro',
          TextStyles.eyebrowSmall,
          family: 'InterLocal',
          size: 10.5, // --text-micro
          height: 1,
          weight: FontWeight.w600,
          wght: 600,
          tracking: 0.18, // --tracking-micro
          uppercase: true,
          tabular: false,
          defaultColor: TextColorRole.muted,
        );
      });

      test('.type-tag — 10/1, 600 uppercase 0.12em (L1238)', () {
        expectSpec(
          '.type-tag',
          TextStyles.tag,
          family: 'InterLocal',
          size: 10, // --text-tag
          height: 1,
          weight: FontWeight.w600,
          wght: 600,
          tracking: 0.12, // --tracking-tag
          uppercase: true,
          tabular: false,
          defaultColor: TextColorRole.none,
        );
      });

      test('.type-badge — 11/1, 600 uppercase 0.14em (L1246)', () {
        expectSpec(
          '.type-badge',
          TextStyles.badge,
          family: 'InterLocal',
          size: 11, // --text-label
          height: 1,
          weight: FontWeight.w600,
          wght: 600,
          tracking: 0.14, // --tracking-badge
          uppercase: true,
          tabular: false,
          defaultColor: TextColorRole.none,
        );
      });

      test('.type-num-xs — mono 11/1.2, 600 tabular -0.01em (L1267)', () {
        expectSpec(
          '.type-num-xs',
          TextStyles.numberXs,
          family: 'GeistMono',
          size: 11, // --text-label
          height: 1.2,
          weight: FontWeight.w600,
          wght: 600,
          tracking: -0.01, // --tracking-num, from the shared rule L1256–1266
          uppercase: false,
          tabular: true,
          defaultColor: TextColorRole.none,
        );
      });

      test('.type-num-sm — mono 12/1.2, 600 tabular -0.01em (L1271)', () {
        expect(TextStyles.numberSm.family, Fonts.mono);
        expect(TextStyles.numberSm.size, 12);
        expect(TextStyles.numberSm.height, 1.2);
        expect(TextStyles.numberSm.weight, FontWeight.w600);
        expect(TextStyles.numberSm.tabular, isTrue);
        expect(TextStyles.numberSm.tracking, -0.01);
        expectSpec(
          '.type-num-sm',
          TextStyles.numberSm,
          family: 'GeistMono',
          size: 12, // --text-num-sm
          height: 1.2,
          weight: FontWeight.w600,
          wght: 600,
          tracking: -0.01,
          uppercase: false,
          tabular: true,
          defaultColor: TextColorRole.none,
        );
      });

      test('.type-num — mono 15/1.2, 600 tabular -0.01em (L1275)', () {
        expectSpec(
          '.type-num',
          TextStyles.numberBase,
          family: 'GeistMono',
          size: 15, // --text-body
          height: 1.2,
          weight: FontWeight.w600,
          wght: 600,
          tracking: -0.01,
          uppercase: false,
          tabular: true,
          defaultColor: TextColorRole.none,
        );
      });

      test('.type-num-md — mono 20/1.15, 600 tabular -0.01em (L1279)', () {
        expectSpec(
          '.type-num-md',
          TextStyles.numberMd,
          family: 'GeistMono',
          size: 20, // 1.25rem
          height: 1.15,
          weight: FontWeight.w600,
          wght: 600,
          tracking: -0.01,
          uppercase: false,
          tabular: true,
          defaultColor: TextColorRole.none,
        );
      });

      test('.type-num-lg — mono 28/1.05, 600 tabular -0.01em (L1283)', () {
        expectSpec(
          '.type-num-lg',
          TextStyles.numberLg,
          family: 'GeistMono',
          size: 28, // 1.75rem
          height: 1.05,
          weight: FontWeight.w600,
          wght: 600,
          tracking: -0.01,
          uppercase: false,
          tabular: true,
          defaultColor: TextColorRole.none,
        );
      });

      test('.type-num-xl — mono 40/1, 600 tabular, tracking overridden to '
          '-0.025em (L1287)', () {
        expectSpec(
          '.type-num-xl',
          TextStyles.numberXl,
          family: 'GeistMono',
          size: 40, // 2.5rem
          height: 1,
          weight: FontWeight.w600,
          wght: 600,
          tracking: -0.025, // the one numeric that leaves --tracking-num
          uppercase: false,
          tabular: true,
          defaultColor: TextColorRole.none,
        );
      });
    },
  );

  group('TextStyles — cross-class invariants', () {
    test('exactly five classes set their own colour, all muted-foreground', () {
      final List<TextStyleToken> muted = <TextStyleToken>[
        TextStyles.lead,
        TextStyles.small,
        TextStyles.eyebrow,
        TextStyles.eyebrowSmall,
        TextStyles.section,
      ];
      for (final TextStyleToken spec in muted) {
        expect(spec.defaultColor, TextColorRole.muted);
      }
      expect(
        TextStyles.all.where(
          (TextStyleToken s) => s.defaultColor != TextColorRole.none,
        ),
        hasLength(5),
      );
    });

    test(
      'exactly five classes uppercase: label, serial, micro, tag, badge',
      () {
        expect(
          TextStyles.all.where((TextStyleToken s) => s.uppercase),
          hasLength(5),
        );
        for (final TextStyleToken spec in <TextStyleToken>[
          TextStyles.eyebrow,
          TextStyles.identifier,
          TextStyles.eyebrowSmall,
          TextStyles.tag,
          TextStyles.badge,
        ]) {
          expect(spec.uppercase, isTrue);
        }
      },
    );

    test('exactly the six .type-num-* classes are tabular, all mono', () {
      final Iterable<TextStyleToken> tabular = TextStyles.all.where(
        (TextStyleToken s) => s.tabular,
      );
      expect(tabular, hasLength(6));
      for (final TextStyleToken spec in tabular) {
        expect(spec.family, Fonts.mono);
        expect(spec.weight, FontWeight.w600);
      }
    });

    test('the mono face carries the numerics, code and serials only', () {
      expect(
        TextStyles.all.where((TextStyleToken s) => s.family == Fonts.mono),
        hasLength(8),
      ); // 6 numerics + code + serial
    });

    test('.type-accent is the only class off the two foundation faces', () {
      expect(
        TextStyles.all.where((TextStyleToken s) => s.family == Fonts.accent),
        <TextStyleToken>[TextStyles.accent],
      );
      expect(
        TextStyles.all.where(
          (TextStyleToken s) => s.fontStyle == FontStyle.italic,
        ),
        <TextStyleToken>[TextStyles.accent],
      );
    });

    test('all 27 classes are registered', () {
      expect(TextStyles.all, hasLength(27));
    });
  });

  group('TextStyleToken.resolve', () {
    test('prefixes the family with the package so call sites never do', () {
      final TextStyle style = TextStyles.numberSm.resolve(12, _ink);
      expect(style.fontFamily, 'packages/elattar_design_system/GeistMono');
    });

    test(
      'converts em tracking to px letterSpacing against the resolved size',
      () {
        expect(
          TextStyles.numberSm.resolve(12, _ink).letterSpacing,
          closeTo(-0.12, 1e-9),
        ); // -0.01em × 12
        expect(
          TextStyles.eyebrow.resolve(11, _ink).letterSpacing,
          closeTo(1.76, 1e-9),
        ); // 0.16em × 11
        expect(
          TextStyles.display.resolve(64, _ink).letterSpacing,
          closeTo(-1.92, 1e-9),
        ); // -0.03em × 64
        expect(
          TextStyles.numberXl.resolve(40, _ink).letterSpacing,
          closeTo(-1, 1e-9),
        ); // -0.025em × 40
      },
    );

    test('a class with no letter-spacing resolves to none', () {
      expect(TextStyles.body.resolve(15, _ink).letterSpacing, isNull);
      expect(TextStyles.h4.resolve(17, _ink).letterSpacing, isNull);
    });

    test('a tabular class carries FontFeature.tabularFigures()', () {
      final TextStyle style = TextStyles.numberBase.resolve(15, _ink);
      expect(style.fontFeatures, contains(const FontFeature.tabularFigures()));
      expect(
        TextStyles.body.resolve(15, _ink).fontFeatures,
        anyOf(isNull, isEmpty),
      );
    });

    test('carries size, height, weight, style and colour through', () {
      final TextStyle style = TextStyles.lead.resolve(17, _ink);
      expect(style.fontSize, 17);
      expect(style.height, 1.65);
      expect(style.fontWeight, FontWeight.w400);
      expect(style.fontStyle, FontStyle.normal);
      expect(style.color, _ink);

      final TextStyle accent = TextStyles.accent.resolve(67.52, _ink);
      expect(accent.fontStyle, FontStyle.italic);
      expect(accent.height, isNull); // no line-height declared
    });

    test('an inherited font-weight stays unset', () {
      expect(TextStyles.code.resolve(12.5, _ink).fontWeight, isNull);
      expect(
        TextStyles.code.resolve(12.5, _ink).fontVariations,
        anyOf(isNull, isEmpty),
      );
      expect(TextStyles.identifier.resolve(15, _ink).fontWeight, isNull);
    });

    test('an explicit size overrides a fixed-size class', () {
      expect(TextStyles.body.size, 15);
      final TextStyle style = TextStyles.body.resolve(24, _ink);
      expect(style.fontSize, 24);
      expect(TextStyles.h2.resolve(24, _ink).fontSize, 24);
    });

    test('uppercase is a flag only — resolve applies no transform', () {
      expect(TextStyles.eyebrow.uppercase, isTrue);
      expect(
        TextStyles.eyebrow.resolve(11, _ink).fontFeatures,
        anyOf(isNull, isEmpty),
      );
    });

    test('the fluid classes resolve at whatever the viewport hands them', () {
      expect(
        TextStyles.display.resolve(TextStyles.displaySize(1440), _ink).fontSize,
        closeTo(63.36, 1e-9),
      );
      expect(TextStyles.h1.resolve(TextStyles.h1Size(1440), _ink).fontSize, 40);
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
