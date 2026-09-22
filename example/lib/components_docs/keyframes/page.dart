/// Public documentation page for the `keyframes` motion primitive.
///
/// **Why `EffectSection`, not `ShowcaseSection`, and why there is no single
/// widget.** `lib/src/components/ui/keyframes.dart` exports no component: it is
/// twelve data tables (`EnterMotion`, `ExitMotion`, … `SwapRollMotion`) plus
/// one player, `KeyframePlayer`. `SwapRollMotion` is the twelfth and the odd
/// one out — a transition table, explicitly documented as not a keyframe at
/// all. `Press` and `ActiveIndicator` round the vocabulary out to fourteen,
/// each with its own page, but every one of the fourteen is worth seeing on
/// the piece of UI it actually animates rather than as a bare animated box —
/// so this page's one specimen section is fourteen cards, one per motion,
/// each staged on a representative host with its own Replay, plus one
/// Replay all.
///
/// **`pumpAndSettle` never appears in this page's own test.** `SpinMotion`,
/// `ShimmerMotion`, `ProgressMotion` and `PulseMotion` all run on a
/// `repeat()`ing `AnimationController` inside `KeyframePlayer` and never
/// idle, so this page's test uses `tester.pump()` and bounded
/// `tester.pump(duration)` calls throughout, exactly as
/// `example/lib/pages/motion.dart` and `test/motion_test.dart` already do
/// for the same tables.
library;

import 'dart:async';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/gestures.dart';
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

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import 'meta.dart';

final ComponentDocSpec keyframesDocSpec = ComponentDocSpec(
  name: 'keyframes',
  title: 'Keyframes',
  description: keyframesDoc.description,
  sections: <DocsPageSection>[
    EffectSection(
      id: 'the-fourteen',
      title: 'The fourteen',
      description:
          "Use one of these; don't write a new keyframe. They all live in "
          'lib/src/components/ui/keyframes.dart — change that file and '
          'every component follows. Each card plays on the piece of UI it '
          'actually animates: a dialog on its scrim, a list of rows, a '
          'skeleton, the OTP caret, a button being pressed. Replay remounts '
          'a card under a fresh key, or — for the three that answer a '
          'state change rather than a mount (exit, close, press, '
          'toggle-slide, swap-roll are transitions) — flips the same state '
          'the real component flips, for a beat and back.',
      host: const _FourteenGrid(),
      code: _fourteenCode,
      label: 'The fourteen specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'keyframes has a real registry manifest, `elattar add keyframes` '
          'installs lib/src/components/ui/keyframes.dart and resolves its one '
          'registryDependency, source-foundation, automatically. The '
          'Manual tab is for a project not using the CLI.',
      command: keyframesDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/keyframes.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/ui/keyframes.dart's generated "
              '@ui/keyframes.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated keyframes source here when using '
              'manual mode.',
        ),
        DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so every table and KeyframePlayer '
              'are reachable the same way the CLI path already makes '
              'them.',
          code: "export 'keyframes.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'KeyframePlayer runs one table\'s clock and hands linear '
          'progress to builder; the easing lives in the table\'s own '
          'Animatable, never in the player.',
      code: _usageCode,
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'The fourteen keyframe tables this file exports, by name, read '
          'off lib/src/components/ui/keyframes.dart: what each animates, and the '
          'duration, curve and fill mode it runs under. SwapRollMotion — a '
          'transition, not a keyframe — follows in its own paragraph.',
      child: const _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      child: const _StatesContent(),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      child: const _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      child: const _KeyboardContent(),
    ),
    DisclosureSection(
      id: 'responsive',
      title: 'Responsive',
      child: const _ResponsiveContent(),
    ),
    DisclosureSection(
      id: 'dependencies',
      title: 'Dependencies',
      child: const _DependenciesContent(),
    ),
    DisclosureSection(
      id: 'theming',
      title: 'Theming',
      child: const _ThemingContent(),
    ),
    DisclosureSection(
      id: 'source',
      title: 'Source',
      child: DocsInstallFacts(
        title: 'Reference',
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Source',
            value: keyframesDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/motion_test.dart',
            description:
                'Every table in this file has its own group in the shared '
                'motion suite, sampled against the stopTolerance the file '
                'itself documents.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/keyframes_test.dart',
            description:
                'Covers this page: the article mounts, the full API '
                'table, a live replay and a live loop advance, and both '
                'themes — never with pumpAndSettle.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/keyframes/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class KeyframesDocPage extends StatelessWidget {
  const KeyframesDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: keyframesDoc.route,
    intro: DocsPageIntro(
      title: keyframesDoc.title,
      description: keyframesDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Keyframes'),
    ],
    toc: keyframesDocSpec.toc,
    previous: null,
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('keyframes-doc-article'),
      child: ComponentDocPage(spec: keyframesDocSpec, header: false),
    ),
  );
}

/* ── The fourteen ────────────────────────────────────────────────────────── */

/// One card's spec: its name (as code), its one-line "what it is for", and
/// the stage it plays on.
class _CardSpec {
  const _CardSpec({
    required this.id,
    required this.name,
    required this.what,
    required this.builder,
    this.transition = false,
  });

  /// A short, key-safe id — `keyframes-example:<id>`.
  final String id;

  /// The class name, shown as code in the card header.
  final String name;

  /// The one-line caption, adapted from the web reference verbatim where the
  /// web names a CSS custom property or utility this Dart API replaces.
  final String what;

  /// True for the five cards that answer a state change rather than a
  /// mount: Replay flips a flag for a beat (`MotionDurations.hoverCardShowDelay`,
  /// 700ms — an existing token, reused rather than a new literal) and back,
  /// exactly as `on` did on the reference page. Every other card remounts
  /// under a fresh key.
  final bool transition;

  /// Builds the stage. [run] is the remount counter (bumped by this card's
  /// own Replay and by Replay all); [on] is true for the beat after a
  /// transition Replay.
  final Widget Function(BuildContext context, int run, bool on) builder;
}

/// The four rows [_enterStage] and [_exitStage] both stage.
class _StageRow extends StatelessWidget {
  const _StageRow({this.opacity = 1, this.translateY = 0, this.scale = 1});

  final double opacity;
  final double translateY;
  final double scale;

  static double get width => space(40);
  static double get height => space(6);

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: Transform.translate(
        offset: Offset(0, translateY),
        child: Transform.scale(
          scale: scale,
          child: Container(
            width: width,
            height: height,
            padding: EdgeInsets.symmetric(horizontal: space(2)),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: theme.card,
              border: Border.all(
                color: theme.border,
                width: BorderWidths.hairline,
              ),
              borderRadius: BorderRadius.circular(Radii.md),
            ),
            child: Container(
              height: space(1.5),
              width: space(20),
              decoration: BoxDecoration(
                color: theme.muted,
                borderRadius: BorderRadius.circular(Radii.full),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// enter — four rows, staggered with [EnterMotion.delayFor].
///
/// One controller runs the whole stagger; each row reads its own local
/// progress off it rather than owning a player of its own, which is what
/// lets `EnterMotion.delayFor(index)` — the stagger step the reference
/// spells `--enter-stage` — read the same way a caller reads it.
class _EnterRows extends StatefulWidget {
  const _EnterRows();

  @override
  State<_EnterRows> createState() => _EnterRowsState();
}

class _EnterRowsState extends State<_EnterRows>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static Duration get _total => EnterMotion.duration + EnterMotion.delayFor(3);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _total)
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    builder: (BuildContext context, Widget? child) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (int i = 0; i < 4; i++) ...<Widget>[
          if (i > 0) SizedBox(height: space(1.5)),
          _rowAt(i),
        ],
      ],
    ),
  );

  Widget _rowAt(int i) {
    final double elapsedMs =
        _controller.value * _total.inMilliseconds.toDouble();
    final double delayMs = EnterMotion.delayFor(i).inMilliseconds.toDouble();
    final double durationMs = EnterMotion.duration.inMilliseconds.toDouble();
    final double local = durationMs == 0
        ? 1
        : ((elapsedMs - delayMs) / durationMs).clamp(0.0, 1.0);
    return _StageRow(
      opacity: EnterMotion.opacity.transform(local),
      translateY: EnterMotion.translateY.transform(local),
      scale: EnterMotion.scale.transform(local),
    );
  }
}

Widget _enterStage(BuildContext context, int run, bool on) =>
    KeyedSubtree(key: ValueKey<String>('enter-$run'), child: const _EnterRows());

/// exit — the same four rows, statically at rest; the second one leaves on
/// Replay (playing [ExitMotion] once) and comes back — no animation class at
/// all once the beat ends, exactly as the reference's `still` rows carry
/// none.
class _ExitRows extends StatelessWidget {
  const _ExitRows({required this.run, required this.on});

  final int run;
  final bool on;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      for (int i = 0; i < 4; i++) ...<Widget>[
        if (i > 0) SizedBox(height: space(1.5)),
        if (i == 1 && on)
          KeyedSubtree(
            key: ValueKey<String>('exit-$run'),
            child: KeyframePlayer(
              duration: ExitMotion.duration,
              fill: ExitMotion.fill,
              builder: (BuildContext context, double t, Widget? child) =>
                  _StageRow(
                    opacity: ExitMotion.opacity.transform(t),
                    translateY: ExitMotion.translateY.transform(t),
                    scale: ExitMotion.scale.transform(t),
                  ),
            ),
          )
        else
          const _StageRow(),
      ],
    ],
  );
}

Widget _exitStage(BuildContext context, int run, bool on) =>
    _ExitRows(run: run, on: on);

/// The scrim alpha the reference's `bg-background/60` names, shared by the
/// open and close stages.
const double _scrimAlpha = 0.6;

// Title only, no description: the card's stage area is a fixed
// space(36) high, and a two-line CardHeader does not fit it once the
// scrim and the stage's own padding are accounted for.
Widget _overlayDialog(BuildContext context) => SizedBox(
  width: space(44),
  child: const Card(children: <Widget>[CardHeader(title: CardTitle('Delete pack?'))]),
);

/// open — a dialog on its scrim, driven forward once per remount by
/// [OpenTransition].
class _OpenStage extends StatefulWidget {
  const _OpenStage();

  @override
  State<_OpenStage> createState() => _OpenStageState();
}

class _OpenStageState extends State<_OpenStage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: OpenMotion.duration)
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    // No fixed size: the Stack takes the dialog's own natural size (the one
    // non-positioned child), so text scaled to 200% grows the card instead
    // of overflowing a pixel box.
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget? child) => Opacity(
              opacity:
                  EnterMotion.opacity.transform(_controller.value).clamp(
                        0.0,
                        1.0,
                      ) *
                  _scrimAlpha,
              child: DecoratedBox(
                decoration: BoxDecoration(color: theme.background),
              ),
            ),
          ),
        ),
        OpenTransition(animation: _controller, child: _overlayDialog(context)),
      ],
    );
  }
}

Widget _openStage(BuildContext context, int run, bool on) =>
    KeyedSubtree(key: ValueKey<String>('open-$run'), child: const _OpenStage());

/// close — the same overlay leaving. Replay reverses the controller
/// (playing [CloseMotion]); when the beat ends the dialog pops back, no
/// animation at all, matching the reference's own edge.
class _CloseStage extends StatefulWidget {
  const _CloseStage({required this.on});

  final bool on;

  @override
  State<_CloseStage> createState() => _CloseStageState();
}

class _CloseStageState extends State<_CloseStage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      value: 1,
      duration: OpenMotion.duration,
      reverseDuration: CloseMotion.duration,
    );
  }

  @override
  void didUpdateWidget(_CloseStage old) {
    super.didUpdateWidget(old);
    if (widget.on && !old.on) {
      _controller.reverse(from: 1);
    } else if (!widget.on && old.on) {
      _controller.value = 1;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget? child) => Opacity(
              opacity: _controller.value.clamp(0.0, 1.0) * _scrimAlpha,
              child: DecoratedBox(
                decoration: BoxDecoration(color: theme.background),
              ),
            ),
          ),
        ),
        OpenTransition(animation: _controller, child: _overlayDialog(context)),
      ],
    );
  }
}

Widget _closeStage(BuildContext context, int run, bool on) =>
    _CloseStage(on: on);

/// expand — a real [Accordion] panel, auto-opened one frame after each
/// remount, the way the reference's own key-remounted div plays its unfold
/// on mount rather than waiting for a tap.
class _ExpandStage extends StatefulWidget {
  const _ExpandStage();

  @override
  State<_ExpandStage> createState() => _ExpandStageState();
}

class _ExpandStageState extends State<_ExpandStage> {
  bool _open = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _open = true);
    });
  }

  @override
  // Unconstrained width — a narrower box risks the trigger label and
  // content wrapping to a second line, which, combined with
  // MotionCurves.emphasized's own overshoot on the way open, is what
  // pushed the panel a fraction of a pixel past this card's fixed
  // space(36) stage.
  Widget build(BuildContext context) => Accordion(
    items: <AccordionItem>[
      AccordionItem(
        title: 'Shipping',
        content: StyledText(
          'Ships free.',
          TextStyles.small,
          color: ThemeScope.of(context).mutedForeground,
        ),
      ),
    ],
    openIndex: _open ? 0 : null,
    // Decorative: this card auto-plays the unfold rather than waiting on
    // a tap, matching the reference's own key-remounted specimen.
    onChanged: (int? _) {},
  );
}

Widget _expandStage(BuildContext context, int run, bool on) => KeyedSubtree(
  key: ValueKey<String>('expand-$run'),
  child: const _ExpandStage(),
);

/// change — a value tile that flips between two figures, squashing in with
/// [ChangeMotion] on every remount.
Widget _changeStage(BuildContext context, int run, bool on) {
  final ThemeTokens theme = ThemeScope.of(context);
  return KeyedSubtree(
    key: ValueKey<String>('change-$run'),
    child: KeyframePlayer(
      duration: ChangeMotion.duration,
      fill: ChangeMotion.fill,
      builder: (BuildContext context, double t, Widget? child) {
        final Offset scale = ChangeMotion.scale.transform(t);
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.diagonal3Values(scale.dx, scale.dy, 1),
          child: child,
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: space(6), vertical: space(3)),
        decoration: BoxDecoration(
          color: theme.card,
          border: Border.all(color: theme.border, width: BorderWidths.hairline),
          borderRadius: BorderRadius.circular(Radii.lg),
        ),
        child: StyledText(
          run.isEven ? r'$1,240' : r'$2,480',
          TextStyles.numberMd,
          color: theme.premiumText,
        ),
      ),
    ),
  );
}

/// spin — the real [Spinner].
Widget _spinStage(BuildContext context, int run, bool on) => KeyedSubtree(
  key: ValueKey<String>('spin-$run'),
  child: Spinner(size: space(8)),
);

/// shimmer — three real [Skeleton]s.
Widget _shimmerStage(BuildContext context, int run, bool on) => KeyedSubtree(
  key: ValueKey<String>('shimmer-$run'),
  child: SizedBox(
    width: space(40),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Skeleton(height: space(3)),
        SizedBox(height: space(2)),
        Skeleton(height: space(3), width: space(30)),
        SizedBox(height: space(2)),
        Skeleton(height: space(3), width: space(20)),
      ],
    ),
  ),
);

/// progress — an indeterminate sweep built from [ProgressMotion] directly.
///
/// DEVIATION FROM BRIEF: the brief asks for "the real `Progress()` with no
/// value", but `lib/src/components/ui/progress.dart`'s [Progress] declares
/// `value` as a required, non-nullable `double` — the port never grew an
/// indeterminate mode, so there is no such call to make. This reproduces the
/// same sweep the pre-existing Progress section on this page already built
/// from [ProgressMotion] and a themed channel, rather than inventing a fake
/// widget or silently skipping the card.
Widget _progressStage(BuildContext context, int run, bool on) {
  final ThemeTokens theme = ThemeScope.of(context);
  return KeyedSubtree(
    key: ValueKey<String>('progress-$run'),
    child: SizedBox(
      width: space(40),
      height: space(3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Radii.sm),
        child: DecoratedBox(
          decoration: BoxDecoration(color: theme.muted),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) =>
                KeyframePlayer(
                  duration: ProgressMotion.duration,
                  fill: KeyframeFill.none,
                  repeat: true,
                  builder: (BuildContext context, double t, Widget? child) {
                    final double width = constraints.maxWidth;
                    final double fraction =
                        ProgressMotion.fromFraction +
                        (ProgressMotion.toFraction -
                                ProgressMotion.fromFraction) *
                            t;
                    return Transform.translate(
                      offset: Offset(fraction * width, 0),
                      child: SizedBox(
                        width: width * ProgressMotion.sliverFraction,
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: theme.primary),
                        ),
                      ),
                    );
                  },
                ),
          ),
        ),
      ),
    ),
  );
}

/// pulse — the live dot, [PulseMotion]'s ring painted around it.
Widget _pulseStage(BuildContext context, int run, bool on) => KeyedSubtree(
  key: ValueKey<String>('pulse-$run'),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      SizedBox(
        width: space(6),
        height: space(6),
        child: KeyframePlayer(
          duration: PulseMotion.duration,
          fill: PulseMotion.fill,
          repeat: PulseMotion.loops,
          builder: (BuildContext context, double t, Widget? child) =>
              CustomPaint(painter: _PulseLivePainter(t: t)),
        ),
      ),
      SizedBox(width: space(2)),
      StyledText(
        'Live',
        TextStyles.small,
        color: ThemeScope.of(context).successText,
      ),
    ],
  ),
);

/// caret — four OTP boxes, the third carrying [CaretMotion]'s hard-cut
/// blink.
Widget _caretStage(BuildContext context, int run, bool on) {
  final ThemeTokens theme = ThemeScope.of(context);
  const List<String> digits = <String>['4', '8', '', ''];
  return KeyedSubtree(
    key: ValueKey<String>('caret-$run'),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < 4; i++) ...<Widget>[
          if (i > 0) SizedBox(width: space(1.5)),
          Container(
            width: space(7),
            height: space(9),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.card,
              border: Border.all(
                color: theme.border,
                width: BorderWidths.hairline,
              ),
              borderRadius: BorderRadius.circular(Radii.md),
            ),
            child: i == 2
                ? KeyframePlayer(
                    duration: CaretMotion.duration,
                    fill: KeyframeFill.none,
                    repeat: CaretMotion.loops,
                    builder: (BuildContext context, double t, Widget? child) =>
                        Opacity(
                          opacity: CaretMotion.visibleAt(t) ? 1 : 0,
                          child: child,
                        ),
                    child: Container(
                      width: BorderWidths.hairline,
                      height: space(4),
                      color: theme.foreground,
                    ),
                  )
                : StyledText(
                    digits[i],
                    TextStyles.numberSm,
                    color: theme.foreground,
                  ),
          ),
        ],
      ],
    ),
  );
}

/// press — a real [Button], driven into its own pressed state by a
/// synthetic pointer down and, [MotionDurations.hoverCardShowDelay] (700ms
/// — an existing token, not a new literal) later, a synthetic pointer up.
/// [Button.suppressPressScale] is not set: the squish shown is the button's
/// own, exactly as a real press produces it — this card is not a `Press`
/// demo, `Press` already has its own page.
class _PressStage extends StatefulWidget {
  const _PressStage({required this.on});

  final bool on;

  @override
  State<_PressStage> createState() => _PressStageState();
}

class _PressStageState extends State<_PressStage> {
  final GlobalKey _buttonKey = GlobalKey();
  int _pointer = 0;

  @override
  void didUpdateWidget(_PressStage old) {
    super.didUpdateWidget(old);
    if (widget.on && !old.on) _sendDown();
    if (!widget.on && old.on) _sendUp();
  }

  Offset? _center() {
    final RenderObject? object = _buttonKey.currentContext
        ?.findRenderObject();
    if (object is! RenderBox || !object.hasSize) return null;
    return object.localToGlobal(object.size.center(Offset.zero));
  }

  void _sendDown() {
    final Offset? center = _center();
    if (center == null) return;
    _pointer += 1;
    GestureBinding.instance.handlePointerEvent(
      PointerDownEvent(pointer: _pointer, position: center),
    );
  }

  void _sendUp() {
    final Offset? center = _center();
    if (center == null) return;
    GestureBinding.instance.handlePointerEvent(
      PointerUpEvent(pointer: _pointer, position: center),
    );
  }

  @override
  Widget build(BuildContext context) => Button(
    key: _buttonKey,
    onPressed: () {},
    child: const Text('Continue'),
  );
}

Widget _pressStage(BuildContext context, int run, bool on) =>
    _PressStage(on: on);

/// toggle-slide — a real [ActiveIndicator], its pill travelling between
/// "Inbox" and "Sent".
Widget _toggleLabel(BuildContext context, String label) => Padding(
  padding: EdgeInsets.symmetric(horizontal: space(4), vertical: space(1.5)),
  child: StyledText(
    label,
    TextStyles.small,
    color: ThemeScope.of(context).foreground,
  ),
);

Widget _toggleSlideStage(BuildContext context, int run, bool on) {
  final ThemeTokens theme = ThemeScope.of(context);
  return ActiveIndicator(
    activeIndex: on ? 1 : 0,
    padding: EdgeInsets.all(space(1)),
    indicator: DecoratedBox(
      decoration: BoxDecoration(
        color: theme.accent,
        borderRadius: BorderRadius.circular(Radii.full),
      ),
    ),
    children: <Widget>[
      _toggleLabel(context, 'Inbox'),
      _toggleLabel(context, 'Sent'),
    ],
  );
}

/// swap-roll — a real [IconSwap], heart rolling into star.
Widget _swapRollStage(BuildContext context, int run, bool on) {
  final ThemeTokens theme = ThemeScope.of(context);
  return Container(
    width: space(10),
    height: space(10),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: theme.card,
      border: Border.all(color: theme.border, width: BorderWidths.hairline),
      borderRadius: BorderRadius.circular(Radii.lg),
    ),
    child: IconSwap(
      activeIndex: on ? 1 : 0,
      window: space(5),
      cell: space(4),
      icons: const <Widget>[
        Icon(IconGlyph.heart, tone: IconTone.action),
        Icon(IconGlyph.star, tone: IconTone.value),
      ],
    ),
  );
}

final List<_CardSpec> _cardSpecs = <_CardSpec>[
  _CardSpec(
    id: 'enter',
    name: 'EnterMotion',
    what: 'Anything appearing. Rows stagger with EnterMotion.delayFor.',
    builder: _enterStage,
  ),
  _CardSpec(
    id: 'exit',
    name: 'ExitMotion',
    what: 'Anything leaving. Quicker than arriving.',
    transition: true,
    builder: _exitStage,
  ),
  _CardSpec(
    id: 'open',
    name: 'OpenMotion',
    what: 'Dialogs, popovers, menus, tooltips opening.',
    builder: _openStage,
  ),
  _CardSpec(
    id: 'close',
    name: 'CloseMotion',
    what: 'The same overlay leaving.',
    transition: true,
    builder: _closeStage,
  ),
  _CardSpec(
    id: 'expand',
    name: 'ExpandMotion',
    what:
        'Accordions and collapsibles. The reverse leg '
        '(ExpandMotion.collapseDuration) closes them.',
    builder: _expandStage,
  ),
  _CardSpec(
    id: 'change',
    name: 'ChangeMotion',
    what: 'A value that just changed. Also the checkbox tick and radio dot.',
    builder: _changeStage,
  ),
  _CardSpec(id: 'spin', name: 'SpinMotion', what: 'The spinner.', builder: _spinStage),
  _CardSpec(
    id: 'shimmer',
    name: 'ShimmerMotion',
    what:
        'Skeleton loading. ShimmerMotion.textDuration is the same sweep '
        'through text.',
    builder: _shimmerStage,
  ),
  _CardSpec(
    id: 'progress',
    name: 'ProgressMotion',
    what: "A progress bar that doesn't know how long.",
    builder: _progressStage,
  ),
  _CardSpec(
    id: 'pulse',
    name: 'PulseMotion',
    what: 'The live dot.',
    builder: _pulseStage,
  ),
  _CardSpec(
    id: 'caret',
    name: 'CaretMotion',
    what: 'The cursor in a one-time-code input.',
    builder: _caretStage,
  ),
  _CardSpec(
    id: 'press',
    name: 'Press',
    what: 'Anything clickable: shrinks to 90% while held, springs back.',
    transition: true,
    builder: _pressStage,
  ),
  _CardSpec(
    id: 'toggle-slide',
    name: 'ActiveIndicator',
    what: 'The selected-item pill moving to the new item.',
    transition: true,
    builder: _toggleSlideStage,
  ),
  _CardSpec(
    id: 'swap-roll',
    name: 'SwapRollMotion',
    what: 'One icon rolling into another, like a wheel.',
    transition: true,
    builder: _swapRollStage,
  ),
];

class _ReplayIconButton extends StatelessWidget {
  const _ReplayIconButton({
    required this.onTap,
    required this.semanticLabel,
    this.keyValue,
  });

  final VoidCallback onTap;
  final String semanticLabel;
  final String? keyValue;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return SizedBox(
      key: keyValue == null ? null : ValueKey<String>(keyValue!),
      child: Press(
        onTap: onTap,
        semanticLabel: semanticLabel,
        focusRadius: Radii.full,
        child: Container(
          width: space(8),
          height: space(8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.secondary,
            shape: BoxShape.circle,
          ),
          child: DefaultTextStyle(
            style: DefaultTextStyle.of(
              context,
            ).style.copyWith(color: theme.secondaryForeground),
            child: const Icon(
              IconGlyph.refreshCw,
              size: IconSize.sm,
              tone: IconTone.inherit,
            ),
          ),
        ),
      ),
    );
  }
}

/// One card: the name as code, a Replay button, the stage, and the caption.
class _MotionCard extends StatefulWidget {
  const _MotionCard({required this.spec, required this.replayAll});

  final _CardSpec spec;
  final Listenable replayAll;

  @override
  State<_MotionCard> createState() => _MotionCardState();
}

class _MotionCardState extends State<_MotionCard> {
  int _run = 0;
  bool _on = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    widget.replayAll.addListener(_replay);
  }

  @override
  void dispose() {
    widget.replayAll.removeListener(_replay);
    _timer?.cancel();
    super.dispose();
  }

  void _replay() {
    _timer?.cancel();
    setState(() {
      _run++;
      if (widget.spec.transition) _on = true;
    });
    if (widget.spec.transition) {
      _timer = Timer(MotionDurations.hoverCardShowDelay, () {
        if (mounted) setState(() => _on = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Container(
      key: ValueKey<String>('keyframes-example:${widget.spec.id}'),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(color: theme.border, width: BorderWidths.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: space(3),
              vertical: space(2),
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.border,
                  width: BorderWidths.hairline,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: StyledText(
                    '.${widget.spec.name}',
                    TextStyles.code,
                    color: theme.actionText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: space(2)),
                _ReplayIconButton(
                  onTap: _replay,
                  semanticLabel: 'Replay ${widget.spec.name}',
                  keyValue: 'keyframes-example:${widget.spec.id}-replay',
                ),
              ],
            ),
          ),
          // A minimum, not a fixed height: at rest every card reads as the
          // same size, but a stage whose content needs more room — text
          // scaled to 200%, an accordion's own MotionCurves.emphasized
          // overshoot — is allowed to take it rather than overflow.
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: space(36)),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(space(3)),
              // A bare horizontal SingleChildScrollView hands its child an
              // *infinite* width, which crashes anything that fills it —
              // the accordion and ActiveIndicator both stretch. LayoutBuilder
              // reads the real, finite width first, so the scroll view's
              // child gets a generous but bounded box: wide enough for
              // scaled text to still fit without a hard overflow, never
              // infinite.
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints outer) {
                  final double safeWidth = outer.maxWidth.isFinite
                      ? outer.maxWidth
                      : space(84);
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: safeWidth,
                        maxWidth: safeWidth * 3,
                      ),
                      child: widget.spec.builder(context, _run, _on),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: space(3),
              vertical: space(2),
            ),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: theme.border,
                  width: BorderWidths.hairline,
                ),
              ),
            ),
            child: StyledText(
              widget.spec.what,
              TextStyles.small,
              color: theme.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

class _FourteenGrid extends StatefulWidget {
  const _FourteenGrid();

  @override
  State<_FourteenGrid> createState() => _FourteenGridState();
}

class _FourteenGridState extends State<_FourteenGrid> {
  final ValueNotifier<int> _replayAll = ValueNotifier<int>(0);

  @override
  void dispose() {
    _replayAll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            key: const ValueKey<String>('keyframes-example:replay-all'),
            child: Press(
              onTap: () => _replayAll.value++,
              child: Container(
                height: space(9),
                padding: EdgeInsets.symmetric(horizontal: space(4)),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.secondary,
                  borderRadius: BorderRadius.circular(Radii.full),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    DefaultTextStyle(
                      style: DefaultTextStyle.of(
                        context,
                      ).style.copyWith(color: theme.secondaryForeground),
                      child: const Icon(
                        IconGlyph.refreshCw,
                        size: IconSize.sm,
                        tone: IconTone.inherit,
                      ),
                    ),
                    SizedBox(width: space(2)),
                    Flexible(
                      child: StyledText(
                        'Replay all',
                        TextStyles.small,
                        color: theme.secondaryForeground,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: space(4)),
        Wrap(
          spacing: space(4),
          runSpacing: space(4),
          children: <Widget>[
            for (final _CardSpec spec in _cardSpecs)
              SizedBox(
                width: space(84),
                child: _MotionCard(spec: spec, replayAll: _replayAll),
              ),
          ],
        ),
      ],
    );
  }
}

const String _fourteenCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    '// A one-shot recipe: remount under a fresh key to replay.\n'
    "KeyedSubtree(\n"
    "  key: ValueKey('enter-\$run'),\n"
    '  child: KeyframePlayer(\n'
    '    duration: EnterMotion.duration,\n'
    '    fill: EnterMotion.fill,\n'
    '    builder: (context, t, child) => Opacity(\n'
    '      opacity: EnterMotion.opacity.transform(t),\n'
    '      child: Transform.translate(\n'
    '        offset: Offset(0, EnterMotion.translateY.transform(t)),\n'
    '        child: child,\n'
    '      ),\n'
    '    ),\n'
    "    child: const Row(...),\n"
    '  ),\n'
    ')\n\n'
    '// A transition: flip the same state the real component flips.\n'
    'OpenTransition(animation: controller, child: dialog)\n'
    'ActiveIndicator(activeIndex: selected, indicator: pill, children: options)\n'
    "IconSwap(activeIndex: selected, icons: {...}, window: 20, cell: 16)";

/// The [PulseMotion] ring, painted around a live dot. Shared with the
/// pulse card.
class _PulseLivePainter extends CustomPainter {
  const _PulseLivePainter({required this.t});

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    canvas.drawCircle(
      center,
      PulseMotion.ringRadiusAt(t),
      Paint()..color = PulseMotion.ringColorAt(t),
    );
    canvas.drawCircle(
      center,
      PulseMotion.dotRadius,
      Paint()
        ..color = PulseMotion.dotColor.withValues(
          alpha: PulseMotion.dotOpacityAt(t),
        ),
    );
  }

  @override
  bool shouldRepaint(covariant _PulseLivePainter oldDelegate) =>
      oldDelegate.t != t;
}

/* ── Disclosure content ─────────────────────────────────────────────────── */

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

KeyframePlayer(
  duration: EnterMotion.duration,
  fill: EnterMotion.fill,
  builder: (context, t, child) {
    final scale = EnterMotion.scale.transform(t);
    return Opacity(
      opacity: EnterMotion.opacity.transform(t),
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.diagonal3Values(scale.dx, scale.dy, 1),
        child: child,
      ),
    );
  },
  child: const NotificationCard(),
)''';

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const DocsApiTable(title: 'The twelve keyframes', facts: _apiFacts),
      SizedBox(height: space(4)),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
        child: StyledText(
          'SwapRollMotion is the twelfth entry and the odd one out: it is a '
          'transition (a from-state and a to-state, no stops), running '
          'MotionDurations.slow (400ms) on MotionCurves.emphasized — see '
          'its swap-roll card above. Press and ActiveIndicator round '
          'the vocabulary out to fourteen; each is documented on its own '
          'page.',
          TextStyles.small,
          color: ThemeScope.of(context).mutedForeground,
        ),
      ),
    ],
  );
}

const List<DocsApiFact> _apiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'EnterMotion',
    type: 'both · slow (400ms) · ease-enter',
    description:
        'Opacity 0 → 1, a 12px translateY rise to 0, and a 0.97 → 1 '
        'scale, together: content arriving in place.',
  ),
  DocsApiFact(
    name: 'ExitMotion',
    type: 'both · fast (150ms) · ease-exit',
    description:
        'Opacity 1 → 0, a 6px translateY drop, and a 1 → 0.98 scale: '
        'content leaving in place, the mirror of EnterMotion.',
  ),
  DocsApiFact(
    name: 'OpenMotion',
    type: 'both · open (420ms) · ease-spring',
    description:
        'Opacity, scale and translateY together: an overlay\'s own '
        'arrival — opacity 0 → 1 by 60%, scale 0.92 → 1.02 → 1, '
        'translateY 24px → -4px → 0.',
  ),
  DocsApiFact(
    name: 'CloseMotion',
    type: 'both · normal (250ms) · ease-move',
    description:
        'An overlay\'s exit: opacity held at 1 through 30% then to 0, '
        'scale 1 → 1.01 → 0.94, translateY 0 → -4px → 16px — an '
        'anticipation tick before it drops away.',
  ),
  DocsApiFact(
    name: 'ExpandMotion',
    type: 'n/a · open forward / normal reverse · ease-spring / ease-move',
    description:
        'Disclosure on height. No Animatable of its own — a collapsible '
        'or accordion drives a SizeTransition directly off this '
        'duration/curve pair, forward to open and reverse to collapse.',
  ),
  DocsApiFact(
    name: 'ChangeMotion',
    type: 'both · stateChange (600ms) · ease-enter',
    description:
        'Scale only, squash-and-stretch: 1 → 1.18×0.82 (30%) → '
        '0.88×1.12 (45%) → 1.06×0.94 (60%) → 0.98×1.02 (78%) → 1. "This '
        'value just changed" — every selection indicator plays it whole, '
        'painted at rest, on mount.',
  ),
  DocsApiFact(
    name: 'SpinMotion',
    type: 'none · spin (900ms) · linear, loops',
    description: 'One full turn, uneased: the loading spinner\'s rotation.',
  ),
  DocsApiFact(
    name: 'ShimmerMotion',
    type: 'none · shimmer (1400ms) / shimmerText (2600ms) · ease-move, loops',
    description:
        'A 2×-wide gradient band sweeping across a skeleton or a status '
        'line, tiled so the box is never empty at the extremes.',
  ),
  DocsApiFact(
    name: 'ProgressMotion',
    type: 'none · shimmer (1400ms) · linear, loops',
    description:
        'A third-width sliver sweeping −100% → 300%: the indeterminate '
        'progress bar.',
  ),
  DocsApiFact(
    name: 'PulseMotion',
    type: 'none · pulseLive (2000ms) · ease-move, loops',
    description:
        'A ring expanding outward while it fades, around a dot whose own '
        'opacity breathes: the live-status indicator.',
  ),
  DocsApiFact(
    name: 'CaretMotion',
    type: 'n/a · caret (1000ms) · steps(1, end), loops',
    description:
        'On for half the period, off for half — a hard cut, no '
        'interpolation: the OTP field\'s fake caret.',
  ),
  DocsApiFact(
    name: 'SwapRollMotion',
    type: 'transition · slow (400ms) · ease-spring',
    description:
        'Not an animation but a transition: translateY by 160% of the '
        'cell\'s own height per step, and opacity, whenever the wheel\'s '
        'offset changes — the IconSwap roll.',
  ),
];

class _StatesContent extends StatelessWidget {
  const _StatesContent();

  @override
  Widget build(
    BuildContext context,
  ) => _bullets(ThemeScope.of(context), <String>[
    'This file has no "component state" of its own — each table is '
        'data, and KeyframePlayer is the one place a run state lives: '
        'forward-once (EnterMotion, ExitMotion, OpenMotion, CloseMotion, '
        'ChangeMotion, all fill: both) or repeat() forever (SpinMotion, '
        'ShimmerMotion, ProgressMotion, PulseMotion, all fill: none). '
        'ExpandMotion, CaretMotion and SwapRollMotion declare no fill at '
        'all — none of the three is driven by KeyframePlayer.',
    'Reduced motion is the one real state every table answers to. '
        'KeyframePlayer reads effectiveMotionDuration on every build: '
        'under MediaQuery.disableAnimations the controller stops and '
        'its value snaps outright — never a zero-length animation — '
        'to upperBound for a both-fill table (holding its final '
        'stop) or to lowerBound for a none-fill looper (reverting to '
        'the element\'s own resting style, stop 0).',
    'A both-fill table never restarts on its own: replay is remount, '
        'a fresh KeyedSubtree — see the fourteen cards above, each with '
        'its own Replay.',
  ]);
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'KeyframePlayer renders no Semantics node: build() returns an '
            'AnimatedBuilder, wrapped in a RepaintBoundary only when '
            'repeat is true. Whatever semantics the builder\'s own output '
            'carries pass through untouched.',
        'CaretMotion is the one table with a hard cut rather than an '
            'interpolation: on for half its 1000ms period, off for the '
            'other half, a square wave rather than a fade — well under '
            'the WCAG 3Hz flash threshold, but worth naming because '
            'nothing else on this page cuts rather than eases.',
        'Nothing here announces that a surface is animating: reduced '
            'motion is the only accessibility lever this file exposes, '
            'and it is read automatically from the platform, never from '
            'a widget-level toggle.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Takes no focus and handles no key: none of the twelve tables '
            'or KeyframePlayer itself declare a Focus, a FocusNode or '
            'an onKeyEvent. Every specimen on this page that responds to '
            'a tap — each card\'s own Replay button, the Replay all '
            'button, the open/close and press/toggle-slide/swap-roll '
            'cards\' interactive hosts — does so through the Press or '
            'the real component this page composes around it, not '
            'through anything keyframes.dart exposes.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(
    BuildContext context,
  ) => _bullets(ThemeScope.of(context), <String>[
    'No breakpoint branching anywhere in keyframes.dart: '
        'BuildContext width is never read for a layout decision.',
    'Every geometric table (ShimmerMotion\'s tile, SwapRollMotion\'s '
        'travel) is expressed as a function of the host\'s own size — '
        'tileWidth(width), travelFor(cellHeight) — so the motion scales '
        'with whatever box a caller gives it, exactly like a CSS '
        'background-size or a percentage transform would.',
  ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ThemeScope.of(context), <String>[
        'File: lib/src/components/ui/keyframes.dart: one file, no companions.',
        'Flutter imports: dart:math, package:flutter/widgets.dart.',
        'Foundation imports: foundation/colors.dart (OklabColor, Palette, '
            'for PulseMotion\'s ring), foundation/motion.dart '
            '(MotionDurations, MotionCurves, effectiveMotionDuration), '
            'foundation/spacing.dart (space), foundation/theme.dart, '
            'theme_scope.dart.',
        'registryDependencies, resolved automatically by `elattar add '
            'keyframes`: source-foundation — copied verbatim from '
            'registry/components/keyframes.json.',
        'Real use in this corpus: active_indicator.dart\'s own private '
            '_jellyScale is the pattern Keyframes.track generalises; '
            'icon_swap.dart composes ChangeMotion with SwapRollMotion for its own '
            'arrival squash; the checkbox and the radio both consume '
            'ChangeMotion directly, on mount, painted whole; open_transition.dart '
            'composes OpenMotion and CloseMotion into the one overlay '
            'transition every dialog, popover, menu and tooltip shares.',
      ]),
      SizedBox(height: space(2)),
      DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Press', route: '/components/press'),
          DocsLink(
            label: 'Active Indicator',
            route: '/components/active_indicator',
          ),
          DocsLink(label: 'Icon Swap', route: '/components/icon_swap'),
          DocsLink(
            label: 'Source Foundation',
            route: '/components/source_foundation',
          ),
        ],
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(
    BuildContext context,
  ) => _bullets(ThemeScope.of(context), <String>[
    'Every table in this file is theme-blind: the geometry, the '
        'durations and the curves are all constants. The one that '
        'touches colour at all resolves it live rather than storing '
        'it: PulseMotion.ringColorAt mixes a fixed ink against '
        'OklabColor.mix, read fresh on every frame rather than cached.',
    'What actually flips with the theme on this page is the host '
        'around each table: the card fill (theme.card), its border '
        '(theme.border) and the icon tones passed to Icon — the '
        'same as any other specimen on the kit.',
  ]);
}

Widget _bullets(ThemeTokens theme, List<String> lines) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    for (final String line in lines) ...<Widget>[
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
        child: StyledText(
          '•  $line',
          TextStyles.small,
          color: theme.mutedForeground,
        ),
      ),
      SizedBox(height: space(2)),
    ],
  ],
);
