/// Public documentation page for the `active-indicator` motion primitive.
///
/// **Why `EffectSection`, not `ShowcaseSection`.** `ActiveIndicator` has
/// no variant enum and nothing to look at on its own: it lays out `children`
/// and paints one `pill` behind whichever one is selected. A
/// `ShowcaseSection` would stage the pill and its host as one anonymous
/// specimen; `EffectSection` names the host explicitly, which is what a
/// reader needs to tell "the pill this page documents" from "the toggle
/// group it happens to be sitting inside."
///
/// **Section list.** Preview contrasts RULES §4's own claim — "selection
/// travels, never blinks" — against a plain two-state control with no shared
/// pill. Toggle Group and Tabs — Line are this port's two real corpus
/// consumers (`lib/src/components/ui/toggle_group.dart`,
/// `lib/src/components/ui/tabs.dart`'s `line` variant), the second chosen over
/// the `standard` variant specifically because it exercises `jellyAlignment`,
/// a real constructor parameter Toggle Group never varies from its default.
/// Deselection is the one behaviour the source's own docstring calls out at
/// length as a genuine edge the reference measured, not guessed — worth its
/// own facet because "the pill fades in place" is easy to get backwards
/// (sliding to the origin, which is what an earlier port revision did).
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
import 'meta.dart';

final ComponentDocSpec slidingPillDocSpec = ComponentDocSpec(
  name: 'active_indicator',
  title: 'Active Indicator',
  description:
      'A single travelling pill that measures the selected option and moves '
      'to it with a squash on arrival — selection travels, it never blinks '
      'on and off between options.',
  sections: <DocsPageSection>[
    EffectSection(
      id: 'preview',
      title: 'Preview',
      description:
          'RULES §4: "selection travels, never blinks." The left group '
          'owns one ActiveIndicator pill that physically moves between '
          'options; the right pair are two independent buttons that flip '
          'their own fill on and off with no shared pill and no travel — '
          'the "blinks" this primitive replaces.',
      host: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'active-indicator has a real registry manifest: `elattar add '
          'active-indicator` installs lib/src/components/ui/active_indicator.dart and '
          'resolves both registryDependencies automatically. The Manual tab '
          'is for a project not using the CLI.',
      command: activeIndicatorDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/motion/active_indicator.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/ui/active_indicator.dart's generated "
              '@ui/active_indicator.dart payload into your motion folder.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated active-indicator source here when using '
              'manual mode.',
        ),
        DocsCodeFile(
          path: 'lib/motion/motion.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ActiveIndicator is reachable the '
              'same way the CLI path already makes it.',
          code: "export 'active_indicator.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The pill is painted first, behind children, ignores pointers, '
          'and takes the exact measured rect of the child at activeIndex.',
      code: _usageCode,
    ),
    EffectSection(
      id: 'toggle-group',
      title: 'Toggle Group',
      description:
          "lib/src/components/ui/toggle_group.dart's own composition: an "
          'Surface pill wearing shadow-chip over theme.primary, '
          'behind Toggle members in an exclusive group. Tapping the '
          'already-selected option clears the selection — see Deselection '
          'below for what the pill does then.',
      host: _ToggleGroupSpecimen(),
      code: _toggleGroupCode,
      label: 'Toggle Group specimen view',
    ),
    EffectSection(
      id: 'tabs-line',
      title: 'Tabs — Line',
      description:
          "lib/src/components/ui/tabs.dart's line variant: the jelly span is "
          're-classed to a 2px rule sitting on the bottom edge of the '
          'trigger rather than a filled pill behind it, so it scales about '
          'its own centre rather than the rect\'s — jellyAlignment: '
          'Alignment.bottomCenter instead of the default .center Toggle '
          'Group above never varies from.',
      host: _TabsLineSpecimen(),
      code: _tabsLineCode,
      label: 'Tabs — Line specimen view',
    ),
    EffectSection(
      id: 'deselection',
      title: 'Deselection',
      description:
          "Measured on the reference, not guessed (behaviour-audit T8b): "
          'clicking the selected option again does not slide the pill back '
          'to the group origin. width, height and transform stay exactly '
          "what they were at the last selection; only opacity fades, over "
          "150ms --ease-out, and the arrival squash does not replay — the "
          "reference's own move() returns before reaching the jelly branch "
          'whenever nothing is active.',
      host: _DeselectionSpecimen(),
      code: _deselectionCode,
      label: 'Deselection specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description: 'Every constructor parameter ActiveIndicator declares.',
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Read straight off _ActiveIndicatorState and the source\'s own '
          'behaviour-audit citations, not inferred.',
      child: DocsStateMatrix(facts: _stateFacts),
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
            value: activeIndicatorDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/motion_test.dart',
            description:
                'ActiveIndicator has its own group in the shared motion '
                'suite, including a reduced-motion group: there is no '
                'dedicated sliding_pill_test.dart in the package yet.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/sliding_pill_test.dart',
            description:
                'Covers this page: the article mounts, the full API table, '
                'both real call sites, deselection, and both themes.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/active_indicator/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class ActiveIndicatorDocPage extends StatelessWidget {
  const ActiveIndicatorDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: activeIndicatorDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / MOTION',
      title: activeIndicatorDoc.title,
      description: activeIndicatorDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Active Indicator'),
    ],
    toc: slidingPillDocSpec.toc,
    previous: const DocsPageLink(title: 'Lift', route: '/components/lift'),
    next: const DocsPageLink(
      title: 'Content Change',
      route: '/components/content_change',
    ),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('active-indicator-doc-article'),
      child: ComponentDocPage(spec: slidingPillDocSpec, header: false),
    ),
  );
}

/* ── Effect specimens ───────────────────────────────────────────────────── */

Widget _pillCaption(BuildContext context, String label) => StyledText(
  label,
  TextStyles.caption,
  color: ThemeScope.of(context).mutedForeground,
);

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: space(2)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _pillCaption(context, 'Travels'),
              SizedBox(height: space(3)),
              const KeyedSubtree(
                key: ValueKey<String>('active-indicator-preview:travels'),
                child: _TravelsPreview(),
              ),
            ],
          ),
          SizedBox(width: space(10)),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _pillCaption(context, 'Blinks'),
              SizedBox(height: space(3)),
              const KeyedSubtree(
                key: ValueKey<String>('active-indicator-preview:blinks'),
                child: _BlinksPreview(),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

const String _previewCode =
    '// Travels — one pill, physically moves\n'
    'ActiveIndicator(\n'
    '  activeIndex: selected,\n'
    '  indicator: Surface(\n'
    '    spec: Shadows.compactControl,\n'
    '    radius: BorderRadius.circular(Radii.full),\n'
    '    fill: theme.primary,\n'
    '    child: const SizedBox.expand(),\n'
    '  ),\n'
    '  children: [Toggle(...), Toggle(...)],\n'
    ')\n\n'
    '// Blinks — no shared pill, each button flips its own fill\n'
    'Row(children: [\n'
    '  for (final i in [0, 1])\n'
    '    GestureDetector(\n'
    '      onTap: () => setState(() => selected = i),\n'
    '      child: DecoratedBox(\n'
    '        decoration: BoxDecoration(\n'
    '          color: selected == i ? theme.primary : null,\n'
    '        ),\n'
    '        child: Text(labels[i]),\n'
    '      ),\n'
    '    ),\n'
    '])';

class _TravelsPreview extends StatefulWidget {
  const _TravelsPreview();

  @override
  State<_TravelsPreview> createState() => _TravelsPreviewState();
}

class _TravelsPreviewState extends State<_TravelsPreview> {
  int _selected = 0;
  static const List<String> _labels = <String>['Grid', 'List'];

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return ActiveIndicator(
      activeIndex: _selected,
      gap: space(1),
      padding: EdgeInsets.all(space(1)),
      indicator: Surface(
        spec: Shadows.compactControl,
        radius: BorderRadius.circular(Radii.full),
        fill: theme.primary,
        child: const SizedBox.expand(),
      ),
      children: <Widget>[
        for (int i = 0; i < _labels.length; i++)
          Toggle(
            pressed: i == _selected,
            onChanged: (bool _) => setState(() => _selected = i),
            inExclusiveGroup: true,
            pressedFill: transparent,
            pressedInk: theme.primaryForeground,
            child: Text(_labels[i]),
          ),
      ],
    );
  }
}

class _BlinksPreview extends StatefulWidget {
  const _BlinksPreview();

  @override
  State<_BlinksPreview> createState() => _BlinksPreviewState();
}

class _BlinksPreviewState extends State<_BlinksPreview> {
  int _selected = 0;
  static const List<String> _labels = <String>['Grid', 'List'];

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < _labels.length; i++) ...<Widget>[
          if (i > 0) SizedBox(width: space(1)),
          GestureDetector(
            onTap: () => setState(() => _selected = i),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: i == _selected ? theme.primary : theme.card,
                borderRadius: BorderRadius.circular(Radii.full),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: space(4),
                  vertical: space(2),
                ),
                child: StyledText(
                  _labels[i],
                  TextStyles.small,
                  color: i == _selected
                      ? theme.primaryForeground
                      : theme.foreground,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _ToggleGroupSpecimen extends StatefulWidget {
  const _ToggleGroupSpecimen();

  @override
  State<_ToggleGroupSpecimen> createState() => _ToggleGroupSpecimenState();
}

class _ToggleGroupSpecimenState extends State<_ToggleGroupSpecimen> {
  int? _selected = 0;
  static const List<String> _labels = <String>['List', 'Board', 'Calendar'];

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return KeyedSubtree(
      key: const ValueKey<String>('active-indicator-example:toggle-group'),
      child: ActiveIndicator(
        activeIndex: _selected ?? -1,
        gap: space(2),
        padding: EdgeInsets.all(space(1)),
        indicator: Surface(
          spec: Shadows.compactControl,
          radius: BorderRadius.circular(Radii.full),
          fill: theme.primary,
          child: const SizedBox.expand(),
        ),
        children: <Widget>[
          for (int i = 0; i < _labels.length; i++)
            Toggle(
              pressed: i == _selected,
              onChanged: (bool on) => setState(() => _selected = on ? i : null),
              inExclusiveGroup: true,
              pressedFill: transparent,
              pressedInk: theme.primaryForeground,
              child: Text(_labels[i]),
            ),
        ],
      ),
    );
  }
}

const String _toggleGroupCode =
    'ActiveIndicator(\n'
    '  activeIndex: selectedIndex ?? -1,\n'
    '  gap: ToggleGroup.gap,\n'
    '  indicator: Surface(\n'
    '    spec: Shadows.compactControl,\n'
    '    radius: BorderRadius.circular(Radii.full),\n'
    '    fill: theme.primary,\n'
    '    child: const SizedBox.expand(),\n'
    '  ),\n'
    '  children: [\n'
    '    for (final item in items)\n'
    '      Toggle(\n'
    '        pressed: item.index == selectedIndex,\n'
    '        onChanged: (on) => onChanged(on ? item.index : null),\n'
    '        inExclusiveGroup: true,\n'
    '        pressedFill: transparent,\n'
    '        pressedInk: theme.primaryForeground,\n'
    '        child: Text(item.label),\n'
    '      ),\n'
    '  ],\n'
    ')';

class _TabsLineSpecimen extends StatefulWidget {
  const _TabsLineSpecimen();

  @override
  State<_TabsLineSpecimen> createState() => _TabsLineSpecimenState();
}

class _TabsLineSpecimenState extends State<_TabsLineSpecimen> {
  int _selected = 0;
  static const List<String> _labels = <String>['Overview', 'Activity'];

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return KeyedSubtree(
      key: const ValueKey<String>('active-indicator-example:tabs-line'),
      child: SizedBox(
        height: Tabs.trackHeight,
        child: ActiveIndicator(
          activeIndex: _selected,
          gap: Tabs.gapFor(TabsVariant.line),
          padding: EdgeInsets.symmetric(
            vertical: (Tabs.trackHeight - Tabs.triggerHeight) / 2,
          ),
          jellyAlignment: Alignment.bottomCenter,
          indicator: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: Tabs.ruleHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.actionText,
                  borderRadius: BorderRadius.circular(Radii.full),
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          children: <Widget>[
            for (int i = 0; i < _labels.length; i++)
              GestureDetector(
                onTap: () => setState(() => _selected = i),
                child: SizedBox(
                  height: Tabs.triggerHeight,
                  child: Center(
                    child: StyledText(
                      _labels[i],
                      TextStyles.small,
                      color: i == _selected
                          ? theme.foreground
                          : theme.mutedForeground,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

const String _tabsLineCode =
    'ActiveIndicator(\n'
    '  activeIndex: selectedIndex,\n'
    '  gap: Tabs.gapFor(TabsVariant.line),\n'
    '  jellyAlignment: Alignment.bottomCenter,\n'
    '  indicator: Align(\n'
    '    alignment: Alignment.bottomCenter,\n'
    '    child: SizedBox(\n'
    '      height: Tabs.ruleHeight,\n'
    '      child: DecoratedBox(\n'
    '        decoration: BoxDecoration(\n'
    '          color: theme.actionText,\n'
    '          borderRadius: BorderRadius.circular(Radii.full),\n'
    '        ),\n'
    '        child: const SizedBox.expand(),\n'
    '      ),\n'
    '    ),\n'
    '  ),\n'
    '  children: [for (final t in triggers) TabsTrigger(t)],\n'
    ')';

class _DeselectionSpecimen extends StatefulWidget {
  const _DeselectionSpecimen();

  @override
  State<_DeselectionSpecimen> createState() => _DeselectionSpecimenState();
}

class _DeselectionSpecimenState extends State<_DeselectionSpecimen> {
  int? _selected = 0;
  static const List<String> _labels = <String>['Small', 'Medium', 'Large'];

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return KeyedSubtree(
      key: const ValueKey<String>('active-indicator-example:deselection'),
      child: ActiveIndicator(
        activeIndex: _selected ?? -1,
        gap: space(2),
        padding: EdgeInsets.all(space(1)),
        indicator: Surface(
          spec: Shadows.compactControl,
          radius: BorderRadius.circular(Radii.full),
          fill: theme.primary,
          child: const SizedBox.expand(),
        ),
        children: <Widget>[
          for (int i = 0; i < _labels.length; i++)
            Toggle(
              pressed: i == _selected,
              // Tapping the already-selected option clears it — the group
              // resolves activeIndex to -1, and the pill fades where it
              // stands rather than sliding to the group origin.
              onChanged: (bool on) => setState(() => _selected = on ? i : null),
              inExclusiveGroup: true,
              pressedFill: transparent,
              pressedInk: theme.primaryForeground,
              child: Text(_labels[i]),
            ),
        ],
      ),
    );
  }
}

const String _deselectionCode =
    'ActiveIndicator(\n'
    '  // A tap that clears the selection resolves activeIndex to -1.\n'
    '  activeIndex: selectedIndex ?? -1,\n'
    '  indicator: pill,\n'
    '  children: [\n'
    '    for (final item in items)\n'
    '      Toggle(\n'
    '        pressed: item.index == selectedIndex,\n'
    '        // Tapping the pressed item asks for !pressed == false.\n'
    '        onChanged: (on) => onChanged(on ? item.index : null),\n'
    '        inExclusiveGroup: true,\n'
    '        child: Text(item.label),\n'
    '      ),\n'
    '  ],\n'
    ')';

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

ActiveIndicator(
  activeIndex: selectedIndex,
  indicator: Surface(
    spec: Shadows.compactControl,
    radius: BorderRadius.circular(Radii.full),
    fill: theme.primary,
    child: const SizedBox.expand(),
  ),
  children: [
    for (final option in options)
      Toggle(
        pressed: option.index == selectedIndex,
        onChanged: (on) => onChanged(on ? option.index : null),
        inExclusiveGroup: true,
        child: Text(option.label),
      ),
  ],
)''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) =>
      const DocsApiTable(title: 'ActiveIndicator', facts: _pillApiFacts);
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Decorative by itself: the pill Stack wraps its AnimatedPositioned '
            'in IgnorePointer and sets no Semantics node of its own. '
            'active_indicator.dart never calls Semantics anywhere in the file.',
        'The accessible state belongs entirely to children: an Toggle '
            'child still reports its own aria-pressed-equivalent whether or '
            'not a pill happens to be riding behind it — the pill is a '
            'purely visual restatement of state a screen reader already '
            'has another way to reach.',
        'A caller relying on the pill alone to communicate selection '
            '(instead of a pressed/selected state on each child) would '
            'ship a control with no accessible selection story at all: '
            'this widget does not supply one.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'ActiveIndicator takes no focus and handles no key: no Focus, '
            'no FocusNode, no onKeyEvent anywhere in active_indicator.dart. It '
            'is a Stack of AnimatedPositioned/AnimatedOpacity/'
            'AnimatedBuilder over a measured Row.',
        'Every keyboard story on this page belongs to children: Toggle '
            "Group's Toggle members carry their own Tab order and "
            'Enter/Space activation; the pill travels because activeIndex '
            'changed underneath it, not because a key reached this widget.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No breakpoint branching: BuildContext width is never read for a '
            'layout decision.',
        'It is genuinely reactive to layout, though, in a different sense: '
            '_measure runs after every build via addPostFrameCallback and '
            'only calls setState when a child\'s rect actually moved — a '
            'window resize, a font swap, or a child appearing all replay '
            'the travel and the squash, covering what the reference\'s '
            'MutationObserver + ResizeObserver pair covers.',
        'children of different widths are handled by design, not as an '
            'edge case: the pill measures each option\'s real rect rather '
            'than assuming a uniform size, so width moves in exact '
            'lock-step with position on every travel.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      _bullets(ThemeScope.of(context), <String>[
        'File: lib/src/components/ui/active_indicator.dart: one file, no companions; '
            'the registry manifest lists exactly one entry under "files".',
        'Flutter imports: package:flutter/widgets.dart only.',
        'Foundation imports: foundation/motion.dart (effectiveMotionDuration, '
            'MotionCurves, MotionDurations), motion/keyframes.dart (StateChangeMotion, the '
            'arrival squash table this file used to carry a private copy '
            'of).',
        'registryDependencies, resolved automatically by `elattar add '
            'active-indicator`: keyframes, source-foundation — copied verbatim '
            'from registry/components/active-indicator.json.',
        'Not a dependency of active_indicator.dart itself, but its two live '
            'consumers in the corpus: Toggle Group and the line variant of '
            'Tabs.',
      ]),
      SizedBox(height: space(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Toggle Group', route: '/components/toggle-group'),
          DocsLink(label: 'Tabs', route: '/components/tabs'),
          DocsLink(label: 'Keyframes', route: '/components/keyframes'),
          DocsLink(
            label: 'Source Foundation',
            route: '/components/source_foundation',
          ),
        ],
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(
    BuildContext context,
  ) => _bullets(ThemeScope.of(context), <String>[
    'No colour of its own: active_indicator.dart never reads ThemeScope.of'
        '(context). Every colour comes from the pill Widget the caller '
        'hands in — theme.primary + shadow-chip on Toggle Group, '
        'theme.actionText on the Tabs line variant — and from whatever '
        'colour the children paint themselves.',
    'Shape is the same story: BorderRadius.circular(Radii.full) on '
        'the Toggle Group pill and the Tabs line variant\'s rule both '
        'come from the pill Widget passed in, not from this file.',
    'The one thing this file reads through the theme scope is motion: '
        'effectiveMotionDuration(context, …) on the jelly controller\'s own '
        'duration and on both AnimatedPositioned/AnimatedOpacity '
        'durations, so MediaQuery.disableAnimations collapses travel, '
        'fade and squash together — see States above.',
  ]);
}

Widget _bullets(ThemeTokens theme, List<String> lines) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    for (final String line in lines) ...<Widget>[
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
        child: StyledText(
          '•  $line',
          TextStyles.small,
          color: theme.mutedForeground,
        ),
      ),
      SizedBox(height: space(2)),
    ],
  ],
);

const List<DocsApiFact> _pillApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'activeIndex',
    type: 'int',
    description:
        'Required. The selected child. Out of range — including a '
        'deliberate -1 — hides the pill, which is how a fully deselected '
        'group is handled.',
  ),
  DocsApiFact(
    name: 'pill',
    type: 'Widget',
    description:
        "Required. The pill itself, stretched to the active child's "
        'measured rect. This widget paints no colour or shape of its own — '
        'every visual fact about the pill comes from here.',
  ),
  DocsApiFact(
    name: 'children',
    type: 'List<Widget>',
    description:
        'Required. The options, in paint order. Each is measured after '
        'layout via a GlobalKey, so options of different widths are '
        'handled correctly, not assumed uniform.',
  ),
  DocsApiFact(
    name: 'padding',
    type: 'EdgeInsets',
    description: "Optional. Defaults to EdgeInsets.zero. The row's own inset.",
  ),
  DocsApiFact(
    name: 'gap',
    type: 'double',
    description: 'Optional. Defaults to 0. Space between options.',
  ),
  DocsApiFact(
    name: 'moveDuration',
    type: 'Duration?',
    description:
        'Optional. Defaults to null, which resolves to MotionDurations.normal '
        '(250ms) on MotionCurves.emphasized. Duration.zero makes the move a snap — '
        'the one real call site is the theme toggle, whose click also '
        "freezes every colour in the document for ~14ms, so the pill's own "
        'transform must commit inside that window rather than travel.',
  ),
  DocsApiFact(
    name: 'jellyAlignment',
    type: 'Alignment',
    description:
        "Optional. Defaults to Alignment.center — the transform-origin for "
        "the arrival squash. Tabs' line variant is the one real call site "
        "that overrides it to Alignment.bottomCenter, since what's being "
        'squashed there is a 2px rule sitting on the trigger\'s bottom '
        'edge, not a pill filling the whole rect.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'First measurement',
    treatment:
        '_rects is null until the first post-frame _measure() succeeds; '
        'before that the pill has no target and AnimatedPositioned/'
        'AnimatedOpacity both animate over Duration.zero once one arrives, '
        'because _placed is still false.',
    userSignal:
        'The pill pops into place on the active option — no travel, no '
        'fade — and then squashes once, since the reference\'s own '
        'ResizeObserver re-enters move() right after mount and that call '
        'does take the jelly branch.',
  ),
  DocsStateFact(
    state: 'Selection changes (placed)',
    treatment:
        'AnimatedPositioned travels over moveDuration ?? MotionDurations.'
        'base on MotionCurves.emphasized; AnimatedOpacity holds at 1 over '
        'MotionDurations.fast; _jelly.forward(from: 0) restarts concurrently '
        'over MotionDurations.stateChange (600ms).',
    userSignal:
        'The pill slides to the new option\'s measured rect with a '
        '≈9.65–9.67% overshoot and squashes on the way, not after '
        'arriving — travel and squash run at once, the squash simply '
        'outlives the travel by 350ms.',
  ),
  DocsStateFact(
    state: 'Deselection (activeIndex resolves to null)',
    treatment:
        '_held keeps the last active rect; target is null so rect falls '
        'back to _held unchanged, and travels is still true so the '
        'AnimatedPositioned duration stays live even though left/top/'
        'width/height never actually change. Only AnimatedOpacity animates, '
        'to 0. _replayJelly returns early because _target is null.',
    userSignal:
        'The pill fades out exactly where it was standing — it does not '
        'slide anywhere, and it does not squash on the way out.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'effectiveMotionDuration(context, …) gates the jelly controller\'s '
        'duration and both AnimatedPositioned/AnimatedOpacity durations on '
        'every build.',
    userSignal:
        'Every leg — travel, fade, squash — collapses to zero together: '
        'the pill still ends up in the right place, instantly.',
  ),
];
