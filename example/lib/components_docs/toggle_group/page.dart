/// Public documentation page for the `toggle-group` component.
///
/// **Re-housed onto the documentation kit.** This page used to be a
/// hand-composed `_ToggleGroupArticle` built from `kit.dart`'s `Section`
/// (see `example/lib/components_docs/button/page.dart`'s own library doc for
/// the house shape every page is being moved onto). Every specimen and every
/// code string below is the same one the old page rendered; what moved is
/// only where the content lives: a `ComponentDocSpec` declaration plus a
/// ten-line widget, `DocsSection`/`DocsDisclosure` instead of `Section`,
/// and the eight fixed disclosures in the house order (API Reference,
/// States, Accessibility, Keyboard, Responsive, Dependencies, Theming,
/// Source) instead of the old page's own six.
///
/// **Usage keeps its live specimen.** Unlike the button page's own Usage
/// (a bare `SnippetSection`), this component's Usage section always carried
/// a second, interactive half — the nullable-selection "sort control" demo,
/// proving the deselect-to-null contract the prose above it describes.
/// `DocsPageSection` is sealed, not typed per title, so nothing stops Usage
/// from being a `ShowcaseSection` here instead: the demo (keyed
/// `toggle-group-usage-specimen`, unchanged) and both code samples move
/// across together rather than dropping the specimen to fit a shape that
/// does not suit this component.
///
/// **Spacing and Vertical became disclosures.** Neither carries a live
/// specimen — they are "here is what shadcn's own prop does and why this
/// port has no equivalent" panels — so each is a `DisclosureSection` in the
/// middle of the section list, honestly disclosing a gap rather than forcing
/// a fake demo into a `ShowcaseSection`.
///
/// **One real addition: Keyboard.** The old page's Accessibility panel
/// already named the one real keyboard divergence (no `RovingFocusGroup`);
/// the new Keyboard disclosure below restates the activation and traversal
/// facts on their own, matching the split the button and toggle pages both
/// made between their own Accessibility and Keyboard sections.
///
/// `toggleGroupDoc` (from `meta.dart`) is the data source, not
/// `componentDoc('toggle-group')`.
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
/// not `const`: `InstallSection.command` reads `toggleGroupDoc.command`, a
/// computed getter, not a constant expression.
final ComponentDocSpec toggleGroupDocSpec = ComponentDocSpec(
  name: 'toggle-group',
  title: 'Toggle group',
  description: toggleGroupDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'One selection at most, over a single travelling pill. Tap a '
          'different option to move the selection; tap the selected option '
          'again to clear it.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'Command install is available: read this before reaching for '
          'elattar add toggle-group.',
      command: toggleGroupDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/src/components/ui/toggle_group.dart',
          title: 'Manual: source mode (not recommended yet)',
          description:
              'Copying toggle_group.dart alone will not compile: every '
              'item is a Toggle from toggle.dart, and the selection pill '
              'is ActiveIndicator from active_indicator.dart. Those in turn '
              'need siblings of their own (see Dependencies below), and no '
              'manifest exists yet to resolve them for you. Package mode — '
              'depending on the package and using ToggleGroup and '
              'ToggleGroupItem directly, exactly as this page does — is '
              'supported today.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Package mode: depend on the package and use ToggleGroup\n'
              '// directly. Source mode has no manifest yet.',
        ),
      ],
    ),
    ShowcaseSection(
      id: 'usage',
      title: 'Usage',
      description:
          'onChanged is ValueChanged<int?>: tapping an unselected option '
          "calls it with that option's index, and tapping the "
          'already-selected option calls it with null. selectedIndex has '
          'to accept both: the group never decides on its own whether '
          '"nothing selected" is a state your UI allows, it only reports '
          'the tap. ToggleGroup has no opinion on what null means to '
          'your screen beyond that: it only reports it — the two policies '
          'below are both valid.',
      specimen: _UsageSpecimen(),
      code: _usageCode,
      label: 'Usage specimen view',
    ),
    SnippetSection(
      id: 'composition',
      title: 'Composition',
      description:
          'ToggleGroup has no ToggleGroupItem widget to assemble by '
          'hand: items builds the whole row, and ActiveIndicator\'s own '
          'travelling pill is inserted underneath it. What follows is what '
          'that single call builds internally.',
      code: _compositionCode,
    ),
    ShowcaseSection(
      id: 'outline',
      title: 'Outline',
      description:
          "variant is passed to every item, the same way the reference's "
          'root context provider passes it. It is ToggleVariant, '
          "Toggle's own enum: the group declares no variant type of its "
          'own.',
      specimen: _OutlineSpecimen(),
      code: _outlineCode,
      label: 'Outline specimen view',
    ),
    ShowcaseSection(
      id: 'sizes',
      title: 'Sizes',
      description:
          'size is passed to every item too, and is ToggleSize, '
          "Toggle's own enum: sm and lg side by side. The travelling "
          'pill measures itself from whatever geometry the items end up '
          'with, so it needs no size of its own.',
      specimen: _SizesSpecimen(),
      code: _sizesCode,
      label: 'Sizes specimen view',
    ),
    DisclosureSection(
      id: 'spacing',
      title: 'Spacing',
      description: 'Not ported: ToggleGroup declares no spacing parameter.',
      child: const DocsInstallFacts(
        title: 'What is missing, and what you get instead',
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'The reference prop',
            value: 'spacing',
            description:
                "shadcn's ToggleGroup takes a root spacing prop and its own "
                'changelog records moving its default. spacing={0} is how '
                'a caller asks for connected segments with no gap between '
                'them, the classic joined segmented control.',
          ),
          DocsInstallFact(
            label: 'What this port has',
            value: 'ToggleGroup.gap, a static getter: 8px, fixed',
            description:
                'The gap between items is ToggleGroup.gap, read once '
                'and handed to ActiveIndicator. It is a static on the '
                'class, not a constructor parameter: no call site can '
                'change it, and there is no per-instance override anywhere '
                'in toggle_group.dart.',
          ),
          DocsInstallFact(
            label: 'Consequence',
            value: 'Connected segments are not expressible',
            description:
                'A caller who needs spacing={0} cannot get it from this '
                'component. Nothing here approximates it: wrapping the '
                'group in tighter padding changes the outside, not the '
                'gaps between items, and the travelling pill is measured '
                'against the same fixed gap. This section exists so the '
                'gap is recorded, not so it looks solved.',
          ),
        ],
      ),
    ),
    DisclosureSection(
      id: 'vertical',
      title: 'Vertical',
      description:
          'Not ported: ToggleGroup declares no orientation parameter, and '
          'always lays out horizontally.',
      child: const DocsInstallFacts(
        title: 'What is missing, and what you get instead',
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'The reference prop',
            value: 'orientation="vertical"',
            description:
                "shadcn's ToggleGroup takes a root orientation prop and "
                'stacks its items into a column when it is set to '
                'vertical.',
          ),
          DocsInstallFact(
            label: 'What this port has',
            value: 'A horizontal row only',
            description:
                'ToggleGroup hands its items to ActiveIndicator, '
                "whose own layout is a Row and whose pill travels along "
                'one axis. Neither takes an orientation, so there is no '
                'parameter to set and no vertical branch to reach.',
          ),
          DocsInstallFact(
            label: 'Consequence',
            value: 'A vertical group is not expressible',
            description:
                'Wrapping ToggleGroup in a Column does nothing: the '
                'Column holds one group, and that group is still a row. A '
                'stacked exclusive selection needs a different primitive, '
                'not this one with a flag flipped. This section exists so '
                'the gap is recorded, not so it looks solved.',
          ),
        ],
      ),
    ),
    ShowcaseSection(
      id: 'disabled',
      title: 'Disabled',
      description:
          'ToggleGroupItem.enabled: false disables just that one option; '
          'ToggleGroup wires its onChanged to null for a disabled item, '
          'the same as a standalone Toggle. There is no group-wide '
          'disabled flag: disable every item to disable the whole control.',
      specimen: _DisabledSpecimen(),
      code: _disabledCode,
      label: 'Disabled specimen view',
    ),
    ShowcaseSection(
      id: 'custom',
      title: 'Custom',
      description:
          'ToggleGroupItem.child is per-item and optional: two options '
          'here supply an icon-and-label row, and the third omits child '
          'entirely and falls back to a bare Text(label). label is still '
          'required on all three: it is what the item announces to a '
          'screen reader either way.',
      specimen: _CustomSpecimen(),
      code: _customCode,
      label: 'Custom specimen view',
    ),
    ShowcaseSection(
      id: 'rtl',
      title: 'RTL',
      description:
          "ActiveIndicator measures each child's own RenderBox and "
          'positions the pill from those measurements, so it reads '
          'correctly under Directionality.rtl too: the items mirror, and '
          'the pill follows the item it is under.',
      specimen: _RtlSpecimen(),
      code: _rtlCode,
      label: 'RTL specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter ToggleGroup and ToggleGroupItem '
          'declare, and the group\'s one static: one table each, read off '
          'lib/src/components/ui/toggle_group.dart.',
      child: _ApiReferenceContent(),
      children: <DocsTocEntry>[
        DocsTocEntry(title: 'ToggleGroup', anchor: 'api-eltogglegroup'),
        DocsTocEntry(
          title: 'ToggleGroup static helpers',
          anchor: 'api-eltogglegroup-static',
        ),
        DocsTocEntry(title: 'ToggleGroupItem', anchor: 'api-eltogglegroupitem'),
      ],
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Read off toggle_group.dart and the Toggle skin it configures. '
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
            value: toggleGroupDoc.sourcePath,
            description:
                'Authoritative implementation of ToggleGroup and '
                'ToggleGroupItem: the truth this page was written from.',
          ),
          const DocsInstallFact(
            label: 'Item source',
            value: toggleItemSourcePath,
            description:
                'Toggle, ToggleVariant and ToggleSize: every item is '
                'one of these, and both enums belong to it. Documented on '
                'the toggle page.',
          ),
          const DocsInstallFact(
            label: 'Shared machinery',
            value: slidingPillSourcePath,
            description:
                'ActiveIndicator: the travelling-pill engine, shared '
                'with Tabs, Sidebar and IconSwap, and documented on '
                'their own component pages.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/components_test.dart',
            description:
                'The ToggleGroup group within that file covers '
                'selection, deselection and per-item disabling in the '
                'package itself; there is no dedicated '
                'toggle_group_test.dart in the package yet.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/toggle_group_test.dart',
            description:
                'Covers this page: the section order, API completeness for '
                'both classes and the one static, every live group '
                'specimen including the deselect-to-null path, the two '
                'not-ported disclosures, and both themes at two viewport '
                'widths.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/toggle_group/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class ToggleGroupDocPage extends StatelessWidget {
  const ToggleGroupDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: toggleGroupDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: toggleGroupDoc.title,
      description: toggleGroupDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Toggle group'),
    ],
    toc: toggleGroupDocSpec.toc,
    previous: const DocsPageLink(title: 'Toggle', route: '/components/toggle'),
    next: const DocsPageLink(title: 'Tooltip', route: '/components/tooltip'),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('toggle-group-doc-article'),
      child: ComponentDocPage(spec: toggleGroupDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */
// ActiveIndicator's internal Row neither wraps nor scrolls, so every live
// group specimen below carries the same SingleChildScrollView(scrollDirection:
// Axis.horizontal) mitigation the old page's own library doc named.

class _PreviewSpecimen extends StatefulWidget {
  const _PreviewSpecimen();

  @override
  State<_PreviewSpecimen> createState() => _PreviewSpecimenState();
}

class _PreviewSpecimenState extends State<_PreviewSpecimen> {
  static const List<String> _labels = <String>['Newest', 'Price', 'Popular'];

  int? _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ToggleGroup(
            key: const ValueKey<String>('toggle-group-live-specimen'),
            items: const <ToggleGroupItem>[
              ToggleGroupItem(label: 'Newest'),
              ToggleGroupItem(label: 'Price'),
              ToggleGroupItem(label: 'Popular'),
            ],
            selectedIndex: _selectedIndex,
            onChanged: (int? next) => setState(() => _selectedIndex = next),
          ),
        ),
        SizedBox(height: space(3)),
        StyledText(
          _selectedIndex == null
              ? 'selectedIndex: null: tap any option to select it.'
              : 'selectedIndex: $_selectedIndex: tap '
                    '"${_labels[_selectedIndex!]}" again to deselect it.',
          TextStyles.small,
          color: theme.mutedForeground,
        ),
        SizedBox(height: space(3)),
        StyledText(
          'The pill is theme.primary; the fading of "nothing selected" is '
          'what ActiveIndicator renders whenever selectedIndex is null.',
          TextStyles.small,
          color: theme.mutedForeground,
        ),
      ],
    );
  }
}

const String _previewCode = '''int? sortIndex = 0;

ToggleGroup(
  items: const <ToggleGroupItem>[
    ToggleGroupItem(label: 'Newest'),
    ToggleGroupItem(label: 'Price'),
    ToggleGroupItem(label: 'Popular'),
  ],
  selectedIndex: sortIndex,
  // Receives the tapped index, or null when the tap re-selected the
  // option that was already active.
  onChanged: (int? next) => setState(() => sortIndex = next),
)''';

/// The Usage section's live "sort control": the same nullable contract as
/// [_PreviewSpecimen], composed a second time with its own state so the
/// section that explains the contract in prose also proves it live.
class _UsageSpecimen extends StatefulWidget {
  const _UsageSpecimen();

  @override
  State<_UsageSpecimen> createState() => _UsageSpecimenState();
}

class _UsageSpecimenState extends State<_UsageSpecimen> {
  static const List<String> _labels = <String>['Newest', 'Price', 'Popular'];

  int? _sortIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ToggleGroup(
            key: const ValueKey<String>('toggle-group-usage-specimen'),
            items: const <ToggleGroupItem>[
              ToggleGroupItem(label: 'Newest'),
              ToggleGroupItem(label: 'Price'),
              ToggleGroupItem(label: 'Popular'),
            ],
            selectedIndex: _sortIndex,
            onChanged: (int? next) => setState(() => _sortIndex = next),
          ),
        ),
        SizedBox(height: space(2)),
        StyledText(
          _sortIndex == null
              ? 'Sorting by: none selected'
              : 'Sorting by: ${_labels[_sortIndex!]}',
          TextStyles.small,
          color: theme.mutedForeground,
        ),
      ],
    );
  }
}

const String _usageCode = '''int? sortIndex = 0;

ToggleGroup(
  items: const <ToggleGroupItem>[
    ToggleGroupItem(label: 'Newest'),
    ToggleGroupItem(label: 'Price'),
    ToggleGroupItem(label: 'Popular'),
  ],
  selectedIndex: sortIndex,
  onChanged: (int? next) => setState(() => sortIndex = next),
)

// ToggleGroup has no opinion on what null means to your screen: it only
// reports it. Two real policies, both valid:

// 1. Keep the null: "nothing selected" is a real, distinct state.
onChanged: (int? next) => setState(() => sortIndex = next),

// 2. Coerce it: never let the group end up with nothing selected. A
// family/platform filter bar might make this choice instead:
onFamilyChanged: (int? index) => setState(() => familyIndex = index ?? 0),''';

const String _compositionCode =
    '''ActiveIndicator(                    // owns the travelling selection pill
  activeIndex: selectedIndex ?? -1,
  gap: ToggleGroup.gap,
  indicator: Surface(...),          // theme.primary, Radii.full, Shadows.compactControl
  children: <Widget>[
    for (final ToggleGroupItem item in items)
      Toggle(                          // one Toggle per ToggleGroupItem
        pressed: item == selected,
        inExclusiveGroup: true,          // radio-shaped semantics, not an
                                          // independent on/off switch
        pressedFill: transparent,      // gives up its own fill …
        pressedInk: theme.primaryForeground, // … so the pill shows through
        child: item.child ?? Text(item.label),
      ),
  ],
)''';

class _OutlineSpecimen extends StatefulWidget {
  const _OutlineSpecimen();

  @override
  State<_OutlineSpecimen> createState() => _OutlineSpecimenState();
}

class _OutlineSpecimenState extends State<_OutlineSpecimen> {
  int? _index = 0;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: ToggleGroup(
      key: const ValueKey<String>('toggle-group-outline-specimen'),
      variant: ToggleVariant.outline,
      items: const <ToggleGroupItem>[
        ToggleGroupItem(label: 'Newest'),
        ToggleGroupItem(label: 'Price'),
        ToggleGroupItem(label: 'Popular'),
      ],
      selectedIndex: _index,
      onChanged: (int? next) => setState(() => _index = next),
    ),
  );
}

const String _outlineCode = '''ToggleGroup(
  variant: ToggleVariant.outline,
  items: const <ToggleGroupItem>[
    ToggleGroupItem(label: 'Newest'),
    ToggleGroupItem(label: 'Price'),
    ToggleGroupItem(label: 'Popular'),
  ],
  selectedIndex: sortIndex,
  onChanged: (int? next) => setState(() => sortIndex = next),
)''';

class _SizesSpecimen extends StatefulWidget {
  const _SizesSpecimen();

  @override
  State<_SizesSpecimen> createState() => _SizesSpecimenState();
}

class _SizesSpecimenState extends State<_SizesSpecimen> {
  int? _smIndex = 0;
  int? _lgIndex = 0;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: space(6),
    runSpacing: space(4),
    crossAxisAlignment: WrapCrossAlignment.center,
    children: <Widget>[
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ToggleGroup(
          key: const ValueKey<String>('toggle-group-sizes-sm-specimen'),
          size: ToggleSize.sm,
          items: const <ToggleGroupItem>[
            ToggleGroupItem(label: 'Newest'),
            ToggleGroupItem(label: 'Price'),
            ToggleGroupItem(label: 'Popular'),
          ],
          selectedIndex: _smIndex,
          onChanged: (int? next) => setState(() => _smIndex = next),
        ),
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ToggleGroup(
          key: const ValueKey<String>('toggle-group-sizes-lg-specimen'),
          size: ToggleSize.lg,
          items: const <ToggleGroupItem>[
            ToggleGroupItem(label: 'Newest'),
            ToggleGroupItem(label: 'Price'),
            ToggleGroupItem(label: 'Popular'),
          ],
          selectedIndex: _lgIndex,
          onChanged: (int? next) => setState(() => _lgIndex = next),
        ),
      ),
    ],
  );
}

const String _sizesCode =
    '''ToggleGroup(size: ToggleSize.sm, items: items, selectedIndex: smIndex, onChanged: (int? next) => setState(() => smIndex = next))

ToggleGroup(size: ToggleSize.lg, items: items, selectedIndex: lgIndex, onChanged: (int? next) => setState(() => lgIndex = next))''';

class _DisabledSpecimen extends StatefulWidget {
  const _DisabledSpecimen();

  @override
  State<_DisabledSpecimen> createState() => _DisabledSpecimenState();
}

class _DisabledSpecimenState extends State<_DisabledSpecimen> {
  int? _index = 0;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: ToggleGroup(
      key: const ValueKey<String>('toggle-group-disabled-specimen'),
      items: const <ToggleGroupItem>[
        ToggleGroupItem(label: 'Newest'),
        ToggleGroupItem(label: 'Price', enabled: false),
        ToggleGroupItem(label: 'Popular'),
      ],
      selectedIndex: _index,
      onChanged: (int? next) => setState(() => _index = next),
    ),
  );
}

const String _disabledCode = '''ToggleGroup(
  items: const <ToggleGroupItem>[
    ToggleGroupItem(label: 'Newest'),
    ToggleGroupItem(label: 'Price', enabled: false),
    ToggleGroupItem(label: 'Popular'),
  ],
  selectedIndex: sortIndex,
  onChanged: (int? next) => setState(() => sortIndex = next),
)''';

class _CustomSpecimen extends StatefulWidget {
  const _CustomSpecimen();

  @override
  State<_CustomSpecimen> createState() => _CustomSpecimenState();
}

class _CustomSpecimenState extends State<_CustomSpecimen> {
  int? _viewIndex = 0;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: ToggleGroup(
      key: const ValueKey<String>('toggle-group-custom-specimen'),
      items: <ToggleGroupItem>[
        ToggleGroupItem(
          label: 'Grid',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                IconGlyph.layoutGrid,
                size: Toggle.iconSizeFor(ToggleSize.md),
              ),
              SizedBox(width: Toggle.gap),
              const Text('Grid'),
            ],
          ),
        ),
        ToggleGroupItem(
          label: 'List',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(IconGlyph.rows3, size: Toggle.iconSizeFor(ToggleSize.md)),
              SizedBox(width: Toggle.gap),
              const Text('List'),
            ],
          ),
        ),
        const ToggleGroupItem(label: 'Table'),
      ],
      selectedIndex: _viewIndex,
      onChanged: (int? next) => setState(() => _viewIndex = next),
    ),
  );
}

const String _customCode =
    '''// ToggleGroupItem.child is optional per item: two options here supply
// an icon-and-label row, and the third omits child and falls back to a
// bare Text(label).
int? viewIndex = 0;

ToggleGroup(
  items: <ToggleGroupItem>[
    ToggleGroupItem(
      label: 'Grid',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            IconGlyph.layoutGrid,
            size: Toggle.iconSizeFor(ToggleSize.md),
          ),
          SizedBox(width: Toggle.gap),
          const Text('Grid'),
        ],
      ),
    ),
    ToggleGroupItem(
      label: 'List',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            IconGlyph.rows3,
            size: Toggle.iconSizeFor(ToggleSize.md),
          ),
          SizedBox(width: Toggle.gap),
          const Text('List'),
        ],
      ),
    ),
    const ToggleGroupItem(label: 'Table'),
  ],
  selectedIndex: viewIndex,
  onChanged: (int? next) => setState(() => viewIndex = next),
)''';

class _RtlSpecimen extends StatefulWidget {
  const _RtlSpecimen();

  @override
  State<_RtlSpecimen> createState() => _RtlSpecimenState();
}

class _RtlSpecimenState extends State<_RtlSpecimen> {
  int? _index = 0;

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ToggleGroup(
        key: const ValueKey<String>('toggle-group-rtl-specimen'),
        items: const <ToggleGroupItem>[
          ToggleGroupItem(label: 'الأحدث'),
          ToggleGroupItem(label: 'السعر'),
          ToggleGroupItem(label: 'الأكثر شيوعا'),
        ],
        selectedIndex: _index,
        onChanged: (int? next) => setState(() => _index = next),
      ),
    ),
  );
}

const String _rtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: ToggleGroup(
    items: const <ToggleGroupItem>[
      ToggleGroupItem(label: 'الأحدث'),
      ToggleGroupItem(label: 'السعر'),
      ToggleGroupItem(label: 'الأكثر شيوعا'),
    ],
    selectedIndex: sortIndex,
    onChanged: (int? next) => setState(() => sortIndex = next),
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
        id: 'api-eltogglegroup',
        child: DocsApiTable(title: 'ToggleGroup', facts: _groupApiFacts),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-eltogglegroup-static',
        child: DocsApiTable(
          title: 'ToggleGroup static helpers',
          facts: _groupStaticFacts,
        ),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-eltogglegroupitem',
        child: DocsApiTable(title: 'ToggleGroupItem', facts: _itemApiFacts),
      ),
    ],
  );
}

const List<DocsApiFact> _groupApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'items',
    type: 'List<ToggleGroupItem>',
    description:
        'Required. The options, in paint order. One Toggle is built per '
        'entry, and the index a caller reads back is this list\'s index.',
  ),
  DocsApiFact(
    name: 'selectedIndex',
    type: 'int?',
    description:
        'Required, and nullable: null is a legal value, not an omission. '
        'Which option is selected, or null for none, the state the '
        'travelling pill reads. Null or out-of-range is what '
        'ActiveIndicator treats as deselected: the pill fades out and '
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
    type: 'ToggleVariant',
    description:
        'Optional. Defaults to ToggleVariant.standard. Forwarded '
        "unchanged to every item. Toggle's own enum, documented on the "
        'toggle page.',
  ),
  DocsApiFact(
    name: 'size',
    type: 'ToggleSize',
    description:
        'Optional. Defaults to ToggleSize.md. Forwarded unchanged to '
        "every item. Toggle's own enum, documented on the toggle page.",
  ),
  DocsApiFact(
    name: 'label',
    type: 'String?',
    description:
        'Optional. Defaults to null, which emits no extra container '
        'semantics node at all. Non-null wraps the group in '
        'Semantics(container: true, label: …): supply one when nothing '
        'else on the screen names the group.',
  ),
];

const List<DocsApiFact> _groupStaticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ToggleGroup.gap',
    type: 'static double',
    description:
        'A getter, not a per-size function and not a constructor '
        'parameter: 8px between items, on every size and every variant. '
        "Handed straight to ActiveIndicator, so it is also the gap the "
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
        'Optional. Defaults to null, which renders label as a bare Text '
        "in the toggle's own resolved style. Non-null replaces the "
        'rendered content only: label still supplies the accessible name.',
  ),
  DocsApiFact(
    name: 'enabled',
    type: 'bool',
    description:
        'Optional. Defaults to true. false makes the group pass a null '
        "onChanged to this item's Toggle, which is the only disabled "
        'switch a toggle has: 50% opacity, no hit-testing, no tab stop.',
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
            'Pressed is not a row: an item is a Toggle, whose class '
            'list carries no active-state rule and no press '
            'utility, so nothing happens between pointer-down and '
            'pointer-up. Loading and Empty are not rows: this is a '
            'synchronous primitive with no async operation, and an empty '
            'items list simply renders nothing rather than an empty '
            'state. Error is not a row: aria-invalid is never set on '
            'this control anywhere in the reference, and neither '
            'ToggleGroup nor ToggleGroupItem exposes an invalid '
            'parameter. Success is not a row: the component defines no '
            'success semantics of its own.',
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
    state: 'Rest (unselected item)',
    treatment:
        'Each item is a Toggle with pressed: false. standard: no fill, '
        'no border. outline: a 1px theme.input border. Ink is '
        'theme.foreground.',
    userSignal:
        'A row of unfilled options with the pill sitting under whichever '
        'one is selected.',
  ),
  DocsStateFact(
    state: 'Hover',
    treatment:
        "theme.muted fill on the hovered item, on both variants: the item's "
        'own hover, unchanged by the group.',
    userSignal:
        'A grey wash appears under the pointer; the cursor becomes a '
        'click cursor.',
  ),
  DocsStateFact(
    state: 'Selected',
    treatment:
        'The group passes pressedFill: transparent and pressedInk: '
        "theme.primaryForeground, so the item gives up its own fill and "
        "ActiveIndicator's single theme.primary pill, already "
        'travelling underneath it, shows through.',
    userSignal:
        'White-on-blue ink over the travelling indicator: the one place '
        'selection reads as the brand colour in this family.',
  ),
  DocsStateFact(
    state: 'Nothing selected',
    treatment:
        'selectedIndex: null reaches ActiveIndicator as activeIndex: '
        '-1, its deselected sentinel. The pill fades out and stays '
        'parked where it last was rather than travelling off the end.',
    userSignal:
        'Every option reads as unselected, and the pill is simply gone.',
  ),
  DocsStateFact(
    state: 'Focus-visible',
    treatment:
        'Per item, not per group: the focused item paints a ring at '
        'theme.ring, 50% alpha, and on outline its border swaps to '
        'theme.ring too. Every item is its own tab stop (see '
        'Accessibility).',
    userSignal:
        'A ring around one option, appearing only after keyboard focus.',
  ),
  DocsStateFact(
    state: 'Disabled (per item)',
    treatment:
        'ToggleGroupItem.enabled: false makes the group pass a null '
        'onChanged to that item: 50% opacity, and an IgnorePointer that '
        'removes it from hit-testing, hover tracking and the tab order '
        'together. The rest of the group stays live.',
    userSignal: 'One dimmed, inert option among operable ones.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        "The item's fill/ink/border/ring tween chain and "
        "ActiveIndicator's own travel and jelly squash all resolve "
        'through effectiveMotionDuration, which reduced motion shortens '
        'toward zero.',
    userSignal:
        'The pill appears at its new position instead of travelling to '
        'it, with no colour transition to sit through.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) => DocsInstallFacts(
    title: 'Accessibility',
    facts: <DocsInstallFact>[
      const DocsInstallFact(
        label: 'Semantic role (per item)',
        value: 'Semantics(button:, selected:, inMutuallyExclusiveGroup:)',
        description:
            'The group sets inExclusiveGroup: true on every item it '
            'builds, so each announces as a choice among others (selected: '
            'pressed, inMutuallyExclusiveGroup: true) with toggled left '
            'null, rather than as an independent on/off switch.',
      ),
      const DocsInstallFact(
        label: 'Semantic role (the group)',
        value: 'Semantics(container: true, label: …), only when label is set',
        description:
            'With label null, the default, ToggleGroup emits no '
            'container node at all: the items are the only semantics '
            'present. Supply label when nothing else on the screen names '
            'the group.',
      ),
      const DocsInstallFact(
        label: 'Label association',
        value: 'ToggleGroupItem.label',
        description:
            "Passed straight through as the Toggle's own label for "
            "every item, which overrides rather than joins the child's "
            'content-derived name. That is why label is required on the '
            'item even when child renders its own text.',
      ),
      const DocsInstallFact(
        label: 'Keyboard activation',
        value: 'Enter, numpad Enter, Space, per item',
        description:
            'Inherited from Toggle, hand-wired through '
            'Focus.onKeyEvent. Activating the already-selected item '
            'clears the selection, exactly as tapping it does — see '
            'Keyboard below.',
      ),
      const DocsInstallFact(
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
      const DocsInstallFact(
        label: 'Touch target',
        value: "Exactly each item's visual box: no cushion",
        description:
            '28x28 / 32x32 / 36x36 per item depending on size, plus 8px '
            'of dead gap between items. Every size sits below the '
            "system's 44px touch-target floor: recorded rather than "
            'corrected, because it is what the source renders.',
      ),
      const DocsInstallFact(
        label: 'Non-colour signal',
        value: 'The selected semantics flag itself',
        description:
            'Visually the selection is the pill, a colour and a '
            'position; there is no drawn glyph to fall back on. A screen '
            'reader is told regardless, through the selected flag on the '
            'item.',
      ),
      const DocsInstallFact(
        label: 'Error wiring',
        value: 'N/A: no invalid parameter exists',
        description:
            'Neither ToggleGroup nor ToggleGroupItem declares an '
            'invalid/aria-invalid path; the source states aria-invalid '
            'is never set on this control anywhere in the reference. '
            'There is nothing to wire.',
      ),
      const DocsInstallFact(
        label: 'Screen-reader announcements',
        value: 'No live region',
        description:
            'Selection changes are exposed purely through the per-item '
            'semantics flags above; no extra announcement is authored, '
            "and the pill's travel is not narrated.",
      ),
    ],
  );
}

/// New: the design calls for this page to carry its own Keyboard section.
/// Every claim here is read off `lib/src/components/ui/toggle_group.dart`
/// directly: the file wires no `Focus.onKeyEvent` of its own — every item
/// is a plain `Toggle`, so activation and the disabled/traversal rule
/// come from that component's own `_onKey` and `Focus` wiring — plus the
/// one real divergence toggle_group.dart's own library doc records: no
/// `RovingFocusGroup`.
class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'toggle_group.dart wires no Focus.onKeyEvent, no '
            'FocusTraversalPolicy, and no RovingFocusGroup of its own: '
            'every item is a plain Toggle, and every key event it '
            'receives is handled by that component\'s own _onKey.',
        'Activation: Enter, NumpadEnter, and Space activate a focused, '
            'enabled item, identical to the standalone toggle. Activating '
            'the already-selected item clears the selection (onChanged: '
            'null), exactly as tapping it does.',
        'Tab order: one stop per item, not one stop for the whole group. '
            'The reference wraps a toggle group\'s items in a '
            'RovingFocusGroup (one Tab stop, arrow keys to move within '
            'it); toggle_group.dart states this divergence rather than '
            'approximating half of it, so a three-item group costs three '
            'Tab presses to cross.',
        'Disabled items: ToggleGroupItem.enabled: false makes the group '
            'pass a null onChanged to that item\'s Toggle, which removes '
            'it from keyboard traversal entirely (canRequestFocus: '
            '_enabled, one layer down) — not just dimmed in place.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
    child: StyledText(
      'ToggleGroup has no breakpoints of its own: it is a Row of '
      'fixed-height items plus a travelling pill, sized to its own '
      'content, and nothing in toggle_group.dart reads a viewport width. '
      "That is the thing to plan for, not a feature: ActiveIndicator's "
      'internal Row neither wraps nor scrolls, so a group whose items '
      'want more width than the column has WILL overflow rather than '
      'reflow. Three of the sort segments on this page already do it at '
      'a 390px viewport, and the Arabic-label RTL group overflows '
      'furthest. Every live group on this page is therefore wrapped in '
      'SingleChildScrollView(scrollDirection: Axis.horizontal), eight of '
      'them, which is the mitigation a real filter bar needs too. '
      'Wrapping the group in a Wrap does not help: a Wrap can only move '
      'whole groups onto new runs, never split one group across two '
      'lines, because the pill is measured against a single continuous '
      'row. Keyboard activation and pointer activation behave identically '
      'on every Flutter target this package supports; there is no '
      'platform channel and nothing here is web-only or desktop-only.',
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
            value: toggleGroupDoc.sourcePath,
            description:
                'The authoritative implementation of ToggleGroup and '
                'ToggleGroupItem: one file.',
          ),
          const DocsInstallFact(
            label: 'Flutter imports',
            value: 'package:flutter/widgets.dart',
            description:
                'The only Flutter import: no services.dart here, because '
                'the key handling lives in Toggle, one layer down.',
          ),
          DocsInstallFact(
            label: 'Local file dependencies',
            value:
                '$toggleItemSourcePath, $slidingPillSourcePath, '
                'effects/surface.dart',
            description:
                'toggle_group.dart imports toggle.dart directly: every '
                'item IS a Toggle underneath, configured with '
                'pressedFill, pressedInk and inExclusiveGroup. It imports '
                'motion/active_indicator.dart for ActiveIndicator, the '
                'travelling-pill machinery it shares with Tabs, '
                'Sidebar and IconSwap, and effects/surface.dart '
                'to paint the pill itself. None are copyable in '
                'isolation: see Installation.',
          ),
          const DocsInstallFact(
            label: 'Foundation dependencies',
            value:
                'foundation/colors.dart, foundation/shadows.dart, '
                'foundation/spacing.dart, foundation/theme.dart, '
                'theme_scope.dart',
            description:
                'Token sources: the transparent-colour constant the '
                'selected item is filled with, Shadows.compactControl for the '
                'pill, the space() spacing scale and Radii.full, and the '
                'live theme. Note what is absent next to toggle.dart\'s '
                'own list: no typography.dart and no motion.dart, '
                'because the item resolves its own text style and its '
                'own timing.',
          ),
          DocsInstallFact(
            label: 'Exports',
            value: toggleGroupDoc.exports.join(', '),
            description:
                'The public symbols this component makes available. '
                'ToggleVariant and ToggleSize are toggle.dart\'s own '
                'exports, documented on the toggle page.',
          ),
          const DocsInstallFact(
            label: 'Assets',
            value: 'none',
            description:
                'The pill, the fills and the borders are plain box '
                'decoration: no image and no icon-font glyph of its own. '
                'An icon supplied through ToggleGroupItem.child brings '
                'its own geometry from icon_paths.dart, not an asset '
                'file.',
          ),
          const DocsInstallFact(
            label: 'Fonts',
            value: 'none',
            description:
                'The group renders no text of its own: an item falls '
                'back to a bare Text, which inherits the '
                'DefaultTextStyle Toggle installs.',
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
            DocsLink(label: 'Toggle', route: '/components/toggle'),
            DocsLink(
              label: 'Active Indicator',
              route: '/components/active_indicator',
            ),
            DocsLink(label: 'Surface', route: '/components/surface'),
            DocsLink(
              label: 'Source Foundation',
              route: '/components/source_foundation',
            ),
            DocsLink(label: 'Tabs', route: '/components/tabs'),
            DocsLink(label: 'Sidebar', route: '/components/sidebar'),
            DocsLink(label: 'Icon Swap', route: '/components/icon_swap'),
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
        label: 'Pill fill',
        value: 'theme.primary',
        description:
            'The one blue selection surface in this family. Read live off '
            'ThemeScope.of(context) at build time, so flipping the theme '
            'controller re-resolves it on the next frame.',
      ),
      const DocsInstallFact(
        label: 'Pill shape and elevation',
        value: 'Radii.full, Shadows.compactControl',
        description:
            "A stadium over the item's own rounded rect, wearing the chip "
            "spec's inner rim and inner shade. Always Radii.full "
            'regardless of item size: a documented drift in '
            "toggle_group.dart's own header, since the item underneath is "
            'Radii.lg or Radii.md.',
      ),
      const DocsInstallFact(
        label: 'Selected item fill and ink',
        value: 'transparent, theme.primaryForeground',
        description:
            'Passed down as pressedFill and pressedInk. The item gives up '
            'the theme.muted fill it would paint on its own so the pill '
            'shows through, and flips to primaryForeground ink because '
            'what is behind it is now theme.primary.',
      ),
      const DocsInstallFact(
        label: 'Unselected item colours',
        value: 'Inherited from Toggle, unchanged',
        description:
            'transparent at rest, theme.muted on hover, theme.input or '
            'theme.ring for an outline border, theme.foreground ink. The '
            'group overrides none of them: see the toggle page.',
      ),
      const DocsInstallFact(
        label: 'Gap',
        value: 'ToggleGroup.gap, 8px',
        description:
            'Fixed, and not themeable or overridable: see Spacing above.',
      ),
      const DocsInstallFact(
        label: 'Motion',
        value:
            'ActiveIndicator: MotionDurations.normal, MotionCurves.emphasized',
        description:
            "The pill's travel, plus a jelly squash on "
            'MotionDurations.stateChange, all resolved through '
            'effectiveMotionDuration so reduced motion shortens or removes '
            "them automatically. The item's own colour legs run on "
            'MotionDurations.normal and MotionCurves.enter instead, one '
            'layer down.',
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
