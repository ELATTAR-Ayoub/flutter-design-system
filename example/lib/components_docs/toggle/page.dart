/// Public documentation page for the `toggle` component.
///
/// **Split from toggle-group.** This page used to document `ElToggle` and
/// `ElToggleGroup`/`ElToggleGroupItem` together. They are two separately
/// barrel-exported components with two separate shadcn counterparts, so the
/// group moved out whole to `components_docs/toggle_group/page.dart`: every
/// `ElToggleGroup` specimen, its narrow-viewport `SingleChildScrollView`
/// mitigation, its Arabic-label RTL demo, and every mention of
/// `ElSlidingPillGroup` (which `toggle_group.dart` imports and `toggle.dart`
/// does not). What is left here is `ElToggle` alone.
///
/// **Shape.** `components_docs/button/page.dart` is the structural reference:
/// an un-headed live demo before any heading, then Installation, then Usage,
/// then one top-level section per shadcn example, then API Reference last of
/// the component-specific sections, then the six sections shadcn does not
/// carry (States, Accessibility, Responsive, Dependencies, Theming, Source).
/// Section titles carry no `Toggle:` prefix any more: with the group split
/// off, every section on this page is about `ElToggle`, so the prefix restated
/// the page title on every heading.
///
/// **Counterpart.** https://ui.shadcn.com/docs/components/base/toggle, fetched
/// fresh. Its `<h2>`s are, in order: Installation, Usage, Outline, With Text,
/// Size, Disabled, RTL, API Reference. Every one is a section below, under the
/// same name (`Size` pluralised to `Sizes`, because this port ships three
/// rungs rather than shadcn's demo of one).
///
/// **Added, in shadcn's own per-example style.** `Independent toggles` is not
/// on the counterpart page: it exists because the question it answers ("two
/// ElToggles or one ElToggleGroup?") is the one a reader arrives with now that
/// the two components have separate pages. It sits beside `With text`, both
/// being compositions rather than variants.
///
/// **Skipped, honestly.** `Changelog`, present on the counterpart page, has no
/// analogue: this package ships from source, not a versioned registry entry
/// with its own release notes.
///
/// `RTL` is NOT skipped. `ElToggle` paints no direction-dependent geometry of
/// its own (`EdgeInsets.symmetric`, `Center`), so the same composition mirrors
/// correctly under `Directionality.rtl` with no extra wiring: the section
/// below is a real, tappable demonstration, not a documented gap.
///
/// `toggleDoc` (from `meta.dart`) is the data source, not
/// `componentDoc('toggle')`.
///
/// [ComponentDocEntry.description] is the page's only rendered description:
/// the short, one-sentence hero line. No second, longer paragraph renders
/// beneath it; Installation is the first section after the hero.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

class ToggleDocPage extends StatelessWidget {
  const ToggleDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    return DocsLayout(
      route: toggleDoc.route,
      intro: DocsPageIntro(
        eyebrow: 'COMPONENTS / BASE',
        title: toggleDoc.title,
        description: toggleDoc.description,
      ),
      breadcrumbs: const <ElBreadcrumbEntry>[
        ElBreadcrumbEntry.link('Components'),
        ElBreadcrumbEntry.page('Toggle'),
      ],
      // No entry for the hero demo: it renders before any heading, exactly as
      // shadcn's own "Bookmark" demo is not itself a stop on the reference's
      // on-this-page nav.
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Installation', anchor: 'install'),
        DocsTocEntry(title: 'Usage', anchor: 'usage'),
        DocsTocEntry(title: 'Outline', anchor: 'outline'),
        DocsTocEntry(title: 'With text', anchor: 'with-text'),
        DocsTocEntry(title: 'Independent toggles', anchor: 'independent'),
        DocsTocEntry(title: 'Sizes', anchor: 'sizes'),
        DocsTocEntry(title: 'Disabled', anchor: 'disabled'),
        DocsTocEntry(title: 'RTL', anchor: 'rtl'),
        DocsTocEntry(
          title: 'API Reference',
          anchor: 'api',
          children: <DocsTocEntry>[
            DocsTocEntry(title: 'ElToggle', anchor: 'api-eltoggle'),
            DocsTocEntry(
              title: 'ElToggle static helpers',
              anchor: 'api-eltoggle-static',
            ),
            DocsTocEntry(
              title: 'ElToggleVariant',
              anchor: 'api-eltoggle-variant',
            ),
            DocsTocEntry(title: 'ElToggleSize', anchor: 'api-eltoggle-size'),
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
        title: 'Switch',
        route: '/components/switch',
      ),
      // The page the group half of this one moved to.
      next: const DocsPageLink(
        title: 'Toggle group',
        route: '/components/toggle-group',
      ),
      onNavigate: onNavigate,
      child: const _ToggleArticle(),
    );
  }
}

class _ToggleArticle extends StatelessWidget {
  const _ToggleArticle();

  @override
  Widget build(BuildContext context) => Column(
    key: const ValueKey<String>('toggle-doc-article'),
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      _Anchor('preview', child: const _PreviewSection()),
      SizedBox(height: el(8)),
      const _InstallSection(),
      SizedBox(height: el(2)),
      const _UsageSection(),
      SizedBox(height: el(2)),
      const _OutlineSection(),
      SizedBox(height: el(2)),
      const _WithTextSection(),
      SizedBox(height: el(2)),
      const _IndependentSection(),
      SizedBox(height: el(2)),
      const _SizesSection(),
      SizedBox(height: el(2)),
      const _DisabledSection(),
      SizedBox(height: el(2)),
      const _RtlSection(),
      SizedBox(height: el(2)),
      const _ApiSection(),
      SizedBox(height: el(2)),
      const _StatesSection(),
      SizedBox(height: el(2)),
      const _AccessibilitySection(),
      SizedBox(height: el(2)),
      const _ResponsiveSection(),
      SizedBox(height: el(2)),
      const _DependenciesSection(),
      SizedBox(height: el(2)),
      const _ThemingSection(),
      SizedBox(height: el(2)),
      const _SourceSection(),
    ],
  );
}

/// The counterpart page's own un-headed hero demo: five standalone [ElToggle]
/// specimens, one per state a reader needs to tell apart.
class _PreviewSection extends StatelessWidget {
  const _PreviewSection();

  @override
  Widget build(BuildContext context) => const DocsCodeExample(
    title: 'Toggle',
    description:
        'Rest, Selected, Outline variant and Focus-visible are operable: '
        'tap or Tab to them. Disabled is deliberately inert.',
    preview: _TogglePreview(),
  );
}

class _TogglePreview extends StatefulWidget {
  const _TogglePreview();

  @override
  State<_TogglePreview> createState() => _TogglePreviewState();
}

class _TogglePreviewState extends State<_TogglePreview> {
  bool _rest = false;
  bool _selected = true;
  bool _outline = false;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: el(3),
      runSpacing: el(3),
      children: <Widget>[
        ElStateCell(
          label: 'Rest',
          note: 'Tap to toggle',
          child: ElToggle(
            key: const ValueKey<String>('toggle-live-specimen'),
            pressed: _rest,
            label: 'Favorite',
            onChanged: (bool next) => setState(() => _rest = next),
            child: ElIcon(
              ElIconGlyph.heart,
              size: ElToggle.iconSizeFor(ElToggleSize.md),
            ),
          ),
        ),
        ElStateCell(
          label: 'Selected (on)',
          note: 'Tap to toggle',
          child: ElToggle(
            pressed: _selected,
            label: 'Favorite',
            onChanged: (bool next) => setState(() => _selected = next),
            child: ElIcon(
              ElIconGlyph.heart,
              size: ElToggle.iconSizeFor(ElToggleSize.md),
            ),
          ),
        ),
        ElStateCell(
          label: 'Outline variant',
          note: 'Tap to toggle',
          child: ElToggle(
            variant: ElToggleVariant.outline,
            pressed: _outline,
            label: 'Bold',
            onChanged: (bool next) => setState(() => _outline = next),
            child: const Text('B'),
          ),
        ),
        const ElStateCell(
          label: 'Focus-visible',
          note: 'Real keyboard focus, not a forced prop',
          child: _ToggleFocusDemo(),
        ),
        ElStateCell(
          label: 'Disabled',
          child: ElToggle(
            pressed: false,
            label: 'Favorite',
            child: ElIcon(
              ElIconGlyph.heart,
              size: ElToggle.iconSizeFor(ElToggleSize.md),
            ),
          ),
        ),
      ],
    );
  }
}

/// A [ElToggle] that requests real keyboard focus on mount, rather than a
/// forced prop: ElToggle exposes no `forceFocusRing`, so this is what showing
/// focus-visible genuinely means for this control.
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
  Widget build(BuildContext context) {
    return ElToggle(
      focusNode: _node,
      pressed: _pressed,
      label: 'Favorite',
      onChanged: (bool next) => setState(() => _pressed = next),
      child: ElIcon(
        ElIconGlyph.heart,
        size: ElToggle.iconSizeFor(ElToggleSize.md),
      ),
    );
  }
}

/// shadcn's Installation section: CLI and Manual tabs. `toggle` has not
/// shipped a registry manifest yet, so `elattar add toggle` will not resolve:
/// the Manual tab is the whole story, and this panel also folds in the
/// version and platform facts rather than giving them a heading the
/// counterpart page has nowhere.
class _InstallSection extends StatelessWidget {
  const _InstallSection();

  @override
  Widget build(BuildContext context) => const ElSection(
    id: 'install',
    title: 'Installation',
    description:
        'Command install is available: read this before reaching '
        'for elattar add toggle.',
    child: DocsInstallFacts(
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'CLI',
          value: 'elattar add toggle',
          description:
              'toggle is a registry item, so this resolves it and its '
              'dependencies and copies the source into your project.',
        ),
        DocsInstallFact(
          label: 'Manual: package mode (supported today)',
          value:
              "import 'package:elattar_design_system/elattar_design_system.dart';",
          description:
              'Depend on the package and use ElToggle directly, exactly as '
              'this page does.',
        ),
        DocsInstallFact(
          label: 'Manual: source mode (not recommended yet)',
          value: 'lib/src/components/toggle.dart',
          description:
              'Copying this file will not compile on its own: it needs '
              'sibling files with it (see Dependencies below), and no '
              'manifest exists yet to resolve them for you.',
        ),
        DocsInstallFact(
          label: 'Status',
          value: 'Stable, installable through elattar add toggle',
          description:
              'Ported and tested against lib/src/components/toggle.dart.',
        ),
        DocsInstallFact(
          label: 'Version',
          value: '0.0.1',
          description:
              'Tracks the package version; there is no registry schema '
              'version; the shipped manifest installs it.',
        ),
        DocsInstallFact(
          label: 'Platforms',
          value: 'Android, iOS, Web, macOS, Windows, Linux',
          description:
              'A pure Flutter widget tree: no platform channel and no '
              'platform-specific branch anywhere in the component.',
        ),
      ],
    ),
  );
}

/// shadcn's Usage section: the smallest correct construction. Every example
/// below only changes named arguments on top of this.
class _UsageSection extends StatelessWidget {
  const _UsageSection();

  @override
  Widget build(BuildContext context) {
    return ElSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct example. ElToggle never holds its own '
          'state: pressed comes in, onChanged goes out.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ElPanel(
            label: 'DART',
            note: 'SMALLEST CORRECT EXAMPLE',
            child: DocsSelectableCodeBlock(code: _smallestUsageCode),
          ),
          SizedBox(height: el(5)),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: ElWidths.prose),
            child: ElText(
              'onChanged is always called with !pressed, because a toggle '
              'has exactly one other state. The control is fully governed '
              'by the caller: it holds no internal value, so nothing '
              'changes on screen until the state you pass back in changes. '
              'For a mutually exclusive row of options, where selecting one '
              'must clear the rest, reach for ElToggleGroup instead: it has '
              'its own page.',
              ElType.small,
              color: ElTheme.of(context).mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

const String _smallestUsageCode = '''bool bold = false;

ElToggle(
  pressed: bold,
  label: 'Bold',
  onChanged: (bool next) => setState(() => bold = next),
  child: const Text('B'),
)''';

/// shadcn's Outline example: ElToggleVariant.outline adds a 1px theme.input
/// border on top of the same fill and ink standard already paints.
class _OutlineSection extends StatelessWidget {
  const _OutlineSection();

  @override
  Widget build(BuildContext context) => const ElSection(
    id: 'outline',
    title: 'Outline',
    description:
        'variant: ElToggleVariant.outline adds a 1px theme.input border; '
        'the fill and ink stay the same as standard.',
    child: DocsCodeExample(
      title: 'Outline variant',
      preview: _OutlinePreview(),
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(path: 'outline_example.dart', code: _outlineCode),
      ],
    ),
  );
}

class _OutlinePreview extends StatefulWidget {
  const _OutlinePreview();

  @override
  State<_OutlinePreview> createState() => _OutlinePreviewState();
}

class _OutlinePreviewState extends State<_OutlinePreview> {
  bool _bold = false;
  bool _italic = false;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      ElToggle(
        key: const ValueKey<String>('toggle-outline-bold-specimen'),
        variant: ElToggleVariant.outline,
        pressed: _bold,
        label: 'Bold',
        onChanged: (bool next) => setState(() => _bold = next),
        child: const Text('B'),
      ),
      SizedBox(width: ElToggle.gap),
      ElToggle(
        variant: ElToggleVariant.outline,
        pressed: _italic,
        label: 'Italic',
        onChanged: (bool next) => setState(() => _italic = next),
        child: const Text('I'),
      ),
    ],
  );
}

const String _outlineCode = '''ElToggle(
  variant: ElToggleVariant.outline,
  pressed: bold,
  label: 'Bold',
  onChanged: (bool next) => setState(() => bold = next),
  child: const Text('B'),
)''';

/// shadcn's With Text example: child accepts any widget, so an icon and a
/// label can share one Row, spaced by ElToggle.gap.
class _WithTextSection extends StatelessWidget {
  const _WithTextSection();

  @override
  Widget build(BuildContext context) => const ElSection(
    id: 'with-text',
    title: 'With text',
    description:
        'A toggle is not limited to a bare icon: child accepts any widget, '
        'so an icon and a label can share one Row, spaced by ElToggle.gap.',
    child: DocsCodeExample(
      title: 'Icon and label',
      preview: _WithTextPreview(),
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(path: 'with_text_example.dart', code: _withTextCode),
      ],
    ),
  );
}

class _WithTextPreview extends StatefulWidget {
  const _WithTextPreview();

  @override
  State<_WithTextPreview> createState() => _WithTextPreviewState();
}

class _WithTextPreviewState extends State<_WithTextPreview> {
  bool _favorite = false;

  @override
  Widget build(BuildContext context) => ElToggle(
    key: const ValueKey<String>('toggle-with-text-specimen'),
    pressed: _favorite,
    onChanged: (bool next) => setState(() => _favorite = next),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ElIcon(ElIconGlyph.heart, size: ElToggle.iconSizeFor(ElToggleSize.md)),
        SizedBox(width: ElToggle.gap),
        const Text('Favorite'),
      ],
    ),
  );
}

const String _withTextCode = '''ElToggle(
  pressed: favorite,
  onChanged: (bool next) => setState(() => favorite = next),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      ElIcon(ElIconGlyph.heart, size: ElToggle.iconSizeFor(ElToggleSize.md)),
      SizedBox(width: ElToggle.gap),
      const Text('Favorite'),
    ],
  ),
)''';

/// Not on the counterpart page, added in its per-example style: the question
/// a reader arrives with now that ElToggleGroup has its own page. Two
/// ElToggles, not a ElToggleGroup, because Bold and Italic can both be on,
/// both be off, or any mix.
class _IndependentSection extends StatelessWidget {
  const _IndependentSection();

  @override
  Widget build(BuildContext context) {
    return const ElSection(
      id: 'independent',
      title: 'Independent toggles',
      description:
          'Two ElToggles, not a ElToggleGroup: Bold and Italic can both be '
          'on, both be off, or any mix. There is no mutual exclusivity '
          'between them, so a group (which always has at most one '
          'selection) would be the wrong tool.',
      child: ElPanel(
        label: 'DART',
        note: 'INDEPENDENT TOOLBAR TOGGLES',
        child: DocsSelectableCodeBlock(code: _toolbarCode),
      ),
    );
  }
}

const String _toolbarCode = '''bool bold = false;
bool italic = false;

Row(
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    ElToggle(
      pressed: bold,
      label: 'Bold',
      onChanged: (bool next) => setState(() => bold = next),
      child: const Text('B'),
    ),
    SizedBox(width: ElToggle.gap),
    ElToggle(
      pressed: italic,
      label: 'Italic',
      onChanged: (bool next) => setState(() => italic = next),
      child: const Text('I'),
    ),
  ],
)''';

/// shadcn's Size example, generalized: two variants times three sizes, all
/// six combinations real and tappable, unlike ElCheckbox's fixed geometry.
class _SizesSection extends StatelessWidget {
  const _SizesSection();

  @override
  Widget build(BuildContext context) => const ElSection(
    id: 'sizes',
    title: 'Sizes',
    description:
        'Three rungs, and each one changes height, minimum width, corner '
        'radius, and the icon rung a child ElIcon should render at. Two '
        'variants times three sizes: all six combinations are real and '
        'tappable below.',
    child: _ToggleSizeVariantGrid(),
  );
}

class _ToggleSizeVariantGrid extends StatefulWidget {
  const _ToggleSizeVariantGrid();

  @override
  State<_ToggleSizeVariantGrid> createState() => _ToggleSizeVariantGridState();
}

class _ToggleSizeVariantGridState extends State<_ToggleSizeVariantGrid> {
  static const List<ElToggleVariant> _variants = <ElToggleVariant>[
    ElToggleVariant.standard,
    ElToggleVariant.outline,
  ];
  static const List<ElToggleSize> _sizes = <ElToggleSize>[
    ElToggleSize.sm,
    ElToggleSize.md,
    ElToggleSize.lg,
  ];

  final List<bool> _pressed = List<bool>.filled(
    _variants.length * _sizes.length,
    false,
  );

  @override
  Widget build(BuildContext context) {
    final List<Widget> cells = <Widget>[];
    int index = 0;
    for (final ElToggleVariant variant in _variants) {
      for (final ElToggleSize size in _sizes) {
        final int cellIndex = index;
        cells.add(
          ElStateCell(
            label: '${variant.name} · ${size.name}',
            note: 'Tap to toggle',
            child: ElToggle(
              key: ValueKey<String>(
                'toggle-sizes-${variant.name}-${size.name}-specimen',
              ),
              variant: variant,
              size: size,
              pressed: _pressed[cellIndex],
              label: 'Favorite',
              onChanged: (bool next) =>
                  setState(() => _pressed[cellIndex] = next),
              child: ElIcon(
                ElIconGlyph.heart,
                size: ElToggle.iconSizeFor(size),
              ),
            ),
          ),
        );
        index++;
      }
    }
    return Wrap(spacing: el(3), runSpacing: el(3), children: cells);
  }
}

/// shadcn's Disabled example: two disabled toggle states, on and off, both
/// shown so the reader sees the dimmed treatment applies to either value.
class _DisabledSection extends StatelessWidget {
  const _DisabledSection();

  @override
  Widget build(BuildContext context) => const ElSection(
    id: 'disabled',
    title: 'Disabled',
    description:
        'A null onChanged dims the control to 50% opacity and removes it '
        'from hit-testing and the tab order, independent of pressed. There '
        'is no separate enabled flag.',
    child: DocsCodeExample(
      title: 'Disabled',
      preview: _DisabledPreview(),
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(path: 'disabled_example.dart', code: _disabledCode),
      ],
    ),
  );
}

class _DisabledPreview extends StatelessWidget {
  const _DisabledPreview();

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const ElToggle(
        key: ValueKey<String>('toggle-disabled-off-specimen'),
        pressed: false,
        label: 'Bold',
        child: Text('B'),
      ),
      SizedBox(width: ElToggle.gap),
      const ElToggle(
        key: ValueKey<String>('toggle-disabled-on-specimen'),
        pressed: true,
        label: 'Bold',
        child: Text('B'),
      ),
    ],
  );
}

const String _disabledCode =
    '''ElToggle(pressed: false, label: 'Bold', child: const Text('B'))

ElToggle(pressed: true, label: 'Bold', child: const Text('B'))''';

/// shadcn's RTL example. ElToggle paints no direction-dependent geometry of
/// its own (EdgeInsets.symmetric, Center), so the same composition reads
/// correctly under Directionality.rtl with no extra wiring: a real, tappable
/// demonstration, not a documented gap.
class _RtlSection extends StatelessWidget {
  const _RtlSection();

  @override
  Widget build(BuildContext context) => const ElSection(
    id: 'rtl',
    title: 'RTL',
    description:
        'ElToggle paints no direction-dependent geometry of its own, so '
        'the same composition reads correctly under Directionality.rtl '
        'with no extra wiring.',
    child: DocsCodeExample(
      title: 'RTL',
      preview: _RtlPreview(),
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(path: 'rtl_example.dart', code: _rtlCode),
      ],
    ),
  );
}

class _RtlPreview extends StatefulWidget {
  const _RtlPreview();

  @override
  State<_RtlPreview> createState() => _RtlPreviewState();
}

class _RtlPreviewState extends State<_RtlPreview> {
  bool _bold = false;

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: ElToggle(
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
  child: ElToggle(
    pressed: bold,
    label: 'غامق',
    onChanged: (bool next) => setState(() => bold = next),
    child: const Text('غامق'),
  ),
)''';

/// shadcn's own API Reference just links out to Base UI's docs; ours renders
/// real prop tables, an addition their page does not have. One table per
/// class or enum `toggle.dart` declares, plus one for the static helpers
/// callers actually reach for. Nothing from `toggle_group.dart` appears here:
/// `ElToggleGroup` and `ElToggleGroupItem` have their own page and their own
/// tables, built from their own constructors.
class _ApiSection extends StatelessWidget {
  const _ApiSection();

  @override
  Widget build(BuildContext context) => ElSection(
    id: 'api',
    title: 'API Reference',
    description:
        'Every constructor parameter ElToggle declares, its six static '
        'helpers, and both enums it owns: one table each, read off '
        'lib/src/components/toggle.dart.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        KeyedSubtree(
          key: docsAnchorKey('api-eltoggle'),
          child: const DocsApiTable(title: 'ElToggle', facts: _toggleApiFacts),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-eltoggle-static'),
          child: const DocsApiTable(
            title: 'ElToggle static helpers',
            facts: _toggleStaticFacts,
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-eltoggle-variant'),
          child: const DocsApiTable(
            title: 'ElToggleVariant',
            facts: _variantFacts,
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-eltoggle-size'),
          child: const DocsApiTable(title: 'ElToggleSize', facts: _sizeFacts),
        ),
      ],
    ),
  );
}

const List<DocsApiFact> _toggleApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description:
        'Required. The content: a label, an icon, or a row of both spaced '
        'by ElToggle.gap. This widget installs the resolved text style as a '
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
    type: 'ElToggleVariant',
    description:
        'Optional. Defaults to ElToggleVariant.standard (no border box at '
        'all). See the ElToggleVariant table below.',
  ),
  DocsApiFact(
    name: 'size',
    type: 'ElToggleSize',
    description:
        'Optional. Defaults to ElToggleSize.md. Selects height, minimum '
        'width, corner radius, and the icon rung a child should render at. '
        'See the ElToggleSize table below.',
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
        'ElToggleGroup alone, which overrides it to a transparent fill so '
        'its travelling pill shows through.',
  ),
  DocsApiFact(
    name: 'pressedInk',
    type: 'Color?',
    description:
        'Optional. Defaults to null, which keeps the inherited '
        'theme.foreground. The ink painted while pressed is true. '
        'ElToggleGroup overrides it to theme.primaryForeground for the '
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
        'ElToggleGroup sets it for every item it builds.',
  ),
];

const List<DocsApiFact> _toggleStaticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ElToggle.heightFor(size)',
    type: 'static double',
    description: "The rung's fixed height: 28 / 32 / 36 for sm / md / lg.",
  ),
  DocsApiFact(
    name: 'ElToggle.minWidthFor(size)',
    type: 'static double',
    description:
        'The same 28 / 32 / 36 floor, so an icon-only toggle does not '
        'collapse onto its glyph.',
  ),
  DocsApiFact(
    name: 'ElToggle.paddingX',
    type: 'static double',
    description:
        'A getter, not a per-size function: the same 10px of horizontal '
        'padding on every rung.',
  ),
  DocsApiFact(
    name: 'ElToggle.gap',
    type: 'static double',
    description:
        'A getter too: 4px between an icon and a label, when a caller '
        'composes both into one child Row. Exposed, not applied.',
  ),
  DocsApiFact(
    name: 'ElToggle.radiusFor(size)',
    type: 'static double',
    description:
        "The rung's corner: ElRadii.lg (12px) on md and lg, and exactly "
        'ElRadii.md (10px) on sm, which the source writes as '
        'math.min(ElRadii.md, ElRadii.lg). Never a pill: only '
        "ElToggleGroup's own travelling pill is a stadium.",
  ),
  DocsApiFact(
    name: 'ElToggle.iconSizeFor(size)',
    type: 'static ElIconSize',
    description:
        'The icon rung a child ElIcon should render at to match this '
        "control's size: ElIconSize.sm on ElToggleSize.sm, ElIconSize.md "
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
    type: '28px · ElRadii.md',
    description:
        'The dense rung, and the only one that steps its icon child down '
        'to ElIconSize.sm.',
  ),
  DocsApiFact(
    name: 'md',
    type: '32px · ElRadii.lg',
    description: 'The constructor default.',
  ),
  DocsApiFact(
    name: 'lg',
    type: '36px · ElRadii.lg',
    description:
        'Taller and wider, but the same corner and the same ElIconSize.md '
        'child as md.',
  ),
];

/// Rest, Hover, Selected, Focus-visible, Disabled and Reduced motion.
/// Pressed, Loading, Empty, Error and Success are addressed in prose below
/// the table rather than invented as rows.
class _StatesSection extends StatelessWidget {
  const _StatesSection();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return ElSection(
      id: 'states',
      title: 'States',
      description:
          'Read straight off _DsToggleState._skin and _DsToggleState.build. '
          'Pressed, Loading, Empty, Error and Success are omitted: reasons '
          'follow the table.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const DocsStateMatrix(
            facts: <DocsStateFact>[
              DocsStateFact(
                state: 'Rest',
                treatment:
                    'standard: no fill, no border. outline: a 1px '
                    'theme.input border. Ink is theme.foreground either '
                    'way: hover:text-foreground in the reference restates '
                    'a colour the element already has and changes nothing.',
                userSignal:
                    'An unfilled control, distinguishable from Selected '
                    'only once a fill or border tells them apart.',
              ),
              DocsStateFact(
                state: 'Hover',
                treatment:
                    'theme.muted fill, on both variants: the same fill '
                    'Selected paints, so hover and on are visually '
                    'identical on a standalone toggle.',
                userSignal:
                    'A grey wash appears under the pointer; the cursor '
                    'becomes a click cursor.',
              ),
              DocsStateFact(
                state: 'Selected (on)',
                treatment:
                    'theme.muted fill (the class hover also paints), '
                    'theme.foreground ink. Unlike ElSwitch and ElCheckbox, '
                    'the on-state is not the brand colour here. '
                    'pressedFill and pressedInk are the two hooks that '
                    'change that, and ElToggleGroup is the one caller in '
                    'the corpus that uses them.',
                userSignal:
                    'A filled control that stays filled after the pointer '
                    'leaves: the only way Rest and Selected are told apart.',
              ),
              DocsStateFact(
                state: 'Focus-visible',
                treatment:
                    'A ring at theme.ring, 50% alpha, faded up from fully '
                    'transparent on the same clock as the colour legs. On '
                    'outline the border also swaps to theme.ring; on '
                    'standard there is no border box to colour, so only '
                    'the ring paints.',
                userSignal:
                    'A ring that appears only after keyboard focus: a '
                    'bare pointer tap does not request focus, so a '
                    'tapped-and-released toggle shows no ring.',
              ),
              DocsStateFact(
                state: 'Disabled',
                treatment:
                    'onChanged: null, 50% opacity, and an IgnorePointer '
                    'that removes the control from hit-testing and hover '
                    'tracking together, and from the tab order.',
                userSignal:
                    'Dimmed and inert: the one state that visibly dims, '
                    "matching ElButton's own disabled treatment.",
              ),
              DocsStateFact(
                state: 'Reduced motion',
                treatment:
                    'The fill/ink/border/ring tween chain resolves through '
                    'elAnimationDuration, which reduced motion shortens '
                    'toward zero.',
                userSignal:
                    'State changes land on their finished colours '
                    'immediately, with no transition to sit through.',
              ),
            ],
          ),
          SizedBox(height: el(3)),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: ElWidths.prose),
            child: ElText(
              'Pressed is not a row: the class list carries no active-'
              'state rule and no press-motion utility, a toggle does '
              'nothing at all between pointer-down and pointer-up, unlike '
              "ElButton's spring squash (a documented drift in "
              "toggle.dart's own header). Loading and Empty are not rows "
              'either: this is a synchronous primitive with no async '
              'operation and nothing to list. Error is not a row: '
              'aria-invalid is never set on this control anywhere in the '
              'reference, and ElToggle exposes no invalid parameter at '
              'all. Success is not a row: the component defines no success '
              'semantics of its own.',
              ElType.small,
              color: theme.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

/// Semantic role, label association, keyboard, focus, touch target,
/// non-colour signal and error wiring.
class _AccessibilitySection extends StatelessWidget {
  const _AccessibilitySection();

  @override
  Widget build(BuildContext context) => const ElSection(
    id: 'accessibility',
    title: 'Accessibility',
    child: DocsInstallFacts(
      title: 'Accessibility',
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'Semantic role',
          value: 'Semantics(button:, toggled:/selected:)',
          description:
              'A standalone toggle (inExclusiveGroup: false, the default) '
              'exposes toggled: pressed. Set inExclusiveGroup: true and it '
              'exposes selected: pressed and inMutuallyExclusiveGroup: '
              'true instead, with toggled left null: a choice among '
              'others, not an independent on/off switch. ElToggleGroup is '
              'what sets it in practice.',
        ),
        DocsInstallFact(
          label: 'Label association',
          value: 'label',
          description:
              "Overrides, rather than adds to, the child's own "
              'content-derived name (excludeSemantics: true whenever label '
              'is set). Required for an icon-only toggle to have any '
              'accessible name.',
        ),
        DocsInstallFact(
          label: 'Keyboard activation',
          value: 'Enter, numpad Enter, Space',
          description:
              'Hand-wired through Focus.onKeyEvent, the same wiring '
              'ElButton and ElCheckbox use: the control is not a native '
              'button, so nothing arrives for free.',
        ),
        DocsInstallFact(
          label: 'Focus behavior',
          value: 'A ring at theme.ring, 50% alpha: keyboard-only',
          description:
              'focus-visible, not focus. Flutter does not move focus on a '
              'bare pointer tap, so hasFocus here already is the '
              'keyboard-only predicate CSS means; a tapped-and-released '
              'toggle never shows the ring.',
        ),
        DocsInstallFact(
          label: 'Touch target',
          value: 'Exactly the visual box: no cushion',
          description:
              '28x28 / 32x32 / 36x36 depending on size. Unlike '
              "ElCheckbox's ElHitArea, ElToggle wraps its GestureDetector "
              'directly around the sized box with no extra hit-test '
              "padding. Every size sits below the system's 44px "
              'touch-target floor: recorded rather than corrected, because '
              'it is what the source renders.',
        ),
        DocsInstallFact(
          label: 'Non-colour signal',
          value: 'The toggled/selected semantics flag itself',
          description:
              'Visually, the only change between Rest and Selected is a '
              'fill colour; a sighted user who cannot rely on that has no '
              "drawn glyph to fall back on the way ElCheckbox's tick "
              'provides. A screen reader is told regardless, through the '
              'toggled or selected flag.',
        ),
        DocsInstallFact(
          label: 'Error wiring',
          value: 'N/A: no invalid parameter exists',
          description:
              'ElToggle declares no invalid/aria-invalid path; the source '
              'states aria-invalid is never set on this control anywhere '
              'in the reference. There is nothing to wire.',
        ),
        DocsInstallFact(
          label: 'Screen-reader announcements',
          value: 'No live region',
          description:
              'State changes are exposed purely through the semantics '
              'flags above; no extra announcement is authored.',
        ),
      ],
    ),
  );
}

/// Layout, breakpoints, and platform behavior.
class _ResponsiveSection extends StatelessWidget {
  const _ResponsiveSection();

  @override
  Widget build(BuildContext context) => ElSection(
    id: 'responsive',
    title: 'Responsive',
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: ElWidths.prose),
      child: ElText(
        'ElToggle has no breakpoints of its own: it is a fixed-size atomic '
        'control (28 / 32 / 36px tall, and at least that wide), and '
        'nothing in toggle.dart reads a viewport width to decide '
        'anything. What changes with layout belongs to whatever composes '
        'it: a toolbar of several toggles is the caller\'s own Row or '
        'Wrap, and a Row of them needs the caller\'s own wrapping or '
        'scrolling at a narrow viewport, because the control adds none. A '
        'long text child is not truncated or ellipsised either: '
        'whitespace-nowrap is what the class list carries, so the child '
        'overflows rather than wrapping. '
        'Keyboard activation and pointer activation behave identically on '
        'every Flutter target this package supports; there is no platform '
        'channel and nothing here is web-only or desktop-only.',
        ElType.small,
      ),
    ),
  );
}

/// The real source-level files, imports, assets, fonts and shaders this
/// component pulls in.
class _DependenciesSection extends StatelessWidget {
  const _DependenciesSection();

  @override
  Widget build(BuildContext context) => ElSection(
    id: 'dependencies',
    title: 'Dependencies',
    child: DocsInstallFacts(
      title: 'Dependencies and files',
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'Source file',
          value: toggleDoc.sourcePath,
          description:
              'The authoritative implementation: one file, no companions.',
        ),
        const DocsInstallFact(
          label: 'Flutter imports',
          value:
              'dart:math (math.min), package:flutter/services.dart '
              '(LogicalKeyboardKey, KeyEvent), package:flutter/widgets.dart',
          description:
              'math.min is used by radiusFor alone; services.dart supplies '
              'the key constants the Enter/Space wiring compares against.',
        ),
        const DocsInstallFact(
          label: 'Local file dependencies',
          value: 'button.dart, icon.dart, effects/machine_surface.dart',
          description:
              'toggle.dart imports button.dart for ElButton.withFocusRing, '
              'icon.dart for the ElIconSize return type of iconSizeFor, '
              'and effects/machine_surface.dart for ElMachineSurface. It '
              'does NOT import motion/sliding_pill.dart: the travelling '
              'pill belongs to ElToggleGroup, on its own page. None of '
              'these are copyable in isolation: see Installation.',
        ),
        const DocsInstallFact(
          label: 'Foundation dependencies',
          value:
              'foundation/colors.dart, foundation/motion.dart, '
              'foundation/shadows.dart, foundation/spacing.dart, '
              'foundation/theme.dart, foundation/typography.dart, '
              'theme_scope.dart',
          description:
              'Token sources: the transparent-colour constant, durations '
              'and curves, shadow specs, the el() spacing scale and '
              'ElRadii, the live theme, and the resolved toggle-label text '
              'style.',
        ),
        DocsInstallFact(
          label: 'Exports',
          value: toggleDoc.exports.join(', '),
          description:
              'The public symbols this component makes available. '
              'ElToggleGroup and ElToggleGroupItem are a separate export, '
              'documented on their own page.',
        ),
        const DocsInstallFact(
          label: 'Assets',
          value: 'none',
          description:
              'Fills, borders and the focus ring are plain box '
              'decoration: no image and no icon-font glyph of its own. An '
              'icon child, if one is composed in, brings its own geometry '
              'from icon_paths.dart, not an asset file.',
        ),
        const DocsInstallFact(
          label: 'Fonts',
          value: 'none',
          description:
              'The component renders no text of its own; a text child '
              "inherits the DefaultTextStyle it installs, which resolves "
              "off the app's own type scale.",
        ),
        const DocsInstallFact(
          label: 'Shaders',
          value: 'none',
          description: 'No fragment shader is used by this file.',
        ),
      ],
    ),
  );
}

/// How colour and motion resolve.
class _ThemingSection extends StatelessWidget {
  const _ThemingSection();

  @override
  Widget build(BuildContext context) => const ElSection(
    id: 'theming',
    title: 'Theming',
    child: DocsInstallFacts(
      title: 'Tokens this component reads',
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'Fill',
          value: 'transparent (rest) / theme.muted (hover and on)',
          description:
              "The control's own background. pressedFill replaces the "
              'on-fill when a caller supplies one.',
        ),
        DocsInstallFact(
          label: 'Border',
          value:
              'theme.input (outline, rest) / theme.ring (outline, '
              'focus-visible)',
          description:
              'Only painted on ElToggleVariant.outline: standard has no '
              'border box at all.',
        ),
        DocsInstallFact(
          label: 'Ink',
          value: 'theme.foreground (rest and on)',
          description:
              "The child's resolved text/icon colour. pressedInk replaces "
              'it while pressed when a caller supplies one.',
        ),
        DocsInstallFact(
          label: 'Ring',
          value: 'theme.ring at 50% alpha',
          description:
              'The focus-visible ring, composited in front of the surface '
              'through ElButton.withFocusRing, the shared helper ElInput '
              'reaches for too.',
        ),
        DocsInstallFact(
          label: 'Radius',
          value: 'ElRadii.lg on md and lg / ElRadii.md on sm',
          description:
              'math.min(ElRadii.md, ElRadii.lg) on sm, which resolves to '
              'ElRadii.md exactly. Never ElRadii.pill: this control is a '
              'rounded rect at every size.',
        ),
        DocsInstallFact(
          label: 'Shadow',
          value: 'ElShadows.none, plus the focus ring',
          description:
              'The surface carries no resting elevation. The only thing '
              'ElMachineSurface ever paints here is the focus-visible '
              'ring, faded up from a fully transparent copy of itself so '
              'the layer counts match and the colour can interpolate.',
        ),
        DocsInstallFact(
          label: 'Motion',
          value: 'ElDurations.transitionDefault, ElCurves.out',
          description:
              'The fill/ink/border/ring tween chain, resolved through '
              'elAnimationDuration, so reduced motion shortens or removes '
              'it automatically. There is no press animation to reduce: '
              'the class list declares none.',
        ),
      ],
    ),
  );
}

/// Source, package tests, and this page's own docs test.
class _SourceSection extends StatelessWidget {
  const _SourceSection();

  @override
  Widget build(BuildContext context) => ElSection(
    id: 'source',
    title: 'Source',
    child: DocsInstallFacts(
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'Source',
          value: toggleDoc.sourcePath,
          description:
              'Authoritative implementation of ElToggle, ElToggleVariant '
              'and ElToggleSize: the truth this page was written from.',
        ),
        const DocsInstallFact(
          label: 'Package tests',
          value: 'test/components_test.dart',
          description:
              'The ElToggle group within that file covers geometry, '
              'statics and state behaviour in the package itself; there is '
              'no dedicated toggle_test.dart in the package yet.',
        ),
        const DocsInstallFact(
          label: 'Docs test',
          value: 'example/test/components_docs/toggle_test.dart',
          description:
              'Covers this page: the section order, API completeness for '
              'ElToggle and both its enums, every live specimen, and both '
              'themes at two viewport widths.',
        ),
        const DocsInstallFact(
          label: 'Edit these docs',
          value: 'example/lib/components_docs/toggle/page.dart',
          description: 'This file.',
        ),
        const DocsInstallFact(
          label: 'Related',
          value: 'example/lib/components_docs/toggle_group/page.dart',
          description:
              'ElToggleGroup and ElToggleGroupItem: the mutually exclusive '
              'segmented control built from this component, and the only '
              'caller of pressedFill and pressedInk in the corpus.',
        ),
      ],
    ),
  );
}

class _Anchor extends StatelessWidget {
  const _Anchor(this.name, {required this.child});

  final String name;
  final Widget child;

  @override
  // The key the table of contents and the mobile anchor strip look this
  // section up by: used only for the un-headed hero demo above, every other
  // section gets its anchor from ElSection itself.
  Widget build(BuildContext context) =>
      KeyedSubtree(key: docsAnchorKey(name), child: child);
}
