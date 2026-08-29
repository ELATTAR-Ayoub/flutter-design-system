/// Public documentation page for the `button_group` component.
///
/// **Re-housed onto the documentation kit.** This page used to be a
/// hand-composed `_Article` built from `kit.dart`'s `Section` (see
/// `example/lib/components_docs/button/page.dart`'s own library doc for the
/// house shape every page is being moved onto). Every specimen and every
/// code string below is the same one the old page rendered; what moved is
/// only where the content lives: a `ComponentDocSpec` declaration plus a
/// ten-line widget, `DocsSection`/`DocsDisclosure` instead of `Section`,
/// and the eight fixed disclosures in the house order (API Reference,
/// States, Accessibility, Keyboard, Responsive, Dependencies, Theming,
/// Source) instead of the old page's own varying set.
///
/// **Two sections became disclosures.** `Composition` and `Usage` still read
/// as always-open code (`SnippetSection`), matching the button page's own
/// `Usage`. `Vs. Selection Control` has no live specimen and no code sample
/// of its own — it is a discursive comparison — so it moved into a
/// `DisclosureSection` of its own, sitting in the middle of the section list
/// rather than among the eight fixed trailing ones. `Sizes` carries no live
/// demo either (`ButtonGroup` has no size prop of its own to demonstrate):
/// it is a `SnippetSection` illustrating the one real pattern its own prose
/// already named, giving every member the same `ButtonSize`.
///
/// **One real addition: Keyboard.** The old page had no dedicated Keyboard
/// section. `button_group.dart` wires no `Focus.onKeyEvent`, no
/// `FocusTraversalPolicy`, and no roving-tabindex of its own — every key
/// event a member receives is handled by that member's own widget (usually
/// `Button`) — and the new Keyboard disclosure below says exactly that.
///
/// `buttonGroupDoc` (from `meta.dart`) is the data source, not
/// `componentDoc('button_group')`.
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
import '../../docs/docs_section.dart' show DocsAnchor;
import 'meta.dart';

/// The declaration: every section this page shows, in TOC order. `final`,
/// not `const`: `InstallSection.command` reads `buttonGroupDoc.command`, a
/// computed getter, not a constant expression.
final ComponentDocSpec buttonGroupDocSpec = ComponentDocSpec(
  name: 'button-group',
  title: 'Button group',
  description: buttonGroupDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description: 'A quantity stepper: the app owns the count, not the group.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          '`elattar add button-group` installs the component and its '
          'declared dependency closure.',
      command: buttonGroupDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/button_group.dart',
          description:
              'No registry/components/button-group.json exists yet. Copy '
              'lib/src/components/ui/button_group.dart manually.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Install with: elattar add button-group',
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct import and construction. Every example '
          'below only changes which members are composed on top of this.',
      code: _usageCode,
    ),
    SnippetSection(
      id: 'composition',
      title: 'Composition',
      description: 'The widget hierarchy ButtonGroup builds on.',
      code: _compositionCode,
    ),
    ShowcaseSection(
      id: 'composing-others',
      title: 'Composing other members',
      description:
          'children accepts any widget, not only Button and '
          'ButtonGroupText: only those two types get corner reshaping and '
          'border synthesis. An unrecognised member is placed flush with its '
          'own corners untouched, which covers a plain field, a dropdown '
          'trigger, a select, or a popover trigger composed alongside a '
          'button, all the same mechanism regardless of which widget.',
      specimen: _ComposingOthersSpecimen(),
      code: _composingOthersCode,
      label: 'Composing other members specimen view',
    ),
    ShowcaseSection(
      id: 'separator',
      title: 'Separator',
      description:
          'ButtonGroupSeparator draws one hairline rule between two '
          'members. Members with an outline border already carry a seam of '
          'their own, a separator is for the five variants that do not.',
      specimen: _SeparatorSpecimen(),
      code: _separatorCode,
      label: 'Separator specimen view',
    ),
    ShowcaseSection(
      id: 'split',
      title: 'Split',
      description:
          'A primary action and a narrower secondary action, divided by the '
          'same separator.',
      specimen: _SplitSpecimen(),
      code: _splitCode,
      label: 'Split specimen view',
    ),
    ShowcaseSection(
      id: 'nested',
      title: 'Nested',
      description:
          'Two groups placed side by side. The reference\'s '
          'has-[>[data-slot=button-group]]:gap-2 rule, which spaces a group '
          'nested inside another, is not ported (nothing in this port nests '
          'a group), so a nested layout needs its own gap, an 8px SizedBox '
          'below.',
      specimen: _NestedSpecimen(),
      code: _nestedCode,
      label: 'Nested specimen view',
    ),
    SnippetSection(
      id: 'sizes',
      title: 'Sizes',
      description:
          'ButtonGroup has no size prop of its own: each member keeps its '
          'own ButtonSize. Give every Button in a group the same size '
          'for a level row, the sm stepper in the Preview above and the sm '
          'view switcher in Nested above are both already that pattern.',
      code: _sizesCode,
    ),
    DisclosureSection(
      id: 'vs-selection-control',
      title: 'Vs. selection control',
      child: _VsSelectionControlContent(),
    ),
    ShowcaseSection(
      id: 'rtl',
      title: 'RTL',
      description: 'Right-to-left reading order, mirrored automatically.',
      specimen: const Directionality(
        textDirection: TextDirection.rtl,
        child: _RtlSpecimen(),
      ),
      code: _rtlCode,
      label: 'RTL specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter each exported class declares, read '
          'directly off lib/src/components/ui/button_group.dart: one table per '
          'class.',
      child: _ApiReferenceContent(),
      children: <DocsTocEntry>[
        DocsTocEntry(title: 'ButtonGroup', anchor: 'api-elbuttongroup'),
        DocsTocEntry(title: 'ButtonGroupText', anchor: 'api-elbuttongrouptext'),
        DocsTocEntry(
          title: 'ButtonGroupSeparator',
          anchor: 'api-elbuttongroupseparator',
        ),
      ],
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'ButtonGroup coordinates no state of its own: every state below '
          'belongs to a member.',
      child: const DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      child: _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
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
    ),
  ],
);

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
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Button group'),
    ],
    toc: buttonGroupDocSpec.toc,
    previous: const DocsPageLink(
      title: 'Input group',
      route: '/components/input_group',
    ),
    next: const DocsPageLink(
      title: 'Input OTP',
      route: '/components/input_otp',
    ),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('button-group-doc-article'),
      child: ComponentDocPage(spec: buttonGroupDocSpec, header: false),
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
  int _count = 3;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: ButtonGroup(
      children: <Widget>[
        Button(
          key: const ValueKey<String>('button-group-doc-decrease'),
          variant: ButtonVariant.outline,
          size: ButtonSize.sm,
          onPressed: () => setState(() => _count = (_count - 1).clamp(0, 99)),
          child: StyledText('−', TextStyles.buttonLabel),
        ),
        ButtonGroupText(
          _count.toString(),
          key: const ValueKey<String>('button-group-doc-count'),
          numeric: true,
        ),
        Button(
          key: const ValueKey<String>('button-group-doc-increase'),
          variant: ButtonVariant.outline,
          size: ButtonSize.sm,
          onPressed: () => setState(() => _count = (_count + 1).clamp(0, 99)),
          child: StyledText('+', TextStyles.buttonLabel),
        ),
      ],
    ),
  );
}

const String _previewCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    'ButtonGroup(\n'
    '  children: [\n'
    '    Button(\n'
    '      variant: ButtonVariant.outline,\n'
    '      size: ButtonSize.sm,\n'
    '      onPressed: () => setState(() => count--),\n'
    "      child: const Text('−'),\n"
    '    ),\n'
    "    ButtonGroupText(count.toString(), numeric: true),\n"
    '    Button(\n'
    '      variant: ButtonVariant.outline,\n'
    '      size: ButtonSize.sm,\n'
    '      onPressed: () => setState(() => count++),\n'
    "      child: const Text('+'),\n"
    '    ),\n'
    '  ],\n'
    ')';

const String _usageCode = '''ButtonGroup(
  children: <Widget>[
    Button(
      variant: ButtonVariant.outline,
      onPressed: () {},
      child: const Text('Day'),
    ),
    Button(
      variant: ButtonVariant.outline,
      onPressed: () {},
      child: const Text('Week'),
    ),
    Button(
      variant: ButtonVariant.outline,
      onPressed: () {},
      child: const Text('Month'),
    ),
  ],
)''';

const String _compositionCode = '''ButtonGroup
├── Button (or any widget)
├── ButtonGroupSeparator
└── ButtonGroupText''';

class _ComposingOthersSpecimen extends StatelessWidget {
  const _ComposingOthersSpecimen();

  @override
  Widget build(BuildContext context) => SizedBox(
    width: space(72),
    child: ButtonGroup(
      children: <Widget>[
        Expanded(child: Input(placeholder: 'Email address')),
        Button(
          variant: ButtonVariant.outline,
          onPressed: () {},
          child: StyledText('Send', TextStyles.buttonLabel),
        ),
      ],
    ),
  );
}

const String _composingOthersCode =
    'ButtonGroup(\n'
    '  children: [\n'
    "    Expanded(child: Input(placeholder: 'Email address')),\n"
    '    Button(\n'
    '      variant: ButtonVariant.outline,\n'
    '      onPressed: () {},\n'
    "      child: const Text('Send'),\n"
    '    ),\n'
    '  ],\n'
    ')';

class _SeparatorSpecimen extends StatelessWidget {
  const _SeparatorSpecimen();

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: ButtonGroup(
      children: <Widget>[
        Button(
          variant: ButtonVariant.ghost,
          onPressed: () {},
          child: StyledText('Bold', TextStyles.buttonLabel),
        ),
        Button(
          variant: ButtonVariant.ghost,
          onPressed: () {},
          child: StyledText('Italic', TextStyles.buttonLabel),
        ),
        const ButtonGroupSeparator(),
        Button(
          variant: ButtonVariant.ghost,
          onPressed: () {},
          child: StyledText('Underline', TextStyles.buttonLabel),
        ),
      ],
    ),
  );
}

const String _separatorCode =
    'ButtonGroup(\n'
    '  children: [\n'
    '    Button(variant: ButtonVariant.ghost, onPressed: () {}, '
    "child: const Text('Bold')),\n"
    '    Button(variant: ButtonVariant.ghost, onPressed: () {}, '
    "child: const Text('Italic')),\n"
    '    const ButtonGroupSeparator(),\n'
    '    Button(variant: ButtonVariant.ghost, onPressed: () {}, '
    "child: const Text('Underline')),\n"
    '  ],\n'
    ')';

class _SplitSpecimen extends StatelessWidget {
  const _SplitSpecimen();

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: ButtonGroup(
      children: <Widget>[
        Button(
          onPressed: () {},
          child: StyledText('Save', TextStyles.buttonLabel),
        ),
        const ButtonGroupSeparator(),
        Button(
          onPressed: () {},
          child: const Icon(
            IconGlyph.chevronDown,
            size: IconSize.sm,
            tone: IconTone.inherit,
          ),
        ),
      ],
    ),
  );
}

const String _splitCode =
    'ButtonGroup(\n'
    '  children: [\n'
    '    Button(\n'
    '      onPressed: () {},\n'
    "      child: const Text('Save'),\n"
    '    ),\n'
    '    const ButtonGroupSeparator(),\n'
    '    Button(\n'
    '      onPressed: () {},\n'
    '      child: const Icon(IconGlyph.chevronDown, size: IconSize.sm),\n'
    '    ),\n'
    '  ],\n'
    ')';

class _NestedSpecimen extends StatelessWidget {
  const _NestedSpecimen();

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ButtonGroup(
          children: <Widget>[
            Button(
              variant: ButtonVariant.outline,
              size: ButtonSize.sm,
              onPressed: () {},
              child: StyledText('Cut', TextStyles.buttonLabel),
            ),
            Button(
              variant: ButtonVariant.outline,
              size: ButtonSize.sm,
              onPressed: () {},
              child: StyledText('Copy', TextStyles.buttonLabel),
            ),
          ],
        ),
        SizedBox(width: space(2)),
        ButtonGroup(
          children: <Widget>[
            Button(
              variant: ButtonVariant.outline,
              size: ButtonSize.sm,
              onPressed: () {},
              child: StyledText('Paste', TextStyles.buttonLabel),
            ),
          ],
        ),
      ],
    ),
  );
}

const String _nestedCode =
    'Row(\n'
    '  children: [\n'
    '    ButtonGroup(\n'
    '      children: [\n'
    '        Button(variant: ButtonVariant.outline, size: '
    "ButtonSize.sm, onPressed: () {}, child: const Text('Cut')),\n"
    '        Button(variant: ButtonVariant.outline, size: '
    "ButtonSize.sm, onPressed: () {}, child: const Text('Copy')),\n"
    '      ],\n'
    '    ),\n'
    '    SizedBox(width: 8), // no has-[>[data-slot=button-group]]:gap-2 in '
    'this port\n'
    '    ButtonGroup(\n'
    '      children: [\n'
    '        Button(variant: ButtonVariant.outline, size: '
    "ButtonSize.sm, onPressed: () {}, child: const Text('Paste')),\n"
    '      ],\n'
    '    ),\n'
    '  ],\n'
    ')';

const String _sizesCode =
    '// Give every Button in a group the same size for a level row.\n'
    'ButtonGroup(\n'
    '  children: [\n'
    '    Button(size: ButtonSize.sm, variant: ButtonVariant.outline, '
    "onPressed: () {}, child: const Text('Cut')),\n"
    '    Button(size: ButtonSize.sm, variant: ButtonVariant.outline, '
    "onPressed: () {}, child: const Text('Copy')),\n"
    '  ],\n'
    ')';

class _RtlSpecimen extends StatelessWidget {
  const _RtlSpecimen();

  @override
  Widget build(BuildContext context) => ButtonGroup(
    children: <Widget>[
      Button(
        variant: ButtonVariant.outline,
        size: ButtonSize.sm,
        onPressed: () {},
        child: StyledText('الكل', TextStyles.buttonLabel),
      ),
      Button(
        variant: ButtonVariant.outline,
        size: ButtonSize.sm,
        onPressed: () {},
        child: StyledText('نشط', TextStyles.buttonLabel),
      ),
      Button(
        variant: ButtonVariant.outline,
        size: ButtonSize.sm,
        onPressed: () {},
        child: StyledText('مؤرشف', TextStyles.buttonLabel),
      ),
    ],
  );
}

const String _rtlCode =
    'Directionality(\n'
    '  textDirection: TextDirection.rtl,\n'
    '  child: ButtonGroup(\n'
    '    children: [\n'
    "      Button(variant: ButtonVariant.outline, size: ButtonSize.sm, onPressed: () {}, child: const Text('الكل')),\n"
    "      Button(variant: ButtonVariant.outline, size: ButtonSize.sm, onPressed: () {}, child: const Text('نشط')),\n"
    "      Button(variant: ButtonVariant.outline, size: ButtonSize.sm, onPressed: () {}, child: const Text('مؤرشف')),\n"
    '    ],\n'
    '  ),\n'
    ')';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _VsSelectionControlContent extends StatelessWidget {
  const _VsSelectionControlContent();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _bullets(theme, <String>[
          'ButtonGroup: every member is its own action, pressing "Save" '
              'does not change what "Share" does next to it. Use it for '
              'independent commands, a toolbar, a split action, a stepper.',
          'SelectionControl (this port\'s nearest neighbour to shadcn\'s '
              'ToggleGroup) tracks which option is chosen and stays chosen. '
              'Use it when pressing one option is meant to change the state '
              'of the others, a view filter, a single-select set of chips.',
          'The two are not interchangeable: reach for ButtonGroup by '
              'default, reach for SelectionControl only once a press needs '
              'to persist as selected.',
        ]),
        SizedBox(height: space(2)),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
          child: DocsLinkRow(
            links: <DocsLink>[
              DocsLink(label: 'Button', route: '/components/button'),
              DocsLink(
                label: 'Selection control',
                route: '/components/selection_control',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elbuttongroup',
        child: DocsApiTable(title: 'ButtonGroup', facts: _buttonGroupFacts),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elbuttongrouptext',
        child: DocsApiTable(title: 'ButtonGroupText', facts: _textFacts),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elbuttongroupseparator',
        child: DocsApiTable(
          title: 'ButtonGroupSeparator',
          facts: <DocsApiFact>[],
        ),
      ),
    ],
  );
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Semantic role: Semantics(container: true, explicitChildNodes: '
            'true) on the row, a plain container role rather than a group '
            'role with its own name, matching the reference\'s role="group". '
            'The members inside keep their own semantics and stay '
            'individually reachable.',
        'Keyboard: ButtonGroup is not in the tab order itself, it is a '
            'control family, not a focusable container. Each Button '
            'inside keeps its own Enter/Space activation and focus ring — '
            'see Keyboard below.',
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
        'Touch target: each member keeps its own ButtonSize touch '
            'target; ButtonGroup adds no minimum of its own.',
      ]);
}

/// New: the design calls for this page to carry its own Keyboard section.
/// Every claim here is read off `lib/src/components/ui/button_group.dart`
/// directly: the file wires no `Focus.onKeyEvent`, no
/// `FocusTraversalPolicy`, and no roving-tabindex mechanism of its own.
class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'ButtonGroup itself wires no keyboard handling: no Focus, no '
            'FocusNode, no Focus.onKeyEvent, and no FocusTraversalPolicy '
            'anywhere in button_group.dart. Every key a member receives is '
            'handled entirely by that member\'s own widget.',
        'An Button member keeps its own Enter/NumpadEnter/Space '
            'activation and its own tab stop unchanged: see the button '
            'page\'s own Keyboard section for exactly what that wiring is.',
        'Tab order: source order, one stop per focusable member, the same '
            'as any other Row. There is no roving-tabindex / single-Tab-'
            'stop-then-arrow-keys mechanism the way a native toolbar '
            'widget set might offer: this is a control family, not one '
            'composite control.',
        'A non-Button member (an Input, say) keeps whatever keyboard '
            'behaviour it already had outside the group: composing it here '
            'changes its corners and its border, never its key handling.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
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
            'ButtonGroupText comes out 40px tall next to a default-size '
            'button.',
        'Platform parity: Android, iOS, Web, macOS, Windows, and Linux all '
            'render the same widget tree: no dart:io Platform branch '
            'anywhere in the file.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ThemeScope.of(context), <String>[
        'File: lib/src/components/ui/button_group.dart. No companion parts.',
        'Dart imports: dart:math (RRect radius scaling for the pill-corner '
            'clip).',
        'Flutter imports: package:flutter/rendering.dart (the custom '
            'RenderBox that bleeds and clips a button\'s corners), '
            'package:flutter/widgets.dart.',
        'Foundation imports: colors.dart, spacing.dart (space()), theme.dart, '
            'typography.dart.',
        'No effects import: unlike InputGroup and InputOtp, this file '
            'paints its own borders with a CustomPainter rather than '
            'reaching for Surface.',
        'Component imports: button.dart (Button, ButtonVariant: reads '
            'a member\'s own variant to derive the seam colour it '
            'contributes).',
        'Registry dependencies are resolved automatically by `elattar add '
            'button-group`.',
      ]),
      SizedBox(height: space(2)),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
        child: DocsLinkRow(
          links: <DocsLink>[
            DocsLink(label: 'Button', route: '/components/button'),
          ],
        ),
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'ButtonGroup paints no fill or border of its own: every visible '
            'colour comes from its members and from the seams the group '
            'synthesises between them.',
        'Seam colour: theme.input for an outline Button, '
            'theme.destructive at 25% alpha for a destructive one, '
            'transparent for the other five variants (primary, premium, '
            'secondary, ghost, link contribute nothing, which is why an '
            'all-ghost group reads as one solid control with only its '
            'separators visible).',
        'ButtonGroupText: theme.muted fill, theme.border stroke (its own '
            '@layer base default, not a group-specific colour).',
        'ButtonGroupSeparator: theme.input, beating the plain '
            'separator\'s usual theme.border because it is composed later.',
        'No colour overrides: every value comes from ThemeScope.of(context) '
            'or from the member\'s own resolved variant colour.',
      ]);
}

Widget _bullets(ThemeTokens theme, List<String> lines) => ConstrainedBox(
  constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      for (final String line in lines) ...<Widget>[
        StyledText('•  $line', TextStyles.small, color: theme.mutedForeground),
        SizedBox(height: space(2)),
      ],
    ],
  ),
);

const List<DocsApiFact> _buttonGroupFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'children',
    type: 'List<Widget>',
    description:
        'Required. The members, in source order: Button, '
        'ButtonGroupText, ButtonGroupSeparator, or any other widget, '
        'placed flush and left unreshaped.',
  ),
  DocsApiFact(
    name: 'ButtonGroup.radiiOf',
    type: 'static BorderRadius Function(List<Widget>, int)',
    description:
        'The corner radii the group\'s rules give the member at a given '
        'index: the left end keeps the member\'s own radius, the last '
        'data-slot member is forced to Radii.lg, every interior corner '
        'is squared.',
  ),
  DocsApiFact(
    name: 'ButtonGroup.hasLeftBorder',
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
        'TextStyles.buttonGroupNum (mono, tabular figures) instead '
        'of TextStyles.buttonGroupText.',
  ),
  DocsApiFact(
    name: 'ButtonGroupText.paddingX',
    type: 'static double',
    description: '10px: horizontal padding.',
  ),
  DocsApiFact(
    name: 'ButtonGroupText.gap',
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
        'Owned entirely by each member: a Button inside the group '
        'renders its own variant\'s states unmodified. ButtonGroup '
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
