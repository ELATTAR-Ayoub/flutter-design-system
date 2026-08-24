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
  // ── elHsl — CSS hsl() rasterisation ────────────────────────────────────────
  group('elHsl', () {
    // globals.css L99–105: the ramp was annotated #93C5FD / #2563EB / #1D4ED8
    // for three brands and never rasterised to those. The hsl() values are
    // authoritative; these three hexes are what they actually paint.
    test('--color-action-bright: hsl(213 94% 78%) rasterises #92C2FC', () {
      expect(elHsl(213, 94, 78), const Color(0xFF92C2FC));
    });

    test('--color-action: hsl(217 91% 53%) rasterises #1A6EF4', () {
      expect(elHsl(217, 91, 53), const Color(0xFF1A6EF4));
    });

    test('--color-action-dark: hsl(224 76% 33%) rasterises #143694', () {
      expect(elHsl(224, 76, 33), const Color(0xFF143694));
    });

    test('achromatic and boundary hues', () {
      expect(elHsl(0, 0, 100), const Color(0xFFFFFFFF));
      expect(elHsl(0, 0, 0), const Color(0xFF000000));
      // hsl(0 72.2% 50.6%) — --destructive, both themes (L596 / L805).
      expect(elHsl(0, 72.2, 50.6), const Color(0xFFDC2626));
    });

    test('alpha is straight, never pre-composited', () {
      // --ink-2: hsl(240 20% 20% / 0.07) — globals.css L611.
      final Color ink2 = elHsl(240, 20, 20, 0.07);
      expect(ink2.a, 0.07);
      expect(ink2.r, elHsl(240, 20, 20).r);
      expect(ink2.g, elHsl(240, 20, 20).g);
      expect(ink2.b, elHsl(240, 20, 20).b);
    });

    test('elTransparent is a fully transparent black', () {
      expect(elTransparent, const Color(0x00000000));
      expect(elTransparent.a, 0);
    });
  });

  // ── ElPalette — @theme static ramps + state (globals.css L71–433) ──────────
  group('ElPalette', () {
    test('brand ramps (L103–109)', () {
      expect(ElPalette.actionBright, elHsl(213, 94, 78));
      expect(ElPalette.action, elHsl(217, 91, 53));
      expect(ElPalette.actionDark, elHsl(224, 76, 33));
      expect(ElPalette.valueBright, const Color(0xFFD9F99D));
      expect(ElPalette.value, const Color(0xFFA3E635));
      expect(ElPalette.valueDark, const Color(0xFF4D7C0F));
    });

    test('--color-value-foreground does not flip with the theme (L127)', () {
      expect(ElPalette.valueForeground, elHsl(240, 10, 8));
    });

    test('state hues (L148–150)', () {
      expect(ElPalette.success, const Color(0xFF10B981));
      expect(ElPalette.warning, const Color(0xFFFBBF24));
      expect(ElPalette.info, const Color(0xFF22D3EE));
    });

    test('deep state hues (L158–165)', () {
      expect(ElPalette.successDeep, const Color(0xFF047857));
      expect(ElPalette.warningDeep, const Color(0xFFB45309));
      expect(ElPalette.infoDeep, const Color(0xFF0E7490));
      expect(ElPalette.destructiveLifted, const Color(0xFFF87171));
      expect(ElPalette.destructiveDeep, elHsl(0, 72.2, 46));
    });
  });

  // ── ElThemeData.dark — `.dark` block, globals.css L741–942 ────────────────
  group('ElThemeData.dark', () {
    final ElThemeData t = ElThemeData.dark;

    test('kind', () => expect(t.kind, ElThemeKind.dark));

    test('monochrome (L746–762)', () {
      expect(t.background, elHsl(240, 10, 3.9));
      expect(t.foreground, elHsl(0, 0, 98));
      expect(t.card, elHsl(240, 5.9, 10));
      expect(t.cardForeground, elHsl(0, 0, 98));
      expect(t.popover, elHsl(240, 5.9, 10));
      expect(t.popoverForeground, elHsl(0, 0, 98));
      expect(t.secondary, elHsl(240, 3.7, 15.9));
      expect(t.secondaryForeground, elHsl(0, 0, 98));
      expect(t.muted, elHsl(240, 3.7, 15.9));
      expect(t.mutedForeground, elHsl(240, 4.9, 83.9));
      expect(t.accent, elHsl(240, 5.3, 26.1));
      expect(t.accentForeground, elHsl(0, 0, 98));
      expect(t.border, elHsl(240, 3.7, 15.9));
      expect(t.input, elHsl(240, 5.3, 26.1));
    });

    test('--page-glow (L769)', () => expect(t.pageGlow, elHsl(240, 8, 10)));

    test('brand (L772–780)', () {
      expect(t.primary, ElPalette.action);
      expect(t.primaryForeground, elHsl(0, 0, 100));
      expect(t.ring, ElPalette.actionBright);
    });

    test('ink pointers pick the lifted end (L784–802)', () {
      expect(t.actionInk, ElPalette.actionBright);
      // Documented drift: `-bright`, not the mid the §1.3 table asks for.
      expect(t.valueInk, ElPalette.valueBright);
      expect(t.successInk, ElPalette.success);
      expect(t.warningInk, ElPalette.warning);
      expect(t.infoInk, ElPalette.info);
      expect(t.destructiveInk, ElPalette.destructiveLifted);
    });

    test('destructive (L805–806)', () {
      expect(t.destructive, elHsl(0, 72.2, 50.6));
      expect(t.destructiveForeground, elHsl(0, 0, 98));
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
      expect(t.wall, elHsl(240, 6, 8));
    });

    test('charts name the legible end of each ramp (L842–846)', () {
      expect(t.chart1, ElPalette.actionBright);
      expect(t.chart2, ElPalette.value);
      expect(t.chart3, ElPalette.info);
      expect(t.chart4, ElPalette.valueBright);
      expect(t.chart5, ElPalette.success);
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
      expect(t.agent, ElPalette.actionBright);
      expect(t.agentMuted, elHsl(217, 40, 13));
      expect(t.scrim, elHsl(240, 10, 3.9, 0.66));
    });

    test('--radius (L814)', () => expect(t.radius, ElRadii.md));
  });

  // ── ElThemeData.light — `:root, .light` block, globals.css L546–735 ────────
  group('ElThemeData.light', () {
    final ElThemeData t = ElThemeData.light;

    test('kind', () => expect(t.kind, ElThemeKind.light));

    test('monochrome (L549–574)', () {
      expect(t.background, elHsl(0, 0, 100));
      expect(t.foreground, elHsl(240, 10, 3.9));
      expect(t.card, elHsl(0, 0, 100));
      expect(t.cardForeground, elHsl(240, 10, 3.9));
      expect(t.popover, elHsl(0, 0, 100));
      expect(t.popoverForeground, elHsl(240, 10, 3.9));
      expect(t.secondary, elHsl(240, 4.8, 95.9));
      expect(t.secondaryForeground, elHsl(240, 5.9, 10));
      expect(t.muted, elHsl(240, 4.8, 95.9));
      expect(t.accent, elHsl(240, 4.8, 95.9));
      expect(t.accentForeground, elHsl(240, 5.9, 10));
      expect(t.border, elHsl(240, 5.9, 90));
      expect(t.input, elHsl(240, 5.9, 90));
    });

    test('--muted-foreground is the deeper step, not zinc 500 (L569)', () {
      expect(t.mutedForeground, elHsl(240, 4, 40));
    });

    test('--page-glow (L579)', () => expect(t.pageGlow, elHsl(240, 30, 98)));

    test('brand (L582–584)', () {
      expect(t.primary, ElPalette.action);
      expect(t.primaryForeground, elHsl(0, 0, 100));
      expect(t.ring, ElPalette.action);
    });

    test('ink pointers pick the deep end (L589–594)', () {
      expect(t.actionInk, ElPalette.actionDark);
      expect(t.valueInk, ElPalette.valueDark);
      expect(t.successInk, ElPalette.successDeep);
      expect(t.warningInk, ElPalette.warningDeep);
      expect(t.infoInk, ElPalette.infoDeep);
      expect(t.destructiveInk, ElPalette.destructiveDeep);
    });

    test('destructive (L596–597)', () {
      expect(t.destructive, elHsl(0, 72.2, 50.6));
      expect(t.destructiveForeground, elHsl(0, 0, 98));
    });

    test('shadow ink is slate, a fifth of dark mode (L610–616)', () {
      expect(t.ink1, elHsl(240, 20, 20, 0.04));
      expect(t.ink2, elHsl(240, 20, 20, 0.07));
      expect(t.ink3, elHsl(240, 20, 20, 0.11));
      expect(t.ink4, elHsl(240, 20, 20, 0.16));
      expect(t.rim, elHsl(0, 0, 100, 0.85));
      expect(t.rimStrong, elHsl(0, 0, 100, 0.4));
      expect(t.wall, elHsl(240, 6, 82));
    });

    test('charts name the legible end of each ramp (L624–628)', () {
      expect(t.chart1, ElPalette.action);
      expect(t.chart2, ElPalette.valueDark);
      expect(t.chart3, ElPalette.infoDeep);
      expect(t.chart4, ElPalette.actionDark);
      expect(t.chart5, ElPalette.successDeep);
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
      expect(t.agent, ElPalette.action);
      expect(t.agentMuted, elHsl(213, 100, 97));
      expect(t.scrim, elHsl(240, 10, 3.9, 0.28));
    });

    test('--radius (L605)', () => expect(t.radius, ElRadii.md));
  });

  // ── The two themes are genuinely two ───────────────────────────────────────
  test('the ramps swap which end carries a glyph', () {
    expect(ElThemeData.dark.actionInk, isNot(ElThemeData.light.actionInk));
    expect(ElThemeData.dark.valueInk, isNot(ElThemeData.light.valueInk));
    expect(ElThemeData.dark.background, ElThemeData.light.foreground);
  });

  // ── ElOklab ────────────────────────────────────────────────────────────────
  group('ElOklab.mix', () {
    test('mixing a colour with itself is that colour', () {
      for (final double t in <double>[0.13, 0.5, 0.87]) {
        expect(
          ElOklab.mix(ElPalette.action, ElPalette.action, t),
          ElPalette.action,
        );
      }
    });

    test('endpoints are exact', () {
      expect(
        ElOklab.mix(ElPalette.action, ElPalette.value, 1),
        ElPalette.action,
      );
      expect(
        ElOklab.mix(ElPalette.action, ElPalette.value, 0),
        ElPalette.value,
      );
    });

    test('color-mix(in oklab, X n%, transparent) is X at n% alpha', () {
      // The form used by every shadow glow and wash in globals.css
      // (e.g. --shadow-glow-action, L382–384).
      expect(
        ElOklab.mix(ElPalette.action, elTransparent, 0.45),
        ElPalette.action.withValues(alpha: 0.45),
      );
      expect(
        ElOklab.mix(ElPalette.value, elTransparent, 0.42),
        ElPalette.value.withValues(alpha: 0.42),
      );
    });

    test('the midpoint interpolates in oklab, not sRGB', () {
      const Color black = Color(0xFF000000);
      const Color white = Color(0xFFFFFFFF);
      final Color mid = ElOklab.mix(white, black, 0.5);
      // Perceptual midpoint: L lands halfway, unlike a straight sRGB average
      // (which would put the channel at 0.5, not 0.3886).
      expect(ElOklab.toOklch(mid).l, closeTo(0.5, 0.0001));
      expect(mid.r, closeTo(0.3886, 0.0005));
      // Neutral stays neutral: the forward/inverse matrices are approximate
      // inverses, so the grey axis reproduces to ~1e-8, not bit-exactly.
      expect(mid.g, closeTo(mid.r, 0.000001));
      expect(mid.b, closeTo(mid.r, 0.000001));
      expect(mid.a, 1);
    });

    test('toOklch round-trips through fromOklch', () {
      final ({double c, double h, double l}) lch = ElOklab.toOklch(
        ElPalette.action,
      );
      expect(lch.l, closeTo(0.5727, 0.002));
      expect(lch.c, closeTo(0.2156, 0.002));
      expect(lch.h, closeTo(260.19, 0.5));
      final Color back = ElOklab.fromOklch(lch.l, lch.c, lch.h);
      expect(back.r, closeTo(ElPalette.action.r, 0.004));
      expect(back.g, closeTo(ElPalette.action.g, 0.004));
      expect(back.b, closeTo(ElPalette.action.b, 0.004));
    });
  });

  // ── bubble-tinted: relative OKLCH, computed not hardcoded ─────────────────
  group('--bubble-tinted / --bubble-tinted-hover', () {
    final ({double c, double h, double l}) primary = ElOklab.toOklch(
      ElPalette.action,
    );

    test('--primary reads as oklch(0.5727 0.2156 260.19)', () {
      expect(primary.l, closeTo(0.57266, 0.0001));
      expect(primary.c, closeTo(0.21557, 0.0001));
      expect(primary.h, closeTo(260.193, 0.001));
    });

    test('light: oklch(from --primary 0.93 calc(c * 0.4) h) — L602', () {
      final Color bt = ElThemeData.light.bubbleTinted;
      final ({double c, double h, double l}) got = ElOklab.toOklch(bt);
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
      final Color bth = ElThemeData.light.bubbleTintedHover;
      final ({double c, double h, double l}) got = ElOklab.toOklch(bth);
      expect(got.l, closeTo(0.88, 0.0001));
      expect(got.h, closeTo(primary.h, 0.02));
      expect(_isInGamut(bth), isTrue);
      // Also outside sRGB as asked for, and also reduced to the boundary.
      expect(got.c, lessThan(primary.c * 0.5));
      expect(got.c, closeTo(0.05866, 0.0005));
      expect(bth.b, closeTo(1, 0.0005));
      // Hover is the darker, more saturated of the pair.
      final ({double c, double h, double l}) rest = ElOklab.toOklch(
        ElThemeData.light.bubbleTinted,
      );
      expect(got.l, lessThan(rest.l));
      expect(got.c, greaterThan(rest.c));
    });

    test('dark: oklch(from --primary 0.3 calc(c * 0.4) h) — L811', () {
      final Color bt = ElThemeData.dark.bubbleTinted;
      final ({double c, double h, double l}) got = ElOklab.toOklch(bt);
      expect(got.l, closeTo(0.3, 0.0001));
      expect(got.h, closeTo(primary.h, 0.02));
      // A deep wash at L 0.3 fits sRGB, so chroma survives intact — no
      // reduction, unlike either light value.
      expect(got.c, closeTo(primary.c * 0.4, 0.000001));
      expect(_isInGamut(bt), isTrue);
    });

    test('dark hover: 0.35 / calc(c * 0.5) — L812', () {
      final Color bth = ElThemeData.dark.bubbleTintedHover;
      final ({double c, double h, double l}) got = ElOklab.toOklch(bth);
      expect(got.l, closeTo(0.35, 0.0001));
      expect(got.h, closeTo(primary.h, 0.02));
      expect(got.c, closeTo(primary.c * 0.5, 0.000001));
      expect(_isInGamut(bth), isTrue);
      expect(
        got.l,
        greaterThan(ElOklab.toOklch(ElThemeData.dark.bubbleTinted).l),
      );
    });

    test('the four are computed from --primary, never hardcoded', () {
      // Re-deriving from the palette must reproduce the theme values exactly.
      expect(
        ElOklab.fromOklchRelative(
          ElPalette.action,
          lightness: 0.93,
          chromaScale: 0.4,
        ),
        ElThemeData.light.bubbleTinted,
      );
      expect(
        ElOklab.fromOklchRelative(
          ElPalette.action,
          lightness: 0.3,
          chromaScale: 0.4,
        ),
        ElThemeData.dark.bubbleTinted,
      );
    });
  });

  // ── spacing.dart ───────────────────────────────────────────────────────────
  group('spacing, widths, radii, breakpoints', () {
    test('el() is Tailwind\'s 4px --spacing unit', () {
      expect(el(6), 24);
      expect(el(0), 0);
      expect(el(1), 4);
      expect(el(0.5), 2);
      expect(el(20), 80);
    });

    test('widths (globals.css L228–322)', () {
      expect(ElWidths.shell, 1680);
      expect(ElWidths.content, 1080);
      expect(ElWidths.page, 1200);
      expect(ElWidths.prose, 720);
      expect(ElWidths.rail, 240);
      expect(ElWidths.sidebar, 256);
      expect(ElWidths.sidebarIcon, 48);
      expect(ElWidths.sidebarMobile, 288);
      expect(ElWidths.siteHeader, 64);
      // --scroll-offset: calc(--height-site-header + --spacing * 8).
      expect(ElWidths.scrollOffset, ElWidths.siteHeader + el(8));
      expect(ElWidths.scrollOffset, 96);
    });

    test('radii (globals.css L324–339)', () {
      expect(ElRadii.xs, 2);
      expect(ElRadii.sm, 6);
      expect(ElRadii.md, 10);
      expect(ElRadii.lg, 12);
      expect(ElRadii.xl, 16);
      expect(ElRadii.xl2, 20);
      expect(ElRadii.xl3, 24);
      expect(ElRadii.xl4, 32);
      expect(ElRadii.pill, 999);
    });

    test('breakpoints are Tailwind stock', () {
      expect(ElBreakpoints.sm, 640);
      expect(ElBreakpoints.md, 768);
      expect(ElBreakpoints.lg, 1024);
      expect(ElBreakpoints.xl, 1280);
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
