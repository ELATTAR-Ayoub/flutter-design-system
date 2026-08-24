/// Public documentation page for the `button_group` component.
///
/// **Split from a merged page.** Phase F/J's original `input_group` route
/// documented three unrelated components on one page: `ElInputGroup`,
/// `ElButtonGroup`, and `ElInputOtp`. This page now covers `ElButtonGroup`
/// alone; `ElInputGroup` lives at `../input_group/page.dart` and
/// `ElInputOtp` at `../input_otp/page.dart`, each its own route.
///
/// **Shape.** Matches `components_docs/button/page.dart`'s own reference
/// shape: an unheaded live specimen above the first heading, Installation,
/// Usage, then this component's own sections, API Reference last of the
/// shadcn-named sections (one prop table per exported class, nested under
/// it), then the fixed six: States, Accessibility, Responsive, Dependencies,
/// Theming, Source.
///
/// **Against shadcn's own page**
/// (https://ui.shadcn.com/docs/components/base/button-group, fetched
/// fresh): its own `<h2>`s are Installation, Usage, Composition,
/// Accessibility, ButtonGroup vs ToggleGroup, Orientation, Size, Nested,
/// Separator, Split, Input, Input Group, Dropdown Menu, Select, Popover,
/// RTL, API Reference (three nested tables: ButtonGroup,
/// ButtonGroupSeparator, ButtonGroupText).
///
/// Composition, Nested, Separator, Split, and RTL keep their own names.
/// ButtonGroup vs ToggleGroup becomes Vs. Selection Control: this port's
/// nearest neighbour to shadcn's ToggleGroup is `ElSelectionControl`, not a
/// same-named type. Input, Input Group, Dropdown Menu, Select, and Popover
/// are five shadcn sections about composing a NON-button member into the
/// group; this port has one problem-shaped section for all five, Composing
/// Other Members, because the mechanism is identical regardless of which
/// widget: `ElButtonGroup.children` reshapes what it recognises
/// (`ElButton`, `ElButtonGroupText`) and places anything else flush,
/// unreshaped. Size becomes Sizes: ElButtonGroup carries no size prop of
/// its own, so the section explains that each member keeps its own
/// ElButtonSize rather than showing a prop this component does not have.
///
/// Two sections are skipped, honestly: shadcn's own `Accessibility` H2
/// (mid-page, distinct from this page's own fixed Accessibility section at
/// the end, which supersedes it) folds into that final section instead of
/// duplicating a heading; and Orientation is dropped outright — the cva's
/// `orientation="vertical"` is recorded in `button_group.dart`'s own library
/// doc as never reached by a ported page, and only `horizontal` is built.
///
/// [ComponentDocEntry.description] is the page's only rendered description:
/// the short, one-sentence form (nav/search, and this page's own hero
/// paragraph). No second, longer paragraph renders beneath it.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

class ButtonGroupDocPage extends StatelessWidget {
  const ButtonGroupDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: buttonGroupDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: buttonGroupDoc.title,
      description: buttonGroupDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Button group'),
    ],
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Installation', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'Composition', anchor: 'composition'),
      DocsTocEntry(
        title: 'Composing other members',
        anchor: 'composing-others',
      ),
      DocsTocEntry(title: 'Separator', anchor: 'separator'),
      DocsTocEntry(title: 'Split', anchor: 'split'),
      DocsTocEntry(title: 'Nested', anchor: 'nested'),
      DocsTocEntry(title: 'Sizes', anchor: 'sizes'),
      DocsTocEntry(
        title: 'Vs. selection control',
        anchor: 'vs-selection-control',
      ),
      DocsTocEntry(title: 'RTL', anchor: 'rtl'),
      DocsTocEntry(
        title: 'API Reference',
        anchor: 'api',
        children: <DocsTocEntry>[
          DocsTocEntry(title: 'ElButtonGroup', anchor: 'api-elbuttongroup'),
          DocsTocEntry(
            title: 'ElButtonGroupText',
            anchor: 'api-elbuttongrouptext',
          ),
          DocsTocEntry(
            title: 'ElButtonGroupSeparator',
            anchor: 'api-elbuttongroupseparator',
          ),
        ],
      ),
      DocsTocEntry(title: 'States', anchor: 'states'),
      DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
      DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
      DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
      DocsTocEntry(title: 'Theming', anchor: 'theming'),
      DocsTocEntry(title: 'Source', anchor: 'source'),
    ],
    previous: const DocsPageLink(
      title: 'Input group',
      route: '/components/input_group',
    ),
    next: const DocsPageLink(
      title: 'Input OTP',
      route: '/components/input_otp',
    ),
    onNavigate: onNavigate,
    child: const _Article(),
  );
}

class _Article extends StatefulWidget {
  const _Article();

  @override
  State<_Article> createState() => _ArticleState();
}

class _ArticleState extends State<_Article> {
  int _count = 3;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      key: const ValueKey<String>('button-group-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _preview(),
        SizedBox(height: el(6)),
        _install(),
        SizedBox(height: el(6)),
        _usage(),
        SizedBox(height: el(6)),
        _composition(),
        _composingOthers(theme),
        _separator(),
        _split(),
        _nested(theme),
        _sizes(theme),
        _vsSelectionControl(theme),
        _rtl(),
        _api(),
        _states(),
        _accessibility(theme),
        _responsive(theme),
        _dependencies(theme),
        _theming(theme),
        _source(),
      ],
    );
  }

  Widget _preview() => DocsCodeExample(
    title: 'Button group',
    description: 'A quantity stepper: the app owns the count, not the group.',
    preview: Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ElButtonGroup(
          children: <Widget>[
            ElButton(
              key: const ValueKey<String>('button-group-doc-decrease'),
              variant: ElButtonVariant.outline,
              size: ElButtonSize.sm,
              onPressed: () =>
                  setState(() => _count = (_count - 1).clamp(0, 99)),
              child: ElText('−', ElComponentType.buttonLabel),
            ),
            ElButtonGroupText(
              _count.toString(),
              key: const ValueKey<String>('button-group-doc-count'),
              numeric: true,
            ),
            ElButton(
              key: const ValueKey<String>('button-group-doc-increase'),
              variant: ElButtonVariant.outline,
              size: ElButtonSize.sm,
              onPressed: () =>
                  setState(() => _count = (_count + 1).clamp(0, 99)),
              child: ElText('+', ElComponentType.buttonLabel),
            ),
          ],
        ),
      ),
    ),
    manualFiles: const <DocsCodeFile>[
      DocsCodeFile(
        path: 'button_group_preview.dart',
        title: 'Quantity stepper',
        code:
            "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
            'ElButtonGroup(\n'
            '  children: [\n'
            '    ElButton(\n'
            '      variant: ElButtonVariant.outline,\n'
            '      size: ElButtonSize.sm,\n'
            '      onPressed: () => setState(() => count--),\n'
            "      child: const Text('−'),\n"
            '    ),\n'
            "    ElButtonGroupText(count.toString(), numeric: true),\n"
            '    ElButton(\n'
            '      variant: ElButtonVariant.outline,\n'
            '      size: ElButtonSize.sm,\n'
            '      onPressed: () => setState(() => count++),\n'
            "      child: const Text('+'),\n"
            '    ),\n'
            '  ],\n'
            ')',
      ),
    ],
  );

  Widget _install() => ElSection(
    id: 'install',
    title: 'Installation',
    description:
        '`elattar add button-group` installs the component and its declared '
        'dependency closure.',
    child: DocsInstallFacts(
      title: 'Installation facts',
      facts: <DocsInstallFact>[
        const DocsInstallFact(
          label: 'Registry manifest',
          value: 'registry/components/button-group.json',
          description:
              'No registry/components/button_group.json exists. Copy '
              'lib/src/components/button_group.dart manually.',
        ),
        const DocsInstallFact(
          label: 'Platforms',
          value: 'Android, iOS, Web, macOS, Windows, Linux',
          description: 'Pure widget composition: no platform-conditional code.',
        ),
        const DocsInstallFact(
          label: 'Verified',
          value: 'docs specimen only',
          description:
              'This page\'s live preview and example/test/components_docs/'
              'button_group_test.dart.',
        ),
      ],
    ),
  );

  Widget _usage() => ElSection(
    id: 'usage',
    title: 'Usage',
    description:
        'The smallest correct import and construction. Every example '
        'below only changes which members are composed on top of this.',
    child: ElPanel(
      label: 'DART',
      note: 'MINIMAL',
      child: DocsSelectableCodeBlock(code: _usageCode),
    ),
  );

  Widget _composition() => ElSection(
    id: 'composition',
    title: 'Composition',
    description: 'The widget hierarchy ElButtonGroup builds on.',
    child: ElPanel(
      label: 'TREE',
      child: DocsSelectableCodeBlock(code: _compositionCode),
    ),
  );

  Widget _composingOthers(ElThemeData theme) => ElSection(
    id: 'composing-others',
    title: 'Composing other members',
    description:
        'children accepts any widget, not only ElButton and '
        'ElButtonGroupText: only those two types get corner reshaping and '
        'border synthesis. An unrecognised member is placed flush with its '
        'own corners untouched, which covers a plain field, a dropdown '
        'trigger, a select, or a popover trigger composed alongside a '
        'button, all the same mechanism regardless of which widget.',
    child: DocsCodeExample(
      title: 'A plain field alongside a button',
      preview: SizedBox(
        width: el(72),
        child: ElButtonGroup(
          children: <Widget>[
            Expanded(child: ElInput(placeholder: 'Email address')),
            ElButton(
              variant: ElButtonVariant.outline,
              onPressed: () {},
              child: ElText('Send', ElComponentType.buttonLabel),
            ),
          ],
        ),
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'button_group_composing_others.dart',
          title: 'Composing other members',
          code:
              'ElButtonGroup(\n'
              '  children: [\n'
              "    Expanded(child: ElInput(placeholder: 'Email address')),\n"
              '    ElButton(\n'
              '      variant: ElButtonVariant.outline,\n'
              '      onPressed: () {},\n'
              "      child: const Text('Send'),\n"
              '    ),\n'
              '  ],\n'
              ')',
        ),
      ],
    ),
  );

  Widget _separator() => ElSection(
    id: 'separator',
    title: 'Separator',
    description:
        'ElButtonGroupSeparator draws one hairline rule between two '
        'members. Members with an outline border already carry a seam of '
        'their own, a separator is for the five variants that do not.',
    child: DocsCodeExample(
      title: 'A rule between two members',
      preview: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ElButtonGroup(
          children: <Widget>[
            ElButton(
              variant: ElButtonVariant.ghost,
              onPressed: () {},
              child: ElText('Bold', ElComponentType.buttonLabel),
            ),
            ElButton(
              variant: ElButtonVariant.ghost,
              onPressed: () {},
              child: ElText('Italic', ElComponentType.buttonLabel),
            ),
            const ElButtonGroupSeparator(),
            ElButton(
              variant: ElButtonVariant.ghost,
              onPressed: () {},
              child: ElText('Underline', ElComponentType.buttonLabel),
            ),
          ],
        ),
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'button_group_separator.dart',
          title: 'Separator',
          code:
              'ElButtonGroup(\n'
              '  children: [\n'
              '    ElButton(variant: ElButtonVariant.ghost, onPressed: () {}, '
              "child: const Text('Bold')),\n"
              '    ElButton(variant: ElButtonVariant.ghost, onPressed: () {}, '
              "child: const Text('Italic')),\n"
              '    const ElButtonGroupSeparator(),\n'
              '    ElButton(variant: ElButtonVariant.ghost, onPressed: () {}, '
              "child: const Text('Underline')),\n"
              '  ],\n'
              ')',
        ),
      ],
    ),
  );

  Widget _split() => ElSection(
    id: 'split',
    title: 'Split',
    description:
        'A primary action and a narrower secondary action, divided by the '
        'same separator.',
    child: DocsCodeExample(
      title: 'A primary action with a trailing option',
      preview: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ElButtonGroup(
          children: <Widget>[
            ElButton(
              onPressed: () {},
              child: ElText('Save', ElComponentType.buttonLabel),
            ),
            const ElButtonGroupSeparator(),
            ElButton(
              onPressed: () {},
              child: const ElIcon(
                ElIconGlyph.chevronDown,
                size: ElIconSize.sm,
                tone: ElIconTone.inherit,
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _nested(ElThemeData theme) => ElSection(
    id: 'nested',
    title: 'Nested',
    description:
        'Two groups placed side by side. The reference\'s '
        'has-[>[data-slot=button-group]]:gap-2 rule, which spaces a group '
        'nested inside another, is not ported (nothing in this port nests '
        'a group), so a nested layout needs its own gap, an 8px SizedBox '
        'below.',
    child: DocsCodeExample(
      title: 'Two independent groups, one row',
      preview: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ElButtonGroup(
            children: <Widget>[
              ElButton(
                variant: ElButtonVariant.outline,
                size: ElButtonSize.sm,
                onPressed: () {},
                child: ElText('Cut', ElComponentType.buttonLabel),
              ),
              ElButton(
                variant: ElButtonVariant.outline,
                size: ElButtonSize.sm,
                onPressed: () {},
                child: ElText('Copy', ElComponentType.buttonLabel),
              ),
            ],
          ),
          SizedBox(width: el(2)),
          ElButtonGroup(
            children: <Widget>[
              ElButton(
                variant: ElButtonVariant.outline,
                size: ElButtonSize.sm,
                onPressed: () {},
                child: ElText('Paste', ElComponentType.buttonLabel),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _sizes(ElThemeData theme) => ElSection(
    id: 'sizes',
    title: 'Sizes',
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: ElWidths.prose),
      child: ElText(
        'ElButtonGroup has no size prop of its own: each member keeps its '
        'own ElButtonSize. Give every ElButton in a group the same size '
        'for a level row, the sm stepper in the live preview above and '
        'the sm view switcher in Nested are both already that pattern.',
        ElType.small,
        color: theme.mutedForeground,
      ),
    ),
  );

  Widget _vsSelectionControl(ElThemeData theme) => ElSection(
    id: 'vs-selection-control',
    title: 'Vs. selection control',
    child: _bullets(theme, <String>[
      'ElButtonGroup: every member is its own action, pressing "Save" '
          'does not change what "Share" does next to it. Use it for '
          'independent commands, a toolbar, a split action, a stepper.',
      'ElSelectionControl (this port\'s nearest neighbour to shadcn\'s '
          'ToggleGroup) tracks which option is chosen and stays chosen. '
          'Use it when pressing one option is meant to change the state '
          'of the others, a view filter, a single-select set of chips.',
      'The two are not interchangeable: reach for ElButtonGroup by '
          'default, reach for ElSelectionControl only once a press needs '
          'to persist as selected.',
    ]),
  );

  Widget _rtl() => ElSection(
    id: 'rtl',
    title: 'RTL',
    child: DocsCodeExample(
      title: 'Right-to-left reading order',
      preview: const Directionality(
        textDirection: TextDirection.rtl,
        child: _RtlButtonGroup(),
      ),
    ),
  );

  Widget _api() => ElSection(
    id: 'api',
    title: 'API Reference',
    description:
        'Every constructor parameter each exported class declares, read '
        'directly off lib/src/components/button_group.dart: one table per '
        'class.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        KeyedSubtree(
          key: docsAnchorKey('api-elbuttongroup'),
          child: const DocsApiTable(
            title: 'ElButtonGroup',
            facts: _buttonGroupFacts,
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elbuttongrouptext'),
          child: const DocsApiTable(
            title: 'ElButtonGroupText',
            facts: _textFacts,
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elbuttongroupseparator'),
          child: const DocsApiTable(
            title: 'ElButtonGroupSeparator',
            facts: <DocsApiFact>[],
          ),
        ),
      ],
    ),
  );

  Widget _states() => ElSection(
    id: 'states',
    title: 'States',
    description:
        'ElButtonGroup coordinates no state of its own: every state below '
        'belongs to a member.',
    child: const DocsStateMatrix(facts: _stateFacts),
  );

  Widget _accessibility(ElThemeData theme) => ElSection(
    id: 'accessibility',
    title: 'Accessibility and keyboard behavior',
    child: _bullets(theme, <String>[
      'Semantic role: Semantics(container: true, explicitChildNodes: '
          'true) on the row, a plain container role rather than a group '
          'role with its own name, matching the reference\'s role="group". '
          'The members inside keep their own semantics and stay '
          'individually reachable.',
      'Keyboard: ElButtonGroup is not in the tab order itself, it is a '
          'control family, not a focusable container. Each ElButton '
          'inside keeps its own Enter/Space activation and focus ring.',
      'Focus-visible ring: `*:focus-visible:relative *:focus-visible:z-10` '
          'is reproduced by paint order alone, IntrinsicHeight and Row '
          'lay every member out flush and a focused member\'s own ring '
          'paints in front of its neighbours because Flutter draws in '
          'source order.',
      'Known cost of the bleed-and-clip corner mechanism (see the '
          'source\'s own library doc): a focused member\'s ring is drawn '
          'around a box stretched a full height wider than its visible '
          'bounds, so the ring closes half a height out instead of '
          'exactly at the seam the way the browser renders it.',
      'Touch target: each member keeps its own ElButtonSize touch '
          'target; ElButtonGroup adds no minimum of its own.',
    ]),
  );

  Widget _responsive(ElThemeData theme) => ElSection(
    id: 'responsive',
    title: 'Responsive and platform behavior',
    child: _bullets(theme, <String>[
      'No breakpoint branching in button_group.dart: BuildContext width '
          'is never read for a layout decision.',
      'Orientation stays horizontal on every viewport: the reference\'s '
          'own vertical orientation is recorded but never built (see the '
          'source\'s own library doc); this port has no code path for it.',
      'Width: mainAxisSize: MainAxisSize.min keeps the row shrink-to-fit '
          '(w-fit), never stretching to its parent. Overflow scrolls the '
          'caller\'s own ancestor, not the group.',
      'Height: IntrinsicHeight sizes every member to the tallest '
          '(items-stretch), which is the whole reason a height-less '
          'ElButtonGroupText comes out 40px tall next to a default-size '
          'button.',
      'Platform parity: Android, iOS, Web, macOS, Windows, and Linux all '
          'render the same widget tree: no dart:io Platform branch '
          'anywhere in the file.',
    ]),
  );

  Widget _dependencies(ElThemeData theme) => ElSection(
    id: 'dependencies',
    title: 'Dependencies, files, and assets',
    child: _bullets(theme, <String>[
      'File: lib/src/components/button_group.dart. No companion parts.',
      'Dart imports: dart:math (RRect radius scaling for the pill-corner '
          'clip).',
      'Flutter imports: package:flutter/rendering.dart (the custom '
          'RenderBox that bleeds and clips a button\'s corners), '
          'package:flutter/widgets.dart.',
      'Foundation imports: colors.dart, spacing.dart (el()), theme.dart, '
          'typography.dart.',
      'No effects import: unlike ElInputGroup and ElInputOtp, this file '
          'paints its own borders with a CustomPainter rather than '
          'reaching for ElMachineSurface.',
      'Component imports: button.dart (ElButton, ElButtonVariant: reads '
          'a member\'s own variant to derive the seam colour it '
          'contributes).',
      'Registry dependencies are resolved automatically by `elattar add button-group`.',
    ]),
  );

  Widget _theming(ElThemeData theme) => ElSection(
    id: 'theming',
    title: 'Theming notes',
    child: _bullets(theme, <String>[
      'ElButtonGroup paints no fill or border of its own: every visible '
          'colour comes from its members and from the seams the group '
          'synthesises between them.',
      'Seam colour: theme.input for an outline ElButton, '
          'theme.destructive at 25% alpha for a destructive one, '
          'transparent for the other five variants (primary, premium, '
          'secondary, ghost, link contribute nothing, which is why an '
          'all-ghost group reads as one solid control with only its '
          'separators visible).',
      'ElButtonGroupText: theme.muted fill, theme.border stroke (its own '
          '@layer base default, not a group-specific colour).',
      'ElButtonGroupSeparator: theme.input, beating the plain '
          'separator\'s usual theme.border because it is composed later.',
      'No colour overrides: every value comes from ElTheme.of(context) '
          'or from the member\'s own resolved variant colour.',
    ]),
  );

  Widget _source() => ElSection(
    id: 'source',
    title: 'Source and tests',
    child: DocsInstallFacts(
      title: 'Reference',
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'Source',
          value: buttonGroupDoc.sourcePath,
          description:
              'Authoritative implementation: the truth this page was '
              'written from.',
        ),
        const DocsInstallFact(
          label: 'Package tests',
          value: 'none yet',
          description: 'No dedicated unit tests in the package test suite.',
        ),
        const DocsInstallFact(
          label: 'Docs test',
          value: 'example/test/components_docs/button_group_test.dart',
          description:
              'Covers this page: API tables, live specimens, the '
              'radiiOf/hasLeftBorder corner contract, and theme coverage.',
        ),
        const DocsInstallFact(
          label: 'Edit these docs',
          value: 'example/lib/components_docs/button_group/page.dart',
          description: 'This file.',
        ),
      ],
    ),
  );
}

Widget _bullets(ElThemeData theme, List<String> lines) => ConstrainedBox(
  constraints: const BoxConstraints(maxWidth: ElWidths.prose),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      for (final String line in lines) ...<Widget>[
        ElText('•  $line', ElType.small, color: theme.mutedForeground),
        SizedBox(height: el(2)),
      ],
    ],
  ),
);

class _RtlButtonGroup extends StatelessWidget {
  const _RtlButtonGroup();

  @override
  Widget build(BuildContext context) => ElButtonGroup(
    children: <Widget>[
      ElButton(
        variant: ElButtonVariant.outline,
        size: ElButtonSize.sm,
        onPressed: () {},
        child: ElText('الكل', ElComponentType.buttonLabel),
      ),
      ElButton(
        variant: ElButtonVariant.outline,
        size: ElButtonSize.sm,
        onPressed: () {},
        child: ElText('نشط', ElComponentType.buttonLabel),
      ),
      ElButton(
        variant: ElButtonVariant.outline,
        size: ElButtonSize.sm,
        onPressed: () {},
        child: ElText('مؤرشف', ElComponentType.buttonLabel),
      ),
    ],
  );
}

const String _usageCode = '''ElButtonGroup(
  children: <Widget>[
    ElButton(
      variant: ElButtonVariant.outline,
      onPressed: () {},
      child: const Text('Day'),
    ),
    ElButton(
      variant: ElButtonVariant.outline,
      onPressed: () {},
      child: const Text('Week'),
    ),
    ElButton(
      variant: ElButtonVariant.outline,
      onPressed: () {},
      child: const Text('Month'),
    ),
  ],
)''';

const String _compositionCode = '''ElButtonGroup
├── ElButton (or any widget)
├── ElButtonGroupSeparator
└── ElButtonGroupText''';

const List<DocsApiFact> _buttonGroupFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'children',
    type: 'List<Widget>',
    description:
        'Required. The members, in source order: ElButton, '
        'ElButtonGroupText, ElButtonGroupSeparator, or any other widget, '
        'placed flush and left unreshaped.',
  ),
  DocsApiFact(
    name: 'ElButtonGroup.radiiOf',
    type: 'static BorderRadius Function(List<Widget>, int)',
    description:
        'The corner radii the group\'s rules give the member at a given '
        'index: the left end keeps the member\'s own radius, the last '
        'data-slot member is forced to ElRadii.lg, every interior corner '
        'is squared.',
  ),
  DocsApiFact(
    name: 'ElButtonGroup.hasLeftBorder',
    type: 'static bool Function(List<Widget>, int)',
    description:
        'Whether the member at a given index keeps its left border: '
        'true only for the first member.',
  ),
];

const List<DocsApiFact> _textFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'text',
    type: 'String',
    description: 'Required. The cell\'s label, as authored.',
  ),
  DocsApiFact(
    name: 'numeric',
    type: 'bool',
    description:
        'Optional. Defaults to false. Renders with '
        'ElComponentType.buttonGroupNum (mono, tabular figures) instead '
        'of ElComponentType.buttonGroupText.',
  ),
  DocsApiFact(
    name: 'ElButtonGroupText.paddingX',
    type: 'static double',
    description: '10px: horizontal padding.',
  ),
  DocsApiFact(
    name: 'ElButtonGroupText.gap',
    type: 'static double',
    description:
        '8px: gap for a caller composing a glyph beside the label. '
        'Exposed, not applied: a bare-text cell never reaches it.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest / hover / pressed / focus / disabled',
    treatment:
        'Owned entirely by each member: a ElButton inside the group '
        'renders its own variant\'s states unmodified. ElButtonGroup '
        'reads a member\'s variant only to pick the seam colour between '
        'it and its neighbour.',
    userSignal: 'Refer to the button docs for each member\'s own states.',
  ),
  DocsStateFact(
    state: 'Focus-visible (group-level)',
    treatment:
        'A focused member\'s ring paints over its neighbours because '
        'Flutter draws in source order (see Accessibility): no separate '
        'z-index mechanism exists to raise it.',
    userSignal: 'The focused segment\'s ring appears to sit above the rest.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment: 'No AnimationController in button_group.dart itself.',
    userSignal:
        'Nothing to still at the group level; a member\'s own motion '
        'still respects MediaQuery.disableAnimations.',
  ),
];
