/// `/design-system/components/agent/console` — the whole component, live, on a
/// scripted transport.
///
/// **The specimens are not pictures.** The page's own opening note is the thesis
/// and the acceptance test: *"Nothing on this page is a screenshot. The console
/// below is the real component on a scripted transport, so every state is
/// reachable by typing."* A reader types *what is left* and it searches;
/// *export* and it hands back a CSV; *buy* and it stops and asks; *price* and it
/// fails, on purpose. `example/lib/agent/mock_transport.dart` is the port of
/// `lib/agent/mock-transport.ts` that makes all four true, and a port that
/// rendered any of these four sections as a still fails the bar however exact
/// the pixels.
///
/// ## The page is four sections; the nav promises six
///
/// `page.tsx` renders `live` → `transport` → `features` → `launcher`. The nav
/// registry's `contents` for this category reads *Live console · The four seams
/// · Feature flags · Personas · Launcher · Transport contract* — **six chips, a
/// different order, and two of them (`The four seams`, `Personas`) have no
/// section behind them at all.** That is the exact failure the selects page's
/// own §6 is a postmortem of, and it is reproduced here on both sides: the chip
/// row ships as the registry has it, the sections ship as the page has them, and
/// neither is reordered to agree with the other. Drift 2 and 3 below.
///
/// ## Oracle
///
/// Measured with `tool/verify/section-oracle.js` at 1440×900, light:
///
/// ```
/// scrollHeight 3205; main {top 64, height 3141}
/// live      top  555.9  h 708.3
/// transport top 1344.2  h 607.3
/// features  top 2031.5  h 459.7
/// launcher  top 2571.2  h 404.8
/// ```
///
/// The two demo boxes carry explicit heights — `h-152` (608) on [LiveConsole],
/// `h-80` (320) on [MinimalConsole], `h-56` (224) on the launcher panel — so the
/// document height does **not** depend on the console's internals. Fidelity
/// does; parity does not. `console_page_test.dart` pins both.
///
/// ## Drift register — recorded, shipped as written
///
///  1. **The eyebrow says the group twice over.** `` `${group.title} ·
///     Components` `` with `group.title = "Agent"`, so it reads *"Agent ·
///     Components"* on a page that is already under `/components/agent/`. Every
///     agent page carries it.
///  2. **The nav's `contents` is in a different order from the page.** Registry:
///     Live console, The four seams, Feature flags, Personas, Launcher,
///     Transport contract. Page: live, transport, features, launcher.
///  3. **Two chips have no section.** *The four seams* and *Personas* are
///     advertised in the header and rendered nowhere. Six chips, four anchors.
///  4. **The section descriptions count features differently from the Panel
///     note.** §features says *"Nine switches, all on by default"* and its Panel
///     note lists nine names — but [MinimalConsole] turns **eight** of them off
///     and leaves `reset` on, which is the one the note lists last and the demo
///     never touches. The copy is right about the count and silent about which
///     one survives.
///  5. **`MAX_CAPABILITIES` never binds.** The welcome card takes four and the
///     console hands it `COMMANDS`, of which only three are `group: "skill"`.
///     Three chips, always.
///  6. **The transport section documents `restore?`, which the console never
///     calls.** `AgentConsole` has no history control and reads no `restore`;
///     the mock transport implements it anyway and the `Meta` list documents it
///     as optional. Ported into the list as written — the port's
///     [DsAgentTransport] does not declare it, so the row documents a member of
///     the reference's interface that this one does not have, which is itself
///     the honest reading of *"a transport with no history behind it omits it"*.
///  7. **The approval gate never reaches `awaiting_approval`.** Probed live: the
///     status line reads `Processing` while the card is up. See
///     [DsAgentConsole]'s own register — one of the twenty states is unreachable
///     through this transport.
///  8. **The launcher's label does not slide.** `translate-x-2` compiles to the
///     standalone `translate` property, which is not in the element's
///     `transition-property`; the 8px offset snaps on the first hover frame and
///     only the opacity fades. Traced with a real pointer — see
///     [DsAgentLauncher].
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/agent/mock_transport.dart';
import 'package:example/kit.dart';
import 'package:example/nav.dart';
import 'package:flutter/widgets.dart';

/* ── Shared fixtures ─────────────────────────────────────────────────────── */

/// `PERSONA` — `components/ds/agent-demo.tsx`.
const DsAgentPersona kVaultPersona = DsAgentPersona(
  name: 'Vault',
  blurb: 'Ask about packs, pulls, prices and your wallet.',
  suggestions: <String>[
    'What sealed boxes are left?',
    'Export my last 30 days',
    'Buy me an Eclipse Vault pack',
    'What is Eclipse Vault worth right now?',
  ],
  placeholder: 'Ask about a pack, a pull or your balance…',
);

/// `TOOL_STATES` — *"how this product's tools map onto the state machine.
/// Supplied by the caller rather than guessed, because only the caller knows
/// whether `export_activity` is reading, writing or running — and a status line
/// that guesses is a status line that lies."*
const DsToolStateMap kVaultToolStates = <String, DsAgentState>{
  'search_inventory': DsAgentState.searching,
  'read_wallet': DsAgentState.retrieving,
  'export_activity': DsAgentState.writing,
  'fetch_market_price': DsAgentState.retrieving,
};

/// `COMMANDS` — three skills and one command, which is why the welcome card
/// shows three chips (drift 5).
const List<DsAgentCommand> kVaultCommands = <DsAgentCommand>[
  DsAgentCommand(
    id: 'inventory',
    label: 'inventory',
    hint: 'What is in stock',
    group: DsAgentCommandGroup.skill,
    icon: DsLucide.search,
  ),
  DsAgentCommand(
    id: 'wallet',
    label: 'wallet',
    hint: 'Balance and recent movement',
    group: DsAgentCommandGroup.skill,
    icon: DsLucide.wallet,
  ),
  DsAgentCommand(
    id: 'export',
    label: 'export',
    hint: 'Download activity as CSV',
    group: DsAgentCommandGroup.skill,
    icon: DsLucide.download,
  ),
  DsAgentCommand(
    id: 'guide',
    label: 'guide',
    hint: 'How pack odds work',
    group: DsAgentCommandGroup.command,
    icon: DsLucide.bookOpen,
  ),
];

/// `MODELS`.
const List<DsAgentModel> kVaultModels = <DsAgentModel>[
  DsAgentModel(id: 'fast', label: 'Fast', hint: 'Answers in a second'),
  DsAgentModel(id: 'deep', label: 'Deep', hint: 'Slower, checks its work'),
];

/// `describeApproval` — *"turns a held action into a sentence a human can decide
/// on."*
String describeVaultApproval(String action, Map<String, Object?> params) {
  if (action == 'purchase_pack') {
    final double price = (params['price'] as num? ?? 0).toDouble();
    return 'Buy ${params['pack']} for \$${price.toStringAsFixed(2)}. '
        'This spends real money and cannot be undone.';
  }
  return 'Run $action.';
}

/* ── The page ────────────────────────────────────────────────────────────── */

class ConsolePage extends StatelessWidget {
  const ConsolePage({super.key});

  @override
  Widget build(BuildContext context) {
    final DsCategoryHit here = findCategory('agent', 'console');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsPageHeader(
          // DRIFT 1.
          eyebrow: '${here.group.title} · Components',
          title: here.category.title,
          blurb: here.category.blurb,
          // DRIFT 2 and 3 — six chips, a different order, two with no anchor.
          contents: here.category.contents,
        ),
        // `className="mb-12"` — 48px, above the first section rather than
        // inside it.
        Padding(
          padding: EdgeInsets.only(bottom: ds(12)),
          child: const DsNote(
            title: 'This is running',
            child: _OpeningNote(),
          ),
        ),
        const _LiveSection(),
        const _TransportSection(),
        const _FeaturesSection(),
        const _LauncherSection(),
        const DsPageFootNav(groupId: 'agent', slug: 'console'),
      ],
    );
  }
}

class _OpeningNote extends StatelessWidget {
  const _OpeningNote();

  @override
  Widget build(BuildContext context) => DsRichText(
        TextSpan(
          children: <InlineSpan>[
            const TextSpan(
              text: 'Nothing on this page is a screenshot. The console below is '
                  'the real component on a scripted transport, so every state '
                  'is reachable by typing. Ask it ',
            ),
            _em(context, 'what is left'),
            const TextSpan(text: ' and it searches. Ask it to '),
            _em(context, 'export'),
            const TextSpan(
              text: ' and it hands back a file. Ask it to ',
            ),
            _em(context, 'buy'),
            const TextSpan(
              text: ' something and it stops and asks you first. Ask about a ',
            ),
            _em(context, 'price'),
            const TextSpan(text: ' and it fails, on purpose.'),
          ],
        ),
        DsType.small,
      );
}

/// `<em>` — italic, inheriting everything else from the sentence.
InlineSpan _em(BuildContext context, String text) => TextSpan(
      text: text,
      style: const TextStyle(fontStyle: FontStyle.italic),
    );

/* ── #live ───────────────────────────────────────────────────────────────── */

class _LiveSection extends StatelessWidget {
  const _LiveSection();

  @override
  Widget build(BuildContext context) => const DsSection(
        id: 'live',
        title: 'The console',
        description: 'Transcript, composer, face and voice in one component. It '
            'owns the conversation and nothing else — the persona, the tools, '
            'the models and the agent itself all arrive as props.',
        child: DsPanel(flush: true, child: LiveConsole()),
      );
}

/// `LiveConsole` — *"the console, live."* `className="h-152"`.
class LiveConsole extends StatefulWidget {
  const LiveConsole({super.key});

  /// `h-152` — 608px.
  static double get height => ds(152);

  @override
  State<LiveConsole> createState() => _LiveConsoleState();
}

class _LiveConsoleState extends State<LiveConsole> {
  final DsMockTransport _transport = DsMockTransport();

  @override
  void dispose() {
    _transport.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DsAgentConsole(
        transport: _transport,
        persona: kVaultPersona,
        toolStates: kVaultToolStates,
        commands: kVaultCommands,
        models: kVaultModels,
        describeApproval: describeVaultApproval,
        height: LiveConsole.height,
      );
}

/* ── #transport ──────────────────────────────────────────────────────────── */

class _TransportSection extends StatelessWidget {
  const _TransportSection();

  @override
  Widget build(BuildContext context) => DsSection(
        id: 'transport',
        title: 'The transport contract',
        description: 'One interface stands between this component and whatever '
            'is actually answering. Implement it and the console points at your '
            'agent; nothing else in the family moves.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DsMeta(
              items: <DsMetaItem>[
                (
                  k: 'turns',
                  v: const TextSpan(
                    text: 'AgentTurn[] — the transcript, in order. Owned by the '
                        'transport so it can settle its own tool calls.',
                  ),
                ),
                (
                  k: 'send',
                  v: const TextSpan(text: '(text, options) => Promise<void>'),
                ),
                (
                  k: 'abort',
                  v: const TextSpan(
                    text: '() => void — the user pressed stop. Not an error.',
                  ),
                ),
                (k: 'reset', v: const TextSpan(text: '() => void')),
                (k: 'isLoading', v: const TextSpan(text: 'boolean')),
                (
                  k: 'isReady',
                  v: const TextSpan(
                    text: 'boolean — false while acquiring a session, socket or '
                        'handler. The composer disables rather than dropping '
                        'the first message.',
                  ),
                ),
                (k: 'error', v: const TextSpan(text: 'Error | null')),
                (
                  k: 'pendingApprovals',
                  v: const TextSpan(
                    text: 'PendingApproval[] — requests held at a gate, keyed by '
                        'turn id.',
                  ),
                ),
                (
                  k: 'capabilities',
                  v: const TextSpan(
                    text: 'TransportCapabilities — attachments, models, '
                        'approvals. Advertised so the console renders only what '
                        'this agent can do.',
                  ),
                ),
                // DRIFT 6 — documented here, absent from the port's own
                // interface, and never called by the console either way.
                (
                  k: 'restore?',
                  v: const TextSpan(
                    text: '(messages) => void — optional. A transport with no '
                        'history behind it omits it, and the console renders no '
                        'history control.',
                  ),
                ),
              ],
            ),
            // `<p className="type-small mt-6">`.
            SizedBox(height: ds(6)),
            DsRichText(
              TextSpan(
                children: <InlineSpan>[
                  DsCode.span('lib/agent/mock-transport.ts'),
                  const TextSpan(
                    text: ' is a complete implementation of all of it, in about '
                        'three hundred lines. Read that before writing a real '
                        'one — everything a live transport must do is written '
                        'down there and nowhere else.',
                  ),
                ],
              ),
              DsType.small,
            ),
          ],
        ),
      );
}

/* ── #features ───────────────────────────────────────────────────────────── */

class _FeaturesSection extends StatelessWidget {
  const _FeaturesSection();

  @override
  Widget build(BuildContext context) => const DsSection(
        id: 'features',
        title: 'Feature flags',
        description: 'Nine switches, all on by default. A console with '
            'everything turned off is still a console — which is the test that '
            'the parts are genuinely separable rather than merely arranged.',
        child: DsPanel(
          label: 'features',
          // DRIFT 4 — nine names listed, eight of them switched off below.
          note: 'avatar · suggestions · toolTrace · microphone · speech · '
              'attachments · commands · models · reset',
          flush: true,
          child: MinimalConsole(),
        ),
      );
}

/// `MinimalConsole` — *"the same console with most of it switched off, to show
/// the flags do work."* `className="h-80"`.
class MinimalConsole extends StatefulWidget {
  const MinimalConsole({super.key});

  /// `h-80` — 320px.
  static double get height => ds(80);

  /// The eight flags the demo turns off. `reset` is the ninth and stays on.
  static const DsAgentFeatures features = DsAgentFeatures(
    avatar: false,
    suggestions: false,
    microphone: false,
    speech: false,
    attachments: false,
    commands: false,
    models: false,
    toolTrace: false,
  );

  @override
  State<MinimalConsole> createState() => _MinimalConsoleState();
}

class _MinimalConsoleState extends State<MinimalConsole> {
  final DsMockTransport _transport = DsMockTransport();

  @override
  void dispose() {
    _transport.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DsAgentConsole(
        transport: _transport,
        persona: const DsAgentPersona(
          name: 'Vault',
          placeholder: 'Ask a question…',
        ),
        toolStates: kVaultToolStates,
        features: MinimalConsole.features,
        height: MinimalConsole.height,
      );
}

/* ── #launcher ───────────────────────────────────────────────────────────── */

class _LauncherSection extends StatelessWidget {
  const _LauncherSection();

  @override
  Widget build(BuildContext context) => DsSection(
        id: 'launcher',
        title: 'Launcher',
        description: 'How the agent appears on a working page: the avatar '
            'itself, in the corner, rather than a button with a label on it. '
            'The thing you click is the thing that then talks to you, and a '
            'glance at it tells you whether it is idle or still working on the '
            'last thing you asked.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const LauncherDemo(),
            SizedBox(height: ds(6)),
            DsRichText(
              TextSpan(
                children: <InlineSpan>[
                  const TextSpan(text: 'The launcher takes the console as '),
                  DsCode.span('children'),
                  const TextSpan(
                    text: ' rather than building one. A launcher that '
                        'constructed its own console would have to know about '
                        'transports, personas and tools — all of which are the '
                        'product’s business — and every product would then fork '
                        'it. This way the entrance is system-owned and what it '
                        'opens is not.',
                  ),
                ],
              ),
              DsType.small,
            ),
          ],
        ),
      );
}

/// `LauncherDemo` — *"the floating launcher, opening the real console in a
/// dialog."*
///
/// The panel is `relative h-56 overflow-hidden rounded-lg border bg-background`
/// and the launcher inside it is `position: fixed`, so it escapes the panel
/// entirely and sits in the viewport's bottom-right corner — which is the joke
/// the panel's own copy makes.
class LauncherDemo extends StatefulWidget {
  const LauncherDemo({super.key});

  /// `h-56` — 224px.
  static double get height => ds(56);

  /// `p-5` on the absolutely-positioned paragraph.
  static double get padding => ds(5);

  @override
  State<LauncherDemo> createState() => _LauncherDemoState();
}

class _LauncherDemoState extends State<LauncherDemo> {
  final DsMockTransport _transport = DsMockTransport();

  @override
  void dispose() {
    _transport.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return SizedBox(
      height: LauncherDemo.height,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: theme.background,
          borderRadius: BorderRadius.circular(DsRadii.lg),
          border: Border.all(color: theme.border, width: DsWidths.hairline),
        ),
        child: Stack(
          children: <Widget>[
            // `absolute inset-x-0 top-0 p-5`.
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Padding(
                padding: EdgeInsets.all(LauncherDemo.padding),
                child: DsText(
                  'The launcher is fixed to the viewport, not to this panel — '
                  'it is sitting in the bottom-right corner of the page you are '
                  'reading. Click it.',
                  DsType.small,
                ),
              ),
            ),
            DsAgentLauncher(
              label: 'Ask the assistant',
              title: 'Vault',
              description: 'Ask about packs, pulls, prices and your wallet.',
              child: DsAgentConsole(
                transport: _transport,
                persona: kVaultPersona,
                toolStates: kVaultToolStates,
                commands: kVaultCommands,
                models: kVaultModels,
                describeApproval: describeVaultApproval,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
