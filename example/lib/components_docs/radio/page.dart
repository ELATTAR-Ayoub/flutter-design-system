/// Public documentation page for the `radio` (radio group) component.
///
/// **Re-housed onto the kit.** This page used to hand-compose `Section`
/// panels; it now declares a `ComponentDocSpec`
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// `ComponentDocPage`, the same shape `button` established. Every specimen
/// widget and every code string below is the same one the hand-composed page
/// carried; only where it lives changed, plus three live specimens
/// (Description, Choice Card, Fieldset) that were code-only panels before
/// and are genuinely live now, built from the exact same quoted source.
///
/// **Section order**, matching `button`'s own house shape: Preview,
/// Installation, Usage (the smallest correct example only — the fieldset,
/// plan-picker and payout-rhythm compositions the old Usage section also
/// carried now have their own sections below, Composition and Description),
/// then Choice Card, Fieldset, Disabled, Invalid, then the eight
/// disclosures. New: a Keyboard disclosure, between Accessibility and
/// Responsive, carved out of Accessibility's own "Keyboard: tab stop",
/// "Keyboard: arrows" and "Keyboard: activation" rows — the same split
/// `button`'s page makes.
///
/// This page and `selection_control`'s (owned separately) overlap in
/// subject: `selection_control` documents the shared socket/hit-area/focus-
/// ring machinery every selection control composes, this page documents the
/// group semantics — value, roving tab stop, arrow-key traversal — that are
/// specific to a mutually-exclusive set. Nothing here duplicates that page's
/// own angle.
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
import '../../kit.dart' show StateCell;
import 'meta.dart';

final ComponentDocSpec radioDocSpec = ComponentDocSpec(
  name: 'radio',
  title: radioDoc.title,
  description:
      'An exclusive choice among a small, fully visible set of mutually '
      'exclusive options, built from real RadioGroup and RadioGroupItem '
      'widgets.',
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'Six live specimens, all built from real RadioGroup and '
          'RadioGroupItem widgets. Payout rhythm, Focus-visible and Error '
          'are operable: tap an option. Disabled, Disabled (selected) and '
          'Group disabled are deliberately inert; all three are explained '
          'in States below.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'radio is a registry item: elattar add radio resolves it and '
          'its dependencies and copies the source into your project. The '
          'Manual tab is for a project not using the CLI.',
      command: radioDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/radio.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/ui/radio.dart's generated @ui/"
              'radio.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated radio source here when using manual '
              'mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so RadioGroup and RadioGroupItem '
              'are reachable the same way the CLI path already makes '
              'them.',
          code: "export 'radio.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'A bare RadioGroupItem renders no visible text of its own, its '
          'label only supplies the accessible name, the same rule '
          'Checkbox follows. The composed-forms pattern below (see '
          'Composition) pairs a FieldSet and FieldLegend for the '
          'group\'s visible caption with one horizontal Field per item '
          'for each option\'s own visible label.',
      code: _smallestUsageCode,
    ),
    ShowcaseSection(
      id: 'composition',
      title: 'Composition',
      description:
          'The shape every fieldset example on this page builds on: a '
          'RadioGroup owns the value, a FieldSet and FieldLegend '
          'give the group its visible caption, and each option is a '
          'horizontal Field wrapping one RadioGroupItem.',
      specimen: _CompositionSpecimen(),
      code: _fieldSetUsageCode,
      label: 'Composition specimen view',
    ),
    ShowcaseSection(
      id: 'description',
      title: 'Description',
      description:
          'A one-line description per option, the same Field.'
          'description prop Checkbox and every other field-composed '
          'control reads.',
      specimen: _DescriptionSpecimen(),
      code: _descriptionUsageCode,
      label: 'Description specimen view',
    ),
    ShowcaseSection(
      id: 'choice-card',
      title: 'Choice Card',
      description:
          'RadioGroupItem has no card variant of its own, but a Card '
          'wrapping a horizontal Field composes one: the field\'s own '
          'label-tap wiring still selects the item, the card only '
          'supplies the border.',
      specimen: _ChoiceCardSpecimen(),
      code: _choiceCardCode,
      label: 'Choice Card specimen view',
    ),
    ShowcaseSection(
      id: 'fieldset',
      title: 'Fieldset',
      description:
          'The full grouped shape: a FieldSet and FieldLegend for the '
          'group\'s own visible caption, one horizontal Field per '
          'option, and a FieldError row that mounts only once there is '
          'an error to show.',
      specimen: _FieldsetSpecimen(),
      code: _shippingMethodCode,
      label: 'Fieldset specimen view',
    ),
    ShowcaseSection(
      id: 'disabled',
      title: 'Disabled',
      description:
          'onChanged: null disables every item in the group at once, '
          'regardless of each item\'s own enabled flag; live specimens '
          'for this and for a single disabled item are in Preview above.',
      specimen: _DisabledSpecimen(),
      code: _disabledUsageCode,
      label: 'Disabled specimen view',
    ),
    ShowcaseSection(
      id: 'invalid',
      title: 'Invalid',
      description:
          'invalid: true (or a per-item nested field\'s own invalid flag) '
          'paints the destructive border and ring on every item; the live '
          '"Error" specimen in Preview above shows the painted result.',
      specimen: _InvalidSpecimen(),
      code: _invalidUsageCode,
      label: 'Invalid specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Neither RadioGroup nor RadioGroupItem takes a variant or '
          'size parameter: RadioGroupItem.size fixes one 20px geometry, '
          'level with Checkbox, and there is no third "held" state the '
          'way Checkbox has an inert flag.',
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Hover, Pressed, Loading, Empty and Success are omitted below: '
          'reasons follow the table.',
      child: _StatesContent(),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      child: DocsInstallFacts(title: 'Accessibility', facts: _a11yFacts),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      description:
          'Verified against the real implementation rather than assumed: '
          'lib/src/components/ui/radio.dart\'s own _onKey and _RadioGroupState'
          '.moveFrom.',
      child: DocsInstallFacts(title: 'Keyboard', facts: _keyboardFacts),
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
      child: DocsInstallFacts(
        title: 'Tokens this component reads',
        facts: _themingFacts,
      ),
    ),
    DisclosureSection(
      id: 'source',
      title: 'Source',
      child: DocsInstallFacts(
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Component source',
            value: radioDoc.sourcePath,
            description: 'Authoritative implementation.',
          ),
          const DocsInstallFact(
            label: 'Shared machinery',
            value: 'lib/src/components/ui/selection_control.dart',
            description:
                'SelectionControl, HitArea and StateChangeFeedback, shared '
                'with the checkbox and switch families and documented on '
                'their own component pages.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/selection_feedback_test.dart',
            description:
                'State-matrix, arrow-key traversal, roving-tabindex and '
                'field-adoption coverage for RadioGroup and '
                'RadioGroupItem in the package itself.',
          ),
          const DocsInstallFact(
            label: 'Docs page tests',
            value: 'example/test/components_docs/radio_test.dart',
            description:
                'Coverage for this page: API completeness, the live '
                'group specimen selecting and deselecting, and both '
                'themes.',
          ),
        ],
      ),
    ),
  ],
);

class RadioDocPage extends StatelessWidget {
  const RadioDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: radioDoc.route,
    intro: DocsPageIntro(
      title: radioDocSpec.title,
      description: radioDocSpec.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Radio group'),
    ],
    toc: radioDocSpec.toc,
    previous: const DocsPageLink(
      title: 'Native select',
      route: '/components/native_select',
    ),
    next: const DocsPageLink(
      title: 'Selection control',
      route: '/components/selection_control',
    ),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('radio-doc-article'),
      child: ComponentDocPage(spec: radioDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

class _PreviewSpecimen extends StatefulWidget {
  const _PreviewSpecimen();

  @override
  State<_PreviewSpecimen> createState() => _PreviewSpecimenState();
}

class _PreviewSpecimenState extends State<_PreviewSpecimen> {
  String? _payout = 'daily';
  String? _focusValue;
  String? _errorValue = 'daily';

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: space(3),
    runSpacing: space(3),
    children: <Widget>[
      StateCell(
        label: 'Payout rhythm',
        note: 'Tap an option: the previous one deselects',
        child: RadioGroup<String>(
          key: const ValueKey<String>('radio-live-specimen'),
          value: _payout,
          label: 'Payout rhythm',
          onChanged: (String next) => setState(() => _payout = next),
          children: const <Widget>[
            RadioGroupItem<String>(value: 'daily', label: 'Daily'),
            RadioGroupItem<String>(value: 'weekly', label: 'Weekly'),
            RadioGroupItem<String>(value: 'monthly', label: 'Monthly'),
          ],
        ),
      ),
      StateCell(
        label: 'Focus-visible',
        note: 'Ring painted, not focused',
        child: RadioGroup<String>(
          value: _focusValue,
          onChanged: (String next) => setState(() => _focusValue = next),
          children: <Widget>[
            RadioGroupItem<String>(
              value: 'focus',
              forceFocusRing: true,
              label: 'Focus-visible',
            ),
          ],
        ),
      ),
      StateCell(
        label: 'Error',
        note: 'invalid: true',
        child: RadioGroup<String>(
          value: _errorValue,
          invalid: true,
          onChanged: (String next) => setState(() => _errorValue = next),
          children: const <Widget>[
            RadioGroupItem<String>(value: 'daily', label: 'Daily'),
            RadioGroupItem<String>(value: 'weekly', label: 'Weekly'),
          ],
        ),
      ),
      StateCell(
        label: 'Disabled',
        note: 'enabled: false on the item itself',
        child: RadioGroup<String>(
          value: null,
          onChanged: (String _) {},
          children: const <Widget>[
            RadioGroupItem<String>(
              value: 'daily',
              enabled: false,
              label: 'Disabled',
            ),
          ],
        ),
      ),
      StateCell(
        label: 'Disabled (selected)',
        note: 'enabled: false, and it is the group\'s value',
        child: RadioGroup<String>(
          value: 'daily',
          onChanged: (String _) {},
          children: const <Widget>[
            RadioGroupItem<String>(
              value: 'daily',
              enabled: false,
              label: 'Disabled selected',
            ),
          ],
        ),
      ),
      const StateCell(
        label: 'Group disabled',
        note: 'onChanged: null: no item in the group can be operated',
        child: RadioGroup<String>(
          value: 'weekly',
          onChanged: null,
          children: <Widget>[
            RadioGroupItem<String>(value: 'weekly', label: 'Weekly'),
          ],
        ),
      ),
    ],
  );
}

const String _previewCode = '''Wrap(
  spacing: 12,
  runSpacing: 12,
  children: [
    RadioGroup<String>(
      value: payout,
      label: 'Payout rhythm',
      onChanged: (next) => setState(() => payout = next),
      children: const [
        RadioGroupItem<String>(value: 'daily', label: 'Daily'),
        RadioGroupItem<String>(value: 'weekly', label: 'Weekly'),
        RadioGroupItem<String>(value: 'monthly', label: 'Monthly'),
      ],
    ),
    RadioGroup<String>(
      value: null,
      onChanged: (_) {},
      children: const [
        RadioGroupItem<String>(
          value: 'daily',
          enabled: false,
          label: 'Disabled',
        ),
      ],
    ),
    const RadioGroup<String>(
      value: 'weekly',
      onChanged: null,
      children: [RadioGroupItem<String>(value: 'weekly', label: 'Weekly')],
    ),
  ],
)''';

const String _smallestUsageCode = '''String? payout;

RadioGroup<String>(
  value: payout,
  label: 'Payout rhythm',
  onChanged: (String next) => setState(() => payout = next),
  children: const <Widget>[
    RadioGroupItem<String>(value: 'daily', label: 'Daily'),
    RadioGroupItem<String>(value: 'weekly', label: 'Weekly'),
  ],
)''';

/// A live, functioning fieldset-composed radio group: proof the composition
/// Composition and Usage describe actually renders and selects, not just a
/// code excerpt.
class _CompositionSpecimen extends StatefulWidget {
  const _CompositionSpecimen();

  @override
  State<_CompositionSpecimen> createState() => _CompositionSpecimenState();
}

class _CompositionSpecimenState extends State<_CompositionSpecimen> {
  String? _payout;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const FieldLegend('Payout rhythm'),
      SizedBox(height: FieldLegend.spaceBelow),
      FieldSet(
        tightForGroup: true,
        children: <Widget>[
          RadioGroup<String>(
            value: _payout,
            gap: FieldSet.groupGap,
            label: 'Payout rhythm',
            onChanged: (String next) => setState(() => _payout = next),
            children: <Widget>[
              Field(
                label: 'Daily',
                orientation: FieldOrientation.horizontal,
                child: const RadioGroupItem<String>(value: 'daily'),
              ),
              Field(
                label: 'Weekly',
                orientation: FieldOrientation.horizontal,
                child: const RadioGroupItem<String>(value: 'weekly'),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

const String _fieldSetUsageCode = '''String? payout;

Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    const FieldLegend('Payout rhythm'),
    SizedBox(height: FieldLegend.spaceBelow),
    FieldSet(
      tightForGroup: true,
      children: <Widget>[
        RadioGroup<String>(
          value: payout,
          gap: FieldSet.groupGap,
          label: 'Payout rhythm',
          onChanged: (String next) => setState(() => payout = next),
          children: const <Widget>[
            Field(
              label: 'Daily',
              orientation: FieldOrientation.horizontal,
              child: RadioGroupItem<String>(value: 'daily'),
            ),
            Field(
              label: 'Weekly',
              orientation: FieldOrientation.horizontal,
              child: RadioGroupItem<String>(value: 'weekly'),
            ),
          ],
        ),
      ],
    ),
  ],
)''';

class _DescriptionSpecimen extends StatefulWidget {
  const _DescriptionSpecimen();

  @override
  State<_DescriptionSpecimen> createState() => _DescriptionSpecimenState();
}

class _DescriptionSpecimenState extends State<_DescriptionSpecimen> {
  String? _frequency;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const FieldLegend('Digest frequency'),
      SizedBox(height: FieldLegend.spaceBelow),
      FieldSet(
        tightForGroup: true,
        children: <Widget>[
          RadioGroup<String>(
            value: _frequency,
            gap: FieldSet.groupGap,
            label: 'Digest frequency',
            onChanged: (String next) => setState(() => _frequency = next),
            children: <Widget>[
              Field(
                label: 'Daily',
                description: 'One email every morning.',
                orientation: FieldOrientation.horizontal,
                child: const RadioGroupItem<String>(value: 'daily'),
              ),
              Field(
                label: 'Weekly',
                description: 'One email every Monday.',
                orientation: FieldOrientation.horizontal,
                child: const RadioGroupItem<String>(value: 'weekly'),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

const String _descriptionUsageCode = '''String? frequency;

Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    const FieldLegend('Digest frequency'),
    SizedBox(height: FieldLegend.spaceBelow),
    FieldSet(
      tightForGroup: true,
      children: <Widget>[
        RadioGroup<String>(
          value: frequency,
          gap: FieldSet.groupGap,
          label: 'Digest frequency',
          onChanged: (String next) => setState(() => frequency = next),
          children: const <Widget>[
            Field(
              label: 'Daily',
              description: 'One email every morning.',
              orientation: FieldOrientation.horizontal,
              child: RadioGroupItem<String>(value: 'daily'),
            ),
            Field(
              label: 'Weekly',
              description: 'One email every Monday.',
              orientation: FieldOrientation.horizontal,
              child: RadioGroupItem<String>(value: 'weekly'),
            ),
          ],
        ),
      ],
    ),
  ],
)''';

class _ChoiceCardSpecimen extends StatefulWidget {
  const _ChoiceCardSpecimen();

  @override
  State<_ChoiceCardSpecimen> createState() => _ChoiceCardSpecimenState();
}

class _ChoiceCardSpecimenState extends State<_ChoiceCardSpecimen> {
  String? _plan = 'pro';

  @override
  Widget build(BuildContext context) => RadioGroup<String>(
    value: _plan,
    label: 'Plan',
    gap: space(3),
    onChanged: (String next) => setState(() => _plan = next),
    children: <Widget>[
      Card(
        children: <Widget>[
          CardContent(
            child: Field(
              label: 'Free',
              description: 'For trying things out.',
              orientation: FieldOrientation.horizontal,
              child: const RadioGroupItem<String>(value: 'free'),
            ),
          ),
        ],
      ),
      Card(
        children: <Widget>[
          CardContent(
            child: Field(
              label: 'Pro',
              description: 'For a team that ships every week.',
              orientation: FieldOrientation.horizontal,
              child: const RadioGroupItem<String>(value: 'pro'),
            ),
          ),
        ],
      ),
      Card(
        children: <Widget>[
          CardContent(
            child: Field(
              label: 'Vault',
              description: 'For everything that must never move.',
              orientation: FieldOrientation.horizontal,
              child: const RadioGroupItem<String>(value: 'vault'),
            ),
          ),
        ],
      ),
    ],
  );
}

const String _choiceCardCode = '''String? plan = 'pro';

RadioGroup<String>(
  value: plan,
  label: 'Plan',
  gap: space(3),
  onChanged: (String next) => setState(() => plan = next),
  children: <Widget>[
    Card(
      children: <Widget>[
        CardContent(
          child: Field(
            label: 'Free',
            description: 'For trying things out.',
            orientation: FieldOrientation.horizontal,
            child: const RadioGroupItem<String>(value: 'free'),
          ),
        ),
      ],
    ),
    Card(
      children: <Widget>[
        CardContent(
          child: Field(
            label: 'Pro',
            description: 'For a team that ships every week.',
            orientation: FieldOrientation.horizontal,
            child: const RadioGroupItem<String>(value: 'pro'),
          ),
        ),
      ],
    ),
    Card(
      children: <Widget>[
        CardContent(
          child: Field(
            label: 'Vault',
            description: 'For everything that must never move.',
            orientation: FieldOrientation.horizontal,
            child: const RadioGroupItem<String>(value: 'vault'),
          ),
        ),
      ],
    ),
  ],
)''';

class _FieldsetSpecimen extends StatefulWidget {
  const _FieldsetSpecimen();

  @override
  State<_FieldsetSpecimen> createState() => _FieldsetSpecimenState();
}

class _FieldsetSpecimenState extends State<_FieldsetSpecimen> {
  String? _method;
  static const List<String> _errors = <String>[];

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const FieldLegend('Shipping method'),
      SizedBox(height: FieldLegend.spaceBelow),
      FieldSet(
        tightForGroup: true,
        children: <Widget>[
          RadioGroup<String>(
            value: _method,
            gap: FieldSet.groupGap,
            invalid: _errors.isNotEmpty,
            label: 'Shipping method',
            hint: _errors.isEmpty ? null : _errors.join(' '),
            onChanged: (String next) => setState(() => _method = next),
            children: <Widget>[
              Field(
                label: 'Standard, 5 to 7 days',
                orientation: FieldOrientation.horizontal,
                child: const RadioGroupItem<String>(value: 'standard'),
              ),
              Field(
                label: 'Express, 2 days',
                orientation: FieldOrientation.horizontal,
                child: const RadioGroupItem<String>(value: 'express'),
              ),
              Field(
                label: 'Overnight',
                orientation: FieldOrientation.horizontal,
                child: const RadioGroupItem<String>(value: 'overnight'),
              ),
            ],
          ),
          if (_errors.isNotEmpty) FieldError(_errors),
        ],
      ),
    ],
  );
}

const String _shippingMethodCode = '''String? method;
final List<String> errors = <String>[];

Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    const FieldLegend('Shipping method'),
    SizedBox(height: FieldLegend.spaceBelow),
    FieldSet(
      tightForGroup: true,
      children: <Widget>[
        RadioGroup<String>(
          value: method,
          gap: FieldSet.groupGap,
          invalid: errors.isNotEmpty,
          label: 'Shipping method',
          hint: errors.isEmpty ? null : errors.join(' '),
          onChanged: (String next) => setState(() => method = next),
          children: const <Widget>[
            Field(
              label: 'Standard, 5 to 7 days',
              orientation: FieldOrientation.horizontal,
              child: RadioGroupItem<String>(value: 'standard'),
            ),
            Field(
              label: 'Express, 2 days',
              orientation: FieldOrientation.horizontal,
              child: RadioGroupItem<String>(value: 'express'),
            ),
            Field(
              label: 'Overnight',
              orientation: FieldOrientation.horizontal,
              child: RadioGroupItem<String>(value: 'overnight'),
            ),
          ],
        ),
        if (errors.isNotEmpty) FieldError(errors),
      ],
    ),
  ],
)''';

class _DisabledSpecimen extends StatelessWidget {
  const _DisabledSpecimen();

  @override
  Widget build(BuildContext context) => const RadioGroup<String>(
    value: null,
    onChanged: null,
    children: <Widget>[
      RadioGroupItem<String>(value: 'daily', label: 'Daily'),
      RadioGroupItem<String>(value: 'weekly', label: 'Weekly'),
    ],
  );
}

const String _disabledUsageCode = '''RadioGroup<String>(
  value: null,
  onChanged: null,
  children: const <Widget>[
    RadioGroupItem<String>(value: 'daily', label: 'Daily'),
    RadioGroupItem<String>(value: 'weekly', label: 'Weekly'),
  ],
)''';

class _InvalidSpecimen extends StatefulWidget {
  const _InvalidSpecimen();

  @override
  State<_InvalidSpecimen> createState() => _InvalidSpecimenState();
}

class _InvalidSpecimenState extends State<_InvalidSpecimen> {
  String? _method;

  @override
  Widget build(BuildContext context) => RadioGroup<String>(
    value: _method,
    invalid: true,
    hint: 'Choose a shipping method.',
    onChanged: (String next) => setState(() => _method = next),
    children: const <Widget>[
      RadioGroupItem<String>(value: 'standard', label: 'Standard'),
      RadioGroupItem<String>(value: 'express', label: 'Express'),
    ],
  );
}

const String _invalidUsageCode = '''RadioGroup<String>(
  value: method,
  invalid: true,
  hint: 'Choose a shipping method.',
  onChanged: (String next) => setState(() => method = next),
  children: const <Widget>[
    RadioGroupItem<String>(value: 'standard', label: 'Standard'),
    RadioGroupItem<String>(value: 'express', label: 'Express'),
  ],
)''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsApiTable(title: 'RadioGroup<T>', facts: _radioGroupFacts),
      SizedBox(height: space(5)),
      const DocsApiTable(
        title: 'RadioGroupItem<T>',
        facts: _radioGroupItemFacts,
      ),
      SizedBox(height: space(5)),
      const DocsApiTable(title: 'Static helpers', facts: _staticFacts),
    ],
  );
}

const List<DocsApiFact> _radioGroupFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'value',
    type: 'T?',
    description:
        'The selected item, compared against each item\'s own value by '
        '==. null while nothing is chosen.',
  ),
  DocsApiFact(
    name: 'onChanged',
    type: 'ValueChanged<T>?',
    description:
        'Called with the value of whichever item the user picked: by '
        'tap, by Enter/Space on the focused item, or by an arrow key that '
        'moves the selection. null disables every item in the group.',
  ),
  DocsApiFact(
    name: 'children',
    type: 'List<Widget>',
    description:
        'The rows. Each holds a RadioGroupItem<T> somewhere inside it: '
        'either bare, or wrapped in its own Field for a visible '
        'per-option label.',
  ),
  DocsApiFact(
    name: 'gap',
    type: 'double?',
    description:
        'The vertical space between rows. Defaults to '
        'RadioGroup.defaultGap (8px); the composed forms page passes '
        'FieldSet.groupGap (12px) instead.',
  ),
  DocsApiFact(
    name: 'enabled',
    type: 'bool',
    description:
        'Defaults to true. Disables every item; ANDed with the enclosing '
        'FieldScope\'s own enabled flag when the group itself sits in a '
        'Field.',
  ),
  DocsApiFact(
    name: 'invalid',
    type: 'bool',
    description:
        'Defaults to false. true paints the destructive border and ring '
        'on every item. ORed with the enclosing FieldScope\'s own '
        'invalid flag.',
  ),
  DocsApiFact(
    name: 'focusNode',
    type: 'FocusNode?',
    description:
        'The node a failed form submit lands on, adopted from the '
        'enclosing FieldScope when null. The group itself never keeps '
        'this focus: it forwards it straight to the roving tab-stop item, '
        'so a keyboard user always lands on a real, operable radio and '
        'never on the group container.',
  ),
  DocsApiFact(
    name: 'label',
    type: 'String?',
    description:
        'The group\'s accessible name: the legend\'s text, announced as a '
        'whole rather than through `<label for>`: an HTML label may only '
        'point at a labelable element and a radio group container is a '
        'div, so this is the one place the port cannot lean on the '
        'id-graph translation it uses everywhere else.',
  ),
  DocsApiFact(
    name: 'hint',
    type: 'String?',
    description:
        'Read after the label: the aria-describedby analogue for the '
        'group as a whole, resolved through Semantics.hint.',
  ),
];

const List<DocsApiFact> _radioGroupItemFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'value',
    type: 'T',
    description:
        'This item\'s own value. The item renders checked exactly when '
        'the enclosing group\'s value equals this one: there is no '
        'separate checked or state field to set by hand.',
  ),
  DocsApiFact(
    name: 'enabled',
    type: 'bool',
    description:
        'Defaults to true. ANDed with the group\'s own enabled flag and, '
        'when this item sits in its own nested Field, with that '
        'field\'s enabled flag too.',
  ),
  DocsApiFact(
    name: 'invalid',
    type: 'bool',
    description:
        'Defaults to false. ORed with the group\'s invalid flag and, '
        'when this item has its own nested Field, with that field\'s '
        'invalid flag.',
  ),
  DocsApiFact(
    name: 'forceFocusRing',
    type: 'bool?',
    description:
        'true paints the focus ring without owning focus, false '
        'withholds it even while genuinely focused, and null (the '
        'default) follows real focus.',
  ),
  DocsApiFact(
    name: 'label',
    type: 'String?',
    description:
        'This item\'s own accessible name: never the group\'s legend. '
        'Falls back to this item\'s own nested Field\'s label when it '
        'has one, and to nothing when it does not.',
  ),
  DocsApiFact(
    name: 'hint',
    type: 'String?',
    description:
        'This item\'s own aria-describedby analogue, resolved the same '
        'way as label: its own value first, then its own nested field\'s.',
  ),
];

const List<DocsApiFact> _staticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'RadioGroup.defaultGap',
    type: 'static double',
    description:
        'The Root\'s own row gap, 8px, used whenever gap is left '
        'null.',
  ),
  DocsApiFact(
    name: 'RadioGroupItem.size',
    type: 'static double',
    description:
        'The 20px circle: sized to sit level with Checkbox rather than '
        'the reference\'s own smaller default.',
  ),
];

class _StatesContent extends StatelessWidget {
  const _StatesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsStateMatrix(facts: _stateFacts),
      SizedBox(height: space(4)),
      StyledText(
        'Omitted: Hover: no control in this family authors a hover skin; '
        'only the pointer cursor changes. Pressed, there is no separate '
        'pointer-down look; each socket that actually changes value '
        'squashes once, after the change, via StateChangeFeedback: both the '
        'item that becomes selected and the one that was selected a '
        'moment ago squash, because both genuinely changed state. '
        'Loading and Empty, RadioGroup is a synchronous primitive with '
        'no async operation and nothing to list, so neither applies. '
        'Success: the component defines no success semantics of its own.',
        TextStyles.small,
        color: ThemeScope.of(context).mutedForeground,
      ),
    ],
  );
}

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest (unselected)',
    treatment:
        'theme.card fill, theme.input border, pressed-style shadow: '
        'identical socket mechanics to an unchecked checkbox, drawn as a '
        'circle.',
    userSignal: 'An empty 20px ring; no dot is mounted.',
  ),
  DocsStateFact(
    state: 'Selected',
    treatment:
        'theme.primary fill and border; an 8px filled dot mounts and '
        'pops in: scale 0 → 1.35 at 55% → 1 on the spring curve: rather '
        'than fading or drawing a stroke. Mounted only while this item is '
        'the group\'s value, so the pop replays on every real selection '
        'and never on an unrelated rebuild.',
    userSignal:
        'A small raised dot popping into the centre, visible even to a '
        'reader who cannot rely on the fill colour changing.',
  ),
  DocsStateFact(
    state: 'Focus-visible',
    treatment: 'border-ring plus a 3px ring at 50% alpha.',
    userSignal:
        'A visible ring around whichever item holds the group\'s one '
        'roving tab stop: beaten by Error below when both apply.',
  ),
  DocsStateFact(
    state: 'Error',
    treatment:
        'invalid: true (on the item, the group, or a per-item nested '
        'field) swaps the border and ring to the destructive colour at '
        '20% ring alpha.',
    userSignal:
        'aria-invalid beats focus-visible: a focused, invalid item looks '
        'pixel-identical to an unfocused invalid one: reproduced '
        'faithfully from the rest of the selection-control family rather '
        'than "fixed".',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment:
        'Three independent levers land on the same dimmed, deaf '
        'rendering: the group\'s own enabled: false; the group\'s '
        'onChanged: null (which disables every item even when each '
        'item\'s own enabled stays true); or one item\'s own enabled: '
        'false, including through that item\'s own nested Field going '
        'disabled.',
    userSignal:
        '50% opacity, out of the tab order, deaf to pointer and '
        'keyboard: the one state that dims.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'The dot-pop keyframe player fills both ends, so a '
        'reduced-motion context lands directly on the settled 8px dot '
        'instead of playing the overshoot; the socket colour/border/ring '
        'tween collapses to its resolved near-zero duration.',
    userSignal: 'The same end state, with no pop to sit through.',
  ),
];

const List<DocsInstallFact> _a11yFacts = <DocsInstallFact>[
  DocsInstallFact(
    label: 'Semantic role',
    value:
        'Semantics(container:) on the group, '
        'Semantics(inMutuallyExclusiveGroup:, checked:) on each item',
    description:
        'The group carries a container semantics node; each item is '
        'flagged as a member of a mutually exclusive group with its own '
        'checked flag, Flutter\'s nearest primitive to an ARIA radiogroup '
        'and its radios.',
  ),
  DocsInstallFact(
    label: 'Label association',
    value: 'label on the group; label on each item',
    description:
        'The group\'s label (or its own enclosing field\'s) is announced '
        'as the legend for the whole set. Each item\'s own label (or its '
        'own nested field\'s: never the group\'s) is announced as that '
        'one option\'s name. Neither is rendered as visible text on its '
        'own; a FieldSet + FieldLegend gives the group a visible '
        'caption, and a per-item Field gives each option one.',
  ),
  DocsInstallFact(
    label: 'Focus behavior',
    value: 'border-ring plus a 3px ring at 50% alpha',
    description:
        'The group\'s own Focus node (adopted from a FieldScope, e.g. '
        'a failed form submit) skips traversal and immediately forwards '
        'to the tab-stop item rather than holding focus itself: the '
        'group is not itself operable, so a keyboard user always sees '
        'the ring on a real, selectable item.',
  ),
  DocsInstallFact(
    label: 'Label tap: group vs item',
    value:
        'Tapping the group\'s label focuses; tapping an item\'s own '
        'label selects',
    description:
        'A FieldSet + FieldLegend caption over the whole group only '
        'moves focus to the tab-stop item when tapped: a legend cannot '
        'select on behalf of a set it only names. A visible label from '
        'an item\'s own nested Field genuinely selects that one option '
        'when tapped, the same activator wiring an HTML <label for> '
        'click uses.',
  ),
  DocsInstallFact(
    label: 'Touch target',
    value: '42 x 34, centred on each 20 x 20 circle',
    description:
        'HitArea grows the hit test past the painted circle, identical '
        'to Checkbox\'s own measurement, 2px short of the system\'s own '
        '44px floor on both axes, recorded rather than corrected.',
  ),
  DocsInstallFact(
    label: 'Non-colour signal',
    value: 'A raised, popping dot, not just a fill change',
    description:
        'Selecting an item mounts a distinct shape rather than only '
        'recolouring the socket, so the state does not depend on a '
        'reader distinguishing fill colours.',
  ),
  DocsInstallFact(
    label: 'Error wiring',
    value:
        'invalid, ORed across the item, the group, and a per-item '
        'nested field',
    description:
        'A Field around the whole group folds its own invalid flag in '
        'at the group level, reaching every item; a Field around one '
        'item folds in at that item alone.',
  ),
  DocsInstallFact(
    label: 'Screen-reader announcements',
    value: 'No live region',
    description:
        'State changes are exposed purely through the '
        'inMutuallyExclusiveGroup/checked flags on each item\'s merged '
        'semantics node; no extra announcement is authored.',
  ),
];

const List<DocsInstallFact> _keyboardFacts = <DocsInstallFact>[
  DocsInstallFact(
    label: 'Tab stop',
    value: 'The group is one tab stop, not N (roving tabindex)',
    description:
        'Tab reaches the currently selected item, or the first enabled '
        'item when nothing is selected yet; every other item is '
        'focusable but skipped in tab order.',
  ),
  DocsInstallFact(
    label: 'Arrows',
    value: 'Arrow Up/Left and Down/Right move AND select, and they wrap',
    description:
        'Verified against the real implementation rather than assumed: '
        'an arrow key does not just move focus, it calls onChanged with '
        'the destination item\'s value in the same step and moves focus '
        'to it: the full ARIA radiogroup contract, wrapping from the '
        'last enabled item back to the first and back again.',
  ),
  DocsInstallFact(
    label: 'Activation',
    value: 'Enter, numpad Enter, Space',
    description:
        'Selects whichever item currently holds focus. Wired by hand '
        'through Focus.onKeyEvent: the control is not a native button, '
        'so nothing arrives for free.',
  ),
  DocsInstallFact(
    label: 'No custom ordering',
    value: 'No FocusTraversalPolicy of its own',
    description:
        'Tab and Shift+Tab, and which item the roving tab stop names, '
        'walk whatever order the surrounding page (or FieldSet) '
        'already declares. The arrow-key order above is a separate '
        'mechanism from Tab order: it walks _items in registration '
        'order, wrapping.',
  ),
];

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'RadioGroup fills whatever width it is given (a loose, not a '
            'stretching, constraint), but does not stretch its rows to '
            'match: a bare RadioGroupItem stays a fixed 20 x 20 circle '
            'with a fixed 42 x 34 hit area while a Field row placed '
            'beside it still fills the available width: the same '
            'distinction a CSS grid\'s default item-stretch would blur, '
            'made explicit here because the item declares its own size.',
        'What reflows with layout belongs to whatever composes the '
            'group: a FieldSet + FieldLegend wraps its own caption, '
            'and a settings page decides its own row wrapping.',
        'Keyboard activation (Enter/Space, the roving tab stop, and the '
            'arrow keys) and pointer activation behave identically on '
            'every Flutter target this package supports; there is no '
            'platform channel and nothing here is web-only or '
            'desktop-only.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DocsInstallFacts(
        title: 'Dependencies',
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Status',
            value: 'Stable, installable through elattar add radio',
            description:
                'Ported and tested against lib/src/components/ui/radio.dart, '
                'and shipped as a registry item.',
          ),
          const DocsInstallFact(
            label: 'Platforms',
            value: 'Android, iOS, Web, macOS, Windows, Linux',
            description:
                'A pure Flutter widget tree: no platform channel and no '
                'platform-specific branch.',
          ),
          DocsInstallFact(
            label: 'Source file',
            value: radioDoc.sourcePath,
            description: 'The authoritative implementation.',
          ),
          const DocsInstallFact(
            label: 'Local file dependencies',
            value:
                'selection_control.dart, field.dart, '
                'effects/surface.dart, motion/keyframes.dart',
            description:
                'radio.dart imports these directly: selection_control.dart '
                'for the shared socket / hit-area / focus-ring machinery '
                '(SelectionControl), field.dart for FieldScope '
                'wiring, effects/surface.dart for the raised '
                'dot\'s own surface (Surface: used directly here, '
                'unlike checkbox\'s hand-drawn path), and '
                'motion/keyframes.dart for the dot-pop player. None are '
                'copyable in isolation.',
          ),
          const DocsInstallFact(
            label: 'Foundation dependencies',
            value:
                'foundation/motion.dart, foundation/shadows.dart, '
                'foundation/spacing.dart, foundation/theme.dart, '
                'theme_scope.dart',
            description:
                'Token sources: durations and curves, shadow specs, the '
                'space() spacing scale, and the live theme.',
          ),
          DocsInstallFact(
            label: 'Exports',
            value: radioDoc.exports.join(', '),
            description:
                'The public symbols this component makes '
                'available.',
          ),
          const DocsInstallFact(
            label: 'Assets',
            value: 'none',
            description:
                'The dot is a plain filled circle drawn with '
                'Surface, not an image or an icon-font glyph, '
                'radio needs no icon grid at all, unlike checkbox\'s '
                'hand-authored tick path.',
          ),
          const DocsInstallFact(
            label: 'Fonts',
            value: 'none',
            description: 'No text is rendered by RadioGroupItem itself.',
          ),
          const DocsInstallFact(
            label: 'Shaders',
            value: 'none',
            description: 'No fragment shader is used.',
          ),
        ],
      ),
      SizedBox(height: space(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Field', route: '/components/field'),
          DocsLink(label: 'Checkbox', route: '/components/checkbox'),
          DocsLink(label: 'Switch', route: '/components/switch'),
          DocsLink(
            label: 'Selection control',
            route: '/components/selection_control',
          ),
          DocsLink(label: 'Surface', route: '/components/surface'),
          DocsLink(label: 'Keyframes', route: '/components/keyframes'),
          DocsLink(
            label: 'Source Foundation',
            route: '/components/source_foundation',
          ),
        ],
      ),
    ],
  );
}

const List<DocsInstallFact> _themingFacts = <DocsInstallFact>[
  DocsInstallFact(
    label: 'Fill',
    value: 'theme.card (rest) / theme.primary (selected)',
    description: 'Socket background.',
  ),
  DocsInstallFact(
    label: 'Border',
    value:
        'theme.input (rest) / theme.primary (selected) / theme.ring '
        '(focus-visible) / theme.destructive (invalid)',
    description: 'Resolved in that precedence order: invalid always wins.',
  ),
  DocsInstallFact(
    label: 'Dot colour',
    value: 'theme.primaryForeground',
    description: 'The raised filled dot.',
  ),
  DocsInstallFact(
    label: 'Shadow',
    value:
        'Shadows.inset (rest) / Shadows.controlPrimary (selected) on '
        'the socket; Shadows.sm on the dot',
    description:
        'The socket shadow spec, composed with the focus or invalid '
        'ring; the dot carries its own raised shadow, separately from '
        'the socket beneath it.',
  ),
  DocsInstallFact(
    label: 'Radius',
    value: 'BorderRadius.circular(size / 2)',
    description: 'A full circle: half the 20px box, not a named Radii token.',
  ),
  DocsInstallFact(
    label: 'Motion',
    value: 'MotionDurations.normal, DotSelectionMotion, StateChangeFeedback',
    description:
        'Socket colour/border/ring tween duration, the dot\'s own '
        'pop-in keyframe (scale and opacity, on the spring curve), and '
        'the post-selection squash: all resolved through '
        'effectiveMotionDuration, so reduced motion shortens or removes '
        'them automatically.',
  ),
  DocsInstallFact(
    label: 'Row gap',
    value: 'RadioGroup.defaultGap (8px) or FieldSet.groupGap (12px)',
    description:
        'The group\'s own default, or the tighter step the composed '
        'forms page passes when the group sits inside a FieldSet.',
  ),
];

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
