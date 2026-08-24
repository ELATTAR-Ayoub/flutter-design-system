/// Public documentation page for the `toggle-group` component.
///
/// **Split from toggle.** `ElToggleGroup` and `ElToggleGroupItem` used to be
/// documented on `components_docs/toggle/page.dart` alongside `ElToggle`. They
/// are their own barrel export with their own shadcn counterpart, so every
/// group specimen, every mention of `ElSlidingPillGroup` (the travelling-pill
/// engine `toggle_group.dart` imports and `toggle.dart` does not), and the
/// Arabic-label RTL demo moved here whole. `toggle/page.dart` keeps
/// `ElToggle`, its own separate RTL demo, and nothing else.
///
/// Every moved specimen brought its narrow-viewport mitigation with it:
/// `ElSlidingPillGroup`'s internal `Row` neither wraps nor scrolls, and three
/// segments overflow a 390px column, so each live group is wrapped in
/// `SingleChildScrollView(scrollDirection: Axis.horizontal)`. There are eight
/// such wrappers on this page, one per live group, and none left behind on
/// `toggle/page.dart`, which mounts no group at all.
///
/// **Shape.** `components_docs/button/page.dart` is the structural reference:
/// an un-headed live demo before any heading, then Installation, then Usage,
/// then one top-level section per shadcn example, then API Reference last of
/// the component-specific sections, then the six sections shadcn does not
/// carry (States, Accessibility, Responsive, Dependencies, Theming, Source).
/// Section titles carry no `Toggle group:` prefix any more: with the split,
/// every section here is about the group, so the prefix restated the page
/// title on every heading.
///
/// **Counterpart.** https://ui.shadcn.com/docs/components/base/toggle-group,
/// fetched fresh. Its `<h2>`s are, in order: Installation, Usage, Composition,
/// Outline, Size, Spacing, Vertical, Disabled, Custom, RTL, API Reference,
/// Changelog. Every one but Changelog has a section below, under the same name
/// (`Size` pluralised to `Sizes`).
///
/// **Not ported, disclosed rather than skipped.** `Spacing` and `Vertical`
/// name two root props `toggle_group.dart` does not have: there is no
/// `spacing` parameter and no `orientation` parameter on `ElToggleGroup`, and
/// nothing in this port takes their place. Both sections still render, and
/// each says exactly what is missing and what a caller gets instead, rather
/// than being dropped silently or reframed as if the capability existed.
///
/// **Skipped.** `Changelog`, present on the counterpart page, has no analogue:
/// this package ships from source, not a versioned registry entry with its own
/// release notes. The counterpart's one changelog entry is itself about the
/// `spacing` default, a prop this port does not have.
///
/// `RTL` is NOT skipped. `ElSlidingPillGroup` measures each child's own
/// `RenderBox` and positions the pill from those measurements, so the group
/// mirrors correctly under `Directionality.rtl` with no extra wiring: the
/// section below is a real, tappable demonstration, not a documented gap.
///
/// `toggleGroupDoc` (from `meta.dart`) is the data source: `toggle-group` is
/// not registered in `catalog.dart`'s `componentDocs` list, so calling
/// `componentDoc('toggle-group')` would throw. Adding it there, and wiring
/// this page into the router, is a supervisor-owned aggregation step.
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

class ToggleGroupDocPage extends StatelessWidget {
  const ToggleGroupDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    return DocsLayout(
      route: toggleGroupDoc.route,
      intro: DocsPageIntro(
        eyebrow: 'COMPONENTS / BASE',
        title: toggleGroupDoc.title,
        description: toggleGroupDoc.description,
      ),
      breadcrumbs: const <ElBreadcrumbEntry>[
        ElBreadcrumbEntry.link('Components'),
        ElBreadcrumbEntry.page('Toggle group'),
      ],
      // No entry for the hero demo: it renders before any heading, exactly as
      // shadcn's own "Bold / Italic / Underline" demo is not itself a stop on
      // the reference's on-this-page nav.
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Installation', anchor: 'install'),
        DocsTocEntry(title: 'Usage', anchor: 'usage'),
        DocsTocEntry(title: 'Composition', anchor: 'composition'),
        DocsTocEntry(title: 'Outline', anchor: 'outline'),
        DocsTocEntry(title: 'Sizes', anchor: 'sizes'),
        DocsTocEntry(title: 'Spacing', anchor: 'spacing'),
        DocsTocEntry(title: 'Vertical', anchor: 'vertical'),
        DocsTocEntry(title: 'Disabled', anchor: 'disabled'),
        DocsTocEntry(title: 'Custom', anchor: 'custom'),
        DocsTocEntry(title: 'RTL', anchor: 'rtl'),
        DocsTocEntry(
          title: 'API Reference',
          anchor: 'api',
          children: <DocsTocEntry>[
            DocsTocEntry(title: 'ElToggleGroup', anchor: 'api-eltogglegroup'),
            DocsTocEntry(
              title: 'ElToggleGroup static helpers',
              anchor: 'api-eltogglegroup-static',
            ),
            DocsTocEntry(
              title: 'ElToggleGroupItem',
              anchor: 'api-eltogglegroupitem',
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
      // The page this one split off from.
      previous: const DocsPageLink(
        title: 'Toggle',
        route: '/components/toggle',
      ),
      next: const DocsPageLink(title: 'Tooltip', route: '/components/tooltip'),
      onNavigate: onNavigate,
      child: const _ToggleGroupArticle(),
    );
  }
}

class _ToggleGroupArticle extends StatelessWidget {
  const _ToggleGroupArticle();

  @override
  Widget build(BuildContext context) => Column(
    key: const ValueKey<String>('toggle-group-doc-article'),
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      _Anchor('preview', child: const _PreviewSection()),
      SizedBox(height: el(8)),
      const _InstallSection(),
      SizedBox(height: el(2)),
      const _UsageSection(),
      SizedBox(height: el(2)),
      const _CompositionSection(),
      SizedBox(height: el(2)),
      const _OutlineSection(),
      SizedBox(height: el(2)),
      const _SizesSection(),
      SizedBox(height: el(2)),
      const _SpacingSection(),
      SizedBox(height: el(2)),
      const _VerticalSection(),
      SizedBox(height: el(2)),
      const _DisabledSection(),
      SizedBox(height: el(2)),
      const _CustomSection(),
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

/// The counterpart page's own un-headed hero demo: a live [ElToggleGroup],
/// stating its own `selectedIndex` including the moment it becomes null.
class _PreviewSection extends StatelessWidget {
  const _PreviewSection();

  @override
  Widget build(BuildContext context) => const DocsCodeExample(
    title: 'Toggle group',
    description:
        'One selection at most, over a single travelling pill. Tap a '
        'different option to move the selection; tap the selected option '
        'again to clear it.',
    preview: _ToggleGroupPreview(),
  );
}

/// The live [ElToggleGroup] specimen: three sort options, one of which starts
/// selected, and the exact deselect-to-null behaviour this page exists to
/// document.
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
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // ElSlidingPillGroup's Row has no wrap of its own: at a narrow
        // viewport three segments can ask for more width than this column
        // has, the same overflow a multi-segment filter bar runs into. Same
        // fix here, and on every other live group on this page.
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ElToggleGroup(
            key: const ValueKey<String>('toggle-group-live-specimen'),
            items: const <ElToggleGroupItem>[
              ElToggleGroupItem(label: 'Newest'),
              ElToggleGroupItem(label: 'Price'),
              ElToggleGroupItem(label: 'Popular'),
            ],
            selectedIndex: _selectedIndex,
            onChanged: (int? next) => setState(() => _selectedIndex = next),
          ),
        ),
        SizedBox(height: el(3)),
        ElText(
          _selectedIndex == null
              ? 'selectedIndex: null: tap any option to select it.'
              : 'selectedIndex: $_selectedIndex: tap '
                    '"${_labels[_selectedIndex!]}" again to deselect it.',
          ElType.small,
          color: theme.mutedForeground,
        ),
        SizedBox(height: el(3)),
        ElText(
          'The pill is theme.primary; the fading of "nothing selected" is '
          'what ElSlidingPillGroup renders whenever selectedIndex is null.',
          ElType.small,
          color: theme.mutedForeground,
        ),
      ],
    );
  }
}

/// shadcn's Installation section: CLI and Manual tabs. `toggle-group` has not
/// shipped a registry manifest yet, so `elattar add toggle-group` will not
/// resolve: the Manual tab is the whole story, and this panel also folds in
/// the version and platform facts rather than giving them a heading the
/// counterpart page has nowhere.
class _InstallSection extends StatelessWidget {
  const _InstallSection();

  @override
  Widget build(BuildContext context) => const ElSection(
    id: 'install',
    title: 'Installation',
    description:
        'Command install is available: read this before reaching '
        'for elattar add toggle-group.',
    child: DocsInstallFacts(
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'CLI',
          value: 'elattar add toggle-group',
          description:
              'toggle-group is a registry item, so this resolves it and its '
              'dependencies and copies the source into your project.',
        ),
        DocsInstallFact(
          label: 'Manual: package mode (supported today)',
          value:
              "import 'package:elattar_design_system/elattar_design_system.dart';",
          description:
              'Depend on the package and use ElToggleGroup and '
              'ElToggleGroupItem directly, exactly as this page does.',
        ),
        DocsInstallFact(
          label: 'Manual: source mode (not recommended yet)',
          value:
              'lib/src/components/toggle_group.dart, '
              'lib/src/components/toggle.dart, '
              'lib/src/motion/sliding_pill.dart',
          description:
              'Copying toggle_group.dart alone will not compile: every '
              'item is a ElToggle from toggle.dart, and the selection pill '
              'is ElSlidingPillGroup from sliding_pill.dart. Those in turn '
              'need siblings of their own (see Dependencies below), and no '
              'manifest exists yet to resolve them for you.',
        ),
        DocsInstallFact(
          label: 'Status',
          value: 'Stable, installable through elattar add toggle-group',
          description:
              'Ported and tested against '
              'lib/src/components/toggle_group.dart.',
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

/// shadcn's Usage section: the smallest correct construction, plus the one
/// thing a caller has to decide before writing it, what null means.
class _UsageSection extends StatelessWidget {
  const _UsageSection();

  @override
  Widget build(BuildContext context) {
    return ElSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct example, then the nullable selection every '
          'caller has to make a decision about.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ElPanel(
            label: 'DART',
            note: 'SMALLEST CORRECT EXAMPLE',
            child: DocsSelectableCodeBlock(code: _groupUsageCode),
          ),
          SizedBox(height: el(5)),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: ElWidths.prose),
            child: ElText(
              'onChanged is ValueChanged<int?>: tapping an unselected '
              "option calls it with that option's index, and tapping the "
              'already-selected option calls it with null. selectedIndex '
              'has to accept both: the group never decides on its own '
              'whether "nothing selected" is a state your UI allows, it '
              'only reports the tap. A live specimen of exactly this, '
              'including the moment selectedIndex becomes null, follows:',
              ElType.small,
              color: ElTheme.of(context).mutedForeground,
            ),
          ),
          SizedBox(height: el(3)),
          const _SortControlExample(),
          SizedBox(height: el(5)),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: ElWidths.prose),
            child: ElText(
              'ElToggleGroup has no opinion on what null means to your '
              'screen: it only reports it. Two real policies, both valid:',
              ElType.small,
              color: ElTheme.of(context).mutedForeground,
            ),
          ),
          SizedBox(height: el(3)),
          ElPanel(
            label: 'DART',
            note: 'TWO VALID DESELECTION POLICIES',
            child: DocsSelectableCodeBlock(code: _policyCode),
          ),
        ],
      ),
    );
  }
}

const String _groupUsageCode = '''int? sortIndex = 0;

ElToggleGroup(
  items: const <ElToggleGroupItem>[
    ElToggleGroupItem(label: 'Newest'),
    ElToggleGroupItem(label: 'Price'),
    ElToggleGroupItem(label: 'Popular'),
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
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Same narrow-viewport overflow every live group on this page guards
        // against: see _ToggleGroupPreview above.
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ElToggleGroup(
            key: const ValueKey<String>('toggle-group-usage-specimen'),
            items: const <ElToggleGroupItem>[
              ElToggleGroupItem(label: 'Newest'),
              ElToggleGroupItem(label: 'Price'),
              ElToggleGroupItem(label: 'Popular'),
            ],
            selectedIndex: _sortIndex,
            onChanged: (int? next) => setState(() => _sortIndex = next),
          ),
        ),
        SizedBox(height: el(2)),
        ElText(
          _sortIndex == null
              ? 'Sorting by: none selected'
              : 'Sorting by: ${_labels[_sortIndex!]}',
          ElType.small,
          color: theme.mutedForeground,
        ),
      ],
    );
  }
}

/// shadcn's Composition example: a tree of the widget hierarchy.
/// ElToggleGroup has no ToggleGroupItem widget to assemble by hand: items
/// builds the whole row, and ElSlidingPillGroup's travelling pill is inserted
/// underneath it. What follows is what that single call builds internally.
class _CompositionSection extends StatelessWidget {
  const _CompositionSection();

  @override
  Widget build(BuildContext context) => const ElSection(
    id: 'composition',
    title: 'Composition',
    description:
        'ElToggleGroup has no ToggleGroupItem widget to assemble by hand: '
        "items builds the whole row, and ElSlidingPillGroup's travelling "
        'pill is inserted underneath it. What follows is what that single '
        'call builds internally.',
    child: ElPanel(
      label: 'What ElToggleGroup(items: …) assembles',
      child: DocsSelectableCodeBlock(code: _compositionCode),
    ),
  );
}

const String _compositionCode =
    '''ElSlidingPillGroup(                    // owns the travelling selection pill
  activeIndex: selectedIndex ?? -1,
  gap: ElToggleGroup.gap,
  pill: ElMachineSurface(...),          // theme.primary, ElRadii.pill, ElShadows.chip
  children: <Widget>[
    for (final ElToggleGroupItem item in items)
      ElToggle(                          // one ElToggle per ElToggleGroupItem
        pressed: item == selected,
        inExclusiveGroup: true,          // radio-shaped semantics, not an
                                          // independent on/off switch
        pressedFill: elTransparent,      // gives up its own fill …
        pressedInk: theme.primaryForeground, // … so the pill shows through
        child: item.child ?? Text(item.label),
      ),
  ],
)''';

/// shadcn's Outline example: variant is passed to every item, the same way
/// the reference's root context provider passes it.
class _OutlineSection extends StatelessWidget {
  const _OutlineSection();

  @override
  Widget build(BuildContext context) => const ElSection(
    id: 'outline',
    title: 'Outline',
    description:
        "variant is passed to every item, the same way the reference's "
        'root context provider passes it. It is ElToggleVariant, '
        "ElToggle's own enum: the group declares no variant type of its "
        'own.',
    child: DocsCodeExample(
      title: 'Outline variant',
      preview: _OutlinePreview(),
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(path: 'group_outline_example.dart', code: _outlineCode),
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
  int? _index = 0;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: ElToggleGroup(
      key: const ValueKey<String>('toggle-group-outline-specimen'),
      variant: ElToggleVariant.outline,
      items: const <ElToggleGroupItem>[
        ElToggleGroupItem(label: 'Newest'),
        ElToggleGroupItem(label: 'Price'),
        ElToggleGroupItem(label: 'Popular'),
      ],
      selectedIndex: _index,
      onChanged: (int? next) => setState(() => _index = next),
    ),
  );
}

const String _outlineCode = '''ElToggleGroup(
  variant: ElToggleVariant.outline,
  items: const <ElToggleGroupItem>[
    ElToggleGroupItem(label: 'Newest'),
    ElToggleGroupItem(label: 'Price'),
    ElToggleGroupItem(label: 'Popular'),
  ],
  selectedIndex: sortIndex,
  onChanged: (int? next) => setState(() => sortIndex = next),
)''';

/// shadcn's Size example: size is passed to every item too, sm and lg side by
/// side.
class _SizesSection extends StatelessWidget {
  const _SizesSection();

  @override
  Widget build(BuildContext context) => const ElSection(
    id: 'sizes',
    title: 'Sizes',
    description:
        'size is passed to every item too, and is ElToggleSize, ElToggle\'s '
        'own enum: sm and lg side by side. The travelling pill measures '
        'itself from whatever geometry the items end up with, so it needs '
        'no size of its own.',
    child: DocsCodeExample(
      title: 'Both sizes',
      preview: _SizesPreview(),
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(path: 'group_sizes_example.dart', code: _sizesCode),
      ],
    ),
  );
}

class _SizesPreview extends StatefulWidget {
  const _SizesPreview();

  @override
  State<_SizesPreview> createState() => _SizesPreviewState();
}

class _SizesPreviewState extends State<_SizesPreview> {
  int? _smIndex = 0;
  int? _lgIndex = 0;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: el(6),
    runSpacing: el(4),
    crossAxisAlignment: WrapCrossAlignment.center,
    children: <Widget>[
      // Wrap lays the two groups out on their own runs when both do not fit
      // side by side, but a single group's own Row still neither wraps nor
      // scrolls: each gets the page's established horizontal-scroll
      // mitigation too.
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ElToggleGroup(
          key: const ValueKey<String>('toggle-group-sizes-sm-specimen'),
          size: ElToggleSize.sm,
          items: const <ElToggleGroupItem>[
            ElToggleGroupItem(label: 'Newest'),
            ElToggleGroupItem(label: 'Price'),
            ElToggleGroupItem(label: 'Popular'),
          ],
          selectedIndex: _smIndex,
          onChanged: (int? next) => setState(() => _smIndex = next),
        ),
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ElToggleGroup(
          key: const ValueKey<String>('toggle-group-sizes-lg-specimen'),
          size: ElToggleSize.lg,
          items: const <ElToggleGroupItem>[
            ElToggleGroupItem(label: 'Newest'),
            ElToggleGroupItem(label: 'Price'),
            ElToggleGroupItem(label: 'Popular'),
          ],
          selectedIndex: _lgIndex,
          onChanged: (int? next) => setState(() => _lgIndex = next),
        ),
      ),
    ],
  );
}

const String _sizesCode =
    '''ElToggleGroup(size: ElToggleSize.sm, items: items, selectedIndex: smIndex, onChanged: (int? next) => setState(() => smIndex = next))

ElToggleGroup(size: ElToggleSize.lg, items: items, selectedIndex: lgIndex, onChanged: (int? next) => setState(() => lgIndex = next))''';

/// shadcn's Spacing section, disclosed rather than faked: there is no
/// `spacing` parameter on `ElToggleGroup` at all.
class _SpacingSection extends StatelessWidget {
  const _SpacingSection();

  @override
  Widget build(BuildContext context) => const ElSection(
    id: 'spacing',
    title: 'Spacing',
    description: 'Not ported: ElToggleGroup declares no spacing parameter.',
    child: DocsInstallFacts(
      title: 'What is missing, and what you get instead',
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'The reference prop',
          value: 'spacing',
          description:
              "shadcn's ToggleGroup takes a root spacing prop and its own "
              'changelog records moving its default. spacing={0} is how a '
              'caller asks for connected segments with no gap between '
              'them, the classic joined segmented control.',
        ),
        DocsInstallFact(
          label: 'What this port has',
          value: 'ElToggleGroup.gap, a static getter: 8px, fixed',
          description:
              'The gap between items is ElToggleGroup.gap, read once and '
              'handed to ElSlidingPillGroup. It is a static on the class, '
              'not a constructor parameter: no call site can change it, '
              'and there is no per-instance override anywhere in '
              'toggle_group.dart.',
        ),
        DocsInstallFact(
          label: 'Consequence',
          value: 'Connected segments are not expressible',
          description:
              'A caller who needs spacing={0} cannot get it from this '
              'component. Nothing here approximates it: wrapping the group '
              'in tighter padding changes the outside, not the gaps '
              'between items, and the travelling pill is measured against '
              'the same fixed gap. This section exists so the gap is '
              'recorded, not so it looks solved.',
        ),
      ],
    ),
  );
}

/// shadcn's Vertical section, disclosed rather than faked: there is no
/// `orientation` parameter on `ElToggleGroup` at all.
class _VerticalSection extends StatelessWidget {
  const _VerticalSection();

  @override
  Widget build(BuildContext context) => const ElSection(
    id: 'vertical',
    title: 'Vertical',
    description:
        'Not ported: ElToggleGroup declares no orientation parameter, and '
        'always lays out horizontally.',
    child: DocsInstallFacts(
      title: 'What is missing, and what you get instead',
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'The reference prop',
          value: 'orientation="vertical"',
          description:
              "shadcn's ToggleGroup takes a root orientation prop and "
              'stacks its items into a column when it is set to vertical.',
        ),
        DocsInstallFact(
          label: 'What this port has',
          value: 'A horizontal row only',
          description:
              'ElToggleGroup hands its items to ElSlidingPillGroup, whose '
              'own layout is a Row and whose pill travels along one axis. '
              'Neither takes an orientation, so there is no parameter to '
              'set and no vertical branch to reach.',
        ),
        DocsInstallFact(
          label: 'Consequence',
          value: 'A vertical group is not expressible',
          description:
              'Wrapping ElToggleGroup in a Column does nothing: the Column '
              'holds one group, and that group is still a row. A stacked '
              'exclusive selection needs a different primitive, not this '
              'one with a flag flipped. This section exists so the gap is '
              'recorded, not so it looks solved.',
        ),
      ],
    ),
  );
}

/// shadcn's Disabled example: ElToggleGroupItem.enabled: false disables just
/// that one option; ElToggleGroup wires its onChanged to null for a disabled
/// item, the same as a standalone ElToggle.
class _DisabledSection extends StatelessWidget {
  const _DisabledSection();

  @override
  Widget build(BuildContext context) => const ElSection(
    id: 'disabled',
    title: 'Disabled',
    description:
        'ElToggleGroupItem.enabled: false disables just that one option; '
        'ElToggleGroup wires its onChanged to null for a disabled item, '
        'the same as a standalone ElToggle. There is no group-wide disabled '
        'flag: disable every item to disable the whole control.',
    child: DocsCodeExample(
      title: 'One disabled option',
      preview: _DisabledPreview(),
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(path: 'group_disabled_example.dart', code: _disabledCode),
      ],
    ),
  );
}

class _DisabledPreview extends StatefulWidget {
  const _DisabledPreview();

  @override
  State<_DisabledPreview> createState() => _DisabledPreviewState();
}

class _DisabledPreviewState extends State<_DisabledPreview> {
  int? _index = 0;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: ElToggleGroup(
      key: const ValueKey<String>('toggle-group-disabled-specimen'),
      items: const <ElToggleGroupItem>[
        ElToggleGroupItem(label: 'Newest'),
        ElToggleGroupItem(label: 'Price', enabled: false),
        ElToggleGroupItem(label: 'Popular'),
      ],
      selectedIndex: _index,
      onChanged: (int? next) => setState(() => _index = next),
    ),
  );
}

const String _disabledCode = '''ElToggleGroup(
  items: const <ElToggleGroupItem>[
    ElToggleGroupItem(label: 'Newest'),
    ElToggleGroupItem(label: 'Price', enabled: false),
    ElToggleGroupItem(label: 'Popular'),
  ],
  selectedIndex: sortIndex,
  onChanged: (int? next) => setState(() => sortIndex = next),
)''';

/// shadcn's Custom example: a practical implementation, not a manufactured
/// one the Dart API cannot support. ElToggleGroupItem.child is per-item and
/// optional, so a group can mix icon-and-label rows with bare labels.
class _CustomSection extends StatelessWidget {
  const _CustomSection();

  @override
  Widget build(BuildContext context) => const ElSection(
    id: 'custom',
    title: 'Custom',
    description:
        'ElToggleGroupItem.child is per-item and optional: two options '
        'here supply an icon-and-label row, and the third omits child '
        'entirely and falls back to a bare Text(label). label is still '
        'required on all three: it is what the item announces to a screen '
        'reader either way.',
    child: DocsCodeExample(
      title: 'Heterogeneous group children',
      preview: _CustomPreview(),
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(path: 'group_custom_example.dart', code: _customCode),
      ],
    ),
  );
}

class _CustomPreview extends StatefulWidget {
  const _CustomPreview();

  @override
  State<_CustomPreview> createState() => _CustomPreviewState();
}

class _CustomPreviewState extends State<_CustomPreview> {
  int? _viewIndex = 0;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: ElToggleGroup(
      key: const ValueKey<String>('toggle-group-custom-specimen'),
      items: <ElToggleGroupItem>[
        ElToggleGroupItem(
          label: 'Grid',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElIcon(
                ElIconGlyph.layoutGrid,
                size: ElToggle.iconSizeFor(ElToggleSize.md),
              ),
              SizedBox(width: ElToggle.gap),
              const Text('Grid'),
            ],
          ),
        ),
        ElToggleGroupItem(
          label: 'List',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElIcon(
                ElIconGlyph.rows3,
                size: ElToggle.iconSizeFor(ElToggleSize.md),
              ),
              SizedBox(width: ElToggle.gap),
              const Text('List'),
            ],
          ),
        ),
        const ElToggleGroupItem(label: 'Table'),
      ],
      selectedIndex: _viewIndex,
      onChanged: (int? next) => setState(() => _viewIndex = next),
    ),
  );
}

const String _customCode =
    '''// ElToggleGroupItem.child is optional per item: two options here supply
// an icon-and-label row, and the third omits child and falls back to a
// bare Text(label).
int? viewIndex = 0;

ElToggleGroup(
  items: <ElToggleGroupItem>[
    ElToggleGroupItem(
      label: 'Grid',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ElIcon(
            ElIconGlyph.layoutGrid,
            size: ElToggle.iconSizeFor(ElToggleSize.md),
          ),
          SizedBox(width: ElToggle.gap),
          const Text('Grid'),
        ],
      ),
    ),
    ElToggleGroupItem(
      label: 'List',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ElIcon(
            ElIconGlyph.rows3,
            size: ElToggle.iconSizeFor(ElToggleSize.md),
          ),
          SizedBox(width: ElToggle.gap),
          const Text('List'),
        ],
      ),
    ),
    const ElToggleGroupItem(label: 'Table'),
  ],
  selectedIndex: viewIndex,
  onChanged: (int? next) => setState(() => viewIndex = next),
)''';

/// shadcn's RTL example. ElSlidingPillGroup measures each child's own
/// RenderBox and positions the pill from those measurements, so it reads
/// correctly under Directionality.rtl too.
class _RtlSection extends StatelessWidget {
  const _RtlSection();

  @override
  Widget build(BuildContext context) => const ElSection(
    id: 'rtl',
    title: 'RTL',
    description:
        "ElSlidingPillGroup measures each child's own RenderBox and "
        'positions the pill from those measurements, so it reads correctly '
        'under Directionality.rtl too: the items mirror, and the pill '
        'follows the item it is under.',
    child: DocsCodeExample(
      title: 'RTL',
      preview: _RtlPreview(),
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(path: 'group_rtl_example.dart', code: _rtlCode),
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
  int? _index = 0;

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    // The narrow-viewport mitigation stays inside the Directionality, right
    // where the group is: the Arabic labels are the widest set on this page
    // and were measured overflowing furthest at 390px.
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ElToggleGroup(
        key: const ValueKey<String>('toggle-group-rtl-specimen'),
        items: const <ElToggleGroupItem>[
          ElToggleGroupItem(label: 'الأحدث'),
          ElToggleGroupItem(label: 'السعر'),
          ElToggleGroupItem(label: 'الأكثر شيوعا'),
        ],
        selectedIndex: _index,
        onChanged: (int? next) => setState(() => _index = next),
      ),
    ),
  );
}

const String _rtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: ElToggleGroup(
    items: const <ElToggleGroupItem>[
      ElToggleGroupItem(label: 'الأحدث'),
      ElToggleGroupItem(label: 'السعر'),
      ElToggleGroupItem(label: 'الأكثر شيوعا'),
    ],
    selectedIndex: sortIndex,
    onChanged: (int? next) => setState(() => sortIndex = next),
  ),
)''';

/// shadcn's own API Reference just links out to Base UI's docs; ours renders
/// real prop tables, an addition their page does not have. One table per
/// class `toggle_group.dart` declares, plus one for its single static.
/// Nothing from `toggle.dart` appears here: ElToggle, ElToggleVariant and
/// ElToggleSize have their own page and their own tables.
class _ApiSection extends StatelessWidget {
  const _ApiSection();

  @override
  Widget build(BuildContext context) => ElSection(
    id: 'api',
    title: 'API Reference',
    description:
        'Every constructor parameter ElToggleGroup and ElToggleGroupItem '
        'declare, and the group\'s one static: one table each, read off '
        'lib/src/components/toggle_group.dart.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        KeyedSubtree(
          key: docsAnchorKey('api-eltogglegroup'),
          child: const DocsApiTable(
            title: 'ElToggleGroup',
            facts: _groupApiFacts,
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-eltogglegroup-static'),
          child: const DocsApiTable(
            title: 'ElToggleGroup static helpers',
            facts: _groupStaticFacts,
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-eltogglegroupitem'),
          child: const DocsApiTable(
            title: 'ElToggleGroupItem',
            facts: _itemApiFacts,
          ),
        ),
      ],
    ),
  );
}

const List<DocsApiFact> _groupApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'items',
    type: 'List<ElToggleGroupItem>',
    description:
        'Required. The options, in paint order. One ElToggle is built per '
        'entry, and the index a caller reads back is this list\'s index.',
  ),
  DocsApiFact(
    name: 'selectedIndex',
    type: 'int?',
    description:
        'Required, and nullable: null is a legal value, not an omission. '
        'Which option is selected, or null for none, the state the '
        'travelling pill reads. Null or out-of-range is what '
        'ElSlidingPillGroup treats as deselected: the pill fades out and '
        'stays parked where it last was.',
  ),
  DocsApiFact(
    name: 'onChanged',
    type: 'ValueChanged<int?>',
    description:
        'Required, and NOT itself nullable: a group always needs a way to '
        'hear both an index and a clear. Called with the tapped index, or '
        'null when the tapped option was already selected, the '
        'type="single" deselect semantics of the reference.',
  ),
  DocsApiFact(
    name: 'variant',
    type: 'ElToggleVariant',
    description:
        'Optional. Defaults to ElToggleVariant.standard. Forwarded '
        "unchanged to every item. ElToggle's own enum, documented on the "
        'toggle page.',
  ),
  DocsApiFact(
    name: 'size',
    type: 'ElToggleSize',
    description:
        'Optional. Defaults to ElToggleSize.md. Forwarded unchanged to '
        "every item. ElToggle's own enum, documented on the toggle page.",
  ),
  DocsApiFact(
    name: 'label',
    type: 'String?',
    description:
        "Optional. Defaults to null, which emits no extra container "
        "semantics node at all. Non-null wraps the group in "
        'Semantics(container: true, label: …): supply one when nothing '
        'else on the screen names the group.',
  ),
];

const List<DocsApiFact> _groupStaticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ElToggleGroup.gap',
    type: 'static double',
    description:
        'A getter, not a per-size function and not a constructor '
        'parameter: 8px between items, on every size and every variant. '
        "Handed straight to ElSlidingPillGroup, so it is also the gap the "
        "travelling pill's own geometry is measured against. See Spacing "
        'above for what this being fixed rules out.',
  ),
];

const List<DocsApiFact> _itemApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'label',
    type: 'String',
    description:
        "Required. The option's name: what a screen reader announces, and "
        'what the item renders when child is null.',
  ),
  DocsApiFact(
    name: 'child',
    type: 'Widget?',
    description:
        'Optional. Defaults to null, which renders label as a bare Text in '
        "the toggle's own resolved style. Non-null replaces the rendered "
        'content only: label still supplies the accessible name.',
  ),
  DocsApiFact(
    name: 'enabled',
    type: 'bool',
    description:
        'Optional. Defaults to true. false makes the group pass a null '
        "onChanged to this item's ElToggle, which is the only disabled "
        'switch a toggle has: 50% opacity, no hit-testing, no tab stop.',
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
          'Read off toggle_group.dart and the ElToggle skin it configures. '
          'Pressed, Loading, Empty, Error and Success are omitted: reasons '
          'follow the table.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const DocsStateMatrix(
            facts: <DocsStateFact>[
              DocsStateFact(
                state: 'Rest (unselected item)',
                treatment:
                    'Each item is a ElToggle with pressed: false. '
                    'standard: no fill, no border. outline: a 1px '
                    'theme.input border. Ink is theme.foreground.',
                userSignal:
                    'A row of unfilled options with the pill sitting under '
                    'whichever one is selected.',
              ),
              DocsStateFact(
                state: 'Hover',
                treatment:
                    'theme.muted fill on the hovered item, on both '
                    'variants: the item\'s own hover, unchanged by the '
                    'group.',
                userSignal:
                    'A grey wash appears under the pointer; the cursor '
                    'becomes a click cursor.',
              ),
              DocsStateFact(
                state: 'Selected',
                treatment:
                    'The group passes pressedFill: transparent and '
                    'pressedInk: theme.primaryForeground, so the item '
                    "gives up its own fill and ElSlidingPillGroup's single "
                    'theme.primary pill, already travelling underneath it, '
                    'shows through.',
                userSignal:
                    'White-on-blue ink over the travelling pill: the one '
                    'place selection reads as the brand colour in this '
                    'family.',
              ),
              DocsStateFact(
                state: 'Nothing selected',
                treatment:
                    'selectedIndex: null reaches ElSlidingPillGroup as '
                    'activeIndex: -1, its deselected sentinel. The pill '
                    'fades out and stays parked where it last was rather '
                    'than travelling off the end.',
                userSignal:
                    'Every option reads as unselected, and the pill is '
                    'simply gone.',
              ),
              DocsStateFact(
                state: 'Focus-visible',
                treatment:
                    'Per item, not per group: the focused item paints a '
                    'ring at theme.ring, 50% alpha, and on outline its '
                    'border swaps to theme.ring too. Every item is its own '
                    'tab stop (see Accessibility).',
                userSignal:
                    'A ring around one option, appearing only after '
                    'keyboard focus.',
              ),
              DocsStateFact(
                state: 'Disabled (per item)',
                treatment:
                    'ElToggleGroupItem.enabled: false makes the group pass '
                    'a null onChanged to that item: 50% opacity, and an '
                    'IgnorePointer that removes it from hit-testing, hover '
                    'tracking and the tab order together. The rest of the '
                    'group stays live.',
                userSignal: 'One dimmed, inert option among operable ones.',
              ),
              DocsStateFact(
                state: 'Reduced motion',
                treatment:
                    "The item's fill/ink/border/ring tween chain and "
                    "ElSlidingPillGroup's own travel and jelly squash all "
                    'resolve through elAnimationDuration, which reduced '
                    'motion shortens toward zero.',
                userSignal:
                    'The pill appears at its new position instead of '
                    'travelling to it, with no colour transition to sit '
                    'through.',
              ),
            ],
          ),
          SizedBox(height: el(3)),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: ElWidths.prose),
            child: ElText(
              'Pressed is not a row: an item is a ElToggle, whose class '
              'list carries no active-state rule and no press-motion '
              'utility, so nothing happens between pointer-down and '
              'pointer-up. Loading and Empty are not rows: this is a '
              'synchronous primitive with no async operation, and an empty '
              'items list simply renders nothing rather than an empty '
              'state. Error is not a row: aria-invalid is never set on '
              'this control anywhere in the reference, and neither '
              'ElToggleGroup nor ElToggleGroupItem exposes an invalid '
              'parameter. Success is not a row: the component defines no '
              'success semantics of its own.',
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
/// non-colour signal, error wiring, and the one known divergence from the
/// reference's roving focus.
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
          label: 'Semantic role (per item)',
          value: 'Semantics(button:, selected:, inMutuallyExclusiveGroup:)',
          description:
              'The group sets inExclusiveGroup: true on every item it '
              'builds, so each announces as a choice among others '
              '(selected: pressed, inMutuallyExclusiveGroup: true) with '
              'toggled left null, rather than as an independent on/off '
              'switch.',
        ),
        DocsInstallFact(
          label: 'Semantic role (the group)',
          value: 'Semantics(container: true, label: …), only when label is set',
          description:
              'With label null, the default, ElToggleGroup emits no '
              'container node at all: the items are the only semantics '
              'present. Supply label when nothing else on the screen names '
              'the group.',
        ),
        DocsInstallFact(
          label: 'Label association',
          value: 'ElToggleGroupItem.label',
          description:
              "Passed straight through as the ElToggle's own label for "
              "every item, which overrides rather than joins the child's "
              'content-derived name. That is why label is required on the '
              'item even when child renders its own text.',
        ),
        DocsInstallFact(
          label: 'Keyboard activation',
          value: 'Enter, numpad Enter, Space, per item',
          description:
              'Inherited from ElToggle, hand-wired through '
              'Focus.onKeyEvent. Activating the already-selected item '
              'clears the selection, exactly as tapping it does.',
        ),
        DocsInstallFact(
          label: 'Known divergence',
          value: 'Roving focus is not ported',
          description:
              "The reference wraps a toggle group's items in a "
              'RovingFocusGroup: one Tab stop for the whole group, arrow '
              "keys to move within it. Flutter's default traversal gives "
              'every item its own Tab stop instead. toggle_group.dart '
              'states this divergence rather than approximating half of '
              'the reference behaviour, so a three-item group costs three '
              'Tab presses to cross.',
        ),
        DocsInstallFact(
          label: 'Touch target',
          value: 'Exactly each item\'s visual box: no cushion',
          description:
              '28x28 / 32x32 / 36x36 per item depending on size, plus 8px '
              'of dead gap between items. Every size sits below the '
              "system's 44px touch-target floor: recorded rather than "
              'corrected, because it is what the source renders.',
        ),
        DocsInstallFact(
          label: 'Non-colour signal',
          value: 'The selected semantics flag itself',
          description:
              'Visually the selection is the pill, a colour and a '
              'position; there is no drawn glyph to fall back on. A screen '
              'reader is told regardless, through the selected flag on the '
              'item.',
        ),
        DocsInstallFact(
          label: 'Error wiring',
          value: 'N/A: no invalid parameter exists',
          description:
              'Neither ElToggleGroup nor ElToggleGroupItem declares an '
              'invalid/aria-invalid path; the source states aria-invalid is '
              'never set on this control anywhere in the reference. There '
              'is nothing to wire.',
        ),
        DocsInstallFact(
          label: 'Screen-reader announcements',
          value: 'No live region',
          description:
              'Selection changes are exposed purely through the per-item '
              'semantics flags above; no extra announcement is authored, '
              'and the pill\'s travel is not narrated.',
        ),
      ],
    ),
  );
}

/// Layout, breakpoints, and platform behavior. The narrow-viewport overflow
/// this page mitigates eight times over is the whole substance of this
/// section.
class _ResponsiveSection extends StatelessWidget {
  const _ResponsiveSection();

  @override
  Widget build(BuildContext context) => ElSection(
    id: 'responsive',
    title: 'Responsive',
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: ElWidths.prose),
      child: ElText(
        'ElToggleGroup has no breakpoints of its own: it is a Row of '
        'fixed-height items plus a travelling pill, sized to its own '
        'content, and nothing in toggle_group.dart reads a viewport width. '
        'That is the thing to plan for, not a feature: ElSlidingPillGroup\'s '
        'internal Row neither wraps nor scrolls, so a group whose items '
        'want more width than the column has WILL overflow rather than '
        'reflow. Three of the sort segments below already do it at a 390px '
        'viewport, and the Arabic-label RTL group overflows furthest. '
        'Every live group on this page is therefore wrapped in '
        'SingleChildScrollView(scrollDirection: Axis.horizontal), eight of '
        'them, which is the mitigation a real filter bar needs too. Wrapping '
        'the group in a Wrap does not help: a Wrap can only move whole '
        'groups onto new runs, never split one group across two lines, '
        'because the pill is measured against a single continuous row. '
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
          value: toggleGroupDoc.sourcePath,
          description:
              'The authoritative implementation of ElToggleGroup and '
              'ElToggleGroupItem: one file.',
        ),
        const DocsInstallFact(
          label: 'Flutter imports',
          value: 'package:flutter/widgets.dart',
          description:
              'The only Flutter import: no services.dart here, because '
              'the key handling lives in ElToggle, one layer down.',
        ),
        DocsInstallFact(
          label: 'Local file dependencies',
          value:
              '$toggleItemSourcePath, $slidingPillSourcePath, '
              'effects/machine_surface.dart',
          description:
              'toggle_group.dart imports toggle.dart directly: every item '
              'IS a ElToggle underneath, configured with pressedFill, '
              'pressedInk and inExclusiveGroup. It imports '
              'motion/sliding_pill.dart for ElSlidingPillGroup, the '
              'travelling-pill machinery it shares with ElTabs, ElSidebar '
              'and IconSwap, and effects/machine_surface.dart to paint the '
              'pill itself. None are copyable in isolation: see '
              'Installation.',
        ),
        const DocsInstallFact(
          label: 'Foundation dependencies',
          value:
              'foundation/colors.dart, foundation/shadows.dart, '
              'foundation/spacing.dart, foundation/theme.dart, '
              'theme_scope.dart',
          description:
              'Token sources: the transparent-colour constant the selected '
              'item is filled with, ElShadows.chip for the pill, the el() '
              'spacing scale and ElRadii.pill, and the live theme. Note '
              'what is absent next to toggle.dart\'s own list: no '
              'typography.dart and no motion.dart, because the item '
              'resolves its own text style and its own timing.',
        ),
        DocsInstallFact(
          label: 'Exports',
          value: toggleGroupDoc.exports.join(', '),
          description:
              'The public symbols this component makes available. '
              'ElToggleVariant and ElToggleSize are toggle.dart\'s exports, '
              'documented on the toggle page.',
        ),
        const DocsInstallFact(
          label: 'Assets',
          value: 'none',
          description:
              'The pill, the fills and the borders are plain box '
              'decoration: no image and no icon-font glyph of its own. An '
              'icon supplied through ElToggleGroupItem.child brings its own '
              'geometry from icon_paths.dart, not an asset file.',
        ),
        const DocsInstallFact(
          label: 'Fonts',
          value: 'none',
          description:
              'The group renders no text of its own: an item falls back to '
              "a bare Text, which inherits the DefaultTextStyle ElToggle "
              'installs.',
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

/// How colour and motion resolve, and the one blue selection surface this
/// component paints.
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
          label: 'Pill fill',
          value: 'theme.primary',
          description:
              'The one blue selection surface in this family. Read live '
              'off ElTheme.of(context) at build time, so flipping the '
              'theme controller re-resolves it on the next frame.',
        ),
        DocsInstallFact(
          label: 'Pill shape and elevation',
          value: 'ElRadii.pill, ElShadows.chip',
          description:
              "A stadium over the item's own rounded rect, wearing the "
              "chip spec's inner rim and inner shade. Always ElRadii.pill "
              'regardless of item size: a documented drift in '
              "toggle_group.dart's own header, since the item underneath "
              'is ElRadii.lg or ElRadii.md.',
        ),
        DocsInstallFact(
          label: 'Selected item fill and ink',
          value: 'elTransparent, theme.primaryForeground',
          description:
              'Passed down as pressedFill and pressedInk. The item gives '
              'up the theme.muted fill it would paint on its own so the '
              'pill shows through, and flips to primaryForeground ink '
              'because what is behind it is now theme.primary.',
        ),
        DocsInstallFact(
          label: 'Unselected item colours',
          value: 'Inherited from ElToggle, unchanged',
          description:
              'transparent at rest, theme.muted on hover, theme.input or '
              'theme.ring for an outline border, theme.foreground ink. The '
              'group overrides none of them: see the toggle page.',
        ),
        DocsInstallFact(
          label: 'Gap',
          value: 'ElToggleGroup.gap, 8px',
          description:
              'Fixed, and not themeable or overridable: see Spacing above.',
        ),
        DocsInstallFact(
          label: 'Motion',
          value: 'ElSlidingPillGroup: ElDurations.base, ElCurves.spring',
          description:
              "The pill's travel, plus a jelly squash on ElDurations."
              'animJelly, all resolved through elAnimationDuration so '
              'reduced motion shortens or removes them automatically. The '
              "item's own colour legs run on ElDurations.transitionDefault "
              'and ElCurves.out instead, one layer down.',
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
          value: toggleGroupDoc.sourcePath,
          description:
              'Authoritative implementation of ElToggleGroup and '
              'ElToggleGroupItem: the truth this page was written from.',
        ),
        const DocsInstallFact(
          label: 'Item source',
          value: toggleItemSourcePath,
          description:
              'ElToggle, ElToggleVariant and ElToggleSize: every item is '
              'one of these, and both enums belong to it. Documented on '
              'the toggle page.',
        ),
        const DocsInstallFact(
          label: 'Shared machinery',
          value: slidingPillSourcePath,
          description:
              'ElSlidingPillGroup: the travelling-pill engine, shared with '
              'ElTabs, ElSidebar and IconSwap, and documented on their own '
              'component pages.',
        ),
        const DocsInstallFact(
          label: 'Package tests',
          value: 'test/components_test.dart',
          description:
              'The ElToggleGroup group within that file covers selection, '
              'deselection and per-item disabling in the package itself; '
              'there is no dedicated toggle_group_test.dart in the package '
              'yet.',
        ),
        const DocsInstallFact(
          label: 'Docs test',
          value: 'example/test/components_docs/toggle_group_test.dart',
          description:
              'Covers this page: the section order, API completeness for '
              'both classes and the one static, every live group specimen '
              'including the deselect-to-null path, the two not-ported '
              'disclosures, and both themes at two viewport widths.',
        ),
        const DocsInstallFact(
          label: 'Edit these docs',
          value: 'example/lib/components_docs/toggle_group/page.dart',
          description: 'This file.',
        ),
        const DocsInstallFact(
          label: 'Related',
          value: 'example/lib/components_docs/toggle/page.dart',
          description:
              'ElToggle on its own: the two-state control every item here '
              'is built from, and the page this one split off from.',
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
