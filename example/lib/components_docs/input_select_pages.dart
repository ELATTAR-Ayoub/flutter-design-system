library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/material.dart';

import '../docs/docs_code.dart';
import '../docs/docs_facts.dart';
import '../docs/docs_layout.dart';
import '../kit.dart';
import 'catalog.dart';

class InputDocPage extends StatelessWidget {
  const InputDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    final ComponentDocEntry entry = componentDoc('input');
    return _ComponentDocShell(
      entry: entry,
      intro: const DocsPageIntro(
        eyebrow: 'Components',
        title: 'Input',
        description:
            'DsInput is the system’s text-entry socket: a pill field that composes with DsField for labels, descriptions, errors, and form semantics.',
      ),
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Preview', anchor: 'preview'),
        DocsTocEntry(title: 'Installation', anchor: 'installation'),
        DocsTocEntry(title: 'Usage', anchor: 'usage'),
        DocsTocEntry(title: 'API', anchor: 'api'),
        DocsTocEntry(title: 'States', anchor: 'states'),
        DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
        DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
        DocsTocEntry(title: 'Source', anchor: 'source'),
      ],
      previous: _pageLinkBefore(entry.name),
      next: _pageLinkAfter(entry.name),
      onNavigate: onNavigate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DsSection(
            id: 'preview',
            title: 'Live preview',
            description:
                'Preview the field as a DsField companion. Toggle the common documentation states to see how the socket, semantics, and helper copy behave together.',
            child: DocsCodeExample(
              title: 'Interactive input preview',
              description:
                  'Label and placeholder are distinct: the label names the control, while the placeholder disappears as soon as the field has a value.',
              preview: const _InputPreview(),
              command: DocsCodeCommand(
                command: entry.command,
                description:
                    'Installs DsInput into lib/components/ui with its field and surface dependencies.',
              ),
              manualFiles: const <DocsCodeFile>[
                DocsCodeFile(
                  path: 'lib/components/ui/input.dart',
                  title: 'Manual import',
                  description: 'Import the installed component in your app.',
                  code: "import 'package:your_app/components/ui/input.dart';\n",
                ),
                DocsCodeFile(
                  path: 'usage.dart',
                  title: 'Usage',
                  description: 'Compose DsInput inside DsField.',
                  code: '''
DsField(
  label: 'Email',
  description: 'We will send updates only when something changes.',
  child: DsInput(
    label: 'Email',
    placeholder: 'you@example.com',
  ),
)''',
                ),
              ],
            ),
          ),
          DsSection(
            id: 'installation',
            title: 'Installation',
            description:
                'The CLI places DsInput under lib/components/ui and keeps the shared foundations and field dependencies aligned with the registry.',
            child: DocsInstallFacts(
              facts: <DocsInstallFact>[
                DocsInstallFact(
                  label: 'CLI command',
                  value: entry.command,
                  description: 'Adds DsInput plus its transitive dependencies.',
                ),
                DocsInstallFact(
                  label: 'Installed path',
                  value: 'lib/components/ui/input.dart',
                  description:
                      'All installable components land under components/ui.',
                ),
                DocsInstallFact(
                  label: 'Best companion',
                  value: 'DsField',
                  description:
                      'Use DsField for visible labels, descriptions, and error messaging around the input socket.',
                ),
              ],
            ),
          ),
          DsSection(
            id: 'usage',
            title: 'Usage',
            description:
                'Use DsInput directly for a simple field, or wrap it in DsField when the user needs visible label, description, and error copy.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                DocsCodeExample(
                  title: 'Field companion',
                  description:
                      'This is the default pattern for forms and settings pages.',
                  preview: const _FieldCompanionPreview(),
                  command: const DocsCodeCommand(
                    command: 'elattar add input',
                    description:
                        'Installs the input socket; DsField comes along as a dependency.',
                  ),
                  manualFiles: const <DocsCodeFile>[
                    DocsCodeFile(
                      path: 'field_usage.dart',
                      code: '''
DsField(
  label: 'Display name',
  description: 'Shown publicly on your profile.',
  child: DsInput(
    label: 'Display name',
    initialValue: 'Astra Vale',
  ),
)''',
                    ),
                  ],
                ),
                SizedBox(height: ds(6)),
                DocsCodeExample(
                  title: 'Read-only and bare compositions',
                  description:
                      'Read-only is mostly semantic; bare mode removes the socket surface for grouped compositions.',
                  preview: const _InputReadOnlyBarePreview(),
                  manualFiles: const <DocsCodeFile>[
                    DocsCodeFile(
                      path: 'read_only_usage.dart',
                      code: '''
const DsInput(
  label: 'Wallet address',
  initialValue: '0xA71c…4F2b',
  readOnly: true,
)''',
                    ),
                    DocsCodeFile(
                      path: 'bare_usage.dart',
                      code: '''
const DsInput(
  placeholder: 'Search packs',
  bare: true,
)''',
                    ),
                  ],
                ),
              ],
            ),
          ),
          DsSection(
            id: 'api',
            title: 'API',
            description:
                'These are the props that most often change page behavior or semantics in real product usage.',
            child: const DocsApiTable(
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'controller',
                  type: 'TextEditingController?',
                  description:
                      'Controls the value externally. Mutually exclusive with initialValue.',
                ),
                DocsApiFact(
                  name: 'initialValue',
                  type: 'String?',
                  description:
                      'Seeds the input’s own controller for uncontrolled usage.',
                ),
                DocsApiFact(
                  name: 'label',
                  type: 'String?',
                  description:
                      'Accessible name when the field has no visible external label.',
                ),
                DocsApiFact(
                  name: 'placeholder',
                  type: 'String?',
                  description:
                      'Hint text inside the empty socket. It does not replace the label.',
                ),
                DocsApiFact(
                  name: 'hint',
                  type: 'String?',
                  description:
                      'Semantic description channel, often paired with validation copy.',
                ),
                DocsApiFact(
                  name: 'invalid',
                  type: 'bool',
                  description:
                      'Applies the destructive field treatment and invalid semantics.',
                ),
                DocsApiFact(
                  name: 'readOnly',
                  type: 'bool',
                  description:
                      'Makes the value selectable but not editable, with semantic read-only state.',
                ),
                DocsApiFact(
                  name: 'enabled',
                  type: 'bool',
                  description:
                      'Disables editing and dims the field to the documented 45% opacity.',
                ),
                DocsApiFact(
                  name: 'obscureText',
                  type: 'bool',
                  description:
                      'Use for password-style entry; compose a visibility toggle outside the base input.',
                ),
                DocsApiFact(
                  name: 'bare',
                  type: 'bool',
                  description:
                      'Removes the socket surface for grouped or wrapper-owned layouts.',
                ),
              ],
            ),
          ),
          DsSection(
            id: 'states',
            title: 'States',
            description:
                'The socket stays visually restrained. Focus changes the ring, invalid wins over focus, and read-only is intentionally light on visual styling.',
            child: const DocsStateMatrix(
              facts: <DocsStateFact>[
                DocsStateFact(
                  state: 'Default',
                  treatment:
                      'Sunken card-colored socket with placeholder support and full-width composition.',
                  userSignal: 'The field is editable and ready for text entry.',
                ),
                DocsStateFact(
                  state: 'Focused',
                  treatment:
                      'Visible focus ring and border emphasis without lifting the socket.',
                  userSignal:
                      'Keyboard focus is clear without changing the recessed input idea.',
                ),
                DocsStateFact(
                  state: 'Invalid',
                  treatment:
                      'Destructive border and ring replace the focus styling outright.',
                  userSignal:
                      'The field needs correction now, and the error state is announced semantically.',
                ),
                DocsStateFact(
                  state: 'Disabled',
                  treatment: 'Opacity drops to 45% and editing is disabled.',
                  userSignal:
                      'The control cannot be changed in the current context.',
                ),
                DocsStateFact(
                  state: 'Read-only',
                  treatment:
                      'Value remains selectable with semantic read-only state and minimal paint changes.',
                  userSignal:
                      'The content is real and copyable, but not editable.',
                ),
                DocsStateFact(
                  state: 'Bare',
                  treatment:
                      'Socket surface is removed so a group or wrapper can own the container.',
                  userSignal:
                      'Use this only inside a higher-level composition such as an input group.',
                ),
              ],
            ),
          ),
          DsSection(
            id: 'accessibility',
            title: 'Accessibility',
            description:
                'Document the input as a labeled field, not as placeholder-only text entry. The control publishes one merged semantic node for name, hint, and validation result.',
            child: _Bullets(
              items: const <String>[
                'Use a visible DsField label for production forms; placeholders disappear as soon as the user types.',
                'invalid publishes SemanticsValidationResult.invalid and the destructive treatment.',
                'readOnly is semantic first: users can still select and copy the value.',
                'hint is the described-by style channel for supportive or recovery copy.',
                'The field family includes keyboard-avoidance behavior so focused fields stay visible above the software keyboard.',
              ],
            ),
          ),
          DsSection(
            id: 'dependencies',
            title: 'Dependencies',
            description:
                'Registry dependencies explain what the installer has to bring along for the input socket to render and behave correctly.',
            child: _DependenciesPanel(entry: entry),
          ),
          DsSection(
            id: 'source',
            title: 'Source',
            description:
                'Public docs should point readers back to the package source of truth when they need the full contract or implementation details.',
            child: _SourcePanel(entry: entry),
          ),
        ],
      ),
    );
  }
}

class SelectDocPage extends StatelessWidget {
  const SelectDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    final ComponentDocEntry entry = componentDoc('select');
    return _ComponentDocShell(
      entry: entry,
      intro: const DocsPageIntro(
        eyebrow: 'Components',
        title: 'Select',
        description:
            'DsSelect is a typed trigger-and-menu control with grouped options, separators, placeholder state, and keyboard-friendly selection behavior.',
      ),
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Preview', anchor: 'preview'),
        DocsTocEntry(title: 'Installation', anchor: 'installation'),
        DocsTocEntry(title: 'Usage', anchor: 'usage'),
        DocsTocEntry(title: 'API', anchor: 'api'),
        DocsTocEntry(title: 'States', anchor: 'states'),
        DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
        DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
        DocsTocEntry(title: 'Source', anchor: 'source'),
      ],
      previous: _pageLinkBefore(entry.name),
      next: _pageLinkAfter(entry.name),
      onNavigate: onNavigate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DsSection(
            id: 'preview',
            title: 'Live preview',
            description:
                'Preview a typed select with grouped options, explicit sizes, disabled options, and placeholder behavior.',
            child: DocsCodeExample(
              title: 'Interactive select preview',
              description:
                  'The menu walks selectable options only. Group labels and separators document structure, while disabled rows are skipped by keyboard navigation.',
              preview: const _SelectPreview(),
              command: DocsCodeCommand(
                command: entry.command,
                description:
                    'Installs DsSelect and the popover, icon, field, and surface dependencies it needs.',
              ),
              manualFiles: const <DocsCodeFile>[
                DocsCodeFile(
                  path: 'lib/components/ui/select.dart',
                  title: 'Manual import',
                  description: 'Import the installed component in your app.',
                  code:
                      "import 'package:your_app/components/ui/select.dart';\n",
                ),
                DocsCodeFile(
                  path: 'usage.dart',
                  title: 'Typed usage',
                  description: 'A typed menu with grouped options.',
                  code: '''
DsSelect<String>(
  options: const <DsSelectChild<String>>[
    DsSelectGroup(
      label: 'Activity',
      children: [
        DsSelectOption(value: 'popular', label: 'Most popular'),
        DsSelectOption(value: 'newest', label: 'Newest'),
      ],
    ),
    DsSelectSeparator(),
    DsSelectGroup(
      label: 'Price',
      children: [
        DsSelectOption(value: 'low', label: 'Price: low to high'),
        DsSelectOption(value: 'high', label: 'Price: high to low'),
      ],
    ),
  ],
  value: sort,
  onChanged: onSortChanged,
  placeholder: 'Choose a sort order',
  expand: true,
)''',
                ),
              ],
            ),
          ),
          DsSection(
            id: 'installation',
            title: 'Installation',
            description:
                'The CLI installs the trigger, menu, and the support primitives that make grouped and keyboard-friendly selection work.',
            child: DocsInstallFacts(
              facts: <DocsInstallFact>[
                DocsInstallFact(
                  label: 'CLI command',
                  value: entry.command,
                  description:
                      'Adds DsSelect plus its transitive dependencies.',
                ),
                DocsInstallFact(
                  label: 'Installed path',
                  value: 'lib/components/ui/select.dart',
                  description:
                      'Like all installable components, the file lands in components/ui.',
                ),
                DocsInstallFact(
                  label: 'Companion pieces',
                  value: 'field, popover, icon',
                  description:
                      'These dependencies power labeling, menu placement, and trigger glyphs.',
                ),
              ],
            ),
          ),
          DsSection(
            id: 'usage',
            title: 'Usage',
            description:
                'Build a typed select with flat rows for simple menus, or use groups and separators when the menu has multiple semantic sections.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                DocsCodeExample(
                  title: 'Grouped menu',
                  description:
                      'Group labels and separators are part of the public API, not an implementation detail.',
                  preview: const _GroupedSelectPreview(),
                  manualFiles: const <DocsCodeFile>[
                    DocsCodeFile(
                      path: 'grouped_select.dart',
                      code: '''
DsSelect<String>(
  options: const <DsSelectChild<String>>[
    DsSelectGroup(
      label: 'Category',
      children: [
        DsSelectOption(value: 'design', label: 'Design & culture'),
        DsSelectOption(value: 'photo', label: 'Photography'),
      ],
    ),
    DsSelectSeparator(),
    DsSelectGroup(
      label: 'Visibility',
      children: [
        DsSelectOption(value: 'public', label: 'Public'),
        DsSelectOption(value: 'private', label: 'Private'),
      ],
    ),
  ],
  value: value,
  onChanged: onChanged,
  expand: true,
)''',
                    ),
                  ],
                ),
                SizedBox(height: ds(6)),
                DocsCodeExample(
                  title: 'Size and width control',
                  description:
                      'Use size for the trigger height, expand for full-width forms, and width when a state cell needs a fixed measure.',
                  preview: const _SelectSizePreview(),
                  manualFiles: const <DocsCodeFile>[
                    DocsCodeFile(
                      path: 'sized_select.dart',
                      code: '''
DsSelect<String>(
  options: rarityOptions,
  value: rarity,
  onChanged: onChanged,
  placeholder: 'Any rarity',
  size: DsSelectSize.sm,
  width: 160,
)''',
                    ),
                  ],
                ),
              ],
            ),
          ),
          DsSection(
            id: 'api',
            title: 'API',
            description:
                'These are the props and supporting types that shape how the trigger, menu, and typed value behave on a page.',
            child: const DocsApiTable(
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'options',
                  type: 'List<DsSelectChild<T>>',
                  description:
                      'Accepts options, groups, and separators in menu order.',
                ),
                DocsApiFact(
                  name: 'value',
                  type: 'T?',
                  description:
                      'Selected typed value. Null renders the placeholder state.',
                ),
                DocsApiFact(
                  name: 'onChanged',
                  type: 'ValueChanged<T>?',
                  description: 'Selection callback. Null disables interaction.',
                ),
                DocsApiFact(
                  name: 'placeholder',
                  type: 'String?',
                  description: 'Displayed when there is no selected value.',
                ),
                DocsApiFact(
                  name: 'size',
                  type: 'DsSelectSize',
                  description:
                      'sm renders a 32px trigger; md renders the default 40px trigger.',
                ),
                DocsApiFact(
                  name: 'expand',
                  type: 'bool',
                  description: 'Fills the available form width when true.',
                ),
                DocsApiFact(
                  name: 'width',
                  type: 'double?',
                  description:
                      'Explicit trigger width. This wins over expand when both are supplied.',
                ),
                DocsApiFact(
                  name: 'invalid',
                  type: 'bool',
                  description:
                      'Applies destructive treatment and invalid semantics.',
                ),
                DocsApiFact(
                  name: 'label',
                  type: 'String?',
                  description:
                      'Accessible trigger name when the select has no visible outer label.',
                ),
                DocsApiFact(
                  name: 'hint',
                  type: 'String?',
                  description:
                      'Described-by style semantic copy for the trigger.',
                ),
              ],
            ),
          ),
          DsSection(
            id: 'states',
            title: 'States',
            description:
                'The trigger behaves like a field socket. Width, placeholder, disabled options, and grouped geometry are part of the shipped contract.',
            child: const DocsStateMatrix(
              facts: <DocsStateFact>[
                DocsStateFact(
                  state: 'Placeholder',
                  treatment:
                      'Null value shows muted placeholder text in the trigger.',
                  userSignal: 'The user still has to make a selection.',
                ),
                DocsStateFact(
                  state: 'Selected',
                  treatment:
                      'Trigger shows the current label and the menu aligns the chosen row to the trigger.',
                  userSignal:
                      'The current value is visible before opening the menu.',
                ),
                DocsStateFact(
                  state: 'Invalid',
                  treatment:
                      'Destructive border and ring override the neutral trigger styling.',
                  userSignal:
                      'The selection needs correction and is announced semantically.',
                ),
                DocsStateFact(
                  state: 'Disabled',
                  treatment: 'Trigger dims and can no longer open the menu.',
                  userSignal:
                      'The field is unavailable in the current workflow.',
                ),
                DocsStateFact(
                  state: 'Disabled option',
                  treatment:
                      'The row stays visible but is skipped by keyboard and pointer selection.',
                  userSignal:
                      'Users can understand the unavailable choice without accidentally selecting it.',
                ),
                DocsStateFact(
                  state: 'Grouped menu',
                  treatment:
                      'Labels and separators structure the menu but are not selection stops.',
                  userSignal:
                      'The menu remains easy to scan and navigate with the keyboard.',
                ),
              ],
            ),
          ),
          DsSection(
            id: 'accessibility',
            title: 'Accessibility',
            description:
                'Document DsSelect as a typed trigger with a real keyboard path. Labels, placeholder messaging, and disabled-option behavior all matter to the user model.',
            child: _Bullets(
              items: const <String>[
                'Provide a visible DsField label in forms, or pass label for accessible naming when the trigger stands alone.',
                'Placeholder is for the empty selection state only; it is not a substitute for labeling the control.',
                'Keyboard navigation moves through selectable rows only and skips group labels, separators, and disabled options.',
                'invalid publishes the destructive treatment and semantic invalid state on the trigger.',
                'Use grouped menus when structure helps comprehension, not just for decoration.',
              ],
            ),
          ),
          DsSection(
            id: 'dependencies',
            title: 'Dependencies',
            description:
                'The installer brings along the support primitives that let DsSelect behave like a real trigger + menu system.',
            child: _DependenciesPanel(entry: entry),
          ),
          DsSection(
            id: 'source',
            title: 'Source',
            description:
                'Keep the package file visible in docs so contributors can jump from prose to the implementation contract quickly.',
            child: _SourcePanel(entry: entry),
          ),
        ],
      ),
    );
  }
}

class _ComponentDocShell extends StatelessWidget {
  const _ComponentDocShell({
    required this.entry,
    required this.intro,
    required this.toc,
    required this.child,
    required this.previous,
    required this.next,
    this.onNavigate,
  });

  final ComponentDocEntry entry;
  final DocsPageIntro intro;
  final List<DocsTocEntry> toc;
  final Widget child;
  final DocsPageLink? previous;
  final DocsPageLink? next;
  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    return DocsLayout(
      route: entry.route,
      intro: intro,
      breadcrumbs: <DsBreadcrumbEntry>[
        const DsBreadcrumbEntry.link('Components'),
        DsBreadcrumbEntry.page(entry.title),
      ],
      sidebar: <DocsSidebarEntry>[
        for (final ComponentDocEntry doc in componentDocs)
          DocsSidebarEntry(
            title: doc.title,
            route: doc.route,
            selected: doc.name == entry.name,
          ),
      ],
      toc: toc,
      previous: previous,
      next: next,
      onNavigate: onNavigate,
      child: child,
    );
  }
}

class _DependenciesPanel extends StatelessWidget {
  const _DependenciesPanel({required this.entry});

  final ComponentDocEntry entry;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return DsPanel(
      label: 'Registry dependencies',
      note: '${entry.dependencies.length} items',
      child: Wrap(
        spacing: ds(2),
        runSpacing: ds(2),
        children: <Widget>[
          for (final String dependency in entry.dependencies)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ds(3),
                vertical: ds(1.5),
              ),
              decoration: BoxDecoration(
                color: theme.muted,
                borderRadius: BorderRadius.circular(DsRadii.pill),
                border: Border.all(
                  color: theme.border,
                  width: DsWidths.hairline,
                ),
              ),
              child: DsText(
                dependency,
                DsType.chip,
                color: theme.mutedForeground,
              ),
            ),
        ],
      ),
    );
  }
}

class _SourcePanel extends StatelessWidget {
  const _SourcePanel({required this.entry});

  final ComponentDocEntry entry;

  @override
  Widget build(BuildContext context) {
    return DocsInstallFacts(
      title: 'Source references',
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'Package file',
          value: entry.sourcePath,
          description:
              'The authoritative Flutter source file for this component.',
        ),
        DocsInstallFact(
          label: 'Exports',
          value: entry.exports.join(', '),
          description: 'Public APIs consumers can rely on after installation.',
        ),
      ],
    );
  }
}

class _Bullets extends StatelessWidget {
  const _Bullets({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return DsPanel(
      label: 'Guidance',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (int index = 0; index < items.length; index++) ...<Widget>[
            if (index > 0) SizedBox(height: ds(3)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: ds(1.5)),
                  child: Container(
                    width: ds(1.5),
                    height: ds(1.5),
                    decoration: BoxDecoration(
                      color: theme.actionInk,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                SizedBox(width: ds(3)),
                Expanded(child: DsText(items[index], DsType.small)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _InputPreview extends StatefulWidget {
  const _InputPreview();

  @override
  State<_InputPreview> createState() => _InputPreviewState();
}

class _InputPreviewState extends State<_InputPreview> {
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
          spacing: ds(2),
          runSpacing: ds(2),
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
        SizedBox(height: ds(5)),
        DsField(
          label: 'Email',
          description:
              'Visible labels carry the durable meaning. Placeholders only help while the field is empty.',
          errors: _invalid
              ? const <String>['That address is missing a valid domain.']
              : const <String>[],
          child: DsInput(
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

class _FieldCompanionPreview extends StatelessWidget {
  const _FieldCompanionPreview();

  @override
  Widget build(BuildContext context) {
    return DsField(
      label: 'Display name',
      description: 'Shown publicly on your profile.',
      child: const DsInput(label: 'Display name', initialValue: 'Astra Vale'),
    );
  }
}

class _InputReadOnlyBarePreview extends StatelessWidget {
  const _InputReadOnlyBarePreview();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DsField(
          label: 'Wallet address',
          description: 'Copyable, but not editable.',
          child: DsInput(
            label: 'Wallet address',
            initialValue: '0xA71c…4F2b',
            readOnly: true,
          ),
        ),
        SizedBox(height: ds(5)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: ds(4), vertical: ds(2)),
          decoration: BoxDecoration(
            color: DsTheme.of(context).muted,
            borderRadius: BorderRadius.circular(DsRadii.lg),
            border: Border.all(
              color: DsTheme.of(context).border,
              width: DsWidths.hairline,
            ),
          ),
          child: const DsInput(
            placeholder: 'Search packs',
            label: 'Search packs',
            bare: true,
          ),
        ),
      ],
    );
  }
}

class _SelectPreview extends StatefulWidget {
  const _SelectPreview();

  @override
  State<_SelectPreview> createState() => _SelectPreviewState();
}

class _SelectPreviewState extends State<_SelectPreview> {
  String? _value;
  bool _invalid = false;
  bool _disabled = false;
  DsSelectSize _size = DsSelectSize.md;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Wrap(
          spacing: ds(2),
          runSpacing: ds(2),
          children: <Widget>[
            _TogglePill(
              selected: _size == DsSelectSize.md,
              label: 'Size md',
              onPressed: () => setState(() => _size = DsSelectSize.md),
            ),
            _TogglePill(
              selected: _size == DsSelectSize.sm,
              label: 'Size sm',
              onPressed: () => setState(() => _size = DsSelectSize.sm),
            ),
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
          ],
        ),
        SizedBox(height: ds(5)),
        DsField(
          label: 'Sort order',
          description:
              'Grouped options stay keyboard-friendly: the arrows skip labels, separators, and disabled rows.',
          errors: _invalid
              ? const <String>['Choose a sort order before continuing.']
              : const <String>[],
          child: DsSelect<String>(
            options: _sortOptions,
            value: _value,
            onChanged: _disabled
                ? null
                : (String next) => setState(() => _value = next),
            placeholder: 'Choose a sort order',
            size: _size,
            invalid: _invalid,
            expand: true,
            label: 'Sort order',
            hint: _invalid
                ? 'Choose a sort order before continuing.'
                : 'Grouped menu with disabled rows.',
          ),
        ),
        SizedBox(height: ds(4)),
        DsText(
          _value == null ? 'No value selected yet.' : 'Selected: $_value',
          DsType.small,
          color: DsTheme.of(context).mutedForeground,
        ),
      ],
    );
  }
}

class _GroupedSelectPreview extends StatefulWidget {
  const _GroupedSelectPreview();

  @override
  State<_GroupedSelectPreview> createState() => _GroupedSelectPreviewState();
}

class _GroupedSelectPreviewState extends State<_GroupedSelectPreview> {
  String? _category = 'design';

  @override
  Widget build(BuildContext context) {
    return DsField(
      label: 'Category',
      description: 'A grouped menu with semantic sections.',
      child: DsSelect<String>(
        options: _profileOptions,
        value: _category,
        onChanged: (String next) => setState(() => _category = next),
        expand: true,
        label: 'Category',
      ),
    );
  }
}

class _SelectSizePreview extends StatefulWidget {
  const _SelectSizePreview();

  @override
  State<_SelectSizePreview> createState() => _SelectSizePreviewState();
}

class _SelectSizePreviewState extends State<_SelectSizePreview> {
  String? _rarity;
  bool _expand = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _TogglePill(
          selected: _expand,
          label: _expand ? 'Expand on' : 'Expand off',
          onPressed: () => setState(() => _expand = !_expand),
        ),
        SizedBox(height: ds(5)),
        DsSelect<String>(
          options: _rarityOptions,
          value: _rarity,
          onChanged: (String next) => setState(() => _rarity = next),
          placeholder: 'Any rarity',
          size: DsSelectSize.sm,
          width: _expand ? null : ds(40),
          expand: _expand,
          label: 'Rarity',
        ),
      ],
    );
  }
}

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
    return DsButton(
      variant: selected ? DsButtonVariant.primary : DsButtonVariant.secondary,
      size: DsButtonSize.sm,
      label: label,
      onPressed: onPressed,
      child: DsText(label, DsComponentType.buttonLabel),
    );
  }
}

DocsPageLink? _pageLinkBefore(String name) {
  final int index = componentDocs.indexWhere(
    (ComponentDocEntry entry) => entry.name == name,
  );
  if (index <= 0) return null;
  final ComponentDocEntry previous = componentDocs[index - 1];
  return DocsPageLink(title: previous.title, route: previous.route);
}

DocsPageLink? _pageLinkAfter(String name) {
  final int index = componentDocs.indexWhere(
    (ComponentDocEntry entry) => entry.name == name,
  );
  if (index < 0 || index >= componentDocs.length - 1) return null;
  final ComponentDocEntry next = componentDocs[index + 1];
  return DocsPageLink(title: next.title, route: next.route);
}

const List<DsSelectChild<String>> _sortOptions = <DsSelectChild<String>>[
  DsSelectGroup<String>(
    label: 'Activity',
    children: <DsSelectOption<String>>[
      DsSelectOption<String>(value: 'popular', label: 'Most popular'),
      DsSelectOption<String>(value: 'newest', label: 'Newest'),
      DsSelectOption<String>(value: 'volatility', label: 'Volatility'),
    ],
  ),
  DsSelectSeparator(),
  DsSelectGroup<String>(
    label: 'Price',
    children: <DsSelectOption<String>>[
      DsSelectOption<String>(value: 'low', label: 'Price: low to high'),
      DsSelectOption<String>(
        value: 'high',
        label: 'Price: high to low',
        enabled: false,
      ),
    ],
  ),
];

const List<DsSelectChild<String>> _profileOptions = <DsSelectChild<String>>[
  DsSelectGroup<String>(
    label: 'Category',
    children: <DsSelectOption<String>>[
      DsSelectOption<String>(value: 'design', label: 'Design & culture'),
      DsSelectOption<String>(value: 'photo', label: 'Photography'),
    ],
  ),
  DsSelectSeparator(),
  DsSelectGroup<String>(
    label: 'Visibility',
    children: <DsSelectOption<String>>[
      DsSelectOption<String>(value: 'public', label: 'Public'),
      DsSelectOption<String>(value: 'private', label: 'Private'),
    ],
  ),
];

const List<DsSelectChild<String>> _rarityOptions = <DsSelectChild<String>>[
  DsSelectOption<String>(value: 'common', label: 'Common'),
  DsSelectOption<String>(value: 'rare', label: 'Rare'),
  DsSelectOption<String>(value: 'mythic', label: 'Mythic'),
];
