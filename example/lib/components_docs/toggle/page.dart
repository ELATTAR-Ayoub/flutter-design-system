/// Public documentation page for the `toggle` component.
///
/// **Re-housed onto the documentation kit.** This page used to be a
/// hand-composed `_ToggleArticle` built from `kit.dart`'s `Section` (see
/// `example/lib/components_docs/button/page.dart`'s own library doc for the
/// house shape every page is being moved onto). Every specimen and every
/// code string below is the same one the old page rendered; what moved is
/// only where the content lives: a `ComponentDocSpec` declaration plus a
/// ten-line widget, `DocsSection`/`DocsDisclosure` instead of `Section`,
/// and the eight fixed disclosures in the house order (API Reference,
/// States, Accessibility, Keyboard, Responsive, Dependencies, Theming,
/// Source) instead of the old page's own six.
///
/// **Two specimens gained a code string, and one gained a live specimen.**
/// The old un-headed hero demo and the `Independent toggles` example had no
/// `code:` of their own (`DocsCodeExample` renders a bare preview when no
/// `manualFiles` are given, and `Independent toggles` rendered ONLY a static
/// code block with no interactive demo at all). Every `ShowcaseSection`
/// requires both halves of the Preview↔Code toggle, so `Preview` gets an
/// honest code sample of the composition already on screen, and
/// `Independent toggles` gets a live pair of `Toggle`s built from the
/// exact code the old page already showed, rather than dropping either half.
///
/// **Split from toggle-group**, unchanged by this pass: see the sibling
/// `components_docs/toggle_group/page.dart` for `ToggleGroup` and
/// `ToggleGroupItem`.
///
/// **One real addition: Keyboard.** The old page's Accessibility panel
/// already named the activation keys and the focus-visible predicate; the
/// new Keyboard disclosure restates them on their own, read directly off
/// `lib/src/components/ui/toggle.dart`'s `_onKey` and its `Focus` wrapper —
/// the same split the button page made between its own Accessibility and
/// Keyboard sections.
///
/// `toggleDoc` (from `meta.dart`) is the data source, not
/// `componentDoc('toggle')`.
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
import '../../kit.dart' show StateCell;
import 'meta.dart';

/// The declaration: every section this page shows, in TOC order. `final`,
/// not `const`: `InstallSection.command` reads `toggleDoc.command`, a
/// computed getter, not a constant expression.
final ComponentDocSpec toggleDocSpec = ComponentDocSpec(
  name: 'toggle',
  title: 'Toggle',
  description: toggleDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'Rest, Selected, Outline variant and Focus-visible are operable: '
          'tap or Tab to them. Disabled is deliberately inert.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'Command install is available: read this before reaching for '
          'elattar add toggle.',
      command: toggleDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/src/components/ui/toggle.dart',
          title: 'Manual: source mode (not recommended yet)',
          description:
              'Copying this file will not compile on its own: it needs '
              'sibling files with it (see Dependencies below), and no '
              'manifest exists yet to resolve them for you. Package mode — '
              'depending on the package and using Toggle directly, exactly '
              'as this page does — is supported today.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Package mode: depend on the package and use Toggle\n'
              '// directly. Source mode has no manifest yet.',
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct example. Toggle never holds its own '
          'state: pressed comes in, onChanged goes out. onChanged is always '
          'called with !pressed, because a toggle has exactly one other '
          'state. The control is fully governed by the caller: it holds no '
          'internal value, so nothing changes on screen until the state you '
          'pass back in changes. For a mutually exclusive row of options, '
          'where selecting one must clear the rest, reach for ToggleGroup '
          'instead: it has its own page.',
      code: _smallestUsageCode,
    ),
    ShowcaseSection(
      id: 'outline',
      title: 'Outline',
      description:
          'variant: ToggleVariant.outline adds a 1px theme.input border; '
          'the fill and ink stay the same as standard.',
      specimen: _OutlineSpecimen(),
      code: _outlineCode,
      label: 'Outline specimen view',
    ),
    ShowcaseSection(
      id: 'with-text',
      title: 'With text',
      description:
          'A toggle is not limited to a bare icon: child accepts any '
          'widget, so an icon and a label can share one Row, spaced by '
          'Toggle.gap.',
      specimen: _WithTextSpecimen(),
      code: _withTextCode,
      label: 'With text specimen view',
    ),
    ShowcaseSection(
      id: 'independent',
      title: 'Independent toggles',
      description:
          'Not on the counterpart page, added in its per-example style: '
          'the question a reader arrives with now that ToggleGroup has '
          'its own page. Two Toggles, not a ToggleGroup: Bold and '
          'Italic can both be on, both be off, or any mix. There is no '
          'mutual exclusivity between them, so a group (which always has at '
          'most one selection) would be the wrong tool.',
      specimen: _IndependentSpecimen(),
      code: _toolbarCode,
      label: 'Independent toggles specimen view',
    ),
    ShowcaseSection(
      id: 'sizes',
      title: 'Sizes',
      description:
          'Three rungs, and each one changes height, minimum width, corner '
          'radius, and the icon rung a child Icon should render at. Two '
          'variants times three sizes: all six combinations are real and '
          'tappable below.',
      specimen: _SizesSpecimen(),
      code: _sizesCode,
      label: 'Sizes specimen view',
    ),
    ShowcaseSection(
      id: 'disabled',
      title: 'Disabled',
      description:
          'A null onChanged dims the control to 50% opacity and removes it '
          'from hit-testing and the tab order, independent of pressed. '
          'There is no separate enabled flag.',
      specimen: _DisabledSpecimen(),
      code: _disabledCode,
      label: 'Disabled specimen view',
    ),
    ShowcaseSection(
      id: 'rtl',
      title: 'RTL',
      description:
          'Toggle paints no direction-dependent geometry of its own '
          '(EdgeInsets.symmetric, Center), so the same composition reads '
          'correctly under Directionality.rtl with no extra wiring.',
      specimen: _RtlSpecimen(),
      code: _rtlCode,
      label: 'RTL specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter Toggle declares, its six static '
          'helpers, and both enums it owns: one table each, read off '
          'lib/src/components/ui/toggle.dart.',
      child: _ApiReferenceContent(),
      children: <DocsTocEntry>[
        DocsTocEntry(title: 'Toggle', anchor: 'api-eltoggle'),
        DocsTocEntry(
          title: 'Toggle static helpers',
          anchor: 'api-eltoggle-static',
        ),
        DocsTocEntry(title: 'ToggleVariant', anchor: 'api-eltoggle-variant'),
        DocsTocEntry(title: 'ToggleSize', anchor: 'api-eltoggle-size'),
      ],
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Read straight off _DsToggleState._skin and _DsToggleState.build. '
          'Pressed, Loading, Empty, Error and Success are omitted: reasons '
          'follow the table.',
      child: _StatesContent(),
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
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Source',
            value: toggleDoc.sourcePath,
            description:
                'Authoritative implementation of Toggle, ToggleVariant '
                'and ToggleSize: the truth this page was written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/components_test.dart',
            description:
                'The Toggle group within that file covers geometry, '
                'statics and state behaviour in the package itself; there '
                'is no dedicated toggle_test.dart in the package yet.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/toggle_test.dart',
            description:
                'Covers this page: the section order, API completeness for '
                'Toggle and both its enums, every live specimen, and both '
                'themes at two viewport widths.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/toggle/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class ToggleDocPage extends StatelessWidget {
  const ToggleDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: toggleDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: toggleDoc.title,
      description: toggleDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Toggle'),
    ],
    toc: toggleDocSpec.toc,
    previous: const DocsPageLink(title: 'Switch', route: '/components/switch'),
    next: const DocsPageLink(
      title: 'Toggle group',
      route: '/components/toggle-group',
    ),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('toggle-doc-article'),
      child: ComponentDocPage(spec: toggleDocSpec, header: false),
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
  bool _rest = false;
  bool _selected = true;
  bool _outline = false;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: space(3),
    runSpacing: space(3),
    children: <Widget>[
      StateCell(
        label: 'Rest',
        note: 'Tap to toggle',
        child: Toggle(
          key: const ValueKey<String>('toggle-live-specimen'),
          pressed: _rest,
          label: 'Favorite',
          onChanged: (bool next) => setState(() => _rest = next),
          child: Icon(IconGlyph.heart, size: Toggle.iconSizeFor(ToggleSize.md)),
        ),
      ),
      StateCell(
        label: 'Selected (on)',
        note: 'Tap to toggle',
        child: Toggle(
          pressed: _selected,
          label: 'Favorite',
          onChanged: (bool next) => setState(() => _selected = next),
          child: Icon(IconGlyph.heart, size: Toggle.iconSizeFor(ToggleSize.md)),
        ),
      ),
      StateCell(
        label: 'Outline variant',
        note: 'Tap to toggle',
        child: Toggle(
          variant: ToggleVariant.outline,
          pressed: _outline,
          label: 'Bold',
          onChanged: (bool next) => setState(() => _outline = next),
          child: const Text('B'),
        ),
      ),
      const StateCell(
        label: 'Focus-visible',
        note: 'Real keyboard focus, not a forced prop',
        child: _ToggleFocusDemo(),
      ),
      StateCell(
        label: 'Disabled',
        child: Toggle(
          pressed: false,
          label: 'Favorite',
          child: Icon(IconGlyph.heart, size: Toggle.iconSizeFor(ToggleSize.md)),
        ),
      ),
    ],
  );
}

/// A [Toggle] that requests real keyboard focus on mount, rather than a
/// forced prop: Toggle exposes no `forceFocusRing`, so this is what
/// showing focus-visible genuinely means for this control.
class _ToggleFocusDemo extends StatefulWidget {
  const _ToggleFocusDemo();

  @override
  State<_ToggleFocusDemo> createState() => _ToggleFocusDemoState();
}

class _ToggleFocusDemoState extends State<_ToggleFocusDemo> {
  final FocusNode _node = FocusNode(debugLabel: 'toggle-focus-demo');
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((Duration _) {
      if (mounted) _node.requestFocus();
    });
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Toggle(
    focusNode: _node,
    pressed: _pressed,
    label: 'Favorite',
    onChanged: (bool next) => setState(() => _pressed = next),
    child: Icon(IconGlyph.heart, size: Toggle.iconSizeFor(ToggleSize.md)),
  );
}

const String _previewCode = '''Toggle(
  pressed: favorite,
  label: 'Favorite',
  onChanged: (bool next) => setState(() => favorite = next),
  child: Icon(IconGlyph.heart, size: Toggle.iconSizeFor(ToggleSize.md)),
)

// Outline variant
Toggle(
  variant: ToggleVariant.outline,
  pressed: bold,
  label: 'Bold',
  onChanged: (bool next) => setState(() => bold = next),
  child: const Text('B'),
)

// Disabled: a null onChanged is the only disabled switch Toggle has.
Toggle(
  pressed: false,
  label: 'Favorite',
  child: Icon(IconGlyph.heart, size: Toggle.iconSizeFor(ToggleSize.md)),
)''';

const String _smallestUsageCode = '''bool bold = false;

Toggle(
  pressed: bold,
  label: 'Bold',
  onChanged: (bool next) => setState(() => bold = next),
  child: const Text('B'),
)''';

class _OutlineSpecimen extends StatefulWidget {
  const _OutlineSpecimen();

  @override
  State<_OutlineSpecimen> createState() => _OutlineSpecimenState();
}

class _OutlineSpecimenState extends State<_OutlineSpecimen> {
  bool _bold = false;
  bool _italic = false;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Toggle(
        key: const ValueKey<String>('toggle-outline-bold-specimen'),
        variant: ToggleVariant.outline,
        pressed: _bold,
        label: 'Bold',
        onChanged: (bool next) => setState(() => _bold = next),
        child: const Text('B'),
      ),
      SizedBox(width: Toggle.gap),
      Toggle(
        variant: ToggleVariant.outline,
        pressed: _italic,
        label: 'Italic',
        onChanged: (bool next) => setState(() => _italic = next),
        child: const Text('I'),
      ),
    ],
  );
}

const String _outlineCode = '''Toggle(
  variant: ToggleVariant.outline,
  pressed: bold,
  label: 'Bold',
  onChanged: (bool next) => setState(() => bold = next),
  child: const Text('B'),
)''';

class _WithTextSpecimen extends StatefulWidget {
  const _WithTextSpecimen();

  @override
  State<_WithTextSpecimen> createState() => _WithTextSpecimenState();
}

class _WithTextSpecimenState extends State<_WithTextSpecimen> {
  bool _favorite = false;

  @override
  Widget build(BuildContext context) => Toggle(
    key: const ValueKey<String>('toggle-with-text-specimen'),
    pressed: _favorite,
    onChanged: (bool next) => setState(() => _favorite = next),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(IconGlyph.heart, size: Toggle.iconSizeFor(ToggleSize.md)),
        SizedBox(width: Toggle.gap),
        const Text('Favorite'),
      ],
    ),
  );
}

const String _withTextCode = '''Toggle(
  pressed: favorite,
  onChanged: (bool next) => setState(() => favorite = next),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Icon(IconGlyph.heart, size: Toggle.iconSizeFor(ToggleSize.md)),
      SizedBox(width: Toggle.gap),
      const Text('Favorite'),
    ],
  ),
)''';

class _IndependentSpecimen extends StatefulWidget {
  const _IndependentSpecimen();

  @override
  State<_IndependentSpecimen> createState() => _IndependentSpecimenState();
}

class _IndependentSpecimenState extends State<_IndependentSpecimen> {
  bool _bold = false;
  bool _italic = false;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Toggle(
        key: const ValueKey<String>('toggle-independent-bold-specimen'),
        pressed: _bold,
        label: 'Bold',
        onChanged: (bool next) => setState(() => _bold = next),
        child: const Text('B'),
      ),
      SizedBox(width: Toggle.gap),
      Toggle(
        key: const ValueKey<String>('toggle-independent-italic-specimen'),
        pressed: _italic,
        label: 'Italic',
        onChanged: (bool next) => setState(() => _italic = next),
        child: const Text('I'),
      ),
    ],
  );
}

const String _toolbarCode = '''bool bold = false;
bool italic = false;

Row(
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    Toggle(
      pressed: bold,
      label: 'Bold',
      onChanged: (bool next) => setState(() => bold = next),
      child: const Text('B'),
    ),
    SizedBox(width: Toggle.gap),
    Toggle(
      pressed: italic,
      label: 'Italic',
      onChanged: (bool next) => setState(() => italic = next),
      child: const Text('I'),
    ),
  ],
)''';

class _SizesSpecimen extends StatefulWidget {
  const _SizesSpecimen();

  @override
  State<_SizesSpecimen> createState() => _SizesSpecimenState();
}

class _SizesSpecimenState extends State<_SizesSpecimen> {
  static const List<ToggleVariant> _variants = <ToggleVariant>[
    ToggleVariant.standard,
    ToggleVariant.outline,
  ];
  static const List<ToggleSize> _sizes = <ToggleSize>[
    ToggleSize.sm,
    ToggleSize.md,
    ToggleSize.lg,
  ];

  final List<bool> _pressed = List<bool>.filled(
    _variants.length * _sizes.length,
    false,
  );

  @override
  Widget build(BuildContext context) {
    final List<Widget> cells = <Widget>[];
    int index = 0;
    for (final ToggleVariant variant in _variants) {
      for (final ToggleSize size in _sizes) {
        final int cellIndex = index;
        cells.add(
          StateCell(
            label: '${variant.name} · ${size.name}',
            note: 'Tap to toggle',
            child: Toggle(
              key: ValueKey<String>(
                'toggle-sizes-${variant.name}-${size.name}-specimen',
              ),
              variant: variant,
              size: size,
              pressed: _pressed[cellIndex],
              label: 'Favorite',
              onChanged: (bool next) =>
                  setState(() => _pressed[cellIndex] = next),
              child: Icon(IconGlyph.heart, size: Toggle.iconSizeFor(size)),
            ),
          ),
        );
        index++;
      }
    }
    return Wrap(spacing: space(3), runSpacing: space(3), children: cells);
  }
}

const String _sizesCode =
    '''Toggle(size: ToggleSize.sm, pressed: on, label: 'Favorite', onChanged: (bool next) => setState(() => on = next), child: Icon(IconGlyph.heart, size: Toggle.iconSizeFor(ToggleSize.sm)))
Toggle(size: ToggleSize.md, pressed: on, label: 'Favorite', onChanged: (bool next) => setState(() => on = next), child: Icon(IconGlyph.heart, size: Toggle.iconSizeFor(ToggleSize.md)))
Toggle(size: ToggleSize.lg, pressed: on, label: 'Favorite', onChanged: (bool next) => setState(() => on = next), child: Icon(IconGlyph.heart, size: Toggle.iconSizeFor(ToggleSize.lg)))

// Each rung shown at both variant: ToggleVariant.standard and .outline.''';

class _DisabledSpecimen extends StatelessWidget {
  const _DisabledSpecimen();

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const Toggle(
        key: ValueKey<String>('toggle-disabled-off-specimen'),
        pressed: false,
        label: 'Bold',
        child: Text('B'),
      ),
      SizedBox(width: Toggle.gap),
      const Toggle(
        key: ValueKey<String>('toggle-disabled-on-specimen'),
        pressed: true,
        label: 'Bold',
        child: Text('B'),
      ),
    ],
  );
}

const String _disabledCode =
    '''Toggle(pressed: false, label: 'Bold', child: const Text('B'))

Toggle(pressed: true, label: 'Bold', child: const Text('B'))''';

class _RtlSpecimen extends StatefulWidget {
  const _RtlSpecimen();

  @override
  State<_RtlSpecimen> createState() => _RtlSpecimenState();
}

class _RtlSpecimenState extends State<_RtlSpecimen> {
  bool _bold = false;

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Toggle(
      key: const ValueKey<String>('toggle-rtl-specimen'),
      pressed: _bold,
      label: 'غامق',
      onChanged: (bool next) => setState(() => _bold = next),
      child: const Text('غامق'),
    ),
  );
}

const String _rtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: Toggle(
    pressed: bold,
    label: 'غامق',
    onChanged: (bool next) => setState(() => bold = next),
    child: const Text('غامق'),
  ),
)''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-eltoggle',
        child: DocsApiTable(title: 'Toggle', facts: _toggleApiFacts),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-eltoggle-static',
        child: DocsApiTable(
          title: 'Toggle static helpers',
          facts: _toggleStaticFacts,
        ),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-eltoggle-variant',
        child: DocsApiTable(title: 'ToggleVariant', facts: _variantFacts),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-eltoggle-size',
        child: DocsApiTable(title: 'ToggleSize', facts: _sizeFacts),
      ),
    ],
  );
}

const List<DocsApiFact> _toggleApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description:
        'Required. The content: a label, an icon, or a row of both spaced '
        'by Toggle.gap. This widget installs the resolved text style as a '
        'DefaultTextStyle, so a bare Text child is the right choice for a '
        'labelled toggle.',
  ),
  DocsApiFact(
    name: 'pressed',
    type: 'bool',
    description:
        'Required. Which of the two states is rendered: on when true. The '
        'control never holds its own state, it is fully governed by the '
        'caller, because a group above it may need to clear the selection '
        'entirely.',
  ),
  DocsApiFact(
    name: 'onChanged',
    type: 'ValueChanged<bool>?',
    description:
        'Optional. Defaults to null, which disables the control on its '
        'own: there is no separate enabled flag. Called with the value the '
        'control is asking to move to, always !pressed, since a toggle has '
        'exactly one other state.',
  ),
  DocsApiFact(
    name: 'variant',
    type: 'ToggleVariant',
    description:
        'Optional. Defaults to ToggleVariant.standard (no border box at '
        'all). See the ToggleVariant table below.',
  ),
  DocsApiFact(
    name: 'size',
    type: 'ToggleSize',
    description:
        'Optional. Defaults to ToggleSize.md. Selects height, minimum '
        'width, corner radius, and the icon rung a child should render at. '
        'See the ToggleSize table below.',
  ),
  DocsApiFact(
    name: 'label',
    type: 'String?',
    description:
        'Optional. Defaults to null. The accessible name: overrides, '
        "rather than adds to, whatever name the child's own content would "
        'supply (excludeSemantics: true whenever it is set). Required for '
        'an icon-only toggle to have any accessible name; optional for a '
        'text-labelled one, whose own text already names it.',
  ),
  DocsApiFact(
    name: 'focusNode',
    type: 'FocusNode?',
    description:
        'Optional. Defaults to null, which lets the control own its own '
        'node. Supply one to drive focus-visible from outside.',
  ),
  DocsApiFact(
    name: 'pressedFill',
    type: 'Color?',
    description:
        'Optional. Defaults to null, which keeps the default on-fill, '
        'theme.muted. The fill painted while pressed is true. Exists for '
        'ToggleGroup alone, which overrides it to a transparent fill so '
        'its travelling pill shows through.',
  ),
  DocsApiFact(
    name: 'pressedInk',
    type: 'Color?',
    description:
        'Optional. Defaults to null, which keeps the inherited '
        'theme.foreground. The ink painted while pressed is true. '
        'ToggleGroup overrides it to theme.primaryForeground for the '
        'selected item.',
  ),
  DocsApiFact(
    name: 'inExclusiveGroup',
    type: 'bool',
    description:
        'Optional. Defaults to false. true changes only the semantics '
        'node: a standalone toggle announces as a button with an on/off '
        'state; one option of a single-select group announces as a choice '
        'among others instead (selected + inMutuallyExclusiveGroup). '
        'ToggleGroup sets it for every item it builds.',
  ),
];

const List<DocsApiFact> _toggleStaticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'Toggle.heightFor(size)',
    type: 'static double',
    description: "The rung's fixed height: 28 / 32 / 36 for sm / md / lg.",
  ),
  DocsApiFact(
    name: 'Toggle.minWidthFor(size)',
    type: 'static double',
    description:
        'The same 28 / 32 / 36 floor, so an icon-only toggle does not '
        'collapse onto its glyph.',
  ),
  DocsApiFact(
    name: 'Toggle.paddingX',
    type: 'static double',
    description:
        'A getter, not a per-size function: the same 10px of horizontal '
        'padding on every rung.',
  ),
  DocsApiFact(
    name: 'Toggle.gap',
    type: 'static double',
    description:
        'A getter too: 4px between an icon and a label, when a caller '
        'composes both into one child Row. Exposed, not applied.',
  ),
  DocsApiFact(
    name: 'Toggle.radiusFor(size)',
    type: 'static double',
    description:
        "The rung's corner: Radii.lg (12px) on md and lg, and exactly "
        'Radii.md (10px) on sm, which the source writes as '
        'math.min(Radii.md, Radii.lg). Never a indicator: only '
        "ToggleGroup's own travelling pill is a stadium.",
  ),
  DocsApiFact(
    name: 'Toggle.iconSizeFor(size)',
    type: 'static IconSize',
    description:
        'The icon rung a child Icon should render at to match this '
        "control's size: IconSize.sm on ToggleSize.sm, IconSize.md "
        'on md and lg. The caller passes it; a Flutter parent cannot '
        'resize its child the way a CSS descendant selector can.',
  ),
];

const List<DocsApiFact> _variantFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'standard',
    type: 'enum value',
    description:
        'The constructor default. Transparent at rest, theme.muted on '
        'hover and while pressed, and no border box at all.',
  ),
  DocsApiFact(
    name: 'outline',
    type: 'enum value',
    description:
        'The same fill and ink, plus a 1px border: theme.input at rest, '
        'theme.ring while focus-visible. The only variant with a border to '
        'colour.',
  ),
];

const List<DocsApiFact> _sizeFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'sm',
    type: '28px · Radii.md',
    description:
        'The dense rung, and the only one that steps its icon child down '
        'to IconSize.sm.',
  ),
  DocsApiFact(
    name: 'md',
    type: '32px · Radii.lg',
    description: 'The constructor default.',
  ),
  DocsApiFact(
    name: 'lg',
    type: '36px · Radii.lg',
    description:
        'Taller and wider, but the same corner and the same IconSize.md '
        'child as md.',
  ),
];

class _StatesContent extends StatelessWidget {
  const _StatesContent();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsStateMatrix(facts: _stateFacts),
        SizedBox(height: space(3)),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
          child: StyledText(
            'Pressed is not a row: the class list carries no active-state '
            'rule and no press utility, a toggle does nothing at all '
            "between pointer-down and pointer-up, unlike Button's spring "
            "squash (a documented drift in toggle.dart's own header). "
            'Loading and Empty are not rows either: this is a synchronous '
            'primitive with no async operation and nothing to list. Error '
            'is not a row: aria-invalid is never set on this control '
            'anywhere in the reference, and Toggle exposes no invalid '
            'parameter at all. Success is not a row: the component defines '
            'no success semantics of its own.',
            TextStyles.small,
            color: theme.mutedForeground,
          ),
        ),
      ],
    );
  }
}

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest',
    treatment:
        'standard: no fill, no border. outline: a 1px theme.input border. '
        'Ink is theme.foreground either way: hover:text-foreground in the '
        'reference restates a colour the element already has and changes '
        'nothing.',
    userSignal:
        'An unfilled control, distinguishable from Selected only once a '
        'fill or border tells them apart.',
  ),
  DocsStateFact(
    state: 'Hover',
    treatment:
        'theme.muted fill, on both variants: the same fill Selected paints, '
        'so hover and on are visually identical on a standalone toggle.',
    userSignal:
        'A grey wash appears under the pointer; the cursor becomes a click '
        'cursor.',
  ),
  DocsStateFact(
    state: 'Selected (on)',
    treatment:
        'theme.muted fill (the class hover also paints), theme.foreground '
        'ink. Unlike Switch and Checkbox, the on-state is not the '
        'brand colour here. pressedFill and pressedInk are the two hooks '
        'that change that, and ToggleGroup is the one caller in the '
        'corpus that uses them.',
    userSignal:
        'A filled control that stays filled after the pointer leaves: the '
        'only way Rest and Selected are told apart.',
  ),
  DocsStateFact(
    state: 'Focus-visible',
    treatment:
        'A ring at theme.ring, 50% alpha, faded up from fully transparent '
        'on the same clock as the colour legs. On outline the border also '
        'swaps to theme.ring; on standard there is no border box to '
        'colour, so only the ring paints.',
    userSignal:
        'A ring that appears only after keyboard focus: a bare pointer tap '
        'does not request focus, so a tapped-and-released toggle shows no '
        'ring.',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment:
        'onChanged: null, 50% opacity, and an IgnorePointer that removes '
        'the control from hit-testing and hover tracking together, and '
        'from the tab order.',
    userSignal:
        'Dimmed and inert: the one state that visibly dims, matching '
        "Button's own disabled treatment.",
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'The fill/ink/border/ring tween chain resolves through '
        'effectiveMotionDuration, which reduced motion shortens toward zero.',
    userSignal:
        'State changes land on their finished colours immediately, with '
        'no transition to sit through.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) => DocsInstallFacts(
    title: 'Accessibility',
    facts: <DocsInstallFact>[
      const DocsInstallFact(
        label: 'Semantic role',
        value: 'Semantics(button:, toggled:/selected:)',
        description:
            'A standalone toggle (inExclusiveGroup: false, the default) '
            'exposes toggled: pressed. Set inExclusiveGroup: true and it '
            'exposes selected: pressed and inMutuallyExclusiveGroup: true '
            'instead, with toggled left null: a choice among others, not '
            'an independent on/off switch. ToggleGroup is what sets it '
            'in practice.',
      ),
      const DocsInstallFact(
        label: 'Label association',
        value: 'label',
        description:
            "Overrides, rather than adds to, the child's own "
            'content-derived name (excludeSemantics: true whenever label '
            'is set). Required for an icon-only toggle to have any '
            'accessible name.',
      ),
      const DocsInstallFact(
        label: 'Keyboard activation',
        value: 'Enter, numpad Enter, Space',
        description:
            'Hand-wired through Focus.onKeyEvent, the same wiring Button '
            'and Checkbox use: the control is not a native button, so '
            'nothing arrives for free — see Keyboard below.',
      ),
      const DocsInstallFact(
        label: 'Focus behavior',
        value: 'A ring at theme.ring, 50% alpha: keyboard-only',
        description:
            'focus-visible, not focus. Flutter does not move focus on a '
            'bare pointer tap, so hasFocus here already is the '
            'keyboard-only predicate CSS means; a tapped-and-released '
            'toggle never shows the ring.',
      ),
      const DocsInstallFact(
        label: 'Touch target',
        value: 'Exactly the visual box: no cushion',
        description:
            '28x28 / 32x32 / 36x36 depending on size. Unlike Checkbox\'s '
            'HitArea, Toggle wraps its GestureDetector directly around '
            'the sized box with no extra hit-test padding. Every size sits '
            "below the system's 44px touch-target floor: recorded rather "
            'than corrected, because it is what the source renders.',
      ),
      const DocsInstallFact(
        label: 'Non-colour signal',
        value: 'The toggled/selected semantics flag itself',
        description:
            'Visually, the only change between Rest and Selected is a '
            'fill colour; a sighted user who cannot rely on that has no '
            "drawn glyph to fall back on the way Checkbox's tick "
            'provides. A screen reader is told regardless, through the '
            'toggled or selected flag.',
      ),
      const DocsInstallFact(
        label: 'Error wiring',
        value: 'N/A: no invalid parameter exists',
        description:
            'Toggle declares no invalid/aria-invalid path; the source '
            'states aria-invalid is never set on this control anywhere in '
            'the reference. There is nothing to wire.',
      ),
      const DocsInstallFact(
        label: 'Screen-reader announcements',
        value: 'No live region',
        description:
            'State changes are exposed purely through the semantics flags '
            'above; no extra announcement is authored.',
      ),
    ],
  );
}

/// New: the design calls for this page to carry its own Keyboard section,
/// separate from the interaction facts folded into Accessibility above.
/// Every claim here is read off `lib/src/components/ui/toggle.dart`'s own
/// `_onKey` (L334-L339) and its `Focus` wrapper (L465-L469), not inferred.
class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Activation: Enter, NumpadEnter, and Space activate a focused, '
            'enabled toggle. _onKey only inspects these three '
            'LogicalKeyboardKey values; any other key returns '
            'KeyEventResult.ignored so it keeps propagating.',
        'Tab order: canRequestFocus is wired straight to _enabled '
            '(onChanged != null), so a disabled toggle (onChanged: null) '
            'is removed from keyboard traversal entirely, not just dimmed '
            'in place.',
        'No custom ordering: toggle.dart wires no FocusTraversalPolicy of '
            'its own. Tab and Shift+Tab walk whatever order the '
            'surrounding page already declares.',
        'Pointer vs keyboard: a bare pointer tap never requests focus on '
            'the node; only keyboard traversal, or an explicit '
            'focusNode.requestFocus() from outside, does. That asymmetry '
            'is what lets hasFocus stand in for :focus-visible, see '
            'Accessibility above for the ring it drives.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
    child: StyledText(
      'Toggle has no breakpoints of its own: it is a fixed-size atomic '
      'control (28 / 32 / 36px tall, and at least that wide), and nothing '
      'in toggle.dart reads a viewport width to decide anything. What '
      'changes with layout belongs to whatever composes it: a toolbar of '
      "several toggles is the caller's own Row or Wrap, and a Row of them "
      "needs the caller's own wrapping or scrolling at a narrow viewport, "
      'because the control adds none. A long text child is not truncated '
      'or ellipsised either: whitespace-nowrap is what the class list '
      'carries, so the child overflows rather than wrapping. Keyboard '
      'activation and pointer activation behave identically on every '
      'Flutter target this package supports; there is no platform channel '
      'and nothing here is web-only or desktop-only.',
      TextStyles.small,
    ),
  );
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      DocsInstallFacts(
        title: 'Dependencies and files',
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Source file',
            value: toggleDoc.sourcePath,
            description:
                'The authoritative implementation: one file, no '
                'companions.',
          ),
          const DocsInstallFact(
            label: 'Flutter imports',
            value:
                'dart:math (math.min), package:flutter/services.dart '
                '(LogicalKeyboardKey, KeyEvent), '
                'package:flutter/widgets.dart',
            description:
                'math.min is used by radiusFor alone; services.dart '
                'supplies the key constants the Enter/Space wiring '
                'compares against.',
          ),
          const DocsInstallFact(
            label: 'Local file dependencies',
            value: 'button.dart, icon.dart, effects/surface.dart',
            description:
                'toggle.dart imports button.dart for '
                'Button.withFocusRing, icon.dart for the IconSize '
                'return type of iconSizeFor, and effects/'
                'surface.dart for Surface. It does NOT '
                'import motion/active_indicator.dart: the travelling pill '
                'belongs to ToggleGroup, on its own page. None of these '
                'are copyable in isolation: see Installation.',
          ),
          const DocsInstallFact(
            label: 'Foundation dependencies',
            value:
                'foundation/colors.dart, foundation/motion.dart, '
                'foundation/shadows.dart, foundation/spacing.dart, '
                'foundation/theme.dart, foundation/typography.dart, '
                'theme_scope.dart',
            description:
                'Token sources: the transparent-colour constant, '
                'durations and curves, shadow specs, the space() spacing '
                'scale and Radii, the live theme, and the resolved '
                'toggle-label text style.',
          ),
          DocsInstallFact(
            label: 'Exports',
            value: toggleDoc.exports.join(', '),
            description:
                'The public symbols this component makes available. '
                'ToggleGroup and ToggleGroupItem are a separate '
                'export, documented on their own page.',
          ),
          const DocsInstallFact(
            label: 'Assets',
            value: 'none',
            description:
                'Fills, borders and the focus ring are plain box '
                'decoration: no image and no icon-font glyph of its own. '
                'An icon child, if one is composed in, brings its own '
                'geometry from icon_paths.dart, not an asset file.',
          ),
          const DocsInstallFact(
            label: 'Fonts',
            value: 'none',
            description:
                'The component renders no text of its own; a text child '
                'inherits the DefaultTextStyle it installs, which '
                "resolves off the app's own type scale.",
          ),
          const DocsInstallFact(
            label: 'Shaders',
            value: 'none',
            description: 'No fragment shader is used by this file.',
          ),
        ],
      ),
      SizedBox(height: space(2)),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
        child: DocsLinkRow(
          links: <DocsLink>[
            DocsLink(label: 'Button', route: '/components/button'),
            DocsLink(label: 'Icon', route: '/components/icon'),
            DocsLink(label: 'Toggle group', route: '/components/toggle-group'),
            DocsLink(label: 'Surface', route: '/components/surface'),
            DocsLink(
              label: 'Source Foundation',
              route: '/components/source_foundation',
            ),
          ],
        ),
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) => DocsInstallFacts(
    title: 'Tokens this component reads',
    facts: <DocsInstallFact>[
      const DocsInstallFact(
        label: 'Fill',
        value: 'transparent (rest) / theme.muted (hover and on)',
        description:
            "The control's own background. pressedFill replaces the "
            'on-fill when a caller supplies one.',
      ),
      const DocsInstallFact(
        label: 'Border',
        value:
            'theme.input (outline, rest) / theme.ring (outline, '
            'focus-visible)',
        description:
            'Only painted on ToggleVariant.outline: standard has no '
            'border box at all.',
      ),
      const DocsInstallFact(
        label: 'Ink',
        value: 'theme.foreground (rest and on)',
        description:
            "The child's resolved text/icon colour. pressedInk replaces "
            'it while pressed when a caller supplies one.',
      ),
      const DocsInstallFact(
        label: 'Ring',
        value: 'theme.ring at 50% alpha',
        description:
            'The focus-visible ring, composited in front of the surface '
            'through Button.withFocusRing, the shared helper Input '
            'reaches for too.',
      ),
      const DocsInstallFact(
        label: 'Radius',
        value: 'Radii.lg on md and lg / Radii.md on sm',
        description:
            'math.min(Radii.md, Radii.lg) on sm, which resolves to '
            'Radii.md exactly. Never Radii.full: this control is a '
            'rounded rect at every size.',
      ),
      const DocsInstallFact(
        label: 'Shadow',
        value: 'Shadows.none, plus the focus ring',
        description:
            'The surface carries no resting elevation. The only thing '
            'Surface ever paints here is the focus-visible ring, '
            'faded up from a fully transparent copy of itself so the '
            'layer counts match and the colour can interpolate.',
      ),
      const DocsInstallFact(
        label: 'Motion',
        value: 'MotionDurations.normal, MotionCurves.enter',
        description:
            'The fill/ink/border/ring tween chain, resolved through '
            'effectiveMotionDuration, so reduced motion shortens or removes '
            'it automatically. There is no press animation to reduce: '
            'the class list declares none.',
      ),
    ],
  );
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
