/// `/design-system/components/agent/composer` — everything below the
/// transcript.
///
/// Five sections and four live composers. **Nothing on this page is a
/// picture**: a reader can type into any of them and watch the box grow, open
/// the slash palette by typing `/` and walk it with the arrow keys, open the
/// plus menu, take the attachment back out of the tray, and see busy and
/// disabled differ in the two things they actually differ in — which button
/// the right-hand slot holds, and whether the input is dimmed.
///
/// ## Drift register — recorded, shipped as written
///
///  1. **The eyebrow says "Components" where every base page says "Base".**
///     `` `${group.title} · Components` `` with `group.title = "Agent"`, so
///     this family's pages read *"Agent · Components"* against the base
///     family's *"Base Components · Base"*. Two different templates for one
///     eyebrow.
///  2. **The chip list promises two sections the page does not have.**
///     `nav.ts` gives this category `["Composer", "Attach menu", "Slash
///     palette", "Dictation", "Model picker"]`; the page renders `rest`,
///     `states`, `attachments`, `slash` and `props`. **Dictation** and **Model
///     picker** have no section behind them at all, and *"Attach menu"* has
///     none either — the plus is only visible inside the composers. This is the
///     exact bug the selects page's own §6 is a postmortem of, one family over,
///     and `nav.dart` already carries the list verbatim.
///  3. **The slash-palette section shows almost no slash palette.** §4's Panel
///     holds a paragraph, and the note says *"type / in any composer above"* —
///     so the only way to see the component this section documents is to scroll
///     back up. *(Probed: doing that shows the bottom **56px** of a 256px
///     panel, because `bottom-full` lifts it clear out of a Panel card that is
///     `overflow-hidden`.)* The port reproduces both halves: the paragraph, and
///     the clipping.
///  4. **`Panel note="idle"` is the only status any composer here declares**,
///     and it is on the one composer that is neither busy nor disabled — so the
///     word describes the absence of the other two rather than a state the
///     component has.
///  5. **The Props table documents `value / onChange` and `inputRef`**, which
///     this port collapses into one `TextEditingController`. The rows are
///     reproduced verbatim anyway: they describe the reference's API, and the
///     port note that reconciles them lives on `DsAgentComposer` itself.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../kit.dart';
import '../nav.dart';

/* ── Fixtures ────────────────────────────────────────────────────────────── */

/// `PERSONA.placeholder` from `agent-demo.tsx` — the one field of the persona
/// this page's specimen reads.
const String _placeholder = 'Ask about a pack, a pull or your balance…';

/// `COMMANDS` from `agent-demo.tsx`, verbatim — three skills and one command,
/// each carrying the glyph its capability carries everywhere else.
const List<DsAgentCommand> _commands = <DsAgentCommand>[
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

/// The one attachment `ComposerSpecimen` seeds when `withAttachment` is set.
const DsAgentAttachment _seeded = DsAgentAttachment(
  id: 'spec-upload',
  name: 'collection-export.csv',
  mime: 'text/csv',
  kind: DsAgentAttachmentKind.data,
  size: 18422,
  delivery: DsAgentDelivery.content(),
);

/* ── The specimen ────────────────────────────────────────────────────────── */

/// `ComposerSpecimen` (`agent-demo.tsx` L686) — the real component, holding its
/// own draft and its own attachment list.
///
/// *"Nothing here is a mock-up. Every specimen is the real component; what is
/// faked is only what is behind it."*
class ComposerSpecimen extends StatefulWidget {
  const ComposerSpecimen({
    super.key,
    this.busy = false,
    this.disabled = false,
    this.withAttachment = false,
  });

  final bool busy;
  final bool disabled;
  final bool withAttachment;

  @override
  State<ComposerSpecimen> createState() => _ComposerSpecimenState();
}

class _ComposerSpecimenState extends State<ComposerSpecimen> {
  final TextEditingController _controller = TextEditingController();
  late List<DsAgentAttachment> _attachments = widget.withAttachment
      ? <DsAgentAttachment>[_seeded]
      : <DsAgentAttachment>[];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DsAgentComposer(
      controller: _controller,
      // `onSubmit={() => setValue("")}` — the specimen has nowhere to send it,
      // so sending is emptying.
      onSubmit: _controller.clear,
      onStop: () {},
      busy: widget.busy,
      disabled: widget.disabled,
      placeholder: _placeholder,
      commands: _commands,
      attachments: _attachments,
      onAttach: (List<DsAgentAttachment> files) => setState(
        () => _attachments = <DsAgentAttachment>[..._attachments, ...files],
      ),
      onRemoveAttachment: (String id) => setState(
        () => _attachments = _attachments
            .where((DsAgentAttachment a) => a.id != id)
            .toList(),
      ),
    );
  }
}

/* ── The page ────────────────────────────────────────────────────────────── */

class ComposerPage extends StatelessWidget {
  const ComposerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DsCategoryHit here = findCategory('agent', 'composer');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsPageHeader(
          // DRIFT 1 — "Components", not "Base".
          eyebrow: '${here.group.title} · Components',
          title: here.category.title,
          blurb: here.category.blurb,
          // DRIFT 2 — five chips, three of which name no section.
          contents: here.category.contents,
        ),
        const _RestSection(),
        const _StatesSection(),
        const _AttachmentsSection(),
        const _SlashSection(),
        const _PropsSection(),
        const DsPageFootNav(groupId: 'agent', slug: 'composer'),
      ],
    );
  }
}

/* ── §1 · at rest ────────────────────────────────────────────────────────── */

class _RestSection extends StatelessWidget {
  const _RestSection();

  @override
  Widget build(BuildContext context) {
    return const DsSection(
      id: 'rest',
      title: 'At rest',
      description: 'Grows to fit as you type, up to a cap, then scrolls. Enter '
          'sends and Shift-Enter breaks the line — the convention every chat '
          'surface has agreed on, and breaking it is a novelty nobody asked '
          'for.',
      child: DsPanel(
        label: 'Composer',
        // DRIFT 4.
        note: 'idle',
        child: ComposerSpecimen(),
      ),
    );
  }
}

/* ── §2 · busy and disabled ──────────────────────────────────────────────── */

class _StatesSection extends StatelessWidget {
  const _StatesSection();

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'states',
      title: 'Busy and disabled',
      description: 'Two different facts, drawn differently. Busy means the '
          'agent is answering and send becomes stop. Disabled means the '
          'transport is not ready to carry a message at all — which the '
          'composer says by refusing input rather than by dropping the first '
          'message on the floor.',
      // `flex flex-col gap-6`.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const DsPanel(
            label: 'Composer',
            note: 'busy — send becomes stop',
            child: ComposerSpecimen(busy: true),
          ),
          SizedBox(height: ds(6)),
          const DsPanel(
            label: 'Composer',
            note: 'disabled — transport not ready',
            child: ComposerSpecimen(disabled: true),
          ),
        ],
      ),
    );
  }
}

/* ── §3 · file tray ──────────────────────────────────────────────────────── */

class _AttachmentsSection extends StatelessWidget {
  const _AttachmentsSection();

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'attachments',
      title: 'File tray',
      description: 'Files arrive by picker, by drag-and-drop onto the console, '
          'or by paste. They sit above the input until sent, and each one '
          'states whether its contents can actually travel.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const DsPanel(
            label: 'Composer',
            note: 'one attachment, content delivered',
            child: ComposerSpecimen(withAttachment: true),
          ),
          // `className="mt-6"` on the Note.
          Padding(
            padding: EdgeInsets.only(top: ds(6)),
            child: const DsNote(
              tone: DsNoteTone.value,
              title: 'The border is the drop target',
              child: _DropTargetBody(),
            ),
          ),
        ],
      ),
    );
  }
}

class _DropTargetBody extends StatelessWidget {
  const _DropTargetBody();

  @override
  Widget build(BuildContext context) {
    return DsRichText(
      TextSpan(
        children: <InlineSpan>[
          const TextSpan(text: 'Dragging a file over the console lights '),
          DsCode.span('border-agent bg-agent/8'),
          const TextSpan(
            text: ' on the composer rather than overlaying a dashed rectangle '
                'across the transcript. The transcript is what the user is '
                // `&ldquo;` / `&rdquo;` — real curly quotes.
                'reading; covering it to say “you may drop here” hides the '
                'thing they dropped the file because of.',
          ),
        ],
      ),
      DsType.small,
    );
  }
}

/* ── §4 · slash palette ──────────────────────────────────────────────────── */

class _SlashSection extends StatelessWidget {
  const _SlashSection();

  @override
  Widget build(BuildContext context) {
    return const DsSection(
      id: 'slash',
      title: 'Slash palette',
      description: 'Typing / at the start of the input opens the palette. '
          'Skills are things the agent can do; commands run in the browser. '
          'Both carry the same glyph they carry in the tool chip, so one '
          'capability has one mark everywhere.',
      // DRIFT 3 — the section about the palette holds a paragraph about it.
      child: DsPanel(
        label: 'SlashPalette',
        note: 'type / in any composer above',
        child: _SlashBody(),
      ),
    );
  }
}

class _SlashBody extends StatelessWidget {
  const _SlashBody();

  @override
  Widget build(BuildContext context) {
    return DsRichText(
      TextSpan(
        children: <InlineSpan>[
          const TextSpan(
            text: 'The palette is filtered by what follows the slash and is '
                'anchored to the composer rather than portalled, so it moves '
                'with the input as it grows. ',
          ),
          DsCode.span('filterCommands'),
          const TextSpan(text: ' and '),
          DsCode.span('slashQuery'),
          const TextSpan(
            text: ' are exported separately — the matching is a pure function '
                'and can be tested without a DOM.',
          ),
        ],
      ),
      DsType.small,
    );
  }
}

/* ── §5 · props ──────────────────────────────────────────────────────────── */

class _PropsSection extends StatelessWidget {
  const _PropsSection();

  @override
  Widget build(BuildContext context) {
    return const DsSection(
      id: 'props',
      title: 'Props',
      description: 'The composer is controlled and stateless apart from its '
          'own measurement. The console owns the draft, the attachments and '
          'the dictation session, which is what lets a caller compose a '
          'different shell around the same input.',
      child: DsMeta(
        items: <DsMetaItem>[
          // DRIFT 5 — the reference's own API, reproduced as written.
          (
            k: 'value / onChange',
            v: TextSpan(text: 'string — controlled'),
          ),
          (k: 'onSubmit / onStop', v: TextSpan(text: '() => void')),
          (k: 'busy', v: TextSpan(text: 'boolean — send becomes stop')),
          (
            k: 'disabled',
            v: TextSpan(text: 'boolean — transport not ready'),
          ),
          (
            k: 'commands',
            v: TextSpan(text: 'AgentCommand[] — the / palette'),
          ),
          (
            k: 'attachments',
            v: TextSpan(
              text: 'Attachment[] with onAttach and onRemoveAttachment',
            ),
          ),
          (
            k: 'dictation',
            v: TextSpan(
              text: 'Dictation — the live session, from useDictation',
            ),
          ),
          (
            k: 'accessory',
            v: TextSpan(
              text: 'ReactNode — slot for the model picker, left of the '
                  'control row',
            ),
          ),
          (
            k: 'micControl',
            v: TextSpan(
              text: 'ReactNode — supplied by the console because it also '
                  'carries the speech settings',
            ),
          ),
          (
            k: 'inputRef',
            v: TextSpan(
              text: 'RefObject — for callers that write into it from outside, '
                  'like the welcome card arming a skill',
            ),
          ),
        ],
      ),
    );
  }
}
