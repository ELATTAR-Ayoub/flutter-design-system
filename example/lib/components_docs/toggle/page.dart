/// Public component documentation for the toggle and toggle-group
/// components, reshaped to shadcn parity (`components_docs/switch/page.dart`
/// is the structural reference: a live demo before any heading, then
/// Installation, Usage, one top-level section per shadcn example, API
/// Reference, and finally the six sections shadcn does not carry).
///
/// One page, not two: `toggle_group.dart`'s own library doc states the
/// reason, a `ToggleGroupItem` **is** a [DsToggle] underneath
/// (`toggleVariants(...)` plus two trailing overrides), so the group's
/// semantics only make sense read alongside the item's.
///
/// This page covers TWO shadcn counterparts,
/// https://ui.shadcn.com/docs/components/base/toggle and
/// https://ui.shadcn.com/docs/components/base/toggle-group, merged section
/// by section: Installation and Usage are shared (both components install
/// and construct the same way), then every component-specific shadcn
/// section is kept, one heading per section, grouped under its own
/// component name so the two families never interleave: `Toggle: …` for
/// six of DsToggle's own examples, `Toggle group: …` for six of
/// DsToggleGroup's. Three shadcn sections are skipped rather than faked:
/// `Toggle group: Spacing` and `Toggle group: Vertical` name two root props
/// (`spacing`, `orientation`) `toggle_group.dart`'s own header documents as
/// not ported; `Changelog` (present on both counterpart pages) has no
/// analogue here, this package ships from source, not a versioned registry
/// entry with its own release notes.
///
/// `RTL` is NOT skipped for either component, unlike `switch/page.dart`'s
/// own `DsSwitch`: neither `DsToggle` nor `DsToggleGroup` paints anything
/// with `Positioned.left` or another direction-dependent absolute offset.
/// `EdgeInsets.symmetric`, `Center`, and `DsSlidingPillGroup`'s own
/// measure-each-child placement all mirror correctly under
/// `Directionality.rtl` with no extra wiring, so both `Toggle: RTL` and
/// `Toggle group: RTL` below are real, tappable demonstrations.
///
/// `toggleDoc` (from `meta.dart`) is the data source, not
/// `componentDoc('toggle')`: toggle is not yet registered in
/// `catalog.dart`'s `componentDocs` list, so calling that would throw. Adding
/// it there is a supervisor-owned aggregation step (Phase J plan).
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
      breadcrumbs: const <DsBreadcrumbEntry>[
        DsBreadcrumbEntry.link('Components'),
        DsBreadcrumbEntry.page('Toggle'),
      ],
      // No entry for the hero demo: it renders before any heading, exactly
      // as shadcn's own "Bookmark" (toggle) and "Bold/Italic/Underline"
      // (toggle-group) demos are not themselves a stop on either
      // reference's on-this-page nav.
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Installation', anchor: 'install'),
        DocsTocEntry(title: 'Usage', anchor: 'usage'),
        DocsTocEntry(title: 'Toggle: Outline', anchor: 'toggle-outline'),
        DocsTocEntry(
          title: 'Toggle: With text',
          anchor: 'toggle-with-text',
        ),
        DocsTocEntry(
          title: 'Toggle: Independent toggles',
          anchor: 'toggle-independent',
        ),
        DocsTocEntry(title: 'Toggle: Sizes', anchor: 'toggle-sizes'),
        DocsTocEntry(title: 'Toggle: Disabled', anchor: 'toggle-disabled'),
        DocsTocEntry(title: 'Toggle: RTL', anchor: 'toggle-rtl'),
        DocsTocEntry(
          title: 'Toggle group: Composition',
          anchor: 'toggle-group-composition',
        ),
        DocsTocEntry(
          title: 'Toggle group: Outline',
          anchor: 'toggle-group-outline',
        ),
        DocsTocEntry(
          title: 'Toggle group: Sizes',
          anchor: 'toggle-group-sizes',
        ),
        DocsTocEntry(
          title: 'Toggle group: Disabled',
          anchor: 'toggle-group-disabled',
        ),
        DocsTocEntry(
          title: 'Toggle group: Custom',
          anchor: 'toggle-group-custom',
        ),
        DocsTocEntry(
          title: 'Toggle group: RTL',
          anchor: 'toggle-group-rtl',
        ),
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
        title: 'Switch',
        route: '/components/switch',
      ),
      next: const DocsPageLink(title: 'Tooltip', route: '/components/tooltip'),
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
      _heroExpansion(),
      SizedBox(height: ds(6)),
      _Anchor('preview', child: const _PreviewSection()),
      SizedBox(height: ds(8)),
      const _InstallSection(),
      SizedBox(height: ds(2)),
      const _UsageSection(),
      SizedBox(height: ds(2)),
      const _ToggleOutlineSection(),
      SizedBox(height: ds(2)),
      const _ToggleWithTextSection(),
      SizedBox(height: ds(2)),
      const _ToggleIndependentSection(),
      SizedBox(height: ds(2)),
      const _ToggleSizesSection(),
      SizedBox(height: ds(2)),
      const _ToggleDisabledSection(),
      SizedBox(height: ds(2)),
      const _ToggleRtlSection(),
      SizedBox(height: ds(2)),
      const _ToggleGroupCompositionSection(),
      SizedBox(height: ds(2)),
      const _ToggleGroupOutlineSection(),
      SizedBox(height: ds(2)),
      const _ToggleGroupSizesSection(),
      SizedBox(height: ds(2)),
      const _ToggleGroupDisabledSection(),
      SizedBox(height: ds(2)),
      const _ToggleGroupCustomSection(),
      SizedBox(height: ds(2)),
      const _ToggleGroupRtlSection(),
      SizedBox(height: ds(2)),
      const _ApiSection(),
      SizedBox(height: ds(2)),
      const _StatesSection(),
      SizedBox(height: ds(2)),
      const _AccessibilitySection(),
      SizedBox(height: ds(2)),
      const _ResponsiveSection(),
      SizedBox(height: ds(2)),
      const _DependenciesSection(),
      SizedBox(height: ds(2)),
      const _ThemingSection(),
      SizedBox(height: ds(2)),
      const _SourceSection(),
    ],
  );
}

/// IA §9.2's expanded "when to use a toggle" description: plain hero prose
/// above the fold, not a [DsSection], so it carries no heading and no TOC
/// anchor of its own, the same as `switch/page.dart`'s own
/// `_heroExpansion()`.
Widget _heroExpansion() => ConstrainedBox(
  constraints: const BoxConstraints(maxWidth: DsWidths.prose),
  child: DsText(toggleExpandedDescription, DsType.body),
);

/// The shadcn pages' own un-headed hero demos, combined: five standalone
/// [DsToggle] specimens, then a live [DsToggleGroup].
class _PreviewSection extends StatelessWidget {
  const _PreviewSection();

  @override
  Widget build(BuildContext context) => const DocsCodeExample(
    title: 'Toggle and toggle-group specimens',
    description:
        'Rest, Selected, Outline variant and Focus-visible are operable: '
        'tap or Tab to them. Disabled is deliberately inert. The group '
        'specimen states its own selectedIndex live, including the moment '
        'it becomes null.',
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
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Wrap(
          spacing: ds(3),
          runSpacing: ds(3),
          children: <Widget>[
            DsStateCell(
              label: 'Rest',
              note: 'Tap to toggle',
              child: DsToggle(
                key: const ValueKey<String>('toggle-live-specimen'),
                pressed: _rest,
                label: 'Favorite',
                onChanged: (bool next) => setState(() => _rest = next),
                child: DsIcon(
                  DsIconGlyph.heart,
                  size: DsToggle.iconSizeFor(DsToggleSize.md),
                ),
              ),
            ),
            DsStateCell(
              label: 'Selected (on)',
              note: 'Tap to toggle',
              child: DsToggle(
                pressed: _selected,
                label: 'Favorite',
                onChanged: (bool next) => setState(() => _selected = next),
                child: DsIcon(
                  DsIconGlyph.heart,
                  size: DsToggle.iconSizeFor(DsToggleSize.md),
                ),
              ),
            ),
            DsStateCell(
              label: 'Outline variant',
              note: 'Tap to toggle',
              child: DsToggle(
                variant: DsToggleVariant.outline,
                pressed: _outline,
                label: 'Bold',
                onChanged: (bool next) => setState(() => _outline = next),
                child: const Text('B'),
              ),
            ),
            const DsStateCell(
              label: 'Focus-visible',
              note: 'Real keyboard focus, not a forced prop',
              child: _ToggleFocusDemo(),
            ),
            DsStateCell(
              label: 'Disabled',
              child: DsToggle(
                pressed: false,
                label: 'Favorite',
                child: DsIcon(
                  DsIconGlyph.heart,
                  size: DsToggle.iconSizeFor(DsToggleSize.md),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        DsText('DsToggleGroup: segmented, single-select', DsType.label),
        SizedBox(height: ds(3)),
        const _ToggleGroupPreview(),
        SizedBox(height: ds(3)),
        DsText(
          'The pill above is theme.primary; the fading of "nothing '
          'selected" is what DsSlidingPillGroup renders whenever '
          'selectedIndex is null.',
          DsType.small,
          color: theme.mutedForeground,
        ),
      ],
    );
  }
}

/// A [DsToggle] that requests real keyboard focus on mount, rather than a
/// forced prop: DsToggle exposes no `forceFocusRing`, so this is what
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
  Widget build(BuildContext context) {
    return DsToggle(
      focusNode: _node,
      pressed: _pressed,
      label: 'Favorite',
      onChanged: (bool next) => setState(() => _pressed = next),
      child: DsIcon(
        DsIconGlyph.heart,
        size: DsToggle.iconSizeFor(DsToggleSize.md),
      ),
    );
  }
}

/// The live [DsToggleGroup] specimen: three sort options, one of which
/// starts selected, and the exact deselect-to-null behaviour the page exists
/// to document.
class _ToggleGroupPreview extends StatefulWidget {
  const _ToggleGroupPreview();

  @override
  State<_ToggleGroupPreview> createState() => _ToggleGroupPreviewState();
}

class _ToggleGroupPreviewState extends State<_ToggleGroupPreview> {
  static const List<String> _labels = <String>['Newest', 'Price', 'Popular'];

  int? _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // DsSlidingPillGroup's Row has no wrap of its own: at a narrow
        // viewport three segments can ask for more width than this column
        // has, the same overflow a multi-segment filter bar runs into. Same
        // fix here.
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DsToggleGroup(
            key: const ValueKey<String>('toggle-group-live-specimen'),
            items: const <DsToggleGroupItem>[
              DsToggleGroupItem(label: 'Newest'),
              DsToggleGroupItem(label: 'Price'),
              DsToggleGroupItem(label: 'Popular'),
            ],
            selectedIndex: _selectedIndex,
            onChanged: (int? next) => setState(() => _selectedIndex = next),
          ),
        ),
        SizedBox(height: ds(3)),
        DsText(
          _selectedIndex == null
              ? 'selectedIndex: null: tap any option to select it.'
              : 'selectedIndex: $_selectedIndex: tap '
                    '"${_labels[_selectedIndex!]}" again to deselect it.',
          DsType.small,
          color: theme.mutedForeground,
        ),
      ],
    );
  }
}

/// shadcn's Installation section: CLI and Manual tabs. toggle and
/// toggle-group have not shipped a registry manifest yet, so `elattar add
/// toggle` will not resolve: the Manual tab is the whole story, and this
/// panel also folds in the old "Status" facts (version, platforms) rather
/// than giving them a heading shadcn has nowhere on either counterpart page.
class _InstallSection extends StatelessWidget {
  const _InstallSection();

  @override
  Widget build(BuildContext context) => const DsSection(
    id: 'install',
    title: 'Installation',
    description:
        'Command install is not available yet: read this before reaching '
        'for elattar add toggle.',
    child: DocsInstallFacts(
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'CLI',
          value: 'Not available',
          description:
              'toggle and toggle-group are not yet registry items, so '
              '`elattar add toggle` will not resolve. They are among the '
              'Wave 1 base components still awaiting a manifest, see the '
              'Phase J documentation plan.',
        ),
        DocsInstallFact(
          label: 'Manual: package mode (supported today)',
          value:
              "import 'package:elattar_design_system/elattar_design_system.dart';",
          description:
              'Depend on the package and use DsToggle and DsToggleGroup '
              'directly, exactly as this page does.',
        ),
        DocsInstallFact(
          label: 'Manual: source mode (not recommended yet)',
          value:
              'lib/src/components/toggle.dart, '
              'lib/src/components/toggle_group.dart',
          description:
              'Copying these two files will not compile on their own: '
              'they need sibling files with them (see Dependencies below), '
              'and no manifest exists yet to resolve them for you.',
        ),
        DocsInstallFact(
          label: 'Status',
          value: 'Stable, not yet a registry item',
          description:
              'Ported and tested against lib/src/components/toggle.dart '
              'and lib/src/components/toggle_group.dart.',
        ),
        DocsInstallFact(
          label: 'Version',
          value: '0.0.1',
          description:
              'Tracks the package version; there is no registry schema '
              'version yet because there is no manifest.',
        ),
        DocsInstallFact(
          label: 'Platforms',
          value: 'Android, iOS, Web, macOS, Windows, Linux',
          description:
              'A pure Flutter widget tree: no platform channel and no '
              'platform-specific branch in either component.',
        ),
      ],
    ),
  );
}

/// shadcn's Usage sections, merged: the smallest correct standalone toggle,
/// then the smallest correct group and its nullable selection, then the two
/// valid ways a caller can handle that null (folded in from the old
/// "Composition examples" wrapper this page no longer carries, per the
/// worker brief's no-Examples-wrapper rule).
class _UsageSection extends StatelessWidget {
  const _UsageSection();

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct standalone example, then the group and its '
          'nullable selection.',
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
            'DsToggleGroup.onChanged is ValueChanged<int?>: tapping an '
            'unselected option calls it with that option\'s index, and '
            'tapping the already-selected option calls it with null. '
            'selectedIndex has to accept both: the group never decides on '
            'its own whether "nothing selected" is a state your UI '
            'allows, it only reports the tap. A live specimen of exactly '
            'this, including the moment selectedIndex becomes null, '
            'follows:',
            DsType.small,
            color: DsTheme.of(context).mutedForeground,
          ),
          SizedBox(height: ds(3)),
          const _SortControlExample(),
          SizedBox(height: ds(3)),
          DsPanel(
            label: 'DART',
            note: 'A NULLABLE GROUP',
            child: DocsSelectableCodeBlock(code: _groupUsageCode),
          ),
          SizedBox(height: ds(5)),
          DsText(
            'DsToggleGroup has no opinion on what null means to your '
            'screen: it only reports it. Two real policies, both valid:',
            DsType.small,
            color: DsTheme.of(context).mutedForeground,
          ),
          SizedBox(height: ds(3)),
          DsPanel(
            label: 'DART',
            note: 'TWO VALID DESELECTION POLICIES',
            child: DocsSelectableCodeBlock(code: _policyCode),
          ),
        ],
      ),
    );
  }
}

const String _smallestUsageCode = '''bool bold = false;

DsToggle(
  pressed: bold,
  label: 'Bold',
  onChanged: (bool next) => setState(() => bold = next),
  child: const Text('B'),
)''';

const String _groupUsageCode = '''int? sortIndex = 0;

DsToggleGroup(
  items: const <DsToggleGroupItem>[
    DsToggleGroupItem(label: 'Newest'),
    DsToggleGroupItem(label: 'Price'),
    DsToggleGroupItem(label: 'Popular'),
  ],
  selectedIndex: sortIndex,
  // Receives the tapped index, or null when the tap re-selected the
  // option that was already active.
  onChanged: (int? next) => setState(() => sortIndex = next),
)''';

const String _policyCode =
    '''// 1. Keep the null: "nothing selected" is a real, distinct state.
onChanged: (int? next) => setState(() => sortIndex = next),

// 2. Coerce it: never let the group end up with nothing selected. A
// family/platform filter bar might make this choice instead:
onFamilyChanged: (int? index) => setState(() => familyIndex = index ?? 0),''';

/// The Usage section's live "sort control": the same nullable contract as
/// [_ToggleGroupPreview], composed a second time with its own state so the
/// section that explains the contract in prose also proves it live.
class _SortControlExample extends StatefulWidget {
  const _SortControlExample();

  @override
  State<_SortControlExample> createState() => _SortControlExampleState();
}

class _SortControlExampleState extends State<_SortControlExample> {
  static const List<String> _labels = <String>['Newest', 'Price', 'Popular'];

  int? _sortIndex = 0;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Same narrow-viewport overflow a multi-segment filter bar guards
        // against: see _ToggleGroupPreview above.
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DsToggleGroup(
            items: const <DsToggleGroupItem>[
              DsToggleGroupItem(label: 'Newest'),
              DsToggleGroupItem(label: 'Price'),
              DsToggleGroupItem(label: 'Popular'),
            ],
            selectedIndex: _sortIndex,
            onChanged: (int? next) => setState(() => _sortIndex = next),
          ),
        ),
        SizedBox(height: ds(2)),
        DsText(
          _sortIndex == null
              ? 'Sorting by: none selected'
              : 'Sorting by: ${_labels[_sortIndex!]}',
          DsType.small,
          color: theme.mutedForeground,
        ),
      ],
    );
  }
}

/// shadcn Toggle's Outline example: DsToggleVariant.outline adds a 1px
/// theme.input border on top of the same fill and ink standard already
/// paints.
class _ToggleOutlineSection extends StatelessWidget {
  const _ToggleOutlineSection();

  @override
  Widget build(BuildContext context) => const DsSection(
    id: 'toggle-outline',
    title: 'Toggle: Outline',
    description:
        'variant: DsToggleVariant.outline adds a 1px theme.input border; '
        'the fill and ink stay the same as standard.',
    child: DocsCodeExample(
      title: 'Outline variant',
      preview: _ToggleOutlinePreview(),
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(path: 'outline_example.dart', code: _toggleOutlineCode),
      ],
    ),
  );
}

class _ToggleOutlinePreview extends StatefulWidget {
  const _ToggleOutlinePreview();

  @override
  State<_ToggleOutlinePreview> createState() => _ToggleOutlinePreviewState();
}

class _ToggleOutlinePreviewState extends State<_ToggleOutlinePreview> {
  bool _bold = false;
  bool _italic = false;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      DsToggle(
        key: const ValueKey<String>('toggle-outline-bold-specimen'),
        variant: DsToggleVariant.outline,
        pressed: _bold,
        label: 'Bold',
        onChanged: (bool next) => setState(() => _bold = next),
        child: const Text('B'),
      ),
      SizedBox(width: DsToggle.gap),
      DsToggle(
        variant: DsToggleVariant.outline,
        pressed: _italic,
        label: 'Italic',
        onChanged: (bool next) => setState(() => _italic = next),
        child: const Text('I'),
      ),
    ],
  );
}

const String _toggleOutlineCode = '''DsToggle(
  variant: DsToggleVariant.outline,
  pressed: bold,
  label: 'Bold',
  onChanged: (bool next) => setState(() => bold = next),
  child: const Text('B'),
)''';

/// shadcn Toggle's With Text example: child accepts any widget, so an icon
/// and a label can share one Row, spaced by DsToggle.gap.
class _ToggleWithTextSection extends StatelessWidget {
  const _ToggleWithTextSection();

  @override
  Widget build(BuildContext context) => const DsSection(
    id: 'toggle-with-text',
    title: 'Toggle: With text',
    description:
        'A toggle is not limited to a bare icon: child accepts any widget, '
        'so an icon and a label can share one Row, spaced by DsToggle.gap.',
    child: DocsCodeExample(
      title: 'Icon and label',
      preview: _ToggleWithTextPreview(),
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'with_text_example.dart',
          code: _toggleWithTextCode,
        ),
      ],
    ),
  );
}

class _ToggleWithTextPreview extends StatefulWidget {
  const _ToggleWithTextPreview();

  @override
  State<_ToggleWithTextPreview> createState() =>
      _ToggleWithTextPreviewState();
}

class _ToggleWithTextPreviewState extends State<_ToggleWithTextPreview> {
  bool _favorite = false;

  @override
  Widget build(BuildContext context) => DsToggle(
    key: const ValueKey<String>('toggle-with-text-specimen'),
    pressed: _favorite,
    onChanged: (bool next) => setState(() => _favorite = next),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DsIcon(
          DsIconGlyph.heart,
          size: DsToggle.iconSizeFor(DsToggleSize.md),
        ),
        SizedBox(width: DsToggle.gap),
        const Text('Favorite'),
      ],
    ),
  );
}

const String _toggleWithTextCode = '''DsToggle(
  pressed: favorite,
  onChanged: (bool next) => setState(() => favorite = next),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      DsIcon(DsIconGlyph.heart, size: DsToggle.iconSizeFor(DsToggleSize.md)),
      SizedBox(width: DsToggle.gap),
      const Text('Favorite'),
    ],
  ),
)''';

/// Ours only, added in shadcn's own per-example style: two DsToggles, not a
/// DsToggleGroup, because Bold and Italic can both be on, both be off, or
/// any mix. There is no mutual exclusivity between them, so a group (which
/// always has at most one selection) would be the wrong tool. Carries the
/// page's pre-existing toolbar specimen code forward unchanged, out of the
/// old "Composition examples" wrapper this page no longer carries.
class _ToggleIndependentSection extends StatelessWidget {
  const _ToggleIndependentSection();

  @override
  Widget build(BuildContext context) {
    return const DsSection(
      id: 'toggle-independent',
      title: 'Toggle: Independent toggles',
      description:
          'Two DsToggles, not a DsToggleGroup: Bold and Italic can both be '
          'on, both be off, or any mix. There is no mutual exclusivity '
          'between them, so a group (which always has at most one '
          'selection) would be the wrong tool.',
      child: DsPanel(
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
    DsToggle(
      pressed: bold,
      label: 'Bold',
      onChanged: (bool next) => setState(() => bold = next),
      child: const Text('B'),
    ),
    SizedBox(width: DsToggle.gap),
    DsToggle(
      pressed: italic,
      label: 'Italic',
      onChanged: (bool next) => setState(() => italic = next),
      child: const Text('I'),
    ),
  ],
)''';

/// shadcn Toggle's Size example, generalized: two variants times three
/// sizes, all six combinations real and tappable, unlike DsCheckbox's fixed
/// geometry. Carries the page's pre-existing grid specimen forward
/// unchanged.
class _ToggleSizesSection extends StatelessWidget {
  const _ToggleSizesSection();

  @override
  Widget build(BuildContext context) => const DsSection(
    id: 'toggle-sizes',
    title: 'Toggle: Sizes',
    description:
        'Two variants times three sizes: all six combinations are real '
        'and tappable below.',
    child: _ToggleSizeVariantGrid(),
  );
}

class _ToggleSizeVariantGrid extends StatefulWidget {
  const _ToggleSizeVariantGrid();

  @override
  State<_ToggleSizeVariantGrid> createState() =>
      _ToggleSizeVariantGridState();
}

class _ToggleSizeVariantGridState extends State<_ToggleSizeVariantGrid> {
  static const List<DsToggleVariant> _variants = <DsToggleVariant>[
    DsToggleVariant.standard,
    DsToggleVariant.outline,
  ];
  static const List<DsToggleSize> _sizes = <DsToggleSize>[
    DsToggleSize.sm,
    DsToggleSize.md,
    DsToggleSize.lg,
  ];

  final List<bool> _pressed = List<bool>.filled(
    _variants.length * _sizes.length,
    false,
  );

  @override
  Widget build(BuildContext context) {
    final List<Widget> cells = <Widget>[];
    int index = 0;
    for (final DsToggleVariant variant in _variants) {
      for (final DsToggleSize size in _sizes) {
        final int cellIndex = index;
        cells.add(
          DsStateCell(
            label: '${variant.name} · ${size.name}',
            note: 'Tap to toggle',
            child: DsToggle(
              variant: variant,
              size: size,
              pressed: _pressed[cellIndex],
              label: 'Favorite',
              onChanged: (bool next) =>
                  setState(() => _pressed[cellIndex] = next),
              child: DsIcon(
                DsIconGlyph.heart,
                size: DsToggle.iconSizeFor(size),
              ),
            ),
          ),
        );
        index++;
      }
    }
    return Wrap(spacing: ds(3), runSpacing: ds(3), children: cells);
  }
}

/// shadcn Toggle's Disabled example: two disabled toggle states, on and
/// off, both shown so the reader sees the dimmed treatment applies to
/// either value.
class _ToggleDisabledSection extends StatelessWidget {
  const _ToggleDisabledSection();

  @override
  Widget build(BuildContext context) => const DsSection(
    id: 'toggle-disabled',
    title: 'Toggle: Disabled',
    description:
        'A null onChanged dims the control to 50% opacity and removes it '
        'from hit-testing and the tab order, independent of pressed.',
    child: DocsCodeExample(
      title: 'Disabled',
      preview: _ToggleDisabledPreview(),
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'disabled_example.dart',
          code: _toggleDisabledCode,
        ),
      ],
    ),
  );
}

class _ToggleDisabledPreview extends StatelessWidget {
  const _ToggleDisabledPreview();

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      DsToggle(
        pressed: false,
        label: 'Bold',
        child: const Text('B'),
      ),
      SizedBox(width: DsToggle.gap),
      DsToggle(
        pressed: true,
        label: 'Bold',
        child: const Text('B'),
      ),
    ],
  );
}

const String _toggleDisabledCode =
    '''DsToggle(pressed: false, label: 'Bold', child: const Text('B'))

DsToggle(pressed: true, label: 'Bold', child: const Text('B'))''';

/// shadcn Toggle's RTL example. DsToggle paints no direction-dependent
/// geometry of its own (EdgeInsets.symmetric, Center), so the same
/// composition reads correctly under Directionality.rtl with no extra
/// wiring: a real, tappable demonstration, not a documented gap.
class _ToggleRtlSection extends StatelessWidget {
  const _ToggleRtlSection();

  @override
  Widget build(BuildContext context) => const DsSection(
    id: 'toggle-rtl',
    title: 'Toggle: RTL',
    description:
        'DsToggle paints no direction-dependent geometry of its own, so '
        'the same composition reads correctly under Directionality.rtl '
        'with no extra wiring.',
    child: DocsCodeExample(
      title: 'RTL',
      preview: _ToggleRtlPreview(),
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(path: 'rtl_example.dart', code: _toggleRtlCode),
      ],
    ),
  );
}

class _ToggleRtlPreview extends StatefulWidget {
  const _ToggleRtlPreview();

  @override
  State<_ToggleRtlPreview> createState() => _ToggleRtlPreviewState();
}

class _ToggleRtlPreviewState extends State<_ToggleRtlPreview> {
  bool _bold = false;

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: DsToggle(
      key: const ValueKey<String>('toggle-rtl-specimen'),
      pressed: _bold,
      label: 'غامق',
      onChanged: (bool next) => setState(() => _bold = next),
      child: const Text('غامق'),
    ),
  );
}

const String _toggleRtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: DsToggle(
    pressed: bold,
    label: 'غامق',
    onChanged: (bool next) => setState(() => bold = next),
    child: const Text('غامق'),
  ),
)''';

/// shadcn Toggle Group's Composition example: a tree of the widget
/// hierarchy. DsToggleGroup has no ToggleGroupItem widget to assemble by
/// hand: items builds the whole row, and DsSlidingPillGroup's travelling
/// pill is inserted underneath it. What follows is what that single call
/// builds internally.
class _ToggleGroupCompositionSection extends StatelessWidget {
  const _ToggleGroupCompositionSection();

  @override
  Widget build(BuildContext context) => const DsSection(
    id: 'toggle-group-composition',
    title: 'Toggle group: Composition',
    description:
        'DsToggleGroup has no ToggleGroupItem widget to assemble by hand: '
        'items builds the whole row, and DsSlidingPillGroup\'s travelling '
        'pill is inserted underneath it. What follows is what that single '
        'call builds internally.',
    child: DsPanel(
      label: 'What DsToggleGroup(items: …) assembles',
      child: DocsSelectableCodeBlock(code: _toggleGroupCompositionCode),
    ),
  );
}

const String _toggleGroupCompositionCode =
    '''DsSlidingPillGroup(                    // owns the travelling selection pill
  activeIndex: selectedIndex ?? -1,
  pill: DsMachineSurface(...),          // theme.primary, DsRadii.pill, DsShadows.chip
  children: <Widget>[
    for (final DsToggleGroupItem item in items)
      DsToggle(                          // one DsToggle per DsToggleGroupItem
        pressed: item == selected,
        inExclusiveGroup: true,          // radio-shaped semantics, not an
                                          // independent on/off switch
        pressedFill: dsTransparent,      // gives up its own fill …
        pressedInk: theme.primaryForeground, // … so the pill shows through
        child: item.child ?? Text(item.label),
      ),
  ],
)''';

/// shadcn Toggle Group's Outline example: variant is passed to every item,
/// the same way the reference's root context provider passes it.
class _ToggleGroupOutlineSection extends StatelessWidget {
  const _ToggleGroupOutlineSection();

  @override
  Widget build(BuildContext context) => const DsSection(
    id: 'toggle-group-outline',
    title: 'Toggle group: Outline',
    description:
        'variant is passed to every item, the same way the reference\'s '
        'root context provider passes it.',
    child: DocsCodeExample(
      title: 'Outline variant',
      preview: _ToggleGroupOutlinePreview(),
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'group_outline_example.dart',
          code: _toggleGroupOutlineCode,
        ),
      ],
    ),
  );
}

class _ToggleGroupOutlinePreview extends StatefulWidget {
  const _ToggleGroupOutlinePreview();

  @override
  State<_ToggleGroupOutlinePreview> createState() =>
      _ToggleGroupOutlinePreviewState();
}

class _ToggleGroupOutlinePreviewState
    extends State<_ToggleGroupOutlinePreview> {
  int? _index = 0;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: DsToggleGroup(
      key: const ValueKey<String>('toggle-group-outline-specimen'),
      variant: DsToggleVariant.outline,
      items: const <DsToggleGroupItem>[
        DsToggleGroupItem(label: 'Newest'),
        DsToggleGroupItem(label: 'Price'),
        DsToggleGroupItem(label: 'Popular'),
      ],
      selectedIndex: _index,
      onChanged: (int? next) => setState(() => _index = next),
    ),
  );
}

const String _toggleGroupOutlineCode = '''DsToggleGroup(
  variant: DsToggleVariant.outline,
  items: const <DsToggleGroupItem>[
    DsToggleGroupItem(label: 'Newest'),
    DsToggleGroupItem(label: 'Price'),
    DsToggleGroupItem(label: 'Popular'),
  ],
  selectedIndex: sortIndex,
  onChanged: (int? next) => setState(() => sortIndex = next),
)''';

/// shadcn Toggle Group's Size example: size is passed to every item too,
/// sm and lg side by side.
class _ToggleGroupSizesSection extends StatelessWidget {
  const _ToggleGroupSizesSection();

  @override
  Widget build(BuildContext context) => const DsSection(
    id: 'toggle-group-sizes',
    title: 'Toggle group: Sizes',
    description: 'size is passed to every item too: sm and lg side by side.',
    child: DocsCodeExample(
      title: 'Both sizes',
      preview: _ToggleGroupSizesPreview(),
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'group_sizes_example.dart',
          code: _toggleGroupSizesCode,
        ),
      ],
    ),
  );
}

class _ToggleGroupSizesPreview extends StatefulWidget {
  const _ToggleGroupSizesPreview();

  @override
  State<_ToggleGroupSizesPreview> createState() =>
      _ToggleGroupSizesPreviewState();
}

class _ToggleGroupSizesPreviewState extends State<_ToggleGroupSizesPreview> {
  int? _smIndex = 0;
  int? _lgIndex = 0;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: ds(6),
    runSpacing: ds(4),
    crossAxisAlignment: WrapCrossAlignment.center,
    children: <Widget>[
      // Wrap lays the two groups out on their own runs when both do not
      // fit side by side, but a single group's own Row still neither wraps
      // nor scrolls: each gets the page's established horizontal-scroll
      // mitigation too.
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DsToggleGroup(
          key: const ValueKey<String>('toggle-group-sizes-sm-specimen'),
          size: DsToggleSize.sm,
          items: const <DsToggleGroupItem>[
            DsToggleGroupItem(label: 'Newest'),
            DsToggleGroupItem(label: 'Price'),
            DsToggleGroupItem(label: 'Popular'),
          ],
          selectedIndex: _smIndex,
          onChanged: (int? next) => setState(() => _smIndex = next),
        ),
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DsToggleGroup(
          key: const ValueKey<String>('toggle-group-sizes-lg-specimen'),
          size: DsToggleSize.lg,
          items: const <DsToggleGroupItem>[
            DsToggleGroupItem(label: 'Newest'),
            DsToggleGroupItem(label: 'Price'),
            DsToggleGroupItem(label: 'Popular'),
          ],
          selectedIndex: _lgIndex,
          onChanged: (int? next) => setState(() => _lgIndex = next),
        ),
      ),
    ],
  );
}

const String _toggleGroupSizesCode =
    '''DsToggleGroup(size: DsToggleSize.sm, items: items, selectedIndex: smIndex, onChanged: (int? next) => setState(() => smIndex = next))

DsToggleGroup(size: DsToggleSize.lg, items: items, selectedIndex: lgIndex, onChanged: (int? next) => setState(() => lgIndex = next))''';

/// shadcn Toggle Group's Disabled example: DsToggleGroupItem.enabled: false
/// disables just that one option; DsToggleGroup wires its onChanged to null
/// for a disabled item, the same as a standalone DsToggle.
class _ToggleGroupDisabledSection extends StatelessWidget {
  const _ToggleGroupDisabledSection();

  @override
  Widget build(BuildContext context) => const DsSection(
    id: 'toggle-group-disabled',
    title: 'Toggle group: Disabled',
    description:
        'DsToggleGroupItem.enabled: false disables just that one option; '
        'DsToggleGroup wires its onChanged to null for a disabled item, '
        'the same as a standalone DsToggle.',
    child: DocsCodeExample(
      title: 'One disabled option',
      preview: _ToggleGroupDisabledPreview(),
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'group_disabled_example.dart',
          code: _toggleGroupDisabledCode,
        ),
      ],
    ),
  );
}

class _ToggleGroupDisabledPreview extends StatefulWidget {
  const _ToggleGroupDisabledPreview();

  @override
  State<_ToggleGroupDisabledPreview> createState() =>
      _ToggleGroupDisabledPreviewState();
}

class _ToggleGroupDisabledPreviewState
    extends State<_ToggleGroupDisabledPreview> {
  int? _index = 0;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: DsToggleGroup(
      key: const ValueKey<String>('toggle-group-disabled-specimen'),
      items: const <DsToggleGroupItem>[
        DsToggleGroupItem(label: 'Newest'),
        DsToggleGroupItem(label: 'Price', enabled: false),
        DsToggleGroupItem(label: 'Popular'),
      ],
      selectedIndex: _index,
      onChanged: (int? next) => setState(() => _index = next),
    ),
  );
}

const String _toggleGroupDisabledCode = '''DsToggleGroup(
  items: const <DsToggleGroupItem>[
    DsToggleGroupItem(label: 'Newest'),
    DsToggleGroupItem(label: 'Price', enabled: false),
    DsToggleGroupItem(label: 'Popular'),
  ],
  selectedIndex: sortIndex,
  onChanged: (int? next) => setState(() => sortIndex = next),
)''';

/// shadcn Toggle Group's Custom example: a practical implementation, not a
/// manufactured one the Dart API cannot support. Carries the page's
/// pre-existing heterogeneous-children specimen forward unchanged, out of
/// the old "Composition examples" wrapper this page no longer carries.
class _ToggleGroupCustomSection extends StatelessWidget {
  const _ToggleGroupCustomSection();

  @override
  Widget build(BuildContext context) {
    return const DsSection(
      id: 'toggle-group-custom',
      title: 'Toggle group: Custom',
      description:
          'DsToggleGroupItem.child is per-item and optional: two options '
          'here supply an icon-and-label row, and the third omits child '
          'entirely and falls back to a bare Text(label).',
      child: DsPanel(
        label: 'DART',
        note: 'HETEROGENEOUS GROUP CHILDREN',
        child: DocsSelectableCodeBlock(code: _viewSwitcherCode),
      ),
    );
  }
}

const String _viewSwitcherCode =
    '''// DsToggleGroupItem.child is optional per item: two options here supply
// an icon-and-label row, and the third omits child and falls back to a
// bare Text(label).
int? viewIndex = 0;

DsToggleGroup(
  items: <DsToggleGroupItem>[
    DsToggleGroupItem(
      label: 'Grid',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DsIcon(
            DsIconGlyph.layoutGrid,
            size: DsToggle.iconSizeFor(DsToggleSize.md),
          ),
          SizedBox(width: DsToggle.gap),
          const Text('Grid'),
        ],
      ),
    ),
    DsToggleGroupItem(
      label: 'List',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DsIcon(
            DsIconGlyph.rows3,
            size: DsToggle.iconSizeFor(DsToggleSize.md),
          ),
          SizedBox(width: DsToggle.gap),
          const Text('List'),
        ],
      ),
    ),
    const DsToggleGroupItem(label: 'Table'),
  ],
  selectedIndex: viewIndex,
  onChanged: (int? next) => setState(() => viewIndex = next),
)''';

/// shadcn Toggle Group's RTL example. Same reasoning as the standalone
/// control: DsSlidingPillGroup measures each child's own RenderBox and
/// positions the pill from those measurements, so it reads correctly under
/// Directionality.rtl too.
class _ToggleGroupRtlSection extends StatelessWidget {
  const _ToggleGroupRtlSection();

  @override
  Widget build(BuildContext context) => const DsSection(
    id: 'toggle-group-rtl',
    title: 'Toggle group: RTL',
    description:
        'DsSlidingPillGroup measures each child\'s own RenderBox and '
        'positions the pill from those measurements, so it reads correctly '
        'under Directionality.rtl too.',
    child: DocsCodeExample(
      title: 'RTL',
      preview: _ToggleGroupRtlPreview(),
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'group_rtl_example.dart',
          code: _toggleGroupRtlCode,
        ),
      ],
    ),
  );
}

class _ToggleGroupRtlPreview extends StatefulWidget {
  const _ToggleGroupRtlPreview();

  @override
  State<_ToggleGroupRtlPreview> createState() =>
      _ToggleGroupRtlPreviewState();
}

class _ToggleGroupRtlPreviewState extends State<_ToggleGroupRtlPreview> {
  int? _index = 0;

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DsToggleGroup(
        key: const ValueKey<String>('toggle-group-rtl-specimen'),
        items: const <DsToggleGroupItem>[
          DsToggleGroupItem(label: 'الأحدث'),
          DsToggleGroupItem(label: 'السعر'),
          DsToggleGroupItem(label: 'الأكثر شيوعا'),
        ],
        selectedIndex: _index,
        onChanged: (int? next) => setState(() => _index = next),
      ),
    ),
  );
}

const String _toggleGroupRtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: DsToggleGroup(
    items: const <DsToggleGroupItem>[
      DsToggleGroupItem(label: 'الأحدث'),
      DsToggleGroupItem(label: 'السعر'),
      DsToggleGroupItem(label: 'الأكثر شيوعا'),
    ],
    selectedIndex: sortIndex,
    onChanged: (int? next) => setState(() => sortIndex = next),
  ),
)''';

/// shadcn's own API Reference just links out to Base UI's docs on both
/// counterpart pages; ours renders real prop tables, an addition their
/// pages do not have, one table per class in the family.
class _ApiSection extends StatelessWidget {
  const _ApiSection();

  @override
  Widget build(BuildContext context) => DsSection(
    id: 'api',
    title: 'API Reference',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DocsApiTable(
          title: 'DsToggle',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'child',
              type: 'Widget',
              description:
                  'The content: a label, an icon, or a row of both spaced '
                  'by DsToggle.gap. This widget installs the resolved text '
                  'style as a DefaultTextStyle, so a bare Text child is '
                  'the right choice for a labelled toggle.',
            ),
            DocsApiFact(
              name: 'pressed',
              type: 'bool',
              description:
                  'Which of the two states is rendered: on when true. The '
                  'control never holds its own state: it is fully '
                  'governed by the caller, because a group above it may '
                  'need to clear the selection entirely.',
            ),
            DocsApiFact(
              name: 'onChanged',
              type: 'ValueChanged<bool>?',
              description:
                  'Called with the value the control is asking to move '
                  'to: always !pressed, since a toggle has exactly one '
                  'other state. Null disables the control.',
            ),
            DocsApiFact(
              name: 'variant',
              type: 'DsToggleVariant',
              description:
                  'Defaults to DsToggleVariant.standard (no border box at '
                  'all). outline adds a 1px theme.input border.',
            ),
            DocsApiFact(
              name: 'size',
              type: 'DsToggleSize',
              description:
                  'Defaults to DsToggleSize.md (32px tall). sm is 28px, lg '
                  'is 36px.',
            ),
            DocsApiFact(
              name: 'label',
              type: 'String?',
              description:
                  'The accessible name: overrides, rather than adds to, '
                  'whatever name the child\'s own content would supply. '
                  'Required for an icon-only toggle to have any '
                  'accessible name; optional for a text-labelled one, '
                  'whose own text already names it.',
            ),
            DocsApiFact(
              name: 'focusNode',
              type: 'FocusNode?',
              description:
                  'Supply one to drive focus-visible from outside; '
                  'otherwise the control owns its own node.',
            ),
            DocsApiFact(
              name: 'pressedFill',
              type: 'Color?',
              description:
                  'The fill painted while pressed is true. Null keeps the '
                  'default on-fill, theme.muted. Exists for DsToggleGroup '
                  'alone, which overrides it to a transparent fill so its '
                  'travelling pill shows through.',
            ),
            DocsApiFact(
              name: 'pressedInk',
              type: 'Color?',
              description:
                  'The ink painted while pressed is true. Null keeps the '
                  'inherited theme.foreground. DsToggleGroup overrides it '
                  'to theme.primaryForeground for the selected item.',
            ),
            DocsApiFact(
              name: 'inExclusiveGroup',
              type: 'bool',
              description:
                  'Defaults to false. true changes only the semantics '
                  'node: a standalone toggle announces as a button with '
                  'an on/off state; one option of a single-select group '
                  'announces as a choice among others instead (selected + '
                  'inMutuallyExclusiveGroup).',
            ),
          ],
        ),
        SizedBox(height: ds(5)),
        DocsApiTable(
          title: 'DsToggleVariant, DsToggleSize and statics',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'DsToggleVariant.standard',
              type: 'enum value',
              description:
                  'bg-transparent, no border box at all: the default.',
            ),
            DocsApiFact(
              name: 'DsToggleVariant.outline',
              type: 'enum value',
              description: 'A 1px theme.input border, still no fill.',
            ),
            DocsApiFact(
              name: 'DsToggleSize.sm',
              type: 'enum value',
              description: '28px tall.',
            ),
            DocsApiFact(
              name: 'DsToggleSize.md',
              type: 'enum value',
              description: '32px tall: the default.',
            ),
            DocsApiFact(
              name: 'DsToggleSize.lg',
              type: 'enum value',
              description: '36px tall.',
            ),
            DocsApiFact(
              name: 'DsToggle.heightFor',
              type: 'static double Function(DsToggleSize)',
              description: '28 / 32 / 36 for sm / md / lg.',
            ),
            DocsApiFact(
              name: 'DsToggle.minWidthFor',
              type: 'static double Function(DsToggleSize)',
              description:
                  'The same 28 / 32 / 36 floor, so a 16px icon-only '
                  'toggle does not collapse onto its glyph.',
            ),
            DocsApiFact(
              name: 'DsToggle.paddingX',
              type: 'static double',
              description: '10px of horizontal padding, on every size.',
            ),
            DocsApiFact(
              name: 'DsToggle.gap',
              type: 'static double',
              description:
                  '4px between an icon and a label, when a caller '
                  'composes both into one child Row.',
            ),
            DocsApiFact(
              name: 'DsToggle.radiusFor',
              type: 'static double Function(DsToggleSize)',
              description: '12px on md and lg; a clamped ~10px on sm.',
            ),
            DocsApiFact(
              name: 'DsToggle.iconSizeFor',
              type: 'static DsIconSize Function(DsToggleSize)',
              description:
                  'The icon rung a child DsIcon should render at to '
                  'match this control\'s size, DsIconSize.sm on '
                  'DsToggleSize.sm, DsIconSize.md otherwise.',
            ),
          ],
        ),
        SizedBox(height: ds(5)),
        DocsApiTable(
          title: 'DsToggleGroupItem',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'label',
              type: 'String',
              description:
                  'The option\'s name: both what it renders as its '
                  'default child and what a screen reader announces.',
            ),
            DocsApiFact(
              name: 'child',
              type: 'Widget?',
              description:
                  'What the item renders in place of its own label text. '
                  'Null, the default, renders label as a bare Text in '
                  'the toggle\'s resolved style.',
            ),
            DocsApiFact(
              name: 'enabled',
              type: 'bool',
              description:
                  'Defaults to true. false disables just this one '
                  'option; DsToggleGroup wires its onChanged to null for '
                  'a disabled item, the same as a standalone DsToggle.',
            ),
          ],
        ),
        SizedBox(height: ds(5)),
        DocsApiTable(
          title: 'DsToggleGroup',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'items',
              type: 'List<DsToggleGroupItem>',
              description: 'The options, in paint order.',
            ),
            DocsApiFact(
              name: 'selectedIndex',
              type: 'int?',
              description:
                  'Which option is selected, or null for none, the '
                  'state the travelling pill reads. Null or '
                  'out-of-range is what DsSlidingPillGroup treats as '
                  '"deselected": the pill fades to 0 opacity and stays '
                  'parked where it last was.',
            ),
            DocsApiFact(
              name: 'onChanged',
              type: 'ValueChanged<int?>',
              description:
                  'Called with the new selection: the tapped index, or '
                  'null when the tapped option was already selected, '
                  'Radix type="single" deselect semantics. Not nullable '
                  'itself: a group always needs a way to hear both an '
                  'index and a clear.',
            ),
            DocsApiFact(
              name: 'variant',
              type: 'DsToggleVariant',
              description:
                  'Passed to every item. Defaults to '
                  'DsToggleVariant.standard.',
            ),
            DocsApiFact(
              name: 'size',
              type: 'DsToggleSize',
              description:
                  'Passed to every item. Defaults to DsToggleSize.md.',
            ),
            DocsApiFact(
              name: 'label',
              type: 'String?',
              description:
                  'The group\'s own accessible name. Null, the default, '
                  'emits no extra container semantics node; supply one '
                  'when nothing else on the screen names the group.',
            ),
            DocsApiFact(
              name: 'DsToggleGroup.gap',
              type: 'static double',
              description:
                  '8px between items: also the gap the travelling '
                  'pill\'s own geometry is measured against.',
            ),
          ],
        ),
      ],
    ),
  );
}

/// Rest, Hover, Selected (standalone and in a group), Focus-visible,
/// Disabled and Reduced motion. Pressed, Loading, Empty, Error and Success
/// are addressed in prose below the table rather than invented as rows.
class _StatesSection extends StatelessWidget {
  const _StatesSection();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return DsSection(
      id: 'states',
      title: 'States',
      description:
          'Pressed, Loading, Empty, Error and Success are omitted below: '
          'reasons follow the table.',
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
                    'a colour the element already has and changes '
                    'nothing.',
                userSignal:
                    'An unfilled control, distinguishable from Selected '
                    'only once a fill or border tells them apart.',
              ),
              DocsStateFact(
                state: 'Hover',
                treatment:
                    'theme.muted fill, on both variants: the same fill '
                    'Selected paints outside a group, so hover and on '
                    'are visually identical there.',
                userSignal:
                    'A grey wash appears under the pointer; the cursor '
                    'becomes a click cursor.',
              ),
              DocsStateFact(
                state: 'Selected (on): standalone',
                treatment:
                    'theme.muted fill (the class hover also paints), '
                    'theme.foreground ink. Unlike DsSwitch and '
                    'DsCheckbox, the on-state is not the brand colour '
                    'here.',
                userSignal:
                    'A filled control that stays filled after the '
                    'pointer leaves: the only way Rest and Selected are '
                    'told apart outside a group.',
              ),
              DocsStateFact(
                state: 'Selected: in a group',
                treatment:
                    'pressedFill: transparent, pressedInk: '
                    'theme.primaryForeground: the item gives up its own '
                    'fill so DsSlidingPillGroup\'s single theme.primary '
                    'pill, already travelling underneath it, shows '
                    'through.',
                userSignal:
                    'White-on-blue ink over the travelling pill: the '
                    'one place selection reads as the brand colour on '
                    'this page.',
              ),
              DocsStateFact(
                state: 'Focus-visible',
                treatment:
                    'A 3px ring at theme.ring, 50% alpha. On outline the '
                    'border also swaps to theme.ring; on standard there '
                    'is no border box to colour, so only the ring '
                    'paints.',
                userSignal:
                    'A ring that appears only after keyboard focus: a '
                    'bare pointer tap does not request focus, so a '
                    'tapped-and-released toggle shows no ring.',
              ),
              DocsStateFact(
                state: 'Disabled',
                treatment:
                    'onChanged: null, 50% opacity, and an IgnorePointer '
                    'that removes the control from hit-testing and '
                    'hover tracking together, and from the tab order.',
                userSignal:
                    'Dimmed and inert: the one state that visibly dims, '
                    'matching DsButton\'s own disabled treatment.',
              ),
              DocsStateFact(
                state: 'Reduced motion',
                treatment:
                    'The fill/ink/border/ring tween chain and '
                    'DsSlidingPillGroup\'s own travel both resolve '
                    'through dsAnimationDuration, which reduced motion '
                    'shortens toward zero.',
                userSignal:
                    'State changes land on their finished colours and '
                    'position immediately, with no transition or travel '
                    'to sit through.',
              ),
            ],
          ),
          SizedBox(height: ds(3)),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: DsWidths.prose),
            child: DsText(
              'Pressed is not a row: the class list carries no active-'
              'state rule and no press-motion utility, a toggle does '
              'nothing at all between pointer-down and pointer-up, '
              'unlike DsButton\'s spring squash (a documented drift in '
              'toggle.dart\'s own header). Loading and Empty are not '
              'rows either: both components are synchronous primitives '
              'with no async operation and nothing to list. Error is '
              'not a row: aria-invalid is never set on this control '
              'anywhere in the reference, neither DsToggle nor '
              'DsToggleGroup exposes an invalid parameter at all. '
              'Success is not a row: neither component defines success '
              'semantics of its own.',
              DsType.small,
              color: theme.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

/// Semantic role, label association, keyboard, focus, touch target,
/// non-colour signal, error wiring, and one known divergence from Radix.
class _AccessibilitySection extends StatelessWidget {
  const _AccessibilitySection();

  @override
  Widget build(BuildContext context) => const DsSection(
    id: 'accessibility',
    title: 'Accessibility',
    child: DocsInstallFacts(
      title: 'Accessibility',
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'Semantic role',
          value: 'Semantics(button:, toggled:/selected:)',
          description:
              'A standalone toggle (inExclusiveGroup: false) exposes '
              'toggled: pressed. One option of a DsToggleGroup '
              '(inExclusiveGroup: true, set by the group for every '
              'item) exposes selected: pressed and '
              'inMutuallyExclusiveGroup: true instead, with toggled '
              'left null: a choice among others, not an independent '
              'on/off switch.',
        ),
        DocsInstallFact(
          label: 'Label association',
          value: 'label',
          description:
              'Overrides, rather than adds to, the child\'s own '
              'content-derived name (excludeSemantics: true whenever '
              'label is set). Required for an icon-only toggle to have '
              'any accessible name; DsToggleGroupItem.label is passed '
              'straight through as this for every item the group '
              'builds.',
        ),
        DocsInstallFact(
          label: 'Keyboard activation',
          value: 'Enter, numpad Enter, Space',
          description:
              'Hand-wired through Focus.onKeyEvent, the same wiring '
              'DsButton and DsCheckbox use: the control is not a '
              'native button, so nothing arrives for free.',
        ),
        DocsInstallFact(
          label: 'Focus behavior',
          value: 'A 3px ring at theme.ring, 50% alpha: keyboard-only',
          description:
              'focus-visible, not focus. Flutter does not move focus '
              'on a bare pointer tap, so hasFocus here already is the '
              'keyboard-only predicate CSS means; a tapped-and-'
              'released toggle never shows the ring.',
        ),
        DocsInstallFact(
          label: 'Touch target',
          value: 'Exactly the visual box: no cushion',
          description:
              '28×28 / 32×32 / 36×36 depending on size. Unlike '
              'DsCheckbox\'s DsHitArea, DsToggle wraps its '
              'GestureDetector directly around the sized box with no '
              'extra hit-test padding. Every size sits below the '
              'system\'s 44px touch-target floor: recorded rather than '
              'corrected, because it is what the source renders.',
        ),
        DocsInstallFact(
          label: 'Non-colour signal',
          value: 'The toggled/selected semantics flag itself',
          description:
              'Visually, the only change between Rest and Selected '
              'outside a group is a fill colour; a sighted user who '
              'cannot rely on that has no drawn glyph to fall back on '
              'the way DsCheckbox\'s tick provides. A screen reader is '
              'told regardless, through the toggled or selected flag.',
        ),
        DocsInstallFact(
          label: 'Error wiring',
          value: 'N/A: no invalid parameter exists',
          description:
              'Neither DsToggle nor DsToggleGroup declares an invalid/'
              'aria-invalid path; the source states aria-invalid is '
              'never set on this control anywhere in the reference. '
              'There is nothing to wire.',
        ),
        DocsInstallFact(
          label: 'Screen-reader announcements',
          value: 'No live region',
          description:
              'State changes are exposed purely through the semantics '
              'flags above; no extra announcement is authored.',
        ),
        DocsInstallFact(
          label: 'Known divergence',
          value: 'Roving focus is not ported',
          description:
              'Radix wraps a ToggleGroup\'s items in a '
              'RovingFocusGroup: one Tab stop for the whole group, '
              'arrow keys to move within it. Flutter\'s default '
              'traversal gives every item its own Tab stop instead; '
              'toggle_group.dart states this divergence rather than '
              'approximating half of the reference behaviour.',
        ),
      ],
    ),
  );
}

/// Layout, breakpoints, and platform behavior, split out from
/// Accessibility, matching `switch/page.dart`'s own separation of the two
/// concerns.
class _ResponsiveSection extends StatelessWidget {
  const _ResponsiveSection();

  @override
  Widget build(BuildContext context) => DsSection(
    id: 'responsive',
    title: 'Responsive',
    child: DsText(
      'Neither component has breakpoints of its own: DsToggle is a '
      'fixed-height atomic control (28 / 32 / 36px) and DsToggleGroup is '
      'a Row of them plus a travelling pill, sized to its own content. '
      'What changes with layout belongs to whatever composes them: a '
      'filter bar wrapping two DsToggleGroup filters needs a '
      'SingleChildScrollView, because a four-item family filter does not '
      'fit every narrow viewport, and DsSlidingPillGroup has no wrap of '
      'its own to fall back on. '
      'Keyboard activation and pointer activation behave identically on '
      'every Flutter target this package supports; there is no platform '
      'channel and nothing here is web-only or desktop-only.',
      DsType.small,
    ),
  );
}

/// The real source-level files, imports, assets, fonts and shaders these
/// two components pull in.
class _DependenciesSection extends StatelessWidget {
  const _DependenciesSection();

  @override
  Widget build(BuildContext context) => DsSection(
    id: 'dependencies',
    title: 'Dependencies',
    child: DocsInstallFacts(
      title: 'Dependencies and files',
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'Source files',
          value: '${toggleDoc.sourcePath}, $toggleGroupSourcePath',
          description:
              'The authoritative implementations. toggle_group.dart '
              'imports toggle.dart directly: every group item is a '
              'DsToggle underneath.',
        ),
        const DocsInstallFact(
          label: 'Local file dependencies',
          value:
              'button.dart, icon.dart, effects/machine_surface.dart, '
              'motion/sliding_pill.dart',
          description:
              'toggle.dart imports button.dart for '
              'DsButton.withFocusRing and icon.dart for the DsIconSize '
              'return type of iconSizeFor; both files import '
              'effects/machine_surface.dart for DsMachineSurface. '
              'toggle_group.dart additionally imports '
              'motion/sliding_pill.dart for DsSlidingPillGroup, the '
              'travelling-pill machinery it shares with DsTabs, '
              'DsSidebar and IconSwap. None are copyable in isolation: '
              'see Installation.',
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
              'durations and curves, shadow specs, the ds() spacing '
              'scale, the live theme, and the resolved toggle-label '
              'text style.',
        ),
        DocsInstallFact(
          label: 'Exports',
          value: toggleDoc.exports.join(', '),
          description:
              'The public symbols these two components make available.',
        ),
        const DocsInstallFact(
          label: 'Assets',
          value: 'none',
          description:
              'Both components paint fills, borders, rings and the '
              'travelling pill with plain box decoration: no image and '
              'no icon-font glyph of their own. An icon child, if one '
              'is composed in, brings its own geometry from '
              'icon_paths.dart, not an asset file.',
        ),
        const DocsInstallFact(
          label: 'Fonts',
          value: 'none',
          description:
              'Neither component renders text of its own; a text '
              'child inherits whatever the app\'s theme already '
              'resolves.',
        ),
        const DocsInstallFact(
          label: 'Shaders',
          value: 'none',
          description: 'No fragment shader is used by either file.',
        ),
      ],
    ),
  );
}

/// How colour and motion resolve, plus the one blue selection surface
/// either component paints.
class _ThemingSection extends StatelessWidget {
  const _ThemingSection();

  @override
  Widget build(BuildContext context) => const DsSection(
    id: 'theming',
    title: 'Theming',
    child: DocsInstallFacts(
      title: 'Tokens this component reads',
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'Fill',
          value:
              'theme.muted (hover / on, standalone) / transparent (on, '
              'inside a group)',
          description: 'The control\'s own background.',
        ),
        DocsInstallFact(
          label: 'Border',
          value:
              'theme.input (outline, rest) / theme.ring (outline, '
              'focus-visible)',
          description:
              'Only painted on DsToggleVariant.outline: standard has '
              'no border box at all.',
        ),
        DocsInstallFact(
          label: 'Ink',
          value:
              'theme.foreground (rest and on, standalone) / '
              'theme.primaryForeground (on, inside a group)',
          description: 'The child\'s resolved text/icon colour.',
        ),
        DocsInstallFact(
          label: 'Ring',
          value: 'theme.ring at 50% alpha',
          description: 'The focus-visible ring.',
        ),
        DocsInstallFact(
          label: 'Pill (group only)',
          value: 'theme.primary, DsShadows.chip, DsRadii.pill',
          description:
              'The one blue selection surface either component paints, '
              'DsSlidingPillGroup\'s travelling pill.',
        ),
        DocsInstallFact(
          label: 'Radius',
          value: 'DsRadii.lg (md/lg) / a clamped ~DsRadii.md (sm)',
          description:
              'The item\'s own corner. The group\'s pill is always '
              'DsRadii.pill regardless of item size: a stadium over a '
              'rounded rect in the same slot, a documented drift in '
              'toggle_group.dart\'s own header.',
        ),
        DocsInstallFact(
          label: 'Motion',
          value:
              'DsDurations.transitionDefault, DsCurves.out, '
              'DsSlidingPillGroup',
          description:
              'The toggle\'s own fill/ink/border/ring tween chain, and '
              'the pill\'s 250ms spring travel plus jelly squash: all '
              'resolved through dsAnimationDuration, so reduced motion '
              'shortens or removes them automatically.',
        ),
      ],
    ),
  );
}

/// Source, package tests, and this page's own docs test.
class _SourceSection extends StatelessWidget {
  const _SourceSection();

  @override
  Widget build(BuildContext context) => DsSection(
    id: 'source',
    title: 'Source',
    child: DocsInstallFacts(
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'Toggle source',
          value: toggleDoc.sourcePath,
          description: 'Authoritative implementation of DsToggle.',
        ),
        const DocsInstallFact(
          label: 'Toggle-group source',
          value: toggleGroupSourcePath,
          description:
              'Authoritative implementation of DsToggleGroup and '
              'DsToggleGroupItem.',
        ),
        const DocsInstallFact(
          label: 'Shared machinery',
          value: 'lib/src/motion/sliding_pill.dart',
          description:
              'DsSlidingPillGroup: shared with DsTabs, DsSidebar and '
              'IconSwap, and documented on their own component pages.',
        ),
        const DocsInstallFact(
          label: 'Package tests',
          value: 'test/components_test.dart',
          description:
              'The DsToggle and DsToggleGroup groups within that file '
              'cover geometry, statics and state behaviour for both '
              'components in the package itself.',
        ),
        const DocsInstallFact(
          label: 'Docs page tests',
          value: 'example/test/components_docs/toggle_test.dart',
          description:
              'Coverage for this page: the shadcn-parity section order, '
              'API completeness for both components, the live toggle '
              'and group specimens (including the group\'s deselect-to-'
              'null path), and both themes.',
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
  // section up by, matching `switch/page.dart`'s own convention: used only
  // for the un-headed hero demo above, every other section gets its anchor
  // from DsSection itself.
  Widget build(BuildContext context) =>
      KeyedSubtree(key: docsAnchorKey(name), child: child);
}
