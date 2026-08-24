/// `components/ui/sheet.tsx`, left side only — the mobile navigation drawer.
///
/// Below `lg`, `ElMobileNav` swaps the 240px sidebar for a burger that opens
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
import 'dialog.dart';
import 'safe_area.dart';
import 'icon.dart';
import 'icon_paths.dart';

/// `slide-in-from-left-10` → `--tw-enter-translate-x: calc(.1 * 100%)`.
///
/// **CORRECTED, and the correction is measured.** This shipped as `el(10)` —
/// 40px — on the reading that tw-animate-css's `slide-in-from-*-<n>` is a
/// spacing-unit utility. It is not: the installed build resolves the `10` as a
/// **percentage of the element's own border box**, and the computed variable
/// reads `calc(.1*100%)` on the live sheet. Traced on the dialogs page's
/// right-hand sheet (2026-08-16), the first frame of `enter` is
/// `matrix(1, 0, 0, 1, 38.4, 0)` against a 384px panel — 10% exactly — and the
/// last frame of `exit` returns to the same 38.4.
///
/// So the distance is a *fraction*, and the docs sheet (288 wide) travels
/// **28.8px**, not 40. Both the mobile-nav route below and [ElSheetContent]
/// read it from here.
const double _slideFraction = 0.1;

/// `bg-background/15` on the overlay.
const double _barrierAlpha = 0.15;

/// Opens things that slide in over the page.
class ElSheet {
  const ElSheet._();

  /// Pushes a left-hand sheet and completes when it closes.
  ///
  /// [width] defaults to the docs override `w-72` — `--width-sidebar-mobile`,
  /// 288px, deliberately wider than the 256px docked sidebar because a sheet
  /// has no rail beside it competing for the eye.
  static Future<void> showLeft(
    BuildContext context, {
    required WidgetBuilder builder,
    double width = ElWidths.sidebarMobile,
    bool showCloseButton = true,
  }) {
    return Navigator.of(context).push<void>(
      _ElLeftSheetRoute(
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
class ElSheetPanel extends StatelessWidget {
  const ElSheetPanel({
    super.key,
    required this.width,
    required this.child,
    this.showCloseButton = true,
  });

  final double width;

  final Widget child;

  /// The reference defaults this on, and `ElMobileNav` does not turn it off —
  /// so the docs sheet really does carry an X in its corner.
  final bool showCloseButton;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);

    return SizedBox(
      width: width,
      height: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.popover,
          border: Border(
            right: BorderSide(color: theme.border, width: ElWidths.hairline),
          ),
          boxShadow: ElShadows.tailwindLg.outerShadows(theme),
        ),
        // `w-72` is the *border* box: `box-sizing: border-box` spends one of
        // those 288 pixels on the right-hand hairline, so the panel's content
        // — and the absolutely-positioned close button, which is placed
        // against the padding box — starts one pixel in from it.
        child: Padding(
          padding: const EdgeInsets.only(right: ElWidths.hairline),
          child: DefaultTextStyle(
            style: ElText.styleOf(
              context,
              ElComponentType.sheetBody,
              color: theme.popoverForeground,
            ),
            child: ElSafeArea(
              child: Stack(
                children: <Widget>[
                  child,
                  if (showCloseButton)
                    Positioned(
                      // `absolute top-3 right-3`.
                      top: el(3),
                      right: el(3),
                      child: ElButton(
                        variant: ElButtonVariant.ghost,
                        size: ElButtonSize.iconSm,
                        label: 'Close',
                        onPressed: () => Navigator.of(context).maybePop(),
                        child: const ElIcon(ElIconGlyph.x),
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

class _ElLeftSheetRoute extends PopupRoute<void> {
  _ElLeftSheetRoute({
    required this.builder,
    required this.width,
    required this.showCloseButton,
  });

  final WidgetBuilder builder;
  final double width;
  final bool showCloseButton;

  @override
  Duration get transitionDuration => ElDurations.overlay;

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
  Duration get reverseTransitionDuration => ElDurations.overlay;

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
      child: ElSheetPanel(
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
      curve: ElCurves.out,
      // Flipped so the easing runs forward in real time on the way out, which
      // is what a CSS animation does in either direction.
      reverseCurve: ElCurves.out.flipped,
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
    final ElThemeData theme = ElTheme.of(context);
    return BackdropFilter(
      filter: ui.ImageFilter.blur(sigmaX: ElBlurs.xs, sigmaY: ElBlurs.xs),
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
// than a route (see `ElModalPortal`'s doc for why a route cannot be used).
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
enum ElSheetSide {
  top,
  right,
  bottom,
  left;

  /// True for [left] and [right] — the sides whose panel is sized by width.
  bool get isHorizontal =>
      this == ElSheetSide.left || this == ElSheetSide.right;
}

/// `Sheet` — trigger, portal, overlay, panel.
///
/// Named with the `Panel` suffix free: [ElSheet] above is the mobile nav's
/// static opener and keeps its name, because `example/lib/shell.dart` calls it
/// and the shell is not this family's file.
class ElSheetOverlay extends StatelessWidget {
  const ElSheetOverlay({
    super.key,
    required this.trigger,
    required this.content,
    this.side = ElSheetSide.right,
  });

  final ElModalTriggerBuilder trigger;
  final ElModalContentBuilder content;

  /// `side="right"` is the component's own default.
  final ElSheetSide side;

  Alignment get _alignment => switch (side) {
    ElSheetSide.top => Alignment.topCenter,
    ElSheetSide.right => Alignment.centerRight,
    ElSheetSide.bottom => Alignment.bottomCenter,
    ElSheetSide.left => Alignment.centerLeft,
  };

  @override
  Widget build(BuildContext context) => ElModalPortal(
    trigger: trigger,
    content: content,
    alignment: _alignment,
    // USER-ORDERED MOBILE ADAPTATION — out of the host's 90vw x 75vh box,
    // and [ElSheetContent] clamps its own width instead. A side sheet is
    // full-height by definition — that is the whole difference between a
    // sheet and a dialog — so a 75vh cap would crop the one dimension the
    // component exists to fill. What it *does* need on a phone is the
    // width: `sm:max-w-sm` is 384 against a 375px viewport, which is the
    // same overflow the dialog had. See [ElSheetContent.width].
    clampToViewport: false,
    // The sheet's own clock, both ways: `--duration-overlay`.
    enterDuration: ElDurations.overlay,
    exitDuration: ElDurations.overlay,
    transition:
        (BuildContext context, Animation<double> animation, Widget child) =>
            ElSheetTransition(animation: animation, side: side, child: child),
  );
}

/// `fade-in-0` + `slide-in-from-<side>-10`, and the exit twin the class list
/// spells out.
class ElSheetTransition extends StatelessWidget {
  const ElSheetTransition({
    super.key,
    required this.animation,
    required this.side,
    required this.child,
  });

  final Animation<double> animation;
  final ElSheetSide side;
  final Widget child;

  /// The travel, as a fraction of the panel's own size on the axis it enters
  /// along — see [_slideFraction].
  static double get fraction => _slideFraction;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: animation,
    child: child,
    builder: (BuildContext context, Widget? child) {
      final double t = ElCurves.out.transform(animation.value.clamp(0, 1));
      final double travel = (1 - t) * _slideFraction;
      final Offset unit = switch (side) {
        ElSheetSide.left => Offset(-travel, 0),
        ElSheetSide.right => Offset(travel, 0),
        ElSheetSide.top => Offset(0, -travel),
        ElSheetSide.bottom => Offset(0, travel),
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
class ElSheetContent extends StatelessWidget {
  const ElSheetContent({
    super.key,
    required this.children,
    this.side = ElSheetSide.right,
    this.showCloseButton = true,
    this.onClose,
    this.width,
    this.fill,
  });

  /// The `flex flex-col gap-4` column. A [ElSheetFooter] takes `mt-auto` and is
  /// pushed to the bottom.
  final List<Widget> children;

  final ElSheetSide side;

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
  static double get maxWidth => ElContainers.sm;

  /// `gap-4`.
  static double get gap => el(4);

  /// USER-ORDERED MOBILE ADAPTATION — the panel width for [viewport].
  ///
  /// [maxWidth] (or the [width] override) everywhere the reference was
  /// measured, and [ElModalCompact.maxWidthFraction] of the viewport once
  /// compact — 384 does not fit a 375px phone, and a panel wider than the
  /// screen has no scrim left to tap.
  ///
  /// The reference reaches the same place by another road: `SheetContent`'s
  /// base is `w-3/4` and only `sm:max-w-sm` pins it to 384, so below 640 the
  /// live component is already a fraction of the viewport. The port renders
  /// the `sm:` branch (see the header table), and this is the clamp that keeps
  /// that decision from running off a phone.
  static double widthFor(double width, Size viewport) =>
      ElModalCompact.clampWidth(width, viewport);

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final BorderSide edge = BorderSide(
      color: theme.border,
      width: ElWidths.hairline,
    );

    final List<Widget> rows = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      final Widget child = children[i];
      if (i > 0) {
        // `mt-auto` on the footer: the automatic margin eats the slack, and the
        // 16px gap is paid on top of it.
        if (child is ElSheetFooter) rows.add(const Spacer());
        rows.add(SizedBox(height: gap));
      }
      rows.add(child);
    }

    return ElSheetContentGroup(
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
              ElSheetSide.left => Border(right: edge),
              ElSheetSide.right => Border(left: edge),
              ElSheetSide.top => Border(bottom: edge),
              ElSheetSide.bottom => Border(top: edge),
            },
            boxShadow: ElShadows.tailwindLg.outerShadows(theme),
          ),
          child: Padding(
            // `box-sizing: border-box` — the border is paid out of the 384.
            padding: switch (side) {
              ElSheetSide.left => EdgeInsets.only(right: ElWidths.hairline),
              ElSheetSide.right => EdgeInsets.only(left: ElWidths.hairline),
              ElSheetSide.top => EdgeInsets.only(bottom: ElWidths.hairline),
              ElSheetSide.bottom => EdgeInsets.only(top: ElWidths.hairline),
            },
            child: DefaultTextStyle(
              style: ElText.styleOf(
                context,
                ElComponentType.sheetBody,
                color: theme.popoverForeground,
              ),
              child: ElSafeArea(
                top: side != ElSheetSide.bottom,
                bottom: side != ElSheetSide.top,
                child: Stack(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: rows,
                    ),
                    if (showCloseButton)
                      Positioned(
                        // `absolute top-3 right-3`.
                        top: el(3),
                        right: el(3),
                        child: ElButton(
                          variant: ElButtonVariant.ghost,
                          size: ElButtonSize.iconSm,
                          label: 'Close',
                          onPressed: onClose,
                          child: const ElIcon(ElIconGlyph.x),
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
class ElSheetContentGroup extends InheritedWidget {
  const ElSheetContentGroup({
    super.key,
    required this.showCloseButton,
    required super.child,
  });

  final bool showCloseButton;

  static ElSheetContentGroup? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ElSheetContentGroup>();

  @override
  bool updateShouldNotify(ElSheetContentGroup old) =>
      old.showCloseButton != showCloseButton;
}

/// `SheetHeader` — *"the same three-zone banding as Dialog: a muted header, a
/// lit body, a muted footer. A sheet is usually taller and scrollier than a
/// dialog, so the rules do more work here — they are what keeps the title and
/// the CTAs anchored while the middle moves."*
///
/// *"No negative margins, unlike Dialog: `SheetContent` carries no padding of
/// its own, so the bands already reach the edges."*
class ElSheetHeader extends StatelessWidget {
  const ElSheetHeader({super.key, required this.children});

  /// `flex flex-col gap-0.5`.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final bool close =
        ElSheetContentGroup.maybeOf(context)?.showCloseButton ?? true;
    // [Container] pays for the rule out of the band's own box.
    return Container(
      decoration: BoxDecoration(
        color: theme.muted.withValues(alpha: _bandAlpha),
        border: Border(
          bottom: BorderSide(color: theme.border, width: ElWidths.hairline),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          el(4),
          el(4),
          close ? el(12) : el(4),
          el(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (int i = 0; i < children.length; i++) ...<Widget>[
              if (i > 0) SizedBox(height: el(0.5)),
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
class ElSheetFooter extends StatelessWidget {
  const ElSheetFooter({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.muted.withValues(alpha: _bandAlpha),
        border: Border(
          top: BorderSide(color: theme.border, width: ElWidths.hairline),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(el(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (int i = 0; i < children.length; i++) ...<Widget>[
              if (i > 0) SizedBox(height: el(2)),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}

/// `SheetTitle` — `font-heading text-base font-medium text-foreground`.
class ElSheetTitle extends StatelessWidget {
  const ElSheetTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => ElText(
    text,
    ElComponentType.overlayTitle,
    color: ElTheme.of(context).foreground,
  );
}

/// `SheetDescription` — `text-sm text-muted-foreground`.
class ElSheetDescription extends StatelessWidget {
  const ElSheetDescription(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => ElText(
    text,
    ElComponentType.sheetBody,
    color: ElTheme.of(context).mutedForeground,
  );
}
