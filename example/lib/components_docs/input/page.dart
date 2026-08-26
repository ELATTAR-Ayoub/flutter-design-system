/// Public documentation page for the `input` component.
///
/// **Re-housed onto the kit.** This page used to be `InputDocPage`,
/// hand-composing `ElSection` panels inside
/// `example/lib/components_docs/input_select_pages.dart` and living outside
/// `componentDocs`. It now declares a `ComponentDocSpec`
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// `ComponentDocPage`, the same shape `button`, `field` and `checkbox`
/// already carry. Every specimen widget and every code string below is the
/// same one the hand-composed page carried (`_InputPreview`,
/// `_FieldCompanionPreview`, `_InputReadOnlyBarePreview`, `_TogglePill`);
/// only where they live changed.
///
/// **Section order**, matching the house shape: Preview, Installation,
/// Usage (the smallest correct construction, code-only — the old page's
/// live "Field companion" and "Read-only and bare" examples move to their
/// own sections below it, since `SnippetSection` carries no live specimen),
/// Field companion, Read-only & Bare, then the eight disclosures. New: a
/// Keyboard disclosure, between Accessibility and Responsive — `input.dart`
/// wires no key handling of its own, and that absence is exactly what the
/// section says.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import 'meta.dart';

final ComponentDocSpec inputDocSpec = ComponentDocSpec(
  name: 'input',
  title: inputDoc.title,
  description: inputDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'Toggle Invalid, Disabled, Read only, and Seeded value to see '
          'the socket, focus ring, and helper copy behave together. The '
          'label is visible external ElField label; the placeholder '
          'disappears as soon as the field has a value.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'input has a real registry manifest: elattar add input '
          'installs lib/src/components/input.dart and resolves button, '
          'field, machine-surface, and source-foundation automatically. '
          'The Manual tab is for a project not using the CLI.',
      command: inputDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/input.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/input.dart's generated "
              '@ui/input.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated input source here when using manual '
              'mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ElInput, ElFieldSurface, and '
              'ElFieldVisibility are reachable the same way the CLI path '
              'already makes them.',
          code: "export 'input.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct composition: ElField supplies the visible '
          'label, description, and error copy around the socket.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'field-companion',
      title: 'Field companion',
      description:
          'The default pattern for forms and settings pages: ElField '
          'supplies the label and description, ElInput is the socket.',
      specimen: _FieldCompanionPreview(),
      code: _fieldCompanionCode,
      label: 'Field companion specimen view',
    ),
    ShowcaseSection(
      id: 'read-only-bare',
      title: 'Read-only & Bare',
      description:
          'readOnly is mostly semantic: the value stays selectable. bare '
          'removes the socket surface entirely, for a grouped or '
          'wrapper-owned layout such as ElInputGroup.',
      specimen: _ReadOnlyBareSpecimen(),
      code: _readOnlyBareCode,
      label: 'Read-only and bare specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter ElInput declares, plus the two '
          'supporting classes it exports: ElFieldSurface (the pill, its '
          'socket, and the one ring it ever draws) and ElFieldVisibility '
          '(the keyboard-avoidance wrapper every field in the family '
          'uses).',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'ElInput', anchor: 'api-elinput'),
        DocsTocEntry(title: 'ElFieldSurface', anchor: 'api-elfieldsurface'),
        DocsTocEntry(
          title: 'ElFieldVisibility',
          anchor: 'api-elfieldvisibility',
        ),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Read off _ElInputState.build and ElFieldSurface.build, not '
          'inferred: the socket carries no hover state at all — it is a '
          'sunken field you type into, never a control that rises.',
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
      description:
          'input.dart wires no key handling of its own: every fact here '
          'is about what does NOT happen, read off _ElInputState.build '
          'directly.',
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
            value: inputDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/inputs_test.dart',
            description:
                'ElInput is covered there (112 ElInput references at the '
                'time this page was written).',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/input_test.dart',
            description:
                'Covers this page: the article mounts, every ElInput '
                'constructor parameter this page claims to document, and '
                'both themes at two viewport widths.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/input/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class InputDocPage extends StatelessWidget {
  const InputDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: inputDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: inputDoc.title,
      description: inputDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Input'),
    ],
    toc: inputDocSpec.toc,
    previous: const DocsPageLink(title: 'Icon', route: '/components/icon'),
    next: const DocsPageLink(
      title: 'Input group',
      route: '/components/input_group',
    ),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('input-doc-article'),
      child: ComponentDocPage(spec: inputDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */
// Carried unchanged from the old input_select_pages.dart: the same
// `_InputPreview`/`_InputPreviewState`, `_FieldCompanionPreview`,
// `_InputReadOnlyBarePreview` and `_TogglePill` classes, renamed only to
// match this page's own specimen naming.

class _PreviewSpecimen extends StatefulWidget {
  const _PreviewSpecimen();

  @override
  State<_PreviewSpecimen> createState() => _PreviewSpecimenState();
}

class _PreviewSpecimenState extends State<_PreviewSpecimen> {
  bool _invalid = false;
  bool _disabled = false;
  bool _readOnly = false;
  bool _showValue = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Wrap(
          spacing: el(2),
          runSpacing: el(2),
          children: <Widget>[
            _TogglePill(
              selected: _invalid,
              label: 'Invalid',
              onPressed: () => setState(() => _invalid = !_invalid),
            ),
            _TogglePill(
              selected: _disabled,
              label: 'Disabled',
              onPressed: () => setState(() => _disabled = !_disabled),
            ),
            _TogglePill(
              selected: _readOnly,
              label: 'Read only',
              onPressed: () => setState(() => _readOnly = !_readOnly),
            ),
            _TogglePill(
              selected: _showValue,
              label: 'Seeded value',
              onPressed: () => setState(() => _showValue = !_showValue),
            ),
          ],
        ),
        SizedBox(height: el(5)),
        ElField(
          label: 'Email',
          description:
              'Visible labels carry the durable meaning. Placeholders only '
              'help while the field is empty.',
          errors: _invalid
              ? const <String>['That address is missing a valid domain.']
              : const <String>[],
          child: ElInput(
            key: ValueKey<String>(
              'input-preview:$_invalid:$_disabled:$_readOnly:$_showValue',
            ),
            label: 'Email',
            hint: _invalid ? 'That address is missing a valid domain.' : null,
            placeholder: 'you@example.com',
            initialValue: _showValue ? 'collector@pulls.xyz' : null,
            enabled: !_disabled,
            readOnly: _readOnly,
            invalid: _invalid,
          ),
        ),
      ],
    );
  }
}

const String _previewCode = '''ElField(
  label: 'Email',
  description: 'Visible labels carry the durable meaning.',
  errors: invalid ? ['That address is missing a valid domain.'] : [],
  child: ElInput(
    label: 'Email',
    placeholder: 'you@example.com',
    initialValue: seeded ? 'collector@pulls.xyz' : null,
    enabled: !disabled,
    readOnly: readOnly,
    invalid: invalid,
  ),
)''';

const String _usageCode = '''ElField(
  label: 'Email',
  description: 'We will send updates only when something changes.',
  child: ElInput(
    label: 'Email',
    placeholder: 'you@example.com',
  ),
)''';

class _FieldCompanionPreview extends StatelessWidget {
  const _FieldCompanionPreview();

  @override
  Widget build(BuildContext context) {
    return ElField(
      label: 'Display name',
      description: 'Shown publicly on your profile.',
      child: const ElInput(label: 'Display name', initialValue: 'Astra Vale'),
    );
  }
}

const String _fieldCompanionCode = '''ElField(
  label: 'Display name',
  description: 'Shown publicly on your profile.',
  child: ElInput(
    label: 'Display name',
    initialValue: 'Astra Vale',
  ),
)''';

class _ReadOnlyBareSpecimen extends StatelessWidget {
  const _ReadOnlyBareSpecimen();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const ElField(
          label: 'Wallet address',
          description: 'Copyable, but not editable.',
          child: ElInput(
            label: 'Wallet address',
            initialValue: '0xA71c…4F2b',
            readOnly: true,
          ),
        ),
        SizedBox(height: el(5)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: el(4), vertical: el(2)),
          decoration: BoxDecoration(
            color: ElTheme.of(context).muted,
            borderRadius: BorderRadius.circular(ElRadii.lg),
            border: Border.all(
              color: ElTheme.of(context).border,
              width: ElWidths.hairline,
            ),
          ),
          child: const ElInput(
            placeholder: 'Search packs',
            label: 'Search packs',
            bare: true,
          ),
        ),
      ],
    );
  }
}

const String _readOnlyBareCode = '''const ElField(
  label: 'Wallet address',
  description: 'Copyable, but not editable.',
  child: ElInput(
    label: 'Wallet address',
    initialValue: '0xA71c… 4F2b',
    readOnly: true,
  ),
)

// Inside a grouped or wrapper-owned surface:
const ElInput(
  placeholder: 'Search packs',
  label: 'Search packs',
  bare: true,
)''';

class _TogglePill extends StatelessWidget {
  const _TogglePill({
    required this.selected,
    required this.label,
    required this.onPressed,
  });

  final bool selected;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElButton(
      variant: selected ? ElButtonVariant.primary : ElButtonVariant.secondary,
      size: ElButtonSize.sm,
      label: label,
      onPressed: onPressed,
      child: ElText(label, ElComponentType.buttonLabel),
    );
  }
}

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elinput',
        child: DocsApiTable(title: 'ElInput', facts: _inputFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elfieldsurface',
        child: DocsApiTable(
          title: 'ElFieldSurface',
          facts: _fieldSurfaceFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elfieldvisibility',
        child: DocsApiTable(
          title: 'ElFieldVisibility',
          facts: _fieldVisibilityFacts,
        ),
      ),
    ],
  );
}

const List<DocsApiFact> _inputFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'controller',
    type: 'TextEditingController?',
    description:
        'Optional. Supply one to read or seed the value externally; '
        'otherwise the field owns its own and disposes it. Mutually '
        'exclusive with initialValue (asserted).',
  ),
  DocsApiFact(
    name: 'initialValue',
    type: 'String?',
    description:
        'Optional. Seeds the field\'s own controller once, on creation; '
        'a later change to it does nothing.',
  ),
  DocsApiFact(
    name: 'focusNode',
    type: 'FocusNode?',
    description:
        'Optional. Supply one to drive focus from outside. A '
        'ElFieldScope\'s node wins over the owned one and loses to this.',
  ),
  DocsApiFact(
    name: 'placeholder',
    type: 'String?',
    description:
        'Optional. Shown whenever the value is empty, focused or not.',
  ),
  DocsApiFact(
    name: 'onChanged',
    type: 'ValueChanged<String>?',
    description: 'Optional. Called on every edit.',
  ),
  DocsApiFact(
    name: 'onSubmitted',
    type: 'ValueChanged<String>?',
    description: 'Optional. Called when the field is submitted.',
  ),
  DocsApiFact(
    name: 'enabled',
    type: 'bool',
    description:
        'Optional. Defaults to true. ANDed with the enclosing '
        'ElFieldScope\'s. Opacity drops to 45% and input is ignored '
        'when false.',
  ),
  DocsApiFact(
    name: 'readOnly',
    type: 'bool',
    description:
        'Optional. Defaults to false. The value stays selectable but not '
        'editable. Carries no visual treatment of its own.',
  ),
  DocsApiFact(
    name: 'invalid',
    type: 'bool',
    description:
        'Optional. Defaults to false. ORed with the enclosing '
        'ElFieldScope\'s. The single switch for the destructive border, '
        'ring, and SemanticsValidationResult.invalid — and it beats '
        'focus at equal specificity.',
  ),
  DocsApiFact(
    name: 'obscureText',
    type: 'bool',
    description: 'Optional. Defaults to false. Password-style entry.',
  ),
  DocsApiFact(
    name: 'keyboardType',
    type: 'TextInputType?',
    description: 'Optional. What the software keyboard opens as.',
  ),
  DocsApiFact(
    name: 'autofillHints',
    type: 'List<String>?',
    description: 'Optional. Autofill hints for the platform keyboard.',
  ),
  DocsApiFact(
    name: 'textSpec',
    type: 'ElTypeSpec?',
    description:
        'Optional. Defaults to ElComponentType.sheetBody. The .type-* '
        'class stacked on the field\'s own text-sm.',
  ),
  DocsApiFact(
    name: 'label',
    type: 'String?',
    description:
        'Optional. The accessible name for a field with no visible '
        'external ElField label.',
  ),
  DocsApiFact(
    name: 'hint',
    type: 'String?',
    description:
        'Optional. aria-describedby folded into Semantics(hint:) — the '
        'description, then the error, in that order.',
  ),
  DocsApiFact(
    name: 'bare',
    type: 'bool',
    description:
        'Optional. Defaults to false. Removes the socket surface '
        'entirely, for a grouped or wrapper-owned layout such as '
        'ElInputGroup.',
  ),
  DocsApiFact(
    name: 'padding',
    type: 'EdgeInsetsGeometry?',
    description:
        "Optional. Overrides the socket's own 16/4px padding. "
        'ElInputGroupInput computes it; nothing else should need to.',
  ),
  DocsApiFact(
    name: 'boxHeight',
    type: 'double?',
    description:
        'Optional. Overrides the fixed 40px height. SidebarInput\'s own '
        '32px field is the one real caller.',
  ),
  DocsApiFact(
    name: 'fill',
    type: 'Color?',
    description:
        "Optional. Overrides the socket's theme.card fill. "
        "SidebarInput sinks it to theme.background instead.",
  ),
  DocsApiFact(
    name: 'flat',
    type: 'bool',
    description:
        'Optional. Defaults to false. Drops the permanent pressed '
        'shadow, keeping the focus ring.',
  ),
  DocsApiFact(
    name: 'radius',
    type: 'BorderRadius?',
    description:
        'Optional. Overrides the socket\'s pill radius. The agent '
        'history card\'s inline rename field is the one real caller.',
  ),
  DocsApiFact(
    name: 'ElInput.height',
    type: 'static double',
    description: 'The fixed 40px socket height, before boxHeight overrides.',
  ),
  DocsApiFact(
    name: 'ElInput.insets',
    type: 'static EdgeInsets',
    description: "The field's own 16/4px padding, before padding overrides.",
  ),
];

const List<DocsApiFact> _fieldSurfaceFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'radius',
    type: 'BorderRadius',
    description: 'Required. The socket\'s corner radius.',
  ),
  DocsApiFact(
    name: 'focused',
    type: 'bool',
    description: 'Required. Drives the border/ring focus treatment.',
  ),
  DocsApiFact(
    name: 'invalid',
    type: 'bool',
    description:
        'Required. Beats focused on both properties they share: an '
        'errored field shows no focus ring at all, only its own.',
  ),
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description: 'Required. The padded content the socket wraps.',
  ),
  DocsApiFact(
    name: 'fill',
    type: 'Color?',
    description: 'Optional. Overrides the socket\'s theme.card fill.',
  ),
  DocsApiFact(
    name: 'flat',
    type: 'bool',
    description:
        'Optional. Defaults to false. Drops the permanent pressed '
        'shadow, keeping the ring.',
  ),
  DocsApiFact(
    name: 'ElFieldSurface.selectionAlpha',
    type: 'static const double',
    description:
        '0.35 — the text-selection wash every field in the family '
        'shares, so no one field can drift from another.',
  ),
];

const List<DocsApiFact> _fieldVisibilityFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'focusNode',
    type: 'FocusNode',
    description:
        'Required. The node whose focus decides when to reveal the '
        'field above the software keyboard.',
  ),
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description: 'Required. Returned unchanged: this widget owns no '
        'render object of its own.',
  ),
  DocsApiFact(
    name: 'ElFieldVisibility.margin',
    type: 'static double',
    description: 'The clearance left between the field and the keyboard.',
  ),
  DocsApiFact(
    name: 'ElFieldVisibility.travel',
    type: 'static Duration',
    description: 'How long the reveal scroll takes.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Default',
    treatment:
        'Sunken card-coloured socket, permanent shadow-pressed, no '
        'hover state at all: it is a socket, and it never rises.',
    userSignal: 'The field is editable and ready for text entry.',
  ),
  DocsStateFact(
    state: 'Focused',
    treatment:
        'Border tints theme.primary at 50% and a ring springs in at '
        'theme.ring 35%, added to the permanent socket shadow rather '
        'than replacing it. 250ms on ease-out.',
    userSignal: 'A visible ring without the socket lifting.',
  ),
  DocsStateFact(
    state: 'Invalid',
    treatment:
        'Destructive border and a destructive-tinted ring replace the '
        'focus styling outright — invalid beats focus even when both '
        'are true.',
    userSignal: 'The field needs correction, announced as '
        'SemanticsValidationResult.invalid.',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment: 'Opacity drops to 45%; IgnorePointer kills input.',
    userSignal: 'The control cannot be changed in the current context.',
  ),
  DocsStateFact(
    state: 'Read-only',
    treatment:
        'No visual treatment of its own in input.dart; the value stays '
        'selectable and editing is refused.',
    userSignal: 'The content is real and copyable, but not editable.',
  ),
  DocsStateFact(
    state: 'Bare',
    treatment:
        'The socket surface is not built at all: no border, no shadow, '
        'no ring, no fixed height.',
    userSignal: 'Use only inside a higher-level composition such as '
        'ElInputGroup.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'A Semantics(textField: true) node mounts whenever label, hint, '
            'or invalid is set, merging the accessible name, description, '
            'and validation result into one node a screen reader hears '
            'as one thing.',
        'Use a visible ElFieldLabel for production forms; placeholders '
            'disappear as soon as the user types and never substitute '
            'for a label.',
        'invalid publishes SemanticsValidationResult.invalid, never '
            '.valid on a clean field: the web equivalent emits '
            'aria-invalid="false" on a valid field, which announces '
            'nothing, and this port matches that silence.',
        'readOnly is semantic first (Semantics.readOnly): users can '
            'still select and copy the value.',
        'ElFieldVisibility keeps a focused field above the software '
            'keyboard on every platform that has one — a USER-ORDERED '
            'mobile adaptation with no reference precedent.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No custom key handling: EditableText supplies the platform\'s '
            'normal caret, selection, and IME behaviour, and input.dart '
            'adds nothing on top of it.',
        'onSubmitted forwards whatever EditableText reports (typically '
            'the platform\'s enter/done action); nothing here intercepts '
            'a key press directly.',
        'Tab order follows FocusNode\'s default traversal: input.dart '
            'wires no FocusTraversalPolicy of its own.',
        'A tap on the field requests the keyboard and lands the caret '
            'at the end of the value; EditableText itself handles no '
            'pointer gesture, so this file wires the GestureDetector '
            'that does.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No breakpoint branching anywhere in input.dart: the field '
            'fills whatever width the caller allows (SizedBox(width: '
            'double.infinity)), the same widget tree at 390px and '
            '1440px.',
        'ElFieldVisibility is the one adaptation that reads the '
            'viewport: MediaQuery.viewInsets.bottom, gated to only ever '
            'run while a software keyboard is actually on screen. A '
            'desktop frame with no keyboard is byte-identical.',
        'Every measurement (height, insets) is a fixed 4px-grid value, '
            'never scaled by density or text-scale settings.',
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
            label: 'Registry item',
            value: 'registry/components/input.json',
            description: 'Installable through the CLI today.',
          ),
          const DocsInstallFact(
            label: 'Destination',
            value: 'lib/components/ui/input.dart',
            description:
                'The same lib/components/ui/ target every component '
                'installs to.',
          ),
          DocsInstallFact(
            label: 'Dependencies',
            value: inputDoc.dependencies.join(', '),
            description:
                "The manifest's registryDependencies, resolved "
                'automatically. button supplies ElButton.withFocusRing, '
                'the shared focus-ring compositor this file and '
                'button.dart both reach for.',
          ),
          const DocsInstallFact(
            label: 'Best companion',
            value: 'ElField',
            description:
                'Supplies the visible label, description, and error '
                'copy around the socket; input.dart reads its scope '
                'directly (ElFieldScope.maybeOf).',
          ),
        ],
      ),
      SizedBox(height: el(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Field', route: '/components/field'),
          DocsLink(label: 'Button', route: '/components/button'),
          DocsLink(
            label: 'Machine Surface',
            route: '/components/machine_surface',
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
        label: 'theme.card',
        value: 'Socket fill',
        description: 'Overridable per call site with fill.',
      ),
      DocsInstallFact(
        label: 'theme.input',
        value: 'Border at rest',
        description: 'Replaced by theme.primary at 50% while focused.',
      ),
      DocsInstallFact(
        label: 'theme.primary / theme.ring',
        value: 'Focus border / ring',
        description: 'Both spring in over 250ms on ease-out.',
      ),
      DocsInstallFact(
        label: 'theme.destructive',
        value: 'Invalid border and ring',
        description:
            'The bare field declares no dark: variant, so the alpha is '
            'the same in both themes.',
      ),
      DocsInstallFact(
        label: 'theme.mutedForeground',
        value: 'Placeholder ink',
        description: 'Full opacity, not the 60% the source docstring once '
            'claimed — a documented drift.',
      ),
      DocsInstallFact(
        label: 'theme.foreground',
        value: 'Typed text and caret',
        description:
            'input { color: inherit } on the web; ElText.styleOf(context, '
            'spec) with no explicit colour is how this port spells that.',
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
