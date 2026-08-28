/// `components/agent/parts/` — the transcript's own parts.
///
/// `message.tsx`, `tool-chip.tsx`, `approval-card.tsx` and `welcome-card.tsx`
/// arrive here as one library because they are one family: everything a turn
/// can be, drawn. The markdown renderer and the attachment list are big enough
/// to be their own files (`agent_markdown.dart`, `agent_attachments.dart`) and
/// this one composes both.
///
/// **The two sides are deliberately not symmetrical.** The user's message is a
/// bubble — bounded, right-aligned, clearly a thing that was said. The
/// assistant's is not: it is set flush in the column like body copy, because it
/// is often long, frequently contains lists and tables, and putting three
/// hundred words in a speech bubble makes them harder to read for no gain.
/// Both go through the same markdown renderer: someone who pastes a code block
/// into the composer meant it, and echoing it back as literal backticks reads
/// as a bug in the product rather than as a faithful quotation.
///
/// ## Probe corrections carried here
///
///  * **The chip's `duration-fast` is inert.** The chevron's
///    `transition-transform duration-fast` computes to **0.25s** — the standing
///    finding that a `duration-<word>` utility is a no-op unless globals.css
///    reads the variable directly. [ToolChip] runs
///    [MotionDurations.normal].
///  * **The chip's label is `AGENT_STATE_LABEL`, not a paraphrase.** Measured on
///    the failed chip: `Retrieving knowledge · attempt 2`, 180.81×13.8.
///  * **The caret is a block, not an inline mark.** `<Markdown>` renders a
///    `div`, so the cursor `span` after it starts a new line box — 24px tall,
///    off the container's inherited leading, with the 16px caret sitting on the
///    content-area bottom (`align-text-bottom`). Measured: the streaming turn's
///    text block is 24.38 and the whole turn 48.38.
library;

import 'dart:convert';

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

import '../../design_system/foundation/colors.dart';
import '../../design_system/foundation/motion.dart';
import '../../design_system/foundation/spacing.dart';
import '../../design_system/foundation/theme.dart';
import '../../design_system/foundation/typography.dart';
import './keyframes.dart';
import '../../design_system/foundation/text_layout.dart';
import '../../design_system/foundation/theme_scope.dart';
import './agent_attachments.dart';
import './agent_core.dart';
import './agent_markdown.dart';
import './button.dart';
import './icon.dart';
import './icon_paths.g.dart';

/* ── Shared helpers ──────────────────────────────────────────────────────── */

// `stripProtocol` is NOT declared here. It belongs to `agent_core.dart` — the
// console family owns that file, and `message.tsx` reaches for the same helper
// the console does. Declaring a second copy here re-exported the same name
// twice through the package barrel, which is a compile error for every
// consumer of the library rather than just for this file. [AgentMessage]
// calls the one imported above.

/// `PRODUCED_KEY` — the namespaced envelope a tool returns its files under.
const String _producedKey = '__attachments';

/// `withoutProduced` — strip the attachment envelope so the disclosure shows a
/// clean result.
Object? _withoutProduced(Object? result) {
  if (result is! Map<String, Object?>) return result;
  if (!result.containsKey(_producedKey)) return result;
  final Map<String, Object?> clone = Map<String, Object?>.of(result)
    ..remove(_producedKey);
  return clone;
}

/// `JSON.stringify(value, null, 2)`, with the reference's own fallback.
String _safeJson(Object? value) {
  try {
    return const JsonEncoder.withIndent('  ').convert(value);
  } on Object {
    return '$value';
  }
}

/// A tool that returns four hundred rows would otherwise push the conversation
/// off the screen. The cap is announced rather than silent, for the same reason
/// truncated attachments are.
const int maxJsonChars = 4000;

/* ── Message ─────────────────────────────────────────────────────────────── */

/// `UserMessage` — the bubble.
class UserMessage extends StatelessWidget {
  const UserMessage({
    super.key,
    required this.turn,
    this.imageBuilder,
    this.onDownload,
  });

  /// `max-w-[85%]`.
  static const double maxWidthFraction = 0.85;

  /// `gap-2` in the right-aligned column.
  static double get gap => space(2);

  /// `px-4 py-3`.
  static double get padX => space(4);
  static double get padY => space(3);

  /// `border-agent/20`.
  static const double rimAlpha = 0.20;

  /// `rounded-xl rounded-br-sm` — 16 / 16 / **6** / 16.
  static BorderRadius get radius => BorderRadius.only(
    topLeft: const Radius.circular(Radii.xl),
    topRight: const Radius.circular(Radii.xl),
    bottomRight: const Radius.circular(Radii.sm),
    bottomLeft: const Radius.circular(Radii.xl),
  );

  final UserTurn turn;
  final Widget Function(BuildContext, AgentAttachment)? imageBuilder;
  final void Function(String name)? onDownload;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double cap = constraints.maxWidth.isFinite
            ? constraints.maxWidth * maxWidthFraction
            : double.infinity;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (turn.text.isNotEmpty)
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: cap),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: padX,
                    vertical: padY,
                  ),
                  decoration: BoxDecoration(
                    color: theme.agentAccentMuted,
                    borderRadius: radius,
                    border: Border.all(
                      color: theme.agentAccent.withValues(alpha: rimAlpha),
                      width: BorderWidths.hairline,
                    ),
                  ),
                  child: AgentMarkdown(text: turn.text),
                ),
              ),
            if (turn.attachments.isNotEmpty) ...<Widget>[
              if (turn.text.isNotEmpty) SizedBox(height: gap),
              // `className="w-full max-w-[85%]"` — the tray is capped like the
              // bubble but always fills that cap.
              SizedBox(
                width: cap,
                child: AgentAttachmentList(
                  attachments: turn.attachments,
                  imageBuilder: imageBuilder,
                  onDownload: onDownload,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

/// `AgentMessage` — flush in the column, like body copy.
class AgentMessage extends StatelessWidget {
  const AgentMessage({
    super.key,
    required this.turn,
    this.imageBuilder,
    this.onDownload,
  });

  /// `gap-3`.
  static double get gap => space(3);

  final TextTurn turn;
  final Widget Function(BuildContext, AgentAttachment)? imageBuilder;
  final void Function(String name)? onDownload;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final String text = stripProtocol(turn.text);
    if (text.trim().isEmpty && turn.attachments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (text.trim().isNotEmpty)
          DefaultTextStyle.merge(
            style: TextStyle(color: theme.foreground),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AgentMarkdown(text: text),
                // The cursor is only ever shown on a turn the model is
                // genuinely still writing into — `streaming` is cleared the
                // moment anything else arrives, so it cannot be left blinking
                // on a finished paragraph three tool calls later.
                if (turn.streaming) const TypingCursor(),
              ],
            ),
          ),
        if (turn.attachments.isNotEmpty) ...<Widget>[
          if (text.trim().isNotEmpty) SizedBox(height: gap),
          AgentAttachmentList(
            attachments: turn.attachments,
            imageBuilder: imageBuilder,
            onDownload: onDownload,
          ),
        ],
      ],
    );
  }
}

/// `<span className="bg-agent anim-pulse-live ml-1 inline-block h-4 w-px
/// align-text-bottom" />` — the one place `--agent` is a solid fill rather than
/// a foreground.
///
/// A mark a pixel and a half wide, pulsing on `anim-pulse-live`. It is what
/// tells a reader the agent has not stalled.
///
/// The `span` follows a block `div`, so it lands on a line box of its own —
/// 24px off the container's inherited leading, with the 16px mark sitting on
/// the content-area bottom because `align-text-bottom` says so.
class TypingCursor extends StatefulWidget {
  const TypingCursor({super.key});

  /// `h-4`.
  static double get markHeight => space(4);

  /// `w-px`.
  static const double markWidth = BorderWidths.hairline;

  /// `ml-1`.
  static double get inset => space(1);

  @override
  State<TypingCursor> createState() => _TypingCursorState();
}

class _TypingCursorState extends State<TypingCursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: LivePulseMotion.duration,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (effectiveMotionDuration(context, LivePulseMotion.duration) ==
        Duration.zero) {
      _c.stop();
      _c.value = 0;
    } else if (!_c.isAnimating) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final TextStyle ambient = DefaultTextStyle.of(context).style;
    final double lineBox =
        (ambient.fontSize ?? TextStyles.body.size!) * (ambient.height ?? 1);
    // CSS splits the leading evenly; `align-text-bottom` puts the mark's bottom
    // on the content area's, which is half a leading above the line box's.
    final double halfLeading = ((lineBox - contentAreaHeight(ambient)) / 2)
        .clamp(0, lineBox);

    return SizedBox(
      height: lineBox,
      child: Align(
        alignment: AlignmentDirectional.bottomStart,
        child: Padding(
          padding: EdgeInsetsDirectional.only(
            start: TypingCursor.inset,
            bottom: halfLeading,
          ),
          child: AnimatedBuilder(
            animation: _c,
            builder: (BuildContext context, Widget? _) => CustomPaint(
              size: Size(TypingCursor.markWidth, TypingCursor.markHeight),
              painter: _CaretPainter(phase: _c.value, mark: theme.agentAccent),
            ),
          ),
        ),
      ),
    );
  }
}

/// `pulls-pulse-live` on a 1×16 box.
///
/// CSS spread grows the *border box* on all four sides, and the caret's box has
/// square corners, so the ring is a rectangle rather than the circle
/// [LivePulseMotion] draws for the live dot. Both halves read off the same
/// keyframe table, so retiming one retimes the other.
class _CaretPainter extends CustomPainter {
  const _CaretPainter({required this.phase, required this.mark});

  final double phase;
  final Color mark;

  @override
  void paint(Canvas canvas, Size size) {
    final double spread =
        LivePulseMotion.ringSpread * LivePulseMotion.ringPhase.transform(phase);
    if (spread > 0) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height).inflate(spread),
        Paint()..color = LivePulseMotion.ringColorAt(phase),
      );
    }
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..color = mark.withValues(
          alpha: mark.a * LivePulseMotion.dotOpacityAt(phase),
        ),
    );
  }

  @override
  bool shouldRepaint(_CaretPainter old) =>
      old.phase != phase || old.mark != mark;
}

/* ── Tool chip ───────────────────────────────────────────────────────────── */

/// `anim-spin` — `pulls-spin 0.9s linear infinite`.
///
/// *"`linear` on purpose: a spinner that eases is a spinner that looks broken."*
class _Spin extends StatefulWidget {
  const _Spin({required this.child});

  final Widget child;

  @override
  State<_Spin> createState() => _SpinState();
}

class _SpinState extends State<_Spin> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: MotionDurations.spin,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (effectiveMotionDuration(context, MotionDurations.spin) ==
        Duration.zero) {
      _c.stop();
      _c.value = 0;
    } else if (!_c.isAnimating) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      RotationTransition(turns: _c, child: widget.child);
}

/// `StatusIcon` — the glyph that says what happened, at `size-3.5`.
class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.status, this.attempt});

  /// `size-3.5`.
  static double get px => space(3.5);

  final AgentTurnStatus status;
  final int? attempt;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    if (status == AgentTurnStatus.running) {
      // A retry is a different fact from a first attempt, and the chip says so
      // before its label does.
      final bool retry = attempt != null && attempt! > 1;
      return _Spin(
        child: DefaultTextStyle.merge(
          style: TextStyle(
            color: retry ? theme.warningText : theme.agentAccent,
          ),
          child: Icon.lucide(
            retry ? Lucide.rotateCw : Lucide.loaderCircle,
            sizePx: px,
            tone: IconTone.inherit,
          ),
        ),
      );
    }
    if (status == AgentTurnStatus.error) {
      return Icon.lucide(
        Lucide.triangleAlert,
        sizePx: px,
        tone: IconTone.error,
      );
    }
    return Icon.lucide(Lucide.check, sizePx: px, tone: IconTone.success);
  }
}

/// `ToolChip` — one step of the agent's work, on the record.
///
/// The chip is closed by default and says what happened in a sentence. Opening
/// it shows the arguments and the raw result — which is the difference between
/// a product that claims it did something and one that can be checked.
///
/// The label comes from the same tool map that drives the avatar, so the chip
/// and the face can never describe the same call differently. Where a caller
/// has not mapped a tool, the chip falls back to the tool's own name rather
/// than to a generic "used a tool" — the name is the most honest thing
/// available.
class ToolChip extends StatefulWidget {
  const ToolChip({
    super.key,
    required this.turn,
    this.toolStates,
    this.renderResult,
    this.imageBuilder,
    this.onDownload,
  });

  /// `gap-2` between the chip and whatever it opens.
  static double get gap => space(2);

  /// `px-3 py-1` — the only geometry the chip overrides on `Button size="sm"`.
  static double get padX => space(3);
  static double get padY => space(1);

  /// `gap-2` between the glyph, the label, the elapsed time and the chevron.
  static double get contentGap => space(2);

  /// `size-3` on the chevron, at `text-muted-foreground/60`.
  static double get chevronPx => space(3);
  static const double chevronAlpha = 0.60;

  /// `border-destructive/40` on a failed chip.
  static const double errorRimAlpha = 0.40;

  /// `p-3` and `space-y-3` in the disclosure panel, on `bg-muted/40`.
  static double get panelPad => space(3);
  static double get panelGap => space(3);
  static const double panelFillAlpha = 0.40;

  /// `space-y-1` inside one labelled detail.
  static double get detailGap => space(1);

  /// `max-h-64` on a raw value.
  static double get valueMaxHeight => space(64);

  final ToolTurn turn;
  final ToolStateMap? toolStates;

  /// The caller's generative renderer for this tool's result, if it has one.
  final Widget Function(ToolTurn)? renderResult;

  final Widget Function(BuildContext, AgentAttachment)? imageBuilder;
  final void Function(String name)? onDownload;

  @override
  State<ToolChip> createState() => _ToolChipState();
}

class _ToolChipState extends State<ToolChip> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final ToolTurn turn = widget.turn;
    final AgentState? mapped = stateForTool(turn.name, widget.toolStates);
    final String label = mapped == null
        ? humaniseToolName(turn.name)
        : mapped.label;
    final Widget? rendered =
        turn.status == AgentTurnStatus.ok && widget.renderResult != null
        ? widget.renderResult!(turn)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // `Button variant="outline"` already IS this chip: pill radius, card
        // fill, hairline border, the press feel, the focus ring and the
        // `aria-expanded` surface. Only the geometry is overridden — a chip is
        // content-height and shrink-to-fit, where a button is a fixed row.
        Button(
          variant: ButtonVariant.outline,
          size: ButtonSize.sm,
          autoHeight: true,
          padding: EdgeInsets.symmetric(
            horizontal: ToolChip.padX,
            vertical: ToolChip.padY,
          ),
          surface: turn.status == AgentTurnStatus.error
              ? ButtonStyleRecipe(
                  border: theme.destructive.withValues(
                    alpha: ToolChip.errorRimAlpha,
                  ),
                )
              : null,
          onPressed: () => setState(() => _open = !_open),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _StatusIcon(status: turn.status, attempt: turn.attempt),
              SizedBox(width: ToolChip.contentGap),
              Flexible(
                child: StyledText(
                  turn.attempt > 1 ? '$label · attempt ${turn.attempt}' : label,
                  TextStyles.chip,
                  color: theme.mutedForeground,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
              if (turn.ms != null) ...<Widget>[
                SizedBox(width: ToolChip.contentGap),
                StyledText(
                  formatMs(turn.ms!),
                  TextStyles.caption,
                  color: theme.mutedForeground,
                ),
              ],
              SizedBox(width: ToolChip.contentGap),
              // `transition-transform duration-fast` → 250ms; the utility is a
              // no-op, so this is the socket default.
              AnimatedRotation(
                turns: _open ? 0.25 : 0,
                duration: effectiveMotionDuration(
                  context,
                  MotionDurations.normal,
                ),
                child: Icon.lucide(
                  Lucide.chevronRight,
                  sizePx: ToolChip.chevronPx,
                  tone: IconTone.inherit,
                ),
              ),
            ],
          ),
        ),
        if (_open) ...<Widget>[
          SizedBox(height: ToolChip.gap),
          Container(
            padding: EdgeInsets.all(ToolChip.panelPad),
            decoration: BoxDecoration(
              color: theme.muted.withValues(alpha: ToolChip.panelFillAlpha),
              borderRadius: BorderRadius.circular(Radii.md),
              border: Border.all(
                color: theme.border,
                width: BorderWidths.hairline,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _Detail(
                  label: 'Tool',
                  child: StyledText(turn.name, TextStyles.code),
                ),
                if (turn.params.isNotEmpty) ...<Widget>[
                  SizedBox(height: ToolChip.panelGap),
                  _Detail(
                    label: 'Arguments',
                    child: _Json(value: turn.params),
                  ),
                ],
                if (turn.error != null) ...<Widget>[
                  SizedBox(height: ToolChip.panelGap),
                  _Detail(
                    label: 'Error',
                    child: StyledText(
                      turn.error!,
                      TextStyles.small,
                      color: theme.destructiveText,
                    ),
                  ),
                ],
                if (turn.result != null) ...<Widget>[
                  SizedBox(height: ToolChip.panelGap),
                  _Detail(
                    label: 'Result',
                    child: _Json(value: _withoutProduced(turn.result)),
                  ),
                ],
              ],
            ),
          ),
        ],
        // The generative half: a caller-supplied renderer turns a raw result
        // into the product's own components. Shown outside the disclosure
        // because it is the answer, not the evidence.
        if (rendered != null) ...<Widget>[
          SizedBox(height: ToolChip.gap),
          rendered,
        ],
        if (turn.attachments.isNotEmpty) ...<Widget>[
          SizedBox(height: ToolChip.gap),
          AgentAttachmentList(
            attachments: turn.attachments,
            imageBuilder: widget.imageBuilder,
            onDownload: widget.onDownload,
          ),
        ],
      ],
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        StyledText(label, TextStyles.caption, color: theme.mutedForeground),
        SizedBox(height: ToolChip.detailGap),
        child,
      ],
    );
  }
}

/// Raw values, capped and announced.
class _Json extends StatelessWidget {
  const _Json({required this.value});

  final Object? value;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final String text = _safeJson(value);
    final bool clipped = text.length > maxJsonChars;
    final String shown = clipped
        ? '${text.substring(0, maxJsonChars)}\n… '
              '${text.length - maxJsonChars} more characters'
        : text;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: ToolChip.valueMaxHeight),
      child: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: StyledText(
            shown,
            TextStyles.code,
            color: theme.mutedForeground,
            softWrap: false,
          ),
        ),
      ),
    );
  }
}

/// `ActionChip` — a step the browser performed, rather than the server.
///
/// Kept visually distinct from a tool chip because the user can verify these
/// themselves: the page just moved, or it did not.
class ActionChip extends StatelessWidget {
  const ActionChip({super.key, required this.turn});

  /// `px-3 py-1`, `gap-2`.
  static double get padX => space(3);
  static double get padY => space(1);
  static double get gap => space(2);

  /// `border-destructive/40` when it failed, `border-warning/40` when the user
  /// said no.
  static const double rimAlpha = 0.40;

  final ActionTurn turn;

  static String _describeTarget(Map<String, Object?> params) {
    final Object? target =
        params['url'] ?? params['path'] ?? params['selector'];
    return target is String && target.isNotEmpty ? ' · $target' : '';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final String label =
        '${humaniseToolName(turn.action)}${_describeTarget(turn.params)}';
    final Color rim = switch (turn) {
      ActionTurn(status: AgentTurnStatus.error) => theme.destructive.withValues(
        alpha: rimAlpha,
      ),
      ActionTurn(approval: ApprovalOutcome.rejected) =>
        Palette.warning.withValues(alpha: rimAlpha),
      _ => theme.border,
    };

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: padX, vertical: padY),
        decoration: BoxDecoration(
          color: theme.card,
          borderRadius: BorderRadius.circular(Radii.full),
          border: Border.all(color: rim, width: BorderWidths.hairline),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _StatusIcon(status: turn.status),
            SizedBox(width: gap),
            Flexible(
              child: StyledText(
                turn.approval == ApprovalOutcome.rejected
                    ? 'Declined: $label'
                    : label,
                TextStyles.chip,
                color: theme.mutedForeground,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            ),
            if (turn.ms != null) ...<Widget>[
              SizedBox(width: gap),
              StyledText(
                formatMs(turn.ms!),
                TextStyles.caption,
                color: theme.mutedForeground,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/* ── Approval ────────────────────────────────────────────────────────────── */

/// `ApprovalCard` — the hold.
///
/// This is a real gate, not a rendering of one. The agent's action bridge is a
/// request/response handshake: the runtime emits an action request and then
/// *waits* for the browser to report an outcome. The console parks that promise
/// here. Until a button is pressed the agent is genuinely blocked, and pressing
/// Decline returns a failure the model then has to reason about — it is told
/// the user said no, in as many words, rather than being left to time out.
class ApprovalCard extends StatelessWidget {
  const ApprovalCard({super.key, required this.approval, this.describe});

  /// `p-4` and `space-y-3`.
  static double get pad => space(4);
  static double get gap => space(3);

  /// `gap-3` between the glyph and the sentence, and `space-y-1` inside it.
  static double get headGap => space(3);
  static double get headLineGap => space(1);

  /// `mt-1 size-4` on the glyph.
  static double get glyphPx => space(4);
  static double get glyphTop => space(1);

  /// `border-warning/40 bg-warning/8`.
  static const double rimAlpha = 0.40;
  static const double washAlpha = 0.08;

  /// `max-h-40 p-2` on the parameter block.
  static double get paramsMaxHeight => space(40);
  static double get paramsPad => space(2);

  /// `gap-2` between Approve and Decline.
  static double get actionGap => space(2);

  /// The reason Decline hands back, verbatim.
  static const String declineReason = 'The user declined this action.';

  final PendingApproval approval;

  /// Turns the raw action into a sentence a human can decide on.
  final String Function(String action, Map<String, Object?> params)? describe;

  static String defaultSentence(PendingApproval approval) {
    final Object? target =
        approval.params['url'] ??
        approval.params['path'] ??
        approval.params['selector'];
    final String suffix = target is String && target.isNotEmpty
        ? ' on $target'
        : '';
    return 'The assistant wants to run "${approval.action}"$suffix.';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final String sentence =
        describe?.call(approval.action, approval.params) ??
        defaultSentence(approval);

    return FadeUp(
      child: Semantics(
        container: true,
        label: 'The assistant is asking permission',
        child: Container(
          padding: EdgeInsets.all(pad),
          decoration: BoxDecoration(
            color: Palette.warning.withValues(alpha: washAlpha),
            borderRadius: BorderRadius.circular(Radii.lg),
            border: Border.all(
              color: Palette.warning.withValues(alpha: rimAlpha),
              width: BorderWidths.hairline,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: glyphTop),
                    child: Icon.lucide(
                      Lucide.shieldQuestionMark,
                      sizePx: glyphPx,
                      tone: IconTone.warning,
                    ),
                  ),
                  SizedBox(width: headGap),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        StyledText(
                          'Needs your approval',
                          TextStyles.eyebrow,
                          color: theme.warningText,
                        ),
                        SizedBox(height: headLineGap),
                        StyledText(
                          sentence,
                          TextStyles.small,
                          color: theme.foreground,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (approval.params.isNotEmpty) ...<Widget>[
                SizedBox(height: gap),
                Container(
                  padding: EdgeInsets.all(paramsPad),
                  decoration: BoxDecoration(
                    color: theme.card,
                    borderRadius: BorderRadius.circular(Radii.sm),
                    border: Border.all(
                      color: theme.border,
                      width: BorderWidths.hairline,
                    ),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: paramsMaxHeight),
                    child: SingleChildScrollView(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: StyledText(
                          _safeJson(approval.params),
                          TextStyles.code,
                          color: theme.mutedForeground,
                          softWrap: false,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              SizedBox(height: gap),
              Row(
                children: <Widget>[
                  Button(
                    size: ButtonSize.sm,
                    onPressed: approval.approve,
                    child: const Text('Approve'),
                  ),
                  SizedBox(width: actionGap),
                  Button(
                    variant: ButtonVariant.outline,
                    size: ButtonSize.sm,
                    onPressed: () => approval.reject(declineReason),
                    child: const Text('Decline'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ── Entrance utilities ──────────────────────────────────────────────────── */

/// `anim-fade-up` — `pulls-fade-up var(--duration-slow) var(--ease-out) both`:
/// opacity 0→1 over a 10px rise.
class FadeUp extends StatefulWidget {
  const FadeUp({super.key, required this.child});

  /// `translateY(10px)` at the `from` stop.
  static double get rise => space(2.5);

  final Widget child;

  @override
  State<FadeUp> createState() => _FadeUpState();
}

class _FadeUpState extends State<FadeUp> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: MotionDurations.slow,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (effectiveMotionDuration(context, MotionDurations.slow) ==
        Duration.zero) {
      _c.value = 1;
    } else if (!_c.isAnimating && _c.value == 0) {
      _c.forward();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _c,
    builder: (BuildContext context, Widget? child) {
      final double t = MotionCurves.enter.transform(_c.value);
      return Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, FadeUp.rise * (1 - t)),
          child: child,
        ),
      );
    },
    child: widget.child,
  );
}

/// `anim-row-in` — `pulls-row-in var(--duration-base) var(--ease-out) both`
/// with `animation-delay: calc(tick + index * tick / 2)`.
///
/// The same stagger the history list uses, so the two editable grids in this
/// product arrive the same way.
class RowIn extends StatefulWidget {
  const RowIn({super.key, required this.index, required this.child});

  /// `translateX(-10px)` at the `from` stop.
  static double get slide => space(2.5);

  /// `calc(var(--duration-tick) + var(--row-index) * var(--duration-tick) / 2)`
  /// — 80ms, then 40ms per row. Measured 0.08 / 0.12 / 0.16s on the three
  /// capability chips.
  static Duration delayFor(int index) => MotionDurations.tick * (1 + index / 2);

  final int index;
  final Widget child;

  @override
  State<RowIn> createState() => _RowInState();
}

class _RowInState extends State<RowIn> with SingleTickerProviderStateMixin {
  /// **The delay is a curve, not a timer.**
  ///
  /// The obvious shape — `Timer(delay, _c.forward)` — is wrong twice. It leaves
  /// a pending timer at teardown, so any test that pumps a staggered grid and
  /// finishes without advancing the clock dies on *"A Timer is still pending
  /// after the widget tree was disposed"*; and it models the delay as a period
  /// in which the animation does not exist, when CSS's `animation-fill-mode:
  /// both` says the opposite — the row is *already holding its `from` frame*
  /// through the delay.
  ///
  /// So the controller runs for `delay + duration` and an [Interval] holds it
  /// at 0 for the delay's share of that span. One ticker, no timer, and the
  /// backwards fill is expressed rather than approximated.
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: RowIn.delayFor(widget.index) + MotionDurations.normal,
  );

  /// `Interval(delay / total, 1)` composed with the animation's own easing.
  late final CurvedAnimation _t = CurvedAnimation(
    parent: _c,
    curve: Interval(
      RowIn.delayFor(widget.index).inMicroseconds /
          (RowIn.delayFor(widget.index) + MotionDurations.normal)
              .inMicroseconds,
      1,
      curve: MotionCurves.enter,
    ),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (effectiveMotionDuration(context, MotionDurations.normal) ==
        Duration.zero) {
      _c.value = 1;
    } else if (!_c.isAnimating && _c.value == 0) {
      _c.forward();
    }
  }

  @override
  void dispose() {
    _t.dispose();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _t,
    builder: (BuildContext context, Widget? child) {
      final double t = _t.value;
      return Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(-RowIn.slide * (1 - t), 0),
          child: child,
        ),
      );
    },
    child: widget.child,
  );
}

/* ── Welcome ─────────────────────────────────────────────────────────────── */

/// One entry in the welcome card's capability grid — a *skill*, drawn as a chip.
@immutable
class AgentCapability {
  const AgentCapability({
    required this.id,
    required this.label,
    this.hint,
    this.glyph,
  });

  final String id;
  final String label;

  /// `title` on the chip.
  final String? hint;

  /// Defaults to `SparklesIcon` when the capability declares none.
  final LucideGlyph? glyph;
}

/// `WelcomeCard` — what the assistant is, before it has said anything.
///
/// An empty conversation is the one moment where a user has no idea what they
/// are allowed to ask, and a blinking cursor answers none of it. So the empty
/// state is a card rather than a void: the face, the name, what this particular
/// agent can actually do, and four things worth typing.
///
/// **Starter prompts send immediately** because each one is already a whole
/// question; **skills only write themselves into the composer**, because a
/// skill on its own is not a question and firing "search the catalogue" with
/// nothing to search for wastes a turn.
class WelcomeCard extends StatelessWidget {
  const WelcomeCard({
    super.key,
    this.name,
    this.blurb,
    this.capabilities = const <AgentCapability>[],
    this.suggestions = const <String>[],
    required this.onPick,
    this.onUseCapability,
    this.disabled = false,
    this.avatar,
  });

  /// `MAX_CAPABILITIES` — four, as chips.
  ///
  /// An earlier version gave each one a bordered box and its full tool
  /// description, which is accurate and far too much: the card is an
  /// orientation, not a manual.
  static const int maxCapabilities = 4;

  /// `py-4` on the placement grid.
  static double get outerPadY => space(4);

  /// `max-w-md` on the column.
  static double get columnWidth => Containers.md;

  /// `size-lg` on the avatar — 80px.
  static double get avatarPx => space(20);

  /// `mt-3` / `mt-1` / `mt-4` / `mt-4`, and `gap-2` / `gap-px` inside the two
  /// lists.
  static double get nameTop => space(3);
  static double get blurbTop => space(1);
  static double get listTop => space(4);
  static double get gridGap => space(2);
  static double get suggestionGap => BorderWidths.hairline;

  /// `size-3.5` on a capability's glyph, and `gap-1.5` beside it (the `sm`
  /// button rung's own).
  static double get capabilityGlyphPx => space(3.5);

  /// `hover:border-agent/50` on a capability chip.
  static const double capabilityHoverRimAlpha = 0.50;

  final String? name;
  final String? blurb;

  /// Skills. Clicking one arms it in the composer.
  final List<AgentCapability> capabilities;

  /// Starter prompts. These are clickable — they send.
  final List<String> suggestions;

  /// A suggestion was chosen. Sends immediately: it is already a whole
  /// question.
  final void Function(String text) onPick;

  /// A capability was chosen. Writes its directive into the composer rather
  /// than sending.
  final void Function(AgentCapability capability)? onUseCapability;

  final bool disabled;

  /// The live face, at the size the card asks for.
  ///
  /// `avatar?: AvatarRenderer` in the reference, defaulting to `CubeAvatar`.
  /// The cube is another family's file and is not in the corpus yet, so this
  /// port reserves its 80px box and lets the caller fill it — which is the same
  /// seam the reference exposes, without inventing an avatar to sit in it.
  final Widget Function(BuildContext context, double size)? avatar;

  /// `type-caption` losing its size to the `sm` rung's `text-small`: measured
  /// **13px / 17.55px / 500** on the live chip. The utility layer wins the
  /// size, the component class keeps the leading.
  static final TextStyleToken capabilityLabel = TextStyleToken(
    family: Fonts.sans,
    size: TextStyles.small.size,
    height: TextStyles.caption.height,
    wght: 500,
  );

  /// `type-small` under the same rung — 13px / 19.5px / 500.
  static final TextStyleToken suggestionLabel = TextStyleToken(
    family: Fonts.sans,
    size: TextStyles.small.size,
    height: TextStyles.small.height,
    wght: 500,
  );

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final List<AgentCapability> shown = capabilities
        .take(maxCapabilities)
        .toList(growable: false);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: outerPadY),
      child: Center(
        child: SpringUpEntrance(
          child: SizedBox(
            width: columnWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // The live avatar, not a picture of one. It pops on arrival on
                // top of its own perpetual rotation: the two do not fight
                // because they are on different elements.
                PopInEntrance(
                  child: SizedBox.square(
                    dimension: avatarPx,
                    child: avatar?.call(context, avatarPx),
                  ),
                ),
                if (name != null) ...<Widget>[
                  SizedBox(height: nameTop),
                  StyledText(
                    name!,
                    TextStyles.h4,
                    color: theme.foreground,
                    align: TextAlign.center,
                  ),
                ],
                if (blurb != null) ...<Widget>[
                  SizedBox(height: blurbTop),
                  StyledText(blurb!, TextStyles.small, align: TextAlign.center),
                ],
                if (shown.isNotEmpty) ...<Widget>[
                  SizedBox(height: listTop),
                  _CapabilityGrid(
                    capabilities: shown,
                    disabled: disabled,
                    onUse: onUseCapability,
                  ),
                ],
                if (suggestions.isNotEmpty) ...<Widget>[
                  SizedBox(height: listTop),
                  // No rule above these. The capabilities are chips and the
                  // questions are lines — the change of form already separates
                  // them, and a border on a card this small reads as a seam
                  // rather than a division.
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      for (int i = 0; i < suggestions.length; i += 1)
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: i == suggestions.length - 1
                                ? 0
                                : suggestionGap,
                          ),
                          child: Button(
                            variant: ButtonVariant.ghost,
                            size: ButtonSize.sm,
                            radius: BorderRadius.circular(Radii.md),
                            expanded: true,
                            contentAlignment: AlignmentDirectional.centerStart,
                            onPressed: disabled
                                ? null
                                : () => onPick(suggestions[i]),
                            child: StyledText(
                              suggestions[i],
                              suggestionLabel,
                              color: theme.mutedForeground,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CapabilityGrid extends StatelessWidget {
  const _CapabilityGrid({
    required this.capabilities,
    required this.disabled,
    required this.onUse,
  });

  final List<AgentCapability> capabilities;
  final bool disabled;
  final void Function(AgentCapability)? onUse;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final double gap = WelcomeCard.gridGap;
    final int rows = (capabilities.length + 1) ~/ 2;

    Widget chip(int index) {
      final AgentCapability capability = capabilities[index];
      // `Button` owns the chrome — border, radius, press feel, disabled and the
      // focus ring. Only what makes this a *row* rather than a pill is
      // overridden: a rectangular radius, a left-aligned label and full width.
      return RowIn(
        index: index,
        child: Button(
          variant: ButtonVariant.outline,
          size: ButtonSize.sm,
          radius: BorderRadius.circular(Radii.lg),
          expanded: true,
          contentAlignment: AlignmentDirectional.centerStart,
          label: capability.hint,
          // GAP CLOSED. The chip writes `hover:border-agent/50` beside
          // `hover:text-foreground`, and [ButtonStyleRecipe] carried no
          // `hoverBorder` — so the ink moved on hover and the rim stayed the
          // outline variant's own, which is a half-painted hover rather than a
          // missing one. The primitive has the fifth override now (it was
          // reported from here and from `agent_launcher.dart` at once), and
          // both halves land: the rim springs to the agent colour at half alpha
          // on `btn-spring`'s own clock, because that is the clock the border
          // colour was always on.
          surface: ButtonStyleRecipe(
            hoverBorder: theme.agentAccent.withValues(
              alpha: WelcomeCard.capabilityHoverRimAlpha,
            ),
            hoverInk: theme.foreground,
          ),
          onPressed: disabled ? null : () => onUse?.call(capability),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DefaultTextStyle.merge(
                style: TextStyle(color: theme.agentAccent),
                child: Icon.lucide(
                  capability.glyph ?? Lucide.sparkles,
                  sizePx: WelcomeCard.capabilityGlyphPx,
                  tone: IconTone.inherit,
                ),
              ),
              SizedBox(width: Button.gapFor(ButtonSize.sm)),
              Flexible(
                child: StyledText(
                  capability.label,
                  WelcomeCard.capabilityLabel,
                  color: theme.mutedForeground,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int r = 0; r < rows; r += 1)
          Padding(
            padding: EdgeInsets.only(bottom: r == rows - 1 ? 0 : gap),
            child: Row(
              children: <Widget>[
                Expanded(child: chip(r * 2)),
                SizedBox(width: gap),
                Expanded(
                  child: r * 2 + 1 < capabilities.length
                      ? chip(r * 2 + 1)
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// `anim-spring-up` on the welcome column.
class SpringUpEntrance extends StatefulWidget {
  const SpringUpEntrance({super.key, required this.child});

  final Widget child;

  @override
  State<SpringUpEntrance> createState() => _SpringUpEntranceState();
}

class _SpringUpEntranceState extends State<SpringUpEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: SpringEntranceMotion.duration,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (effectiveMotionDuration(context, SpringEntranceMotion.duration) ==
        Duration.zero) {
      _c.value = 1;
    } else if (!_c.isAnimating && _c.value == 0) {
      _c.forward();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _c,
    builder: (BuildContext context, Widget? child) => Opacity(
      opacity: SpringEntranceMotion.opacity.transform(_c.value),
      child: Transform.translate(
        offset: Offset(0, SpringEntranceMotion.translateY.transform(_c.value)),
        child: child,
      ),
    ),
    child: widget.child,
  );
}

/// `anim-pop-in` on the avatar.
class PopInEntrance extends StatefulWidget {
  const PopInEntrance({super.key, required this.child});

  final Widget child;

  @override
  State<PopInEntrance> createState() => _PopInEntranceState();
}

class _PopInEntranceState extends State<PopInEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: EntranceMotion.duration,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (effectiveMotionDuration(context, EntranceMotion.duration) ==
        Duration.zero) {
      _c.value = 1;
    } else if (!_c.isAnimating && _c.value == 0) {
      _c.forward();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _c,
    builder: (BuildContext context, Widget? child) {
      // `dx` is `scaleX`, `dy` is `scaleY` — the pop squashes on the way
      // through, so the two axes are never equal mid-flight.
      final Offset scale = EntranceMotion.scale.transform(_c.value);
      return Opacity(
        opacity: EntranceMotion.opacity.transform(_c.value),
        child: Transform.scale(
          scaleX: scale.dx,
          scaleY: scale.dy,
          child: child,
        ),
      );
    },
    child: widget.child,
  );
}
