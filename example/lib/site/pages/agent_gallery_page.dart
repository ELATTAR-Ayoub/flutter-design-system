// example/lib/site/pages/agent_gallery_page.dart
/// `/agent`: the agent, live, for a visitor to actually use.
///
/// Mirrors `/charts`'s shape — a hero with two buttons, a component-reference
/// block at the foot read from `componentDocs` — but the body is not a
/// gallery of copyable cards. It is a working [AgentConsole] a visitor can
/// type into and watch answer, plus the surfaces around it (history, voice,
/// the launcher, a structured transcript turn) each as something the visitor
/// operates rather than a screenshot of it.
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

import '../../components_docs/catalog.dart';
import '../../kit.dart';
import '../../pages/agent_voice.dart' show VoiceDemo;
import '../../pages/console.dart' show LauncherDemo, LiveConsole;
import '../../pages/history.dart' show HistoryListDemo;
import '../../pages/transcript.dart' show QuestionnaireDemo;

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
            SizedBox(height: space(12)),
            const _SupportingSurfaces(),
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
            'One console, on a scripted transport, with the same history, '
            'voice and launcher surfaces a real deployment carries — type '
            'into it below, no reading required first.',
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
                  : () => onNavigate!('/components/agent_core'),
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
          'Vault, on a mock transport — ask what is in stock, ask it to '
          'export your activity, ask it to buy a pack. Every answer, tool '
          'call and approval gate is the real component.',
          TextStyles.small,
          color: theme.mutedForeground,
        ),
        SizedBox(height: space(4)),
        KeyedSubtree(
          key: consoleKey,
          child: const Panel(label: 'AgentConsole', child: LiveConsole()),
        ),
      ],
    );
  }
}

/* ── Supporting surfaces ─────────────────────────────────────────────────── */

class _SupportingSurfaces extends StatelessWidget {
  const _SupportingSurfaces();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CapsLabel('Try the surfaces around it', color: theme.mutedForeground),
        SizedBox(height: space(4)),
        Grid(
          base: 1,
          lg: 2,
          gap: space(6),
          matchHeights: false,
          children: <Widget>[
            _SurfaceCard(
              title: 'History',
              description:
                  'Open, rename, pin and delete conversations — the same '
                  'list a returning visitor sees.',
              child: SizedBox(
                height: space(96),
                child: SingleChildScrollView(child: HistoryListDemo()),
              ),
            ),
            _SurfaceCard(
              title: 'Voice',
              description:
                  'Arm the microphone; the waveform and level meter answer '
                  'to the toggle.',
              child: const VoiceDemo(),
            ),
            _SurfaceCard(
              title: 'Launcher',
              description:
                  'How the agent sits on a working page: an avatar in the '
                  'corner that opens the console in a dialog. Click it, '
                  'bottom-right of the viewport.',
              child: const LauncherDemo(),
            ),
            _SurfaceCard(
              title: 'Transcript',
              description:
                  'A structured turn inside the transcript — answer with the '
                  'mouse or press A, B or C.',
              child: const QuestionnaireDemo(),
            ),
          ],
        ),
      ],
    );
  }
}

class _SurfaceCard extends StatelessWidget {
  const _SurfaceCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        StyledText(title, TextStyles.h4, color: theme.foreground),
        SizedBox(height: space(1)),
        StyledText(description, TextStyles.small, color: theme.mutedForeground),
        SizedBox(height: space(3)),
        Panel(label: title, child: child),
      ],
    );
  }
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
                  StyledText(entry.title, TextStyles.h4, color: theme.foreground),
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
