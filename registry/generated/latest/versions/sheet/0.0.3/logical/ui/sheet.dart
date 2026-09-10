/// `components/ui/sheet.tsx`, left side only — the mobile navigation drawer.
///
/// Below `lg`, `MobileNav` swaps the 240px sidebar for a burger that opens
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

import '../../design_system/foundation/motion.dart';
import '../../design_system/foundation/shadows.dart';
import '../../design_system/foundation/spacing.dart';
import '../../design_system/foundation/theme.dart';
import '../../design_system/foundation/typography.dart';
import '../../design_system/foundation/theme_scope.dart';
import './button.dart';
import './dialog.dart';
import './safe_area.dart';
import './icon.dart';
import './icon_paths.dart';

/// `slide-in-from-left-10` → `--tw-enter-translate-x: calc(.1 * 100%)`.
///
/// **CORRECTED, and the correction is measured.** This shipped as `space(10)` —
/// 40px — on the reading that tw-animate-css's `slide-in-from-*-<n>` is a
/// spacing-unit utility. It is not: the installed build resolves the `10` as a
/// **percentage of the element's own border box**, and the computed variable
/// reads `calc(.1*100%)` on the live sheet. Traced on the dialogs page's
/// right-hand sheet (2026-08-16), the first frame of `enter` is
/// `matrix(1, 0, 0, 1, 38.4, 0)` against a 384px panel — 10% exactly — and the
/// last frame of `exit` returns to the same 38.4.
///
/// So the distance is a *fraction*, and the docs sheet (288 wide) travels
/// **28.8px**, not 40. Both the mobile-nav route below and [SheetContent]
/// read it from here.
const double _slideFraction = 0.1;

/// `bg-background/15` on the overlay.
const double _barrierAlpha = 0.15;

/// Opens things that slide in over the page.
class Sheet {
  const Sheet._();

  /// Pushes a left-hand sheet and completes when it closes.
  ///
  /// [width] defaults to the docs override `w-72` — `--width-sidebar-mobile`,
  /// 288px, deliberately wider than the 256px docked sidebar because a sheet
  /// has no rail beside it competing for the eye.
  static Future<void> showLeft(
    BuildContext context, {
    required WidgetBuilder builder,
    double width = LayoutWidths.sidebarMobile,
    bool showCloseButton = true,
  }) {
    return Navigator.of(context).push<void>(
      _LeftSheetRoute(
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
class SheetPanel extends StatelessWidget {
  const SheetPanel({
    super.key,
    required this.width,
    required this.child,
    this.showCloseButton = true,
  });

  final double width;

  final Widget child;

  /// The reference defaults this on, and `MobileNav` does not turn it off —
  /// so the docs sheet really does carry an X in its corner.
  final bool showCloseButton;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return SizedBox(
      width: width,
      height: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.popover,
          border: Border(
            right: BorderSide(
              color: theme.border,
              width: BorderWidths.hairline,
            ),
          ),
          boxShadow: Shadows.overlay.outerShadows(theme),
        ),
        // `w-72` is the *border* box: `box-sizing: border-box` spends one of
        // those 288 pixels on the right-hand hairline, so the panel's content
        // — and the absolutely-positioned close button, which is placed
        // against the padding box — starts one pixel in from it.
        child: Padding(
          padding: const EdgeInsets.only(right: BorderWidths.hairline),
          child: DefaultTextStyle(
            style: StyledText.styleOf(
              context,
              TextStyles.body,
              color: theme.popoverForeground,
            ),
            child: SafeArea(
              child: Stack(
                children: <Widget>[
                  child,
                  if (showCloseButton)
                    Positioned(
                      // `absolute top-3 right-3`.
                      top: space(3),
                      right: space(3),
                      child: Button(
                        variant: ButtonVariant.ghost,
                        size: ButtonSize.iconSm,
                        label: 'Close',
                        onPressed: () => Navigator.of(context).maybePop(),
                        child: const Icon(IconGlyph.x),
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

class _LeftSheetRoute extends PopupRoute<void> {
  _LeftSheetRoute({
    required this.builder,
    required this.width,
    required this.showCloseButton,
  });

  final WidgetBuilder builder;
  final double width;
  final bool showCloseButton;

  @override
  Duration get transitionDuration => MotionDurations.overlayEnter;

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
  Duration get reverseTransitionDuration => MotionDurations.overlayExit;

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
      child: SheetPanel(
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
      curve: MotionCurves.enter,
      // Flipped so the easing runs forward in real time on the way out, which
      // is what a CSS animation does in either direction.
      reverseCurve: MotionCurves.enter.flipped,
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
              offset: Offset(-width * _slideFraction * (1 - t), 0),
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
    final ThemeTokens theme = ThemeScope.of(context);
    return BackdropFilter(
      filter: ui.ImageFilter.blur(sigmaX: Blurs.xs, sigmaY: Blurs.xs),
      child: ColoredBox(
        color: theme.background.withValues(alpha: _barrierAlpha),
      ),
    );
  }
}

/* ── The full component ──────────────────────────────────────────────────── */
//
// Everything above is the mobile navigation drawer: one route, one side, one
// caller. Everything below is `components/ui/sheet.tsx` as the dialogs page
// renders it — the four sides, the three-zone banding, and a portal rather
// than a route (see `OverlayPortal`'s doc for why a route cannot be used).
//
// Measured open on `/design-system/components/base/dialogs` (2026-08-16,
// 1440x900), left and right:
//
// | part | measured |
// |---|---|
// | panel | `w-3/4 sm:max-w-sm` — **384** — full height, `--popover` fill, one 1px border on the inner edge, Tailwind `shadow-lg` |
// | column | `flex flex-col gap-4` |
// | header | 383 wide inside the border, `p-4` with `pr-12` for the close button, `gap-0.5`, `--muted`/50, 1px bottom rule |
// | footer | `mt-auto` — measured 458.94px of automatic margin on top of the 16px gap — `p-4`, `gap-2`, `--muted`/50, 1px top rule |
// | enter | `animate-in fade-in-0 slide-in-from-right-10` over 320ms on `--ease-out` |
// | exit | `animate-out fade-out-0 slide-out-to-right-10` — the one overlay whose exit really does slide, because the class list writes the twin |
//
// `transition ease-in-out` on `SheetContent` is inert and stays that way. Its
// property list was probed and it does carry `transform`, `translate`, `scale`
// and `rotate` — but open and close are keyframe *animations*, so there is
// nothing for the transition to interpolate. Recorded because the standing
// rule is that a standalone-transform transition ships only when the expanded
// list carries it: here the list does, and the transition still never runs.

/// `bg-muted/50` — the sheet's two chrome bands.
const double _bandAlpha = 0.5;

/// `SheetContent side` — `"top" | "right" | "bottom" | "left"`.
enum SheetSide {
  top,
  right,
  bottom,
  left;

  /// True for [left] and [right] — the sides whose panel is sized by width.
  bool get isHorizontal => this == SheetSide.left || this == SheetSide.right;
}

/// `Sheet` — trigger, portal, overlay, panel.
///
/// Named with the `Panel` suffix free: [Sheet] above is the mobile nav's
/// static opener and keeps its name, because `example/lib/shell.dart` calls it
/// and the shell is not this family's file.
class SheetOverlay extends StatelessWidget {
  const SheetOverlay({
    super.key,
    required this.trigger,
    required this.content,
    this.side = SheetSide.right,
  });

  final ModalTriggerBuilder trigger;
  final ModalContentBuilder content;

  /// `side="right"` is the component's own default.
  final SheetSide side;

  Alignment get _alignment => switch (side) {
    SheetSide.top => Alignment.topCenter,
    SheetSide.right => Alignment.centerRight,
    SheetSide.bottom => Alignment.bottomCenter,
    SheetSide.left => Alignment.centerLeft,
  };

  @override
  Widget build(BuildContext context) => OverlayPortal(
    trigger: trigger,
    content: content,
    alignment: _alignment,
    // USER-ORDERED MOBILE ADAPTATION — out of the host's 90vw x 75vh box,
    // and [SheetContent] clamps its own width instead. A side sheet is
    // full-height by definition — that is the whole difference between a
    // sheet and a dialog — so a 75vh cap would crop the one dimension the
    // component exists to fill. What it *does* need on a phone is the
    // width: `sm:max-w-sm` is 384 against a 375px viewport, which is the
    // same overflow the dialog had. See [SheetContent.width].
    clampToViewport: false,
    // The sheet's own clock, both ways: `--duration-overlay`.
    enterDuration: MotionDurations.overlayEnter,
    exitDuration: MotionDurations.overlayExit,
    transition:
        (BuildContext context, Animation<double> animation, Widget child) =>
            SheetTransition(animation: animation, side: side, child: child),
  );
}

/// `fade-in-0` + `slide-in-from-<side>-10`, and the exit twin the class list
/// spells out.
class SheetTransition extends StatelessWidget {
  const SheetTransition({
    super.key,
    required this.animation,
    required this.side,
    required this.child,
  });

  final Animation<double> animation;
  final SheetSide side;
  final Widget child;

  /// The travel, as a fraction of the panel's own size on the axis it enters
  /// along — see [_slideFraction].
  static double get fraction => _slideFraction;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: animation,
    child: child,
    builder: (BuildContext context, Widget? child) {
      final double t = MotionCurves.enter.transform(
        animation.value.clamp(0, 1),
      );
      final double travel = (1 - t) * _slideFraction;
      final Offset unit = switch (side) {
        SheetSide.left => Offset(-travel, 0),
        SheetSide.right => Offset(travel, 0),
        SheetSide.top => Offset(0, -travel),
        SheetSide.bottom => Offset(0, travel),
      };
      return Opacity(
        opacity: t,
        // A percentage translate is a fraction of the element's OWN box,
        // which is exactly what [FractionalTranslation] means and what a
        // pixel [Transform.translate] cannot say.
        child: FractionalTranslation(translation: unit, child: child),
      );
    },
  );
}

/// `SheetContent` — the panel, on one edge.
class SheetContent extends StatelessWidget {
  const SheetContent({
    super.key,
    required this.children,
    this.side = SheetSide.right,
    this.showCloseButton = true,
    this.onClose,
    this.width,
    this.fill,
  });

  /// The `flex flex-col gap-4` column. A [SheetFooter] takes `mt-auto` and is
  /// pushed to the bottom.
  final List<Widget> children;

  final SheetSide side;

  /// Overrides `sm:max-w-sm`.
  ///
  /// One consumer, and its class list explains why the override has to be
  /// *important* on the reference: `Sidebar`'s mobile branch writes
  /// `w-(--sidebar-width)!` at `--width-sidebar-mobile` (288), because
  /// `SheetContent` already sets `data-[side=left]:w-3/4` and a
  /// variant-prefixed width outranks a plain one. The file records the bug that
  /// caught: the panel rendered at 281.25 of a 375px viewport — exactly 0.75 ×
  /// 375 — with the token *declared, referenced and completely inert*.
  final double? width;

  /// Overrides `bg-popover` — the mobile sidebar's `bg-sidebar`.
  final Color? fill;

  /// Defaulted on by the reference, which is what puts `pr-12` on the header.
  final bool showCloseButton;

  final VoidCallback? onClose;

  /// `sm:max-w-sm` — 384 on both horizontal sides.
  static double get maxWidth => Containers.sm;

  /// `gap-4`.
  static double get gap => space(4);

  /// USER-ORDERED MOBILE ADAPTATION — the panel width for [viewport].
  ///
  /// [maxWidth] (or the [width] override) everywhere the reference was
  /// measured, and [CompactDialogLayout.maxWidthFraction] of the viewport once
  /// compact — 384 does not fit a 375px phone, and a panel wider than the
  /// screen has no scrim left to tap.
  ///
  /// The reference reaches the same place by another road: `SheetContent`'s
  /// base is `w-3/4` and only `sm:max-w-sm` pins it to 384, so below 640 the
  /// live component is already a fraction of the viewport. The port renders
  /// the `sm:` branch (see the header table), and this is the clamp that keeps
  /// that decision from running off a phone.
  static double widthFor(double width, Size viewport) =>
      CompactDialogLayout.clampWidth(width, viewport);

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final BorderSide edge = BorderSide(
      color: theme.border,
      width: BorderWidths.hairline,
    );

    final List<Widget> rows = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      final Widget child = children[i];
      if (i > 0) {
        // `mt-auto` on the footer: the automatic margin eats the slack, and the
        // 16px gap is paid on top of it.
        if (child is SheetFooter) rows.add(const Spacer());
        rows.add(SizedBox(height: gap));
      }
      rows.add(child);
    }

    return SheetContentGroup(
      showCloseButton: showCloseButton,
      child: SizedBox(
        width: side.isHorizontal
            ? widthFor(width ?? maxWidth, MediaQuery.sizeOf(context))
            : null,
        height: side.isHorizontal ? double.infinity : null,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: fill ?? theme.popover,
            border: switch (side) {
              SheetSide.left => Border(right: edge),
              SheetSide.right => Border(left: edge),
              SheetSide.top => Border(bottom: edge),
              SheetSide.bottom => Border(top: edge),
            },
            boxShadow: Shadows.overlay.outerShadows(theme),
          ),
          child: Padding(
            // `box-sizing: border-box` — the border is paid out of the 384.
            padding: switch (side) {
              SheetSide.left => EdgeInsets.only(right: BorderWidths.hairline),
              SheetSide.right => EdgeInsets.only(left: BorderWidths.hairline),
              SheetSide.top => EdgeInsets.only(bottom: BorderWidths.hairline),
              SheetSide.bottom => EdgeInsets.only(top: BorderWidths.hairline),
            },
            child: DefaultTextStyle(
              style: StyledText.styleOf(
                context,
                TextStyles.body,
                color: theme.popoverForeground,
              ),
              child: SafeArea(
                top: side != SheetSide.bottom,
                bottom: side != SheetSide.top,
                child: Stack(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: rows,
                    ),
                    if (showCloseButton)
                      Positioned(
                        // `absolute top-3 right-3`.
                        top: space(3),
                        right: space(3),
                        child: Button(
                          variant: ButtonVariant.ghost,
                          size: ButtonSize.iconSm,
                          label: 'Close',
                          onPressed: onClose,
                          child: const Icon(IconGlyph.x),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The `group/sheet-content` the header reads `data-close-button` off.
class SheetContentGroup extends InheritedWidget {
  const SheetContentGroup({
    super.key,
    required this.showCloseButton,
    required super.child,
  });

  final bool showCloseButton;

  static SheetContentGroup? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SheetContentGroup>();

  @override
  bool updateShouldNotify(SheetContentGroup old) =>
      old.showCloseButton != showCloseButton;
}

/// `SheetHeader` — *"the same three-zone banding as Dialog: a muted header, a
/// lit body, a muted footer. A sheet is usually taller and scrollier than a
/// dialog, so the rules do more work here — they are what keeps the title and
/// the CTAs anchored while the middle moves."*
///
/// *"No negative margins, unlike Dialog: `SheetContent` carries no padding of
/// its own, so the bands already reach the edges."*
class SheetHeader extends StatelessWidget {
  const SheetHeader({super.key, required this.children});

  /// `flex flex-col gap-0.5`.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final bool close =
        SheetContentGroup.maybeOf(context)?.showCloseButton ?? true;
    // [Container] pays for the rule out of the band's own box.
    return Container(
      decoration: BoxDecoration(
        color: theme.muted.withValues(alpha: _bandAlpha),
        border: Border(
          bottom: BorderSide(color: theme.border, width: BorderWidths.hairline),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          space(4),
          space(4),
          close ? space(12) : space(4),
          space(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (int i = 0; i < children.length; i++) ...<Widget>[
              if (i > 0) SizedBox(height: space(0.5)),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}

/// `SheetFooter` — `mt-auto flex flex-col gap-2 border-t bg-muted/50 p-4`.
///
/// A **column**, unlike the dialog's row: a sheet's CTAs stack.
class SheetFooter extends StatelessWidget {
  const SheetFooter({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.muted.withValues(alpha: _bandAlpha),
        border: Border(
          top: BorderSide(color: theme.border, width: BorderWidths.hairline),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(space(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (int i = 0; i < children.length; i++) ...<Widget>[
              if (i > 0) SizedBox(height: space(2)),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}

/// `SheetTitle` — `font-heading text-base font-medium text-foreground`.
class SheetTitle extends StatelessWidget {
  const SheetTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) =>
      StyledText(text, TextStyles.h4, color: ThemeScope.of(context).foreground);
}

/// `SheetDescription` — `text-sm text-muted-foreground`.
class SheetDescription extends StatelessWidget {
  const SheetDescription(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => StyledText(
    text,
    TextStyles.body,
    color: ThemeScope.of(context).mutedForeground,
  );
}
