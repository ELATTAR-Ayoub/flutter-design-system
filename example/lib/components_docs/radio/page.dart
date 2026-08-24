/// Public component documentation for the radio group component.
///
/// `radioDoc` (from `meta.dart`) is the data source, not
/// `componentDoc('radio')`; this page keeps its typed metadata import.
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
        description:
            'ElRadioGroup lets a user pick exactly one value out of a small '
            'set of options that all stay visible on screen at once, '
            '"daily" or "weekly" payout, never both, and never neither once '
            'something is chosen. Its options exist only in relation to each '
            'other: selecting one always deselects whichever was selected '
            'before, because the whole group shares a single value. Reach '
            'for ElCheckbox instead when the value is independent of every '
            'other option on the screen, "notify me by email" is true or '
            'false on its own, with no sibling it competes against, and a '
            'checkbox group (unlike a radio group) can legitimately have '
            'every box checked at once. Reach for ElSelect instead once the '
            'option count grows past what is comfortable to lay out on '
            'screen, or the choice does not need to stay visible until the '
            'user actually opens it: a radio group spends permanent space '
            'showing every option so the full set is scannable at a glance, '
            'while a select collapses the same list behind one trigger and '
            'costs nothing until it is opened.',
      ),
      breadcrumbs: const <ElBreadcrumbEntry>[
        ElBreadcrumbEntry.link('Components'),
        ElBreadcrumbEntry.page('Radio group'),
      ],
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Installation', anchor: 'install'),
        DocsTocEntry(title: 'Usage', anchor: 'usage'),
        DocsTocEntry(title: 'Composition', anchor: 'composition'),
        DocsTocEntry(title: 'Description', anchor: 'description'),
        DocsTocEntry(title: 'Choice Card', anchor: 'choice-card'),
        DocsTocEntry(title: 'Fieldset', anchor: 'fieldset'),
        DocsTocEntry(title: 'Disabled', anchor: 'disabled'),
        DocsTocEntry(title: 'Invalid', anchor: 'invalid'),
        DocsTocEntry(title: 'API Reference', anchor: 'api'),
        DocsTocEntry(title: 'States', anchor: 'states'),
        DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
        DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
        DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
        DocsTocEntry(title: 'Theming', anchor: 'theming'),
        DocsTocEntry(title: 'Source', anchor: 'source'),
      ],
      // Wave 2's alphabetical neighbours (Phase J plan inventory: button_group,
      // combobox, field, form, input_group, input_otp, native_select, radio,
      // selection_control, slider, textarea). Neither route is registered yet
      // either: the whole wave's previous/next chain is stitched together
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
      child: _RadioArticle(theme: ElTheme.of(context)),
    );
  }
}

class _RadioArticle extends StatelessWidget {
  const _RadioArticle({required this.theme});

  final ElThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey<String>('radio-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: ElWidths.prose),
          child: ElText(
            'Six live specimens, all built from real ElRadioGroup and '
            'ElRadioGroupItem widgets. Payout rhythm, Focus-visible and '
            'Error are operable: tap an option. Disabled, Disabled '
            '(selected) and Group disabled are deliberately inert; all '
            'three are explained in States below.',
            ElType.body,
          ),
        ),
        SizedBox(height: el(6)),
        DocsCodeExample(
          title: 'Radio group specimens',
          description:
              'Every cell below renders a real ElRadioGroup wrapping real '
              'ElRadioGroupItem children.',
          preview: const _RadioPreview(),
          manualFiles: <DocsCodeFile>[
            DocsCodeFile(
              path: radioDoc.sourcePath,
              code:
                  '${radioDoc.command}\n'
                  '// Installs the generated @ui/radio.dart payload.',
            ),
          ],
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'install',
          title: 'Installation',
          description:
              'Stable, but not yet a registry item: command install is not '
              'available yet, read this before reaching for elattar add '
              'radio.',
          child: DocsInstallFacts(
            facts: <DocsInstallFact>[
              const DocsInstallFact(
                label: 'Status',
                value: 'Stable, installable through lattar add radio',
                description:
                    'Ported and tested against lib/src/components/radio.dart. '
                    'It is not yet a registry item, so elattar add radio '
                    'will not resolve: see the facts below for what actually '
                    'works today.',
              ),
              const DocsInstallFact(
                label: 'Platforms',
                value: 'Android, iOS, Web, macOS, Windows, Linux',
                description:
                    'A pure Flutter widget tree: no platform channel and no '
                    'platform-specific branch.',
              ),
              const DocsInstallFact(
                label: 'CLI',
                value: 'registry/components/radio.json',
                description:
                    'radio is not yet a registry item, so `elattar add '
                    'radio` will not resolve. It is one of the Wave 2 form '
                    'components still awaiting a manifest: see the Phase J '
                    'documentation plan.',
              ),
              const DocsInstallFact(
                label: 'Manual: package mode (supported today)',
                value:
                    "import 'package:elattar_design_system/elattar_design_system.dart';",
                description:
                    'Depend on the package and use ElRadioGroup and '
                    'ElRadioGroupItem directly, exactly as this page does.',
              ),
              DocsInstallFact(
                label: 'Manual: source mode (not recommended yet)',
                value: radioDoc.sourcePath,
                description:
                    'Copying this one file will not compile on its own: it '
                    'needs its sibling files with it (see Dependencies and '
                    'files below), and no manifest exists yet to resolve '
                    'them for you.',
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'usage',
          title: 'Usage',
          description:
              'The smallest correct example, then the labelled, real-world '
              'shape.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElPanel(
                label: 'DART',
                note: 'SMALLEST CORRECT EXAMPLE',
                child: DocsSelectableCodeBlock(code: _smallestUsageCode),
              ),
              SizedBox(height: el(5)),
              ElText(
                'A bare ElRadioGroupItem renders no visible text of its own, '
                'its label only supplies the accessible name, the same rule '
                'ElCheckbox follows. The real composed-forms pattern pairs a '
                'ElFieldSet and ElFieldLegend for the group\'s visible '
                'caption with one horizontal ElField per item for each '
                'option\'s own visible label: exactly what the source '
                'comments on ElRadioGroup and ElRadioGroupItem describe, and '
                'what the composed forms page in this repository actually '
                'builds:',
                ElType.small,
                color: theme.mutedForeground,
              ),
              SizedBox(height: el(3)),
              const _PayoutRhythmExample(),
              SizedBox(height: el(3)),
              ElPanel(
                label: 'DART',
                note: 'FIELDSET + LEGEND + PER-ITEM FIELD',
                child: DocsSelectableCodeBlock(code: _fieldSetUsageCode),
              ),
              SizedBox(height: el(5)),
              ElText(
                'A group can hold more than two named options with no '
                'visible caption at all, when the surrounding UI already '
                'names the choice:',
                ElType.small,
                color: theme.mutedForeground,
              ),
              SizedBox(height: el(3)),
              ElPanel(
                label: 'DART',
                note: 'THREE NAMED OPTIONS, NO VISIBLE CAPTION',
                child: DocsSelectableCodeBlock(code: _planPickerCode),
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'composition',
          title: 'Composition',
          description:
              'The shape every example on this page builds on: a '
              'ElRadioGroup owns the value, and each ElRadioGroupItem '
              'inside it answers only to that one value.',
          child: ElPanel(
            label: 'DART',
            note: 'BARE ITEM VS. FIELD-WRAPPED ITEM',
            child: DocsSelectableCodeBlock(code: _compositionTreeCode),
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'description',
          title: 'Description',
          description:
              'A one-line description per option, the same ElField.'
              'description prop ElCheckbox and every other field-composed '
              'control reads.',
          child: ElPanel(
            label: 'DART',
            note: 'FIELDSET + PER-ITEM LABEL AND DESCRIPTION',
            child: DocsSelectableCodeBlock(code: _descriptionUsageCode),
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'choice-card',
          title: 'Choice Card',
          description:
              'ElRadioGroupItem has no card variant of its own, but a '
              'ElCard wrapping a horizontal ElField composes one: the '
              'field\'s own label-tap wiring still selects the item, the '
              'card only supplies the border.',
          child: ElPanel(
            label: 'DART',
            note: 'ELCARD + FIELD + ITEM, THREE PLANS',
            child: DocsSelectableCodeBlock(code: _choiceCardCode),
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'fieldset',
          title: 'Fieldset',
          description:
              'The full grouped shape: a ElFieldSet and ElFieldLegend for '
              'the group\'s own visible caption, one horizontal ElField per '
              'option, and a ElFieldError row that mounts only once there '
              'is an error to show.',
          child: ElPanel(
            label: 'DART',
            note: 'SHIPPING METHOD, FULL FIELDSET COMPOSITION',
            child: DocsSelectableCodeBlock(code: _shippingMethodCode),
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'disabled',
          title: 'Disabled',
          description:
              'onChanged: null disables every item in the group at once, '
              'regardless of each item\'s own enabled flag; live specimens '
              'for this and for a single disabled item are in Preview '
              'above.',
          child: ElPanel(
            label: 'DART',
            note: 'GROUP DISABLED, ONCHANGED: NULL',
            child: DocsSelectableCodeBlock(code: _disabledUsageCode),
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'invalid',
          title: 'Invalid',
          description:
              'invalid: true (or a per-item nested field\'s own invalid '
              'flag) paints the destructive border and ring on every item; '
              'the live "Error" specimen in Preview above shows the '
              'painted result.',
          child: ElPanel(
            label: 'DART',
            note: 'GROUP INVALID, WITH A HINT',
            child: DocsSelectableCodeBlock(code: _invalidUsageCode),
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'api',
          title: 'API Reference',
          description:
              'Neither ElRadioGroup nor ElRadioGroupItem takes a variant or '
              'size parameter: ElRadioGroupItem.size fixes one 20px '
              'geometry, level with ElCheckbox, and there is no third '
              '"held" state the way ElCheckbox has an inert flag.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const DocsApiTable(
                title: 'ElRadioGroup<T>',
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
                        'picked: by tap, by Enter/Space on the focused item, '
                        'or by an arrow key that moves the selection. null '
                        'disables every item in the group.',
                  ),
                  DocsApiFact(
                    name: 'children',
                    type: 'List<Widget>',
                    description:
                        'The rows. Each holds a ElRadioGroupItem<T> '
                        'somewhere inside it: either bare, or wrapped in its '
                        'own ElField for a visible per-option label.',
                  ),
                  DocsApiFact(
                    name: 'gap',
                    type: 'double?',
                    description:
                        'The vertical space between rows. Defaults to '
                        'ElRadioGroup.defaultGap (8px); the composed forms '
                        'page passes ElFieldSet.groupGap (12px) instead.',
                  ),
                  DocsApiFact(
                    name: 'enabled',
                    type: 'bool',
                    description:
                        'Defaults to true. Disables every item; ANDed with '
                        'the enclosing ElFieldScope\'s own enabled flag when '
                        'the group itself sits in a ElField.',
                  ),
                  DocsApiFact(
                    name: 'invalid',
                    type: 'bool',
                    description:
                        'Defaults to false. true paints the destructive '
                        'border and ring on every item. ORed with the '
                        'enclosing ElFieldScope\'s own invalid flag.',
                  ),
                  DocsApiFact(
                    name: 'focusNode',
                    type: 'FocusNode?',
                    description:
                        'The node a failed form submit lands on, adopted '
                        'from the enclosing ElFieldScope when null. The '
                        'group itself never keeps this focus: it forwards '
                        'it straight to the roving tab-stop item, so a '
                        'keyboard user always lands on a real, operable '
                        'radio and never on the group container.',
                  ),
                  DocsApiFact(
                    name: 'label',
                    type: 'String?',
                    description:
                        'The group\'s accessible name: the legend\'s text, '
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
                        'Read after the label: the aria-describedby '
                        'analogue for the group as a whole, resolved through '
                        'Semantics.hint.',
                  ),
                ],
              ),
              SizedBox(height: el(5)),
              const DocsApiTable(
                title: 'ElRadioGroupItem<T>',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'value',
                    type: 'T',
                    description:
                        'This item\'s own value. The item renders checked '
                        'exactly when the enclosing group\'s value equals '
                        'this one: there is no separate checked or state '
                        'field to set by hand.',
                  ),
                  DocsApiFact(
                    name: 'enabled',
                    type: 'bool',
                    description:
                        'Defaults to true. ANDed with the group\'s own '
                        'enabled flag and, when this item sits in its own '
                        'nested ElField, with that field\'s enabled flag too.',
                  ),
                  DocsApiFact(
                    name: 'invalid',
                    type: 'bool',
                    description:
                        'Defaults to false. ORed with the group\'s invalid '
                        'flag and, when this item has its own nested '
                        'ElField, with that field\'s invalid flag.',
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
                        'This item\'s own accessible name: never the '
                        'group\'s legend. Falls back to this item\'s own '
                        'nested ElField\'s label when it has one, and to '
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
              SizedBox(height: el(5)),
              const DocsApiTable(
                title: 'Static helpers',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'ElRadioGroup.defaultGap',
                    type: 'static double',
                    description:
                        'The Root\'s own row gap, 8px, used whenever gap is '
                        'left null.',
                  ),
                  DocsApiFact(
                    name: 'ElRadioGroupItem.size',
                    type: 'static double',
                    description:
                        'The 20px circle: sized to sit level with '
                        'ElCheckbox rather than the reference\'s own smaller '
                        'default.',
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
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
                        'shadow: identical socket mechanics to an '
                        'unchecked checkbox, drawn as a circle.',
                    userSignal: 'An empty 20px ring; no dot is mounted.',
                  ),
                  DocsStateFact(
                    state: 'Selected',
                    treatment:
                        'theme.primary fill and border; an 8px filled dot '
                        'mounts and pops in: scale 0 → 1.35 at 55% → 1 on '
                        'the spring curve: rather than fading or drawing a '
                        'stroke. Mounted only while this item is the '
                        'group\'s value, so the pop replays on every real '
                        'selection and never on an unrelated rebuild.',
                    userSignal:
                        'A small raised dot popping into the centre, '
                        'visible even to a reader who cannot rely on the '
                        'fill colour changing.',
                  ),
                  DocsStateFact(
                    state: 'Focus-visible',
                    treatment: 'border-ring plus a 3px ring at 50% alpha.',
                    userSignal:
                        'A visible ring around whichever item holds the '
                        'group\'s one roving tab stop: beaten by Error '
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
                        'invalid one: reproduced faithfully from the rest '
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
                        'including through that item\'s own nested ElField '
                        'going disabled.',
                    userSignal:
                        '50% opacity, out of the tab order, deaf to pointer '
                        'and keyboard: the one state that dims.',
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
              SizedBox(height: el(4)),
              ElText(
                'Omitted: Hover: no control in this family authors a '
                'hover skin; only the pointer cursor changes. Pressed, '
                'there is no separate pointer-down look; each socket that '
                'actually changes value squashes once, after the change, '
                'via ElJellyReplay: both the item that becomes selected '
                'and the one that was selected a moment ago squash, because '
                'both genuinely changed state. Loading and Empty, '
                'ElRadioGroup is a synchronous primitive with no async '
                'operation and nothing to list, so neither applies. Success '
                '— the component defines no success semantics of its own.',
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
                value:
                    'Semantics(container:) on the group, '
                    'Semantics(inMutuallyExclusiveGroup:, checked:) on each '
                    'item',
                description:
                    'The group carries a container semantics node; each '
                    'item is flagged as a member of a mutually exclusive '
                    'group with its own checked flag, Flutter\'s nearest '
                    'primitive to an ARIA radiogroup and its radios.',
              ),
              const DocsInstallFact(
                label: 'Label association',
                value: 'label on the group; label on each item',
                description:
                    'The group\'s label (or its own enclosing field\'s) is '
                    'announced as the legend for the whole set. Each item\'s '
                    'own label (or its own nested field\'s: never the '
                    'group\'s) is announced as that one option\'s name. '
                    'Neither is rendered as visible text on its own; a '
                    'ElFieldSet + ElFieldLegend gives the group a visible '
                    'caption, and a per-item ElField gives each option one.',
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
                    'the same step and moves focus to it: the full ARIA '
                    'radiogroup contract, wrapping from the last enabled '
                    'item back to the first and back again.',
              ),
              const DocsInstallFact(
                label: 'Keyboard: activation',
                value: 'Enter, numpad Enter, Space',
                description:
                    'Selects whichever item currently holds focus. Wired by '
                    'hand through Focus.onKeyEvent: the control is not a '
                    'native button, so nothing arrives for free.',
              ),
              const DocsInstallFact(
                label: 'Focus behavior',
                value: 'border-ring plus a 3px ring at 50% alpha',
                description:
                    'The group\'s own Focus node (adopted from a '
                    'ElFieldScope, e.g. a failed form submit) skips '
                    'traversal and immediately forwards to the tab-stop '
                    'item rather than holding focus itself: the group is '
                    'not itself operable, so a keyboard user always sees '
                    'the ring on a real, selectable item.',
              ),
              const DocsInstallFact(
                label: 'Label tap: group vs item',
                value:
                    'Tapping the group\'s label focuses; tapping an '
                    'item\'s own label selects',
                description:
                    'A ElFieldSet + ElFieldLegend caption over the whole '
                    'group only moves focus to the tab-stop item when '
                    'tapped: a legend cannot select on behalf of a set it '
                    'only names. A visible label from an item\'s own nested '
                    'ElField genuinely selects that one option when tapped, '
                    'the same activator wiring an HTML <label for> click '
                    'uses.',
              ),
              const DocsInstallFact(
                label: 'Touch target',
                value: '42 x 34, centred on each 20 x 20 circle',
                description:
                    'ElHitArea grows the hit test past the painted circle, '
                    'identical to ElCheckbox\'s own measurement, 2px short '
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
                    'A ElField around the whole group folds its own invalid '
                    'flag in at the group level, reaching every item; a '
                    'ElField around one item folds in at that item alone.',
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
        SizedBox(height: el(6)),
        ElSection(
          id: 'responsive',
          title: 'Responsive and platform behavior',
          child: ElText(
            'ElRadioGroup fills whatever width it is given (a loose, not a '
            'stretching, constraint), but does not stretch its rows to '
            'match: a bare ElRadioGroupItem stays a fixed 20 x 20 circle '
            'with a fixed 42 x 34 hit area while a ElField row placed '
            'beside it still fills the available width: the same '
            'distinction a CSS grid\'s default item-stretch would blur, '
            'made explicit here because the item declares its own size. '
            'What reflows with layout belongs to whatever composes the '
            'group: a ElFieldSet + ElFieldLegend wraps its own caption, and '
            'a settings page decides its own row wrapping. Keyboard '
            'activation (Enter/Space, the roving tab stop, and the arrow '
            'keys) and pointer activation behave identically on every '
            'Flutter target this package supports; there is no platform '
            'channel and nothing here is web-only or desktop-only.',
            ElType.small,
            color: theme.mutedForeground,
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'dependencies',
          title: 'Dependencies, files, assets, fonts and shaders',
          child: DocsInstallFacts(
            title: 'Dependencies',
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
                    '(ElSelectionControl), field.dart for ElFieldScope '
                    'wiring, effects/machine_surface.dart for the raised dot\'s '
                    'own surface (ElMachineSurface: used directly here, '
                    'unlike checkbox\'s hand-drawn path), and '
                    'motion/keyframes.dart for the dot-pop player. None are '
                    'copyable in isolation: see Installation.',
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
                value: radioDoc.exports.join(', '),
                description:
                    'The public symbols this component makes available.',
              ),
              const DocsInstallFact(
                label: 'Assets',
                value: 'none',
                description:
                    'The dot is a plain filled circle drawn with '
                    'ElMachineSurface, not an image or an icon-font glyph, '
                    'radio needs no icon grid at all, unlike checkbox\'s '
                    'hand-authored tick path.',
              ),
              const DocsInstallFact(
                label: 'Fonts',
                value: 'none',
                description: 'No text is rendered by ElRadioGroupItem itself.',
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
                    'Resolved in that precedence order: invalid always '
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
                    'ElShadows.pressed (rest) / ElShadows.btnPrimary '
                    '(selected) on the socket; ElShadows.e1 on the dot',
                description:
                    'The socket shadow spec, composed with the focus or '
                    'invalid ring; the dot carries its own raised shadow, '
                    'separately from the socket beneath it.',
              ),
              DocsInstallFact(
                label: 'Radius',
                value: 'BorderRadius.circular(size / 2)',
                description:
                    'A full circle: half the 20px box, not a named ElRadii '
                    'token.',
              ),
              DocsInstallFact(
                label: 'Motion',
                value:
                    'ElDurations.transitionDefault, ElDotPop, '
                    'ElJellyReplay',
                description:
                    'Socket colour/border/ring tween duration, the dot\'s '
                    'own pop-in keyframe (scale and opacity, on the spring '
                    'curve), and the post-selection squash: all resolved '
                    'through elAnimationDuration, so reduced motion '
                    'shortens or removes them automatically.',
              ),
              DocsInstallFact(
                label: 'Row gap',
                value:
                    'ElRadioGroup.defaultGap (8px) or ElFieldSet.groupGap '
                    '(12px)',
                description:
                    'The group\'s own default, or the tighter step the '
                    'composed forms page passes when the group sits inside '
                    'a ElFieldSet.',
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
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
                    'ElSelectionControl, ElHitArea and ElJellyReplay, '
                    'shared with the checkbox and switch families and '
                    'documented on their own component pages.',
              ),
              const DocsInstallFact(
                label: 'Package tests',
                value: 'test/selection_feedback_test.dart',
                description:
                    'State-matrix, arrow-key traversal, roving-tabindex and '
                    'field-adoption coverage for ElRadioGroup and '
                    'ElRadioGroupItem in the package itself.',
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

ElRadioGroup<String>(
  value: payout,
  label: 'Payout rhythm',
  onChanged: (String next) => setState(() => payout = next),
  children: const <Widget>[
    ElRadioGroupItem<String>(value: 'daily', label: 'Daily'),
    ElRadioGroupItem<String>(value: 'weekly', label: 'Weekly'),
  ],
)''';

const String _fieldSetUsageCode = '''String? payout;

Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    const ElFieldLegend('Payout rhythm'),
    SizedBox(height: ElFieldLegend.spaceBelow),
    ElFieldSet(
      tightForGroup: true,
      children: <Widget>[
        ElRadioGroup<String>(
          value: payout,
          gap: ElFieldSet.groupGap,
          label: 'Payout rhythm',
          onChanged: (String next) => setState(() => payout = next),
          children: const <Widget>[
            ElField(
              label: 'Daily',
              orientation: ElFieldOrientation.horizontal,
              child: ElRadioGroupItem<String>(value: 'daily'),
            ),
            ElField(
              label: 'Weekly',
              orientation: ElFieldOrientation.horizontal,
              child: ElRadioGroupItem<String>(value: 'weekly'),
            ),
          ],
        ),
      ],
    ),
  ],
)''';

const String _planPickerCode = '''String? plan = 'pro';

ElRadioGroup<String>(
  value: plan,
  label: 'Plan',
  onChanged: (String next) => setState(() => plan = next),
  children: const <Widget>[
    ElRadioGroupItem<String>(value: 'free', label: 'Free'),
    ElRadioGroupItem<String>(value: 'pro', label: 'Pro'),
    ElRadioGroupItem<String>(value: 'vault', label: 'Vault'),
  ],
)''';

const String _shippingMethodCode = '''String? method;
final List<String> errors = <String>[];

Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    const ElFieldLegend('Shipping method'),
    SizedBox(height: ElFieldLegend.spaceBelow),
    ElFieldSet(
      tightForGroup: true,
      children: <Widget>[
        ElRadioGroup<String>(
          value: method,
          gap: ElFieldSet.groupGap,
          invalid: errors.isNotEmpty,
          label: 'Shipping method',
          hint: errors.isEmpty ? null : errors.join(' '),
          onChanged: (String next) => setState(() => method = next),
          children: const <Widget>[
            ElField(
              label: 'Standard, 5 to 7 days',
              orientation: ElFieldOrientation.horizontal,
              child: ElRadioGroupItem<String>(value: 'standard'),
            ),
            ElField(
              label: 'Express, 2 days',
              orientation: ElFieldOrientation.horizontal,
              child: ElRadioGroupItem<String>(value: 'express'),
            ),
            ElField(
              label: 'Overnight',
              orientation: ElFieldOrientation.horizontal,
              child: ElRadioGroupItem<String>(value: 'overnight'),
            ),
          ],
        ),
        if (errors.isNotEmpty) ElFieldError(errors),
      ],
    ),
  ],
)''';

/// A bare item next to a field-wrapped one: the two valid shapes every
/// other example on this page is built from.
const String _compositionTreeCode = '''ElRadioGroup<String>(
  value: value,
  onChanged: onChanged,
  children: <Widget>[
    // Bare: the label is announced, never painted.
    const ElRadioGroupItem<String>(value: 'a', label: 'A'),
    // Field-wrapped: the label is painted AND announced, and tapping it
    // selects this item, the same activator wiring an HTML label uses.
    ElField(
      label: 'B',
      orientation: ElFieldOrientation.horizontal,
      child: const ElRadioGroupItem<String>(value: 'b'),
    ),
  ],
)''';

const String _descriptionUsageCode = '''String? frequency;

Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    const ElFieldLegend('Digest frequency'),
    SizedBox(height: ElFieldLegend.spaceBelow),
    ElFieldSet(
      tightForGroup: true,
      children: <Widget>[
        ElRadioGroup<String>(
          value: frequency,
          gap: ElFieldSet.groupGap,
          label: 'Digest frequency',
          onChanged: (String next) => setState(() => frequency = next),
          children: const <Widget>[
            ElField(
              label: 'Daily',
              description: 'One email every morning.',
              orientation: ElFieldOrientation.horizontal,
              child: ElRadioGroupItem<String>(value: 'daily'),
            ),
            ElField(
              label: 'Weekly',
              description: 'One email every Monday.',
              orientation: ElFieldOrientation.horizontal,
              child: ElRadioGroupItem<String>(value: 'weekly'),
            ),
          ],
        ),
      ],
    ),
  ],
)''';

const String _choiceCardCode = '''String? plan = 'pro';

ElRadioGroup<String>(
  value: plan,
  label: 'Plan',
  gap: el(3),
  onChanged: (String next) => setState(() => plan = next),
  children: <Widget>[
    ElCard(
      children: <Widget>[
        ElCardContent(
          child: ElField(
            label: 'Free',
            description: 'For trying things out.',
            orientation: ElFieldOrientation.horizontal,
            child: const ElRadioGroupItem<String>(value: 'free'),
          ),
        ),
      ],
    ),
    ElCard(
      children: <Widget>[
        ElCardContent(
          child: ElField(
            label: 'Pro',
            description: 'For a team that ships every week.',
            orientation: ElFieldOrientation.horizontal,
            child: const ElRadioGroupItem<String>(value: 'pro'),
          ),
        ),
      ],
    ),
    ElCard(
      children: <Widget>[
        ElCardContent(
          child: ElField(
            label: 'Vault',
            description: 'For everything that must never move.',
            orientation: ElFieldOrientation.horizontal,
            child: const ElRadioGroupItem<String>(value: 'vault'),
          ),
        ),
      ],
    ),
  ],
)''';

const String _disabledUsageCode = '''ElRadioGroup<String>(
  value: null,
  onChanged: null,
  children: const <Widget>[
    ElRadioGroupItem<String>(value: 'daily', label: 'Daily'),
    ElRadioGroupItem<String>(value: 'weekly', label: 'Weekly'),
  ],
)''';

const String _invalidUsageCode = '''ElRadioGroup<String>(
  value: method,
  invalid: true,
  hint: 'Choose a shipping method.',
  onChanged: (String next) => setState(() => method = next),
  children: const <Widget>[
    ElRadioGroupItem<String>(value: 'standard', label: 'Standard'),
    ElRadioGroupItem<String>(value: 'express', label: 'Express'),
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
      spacing: el(3),
      runSpacing: el(3),
      children: <Widget>[
        ElStateCell(
          label: 'Payout rhythm',
          note: 'Tap an option: the previous one deselects',
          child: ElRadioGroup<String>(
            key: const ValueKey<String>('radio-live-specimen'),
            value: _payout,
            label: 'Payout rhythm',
            onChanged: (String next) => setState(() => _payout = next),
            children: const <Widget>[
              ElRadioGroupItem<String>(value: 'daily', label: 'Daily'),
              ElRadioGroupItem<String>(value: 'weekly', label: 'Weekly'),
              ElRadioGroupItem<String>(value: 'monthly', label: 'Monthly'),
            ],
          ),
        ),
        ElStateCell(
          label: 'Focus-visible',
          note: 'Ring painted, not focused',
          child: ElRadioGroup<String>(
            value: _focusValue,
            onChanged: (String next) => setState(() => _focusValue = next),
            children: <Widget>[
              ElRadioGroupItem<String>(
                value: 'focus',
                forceFocusRing: true,
                label: 'Focus-visible',
              ),
            ],
          ),
        ),
        ElStateCell(
          label: 'Error',
          note: 'invalid: true',
          child: ElRadioGroup<String>(
            value: _errorValue,
            invalid: true,
            onChanged: (String next) => setState(() => _errorValue = next),
            children: const <Widget>[
              ElRadioGroupItem<String>(value: 'daily', label: 'Daily'),
              ElRadioGroupItem<String>(value: 'weekly', label: 'Weekly'),
            ],
          ),
        ),
        ElStateCell(
          label: 'Disabled',
          note: 'enabled: false on the item itself',
          child: ElRadioGroup<String>(
            value: null,
            onChanged: (String _) {},
            children: const <Widget>[
              ElRadioGroupItem<String>(
                value: 'daily',
                enabled: false,
                label: 'Disabled',
              ),
            ],
          ),
        ),
        ElStateCell(
          label: 'Disabled (selected)',
          note: 'enabled: false, and it is the group\'s value',
          child: ElRadioGroup<String>(
            value: 'daily',
            onChanged: (String _) {},
            children: const <Widget>[
              ElRadioGroupItem<String>(
                value: 'daily',
                enabled: false,
                label: 'Disabled selected',
              ),
            ],
          ),
        ),
        const ElStateCell(
          label: 'Group disabled',
          note: 'onChanged: null: no item in the group can be operated',
          child: ElRadioGroup<String>(
            value: 'weekly',
            onChanged: null,
            children: <Widget>[
              ElRadioGroupItem<String>(value: 'weekly', label: 'Weekly'),
            ],
          ),
        ),
      ],
    );
  }
}

/// A live, functioning fieldset-composed radio group for the "Usage" section
///: proof the composition it documents actually renders and selects, not
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
        const ElFieldLegend('Payout rhythm'),
        SizedBox(height: ElFieldLegend.spaceBelow),
        ElFieldSet(
          tightForGroup: true,
          children: <Widget>[
            ElRadioGroup<String>(
              value: _payout,
              gap: ElFieldSet.groupGap,
              label: 'Payout rhythm',
              onChanged: (String next) => setState(() => _payout = next),
              children: <Widget>[
                ElField(
                  label: 'Daily',
                  orientation: ElFieldOrientation.horizontal,
                  child: const ElRadioGroupItem<String>(value: 'daily'),
                ),
                ElField(
                  label: 'Weekly',
                  orientation: ElFieldOrientation.horizontal,
                  child: const ElRadioGroupItem<String>(value: 'weekly'),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
