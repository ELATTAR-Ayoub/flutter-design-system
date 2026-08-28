/// Public documentation page for the `message` component.
///
/// `message` is the layout of one turn: [Message] is a row — an optional
/// [MessageAvatar] beside an [MessageContent] column — and knows nothing
/// about what is inside the column. [MessageContent] stacks an optional
/// [MessageHeader], a run of bubbles, and an optional [MessageFooter].
/// [MessageGroup] stacks a run of [Message] rows. A single `align` prop
/// on [Message] flips the whole row and, through [MessageScope], pushes
/// every slot in the content column to the same side — which is why the
/// sender's own turn needs no second component.
///
/// This page is new — `message` had no page before this pass — built from
/// `lib/src/components/message.dart` end to end and from the live specimens
/// already staged on `example/lib/pages/chat.dart`'s "Message" section,
/// reused here rather than invented fresh, per the rollout's own brief.
library;

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

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import 'meta.dart';

final ComponentDocSpec messageDocSpec = ComponentDocSpec(
  name: 'message',
  title: messageDoc.title,
  description: messageDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'A two-turn exchange: an avatar, a header naming the sender, a '
          'bubble, and a footer timestamp, on both sides of the column.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: space(160),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'message has a real registry manifest, `elattar add message` '
          'installs lib/src/components/message.dart and resolves bubble '
          'and source-foundation automatically. The Manual tab is for a '
          'project not using the CLI.',
      command: messageDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/message.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/message.dart's generated "
              '@ui/message.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated message source here when using '
              'manual mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so Message and its six companion '
              'classes are reachable the same way the CLI path already '
              'makes them.',
          code: "export 'message.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct import and construction: one bubble, no '
          'avatar, no header, no footer — every part below the row itself '
          'is optional.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'avatar',
      title: 'Avatar',
      description:
          'MessageAvatar is a rounded well on theme.muted. The '
          'component only guarantees min-w-8 (32px); the call site sizes '
          "it. lifted: true rises the well by 32px so it stays level with "
          "the bubble rather than the footer timestamp — pass it exactly "
          "when the message's own content carries a footer.",
      specimen: _AvatarSpecimen(),
      code: _avatarCode,
      label: 'Avatar specimen view',
    ),
    ShowcaseSection(
      id: 'header-footer',
      title: 'Header and Footer',
      description:
          'MessageHeader and MessageFooter both render 12px text on '
          'theme.mutedForeground, inset 12px to line up with '
          "BubbleContent's own padding. Only the footer carries "
          'justify-end under align: end; the header stays flush left '
          'either way.',
      specimen: _HeaderFooterSpecimen(),
      code: _headerFooterCode,
      label: 'Header and Footer specimen view',
    ),
    ShowcaseSection(
      id: 'align',
      title: 'Align',
      description:
          "align: end sets flex-row-reverse on the row and, through "
          'MessageScope, pushes every slot in the content column '
          '(header, bubbles, footer) to self-end — the sender\'s own '
          'turn needs no second component.',
      specimen: _AlignSpecimen(),
      code: _alignCode,
      label: 'Align specimen view',
    ),
    ShowcaseSection(
      id: 'ghost',
      title: 'Ghost',
      description:
          "ghost: true collapses the header and footer's own 12px inset "
          'to zero, matching a ghost bubble, which has no padding of its '
          'own to line up with. Passed rather than sensed: a Flutter '
          'parent cannot ask its content column whether the bubble '
          'inside it is ghost, so the call site that already knows says '
          'so directly.',
      specimen: _GhostSpecimen(),
      code: _ghostCode,
      label: 'Ghost specimen view',
    ),
    ShowcaseSection(
      id: 'group',
      title: 'Group',
      description:
          'MessageGroup stacks a run of Message rows with an 8px gap '
          '— one per conversation, or one per run of turns from the same '
          'sender. Every part beyond the bubble itself is optional, shown '
          'here with none of them set.',
      specimen: _GroupSpecimen(),
      code: _groupCode,
      label: 'Group specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter each of the seven exported '
          'classes declares: one table per class.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'MessageGroup', anchor: 'api-elmessagegroup'),
        DocsTocEntry(title: 'Message', anchor: 'api-elmessage'),
        DocsTocEntry(title: 'MessageScope', anchor: 'api-elmessagescope'),
        DocsTocEntry(title: 'MessageAvatar', anchor: 'api-elmessageavatar'),
        DocsTocEntry(title: 'MessageContent', anchor: 'api-elmessagecontent'),
        DocsTocEntry(title: 'MessageHeader', anchor: 'api-elmessageheader'),
        DocsTocEntry(title: 'MessageFooter', anchor: 'api-elmessagefooter'),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Message itself renders no MouseRegion, Focus or '
          'GestureDetector: every row here is a structural fact read off '
          'message.dart, not a caller-built interaction.',
      child: DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      child: _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      child: _KeyboardContent(),
    ),
    DisclosureSection(
      id: 'responsive',
      title: 'Responsive',
      child: _ResponsiveContent(),
    ),
    DisclosureSection(
      id: 'dependencies',
      title: 'Dependencies',
      child: _DependenciesContent(),
    ),
    DisclosureSection(
      id: 'theming',
      title: 'Theming',
      child: _ThemingContent(),
    ),
    DisclosureSection(
      id: 'source',
      title: 'Source',
      child: DocsInstallFacts(
        title: 'Reference',
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Source',
            value: messageDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/chat_test.dart',
            description:
                'Message and its companions are covered inside the '
                'shared chat-family suite alongside bubble and '
                'message-scroller: there is no dedicated message_test.dart '
                'in the package yet.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/message_test.dart',
            description:
                'Covers this page: the article mounts, the full API '
                'table, a live specimen of every part, and both themes '
                'at two viewport widths.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/message/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class MessageDocPage extends StatelessWidget {
  const MessageDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: messageDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENT · MESSAGE',
      title: messageDocSpec.title,
      description: messageDocSpec.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Message'),
    ],
    toc: messageDocSpec.toc,
    previous: const DocsPageLink(title: 'Bubble', route: '/components/bubble'),
    next: const DocsPageLink(
      title: 'Message Scroller',
      route: '/components/message-scroller',
    ),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('message-doc-article'),
      child: ComponentDocPage(spec: messageDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('message-example:preview'),
    child: MessageGroup(
      children: <Widget>[
        Message(
          avatar: MessageAvatar(
            size: space(8),
            lifted: true,
            child: const Icon.lucide(
              Lucide.bot,
              size: IconSize.sm,
              tone: IconTone.action,
            ),
          ),
          content: const MessageContent(
            header: MessageHeader(text: 'Atlas'),
            footer: MessageFooter(text: '09:41'),
            children: <Widget>[
              Bubble(
                variant: BubbleVariant.muted,
                child: BubbleContent(
                  child: Text(
                    'Eclipse Vault is up 14% overnight, on twice the '
                    'usual volume.',
                  ),
                ),
              ),
            ],
          ),
        ),
        Message(
          align: BubbleAlign.end,
          avatar: MessageAvatar(
            size: space(8),
            lifted: true,
            child: const Icon.lucide(
              Lucide.user,
              size: IconSize.sm,
              tone: IconTone.muted,
            ),
          ),
          content: const MessageContent(
            header: MessageHeader(text: 'You'),
            footer: MessageFooter(text: '09:42'),
            children: <Widget>[
              Bubble(
                align: BubbleAlign.end,
                child: BubbleContent(
                  child: Text('Show me what I hold in that set.'),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

const String _previewCode = '''
MessageGroup(
  children: [
    Message(
      avatar: MessageAvatar(
        size: space(8),
        lifted: true,
        child: const Icon.lucide(Lucide.bot, size: IconSize.sm),
      ),
      content: MessageContent(
        header: MessageHeader(text: 'Atlas'),
        footer: MessageFooter(text: '09:41'),
        children: [
          Bubble(
            variant: BubbleVariant.muted,
            child: BubbleContent(child: Text('Eclipse Vault is up 14%.')),
          ),
        ],
      ),
    ),
    Message(
      align: BubbleAlign.end,
      avatar: MessageAvatar(
        size: space(8),
        lifted: true,
        child: const Icon.lucide(Lucide.user, size: IconSize.sm),
      ),
      content: MessageContent(
        header: MessageHeader(text: 'You'),
        footer: MessageFooter(text: '09:42'),
        children: [
          Bubble(
            align: BubbleAlign.end,
            child: BubbleContent(child: Text('Show me what I hold.')),
          ),
        ],
      ),
    ),
  ],
)''';

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

Message(
  content: MessageContent(
    children: [
      Bubble(child: BubbleContent(child: Text('Which three?'))),
    ],
  ),
)''';

class _AvatarSpecimen extends StatelessWidget {
  const _AvatarSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('message-example:avatar'),
    child: Message(
      avatar: MessageAvatar(
        size: space(8),
        lifted: true,
        child: const Icon.lucide(
          Lucide.bot,
          size: IconSize.sm,
          tone: IconTone.action,
        ),
      ),
      content: const MessageContent(
        footer: MessageFooter(text: '09:41'),
        children: <Widget>[
          Bubble(
            variant: BubbleVariant.muted,
            child: BubbleContent(child: Text('Three sets moved overnight.')),
          ),
        ],
      ),
    ),
  );
}

const String _avatarCode = '''
Message(
  avatar: MessageAvatar(
    size: space(8),
    lifted: true,
    child: const Icon.lucide(Lucide.bot, size: IconSize.sm),
  ),
  content: MessageContent(
    footer: MessageFooter(text: '09:41'),
    children: [
      Bubble(
        variant: BubbleVariant.muted,
        child: BubbleContent(child: Text('Three sets moved overnight.')),
      ),
    ],
  ),
)''';

class _HeaderFooterSpecimen extends StatelessWidget {
  const _HeaderFooterSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('message-example:header-footer'),
    child: Message(
      content: const MessageContent(
        header: MessageHeader(text: 'Atlas'),
        footer: MessageFooter(text: '09:41'),
        children: <Widget>[
          Bubble(
            variant: BubbleVariant.muted,
            child: BubbleContent(child: Text('Three sets moved overnight.')),
          ),
        ],
      ),
    ),
  );
}

const String _headerFooterCode = '''
Message(
  content: MessageContent(
    header: MessageHeader(text: 'Atlas'),
    footer: MessageFooter(text: '09:41'),
    children: [
      Bubble(
        variant: BubbleVariant.muted,
        child: BubbleContent(child: Text('Three sets moved overnight.')),
      ),
    ],
  ),
)''';

class _AlignSpecimen extends StatelessWidget {
  const _AlignSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('message-example:align'),
    child: Message(
      align: BubbleAlign.end,
      content: const MessageContent(
        footer: MessageFooter(text: '09:42'),
        children: <Widget>[
          Bubble(
            align: BubbleAlign.end,
            child: BubbleContent(child: Text('Leave it.')),
          ),
        ],
      ),
    ),
  );
}

const String _alignCode = '''
Message(
  align: BubbleAlign.end,
  content: MessageContent(
    footer: MessageFooter(text: '09:42'),
    children: [
      Bubble(
        align: BubbleAlign.end,
        child: BubbleContent(child: Text('Leave it.')),
      ),
    ],
  ),
)''';

class _GhostSpecimen extends StatelessWidget {
  const _GhostSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('message-example:ghost'),
    child: Message(
      ghost: true,
      content: const MessageContent(
        header: MessageHeader(text: 'Atlas'),
        children: <Widget>[
          Bubble(
            variant: BubbleVariant.ghost,
            child: BubbleContent(
              child: Text(
                'It is concentrated: four accounts account for most of '
                'the volume.',
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

const String _ghostCode = '''
Message(
  ghost: true,
  content: MessageContent(
    header: MessageHeader(text: 'Atlas'),
    children: [
      Bubble(
        variant: BubbleVariant.ghost,
        child: BubbleContent(child: Text('It is concentrated.')),
      ),
    ],
  ),
)''';

class _GroupSpecimen extends StatelessWidget {
  const _GroupSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('message-example:group'),
    child: const MessageGroup(
      children: <Widget>[
        Message(
          content: MessageContent(
            children: <Widget>[
              Bubble(
                variant: BubbleVariant.outline,
                child: BubbleContent(
                  child: Text(
                    'Six cards, two of them graded. \$2,481.00 at this '
                    "morning's mark.",
                  ),
                ),
              ),
            ],
          ),
        ),
        Message(
          align: BubbleAlign.end,
          content: MessageContent(
            children: <Widget>[
              Bubble(
                variant: BubbleVariant.secondary,
                align: BubbleAlign.end,
                child: BubbleContent(child: Text('Leave it.')),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

const String _groupCode = '''
MessageGroup(
  children: [
    Message(
      content: MessageContent(
        children: [
          Bubble(
            variant: BubbleVariant.outline,
            child: BubbleContent(child: Text('Six cards, two graded.')),
          ),
        ],
      ),
    ),
    Message(
      align: BubbleAlign.end,
      content: MessageContent(
        children: [
          Bubble(
            variant: BubbleVariant.secondary,
            align: BubbleAlign.end,
            child: BubbleContent(child: Text('Leave it.')),
          ),
        ],
      ),
    ),
  ],
)''';

/* ── API Reference ──────────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DocsAnchor(
        id: 'api-elmessagegroup',
        child: const DocsApiTable(
          title: 'MessageGroup',
          facts: _messageGroupFacts,
        ),
      ),
      SizedBox(height: space(6)),
      DocsAnchor(
        id: 'api-elmessage',
        child: const DocsApiTable(title: 'Message', facts: _messageFacts),
      ),
      SizedBox(height: space(6)),
      DocsAnchor(
        id: 'api-elmessagescope',
        child: const DocsApiTable(
          title: 'MessageScope',
          facts: _messageScopeFacts,
        ),
      ),
      SizedBox(height: space(6)),
      DocsAnchor(
        id: 'api-elmessageavatar',
        child: const DocsApiTable(
          title: 'MessageAvatar',
          facts: _messageAvatarFacts,
        ),
      ),
      SizedBox(height: space(6)),
      DocsAnchor(
        id: 'api-elmessagecontent',
        child: const DocsApiTable(
          title: 'MessageContent',
          facts: _messageContentFacts,
        ),
      ),
      SizedBox(height: space(6)),
      DocsAnchor(
        id: 'api-elmessageheader',
        child: const DocsApiTable(
          title: 'MessageHeader',
          facts: _messageHeaderFacts,
        ),
      ),
      SizedBox(height: space(6)),
      DocsAnchor(
        id: 'api-elmessagefooter',
        child: const DocsApiTable(
          title: 'MessageFooter',
          facts: _messageFooterFacts,
        ),
      ),
    ],
  );
}

const List<DocsApiFact> _messageGroupFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'children',
    type: 'List<Widget>',
    description: 'Required. A run of Message rows in a column, 8px apart.',
  ),
];

const List<DocsApiFact> _messageFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'content',
    type: 'Widget',
    description: 'Required. Usually an MessageContent.',
  ),
  DocsApiFact(
    name: 'avatar',
    type: 'Widget?',
    description:
        'Optional. Defaults to null. Usually an MessageAvatar. '
        'min-w-8, self-end.',
  ),
  DocsApiFact(
    name: 'align',
    type: 'BubbleAlign',
    description:
        'Optional. Defaults to BubbleAlign.start. The only alignment '
        'control on the row; flips it and, through MessageScope, '
        "pushes the content column's own slots to match.",
  ),
  DocsApiFact(
    name: 'ghost',
    type: 'bool',
    description:
        "Optional. Defaults to false. Whether this row's bubble is the "
        'ghost variant, which has no padding for the header/footer inset '
        'to line up with, so it collapses to zero. Passed rather than '
        "sensed — see the Ghost section above.",
  ),
];

const List<DocsApiFact> _messageScopeFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'align',
    type: 'BubbleAlign',
    description:
        "Required. The enclosing Message's own align, published so a "
        'child Bubble left at its default mirrors the row, and so '
        'MessageHeader/MessageFooter know which edge to hug.',
  ),
  DocsApiFact(
    name: 'ghost',
    type: 'bool',
    description:
        "Required. The enclosing Message's own ghost flag, published "
        "so MessageHeader/MessageFooter know whether to collapse "
        'their own inset.',
  ),
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description: 'Required. The subtree the scope wraps.',
  ),
];

const List<DocsApiFact> _messageAvatarFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description: 'Required. The glyph inside the well.',
  ),
  DocsApiFact(
    name: 'size',
    type: 'double?',
    description:
        'Optional. Defaults to null, which leaves the well at min-w-8 '
        '(32px) wide and as tall as its child. Every real call site '
        'passes space(8) to get a true 32px square.',
  ),
  DocsApiFact(
    name: 'lifted',
    type: 'bool',
    description:
        'Optional. Defaults to false. Rises the well by 32px (a '
        'transform, not a layout change: the slot stays reserved) — '
        "pass it when this message's content carries a footer, so the "
        "avatar stays level with the bubble rather than the timestamp.",
  ),
];

const List<DocsApiFact> _messageContentFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'children',
    type: 'List<Widget>',
    description: 'Required. The bubbles, in order.',
  ),
  DocsApiFact(
    name: 'header',
    type: 'Widget?',
    description: 'Optional. Defaults to null. Usually an MessageHeader.',
  ),
  DocsApiFact(
    name: 'footer',
    type: 'Widget?',
    description: 'Optional. Defaults to null. Usually an MessageFooter.',
  ),
];

const List<DocsApiFact> _messageHeaderFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'text',
    type: 'String',
    description: 'Required. 12px on theme.mutedForeground, inset 12px.',
  ),
];

const List<DocsApiFact> _messageFooterFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'text',
    type: 'String',
    description:
        "Required. The header's twin, plus justify-end under align: "
        'end.',
  ),
];

/* ── States ──────────────────────────────────────────────────────────────── */

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'align: start (default)',
    treatment: 'The row lays out ltr; the content column stretches.',
    userSignal: 'Avatar, header, bubbles and footer all sit at the left.',
  ),
  DocsStateFact(
    state: 'align: end',
    treatment:
        'The row lays out rtl (flex-row-reverse) and every content-column '
        'slot self-aligns to the end.',
    userSignal: 'The whole turn mirrors to the right.',
  ),
  DocsStateFact(
    state: 'avatar present, footer present',
    treatment:
        'Pass MessageAvatar.lifted: true on the avatar — a parameter, '
        'not something the row senses on its own.',
    userSignal: "The avatar rises 32px to stay level with the bubble.",
  ),
  DocsStateFact(
    state: 'ghost: true',
    treatment:
        "Message.ghost forwarded through MessageScope to every "
        "MessageHeader/MessageFooter in the column.",
    userSignal: "The header and footer's own 12px inset collapses to 0.",
  ),
  DocsStateFact(
    state: 'No native interactive state',
    treatment:
        'Nothing — Message mounts no MouseRegion, Focus, or '
        'GestureDetector.',
    userSignal:
        'Hover, press and focus are entirely a property of whatever is '
        'inside the column (a bubble, an asChild control).',
  ),
];

/* ── Prose disclosures ──────────────────────────────────────────────────── */

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Semantic role: none of its own. message.dart mounts Row/Column/'
            'Padding/DefaultTextStyle and an InheritedWidget — a screen '
            'reader hears whatever the avatar, header, bubbles and footer '
            'announce, not a message-level container role.',
        'Reading order follows source order, not visual order: align: end '
            'reverses the row visually (flex-row-reverse via '
            'TextDirection.rtl on the Row only) but the content column '
            'inside it stays LTR, and nothing here reorders a screen '
            "reader's traversal — it follows widget-tree order regardless "
            'of which side something paints on.',
        'MessageAvatar carries no accessible name of its own: its glyph '
            'child supplies whatever semantics it has, or none.',
        'MessageHeader/MessageFooter render plain StyledText — no '
            'semantic heading level or landmark role; a caller building a '
            'page outline needs its own wrapper.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'message.dart wires no key handling of its own anywhere in the '
            'file: no Focus, no focusNode, no LogicalKeyboardKey.',
        'Whatever keyboard story a message carries comes entirely from '
            'what is inside its content column — an asChild BubbleContent '
            'is focusable and answers Enter/Space through its own Focus '
            'wrapper; a plain div bubble is not.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No breakpoint branching anywhere in message.dart: BuildContext '
            'width is never read for a layout decision.',
        'The content column is wrapped in Expanded inside the row, so it '
            'always takes whatever width is left after the avatar — the '
            'row reflows to any width its parent hands it rather than '
            'switching layouts at a breakpoint.',
        'Every fixed measurement (gap, avatar lift, header/footer inset) '
            'is a 4px-grid value from space(), never keyed to viewport.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ThemeScope.of(context), <String>[
        'File: lib/src/components/message.dart — one file, no companions; '
            'the registry manifest lists exactly one entry under "files".',
        'Flutter imports: package:flutter/widgets.dart only.',
        'Foundation imports: foundation/spacing.dart (space()), '
            'foundation/theme.dart, foundation/typography.dart, '
            'theme_scope.dart (StyledText, ThemeScope).',
        'Component import: bubble.dart, for BubbleAlign and '
            'BubbleAlignScope — message.dart mirrors its own align onto '
            "every bubble in the column through bubble's own scope.",
        'registryDependencies, resolved automatically by `elattar add '
            'message`: bubble, source-foundation — copied verbatim from '
            'registry/components/message.json.',
      ]),
      SizedBox(height: space(2)),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
        child: DocsLinkRow(
          links: <DocsLink>[
            DocsLink(label: 'Bubble', route: '/components/bubble'),
            DocsLink(
              label: 'Message Scroller',
              route: '/components/message-scroller',
            ),
            DocsLink(
              label: 'Source Foundation',
              route: '/components/source_foundation',
            ),
          ],
        ),
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'The one colour message.dart reads directly is '
            'theme.mutedForeground, for MessageHeader and '
            'MessageFooter text. Everything else visible on a message — '
            "the avatar's own theme.muted well, every bubble's own fill "
            '— is theme owned by MessageAvatar or Bubble, not by this '
            'file.',
        'Shape: message.dart declares no radius, shadow, or border of '
            'its own; it is a layout file, not a painted surface.',
        'No override field: unlike Card\'s fill/ringColor, nothing here '
            'exposes a theming escape hatch — restyle the avatar or the '
            'bubbles it contains instead.',
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
