/// `/design-system/motion`: the Motion foundation page.
///
/// The only foundation page with state, and the only one whose specimens are
/// clocks: a duration is not a number here, it is a bar you watch cross a
/// track. `"use client"` in the reference, `StatefulWidget` here, and the
/// state is one integer, [_MotionPageState._run].
///
/// **The replay mechanism is the page's spine** (motion-map §11). One counter,
/// three buttons, all calling the same `replay`. React remounts any element
/// whose `key` changes and a freshly mounted element starts its CSS animation
/// at t=0; [KeyedSubtree] with a `ValueKey('$name-$run')` reproduces that
/// exactly, because [KeyframePlayer] creates its controller in `initState`.
/// Sixteen elements are keyed: six duration bars, four easing chips, six of
/// the nine named demos: and the three infinite demos (ratchet, shimmer,
/// pulse-live) are deliberately not: a loop has nothing to replay. There is no
/// `replay()` API to call instead, on purpose; a broadcast `forward(from: 0)`
/// cannot express `space-sweep`'s `both` fill on a demo that has not been built.
///
/// Two mechanisms are worth naming before reading the code:
///
/// * **The player's `t` is linear.** A CSS `animation-timing-function` eases
///   between adjacent keyframes, not across the run, so the easing lives in
///   the tables ([Keyframes.track]) and never in the clock. Wrapping a
///   player in a `CurvedAnimation` would ease twice.
/// * **`animation-fill-mode` decides every reduced-motion freeze frame.** The
///   blanket `prefers-reduced-motion` rule collapses durations and iteration
///   counts and touches neither fill mode nor delay, so `both` holds the final
///   stop and the three unfilled loopers revert to stop 0 (motion-map §8.2).
///   `.anim-sign-on` therefore freezes *lit and glowing*, not neutral.
///
/// ## The seventeen drifts, all shipped as written (motion-map §13)
///
/// 1. **D1: the easing chips do not move.** `space-travel` animates
///    `translateX(calc(100% − 1.5rem))`, and a percentage inside `translateX`
///    resolves against the transformed element's **own** border box. The chip
///    is `size-6` = 24px, so `100%` is 24px and the `calc` is 0px. Verified
///    live by the supervisor (ruling M1): all four chips hold
///    `matrix(1,0,0,1,0,0)` across the run on a 482px track. [_TravelChip]
///    ships the no-op by passing the *chip's* width to
///    [TravelMotion.translationAt]; if upstream ever fixes it, the intended
///    reading: travel the track, less the chip's own width: is that one
///    argument changed to the track's width.
/// 2. **D2, "40ms down, 250ms spring back" is true of two of six.** The
///    `#interaction` description promises it for the family; `press-spring`
///    releases in 220ms ([MotionDurations.pressSpringUp], a raw `0.22s` off the
///    scale entirely) and `press-key` is 80ms linear both ways. The
///    description ships verbatim, the panel notes print the real numbers, and
///    the demos run at their real numbers.
/// 3. **D3, "overlays get up to 350ms"** in the `#durations` description,
///    while `--duration-overlay` is **320ms** and no 350ms token exists.
/// 4. **D4, "things you operate use ease-standard"** in the `#easing`
///    description, while `--ease-standard` is not one of the four panels and
///    controls actually run `--ease-spring`.
/// 5. **D5, `--ease-spring`'s use copy calls it "THE curve … every press
///    release, every jelly entrance"**, which is true of the utilities and is
///    contradicted by Do #2 four sections below.
/// 6. **D6, Do #2 says "Reserve ease-spring for reward moments"**, which is
///    the same claim from the other side: ease-spring is the *control* release
///    curve in `btn-spring`, `press`, `click-spring` and `press-spring`. Both
///    sentences ship, unreconciled.
/// 7. **D7, Do #1 lists 100 and 200ms**, neither of which is a token, and
///    omits 80 (`tick`) and 400 (`slow`), which are: and which this page
///    tables three sections above.
/// 8. **D8, Don't #1 forbids anything over 550ms**, on a page running
///    `anim-jelly` 600ms, `anim-spring-up` 800ms, `anim-sign-on` 900ms,
///    `anim-ratchet` and `anim-shimmer` 1.4s, `anim-pulse-live` 2s and the
///    travel chips at 1000ms.
/// 9. **D9, Don't #3 forbids alternating brightness**, which is exactly what
///    `anim-sign-on` does: six hard cuts of opacity and `brightness()` in
///    900ms, about 3.3 alternations per second.
/// 10. **D10, "Looping animations run exactly once, then hold"** is half true.
///    `animation-iteration-count: 1` does make a loop run once, but only
///    `forwards`/`both` *hold*; all three loopers here declare no fill mode
///    and revert. Copy verbatim, mechanism per-demo.
/// 11. **D11, "550ms each, staggered 60ms … roughly 900ms"**, 550 + 5×60 is
///    850ms.
/// 12. **D12, Turbo "collapses stages 3–6 to 300ms total"**, and 300ms is not
///    a duration token.
/// 13. **D13: three header chips do not name their section, and one section
///    has no chip.** "Interaction utilities" is `#interaction` *"The click
///    feel"*, "Reveal choreography" is `#choreography` *"Pack-opening
///    choreography"*, and `#rules` has no chip at all. Six chips, seven
///    sections; the nav registry's six `contents` strings render unchanged.
/// 14. **D14: the live dot and its ring are different greens.**
///    `pulls-pulse-live` rings in `rgba(61, 220, 151, …)` #3DDC97, a palette
///    orphan; the dot is `bg-success` #10b981. Both themes, one 8px indicator.
/// 15. **D15: the CurveGraph's dashed line is never visible.** The `<line>`
///    at y=0 lies exactly on the `<rect>`'s own top edge, same colour, same
///    width, and the rect's solid stroke paints over it. [_CurveGraphPainter]
///    draws both in source order: dead ink, not a missing feature.
/// 16. **D16: six of the nine named animations set raw time literals**, not
///    tokens; only `anim-jelly-in` and `anim-reveal` read one. The port keeps
///    the literals in the foundation layer ([MotionDurations.popIn], `.springUp`,
///    `.signOn`, `.ratchet`, `.shimmer`, `.pulseLive`) rather than inlining
///    them here, which is the guard's rule, not a correction of the drift.
/// 17. **D17: the prose says Space Grotesk; `--font-sans` is Inter.** Tokens
///    win (recorded port decision). Applies to "LEGENDARY", "Press and hold"
///    and "Hover me".
///
/// ## Two supervisor rulings the code carries rather than the copy
///
/// * **M4, `pulls-reveal` is orthographic.** The element carries no
///   `perspective` and neither does any ancestor, so the Y rotation is a flat
///   horizontal squash with no foreshortening. [RevealMotion.transformAt] never
///   sets the perspective entry; adding it would look better and be wrong.
/// * **M5: the press buttons inherit 16px.** They carry no `.type-*` class,
///   so their label is the browser default at `font-semibold`.
///   [_inheritedFontSize] holds the `integration-verify` marker the supervisor
///   clears by computed-style probe on the rig.
library;

import 'dart:math' as math;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Form,
        FormField,
        Icon,
        OverlayPortal,
        RadioGroup,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;

import '../kit.dart';
import '../nav.dart';

/* ── Measures ────────────────────────────────────────────────────────────── */

/// `h-24`: every demo stage on this page, and the three press buttons.
final double _demoHeight = space(24);

/// `h-8`: a duration bar's track.
final double _sweepTrackHeight = space(8);

/// `h-6`: the easing panels' travel track, and `size-6` the chip on it.
final double _travelTrackHeight = space(6);
final double _chipSize = space(6);

/// `h-28`: the `<svg>` box a [_CurveGraph] is drawn inside.
final double _graphHeight = space(28);

/// `sm:grid-cols-[13rem_4rem_1fr]`: a duration row's two fixed columns.
final double _tokenColumn = space(52);
final double _msColumn = space(16);

/// `max-w-sm`: the `.lift` card's cap.
final double _liftMaxWidth = space(96);

/// `size-10` and its `h-4 w-0.5` needle: the ratchet.
final double _ratchetSquare = space(10);
final double _needleHeight = space(4);
final double _needleWidth = space(0.5);

/// `mt-2 size-1.5`: a reduced-motion bullet's dot.
final double _bulletSize = space(1.5);
final double _bulletTop = space(2);

/// The three press buttons, and the `.lift` card, carry **no** `.type-*`
/// class: `font-semibold` over whatever `<body>` inherits. `html` sets only
/// `font-sans` and `body` sets no size, so the computed value is the browser
/// default.
///
// integration-verify: ruling M5: the supervisor confirms 16px by
// computed-style probe on the rig and clears this marker.
// allow-hardcoded: the browser's own default font-size, which no token names.
const double _inheritedFontSize = 16;

/// `--font-weight-semibold: 600` (globals.css L179).
const double _semiboldWght = 600;

/// `font-semibold` at the inherited size: see [_inheritedFontSize].
final TextStyleToken _inheritedSemibold = TextStyleToken(
  family: Fonts.sans,
  size: _inheritedFontSize,
  wght: _semiboldWght,
);

/* ── Alphas ──────────────────────────────────────────────────────────────── */

/// `border-value/40` / `bg-value/12`: the `.anim-jelly` stage.
const double _valueBorderAlpha = 0.40;
const double _valueWashAlpha = 0.12;

/// `border-primary/40`, `.anim-jelly-in` and `.anim-reveal`.
const double _primaryBorderAlpha = 0.40;

/// `border-success/30` / `bg-success/10`: the live pill.
const double _successBorderAlpha = 0.30;
const double _successWashAlpha = 0.10;

/* ── Page data (the reference's two module-level arrays) ─────────────────── */

/// One row of the duration scale.
///
/// [ms] is not stored: the row prints `duration.inMilliseconds`, so the bar,
/// the printed number and the use copy all read the same token.
typedef _Duration = ({String token, Duration duration, String use});

/// Rows render in **array order**, which is not ascending: 80, 150, 250, 400,
/// **320**, 550. `--duration-slow` sits above `--duration-overlay`. Kept.
final List<_Duration> _durations = <_Duration>[
  (
    token: '--duration-tick',
    duration: MotionDurations.tick,
    use:
        'The machine beat. A press registers in this long, and nothing else '
        'uses it.',
  ),
  (
    token: '--duration-fast',
    duration: MotionDurations.fast,
    use: 'Button press and release, checkbox tick, chip select.',
  ),
  (
    token: '--duration-base',
    duration: MotionDurations.normal,
    use:
        'The default. Spring release, card hover lift, tab underline, focus '
        'fade.',
  ),
  (
    token: '--duration-slow',
    duration: MotionDurations.slow,
    use: 'Content entering: rows springing up, feed items arriving.',
  ),
  (
    token: '--duration-overlay',
    duration: MotionDurations.overlayEnter,
    use: 'Dialogs, drawers, sheets, popovers opening and closing.',
  ),
  (
    token: '--duration-reward',
    duration: MotionDurations.reward,
    use: 'Card reveal, rare pull, XP fill, reward unlock. The only long one.',
  ),
];

/// One easing panel: the token, the string it prints, the curve it runs, and
/// what it is for.
///
/// [curve] is printed **verbatim**: spaces after commas, `1` not `1.0`: and
/// is not derived from [cubic]. The two agreeing is what the page asserts;
/// deriving one from the other would make the assertion unfalsifiable.
typedef _Easing = ({String token, String curve, Cubic cubic, String use});

final List<_Easing> _easings = <_Easing>[
  (
    token: '--ease-spring',
    curve: 'cubic-bezier(0.34, 1.56, 0.64, 1)',
    cubic: MotionCurves.emphasized,
    use:
        'THE curve. Overshoots then settles. Every press release, every jelly '
        'entrance.',
  ),
  (
    token: '--ease-out',
    curve: 'cubic-bezier(0.22, 1, 0.36, 1)',
    cubic: MotionCurves.enter,
    use:
        'Anything that arrives. Cards, rows, overlays. Fast start, long '
        'settle.',
  ),
  (
    token: '--ease-in-out',
    curve: 'cubic-bezier(0.65, 0, 0.35, 1)',
    cubic: MotionCurves.move,
    use: 'Anything that loops. Live pulse, breathing glow, shimmer.',
  ),
  (
    token: '--ease-out-flex',
    curve: 'cubic-bezier(0.05, 0.6, 0.4, 0.9)',
    cubic: MotionCurves.outFlex,
    use: 'Long travel that must not overshoot — drawers, sheets, scroll rails.',
  ),
];

/* ── Page ────────────────────────────────────────────────────────────────── */

class MotionPage extends StatefulWidget {
  const MotionPage({super.key});

  /// The rect the easing graphs' 100×100 unit box occupies inside an `<svg>`
  /// viewport of [size].
  ///
  /// Exposed for tests, the way [Surface.debugInsetRing] is: the
  /// letterbox is the single detail of this page most likely to be got wrong,
  /// and "the painter fills its box" is a bug no copy assertion can catch. At
  /// the reference's 482 × 112 panel this returns
  /// `Rect.fromLTWH(208.44, 37.77, 65.116, 65.116)`: a **65px square adrift in
  /// the middle of a 482px panel**, with roughly 85% of the SVG's width empty.
  @visibleForTesting
  static Rect debugCurveBox(Size size) {
    final _Letterbox box = _letterbox(size);
    return Rect.fromLTWH(
      box.dx + -_viewBoxMinX * box.scale,
      box.dy + -_viewBoxMinY * box.scale,
      _unitBox * box.scale,
      _unitBox * box.scale,
    );
  }

  @override
  State<MotionPage> createState() => _MotionPageState();
}

class _MotionPageState extends State<MotionPage> {
  /// `const [run, setRun] = useState(0)`.
  ///
  /// One counter for the whole page. Three buttons. All three call [_replay],
  /// so pressing "Replay" in the durations panel also restarts the four easing
  /// chips and the six finite named demos. There is no per-section scoping,
  /// and that is load-bearing behaviour rather than an implementation detail.
  int _run = 0;

  void _replay() => setState(() => _run++);

  @override
  Widget build(BuildContext context) {
    final CategoryHit here = findCategory('foundations', 'motion');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        PageHeader(
          eyebrow: here.group.title,
          title: here.category.title,
          blurb: here.category.blurb,
          // Six chips, seven sections: drift D13. The registry's strings ship
          // exactly as registered; no chip is added for `#rules`.
          contents: here.category.contents,
        ),
        // `className="mb-12"`.
        Note(
          title: 'Everything on this page is live',
          child: StyledText(
            'Timings are judged, not read. Hover the interaction demos and use '
            'the replay buttons to re-run the entrances. If your system is set '
            'to reduce motion, every animation here collapses to near-zero — '
            'which is the correct behaviour, not a bug.',
            TextStyles.small,
          ),
        ),
        SizedBox(height: space(12)),
        _DurationsSection(run: _run, onReplay: _replay),
        _EasingSection(run: _run, onReplay: _replay),
        const _InteractionSection(),
        _NamedSection(run: _run, onReplay: _replay),
        const _ChoreographySection(),
        const _ReducedSection(),
        const Section(
          id: 'rules',
          title: 'Rules',
          child: DoDont(
            dos: <String>[
              // D7: 100 and 200 are not tokens; 80 and 400 are, and are tabled
              // three sections above. Verbatim.
              'Use a duration token — 100, 150, 200, 250, 320 or 550ms. '
                  'Nothing in between.',
              // D5/D6: contradicts the `--ease-spring` use copy on this page.
              'Reserve ease-spring for reward moments; it reads as celebration.',
              'Keep skeletons shaped like the content they stand in for.',
              'Make the pack-opening sequence skippable from the moment it '
                  'starts.',
            ],
            donts: <String>[
              // D8: this page runs six animations longer than 550ms.
              "Don't animate anything for longer than 550ms outside the "
                  'opening sequence.',
              "Don't loop an animation except the live indicator — constant "
                  'movement is fatiguing.',
              // D9: `anim-sign-on`, four panels up, is exactly this.
              "Don't flash, strobe or rapidly alternate brightness; it is an "
                  'accessibility hazard.',
              "Don't let text move while it is being read — animate the "
                  'container, not the copy.',
            ],
          ),
        ),
        const PageFootNav(groupId: 'foundations', slug: 'motion'),
      ],
    );
  }
}

/// `Button variant="outline" size="sm"` + `Icon icon={RotateCcw} size="sm"
/// tone="inherit"` + a label. Three of these, identical but for the label,
/// all wired to the same counter.
class _ReplayButton extends StatelessWidget {
  const _ReplayButton({required this.label, required this.onReplay});

  final String label;
  final VoidCallback onReplay;

  @override
  Widget build(BuildContext context) {
    return Align(
      // `flex justify-end`.
      alignment: Alignment.centerRight,
      child: Button(
        variant: ButtonVariant.outline,
        size: ButtonSize.sm,
        onPressed: onReplay,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              IconGlyph.rotateCcw,
              size: IconSize.sm,
              tone: IconTone.inherit,
            ),
            // `gap-1.5`, asked of the component rather than restated.
            SizedBox(width: Button.gapFor(ButtonSize.sm)),
            // Bare [Text]: the button installs its own `text-sm font-medium`
            // as the ambient style, which is exactly what the label inherits
            // in the reference.
            Text(label),
          ],
        ),
      ),
    );
  }
}

/* ── #durations ──────────────────────────────────────────────────────────── */

class _DurationsSection extends StatelessWidget {
  const _DurationsSection({required this.run, required this.onReplay});

  final int run;
  final VoidCallback onReplay;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Section(
      id: 'durations',
      title: 'Durations',
      // D3: `--duration-overlay` is 320ms, and there is no 350ms token.
      description:
          'Six steps. Standard interface motion sits between 150 and '
          '250ms, overlays get up to 350ms, and only reward moments are '
          'allowed past 400ms.',
      child: Panel(
        label: 'Same distance, six speeds',
        // The panel's note is live: the visible read-out of the replay
        // counter, `type-num-sm text-muted-foreground`.
        note: 'run $run',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _ReplayButton(label: 'Replay', onReplay: onReplay),
            SizedBox(height: space(5)),
            // `space-y-4`.
            for (int i = 0; i < _durations.length; i++) ...<Widget>[
              if (i > 0) SizedBox(height: space(4)),
              _DurationRow(row: _durations[i], run: run),
            ],
            // `mt-6 … border-t border-border pt-5`.
            SizedBox(height: space(6)),
            Container(
              padding: EdgeInsets.only(top: space(5)),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: theme.border,
                    width: BorderWidths.hairline,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // `space-y-2`.
                  for (int i = 0; i < _durations.length; i++) ...<Widget>[
                    if (i > 0) SizedBox(height: space(2)),
                    _DurationUse(row: _durations[i]),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// `grid items-center gap-4 sm:grid-cols-[13rem_4rem_1fr]`.
class _DurationRow extends StatelessWidget {
  const _DurationRow({required this.row, required this.run});

  final _Duration row;
  final int run;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final bool wide = MediaQuery.sizeOf(context).width >= Breakpoints.sm;

    final Widget token = StyledText(
      row.token,
      TextStyles.numberSm,
      color: theme.actionText,
    );
    final Widget ms = StyledText(
      '${row.duration.inMilliseconds}ms',
      TextStyles.numberSm,
      color: theme.mutedForeground,
    );
    // `space-sweep {ms}ms var(--ease-out) both`, keyed on the run counter so the
    // replay buttons remount it and it starts again from `from`.
    final Widget track = KeyedSubtree(
      key: ValueKey<String>('${row.token}-$run'),
      child: _SweepBar(duration: row.duration),
    );

    return wide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: _tokenColumn, child: token),
              SizedBox(width: space(4)),
              SizedBox(width: _msColumn, child: ms),
              SizedBox(width: space(4)),
              Expanded(child: track),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Align(alignment: Alignment.centerLeft, child: token),
              SizedBox(height: space(4)),
              Align(alignment: Alignment.centerLeft, child: ms),
              SizedBox(height: space(4)),
              track,
            ],
          );
  }
}

/// `h-8 overflow-hidden rounded-sm bg-muted` with a `h-full rounded-sm
/// bg-action` bar sweeping across it.
///
/// The track's `overflow-hidden` is why the bar needs no arithmetic: a clip is
/// enough. The bar carries `rounded-sm` of its own, so at small widths it is a
/// 6px-radius pill rather than a square sliver.
///
/// Under reduced motion this is the page's joke on itself: `both` holds `to`,
/// so all six bars freeze full-width and identical, and the section's entire
/// point is destroyed by design (motion-map §8.2).
class _SweepBar extends StatelessWidget {
  const _SweepBar({required this.duration});

  /// Supplied by the caller, not read from a table: this panel *is* the
  /// duration scale, so the bar's clock is whichever of the six tokens the row
  /// is documenting.
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return SizedBox(
      height: _sweepTrackHeight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Radii.sm),
        child: ColoredBox(
          color: theme.muted,
          child: KeyframePlayer(
            duration: duration,
            fill: SweepMotion.fill,
            builder: (BuildContext context, double t, Widget? child) =>
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: SweepMotion.widthFactor.transform(t),
                  heightFactor: 1,
                  child: child,
                ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Palette.action,
                borderRadius: BorderRadius.circular(Radii.sm),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// `<p class="type-small"><span class="type-num-sm …">{ms}ms</span>, {use}</p>`.
class _DurationUse extends StatelessWidget {
  const _DurationUse({required this.row});

  final _Duration row;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return RichText(
      TextSpan(
        children: <InlineSpan>[
          TextSpan(
            text: '${row.duration.inMilliseconds}ms',
            style: StyledText.styleOf(
              context,
              TextStyles.numberSm,
              color: theme.mutedForeground,
            ),
          ),
          TextSpan(text: ' — ${row.use}'),
        ],
      ),
      TextStyles.small,
    );
  }
}

/* ── #easing ─────────────────────────────────────────────────────────────── */

class _EasingSection extends StatelessWidget {
  const _EasingSection({required this.run, required this.onReplay});

  final int run;
  final VoidCallback onReplay;

  @override
  Widget build(BuildContext context) {
    return Section(
      id: 'easing',
      title: 'Easing',
      // D4: `--ease-standard` is not one of the four panels, and the controls
      // this sentence describes actually run `--ease-spring`.
      description:
          'Four curves, each with a job. The rule of thumb: things '
          'you operate use ease-standard, things that arrive use ease-out, and '
          'only rewards may overshoot.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Grid(
            sm: 2,
            children: <Widget>[
              for (final _Easing easing in _easings)
                _EasingPanel(easing: easing, run: run),
            ],
          ),
          SizedBox(height: space(4)),
          _ReplayButton(label: 'Replay curves', onReplay: onReplay),
        ],
      ),
    );
  }
}

class _EasingPanel extends StatelessWidget {
  const _EasingPanel({required this.easing, required this.run});

  final _Easing easing;
  final int run;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Panel(
      label: easing.token,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _CurveGraph(cubic: easing.cubic),
          SizedBox(height: space(4)),
          KeyedSubtree(
            key: ValueKey<String>('${easing.token}-$run'),
            child: _TravelChip(curve: easing.cubic),
          ),
          SizedBox(height: space(4)),
          StyledText(
            easing.curve,
            TextStyles.numberSm,
            color: theme.mutedForeground,
          ),
          SizedBox(height: space(2)),
          StyledText(easing.use, TextStyles.small),
        ],
      ),
    );
  }
}

/* ── #easing · the curve graph ───────────────────────────────────────────── */

/// `viewBox="-8 -58 116 172"`, 58 units of headroom that exist for
/// `--ease-spring`'s **control point** at −56, not for the curve, which peaks
/// only 9.78 units above the box.
const double _viewBoxMinX = -8;
const double _viewBoxMinY = -58;
const double _viewBoxWidth = 116;
const double _viewBoxHeight = 172;

/// The unit box the curve is drawn in: `(0,100)` is t 0 / output 0 and
/// `(100,0)` is t 1 / output 1, so Y is flipped and up means more output.
const double _unitBox = 100;

/// `strokeWidth="2.5"` on the path; the `<rect>` and `<line>` take the SVG
/// default of 1. Both are **user units** and are scaled by the same canvas
/// transform, which is what makes them 1.628px and 0.651px at the 482px panel
/// width rather than 2.5px and 1px.
const double _curveStrokeUnits = 2.5;
const double _frameStrokeUnits = 1;

/// `strokeDasharray="3 3"`.
const double _dashOnUnits = 3;
const double _dashOffUnits = 3;

/// What `preserveAspectRatio="xMidYMid meet"` resolves to for one viewport:
/// the scale that fits the viewBox inside it, and the offsets that centre what
/// is left over.
typedef _Letterbox = ({double scale, double dx, double dy});

/// `meet` on a 482 × 112 viewport gives `min(482/116, 112/172) = 0.651163` —
/// **height bound**, which is the whole reason the graph reads small.
_Letterbox _letterbox(Size size) {
  final double scale = math.min(
    size.width / _viewBoxWidth,
    size.height / _viewBoxHeight,
  );
  return (
    scale: scale,
    dx: (size.width - _viewBoxWidth * scale) / 2,
    dy: (size.height - _viewBoxHeight * scale) / 2,
  );
}

/// The `CurveGraph` SVG, translated to painter terms.
///
/// The detail most likely to be got wrong is the letterbox. With
/// `preserveAspectRatio="xMidYMid meet"` (the default) and a viewport of
/// 482 × 112, the scale is `min(482/116, 112/172) = 0.651163`, **height
/// bound**: so the 100×100 unit box renders as a **65.1px square centred in
/// the panel**, and roughly 85% of the SVG's width is empty. A painter that
/// fills its box is visibly wrong.
class _CurveGraph extends StatelessWidget {
  const _CurveGraph({required this.cubic});

  final Cubic cubic;

  /// `aria-label={`Easing curve ${pts.join(", ")}`}`, JS `join` prints `1`,
  /// not `1.0`, so an integral control point loses its fraction.
  static String labelFor(Cubic cubic) {
    String point(double v) => v == v.truncateToDouble() ? '${v.toInt()}' : '$v';
    return 'Easing curve '
        '${point(cubic.a)}, ${point(cubic.b)}, '
        '${point(cubic.c)}, ${point(cubic.d)}';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Semantics(
      image: true,
      label: labelFor(cubic),
      child: SizedBox(
        // `h-28 w-full`.
        height: _graphHeight,
        child: CustomPaint(
          painter: _CurveGraphPainter(
            cubic: cubic,
            frame: theme.border,
            curve: Palette.action,
          ),
        ),
      ),
    );
  }
}

class _CurveGraphPainter extends CustomPainter {
  const _CurveGraphPainter({
    required this.cubic,
    required this.frame,
    required this.curve,
  });

  final Cubic cubic;

  /// `stroke="var(--border)"`: the box and the dead dashed line.
  final Color frame;

  /// `stroke="var(--color-action)"`: the curve itself.
  final Color curve;

  @override
  void paint(Canvas canvas, Size size) {
    // `xMidYMid meet`: scale to fit, centre what is left over.
    final _Letterbox box = _letterbox(size);

    canvas.save();
    canvas.translate(box.dx, box.dy);
    canvas.scale(box.scale);
    // The viewBox's own origin: everything below is authored in user units.
    canvas.translate(-_viewBoxMinX, -_viewBoxMinY);

    final Paint framePaint = Paint()
      ..color = frame
      ..style = PaintingStyle.stroke
      ..strokeWidth = _frameStrokeUnits;

    // 1 · the unit box.
    canvas.drawRect(const Rect.fromLTWH(0, 0, _unitBox, _unitBox), framePaint);

    // 2 · the dashed reference line at output = 1: drift D15. It lies exactly
    // on the rect's own top edge, in the same colour at the same width, so the
    // solid stroke just painted covers it. Drawn in source order anyway: it is
    // dead ink in the reference, and a port that silently dropped it would be
    // asserting a judgement the reference never made.
    for (double x = 0; x < _unitBox; x += _dashOnUnits + _dashOffUnits) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(math.min(x + _dashOnUnits, _unitBox), 0),
        framePaint,
      );
    }

    // 3 · the curve. `M 0 100 C x1·100 (100−y1·100) x2·100 (100−y2·100) 100 0`
    //: the Y flip is what puts more output higher up the box.
    canvas.drawPath(
      Path()
        ..moveTo(0, _unitBox)
        ..cubicTo(
          cubic.a * _unitBox,
          _unitBox - cubic.b * _unitBox,
          cubic.c * _unitBox,
          _unitBox - cubic.d * _unitBox,
          _unitBox,
          0,
        ),
      Paint()
        ..color = curve
        ..style = PaintingStyle.stroke
        // SVG defaults are `butt` caps and `miter` joins, which Flutter also
        // defaults to: unlike `Icon`'s glyph painter, which sets round caps
        // for lucide.
        ..strokeWidth = _curveStrokeUnits,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(_CurveGraphPainter old) =>
      old.cubic != cubic || old.frame != frame || old.curve != curve;
}

/* ── #easing · the travel chip ───────────────────────────────────────────── */

/// `space-travel var(--duration-bloom) {curve} both` on a `size-6` chip, **and a
/// verified no-op** (drift D1, ruling M1).
///
/// The chip is handed its **own** width, because that is what a percentage
/// inside `translateX` resolves against: `calc(100% − 1.5rem)` on a 24px
/// element is 0px, and the animation runs its full second translating nothing.
/// The four panels communicate their curve through [_CurveGraph] alone.
///
/// If upstream ever fixes it, the intended reading is "travel the track, minus
/// the chip's own width": pass the track's width here instead of
/// [_chipSize], and nothing else changes.
class _TravelChip extends StatelessWidget {
  const _TravelChip({required this.curve});

  /// Each panel runs the chip under its own curve, over a deliberately
  /// identical time, so the four can be judged against each other.
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return SizedBox(
      // `h-6 rounded-sm bg-muted`, and no `overflow-hidden`.
      height: _travelTrackHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.muted,
          borderRadius: BorderRadius.circular(Radii.sm),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: KeyframePlayer(
            duration: TravelMotion.duration,
            fill: TravelMotion.fill,
            builder: (BuildContext context, double t, Widget? child) =>
                Transform.translate(
                  offset: Offset(
                    TravelMotion.translationAt(t, _chipSize, curve: curve),
                    0,
                  ),
                  child: child,
                ),
            child: SizedBox(
              width: _chipSize,
              height: _chipSize,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Palette.value,
                  borderRadius: BorderRadius.circular(Radii.sm),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* ── #interaction ────────────────────────────────────────────────────────── */

class _InteractionSection extends StatelessWidget {
  const _InteractionSection();

  @override
  Widget build(BuildContext context) {
    return Section(
      id: 'interaction',
      title: 'The click feel',
      // D2: true of `press` and `click-spring` only. `press-spring` releases
      // in 220ms and `press-key` is 80ms linear both ways: which the panel
      // notes below state correctly, on this same page.
      description:
          'Ported from Yukirhythm, and the single most important '
          'thing in the motion system. Instant squish in, springy return out — '
          '40ms down, 250ms spring back. That asymmetry is what makes the '
          'interface feel alive rather than animated.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Grid(
            sm: 3,
            children: const <Widget>[
              _ClickSpringPanel(),
              _PressSpringPanel(),
              _PressKeyPanel(),
            ],
          ),
          SizedBox(height: space(4)),
          const _LiftPanel(),
          SizedBox(height: space(4)),
          Note(
            title: 'Content bounces; controls click',
            child: StyledText(
              // `Yuki&rsquo;s`: a real right single quotation mark.
              'Yuki’s governing rule, and ours now. Springy motion for things '
              'that appear, react or reward. Machine motion for things you '
              'operate. Never mix them — a button that jellies feels broken, '
              'and a reward that clicks feels cheap.',
              TextStyles.small,
            ),
          ),
        ],
      ),
    );
  }
}

/// The shared body of the three press panels: copy, then a full-width 96px
/// button reading "Press and hold".
class _PressPanel extends StatelessWidget {
  const _PressPanel({
    required this.label,
    required this.note,
    required this.copy,
    required this.button,
  });

  final String label;
  final String note;
  final String copy;
  final Widget button;

  @override
  Widget build(BuildContext context) {
    return Panel(
      label: label,
      note: note,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          StyledText(copy, TextStyles.small),
          SizedBox(height: space(5)),
          button,
        ],
      ),
    );
  }
}

/// `.click-spring`, 40ms down to scale 0.9, 250ms spring back.
class _ClickSpringPanel extends StatelessWidget {
  const _ClickSpringPanel();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return _PressPanel(
      label: '.click-spring',
      note: '40ms down · scale 0.9',
      copy:
          'The global click feel. Goes on anything clickable that is not a '
          'Button — avatars, chips, badges, rows, nav items.',
      button: Press(
        scale: MotionTransforms.clickSpringScale,
        upDuration: MotionDurations.normal,
        child: _PressSurface(
          // `shadow-btn-primary` carries two inset layers.
          spec: Shadows.controlPrimary,
          fill: theme.primary,
          ink: theme.primaryForeground,
        ),
      ),
    );
  }
}

/// `.press-spring`: same 40ms down, scale 0.92, and a **220ms** release: a
/// raw `0.22s` that is not on the duration scale at all (drift D2).
class _PressSpringPanel extends StatelessWidget {
  const _PressSpringPanel();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return _PressPanel(
      label: '.press-spring',
      note: '40ms down · scale 0.92',
      copy:
          'Same feel, less travel. For larger surfaces where 0.9 would look '
          'comical.',
      button: Press(
        scale: MotionTransforms.pressSpringScale,
        upDuration: MotionDurations.pressSpringUp,
        child: _PressSurface(
          spec: Shadows.control,
          fill: theme.card,
          ink: theme.foreground,
          border: Border.all(color: theme.border, width: BorderWidths.hairline),
        ),
      ),
    );
  }
}

/// `.press-key`: machine motion: 80ms linear both ways, 3px of travel, and a
/// `--shadow-key` → `--shadow-key-down` swap. No spring, it just lands.
class _PressKeyPanel extends StatelessWidget {
  const _PressKeyPanel();

  @override
  Widget build(BuildContext context) {
    return const _PressPanel(
      label: '.press-key',
      note: '80ms linear · 3px travel',
      copy:
          'A physical key travelling into its socket. Machine motion — '
          'linear, no spring, it just lands.',
      button: _PressKeyButton(),
    );
  }
}

/// The shared surface: `grid h-24 w-full place-items-center rounded-lg
/// font-semibold`, over a shadow token that has inset layers.
class _PressSurface extends StatelessWidget {
  const _PressSurface({
    required this.spec,
    required this.fill,
    required this.ink,
    this.border,
  });

  final ShadowStyle spec;
  final Color fill;
  final Color ink;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _demoHeight,
      child: Surface(
        spec: spec,
        radius: BorderRadius.circular(Radii.lg),
        fill: fill,
        border: border,
        child: Center(
          child: StyledText('Press and hold', _inheritedSemibold, color: ink),
        ),
      ),
    );
  }
}

/// `press-key`'s own clock.
///
/// Not [Press]: this utility springs nothing. `transition: transform
/// var(--duration-tick) linear, box-shadow var(--duration-tick) linear`: so
/// the controller's raw value **is** the progress, with no curve applied in
/// either direction, and the same 80ms governs press and release.
///
/// The shadow swap is discrete on purpose. `--shadow-key`'s second layer is an
/// outer shadow and `--shadow-key-down`'s is `inset`, and CSS cannot
/// interpolate a shadow list whose insetness differs: the property falls back
/// to discrete interpolation, which flips at 50% of the transition. So the key
/// travels smoothly and its shadow cuts over at 40ms.
class _PressKeyButton extends StatefulWidget {
  const _PressKeyButton();

  @override
  State<_PressKeyButton> createState() => _PressKeyButtonState();
}

class _PressKeyButtonState extends State<_PressKeyButton>
    with SingleTickerProviderStateMixin {
  /// Where a non-interpolable property changes value: CSS discrete
  /// interpolation flips from the start value to the end value at half the
  /// transition, and holds each side.
  static const double _discreteFlip = 0.5;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: MotionDurations.tick,
    reverseDuration: MotionDurations.tick,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final Duration tick = effectiveMotionDuration(
      context,
      MotionDurations.tick,
    );
    _controller
      ..duration = tick
      ..reverseDuration = tick;

    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (PointerDownEvent _) => _controller.forward(),
      onPointerUp: (PointerUpEvent _) => _controller.reverse(),
      onPointerCancel: (PointerCancelEvent _) => _controller.reverse(),
      child: SizedBox(
        height: _demoHeight,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? child) {
            // Linear: the controller's own value, uncurved.
            final double t = _controller.value;
            return Transform.translate(
              offset: Offset(0, MotionTransforms.keyDownY * t),
              child: Surface(
                spec: t < _discreteFlip
                    ? Shadows.keyRaised
                    : Shadows.keyPressed,
                radius: BorderRadius.circular(Radii.lg),
                // `bg-card` and no border class: the raised-key look is
                // entirely the shadow's.
                fill: theme.card,
                child: child!,
              ),
            );
          },
          child: Center(
            child: StyledText(
              'Press and hold',
              _inheritedSemibold,
              color: theme.foreground,
            ),
          ),
        ),
      ),
    );
  }
}

/// `.lift`: rises three pixels onto `--shadow-e3`. Hover-only in CSS, so on a
/// touch platform this demo is simply static, exactly as the web is.
class _LiftPanel extends StatelessWidget {
  const _LiftPanel();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Panel(
      label: '.lift — cards and packs',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) =>
                  SizedBox(
                    // `max-w-sm`: a block box takes what it is offered, up to the
                    // cap.
                    width: math.min(constraints.maxWidth, _liftMaxWidth),
                    height: _demoHeight,
                    child: InteractiveCard(
                      radius: BorderRadius.circular(Radii.lg),
                      builder: (BuildContext context, bool hovered) => Center(
                        child: StyledText(
                          'Hover me',
                          _inheritedSemibold,
                          color: theme.foreground,
                        ),
                      ),
                    ),
                  ),
            ),
          ),
          SizedBox(height: space(5)),
          StyledText(
            'Rises three pixels and gains a shadow — enough to read as '
            'interactive without the grid feeling unstable.',
            TextStyles.small,
          ),
        ],
      ),
    );
  }
}

/* ── #named ──────────────────────────────────────────────────────────────── */

class _NamedSection extends StatelessWidget {
  const _NamedSection({required this.run, required this.onReplay});

  final int run;
  final VoidCallback onReplay;

  @override
  Widget build(BuildContext context) {
    return Section(
      id: 'named',
      title: 'Named animations',
      description:
          "Yukirhythm's set, plus the three this product needed. "
          'Anything that animates should reach for one of these before a new '
          'keyframe is written.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _ReplayButton(label: 'Replay all', onReplay: onReplay),
          SizedBox(height: space(5)),
          Grid(
            sm: 2,
            lg: 3,
            children: <Widget>[
              _NamedPanel(
                label: '.anim-pop-in',
                note: '550ms · from 25%',
                copy:
                    'Pops from 25%, never from 0, so it always reads as '
                    'arriving rather than materialising.',
                demo: KeyedSubtree(
                  key: ValueKey<String>('pop-$run'),
                  child: const _PopInDemo(),
                ),
              ),
              _NamedPanel(
                label: '.anim-jelly',
                note: '600ms · squash & stretch',
                copy:
                    'The reward. Squashes to 1.18×0.82 and wobbles back. '
                    'Reserve it for wins.',
                demo: KeyedSubtree(
                  key: ValueKey<String>('jelly-$run'),
                  child: const _JellyDemo(),
                ),
              ),
              _NamedPanel(
                label: '.anim-spring-up',
                note: '800ms · settle',
                copy:
                    'Rises 32px, overshoots by 4, then settles in three '
                    'decreasing bounces.',
                demo: KeyedSubtree(
                  key: ValueKey<String>('springup-$run'),
                  child: const _SpringUpDemo(),
                ),
              ),
              _NamedPanel(
                label: '.anim-jelly-in',
                note: '420ms · spring',
                copy:
                    'Scale plus rise with an overshoot. The screens-level '
                    'entrance.',
                demo: KeyedSubtree(
                  key: ValueKey<String>('jellyin-$run'),
                  child: const _JellyInDemo(),
                ),
              ),
              // Unkeyed, and the note says why: a loop has nothing to replay.
              const _NamedPanel(
                label: '.anim-ratchet',
                note: '1.4s · steps(8)',
                copy:
                    'Stepped mechanical spin. Eight discrete positions, not '
                    'a smooth rotation — it reads as a mechanism.',
                demo: _RatchetDemo(),
              ),
              _NamedPanel(
                label: '.anim-sign-on',
                note: '900ms · TEXT only',
                copy:
                    'Neon power-up: flickers on, drops out, catches. Drives '
                    'text-shadow, so it only works on text.',
                demo: KeyedSubtree(
                  key: ValueKey<String>('sign-$run'),
                  child: const _SignOnDemo(),
                ),
              ),
              _NamedPanel(
                label: '.anim-reveal',
                note: '550ms · our own',
                copy:
                    'The card turning face-up. Rotates on the Y axis. Ours, '
                    'not Yuki’s.',
                demo: KeyedSubtree(
                  key: ValueKey<String>('reveal-$run'),
                  child: const _RevealDemo(),
                ),
              ),
              const _NamedPanel(
                label: '.anim-shimmer',
                note: '1.4s loop · our own',
                copy:
                    'Skeleton loading. Must match the footprint of the '
                    'content it replaces.',
                demo: _ShimmerDemo(),
              ),
              const _NamedPanel(
                label: '.anim-pulse-live',
                note: '2s loop · our own',
                copy:
                    'The only animation allowed to run forever, and only on '
                    'the live indicator.',
                demo: _PulseLiveDemo(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// One named-animation panel: the demo, then `<p class="type-small mt-4">`.
class _NamedPanel extends StatelessWidget {
  const _NamedPanel({
    required this.label,
    required this.note,
    required this.copy,
    required this.demo,
  });

  final String label;
  final String note;
  final String copy;
  final Widget demo;

  @override
  Widget build(BuildContext context) {
    return Panel(
      label: label,
      note: note,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          demo,
          SizedBox(height: space(4)),
          StyledText(copy, TextStyles.small),
        ],
      ),
    );
  }
}

/// CSS clamps `opacity` to `[0,1]` when it uses the value, not when it
/// interpolates it: and on this page that is load-bearing exactly once.
/// `.anim-jelly-in` runs its `0 → 1` opacity on `--ease-spring`, whose 1.56
/// control point carries the interpolated value **above 1** for most of the
/// first 60%. The keyframe track reports that overshoot faithfully, because
/// the same curve drives the scale and the rise where the overshoot is the
/// whole point; the property clamps it, exactly as a browser does.
double _opacity(double value) => value.clamp(0.0, 1.0);

/// The `h-24 … rounded-lg` stage the first four demos and `.anim-reveal`
/// animate, with a caller-supplied rim and wash.
class _DemoStage extends StatelessWidget {
  const _DemoStage({required this.child, this.border, this.fill});

  final Widget child;
  final Color? border;
  final Color? fill;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return SizedBox(
      height: _demoHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: fill ?? theme.card,
          borderRadius: BorderRadius.circular(Radii.lg),
          border: Border.all(
            color: border ?? theme.border,
            width: BorderWidths.hairline,
          ),
        ),
        child: Center(child: child),
      ),
    );
  }
}

/// `.anim-pop-in`: opacity 0→1 by 55%, and a `scale3d` that overshoots twice
/// before landing. Opacity is declared at two stops only and holds 1 from 55%.
class _PopInDemo extends StatelessWidget {
  const _PopInDemo();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return KeyframePlayer(
      duration: EntranceMotion.duration,
      fill: EntranceMotion.fill,
      builder: (BuildContext context, double t, Widget? child) {
        final Offset scale = EntranceMotion.scale.transform(t);
        return Opacity(
          opacity: _opacity(EntranceMotion.opacity.transform(t)),
          child: Transform.scale(
            scaleX: scale.dx,
            scaleY: scale.dy,
            child: child,
          ),
        );
      },
      child: _DemoStage(
        child: StyledText(
          'Jelly pop',
          TextStyles.small,
          color: theme.foreground,
        ),
      ),
    );
  }
}

/// `.anim-jelly`: the reward. Squashes to 1.18×0.82 and wobbles back.
class _JellyDemo extends StatelessWidget {
  const _JellyDemo();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return KeyframePlayer(
      duration: StateChangeMotion.duration,
      fill: StateChangeMotion.fill,
      builder: (BuildContext context, double t, Widget? child) {
        final Offset scale = StateChangeMotion.scale.transform(t);
        return Transform.scale(
          scaleX: scale.dx,
          scaleY: scale.dy,
          child: child,
        );
      },
      child: _DemoStage(
        border: Palette.value.withValues(alpha: _valueBorderAlpha),
        fill: Palette.value.withValues(alpha: _valueWashAlpha),
        child: StyledText(
          '+\$1,240',
          TextStyles.numberMd,
          color: theme.premiumText,
        ),
      ),
    );
  }
}

/// `.anim-spring-up`: the one table on `--ease-settle`, and the one whose
/// copy is arithmetically exact: 32px rise, −4, +1.5, −0.5.
class _SpringUpDemo extends StatelessWidget {
  const _SpringUpDemo();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return KeyframePlayer(
      duration: SpringEntranceMotion.duration,
      fill: SpringEntranceMotion.fill,
      builder: (BuildContext context, double t, Widget? child) => Opacity(
        opacity: _opacity(SpringEntranceMotion.opacity.transform(t)),
        child: Transform.translate(
          offset: Offset(0, SpringEntranceMotion.translateY.transform(t)),
          child: child,
        ),
      ),
      child: _DemoStage(
        child: StyledText(
          'Section entering',
          TextStyles.small,
          color: theme.foreground,
        ),
      ),
    );
  }
}

/// `.anim-jelly-in`, `transform: scale(s) translateY(y)`, in that order.
///
/// CSS applies a transform list left to right, so the translation happens
/// inside the scaled frame: the scale is the **outer** [Transform] here and
/// the translate the inner one, which is the same matrix product.
class _JellyInDemo extends StatelessWidget {
  const _JellyInDemo();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return KeyframePlayer(
      duration: OpenMotion.duration,
      fill: OpenMotion.fill,
      builder: (BuildContext context, double t, Widget? child) => Opacity(
        opacity: _opacity(OpenMotion.opacity.transform(t)),
        child: Transform.scale(
          scale: OpenMotion.scale.transform(t),
          child: Transform.translate(
            offset: Offset(0, OpenMotion.translateY.transform(t)),
            child: child,
          ),
        ),
      ),
      child: _DemoStage(
        border: theme.primary.withValues(alpha: _primaryBorderAlpha),
        child: StyledText(
          'Screen entering',
          TextStyles.small,
          color: theme.foreground,
        ),
      ),
    );
  }
}

/// `.anim-ratchet`: eight held 45° positions of 175ms each. 360° is never
/// displayed; the cycle wraps to 0°.
///
/// Driven through [DiscreteProgressMotion.radiansAt] rather than a `CurvedAnimation`,
/// deliberately: `CurvedAnimation` short-circuits `t == 1.0` to itself, which
/// would paint the one frame `steps(8, jump-end)` exists to skip.
///
/// Unkeyed and infinite. Under reduced motion it runs one collapsed iteration
/// and, having no fill mode, reverts to the element's own transform, 0°
/// (ruling M7).
class _RatchetDemo extends StatelessWidget {
  const _RatchetDemo();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return SizedBox(
      height: _demoHeight,
      child: Center(
        child: KeyframePlayer(
          duration: DiscreteProgressMotion.duration,
          fill: DiscreteProgressMotion.fill,
          repeat: DiscreteProgressMotion.loops,
          builder: (BuildContext context, double t, Widget? child) =>
              Transform.rotate(
                angle: DiscreteProgressMotion.radiansAt(t),
                child: child,
              ),
          // The **square** rotates, needle included.
          child: Container(
            width: _ratchetSquare,
            height: _ratchetSquare,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.card,
              borderRadius: BorderRadius.circular(Radii.sm),
              border: Border.all(
                color: theme.input,
                width: BorderWidths.hairline,
              ),
            ),
            child: SizedBox(
              width: _needleWidth,
              height: _needleHeight,
              child: ColoredBox(color: Palette.actionBright),
            ),
          ),
        ),
      ),
    );
  }
}

/// `.anim-sign-on`: six hard cuts, no tweening.
///
/// `steps(1, end)` applied between every pair of stops means no interpolation
/// at all, so this reads [TextRevealMotion.frameAt] rather than a tween. Render order
/// is the filter spec's: draw the text **and its shadows**, apply
/// `brightness()`, then apply `opacity`.
///
/// The resting state is not neutral. `both` holds the 70% frame, so after
/// 900ms the word keeps a `0 0 6px` + `0 0 18px` glow at brightness 1.15
/// forever: and that is also the frame reduced motion freezes it on.
class _SignOnDemo extends StatelessWidget {
  const _SignOnDemo();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return SizedBox(
      height: _demoHeight,
      child: Center(
        child: KeyframePlayer(
          duration: TextRevealMotion.duration,
          fill: TextRevealMotion.fill,
          builder: (BuildContext context, double t, Widget? child) {
            final TextRevealFrame frame = TextRevealMotion.frameAt(t);
            // `currentColor` is `text-value-ink`.
            final TextStyle style = StyledText.styleOf(
              context,
              TextStyles.h3,
              color: theme.premiumText,
            ).copyWith(shadows: frame.shadows(theme.premiumText));

            return Opacity(
              opacity: frame.opacity,
              child: ColorFiltered(
                colorFilter: frame.brightnessFilter,
                child: LineBox(
                  style: style,
                  // Literal uppercase in the source; no `text-transform`.
                  child: Text('LEGENDARY', style: style),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// `.anim-reveal`: the card turning face-up, **orthographically** (ruling M4).
class _RevealDemo extends StatelessWidget {
  const _RevealDemo();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return KeyframePlayer(
      duration: RevealMotion.duration,
      fill: RevealMotion.fill,
      builder: (BuildContext context, double t, Widget? child) => Opacity(
        opacity: _opacity(RevealMotion.opacity.transform(t)),
        child: Transform(
          transform: RevealMotion.transformAt(t),
          // `transform-origin: 50% 50%`, the CSS default.
          alignment: Alignment.center,
          child: child,
        ),
      ),
      child: _DemoStage(
        border: theme.primary.withValues(alpha: _primaryBorderAlpha),
        child: const Icon(
          IconGlyph.sparkles,
          size: IconSize.xl,
          tone: IconTone.action,
        ),
      ),
    );
  }
}

/// `.anim-shimmer`: an empty box; all the paint comes from the utility.
///
/// The tile is `2W` wide and its bright `--accent` midpoint crosses from `−W`
/// to `+3W`, left to right, once per cycle. `background-repeat` defaults to
/// `repeat`, which is why the box is never empty at the extremes: and why
/// [TileMode.repeated] rather than a single band.
class _ShimmerDemo extends StatelessWidget {
  const _ShimmerDemo();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return SizedBox(
      height: _demoHeight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Radii.lg),
        child: KeyframePlayer(
          duration: LoadingShimmerMotion.duration,
          fill: LoadingShimmerMotion.fill,
          repeat: LoadingShimmerMotion.loops,
          // No child: a childless [CustomPaint] takes `constraints.smallest`,
          // and the constraints here are tight on both axes: the stretched
          // panel column for width, the `h-24` above for height.
          builder: (BuildContext context, double t, Widget? child) =>
              CustomPaint(
                painter: _ShimmerPainter(
                  t: t,
                  gradient: LoadingShimmerMotion.gradient(theme),
                ),
              ),
        ),
      ),
    );
  }
}

class _ShimmerPainter extends CustomPainter {
  const _ShimmerPainter({required this.t, required this.gradient});

  final double t;
  final LinearGradient gradient;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect tile = Rect.fromLTWH(
      LoadingShimmerMotion.offsetAt(t, size.width),
      0,
      LoadingShimmerMotion.tileWidth(size.width),
      size.height,
    );
    canvas.drawRect(
      Offset.zero & size,
      Paint()..shader = gradient.createShader(tile),
    );
  }

  @override
  bool shouldRepaint(_ShimmerPainter old) =>
      old.t != t || old.gradient != gradient;
}

/// `.anim-pulse-live`: the only animation allowed to run forever.
///
/// The `box-shadow` is offset 0, blur 0, **spread** 0 → 5px at alpha 0.5 → 0:
/// a hard-edged ring growing out of the 8px dot as it fades. Flutter has no
/// hard CSS spread, so the ring is a filled circle painted behind the dot.
class _PulseLiveDemo extends StatelessWidget {
  const _PulseLiveDemo();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return SizedBox(
      height: _demoHeight,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: space(3),
            vertical: space(1.5),
          ),
          decoration: BoxDecoration(
            color: Palette.success.withValues(alpha: _successWashAlpha),
            borderRadius: BorderRadius.circular(Radii.full),
            border: Border.all(
              color: Palette.success.withValues(alpha: _successBorderAlpha),
              width: BorderWidths.hairline,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              KeyframePlayer(
                duration: LivePulseMotion.duration,
                fill: LivePulseMotion.fill,
                repeat: LivePulseMotion.loops,
                builder: (BuildContext context, double t, Widget? child) =>
                    CustomPaint(
                      painter: _PulseRingPainter(t: t),
                      child: child,
                    ),
                child: SizedBox(
                  width: LivePulseMotion.dotDiameter,
                  height: LivePulseMotion.dotDiameter,
                ),
              ),
              SizedBox(width: space(2.5)),
              // `text-success-ink` is a utility, so it beats `.type-micro`'s
              // own muted colour.
              StyledText(
                'Live',
                TextStyles.eyebrowSmall,
                color: theme.successText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PulseRingPainter extends CustomPainter {
  const _PulseRingPainter({required this.t});

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset centre = size.center(Offset.zero);
    // The ring first: a `box-shadow` paints behind its element.
    canvas.drawCircle(
      centre,
      LivePulseMotion.ringRadiusAt(t),
      Paint()..color = LivePulseMotion.ringColorAt(t),
    );
    canvas.drawCircle(
      centre,
      LivePulseMotion.dotRadius,
      Paint()
        ..color = LivePulseMotion.dotColor.withValues(
          alpha: LivePulseMotion.dotOpacityAt(t),
        ),
    );
  }

  @override
  bool shouldRepaint(_PulseRingPainter old) => old.t != t;
}

/* ── #choreography ───────────────────────────────────────────────────────── */

/// Static: nothing on this section animates. The one sequence allowed to take
/// real time is described, not performed.
class _ChoreographySection extends StatelessWidget {
  const _ChoreographySection();

  @override
  Widget build(BuildContext context) {
    return const Section(
      id: 'choreography',
      title: 'Pack-opening choreography',
      description:
          'The one sequence allowed to take real time. It is built '
          'from the same tokens, and every stage is skippable.',
      child: Meta(
        items: <MetaItem>[
          (
            k: '1 · Pack selected',
            v: TextSpan(
              text: '150ms — border becomes blue, glow-action applies.',
            ),
          ),
          (
            k: '2 · Purchase confirmed',
            v: TextSpan(
              text: '320ms — dialog closes, page dims to the opening stage.',
            ),
          ),
          (
            k: '3 · Pack enters',
            v: TextSpan(
              text:
                  '550ms ease-out — pack scales up into the centre of the '
                  'stage.',
            ),
          ),
          (
            k: '4 · Tear',
            v: TextSpan(
              text:
                  '400ms — blue bloom expands from the pack; particles are '
                  'capped and never flash.',
            ),
          ),
          // D11: 550 + 5×60 is 850ms, not 900. The copy's own arithmetic.
          (
            k: '5 · Cards reveal',
            v: TextSpan(
              text:
                  '550ms each, staggered 60ms. Six cards resolve in roughly '
                  '900ms.',
            ),
          ),
          (
            k: '6 · Rare escalation',
            v: TextSpan(
              text:
                  'Legendary and mythic cards add glow-value and anim-pop-in '
                  'on top of the reveal — nothing longer.',
            ),
          ),
          (
            k: '7 · Summary',
            v: TextSpan(
              text: '250ms anim-fade-up — total value and next actions appear.',
            ),
          ),
          // D12: 300ms is not a duration token.
          (
            k: 'Skip / Turbo',
            v: TextSpan(
              text:
                  'Available from stage 3 onward. Turbo collapses stages 3–6 '
                  'to 300ms total.',
            ),
          ),
        ],
      ),
    );
  }
}

/* ── #reduced ────────────────────────────────────────────────────────────── */

/// The section describes the flag; it does not read it. Every demo above
/// already honours it through `effectiveMotionDuration`, which is this port's
/// blanket `prefers-reduced-motion` rule.
class _ReducedSection extends StatelessWidget {
  const _ReducedSection();

  /// Verbatim, in order. Bullet 2 is drift D10.
  static const List<String> _bullets = <String>[
    'All durations and transitions collapse to 0.01ms.',
    'Looping animations run exactly once, then hold.',
    'Entrances resolve to their final state immediately — opacity 1, no '
        'transform.',
    'The pack-opening sequence jumps straight to the revealed cards and the '
        'results summary.',
    'Nothing is hidden or removed. No information exists only inside an '
        'animation.',
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Section(
      id: 'reduced',
      title: 'Reduced motion',
      description:
          'A required behaviour, not a nicety. The product must stay '
          'fully usable and every value must stay legible with motion switched '
          'off.',
      child: Panel(
        label: 'What prefers-reduced-motion: reduce does',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // `space-y-3`.
            for (int i = 0; i < _bullets.length; i++) ...<Widget>[
              if (i > 0) SizedBox(height: space(3)),
              _ReducedBullet(text: _bullets[i]),
            ],
            SizedBox(height: space(5)),
            Container(
              padding: EdgeInsets.only(top: space(5)),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: theme.border,
                    width: BorderWidths.hairline,
                  ),
                ),
              ),
              child: RichText(
                TextSpan(
                  children: <InlineSpan>[
                    const TextSpan(text: 'Implemented globally in '),
                    Code.span('app/globals.css'),
                    const TextSpan(
                      text:
                          ', so a new component inherits it without opting '
                          'in.',
                    ),
                  ],
                ),
                TextStyles.small,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// `li.type-small.flex.gap-2.5`: a 6px `bg-action` dot on an 8px top margin,
/// then the text.
class _ReducedBullet extends StatelessWidget {
  const _ReducedBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: _bulletTop),
          child: SizedBox(
            width: _bulletSize,
            height: _bulletSize,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Palette.action,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        SizedBox(width: space(2.5)),
        Expanded(child: StyledText(text, TextStyles.small)),
      ],
    );
  }
}
