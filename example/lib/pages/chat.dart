/// `/design-system/components/base/chat` — four product-agnostic conversation
/// primitives, only one of which this system itself uses.
///
/// The page whose fifth section is the point of the other four: `Message`,
/// `Bubble` and `Message Scroller` are imported nowhere but here, `Attachment`
/// is composed by the agent console's own wrapper, and the reader is told to
/// read that section first.
///
/// ## The fidelity bar is that every specimen is live
///
/// A reader can hover a reaction pill and watch its count widen out of nothing,
/// press one and feel the squish, scroll an eleven-turn transcript and watch the
/// bottom fade close and the jump button leave the frame, press that button and
/// ride the smooth scroll back, drag the attachment tray sideways and watch it
/// snap, press the save control and see the glyph roll to a check under a
/// *Saving* toast, and open the sample card full size over the dimmed page.
/// Nothing here is a picture.
///
/// ## Probes
///
/// Everything the components pin was measured on the live reference at 1440×900
/// on 2026-08-16, before any of it was built:
/// `scratchpad/ba2-chat-inv.js` (DOM + computed-style inventory),
/// `ba2-chat-scroll.js` (the scroller driven: item heights both sides of
/// `content-visibility`, the mask across a scroll ramp, both button legs, the
/// smooth-scroll trajectory), `ba2-chat-inter.js` (reaction hover and press,
/// the download swap and its toast, the group's snap and fades, a second
/// smooth-scroll distance), `ba2-chat-hover.js` (the hovers the first pass
/// mis-drove) and `ba2-chat-dialog.js` (the media preview panel).
///
/// ## Probe corrections — what the source said and the browser did not
///
///  1. **The scroller button's own transition never applies.**
///     `transition-[translate,scale,opacity]` loses to `Button`'s list through
///     tailwind-merge, so `translate` and `scale` **snap** and only `opacity`
///     animates. Traced one frame for the transforms, 250ms for the fade.
///  2. **`duration-fast` on the reaction count is a no-op, confirmed live** —
///     the pair runs 250ms on `--ease-out`, not 150. Same for the button's
///     `duration-base` / `duration-slow`. (`bubble.tsx:203`,
///     `message-scroller.tsx:109` — the two sites the sweep flagged.)
///  3. **`scroll-fade-b` is scroll-driven, not static.** The mask holds at
///     38.4px for the first 302px of travel and closes over the last 96 on the
///     CSS `ease-in-out` **keyword**, which is not this system's `--ease-in-out`
///     and is 7 points apart from it at the midpoint.
///  4. **`contain-intrinsic-size` is observable.** With the scroller off the
///     browser viewport every item measures the assumed 160px and the content
///     box is 2048; on screen they measure 39.13 and it is 718.38. Only the
///     second is what a reader ever sees.
///  5. **The vertical spinner override never matches.** Two of the five state
///     cells render a 16px spinner beside three cells rendering 24px glyphs, in
///     identical 32px wells, because `Icon` drops `data-slot` before the DOM.
///  6. **The `sm` vertical media well is not full width.** 32px in a 120px
///     tile — the size rule is written after `vertical:w-full` and wins.
///  7. **Attachment padding is uniform.** `px-2.5 py-2` and its two siblings
///     are dead: the `has-media` `p-*` rule takes the whole shorthand. Measured
///     8 / 6 / 4 on all four sides.
///  8. **`Command`-style `has-[>a,>button]:hover` on `Attachment` is
///     unreachable** — probed across all eighteen, not one has a direct `<a>`
///     or `<button>` child.
///  9. **The smooth scroll is distance-dependent**, ~one frame per √px: 100px
///     settles in 168ms and 398px in 335ms.
/// 10. **`DialogContent`'s `data-slot` is overwritten by the call site** —
///     the preview panel is `[data-slot=attachment-preview]`, which is why a
///     `dialog-content` query finds nothing while the dialog is open.
///
/// ## Drift register — recorded, shipped as written
///
///  1. **The eyebrow says "Base" twice.** `` `${group.title} · Base` `` with
///     `group.title = "Base Components"`. All fourteen base pages.
///  2. **Two of the seven bubble variants fail AA, and the page says so.**
///     `default` is 4.39:1 in both themes (inherited from `--primary` under
///     `--primary-foreground`, so every primary button shares it) and
///     `destructive` is 4.12:1 on light. §7 exempts only disabled controls, so
///     both are failures rather than sanctioned exceptions. Reported, not
///     corrected — the fix is a token move that lands on every call site.
///  3. **`BubbleReactions` rings in `--card` and the page has to compensate.**
///     Two specimen panels carry `bodyClassName="bg-card"` so the ring is
///     invisible; on `--background` in dark it reads as a halo, which the
///     page's own source comment says.
///  4. **The reactions rail's `has-[button]:p-0` changes the rail's height.**
///     The bare form is 22.5625 tall and the data form 28 — same component,
///     same side, two different overhangs.
///  5. **`Bubble ghost` keeps its 1px transparent border.** No fill, no
///     padding, no radius — and still a border, so its box is 23.13 rather than
///     21.125.
///  6. **The transcript's eleven turns pass `align` twice.** Every
///     `MessageScrollerItem` sets it on the `Message` *and* on the `Bubble`,
///     which the component's own Meta calls *"redundant rather than wrong"*.
///  7. **`MessageAvatar` sets no size and the page sets `size-8` on both.**
///     The component only guarantees `min-w-8`, so an avatar with a taller
///     child would be a taller circle.
///  8. **The eleven-turn transcript never scrolls past the fade.** It opens at
///     `defaultScrollPosition="start"` — a fade at the bottom, a button in the
///     way — which is the caption's own stated intent and also the one state
///     in which neither of the component's two edge behaviours is at rest.
///  9. **`Attachment` advertises five states and the console's domain type can
///     produce two.** The page says so in §5: `error` and `uploading` are shown
///     *"with data this domain type could never produce"*.
/// 10. **The AA note's own figures are unverifiable from the page.** They are
///     quoted as rasterised measurements against surfaces the page does not
///     name; reproduced verbatim as copy.
/// 11. **`duration-fast` / `duration-base` / `duration-slow` are classes that
///     do nothing.** Tailwind v4 has no `--duration-*` namespace — closed
///     corpus-wide by the sweep, and re-measured on this page's two sites.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../kit.dart';
import '../nav.dart';
import '../shell.dart';

/* ── Specimen data ───────────────────────────────────────────────────────── */

/// `BUBBLE_VARIANTS` — the seven, with the reference's own notes.
const List<(DsBubbleVariant, String)> _bubbleVariants =
    <(DsBubbleVariant, String)>[
  (DsBubbleVariant.normal, "the sender's own turn"),
  (DsBubbleVariant.secondary, 'the other party'),
  (DsBubbleVariant.muted, 'quieter, on a card'),
  (DsBubbleVariant.tinted, 'brand wash, per theme'),
  (DsBubbleVariant.outline, 'hairline, no fill'),
  (DsBubbleVariant.ghost, 'no bubble at all'),
  (DsBubbleVariant.destructive, 'failed to send'),
];

/// One turn of `TRANSCRIPT`.
typedef _Turn = ({String id, bool user, String text});

/// *"Long enough that the viewport genuinely overflows — a fade over nothing
/// proves nothing."*
const List<_Turn> _transcript = <_Turn>[
  (
    id: 'm1',
    user: false,
    text: 'Morning. Three sets on your watchlist moved overnight.'
  ),
  (id: 'm2', user: true, text: 'Which three?'),
  (
    id: 'm3',
    user: false,
    text: 'Eclipse Vault, Origin Pulse and Nightfall. Eclipse is the outlier '
        '— up 14% on twice the usual volume.'
  ),
  (id: 'm4', user: true, text: 'Anything unusual about the volume?'),
  (
    id: 'm5',
    user: false,
    text: 'It is concentrated. Four accounts account for most of it, and all '
        'four bought within the same eleven minutes.'
  ),
  (id: 'm6', user: true, text: 'Show me what I hold in that set.'),
  (
    id: 'm7',
    user: false,
    text: "Six cards, two of them graded. At this morning's mark that is "
        r'$2,481.00, up $312.00 since Friday.'
  ),
  (id: 'm8', user: true, text: 'Leave it. What about Nightfall?'),
  (
    id: 'm9',
    user: false,
    text: 'Flat on price, but the float shrank — nine sealed packs left '
        'listed, down from thirty-one.'
  ),
  (id: 'm10', user: true, text: 'Watch it and tell me if it drops below five.'),
  (
    id: 'm11',
    user: false,
    text: 'Set. I will message you the moment the listed count crosses five, '
        'and again if it clears out entirely.'
  ),
];

/// `ATTACHMENT_STATES`.
const List<(DsAttachmentState, String, String)> _attachmentStates =
    <(DsAttachmentState, String, String)>[
  (DsAttachmentState.idle, 'idle', 'dashed — nothing chosen yet'),
  (DsAttachmentState.uploading, 'uploading', 'spinner + shimmer'),
  (DsAttachmentState.processing, 'processing', 'sent, being read'),
  (DsAttachmentState.error, 'error', 'border and media turn'),
  (DsAttachmentState.done, 'done', 'the resting state'),
];

/// `WHY` — the fifth section, as data.
///
/// *"`what` is what the primitive is for; `instead` is what the console does
/// and why. Both halves matter — a reader who only has the second half
/// concludes the component is useless rather than unused."*
const List<(String name, String what, String instead)> _why =
    <(String, String, String)>[
  (
    'Message',
    'The layout of one turn: avatar, header, content, footer, and an align '
        "that mirrors the whole row for the sender's own messages. It holds no "
        'state and knows nothing about what is inside it — six flex containers '
        'sharing one group/message.',
    'components/agent/parts/message.tsx is not a layout, it is a renderer. '
        'UserMessage and AgentMessage both push their text through Markdown; '
        'AgentMessage first strips the tool protocol out of the stream and '
        'appends a blinking cursor for as long as turn.streaming is true. And '
        "a turn is not the console's unit of layout at all: agent-console.tsx "
        'maps five kinds — user, text, tool, action, error — as flat siblings '
        'in one column, so a tool chip is a peer of a message rather than a '
        'child of one. There is no row for Message to be.',
  ),
  (
    'Bubble',
    'A speech bubble with seven surfaces, an alignment, and a reactions rail '
        'that can hang off any corner. BubbleContent takes asChild, so the '
        'bubble itself can be the button or the link.',
    "The console's two sides are asymmetric on purpose, and parts/message.tsx "
        "says so in a comment: the assistant's turn is set flush in the column "
        'like body copy, because it is often long, frequently contains lists '
        'and tables, and three hundred words in a speech bubble are harder to '
        "read for no gain. Only the user's turn is bubble-shaped, and it is "
        'drawn by hand — bg-agent-muted, border-agent/20, and rounded-br-sm to '
        'square the corner nearest the sender. Bubble has no agent surface and '
        'no tail; every corner is rounded-xl. Adopting it would mean adding a '
        "variant to a generic primitive to carry one product's accent, which "
        'is the wrong direction for a dependency to run.',
  ),
  (
    'Message Scroller',
    'Autoscroll with anchor management, from @shadcn/react rather than Radix. '
        'A provider, a viewport, per-item message ids, a scroll anchor, and a '
        'button that hides itself once it is already at the end. It can scroll '
        'to a named message, hold position while older turns are prepended, '
        'and peek the previous item.',
    "The console's transcript is one plain div it owns outright: a ref, an "
        'onScroll, and blurClass(switchPhase) — the cross-fade the transcript '
        'runs while a conversation is swapped underneath it. Its pin test '
        'allows 32px rather than the default 8, so a reader who is essentially '
        'at the bottom stays pinned, and it re-runs on [transport.turns, '
        'state] so a phase change moves the view too, not only a new turn. The '
        'API is not the obstacle — Viewport forwards ref, onScroll and '
        'className, and scrollEdgeThreshold would cover the 32px. The reason '
        'is smaller and better: the console needs none of what this adds. It '
        'never jumps to a cited message and never prepends history, so a '
        'provider and four nested elements would replace nine lines with more '
        'structure and no more behaviour. The day it does need to cite a '
        'message, this is the component to reach for.',
  ),
  (
    'Attachment',
    'A file, as a row or a tile: five states, three sizes, two orientations, '
        'an icon or an image thumbnail, an actions cluster, and a trigger that '
        'makes the whole tile clickable without nesting a button inside a '
        'button.',
    'This is the one of the four the console actually imports. '
        'components/agent/parts/attachments.tsx is a thin wrapper: '
        'AttachmentCard renders this primitive directly — Attachment, '
        'AttachmentMedia, AttachmentContent, AttachmentActions — and adds '
        'exactly the one thing it cannot express, the delivery badge, which '
        "says whether the file's bytes reached the model or only its filename "
        'did. That is agent semantics rather than file semantics, which is why '
        'it could not simply move into ui/. State is always "done": '
        "core/types.ts's Attachment carries no upload lifecycle, so there is "
        'no error or uploading value the wrapper could pass honestly — those '
        'two states are real on this primitive, shown above with data this '
        "domain type could never produce. One piece stayed separate: the "
        "transcript's full-width image preview keeps its own module-private "
        "ImageAttachment, because this primitive's image media is a fixed 40px "
        'well and a screenshot shrunk to a chip is not the screenshot someone '
        'attached.',
  ),
];

/* ── Page ────────────────────────────────────────────────────────────────── */

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DsCategoryHit here = findCategory('base', 'chat');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsPageHeader(
          // DRIFT 1.
          eyebrow: '${here.group.title} · Base',
          title: here.category.title,
          blurb: here.category.blurb,
          contents: here.category.contents,
        ),
        // `className="mb-12"` — 48px, above the first section rather than
        // inside it.
        Padding(
          padding: EdgeInsets.only(bottom: ds(12)),
          child: const DsNote(
            title: 'Read the last section first',
            child: _OpeningNote(),
          ),
        ),
        const _MessageSection(),
        const _BubbleSection(),
        const _ScrollerSection(),
        const _AttachmentSection(),
        const _WhySection(),
        const DsPageFootNav(groupId: 'base', slug: 'chat'),
      ],
    );
  }
}

class _OpeningNote extends StatelessWidget {
  const _OpeningNote();

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsRichText(
            TextSpan(
              children: <InlineSpan>[
                const TextSpan(
                  text: 'Three of these four are imported nowhere but this '
                      'page, and that is not an oversight. The agent console '
                      'writes its own turn, its own bubble and its own scroll '
                      'logic, for reasons that are specific and documented '
                      'below. They stay because ',
                ),
                DsCode.span('components/ui'),
                const TextSpan(
                  text: ' is the chassis that travels into the next project, '
                      'and the next project may have no agent console in it at '
                      'all.',
                ),
              ],
            ),
            DsType.small,
          ),
          // `<span className="mt-3 block">`.
          SizedBox(height: ds(3)),
          DsRichText(
            TextSpan(
              children: <InlineSpan>[
                const TextSpan(text: 'Attachment is the one exception: '),
                DsCode.span('components/agent/parts/attachments.tsx'),
                const TextSpan(
                  text: ' composes it directly, and that row below says what '
                      'it adds on top — see ',
                ),
                DsCode.span(
                  '/design-system/components/agent/transcript#attachments',
                ),
                const TextSpan(text: ' for the wrapper itself.'),
              ],
            ),
            DsType.small,
          ),
        ],
      );
}

/* ── §1 · Message ────────────────────────────────────────────────────────── */

class _MessageSection extends StatelessWidget {
  const _MessageSection();

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'message',
      title: 'Message',
      description: 'One turn, laid out. Avatar, header, content, footer — and '
          'a single align prop that flips the whole row, so the sender’s own '
          'messages need no second component.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DsPanel(
            label: 'A two-turn exchange',
            note: 'align: start, then end',
            child: DsMessageGroup(
              children: <Widget>[
                DsMessage(
                  avatar: DsMessageAvatar(
                    size: ds(8),
                    lifted: true,
                    child: const DsIcon.lucide(
                      DsLucide.bot,
                      size: DsIconSize.sm,
                      tone: DsIconTone.action,
                    ),
                  ),
                  content: const DsMessageContent(
                    header: DsMessageHeader(text: 'Atlas'),
                    footer: DsMessageFooter(text: '09:41'),
                    children: <Widget>[
                      DsBubble(
                        variant: DsBubbleVariant.muted,
                        child: DsBubbleContent(
                          child: Text(
                            'Eclipse Vault is up 14% overnight, on twice the '
                            'usual volume.',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                DsMessage(
                  align: DsBubbleAlign.end,
                  avatar: DsMessageAvatar(
                    size: ds(8),
                    lifted: true,
                    child: const DsIcon.lucide(
                      DsLucide.user,
                      size: DsIconSize.sm,
                      tone: DsIconTone.muted,
                    ),
                  ),
                  content: const DsMessageContent(
                    header: DsMessageHeader(text: 'You'),
                    footer: DsMessageFooter(text: '09:42'),
                    children: <Widget>[
                      DsBubble(
                        align: DsBubbleAlign.end,
                        child: DsBubbleContent(
                          child: Text('Show me what I hold in that set.'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // `className="mt-4"`.
          SizedBox(height: ds(4)),
          const DsPanel(
            label: 'No avatar, no header, no footer',
            note: 'the parts are all optional',
            child: DsMessageGroup(
              children: <Widget>[
                DsMessage(
                  content: DsMessageContent(
                    children: <Widget>[
                      DsBubble(
                        variant: DsBubbleVariant.outline,
                        child: DsBubbleContent(
                          child: Text(
                            'Six cards, two of them graded. \$2,481.00 at this '
                            'morning’s mark.',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                DsMessage(
                  align: DsBubbleAlign.end,
                  content: DsMessageContent(
                    children: <Widget>[
                      DsBubble(
                        variant: DsBubbleVariant.secondary,
                        align: DsBubbleAlign.end,
                        child: DsBubbleContent(child: Text('Leave it.')),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: ds(4)),
          const DsMeta(
            items: <DsMetaItem>[
              (
                k: 'MessageGroup',
                                v: TextSpan(
                  text: 'The column. flex-col with an 8px gap — one per '
                    'conversation, or one per run of turns from the same '
                    'sender.',
                ),
              ),
              (
                k: 'Message align',
                                v: TextSpan(
                  text: 'start (default) or end. end sets flex-row-reverse and, '
                    'through group-data, pushes every slot inside '
                    'MessageContent to self-end. It is the only alignment '
                    'control — nothing below it takes an align of its own '
                    'except Bubble, which mirrors it.',
                ),
              ),
              (
                k: 'MessageAvatar',
                                v: TextSpan(
                  text: 'A rounded well on --muted. Give it a size; the component '
                    'only sets min-w-8. It lifts itself by 32px when the '
                    'message has a footer, so it stays level with the bubble '
                    'rather than the timestamp.',
                ),
              ),
              (
                k: 'MessageContent',
                                v: TextSpan(
                  text: 'Everything that is not the avatar. Stacks header, bubbles '
                    'and footer with a 10px gap.',
                ),
              ),
              (
                k: 'MessageHeader / MessageFooter',
                                v: TextSpan(
                  text: 'text-xs on --muted-foreground, inset by 12px to line up '
                    'with BubbleContent’s padding. Both collapse that inset to '
                    'zero when the bubble is ghost, which has no padding to '
                    'line up with.',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/* ── §2 · Bubble ─────────────────────────────────────────────────────────── */

class _BubbleSection extends StatelessWidget {
  const _BubbleSection();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    return DsSection(
      id: 'bubble',
      title: 'Bubble',
      description: 'The surface a message sits on. Seven variants, two '
          'alignments, and a reactions rail — all of it driven off data-slot, '
          'so BubbleContent can be swapped for a button or a link without '
          'restating a single class.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DsStateGrid(
            children: <Widget>[
              for (final (DsBubbleVariant v, String note) in _bubbleVariants)
                DsStateCell(
                  label: v.label,
                  note: note,
                  child: DsBubble(
                    variant: v,
                    child: const DsBubbleContent(child: Text('Up 14% overnight')),
                  ),
                ),
              DsStateCell(
                label: 'asChild',
                note: 'hover — the whole bubble is the control',
                child: DsBubble(
                  child: DsBubbleContent(
                    onPressed: () {},
                    child: const Text('Open the set'),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ds(4)),
          const DsNote(
            title: 'tinted is a token now, not a dark: variant',
            child: _TintedNote(),
          ),
          SizedBox(height: ds(4)),
          const DsNote(
            tone: DsNoteTone.error,
            title: 'Two of the seven fail AA — known, and not yet fixed',
            child: _ContrastNote(),
          ),
          SizedBox(height: ds(4)),
          const DsPanel(
            label: 'Alignment',
            note: 'align is set on the Bubble, or inherited from the Message',
            child: DsBubbleGroup(
              children: <Widget>[
                DsBubble(
                  variant: DsBubbleVariant.secondary,
                  child: DsBubbleContent(child: Text('Which three?')),
                ),
                DsBubble(
                  align: DsBubbleAlign.end,
                  child: DsBubbleContent(
                    child: Text('Eclipse, Origin Pulse and Nightfall.'),
                  ),
                ),
                DsBubble(
                  variant: DsBubbleVariant.secondary,
                  child: DsBubbleContent(child: Text('Watch the last one.')),
                ),
              ],
            ),
          ),
          SizedBox(height: ds(4)),
          // DRIFT 3. `BubbleReactions` rings in `--card` to punch itself out of
          // the bubble edge, so this specimen has to sit on a card surface for
          // the ring to be invisible. On `--background` in dark mode it reads
          // as a halo.
          DsPanel(
            label: 'Reactions',
            note: 'side × align — on a card, which is what the ring assumes',
            bodyFill: theme.card,
            child: const _ReactionRails(),
          ),
          SizedBox(height: ds(4)),
          DsPanel(
            label: 'Reactions with counts',
            note: 'reactions + showCount — hover or focus a pill',
            bodyFill: theme.card,
            child: const _ReactionCounts(),
          ),
          SizedBox(height: ds(4)),
          const DsMeta(
            items: <DsMetaItem>[
              (
                k: 'Bubble variant',
                                v: TextSpan(
                  text: 'default · secondary · muted · tinted · outline · ghost · '
                    'destructive. ghost drops the fill, the padding and the '
                    'radius, and is the only variant allowed the full width — '
                    'it is how you set a long answer flush in the column.',
                ),
              ),
              (
                k: 'Bubble align',
                                v: TextSpan(
                  text: 'start (default) or end. Inside a Message it also follows '
                    'that message’s align, so setting it twice is redundant '
                    'rather than wrong.',
                ),
              ),
              (
                k: 'BubbleContent',
                                v: TextSpan(
                  text: 'The painted surface: 12px / 8px padding, rounded-xl, '
                    'text-sm. Takes asChild, which is how a bubble becomes a '
                    'button or a link — the hover fill and the focus ring are '
                    'already written for both.',
                ),
              ),
              (
                k: 'BubbleReactions',
                                v: TextSpan(
                  text: 'side top | bottom, align start | end. Absolutely '
                    'positioned and pulled three quarters outside the bubble, '
                    'so it needs vertical room around it. Rings in --card: put '
                    'it on a card surface, or the ring shows as a halo.',
                ),
              ),
              (
                k: 'Width',
                                v: TextSpan(
                  text: 'Every bubble is capped at 80% of its column so the ragged '
                    'edge stays readable. ghost is exempt.',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TintedNote extends StatelessWidget {
  const _TintedNote();

  @override
  Widget build(BuildContext context) => DsRichText(
        TextSpan(
          children: <InlineSpan>[
            const TextSpan(text: 'It used to be four inline '),
            DsCode.span('oklch(from …)'),
            const TextSpan(text: ' values with a '),
            DsCode.span('dark:'),
            const TextSpan(
              text: ' twin for two of them. A colour that needs a ',
            ),
            DsCode.span('dark:'),
            const TextSpan(
              text: ' variant is a token that has not been written yet — §1, ',
            ),
            const TextSpan(text: 'What light mode actually costs'),
            const TextSpan(
              text: ', which is explicit that no component carries a ',
            ),
            DsCode.span('dark:'),
            const TextSpan(
              text: ' variant for any of the three things that genuinely '
                  'change between the themes. So the wash is ',
            ),
            DsCode.span('--bubble-tinted'),
            const TextSpan(
              text: ', declared once in each theme block and derived from ',
            ),
            DsCode.span('--primary'),
            const TextSpan(
              text: ' so it follows a rebrand. Light lands at lightness 0.93, '
                  'dark at 0.30; the component names one class and never asks '
                  'which surface it is on.',
            ),
          ],
        ),
        DsType.small,
      );
}

class _ContrastNote extends StatelessWidget {
  const _ContrastNote();

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsRichText(
            TextSpan(
              children: <InlineSpan>[
                const TextSpan(
                  text: 'Rasterised into a 1×1 canvas and measured against the '
                      'surface each one actually paints. ',
                ),
                DsCode.span('default'),
                const TextSpan(
                  text: ' is 4.39:1 in both themes: it is the system’s '
                      'standard ',
                ),
                DsCode.span('--primary'),
                const TextSpan(text: ' fill under '),
                DsCode.span('--primary-foreground'),
                const TextSpan(
                  text: ', so the gap is inherited rather than local to this '
                      'component, and every primary button shares the figure. ',
                ),
                DsCode.span('destructive'),
                const TextSpan(
                  text: ' is 6.24:1 on dark but 4.12:1 on light, where the ink '
                      'is the fill shade and the wash under it is nearly '
                      'white.',
                ),
              ],
            ),
            DsType.small,
          ),
          SizedBox(height: ds(3)),
          DsRichText(
            const TextSpan(
              text: '§7 asks every text colour to clear AA and exempts only '
                  'disabled controls, so both of these are failures, not '
                  'sanctioned exceptions. They are reported here rather than '
                  'quietly corrected because the fix is a token move that '
                  'lands on every call site in the system, which is the '
                  'owner’s call and not this page’s. The other five variants '
                  'run from 13:1 to 19:1.',
            ),
            DsType.small,
          ),
        ],
      );
}

/// The four bare rails: `side × align`, on a card.
class _ReactionRails extends StatelessWidget {
  const _ReactionRails();

  /// `grid grid-cols-2 gap-8 sm:grid-cols-4`.
  static const List<(DsBubbleSide, DsBubbleAlign)> _corners =
      <(DsBubbleSide, DsBubbleAlign)>[
    (DsBubbleSide.bottom, DsBubbleAlign.end),
    (DsBubbleSide.bottom, DsBubbleAlign.start),
    (DsBubbleSide.top, DsBubbleAlign.end),
    (DsBubbleSide.top, DsBubbleAlign.start),
  ];

  @override
  Widget build(BuildContext context) => DsGrid(
        base: 2,
        sm: 4,
        gap: ds(8),
        children: <Widget>[
          for (final (DsBubbleSide side, DsBubbleAlign align) in _corners)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DsBubble(
                  variant: DsBubbleVariant.muted,
                  reactions: DsBubbleReactions(
                    side: side,
                    align: align,
                    children: const <Widget>[
                      Text('🔥'),
                      Text('❤️'),
                      Text('👏'),
                    ],
                  ),
                  child: const DsBubbleContent(child: Text('Nice pull')),
                ),
                // `gap-6`.
                SizedBox(height: ds(6)),
                DsText(
                  '${side.name} · ${align.name}',
                  DsType.micro,
                  align: TextAlign.center,
                ),
              ],
            ),
        ],
      );
}

/// The two data rails — `showCount` on hover and always.
class _ReactionCounts extends StatelessWidget {
  const _ReactionCounts();

  static const List<DsBubbleReaction> _reactions = <DsBubbleReaction>[
    DsBubbleReaction(emoji: '🔥', count: 12, label: 'fire', mine: true),
    DsBubbleReaction(emoji: '❤️', count: 8, label: 'a heart'),
    DsBubbleReaction(emoji: '👏', count: 3, label: 'applause'),
  ];

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DsGrid(
            sm: 2,
            gap: ds(10),
            children: <Widget>[
              _CountRail(
                showCount: DsShowCount.hover,
                caption: 'showCount="hover" — the default',
              ),
              _CountRail(
                showCount: DsShowCount.always,
                caption: 'showCount="always"',
              ),
            ],
          ),
          // `Note className="mt-8"`.
          SizedBox(height: ds(8)),
          const DsNote(
            title: 'The count is never only on hover',
            child: _CountNote(),
          ),
        ],
      );

  static List<DsBubbleReaction> get reactions => _reactions;
}

class _CountRail extends StatelessWidget {
  const _CountRail({required this.showCount, required this.caption});

  final DsShowCount showCount;
  final String caption;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DsBubble(
            variant: DsBubbleVariant.muted,
            reactions: DsBubbleReactions(
              showCount: showCount,
              reactions: _ReactionCounts.reactions,
            ),
            child: const DsBubbleContent(child: Text('Nice pull')),
          ),
          SizedBox(height: ds(6)),
          DsText(caption, DsType.micro, align: TextAlign.center),
        ],
      );
}

class _CountNote extends StatelessWidget {
  const _CountNote();

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsRichText(
            TextSpan(
              children: <InlineSpan>[
                const TextSpan(
                  text: 'Collapsing the number until hover or focus is a '
                      'density decision — a rail can hold six of these. It is '
                      'not where the information lives. Every pill carries ',
                ),
                DsCode.span('8 reacted with a heart'),
                const TextSpan(
                  text: ' in the accessibility tree at rest, so a screen '
                      'reader and a keyboard user both get the count without '
                      'pointing at anything. §7 does not allow information to '
                      'live in a hover state alone, and §4.3 says the same of '
                      'animation.',
                ),
              ],
            ),
            DsType.small,
          ),
          SizedBox(height: ds(3)),
          DsRichText(
            TextSpan(
              children: <InlineSpan>[
                const TextSpan(text: 'The first pill is '),
                DsCode.span('mine'),
                const TextSpan(
                  text: ' — the reader already reacted that way. It carries a '
                      'border, a fill and ',
                ),
                DsCode.span('aria-pressed'),
                const TextSpan(
                  text: ', because trap 11 and §7 both rule out a hue as the '
                      'only carrier of a state.',
                ),
              ],
            ),
            DsType.small,
          ),
          SizedBox(height: ds(3)),
          DsRichText(
            TextSpan(
              children: <InlineSpan>[
                DsCode.span('reactions'),
                const TextSpan(
                  text: ' is a parameter on the rail that already existed, not '
                      'a new component. Pass ',
                ),
                DsCode.span('children'),
                const TextSpan(
                  text: ' instead and it stays the bare rail shown above.',
                ),
              ],
            ),
            DsType.small,
          ),
        ],
      );
}

/* ── §3 · Message Scroller ───────────────────────────────────────────────── */

class _ScrollerSection extends StatefulWidget {
  const _ScrollerSection();

  @override
  State<_ScrollerSection> createState() => _ScrollerSectionState();
}

class _ScrollerSectionState extends State<_ScrollerSection> {
  /// `<MessageScrollerProvider autoScroll defaultScrollPosition="start">`.
  final DsMessageScrollerController _controller = DsMessageScrollerController(
    autoScroll: true,
    defaultScrollPosition: DsScrollPosition.start,
  );

  /// `bodyClassName="h-80"` — 320px, and the number every measured fact in
  /// `message_scroller.dart` is relative to.
  static double get viewportHeight => ds(80);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'message-scroller',
      title: 'Message Scroller',
      description: 'A transcript viewport that manages its own scroll: fades '
          'its overflowing edge, offers a jump-to-end button while you are '
          'reading back, and can anchor on a named message. From '
          '@shadcn/react, not Radix.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DsPanel(
            label: 'Eleven turns in a 320px viewport',
            note: 'starts at the top, so both the fade and the button are '
                'visible',
            flush: true,
            child: SizedBox(
              height: viewportHeight,
              child: DsMessageScrollerProvider(
                controller: _controller,
                child: DsMessageScroller(
                  viewport: DsMessageScrollerViewport(
                    child: DsMessageScrollerContent(
                      padding: EdgeInsets.all(ds(6)),
                      children: <Widget>[
                        for (final _Turn t in _transcript)
                          DsMessageScrollerItem(
                            messageId: t.id,
                            child: DsMessage(
                              // DRIFT 6 — the align is set here and again on
                              // the bubble below.
                              align: t.user
                                  ? DsBubbleAlign.end
                                  : DsBubbleAlign.start,
                              content: DsMessageContent(
                                children: <Widget>[
                                  DsBubble(
                                    variant: t.user
                                        ? DsBubbleVariant.normal
                                        : DsBubbleVariant.muted,
                                    align: t.user
                                        ? DsBubbleAlign.end
                                        : DsBubbleAlign.start,
                                    child: DsBubbleContent(
                                      child: Text(t.text),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  button: const DsMessageScrollerButton(),
                ),
              ),
            ),
          ),
          SizedBox(height: ds(4)),
          const DsNote(
            tone: DsNoteTone.value,
            title: 'The fade is not defined in globals.css — do not delete it',
            child: _FadeNote(),
          ),
          SizedBox(height: ds(4)),
          const DsMeta(
            items: <DsMetaItem>[
              (
                k: 'MessageScrollerProvider',
                                v: TextSpan(
                  text: 'Owns the state. autoScroll follows new content when you '
                    'are already at the end; defaultScrollPosition is start · '
                    'end · last-anchor and defaults to end; '
                    'scrollEdgeThreshold is the px tolerance for counting as '
                    'at an edge and defaults to 8.',
                ),
              ),
              (
                k: 'MessageScroller',
                                v: TextSpan(
                  text: 'The positioned frame. Everything else nests inside it, and '
                    'the button is absolute against it.',
                ),
              ),
              (
                k: 'MessageScrollerViewport',
                                v: TextSpan(
                  text: 'The element that actually scrolls. Carries scroll-fade-b '
                    'for the bottom mask, a stable scrollbar gutter so the '
                    'column does not shift when the bar appears, and hides its '
                    'own thumb while an autoscroll is running.',
                ),
              ),
              (
                k: 'MessageScrollerItem',
                                v: TextSpan(
                  text: 'One turn. Pass messageId to make it addressable, '
                    'scrollAnchor to make it the resting point. Renders under '
                    'content-visibility: auto, with an assumed off-screen '
                    'height of 40 spacing steps.',
                ),
              ),
              (
                k: 'MessageScrollerButton',
                                v: TextSpan(
                  text: 'direction start | end. Renders a Button and hides itself — '
                    'scale, opacity and a translate off its own edge — the '
                    'moment that direction has nowhere left to go.',
                ),
              ),
              (
                k: 'Hooks',
                                v: TextSpan(
                  text: 'useMessageScroller for scrollToEnd / scrollToStart / '
                    'scrollToMessage, useMessageScrollerScrollable for whether '
                    'either edge has travel left, useMessageScrollerVisibility '
                    'for the current anchor and what is on screen.',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FadeNote extends StatelessWidget {
  const _FadeNote();

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsRichText(
            TextSpan(
              children: <InlineSpan>[
                DsCode.span('scroll-fade-b'),
                const TextSpan(text: ' on the viewport is an '),
                DsCode.span('@utility'),
                const TextSpan(text: ' from '),
                DsCode.span('shadcn/tailwind.css'),
                const TextSpan(text: ', which '),
                DsCode.span('app/globals.css'),
                const TextSpan(text: ' imports on its third line. So is '),
                DsCode.span('shimmer'),
                const TextSpan(text: '. '),
                DsCode.span('scrollbar-gutter-stable'),
                const TextSpan(text: ', '),
                DsCode.span('scrollbar-thumb-transparent'),
                const TextSpan(text: ' and '),
                DsCode.span('scrollbar-track-transparent'),
                const TextSpan(text: ' come from Tailwind v4 itself. '),
                DsCode.span('scrollbar-thin'),
                const TextSpan(
                  text: ' is the one that is both: Tailwind v4 emits ',
                ),
                DsCode.span('scrollbar-width: thin'),
                const TextSpan(text: ' for it, and '),
                DsCode.span('globals.css'),
                const TextSpan(text: ' layers a second rule on top in an '),
                DsCode.span('@layer utilities'),
                const TextSpan(text: ' block to paint the thumb.'),
              ],
            ),
            DsType.small,
          ),
          SizedBox(height: ds(3)),
          DsRichText(
            TextSpan(
              children: <InlineSpan>[
                const TextSpan(text: 'So grepping '),
                DsCode.span('globals.css'),
                const TextSpan(
                  text: ' answers only “is it defined here” — of these six it '
                      'finds one and misses five. The only authority on '
                      'whether a class resolves is the built stylesheet, or ',
                ),
                DsCode.span('getComputedStyle'),
                const TextSpan(
                  text: ' in the browser. An audit of this page once declared '
                      'all six dead on exactly the grep that finds one of '
                      'them.',
                ),
              ],
            ),
            DsType.small,
          ),
        ],
      );
}

/* ── §4 · Attachment ─────────────────────────────────────────────────────── */

class _AttachmentSection extends StatelessWidget {
  const _AttachmentSection();

  /// `<Image src="/imgs/sample-card.png" width={96} height={96} />`.
  static const AssetImage _sampleCard = AssetImage('assets/imgs/sample-card.png');

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'attachment',
      title: 'Attachment',
      description: 'A file, in a conversation. Five states, because a file '
          'being uploaded, a file being read and a file that failed are three '
          'different things and a spinner alone says none of them.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DsStateGrid(
            cols: 5,
            children: <Widget>[
              for (final (DsAttachmentState s, String label, String note)
                  in _attachmentStates)
                DsStateCell(
                  label: label,
                  note: note,
                  child: DsAttachment(
                    state: s,
                    size: DsAttachmentSize.sm,
                    orientation: DsAttachmentOrientation.vertical,
                    media: DsAttachmentMedia(
                      child: switch (s) {
                        // PROBE CORRECTION 5: the spinner comes out 16px here
                        // while its three sibling glyphs come out 24, because
                        // the `size-6!` override keys off a `data-slot` the
                        // Icon component drops.
                        DsAttachmentState.uploading ||
                        DsAttachmentState.processing =>
                          const DsSpinner(),
                        DsAttachmentState.error => const DsIcon.lucide(
                            DsLucide.circleAlert,
                            sizePx: 24,
                          ),
                        _ => const DsIcon.lucide(DsLucide.sheet, sizePx: 24),
                      },
                    ),
                    content: DsAttachmentContent(
                      title: const DsAttachmentTitle('rarity-table.csv'),
                      description: DsAttachmentDescription(
                        s == DsAttachmentState.error ? 'Upload failed' : '18 KB',
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: ds(4)),
          DsPanel(
            label: 'Horizontal, at all three sizes',
            child: DsRow(
              align: DsRowAlign.start,
              children: <Widget>[
                for (final DsAttachmentSize size in DsAttachmentSize.values)
                  DsAttachment(
                    size: size,
                    media: DsAttachmentMedia(
                      child: DsIcon.lucide(
                        DsLucide.fileText,
                        sizePx: DsAttachmentMedia.glyphFor(
                          size,
                          DsAttachmentOrientation.horizontal,
                        ),
                      ),
                    ),
                    content: DsAttachmentContent(
                      title:
                          const DsAttachmentTitle('eclipse-vault-notes.pdf'),
                      description:
                          DsAttachmentDescription('size=${size.label}'),
                    ),
                    actions: DsAttachmentActions(
                      children: <Widget>[
                        DsAttachmentAction(
                          label: 'Remove eclipse-vault-notes.pdf',
                          onPressed: () {},
                          child: DsIcon.lucide(
                            DsLucide.x,
                            sizePx: DsButton.iconPxFor(DsButtonSize.iconXs),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: ds(4)),
          const DsPanel(
            label: 'Media: icon and image',
            note: 'the image variant dims itself until the file is done',
            child: DsRow(
              align: DsRowAlign.start,
              children: <Widget>[
                DsAttachment(
                  orientation: DsAttachmentOrientation.vertical,
                  media: DsAttachmentMedia(
                    variant: DsAttachmentMediaVariant.image,
                    child: Image(image: _sampleCard, fit: BoxFit.cover),
                  ),
                  content: DsAttachmentContent(
                    title: DsAttachmentTitle('sample-card.png'),
                    description: DsAttachmentDescription('412 KB'),
                  ),
                ),
                DsAttachment(
                  orientation: DsAttachmentOrientation.vertical,
                  media: DsAttachmentMedia(
                    child: DsIcon.lucide(DsLucide.image, sizePx: 24),
                  ),
                  content: DsAttachmentContent(
                    title: DsAttachmentTitle('slab-front.heic'),
                    description: DsAttachmentDescription('No preview'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: ds(4)),
          DsPanel(
            label: 'preview and download',
            note: 'two props, not two components',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                DsRow(
                  align: DsRowAlign.start,
                  children: <Widget>[
                    const DsAttachment(
                      orientation: DsAttachmentOrientation.vertical,
                      media: DsAttachmentMedia(
                        variant: DsAttachmentMediaVariant.image,
                        previewName: 'sample-card.png',
                        previewDescription: '412 KB',
                        preview: Image(image: _sampleCard, fit: BoxFit.contain),
                        child: Image(image: _sampleCard, fit: BoxFit.cover),
                      ),
                      content: DsAttachmentContent(
                        title: DsAttachmentTitle('sample-card.png'),
                        description:
                            DsAttachmentDescription('412 KB · press to expand'),
                      ),
                    ),
                    DsAttachment(
                      media: DsIcon.lucide(DsLucide.fileText, sizePx: 16)
                          .let((Widget glyph) =>
                              DsAttachmentMedia(child: glyph)),
                      content: const DsAttachmentContent(
                        title: DsAttachmentTitle('grading-report.pdf'),
                        description: DsAttachmentDescription('2.6 MB'),
                      ),
                      actions: DsAttachmentActions(
                        children: <Widget>[
                          DsAttachmentAction(
                            downloadName: 'grading-report.pdf',
                            onDownload: (String name) => docsToasts.show(
                              DsToastMessage(
                                title: 'Saving $name',
                                description:
                                    'Your browser is handling the download.',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // `Note className="mt-5"`.
                SizedBox(height: ds(5)),
                const DsNote(
                  title:
                      'Both are parameters on components that already existed',
                  child: _PreviewNote(),
                ),
              ],
            ),
          ),
          SizedBox(height: ds(4)),
          const DsPanel(
            label: 'AttachmentGroup',
            note: 'scrolls sideways, snaps, and fades its edge',
            child: _Tray(),
          ),
          SizedBox(height: ds(4)),
          const DsMeta(
            items: <DsMetaItem>[
              (
                k: 'Attachment state',
                                v: TextSpan(
                  text: 'idle · uploading · processing · error · done. idle draws a '
                    'dashed border; error tints the border and the media well; '
                    'uploading and processing put the title on a shimmer.',
                ),
              ),
              (
                k: 'Attachment size',
                                v: TextSpan(
                  text: 'default (14px text, 40px well) · sm (12px, 32px) · xs '
                    '(12px, 28px, a tighter radius). Pick by how much room the '
                    'tray has, not by importance.',
                ),
              ),
              (
                k: 'Attachment orientation',
                                v: TextSpan(
                  text: 'horizontal is a row with a 160px floor; vertical is a 96px '
                    'tile, widening to 120px once it carries a title.',
                ),
              ),
              (
                k: 'AttachmentMedia variant',
                                v: TextSpan(
                  text: 'icon (default) or image. image expects a real <img> child '
                    'and holds it at 60% opacity until the state is done or '
                    'idle, which is what makes an upload look like it is still '
                    'arriving.',
                ),
              ),
              (
                k: 'AttachmentActions / AttachmentAction',
                                v: TextSpan(
                  text: 'The cluster on the right, floating to the top-right corner '
                    'when vertical. Each action is a ghost icon-xs Button, so '
                    'it needs an aria-label of its own.',
                ),
              ),
              (
                k: 'AttachmentTrigger',
                                v: TextSpan(
                  text: 'An absolutely positioned button covering the whole tile, '
                    'for when the tile itself opens the file. It exists so an '
                    'action can still sit on top without a button nesting '
                    'inside a button.',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A tiny pipe so a `const` glyph can be wrapped without a local.
extension _Let on Widget {
  T let<T>(T Function(Widget) f) => f(this);
}

class _Tray extends StatelessWidget {
  const _Tray();

  static const List<String> _names = <String>[
    'rarity-table.csv',
    'eclipse-vault-notes.pdf',
    'grading-report.pdf',
    'pull-rates-q3.csv',
    'slab-front.png',
    'slab-back.png',
  ];

  @override
  Widget build(BuildContext context) => DsAttachmentGroup(
        children: <Widget>[
          for (final String name in _names)
            DsAttachment(
              size: DsAttachmentSize.sm,
              media: DsAttachmentMedia(
                child: DsIcon.lucide(
                  DsLucide.fileText,
                  sizePx: DsAttachmentMedia.glyphFor(
                    DsAttachmentSize.sm,
                    DsAttachmentOrientation.horizontal,
                  ),
                ),
              ),
              content: DsAttachmentContent(
                title: DsAttachmentTitle(name),
                description: const DsAttachmentDescription('Ready'),
              ),
            ),
        ],
      );
}

class _PreviewNote extends StatelessWidget {
  const _PreviewNote();

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsRichText(
            TextSpan(
              children: <InlineSpan>[
                DsCode.span('AttachmentMedia'),
                const TextSpan(text: ' takes '),
                DsCode.span('src'),
                const TextSpan(
                  text: ' and previews it by default; pass ',
                ),
                DsCode.span('preview={false}'),
                const TextSpan(
                  text: ' only when the well must remain static. The media '
                      'opens in a ',
                ),
                DsCode.span('Dialog'),
                const TextSpan(
                  text: ' over the dimmed page rather than a new tab, which '
                      'would hand the reader to the browser’s own viewer and '
                      'lose whatever they were reading. §5’s table calls a '
                      'dialog the reversible one, and there is nothing here to '
                      'decide. The close control is a ',
                ),
                DsCode.span('secondary'),
                const TextSpan(
                  text: ' Button, not the stock ghost ✕ — this panel has no '
                      'header band for the ✕ to sit on, and a ghost control '
                      'disappears into whatever pixel of the photograph it '
                      'lands on. The trigger is ',
                ),
                DsCode.span('AttachmentTrigger'),
                const TextSpan(
                  text: ', the overlay control this component already had, so '
                      'the thumbnail is never wrapped in a button that would '
                      'inherit padding and a variant it does not want.',
                ),
              ],
            ),
            DsType.small,
          ),
          SizedBox(height: ds(3)),
          DsRichText(
            TextSpan(
              children: <InlineSpan>[
                DsCode.span('AttachmentAction'),
                const TextSpan(text: ' takes '),
                DsCode.span('href'),
                const TextSpan(text: ' and downloads by default; pass '),
                DsCode.span('download={false}'),
                const TextSpan(
                  text: ' only when it should navigate instead. The save '
                      'control carries both signals §5 demands: the glyph '
                      'rolls to a check through ',
                ),
                DsCode.span('IconSwap'),
                const TextSpan(
                  text: ' so the control confirms it heard you, and a toast '
                      'reports the outcome. It says Saving, never Saved — a '
                      'plain ',
                ),
                DsCode.span('download'),
                const TextSpan(
                  text: ' anchor gives the page no completion event, so '
                      'claiming the bytes reached the disk would assert a '
                      'capability this component does not have.',
                ),
              ],
            ),
            DsType.small,
          ),
          SizedBox(height: ds(3)),
          DsRichText(
            TextSpan(
              children: <InlineSpan>[
                const TextSpan(
                  text: 'Both were briefly written as new exports and then '
                      'folded back. §5 grows a base component with a variant '
                      'or a parameter — that is how ',
                ),
                DsCode.span('Button'),
                const TextSpan(text: ', '),
                DsCode.span('Badge'),
                const TextSpan(text: ' and '),
                DsCode.span('Alert'),
                const TextSpan(
                  text: ' already work — and a new component for one more '
                      'branch is the wrong direction.',
                ),
              ],
            ),
            DsType.small,
          ),
        ],
      );
}

/* ── §5 · Why ────────────────────────────────────────────────────────────── */

class _WhySection extends StatelessWidget {
  const _WhySection();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    return DsSection(
      id: 'why',
      title: 'Why the agent console uses only one of them',
      description: 'Message, Bubble and Message Scroller are imported nowhere '
          'but this page; Attachment is the exception, composed by the '
          'console’s own wrapper rather than duplicated. All four cases share '
          'one lesson: reading only "what it does instead" concludes a '
          'component is useless, and reading only "what it is for" concludes '
          'it is unused. Neither half alone tells you whether deleting either '
          'side is safe.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // `div.space-y-4`.
          for (final (String name, String what, String instead) in _why)
            Padding(
              padding: EdgeInsets.only(
                bottom: name == _why.last.$1 ? 0 : ds(4),
              ),
              child: DsPanel(
                label: name,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    DsText('What it is for', DsType.label,
                        color: theme.actionInk),
                    SizedBox(height: ds(2)),
                    DsText(what, DsType.small),
                    // `div.space-y-5`.
                    SizedBox(height: ds(5)),
                    DsText(
                      'What the console does instead',
                      DsType.label,
                    ),
                    SizedBox(height: ds(2)),
                    DsText(instead, DsType.small),
                  ],
                ),
              ),
            ),
          // `Note className="mt-6"`.
          SizedBox(height: ds(6)),
          const DsNote(
            title: 'They stay because ui/ travels',
            child: _TravelNote(),
          ),
          // No gap: `<DoDont>` follows the Note with no margin of its own,
          // measured at 7770.03 + 190 = 7960.03 exactly.
          const DsDoDont(
            dos: <String>[
              'Reach for these when you need a chat surface that is not the '
                  'agent — a support thread, a comment column, two humans '
                  'talking.',
              'Read parts/message.tsx and agent-console.tsx before concluding '
                  'the console could just use these. The differences are '
                  'behavioural, not cosmetic.',
              'Check components/agent/parts/attachments.tsx before assuming a '
                  'ui/ primitive is unused — Attachment is already composed '
                  'there, with the delivery badge as the one thing layered on '
                  'top.',
            ],
            donts: <String>[
              'Delete a ui/ component because nothing in this repo imports it. '
                  'Nothing in this repo is the product; ui/ is the chassis for '
                  'the next one.',
              'Rewire the console onto Message or Bubble. An agent answer is a '
                  'document, not a text message, and the console’s layout says '
                  'so on purpose.',
              'Add an agent-coloured variant to Bubble so the console can '
                  'adopt it. That points the dependency from the generic layer '
                  'at the product layer, which is the direction this system '
                  'does not allow.',
            ],
          ),
        ],
      ),
    );
  }
}

class _TravelNote extends StatelessWidget {
  const _TravelNote();

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsRichText(
            TextSpan(
              children: <InlineSpan>[
                const TextSpan(
                  text: '§10 is explicit that this system is meant to be '
                      'lifted, and that ',
                ),
                DsCode.span('components/ui'),
                const TextSpan(text: ', '),
                DsCode.span('components/agent'),
                const TextSpan(
                  text: ' and the foundations all travel as-is. The next '
                      'project may want a support inbox, a comment thread or a '
                      'two-person chat and no agent console at all — and for '
                      'every one of those, these four are the right starting '
                      'point and ',
                ),
                DsCode.span('parts/message.tsx'),
                const TextSpan(
                  text: ' is not, because it is bound to a transport, a '
                      'markdown renderer and a streaming protocol.',
                ),
              ],
            ),
            DsType.small,
          ),
          SizedBox(height: ds(3)),
          DsRichText(
            TextSpan(
              children: <InlineSpan>[
                const TextSpan(text: 'Yes, each of these is one '),
                DsCode.span('npx shadcn add'),
                const TextSpan(
                  text: ' from coming back. That is not a reason to delete '
                      'them — it is a reason the delete looks free, which is a '
                      'different thing. What does not come back is the sweep '
                      'onto these tokens: a regenerated file arrives on stock '
                      'shadcn’s spacing, type and motion scales and fails ',
                ),
                DsCode.span('check:tokens'),
                const TextSpan(text: ' on arrival, exactly as §10 warns.'),
              ],
            ),
            DsType.small,
          ),
        ],
      );
}
