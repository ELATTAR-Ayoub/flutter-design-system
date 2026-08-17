/// `components/agent/agent-launcher.tsx` — how the agent appears on a working
/// page.
///
/// > The launcher is the agent's face rather than a button with a label on it.
/// > It is the same avatar the console header shows, at rest — which means the
/// > thing you click to start a conversation is the thing that will then talk to
/// > you, and a glance at the corner of the page tells you whether it is idle or
/// > still working on the last thing you asked. The words arrive on hover,
/// > because a circle you have never seen before needs to say what it is exactly
/// > once.
/// >
/// > It takes the console as `children` rather than constructing one. A launcher
/// > that built its own console would have to know about transports, personas
/// > and tools — all of which are the product's business, not the launcher's —
/// > and every product would then fork it. This way the entrance is system-owned
/// > and what it opens is not.
///
/// ## PROBE CORRECTION — the label does not slide
///
/// The class list reads
/// `duration-base ease-out-flex transition-[opacity,transform]` with
/// `translate-x-2` at rest and `group-hover:translate-x-0`, which transcribes as
/// *"opacity and position ride out together over 250ms"*. **They do not.**
/// Tailwind v4 compiles `translate-x-2` to the standalone `translate` property,
/// and `translate` is not in `transition-property` — which is the audit's own
/// §5 finding one component over. Traced with a real `page.mouse.move` onto the
/// launcher:
///
/// | Δ from `pointerover` | `translate` | `opacity` |
/// |---|---|---|
/// | −1 | `8px` | 0 |
/// | **+1** | **`0px`** ← snap, one frame | 0 |
/// | +14 | `0px` | 0.328 |
/// | +160 | `0px` | 0.937 |
/// | **+248** | `0px` | **1.000** ← settled |
///
/// So: the label **jumps 8px left on the first hover frame** and then fades in
/// over 250ms on `--ease-out-flex` (measured
/// `cubic-bezier(0.05, 0.6, 0.4, 0.9)`; the 0.328 at Δ14 is that curve to three
/// decimals). `duration-base` is *not* a no-op here — the utility resolves and
/// 250ms is what runs — but it only ever governed one of the two properties
/// named beside it. [DsAgentLauncher] reproduces the snap.
///
/// The button's own `hover:border-agent/50` springs the way every `DsButton`
/// border does — measured overshooting to L 0.894 at Δ160 and settling at
/// L 0.802 α 0.5 by Δ248, the `--ease-spring` signature. See the GAP CLOSED
/// note below for what it took to paint it.
///
/// ## Measured geometry
///
/// | thing | measured |
/// |---|---|
/// | button | `size-16` = **64×64**, `rounded-pill`, `right-6 bottom-6`, `z-40`, `shadow-e3` |
/// | face | `CubeAvatar size="md"` — 48px inside the 64px pill |
/// | label | `.type-chip`, `px-3 py-2`, `rounded-pill`, `bg-card`, `shadow-e2`; **31.8** tall |
/// | label seat | `right-full mr-3` → its right edge is 12px left of the button's padding box, plus the 8px rest translate |
/// | dialog | `78vw` = **1123.19** at 1440, floored at `--width-console-min` (60vw = 864) and capped at `--width-console` (80rem = **1280**) |
/// | dialog height | `min(88vh, 52rem)` = **792** at 900 |
/// | dialog chrome | `rounded-xl` (16), `p-0`, `gap-0`, `overflow-hidden`, `shadow-e4` under the dialog's own `ring-1 ring-foreground/10` |
///
/// GAP CLOSED — `hover:border-agent/50` is painted. It was not: [DsButtonSurface]
/// had `fill` / `hoverFill` / `border` / `ink` / `hoverInk` and **no
/// `hoverBorder`**, `button.dart` belonged to another lane, and the fix was
/// reported as one field rather than forked into this file. The field landed
/// (it is what the welcome card's capability chips wanted too), and this call
/// site now passes [DsAgentLauncher.hoverRimAlpha] of `--agent` through it. The
/// measured signature above is what it plays back: the border colour was
/// already carried on `btn-spring`'s clock, so the spring came for free and
/// only the value was missing.
library;

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../foundation/motion.dart';
import '../foundation/shadows.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../theme_scope.dart';
import 'agent_core.dart';
import 'agent_face.dart';
import 'button.dart';
import 'dialog.dart';

/// `AgentLauncher`.
class DsAgentLauncher extends StatefulWidget {
  const DsAgentLauncher({
    super.key,
    required this.label,
    required this.title,
    required this.description,
    required this.child,
    this.avatar,
  });

  /// *"Rides out of the button on hover, and is the button's accessible name."*
  final String label;

  /// *"Announced when the dialog opens. Not painted — the console owns its own
  /// header."*
  final String title;
  final String description;

  /// *"The console. Anything, really — the launcher only supplies the shell."*
  final Widget child;

  /// The face on the button. Null takes [DsAgentAvatarRegistry.renderer], the
  /// same default the console header uses — which is the whole point: *"the
  /// thing you click is the thing that then talks to you."*
  final DsAgentAvatarBuilder? avatar;

  /// `size-16`.
  static double get size => ds(16);

  /// `right-6 bottom-6`.
  static double get inset => ds(6);

  /// `mr-3` between the label and the button.
  static double get labelGap => ds(3);

  /// `translate-x-2` at rest — **and it snaps**, see the probe correction.
  static double get labelRest => ds(2);

  /// `px-3 py-2` on the label.
  static EdgeInsets get labelPadding =>
      EdgeInsets.symmetric(horizontal: ds(3), vertical: ds(2));

  /// `hover:border-agent/50` on the pill — see the library note's GAP CLOSED.
  static const double hoverRimAlpha = 0.50;

  /// `width: 78vw`.
  static const double dialogViewportFraction = 0.78;

  /// `min-width: var(--width-console-min)` — `60vw`.
  static const double dialogMinFraction = 0.60;

  /// `max-width: var(--width-console)` — `80rem`.
  static double get dialogMaxWidth => ds(320);

  /// `h-[min(88vh,52rem)]`.
  static const double dialogHeightFraction = 0.88;
  static double get dialogMaxHeight => ds(208);

  /// The resolved dialog box for a viewport of [viewport].
  ///
  /// Stated as a function rather than as three constants because all five
  /// numbers are viewport-relative and the page test pins the result, not the
  /// inputs. At 1440×900 this is **1123.19 × 792**.
  ///
  /// **The order is CSS's, and it is not a clamp.** The used width is
  /// `max(min-width, min(max-width, width))` — `min-width` is applied *after*
  /// `max-width` and therefore beats it. Both bounds here are viewport-relative
  /// against a fixed `80rem` cap, so the consequence is real and reachable:
  /// past ~2133px of viewport, `60vw` exceeds `80rem` and **the cap stops
  /// binding** — a 2400px window gets a 1440px dialog, not a 1280px one. A
  /// naive `clamp(min, max)` throws there rather than reproducing it.
  ///
  /// USER-ORDERED MOBILE ADAPTATION — and the `min-width` is exactly why the
  /// clamp has to be applied here rather than left to the modal host. `60vw`
  /// is a *floor*, so on a phone the CSS keeps the dialog at 88vh tall however
  /// small the screen gets: at 375x812 the spec above resolves to 292.5 x
  /// 714.6, and 714.6 is 88% of the viewport with nothing left for the scrim.
  /// [DsModalCompact.clampSize] takes the last word — 292.5 x 609 — and the
  /// host's identical box then binds nothing. Above the breakpoint the clamp
  /// is the identity and every measured number here is unchanged.
  static Size dialogSize(Size viewport) {
    final double width = viewport.width * dialogViewportFraction;
    final double capped = math.min(width, dialogMaxWidth);
    return DsModalCompact.clampSize(
      Size(
        math.max(viewport.width * dialogMinFraction, capped),
        // `h-[min(88vh,52rem)]` — a plain `min()`, both arms non-negative.
        math.min(viewport.height * dialogHeightFraction, dialogMaxHeight),
      ),
      viewport,
    );
  }

  @override
  State<DsAgentLauncher> createState() => _DsAgentLauncherState();
}

class _DsAgentLauncherState extends State<DsAgentLauncher> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return DsModalPortal(
      alignment: Alignment.center,
      // `fixed right-6 bottom-6 z-40` — the trigger occupies **no layout box at
      // all**, and the control it draws is pinned to the viewport. That is not
      // a detail: the launcher section on the console page measures 404.8 tall
      // with a 224px panel in it, and a launcher that took part in layout would
      // push it.
      trigger: (BuildContext context, VoidCallback open) => _Fixed(
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _Label(text: widget.label, shown: _hovered),
              _button(context, open),
            ],
          ),
        ),
      ),
      transition: (
        BuildContext context,
        Animation<double> animation,
        Widget child,
      ) =>
          DsJellyTransition(animation: animation, child: child),
      content: (BuildContext context, VoidCallback close) => _Dialog(
        title: widget.title,
        description: widget.description,
        child: widget.child,
      ),
    );
  }

  Widget _button(BuildContext context, VoidCallback open) {
    // *"`Button variant="outline"` supplies the surface, the hairline, the
    // pill, the press feel and the focus ring. What is overridden is only what
    // makes this a launcher rather than a button in a row: it is fixed to the
    // viewport, it is larger than any size on the ladder, and it carries a face
    // instead of a label."*
    //
    // …and one colour: `hover:border-agent/50`, which is the whole of what the
    // gap was. The resting rim is still the outline variant's own.
    final DsThemeData theme = DsTheme.of(context);
    return SizedBox.square(
      dimension: DsAgentLauncher.size,
      child: DsButton(
        variant: DsButtonVariant.outline,
        size: DsButtonSize.iconLg,
        padding: EdgeInsets.zero,
        radius: BorderRadius.circular(DsRadii.pill),
        surface: DsButtonSurface(
          hoverBorder:
              theme.agent.withValues(alpha: DsAgentLauncher.hoverRimAlpha),
        ),
        label: widget.label,
        onPressed: open,
        child: DsAgentFace(
          state: DsAgentState.idle,
          avatar: widget.avatar,
        ),
      ),
    );
  }
}

/// `position: fixed`, as a Flutter widget.
///
/// An [OverlayPortal] that is shown for as long as the launcher is mounted and
/// draws its child into the nearest [Overlay] — which is the viewport. The
/// widget itself measures zero, exactly as a `fixed` element is out of flow.
class _Fixed extends StatefulWidget {
  const _Fixed({required this.child});

  final Widget child;

  @override
  State<_Fixed> createState() => _FixedState();
}

class _FixedState extends State<_Fixed> {
  final OverlayPortalController _portal = OverlayPortalController();

  @override
  void initState() {
    super.initState();
    _portal.show();
  }

  @override
  Widget build(BuildContext context) => OverlayPortal(
        controller: _portal,
        overlayChildBuilder: (BuildContext context) => Positioned(
          right: DsAgentLauncher.inset,
          bottom: DsAgentLauncher.inset,
          child: widget.child,
        ),
        child: const SizedBox.shrink(),
      );
}

/// *"The label rides out of the button on hover rather than floating over the
/// page as a tooltip: it belongs to the control, and a tooltip that covers the
/// content behind it defeats the point of a launcher that sits on top of a
/// working page. `pointer-events-none` keeps it from eating the hover it was
/// summoned by."*
class _Label extends StatelessWidget {
  const _Label({required this.text, required this.shown});

  final String text;
  final bool shown;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return IgnorePointer(
      child: Padding(
        padding: EdgeInsets.only(right: DsAgentLauncher.labelGap),
        // The snap: `translate` is not in the transition list, so the 8px
        // offset is gone on the first hover frame while the fade is still at 0.
        child: Transform.translate(
          offset: Offset(shown ? 0 : DsAgentLauncher.labelRest, 0),
          child: AnimatedOpacity(
            opacity: shown ? 1 : 0,
            duration: dsAnimationDuration(context, DsDurations.base),
            curve: DsCurves.outFlex,
            child: Container(
              padding: DsAgentLauncher.labelPadding,
              decoration: BoxDecoration(
                color: theme.card,
                borderRadius: BorderRadius.circular(DsRadii.pill),
                border: Border.all(
                  color: theme.border,
                  width: DsWidths.hairline,
                ),
                boxShadow: DsShadows.e2.outerShadows(theme),
              ),
              child: DsText(
                text,
                DsType.chip,
                color: theme.foreground,
                maxLines: 1,
                softWrap: false,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// `DialogContent` — but none of `dialog.dart`'s own, because every number on
/// it is overridden.
///
/// *"Wide. The transcript carries tables, charts and screenshots, and at a
/// reading column those wrap into uselessness — this is a workspace, not a
/// message thread. Capped so it does not stretch past a comfortable line length
/// on an ultrawide."*
///
/// *"Set inline rather than as utilities because the dialog's own `sm:max-w-*`
/// would otherwise win on every screen this actually runs on… The cap still
/// comes from the system — an inline style is a specificity decision, not a
/// licence to invent a width."*
class _Dialog extends StatelessWidget {
  const _Dialog({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final Size box = DsAgentLauncher.dialogSize(MediaQuery.sizeOf(context));

    return Semantics(
      // `<DialogTitle className="sr-only">` and its description: announced,
      // never painted.
      label: '$title. $description',
      container: true,
      child: Container(
        width: box.width,
        height: box.height,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: theme.popover,
          borderRadius: BorderRadius.circular(DsRadii.xl),
          boxShadow: <BoxShadow>[
            ...DsDialogContent.ringSpec.outerShadows(theme),
            ...DsShadows.e4.outerShadows(theme),
          ],
        ),
        child: child,
      ),
    );
  }
}
