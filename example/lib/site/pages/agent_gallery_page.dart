// example/lib/site/pages/agent_gallery_page.dart
/// `/agent`: the agent, live, for a visitor to actually use.
///
/// Mirrors `/charts`'s shape — a hero with two buttons, a component-reference
/// block at the foot read from `componentDocs` — but the body is not a
/// gallery of copyable cards. It is one working [AgentConsole], configured
/// with [AgentFeatures.all], with a conversation history rail folded into the
/// same surface rather than shown as a separate demo beside it.
///
/// **The microphone is on, and captures real audio on the web.**
/// `AgentFeatures.microphone` is set; `agent_console.dart` wires it to a real
/// `MicControl` beside send. `_IntegratedAgentSurfaceState` builds and owns a
/// real [VoiceSource] (`../../voice_source.dart`) and hands it to
/// `AgentConsole.voiceSource` — the package's own default is an honest no-op
/// (real capture cannot live inside the package itself, see
/// `voice_source_web.dart`'s own docs), so this is what makes pressing the
/// mic here actually ask the browser for the microphone.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/agent/mock_transport.dart';
import 'package:example/voice_source.dart';
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

import '../../components_docs/catalog.dart';
import '../../kit.dart';
import '../../pages/console.dart'
    show
        describeVaultApproval,
        kVaultCommands,
        kVaultModels,
        kVaultPersona,
        kVaultToolStates;
import '../../pages/history.dart' show MockConversationStore;

class AgentGalleryPage extends StatefulWidget {
  const AgentGalleryPage({super.key, this.onNavigate});

  /// The site shell's navigator, passed by `main.dart`'s builder map.
  final void Function(String route)? onNavigate;

  @override
  State<AgentGalleryPage> createState() => _AgentGalleryPageState();
}

class _AgentGalleryPageState extends State<AgentGalleryPage> {
  /// The anchor `Try the Agent` scrolls to: the live console itself.
  final GlobalKey _consoleKey = GlobalKey();

  Future<void> _browse() async {
    final BuildContext? anchor = _consoleKey.currentContext;
    if (anchor == null) return;
    await Scrollable.ensureVisible(
      anchor,
      duration: MotionDurations.normal,
      curve: MotionCurves.enter,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: space(6),
          vertical: space(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _Hero(onTry: _browse, onNavigate: widget.onNavigate),
            SizedBox(height: space(10)),
            _LiveSection(consoleKey: _consoleKey),
            SizedBox(height: space(14)),
            _ComponentReference(onNavigate: widget.onNavigate),
          ],
        ),
      ),
    );
  }
}

/* ── Hero ─────────────────────────────────────────────────────────────────── */

class _Hero extends StatelessWidget {
  const _Hero({required this.onTry, required this.onNavigate});

  final VoidCallback onTry;
  final void Function(String route)? onNavigate;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        StyledText('Agent', TextStyles.h1, color: theme.foreground),
        SizedBox(height: space(4)),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Containers.xl2),
          child: StyledText(
            'One console, on a scripted transport, every feature switched '
            'on — history folded into the same surface — type into it '
            'below, no reading required first.',
            TextStyles.body,
            color: theme.mutedForeground,
          ),
        ),
        SizedBox(height: space(7)),
        Wrap(
          spacing: space(3),
          runSpacing: space(3),
          children: <Widget>[
            Button(onPressed: onTry, child: const Text('Try the Agent')),
            Button(
              variant: ButtonVariant.secondary,
              onPressed: onNavigate == null
                  ? null
                  : () => onNavigate!(componentDoc('agent-core').route),
              child: const Text('Documentation'),
            ),
          ],
        ),
      ],
    );
  }
}

/* ── Live console ─────────────────────────────────────────────────────────── */

class _LiveSection extends StatelessWidget {
  const _LiveSection({required this.consoleKey});

  final GlobalKey consoleKey;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CapsLabel('Live agent', color: theme.mutedForeground),
        SizedBox(height: space(2)),
        StyledText(
          'Vault, on a mock transport, every feature switched on — ask '
          'what is in stock, ask it to export your activity, ask it to buy '
          'a pack, open the sidebar and switch conversations. Every '
          'answer, tool call and approval gate is the real component.',
          TextStyles.small,
          color: theme.mutedForeground,
        ),
        SizedBox(height: space(4)),
        KeyedSubtree(
          key: consoleKey,
          child: const Panel(
            label: 'AgentConsole',
            flush: true,
            child: _IntegratedAgentSurface(),
          ),
        ),
      ],
    );
  }
}

/// One [AgentConsole], [AgentFeatures.all] switched on, with history folded
/// into its `headerSlot` rather than shown beside it as a separate demo.
/// Opening the sidebar (the panel-left icon in the console's header)
/// and choosing a conversation calls [BlurSwitchController.switchTo]: the
/// transcript blurs out, `store.open` runs mid-blur, the console's own
/// `switchPhase` blurs it back in, and the sidebar's own title row swaps to
/// the chosen conversation — the same visible switch `ConsoleWithHistory`
/// demonstrates on `/design-system/components/agent/history`, wired here
/// with every other feature also turned on.
class _IntegratedAgentSurface extends StatefulWidget {
  const _IntegratedAgentSurface();

  /// `h-152`, 608px — the same fixed height every other live console on the
  /// site carries, so the document's height does not depend on the mock
  /// transport's own reply length.
  static double get height => space(152);

  @override
  State<_IntegratedAgentSurface> createState() =>
      _IntegratedAgentSurfaceState();
}

class _IntegratedAgentSurfaceState extends State<_IntegratedAgentSurface> {
  /// The console's own root — the box the history drawer lays itself over.
  final GlobalKey _surface = GlobalKey();
  final MockTransport _transport = MockTransport();

  /// Real microphone capture on the web, the package's own no-op everywhere
  /// else — see `voice_source.dart`. Built once, here, rather than left for
  /// `AgentConsole` to default: the console never disposes an injected
  /// source (it may outlive the widget), so this page — which built it —
  /// is the one that has to.
  final VoiceSource _voiceSource = createExampleVoiceSource();

  MockConversationStore? _store;
  late final BlurSwitchController _switch = BlurSwitchController(
    open: (String id) => _store!.open(id),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _store ??= MockConversationStore(now: Clock.nowOf(context));
  }

  @override
  void dispose() {
    _switch.dispose();
    _store?.dispose();
    _transport.dispose();
    _voiceSource.stop();
    _voiceSource.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    key: _surface,
    height: _IntegratedAgentSurface.height,
    // Listens to `_switch` itself, not just the header slot below: the
    // console's own `switchPhase` prop has to rebuild on every phase change
    // too, or the blur it wears on the transcript never leaves whatever
    // phase was current the one time this widget happened to build.
    child: ListenableBuilder(
      listenable: _switch,
      builder: (BuildContext context, Widget? _) => AgentConsole(
        transport: _transport,
        persona: kVaultPersona,
        toolStates: kVaultToolStates,
        commands: kVaultCommands,
        models: kVaultModels,
        describeApproval: describeVaultApproval,
        features: AgentFeatures.all,
        height: _IntegratedAgentSurface.height,
        switchPhase: _switch.phase,
        voiceSource: _voiceSource,
        headerSlot: ListenableBuilder(
          listenable: _store!,
          builder: (BuildContext context, Widget? _) => ChatHistory(
            store: _store!,
            title: kVaultPersona.name,
            surfaceKey: _surface,
            // `{ ...store, open: switchTo }`: the drawer opens through the
            // blur rather than through the store directly.
            onOpenConversation: _switch.switchTo,
          ),
        ),
      ),
    ),
  );
}

/* ── Component reference ─────────────────────────────────────────────────── */

class _ComponentReference extends StatelessWidget {
  const _ComponentReference({required this.onNavigate});

  final void Function(String route)? onNavigate;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final List<ComponentDocEntry> entries = componentDocsIn(
      ComponentDocFamily.agent,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CapsLabel('Component reference', color: theme.mutedForeground),
        SizedBox(height: space(4)),
        KeyedSubtree(
          key: const ValueKey<String>('agent-gallery-component-reference'),
          child: DividedList(
            children: <Widget>[
              for (final ComponentDocEntry entry in entries)
                _ComponentReferenceRow(entry: entry, onNavigate: onNavigate),
            ],
          ),
        ),
      ],
    );
  }
}

class _ComponentReferenceRow extends StatelessWidget {
  const _ComponentReferenceRow({required this.entry, required this.onNavigate});

  final ComponentDocEntry entry;
  final void Function(String route)? onNavigate;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Press(
      onTap: onNavigate == null ? null : () => onNavigate!(entry.route),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: space(4), vertical: space(4)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  StyledText(
                    entry.title,
                    TextStyles.h4,
                    color: theme.foreground,
                  ),
                  SizedBox(height: space(1)),
                  StyledText(
                    entry.description,
                    TextStyles.small,
                    color: theme.mutedForeground,
                  ),
                ],
              ),
            ),
            SizedBox(width: space(4)),
            Icon.lucide(Lucide.chevronRight, size: IconSize.sm),
          ],
        ),
      ),
    );
  }
}
