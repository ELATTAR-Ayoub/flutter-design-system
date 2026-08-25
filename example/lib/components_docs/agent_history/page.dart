/// Public documentation page for the `agent-history` component.
///
/// Written from nothing: no page existed for this registry item before
/// this file. Read end to end from `lib/src/components/agent_history.dart`
/// (1911 lines, three reference files folded into one) and from
/// `test/agent_history_test.dart`.
///
/// **THE FLIP IS DEAD, AND THAT IS WHAT A READER SEES.** The source's own
/// library note, quoted rather than paraphrased: `ElFlipController` ports
/// `use-flip.ts` correctly — it measures before a reorder, inverts with a
/// transform, and releases on a curve — and none of it reaches the screen,
/// because every card also carries `ElRowMotion`'s own entrance animation,
/// whose `animation-fill-mode: both` outranks the inversion. Pinning a row
/// teleports it and replays the entrance on the one neighbour the
/// reconciliation displaces. The live specimen in Preview reproduces this
/// exactly: pin a row and watch it jump, not glide.
///
/// **Every live specimen owns a small store built for this page**,
/// implementing `ElConversationStore` — the same abstract interface a real
/// product implements — rather than importing one: this page's own
/// dependency closure stops at the registry manifest's `registryDependencies`,
/// and a store is product code, not a registry item.
///
/// **`ElChatHistory`'s drawer opens over a plain placeholder**, not a real
/// console: the console family (`agent-core`, `agent-console`,
/// `agent-transcript`, `agent-composer`) is a separate, not-yet-documented
/// part of this registry, and this page does not claim to show it.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import 'meta.dart';

final ComponentDocSpec agentHistoryDocSpec = ComponentDocSpec(
  name: 'agent-history',
  title: agentHistoryDoc.title,
  description: agentHistoryDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'The full list, live: pinned conversations above the rest, '
          'newest first within each group. Rename a title, delete a row, '
          'pin one and watch the list reorder — nothing here resets '
          'between interactions.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: el(96),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'agent-history has a real registry manifest: `elattar add '
          'agent-history` installs lib/src/components/agent_history.dart '
          'and resolves all seventeen registryDependencies automatically. '
          'The Manual tab is for a project not using the CLI.',
      command: agentHistoryDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/agent_history.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/agent_history.dart's generated "
              '@ui/agent_history.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated agent_history source here when using '
              'manual mode.',
        ),
        DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ElHistoryCard, ElHistorySearch, '
              'ElChatHistory and their supporting classes are reachable '
              'the same way the CLI path already makes them.',
          code: "export 'agent_history.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct import and construction: one card, wired '
          'to callbacks a real store would provide.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'rename',
      title: 'Rename',
      description:
          'Renaming moves nothing: the icon, the timestamp, the preview '
          'and the card\'s own box hold their exact positions — only the '
          'title swaps for an input on the same baseline, at the same '
          'height (titleHeight). Two shapes ship: inline (Enter commits, '
          'Escape abandons, blur commits) and dialog, chosen per card.',
      specimen: _RenameSpecimen(),
      code: _renameCode,
      label: 'Rename specimen view',
    ),
    ShowcaseSection(
      id: 'delete',
      title: 'Delete',
      description:
          'Two ways to ask before deleting. The inline confirm lands ON '
          'TOP of the row\'s own controls (translateX(12%) in, a plain '
          'fade out) rather than beside them, so the delete button is '
          'physically gone by the time the question is up. The dialog '
          'confirm is the system ElAlertDialog, for something genuinely '
          'costly.',
      specimen: _DeleteSpecimen(),
      code: _deleteCode,
      label: 'Delete specimen view',
    ),
    ShowcaseSection(
      id: 'pin',
      title: 'Pin',
      description:
          'A pinned card holds its pin button visible; an unpinned one '
          'reveals it on hover, so a long list is not a wall of grey '
          'icons. Pinned conversations lift above the rest — see the '
          'library note on why the lift itself is a teleport, not a '
          'glide.',
      specimen: _PinSpecimen(),
      code: _pinCode,
      label: 'Pin specimen view',
    ),
    ShowcaseSection(
      id: 'capabilities',
      title: 'Capabilities',
      description:
          'Not from props: the pin button exists because store.pin '
          'exists, and the Share menu item exists because store.share '
          'does. This is the same list as Preview, wired to a store with '
          'neither.',
      specimen: _CapabilitiesSpecimen(),
      code: _capabilitiesCode,
      label: 'Capabilities specimen view',
      minHeight: el(96),
    ),
    ShowcaseSection(
      id: 'search',
      title: 'Search',
      description:
          'A palette rather than a filter box. Opens on recent chats: '
          '"opening a search box onto nothing is a dead end." Matching '
          'runs over the title AND the preview together, which is also '
          'why shouldFilter is off — cmdk would re-score by the row\'s own '
          'rendered text and drop exactly those matches.',
      specimen: _SearchSpecimen(),
      code: _searchCode,
      label: 'Search specimen view',
    ),
    ShowcaseSection(
      id: 'drawer',
      title: 'Chat History Drawer',
      description:
          'ElChatHistory arranges the whole list behind a trigger: a '
          '384px drawer (max-w-sm) sliding in over a scrim, laid out '
          'through an OverlayPortal against surfaceKey — the console\'s '
          'own root — rather than the page\'s Overlay, so a caller with '
          'no console still gets an honest fallback: the whole Overlay.',
      specimen: _DrawerSpecimen(),
      code: _drawerCode,
      label: 'Chat History Drawer specimen view',
      minHeight: el(96),
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'The three real widgets in full — ElHistoryCard, '
          'ElHistorySearch, ElChatHistory — the two enums that shape a '
          'card, and the shared motion machinery underneath all three.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'ElHistoryCard', anchor: 'api-elhistorycard'),
        DocsTocEntry(
          title: 'ElHistorySearch',
          anchor: 'api-elhistorysearch',
        ),
        DocsTocEntry(title: 'ElChatHistory', anchor: 'api-elchathistory'),
        DocsTocEntry(title: 'Enums', anchor: 'api-enums'),
        DocsTocEntry(title: 'ElRowMotion', anchor: 'api-elrowmotion'),
        DocsTocEntry(title: 'ElBlurSwitch', anchor: 'api-elblurswitch'),
        DocsTocEntry(
          title: 'ElFlipController',
          anchor: 'api-elflipcontroller',
        ),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Read off _ElHistoryCardState and the library note directly, '
          'not inferred.',
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
            value: agentHistoryDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/agent_history_test.dart',
            description: "The package's own coverage of the whole family.",
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/agent_history_test.dart',
            description:
                'Covers this page: the article mounts, the API tables '
                'for ElHistoryCard, ElHistorySearch and ElChatHistory '
                'this page claims to document, and both themes at two '
                'viewport widths.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/agent_history/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class AgentHistoryDocPage extends StatelessWidget {
  const AgentHistoryDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: agentHistoryDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / AGENT',
      title: agentHistoryDoc.title,
      description: agentHistoryDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Agent History'),
    ],
    toc: agentHistoryDocSpec.toc,
    previous: null,
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('agent-history-doc-article'),
      child: ComponentDocPage(spec: agentHistoryDocSpec, header: false),
    ),
  );
}

/* ── A store built for this page ────────────────────────────────────────── */

/// A conversation store with nothing behind it, implementing the whole
/// [ElConversationStore] interface a real product would — including the
/// two optional capabilities, so [_CapabilitiesSpecimen] can show the list
/// both with and without them. Timestamps are offsets from [now] rather
/// than fixed strings, because relativeTime renders "3 hours ago" against
/// the clock and a fixed ISO string would quietly rot.
class _DocStore extends ElConversationStore {
  _DocStore({required DateTime now, this.capabilities = true})
    : _conversations = _seed(now);

  final bool capabilities;

  static DateTime _ago(int minutes, DateTime from) =>
      from.subtract(Duration(minutes: minutes));

  static List<ElConversationSummary> _seed(DateTime now) =>
      <ElConversationSummary>[
        ElConversationSummary(
          id: 'c-vault',
          title: 'Sealed inventory check',
          updatedAt: _ago(14, now),
          preview: 'What sealed boxes are left, and what is the best one?',
          pinned: true,
        ),
        ElConversationSummary(
          id: 'c-export',
          title: 'Thirty-day activity export',
          updatedAt: _ago(95, now),
          preview: 'Export my last 30 days as a CSV',
        ),
        ElConversationSummary(
          id: 'c-pricing',
          title: 'Pricing service outage',
          updatedAt: _ago(260, now),
          preview: 'What is Eclipse Vault worth right now?',
        ),
        ElConversationSummary(
          id: 'c-odds',
          title: 'How pack odds actually work',
          updatedAt: _ago(4300, now),
          preview: 'Explain the odds on a sealed box',
        ),
      ];

  List<ElConversationSummary> _conversations;
  String? _activeId = 'c-vault';

  @override
  List<ElConversationSummary> get conversations =>
      List<ElConversationSummary>.unmodifiable(_conversations);

  @override
  String? get activeId => _activeId;

  @override
  bool get isLoading => false;

  @override
  String? get error => null;

  @override
  void open(String id) {
    if (_activeId == id) return;
    _activeId = id;
    notifyListeners();
  }

  @override
  void create() {
    _activeId = null;
    notifyListeners();
  }

  @override
  void rename(String id, String title) {
    _conversations = <ElConversationSummary>[
      for (final ElConversationSummary c in _conversations)
        if (c.id == id) c.copyWith(title: title) else c,
    ];
    notifyListeners();
  }

  @override
  void remove(String id) {
    _conversations = _conversations
        .where((ElConversationSummary c) => c.id != id)
        .toList();
    if (_activeId == id) _activeId = null;
    notifyListeners();
  }

  @override
  void refresh() {}

  @override
  void Function(String id, bool pinned)? get pin => capabilities ? _pin : null;

  void _pin(String id, bool pinned) {
    _conversations = <ElConversationSummary>[
      for (final ElConversationSummary c in _conversations)
        if (c.id == id) c.copyWith(pinned: pinned) else c,
    ];
    notifyListeners();
  }

  @override
  void Function(String id)? get share => capabilities ? _share : null;

  void _share(String id) {
    // A real store would mint a link or export a transcript; the
    // interface only says the product has one.
  }
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

/// The live list: [_DocStore] plus [ElFlipController], sorted pinned-first
/// then newest, exactly the order [ElChatHistory]'s own drawer uses.
class _ListSpecimen extends StatefulWidget {
  const _ListSpecimen({this.capabilities = true});

  final bool capabilities;

  @override
  State<_ListSpecimen> createState() => _ListSpecimenState();
}

class _ListSpecimenState extends State<_ListSpecimen> {
  _DocStore? _store;
  final ElFlipController _flip = ElFlipController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _store ??= _DocStore(
      now: ElClock.nowOf(context),
      capabilities: widget.capabilities,
    );
  }

  @override
  void dispose() {
    _flip.dispose();
    _store?.dispose();
    super.dispose();
  }

  void Function(String, bool)? get _pin {
    final void Function(String, bool)? pin = _store!.pin;
    if (pin == null) return null;
    return (String id, bool pinned) {
      _flip.measure();
      pin(id, pinned);
    };
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _store!,
    builder: (BuildContext context, Widget? _) {
      final _DocStore store = _store!;
      final List<ElConversationSummary> ordered =
          List<ElConversationSummary>.of(store.conversations)
            ..sort((ElConversationSummary a, ElConversationSummary b) {
              if (a.pinned != b.pinned) return a.pinned ? -1 : 1;
              return b.updatedAt.compareTo(a.updatedAt);
            });
      _flip.reconcile(<String>[
        for (final ElConversationSummary c in ordered) c.id,
      ]);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (final ElConversationSummary c in ordered) ...<Widget>[
            ElHistoryCard(
              key: _flip.keyFor(c.id),
              conversation: c,
              active: c.id == store.activeId,
              entranceGeneration: _flip.generationOf(c.id),
              onOpen: store.open,
              onRename: store.rename,
              onRemove: store.remove,
              onPin: _pin,
              onShare: store.share,
            ),
            SizedBox(height: el(1)),
          ],
        ],
      );
    },
  );
}

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) => const _ListSpecimen();
}

const String _previewCode =
    '''
import 'package:elattar_design_system/elattar_design_system.dart';

// A store implements ElConversationStore; the list sorts pinned-first
// then newest and wires each card to it.
for (final conversation in store.conversations)
  ElHistoryCard(
    conversation: conversation,
    onOpen: store.open,
    onRename: store.rename,
    onRemove: store.remove,
    onPin: store.pin,
    onShare: store.share,
  )''';

const String _usageCode =
    '''
import 'package:elattar_design_system/elattar_design_system.dart';

ElHistoryCard(
  conversation: ElConversationSummary(
    id: 'c-1',
    title: 'Sealed inventory check',
    updatedAt: DateTime.now(),
  ),
  onOpen: (id) {},
  onRename: (id, title) {},
  onRemove: (id) {},
)''';

/// One card over a fixed [ElConversationSummary], its title, pin, and
/// presence held in local state so a reader can actually rename, pin, and
/// delete it.
class _CardSpecimen extends StatefulWidget {
  const _CardSpecimen({
    required this.keyValue,
    this.confirm = ElHistoryConfirm.inline,
    this.rename = ElHistoryRename.inline,
    this.pinned = false,
    this.active = false,
  });

  final String keyValue;
  final ElHistoryConfirm confirm;
  final ElHistoryRename rename;
  final bool pinned;
  final bool active;

  /// `Date.now() - 14 minutes`, pinned at build rather than re-derived.
  static const Duration age = Duration(minutes: 14);

  @override
  State<_CardSpecimen> createState() => _CardSpecimenState();
}

class _CardSpecimenState extends State<_CardSpecimen> {
  String _title = 'Sealed inventory check';
  late bool _pinned = widget.pinned;
  bool _gone = false;
  DateTime? _updatedAt;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updatedAt ??= ElClock.nowOf(context).subtract(_CardSpecimen.age);
  }

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    if (_gone) {
      return Container(
        key: ValueKey<String>(widget.keyValue),
        padding: EdgeInsets.all(el(3)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ElRadii.lg),
          border: Border.all(color: theme.border, width: ElWidths.hairline),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: ElText(
                'Deleted.',
                ElType.caption,
                color: theme.mutedForeground,
              ),
            ),
            SizedBox(width: el(3)),
            ElButton(
              size: ElButtonSize.sm,
              variant: ElButtonVariant.outline,
              onPressed: () => setState(() => _gone = false),
              child: const Text('Put it back'),
            ),
          ],
        ),
      );
    }
    return ElHistoryCard(
      key: ValueKey<String>(widget.keyValue),
      conversation: ElConversationSummary(
        id: 'spec-card',
        title: _title,
        updatedAt: _updatedAt!,
        preview: 'What sealed boxes are left, and what is the best one?',
        pinned: _pinned,
      ),
      active: widget.active,
      confirm: widget.confirm,
      rename: widget.rename,
      onOpen: (_) {},
      onRename: (_, String next) => setState(() => _title = next),
      onRemove: (_) => setState(() => _gone = true),
      onPin: (_, bool next) => setState(() => _pinned = next),
      onShare: (_) {},
    );
  }
}

class _RenameSpecimen extends StatelessWidget {
  const _RenameSpecimen();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const _CardSpecimen(
        keyValue: 'agent-history-example:rename-inline',
        rename: ElHistoryRename.inline,
      ),
      SizedBox(height: el(4)),
      const _CardSpecimen(
        keyValue: 'agent-history-example:rename-dialog',
        rename: ElHistoryRename.dialog,
      ),
    ],
  );
}

const String _renameCode =
    '''
ElHistoryCard(
  conversation: conversation,
  rename: ElHistoryRename.inline, // or ElHistoryRename.dialog
  onOpen: (id) {},
  onRename: (id, title) {},
  onRemove: (id) {},
)''';

class _DeleteSpecimen extends StatelessWidget {
  const _DeleteSpecimen();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const _CardSpecimen(
        keyValue: 'agent-history-example:delete-inline',
        confirm: ElHistoryConfirm.inline,
      ),
      SizedBox(height: el(4)),
      const _CardSpecimen(
        keyValue: 'agent-history-example:delete-dialog',
        confirm: ElHistoryConfirm.dialog,
      ),
    ],
  );
}

const String _deleteCode =
    '''
ElHistoryCard(
  conversation: conversation,
  confirm: ElHistoryConfirm.inline, // or ElHistoryConfirm.dialog
  onOpen: (id) {},
  onRename: (id, title) {},
  onRemove: (id) {},
)''';

class _PinSpecimen extends StatelessWidget {
  const _PinSpecimen();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const _CardSpecimen(
        keyValue: 'agent-history-example:pin-pinned',
        pinned: true,
      ),
      SizedBox(height: el(4)),
      const _CardSpecimen(
        keyValue: 'agent-history-example:pin-active',
        active: true,
      ),
    ],
  );
}

const String _pinCode =
    '''
ElHistoryCard(
  conversation: conversation, // conversation.pinned: true
  onOpen: (id) {},
  onRename: (id, title) {},
  onRemove: (id) {},
  onPin: (id, pinned) {},
)''';

class _CapabilitiesSpecimen extends StatelessWidget {
  const _CapabilitiesSpecimen();

  @override
  Widget build(BuildContext context) =>
      const _ListSpecimen(capabilities: false);
}

const String _capabilitiesCode =
    '''
// A store whose pin and share getters both return null: no pin button
// and no Share menu item are drawn, on any card.
class NoCapabilitiesStore extends ElConversationStore {
  @override
  void Function(String, bool)? get pin => null;
  @override
  void Function(String)? get share => null;
  // ...
}''';

/// `DateTime.fromMillisecondsSinceEpoch` is not a `const` constructor, so
/// this list — unlike the rest of this page's specimen data — is `final`
/// rather than `const`. The Search specimen never renders `updatedAt` (it
/// sorts by it, and every entry here ties), so a fixed instant is honest:
/// nothing about this specimen depends on when the page happens to build.
final List<ElConversationSummary> _searchSeed = <ElConversationSummary>[
  ElConversationSummary(
    id: 's-vault',
    title: 'Sealed inventory check',
    updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
    preview: 'What sealed boxes are left, and what is the best one?',
    pinned: true,
  ),
  ElConversationSummary(
    id: 's-export',
    title: 'Thirty-day activity export',
    updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
    preview: 'Export my last 30 days as a CSV',
  ),
  ElConversationSummary(
    id: 's-odds',
    title: 'How pack odds actually work',
    updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
    preview: 'Explain the odds on a sealed box',
  ),
  ElConversationSummary(
    id: 's-balance',
    title: 'Balance and recent movement',
    updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
    preview: 'How much do I have available?',
  ),
];

class _SearchSpecimen extends StatefulWidget {
  const _SearchSpecimen();

  @override
  State<_SearchSpecimen> createState() => _SearchSpecimenState();
}

class _SearchSpecimenState extends State<_SearchSpecimen> {
  bool _open = false;
  String _query = '';
  String? _opened;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ElButton(
            key: const ValueKey<String>('agent-history-search-trigger'),
            variant: ElButtonVariant.outline,
            onPressed: () => setState(() => _open = true),
            child: const Text('Search conversations'),
          ),
          SizedBox(height: el(3)),
          ElText(
            _opened == null ? 'Nothing opened yet.' : 'Opened: $_opened',
            ElType.caption,
            color: theme.mutedForeground,
          ),
          ElHistorySearch(
            key: const ValueKey<String>('agent-history-search'),
            conversations: _searchSeed,
            open: _open,
            onOpenChange: (bool v) => setState(() => _open = v),
            onOpen: (String id) => setState(() => _opened = id),
            query: _query,
            onQueryChange: (String v) => setState(() => _query = v),
          ),
        ],
      ),
    );
  }
}

const String _searchCode =
    '''
ElHistorySearch(
  conversations: conversations,
  open: open,
  onOpenChange: (v) => setState(() => open = v),
  onOpen: (id) => store.open(id),
  query: query,
  onQueryChange: (v) => setState(() => query = v),
)''';

class _DrawerSpecimen extends StatefulWidget {
  const _DrawerSpecimen();

  @override
  State<_DrawerSpecimen> createState() => _DrawerSpecimenState();
}

class _DrawerSpecimenState extends State<_DrawerSpecimen> {
  final GlobalKey _surface = GlobalKey();
  _DocStore? _store;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _store ??= _DocStore(now: ElClock.nowOf(context));
  }

  @override
  void dispose() {
    _store?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Container(
      key: _surface,
      height: el(64),
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.background,
        borderRadius: BorderRadius.circular(ElRadii.lg),
        border: Border.all(color: theme.border, width: ElWidths.hairline),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            top: 0,
            child: Padding(
              padding: EdgeInsets.all(el(3)),
              child: ElChatHistory(
                key: const ValueKey<String>('agent-history-drawer'),
                store: _store!,
                surfaceKey: _surface,
              ),
            ),
          ),
          Center(
            child: ElText(
              'the console\'s own surface',
              ElType.caption,
              color: theme.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

const String _drawerCode =
    '''
Container(
  key: surfaceKey,
  child: ElChatHistory(store: store, surfaceKey: surfaceKey),
)''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elhistorycard',
        child: DocsApiTable(title: 'ElHistoryCard', facts: _historyCardFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elhistorysearch',
        child: DocsApiTable(
          title: 'ElHistorySearch',
          facts: _historySearchFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elchathistory',
        child: DocsApiTable(title: 'ElChatHistory', facts: _chatHistoryFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-enums',
        child: DocsApiTable(title: 'Enums', facts: _enumFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elrowmotion',
        child: DocsApiTable(title: 'ElRowMotion', facts: _rowMotionFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elblurswitch',
        child: DocsApiTable(title: 'ElBlurSwitch', facts: _blurSwitchFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elflipcontroller',
        child: DocsApiTable(
          title: 'ElFlipController',
          facts: _flipControllerFacts,
        ),
      ),
    ],
  );
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'ElHistoryCard is built on ElItem, not beside it: the row\'s '
            'border, radius, padding, gap, and colour transition are all '
            "ElItem's own — including whatever Semantics ElItem itself "
            'contributes.',
        'The pin and menu-trigger buttons are ordinary ElButton instances '
            '(ghost, icon-sm): each carries its own accessible name '
            '(Pin/Unpin, and the menu\'s own trigger label), independent '
            'of the card\'s title.',
        'The inline confirm is role="alertdialog" in the reference; the '
            'port renders it as a plain row with a destructive-tinted '
            'border rather than a Flutter Semantics.namesRoute region — '
            'the confirmation text and the two buttons are still real '
            'Semantics nodes, but nothing marks the group as an alert.',
        'The dialog confirm is the system ElAlertDialog, which carries '
            'its own accessibility contract in full — see that '
            "component's own page.",
        'ElHistorySearch is built on ElCommand: type-ahead filtering, '
            'arrow-key row traversal, and Enter-to-choose are all '
            "ElCommand's own.",
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Inline rename: Enter commits (a blank draft is discarded, same '
            'as blur), Escape abandons and restores the original title, '
            'blur commits.',
        'Inline confirm: no bespoke key handling in agent_history.dart '
            'itself — the Cancel and Delete buttons are ordinary '
            'ElButtons, focusable and activated by Enter/Space like any '
            'other.',
        'ElHistorySearch inherits ElCommand\'s own keyboard model: arrow '
            'keys move the highlighted row, Enter chooses it, and typing '
            'filters — none of that is agent_history.dart\'s own code.',
        'agent_history.dart wires no FocusTraversalPolicy of its own '
            'anywhere in the file: Tab and Shift+Tab walk whatever order '
            'the surrounding page already declares.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No breakpoint branching anywhere in agent_history.dart: '
            'BuildContext width is never read for a layout decision.',
        'ElChatHistory.width is a fixed el(96) = 384px (max-w-sm) '
            'regardless of viewport; on a narrow phone the drawer can '
            'exceed the screen width, which is the same trade-off '
            "ElDrawer's own full-bleed panels make.",
        'A long title is not truncated specially in the rename input; '
            'the resting ItemTitle uses whatever overflow behaviour '
            'ElText already applies.',
        'Platform parity: Android, iOS, Web, macOS, Windows, and Linux '
            'all render the same widget tree; no dart:io Platform branch '
            'anywhere in the file.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ElTheme.of(context), <String>[
        'File: lib/src/components/agent_history.dart — one file, no '
            'companions; the registry manifest lists exactly one entry '
            'under "files".',
        'registryDependencies, resolved automatically by `elattar add '
            'agent-history`: agent-core, alert, alert-dialog, button, '
            'command, dialog, dropdown-menu, empty, field, icon, input, '
            'item, machine-surface, menu, popover, source-foundation, '
            'spinner — seventeen items, copied verbatim from '
            'registry/components/agent-history.json. alert-dialog backs '
            'the dialog confirm shape; command backs ElHistorySearch; '
            'dropdown-menu backs the card\'s own menu trigger; item is '
            'the row ElHistoryCard is built on; field and input back the '
            'inline rename control; spinner covers a loading store\'s own '
            'affordance (not shown live on this page — this port\'s mock '
            'store never reports isLoading: true).',
        'semanticDependencies (the manifest\'s own, narrower field): the '
            'same seventeen minus popover and source-foundation — a hint '
            'at what this component is commonly composed WITH, not a '
            'second import list.',
      ]),
      SizedBox(height: el(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Alert', route: '/components/alert'),
          DocsLink(label: 'Alert Dialog', route: '/components/alert-dialog'),
          DocsLink(label: 'Button', route: '/components/button'),
          DocsLink(label: 'Command', route: '/components/command'),
          DocsLink(label: 'Dialog', route: '/components/dialog'),
          DocsLink(
            label: 'Dropdown Menu',
            route: '/components/dropdown-menu',
          ),
          DocsLink(label: 'Empty', route: '/components/empty'),
          DocsLink(label: 'Field', route: '/components/field'),
          DocsLink(label: 'Icon', route: '/components/icon'),
          DocsLink(label: 'Input', route: '/components/input'),
          DocsLink(label: 'Item', route: '/components/item'),
          DocsLink(label: 'Popover', route: '/components/popover'),
          DocsLink(label: 'Spinner', route: '/components/spinner'),
        ],
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Every colour is read live off ElTheme.of(context) at build '
            'time, mostly through the components this file composes '
            '(ElItem, ElButton, ElAlertDialog, ElCommand) rather than '
            'painted directly here.',
        'The one bespoke colour is the inline destructive confirm\'s '
            'border: theme.destructive at confirmBorderAlpha (0.50), on '
            'an opaque theme.card fill — a tint rather than a solid, the '
            'same reasoning ElButton\'s own destructive variant states on '
            "its own page.",
        'ElRowMotion and ElBlurSwitch paint no colour at all: both are '
            'pure geometry and opacity transforms over whatever child '
            'they wrap.',
      ]);
}

Widget _bullets(ElThemeData theme, List<String> lines) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    for (final String line in lines) ...<Widget>[
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: ElWidths.prose),
        child: ElText('•  $line', ElType.small, color: theme.mutedForeground),
      ),
      SizedBox(height: el(2)),
    ],
  ],
);

const List<DocsApiFact> _historyCardFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'conversation',
    type: 'ElConversationSummary',
    description: 'Required. The row this card renders.',
  ),
  DocsApiFact(
    name: 'active',
    type: 'bool',
    description:
        'Defaults to false. Marks the conversation the console is '
        "showing, by the card's own glyph rather than a tinted surface.",
  ),
  DocsApiFact(
    name: 'confirm',
    type: 'ElHistoryConfirm',
    description: 'Defaults to inline.',
  ),
  DocsApiFact(
    name: 'rename',
    type: 'ElHistoryRename',
    description: 'Defaults to inline.',
  ),
  DocsApiFact(
    name: 'onOpen',
    type: 'void Function(String id)',
    description: 'Required.',
  ),
  DocsApiFact(
    name: 'onRename',
    type: 'void Function(String id, String title)',
    description: 'Required.',
  ),
  DocsApiFact(
    name: 'onRemove',
    type: 'void Function(String id)',
    description: 'Required.',
  ),
  DocsApiFact(
    name: 'onPin',
    type: 'void Function(String id, bool pinned)?',
    description: 'Null omits the pin button and the pinned section entirely.',
  ),
  DocsApiFact(
    name: 'onShare',
    type: 'void Function(String id)?',
    description: 'Null omits the Share menu item.',
  ),
  DocsApiFact(
    name: 'leaving',
    type: 'bool',
    description: 'Defaults to false. Set while this row plays its exit.',
  ),
  DocsApiFact(
    name: 'entranceGeneration',
    type: 'int',
    description:
        'Defaults to 0. Bump it (ElFlipController.generationOf) to '
        'replay the entrance animation.',
  ),
  DocsApiFact(
    name: 'confirmExit',
    type: 'static Duration get',
    description: 'ElDurations.tick.',
  ),
  DocsApiFact(
    name: 'rowExit',
    type: 'static Duration get',
    description: 'ElDurations.base.',
  ),
  DocsApiFact(
    name: 'titleHeight',
    type: 'static double get',
    description: 'el(6) — the title/input\'s shared height.',
  ),
  DocsApiFact(
    name: 'confirmShift',
    type: 'static const double',
    description: '0.12 — the inline confirm\'s own entrance travel.',
  ),
  DocsApiFact(
    name: 'confirmBorderAlpha',
    type: 'static const double',
    description: '0.50.',
  ),
];

const List<DocsApiFact> _historySearchFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'conversations',
    type: 'List<ElConversationSummary>',
    description: 'Required.',
  ),
  DocsApiFact(
    name: 'open',
    type: 'bool',
    description: 'Required. Controlled.',
  ),
  DocsApiFact(
    name: 'onOpenChange',
    type: 'ValueChanged<bool>',
    description: 'Required.',
  ),
  DocsApiFact(
    name: 'onOpen',
    type: 'void Function(String id)',
    description: 'Required.',
  ),
  DocsApiFact(
    name: 'query',
    type: 'String',
    description: 'Required. Controlled.',
  ),
  DocsApiFact(
    name: 'onQueryChange',
    type: 'ValueChanged<String>',
    description: 'Required.',
  ),
  DocsApiFact(
    name: 'recent',
    type: 'static const int',
    description: '6 — how many recent conversations stand in for a query.',
  ),
  DocsApiFact(
    name: 'topFraction',
    type: 'static const double',
    description: '1/3 — the palette rests a third of the way down.',
  ),
  DocsApiFact(
    name: 'matchHeading',
    type: 'static String Function(int n)',
    description: '"n match(es)".',
  ),
  DocsApiFact(
    name: 'partition',
    type:
        'static ({pinned, recent, results}) Function(conversations, query)',
    description:
        'The two-key order every list here shares: pinned first, then '
        'newest.',
  ),
];

const List<DocsApiFact> _chatHistoryFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'store',
    type: 'ElConversationStore',
    description: 'Required.',
  ),
  DocsApiFact(
    name: 'title',
    type: 'String',
    description: "Defaults to 'Conversations'.",
  ),
  DocsApiFact(
    name: 'nav',
    type: 'List<Widget>?',
    description:
        'Extra rows under New chat and above the conversations. A slot, '
        "not a fixed list — what belongs there is the product's own "
        'business.',
  ),
  DocsApiFact(
    name: 'onOpenConversation',
    type: 'void Function(String id)?',
    description: 'Null defaults to store.open.',
  ),
  DocsApiFact(
    name: 'surfaceKey',
    type: 'GlobalKey?',
    description:
        "The box the drawer and scrim are laid over — the console's own "
        'root. Null falls back to the whole Overlay.',
  ),
  DocsApiFact(
    name: 'width',
    type: 'static double get',
    description: 'ElContainers.sm = 384px (max-w-sm).',
  ),
  DocsApiFact(
    name: 'exit',
    type: 'static Duration get',
    description: 'ElDurations.base.',
  ),
  DocsApiFact(
    name: 'panelIn',
    type: 'static Duration get',
    description: 'ElDurations.overlay.',
  ),
];

const List<DocsApiFact> _enumFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ElHistoryConfirm.inline',
    type: 'enum value',
    description: 'The default: the confirmation lands inside the row.',
  ),
  DocsApiFact(
    name: 'ElHistoryConfirm.dialog',
    type: 'enum value',
    description: 'The system ElAlertDialog.',
  ),
  DocsApiFact(
    name: 'ElHistoryRename.inline',
    type: 'enum value',
    description: 'The default: an input on the title\'s own baseline.',
  ),
  DocsApiFact(
    name: 'ElHistoryRename.dialog',
    type: 'enum value',
    description: 'A dedicated rename dialog.',
  ),
];

const List<DocsApiFact> _rowMotionFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description: 'Required.',
  ),
  DocsApiFact(
    name: 'generation',
    type: 'int',
    description: 'Defaults to 0. Bumped to replay the entrance.',
  ),
  DocsApiFact(
    name: 'leaving',
    type: 'bool',
    description: 'Defaults to false.',
  ),
  DocsApiFact(
    name: 'enterShift',
    type: 'static const double',
    description: '-10 — the entrance\'s own translateX.',
  ),
  DocsApiFact(
    name: 'exitShift',
    type: 'static const double',
    description: '-24 — the exit\'s slide, at its 45% stop.',
  ),
  DocsApiFact(
    name: 'exitBreak',
    type: 'static const double',
    description:
        '0.45 — where the exit hands over from the slide to the height '
        'collapse.',
  ),
  DocsApiFact(
    name: 'enterSpan',
    type: 'static Duration get',
    description: 'ElDurations.tick + ElDurations.base.',
  ),
  DocsApiFact(
    name: 'enterDelayFraction',
    type: 'static double get',
    description: 'Where the delay ends inside enterSpan.',
  ),
  DocsApiFact(
    name: 'enterCurve',
    type: 'static Curve get',
    description: 'A hold, then ElCurves.out.',
  ),
];

const List<DocsApiFact> _blurSwitchFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'phase',
    type: 'ElSwitchPhase',
    description:
        'Required. idle / out / blurIn — agent-core\'s own enum, driving '
        'this widget rather than declared by it.',
  ),
  DocsApiFact(name: 'child', type: 'Widget', description: 'Required.'),
  DocsApiFact(
    name: 'outRadius',
    type: 'static const double',
    description: '6 — the blur radius pulls-blur-out ends at (CSS px).',
  ),
  DocsApiFact(
    name: 'inRadius',
    type: 'static const double',
    description: '8 — the blur radius pulls-blur-in starts at (CSS px).',
  ),
];

const List<DocsApiFact> _flipControllerFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'duration',
    type: 'Duration',
    description: 'Defaults to ElDurations.base. Not currently painted.',
  ),
  DocsApiFact(
    name: 'keyFor',
    type: 'GlobalKey Function(String id)',
    description: 'Attach to every row that can move.',
  ),
  DocsApiFact(
    name: 'travel',
    type: 'Map<String, Offset> get',
    description:
        'The inversion the last measure() produced, per row — computed '
        'and never painted; public so a test can assert it.',
  ),
  DocsApiFact(
    name: 'generationOf',
    type: 'int Function(String id)',
    description: 'How many times this row\'s entrance has been replayed.',
  ),
  DocsApiFact(
    name: 'measure',
    type: 'void Function()',
    description: 'Call immediately BEFORE the state change that reorders.',
  ),
  DocsApiFact(
    name: 'reconcile',
    type: 'void Function(List<String> order)',
    description:
        'Call from the list\'s own build with the order about to paint.',
  ),
  DocsApiFact(
    name: 'minimumTravel',
    type: 'static const double',
    description: '1 — sub-pixel drift is not movement.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'rest, unpinned',
    treatment: 'pin button opacity: 0',
    userSignal: 'No pin affordance visible until hovered.',
  ),
  DocsStateFact(
    state: 'hover, unpinned',
    treatment: 'pin and menu-trigger buttons fade to opacity: 1',
    userSignal: 'Both affordances appear.',
  ),
  DocsStateFact(
    state: 'pinned',
    treatment: 'pin button holds opacity: 1 regardless of hover',
    userSignal: 'A pinned row never hides its own pin control.',
  ),
  DocsStateFact(
    state: 'renaming (inline)',
    treatment: 'ElField/ElInput replaces the title at the same baseline',
    userSignal: 'Nothing else in the row moves.',
  ),
  DocsStateFact(
    state: 'confirming delete (inline)',
    treatment: 'the confirm slides in over the row on ElRowMotion\'s own clock',
    userSignal: 'The delete control is physically covered, not just disabled.',
  ),
  DocsStateFact(
    state: 'entering the list (new / replayed)',
    treatment: 'ElRowMotion\'s entrance: opacity + translateX(-10px) in',
    userSignal:
        'A pinned row TELEPORTS (the FLIP inversion is computed and '
        'discarded); the one row it displaces replays this entrance.',
  ),
  DocsStateFact(
    state: 'leaving the list (removed)',
    treatment: 'ElRowMotion\'s exit: slide, then height collapse',
    userSignal: 'The rows below rise into the gap in one movement.',
  ),
];
