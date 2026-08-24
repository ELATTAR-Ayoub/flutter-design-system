/// Public component documentation for the checkbox component.
///
/// `checkboxDoc` (from `meta.dart`) is the data source, not
/// `componentDoc('checkbox')`; this page keeps its typed metadata import.
///
/// Section order mirrors `https://ui.shadcn.com/docs/components/base/checkbox`:
/// a live demo before any heading, exactly like shadcn's own page, then
/// Installation, Usage, Checked state, Invalid state, Basic, Description,
/// Disabled, Group, Table, RTL, API Reference, then the six Elattar-specific
/// sections (States, Accessibility,
/// Responsive, Dependencies, Theming, Source) `button`'s reference shape
/// establishes. Their "Group" and "Table" sections are this component's own
/// two composition examples (a filter row, a tri-state bulk-selection
/// header), renamed and promoted to top level rather than nested under a
/// dropped `Composition examples` wrapper. Their "API Reference" links out to
/// Base UI's own docs; this page keeps the full prop tables that section
/// title already carried.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

class CheckboxDocPage extends StatelessWidget {
  const CheckboxDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    return DocsLayout(
      route: checkboxDoc.route,
      intro: DocsPageIntro(
        eyebrow: 'COMPONENTS / BASE',
        title: checkboxDoc.title,
        description: checkboxDoc.description,
      ),
      breadcrumbs: const <ElBreadcrumbEntry>[
        ElBreadcrumbEntry.link('Components'),
        ElBreadcrumbEntry.page('Checkbox'),
      ],
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Installation', anchor: 'install'),
        DocsTocEntry(title: 'Usage', anchor: 'usage'),
        DocsTocEntry(title: 'Checked state', anchor: 'checked-state'),
        DocsTocEntry(title: 'Invalid state', anchor: 'invalid-state'),
        DocsTocEntry(title: 'Basic', anchor: 'basic'),
        DocsTocEntry(title: 'Description', anchor: 'description'),
        DocsTocEntry(title: 'Disabled', anchor: 'disabled'),
        DocsTocEntry(title: 'Group', anchor: 'group'),
        DocsTocEntry(title: 'Table', anchor: 'table'),
        DocsTocEntry(title: 'RTL', anchor: 'rtl'),
        DocsTocEntry(title: 'API Reference', anchor: 'api'),
        DocsTocEntry(title: 'States', anchor: 'states'),
        DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
        DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
        DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
        DocsTocEntry(title: 'Theming', anchor: 'theming'),
        DocsTocEntry(title: 'Source', anchor: 'source'),
      ],
      // Wave 1's alphabetical neighbours (Phase J plan inventory). Neither
      // route is registered yet either: the whole wave's previous/next chain
      // is stitched together once the supervisor aggregates every meta.dart,
      // the same as this page's own route is not reachable until then.
      previous: const DocsPageLink(
        title: 'Breadcrumb',
        route: '/components/breadcrumb',
      ),
      next: const DocsPageLink(
        title: 'Collapsible',
        route: '/components/collapsible',
      ),
      onNavigate: onNavigate,
      child: _CheckboxArticle(theme: ElTheme.of(context)),
    );
  }
}

class _CheckboxArticle extends StatelessWidget {
  const _CheckboxArticle({required this.theme});

  final ElThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey<String>('checkbox-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: ElWidths.prose),
          child: ElText(
            'Seven live specimens, all built from the same ElCheckbox '
            'constructor. Unchecked, Checked, Focus-visible and Error are '
            'operable: tap them. Indeterminate is deliberately held '
            'still and Disabled is deliberately inert; both are explained '
            'in States below.',
            ElType.small,
          ),
        ),
        SizedBox(height: el(3)),
        DocsCodeExample(
          title: 'Checkbox specimens',
          description: 'Every cell below renders a real ElCheckbox.',
          preview: const _CheckboxPreview(),
          manualFiles: <DocsCodeFile>[
            DocsCodeFile(
              path: checkboxDoc.sourcePath,
              code:
                  '${checkboxDoc.command}\n'
                  '// Installs the generated @ui/checkbox.dart payload.',
            ),
          ],
        ),
        SizedBox(height: el(8)),
        ElSection(
          id: 'install',
          title: 'Installation',
          description:
              'Command install is available: read this before '
              'reaching for elattar add checkbox.',
          child: DocsInstallFacts(
            facts: <DocsInstallFact>[
              const DocsInstallFact(
                label: 'CLI',
                value: 'registry/components/checkbox.json',
                description:
                    'checkbox is a registry item, so `elattar add checkbox` '
                    'resolves it and its dependencies and copies the source '
                    'into your project.',
              ),
              const DocsInstallFact(
                label: 'Manual: package mode (supported today)',
                value:
                    "import 'package:elattar_design_system/elattar_design_system.dart';",
                description:
                    'Depend on the package and use ElCheckbox directly, '
                    'exactly as this page does.',
              ),
              DocsInstallFact(
                label: 'Manual: source mode (not recommended yet)',
                value: checkboxDoc.sourcePath,
                description:
                    'Copying this one file will not compile on its own: it '
                    'needs five sibling files with it (see Dependencies and '
                    'files below), and no manifest exists yet to resolve '
                    'them for you.',
              ),
              const DocsInstallFact(
                label: 'Status',
                value: 'Stable, installable through elattar add checkbox',
                description:
                    'Ported and tested against lib/src/components/checkbox.dart.',
              ),
              DocsInstallFact(
                label: 'Version',
                value: '0.0.1',
                description:
                    'Tracks the package version; there is no registry schema '
                    'version; the shipped manifest installs it.',
              ),
              const DocsInstallFact(
                label: 'Platforms',
                value: 'Android, iOS, Web, macOS, Windows, Linux',
                description:
                    'A pure Flutter widget tree and CustomPainter geometry, '
                    'no platform channel and no platform-specific branch.',
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'usage',
          title: 'Usage',
          description: 'Import the package, then construct a ElCheckbox.',
          child: ElPanel(
            label: 'DART',
            note: 'BASIC CONSTRUCTION',
            child: DocsSelectableCodeBlock(code: _basicUsageCode),
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'checked-state',
          title: 'Checked state',
          description:
              'ElCheckbox is always controlled: state carries the current '
              'ElCheckboxState and onChanged reports the next one on tap.',
          child: ElPanel(
            label: 'DART',
            note: 'CONTROLLED',
            child: DocsSelectableCodeBlock(code: _smallestUsageCode),
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'invalid-state',
          title: 'Invalid state',
          description:
              'invalid: true swaps the border and ring to the destructive '
              'colour; see States and Accessibility below for the full '
              'focus/error precedence.',
          child: ElPanel(
            label: 'DART',
            note: 'INVALID',
            child: DocsSelectableCodeBlock(code: _invalidUsageCode),
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'basic',
          title: 'Basic',
          description:
              'ElCheckbox renders no visible text of its own: label only '
              'supplies the accessible name. Pair it with ElField for a '
              'visible caption, and its ElFieldScope threads the label '
              'straight through:',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const _AcceptTermsExample(),
              SizedBox(height: el(3)),
              ElPanel(
                label: 'DART',
                note: 'IN A FIELD',
                child: DocsSelectableCodeBlock(code: _fieldUsageCode),
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'description',
          title: 'Description',
          child: ElText(
            'The Basic demo above already sets ElField\'s own description '
            '("You can withdraw consent at any time in Settings."). '
            'ElFieldScope threads it straight into ElCheckbox.hint, read '
            'after the label through Semantics.hint: the same '
            'aria-describedby wiring shadcn\'s FieldDescription authors by '
            'hand. No separate prop on ElCheckbox itself is needed once it '
            'is composed inside a ElField.',
            ElType.small,
            color: theme.mutedForeground,
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'disabled',
          title: 'Disabled',
          description:
              'enabled: false dims the control to 50% opacity and removes '
              'it from the tab order.',
          child: ElPanel(
            label: 'DART',
            note: 'DISABLED',
            child: DocsSelectableCodeBlock(code: _disabledUsageCode),
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'group',
          title: 'Group',
          description:
              'A list of independent checkboxes sharing one row layout, '
              'each one still a plain, uncoordinated ElCheckbox.',
          child: ElPanel(
            label: 'DART',
            note: 'FILTER ROW',
            child: DocsSelectableCodeBlock(code: _filterRowCode),
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'table',
          title: 'Table',
          description:
              'A header checkbox reflecting a partial selection across '
              'table rows: the case ElCheckboxState.indeterminate exists '
              'for.',
          child: ElPanel(
            label: 'DART',
            note: 'TRI-STATE BULK SELECTION',
            child: DocsSelectableCodeBlock(code: _bulkSelectionCode),
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'rtl',
          title: 'RTL',
          child: ElText(
            'ElCheckbox carries no left/right-specific geometry of its '
            'own: the socket is square, ElHitArea\'s insets grow '
            'symmetrically on every side, and the tick/bar paths are drawn '
            'in a fixed local coordinate space rather than mirrored. What '
            'flips under Directionality.rtl belongs entirely to whatever '
            'composes it: ElField and ElFieldLabel reorder label, control '
            'and description the same way any other Flutter row does under '
            'RTL, because nothing in checkbox.dart hardcodes a '
            'left-to-right assumption.',
            ElType.small,
            color: theme.mutedForeground,
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'api',
          title: 'API Reference',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const DocsApiTable(
                title: 'ElCheckbox',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'state',
                    type: 'ElCheckboxState',
                    description:
                        'Which of the three data-state values is rendered. '
                        'Defaults to ElCheckboxState.unchecked.',
                  ),
                  DocsApiFact(
                    name: 'onChanged',
                    type: 'ValueChanged<ElCheckboxState>?',
                    description:
                        'Called with the next state on tap or Enter/Space. '
                        'Null disables the control: the same "no handler, '
                        'no operation" rule ElButton follows.',
                  ),
                  DocsApiFact(
                    name: 'enabled',
                    type: 'bool',
                    description:
                        'Defaults to true. false dims the control to 50% '
                        'opacity and removes it from the tab order.',
                  ),
                  DocsApiFact(
                    name: 'inert',
                    type: 'bool',
                    description:
                        'Defaults to false. true holds the control at its '
                        'current state forever: full opacity, still '
                        'focusable, but a tap or Enter/Space does nothing. '
                        'Distinct from enabled: false: see States.',
                  ),
                  DocsApiFact(
                    name: 'invalid',
                    type: 'bool',
                    description:
                        'Defaults to false. true paints the destructive '
                        'border and ring. ORed with the enclosing '
                        'ElFieldScope\'s own invalid flag.',
                  ),
                  DocsApiFact(
                    name: 'forceFocusRing',
                    type: 'bool?',
                    description:
                        'true paints the focus ring without owning focus, '
                        'false withholds it even while genuinely focused, '
                        'and null (the default) follows real focus.',
                  ),
                  DocsApiFact(
                    name: 'focusNode',
                    type: 'FocusNode?',
                    description:
                        'Overrides the node a ElFieldScope would otherwise '
                        'supply.',
                  ),
                  DocsApiFact(
                    name: 'label',
                    type: 'String?',
                    description:
                        'The accessible name. Not rendered as visible text, '
                        'pair with ElField (or ElFieldLabel) for a visible '
                        'caption.',
                  ),
                  DocsApiFact(
                    name: 'hint',
                    type: 'String?',
                    description:
                        'Read after the label: the aria-describedby '
                        'analogue, resolved through Semantics.hint.',
                  ),
                ],
              ),
              SizedBox(height: el(5)),
              const DocsApiTable(
                title: 'ElCheckboxState and statics',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'ElCheckboxState.unchecked',
                    type: 'enum value',
                    description: 'No indicator mounted. isOn is false.',
                  ),
                  DocsApiFact(
                    name: 'ElCheckboxState.checked',
                    type: 'enum value',
                    description: 'The self-drawing tick mark. isOn is true.',
                  ),
                  DocsApiFact(
                    name: 'ElCheckboxState.indeterminate',
                    type: 'enum value',
                    description:
                        'The same lit box, carrying a bar instead of a '
                        'tick. isOn is true.',
                  ),
                  DocsApiFact(
                    name: 'ElCheckbox.size',
                    type: 'static double',
                    description:
                        'The 20px box size: bigger than the reference\'s '
                        'own default because a 16px target and tick were '
                        'judged illegible.',
                  ),
                  DocsApiFact(
                    name: 'ElCheckbox.nextAfter',
                    type: 'static ElCheckboxState Function(ElCheckboxState)',
                    description:
                        'What a click produces: anything not already '
                        'checked becomes checked, and checked becomes '
                        'unchecked.',
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'states',
          title: 'States',
          description:
              'Hover, Pressed, Loading, Empty and Success are omitted below: '
              'reasons follow the table.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const DocsStateMatrix(
                facts: <DocsStateFact>[
                  DocsStateFact(
                    state: 'Rest (unchecked)',
                    treatment:
                        'theme.card fill, theme.input border, pressed-style '
                        'shadow.',
                    userSignal: 'An empty 20px box; no indicator is mounted.',
                  ),
                  DocsStateFact(
                    state: 'Selected (checked)',
                    treatment:
                        'theme.primary fill and border; the tick draws '
                        'itself, stroke first, over its own reveal.',
                    userSignal:
                        'A drawn checkmark rather than a faded-in one, '
                        'visible even to a reader who cannot rely on the '
                        'fill colour changing.',
                  ),
                  DocsStateFact(
                    state: 'Indeterminate',
                    treatment:
                        'The same lit socket as Checked, carrying a '
                        'horizontal bar instead of a tick; re-draws from '
                        'zero on every reveal.',
                    userSignal:
                        'A bar, not a tick: the shape itself signals '
                        '"partially selected," not just a third colour.',
                  ),
                  DocsStateFact(
                    state: 'Inert',
                    treatment:
                        'inert: true holds the control at its current '
                        'state forever, regardless of onChanged.',
                    userSignal:
                        'Full opacity, still in the tab order, looks '
                        'exactly like an operable checkbox: a tap or '
                        'Enter/Space does nothing. Reproduced from the '
                        'reference on purpose, not a bug.',
                  ),
                  DocsStateFact(
                    state: 'Focus-visible',
                    treatment: 'border-ring plus a 3px ring at 50% alpha.',
                    userSignal:
                        'A visible ring around the box: beaten by Error '
                        'below when both apply.',
                  ),
                  DocsStateFact(
                    state: 'Error',
                    treatment:
                        'invalid: true swaps the border and ring to the '
                        'destructive colour at 20% ring alpha.',
                    userSignal:
                        'aria-invalid beats focus-visible: a focused, '
                        'invalid checkbox looks pixel-identical to an '
                        'unfocused invalid one: reproduced faithfully '
                        'rather than "fixed".',
                  ),
                  DocsStateFact(
                    state: 'Disabled',
                    treatment:
                        'enabled: false drops opacity to 50% and removes '
                        'the control from the tab order and from pointer '
                        'and keyboard handling.',
                    userSignal:
                        'Visibly and operably inert: the one state that '
                        'dims.',
                  ),
                  DocsStateFact(
                    state: 'Reduced motion',
                    treatment:
                        'The tick/bar keyframe player fills both ends, so '
                        'a reduced-motion context lands directly on the '
                        'finished stroke instead of drawing to it; the '
                        'socket colour and shadow tween collapses to its '
                        'resolved (near-zero) duration.',
                    userSignal:
                        'The same end state, with no draw-on animation to '
                        'sit through.',
                  ),
                ],
              ),
              SizedBox(height: el(4)),
              ElText(
                'Omitted: Hover: no control in this family authors a '
                'hover skin; only the pointer cursor changes. Pressed, '
                'there is no separate pointer-down look; the box squashes '
                'once, after the state actually changes, via ElJellyReplay, '
                'which is a post-toggle reveal rather than a held-down '
                'state. Loading and Empty, ElCheckbox is a synchronous '
                'primitive with no async operation and nothing to list, so '
                'neither applies. Success: the component defines no '
                'success semantics of its own.',
                ElType.small,
                color: theme.mutedForeground,
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'accessibility',
          title: 'Accessibility',
          child: DocsInstallFacts(
            title: 'Accessibility',
            facts: <DocsInstallFact>[
              const DocsInstallFact(
                label: 'Semantic role',
                value: 'Semantics(checked:, mixed:)',
                description:
                    'unchecked -> checked: false, mixed: false. checked -> '
                    'checked: true. indeterminate -> checked: false, mixed: '
                    'true: read by assistive technology as a tri-state '
                    'checkbox.',
              ),
              const DocsInstallFact(
                label: 'Label association',
                value: 'label',
                description:
                    'Feeds the control\'s accessible name directly. It is '
                    'never rendered as visible text: compose with ElField '
                    '(or a ElFieldLabel) for a caption a sighted user can '
                    'read; tapping that visible label activates the '
                    'control through the same activator wiring an HTML '
                    '<label for> click would use.',
              ),
              const DocsInstallFact(
                label: 'Keyboard activation',
                value: 'Enter, numpad Enter, Space',
                description:
                    'Wired by hand through Focus.onKeyEvent: the control '
                    'is not a native button, so nothing arrives for free.',
              ),
              const DocsInstallFact(
                label: 'Focus behavior',
                value: 'border-ring plus a 3px ring at 50% alpha',
                description:
                    'aria-invalid beats focus-visible at equal '
                    'specificity, reproduced from the reference: a '
                    'focused, invalid checkbox shows no visible change '
                    'from an unfocused invalid one.',
              ),
              const DocsInstallFact(
                label: 'Touch target',
                value: '42 x 34, centred on a 20 x 20 box',
                description:
                    'ElHitArea grows the hit test past the painted box. '
                    'Measured from the reference at 2px short of the '
                    'system\'s own 44px floor on both axes: recorded, not '
                    'corrected, because it is what the reference renders.',
              ),
              const DocsInstallFact(
                label: 'Non-colour signal',
                value: 'A drawn glyph, not just a fill change',
                description:
                    'Checked draws a tick and indeterminate draws a bar, '
                    'two different shapes, so the state does not depend on '
                    'a reader distinguishing fill colours.',
              ),
              const DocsInstallFact(
                label: 'Error wiring',
                value: 'invalid, ORed with the enclosing ElFieldScope',
                description:
                    'A ElField around the control folds its own invalid '
                    'flag in, and colours the field\'s text with '
                    'theme.destructiveInk when either is true.',
              ),
              const DocsInstallFact(
                label: 'Screen-reader announcements',
                value: 'No live region',
                description:
                    'State changes are exposed purely through the '
                    'checked/mixed flags on the merged semantics node; no '
                    'extra announcement is authored.',
              ),
              const DocsInstallFact(
                label: 'Known drift',
                value: 'inert renders as fully operable',
                description:
                    'inert: true carries no disabled semantics at all, '
                    'the control announces enabled: true: so a screen '
                    'reader gets no more signal than a sighted reader that '
                    'the control cannot be operated. Reproduced from the '
                    'reference on purpose.',
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'responsive',
          title: 'Responsive',
          child: ElText(
            'ElCheckbox has no responsive breakpoints of its own: it is a '
            'fixed 20 x 20 atomic control with a fixed 42 x 34 hit area, '
            'identical across mobile, tablet, desktop and web. What '
            'changes with layout belongs to whatever composes it: ElField '
            'reflows its label and description, and a filter list or '
            'bulk-selection row decides its own wrap behaviour. Keyboard '
            'activation (Enter/Space) and pointer activation behave '
            'identically on every Flutter target this package supports; '
            'there is no platform channel and nothing here is web-only or '
            'desktop-only.',
            ElType.small,
            color: theme.mutedForeground,
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'dependencies',
          title: 'Dependencies',
          child: DocsInstallFacts(
            title: 'Dependencies and files',
            facts: <DocsInstallFact>[
              DocsInstallFact(
                label: 'Source file',
                value: checkboxDoc.sourcePath,
                description: 'The authoritative implementation.',
              ),
              const DocsInstallFact(
                label: 'Local file dependencies',
                value:
                    'selection_control.dart, field.dart, icon_paths.dart, '
                    'motion/keyframes.dart',
                description:
                    'checkbox.dart imports these directly: '
                    'selection_control.dart for the shared socket / hit-area '
                    '/ focus-ring machinery (ElSelectionControl), field.dart '
                    'for ElFieldScope wiring, icon_paths.dart for the '
                    '24-unit icon grid, and motion/keyframes.dart for the '
                    'self-drawing stroke player. None are copyable in '
                    'isolation: see Installation.',
              ),
              const DocsInstallFact(
                label: 'Foundation dependencies',
                value:
                    'foundation/motion.dart, foundation/shadows.dart, '
                    'foundation/spacing.dart, foundation/theme.dart, '
                    'theme_scope.dart',
                description:
                    'Token sources: durations and curves, shadow specs, the '
                    'el() spacing scale, and the live theme.',
              ),
              DocsInstallFact(
                label: 'Exports',
                value: checkboxDoc.exports.join(', '),
                description:
                    'The public symbols this component makes available.',
              ),
              const DocsInstallFact(
                label: 'Assets',
                value: 'none',
                description:
                    'The tick and bar are drawn with CustomPainter path '
                    'geometry, not an image or an icon-font glyph.',
              ),
              const DocsInstallFact(
                label: 'Fonts',
                value: 'none',
                description: 'No text is rendered by ElCheckbox itself.',
              ),
              const DocsInstallFact(
                label: 'Shaders',
                value: 'none',
                description: 'No fragment shader is used.',
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'theming',
          title: 'Theming',
          child: DocsInstallFacts(
            title: 'Tokens this component reads',
            facts: const <DocsInstallFact>[
              DocsInstallFact(
                label: 'Fill',
                value:
                    'theme.card (rest) / theme.primary (checked or '
                    'indeterminate)',
                description: 'Socket background.',
              ),
              DocsInstallFact(
                label: 'Border',
                value:
                    'theme.input (rest) / theme.primary (lit) / theme.ring '
                    '(focus-visible) / theme.destructive (invalid)',
                description:
                    'Resolved in that precedence order: invalid always '
                    'wins.',
              ),
              DocsInstallFact(
                label: 'Mark colour',
                value: 'theme.primaryForeground',
                description: 'The drawn tick/bar stroke.',
              ),
              DocsInstallFact(
                label: 'Shadow',
                value: 'ElShadows.pressed (rest) / ElShadows.btnPrimary (lit)',
                description:
                    'The socket shadow spec, composed with the focus or '
                    'invalid ring.',
              ),
              DocsInstallFact(
                label: 'Radius',
                value: 'ElRadii.sm (6px)',
                description: 'The socket corner.',
              ),
              DocsInstallFact(
                label: 'Motion',
                value:
                    'ElDurations.transitionDefault, ElKeyframePlayer, '
                    'ElJellyReplay',
                description:
                    'Socket colour/border/ring tween duration, the '
                    'self-drawing stroke, and the post-toggle squash: all '
                    'resolved through elAnimationDuration, so reduced '
                    'motion shortens or removes them automatically.',
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'source',
          title: 'Source',
          child: DocsInstallFacts(
            facts: <DocsInstallFact>[
              DocsInstallFact(
                label: 'Component source',
                value: checkboxDoc.sourcePath,
                description: 'Authoritative implementation.',
              ),
              const DocsInstallFact(
                label: 'Shared machinery',
                value: 'lib/src/components/selection_control.dart',
                description:
                    'ElSelectionControl, ElHitArea and ElJellyReplay, '
                    'shared with the switch and radio families and '
                    'documented on their own component page.',
              ),
              const DocsInstallFact(
                label: 'Package tests',
                value: 'test/selection_feedback_test.dart',
                description:
                    'State-matrix and geometry coverage for ElCheckbox in '
                    'the package itself.',
              ),
              const DocsInstallFact(
                label: 'Docs page tests',
                value: 'example/test/components_docs/checkbox_test.dart',
                description:
                    'Coverage for this page: API completeness, the live '
                    'specimen toggle, and both themes.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

const String _basicUsageCode =
    '''import 'package:elattar_design_system/elattar_design_system.dart';

ElCheckbox(label: 'Accept the terms')''';

const String _smallestUsageCode = '''bool accepted = false;

ElCheckbox(
  state: accepted ? ElCheckboxState.checked : ElCheckboxState.unchecked,
  label: 'Accept the terms',
  onChanged: (ElCheckboxState next) {
    setState(() => accepted = next == ElCheckboxState.checked);
  },
)''';

const String _invalidUsageCode = '''ElCheckbox(
  invalid: true,
  label: 'Accept the terms',
)''';

const String _disabledUsageCode = '''ElCheckbox(
  enabled: false,
  label: 'Disabled',
)''';

const String _fieldUsageCode = '''ElField(
  label: 'Accept the terms and conditions',
  description: 'You can withdraw consent at any time in Settings.',
  orientation: ElFieldOrientation.horizontal,
  child: ElCheckbox(
    state: accepted ? ElCheckboxState.checked : ElCheckboxState.unchecked,
    onChanged: (ElCheckboxState next) {
      setState(() => accepted = next == ElCheckboxState.checked);
    },
  ),
)''';

const String _filterRowCode = '''Row(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: <Widget>[
    ElCheckbox(
      state: checked ? ElCheckboxState.checked : ElCheckboxState.unchecked,
      label: label,
      onChanged: (ElCheckboxState next) =>
          onChanged(next == ElCheckboxState.checked),
    ),
    SizedBox(width: ElField.gap),
    Expanded(
      child: ElFieldLabel(
        label,
        spec: ElFieldLabel.normal,
        onTap: () => onChanged(!checked),
      ),
    ),
    ElText(count, ElType.numSm),
  ],
)''';

const String _bulkSelectionCode =
    '''// selectedCount tracks how many of `total` rows are checked.
ElCheckbox(
  state: selectedCount == 0
      ? ElCheckboxState.unchecked
      : selectedCount == total
          ? ElCheckboxState.checked
          : ElCheckboxState.indeterminate,
  label: 'Select all \$total rows',
  onChanged: (ElCheckboxState next) {
    final bool selectAll = next == ElCheckboxState.checked;
    setState(() {
      for (int i = 0; i < total; i++) {
        rowSelected[i] = selectAll;
      }
    });
  },
)''';

/// The seven-cell live specimen grid for the "Preview" section.
class _CheckboxPreview extends StatefulWidget {
  const _CheckboxPreview();

  @override
  State<_CheckboxPreview> createState() => _CheckboxPreviewState();
}

class _CheckboxPreviewState extends State<_CheckboxPreview> {
  ElCheckboxState _unchecked = ElCheckboxState.unchecked;
  ElCheckboxState _checked = ElCheckboxState.checked;
  ElCheckboxState _focus = ElCheckboxState.unchecked;
  ElCheckboxState _error = ElCheckboxState.unchecked;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: el(3),
      runSpacing: el(3),
      children: <Widget>[
        ElStateCell(
          label: 'Unchecked',
          note: 'Tap to toggle',
          child: ElCheckbox(
            key: const ValueKey<String>('checkbox-live-specimen'),
            state: _unchecked,
            label: 'Unchecked',
            onChanged: (ElCheckboxState next) =>
                setState(() => _unchecked = next),
          ),
        ),
        ElStateCell(
          label: 'Checked',
          note: 'Tap to toggle',
          child: ElCheckbox(
            state: _checked,
            label: 'Checked',
            onChanged: (ElCheckboxState next) =>
                setState(() => _checked = next),
          ),
        ),
        const ElStateCell(
          label: 'Indeterminate',
          note: 'Held here on purpose: see States',
          child: ElCheckbox(
            state: ElCheckboxState.indeterminate,
            inert: true,
            label: 'Indeterminate',
          ),
        ),
        ElStateCell(
          label: 'Focus-visible',
          note: 'Ring painted, not focused',
          child: ElCheckbox(
            state: _focus,
            forceFocusRing: true,
            label: 'Focus-visible',
            onChanged: (ElCheckboxState next) => setState(() => _focus = next),
          ),
        ),
        ElStateCell(
          label: 'Error',
          note: 'invalid: true',
          child: ElCheckbox(
            state: _error,
            invalid: true,
            label: 'Error',
            onChanged: (ElCheckboxState next) => setState(() => _error = next),
          ),
        ),
        const ElStateCell(
          label: 'Disabled',
          child: ElCheckbox(enabled: false, label: 'Disabled'),
        ),
        const ElStateCell(
          label: 'Disabled checked',
          child: ElCheckbox(
            state: ElCheckboxState.checked,
            enabled: false,
            label: 'Disabled checked',
          ),
        ),
      ],
    );
  }
}

/// A live, functioning `ElField`-wrapped checkbox for the "Basic" section:
/// proof the composition it documents actually renders and toggles, not just
/// a code excerpt.
class _AcceptTermsExample extends StatefulWidget {
  const _AcceptTermsExample();

  @override
  State<_AcceptTermsExample> createState() => _AcceptTermsExampleState();
}

class _AcceptTermsExampleState extends State<_AcceptTermsExample> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    return ElField(
      label: 'Accept the terms and conditions',
      description: 'You can withdraw consent at any time in Settings.',
      orientation: ElFieldOrientation.horizontal,
      child: ElCheckbox(
        state: _accepted ? ElCheckboxState.checked : ElCheckboxState.unchecked,
        onChanged: (ElCheckboxState next) =>
            setState(() => _accepted = next == ElCheckboxState.checked),
      ),
    );
  }
}
