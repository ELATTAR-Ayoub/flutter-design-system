/// Public documentation page for the `agent-core` component.
///
/// **Written from nothing**, per the rollout's per-item brief: `agent-core`
/// has no page today. Everything on it is read off
/// `lib/src/components/agent_core.dart` directly.
///
/// **Not a widget.** Every other item in this family draws something;
/// `agent_core.dart` declares none of its own — it is *"the vocabulary every
/// agent family renders"*: attachment types, the turn union, the twenty-value
/// state machine, the transport contract, and the pure functions around them.
/// The task brief for this page overrides the general "use `EffectSection`
/// for a non-widget item" guidance for this family — `agent-core` is a
/// registry `component`, not an effect — so every section below is a
/// `ShowcaseSection` whose specimen stages the vocabulary itself: the real
/// `ElAgentState.values` as chips, `elResolveAgentState` walked against ten
/// real turn lists, `elStateForTool`'s longest-prefix rule against a real
/// `ElToolStateMap`, the formatting helpers against real inputs, and
/// `elSerialiseAttachments`'s real wire output. Nothing here is invented:
/// every scenario is a real call into the real function, computed at build
/// time, not a hard-coded string standing in for one.
///
/// **Section order** follows the house shape: Preview, Installation, Usage,
/// then one `ShowcaseSection` per facet actually worth demonstrating live
/// (Resolve agent state, Tool state mapping, Formatting helpers, Serialise
/// attachments), then the eight disclosures. API Reference carries one table
/// per exported class, enum, or typedef — twenty-five of them — plus a
/// twenty-sixth for the top-level functions, each wrapped in its own
/// `DocsAnchor` with a matching rail sub-anchor.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import 'meta.dart';

final ComponentDocSpec agentCoreDocSpec = ComponentDocSpec(
  name: 'agent-core',
  title: agentCoreDoc.title,
  description: agentCoreDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'All twenty ElAgentState.values, in states.ts\'s own order, each '
          'showing its real .glyph icon and its real .label sentence — '
          'transcribed from the source, not paraphrased, including the '
          'documented drift that not one of them actually carries the '
          'ellipsis the source comment promises for an ongoing state.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: el(64),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'agent-core has a real registry manifest: elattar add agent-core '
          'installs lib/src/components/agent_core.dart and resolves icon '
          'and source-foundation automatically. The Manual tab is for a '
          'project not using the CLI.',
      command: agentCoreDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/agent_core.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/agent_core.dart's generated "
              '@ui/agent_core.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated agent_core source here when using '
              'manual mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so every type this file declares is '
              'reachable the same way the CLI path already makes them.',
          code: "export 'agent_core.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct call: resolve which of the twenty states is '
          'true right now from an empty transcript and a bare signal.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'resolve-state',
      title: 'Resolve agent state',
      description:
          'elResolveAgentState\'s own nine-branch precedence ladder, walked '
          'against ten real turn lists — the same function a live console '
          'calls every time it rebuilds. Each row below is a real call, not '
          'a claim about one.',
      specimen: _ResolveStateSpecimen(),
      code: _resolveStateCode,
      label: 'Resolve agent state specimen view',
      minHeight: el(96),
    ),
    ShowcaseSection(
      id: 'tool-mapping',
      title: 'Tool state mapping',
      description:
          'elStateForTool: an exact match first, then the longest "."- or '
          '"_"-terminated prefix that matches — so a name that fits both a '
          'blanket finance. mapping and a more specific finance.forecast. '
          'one resolves through the longer, regardless of which was '
          'declared first. An unmapped name resolves to null, and the '
          'chip falls back to elHumaniseToolName instead.',
      specimen: _ToolMappingSpecimen(),
      code: _toolMappingCode,
      label: 'Tool state mapping specimen view',
    ),
    ShowcaseSection(
      id: 'formatting',
      title: 'Formatting helpers',
      description:
          'elFormatBytes, elFormatMs, elHumaniseToolName and elRelativeTime '
          '— the small, pure functions that turn a raw byte count, a '
          'duration, a snake_case tool name, or a DateTime into the '
          'sentence a reader actually sees. elRelativeTime below is passed '
          'a fixed now: so the result is deterministic rather than a moving '
          'target.',
      specimen: _FormattingSpecimen(),
      code: _formattingCode,
      label: 'Formatting helpers specimen view',
      minHeight: el(96),
    ),
    ShowcaseSection(
      id: 'serialise-attachments',
      title: 'Serialise attachments',
      description:
          'elSerialiseAttachments folds attachments into the string that '
          'actually goes on the wire: a textual file inlines under a '
          '<file> fence, an image with a vision reading inlines under an '
          '<image> fence, and anything else — here, an image with no '
          'reading — falls into a trailing <attached-but-not-readable> '
          'block. The fences are reproduced verbatim from the reference.',
      specimen: _SerialiseSpecimen(),
      code: _serialiseCode,
      label: 'Serialise attachments specimen view',
      minHeight: el(96),
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every exported class and enum this library declares, one table '
          'each, plus a twenty-sixth table for the top-level functions. '
          'Alias typedefs (ElAgentAttachmentDelivery, ElAgentUserTurn, and '
          'the rest of the "console spelling" family the library doc '
          'names) are noted beside their canonical type rather than given a '
          'second table: they add no field of their own.',
      children: _apiChildren,
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'agent_core.dart declares no widget, so it has no hover, press, '
          'focus, disabled, or loading state of its own — DocsStateMatrix\'s '
          'State / Treatment / User signal columns describe a control\'s '
          'interaction states, and there is no control here to describe. '
          'What this file DOES have is a twenty-value state machine, which '
          'is a different thing: see the ElAgentState table in API '
          'Reference for every value, and Resolve agent state above for how '
          'elResolveAgentState picks one.',
      child: _StatesContent(),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      description:
          'agent_core.dart paints nothing and sets no Semantics node of its '
          'own — every accessible name and live region in this family '
          'belongs to the widget that renders a turn (agent-transcript\'s '
          'ElToolChip, agent-console\'s status line), documented on those '
          'pages. What this file contributes is the vocabulary those '
          'widgets read.',
      child: _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      description:
          'agent_core.dart declares no widget: it takes no focus and '
          'handles no key.',
      child: _KeyboardContent(),
    ),
    DisclosureSection(
      id: 'responsive',
      title: 'Responsive',
      description:
          'No breakpoint branching: nothing in agent_core.dart reads '
          'MediaQuery, because it draws no layout to break.',
      child: _ResponsiveContent(),
    ),
    DisclosureSection(
      id: 'dependencies',
      title: 'Dependencies',
      description:
          "Elattar's own technical-transparency panel: what this file "
          'needs to install and run, and — the other direction — which of '
          'this family\'s own pages actually import it.',
      child: _DependenciesContent(),
    ),
    DisclosureSection(
      id: 'theming',
      title: 'Theming',
      description:
          'agent_core.dart imports no theme_scope.dart and calls '
          'ElTheme.of(context) nowhere in the file.',
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
            value: agentCoreDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/agent_core_test.dart',
            description:
                'The resolver\'s nine-branch precedence, the attachment '
                'classifier and serialiser, and the formatting helpers, '
                'exercised against the real functions.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/agent_core_test.dart',
            description:
                "This page's own API-completeness, live-specimen, and "
                'theme coverage.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/agent_core/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class AgentCoreDocPage extends StatelessWidget {
  const AgentCoreDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: agentCoreDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / AGENT',
      title: agentCoreDoc.title,
      description: agentCoreDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Agent Core'),
    ],
    toc: agentCoreDocSpec.toc,
    previous: null,
    next: const DocsPageLink(
      title: 'Agent Composer',
      route: '/components/agent-composer',
    ),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('agent-core-doc-article'),
      child: ComponentDocPage(spec: agentCoreDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Wrap(
      spacing: el(2),
      runSpacing: el(2),
      children: <Widget>[
        for (final ElAgentState state in ElAgentState.values)
          Container(
            key: ValueKey<String>('agent-core-preview:${state.name}'),
            padding: EdgeInsets.symmetric(
              horizontal: el(3),
              vertical: el(1.5),
            ),
            decoration: BoxDecoration(
              color: theme.card,
              borderRadius: BorderRadius.circular(ElRadii.pill),
              border: Border.all(color: theme.border, width: ElWidths.hairline),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElIcon.lucide(
                  state.glyph,
                  sizePx: el(3.5),
                  tone: ElIconTone.muted,
                ),
                SizedBox(width: el(1.5)),
                ElText(state.label, ElType.chip, color: theme.mutedForeground),
              ],
            ),
          ),
      ],
    );
  }
}

const String _previewCode = '''for (final ElAgentState state in ElAgentState.values)
  Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      ElIcon.lucide(state.glyph, sizePx: 14, tone: ElIconTone.muted),
      const SizedBox(width: 6),
      ElText(state.label, ElType.chip),
    ],
  )''';

const String _usageCode =
    '''import 'package:elattar_design_system/elattar_design_system.dart';

final ElAgentState state = elResolveAgentState(
  turns: const <ElAgentTurn>[],
  signals: const ElAgentSignals(isLoading: true),
);
// state == ElAgentState.thinking''';

class _ResolveScenario {
  const _ResolveScenario({
    required this.label,
    required this.turns,
    this.signals = const ElAgentSignals(),
    this.toolStates,
  });

  final String label;
  final List<ElAgentTurn> turns;
  final ElAgentSignals signals;
  final ElToolStateMap? toolStates;
}

const List<_ResolveScenario> _resolveScenarios = <_ResolveScenario>[
  _ResolveScenario(label: '0. Empty conversation', turns: <ElAgentTurn>[]),
  _ResolveScenario(
    label: '6. Sent, nothing back yet',
    turns: <ElAgentTurn>[ElUserTurn(id: 'u1', text: 'Hi')],
    signals: ElAgentSignals(awaitingFirstEvent: true),
  ),
  _ResolveScenario(
    label: '7. Loading, no other signal',
    turns: <ElAgentTurn>[],
    signals: ElAgentSignals(isLoading: true),
  ),
  _ResolveScenario(
    label: '3. A tool in flight (unmapped)',
    turns: <ElAgentTurn>[
      ElToolTurn(
        id: 't1',
        name: 'search_inventory',
        params: <String, Object?>{},
        status: ElAgentTurnStatus.running,
        attempt: 1,
      ),
    ],
  ),
  _ResolveScenario(
    label: '3. The same tool, retried after a failure',
    turns: <ElAgentTurn>[
      ElToolTurn(
        id: 't1',
        name: 'search_inventory',
        params: <String, Object?>{},
        status: ElAgentTurnStatus.running,
        attempt: 2,
      ),
    ],
  ),
  _ResolveScenario(
    label: '3. A tool in flight, mapped via toolStates',
    turns: <ElAgentTurn>[
      ElToolTurn(
        id: 't1',
        name: 'search_inventory',
        params: <String, Object?>{},
        status: ElAgentTurnStatus.running,
        attempt: 1,
      ),
    ],
    toolStates: <String, ElAgentState>{
      'search_inventory': ElAgentState.searching,
    },
  ),
  _ResolveScenario(
    label: '2. An action held for approval',
    turns: <ElAgentTurn>[
      ElActionTurn(
        id: 'a1',
        action: 'purchase_pack',
        params: <String, Object?>{},
        status: ElAgentTurnStatus.running,
        approval: ElApprovalOutcome.pending,
      ),
    ],
  ),
  _ResolveScenario(
    label: '5. Prose streaming right after a tool call',
    turns: <ElAgentTurn>[
      ElUserTurn(id: 'u1', text: 'Find the file'),
      ElToolTurn(
        id: 't1',
        name: 'search_files',
        params: <String, Object?>{},
        status: ElAgentTurnStatus.ok,
        attempt: 1,
      ),
      ElTextTurn(id: 'a1', text: 'Found it.', streaming: true),
    ],
  ),
  _ResolveScenario(
    label: '5. Prose streaming with no prior work',
    turns: <ElAgentTurn>[
      ElTextTurn(id: 'a1', text: 'Thinking out loud.', streaming: true),
    ],
  ),
  _ResolveScenario(
    label: '1. A fatal error',
    turns: <ElAgentTurn>[
      ElErrorTurn(id: 'e1', message: 'The upstream timed out.', fatal: true),
    ],
  ),
  _ResolveScenario(
    label: '8. A turn finished, nothing else happening',
    turns: <ElAgentTurn>[
      ElUserTurn(id: 'u1', text: 'Thanks'),
      ElTextTurn(id: 'a1', text: 'You are welcome.', streaming: false),
    ],
  ),
];

class _ResolveStateSpecimen extends StatelessWidget {
  const _ResolveStateSpecimen();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (final _ResolveScenario scenario in _resolveScenarios)
          Padding(
            key: ValueKey<String>('agent-core-resolve:${scenario.label}'),
            padding: EdgeInsets.only(bottom: el(3)),
            child: _StatRow(
              theme: theme,
              label: scenario.label,
              value: elResolveAgentState(
                turns: scenario.turns,
                signals: scenario.signals,
                toolStates: scenario.toolStates,
              ).label,
            ),
          ),
      ],
    );
  }
}

const String _resolveStateCode = '''// Branch numbers are elResolveAgentState's own precedence order.
elResolveAgentState(
  turns: const [ElUserTurn(id: 'u1', text: 'Hi')],
  signals: const ElAgentSignals(awaitingFirstEvent: true),
).label; // 'Queued'

elResolveAgentState(
  turns: [
    ElToolTurn(
      id: 't1',
      name: 'search_inventory',
      params: const {},
      status: ElAgentTurnStatus.running,
      attempt: 2, // a retry
    ),
  ],
  signals: const ElAgentSignals(),
).label; // 'Retrying' ''';

class _ToolMappingSpecimen extends StatelessWidget {
  const _ToolMappingSpecimen();

  static const ElToolStateMap _toolStates = <String, ElAgentState>{
    'search_inventory': ElAgentState.searching,
    'finance.': ElAgentState.retrieving,
    'finance.forecast.': ElAgentState.processing,
  };

  static const List<String> _names = <String>[
    'search_inventory',
    'finance.report',
    'finance.forecast.q3',
    'export_activity',
  ];

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (final String name in _names)
          Padding(
            key: ValueKey<String>('agent-core-tool-mapping:$name'),
            padding: EdgeInsets.only(bottom: el(3)),
            child: _StatRow(
              theme: theme,
              label: name,
              value:
                  elStateForTool(name, _toolStates)?.label ??
                  '(unmapped — falls back to '
                      '"${elHumaniseToolName(name)}")',
            ),
          ),
      ],
    );
  }
}

const String _toolMappingCode = '''const ElToolStateMap toolStates = {
  'search_inventory': ElAgentState.searching,
  'finance.': ElAgentState.retrieving,
  'finance.forecast.': ElAgentState.processing, // the longer prefix
};

elStateForTool('search_inventory', toolStates);    // exact: searching
elStateForTool('finance.report', toolStates);      // prefix: retrieving
elStateForTool('finance.forecast.q3', toolStates); // longest prefix wins: processing
elStateForTool('export_activity', toolStates);     // null: unmapped''';

class _FormattingSpecimen extends StatelessWidget {
  const _FormattingSpecimen();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final DateTime now = DateTime(2026, 8, 26, 12);
    final List<(String, String)> rows = <(String, String)>[
      ('elFormatBytes(512)', elFormatBytes(512)),
      ('elFormatBytes(2048)', elFormatBytes(2048)),
      ('elFormatBytes(2621440)', elFormatBytes(2621440)),
      ('elFormatMs(320)', elFormatMs(320)),
      ('elFormatMs(8000)', elFormatMs(8000)),
      (
        "elHumaniseToolName('search_inventory')",
        elHumaniseToolName('search_inventory'),
      ),
      (
        "elHumaniseToolName('exportActivityReport')",
        elHumaniseToolName('exportActivityReport'),
      ),
      (
        'elRelativeTime(now − 1 day, now: now)',
        elRelativeTime(now.subtract(const Duration(days: 1)), now: now),
      ),
      (
        'elRelativeTime(now + 3 hours, now: now)',
        elRelativeTime(now.add(const Duration(hours: 3)), now: now),
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (final (String call, String result) in rows)
          Padding(
            key: ValueKey<String>('agent-core-formatting:$call'),
            padding: EdgeInsets.only(bottom: el(3)),
            child: _StatRow(theme: theme, label: call, value: result),
          ),
      ],
    );
  }
}

/// A label above its computed value, stacked rather than side by side so
/// neither ever overflows a narrow stage — every showcase specimen on this
/// page that pairs a real call with its real output uses this.
class _StatRow extends StatelessWidget {
  const _StatRow({required this.theme, required this.label, required this.value});

  final ElThemeData theme;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      ElText(label, ElType.code, color: theme.foreground),
      SizedBox(height: el(1)),
      ElText(value, ElType.small, color: theme.mutedForeground),
    ],
  );
}

const String _formattingCode = '''elFormatBytes(512);      // '512 B'
elFormatBytes(2048);     // '2 KB'
elFormatBytes(2621440);  // '2.5 MB'
elFormatMs(320);         // '320ms'
elFormatMs(8000);        // '8.0s'
elHumaniseToolName('search_inventory');     // 'Search inventory'
elHumaniseToolName('exportActivityReport'); // 'Export activity report'
elRelativeTime(then, now: now);             // 'yesterday', 'in 3 hours', …''';

const List<ElAgentAttachment> _sampleAttachments = <ElAgentAttachment>[
  ElAgentAttachment(
    id: 'f1',
    name: 'notes.md',
    mime: 'text/markdown',
    kind: ElAgentAttachmentKind.other,
    size: 42,
    text: '# Notes\n- remember the demo',
  ),
  ElAgentAttachment(
    id: 'f2',
    name: 'diagram.png',
    mime: 'image/png',
    kind: ElAgentAttachmentKind.image,
    size: 20480,
  ),
];

class _SerialiseSpecimen extends StatelessWidget {
  const _SerialiseSpecimen();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final ElSerialisedMessage message = elSerialiseAttachments(
      'Here is what I found.',
      _sampleAttachments,
    );
    return Container(
      key: const ValueKey<String>('agent-core-serialise-output'),
      width: double.infinity,
      padding: EdgeInsets.all(el(3)),
      decoration: BoxDecoration(
        color: theme.muted.withValues(alpha: 0.40),
        borderRadius: BorderRadius.circular(ElRadii.md),
        border: Border.all(color: theme.border, width: ElWidths.hairline),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ElText(
          message.text,
          ElType.code,
          color: theme.mutedForeground,
          softWrap: false,
        ),
      ),
    );
  }
}

const String _serialiseCode = '''final attachments = [
  ElAgentAttachment(
    id: 'f1', name: 'notes.md', mime: 'text/markdown',
    kind: ElAgentAttachmentKind.other, size: 42,
    text: '# Notes\\n- remember the demo',
  ),
  ElAgentAttachment(
    id: 'f2', name: 'diagram.png', mime: 'image/png',
    kind: ElAgentAttachmentKind.image, size: 20480, // no vision reading
  ),
];

elSerialiseAttachments('Here is what I found.', attachments).text;
// 'Here is what I found.'
//
// <file name="notes.md" type="text/markdown">
// # Notes
// - remember the demo
// </file>
//
// <attached-but-not-readable>
// diagram.png (image/png, 20 KB)
// </attached-but-not-readable>
// The files above were attached by the user but their contents are not
// available to you. Ask the user to paste the relevant part if you need it.''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

const List<DocsTocEntry> _apiChildren = <DocsTocEntry>[
  DocsTocEntry(
    title: 'ElAgentAttachmentKind',
    anchor: 'api-elagentattachmentkind',
  ),
  DocsTocEntry(title: 'ElAgentDeliverySent', anchor: 'api-elagentdeliverysent'),
  DocsTocEntry(title: 'ElAgentDelivery', anchor: 'api-elagentdelivery'),
  DocsTocEntry(title: 'ElAgentAttachment', anchor: 'api-elagentattachment'),
  DocsTocEntry(title: 'ElSerialisedMessage', anchor: 'api-elserialisedmessage'),
  DocsTocEntry(title: 'ElAgentTurnStatus', anchor: 'api-elagentturnstatus'),
  DocsTocEntry(title: 'ElAgentTurn', anchor: 'api-elagentturn'),
  DocsTocEntry(title: 'ElUserTurn', anchor: 'api-eluserturn'),
  DocsTocEntry(title: 'ElTextTurn', anchor: 'api-eltextturn'),
  DocsTocEntry(title: 'ElToolTurn', anchor: 'api-eltoolturn'),
  DocsTocEntry(title: 'ElActionTurn', anchor: 'api-elactionturn'),
  DocsTocEntry(title: 'ElApprovalOutcome', anchor: 'api-elapprovaloutcome'),
  DocsTocEntry(title: 'ElErrorTurn', anchor: 'api-elerrorturn'),
  DocsTocEntry(title: 'ElPendingApproval', anchor: 'api-elpendingapproval'),
  DocsTocEntry(title: 'ElAgentState', anchor: 'api-elagentstate'),
  DocsTocEntry(title: 'ElToolStateMap', anchor: 'api-eltoolstatemap'),
  DocsTocEntry(
    title: 'ElAgentAttachmentSupport',
    anchor: 'api-elagentattachmentsupport',
  ),
  DocsTocEntry(title: 'ElAgentCapabilities', anchor: 'api-elagentcapabilities'),
  DocsTocEntry(title: 'ElAgentSendOptions', anchor: 'api-elagentsendoptions'),
  DocsTocEntry(title: 'ElAgentTransport', anchor: 'api-elagenttransport'),
  DocsTocEntry(title: 'ElAgentSignals', anchor: 'api-elagentsignals'),
  DocsTocEntry(
    title: 'ElConversationSummary',
    anchor: 'api-elconversationsummary',
  ),
  DocsTocEntry(title: 'ElConversationStore', anchor: 'api-elconversationstore'),
  DocsTocEntry(title: 'ElSwitchPhase', anchor: 'api-elswitchphase'),
  DocsTocEntry(
    title: 'ElBlurSwitchController',
    anchor: 'api-elblurswitchcontroller',
  ),
  DocsTocEntry(title: 'Top-level functions', anchor: 'api-functions'),
];

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elagentattachmentkind',
        child: DocsApiTable(
          title: 'ElAgentAttachmentKind',
          facts: _attachmentKindFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elagentdeliverysent',
        child: DocsApiTable(
          title: 'ElAgentDeliverySent',
          facts: _deliverySentFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elagentdelivery',
        child: DocsApiTable(title: 'ElAgentDelivery', facts: _deliveryFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elagentattachment',
        child: DocsApiTable(
          title: 'ElAgentAttachment',
          facts: _attachmentFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elserialisedmessage',
        child: DocsApiTable(
          title: 'ElSerialisedMessage',
          facts: _serialisedMessageFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elagentturnstatus',
        child: DocsApiTable(
          title: 'ElAgentTurnStatus',
          facts: _turnStatusFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elagentturn',
        child: DocsApiTable(title: 'ElAgentTurn', facts: _agentTurnFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-eluserturn',
        child: DocsApiTable(title: 'ElUserTurn', facts: _userTurnFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-eltextturn',
        child: DocsApiTable(title: 'ElTextTurn', facts: _textTurnFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-eltoolturn',
        child: DocsApiTable(title: 'ElToolTurn', facts: _toolTurnFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elactionturn',
        child: DocsApiTable(title: 'ElActionTurn', facts: _actionTurnFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elapprovaloutcome',
        child: DocsApiTable(
          title: 'ElApprovalOutcome',
          facts: _approvalOutcomeFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elerrorturn',
        child: DocsApiTable(title: 'ElErrorTurn', facts: _errorTurnFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elpendingapproval',
        child: DocsApiTable(
          title: 'ElPendingApproval',
          facts: _pendingApprovalFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elagentstate',
        child: DocsApiTable(title: 'ElAgentState', facts: _agentStateFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-eltoolstatemap',
        child: DocsApiTable(
          title: 'ElToolStateMap',
          facts: _toolStateMapFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elagentattachmentsupport',
        child: DocsApiTable(
          title: 'ElAgentAttachmentSupport',
          facts: _attachmentSupportFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elagentcapabilities',
        child: DocsApiTable(
          title: 'ElAgentCapabilities',
          facts: _capabilitiesFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elagentsendoptions',
        child: DocsApiTable(
          title: 'ElAgentSendOptions',
          facts: _sendOptionsFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elagenttransport',
        child: DocsApiTable(
          title: 'ElAgentTransport',
          facts: _transportFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elagentsignals',
        child: DocsApiTable(title: 'ElAgentSignals', facts: _signalsFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elconversationsummary',
        child: DocsApiTable(
          title: 'ElConversationSummary',
          facts: _conversationSummaryFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elconversationstore',
        child: DocsApiTable(
          title: 'ElConversationStore',
          facts: _conversationStoreFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elswitchphase',
        child: DocsApiTable(title: 'ElSwitchPhase', facts: _switchPhaseFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elblurswitchcontroller',
        child: DocsApiTable(
          title: 'ElBlurSwitchController',
          facts: _blurSwitchFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-functions',
        child: DocsApiTable(
          title: 'Top-level functions',
          facts: _functionFacts,
        ),
      ),
    ],
  );
}

const List<DocsApiFact> _attachmentKindFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'image',
    type: 'enum value',
    description: 'MIME starts with image/.',
  ),
  DocsApiFact(
    name: 'document',
    type: 'enum value',
    description:
        'application/pdf, or an extension matching pdf/docx?/odt/rtf/pages.',
  ),
  DocsApiFact(
    name: 'data',
    type: 'enum value',
    description:
        'csv/tsv/json/xlsx?/ods/parquet, or MIME application/json or '
        'text/csv.',
  ),
  DocsApiFact(
    name: 'code',
    type: 'enum value',
    description:
        'ts/tsx/js/jsx/py/rb/go/rs/java/c/h/cpp/sql/sh/yml/yaml/toml/css/'
        'html.',
  ),
  DocsApiFact(
    name: 'audio',
    type: 'enum value',
    description: 'MIME starts with audio/.',
  ),
  DocsApiFact(
    name: 'other',
    type: 'enum value',
    description:
        'text/* or txt/md/log, and the final fallback for anything else.',
  ),
];

const List<DocsApiFact> _deliverySentFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'content',
    type: 'enum value',
    description: 'The file\'s content was inlined; the agent can read it.',
  ),
  DocsApiFact(
    name: 'reference',
    type: 'enum value',
    description: 'Only the filename and type travelled.',
  ),
  DocsApiFact(
    name: 'produced',
    type: 'enum value',
    description: 'Produced by the agent, so delivery does not apply.',
  ),
];

const List<DocsApiFact> _deliveryFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ElAgentDelivery.content()',
    type: 'const constructor',
    description: 'sent: content, reason: null.',
  ),
  DocsApiFact(
    name: 'ElAgentDelivery.reference(reason)',
    type: 'const constructor',
    description: 'Required positional String reason. sent: reference.',
  ),
  DocsApiFact(
    name: 'ElAgentDelivery.produced()',
    type: 'const constructor',
    description: 'sent: produced, reason: null.',
  ),
  DocsApiFact(
    name: 'sent',
    type: 'ElAgentDeliverySent',
    description: 'Which constructor built this instance.',
  ),
  DocsApiFact(
    name: 'reason',
    type: 'String?',
    description: 'Only .reference() carries one; every other constructor '
        'leaves it null.',
  ),
];

const List<DocsApiFact> _attachmentFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'id',
    type: 'String',
    description: 'Required.',
  ),
  DocsApiFact(name: 'name', type: 'String', description: 'Required.'),
  DocsApiFact(
    name: 'mime',
    type: 'String',
    description:
        'Required. As reported by the picker, or asserted by the '
        'producing tool.',
  ),
  DocsApiFact(name: 'kind', type: 'ElAgentAttachmentKind', description: 'Required.'),
  DocsApiFact(
    name: 'size',
    type: 'int',
    description: 'Required. Bytes: shown to the user and what the size '
        'cap is enforced against.',
  ),
  DocsApiFact(
    name: 'url',
    type: 'String?',
    description: 'Optional. Object URL for preview and download.',
  ),
  DocsApiFact(
    name: 'text',
    type: 'String?',
    description:
        'Optional. Decoded content, for the kinds where holding it is '
        'useful and cheap.',
  ),
  DocsApiFact(
    name: 'delivery',
    type: 'ElAgentDelivery?',
    description:
        'Optional. Set by the transport once it knows whether the '
        'content actually travelled.',
  ),
  DocsApiFact(
    name: 'copyWith({delivery, text})',
    type: 'method',
    description: 'Returns a new instance with delivery and/or text '
        'replaced; every other field carries over unchanged.',
  ),
];

const List<DocsApiFact> _serialisedMessageFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'text',
    type: 'String',
    description: 'Required. What actually goes on the wire.',
  ),
  DocsApiFact(
    name: 'attachments',
    type: 'List<ElAgentAttachment>',
    description: 'Required. The same attachments, with delivery stamped '
        'on each.',
  ),
];

const List<DocsApiFact> _turnStatusFacts = <DocsApiFact>[
  DocsApiFact(name: 'running', type: 'enum value', description: 'In flight.'),
  DocsApiFact(name: 'ok', type: 'enum value', description: 'Settled, succeeded.'),
  DocsApiFact(name: 'error', type: 'enum value', description: 'Settled, failed.'),
];

const List<DocsApiFact> _agentTurnFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'id',
    type: 'String',
    description:
        'Required. The only field the sealed base class itself declares; '
        'every one of the five subclasses below carries it.',
  ),
];

const List<DocsApiFact> _userTurnFacts = <DocsApiFact>[
  DocsApiFact(name: 'id', type: 'String', description: 'Required (from ElAgentTurn).'),
  DocsApiFact(name: 'text', type: 'String', description: 'Required.'),
  DocsApiFact(
    name: 'attachments',
    type: 'List<ElAgentAttachment>',
    description: 'Defaults to [].',
  ),
];

const List<DocsApiFact> _textTurnFacts = <DocsApiFact>[
  DocsApiFact(name: 'id', type: 'String', description: 'Required (from ElAgentTurn).'),
  DocsApiFact(name: 'text', type: 'String', description: 'Required.'),
  DocsApiFact(
    name: 'attachments',
    type: 'List<ElAgentAttachment>',
    description: 'Defaults to [].',
  ),
  DocsApiFact(
    name: 'streaming',
    type: 'bool',
    description:
        'Defaults to false. True while this is the turn the model is '
        'still streaming into; the transcript reads it for the cursor.',
  ),
  DocsApiFact(
    name: 'notStreaming()',
    type: 'method',
    description: 'Shorthand for copyWith(streaming: false).',
  ),
  DocsApiFact(
    name: 'copyWith({streaming})',
    type: 'method',
    description: 'Returns a new instance with streaming replaced.',
  ),
];

const List<DocsApiFact> _toolTurnFacts = <DocsApiFact>[
  DocsApiFact(name: 'id', type: 'String', description: 'Required (from ElAgentTurn).'),
  DocsApiFact(name: 'name', type: 'String', description: 'Required. The tool name.'),
  DocsApiFact(
    name: 'params',
    type: 'Map<String, Object?>',
    description: 'Required. The call\'s arguments.',
  ),
  DocsApiFact(name: 'status', type: 'ElAgentTurnStatus', description: 'Required.'),
  DocsApiFact(
    name: 'attempt',
    type: 'int',
    description:
        'Required. Incremented when the same tool is re-called after a '
        'failure.',
  ),
  DocsApiFact(
    name: 'startedAt',
    type: 'int',
    description: 'Defaults to 0. Wall-clock at dispatch, in milliseconds.',
  ),
  DocsApiFact(
    name: 'result',
    type: 'Object?',
    description: 'Optional. The settled call\'s return value.',
  ),
  DocsApiFact(
    name: 'error',
    type: 'String?',
    description: 'Optional. The settled call\'s failure message.',
  ),
  DocsApiFact(
    name: 'attachments',
    type: 'List<ElAgentAttachment>',
    description: 'Defaults to []. Files the tool produced.',
  ),
  DocsApiFact(
    name: 'ms',
    type: 'int?',
    description:
        'Optional. How long the call took once settled; null while '
        'running.',
  ),
];

const List<DocsApiFact> _actionTurnFacts = <DocsApiFact>[
  DocsApiFact(name: 'id', type: 'String', description: 'Required (from ElAgentTurn).'),
  DocsApiFact(
    name: 'action',
    type: 'String',
    description: 'Required. The step the browser performed.',
  ),
  DocsApiFact(
    name: 'params',
    type: 'Map<String, Object?>',
    description: 'Required.',
  ),
  DocsApiFact(name: 'status', type: 'ElAgentTurnStatus', description: 'Required.'),
  DocsApiFact(
    name: 'startedAt',
    type: 'int',
    description: 'Defaults to 0.',
  ),
  DocsApiFact(
    name: 'error',
    type: 'String?',
    description: 'Optional.',
  ),
  DocsApiFact(name: 'ms', type: 'int?', description: 'Optional.'),
  DocsApiFact(
    name: 'approval',
    type: 'ElApprovalOutcome?',
    description:
        'Optional. Set when this action is held at an approval card '
        'rather than run.',
  ),
];

const List<DocsApiFact> _approvalOutcomeFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'pending',
    type: 'enum value',
    description: 'Held, waiting on a human.',
  ),
  DocsApiFact(name: 'approved', type: 'enum value', description: 'The user said yes.'),
  DocsApiFact(name: 'rejected', type: 'enum value', description: 'The user said no.'),
];

const List<DocsApiFact> _errorTurnFacts = <DocsApiFact>[
  DocsApiFact(name: 'id', type: 'String', description: 'Required (from ElAgentTurn).'),
  DocsApiFact(name: 'message', type: 'String', description: 'Required.'),
  DocsApiFact(
    name: 'fatal',
    type: 'bool',
    description:
        'Required. A fatal error outranks every other branch in '
        'elResolveAgentState; a non-fatal one does not.',
  ),
];

const List<DocsApiFact> _pendingApprovalFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'turnId',
    type: 'String',
    description: 'Required. The ElActionTurn this belongs to.',
  ),
  DocsApiFact(name: 'action', type: 'String', description: 'Required.'),
  DocsApiFact(
    name: 'params',
    type: 'Map<String, Object?>',
    description: 'Required.',
  ),
  DocsApiFact(name: 'approve', type: 'VoidCallback', description: 'Required.'),
  DocsApiFact(
    name: 'reject',
    type: 'void Function([String? reason])',
    description:
        'Required. The reason is optional-positional, so reject() with '
        'no argument is legal.',
  ),
];

const List<DocsApiFact> _agentStateFacts = <DocsApiFact>[
  DocsApiFact(name: 'idle', type: 'enum value', description: '"Ready" · not busy · ElLucide.circle.'),
  DocsApiFact(name: 'queued', type: 'enum value', description: '"Queued" · busy · ElLucide.clock.'),
  DocsApiFact(name: 'planning', type: 'enum value', description: '"Planning" · busy, narrating · ElLucide.listChecks.'),
  DocsApiFact(name: 'retrieving', type: 'enum value', description: '"Retrieving knowledge" · busy · ElLucide.bookOpen.'),
  DocsApiFact(name: 'ingesting', type: 'enum value', description: '"Ingesting data" · busy · ElLucide.database.'),
  DocsApiFact(name: 'running', type: 'enum value', description: '"Running code" · busy · ElLucide.terminal.'),
  DocsApiFact(name: 'delegating', type: 'enum value', description: '"Delegating to agent" · busy · ElLucide.arrowRightLeft.'),
  DocsApiFact(name: 'awaitingApproval', type: 'enum value', description: '"Awaiting approval" · busy, wire awaiting_approval · ElLucide.shieldQuestionMark.'),
  DocsApiFact(name: 'validating', type: 'enum value', description: '"Validating" · busy · ElLucide.checkCheck.'),
  DocsApiFact(name: 'retrying', type: 'enum value', description: '"Retrying" · busy · ElLucide.rotateCw.'),
  DocsApiFact(name: 'error', type: 'enum value', description: '"Something went wrong" · not busy · ElLucide.triangleAlert.'),
  DocsApiFact(name: 'summarizing', type: 'enum value', description: '"Summarizing" · busy, narrating · ElLucide.scrollText.'),
  DocsApiFact(name: 'thinking', type: 'enum value', description: '"Thinking" · busy · ElLucide.brain.'),
  DocsApiFact(name: 'processing', type: 'enum value', description: '"Processing" · busy · ElLucide.chartColumn.'),
  DocsApiFact(name: 'callingTools', type: 'enum value', description: '"Calling tools" · busy, wire calling_tools · ElLucide.wrench.'),
  DocsApiFact(name: 'searching', type: 'enum value', description: '"Searching" · busy · ElLucide.search.'),
  DocsApiFact(name: 'reading', type: 'enum value', description: '"Reading files" · busy · ElLucide.bookOpen.'),
  DocsApiFact(name: 'recalling', type: 'enum value', description: '"Recalling context" · busy · ElLucide.rotateCcwClock.'),
  DocsApiFact(name: 'writing', type: 'enum value', description: '"Writing" · busy, narrating · ElLucide.pencil.'),
  DocsApiFact(name: 'done', type: 'enum value', description: '"Done" · not busy · ElLucide.check.'),
  DocsApiFact(
    name: '.wire / .label / .isBusy / .isNarrating / .glyph',
    type: 'getters',
    description:
        'The wire spelling, the sentence shown beside the face, whether '
        'the state counts as busy (every value but idle/done/error), '
        'whether it is the agent\'s own voice rather than its hands '
        '(planning/summarizing/writing), and the shared glyph.',
  ),
];

const List<DocsApiFact> _toolStateMapFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ElToolStateMap',
    type: 'typedef Map<String, ElAgentState>',
    description:
        'Supplied by the caller, never guessed: only the caller knows '
        'whether export_activity is reading, writing or running.',
  ),
];

const List<DocsApiFact> _attachmentSupportFacts = <DocsApiFact>[
  DocsApiFact(name: 'content', type: 'enum value', description: 'Can carry attachment content.'),
  DocsApiFact(name: 'reference', type: 'enum value', description: 'Filenames only.'),
  DocsApiFact(name: 'none', type: 'enum value', description: 'No attachments at all.'),
];

const List<DocsApiFact> _capabilitiesFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'attachments',
    type: 'ElAgentAttachmentSupport',
    description: 'Defaults to content.',
  ),
  DocsApiFact(name: 'models', type: 'bool', description: 'Defaults to true. Can the model be chosen per message.'),
  DocsApiFact(
    name: 'approvals',
    type: 'bool',
    description: 'Defaults to true. Can a tool call or action be held for the user to approve.',
  ),
];

const List<DocsApiFact> _sendOptionsFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'attachments',
    type: 'List<ElAgentAttachment>',
    description: 'Defaults to [].',
  ),
  DocsApiFact(
    name: 'model',
    type: 'String?',
    description:
        'Optional. Chosen in the model picker; a transport that cannot '
        'switch models ignores it.',
  ),
  DocsApiFact(
    name: 'wireText',
    type: 'String?',
    description:
        'Optional. What actually goes on the wire, when that differs '
        'from what the user wrote — the transcript keeps text, the '
        'transport sends this.',
  ),
];

const List<DocsApiFact> _transportFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'turns',
    type: 'List<ElAgentTurn> (get)',
    description: 'The transcript, in order. Owned by the transport so it '
        'can settle its own tool calls.',
  ),
  DocsApiFact(
    name: 'send(text, [options])',
    type: 'Future<void> Function',
    description: 'Required.',
  ),
  DocsApiFact(
    name: 'abort()',
    type: 'void Function',
    description: 'The user pressed stop. Not an error.',
  ),
  DocsApiFact(name: 'reset()', type: 'void Function', description: 'Required.'),
  DocsApiFact(name: 'isLoading', type: 'bool (get)', description: 'Required.'),
  DocsApiFact(
    name: 'isReady',
    type: 'bool (get)',
    description:
        'False while the transport is still acquiring whatever it needs '
        'before it can carry a message.',
  ),
  DocsApiFact(name: 'error', type: 'Object? (get)', description: 'Required.'),
  DocsApiFact(
    name: 'pendingApprovals',
    type: 'List<ElPendingApproval> (get)',
    description: 'Requests the transport is holding at an approval gate.',
  ),
  DocsApiFact(
    name: 'capabilities',
    type: 'ElAgentCapabilities (get)',
    description: 'Required.',
  ),
];

const List<DocsApiFact> _signalsFacts = <DocsApiFact>[
  DocsApiFact(name: 'isLoading', type: 'bool', description: 'Defaults to false.'),
  DocsApiFact(
    name: 'awaitingFirstEvent',
    type: 'bool',
    description: 'Defaults to false. True between hitting send and the '
        'first event coming back.',
  ),
  DocsApiFact(
    name: 'declared',
    type: 'ElAgentState?',
    description: 'Optional. A state the agent asserted about itself; '
        'wins over everything derived.',
  ),
];

const List<DocsApiFact> _conversationSummaryFacts = <DocsApiFact>[
  DocsApiFact(name: 'id', type: 'String', description: 'Required.'),
  DocsApiFact(name: 'title', type: 'String', description: 'Required.'),
  DocsApiFact(
    name: 'updatedAt',
    type: 'DateTime',
    description: 'Required. Rendered relative by the list.',
  ),
  DocsApiFact(
    name: 'preview',
    type: 'String?',
    description: 'Optional. First line of the opening message.',
  ),
  DocsApiFact(
    name: 'pinned',
    type: 'bool',
    description: 'Defaults to false. Held at the top of the list.',
  ),
  DocsApiFact(
    name: 'copyWith({title, pinned})',
    type: 'method',
    description: 'Returns a new instance with title and/or pinned '
        'replaced.',
  ),
];

const List<DocsApiFact> _conversationStoreFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'conversations',
    type: 'List<ElConversationSummary> (get)',
    description: 'Required.',
  ),
  DocsApiFact(
    name: 'activeId',
    type: 'String? (get)',
    description: 'The conversation on screen, or null for an unsaved new '
        'one.',
  ),
  DocsApiFact(name: 'isLoading', type: 'bool (get)', description: 'Required.'),
  DocsApiFact(name: 'error', type: 'String? (get)', description: 'Required.'),
  DocsApiFact(name: 'open(id)', type: 'void Function', description: 'Required.'),
  DocsApiFact(name: 'create()', type: 'void Function', description: 'Required.'),
  DocsApiFact(name: 'rename(id, title)', type: 'void Function', description: 'Required.'),
  DocsApiFact(name: 'remove(id)', type: 'void Function', description: 'Required.'),
  DocsApiFact(name: 'refresh()', type: 'void Function', description: 'Required.'),
  DocsApiFact(
    name: 'pin',
    type: 'void Function(String, bool)?',
    description: 'Null when the store cannot pin: the affordance goes '
        'with it. Capabilities are absence, not flags.',
  ),
  DocsApiFact(
    name: 'share',
    type: 'void Function(String)?',
    description: 'Null when the store cannot share.',
  ),
];

const List<DocsApiFact> _switchPhaseFacts = <DocsApiFact>[
  DocsApiFact(name: 'idle', type: 'enum value', description: 'className: "" (no transition in flight).'),
  DocsApiFact(name: 'out', type: 'enum value', description: "className: 'anim-blur-out'."),
  DocsApiFact(
    name: 'blurIn',
    type: 'enum value',
    description:
        "The reference's own \"in\", a Dart reserved word. className: "
        "'anim-blur-in'.",
  ),
];

const List<DocsApiFact> _blurSwitchFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ElBlurSwitchController({required open})',
    type: 'constructor',
    description:
        'open: void Function(String id) — the store call, made at the '
        'darkest point of the transition.',
  ),
  DocsApiFact(
    name: 'ElBlurSwitchController.outDuration',
    type: 'static Duration (get)',
    description: 'ElDurations.fast — anim-blur-out.',
  ),
  DocsApiFact(
    name: 'ElBlurSwitchController.inDuration',
    type: 'static Duration (get)',
    description: 'ElDurations.base — anim-blur-in.',
  ),
  DocsApiFact(name: 'phase', type: 'ElSwitchPhase (get)', description: 'Required.'),
  DocsApiFact(
    name: 'switchTo(id)',
    type: 'void Function',
    description: 'What a history row calls instead of store.open — runs '
        'the blur-out, swap, blur-in sequence.',
  ),
];

const List<DocsApiFact> _functionFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'elAttachmentKind(mime, name)',
    type: 'ElAgentAttachmentKind Function',
    description: 'Classify by MIME first, extension second.',
  ),
  DocsApiFact(
    name: 'elFormatBytes(bytes)',
    type: 'String Function',
    description: '1023 B, 18 KB, 2.6 MB.',
  ),
  DocsApiFact(
    name: 'elIsTextual(attachment)',
    type: 'bool Function',
    description: 'Whether this file\'s bytes are meaningfully text.',
  ),
  DocsApiFact(
    name: 'elSerialiseAttachments(text, attachments)',
    type: 'ElSerialisedMessage Function',
    description: 'Fold attachments into the message the agent receives.',
  ),
  DocsApiFact(
    name: 'elStripProtocol(text)',
    type: 'String Function',
    description: 'Strip the streaming protocol\'s own <complete> tags and '
        'a dangling half-written tag at the end of the buffer.',
  ),
  DocsApiFact(
    name: 'elStateForTool(name, map)',
    type: 'ElAgentState? Function',
    description: 'Exact match first, then longest "."- or "_"-terminated '
        'prefix.',
  ),
  DocsApiFact(
    name: 'elHumaniseToolName(name)',
    type: 'String Function',
    description: 'search_inventory → Search inventory.',
  ),
  DocsApiFact(
    name: 'elFormatMs(ms)',
    type: 'String Function',
    description: '912ms under a second, 8.0s above it.',
  ),
  DocsApiFact(
    name: 'elResolveAgentState({turns, signals, toolStates})',
    type: 'ElAgentState Function',
    description: 'Which of the twenty states is true right now — the '
        'nine-branch precedence ladder.',
  ),
  DocsApiFact(
    name: 'elRelativeTime(then, {now})',
    type: 'String Function',
    description: 'The largest unit that still reads as a whole number: '
        '"just now", "yesterday", "3 hours ago".',
  ),
  DocsApiFact(
    name: 'elRelativeTimeOf(context, then)',
    type: 'String Function',
    description: 'elRelativeTime against the nearest ElClock — the '
        '?clock= seam.',
  ),
];

class _StatesContent extends StatelessWidget {
  const _StatesContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No hover, press, focus, disabled, or loading state: '
            'agent_core.dart declares no widget and paints nothing, so '
            'there is no control here for DocsStateMatrix to describe.',
        'What it has instead is the twenty-value ElAgentState machine — '
            'see the ElAgentState table in API Reference for every value, '
            'label, and glyph, and Resolve agent state above for the real '
            'elResolveAgentState precedence ladder that picks one.',
        'ElSwitchPhase is a second, much smaller state: idle / out / '
            'blurIn, the three frames ElBlurSwitchController drives a '
            'conversation switch through. Also documented in API '
            'Reference, not demonstrated live here: it needs an animated '
            'consumer (agent-history\'s own transcript) to be shown '
            'switching, and this page is not that consumer.',
      ]);
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No Semantics node: agent_core.dart imports package:flutter/'
            'widgets.dart only for @immutable, VoidCallback, '
            'ChangeNotifier, Listenable, and BuildContext — never for a '
            'RenderObject or a Semantics call of its own.',
        'What it supplies instead is the vocabulary a consuming widget '
            'announces: ElAgentState.label is the exact sentence a status '
            'line reads aloud, and elHumaniseToolName is the fallback '
            'name a tool chip announces when no product-specific label '
            'was mapped for it — so an unmapped tool is still announced '
            'as words a person can read, never a raw snake_case slug.',
        'elSerialiseAttachments\'s <attached-but-not-readable> block is '
            'itself an accessibility-adjacent honesty device, aimed at '
            'the model rather than a screen reader: it tells the agent, '
            'in words, exactly which files it cannot see, rather than '
            'silently dropping them from the prompt.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'agent_core.dart declares no widget: it takes no focus and '
            'handles no key event. Every keyboard interaction in this '
            'family — arrow keys in the slash palette, Enter to send — '
            'belongs to a consuming widget, documented on that widget\'s '
            'own page.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No breakpoint branching: nothing in agent_core.dart reads '
            'MediaQuery, because it draws no layout to break.',
        'BuildContext appears in exactly one function, '
            'elRelativeTimeOf, and only to read the ambient ElClock — a '
            'testing seam for freezing "now" — never the viewport.',
        'Platform parity: every type and function in this file is pure '
            'Dart with no dart:io Platform branch and no platform '
            'channel.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DocsInstallFacts(
        facts: <DocsInstallFact>[
          const DocsInstallFact(
            label: 'File',
            value: 'lib/src/components/agent_core.dart',
            description:
                'One file, no companions; the registry manifest lists '
                'exactly one entry under "files".',
          ),
          const DocsInstallFact(
            label: 'Flutter imports',
            value: 'package:flutter/widgets.dart',
            description:
                'For @immutable, VoidCallback, ChangeNotifier, '
                'Listenable, and BuildContext only — no rendering, no '
                'painting.',
          ),
          const DocsInstallFact(
            label: 'Foundation imports',
            value: 'foundation/date_format.dart, foundation/motion.dart, '
                'icon_paths.g.dart',
            description:
                'date_format.dart supplies ElClock (the ?clock= seam '
                'elRelativeTimeOf reads); motion.dart supplies '
                'ElDurations.fast/base for ElBlurSwitchController; '
                'icon_paths.g.dart supplies ElLucideGlyph, the type '
                'ElAgentState.glyph returns.',
          ),
          DocsInstallFact(
            label: 'registryDependencies',
            value: agentCoreDoc.dependencies.join(', '),
            description:
                "The manifest's own list, resolved automatically by "
                'elattar add agent-core. icon is what ElLucideGlyph and '
                'the icon path table it indexes into ultimately come '
                'from.',
          ),
          const DocsInstallFact(
            label: 'Consumed by (the reverse direction)',
            value:
                'agent-console, agent-composer, agent-transcript, '
                'agent-avatar, agent-face, agent-history, '
                'agent-slash-palette, agent-attach-menu, '
                'agent-attachments, agent-markdown, agent-launcher',
            description:
                'Not a registry dependency — every other file in the '
                'agent_* family imports this one; this file imports none '
                'of them back.',
          ),
        ],
      ),
      SizedBox(height: el(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Icon', route: '/components/icon'),
          DocsLink(
            label: 'Agent Attach Menu',
            route: '/components/agent_attach_menu',
          ),
          DocsLink(
            label: 'Agent Attachments',
            route: '/components/agent_attachments',
          ),
          DocsLink(label: 'Agent Avatar', route: '/components/agent_avatar'),
          DocsLink(label: 'Agent Composer', route: '/components/agent-composer'),
          DocsLink(label: 'Agent Console', route: '/components/agent-console'),
          DocsLink(label: 'Agent Face', route: '/components/agent_face'),
          DocsLink(label: 'Agent History', route: '/components/agent_history'),
          DocsLink(
            label: 'Agent Launcher',
            route: '/components/agent_launcher',
          ),
          DocsLink(
            label: 'Agent Markdown',
            route: '/components/agent_markdown',
          ),
          DocsLink(
            label: 'Agent Slash Palette',
            route: '/components/agent_slash_palette',
          ),
          DocsLink(
            label: 'Agent Transcript',
            route: '/components/agent-transcript',
          ),
        ],
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) => DocsInstallFacts(
    title: 'What actually varies with the theme',
    facts: const <DocsInstallFact>[
      DocsInstallFact(
        label: 'Nothing',
        value: 'agent_core.dart reads no ElTheme',
        description:
            'The file imports no theme_scope.dart and calls '
            'ElTheme.of(context) nowhere. Every colour this page shows — '
            'the Preview chips\' theme.card and theme.border, the code '
            'blocks\' theme.muted — belongs to THIS PAGE\'s own specimen '
            'widgets, not to agent_core.dart itself. A consuming widget '
            '(agent-console\'s error banner reads theme.destructive, its '
            'ElAgentFace reads theme.agent) is where the family\'s real '
            'theming lives.',
      ),
    ],
  );
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
