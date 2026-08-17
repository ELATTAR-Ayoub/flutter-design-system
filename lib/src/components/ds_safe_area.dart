/// The system-bar contract — **a user-ordered mobile adaptation, not a port.**
///
/// Ordered 2026-08-16, after screenshots showed the docs header sitting behind
/// the phone's clock and the reading column running under the gesture bar. The
/// reference has no counterpart to reproduce: a desktop browser has no status
/// bar, and the one CSS spelling of this idea — `env(safe-area-inset-*)` —
/// appears nowhere in `app/globals.css`. So this file is written to the ruling
/// rather than to a source line, and the ruling is one sentence:
///
/// > **Backgrounds paint edge-to-edge; content and interactive chrome respect
/// > [MediaQueryData.padding].**
///
/// That split is the whole design. Letterboxing the app inside one big
/// [SafeArea] would satisfy "nothing collides" by throwing away the thing the
/// aesthetic is built on — the page glow bleeding off every edge, a translucent
/// header the status bar's own pixels blur through. So nothing here insets a
/// *painted* box. The bar keeps its full-bleed decoration and grows by the
/// inset ([topBarHeightOf]); the row of controls inside it moves down
/// ([DsSafeArea]); a scroll view keeps scrolling under both bars and pays the
/// bottom one at the end of its content ([scrollPaddingOf]).
///
/// ## Which inset is whose
///
/// [MediaQueryData] carries three insets and they are not interchangeable:
///
///  * **`padding`** — the status bar, the notch, the gesture/navigation bar.
///    Obstructions that are *always* there. This file owns it, and it is the
///    only one anything below reads.
///  * **`viewInsets`** — the software keyboard. Transient, and it belongs to
///    whatever is focused rather than to the shell; the console and composer
///    handle it at their own edge. Nothing here touches it, so the two
///    adaptations cannot double-pay for the same pixels.
///  * **`viewPadding`** — `padding` as it would be with no keyboard up. Not
///    read here either, deliberately: when the keyboard covers the gesture bar
///    the gesture bar is no longer an obstruction, and a scroll view that kept
///    reserving room for it would sit on a strip of nothing above the keyboard.
///
/// ## Why a widget rather than a rule in prose
///
/// A rule in prose is re-broken by the next screen someone writes. Consuming
/// [DsSafeArea] is how a customer app inherits the fix without knowing it
/// exists, and [insetsOf] is the one place the rule is stated for the cases a
/// widget cannot cover (a [Positioned] height, a scroll view's padding).
///
/// ## Desktop is untouched, by construction
///
/// Every entry point short-circuits when the inset it would apply is zero:
/// [DsSafeArea] returns its child **unwrapped**, so no [Padding] and no
/// [MediaQuery] join the tree, and the geometry pins taken at 1440×900 measure
/// exactly the boxes they measured before this file existed. On a desktop, a
/// browser, or any test that does not set `view.padding`, this whole file is a
/// no-op — which is what makes it safe to put on every surface.
library;

import 'package:flutter/widgets.dart';

/// Pads [child] out of the system bars without insetting anything painted
/// around it.
///
/// The framework's own [SafeArea] does the same arithmetic; this exists beside
/// it because the design system needs the rule *named* — a reviewer can grep
/// one symbol and see every surface that has thought about the problem — and
/// because of the zero short-circuit described in the library note, which keeps
/// the desktop tree byte-identical rather than one [Padding] deeper.
///
/// Like [SafeArea], it removes the insets it spends from the [MediaQuery] it
/// hands down, so nesting is safe: a [DsSafeArea] inside a sheet that already
/// paid the bottom bar reads zero and adds nothing.
///
/// ```dart
/// DecoratedBox(                       // paints to the screen edge
///   decoration: const BoxDecoration(/* … */),
///   child: DsSafeArea(bottom: false, child: Row(children: controls)),
/// )
/// ```
class DsSafeArea extends StatelessWidget {
  const DsSafeArea({
    super.key,
    this.left = true,
    this.top = true,
    this.right = true,
    this.bottom = true,
    required this.child,
  });

  /// Pay the left inset — a notch or a rounded corner in landscape.
  final bool left;

  /// Pay the top inset — the status bar.
  final bool top;

  /// Pay the right inset.
  final bool right;

  /// Pay the bottom inset — the gesture pill or the navigation bar.
  final bool bottom;

  /// What gets moved. Whatever paints *around* this widget does not.
  final Widget child;

  /// The system bars' insets in [context] — the one reading of the rule.
  ///
  /// [MediaQueryData.padding], never `viewInsets`: see the library note for why
  /// the keyboard is somebody else's inset. Returns [EdgeInsets.zero] where
  /// there is no [MediaQuery] at all, because a widget with no viewport has no
  /// bars either.
  static EdgeInsets insetsOf(BuildContext context) =>
      MediaQuery.maybePaddingOf(context) ?? EdgeInsets.zero;

  /// The height a bar pinned to the **top** of the window has to reserve to
  /// render [height] of content below the status bar.
  ///
  /// The bar keeps painting across the whole of it — that is the point of
  /// spending the inset here rather than moving the bar down — so the caller
  /// pairs this with a `DsSafeArea(bottom: false)` around the bar's contents,
  /// and with the same number as the top padding of whatever scrolls under it.
  static double topBarHeightOf(BuildContext context, double height) =>
      height + insetsOf(context).top;

  /// [base] plus what a scroll view owes the bars it scrolls under.
  ///
  /// The bottom inset and both horizontal ones are added to [base]; the top is
  /// not. A scroll view is not inset out of the top bar — it scrolls *beneath*
  /// it, and the room it leaves for it is the bar's own height, which is
  /// [topBarHeightOf] and belongs in [base].
  ///
  /// This is padding on the viewport, so it is scrollable content rather than a
  /// dead margin: the last card can still be dragged clear of the gesture bar,
  /// and it comes to rest above it.
  static EdgeInsets scrollPaddingOf(
    BuildContext context, {
    EdgeInsets base = EdgeInsets.zero,
  }) {
    final EdgeInsets bars = insetsOf(context);
    return base +
        EdgeInsets.only(
          left: bars.left,
          right: bars.right,
          bottom: bars.bottom,
        );
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets bars = insetsOf(context);
    final EdgeInsets spend = EdgeInsets.only(
      left: left ? bars.left : 0,
      top: top ? bars.top : 0,
      right: right ? bars.right : 0,
      bottom: bottom ? bars.bottom : 0,
    );
    // The desktop path, and the reason the pins stay green: nothing is added to
    // the tree at all when there is nothing to pay.
    if (spend == EdgeInsets.zero) return child;

    return MediaQuery.removePadding(
      context: context,
      removeLeft: left,
      removeTop: top,
      removeRight: right,
      removeBottom: bottom,
      child: Padding(padding: spend, child: child),
    );
  }
}
