/// Public component documentation for the radio group component.
///
/// `radioDoc` (from `meta.dart`) is the data source, not
/// `componentDoc('radio')` — radio is not yet registered in `catalog.dart`'s
/// `componentDocs` list, so calling that would throw. Adding it there is a
/// supervisor-owned aggregation step (Phase J plan).
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

class RadioDocPage extends StatelessWidget {
  const RadioDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    return DocsLayout(
      route: radioDoc.route,
      intro: DocsPageIntro(
        eyebrow: 'COMPONENTS / BASE',
        title: radioDoc.title,
        description: radioDoc.description,
      ),
      breadcrumbs: const <DsBreadcrumbEntry>[
        DsBreadcrumbEntry.link('Components'),
        DsBreadcrumbEntry.page('Radio group'),
      ],
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Overview', anchor: 'overview'),
        DocsTocEntry(title: 'Status', anchor: 'status'),
        DocsTocEntry(title: 'Preview', anchor: 'preview'),
        DocsTocEntry(title: 'Installation', anchor: 'install'),
        DocsTocEntry(title: 'Usage', anchor: 'usage'),
        DocsTocEntry(title: 'API', anchor: 'api'),
        DocsTocEntry(title: 'Variants and sizes', anchor: 'variants'),
        DocsTocEntry(title: 'States', anchor: 'states'),
        DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
        DocsTocEntry(title: 'Responsive behavior', anchor: 'responsive'),
        DocsTocEntry(title: 'Dependencies and files', anchor: 'dependencies'),
        DocsTocEntry(title: 'Composition', anchor: 'composition'),
        DocsTocEntry(title: 'Theming', anchor: 'theming'),
        DocsTocEntry(title: 'Source', anchor: 'source'),
      ],
      // Wave 2's alphabetical neighbours (Phase J plan inventory: button_group,
      // combobox, field, form, input_group, input_otp, native_select, radio,
      // selection_control, slider, textarea). Neither route is registered yet
      // either — the whole wave's previous/next chain is stitched together
      // once the supervisor aggregates every meta.dart, the same as this
      // page's own route is not reachable until then.
      previous: const DocsPageLink(
        title: 'Native select',
        route: '/components/native_select',
      ),
      next: const DocsPageLink(
        title: 'Selection control',
        route: '/components/selection_control',
      ),
      onNavigate: onNavigate,
      child: _RadioArticle(theme: DsTheme.of(context)),
    );
  }
}

class _RadioArticle extends StatelessWidget {
  const _RadioArticle({required this.theme});

  final DsThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey<String>('radio-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsSection(
          id: 'overview',
          title: 'When to use a radio group',
          description:
              'What it solves, and when a neighbouring control answers the '
              'same interaction better.',
          child: DsText(
            'DsRadioGroup lets a user pick exactly one value out of a small '
            'set of options that all stay visible on screen at once — '
            '"daily" or "weekly" payout, never both, and never neither once '
            'something is chosen. Its options exist only in relation to each '
            'other: selecting one always deselects whichever was selected '
            'before, because the whole group shares a single value. Reach '
            'for DsCheckbox instead when the value is independent of every '
            'other option on the screen — "notify me by email" is true or '
            'false on its own, with no sibling it competes against, and a '
            'checkbox group (unlike a radio group) can legitimately have '
            'every box checked at once. Reach for DsSelect instead once the '
            'option count grows past what is comfortable to lay out on '
            'screen, or the choice does not need to stay visible until the '
            'user actually opens it — a radio group spends permanent space '
            'showing every option so the full set is scannable at a glance, '
            'while a select collapses the same list behind one trigger and '
            'costs nothing until it is opened. As a rule of thumb: few and '
            'always-visible favours DsRadioGroup, many and worth hiding '
            'favours DsSelect, and independent-of-everything-else favours '
            'DsCheckbox.',
            DsType.body,
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'status',
          title: 'Status',
          child: DocsInstallFacts(
            title: 'Status',
            facts: <DocsInstallFact>[
              const DocsInstallFact(
                label: 'Status',
                value: 'Stable, not yet a registry item',
                description:
                    'Ported and tested against lib/src/components/radio.dart. '
                    'It is not yet a registry item, so elattar add radio '
                    'will not resolve — see Installation below.',
              ),
              DocsInstallFact(
                label: 'Version',
                value: '0.0.1',
                description:
                    'Tracks the package version; there is no registry schema '
                    'version yet because there is no manifest.',
              ),
              const DocsInstallFact(
                label: 'Platforms',
                value: 'Android, iOS, Web, macOS, Windows, Linux',
                description:
                    'A pure Flutter widget tree — no platform channel and no '
                    'platform-specific branch.',
              ),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'preview',
          title: 'Preview',
          description:
              'Six live specimens, all built from real DsRadioGroup and '
              'DsRadioGroupItem widgets. Payout rhythm, Focus-visible and '
              'Error are operable — tap an option. Disabled, Disabled '
              '(selected) and Group disabled are deliberately inert; all '
              'three are explained in States below.',
          child: DocsCodeExample(
            title: 'Radio group specimens',
            description:
                'Every cell below renders a real DsRadioGroup wrapping real '
                'DsRadioGroupItem children.',
            preview: const _RadioPreview(),
            manualFiles: <DocsCodeFile>[
              DocsCodeFile(
                path: radioDoc.sourcePath,
                code:
                    '// radio has no registry manifest yet, so there is no\n'
                    '// generated @ui/radio.dart payload to copy here.\n'
                    '// See "Installation" below for what actually works today.',
              ),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'install',
          title: 'Installation',
          description:
              'Command install is not available yet — read this before '
              'reaching for elattar add radio.',
          child: DocsInstallFacts(
            facts: <DocsInstallFact>[
              const DocsInstallFact(
                label: 'CLI',
                value: 'Not available',
                description:
                    'radio is not yet a registry item, so `elattar add '
                    'radio` will not resolve. It is one of the Wave 2 form '
                    'components still awaiting a manifest — see the Phase J '
                    'documentation plan.',
              ),
              const DocsInstallFact(
                label: 'Manual — package mode (supported today)',
                value:
                    "import 'package:elattar_design_system/elattar_design_system.dart';",
                description:
                    'Depend on the package and use DsRadioGroup and '
                    'DsRadioGroupItem directly, exactly as this page does.',
              ),
              DocsInstallFact(
                label: 'Manual — source mode (not recommended yet)',
                value: radioDoc.sourcePath,
                description:
                    'Copying this one file will not compile on its own — it '
                    'needs its sibling files with it (see Dependencies and '
                    'files below), and no manifest exists yet to resolve '
                    'them for you.',
              ),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'usage',
          title: 'Usage',
          description:
              'The smallest correct example, then the labelled, real-world '
              'shape.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DsPanel(
                label: 'DART',
                note: 'SMALLEST CORRECT EXAMPLE',
                child: DocsSelectableCodeBlock(code: _smallestUsageCode),
              ),
              SizedBox(height: ds(5)),
              DsText(
                'A bare DsRadioGroupItem renders no visible text of its own — '
                'its label only supplies the accessible name, the same rule '
                'DsCheckbox follows. The real composed-forms pattern pairs a '
                'DsFieldSet and DsFieldLegend for the group\'s visible '
                'caption with one horizontal DsField per item for each '
                'option\'s own visible label — exactly what the source '
                'comments on DsRadioGroup and DsRadioGroupItem describe, and '
                'what the composed forms page in this repository actually '
                'builds:',
                DsType.small,
                color: theme.mutedForeground,
              ),
              SizedBox(height: ds(3)),
              const _PayoutRhythmExample(),
              SizedBox(height: ds(3)),
              DsPanel(
                label: 'DART',
                note: 'FIELDSET + LEGEND + PER-ITEM FIELD',
                child: DocsSelectableCodeBlock(code: _fieldSetUsageCode),
              ),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'api',
          title: 'API',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const DocsApiTable(
                title: 'DsRadioGroup<T>',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'value',
                    type: 'T?',
                    description:
                        'The selected item, compared against each item\'s own '
                        'value by ==. null while nothing is chosen.',
                  ),
                  DocsApiFact(
                    name: 'onChanged',
                    type: 'ValueChanged<T>?',
                    description:
                        'Called with the value of whichever item the user '
                        'picked — by tap, by Enter/Space on the focused item, '
                        'or by an arrow key that moves the selection. null '
                        'disables every item in the group.',
                  ),
                  DocsApiFact(
                    name: 'children',
                    type: 'List<Widget>',
                    description:
                        'The rows. Each holds a DsRadioGroupItem<T> '
                        'somewhere inside it — either bare, or wrapped in its '
                        'own DsField for a visible per-option label.',
                  ),
                  DocsApiFact(
                    name: 'gap',
                    type: 'double?',
                    description:
                        'The vertical space between rows. Defaults to '
                        'DsRadioGroup.defaultGap (8px); the composed forms '
                        'page passes DsFieldSet.groupGap (12px) instead.',
                  ),
                  DocsApiFact(
                    name: 'enabled',
                    type: 'bool',
                    description:
                        'Defaults to true. Disables every item; ANDed with '
                        'the enclosing DsFieldScope\'s own enabled flag when '
                        'the group itself sits in a DsField.',
                  ),
                  DocsApiFact(
                    name: 'invalid',
                    type: 'bool',
                    description:
                        'Defaults to false. true paints the destructive '
                        'border and ring on every item. ORed with the '
                        'enclosing DsFieldScope\'s own invalid flag.',
                  ),
                  DocsApiFact(
                    name: 'focusNode',
                    type: 'FocusNode?',
                    description:
                        'The node a failed form submit lands on, adopted '
                        'from the enclosing DsFieldScope when null. The '
                        'group itself never keeps this focus — it forwards '
                        'it straight to the roving tab-stop item, so a '
                        'keyboard user always lands on a real, operable '
                        'radio and never on the group container.',
                  ),
                  DocsApiFact(
                    name: 'label',
                    type: 'String?',
                    description:
                        'The group\'s accessible name — the legend\'s text, '
                        'announced as a whole rather than through '
                        '`<label for>`: an HTML label may only point at a '
                        'labelable element and a radio group container is a '
                        'div, so this is the one place the port cannot lean '
                        'on the id-graph translation it uses everywhere '
                        'else.',
                  ),
                  DocsApiFact(
                    name: 'hint',
                    type: 'String?',
                    description:
                        'Read after the label — the aria-describedby '
                        'analogue for the group as a whole, resolved through '
                        'Semantics.hint.',
                  ),
                ],
              ),
              SizedBox(height: ds(5)),
              const DocsApiTable(
                title: 'DsRadioGroupItem<T>',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'value',
                    type: 'T',
                    description:
                        'This item\'s own value. The item renders checked '
                        'exactly when the enclosing group\'s value equals '
                        'this one — there is no separate checked or state '
                        'field to set by hand.',
                  ),
                  DocsApiFact(
                    name: 'enabled',
                    type: 'bool',
                    description:
                        'Defaults to true. ANDed with the group\'s own '
                        'enabled flag and, when this item sits in its own '
                        'nested DsField, with that field\'s enabled flag too.',
                  ),
                  DocsApiFact(
                    name: 'invalid',
                    type: 'bool',
                    description:
                        'Defaults to false. ORed with the group\'s invalid '
                        'flag and, when this item has its own nested '
                        'DsField, with that field\'s invalid flag.',
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
                    name: 'label',
                    type: 'String?',
                    description:
                        'This item\'s own accessible name — never the '
                        'group\'s legend. Falls back to this item\'s own '
                        'nested DsField\'s label when it has one, and to '
                        'nothing when it does not.',
                  ),
                  DocsApiFact(
                    name: 'hint',
                    type: 'String?',
                    description:
                        'This item\'s own aria-describedby analogue, '
                        'resolved the same way as label: its own value '
                        'first, then its own nested field\'s.',
                  ),
                ],
              ),
              SizedBox(height: ds(5)),
              const DocsApiTable(
                title: 'Static helpers',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'DsRadioGroup.defaultGap',
                    type: 'static double',
                    description:
                        'The Root\'s own row gap, 8px, used whenever gap is '
                        'left null.',
                  ),
                  DocsApiFact(
                    name: 'DsRadioGroupItem.size',
                    type: 'static double',
                    description:
                        'The 20px circle — sized to sit level with '
                        'DsCheckbox rather than the reference\'s own smaller '
                        'default.',
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'variants',
          title: 'Variants and sizes',
          description:
              'Not applicable — recorded rather than silently skipped.',
          child: DsText(
            'Neither DsRadioGroup nor DsRadioGroupItem has a variant or '
            'size parameter. DsRadioGroupItem.size fixes one geometry — '
            '20px, "level with a checkbox" per the source\'s own comment — '
            'with nothing smaller or larger to choose between, the same '
            'ruling DsCheckbox makes for its own 20px box. Unlike '
            'DsCheckbox, DsRadioGroupItem also has no inert flag: there is '
            'no third "held at a value forever" state on an individual '
            'radio, only enabled and disabled.',
            DsType.small,
            color: theme.mutedForeground,
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'states',
          title: 'States and feedback',
          description:
              'Hover, Pressed, Loading, Empty and Success are omitted below '
              '— reasons follow the table.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const DocsStateMatrix(
                facts: <DocsStateFact>[
                  DocsStateFact(
                    state: 'Rest (unselected)',
                    treatment:
                        'theme.card fill, theme.input border, pressed-style '
                        'shadow — identical socket mechanics to an '
                        'unchecked checkbox, drawn as a circle.',
                    userSignal: 'An empty 20px ring; no dot is mounted.',
                  ),
                  DocsStateFact(
                    state: 'Selected',
                    treatment:
                        'theme.primary fill and border; an 8px filled dot '
                        'mounts and pops in — scale 0 → 1.35 at 55% → 1 on '
                        'the spring curve — rather than fading or drawing a '
                        'stroke. Mounted only while this item is the '
                        'group\'s value, so the pop replays on every real '
                        'selection and never on an unrelated rebuild.',
                    userSignal:
                        'A small raised dot popping into the centre — '
                        'visible even to a reader who cannot rely on the '
                        'fill colour changing.',
                  ),
                  DocsStateFact(
                    state: 'Focus-visible',
                    treatment: 'border-ring plus a 3px ring at 50% alpha.',
                    userSignal:
                        'A visible ring around whichever item holds the '
                        'group\'s one roving tab stop — beaten by Error '
                        'below when both apply.',
                  ),
                  DocsStateFact(
                    state: 'Error',
                    treatment:
                        'invalid: true (on the item, the group, or a '
                        'per-item nested field) swaps the border and ring '
                        'to the destructive colour at 20% ring alpha.',
                    userSignal:
                        'aria-invalid beats focus-visible: a focused, '
                        'invalid item looks pixel-identical to an unfocused '
                        'invalid one — reproduced faithfully from the rest '
                        'of the selection-control family rather than '
                        '"fixed".',
                  ),
                  DocsStateFact(
                    state: 'Disabled',
                    treatment:
                        'Three independent levers land on the same dimmed, '
                        'deaf rendering: the group\'s own enabled: false; '
                        'the group\'s onChanged: null (which disables every '
                        'item even when each item\'s own enabled stays '
                        'true); or one item\'s own enabled: false, '
                        'including through that item\'s own nested DsField '
                        'going disabled.',
                    userSignal:
                        '50% opacity, out of the tab order, deaf to pointer '
                        'and keyboard — the one state that dims.',
                  ),
                  DocsStateFact(
                    state: 'Reduced motion',
                    treatment:
                        'The dot-pop keyframe player fills both ends, so a '
                        'reduced-motion context lands directly on the '
                        'settled 8px dot instead of playing the overshoot; '
                        'the socket colour/border/ring tween collapses to '
                        'its resolved near-zero duration.',
                    userSignal:
                        'The same end state, with no pop to sit through.',
                  ),
                ],
              ),
              SizedBox(height: ds(4)),
              DsText(
                'Omitted: Hover — no control in this family authors a '
                'hover skin; only the pointer cursor changes. Pressed — '
                'there is no separate pointer-down look; each socket that '
                'actually changes value squashes once, after the change, '
                'via DsJellyReplay — both the item that becomes selected '
                'and the one that was selected a moment ago squash, because '
                'both genuinely changed state. Loading and Empty — '
                'DsRadioGroup is a synchronous primitive with no async '
                'operation and nothing to list, so neither applies. Success '
                '— the component defines no success semantics of its own.',
                DsType.small,
                color: theme.mutedForeground,
              ),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'accessibility',
          title: 'Accessibility',
          child: DocsInstallFacts(
            title: 'Accessibility',
            facts: <DocsInstallFact>[
              const DocsInstallFact(
                label: 'Semantic role',
                value:
                    'Semantics(container:) on the group, '
                    'Semantics(inMutuallyExclusiveGroup:, checked:) on each '
                    'item',
                description:
                    'The group carries a container semantics node; each '
                    'item is flagged as a member of a mutually exclusive '
                    'group with its own checked flag — Flutter\'s nearest '
                    'primitive to an ARIA radiogroup and its radios.',
              ),
              const DocsInstallFact(
                label: 'Label association',
                value: 'label on the group; label on each item',
                description:
                    'The group\'s label (or its own enclosing field\'s) is '
                    'announced as the legend for the whole set. Each item\'s '
                    'own label (or its own nested field\'s — never the '
                    'group\'s) is announced as that one option\'s name. '
                    'Neither is rendered as visible text on its own; a '
                    'DsFieldSet + DsFieldLegend gives the group a visible '
                    'caption, and a per-item DsField gives each option one.',
              ),
              const DocsInstallFact(
                label: 'Keyboard: tab stop',
                value: 'The group is one tab stop, not N (roving tabindex)',
                description:
                    'Tab reaches the currently selected item, or the first '
                    'enabled item when nothing is selected yet; every other '
                    'item is focusable but skipped in tab order.',
              ),
              const DocsInstallFact(
                label: 'Keyboard: arrows',
                value:
                    'Arrow Up/Left and Down/Right move AND select, and they '
                    'wrap',
                description:
                    'Verified against the real implementation rather than '
                    'assumed: an arrow key does not just move focus, it '
                    'calls onChanged with the destination item\'s value in '
                    'the same step and moves focus to it — the full ARIA '
                    'radiogroup contract, wrapping from the last enabled '
                    'item back to the first and back again.',
              ),
              const DocsInstallFact(
                label: 'Keyboard: activation',
                value: 'Enter, numpad Enter, Space',
                description:
                    'Selects whichever item currently holds focus. Wired by '
                    'hand through Focus.onKeyEvent — the control is not a '
                    'native button, so nothing arrives for free.',
              ),
              const DocsInstallFact(
                label: 'Focus behavior',
                value: 'border-ring plus a 3px ring at 50% alpha',
                description:
                    'The group\'s own Focus node (adopted from a '
                    'DsFieldScope, e.g. a failed form submit) skips '
                    'traversal and immediately forwards to the tab-stop '
                    'item rather than holding focus itself — the group is '
                    'not itself operable, so a keyboard user always sees '
                    'the ring on a real, selectable item.',
              ),
              const DocsInstallFact(
                label: 'Label tap: group vs item',
                value:
                    'Tapping the group\'s label focuses; tapping an '
                    'item\'s own label selects',
                description:
                    'A DsFieldSet + DsFieldLegend caption over the whole '
                    'group only moves focus to the tab-stop item when '
                    'tapped — a legend cannot select on behalf of a set it '
                    'only names. A visible label from an item\'s own nested '
                    'DsField genuinely selects that one option when tapped, '
                    'the same activator wiring an HTML <label for> click '
                    'uses.',
              ),
              const DocsInstallFact(
                label: 'Touch target',
                value: '42 x 34, centred on each 20 x 20 circle',
                description:
                    'DsHitArea grows the hit test past the painted circle, '
                    'identical to DsCheckbox\'s own measurement — 2px short '
                    'of the system\'s own 44px floor on both axes, recorded '
                    'rather than corrected.',
              ),
              const DocsInstallFact(
                label: 'Non-colour signal',
                value: 'A raised, popping dot, not just a fill change',
                description:
                    'Selecting an item mounts a distinct shape rather than '
                    'only recolouring the socket, so the state does not '
                    'depend on a reader distinguishing fill colours.',
              ),
              const DocsInstallFact(
                label: 'Error wiring',
                value:
                    'invalid, ORed across the item, the group, and a '
                    'per-item nested field',
                description:
                    'A DsField around the whole group folds its own invalid '
                    'flag in at the group level, reaching every item; a '
                    'DsField around one item folds in at that item alone.',
              ),
              const DocsInstallFact(
                label: 'Screen-reader announcements',
                value: 'No live region',
                description:
                    'State changes are exposed purely through the '
                    'inMutuallyExclusiveGroup/checked flags on each item\'s '
                    'merged semantics node; no extra announcement is '
                    'authored.',
              ),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'responsive',
          title: 'Responsive and platform behavior',
          child: DsText(
            'DsRadioGroup fills whatever width it is given (a loose, not a '
            'stretching, constraint), but does not stretch its rows to '
            'match: a bare DsRadioGroupItem stays a fixed 20 x 20 circle '
            'with a fixed 42 x 34 hit area while a DsField row placed '
            'beside it still fills the available width — the same '
            'distinction a CSS grid\'s default item-stretch would blur, '
            'made explicit here because the item declares its own size. '
            'What reflows with layout belongs to whatever composes the '
            'group: a DsFieldSet + DsFieldLegend wraps its own caption, and '
            'a settings page decides its own row wrapping. Keyboard '
            'activation (Enter/Space, the roving tab stop, and the arrow '
            'keys) and pointer activation behave identically on every '
            'Flutter target this package supports; there is no platform '
            'channel and nothing here is web-only or desktop-only.',
            DsType.small,
            color: theme.mutedForeground,
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'dependencies',
          title: 'Dependencies, files, assets, fonts and shaders',
          child: DocsInstallFacts(
            title: 'Dependencies and files',
            facts: <DocsInstallFact>[
              DocsInstallFact(
                label: 'Source file',
                value: radioDoc.sourcePath,
                description: 'The authoritative implementation.',
              ),
              const DocsInstallFact(
                label: 'Local file dependencies',
                value:
                    'selection_control.dart, field.dart, '
                    'effects/machine_surface.dart, motion/keyframes.dart',
                description:
                    'radio.dart imports these directly: selection_control.dart '
                    'for the shared socket / hit-area / focus-ring machinery '
                    '(DsSelectionControl), field.dart for DsFieldScope '
                    'wiring, effects/machine_surface.dart for the raised dot\'s '
                    'own surface (DsMachineSurface — used directly here, '
                    'unlike checkbox\'s hand-drawn path), and '
                    'motion/keyframes.dart for the dot-pop player. None are '
                    'copyable in isolation — see Installation.',
              ),
              const DocsInstallFact(
                label: 'Foundation dependencies',
                value:
                    'foundation/motion.dart, foundation/shadows.dart, '
                    'foundation/spacing.dart, foundation/theme.dart, '
                    'theme_scope.dart',
                description:
                    'Token sources: durations and curves, shadow specs, the '
                    'ds() spacing scale, and the live theme.',
              ),
              DocsInstallFact(
                label: 'Exports',
                value: radioDoc.exports.join(', '),
                description:
                    'The public symbols this component makes available.',
              ),
              const DocsInstallFact(
                label: 'Assets',
                value: 'none',
                description:
                    'The dot is a plain filled circle drawn with '
                    'DsMachineSurface, not an image or an icon-font glyph — '
                    'radio needs no icon grid at all, unlike checkbox\'s '
                    'hand-authored tick path.',
              ),
              const DocsInstallFact(
                label: 'Fonts',
                value: 'none',
                description: 'No text is rendered by DsRadioGroupItem itself.',
              ),
              const DocsInstallFact(
                label: 'Shaders',
                value: 'none',
                description: 'No fragment shader is used.',
              ),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'composition',
          title: 'Composition examples',
          description:
              'Two larger, real patterns built from the same constructors '
              '— not manufactured examples the Dart API cannot support.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DsPanel(
                label: 'DART',
                note: 'PLAN TIER PICKER — NAMED ITEMS, NO VISIBLE CAPTION',
                child: DocsSelectableCodeBlock(code: _planPickerCode),
              ),
              SizedBox(height: ds(5)),
              DsPanel(
                label: 'DART',
                note: 'SHIPPING METHOD — FULL FIELDSET COMPOSITION',
                child: DocsSelectableCodeBlock(code: _shippingMethodCode),
              ),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'theming',
          title: 'Theming notes',
          child: DocsInstallFacts(
            title: 'Tokens this component reads',
            facts: const <DocsInstallFact>[
              DocsInstallFact(
                label: 'Fill',
                value: 'theme.card (rest) / theme.primary (selected)',
                description: 'Socket background.',
              ),
              DocsInstallFact(
                label: 'Border',
                value:
                    'theme.input (rest) / theme.primary (selected) / '
                    'theme.ring (focus-visible) / theme.destructive '
                    '(invalid)',
                description:
                    'Resolved in that precedence order — invalid always '
                    'wins.',
              ),
              DocsInstallFact(
                label: 'Dot colour',
                value: 'theme.primaryForeground',
                description: 'The raised filled dot.',
              ),
              DocsInstallFact(
                label: 'Shadow',
                value:
                    'DsShadows.pressed (rest) / DsShadows.btnPrimary '
                    '(selected) on the socket; DsShadows.e1 on the dot',
                description:
                    'The socket shadow spec, composed with the focus or '
                    'invalid ring; the dot carries its own raised shadow, '
                    'separately from the socket beneath it.',
              ),
              DocsInstallFact(
                label: 'Radius',
                value: 'BorderRadius.circular(size / 2)',
                description:
                    'A full circle — half the 20px box, not a named DsRadii '
                    'token.',
              ),
              DocsInstallFact(
                label: 'Motion',
                value:
                    'DsDurations.transitionDefault, DsDotPop, '
                    'DsJellyReplay',
                description:
                    'Socket colour/border/ring tween duration, the dot\'s '
                    'own pop-in keyframe (scale and opacity, on the spring '
                    'curve), and the post-selection squash — all resolved '
                    'through dsAnimationDuration, so reduced motion '
                    'shortens or removes them automatically.',
              ),
              DocsInstallFact(
                label: 'Row gap',
                value:
                    'DsRadioGroup.defaultGap (8px) or DsFieldSet.groupGap '
                    '(12px)',
                description:
                    'The group\'s own default, or the tighter step the '
                    'composed forms page passes when the group sits inside '
                    'a DsFieldSet.',
              ),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'source',
          title: 'Source and tests',
          child: DocsInstallFacts(
            facts: <DocsInstallFact>[
              DocsInstallFact(
                label: 'Component source',
                value: radioDoc.sourcePath,
                description: 'Authoritative implementation.',
              ),
              const DocsInstallFact(
                label: 'Shared machinery',
                value: 'lib/src/components/selection_control.dart',
                description:
                    'DsSelectionControl, DsHitArea and DsJellyReplay — '
                    'shared with the checkbox and switch families and '
                    'documented on their own component pages.',
              ),
              const DocsInstallFact(
                label: 'Package tests',
                value: 'test/selection_feedback_test.dart',
                description:
                    'State-matrix, arrow-key traversal, roving-tabindex and '
                    'field-adoption coverage for DsRadioGroup and '
                    'DsRadioGroupItem in the package itself.',
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
  }
}

const String _smallestUsageCode = '''String? payout;

DsRadioGroup<String>(
  value: payout,
  label: 'Payout rhythm',
  onChanged: (String next) => setState(() => payout = next),
  children: const <Widget>[
    DsRadioGroupItem<String>(value: 'daily', label: 'Daily'),
    DsRadioGroupItem<String>(value: 'weekly', label: 'Weekly'),
  ],
)''';

const String _fieldSetUsageCode = '''String? payout;

Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    const DsFieldLegend('Payout rhythm'),
    SizedBox(height: DsFieldLegend.spaceBelow),
    DsFieldSet(
      tightForGroup: true,
      children: <Widget>[
        DsRadioGroup<String>(
          value: payout,
          gap: DsFieldSet.groupGap,
          label: 'Payout rhythm',
          onChanged: (String next) => setState(() => payout = next),
          children: const <Widget>[
            DsField(
              label: 'Daily',
              orientation: DsFieldOrientation.horizontal,
              child: DsRadioGroupItem<String>(value: 'daily'),
            ),
            DsField(
              label: 'Weekly',
              orientation: DsFieldOrientation.horizontal,
              child: DsRadioGroupItem<String>(value: 'weekly'),
            ),
          ],
        ),
      ],
    ),
  ],
)''';

const String _planPickerCode = '''String? plan = 'pro';

DsRadioGroup<String>(
  value: plan,
  label: 'Plan',
  onChanged: (String next) => setState(() => plan = next),
  children: const <Widget>[
    DsRadioGroupItem<String>(value: 'free', label: 'Free'),
    DsRadioGroupItem<String>(value: 'pro', label: 'Pro'),
    DsRadioGroupItem<String>(value: 'vault', label: 'Vault'),
  ],
)''';

const String _shippingMethodCode = '''String? method;
final List<String> errors = <String>[];

Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    const DsFieldLegend('Shipping method'),
    SizedBox(height: DsFieldLegend.spaceBelow),
    DsFieldSet(
      tightForGroup: true,
      children: <Widget>[
        DsRadioGroup<String>(
          value: method,
          gap: DsFieldSet.groupGap,
          invalid: errors.isNotEmpty,
          label: 'Shipping method',
          hint: errors.isEmpty ? null : errors.join(' '),
          onChanged: (String next) => setState(() => method = next),
          children: const <Widget>[
            DsField(
              label: 'Standard — 5 to 7 days',
              orientation: DsFieldOrientation.horizontal,
              child: DsRadioGroupItem<String>(value: 'standard'),
            ),
            DsField(
              label: 'Express — 2 days',
              orientation: DsFieldOrientation.horizontal,
              child: DsRadioGroupItem<String>(value: 'express'),
            ),
            DsField(
              label: 'Overnight',
              orientation: DsFieldOrientation.horizontal,
              child: DsRadioGroupItem<String>(value: 'overnight'),
            ),
          ],
        ),
        if (errors.isNotEmpty) DsFieldError(errors),
      ],
    ),
  ],
)''';

/// The six-cell live specimen grid for the "Preview" section.
class _RadioPreview extends StatefulWidget {
  const _RadioPreview();

  @override
  State<_RadioPreview> createState() => _RadioPreviewState();
}

class _RadioPreviewState extends State<_RadioPreview> {
  String? _payout = 'daily';
  String? _focusValue;
  String? _errorValue = 'daily';

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: ds(3),
      runSpacing: ds(3),
      children: <Widget>[
        DsStateCell(
          label: 'Payout rhythm',
          note: 'Tap an option — the previous one deselects',
          child: DsRadioGroup<String>(
            key: const ValueKey<String>('radio-live-specimen'),
            value: _payout,
            label: 'Payout rhythm',
            onChanged: (String next) => setState(() => _payout = next),
            children: const <Widget>[
              DsRadioGroupItem<String>(value: 'daily', label: 'Daily'),
              DsRadioGroupItem<String>(value: 'weekly', label: 'Weekly'),
              DsRadioGroupItem<String>(value: 'monthly', label: 'Monthly'),
            ],
          ),
        ),
        DsStateCell(
          label: 'Focus-visible',
          note: 'Ring painted, not focused',
          child: DsRadioGroup<String>(
            value: _focusValue,
            onChanged: (String next) => setState(() => _focusValue = next),
            children: <Widget>[
              DsRadioGroupItem<String>(
                value: 'focus',
                forceFocusRing: true,
                label: 'Focus-visible',
              ),
            ],
          ),
        ),
        DsStateCell(
          label: 'Error',
          note: 'invalid: true',
          child: DsRadioGroup<String>(
            value: _errorValue,
            invalid: true,
            onChanged: (String next) => setState(() => _errorValue = next),
            children: const <Widget>[
              DsRadioGroupItem<String>(value: 'daily', label: 'Daily'),
              DsRadioGroupItem<String>(value: 'weekly', label: 'Weekly'),
            ],
          ),
        ),
        DsStateCell(
          label: 'Disabled',
          note: 'enabled: false on the item itself',
          child: DsRadioGroup<String>(
            value: null,
            onChanged: (String _) {},
            children: const <Widget>[
              DsRadioGroupItem<String>(
                value: 'daily',
                enabled: false,
                label: 'Disabled',
              ),
            ],
          ),
        ),
        DsStateCell(
          label: 'Disabled (selected)',
          note: 'enabled: false, and it is the group\'s value',
          child: DsRadioGroup<String>(
            value: 'daily',
            onChanged: (String _) {},
            children: const <Widget>[
              DsRadioGroupItem<String>(
                value: 'daily',
                enabled: false,
                label: 'Disabled selected',
              ),
            ],
          ),
        ),
        const DsStateCell(
          label: 'Group disabled',
          note: 'onChanged: null — no item in the group can be operated',
          child: DsRadioGroup<String>(
            value: 'weekly',
            onChanged: null,
            children: <Widget>[
              DsRadioGroupItem<String>(value: 'weekly', label: 'Weekly'),
            ],
          ),
        ),
      ],
    );
  }
}

/// A live, functioning fieldset-composed radio group for the "Usage" section
/// — proof the composition it documents actually renders and selects, not
/// just a code excerpt.
class _PayoutRhythmExample extends StatefulWidget {
  const _PayoutRhythmExample();

  @override
  State<_PayoutRhythmExample> createState() => _PayoutRhythmExampleState();
}

class _PayoutRhythmExampleState extends State<_PayoutRhythmExample> {
  String? _payout;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const DsFieldLegend('Payout rhythm'),
        SizedBox(height: DsFieldLegend.spaceBelow),
        DsFieldSet(
          tightForGroup: true,
          children: <Widget>[
            DsRadioGroup<String>(
              value: _payout,
              gap: DsFieldSet.groupGap,
              label: 'Payout rhythm',
              onChanged: (String next) => setState(() => _payout = next),
              children: <Widget>[
                DsField(
                  label: 'Daily',
                  orientation: DsFieldOrientation.horizontal,
                  child: const DsRadioGroupItem<String>(value: 'daily'),
                ),
                DsField(
                  label: 'Weekly',
                  orientation: DsFieldOrientation.horizontal,
                  child: const DsRadioGroupItem<String>(value: 'weekly'),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
