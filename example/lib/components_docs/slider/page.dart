/// Public documentation page for the `slider` component.
///
/// **Re-housed onto the kit.** This page used to hand-compose `ElSection`
/// panels; it now declares a `ComponentDocSpec`
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// `ComponentDocPage`, the same shape `button` established. Every specimen
/// widget and every code string the old page carried moves across
/// unchanged; three sections (Range, Multiple thumbs, Controlled) carried
/// code with no live specimen of their own before (Range and Multiple
/// thumbs leaned on the Preview grid's cells; Controlled's own live
/// composition had no quoted source), and now each is genuinely both,
/// since a `ShowcaseSection` is a specimen AND its source.
///
/// **Section order**, matching `button`'s own house shape: Preview (the old
/// four-cell specimen grid, promoted to a real section), Installation,
/// Usage, then one section per shadcn example this port can back up
/// (Variants and sizes — a SnippetSection recording the deliberate absence,
/// matching `field`'s own Anatomy section's shape, since ElSlider fixes one
/// geometry and has nothing to show — Range, Multiple thumbs, Controlled,
/// Disabled, Composition), then the eight disclosures. Vertical and RTL are
/// still skipped: ElSlider exposes no orientation parameter and no
/// directionality-aware layout. Three section titles are corrected to their
/// exact required spelling: "States and feedback" -> "States", "Responsive
/// and platform behavior" -> "Responsive", "Dependencies, files, assets,
/// fonts and shaders" -> "Dependencies", "Theming notes" -> "Theming". New:
/// a Keyboard disclosure, between Accessibility and Responsive, read
/// directly off `lib/src/components/slider.dart`'s own `_onKey` (unlike
/// `switch` and `checkbox`, `slider` wires its own key handler rather than
/// composing `selection_control.dart`'s shared one).
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart' show ElStateCell;
import 'meta.dart';

final ComponentDocSpec sliderDocSpec = ComponentDocSpec(
  name: 'slider',
  title: sliderDoc.title,
  description: sliderDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'Four live specimens, all built from the same ElSlider '
          'constructor. Single value, Range and Custom range are operable: '
          'drag a knob, or focus it (tap and Tab, or see Accessibility) '
          'and use the arrow, Page and Home/End keys. Disabled is '
          'deliberately inert.',
      specimen: _SliderPreview(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'slider is a registry item: elattar add slider resolves it and '
          'its dependencies and copies the source into your project. The '
          'Manual tab is for a project not using the CLI.',
      command: sliderDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/slider.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/slider.dart's generated "
              '@ui/slider.dart payload into components/ui. The file needs '
              'its sibling dependencies too: see Dependencies below.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated slider source here when using manual '
              'mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ElSlider is reachable the same way '
              'the CLI path already makes it.',
          code: "export 'slider.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'Import ElSlider and construct the smallest correct example.',
      code: _smallestUsageCode,
    ),
    SnippetSection(
      id: 'variants',
      title: 'Variants and sizes',
      description:
          'No size or style variant: recorded rather than silently '
          'skipped.',
      code: _variantsCode,
    ),
    ShowcaseSection(
      id: 'range',
      title: 'Range',
      description:
          'Pass two entries in values and ElSlider renders a range '
          'slider: one thumb per entry, each stopping at its neighbour '
          'rather than crossing it.',
      specimen: _RangeSpecimen(),
      code: _rangeUsageCode,
      label: 'Range specimen view',
    ),
    ShowcaseSection(
      id: 'multiple-thumbs',
      title: 'Multiple thumbs',
      description:
          'values is not limited to one or two entries: any length '
          'renders that many thumbs, each still clamped against its '
          'immediate neighbours by index.',
      specimen: _MultipleThumbsSpecimen(),
      code: _multipleThumbsCode,
      label: 'Multiple thumbs specimen view',
    ),
    ShowcaseSection(
      id: 'controlled',
      title: 'Controlled',
      description:
          'ElSlider renders no visible numeric readout of its own, label '
          'only supplies the accessible name, never on-screen text. Pair '
          'it with a ElText showing the current value(s) when the user '
          'needs to see the number, not just feel the position.',
      specimen: _VolumeExample(),
      code: _controlledCode,
      label: 'Controlled specimen view',
    ),
    ShowcaseSection(
      id: 'disabled',
      title: 'Disabled',
      description:
          'enabled: false dims the whole control and withdraws pointer and '
          'keyboard handling; see the live Disabled cell in Preview above.',
      specimen: _DisabledSpecimen(),
      code: _disabledUsageCode,
      label: 'Disabled specimen view',
    ),
    SnippetSection(
      id: 'composition',
      title: 'Composition',
      description:
          'Two larger, real patterns built from the same constructor, not '
          'manufactured examples the Dart API cannot support.',
      code: '$_priceFilterCode\n\n$_ratingCode',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter ElSlider declares, and both static '
          'geometry getters.',
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Selected, Loading, Empty, Error and Success are omitted below: '
          'reasons follow the table.',
      child: _StatesContent(),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      child: DocsInstallFacts(title: 'Accessibility', facts: _a11yFacts),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      description:
          "Read off lib/src/components/slider.dart's own _onKey directly: "
          'unlike switch and checkbox, slider wires its own key handler '
          "rather than composing selection_control.dart's shared one.",
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
      child: DocsInstallFacts(
        title: 'Tokens this component reads',
        facts: _themingFacts,
      ),
    ),
    DisclosureSection(
      id: 'source',
      title: 'Source',
      child: DocsInstallFacts(
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Component source',
            value: sliderDoc.sourcePath,
            description: 'Authoritative implementation.',
          ),
          const DocsInstallFact(
            label: 'Shared machinery',
            value: 'lib/src/components/selection_control.dart',
            description:
                'ElHitArea: shared with the checkbox, switch and radio '
                'families and documented on their own component pages.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/slider_test.dart',
            description:
                'Geometry (both coordinate spaces), rasterised colour/'
                'shadow assertions, pointer/drag/keyboard behaviour, '
                'disabled dimming and reduced-motion coverage: driven and '
                "measured against the live reference per the file's own "
                'header.',
          ),
          const DocsInstallFact(
            label: 'Docs page tests',
            value: 'example/test/components_docs/slider_test.dart',
            description:
                "Coverage for this page: API completeness, both live "
                'specimens (single and range), dragging, keyboard stepping '
                'and Home/End, and both themes.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/slider/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class SliderDocPage extends StatelessWidget {
  const SliderDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: sliderDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: sliderDoc.title,
      description: sliderDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Slider'),
    ],
    toc: sliderDocSpec.toc,
    previous: const DocsPageLink(
      title: 'Selection Control',
      route: '/components/selection_control',
    ),
    next: const DocsPageLink(title: 'Textarea', route: '/components/textarea'),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('slider-doc-article'),
      child: ComponentDocPage(spec: sliderDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

const String _smallestUsageCode = '''double volume = 50;

ElSlider(
  values: <double>[volume],
  min: 0,
  max: 100,
  label: 'Volume',
  onChanged: (List<double> next) => setState(() => volume = next.single),
)''';

const String _variantsCode =
    '''// ElSlider fixes one geometry, like its checkbox/switch/radio
// siblings: no size or style variant to choose between.
ElSlider.trackHeight; // 10px
ElSlider.thumbSize;   // 20px

// The source also carries dormant data-vertical classes for a vertical
// orientation, but no orientation parameter is exposed on ElSlider and no
// call site in the corpus used it: recorded as unbuilt rather than
// shipped, the same ruling the source's own docstring states for the
// reference's vertical branch.''';

const String _rangeUsageCode = '''List<double> priceRange = <double>[10, 240];

ElSlider(
  values: priceRange,
  min: 0,
  max: 500,
  step: 5,
  label: 'Price range',
  onChanged: (List<double> next) => setState(() => priceRange = next),
)''';

class _RangeSpecimen extends StatefulWidget {
  const _RangeSpecimen();

  @override
  State<_RangeSpecimen> createState() => _RangeSpecimenState();
}

class _RangeSpecimenState extends State<_RangeSpecimen> {
  List<double> _priceRange = <double>[10, 240];

  @override
  Widget build(BuildContext context) => SizedBox(
    width: el(80),
    child: ElSlider(
      key: const ValueKey<String>('slider-example:range'),
      values: _priceRange,
      min: 0,
      max: 500,
      step: 5,
      label: 'Price range',
      onChanged: (List<double> next) => setState(() => _priceRange = next),
    ),
  );
}

const String _multipleThumbsCode = '''List<double> tiers = <double>[20, 50, 80];

ElSlider(
  values: tiers,
  min: 0,
  max: 100,
  label: 'Budget tiers',
  onChanged: (List<double> next) => setState(() => tiers = next),
)''';

class _MultipleThumbsSpecimen extends StatefulWidget {
  const _MultipleThumbsSpecimen();

  @override
  State<_MultipleThumbsSpecimen> createState() =>
      _MultipleThumbsSpecimenState();
}

class _MultipleThumbsSpecimenState extends State<_MultipleThumbsSpecimen> {
  List<double> _tiers = <double>[20, 50, 80];

  @override
  Widget build(BuildContext context) => SizedBox(
    width: el(80),
    child: ElSlider(
      key: const ValueKey<String>('slider-example:multiple-thumbs'),
      values: _tiers,
      min: 0,
      max: 100,
      label: 'Budget tiers',
      onChanged: (List<double> next) => setState(() => _tiers = next),
    ),
  );
}

/// A live, functioning slider-plus-readout for the "Controlled" section:
/// proof the composition it documents actually renders and moves, not just
/// a code excerpt.
class _VolumeExample extends StatefulWidget {
  const _VolumeExample();

  @override
  State<_VolumeExample> createState() => _VolumeExampleState();
}

class _VolumeExampleState extends State<_VolumeExample> {
  List<double> _volume = <double>[50];

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return SizedBox(
      width: el(80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ElSlider(
            key: const ValueKey<String>('slider-example:controlled'),
            values: _volume,
            label: 'Volume',
            onChanged: (List<double> next) => setState(() => _volume = next),
          ),
          SizedBox(height: el(2)),
          ElText(
            'Volume: ${_volume.single.round()}',
            ElType.small,
            color: theme.mutedForeground,
          ),
        ],
      ),
    );
  }
}

const String _controlledCode = '''double volume = 50;

Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    ElSlider(
      values: [volume],
      label: 'Volume',
      onChanged: (List<double> next) => setState(() => volume = next.single),
    ),
    ElText('Volume: \${volume.round()}', ElType.small),
  ],
)''';

const String _disabledUsageCode = '''const ElSlider(
  values: <double>[40],
  enabled: false,
  label: 'Disabled',
)''';

class _DisabledSpecimen extends StatelessWidget {
  const _DisabledSpecimen();

  @override
  Widget build(BuildContext context) => SizedBox(
    width: el(80),
    child: const ElSlider(
      key: ValueKey<String>('slider-example:disabled'),
      values: <double>[40],
      enabled: false,
      label: 'Disabled',
    ),
  );
}

const String _priceFilterCode =
    '// priceRange holds the two thumb values, ascending.\n'
    'ElSlider(\n'
    '  values: priceRange,\n'
    '  min: 0,\n'
    '  max: 500,\n'
    '  step: 5,\n'
    "  label: 'Price range',\n"
    '  onChanged: (List<double> next) => setState(() => priceRange = next),\n'
    ')\n\n'
    '// ElSlider draws no numeric readout of its own: the caller states it.\n'
    'ElText(\n'
    "  '\${priceRange.first.round()} - \${priceRange.last.round()}',\n"
    '  ElType.small,\n'
    ')';

const String _ratingCode = '''ElSlider(
  values: <double>[rating],
  min: 0,
  max: 5,
  step: 1,
  label: 'Rating out of 5',
  onChanged: (List<double> next) => setState(() => rating = next.single),
)''';

/// The four-cell live specimen grid for the "Preview" section.
class _SliderPreview extends StatefulWidget {
  const _SliderPreview();

  @override
  State<_SliderPreview> createState() => _SliderPreviewState();
}

class _SliderPreviewState extends State<_SliderPreview> {
  List<double> _single = <double>[50];
  List<double> _range = <double>[20, 70];
  List<double> _custom = <double>[240];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: el(5),
      runSpacing: el(5),
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        ElStateCell(
          label: 'Single value',
          note: 'Drag or use the arrow keys',
          child: SizedBox(
            width: el(60),
            child: ElSlider(
              key: const ValueKey<String>('slider-live-specimen'),
              values: _single,
              label: 'Single value',
              onChanged: (List<double> next) => setState(() => _single = next),
            ),
          ),
        ),
        ElStateCell(
          label: 'Range',
          note: 'Two independent thumbs',
          child: SizedBox(
            width: el(60),
            child: ElSlider(
              key: const ValueKey<String>('slider-live-range-specimen'),
              values: _range,
              label: 'Range',
              onChanged: (List<double> next) => setState(() => _range = next),
            ),
          ),
        ),
        ElStateCell(
          label: 'Custom range and step',
          note: 'min: 0, max: 500, step: 5',
          child: SizedBox(
            width: el(60),
            child: ElSlider(
              values: _custom,
              min: 0,
              max: 500,
              step: 5,
              label: 'Custom range and step',
              onChanged: (List<double> next) => setState(() => _custom = next),
            ),
          ),
        ),
        ElStateCell(
          label: 'Disabled',
          child: SizedBox(
            width: el(60),
            child: const ElSlider(
              values: <double>[40],
              enabled: false,
              label: 'Disabled',
            ),
          ),
        ),
      ],
    );
  }
}

const String _previewCode = '''Wrap(
  spacing: 20,
  runSpacing: 20,
  children: [
    ElSlider(
      values: single,
      label: 'Single value',
      onChanged: (List<double> next) => setState(() => single = next),
    ),
    ElSlider(
      values: range,
      label: 'Range',
      onChanged: (List<double> next) => setState(() => range = next),
    ),
    ElSlider(
      values: custom,
      min: 0,
      max: 500,
      step: 5,
      label: 'Custom range and step',
      onChanged: (List<double> next) => setState(() => custom = next),
    ),
    const ElSlider(values: [40], enabled: false, label: 'Disabled'),
  ],
)''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsApiTable(title: 'ElSlider', facts: _sliderApiFacts),
        SizedBox(height: el(5)),
        const DocsApiTable(title: 'ElSlider statics', facts: _sliderStaticFacts),
        SizedBox(height: el(5)),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: ElWidths.prose),
          child: ElText(
            'What happens with an out-of-range value: ElSlider does not '
            'clamp the List<double> you pass into values. A number below '
            'min or above max still renders: pinned to the near edge of '
            'the track, because the fraction used to position the thumb '
            'and the fill is clamped to [0, 1]: but the accessibility '
            'value it announces is the raw, unclamped number you passed '
            'in, not the visual position. The moment the user actually '
            'moves that thumb, though, the move is clamped into legal '
            'range (bounded by min/max at the ends and by the '
            'neighbouring thumb elsewhere), so an out-of-range value is '
            'corrected on the very first interaction and can never be '
            'produced by dragging or the keyboard: only by a caller '
            'supplying it directly.',
            ElType.small,
            color: theme.mutedForeground,
          ),
        ),
      ],
    );
  }
}

const List<DocsApiFact> _sliderApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'values',
    type: 'List<double>',
    description:
        'Required. One entry renders a single-value slider; two or more '
        'render a range slider, one thumb per entry, in ascending order. '
        "Each thumb's own moves are clamped against its neighbours by "
        'INDEX, not by magnitude: the source never sorts this list, so '
        'the caller is expected to keep it ascending.',
  ),
  DocsApiFact(
    name: 'onChanged',
    type: 'ValueChanged<List<double>>?',
    description:
        'Called with the full next values list (same length) after a '
        'legal move. Null makes the control inoperable: the same "no '
        'handler, no operation" rule ElButton follows.',
  ),
  DocsApiFact(name: 'min', type: 'double', description: 'Defaults to 0.'),
  DocsApiFact(
    name: 'max',
    type: 'double',
    description:
        "Defaults to 100: the component's own default, not a design "
        'token.',
  ),
  DocsApiFact(
    name: 'step',
    type: 'double',
    description:
        'Defaults to 1. Every emitted value is min plus a whole multiple '
        'of step, clamped into [min, max]. Arrow keys move one step; Page '
        'Up/Page Down move ten steps. step <= 0 degrades to plain '
        'clamping with no quantisation.',
  ),
  DocsApiFact(
    name: 'enabled',
    type: 'bool',
    description:
        'Defaults to true. false dims the WHOLE control, track, fill and '
        'every thumb together: through one Opacity at 50%, and withdraws '
        'pointer and keyboard handling. Separate from a null onChanged, '
        'which leaves it at full opacity but still inoperable.',
  ),
  DocsApiFact(
    name: 'label',
    type: 'String?',
    description:
        "Optional accessible name, read by every thumb's own Semantics "
        'node. On a range slider both thumbs announce the identical '
        'string: there is no separate "minimum"/"maximum" label. Left '
        'null, a thumb has no accessible name at all, only a raw numeric '
        'value.',
  ),
];

const List<DocsApiFact> _sliderStaticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ElSlider.trackHeight',
    type: 'static double',
    description:
        "10px: the height of the whole control, since the root box IS "
        'the track.',
  ),
  DocsApiFact(
    name: 'ElSlider.thumbSize',
    type: 'static double',
    description:
        '20px: each thumb overflows the 10px track by 5px top and '
        'bottom.',
  ),
];

class _StatesContent extends StatelessWidget {
  const _StatesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsStateMatrix(facts: _stateFacts),
      SizedBox(height: el(4)),
      ElText(
        'Omitted: Selected: a slider has no boolean "on" state to select; '
        'its whole value IS the state, covered above and in API. Error, '
        'ElSlider defines no invalid parameter and no ElFieldScope '
        'participation at all; it is, in the source\'s own words, the one '
        'control in this family with "no field participation ... no '
        'aria-invalid, no data-invalid, no FieldScope": so there is no '
        'destructive-ring row to show, and this page will not invent one. '
        'Loading and Empty, ElSlider is a synchronous primitive with no '
        'async operation and nothing to list. Success: the component '
        'defines no success semantics of its own. Also unlike its '
        'checkbox/switch/radio siblings, ElSlider never imports '
        'ElJellyReplay: there is no post-change squash animation anywhere '
        'in this control.',
        ElType.small,
        color: ElTheme.of(context).mutedForeground,
      ),
    ],
  );
}

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest',
    treatment:
        'Track: theme.muted fill, theme.input border, ElShadows.pressed. '
        'Thumb: theme.foreground, bordered theme.input, ElShadows.btn, '
        'with a zero-alpha ring slot already reserved.',
    userSignal:
        'A recessed 10px channel with the fill (theme.actionInk) showing '
        'how far the value has travelled, and a raised knob resting on '
        'top of it.',
  ),
  DocsStateFact(
    state: 'Hover',
    treatment:
        "Entering the thumb's 34x34 hit area (not the painted 20px knob) "
        'fades a theme.ring ring in at 50% alpha over 250ms on '
        'ElCurves.spring, and the knob SNAPS: not tweens: to 1.10x scale '
        'in a single frame.',
    userSignal:
        'A visible ring plus a knob that instantly looks 10% larger the '
        'moment the pointer nears it, before any press.',
  ),
  DocsStateFact(
    state: 'Active (pressed / dragging)',
    treatment:
        'The same ring, held lit, and the knob snaps to 1.25x scale '
        'instead of 1.10x, "grabbing it springs the knob up, like '
        'picking it out of the groove," in the source\'s own words.',
    userSignal:
        'The largest the knob ever gets, for as long as the pointer is '
        'down, whether or not the value is actually changing.',
  ),
  DocsStateFact(
    state: 'Focus-visible',
    treatment:
        'Focusing a thumb lights the identical ring the hover and active '
        'states use, ElSlider has no separate focus-only ring.',
    userSignal:
        'A visible ring with no scale change, since focus alone does not '
        'touch the transform.',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment:
        'enabled: false wraps the ENTIRE control: track, fill and every '
        'thumb together: in one Opacity at 50%, and gates the whole '
        'gesture/keyboard surface with IgnorePointer; canRequestFocus '
        'turns false too, so a disabled thumb leaves the tab order.',
    userSignal:
        'Dimmed as one flat unit and completely inert: a click or a step '
        'key does nothing.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        "The ring's colour tween collapses to zero via "
        'elAnimationDuration; the scale snap was never animated in the '
        'first place, so reduced motion changes only the ring.',
    userSignal:
        'The ring appears or disappears instantly instead of springing; '
        "the knob's grow/shrink was always instant and stays that way.",
  ),
];

const List<DocsInstallFact> _a11yFacts = <DocsInstallFact>[
  DocsInstallFact(
    label: 'Semantic role',
    value:
        'Semantics(slider: true, value:, increasedValue:, decreasedValue:)',
    description:
        'Each thumb gets its own Semantics node with slider: true, '
        'container: true and enabled: reflecting whether the control is '
        'actually operable (enabled && onChanged != null): not '
        'ElSlider.enabled alone.',
  ),
  DocsInstallFact(
    label: 'Label association',
    value: 'label',
    description:
        "Fed directly to every thumb's Semantics.label. It is optional: "
        'leave it null and a thumb announces a numeric value with NO '
        'accessible name at all. On a range slider the identical string '
        'is read by both thumbs; there is no per-thumb '
        '"minimum"/"maximum" distinction, reproduced from the '
        'reference\'s own single aria-label="Price range" on both '
        'handles.',
  ),
  DocsInstallFact(
    label: 'Value announcement',
    value: 'Semantics.value, recomputed on every rebuild',
    description:
        'ElSlider does supply a live value announcement that updates as '
        'the thumb moves: printed as a bare integer ("40") when the '
        "value lands on a whole number and as Dart's default decimal "
        'string otherwise, with no percentage sign, no unit and no '
        'surrounding words. A caller who needs "40%" or "\$40" has to '
        'say so themselves: the control announces the number alone.',
  ),
  DocsInstallFact(
    label: 'Keyboard activation',
    value: 'Arrow, Page and Home/End keys; see Keyboard below',
    description:
        'Wired by hand through Focus.onKeyEvent per thumb: see the '
        'Keyboard disclosure below for the exact key list, verified '
        "directly against the shipped implementation and against the "
        "package's own test/slider_test.dart \"keyboard\" group.",
  ),
  DocsInstallFact(
    label: 'Focus behavior',
    value: 'One FocusNode per thumb: a range is two tab stops',
    description:
        "Each thumb's own Focus widget requests and reports its own "
        'focus; arrow keys only move whichever thumb currently holds it, '
        'verified independently for both thumbs on this page.',
  ),
  DocsInstallFact(
    label: 'Touch target',
    value: '34 x 34, centred on each 20 x 20 thumb',
    description:
        'ElHitArea grows the pointer AND hover target past the painted '
        "knob, 8px past its 18px padding box on every side, per "
        "selection_control.dart's own measured table. The track itself "
        'carries no extra inset of its own.',
  ),
  DocsInstallFact(
    label: 'Non-colour signal',
    value: 'Thumb position, plus how much of the track is lit',
    description:
        'The value is legible from where the knob sits and how much of '
        "the channel is filled, independent of the fill's hue.",
  ),
  DocsInstallFact(
    label: 'Error wiring',
    value: 'None',
    description:
        'ElSlider has no invalid parameter and does not read or fold in '
        'an enclosing ElFieldScope\'s invalid flag at all: the one '
        "control in this family with no field participation, stated in "
        "the source's own docstring. A caller who needs an error state "
        'around a slider has to build one outside the control, not '
        'through the widget itself.',
  ),
  DocsInstallFact(
    label: 'Screen-reader announcements',
    value: 'No separate live region',
    description:
        'State changes are exposed purely through the value/'
        "increasedValue/decreasedValue on each thumb's own Semantics "
        'node: there is no extra SemanticsService.announce call.',
  ),
  DocsInstallFact(
    label: 'Known drift',
    value: "A range slider's two thumbs share one label",
    description:
        "Reproduced from the reference's own aria-label=\"Price range\" "
        'on both handles. A screen reader has no built-in way to tell '
        'which of the two thumbs it is currently on beyond its live '
        'value.',
  ),
];

/// Read directly off `lib/src/components/slider.dart`'s own `_onKey`: unlike
/// `switch` and `checkbox`, `slider` wires its own key handler rather than
/// composing `selection_control.dart`'s shared one.
class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Right and Up add one step; Left and Down take one away; Page Up '
            'moves ten steps forward and Page Down ten steps back; Home '
            'and End jump straight to min and max. Every one of them '
            'lands in a single frame: the thumb\'s transition list covers '
            'transform and box-shadow, and its position is left, so '
            'nothing interpolates it.',
        '_onKey only inspects KeyDownEvent when the slider is operable '
            '(enabled && onChanged != null); a matching KeyUpEvent, or '
            'any key on an inoperable slider, returns '
            'KeyEventResult.ignored so it keeps propagating.',
        'Tab order: canRequestFocus is wired to the same operable '
            'predicate, enabled && onChanged != null: a disabled slider, '
            'or one with a null onChanged, leaves every thumb out of '
            'keyboard traversal entirely.',
        'One FocusNode per thumb, not one per slider: a range slider is '
            'two separate tab stops, and an arrow or Page key only moves '
            'whichever thumb currently holds focus.',
        'No custom ordering: slider.dart wires no FocusTraversalPolicy '
            'of its own beyond each thumb\'s own Focus widget. Tab and '
            'Shift+Tab walk whatever order the surrounding page already '
            'declares.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Unlike its checkbox/switch/radio siblings, ElSlider is not a '
            'fixed-size atom: ElSlider.trackHeight (10px) and '
            'ElSlider.thumbSize (20px) are fixed, but the control\'s '
            'WIDTH is fluid: a LayoutBuilder measures whatever width its '
            'parent constrains it to, and every fraction (thumb '
            'position, fill length) is computed against that measured '
            'width on every layout pass.',
        'The same ElSlider genuinely stretches from a narrow mobile '
            'column to a wide desktop panel with no breakpoint logic of '
            'its own; what changes with layout belongs entirely to '
            'whatever composes it.',
        'Keyboard and pointer activation behave identically on every '
            'Flutter target this package supports: there is no platform '
            'channel and nothing here is web-only or desktop-only, '
            'though a coarse (touch) pointer still has to land within '
            'the same 34 x 34 hit area a mouse does; there is no '
            'separate touch-specific target.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DocsInstallFacts(
        title: 'Dependencies, files, assets, fonts and shaders',
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Source file',
            value: sliderDoc.sourcePath,
            description: 'The authoritative implementation.',
          ),
          const DocsInstallFact(
            label: 'Local file dependencies',
            value: 'button.dart, selection_control.dart',
            description:
                'slider.dart imports these directly from '
                'lib/src/components: button.dart for '
                'ElButton.withFocusRing (the ring-prepending shadow '
                "helper the thumb uses) and selection_control.dart for "
                'ElHitArea, the shared hit-area/expander machinery every '
                'control in this family relies on. Neither is copyable '
                'in isolation: see Installation.',
          ),
          const DocsInstallFact(
            label: 'Foundation dependencies',
            value:
                'effects/machine_surface.dart, foundation/motion.dart, '
                'foundation/shadows.dart, foundation/spacing.dart, '
                'foundation/theme.dart, theme_scope.dart',
            description:
                'ElMachineSurface for the track/fill/thumb painting, the '
                'sliderThumbHoverScale/sliderThumbActiveScale transform '
                'tokens, ElShadows.pressed/btn/btnPrimary, the el() '
                'spacing scale, and the live theme.',
          ),
          DocsInstallFact(
            label: 'Exports',
            value: sliderDoc.exports.join(', '),
            description:
                'The public symbols this component makes available: a '
                'single class, unlike checkbox/switch which each also '
                'export a state enum.',
          ),
          const DocsInstallFact(
            label: 'Assets',
            value: 'none',
            description:
                'The track, fill and thumb are ElMachineSurface fills, '
                'not an image or an icon-font glyph.',
          ),
          const DocsInstallFact(
            label: 'Fonts',
            value: 'none',
            description: 'No text is rendered by ElSlider itself.',
          ),
          const DocsInstallFact(
            label: 'Shaders',
            value: 'none',
            description: 'No fragment shader is used.',
          ),
        ],
      ),
      SizedBox(height: el(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Button', route: '/components/button'),
          DocsLink(
            label: 'Selection control',
            route: '/components/selection_control',
          ),
        ],
      ),
    ],
  );
}

const List<DocsInstallFact> _themingFacts = <DocsInstallFact>[
  DocsInstallFact(
    label: 'Track fill / border',
    value: 'theme.muted / theme.input',
    description: 'The sunken channel.',
  ),
  DocsInstallFact(
    label: 'Filled range',
    value: 'theme.actionInk: never theme.primary',
    description:
        'The source measures theme.primary at 1.63:1 contrast against '
        'theme.muted on this palette and theme.actionInk at 6.88:1, so '
        'the fill deliberately uses the theme-split action-ink token '
        'instead.',
  ),
  DocsInstallFact(
    label: 'Thumb fill / border',
    value: 'theme.foreground / theme.input',
    description: 'The raised knob.',
  ),
  DocsInstallFact(
    label: 'Ring colour',
    value: 'theme.ring, at 50% alpha when hovered, dragged or focused',
    description:
        "Prepended in front of ElShadows.btn's own four layers via "
        'ElButton.withFocusRing: never replacing them.',
  ),
  DocsInstallFact(
    label: 'Shadow',
    value:
        'ElShadows.pressed (track) / ElShadows.btnPrimary (range) / '
        'ElShadows.btn (thumb)',
    description:
        'The raised/recessed vocabulary this control shares with '
        'checkbox, switch and radio.',
  ),
  DocsInstallFact(
    label: 'Radius',
    value: 'ElRadii.pill (track ends) / full circle (thumb)',
    description:
        "The range itself paints no radius of its own: the track's "
        "ClipRRect gives it its corners.",
  ),
  DocsInstallFact(
    label: 'Motion',
    value:
        'ElDurations.transitionDefault on ElCurves.spring (ring only); '
        'the scale change is unanimated',
    description:
        "The ring tweens and can overshoot before settling; the "
        "hover/active scale snaps to its target in a single frame, since "
        "Tailwind's scale utility on the reference is not part of its "
        'transition list. elAnimationDuration collapses the ring\'s '
        'duration to zero under reduced motion.',
  ),
];

Widget _bullets(ElThemeData theme, List<String> lines) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    for (final String line in lines) ...<Widget>[
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: ElWidths.prose),
        child: ElText('•  $line', ElType.small, color: theme.mutedForeground),
      ),
      SizedBox(height: el(2)),
    ],
  ],
);
