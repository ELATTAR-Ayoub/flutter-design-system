/// Public documentation page for the `message-scroller` component.
///
/// `message-scroller` is a transcript viewport that manages its own scroll:
/// [MessageScrollerProvider] publishes an [MessageScrollerController],
/// [MessageScrollerViewport] is the element that actually scrolls (a
/// bottom fade wrapped around it via [ScrollFade]), [MessageScrollerItem]
/// wraps each turn so it can register itself by [MessageScrollerItem.messageId]
/// or as the [MessageScrollerItem.scrollAnchor], and
/// [MessageScrollerButton] hides itself the instant its own direction has
/// nowhere left to travel.
///
/// This page is new — `message-scroller` had no page before this pass —
/// built from `lib/src/components/message_scroller.dart` end to end and from
/// the live specimen already staged on
/// `example/lib/pages/chat.dart`'s "Message Scroller" section, reused here
/// rather than invented fresh, per the rollout's own brief. Every stage on
/// this page is a real, eleven-turn scrolling transcript rather than a
/// picture — `minHeight: space(160)` throughout, since a scroller judged in the
/// house default (`space(96)`, 384px) reads as barely a window onto its own
/// content.
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

final ComponentDocSpec messageScrollerDocSpec = ComponentDocSpec(
  name: 'message-scroller',
  title: messageScrollerDoc.title,
  description: messageScrollerDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'Eleven turns in a 320px viewport, starting at the top so both '
          'the bottom fade and the jump-to-end button are visible without '
          'touching anything. Scroll it, or press the button, to watch '
          'the fade close over the last 96px of travel and the button '
          'leave the frame.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: space(160),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'message-scroller has a real registry manifest, `elattar add '
          'message-scroller` installs '
          'lib/src/components/message_scroller.dart and resolves button, '
          'icon and source-foundation automatically. The Manual tab is '
          'for a project not using the CLI.',
      command: messageScrollerDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/message_scroller.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/message_scroller.dart's generated "
              '@ui/message_scroller.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated message scroller source here when '
              'using manual mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so MessageScroller and its nine '
              'companion classes and enums are reachable the same way '
              'the CLI path already makes them.',
          code: "export 'message_scroller.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct construction: a controller, a provider, '
          'the frame, the scrolling viewport, and one item.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'scroll-position',
      title: 'Scroll Position',
      description:
          'defaultScrollPosition is start, end (the provider\'s own '
          'default) or lastAnchor. Applied once, after first layout. This '
          'specimen sets start, so the reader lands at the oldest turn '
          'with newer ones below the fold — the one state in which both '
          'the fade and the button are simultaneously visible.',
      specimen: _ScrollPositionSpecimen(),
      code: _scrollPositionCode,
      label: 'Scroll Position specimen view',
      minHeight: space(160),
    ),
    ShowcaseSection(
      id: 'button',
      title: 'Button',
      description:
          'MessageScrollerButton.direction is start (travels to the '
          'oldest turn) or end (the default, travels to the newest). '
          'Each hides itself — opacity only; the reference\'s own '
          'translate/scale transition loses to Button\'s class list and '
          'snaps in one frame — the instant its own direction has no '
          'travel left.',
      specimen: _ButtonSpecimen(),
      code: _buttonCode,
      label: 'Button specimen view',
      minHeight: space(160),
    ),
    ShowcaseSection(
      id: 'anchor',
      title: 'Anchor',
      description:
          'messageId makes an item addressable; scrollToMessage smooth-'
          'scrolls to it, on a duration and curve fitted to Chrome\'s own '
          'scrollTo({behavior: "smooth"}) — roughly one frame per √px '
          'of travel. Press the control below the transcript to jump to '
          'the sixth turn.',
      specimen: _AnchorSpecimen(),
      code: _anchorCode,
      label: 'Anchor specimen view',
      minHeight: space(160),
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter each exported class declares, and '
          'every value of the two exported enums: one table per class or '
          'enum.',
      children: const <DocsTocEntry>[
        DocsTocEntry(
          title: 'MessageScrollerController',
          anchor: 'api-elmessagescrollercontroller',
        ),
        DocsTocEntry(
          title: 'MessageScrollerProvider',
          anchor: 'api-elmessagescrollerprovider',
        ),
        DocsTocEntry(title: 'MessageScroller', anchor: 'api-elmessagescroller'),
        DocsTocEntry(
          title: 'MessageScrollerViewport',
          anchor: 'api-elmessagescrollerviewport',
        ),
        DocsTocEntry(
          title: 'MessageScrollerContent',
          anchor: 'api-elmessagescrollercontent',
        ),
        DocsTocEntry(
          title: 'MessageScrollerItem',
          anchor: 'api-elmessagescrolleritem',
        ),
        DocsTocEntry(
          title: 'MessageScrollerButton',
          anchor: 'api-elmessagescrollerbutton',
        ),
        DocsTocEntry(title: 'ScrollPosition', anchor: 'api-elscrollposition'),
        DocsTocEntry(title: 'ScrollDirection', anchor: 'api-elscrolldirection'),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Read off MessageScrollerController.scrollable, '
          '_MessageScrollerViewportState.build and '
          'MessageScrollerButton.build, not inferred.',
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
            value: messageScrollerDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/chat_test.dart',
            description:
                'MessageScroller and its controller are covered inside '
                'the shared chat-family suite alongside bubble and '
                'message: there is no dedicated message_scroller_test.dart '
                'in the package yet.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/message_scroller_test.dart',
            description:
                'Covers this page: the article mounts, the full API '
                'table, a live scrolling transcript, and both themes at '
                'two viewport widths.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/message_scroller/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class MessageScrollerDocPage extends StatelessWidget {
  const MessageScrollerDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: messageScrollerDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENT · MESSAGE SCROLLER',
      title: messageScrollerDocSpec.title,
      description: messageScrollerDocSpec.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Message Scroller'),
    ],
    toc: messageScrollerDocSpec.toc,
    previous: const DocsPageLink(
      title: 'Message',
      route: '/components/message',
    ),
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('message-scroller-doc-article'),
      child: ComponentDocPage(spec: messageScrollerDocSpec, header: false),
    ),
  );
}

/* ── Specimen data ───────────────────────────────────────────────────────── */

typedef _Turn = ({String id, bool user, String text});

const List<_Turn> _transcript = <_Turn>[
  (
    id: 'm1',
    user: false,
    text: 'Morning. Three sets on your watchlist moved overnight.',
  ),
  (id: 'm2', user: true, text: 'Which three?'),
  (
    id: 'm3',
    user: false,
    text:
        'Eclipse Vault, Origin Pulse and Nightfall. Eclipse is the '
        'outlier — up 14% on twice the usual volume.',
  ),
  (id: 'm4', user: true, text: 'Anything unusual about the volume?'),
  (
    id: 'm5',
    user: false,
    text:
        'It is concentrated. Four accounts account for most of it, and '
        'all four bought within the same eleven minutes.',
  ),
  (id: 'm6', user: true, text: 'Show me what I hold in that set.'),
  (
    id: 'm7',
    user: false,
    text:
        "Six cards, two of them graded. At this morning's mark that is "
        r'$2,481.00, up $312.00 since Friday.',
  ),
  (id: 'm8', user: true, text: 'Leave it. What about Nightfall?'),
  (
    id: 'm9',
    user: false,
    text:
        'Flat on price, but the float shrank: nine sealed packs left '
        'listed, down from thirty-one.',
  ),
  (id: 'm10', user: true, text: 'Watch it and tell me if it drops below five.'),
  (
    id: 'm11',
    user: false,
    text:
        'Set. I will message you the moment the listed count crosses '
        'five, and again if it clears out entirely.',
  ),
];

/// A transcript, built once per specimen so each can own its own
/// [MessageScrollerController] without repeating the item-building code.
Widget _transcriptContent() => MessageScrollerContent(
  padding: EdgeInsets.all(space(6)),
  children: <Widget>[
    for (final _Turn t in _transcript)
      MessageScrollerItem(
        messageId: t.id,
        child: Message(
          align: t.user ? BubbleAlign.end : BubbleAlign.start,
          content: MessageContent(
            children: <Widget>[
              Bubble(
                variant: t.user ? BubbleVariant.normal : BubbleVariant.muted,
                align: t.user ? BubbleAlign.end : BubbleAlign.start,
                child: BubbleContent(child: Text(t.text)),
              ),
            ],
          ),
        ),
      ),
  ],
);

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

final controller = MessageScrollerController();

MessageScrollerProvider(
  controller: controller,
  child: SizedBox(
    height: 320,
    child: MessageScroller(
      viewport: MessageScrollerViewport(
        child: MessageScrollerContent(
          children: [
            MessageScrollerItem(
              messageId: 'm1',
              child: Message(
                content: MessageContent(
                  children: [Bubble(child: BubbleContent(child: Text('Hi.')))],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ),
)''';

class _PreviewSpecimen extends StatefulWidget {
  const _PreviewSpecimen();

  @override
  State<_PreviewSpecimen> createState() => _PreviewSpecimenState();
}

class _PreviewSpecimenState extends State<_PreviewSpecimen> {
  final MessageScrollerController _controller = MessageScrollerController(
    autoScroll: true,
    defaultScrollPosition: ScrollPosition.start,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('message-scroller-example:preview'),
    child: SizedBox(
      height: space(80),
      child: MessageScrollerProvider(
        controller: _controller,
        child: MessageScroller(
          viewport: MessageScrollerViewport(child: _transcriptContent()),
          button: const MessageScrollerButton(),
        ),
      ),
    ),
  );
}

const String _previewCode = '''
final controller = MessageScrollerController(
  autoScroll: true,
  defaultScrollPosition: ScrollPosition.start,
);

SizedBox(
  height: 320,
  child: MessageScrollerProvider(
    controller: controller,
    child: MessageScroller(
      viewport: MessageScrollerViewport(child: transcript),
      button: const MessageScrollerButton(),
    ),
  ),
)''';

class _ScrollPositionSpecimen extends StatefulWidget {
  const _ScrollPositionSpecimen();

  @override
  State<_ScrollPositionSpecimen> createState() =>
      _ScrollPositionSpecimenState();
}

class _ScrollPositionSpecimenState extends State<_ScrollPositionSpecimen> {
  final MessageScrollerController _controller = MessageScrollerController(
    defaultScrollPosition: ScrollPosition.start,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('message-scroller-example:scroll-position'),
    child: SizedBox(
      height: space(80),
      child: MessageScrollerProvider(
        controller: _controller,
        child: MessageScroller(
          viewport: MessageScrollerViewport(child: _transcriptContent()),
          button: const MessageScrollerButton(),
        ),
      ),
    ),
  );
}

const String _scrollPositionCode = '''
MessageScrollerController(defaultScrollPosition: ScrollPosition.start)''';

class _ButtonSpecimen extends StatefulWidget {
  const _ButtonSpecimen();

  @override
  State<_ButtonSpecimen> createState() => _ButtonSpecimenState();
}

class _ButtonSpecimenState extends State<_ButtonSpecimen> {
  final MessageScrollerController _controller = MessageScrollerController(
    defaultScrollPosition: ScrollPosition.start,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('message-scroller-example:button'),
    child: SizedBox(
      height: space(80),
      child: MessageScrollerProvider(
        controller: _controller,
        child: MessageScroller(
          viewport: MessageScrollerViewport(child: _transcriptContent()),
          button: const MessageScrollerButton(direction: ScrollDirection.end),
        ),
      ),
    ),
  );
}

const String _buttonCode = '''
const MessageScrollerButton(direction: ScrollDirection.end)''';

class _AnchorSpecimen extends StatefulWidget {
  const _AnchorSpecimen();

  @override
  State<_AnchorSpecimen> createState() => _AnchorSpecimenState();
}

class _AnchorSpecimenState extends State<_AnchorSpecimen> {
  final MessageScrollerController _controller = MessageScrollerController(
    defaultScrollPosition: ScrollPosition.start,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('message-scroller-example:anchor'),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: space(70),
          child: MessageScrollerProvider(
            controller: _controller,
            child: MessageScroller(
              viewport: MessageScrollerViewport(child: _transcriptContent()),
              button: const MessageScrollerButton(),
            ),
          ),
        ),
        SizedBox(height: space(3)),
        Button(
          key: const ValueKey<String>(
            'message-scroller-example:anchor-trigger',
          ),
          variant: ButtonVariant.outline,
          onPressed: () => _controller.scrollToMessage('m6'),
          child: const Text('Jump to "Show me what I hold in that set."'),
        ),
      ],
    ),
  );
}

const String _anchorCode = '''
Button(
  onPressed: () => controller.scrollToMessage('m6'),
  child: const Text('Jump to that message'),
)''';

/* ── API Reference ──────────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DocsAnchor(
        id: 'api-elmessagescrollercontroller',
        child: const DocsApiTable(
          title: 'MessageScrollerController',
          facts: _controllerFacts,
        ),
      ),
      SizedBox(height: space(6)),
      DocsAnchor(
        id: 'api-elmessagescrollerprovider',
        child: const DocsApiTable(
          title: 'MessageScrollerProvider',
          facts: _providerFacts,
        ),
      ),
      SizedBox(height: space(6)),
      DocsAnchor(
        id: 'api-elmessagescroller',
        child: const DocsApiTable(
          title: 'MessageScroller',
          facts: _scrollerFacts,
        ),
      ),
      SizedBox(height: space(6)),
      DocsAnchor(
        id: 'api-elmessagescrollerviewport',
        child: const DocsApiTable(
          title: 'MessageScrollerViewport',
          facts: _viewportFacts,
        ),
      ),
      SizedBox(height: space(6)),
      DocsAnchor(
        id: 'api-elmessagescrollercontent',
        child: const DocsApiTable(
          title: 'MessageScrollerContent',
          facts: _contentFacts,
        ),
      ),
      SizedBox(height: space(6)),
      DocsAnchor(
        id: 'api-elmessagescrolleritem',
        child: const DocsApiTable(
          title: 'MessageScrollerItem',
          facts: _itemFacts,
        ),
      ),
      SizedBox(height: space(6)),
      DocsAnchor(
        id: 'api-elmessagescrollerbutton',
        child: const DocsApiTable(
          title: 'MessageScrollerButton',
          facts: _buttonFacts,
        ),
      ),
      SizedBox(height: space(6)),
      DocsAnchor(
        id: 'api-elscrollposition',
        child: const DocsApiTable(
          title: 'ScrollPosition',
          facts: _scrollPositionFacts,
        ),
      ),
      SizedBox(height: space(6)),
      DocsAnchor(
        id: 'api-elscrolldirection',
        child: const DocsApiTable(
          title: 'ScrollDirection',
          facts: _scrollDirectionFacts,
        ),
      ),
    ],
  );
}

const List<DocsApiFact> _controllerFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'autoScroll',
    type: 'bool',
    description:
        'Optional. Defaults to false. Follows new content while already '
        'at the end.',
  ),
  DocsApiFact(
    name: 'defaultScrollPosition',
    type: 'ScrollPosition',
    description:
        'Optional. Defaults to ScrollPosition.end. Applied once, after '
        'first layout.',
  ),
  DocsApiFact(
    name: 'scrollEdgeThreshold',
    type: 'double?',
    description:
        'Optional. Defaults to null, which resolves to '
        'defaultEdgeThreshold (8px). The px tolerance for counting as at '
        'an edge.',
  ),
];

const List<DocsApiFact> _providerFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'controller',
    type: 'MessageScrollerController',
    description:
        'Required. Owned by whatever mounts the scroller — publish it '
        'once above the frame the same way the reference\'s own provider '
        'is mounted.',
  ),
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description: 'Required. The subtree the provider wraps.',
  ),
];

const List<DocsApiFact> _scrollerFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'viewport',
    type: 'Widget',
    description: 'Required. Usually an MessageScrollerViewport.',
  ),
  DocsApiFact(
    name: 'button',
    type: 'Widget?',
    description:
        'Optional. Defaults to null. Usually an '
        'MessageScrollerButton, absolutely positioned against this '
        'frame.',
  ),
];

const List<DocsApiFact> _viewportFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description: 'Required. Usually an MessageScrollerContent.',
  ),
  DocsApiFact(
    name: 'semanticsLabel',
    type: 'String',
    description:
        "Optional. Defaults to 'Messages'. role=\"region\" "
        'aria-label on the live element.',
  ),
];

const List<DocsApiFact> _contentFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'children',
    type: 'List<Widget>',
    description: 'Required. The turns, in order, 24px apart.',
  ),
  DocsApiFact(
    name: 'padding',
    type: 'EdgeInsetsGeometry?',
    description:
        'Optional. Defaults to null (EdgeInsets.zero). The component '
        'itself declares none; every specimen on this page passes its '
        'own.',
  ),
];

const List<DocsApiFact> _itemFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description: 'Required. One turn — usually an Message.',
  ),
  DocsApiFact(
    name: 'messageId',
    type: 'String?',
    description:
        'Optional. Defaults to null. What scrollToMessage looks the '
        'item up by.',
  ),
  DocsApiFact(
    name: 'scrollAnchor',
    type: 'bool',
    description:
        'Optional. Defaults to false. Makes this item the resting point '
        'for ScrollPosition.lastAnchor.',
  ),
];

const List<DocsApiFact> _buttonFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'direction',
    type: 'ScrollDirection',
    description: 'Optional. Defaults to ScrollDirection.end.',
  ),
];

const List<DocsApiFact> _scrollPositionFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'start',
    type: 'enum value',
    description: 'The top of the viewport.',
  ),
  DocsApiFact(
    name: 'end',
    type: 'enum value',
    description: "The bottom — the provider's own default.",
  ),
  DocsApiFact(
    name: 'lastAnchor',
    type: 'enum value',
    description:
        'The item marked scrollAnchor, falling back to end when there '
        'is none.',
  ),
];

const List<DocsApiFact> _scrollDirectionFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'start',
    type: 'enum value',
    description: 'Up, to the oldest message.',
  ),
  DocsApiFact(
    name: 'end',
    type: 'enum value',
    description: 'Down, to the newest — the default.',
  ),
];

/* ── States ──────────────────────────────────────────────────────────────── */

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Fade at rest',
    treatment:
        'Full height (min(12% of the viewport, space(10)/40px)) whenever '
        'the viewport is more than 96px from its own max scroll extent.',
    userSignal: 'A soft mask over the bottom edge, signalling more below.',
  ),
  DocsStateFact(
    state: 'Fade closing',
    treatment:
        'Shrinks to zero over the last 96px of scroll travel, on '
        'MotionCurves.cssEaseInOut — the CSS ease-in-out keyword, not this '
        "system's own --ease-in-out.",
    userSignal: 'The mask visibly thins as the reader nears the bottom.',
  ),
  DocsStateFact(
    state: 'Button active',
    treatment:
        "scrollable(direction) is true: the edge threshold (8px default) "
        'has travel left.',
    userSignal: 'Full opacity, at rest scale and position, tappable.',
  ),
  DocsStateFact(
    state: 'Button inactive',
    treatment:
        'scrollable(direction) is false. Scale and a translate off its '
        'own edge both snap in one frame (the reference\'s own '
        'transition list drops them); only opacity animates, 250ms on '
        'MotionCurves.exit.',
    userSignal: 'Fades out and stops answering taps — IgnorePointer.',
  ),
  DocsStateFact(
    state: 'Autoscrolling',
    treatment:
        'A programmatic smooth scroll is running (scrollToEnd, '
        'scrollToStart, scrollToMessage, or autoScroll following new '
        'content).',
    userSignal:
        'The scrollbar thumb goes fully transparent for the '
        'duration of the jump.',
  ),
];

/* ── Prose disclosures ──────────────────────────────────────────────────── */

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        "MessageScrollerViewport wraps its content in "
            'Semantics(container: true, label: semanticsLabel), '
            "'Messages' by default — role=\"region\" aria-label on the "
            'reference.',
        'MessageScrollerButton is a real Button underneath, and '
            'inherits everything Button\'s own Accessibility disclosure '
            'documents — including a fixed accessible label ("Scroll to '
            'end" / "Scroll to start") independent of the arrow glyph.',
        'When a button goes inactive it is wrapped in IgnorePointer, '
            'which also removes it from hit-testing, but its opacity '
            'animation is the only signal to a screen reader that it '
            'changed state — nothing here sets Semantics.hidden on it.',
        'The bottom fade is a purely visual ShaderMask: it carries no '
            'semantics of its own and communicates nothing to assistive '
            'technology about how much content remains below the fold.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'The viewport itself is a SingleChildScrollView with '
            'ClampingScrollPhysics: Flutter\'s own scroll view answers '
            'arrow-key and Page Up/Down scrolling when it holds focus, '
            'the same as any other Scrollable — message_scroller.dart '
            'adds nothing on top of that default.',
        'MessageScrollerButton is a real Button and inherits its '
            'keyboard story whole: focusable via Tab when active, '
            'removed from traversal when inactive (onPressed: null), '
            'and activates on Enter/Space.',
        'scrollToMessage, scrollToEnd and scrollToStart are plain '
            'Dart methods on the controller — reachable from any '
            'keyboard-triggered callback a caller wires up, not only '
            'from a pointer tap.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No breakpoint branching anywhere in message_scroller.dart: '
            'BuildContext width is never read for a layout decision.',
        'MessageScroller fills whatever box its caller gives it '
            '(size: full in the reference) — every specimen on this page '
            'sets its own SizedBox height for that reason; the component '
            'declares no height of its own.',
        'The fade\'s own height is a fraction of the viewport '
            '(min(12%, space(10))), so it scales down automatically on a '
            'short viewport rather than reading a breakpoint.',
        'MessageScrollerItem carries no content-visibility skip in '
            'this port (Flutter has no off-screen remembered-size '
            'primitive): every item renders its full content regardless '
            'of scroll position, unlike the CSS reference.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ThemeScope.of(context), <String>[
        'File: lib/src/components/message_scroller.dart — one file, no '
            'companions; the registry manifest lists exactly one entry '
            'under "files".',
        'Flutter imports: dart:math (sqrt for the smooth-scroll '
            'duration), package:flutter/gestures.dart (PointerDeviceKind, '
            'the scroll behaviour\'s drag devices), '
            'package:flutter/widgets.dart.',
        'Foundation imports: foundation/colors.dart (transparent), '
            'foundation/motion.dart (effectiveMotionDuration), '
            'foundation/spacing.dart (space()), foundation/theme.dart, '
            'theme_scope.dart.',
        'Component imports: button.dart (Button, for the jump '
            'control) and icon.dart / icon_paths.g.dart (Icon.lucide, '
            'the arrow glyph).',
        'registryDependencies, resolved automatically by `elattar add '
            'message-scroller`: button, icon, source-foundation — '
            'copied verbatim from registry/components/message-scroller.json.',
      ]),
      SizedBox(height: space(2)),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
        child: DocsLinkRow(
          links: <DocsLink>[
            DocsLink(label: 'Button', route: '/components/button'),
            DocsLink(label: 'Icon', route: '/components/icon'),
            DocsLink(label: 'Message', route: '/components/message'),
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
        'The viewport reads theme.border for its scrollbar thumb (and '
            'transparent while autoscrolling) — the one colour '
            'message_scroller.dart resolves directly.',
        "MessageScrollerButton composes Button with an explicit "
            'ButtonStyleRecipe — fill: theme.background, hoverFill: '
            'theme.muted, border: theme.border, ink/hoverInk: '
            'theme.foreground — five overrides on top of the secondary '
            'variant, rather than a bespoke variant of its own.',
        'The bottom fade is a stencil mask (opaque black to transparent), '
            'not a themed colour: it reveals whatever is already painted '
            'beneath it rather than tinting it.',
        'No override field on MessageScroller/MessageScrollerViewport '
            'itself: restyle the button through its own surface, or the '
            'items inside through whatever they compose (an Message, an '
            'Bubble).',
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
