/// An agent run console.
///
/// A workbench, not chat decoration: the transcript, a composer that cannot
/// submit twice, a Stop control while the run is live, and a run-detail panel
/// that is persistent when there is room and one control away when there is
/// not. A mid-stream failure keeps the partial output.
library;

import 'dart:async';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Form,
        FormField,
        Icon,
        OverlayPortal,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;

import 'stress_error.dart';
import 'stress_ui.dart';

/// The run's lifecycle, which is not the same thing as a read state: a run has
/// a beginning the user starts and an end the user can force.
enum RunPhase { empty, streaming, complete, stopped, failed }

extension RunPhasePresentation on RunPhase {
  String get label => switch (this) {
    RunPhase.empty => 'Ready',
    RunPhase.streaming => 'Running',
    RunPhase.complete => 'Complete',
    RunPhase.stopped => 'Stopped by you',
    RunPhase.failed => 'Interrupted',
  };

  IconGlyph get glyph => switch (this) {
    RunPhase.empty => IconGlyph.sparkles,
    RunPhase.streaming => IconGlyph.loaderCircle,
    RunPhase.complete => IconGlyph.circleCheck,
    RunPhase.stopped => IconGlyph.pause,
    RunPhase.failed => IconGlyph.alertTriangle,
  };

  BadgeVariant get variant => switch (this) {
    RunPhase.complete => BadgeVariant.secondary,
    RunPhase.failed => BadgeVariant.destructive,
    _ => BadgeVariant.outline,
  };
}

class AgentConsolePage extends StatefulWidget {
  const AgentConsolePage({super.key, this.failMidStream = false});

  /// Drives the mid-stream failure path so it can be inspected and tested.
  final bool failMidStream;

  @override
  State<AgentConsolePage> createState() => _AgentConsolePageState();
}

class _AgentConsolePageState extends State<AgentConsolePage> {
  final TextEditingController _composer = TextEditingController();
  final FocusNode _composerFocus = FocusNode(debugLabel: 'composer');
  final ScrollController _scroll = ScrollController();

  final List<AgentTurn> _turns = <AgentTurn>[];
  RunPhase _phase = RunPhase.empty;
  AppError? _failure;
  Timer? _stream;
  int _chunk = 0;
  int _elapsedBeats = 0;
  int _tokens = 0;

  static const List<String> _script = <String>[
    'Reading the billing schema. ',
    'Three tables carry invoice state, and two of them disagree about the '
        'past-due flag. ',
    'I will reconcile them and report which rows changed.',
  ];

  @override
  void dispose() {
    _stream?.cancel();
    _composer.dispose();
    _composerFocus.dispose();
    _scroll.dispose();
    super.dispose();
  }

  int get _toolCount => _turns.whereType<ToolTurn>().length;

  bool get _isStreaming => _phase == RunPhase.streaming;

  void _send() {
    // No double submit: a live run owns the composer until it ends.
    if (_isStreaming) return;
    final String text = _composer.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _failure = null;
      _turns.add(UserTurn(id: 'u${_turns.length}', text: text));
      _turns.add(
        ToolTurn(
          id: 't${_turns.length}',
          name: 'read_schema',
          params: <String, Object?>{'target': 'billing', 'depth': 'tables'},
          status: AgentTurnStatus.running,
          attempt: 1,
        ),
      );
      _phase = RunPhase.streaming;
      _chunk = 0;
      _elapsedBeats = 0;
      _tokens = 0;
    });
    _composer.clear();
    announce(context, 'Run started');
    _tick();
  }

  /// Every beat comes from the motion foundation. There is no raw duration in
  /// this file, including for the streaming cadence.
  void _tick() {
    _stream?.cancel();
    _stream = Timer.periodic(MotionDurations.slow, (Timer timer) {
      if (!mounted) return;
      setState(() {
        _elapsedBeats++;
        _tokens += _script.isEmpty ? 0 : _script[_chunk % _script.length].length;

        // The tool settles first, then the answer streams over it.
        final int toolIndex = _turns.indexWhere(
          (AgentTurn turn) =>
              turn is ToolTurn && turn.status == AgentTurnStatus.running,
        );
        if (toolIndex >= 0) {
          final ToolTurn running = _turns[toolIndex] as ToolTurn;
          _turns[toolIndex] = ToolTurn(
            id: running.id,
            name: running.name,
            params: running.params,
            status: AgentTurnStatus.ok,
            attempt: running.attempt,
            result: <String, Object?>{
              'tables': <String>['invoices', 'invoice_lines', 'charges'],
              'rows': 4821,
            },
          );
          return;
        }

        if (widget.failMidStream && _chunk == 1) {
          timer.cancel();
          _fail();
          return;
        }

        if (_chunk >= _script.length) {
          timer.cancel();
          _phase = RunPhase.complete;
          _settleStreamingTurn();
          announce(context, 'Run complete');
          return;
        }

        _appendChunk(_script[_chunk]);
        _chunk++;
      });
    });
  }

  void _appendChunk(String chunk) {
    final int last = _turns.lastIndexWhere((AgentTurn t) => t is TextTurn);
    if (last >= 0 && (_turns[last] as TextTurn).streaming) {
      final TextTurn current = _turns[last] as TextTurn;
      _turns[last] = TextTurn(
        id: current.id,
        text: '${current.text}$chunk',
        streaming: true,
      );
      return;
    }
    _turns.add(
      TextTurn(id: 'a${_turns.length}', text: chunk, streaming: true),
    );
  }

  void _settleStreamingTurn() {
    final int last = _turns.lastIndexWhere((AgentTurn t) => t is TextTurn);
    if (last < 0) return;
    final TextTurn current = _turns[last] as TextTurn;
    _turns[last] = TextTurn(id: current.id, text: current.text);
  }

  /// Stopping is the user's decision, so it is not a failure and it does not
  /// throw away what already arrived.
  void _stop() {
    _stream?.cancel();
    setState(() {
      _phase = RunPhase.stopped;
      _settleStreamingTurn();
    });
    announce(context, 'Run stopped');
  }

  /// A mid-stream failure keeps the partial answer and offers one next step.
  void _fail() {
    _stream?.cancel();
    final AppError error = AppError.of(
      ErrorKind.server,
      diagnostics:
          'stream closed 500 upstream_disconnect '
          'at RunStream.kt:88 after 2 chunks',
      correlationId: 'run_71bd0c',
    );
    setState(() {
      _phase = RunPhase.failed;
      _failure = error;
      _settleStreamingTurn();
    });
    announce(context, error.title);
  }

  void _resume() {
    setState(() {
      _failure = null;
      _phase = RunPhase.streaming;
    });
    _tick();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      final bool wide = constraints.maxWidth >= Breakpoints.lg;
      final Widget transcript = _Transcript(
        turns: _turns,
        phase: _phase,
        failure: _failure,
        scroll: _scroll,
        onResume: _resume,
      );

      return SafeArea(
        // The composer spends the bottom inset itself, below.
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // The header scrolls with the transcript. Pinning it plus
                  // the composer leaves no room at all for the transcript at
                  // 200 percent text on a phone.
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                _Header(
                                  phase: _phase,
                                  wide: wide,
                                  detail: _detail,
                                ),
                                transcript,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (wide) ...<Widget>[
                    SizedBox(width: space(6)),
                    SizedBox(
                      width: LayoutWidths.sidebar,
                      child: SingleChildScrollView(child: _detail),
                    ),
                  ],
                ],
              ),
            ),
            _Composer(
              controller: _composer,
              focusNode: _composerFocus,
              streaming: _isStreaming,
              onSubmit: _send,
              onStop: _stop,
            ),
          ],
        ),
      );
    },
  );

  Widget get _detail => _RunDetail(
    phase: _phase,
    beats: _elapsedBeats,
    tokens: _tokens,
    tools: _toolCount,
  );
}

class _Header extends StatelessWidget {
  const _Header({
    required this.phase,
    required this.wide,
    required this.detail,
  });

  final RunPhase phase;
  final bool wide;
  final Widget detail;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(space(4), space(4), space(4), space(3)),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StyledText('Run console', TextStyles.h3),
              // Status is a word and a glyph, never a color alone.
              Badge(
                label: phase.label,
                glyph: Icon(phase.glyph, size: IconSize.xs),
                variant: phase.variant,
              ),
            ],
          ),
        ),
        // Narrow puts the run detail one control away instead of dropping it.
        if (!wide) _RunDetailSheet(detail: detail),
      ],
    ),
  );
}

/* ── Transcript ──────────────────────────────────────────────────────────── */

class _Transcript extends StatelessWidget {
  const _Transcript({
    required this.turns,
    required this.phase,
    required this.failure,
    required this.scroll,
    required this.onResume,
  });

  final List<AgentTurn> turns;
  final RunPhase phase;
  final AppError? failure;
  final ScrollController scroll;
  final VoidCallback onResume;

  @override
  Widget build(BuildContext context) {
    if (turns.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(space(4)),
        child: RegionEmpty(
          glyph: IconGlyph.sparkles,
          title: 'Nothing has run yet',
          description:
              'Ask for a change and the agent will show its tools and its '
              'reasoning as it works.',
          actionLabel: 'Write the first instruction',
          actionVariant: ButtonVariant.outline,
          onAction: () => FocusScope.of(context).nextFocus(),
        ),
      );
    }

    // The scroller lives one level up, around the header and the transcript
    // together. ScrollArea is not an option either way: it wraps its child in
    // an IntrinsicWidth and the agent message widgets use LayoutBuilder, which
    // cannot be measured intrinsically.
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: space(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            for (final AgentTurn turn in turns)
              Padding(
                padding: EdgeInsets.only(bottom: space(4)),
                child: switch (turn) {
                  final UserTurn user => UserMessage(turn: user),
                  final TextTurn text => AgentMessage(turn: text),
                  final ToolTurn tool => ToolChip(turn: tool),
                  _ => const SizedBox.shrink(),
                },
              ),
            // The partial answer above stays. The failure sits under it with
            // one next step, and the technical detail stays collapsed.
            ?switch (failure) {
              final AppError error => Padding(
                padding: EdgeInsets.only(bottom: space(4)),
                child: RegionFailure(error: error, onRetry: onResume),
              ),
              _ => null,
            },
            if (phase == RunPhase.stopped)
              Padding(
                padding: EdgeInsets.only(bottom: space(4)),
                child: Alert(
                  variant: AlertVariant.info,
                  icon: const Icon(IconGlyph.pause),
                  title: 'You stopped this run',
                  description:
                      'Everything above was kept. Send another instruction to '
                      'carry on from here.',
                ),
              ),
            SizedBox(height: space(6)),
          ],
        ),
      );
  }
}

/* ── Run detail ──────────────────────────────────────────────────────────── */

class _RunDetail extends StatelessWidget {
  const _RunDetail({
    required this.phase,
    required this.beats,
    required this.tokens,
    required this.tools,
  });

  final RunPhase phase;
  final int beats;
  final int tokens;
  final int tools;

  @override
  Widget build(BuildContext context) => Card(
    children: <Widget>[
      const CardHeader(
        title: CardTitle('This run'),
        description: CardDescription('What it did, and what it cost.'),
      ),
      CardContent(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Stat(label: 'Status', value: phase.label),
            SizedBox(height: space(4)),
            Stat(label: 'Duration', value: '${beats}s'),
            SizedBox(height: space(4)),
            Stat(label: 'Tokens', value: '$tokens'),
            SizedBox(height: space(4)),
            Stat(label: 'Tool calls', value: '$tools'),
          ],
        ),
      ),
    ],
  );
}

class _RunDetailSheet extends StatefulWidget {
  const _RunDetailSheet({required this.detail});

  final Widget detail;

  @override
  State<_RunDetailSheet> createState() => _RunDetailSheetState();
}

class _RunDetailSheetState extends State<_RunDetailSheet> {
  final FocusNode _trigger = FocusNode(debugLabel: 'run detail trigger');

  @override
  void dispose() {
    _trigger.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SheetOverlay(
    side: SheetSide.bottom,
    trigger: (BuildContext context, VoidCallback open) => Button(
      variant: ButtonVariant.outline,
      size: ButtonSize.sm,
      focusNode: _trigger,
      onPressed: open,
      label: 'Show run details',
      child: const Icon(IconGlyph.activity, size: IconSize.sm),
    ),
    content: (BuildContext context, VoidCallback close) => SheetContent(
      side: SheetSide.bottom,
      onClose: () {
        close();
        _trigger.requestFocus();
      },
      children: <Widget>[
        const SheetHeader(
          children: <Widget>[
            SheetTitle('Run details'),
            SheetDescription('Status, duration, tokens and tool calls.'),
          ],
        ),
        Padding(padding: EdgeInsets.all(space(4)), child: widget.detail),
      ],
    ),
  );
}

/* ── Composer ────────────────────────────────────────────────────────────── */

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.focusNode,
    required this.streaming,
    required this.onSubmit,
    required this.onStop,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool streaming;
  final VoidCallback onSubmit;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    // The keyboard inset is spent exactly once, here, by the only thing that
    // has to stay above it. The page's SafeArea deliberately skips the bottom.
    final double keyboard = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboard),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(space(4), space(2), space(4), space(3)),
          child: AgentComposer(
            controller: controller,
            focusNode: focusNode,
            busy: streaming,
            placeholder: 'Ask the agent to change something',
            onSubmit: onSubmit,
            // Stop exists only while there is something to stop.
            onStop: streaming ? onStop : null,
          ),
        ),
      ),
    );
  }
}
