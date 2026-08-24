/// Public documentation page for the `marker` component.
///
/// **Split, 2026-08-24.** `ElMarker` and `ElMarkerVariant` used to be
/// documented inside `components_docs/carousel/page.dart` under a single
/// "Marker variants" section that was nothing but an enum table. They are
/// their own barrel export and now own this page; nothing about carousel or
/// nav_user appears here.
///
/// **No shadcn counterpart.** `marker` is not in shadcn's documented
/// component set, so this page is not shaped to a reference page and its
/// sections are not named after shadcn headings. They are named for what the
/// component does, taken from `lib/src/components/marker.dart`'s own library
/// note, whose first job is to correct the name: this is not `<mark>`, it
/// draws no background, and it will not emphasise a matched substring. It is
/// the row that says something happened between the rows around it.
///
/// **Not ported, and named as such:** `asChild` and the `[a]:` rules under
/// it. A marker with a link inside it is the reference file's own idea and
/// nothing in the corpus writes one, so there is no anchor path here to
/// document.
///
/// Section order follows `components_docs/button/page.dart`: an unheaded live
/// demo, Installation, Usage, this component's own sections, API Reference
/// last of those, then States / Accessibility / Responsive / Dependencies /
/// Theming / Source.
///
/// [ComponentDocEntry.description] is the page's only hero text.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

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
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Installation', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'What the name gets wrong', anchor: 'not-a-mark'),
      DocsTocEntry(title: 'Choosing a variant', anchor: 'variants'),
      DocsTocEntry(title: 'Marking a row in a list', anchor: 'in-a-list'),
      DocsTocEntry(title: 'Adding an icon', anchor: 'icon'),
      DocsTocEntry(title: 'How the separator splits the row', anchor: 'rules'),
      DocsTocEntry(
        title: 'API Reference',
        anchor: 'api',
        children: <DocsTocEntry>[
          DocsTocEntry(title: 'ElMarker', anchor: 'api-elmarker'),
          DocsTocEntry(
            title: 'ElMarker measurements',
            anchor: 'api-elmarker-static',
          ),
          DocsTocEntry(title: 'ElMarkerVariant', anchor: 'api-elmarkervariant'),
        ],
      ),
      DocsTocEntry(title: 'States', anchor: 'states'),
      DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
      DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
      DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
      DocsTocEntry(title: 'Theming', anchor: 'theming'),
      DocsTocEntry(title: 'Source', anchor: 'source'),
    ],
    previous: const DocsPageLink(title: 'Kbd', route: '/components/kbd'),
    next: const DocsPageLink(title: 'Menubar', route: '/components/menubar'),
    onNavigate: onNavigate,
    child: const _ArticleContent(),
  );
}

class _ArticleContent extends StatelessWidget {
  const _ArticleContent();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      key: const ValueKey<String>('marker-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _liveDemo(),
        SizedBox(height: el(6)),
        _install(),
        SizedBox(height: el(6)),
        _usage(),
        SizedBox(height: el(6)),
        _notAMark(theme),
        _variants(),
        _inAList(),
        _icon(),
        _rules(theme),
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

  /// The live demo that opens the page: no [ElSection], no anchor, no TOC
  /// entry, matching every other page in the corpus.
  Widget _liveDemo() => DocsCodeExample(
    title: 'Marker',
    description:
        'All three variants, top to bottom: a bare row, a rule-label-rule '
        'divider, and a label with a rule under it.',
    preview: const KeyedSubtree(
      key: ValueKey<String>('marker-preview'),
      child: _AllVariants(),
    ),
    manualFiles: const <DocsCodeFile>[
      DocsCodeFile(
        path: 'marker_preview.dart',
        title: 'Three variants',
        code: _variantsCode,
      ),
    ],
  );

  Widget _install() => ElSection(
    id: 'install',
    title: 'Installation',
    description:
        'marker ships in the registry, so `elattar add marker` is '
        'not available: install by copying the source file manually. It is '
        'the cheapest copy of the three components split out of the old '
        'carousel page: one file, no component imports at all.',
    child: DocsInstallFacts(
      title: 'Installation facts',
      facts: <DocsInstallFact>[
        const DocsInstallFact(
          label: 'Registry item',
          value: 'registry/components/marker.json',
          description:
              'No registry/components/marker.json exists. This is a '
              'source-only component today, and the command a manifest '
              'would enable is deliberately not shown.',
        ),
        const DocsInstallFact(
          label: 'Manual copy target',
          value: 'lib/components/ui/marker.dart',
          description: 'Where the CLI itself would place the file.',
        ),
        const DocsInstallFact(
          label: 'Foundation',
          value: 'source only',
          description: 'No package-backed alternative is offered yet.',
        ),
        const DocsInstallFact(
          label: 'Would-be dependencies',
          value: 'source-foundation',
          description:
              'The whole list. marker.dart imports no other component: '
              'spacing, theme, and typography from the foundation, and '
              'package:flutter/widgets.dart.',
        ),
        const DocsInstallFact(
          label: 'Assets',
          value: 'none',
          description:
              'No images or icon fonts. The optional icon is a widget the '
              'caller supplies.',
        ),
        const DocsInstallFact(
          label: 'Platforms',
          value: 'Android, iOS, Web, macOS, Windows, Linux',
          description: 'No platform-conditional code anywhere in the file.',
        ),
        const DocsInstallFact(
          label: 'Verified',
          value: 'docs specimen only',
          description:
              "This page's live specimens and example/test/components_docs/"
              'marker_test.dart. No dedicated package-level unit test '
              'exists yet.',
        ),
      ],
    ),
  );

  Widget _usage() => ElSection(
    id: 'usage',
    title: 'Usage',
    description:
        'The smallest correct import and construction. label is the only '
        'required argument.',
    child: ElPanel(
      label: 'DART',
      note: 'MINIMAL',
      child: DocsSelectableCodeBlock(code: _usageCode),
    ),
  );

  Widget _notAMark(ElThemeData theme) => ElSection(
    id: 'not-a-mark',
    title: 'What the name gets wrong',
    description:
        'The name is the trap, and the source file says so before it says '
        'anything else. Read this section before reaching for this widget.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _bullets(theme, <String>[
          'It is not an HTML mark element and not a highlight. It draws no '
              'background of any kind, on any variant.',
          'It will not emphasise a matched substring. label is one plain '
              'String rendered whole; there is no range, no query, and no '
              'rich-text path in the file. Search-result highlighting is '
              'not what this is.',
          'What it is: the row that says something happened between the '
              'rows around it. "Stopped by you", "Context cleared", '
              '"Today", "3 messages hidden".',
          'It is annotation, not content. The label is drawn in '
              'theme.mutedForeground at the small text spec, quieter than '
              'the rows it sits between, and that is deliberate.',
          'Not ported: asChild and the anchor rules layered under it. A '
              'marker with a link inside it is the reference file\'s own '
              'idea and nothing in the corpus writes one, so there is no '
              'anchor variant here to document.',
        ]),
        SizedBox(height: el(2)),
        ElPanel(
          label: 'REACH FOR INSTEAD',
          note: 'IF YOU WANTED A HIGHLIGHT',
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: ElWidths.prose),
            child: ElText(
              'Nothing on this page will tint a run of text. If that is '
              'what you came for, this component is the wrong one and the '
              'right one is not documented here: ElMarker has no such '
              'capability and this page will not imply otherwise.',
              ElType.small,
              color: theme.mutedForeground,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _variants() => ElSection(
    id: 'variants',
    title: 'Choosing a variant',
    description:
        'Three variants, and the choice is about what is being separated, '
        'not about how loud the row should be. All three draw the same '
        'muted label; what changes is the rule work around it.',
    child: DocsCodeExample(
      title: 'All three, side by side',
      preview: const KeyedSubtree(
        key: ValueKey<String>('marker-example:variants'),
        child: _AllVariants(),
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(path: 'marker_variants.dart', code: _variantsCode),
      ],
    ),
  );

  Widget _inAList() => ElSection(
    id: 'in-a-list',
    title: 'Marking a row in a list',
    description:
        'A marker read on its own is almost nothing. It only makes sense '
        'between the rows it is annotating, which is the one place it is '
        'meant to appear: separator to divide before from after, border to '
        'head what follows, normal inside a container that already frames '
        'it.',
    child: DocsCodeExample(
      title: 'Between rows',
      preview: const KeyedSubtree(
        key: ValueKey<String>('marker-example:in-a-list'),
        child: _InAList(),
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(path: 'marker_in_a_list.dart', code: _inAListCode),
      ],
    ),
  );

  Widget _icon() => ElSection(
    id: 'icon',
    title: 'Adding an icon',
    description:
        'icon is an optional widget, and the row forces it into a square '
        'of el(4) with ElMarker.gap after it. It sits after the leading '
        'rule under the separator variant, so the glyph reads as part of '
        'the label rather than as part of the divider. Keep it decorative: '
        'the row carries no semantics of its own for it.',
    child: DocsCodeExample(
      title: 'With a glyph',
      preview: const KeyedSubtree(
        key: ValueKey<String>('marker-example:icon'),
        child: _WithIcon(),
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(path: 'marker_icon.dart', code: _iconCode),
      ],
    ),
  );

  Widget _rules(ElThemeData theme) => ElSection(
    id: 'rules',
    title: 'How the separator splits the row',
    description:
        'The separator variant is the only one whose layout is worth '
        'explaining, because the two rules and the label share the width '
        'in a specific order.',
    child: _bullets(theme, <String>[
      'The rules are Expanded, so they take whatever the label leaves. '
          'They are not a fixed fraction of the row and the row is not '
          'divided into thirds.',
      'The label is Flexible under separator and Expanded under the other '
          'two. That difference is what stops the label from eating both '
          'rules: under separator it takes only the width it needs, and it '
          'is centre-aligned.',
      'Between each rule and the label sits ElMarker.ruleGap, el(1), which '
          "is on top of the row's own ElMarker.gap between icon and label. "
          'Two different gaps, not one.',
      'Each rule is ElWidths.hairline tall and painted in theme.border. '
          'Measured on a 1030px row with a 231.05px label: 387.469 + 4 + '
          '231.05 + 4 + 387.484, the two rules differing by fifteen '
          "thousandths of a pixel because the label's own width is "
          'fractional.',
      'The border variant does none of this: it is the plain row with '
          'ElMarker.borderPadding underneath and one hairline bottom '
          'border, and the label stays left-aligned.',
      'The row has a ElMarker.minHeight floor of el(4), which no marker in '
          'the corpus actually reaches: the small text spec\'s own line box '
          'is already taller than 16px, so the floor never binds.',
    ]),
  );

  Widget _api() => ElSection(
    id: 'api',
    title: 'API Reference',
    description:
        'Every constructor parameter, every static measurement, and every '
        'enum value, read straight off lib/src/components/marker.dart.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        KeyedSubtree(
          key: docsAnchorKey('api-elmarker'),
          child: const DocsApiTable(title: 'ElMarker', facts: _markerFacts),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elmarker-static'),
          child: const DocsApiTable(
            title: 'ElMarker measurements',
            facts: _markerStaticFacts,
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elmarkervariant'),
          child: const DocsApiTable(
            title: 'ElMarkerVariant',
            facts: _variantFacts,
          ),
        ),
      ],
    ),
  );

  Widget _states() => ElSection(
    id: 'states',
    title: 'States',
    description:
        'ElMarker is a StatelessWidget with no gesture detector, no focus '
        'node, and no animation. It has no interaction states at all, and '
        'this table says so rather than inventing some.',
    child: const DocsStateMatrix(facts: _stateFacts),
  );

  Widget _accessibility(ElThemeData theme) => ElSection(
    id: 'accessibility',
    title: 'Accessibility',
    child: _bullets(theme, <String>[
      'The label is ordinary ElText, so a screen reader reads it as prose '
          'in document order, between the rows it sits between. That is the '
          'whole of the semantic behaviour.',
      'Nothing is focusable and nothing is tappable: there is no keyboard '
          'interaction to describe.',
      'Known gap: no semantic boundary. The row is not a separator role, '
          'not a heading, and not a landmark, even under the border '
          'variant, which visually heads what follows. A reader hears the '
          'text and infers the break from the wording alone.',
      'Which means the wording carries the whole message. Write a label '
          'that says what happened ("3 messages hidden", "Today"), not one '
          'that only makes sense next to the rule ("above", "before this").',
      'The rules are painted boxes with no text and no semantics, so they '
          'add nothing to and take nothing from the announcement.',
      'The icon is passed through as-is. Anything it announces is the '
          "caller's; the row itself neither labels it nor hides it, so "
          'pass a decorative glyph.',
      'Colour is not the only signal: the label is real text under every '
          'variant, so a low-contrast or monochrome view still reads it.',
    ]),
  );

  Widget _responsive(ElThemeData theme) => ElSection(
    id: 'responsive',
    title: 'Responsive',
    child: _bullets(theme, <String>[
      'No breakpoint is read anywhere in marker.dart, and no width is '
          'branched on. The same tree renders at 390px and at 1440px.',
      'Under separator the layout is intrinsically fluid: the two Expanded '
          'rules absorb every change in available width, so a narrower row '
          'shortens the rules and leaves the label alone.',
      'A label long enough to fill the row squeezes the rules toward zero '
          'rather than wrapping under them: the label is Flexible, so it '
          'takes what it needs first.',
      'Under normal and border the label is Expanded and wraps as ordinary '
          'text would: ElMarker sets no maxLines and adds no ellipsis, so '
          'a long label grows the row taller.',
      'Vertical rhythm is the caller\'s: ElMarker adds no margin above or '
          'below itself, only ElMarker.borderPadding under the border '
          'variant. Spacing between a marker and its neighbours is the '
          "list's own.",
      'Platform parity: identical on Android, iOS, Web, macOS, Windows, '
          'and Linux. No dart:io Platform branch in the file.',
    ]),
  );

  Widget _dependencies(ElThemeData theme) => ElSection(
    id: 'dependencies',
    title: 'Dependencies',
    child: _bullets(theme, <String>[
      'File: lib/src/components/marker.dart, one file, holding ElMarker '
          'and ElMarkerVariant and nothing private at all.',
      'Flutter import: package:flutter/widgets.dart only.',
      'Foundation imports: foundation/spacing.dart (el(), '
          'ElWidths.hairline), foundation/theme.dart (ElThemeData), '
          'foundation/typography.dart (ElComponentType), theme_scope.dart '
          '(ElText, ElTheme).',
      'Component imports: none. This is the only one of the three '
          'components split out of the old carousel page that depends on no '
          'other component.',
      'Registry dependencies: none, from the shipped manifest. '
          'source-foundation is the only item one would need to list.',
      'Assets: none. Fonts: none beyond the system type scale. Shaders: '
          'none.',
    ]),
  );

  Widget _theming(ElThemeData theme) => ElSection(
    id: 'theming',
    title: 'Theming',
    child: _bullets(theme, <String>[
      'Two colours, both read live off ElTheme.of(context) at build time: '
          'theme.mutedForeground for the label, theme.border for the rules '
          'and for the bottom border of the border variant.',
      'No colour parameter exists. A caller cannot recolour the label or '
          'the rules without wrapping or forking the widget.',
      'Type is ElComponentType.textSm, fixed. There is no spec parameter, '
          'so a marker cannot be made larger or bolder from a call site.',
      'Rule thickness is ElWidths.hairline in both places it appears, so '
          'the divider and the bottom border always match.',
      'Flipping ElThemeController re-resolves both colours on the next '
          'frame; nothing is cached.',
      'Geometry is not themeable: gap, minHeight, ruleGap, and '
          'borderPadding are static getters over the 4px grid, exposed for '
          'reading rather than for overriding.',
    ]),
  );

  Widget _source() => ElSection(
    id: 'source',
    title: 'Source',
    child: DocsInstallFacts(
      title: 'Reference',
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'Source',
          value: markerDoc.sourcePath,
          description:
              'Authoritative implementation. Its library note is the spec, '
              'measurements included, and is the truth this page was '
              'written from.',
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
              'Covers this page: the article mounts, the section order, all '
              'three API tables, a live specimen of every ElMarkerVariant '
              'value, and a theme flip.',
        ),
        const DocsInstallFact(
          label: 'Edit these docs',
          value: 'example/lib/components_docs/marker/page.dart',
          description: 'This file.',
        ),
        const DocsInstallFact(
          label: 'Split from',
          value: 'example/lib/components_docs/carousel/page.dart',
          description: 'Where this component was documented before 2026-08-24.',
        ),
      ],
    ),
  );
}

/// One specimen of each [ElMarkerVariant] value, in enum order.
class _AllVariants extends StatelessWidget {
  const _AllVariants();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
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
        'The constructor default. A bare row, for a container that already '
        'frames it: no rules, no border. Named normal because default is a '
        'Dart keyword; the reference calls this variant default.',
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
        'The only state. A muted label, plus whichever rules the variant '
        'draws, at ElWidths.hairline in theme.border.',
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
        'Not applicable: nothing here is actionable, so there is nothing '
        'to disable and no disabled treatment.',
    userSignal: 'Not applicable.',
  ),
  DocsStateFact(
    state: 'Long label',
    treatment:
        'Under separator the label takes the width it needs and squeezes '
        'the rules. Under normal and border it wraps as ordinary text: no '
        'maxLines, no ellipsis.',
    userSignal: 'Shorter rules, or a taller row.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'Nothing animates, so MediaQuery.disableAnimations has nothing to '
        'act on. No token is read for timing anywhere in the file.',
    userSignal: 'Identical either way.',
  ),
];

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

ElMarker(
  variant: ElMarkerVariant.separator,
  label: 'Today',
)''';

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
