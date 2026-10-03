/// `components/ui/message.tsx` — one turn, laid out.
///
/// Six flex containers sharing one `group/message`, holding no state and
/// knowing nothing about what is inside them. A single `align` prop flips the
/// whole row, which is why the sender's own messages need no second component.
///
/// ## Measured
///
/// Read off `/design-system/components/base/chat` at 1440×900 on 2026-08-16
/// (`scratchpad/ba2-chat-inv.js`):
///
/// | slot | measured |
/// |---|---|
/// | `MessageGroup` | `flex-col`, **8px** gap (`gap-2`) |
/// | `Message` | `flex`, **8px** gap, `text-sm` → 13px / 18.5714px, `data-[align=end]:flex-row-reverse` |
/// | `MessageAvatar` | `min-w-8`, `rounded-full`, `--muted`, `self-end`, and `translate: 0 -32px` whenever the message carries a footer |
/// | `MessageContent` | `flex-col`, **10px** gap (`gap-2.5`) |
/// | `MessageHeader` / `MessageFooter` | `px-3`, 16px tall, 12px / 500 on `--muted-foreground` |
///
/// The avatar's `-translate-y-8` is a **transform**, not a layout change: the
/// avatar still occupies its `self-end` slot and paints 32px above it, so the
/// row's height is unaffected. Reproduced as a [Transform.translate], for the
/// same reason.
///
/// ## The two `group-has-*` selectors
///
/// `group-has-data-[slot=message-footer]/message:-translate-y-8` and
/// `group-has-data-[variant=ghost]/message:px-0` are both "does a sibling
/// exist / what is it" queries. A Flutter parent cannot ask that of a subtree
/// after the fact, so [Message] takes the answers as parameters —
/// [MessageContent.footer] is what makes the avatar lift, and
/// [Message.ghost] is what collapses the header and footer inset. Both are
/// derived at the one place that already knows: the call site that composed
/// the message.
library;

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

import '../../design_system/foundation/spacing.dart';
import '../../design_system/foundation/theme.dart';
import '../../design_system/foundation/typography.dart';
import '../../design_system/foundation/theme_scope.dart';
import './bubble.dart';

/// `<div data-slot="message-group">` — the column.
///
/// `flex min-w-0 flex-col gap-2`: one per conversation, or one per run of turns
/// from the same sender.
class MessageGroup extends StatelessWidget {
  const MessageGroup({super.key, required this.children});

  final List<Widget> children;

  /// `gap-2`.
  static double get gap => space(2);

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      for (int i = 0; i < children.length; i++) ...<Widget>[
        if (i > 0) SizedBox(height: gap),
        children[i],
      ],
    ],
  );
}

/// One turn: an optional avatar beside a [MessageContent] column.
///
/// `align: end` sets `flex-row-reverse` **and**, through `group-data`, pushes
/// every slot inside the content column to `self-end`. It is the only
/// alignment control — nothing below it takes an align of its own except
/// [Bubble], which mirrors it through [BubbleAlignScope].
class Message extends StatelessWidget {
  const Message({
    super.key,
    required this.content,
    this.avatar,
    this.align = BubbleAlign.start,
    this.ghost = false,
  });

  /// `gap-2` between the avatar and the content column.
  static double get gap => space(2);

  /// [MessageContent] — everything that is not the avatar.
  final Widget content;

  /// [MessageAvatar], or nothing. `w-fit min-w-8 shrink-0 self-end`.
  final Widget? avatar;

  final BubbleAlign align;

  /// `group-has-data-[variant=ghost]/message` — whether this row's bubble is
  /// the `ghost` variant, which has no padding for the header and footer to
  /// line up with, so their 12px inset collapses to zero.
  ///
  /// A parameter because the reference asks it of the subtree with `:has()`
  /// and Flutter cannot; see the library note.
  final bool ghost;

  @override
  Widget build(BuildContext context) {
    final Widget row = Row(
      // `align-items: stretch` is the flex default, and the avatar's own
      // `self-end` is what pins it to the bottom. Flutter's `stretch` needs a
      // bounded cross axis and a message column has none, so the row aligns to
      // the end instead: the content column is the tallest child on every row
      // in the corpus, so stretching it changes nothing, and the avatar lands
      // exactly where `self-end` puts it.
      crossAxisAlignment: CrossAxisAlignment.end,
      textDirection: align == BubbleAlign.end
          // `data-[align=end]:flex-row-reverse`.
          ? TextDirection.rtl
          : TextDirection.ltr,
      children: <Widget>[
        if (avatar != null) ...<Widget>[avatar!, SizedBox(width: gap)],
        Expanded(
          // The content column is laid out in the page's own direction; only
          // the *row* reverses.
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: content,
          ),
        ),
      ],
    );

    return MessageScope(
      align: align,
      ghost: ghost,
      child: BubbleAlignScope(
        align: align,
        child: DefaultTextStyle.merge(
          // `text-sm` on the row, inherited by every slot that does not state
          // its own.
          style: StyledText.styleOf(context, TextStyles.body),
          child: row,
        ),
      ),
    );
  }
}

/// `group/message`'s two published facts: the row's align, and whether its
/// bubble is `ghost`.
class MessageScope extends InheritedWidget {
  const MessageScope({
    super.key,
    required this.align,
    required this.ghost,
    required super.child,
  });

  final BubbleAlign align;
  final bool ghost;

  static MessageScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MessageScope>();

  @override
  bool updateShouldNotify(MessageScope old) =>
      old.align != align || old.ghost != ghost;
}

/// `<div data-slot="message-avatar">` — a rounded well on `--muted`.
///
/// The component only sets `min-w-8`; the call site gives it a size, which is
/// `className="size-8"` on both of the page's two.
class MessageAvatar extends StatelessWidget {
  const MessageAvatar({
    super.key,
    required this.child,
    this.size,
    this.lifted = false,
  });

  /// `min-w-8` — 32px.
  static double get minWidth => space(8);

  /// `-translate-y-8` — the 32px the avatar rises by when the message has a
  /// footer, so it stays level with the bubble rather than the timestamp.
  static double get lift => space(8);

  /// The glyph inside the well.
  final Widget child;

  /// `className="size-8"` — the square the call site asks for. Null leaves the
  /// well at [minWidth] wide and as tall as its child.
  final double? size;

  /// `group-has-data-[slot=message-footer]/message:-translate-y-8`.
  ///
  /// Passed rather than sensed: see the library note — the call site that
  /// composed the message is the one place that already knows whether it gave
  /// the content column a footer.
  final bool lifted;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    Widget well = Container(
      constraints: BoxConstraints(minWidth: minWidth),
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.muted,
        borderRadius: BorderRadius.circular(Radii.full),
      ),
      // `overflow-hidden`.
      clipBehavior: Clip.antiAlias,
      child: child,
    );

    if (lifted) {
      // A transform, not a layout change — the slot it vacates stays reserved.
      well = Transform.translate(offset: Offset(0, -lift), child: well);
    }

    // `self-end` — the row's own `CrossAxisAlignment.end` is what performs it;
    // see [Message].
    return well;
  }
}

/// `<div data-slot="message-content">` — everything that is not the avatar.
///
/// `flex-col gap-2.5`, and under `align: end` every direct child is pushed to
/// `self-end` by `group-data-[align=end]/message:*:data-slot:self-end`.
class MessageContent extends StatelessWidget {
  const MessageContent({
    super.key,
    required this.children,
    this.header,
    this.footer,
  });

  /// `gap-2.5` — 10px.
  static double get gap => space(2.5);

  /// The bubbles, in order.
  final List<Widget> children;

  /// [MessageHeader], above them.
  final Widget? header;

  /// [MessageFooter], below them.
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final MessageScope? scope = MessageScope.maybeOf(context);
    final bool end = scope?.align == BubbleAlign.end;

    final List<Widget> slots = <Widget>[?header, ...children, ?footer];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: end
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.stretch,
      children: <Widget>[
        for (int i = 0; i < slots.length; i++) ...<Widget>[
          if (i > 0) SizedBox(height: gap),
          slots[i],
        ],
      ],
    );
  }
}

/// `<div data-slot="message-header">` — `px-3 text-xs font-medium` on
/// `--muted-foreground`, inset by 12px to line up with `BubbleContent`'s
/// padding.
class MessageHeader extends StatelessWidget {
  const MessageHeader({super.key, required this.text});

  /// `px-3`, collapsed to zero on a ghost row.
  static double get inset => space(3);

  final String text;

  @override
  Widget build(BuildContext context) => _MessageMeta(text: text, end: false);
}

/// `<div data-slot="message-footer">` — the header's twin, plus
/// `group-data-[align=end]/message:justify-end`.
class MessageFooter extends StatelessWidget {
  const MessageFooter({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => _MessageMeta(text: text, end: true);
}

class _MessageMeta extends StatelessWidget {
  const _MessageMeta({required this.text, required this.end});

  final String text;

  /// Only the footer carries `justify-end`; a header stays flush left even in
  /// an end-aligned row, which is what the reference's class lists say and
  /// what the page renders.
  final bool end;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final MessageScope? scope = MessageScope.maybeOf(context);
    final bool ghost = scope?.ghost ?? false;
    final bool alignEnd = end && scope?.align == BubbleAlign.end;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ghost ? 0 : MessageHeader.inset,
      ),
      child: Align(
        alignment: alignEnd
            ? AlignmentDirectional.centerEnd
            : AlignmentDirectional.centerStart,
        child: StyledText(text, TextStyles.small, color: theme.mutedForeground),
      ),
    );
  }
}
