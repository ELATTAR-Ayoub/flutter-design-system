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
  // ── hslColor — CSS hsl() rasterisation ────────────────────────────────────────
  group('hslColor', () {
    // globals.css L99–105: the ramp was annotated #93C5FD / #2563EB / #1D4ED8
    // for three brands and never rasterised to those. The hsl() values are
    // authoritative; these three hexes are what they actually paint.
    test('--color-action-bright: hsl(213 94% 78%) rasterises #92C2FC', () {
      expect(hslColor(213, 94, 78), const Color(0xFF92C2FC));
    });

    test('--color-action: hsl(217 91% 53%) rasterises #1A6EF4', () {
      expect(hslColor(217, 91, 53), const Color(0xFF1A6EF4));
    });

    test('--color-action-dark: hsl(224 76% 33%) rasterises #143694', () {
      expect(hslColor(224, 76, 33), const Color(0xFF143694));
    });

    test('achromatic and boundary hues', () {
      expect(hslColor(0, 0, 100), const Color(0xFFFFFFFF));
      expect(hslColor(0, 0, 0), const Color(0xFF000000));
      // hsl(0 72.2% 50.6%) — --destructive, both themes (L596 / L805).
      expect(hslColor(0, 72.2, 50.6), const Color(0xFFDC2626));
    });

    test('alpha is straight, never pre-composited', () {
      // --ink-2: hsl(240 20% 20% / 0.07) — globals.css L611.
      final Color ink2 = hslColor(240, 20, 20, 0.07);
      expect(ink2.a, 0.07);
      expect(ink2.r, hslColor(240, 20, 20).r);
      expect(ink2.g, hslColor(240, 20, 20).g);
      expect(ink2.b, hslColor(240, 20, 20).b);
    });

    test('transparent is a fully transparent black', () {
      expect(transparent, const Color(0x00000000));
      expect(transparent.a, 0);
    });
  });

  // ── Palette — @theme static ramps + state (globals.css L71–433) ──────────
  group('Palette', () {
    test('brand ramps (L103–109)', () {
      expect(Palette.actionBright, hslColor(213, 94, 78));
      expect(Palette.action, hslColor(217, 91, 53));
      expect(Palette.actionDark, hslColor(224, 76, 33));
      expect(Palette.valueBright, const Color(0xFFD9F99D));
      expect(Palette.value, const Color(0xFFA3E635));
      expect(Palette.valueDark, const Color(0xFF4D7C0F));
    });

    test('--color-value-foreground does not flip with the theme (L127)', () {
      expect(Palette.valueForeground, hslColor(240, 10, 8));
    });

    test('state hues (L148–150)', () {
      expect(Palette.success, const Color(0xFF10B981));
      expect(Palette.warning, const Color(0xFFFBBF24));
      expect(Palette.info, const Color(0xFF22D3EE));
    });

    test('deep state hues (L158–165)', () {
      expect(Palette.successDeep, const Color(0xFF047857));
      expect(Palette.warningDeep, const Color(0xFFB45309));
      expect(Palette.infoDeep, const Color(0xFF0E7490));
      expect(Palette.destructiveLifted, const Color(0xFFF87171));
      expect(Palette.destructiveDeep, hslColor(0, 72.2, 46));
    });
  });

  // ── ThemeTokens.dark — `.dark` block, globals.css L741–942 ────────────────
  group('ThemeTokens.dark', () {
    final ThemeTokens t = ThemeTokens.dark;

    test('kind', () => expect(t.kind, ResolvedColorMode.dark));

    test('monochrome (L746–762)', () {
      expect(t.background, hslColor(240, 10, 3.9));
      expect(t.foreground, hslColor(0, 0, 98));
      expect(t.card, hslColor(240, 5.9, 10));
      expect(t.cardForeground, hslColor(0, 0, 98));
      expect(t.popover, hslColor(240, 5.9, 10));
      expect(t.popoverForeground, hslColor(0, 0, 98));
      expect(t.secondary, hslColor(240, 3.7, 15.9));
      expect(t.secondaryForeground, hslColor(0, 0, 98));
      expect(t.muted, hslColor(240, 3.7, 15.9));
      expect(t.mutedForeground, hslColor(240, 4.9, 83.9));
      expect(t.accent, hslColor(240, 5.3, 26.1));
      expect(t.accentForeground, hslColor(0, 0, 98));
      expect(t.border, hslColor(240, 3.7, 15.9));
      expect(t.input, hslColor(240, 5.3, 26.1));
    });

    test(
      '--background-effect (L769)',
      () => expect(t.pageGlow, hslColor(240, 8, 10)),
    );

    test('brand (L772–780)', () {
      expect(t.primary, Palette.action);
      expect(t.primaryForeground, hslColor(0, 0, 100));
      expect(t.ring, Palette.actionBright);
    });

    test('ink pointers pick the lifted end (L784–802)', () {
      expect(t.actionText, Palette.actionBright);
      // Documented drift: `-bright`, not the mid the §1.3 table asks for.
      expect(t.premiumText, Palette.valueBright);
      expect(t.successText, Palette.success);
      expect(t.warningText, Palette.warning);
      expect(t.infoText, Palette.info);
      expect(t.destructiveText, Palette.destructiveLifted);
    });

    test('destructive (L805–806)', () {
      expect(t.destructive, hslColor(0, 72.2, 50.6));
      expect(t.destructiveForeground, hslColor(0, 0, 98));
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
      expect(t.wall, hslColor(240, 6, 8));
    });

    test('charts name the legible end of each ramp (L842–846)', () {
      expect(t.chart1, Palette.actionBright);
      expect(t.chart2, Palette.value);
      expect(t.chart3, Palette.info);
      expect(t.chart4, Palette.valueBright);
      expect(t.chart5, Palette.success);
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
      expect(t.agentAccent, Palette.actionBright);
      expect(t.agentAccentMuted, hslColor(217, 40, 13));
      expect(t.scrim, hslColor(240, 10, 3.9, 0.66));
    });

    test('--radius (L814)', () => expect(t.radius, Radii.md));
  });

  // ── ThemeTokens.light — `:root, .light` block, globals.css L546–735 ────────
  group('ThemeTokens.light', () {
    final ThemeTokens t = ThemeTokens.light;

    test('kind', () => expect(t.kind, ResolvedColorMode.light));

    test('monochrome (L549–574)', () {
      expect(t.background, hslColor(0, 0, 100));
      expect(t.foreground, hslColor(240, 10, 3.9));
      expect(t.card, hslColor(0, 0, 100));
      expect(t.cardForeground, hslColor(240, 10, 3.9));
      expect(t.popover, hslColor(0, 0, 100));
      expect(t.popoverForeground, hslColor(240, 10, 3.9));
      expect(t.secondary, hslColor(240, 4.8, 95.9));
      expect(t.secondaryForeground, hslColor(240, 5.9, 10));
      expect(t.muted, hslColor(240, 4.8, 95.9));
      expect(t.accent, hslColor(240, 4.8, 95.9));
      expect(t.accentForeground, hslColor(240, 5.9, 10));
      expect(t.border, hslColor(240, 5.9, 90));
      expect(t.input, hslColor(240, 5.9, 90));
    });

    test('--muted-foreground is the deeper step, not zinc 500 (L569)', () {
      expect(t.mutedForeground, hslColor(240, 4, 40));
    });

    test(
      '--background-effect (L579)',
      () => expect(t.pageGlow, hslColor(240, 30, 98)),
    );

    test('brand (L582–584)', () {
      expect(t.primary, Palette.action);
      expect(t.primaryForeground, hslColor(0, 0, 100));
      expect(t.ring, Palette.action);
    });

    test('ink pointers pick the deep end (L589–594)', () {
      expect(t.actionText, Palette.actionDark);
      expect(t.premiumText, Palette.valueDark);
      expect(t.successText, Palette.successDeep);
      expect(t.warningText, Palette.warningDeep);
      expect(t.infoText, Palette.infoDeep);
      expect(t.destructiveText, Palette.destructiveDeep);
    });

    test('destructive (L596–597)', () {
      expect(t.destructive, hslColor(0, 72.2, 50.6));
      expect(t.destructiveForeground, hslColor(0, 0, 98));
    });

    test('shadow ink is slate, a fifth of dark mode (L610–616)', () {
      expect(t.ink1, hslColor(240, 20, 20, 0.04));
      expect(t.ink2, hslColor(240, 20, 20, 0.07));
      expect(t.ink3, hslColor(240, 20, 20, 0.11));
      expect(t.ink4, hslColor(240, 20, 20, 0.16));
      expect(t.rim, hslColor(0, 0, 100, 0.85));
      expect(t.rimStrong, hslColor(0, 0, 100, 0.4));
      expect(t.wall, hslColor(240, 6, 82));
    });

    test('charts name the legible end of each ramp (L624–628)', () {
      expect(t.chart1, Palette.action);
      expect(t.chart2, Palette.valueDark);
      expect(t.chart3, Palette.infoDeep);
      expect(t.chart4, Palette.actionDark);
      expect(t.chart5, Palette.successDeep);
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
      expect(t.agentAccent, Palette.action);
      expect(t.agentAccentMuted, hslColor(213, 100, 97));
      expect(t.scrim, hslColor(240, 10, 3.9, 0.28));
    });

    test('--radius (L605)', () => expect(t.radius, Radii.md));
  });

  // ── The two themes are genuinely two ───────────────────────────────────────
  test('the ramps swap which end carries a glyph', () {
    expect(ThemeTokens.dark.actionText, isNot(ThemeTokens.light.actionText));
    expect(ThemeTokens.dark.premiumText, isNot(ThemeTokens.light.premiumText));
    expect(ThemeTokens.dark.background, ThemeTokens.light.foreground);
  });

  // ── OklabColor ────────────────────────────────────────────────────────────────
  group('OklabColor.mix', () {
    test('mixing a colour with itself is that colour', () {
      for (final double t in <double>[0.13, 0.5, 0.87]) {
        expect(
          OklabColor.mix(Palette.action, Palette.action, t),
          Palette.action,
        );
      }
    });

    test('endpoints are exact', () {
      expect(OklabColor.mix(Palette.action, Palette.value, 1), Palette.action);
      expect(OklabColor.mix(Palette.action, Palette.value, 0), Palette.value);
    });

    test('color-mix(in oklab, X n%, transparent) is X at n% alpha', () {
      // The form used by every shadow glow and wash in globals.css
      // (e.g. --shadow-glow-action, L382–384).
      expect(
        OklabColor.mix(Palette.action, transparent, 0.45),
        Palette.action.withValues(alpha: 0.45),
      );
      expect(
        OklabColor.mix(Palette.value, transparent, 0.42),
        Palette.value.withValues(alpha: 0.42),
      );
    });

    test('the midpoint interpolates in oklab, not sRGB', () {
      const Color black = Color(0xFF000000);
      const Color white = Color(0xFFFFFFFF);
      final Color mid = OklabColor.mix(white, black, 0.5);
      // Perceptual midpoint: L lands halfway, unlike a straight sRGB average
      // (which would put the channel at 0.5, not 0.3886).
      expect(OklabColor.toOklch(mid).l, closeTo(0.5, 0.0001));
      expect(mid.r, closeTo(0.3886, 0.0005));
      // Neutral stays neutral: the forward/inverse matrices are approximate
      // inverses, so the grey axis reproduces to ~1e-8, not bit-exactly.
      expect(mid.g, closeTo(mid.r, 0.000001));
      expect(mid.b, closeTo(mid.r, 0.000001));
      expect(mid.a, 1);
    });

    test('toOklch round-trips through fromOklch', () {
      final ({double c, double h, double l}) lch = OklabColor.toOklch(
        Palette.action,
      );
      expect(lch.l, closeTo(0.5727, 0.002));
      expect(lch.c, closeTo(0.2156, 0.002));
      expect(lch.h, closeTo(260.19, 0.5));
      final Color back = OklabColor.fromOklch(lch.l, lch.c, lch.h);
      expect(back.r, closeTo(Palette.action.r, 0.004));
      expect(back.g, closeTo(Palette.action.g, 0.004));
      expect(back.b, closeTo(Palette.action.b, 0.004));
    });
  });

  // ── bubble-tinted: relative OKLCH, computed not hardcoded ─────────────────
  group('--bubble-tinted / --bubble-tinted-hover', () {
    final ({double c, double h, double l}) primary = OklabColor.toOklch(
      Palette.action,
    );

    test('--primary reads as oklch(0.5727 0.2156 260.19)', () {
      expect(primary.l, closeTo(0.57266, 0.0001));
      expect(primary.c, closeTo(0.21557, 0.0001));
      expect(primary.h, closeTo(260.193, 0.001));
    });

    test('light: oklch(from --primary 0.93 calc(c * 0.4) h) — L602', () {
      final Color bt = ThemeTokens.light.messageAccent;
      final ({double c, double h, double l}) got = OklabColor.toOklch(bt);
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
      final Color bth = ThemeTokens.light.messageAccentHover;
      final ({double c, double h, double l}) got = OklabColor.toOklch(bth);
      expect(got.l, closeTo(0.88, 0.0001));
      expect(got.h, closeTo(primary.h, 0.02));
      expect(_isInGamut(bth), isTrue);
      // Also outside sRGB as asked for, and also reduced to the boundary.
      expect(got.c, lessThan(primary.c * 0.5));
      expect(got.c, closeTo(0.05866, 0.0005));
      expect(bth.b, closeTo(1, 0.0005));
      // Hover is the darker, more saturated of the pair.
      final ({double c, double h, double l}) rest = OklabColor.toOklch(
        ThemeTokens.light.messageAccent,
      );
      expect(got.l, lessThan(rest.l));
      expect(got.c, greaterThan(rest.c));
    });

    test('dark: oklch(from --primary 0.3 calc(c * 0.4) h) — L811', () {
      final Color bt = ThemeTokens.dark.messageAccent;
      final ({double c, double h, double l}) got = OklabColor.toOklch(bt);
      expect(got.l, closeTo(0.3, 0.0001));
      expect(got.h, closeTo(primary.h, 0.02));
      // A deep wash at L 0.3 fits sRGB, so chroma survives intact — no
      // reduction, unlike either light value.
      expect(got.c, closeTo(primary.c * 0.4, 0.000001));
      expect(_isInGamut(bt), isTrue);
    });

    test('dark hover: 0.35 / calc(c * 0.5) — L812', () {
      final Color bth = ThemeTokens.dark.messageAccentHover;
      final ({double c, double h, double l}) got = OklabColor.toOklch(bth);
      expect(got.l, closeTo(0.35, 0.0001));
      expect(got.h, closeTo(primary.h, 0.02));
      expect(got.c, closeTo(primary.c * 0.5, 0.000001));
      expect(_isInGamut(bth), isTrue);
      expect(
        got.l,
        greaterThan(OklabColor.toOklch(ThemeTokens.dark.messageAccent).l),
      );
    });

    test('the four are computed from --primary, never hardcoded', () {
      // Re-deriving from the palette must reproduce the theme values exactly.
      expect(
        OklabColor.fromOklchRelative(
          Palette.action,
          lightness: 0.93,
          chromaScale: 0.4,
        ),
        ThemeTokens.light.messageAccent,
      );
      expect(
        OklabColor.fromOklchRelative(
          Palette.action,
          lightness: 0.3,
          chromaScale: 0.4,
        ),
        ThemeTokens.dark.messageAccent,
      );
    });
  });

  // ── spacing.dart ───────────────────────────────────────────────────────────
  group('spacing, widths, radii, breakpoints', () {
    test('space() is Tailwind\'s 4px --spacing unit', () {
      expect(space(6), 24);
      expect(space(0), 0);
      expect(space(1), 4);
      expect(space(0.5), 2);
      expect(space(20), 80);
    });

    test('widths (globals.css L228–322)', () {
      expect(LayoutWidths.shell, 1680);
      expect(LayoutWidths.content, 1080);
      expect(LayoutWidths.page, 1200);
      expect(LayoutWidths.prose, 720);
      expect(LayoutWidths.rail, 240);
      expect(LayoutWidths.sidebar, 256);
      expect(LayoutWidths.sidebarCollapsed, 48);
      expect(LayoutWidths.sidebarMobile, 288);
      expect(LayoutHeights.siteHeader, 64);
      // --scroll-offset: calc(--height-site-header + --spacing * 8).
      expect(
        ScrollOffsets.anchoredHeading,
        LayoutHeights.siteHeader + space(8),
      );
      expect(ScrollOffsets.anchoredHeading, 96);
    });

    test('radii (globals.css L324–339)', () {
      expect(Radii.xs, 2);
      expect(Radii.sm, 6);
      expect(Radii.md, 10);
      expect(Radii.lg, 12);
      expect(Radii.xl, 16);
      expect(Radii.xl2, 20);
      expect(Radii.xl3, 24);
      expect(Radii.xl4, 32);
      expect(Radii.full, 999);
    });

    test('breakpoints are Tailwind stock', () {
      expect(Breakpoints.sm, 640);
      expect(Breakpoints.md, 768);
      expect(Breakpoints.lg, 1024);
      expect(Breakpoints.xl, 1280);
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
