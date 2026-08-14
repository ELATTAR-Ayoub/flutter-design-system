/// `components/ui/sheet.tsx`, left side only — the mobile navigation drawer.
///
/// Below `lg`, `DsMobileNav` swaps the 240px sidebar for a burger that opens
/// this: a 288px panel against the left edge, over a barely-tinted, blurred
/// backdrop.
///
/// Motion comes from two places at once, and both are transcribed here:
/// the `tw-animate-css` utilities on the element (`fade-in-0`,
/// `slide-in-from-left-10`) supply the *shape* of the animation, and the
/// unlayered bridge at globals.css L2181–2185 supplies its *timing* —
/// `[class*="animate-in"], [class*="animate-out"] { --tw-duration:
/// var(--duration-overlay); --tw-ease: var(--ease-out) }`, which is what makes
/// every overlay in the system run 320ms on `--ease-out` instead of the
/// library's stock 150ms `ease`.
library;

import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import '../foundation/motion.dart';
import '../foundation/shadows.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../theme_scope.dart';
import 'button.dart';
import 'icon.dart';
import 'icon_paths.dart';

/// `slide-in-from-left-10` → `--tw-enter-translate-x: calc(10 * var(--spacing)
/// * -1)` → 10 spacing units, 40px.
final double _slideDistance = ds(10);

/// `bg-background/15` on the overlay.
const double _barrierAlpha = 0.15;

/// Opens things that slide in over the page.
class DsSheet {
  const DsSheet._();

  /// Pushes a left-hand sheet and completes when it closes.
  ///
  /// [width] defaults to the docs override `w-72` — `--width-sidebar-mobile`,
  /// 288px, deliberately wider than the 256px docked sidebar because a sheet
  /// has no rail beside it competing for the eye.
  static Future<void> showLeft(
    BuildContext context, {
    required WidgetBuilder builder,
    double width = DsWidths.sidebarMobile,
    bool showCloseButton = true,
  }) {
    return Navigator.of(context).push<void>(
      _DsLeftSheetRoute(
        builder: builder,
        width: width,
        showCloseButton: showCloseButton,
      ),
    );
  }
}

/// The sliding panel itself: `bg-popover text-popover-foreground shadow-lg`
/// with a right border, full height, pinned to the left edge.
///
/// Public so a test — or a caller assembling its own route — can find and
/// measure it.
class DsSheetPanel extends StatelessWidget {
  const DsSheetPanel({
    super.key,
    required this.width,
    required this.child,
    this.showCloseButton = true,
  });

  final double width;

  final Widget child;

  /// The reference defaults this on, and `DsMobileNav` does not turn it off —
  /// so the docs sheet really does carry an X in its corner.
  final bool showCloseButton;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    return SizedBox(
      width: width,
      height: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.popover,
          border: Border(
            right: BorderSide(
              color: theme.border,
              width: DsWidths.hairline,
            ),
          ),
          boxShadow: DsShadows.tailwindLg.outerShadows(theme),
        ),
        // `w-72` is the *border* box: `box-sizing: border-box` spends one of
        // those 288 pixels on the right-hand hairline, so the panel's content
        // — and the absolutely-positioned close button, which is placed
        // against the padding box — starts one pixel in from it.
        child: Padding(
          padding: const EdgeInsets.only(right: DsWidths.hairline),
          child: DefaultTextStyle(
            style: DsText.styleOf(
              context,
              DsComponentType.sheetBody,
              color: theme.popoverForeground,
            ),
            child: SafeArea(
              child: Stack(
                children: <Widget>[
                  child,
                  if (showCloseButton)
                    Positioned(
                      // `absolute top-3 right-3`.
                      top: ds(3),
                      right: ds(3),
                      child: DsButton(
                        variant: DsButtonVariant.ghost,
                        size: DsButtonSize.iconSm,
                        label: 'Close',
                        onPressed: () => Navigator.of(context).maybePop(),
                        child: const DsIcon(DsIconGlyph.x),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DsLeftSheetRoute extends PopupRoute<void> {
  _DsLeftSheetRoute({
    required this.builder,
    required this.width,
    required this.showCloseButton,
  });

  final WidgetBuilder builder;
  final double width;
  final bool showCloseButton;

  @override
  Duration get transitionDuration => DsDurations.overlay;

  /// The same 320ms as the entrance.
  ///
  /// **Recorded decision, against the plan text.** The plan called for a
  /// faster 250ms `--ease-in-out` dismissal, on the strength of
  /// `SheetContent`'s `transition ease-in-out` class. That class is inert:
  /// Radix drives open and close with keyframe *animations*
  /// (`data-closed:animate-out`), not property transitions, and the bridge
  /// above points `animate-out` at `--duration-overlay` / `--ease-out` exactly
  /// as it points `animate-in`. Checked against
  /// `node_modules/tw-animate-css/dist/tw-animate.css`, where `--animate-out`
  /// reads `exit var(--tw-animation-duration, var(--tw-duration, .15s))
  /// var(--tw-ease, ease) …`.
  @override
  Duration get reverseTransitionDuration => DsDurations.overlay;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Close';

  /// Painted in [buildTransitions] instead, because the tint has to sit on top
  /// of a [BackdropFilter] and a plain barrier colour cannot carry one.
  @override
  Color? get barrierColor => null;

  @override
  bool get opaque => false;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Align(
      alignment: Alignment.centerLeft,
      child: DsSheetPanel(
        width: width,
        showCloseButton: showCloseButton,
        child: Builder(builder: builder),
      ),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final Animation<double> curved = CurvedAnimation(
      parent: animation,
      curve: DsCurves.out,
      // Flipped so the easing runs forward in real time on the way out, which
      // is what a CSS animation does in either direction.
      reverseCurve: DsCurves.out.flipped,
    );

    return AnimatedBuilder(
      animation: curved,
      builder: (BuildContext context, Widget? panel) {
        final double t = curved.value.clamp(0.0, 1.0);
        return Stack(
          children: <Widget>[
            // The backdrop ignores pointers so taps reach the ModalBarrier
            // underneath, which is what dismisses the sheet.
            Positioned.fill(
              child: IgnorePointer(
                child: Opacity(opacity: t, child: const _SheetBackdrop()),
              ),
            ),
            Transform.translate(
              offset: Offset(-_slideDistance * (1 - t), 0),
              child: Opacity(opacity: t, child: panel),
            ),
          ],
        );
      },
      child: child,
    );
  }
}

/// `fixed inset-0 bg-background/15 supports-backdrop-filter:backdrop-blur-xs`.
class _SheetBackdrop extends StatelessWidget {
  const _SheetBackdrop();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return BackdropFilter(
      filter: ui.ImageFilter.blur(sigmaX: DsBlurs.xs, sigmaY: DsBlurs.xs),
      child: ColoredBox(
        color: theme.background.withValues(alpha: _barrierAlpha),
      ),
    );
  }
}
