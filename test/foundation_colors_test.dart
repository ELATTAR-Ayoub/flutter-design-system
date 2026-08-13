import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

// The barrel is owned by the lead and rewired at integration; until then the
// implementation files are imported directly.
import 'package:elattar_design_system/elattar_design_system.dart';

/// A value-for-value transcript of `app/globals.css` in the reference repo.
///
/// Every expectation below names the CSS declaration it mirrors, so a token
/// that drifts fails here with the line that owns the truth.
/// Source: `D:/DESIGN/Design-System-2026-8/design-system/app/globals.css`.
void main() {
  // ── dsHsl — CSS hsl() rasterisation ────────────────────────────────────────
  group('dsHsl', () {
    // globals.css L99–105: the ramp was annotated #93C5FD / #2563EB / #1D4ED8
    // for three brands and never rasterised to those. The hsl() values are
    // authoritative; these three hexes are what they actually paint.
    test('--color-action-bright: hsl(213 94% 78%) rasterises #92C2FC', () {
      expect(dsHsl(213, 94, 78), const Color(0xFF92C2FC));
    });

    test('--color-action: hsl(217 91% 53%) rasterises #1A6EF4', () {
      expect(dsHsl(217, 91, 53), const Color(0xFF1A6EF4));
    });

    test('--color-action-dark: hsl(224 76% 33%) rasterises #143694', () {
      expect(dsHsl(224, 76, 33), const Color(0xFF143694));
    });

    test('achromatic and boundary hues', () {
      expect(dsHsl(0, 0, 100), const Color(0xFFFFFFFF));
      expect(dsHsl(0, 0, 0), const Color(0xFF000000));
      // hsl(0 72.2% 50.6%) — --destructive, both themes (L596 / L805).
      expect(dsHsl(0, 72.2, 50.6), const Color(0xFFDC2626));
    });

    test('alpha is straight, never pre-composited', () {
      // --ink-2: hsl(240 20% 20% / 0.07) — globals.css L611.
      final Color ink2 = dsHsl(240, 20, 20, 0.07);
      expect(ink2.a, 0.07);
      expect(ink2.r, dsHsl(240, 20, 20).r);
      expect(ink2.g, dsHsl(240, 20, 20).g);
      expect(ink2.b, dsHsl(240, 20, 20).b);
    });

    test('dsTransparent is a fully transparent black', () {
      expect(dsTransparent, const Color(0x00000000));
      expect(dsTransparent.a, 0);
    });
  });

  // ── DsPalette — @theme static ramps + state (globals.css L71–433) ──────────
  group('DsPalette', () {
    test('brand ramps (L103–109)', () {
      expect(DsPalette.actionBright, dsHsl(213, 94, 78));
      expect(DsPalette.action, dsHsl(217, 91, 53));
      expect(DsPalette.actionDark, dsHsl(224, 76, 33));
      expect(DsPalette.valueBright, const Color(0xFFD9F99D));
      expect(DsPalette.value, const Color(0xFFA3E635));
      expect(DsPalette.valueDark, const Color(0xFF4D7C0F));
    });

    test('--color-value-foreground does not flip with the theme (L127)', () {
      expect(DsPalette.valueForeground, dsHsl(240, 10, 8));
    });

    test('state hues (L148–150)', () {
      expect(DsPalette.success, const Color(0xFF10B981));
      expect(DsPalette.warning, const Color(0xFFFBBF24));
      expect(DsPalette.info, const Color(0xFF22D3EE));
    });

    test('deep state hues (L158–165)', () {
      expect(DsPalette.successDeep, const Color(0xFF047857));
      expect(DsPalette.warningDeep, const Color(0xFFB45309));
      expect(DsPalette.infoDeep, const Color(0xFF0E7490));
      expect(DsPalette.destructiveLifted, const Color(0xFFF87171));
      expect(DsPalette.destructiveDeep, dsHsl(0, 72.2, 46));
    });
  });

  // ── DsThemeData.dark — `.dark` block, globals.css L741–942 ────────────────
  group('DsThemeData.dark', () {
    final DsThemeData t = DsThemeData.dark;

    test('kind', () => expect(t.kind, DsThemeKind.dark));

    test('monochrome (L746–762)', () {
      expect(t.background, dsHsl(240, 10, 3.9));
      expect(t.foreground, dsHsl(0, 0, 98));
      expect(t.card, dsHsl(240, 5.9, 10));
      expect(t.cardForeground, dsHsl(0, 0, 98));
      expect(t.popover, dsHsl(240, 5.9, 10));
      expect(t.popoverForeground, dsHsl(0, 0, 98));
      expect(t.secondary, dsHsl(240, 3.7, 15.9));
      expect(t.secondaryForeground, dsHsl(0, 0, 98));
      expect(t.muted, dsHsl(240, 3.7, 15.9));
      expect(t.mutedForeground, dsHsl(240, 4.9, 83.9));
      expect(t.accent, dsHsl(240, 5.3, 26.1));
      expect(t.accentForeground, dsHsl(0, 0, 98));
      expect(t.border, dsHsl(240, 3.7, 15.9));
      expect(t.input, dsHsl(240, 5.3, 26.1));
    });

    test('--page-glow (L769)', () => expect(t.pageGlow, dsHsl(240, 8, 10)));

    test('brand (L772–780)', () {
      expect(t.primary, DsPalette.action);
      expect(t.primaryForeground, dsHsl(0, 0, 100));
      expect(t.ring, DsPalette.actionBright);
    });

    test('ink pointers pick the lifted end (L784–802)', () {
      expect(t.actionInk, DsPalette.actionBright);
      // Documented drift: `-bright`, not the mid the §1.3 table asks for.
      expect(t.valueInk, DsPalette.valueBright);
      expect(t.successInk, DsPalette.success);
      expect(t.warningInk, DsPalette.warning);
      expect(t.infoInk, DsPalette.info);
      expect(t.destructiveInk, DsPalette.destructiveLifted);
    });

    test('destructive (L805–806)', () {
      expect(t.destructive, dsHsl(0, 72.2, 50.6));
      expect(t.destructiveForeground, dsHsl(0, 0, 98));
    });

    test('shadow ink is black and heavy (L820–826)', () {
      expect(t.ink1, const Color.from(alpha: 0.35, red: 0, green: 0, blue: 0));
      expect(t.ink2, const Color.from(alpha: 0.5, red: 0, green: 0, blue: 0));
      expect(t.ink3, const Color.from(alpha: 0.6, red: 0, green: 0, blue: 0));
      expect(t.ink4, const Color.from(alpha: 0.75, red: 0, green: 0, blue: 0));
      expect(t.rim, const Color.from(alpha: 0.14, red: 1, green: 1, blue: 1));
      expect(
        t.rimStrong,
        const Color.from(alpha: 0.28, red: 1, green: 1, blue: 1),
      );
      expect(t.wall, dsHsl(240, 6, 8));
    });

    test('charts name the legible end of each ramp (L842–846)', () {
      expect(t.chart1, DsPalette.actionBright);
      expect(t.chart2, DsPalette.value);
      expect(t.chart3, DsPalette.info);
      expect(t.chart4, DsPalette.valueBright);
      expect(t.chart5, DsPalette.success);
    });

    test('sidebar aliases, declared verbatim (L862–869)', () {
      expect(t.sidebar, t.card);
      expect(t.sidebarForeground, t.mutedForeground);
      expect(t.sidebarPrimary, t.primary);
      expect(t.sidebarPrimaryForeground, t.primaryForeground);
      expect(t.sidebarAccent, t.accent);
      expect(t.sidebarAccentForeground, t.accentForeground);
      expect(t.sidebarBorder, t.border);
      expect(t.sidebarRing, t.ring);
    });

    test('agent + scrim (L881, L903, L906)', () {
      expect(t.agent, DsPalette.actionBright);
      expect(t.agentMuted, dsHsl(217, 40, 13));
      expect(t.scrim, dsHsl(240, 10, 3.9, 0.66));
    });

    test('--radius (L814)', () => expect(t.radius, DsRadii.md));
  });

  // ── DsThemeData.light — `:root, .light` block, globals.css L546–735 ────────
  group('DsThemeData.light', () {
    final DsThemeData t = DsThemeData.light;

    test('kind', () => expect(t.kind, DsThemeKind.light));

    test('monochrome (L549–574)', () {
      expect(t.background, dsHsl(0, 0, 100));
      expect(t.foreground, dsHsl(240, 10, 3.9));
      expect(t.card, dsHsl(0, 0, 100));
      expect(t.cardForeground, dsHsl(240, 10, 3.9));
      expect(t.popover, dsHsl(0, 0, 100));
      expect(t.popoverForeground, dsHsl(240, 10, 3.9));
      expect(t.secondary, dsHsl(240, 4.8, 95.9));
      expect(t.secondaryForeground, dsHsl(240, 5.9, 10));
      expect(t.muted, dsHsl(240, 4.8, 95.9));
      expect(t.accent, dsHsl(240, 4.8, 95.9));
      expect(t.accentForeground, dsHsl(240, 5.9, 10));
      expect(t.border, dsHsl(240, 5.9, 90));
      expect(t.input, dsHsl(240, 5.9, 90));
    });

    test('--muted-foreground is the deeper step, not zinc 500 (L569)', () {
      expect(t.mutedForeground, dsHsl(240, 4, 40));
    });

    test('--page-glow (L579)', () => expect(t.pageGlow, dsHsl(240, 30, 98)));

    test('brand (L582–584)', () {
      expect(t.primary, DsPalette.action);
      expect(t.primaryForeground, dsHsl(0, 0, 100));
      expect(t.ring, DsPalette.action);
    });

    test('ink pointers pick the deep end (L589–594)', () {
      expect(t.actionInk, DsPalette.actionDark);
      expect(t.valueInk, DsPalette.valueDark);
      expect(t.successInk, DsPalette.successDeep);
      expect(t.warningInk, DsPalette.warningDeep);
      expect(t.infoInk, DsPalette.infoDeep);
      expect(t.destructiveInk, DsPalette.destructiveDeep);
    });

    test('destructive (L596–597)', () {
      expect(t.destructive, dsHsl(0, 72.2, 50.6));
      expect(t.destructiveForeground, dsHsl(0, 0, 98));
    });

    test('shadow ink is slate, a fifth of dark mode (L610–616)', () {
      expect(t.ink1, dsHsl(240, 20, 20, 0.04));
      expect(t.ink2, dsHsl(240, 20, 20, 0.07));
      expect(t.ink3, dsHsl(240, 20, 20, 0.11));
      expect(t.ink4, dsHsl(240, 20, 20, 0.16));
      expect(t.rim, dsHsl(0, 0, 100, 0.85));
      expect(t.rimStrong, dsHsl(0, 0, 100, 0.4));
      expect(t.wall, dsHsl(240, 6, 82));
    });

    test('charts name the legible end of each ramp (L624–628)', () {
      expect(t.chart1, DsPalette.action);
      expect(t.chart2, DsPalette.valueDark);
      expect(t.chart3, DsPalette.infoDeep);
      expect(t.chart4, DsPalette.actionDark);
      expect(t.chart5, DsPalette.successDeep);
    });

    test('sidebar aliases, declared verbatim (L651–658)', () {
      expect(t.sidebar, t.card);
      expect(t.sidebarForeground, t.mutedForeground);
      expect(t.sidebarPrimary, t.primary);
      expect(t.sidebarPrimaryForeground, t.primaryForeground);
      expect(t.sidebarAccent, t.accent);
      expect(t.sidebarAccentForeground, t.accentForeground);
      expect(t.sidebarBorder, t.border);
      expect(t.sidebarRing, t.ring);
    });

    test('agent + scrim (L661–663)', () {
      expect(t.agent, DsPalette.action);
      expect(t.agentMuted, dsHsl(213, 100, 97));
      expect(t.scrim, dsHsl(240, 10, 3.9, 0.28));
    });

    test('--radius (L605)', () => expect(t.radius, DsRadii.md));
  });

  // ── The two themes are genuinely two ───────────────────────────────────────
  test('the ramps swap which end carries a glyph', () {
    expect(DsThemeData.dark.actionInk, isNot(DsThemeData.light.actionInk));
    expect(DsThemeData.dark.valueInk, isNot(DsThemeData.light.valueInk));
    expect(DsThemeData.dark.background, DsThemeData.light.foreground);
  });

  // ── DsOklab ────────────────────────────────────────────────────────────────
  group('DsOklab.mix', () {
    test('mixing a colour with itself is that colour', () {
      for (final double t in <double>[0.13, 0.5, 0.87]) {
        expect(DsOklab.mix(DsPalette.action, DsPalette.action, t),
            DsPalette.action);
      }
    });

    test('endpoints are exact', () {
      expect(DsOklab.mix(DsPalette.action, DsPalette.value, 1),
          DsPalette.action);
      expect(DsOklab.mix(DsPalette.action, DsPalette.value, 0), DsPalette.value);
    });

    test('color-mix(in oklab, X n%, transparent) is X at n% alpha', () {
      // The form used by every shadow glow and wash in globals.css
      // (e.g. --shadow-glow-action, L382–384).
      expect(
        DsOklab.mix(DsPalette.action, dsTransparent, 0.45),
        DsPalette.action.withValues(alpha: 0.45),
      );
      expect(
        DsOklab.mix(DsPalette.value, dsTransparent, 0.42),
        DsPalette.value.withValues(alpha: 0.42),
      );
    });

    test('the midpoint interpolates in oklab, not sRGB', () {
      const Color black = Color(0xFF000000);
      const Color white = Color(0xFFFFFFFF);
      final Color mid = DsOklab.mix(white, black, 0.5);
      // Perceptual midpoint: L lands halfway, unlike a straight sRGB average
      // (which would put the channel at 0.5, not 0.3886).
      expect(DsOklab.toOklch(mid).l, closeTo(0.5, 0.0001));
      expect(mid.r, closeTo(0.3886, 0.0005));
      // Neutral stays neutral: the forward/inverse matrices are approximate
      // inverses, so the grey axis reproduces to ~1e-8, not bit-exactly.
      expect(mid.g, closeTo(mid.r, 0.000001));
      expect(mid.b, closeTo(mid.r, 0.000001));
      expect(mid.a, 1);
    });

    test('toOklch round-trips through fromOklch', () {
      final ({double c, double h, double l}) lch =
          DsOklab.toOklch(DsPalette.action);
      expect(lch.l, closeTo(0.5727, 0.002));
      expect(lch.c, closeTo(0.2156, 0.002));
      expect(lch.h, closeTo(260.19, 0.5));
      final Color back = DsOklab.fromOklch(lch.l, lch.c, lch.h);
      expect(back.r, closeTo(DsPalette.action.r, 0.004));
      expect(back.g, closeTo(DsPalette.action.g, 0.004));
      expect(back.b, closeTo(DsPalette.action.b, 0.004));
    });
  });

  // ── bubble-tinted: relative OKLCH, computed not hardcoded ─────────────────
  group('--bubble-tinted / --bubble-tinted-hover', () {
    final ({double c, double h, double l}) primary =
        DsOklab.toOklch(DsPalette.action);

    test('--primary reads as oklch(0.5727 0.2156 260.19)', () {
      expect(primary.l, closeTo(0.57266, 0.0001));
      expect(primary.c, closeTo(0.21557, 0.0001));
      expect(primary.h, closeTo(260.193, 0.001));
    });

    test('light: oklch(from --primary 0.93 calc(c * 0.4) h) — L602', () {
      final Color bt = DsThemeData.light.bubbleTinted;
      final ({double c, double h, double l}) got = DsOklab.toOklch(bt);
      // Lightness and hue are held exactly; only chroma moves.
      expect(got.l, closeTo(0.93, 0.0001));
      expect(got.h, closeTo(primary.h, 0.02));
      expect(bt.a, 1);
      expect(_isInGamut(bt), isTrue);
      // L 0.93 at 40% of the action ramp's chroma is OUTSIDE sRGB, so the
      // requested chroma cannot survive: it is reduced toward 0 until the
      // colour fits, landing on the gamut boundary (blue pinned at 1.0).
      expect(got.c, lessThan(primary.c * 0.4));
      expect(got.c, closeTo(0.03356, 0.0005));
      expect(bt.b, closeTo(1, 0.0005));
      // A pale tinted paper, not a second brand colour.
      expect(bt.r, closeTo(0.8595, 0.001));
      expect(bt.g, closeTo(0.9130, 0.001));
    });

    test('light hover: 0.88 / calc(c * 0.5) — L603', () {
      final Color bth = DsThemeData.light.bubbleTintedHover;
      final ({double c, double h, double l}) got = DsOklab.toOklch(bth);
      expect(got.l, closeTo(0.88, 0.0001));
      expect(got.h, closeTo(primary.h, 0.02));
      expect(_isInGamut(bth), isTrue);
      // Also outside sRGB as asked for, and also reduced to the boundary.
      expect(got.c, lessThan(primary.c * 0.5));
      expect(got.c, closeTo(0.05866, 0.0005));
      expect(bth.b, closeTo(1, 0.0005));
      // Hover is the darker, more saturated of the pair.
      final ({double c, double h, double l}) rest =
          DsOklab.toOklch(DsThemeData.light.bubbleTinted);
      expect(got.l, lessThan(rest.l));
      expect(got.c, greaterThan(rest.c));
    });

    test('dark: oklch(from --primary 0.3 calc(c * 0.4) h) — L811', () {
      final Color bt = DsThemeData.dark.bubbleTinted;
      final ({double c, double h, double l}) got = DsOklab.toOklch(bt);
      expect(got.l, closeTo(0.3, 0.0001));
      expect(got.h, closeTo(primary.h, 0.02));
      // A deep wash at L 0.3 fits sRGB, so chroma survives intact — no
      // reduction, unlike either light value.
      expect(got.c, closeTo(primary.c * 0.4, 0.000001));
      expect(_isInGamut(bt), isTrue);
    });

    test('dark hover: 0.35 / calc(c * 0.5) — L812', () {
      final Color bth = DsThemeData.dark.bubbleTintedHover;
      final ({double c, double h, double l}) got = DsOklab.toOklch(bth);
      expect(got.l, closeTo(0.35, 0.0001));
      expect(got.h, closeTo(primary.h, 0.02));
      expect(got.c, closeTo(primary.c * 0.5, 0.000001));
      expect(_isInGamut(bth), isTrue);
      expect(got.l, greaterThan(DsOklab.toOklch(DsThemeData.dark.bubbleTinted).l));
    });

    test('the four are computed from --primary, never hardcoded', () {
      // Re-deriving from the palette must reproduce the theme values exactly.
      expect(
        DsOklab.fromOklchRelative(DsPalette.action,
            lightness: 0.93, chromaScale: 0.4),
        DsThemeData.light.bubbleTinted,
      );
      expect(
        DsOklab.fromOklchRelative(DsPalette.action,
            lightness: 0.3, chromaScale: 0.4),
        DsThemeData.dark.bubbleTinted,
      );
    });
  });

  // ── spacing.dart ───────────────────────────────────────────────────────────
  group('spacing, widths, radii, breakpoints', () {
    test('ds() is Tailwind\'s 4px --spacing unit', () {
      expect(ds(6), 24);
      expect(ds(0), 0);
      expect(ds(1), 4);
      expect(ds(0.5), 2);
      expect(ds(20), 80);
    });

    test('widths (globals.css L228–322)', () {
      expect(DsWidths.shell, 1680);
      expect(DsWidths.content, 1080);
      expect(DsWidths.page, 1200);
      expect(DsWidths.prose, 720);
      expect(DsWidths.rail, 240);
      expect(DsWidths.sidebar, 256);
      expect(DsWidths.sidebarIcon, 48);
      expect(DsWidths.sidebarMobile, 288);
      expect(DsWidths.siteHeader, 64);
      // --scroll-offset: calc(--height-site-header + --spacing * 8).
      expect(DsWidths.scrollOffset, DsWidths.siteHeader + ds(8));
      expect(DsWidths.scrollOffset, 96);
    });

    test('radii (globals.css L324–339)', () {
      expect(DsRadii.xs, 2);
      expect(DsRadii.sm, 6);
      expect(DsRadii.md, 10);
      expect(DsRadii.lg, 12);
      expect(DsRadii.xl, 16);
      expect(DsRadii.xl2, 20);
      expect(DsRadii.xl3, 24);
      expect(DsRadii.xl4, 32);
      expect(DsRadii.pill, 999);
    });

    test('breakpoints are Tailwind stock', () {
      expect(DsBreakpoints.sm, 640);
      expect(DsBreakpoints.md, 768);
      expect(DsBreakpoints.lg, 1024);
      expect(DsBreakpoints.xl, 1280);
    });
  });
}

/// True when every channel of [color] is inside sRGB without clipping.
bool _isInGamut(Color color) =>
    color.r >= 0 &&
    color.r <= 1 &&
    color.g >= 0 &&
    color.g <= 1 &&
    color.b >= 0 &&
    color.b <= 1;
