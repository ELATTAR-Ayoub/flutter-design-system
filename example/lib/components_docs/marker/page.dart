/// Public documentation page for the `marker` component.
///
/// **Re-housed onto the kit.** This page used to hand-compose `ElSection`
/// panels; it now declares a `ComponentDocSpec`
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// `ComponentDocPage`, the shape `button` established. Every specimen
/// widget and every code string the old page carried moves across
/// unchanged. Three things are new: the unheaded live demo is now a real
/// `Preview` section with its own rail entry; two sections that were pure
/// prose with no live specimen ("What the name gets wrong", "How the
/// separator splits the row") become `SnippetSection`s, their bullets
/// folded into one comment block each, since a `ShowcaseSection` needs a
/// specimen this component has nothing further to show beyond what Preview
/// and Choosing a variant already stage — the same treatment `field`'s own
/// Anatomy section uses; and a Keyboard disclosure now sits between
/// Accessibility and Responsive, carrying the one focus/tap-order fact that
/// used to live inside Accessibility.
///
/// **The manifest is real.** `registry/components/marker.json` ships
/// today: `elattar add marker` installs `lib/src/components/marker.dart`
/// and resolves `source-foundation` automatically. The pre-kit page
/// claimed no manifest existed; it does, and the command below is real.
///
/// **No shadcn counterpart.** `marker` is not in shadcn's documented
/// component set, so this page is not shaped to a reference page and its
/// sections are not named after shadcn headings. They are named for what
/// the component does, taken from `lib/src/components/marker.dart`'s own
/// library note, whose first job is to correct the name: this is not
/// `<mark>`, it draws no background, and it will not emphasise a matched
/// substring. It is the row that says something happened between the rows
/// around it.
///
/// **Not ported, and named as such:** `asChild` and the `[a]:` rules under
/// it. A marker with a link inside it is the reference file's own idea and
/// nothing in the corpus writes one, so there is no anchor path here to
/// document.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import 'meta.dart';

final ComponentDocSpec markerDocSpec = ComponentDocSpec(
  name: 'marker',
  title: markerDoc.title,
  description: markerDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'All three variants, top to bottom: a bare row, a rule-label-'
          'rule divider, and a label with a rule under it. Not a '
          'highlight: ElMarker draws no background on any variant and '
          'will not emphasise a matched substring.',
      specimen: const KeyedSubtree(
        key: ValueKey<String>('marker-preview'),
        child: _AllVariants(),
      ),
      code: _variantsCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'marker has a real registry manifest, `elattar add marker` '
          'installs lib/src/components/marker.dart and resolves '
          'source-foundation automatically. The Manual tab is for a '
          'project not using the CLI.',
      command: markerDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/marker.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/marker.dart's generated "
              '@ui/marker.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated marker source here when using '
              'manual mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ElMarker and ElMarkerVariant are '
              'reachable the same way the CLI path already makes them.',
          code: "export 'marker.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct import and construction. label is the '
          'only required argument.',
      code: _usageCode,
    ),
    SnippetSection(
      id: 'not-a-mark',
      title: 'What the name gets wrong',
      description:
          'The name is the trap, and the source file says so before it '
          'says anything else. Read this before reaching for this '
          'widget: nothing live to stage beyond the correction itself, so '
          'here it is as a note rather than a manufactured specimen.',
      code: _notAMarkCode,
    ),
    ShowcaseSection(
      id: 'variants',
      title: 'Choosing a variant',
      description:
          'Three variants, and the choice is about what is being '
          'separated, not about how loud the row should be. All three '
          'draw the same muted label; what changes is the rule work '
          'around it.',
      specimen: const KeyedSubtree(
        key: ValueKey<String>('marker-example:variants'),
        child: _AllVariants(),
      ),
      code: _variantsCode,
      label: 'Choosing a variant specimen view',
    ),
    ShowcaseSection(
      id: 'in-a-list',
      title: 'Marking a row in a list',
      description:
          'A marker read on its own is almost nothing. It only makes '
          'sense between the rows it is annotating, which is the one '
          'place it is meant to appear: separator to divide before from '
          'after, border to head what follows, normal inside a '
          'container that already frames it.',
      specimen: const KeyedSubtree(
        key: ValueKey<String>('marker-example:in-a-list'),
        child: _InAList(),
      ),
      code: _inAListCode,
      label: 'Marking a row in a list specimen view',
    ),
    ShowcaseSection(
      id: 'icon',
      title: 'Adding an icon',
      description:
          'icon is an optional widget, and the row forces it into a '
          'square of el(4) with ElMarker.gap after it. It sits after the '
          'leading rule under the separator variant, so the glyph reads '
          'as part of the label rather than as part of the divider. Keep '
          'it decorative: the row carries no semantics of its own for it.',
      specimen: const KeyedSubtree(
        key: ValueKey<String>('marker-example:icon'),
        child: _WithIcon(),
      ),
      code: _iconCode,
      label: 'Adding an icon specimen view',
    ),
    SnippetSection(
      id: 'rules',
      title: 'How the separator splits the row',
      description:
          'The separator variant is the only one whose layout is worth '
          'explaining, because the two rules and the label share the '
          'width in a specific order. Nothing live to add beyond the '
          'separator specimen above, so the measurements are laid out '
          'here instead.',
      code: _rulesCode,
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter, every static measurement, and '
          'every enum value, read straight off lib/src/components/'
          'marker.dart.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'ElMarker', anchor: 'api-elmarker'),
        DocsTocEntry(
          title: 'ElMarker measurements',
          anchor: 'api-elmarker-static',
        ),
        DocsTocEntry(title: 'ElMarkerVariant', anchor: 'api-elmarkervariant'),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'ElMarker is a StatelessWidget with no gesture detector, no '
          'focus node, and no animation. It has no interaction states at '
          'all, and this table says so rather than inventing some.',
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
      child: _OneSentence(
        'Nothing is focusable and nothing is tappable: there is no Focus '
        'widget, no FocusNode, and no gesture detector anywhere in '
        'marker.dart, so ElMarker never enters the tab order and has no '
        'keyboard interaction to describe.',
      ),
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
            value: markerDoc.sourcePath,
            description:
                'Authoritative implementation. Its library note is the '
                'spec, measurements included, and is the truth this page '
                'was written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'none yet',
            description: 'No dedicated marker test in the package suite yet.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/marker_test.dart',
            description:
                'Covers this page: the article mounts, the section order, '
                'all three API tables, a live specimen of every '
                'ElMarkerVariant value, and a theme flip.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/marker/page.dart',
            description: 'This file.',
          ),
          const DocsInstallFact(
            label: 'Split from',
            value: 'example/lib/components_docs/carousel/page.dart',
            description:
                'Where this component was documented before 2026-08-24.',
          ),
        ],
      ),
    ),
  ],
);

class MarkerDocPage extends StatelessWidget {
  const MarkerDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: markerDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / LAYOUT & UI',
      title: markerDoc.title,
      description: markerDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Marker'),
    ],
    toc: markerDocSpec.toc,
    previous: const DocsPageLink(title: 'Kbd', route: '/components/kbd'),
    next: const DocsPageLink(title: 'Menubar', route: '/components/menubar'),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('marker-doc-article'),
      child: ComponentDocPage(spec: markerDocSpec, header: false),
    ),
  );
}

/* ── Disclosure content ─────────────────────────────────────────────────── */

/// One honest sentence, for a disclosure this component has nothing more to
/// say under.
class _OneSentence extends StatelessWidget {
  const _OneSentence(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: ElWidths.prose),
    child: ElText(
      text,
      ElType.small,
      color: ElTheme.of(context).mutedForeground,
    ),
  );
}

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elmarker',
        child: DocsApiTable(title: 'ElMarker', facts: _markerFacts),
      ),
      SizedBox(height: el(6)),
      const DocsAnchor(
        id: 'api-elmarker-static',
        child: DocsApiTable(
          title: 'ElMarker measurements',
          facts: _markerStaticFacts,
        ),
      ),
      SizedBox(height: el(6)),
      const DocsAnchor(
        id: 'api-elmarkervariant',
        child: DocsApiTable(title: 'ElMarkerVariant', facts: _variantFacts),
      ),
    ],
  );
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'The label is ordinary ElText, so a screen reader reads it as '
            'prose in document order, between the rows it sits between. '
            'That is the whole of the semantic behaviour.',
        'Known gap: no semantic boundary. The row is not a separator '
            'role, not a heading, and not a landmark, even under the '
            'border variant, which visually heads what follows. A reader '
            'hears the text and infers the break from the wording alone.',
        'Which means the wording carries the whole message. Write a '
            'label that says what happened ("3 messages hidden", '
            '"Today"), not one that only makes sense next to the rule '
            '("above", "before this").',
        'The rules are painted boxes with no text and no semantics, so '
            'they add nothing to and take nothing from the announcement.',
        'The icon is passed through as-is. Anything it announces is the '
            "caller's; the row itself neither labels it nor hides it, so "
            'pass a decorative glyph.',
        'Colour is not the only signal: the label is real text under '
            'every variant, so a low-contrast or monochrome view still '
            'reads it.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No breakpoint is read anywhere in marker.dart, and no width is '
            'branched on. The same tree renders at 390px and at 1440px.',
        'Under separator the layout is intrinsically fluid: the two '
            'Expanded rules absorb every change in available width, so a '
            'narrower row shortens the rules and leaves the label alone.',
        'A label long enough to fill the row squeezes the rules toward '
            'zero rather than wrapping under them: the label is Flexible, '
            'so it takes what it needs first.',
        'Under normal and border the label is Expanded and wraps as '
            'ordinary text would: ElMarker sets no maxLines and adds no '
            'ellipsis, so a long label grows the row taller.',
        'Vertical rhythm is the caller\'s: ElMarker adds no margin above '
            'or below itself, only ElMarker.borderPadding under the '
            'border variant. Spacing between a marker and its neighbours '
            'is the list\'s own.',
        'Platform parity: identical on Android, iOS, Web, macOS, '
            'Windows, and Linux. No dart:io Platform branch in the file.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => _bullets(ElTheme.of(context), <String>[
    'File: lib/src/components/marker.dart, one file, holding ElMarker '
        'and ElMarkerVariant and nothing private at all.',
    'Flutter import: package:flutter/widgets.dart only.',
    'Foundation imports: foundation/spacing.dart (el(), '
        'ElWidths.hairline), foundation/theme.dart (ElThemeData), '
        'foundation/typography.dart (ElComponentType), theme_scope.dart '
        '(ElText, ElTheme).',
    'Component imports: none. This is the only one of the three '
        'components split out of the old carousel page that depends on '
        'no other component.',
    'Registry dependencies: source-foundation, the shipped manifest\'s '
        'own registryDependencies list, verbatim.',
    'Assets: none. Fonts: none beyond the system type scale. Shaders: '
        'none.',
  ]);
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Two colours, both read live off ElTheme.of(context) at build '
            'time: theme.mutedForeground for the label, theme.border for '
            'the rules and for the bottom border of the border variant.',
        'No colour parameter exists. A caller cannot recolour the label '
            'or the rules without wrapping or forking the widget.',
        'Type is ElComponentType.textSm, fixed. There is no spec '
            'parameter, so a marker cannot be made larger or bolder from '
            'a call site.',
        'Rule thickness is ElWidths.hairline in both places it appears, '
            'so the divider and the bottom border always match.',
        'Flipping ElThemeController re-resolves both colours on the '
            'next frame; nothing is cached.',
        'Geometry is not themeable: gap, minHeight, ruleGap, and '
            'borderPadding are static getters over the 4px grid, exposed '
            'for reading rather than for overriding.',
      ]);
}

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

const List<DocsApiFact> _markerFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'label',
    type: 'String',
    description:
        'Required, no default. The whole of the row\'s text, drawn at '
        'ElComponentType.textSm in theme.mutedForeground. Centre-aligned '
        'under the separator variant, left-aligned under the other two.',
  ),
  DocsApiFact(
    name: 'variant',
    type: 'ElMarkerVariant',
    description:
        'Optional. Defaults to ElMarkerVariant.normal. Chooses the rule '
        'work around the label: see the ElMarkerVariant table below.',
  ),
  DocsApiFact(
    name: 'icon',
    type: 'Widget?',
    description:
        'Optional. Defaults to null. Forced into a square of el(4) with '
        'ElMarker.gap after it, before the label and after the leading '
        'rule. Decorative: the row gives it no semantics.',
  ),
];

const List<DocsApiFact> _markerStaticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ElMarker.gap',
    type: 'static double',
    description: 'el(2). Between the icon and the label.',
  ),
  DocsApiFact(
    name: 'ElMarker.minHeight',
    type: 'static double',
    description:
        'el(4). The row\'s floor. No marker in the corpus reaches it, '
        "because the small text spec's own line box is already taller.",
  ),
  DocsApiFact(
    name: 'ElMarker.ruleGap',
    type: 'static double',
    description:
        'el(1). The air between a rule and the label under the separator '
        "variant, on top of the row's own gap.",
  ),
  DocsApiFact(
    name: 'ElMarker.borderPadding',
    type: 'static double',
    description:
        'el(2). The space between the label and the bottom border under '
        'the border variant.',
  ),
];

const List<DocsApiFact> _variantFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'normal',
    type: 'enum value',
    description:
        'The constructor default. A bare row, for a container that '
        'already frames it: no rules, no border. Named normal because '
        'default is a Dart keyword; the reference calls this variant '
        'default.',
  ),
  DocsApiFact(
    name: 'separator',
    type: 'enum value',
    description:
        'Rule, label, rule. Divides before from after. Both rules are '
        'Expanded and take whatever the label leaves; the label is '
        'Flexible and centred.',
  ),
  DocsApiFact(
    name: 'border',
    type: 'enum value',
    description:
        'A left-aligned label with one hairline border under it and '
        'ElMarker.borderPadding above that border. Heads what follows.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest',
    treatment:
        'The only state. A muted label, plus whichever rules the '
        'variant draws, at ElWidths.hairline in theme.border.',
    userSignal: 'A quiet row between louder ones.',
  ),
  DocsStateFact(
    state: 'Hover, focus, pressed',
    treatment:
        'None of them exist. There is no MouseRegion, no Focus, and no '
        'gesture detector anywhere in marker.dart, so the row never '
        'changes under a pointer or a keyboard.',
    userSignal: 'Nothing happens, by design.',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment:
        'Not applicable: nothing here is actionable, so there is '
        'nothing to disable and no disabled treatment.',
    userSignal: 'Not applicable.',
  ),
  DocsStateFact(
    state: 'Long label',
    treatment:
        'Under separator the label takes the width it needs and '
        'squeezes the rules. Under normal and border it wraps as '
        'ordinary text: no maxLines, no ellipsis.',
    userSignal: 'Shorter rules, or a taller row.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'Nothing animates, so MediaQuery.disableAnimations has nothing '
        'to act on. No token is read for timing anywhere in the file.',
    userSignal: 'Identical either way.',
  ),
];

/* ── Showcase specimens ─────────────────────────────────────────────────── */

/// One specimen of each [ElMarkerVariant] value, in enum order.
class _AllVariants extends StatelessWidget {
  const _AllVariants();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const ElMarker(label: 'Bare row, inside a frame that already exists'),
      SizedBox(height: el(6)),
      const ElMarker(
        variant: ElMarkerVariant.separator,
        label: 'Context cleared',
      ),
      SizedBox(height: el(6)),
      const ElMarker(variant: ElMarkerVariant.border, label: 'Today'),
    ],
  );
}

/// The one place a marker makes sense: between the rows it annotates.
class _InAList extends StatelessWidget {
  const _InAList();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const _ListRow(text: 'Draft the release note'),
      const _ListRow(text: 'Check the token guard'),
      SizedBox(height: el(3)),
      const ElMarker(
        variant: ElMarkerVariant.separator,
        label: '3 messages hidden',
      ),
      SizedBox(height: el(3)),
      const _ListRow(text: 'Split the carousel page'),
      SizedBox(height: el(3)),
      const ElMarker(variant: ElMarkerVariant.border, label: 'Yesterday'),
      SizedBox(height: el(3)),
      const _ListRow(text: 'Measure the footer row'),
    ],
  );
}

class _ListRow extends StatelessWidget {
  const _ListRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: el(2)),
    child: ElText(text, ElType.body),
  );
}

class _WithIcon extends StatelessWidget {
  const _WithIcon();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const ElMarker(
        icon: ElIcon.lucide(ElLucide.clock),
        label: 'Waiting on you',
      ),
      SizedBox(height: el(6)),
      const ElMarker(
        variant: ElMarkerVariant.separator,
        icon: ElIcon.lucide(ElLucide.eyeOff),
        label: 'Stopped by you',
      ),
    ],
  );
}

/* ── Code strings ───────────────────────────────────────────────────────── */

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

ElMarker(
  variant: ElMarkerVariant.separator,
  label: 'Today',
)''';

const String _notAMarkCode =
    '''// Not a highlight. The name misleads.
//
// * It is not an HTML mark element and not a highlight. It draws no
//   background of any kind, on any variant.
// * It will not emphasise a matched substring. label is one plain String
//   rendered whole; there is no range, no query, and no rich-text path
//   in the file. Search-result highlighting is not what this is.
// * What it is: the row that says something happened between the rows
//   around it. "Stopped by you", "Context cleared", "Today",
//   "3 messages hidden".
// * It is annotation, not content. The label is drawn in
//   theme.mutedForeground at the small text spec, quieter than the rows
//   it sits between, and that is deliberate.
// * Not ported: asChild and the anchor rules layered under it. A marker
//   with a link inside it is the reference file's own idea and nothing
//   in the corpus writes one, so there is no anchor variant here to
//   document.
//
// Reach for instead, if you wanted a highlight: nothing on this page
// will tint a run of text. ElMarker has no such capability.''';

const String _variantsCode =
    '''// normal: a bare row, for a container that already frames it.
const ElMarker(label: 'Bare row, inside a frame that already exists')

// separator: rule, label, rule. Divides before from after.
const ElMarker(
  variant: ElMarkerVariant.separator,
  label: 'Context cleared',
)

// border: a label with a hairline under it. Heads what follows.
const ElMarker(variant: ElMarkerVariant.border, label: 'Today')''';

const String _inAListCode = '''Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: <Widget>[
    ListRow(text: 'Draft the release note'),
    ListRow(text: 'Check the token guard'),
    const ElMarker(
      variant: ElMarkerVariant.separator,
      label: '3 messages hidden',
    ),
    ListRow(text: 'Split the carousel page'),
    const ElMarker(
      variant: ElMarkerVariant.border,
      label: 'Yesterday',
    ),
    ListRow(text: 'Measure the footer row'),
  ],
)''';

const String _iconCode = '''const ElMarker(
  icon: ElIcon.lucide(ElLucide.clock),
  label: 'Waiting on you',
)

const ElMarker(
  variant: ElMarkerVariant.separator,
  icon: ElIcon.lucide(ElLucide.eyeOff),
  label: 'Stopped by you',
)''';

const String _rulesCode =
    '''// The separator variant's own layout, measured on a 1030px row with
// a 231.05px label:
//
//   387.469  +  4  +  231.05  +  4  +  387.484
//   ^rule       ^gap  ^label    ^gap  ^rule
//
// * The rules are Expanded, so they take whatever the label leaves.
//   They are not a fixed fraction of the row.
// * The label is Flexible under separator (centred) and Expanded under
//   the other two variants. That difference stops the label from
//   eating both rules under separator.
// * Between each rule and the label sits ElMarker.ruleGap (el(1)), on
//   top of the row's own ElMarker.gap between icon and label: two
//   different gaps, not one.
// * Each rule is ElWidths.hairline tall, painted in theme.border. The
//   two rules above differ by fifteen thousandths of a pixel because
//   the label's own width is fractional.
// * The border variant does none of this: a plain row with
//   ElMarker.borderPadding underneath and one hairline bottom border,
//   label left-aligned.
// * ElMarker.minHeight (el(4)) is a floor no marker in the corpus
//   actually reaches: the small text spec's own line box is already
//   taller than 16px.''';
