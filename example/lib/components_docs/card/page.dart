/// Public documentation page for the `card` component.
///
/// **Re-housed, and moved.** This page used to be `CardDocPage`, hand-composed
/// inside `components_docs/button_card_pages.dart` alongside a dead
/// `ButtonDocPage` nothing routed to any more. It now declares a
/// `ComponentDocSpec` (`example/lib/docs/component_doc_page.dart`) and hands
/// it to `ComponentDocPage`, the shape `button` and `field` established. The
/// old page's one live specimen — an "Account" card with a header, a
/// description, a content paragraph and a footer button — is carried across
/// unchanged: it is the Footer section's specimen below, same title, same
/// copy, same button label.
///
/// `card` is not one widget but six: [ElCard] itself is the painted surface
/// (a ring rather than a border, a footer that cancels its own bottom
/// padding), and [ElCardHeader], [ElCardTitle], [ElCardDescription],
/// [ElCardContent] and [ElCardFooter] are the regions a caller composes by
/// hand into its `children`. There is no anatomy flag anywhere in the file:
/// a header with no description renders one grid row instead of two because
/// `description` was left null, not because a variant said so.
///
/// **Section order**, matching the house shape: Preview, Installation, Usage
/// (the smallest correct construction), then one showcase per region a
/// caller actually composes — Header, Header with Action, Content, Footer —
/// plus Custom Fill and Ring, live specimens of the two override fields
/// `ElCard` exposes for a caller like the data page's own navigating stat
/// card, reused from `example/lib/pages/data.dart`'s `_NavigatingStat`. Then
/// the eight disclosures.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import 'meta.dart';

final ComponentDocSpec cardDocSpec = ComponentDocSpec(
  name: 'card',
  title: cardDoc.title,
  description: cardDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'Two real compositions side by side: a header with an action '
          'badge over a figure row, and the header/content/footer shape '
          'every card on this page builds from.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: el(160),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'card has a real registry manifest, `elattar add card` installs '
          'lib/src/components/card.dart and resolves source-foundation '
          'automatically. The Manual tab is for a project not using the '
          'CLI.',
      command: cardDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/card.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/card.dart's generated @ui/card.dart "
              'payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated card source here when using manual '
              'mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ElCard and its five region widgets '
              'are reachable the same way the CLI path already makes them.',
          code: "export 'card.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct construction. Every example below only '
          'adds another region to the same children list.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'header',
      title: 'Header',
      description:
          'ElCardHeader with a title and a description; no action. '
          "description's presence is what adds the second row: leave it "
          'null and the header is one line.',
      specimen: _HeaderSpecimen(),
      code: _headerCode,
      label: 'Header specimen view',
    ),
    ShowcaseSection(
      id: 'header-action',
      title: 'Header with Action',
      description:
          "action fills the header's second column, top-aligned and never "
          'stretched: a badge, a button, or an icon button all sit at the '
          "title's own baseline rather than the description's.",
      specimen: _HeaderActionSpecimen(),
      code: _headerActionCode,
      label: 'Header with Action specimen view',
    ),
    ShowcaseSection(
      id: 'content',
      title: 'Content',
      description:
          'ElCardContent is horizontal padding around whatever a caller '
          'gives it: prose, a row of figures, a form. It applies no other '
          'shape of its own.',
      specimen: _ContentSpecimen(),
      code: _contentCode,
      label: 'Content specimen view',
    ),
    ShowcaseSection(
      id: 'footer',
      title: 'Footer',
      description:
          'The old page\'s own "Account" specimen, unchanged: a header, a '
          'content paragraph, and a footer button. A footer as the last '
          'child is what cancels ElCard\'s own bottom padding, so the '
          "footer's band sits flush against the card's own edge.",
      specimen: _FooterSpecimen(),
      code: _footerCode,
      label: 'Footer specimen view',
    ),
    ShowcaseSection(
      id: 'fill-ring',
      title: 'Custom Fill and Ring',
      description:
          'fill and ringColor are ElCard\'s only two override fields, read '
          'live off ElTheme.of(context) when left null. Reused from '
          'example/lib/pages/data.dart\'s own navigating stat card: hover '
          'to see theme.card animate to theme.accent while the ring '
          'brightens to ElPalette.action at 45% alpha. ElCard computes '
          'neither transition itself — the caller\'s own '
          'TweenAnimationBuilder does, exactly as shown.',
      specimen: _FillRingSpecimen(),
      code: _fillRingCode,
      label: 'Custom Fill and Ring specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter each of the six exported classes '
          'declares, plus ElCard\'s own four static helpers: one table per '
          'class.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'ElCard', anchor: 'api-elcard'),
        DocsTocEntry(title: 'ElCardHeader', anchor: 'api-elcardheader'),
        DocsTocEntry(title: 'ElCardTitle', anchor: 'api-elcardtitle'),
        DocsTocEntry(
          title: 'ElCardDescription',
          anchor: 'api-elcarddescription',
        ),
        DocsTocEntry(title: 'ElCardContent', anchor: 'api-elcardcontent'),
        DocsTocEntry(title: 'ElCardFooter', anchor: 'api-elcardfooter'),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'ElCard itself renders no MouseRegion, Focus or GestureDetector: '
          'every row here is either a structural fact read off card.dart, '
          'or a caller-built state like the Custom Fill and Ring specimen '
          'above.',
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
            value: cardDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/data_display_test.dart',
            description:
                'ElCard is covered inside the shared data-display suite: '
                'there is no dedicated card_test.dart in the package yet.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/card_test.dart',
            description:
                'Covers this page: the article mounts, the full API table, '
                'a live specimen of every region, and both themes at two '
                'viewport widths.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/card/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class CardDocPage extends StatelessWidget {
  const CardDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: cardDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENT · CARD',
      title: cardDocSpec.title,
      description: cardDocSpec.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Card'),
    ],
    toc: cardDocSpec.toc,
    previous: const DocsPageLink(
      title: 'Button',
      route: '/components/button',
    ),
    next: const DocsPageLink(title: 'Dialog', route: '/components/dialog'),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('card-doc-article'),
      child: ComponentDocPage(spec: cardDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: el(2)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              key: const ValueKey<String>('card-preview:action'),
              // el(80) (320px) overflows this row's 'Prize pool' label
              // against the 'numMd' price by 53px once the card's own
              // 32px of horizontal padding is subtracted — widened to
              // el(96) (384px), the same measure DocsShowcase.tallMinHeight
              // uses, rather than shrinking the type or the copy.
              width: el(96),
              child: ElCard(
                children: <Widget>[
                  const ElCardHeader(
                    title: ElCardTitle('Weekly competition'),
                    description: ElCardDescription(
                      'Ends in 2 days, 14 hours.',
                    ),
                    action: ElBadge(
                      label: 'Live',
                      variant: ElBadgeVariant.premium,
                    ),
                  ),
                  ElCardContent(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        ElText('Prize pool', ElType.section),
                        ElText(
                          r'$24,000.00',
                          ElType.numMd,
                          color: theme.valueInk,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: el(6)),
            SizedBox(
              key: const ValueKey<String>('card-preview:footer'),
              width: el(80),
              child: ElCard(
                children: <Widget>[
                  const ElCardHeader(
                    title: ElCardTitle('Account'),
                    description: ElCardDescription(
                      'Manage your account settings.',
                    ),
                  ),
                  const ElCardContent(
                    child: Text(
                      'Your profile and security settings live here.',
                    ),
                  ),
                  ElCardFooter(
                    child: ElButton(
                      expanded: true,
                      onPressed: () {},
                      child: const Text('Save changes'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const String _previewCode = '''
ElCard(
  children: [
    ElCardHeader(
      title: ElCardTitle('Weekly competition'),
      description: ElCardDescription('Ends in 2 days, 14 hours.'),
      action: ElBadge(label: 'Live', variant: ElBadgeVariant.premium),
    ),
    ElCardContent(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElText('Prize pool', ElType.section),
          ElText(r'\$24,000.00', ElType.numMd, color: theme.valueInk),
        ],
      ),
    ),
  ],
)''';

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

ElCard(
  children: [
    ElCardHeader(title: ElCardTitle('Title')),
    ElCardContent(child: Text('Body copy.')),
  ],
)''';

class _HeaderSpecimen extends StatelessWidget {
  const _HeaderSpecimen();

  @override
  Widget build(BuildContext context) => SizedBox(
    key: const ValueKey<String>('card-example:header'),
    width: el(80),
    child: ElCard(
      children: <Widget>[
        const ElCardHeader(
          title: ElCardTitle('Your collection'),
          description: ElCardDescription('Across 8 card sets.'),
        ),
        const ElCardContent(child: Text('1,284 cards owned.')),
      ],
    ),
  );
}

const String _headerCode = '''
ElCard(
  children: [
    ElCardHeader(
      title: ElCardTitle('Your collection'),
      description: ElCardDescription('Across 8 card sets.'),
    ),
    ElCardContent(child: Text('1,284 cards owned.')),
  ],
)''';

class _HeaderActionSpecimen extends StatelessWidget {
  const _HeaderActionSpecimen();

  @override
  Widget build(BuildContext context) => SizedBox(
    key: const ValueKey<String>('card-example:header-action'),
    width: el(80),
    child: ElCard(
      children: <Widget>[
        const ElCardHeader(
          title: ElCardTitle('Weekly competition'),
          description: ElCardDescription(
            'Ends in 2 days, 14 hours. Top 100 collectors share the pool.',
          ),
          action: ElBadge(label: 'Live', variant: ElBadgeVariant.premium),
        ),
      ],
    ),
  );
}

const String _headerActionCode = '''
ElCard(
  children: [
    ElCardHeader(
      title: ElCardTitle('Weekly competition'),
      description: ElCardDescription(
        'Ends in 2 days, 14 hours. Top 100 collectors share the pool.',
      ),
      action: ElBadge(label: 'Live', variant: ElBadgeVariant.premium),
    ),
  ],
)''';

class _ContentSpecimen extends StatelessWidget {
  const _ContentSpecimen();

  static const List<({String k, String v})> _figures = <({String k, String v})>[
    (k: 'Total value', v: r'$12,480.65'),
    (k: 'Cards owned', v: '1,284'),
  ];

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return SizedBox(
      key: const ValueKey<String>('card-example:content'),
      // el(80) (320px) overflows this row's two figure columns by 40px
      // once the card's own 32px of horizontal padding is subtracted —
      // widened to el(96) (384px), the same fix Preview's action card
      // above needed for the same reason.
      width: el(96),
      child: ElCard(
        children: <Widget>[
          const ElCardHeader(title: ElCardTitle('Your collection')),
          ElCardContent(
            // `Expanded` rather than a bare `spaceBetween` Row: two
            // unconstrained columns summed past the available width at a
            // narrow viewport, where the frame can squeeze this specimen
            // below its own requested `el(96)`. Splitting the row in half
            // keeps each figure's own left alignment while guaranteeing
            // neither column can push the row past its constraint.
            child: Row(
              children: <Widget>[
                for (int i = 0; i < _figures.length; i++) ...<Widget>[
                  if (i > 0) SizedBox(width: el(4)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ElText(_figures[i].k, ElType.section),
                        SizedBox(height: el(1.5)),
                        ElText(
                          _figures[i].v,
                          ElType.numMd,
                          color: theme.foreground,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const String _contentCode = '''
ElCard(
  children: [
    ElCardHeader(title: ElCardTitle('Your collection')),
    ElCardContent(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [ElText('Total value', ElType.section), Text(r'\$12,480.65')]),
          Column(children: [ElText('Cards owned', ElType.section), Text('1,284')]),
        ],
      ),
    ),
  ],
)''';

/// The old `button_card_pages.dart` `CardDocPage` specimen, carried across
/// unchanged: same title, same description, same body copy, same button
/// label.
class _FooterSpecimen extends StatelessWidget {
  const _FooterSpecimen();

  @override
  Widget build(BuildContext context) => SizedBox(
    key: const ValueKey<String>('card-example:footer'),
    width: el(80),
    child: ElCard(
      children: <Widget>[
        const ElCardHeader(
          title: ElCardTitle('Account'),
          description: ElCardDescription('Manage your account settings.'),
        ),
        const ElCardContent(
          child: Text('Your profile and security settings live here.'),
        ),
        ElCardFooter(
          child: ElButton(onPressed: () {}, child: const Text('Save changes')),
        ),
      ],
    ),
  );
}

const String _footerCode = '''
ElCard(
  children: [
    ElCardHeader(
      title: ElCardTitle('Account'),
      description: ElCardDescription('Manage your account settings.'),
    ),
    ElCardContent(
      child: Text('Your profile and security settings live here.'),
    ),
    ElCardFooter(
      child: ElButton(onPressed: () {}, child: const Text('Save changes')),
    ),
  ],
)''';

/// The navigating stat card, reused from `example/lib/pages/data.dart`'s
/// `_NavigatingStat`: `fill` tweens to `theme.accent` and `ringColor` to
/// `ElPalette.action` at 45% alpha on hover, both driven by the call site's
/// own `TweenAnimationBuilder`, not by `ElCard`.
class _FillRingSpecimen extends StatefulWidget {
  const _FillRingSpecimen();

  @override
  State<_FillRingSpecimen> createState() => _FillRingSpecimenState();
}

class _FillRingSpecimenState extends State<_FillRingSpecimen> {
  bool _hovered = false;

  static const double _hoverRingAlpha = 0.45;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: ElPress(
        onTap: () {},
        child: SizedBox(
          key: const ValueKey<String>('card-example:fill-ring'),
          width: el(64),
          child: TweenAnimationBuilder<Color?>(
            duration: elAnimationDuration(
              context,
              ElDurations.transitionDefault,
            ),
            curve: ElCurves.out,
            tween: ColorTween(end: _hovered ? theme.accent : theme.card),
            builder: (BuildContext context, Color? fill, Widget? child) =>
                ElCard(
                  fill: fill,
                  ringColor: _hovered
                      ? ElPalette.action.withValues(alpha: _hoverRingAlpha)
                      : ElCard.ringOf(theme),
                  children: <Widget>[child!],
                ),
            child: const ElCardContent(
              child: Text('Hover or press this card.'),
            ),
          ),
        ),
      ),
    );
  }
}

const String _fillRingCode = '''
TweenAnimationBuilder<Color?>(
  duration: elAnimationDuration(context, ElDurations.transitionDefault),
  curve: ElCurves.out,
  tween: ColorTween(end: hovered ? theme.accent : theme.card),
  builder: (context, fill, child) => ElCard(
    fill: fill,
    ringColor: hovered
        ? ElPalette.action.withValues(alpha: 0.45)
        : ElCard.ringOf(theme),
    children: [child!],
  ),
  child: const ElCardContent(child: Text('Hover or press this card.')),
)''';

/* ── API Reference ──────────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DocsAnchor(
        id: 'api-elcard',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const DocsApiTable(title: 'ElCard', facts: _cardApiFacts),
            SizedBox(height: el(6)),
            const DocsApiTable(
              title: 'ElCard static helpers',
              facts: _cardStaticFacts,
            ),
          ],
        ),
      ),
      SizedBox(height: el(6)),
      DocsAnchor(
        id: 'api-elcardheader',
        child: const DocsApiTable(
          title: 'ElCardHeader',
          facts: _cardHeaderApiFacts,
        ),
      ),
      SizedBox(height: el(6)),
      DocsAnchor(
        id: 'api-elcardtitle',
        child: const DocsApiTable(
          title: 'ElCardTitle',
          facts: _cardTitleApiFacts,
        ),
      ),
      SizedBox(height: el(6)),
      DocsAnchor(
        id: 'api-elcarddescription',
        child: const DocsApiTable(
          title: 'ElCardDescription',
          facts: _cardDescriptionApiFacts,
        ),
      ),
      SizedBox(height: el(6)),
      DocsAnchor(
        id: 'api-elcardcontent',
        child: const DocsApiTable(
          title: 'ElCardContent',
          facts: _cardContentApiFacts,
        ),
      ),
      SizedBox(height: el(6)),
      DocsAnchor(
        id: 'api-elcardfooter',
        child: const DocsApiTable(
          title: 'ElCardFooter',
          facts: _cardFooterApiFacts,
        ),
      ),
    ],
  );
}

const List<DocsApiFact> _cardApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'children',
    type: 'List<Widget>',
    description:
        'Required. ElCardHeader, ElCardContent, ElCardFooter, in the order '
        'they are written; ElCard imposes no ordering of its own.',
  ),
  DocsApiFact(
    name: 'fill',
    type: 'Color?',
    description:
        "Overrides theme.card. Null reads the theme live at build time; a "
        'caller like the navigating stat card animates this to theme.accent '
        'on hover, shown in Custom Fill and Ring above.',
  ),
  DocsApiFact(
    name: 'ringColor',
    type: 'Color?',
    description:
        'Overrides the default ring (ElCard.ringOf(theme), theme.foreground '
        'at 10% alpha). Null falls back to the default.',
  ),
];

const List<DocsApiFact> _cardStaticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'spacing',
    type: 'double (static getter)',
    description:
        "el(4), 16px. One number for both ElCard's own padding and the gap "
        'between its children.',
  ),
  DocsApiFact(
    name: 'radius',
    type: 'double (static getter)',
    description: 'ElRadii.xl — the corner radius the whole card clips to.',
  ),
  DocsApiFact(
    name: 'ringWidth',
    type: 'double (static getter)',
    description: 'ElWidths.hairline — the ring\'s own spread.',
  ),
  DocsApiFact(
    name: 'ringOf(theme)',
    type: 'Color Function(ElThemeData)',
    description: 'The default ring colour: theme.foreground at 10% alpha.',
  ),
];

const List<DocsApiFact> _cardHeaderApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'title',
    type: 'Widget',
    description: 'Required. Usually an ElCardTitle.',
  ),
  DocsApiFact(
    name: 'description',
    type: 'Widget?',
    description:
        "Usually an ElCardDescription. Its presence is what adds the "
        "header's second row; null leaves the header one line.",
  ),
  DocsApiFact(
    name: 'action',
    type: 'Widget?',
    description:
        "Fills the header's second column: top-aligned, spanning both "
        'rows, never stretched. Its presence is what adds the column at '
        'all; null leaves the header a single-column stack.',
  ),
];

const List<DocsApiFact> _cardTitleApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'text',
    type: 'String (positional)',
    description:
        'Required. Renders through ElText at ElComponentType.cardTitle.',
  ),
];

const List<DocsApiFact> _cardDescriptionApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'text',
    type: 'String (positional)',
    description:
        'Required. Renders through ElText at ElComponentType.textSm, '
        'coloured theme.mutedForeground.',
  ),
];

const List<DocsApiFact> _cardContentApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description:
        "Required. Whatever a caller wants: prose, a row of figures, a "
        "form. ElCardContent adds only ElCard's own horizontal padding.",
  ),
];

const List<DocsApiFact> _cardFooterApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description:
        'Required. Painted on a muted band with a top rule; as the last '
        "child in ElCard.children it also cancels ElCard's own bottom "
        'padding, so the band sits flush against the card edge.',
  ),
];

/* ── States ──────────────────────────────────────────────────────────────── */

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Footer present',
    treatment: 'The last item in children is an ElCardFooter.',
    userSignal:
        "ElCard's own bottom padding drops to 0; the footer's own padding "
        'and top rule take over the band instead.',
  ),
  DocsStateFact(
    state: 'No footer',
    treatment: 'The last item in children is anything else.',
    userSignal: 'Bottom padding stays at ElCard.spacing (16px).',
  ),
  DocsStateFact(
    state: 'Custom fill',
    treatment: 'Pass fill.',
    userSignal:
        'Overrides theme.card. ElCard computes no hover fill of its own — '
        'a caller animates it externally, shown in Custom Fill and Ring.',
  ),
  DocsStateFact(
    state: 'Custom ring',
    treatment: 'Pass ringColor.',
    userSignal:
        'Overrides the default 10%-alpha foreground ring. Not animated by '
        'ElCard itself.',
  ),
  DocsStateFact(
    state: 'No native interactive state',
    treatment: 'Nothing — ElCard mounts no MouseRegion, Focus, or '
        'GestureDetector.',
    userSignal:
        'Hover, press, and focus are entirely caller-built, as in the '
        'Custom Fill and Ring specimen above.',
  ),
];

/* ── Prose disclosures ──────────────────────────────────────────────────── */

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Semantic role: none. ElCard renders a DecoratedBox / ClipRRect / '
            'ColoredBox / Padding / Column tree and mounts no Semantics node '
            'of its own — a screen reader hears whatever its children '
            'announce, not a card-level container or region role.',
        'Heading structure: ElCardTitle renders through ElText at '
            'ElComponentType.cardTitle, a styled Text — it carries no '
            'semantic heading level. A caller building a page outline needs '
            'to wrap it, or reach for a real heading widget instead.',
        'Interactivity is entirely opt-in: the Custom Fill and Ring '
            'specimen above wraps its ElCard in MouseRegion, ElPress, and '
            'the caller\'s own tap handler; ElCard itself supplies none of '
            'that, and a card with no such wrapper is not focusable, not '
            'tappable, and announces no button or link role.',
        'Contrast: fill and ringColor are read live off ElTheme.of(context) '
            'when left null, so the default ring and background already '
            'clear whatever the active theme guarantees; a caller passing '
            'either override owns that contrast decision.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'card.dart wires no key handling of its own: ElCard takes no '
            'focusNode, requests no focus, and reads no LogicalKeyboardKey.',
        'A caller that makes a card interactive — the Custom Fill and Ring '
            "specimen's ElPress wrapper — owns whatever keyboard story that "
            'gesture layer provides; the source contributes nothing beyond '
            'painting the surface underneath it.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No breakpoint branching anywhere in card.dart: BuildContext width '
            'is never read for a layout decision.',
        'ElCard imposes no width of its own — it shrink-wraps whatever '
            'constraint its caller hands it, which is why every specimen '
            'above sits inside its own SizedBox(width: ...).',
        "ElCardHeader's action column is a fixed two-column shape at every "
            'width: no responsive collapsing to a single column on a '
            'narrow viewport.',
        'Every measurement (spacing, radius, ringWidth, gap) is a fixed '
            '4px-grid value from el(), never a value keyed to viewport.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ElTheme.of(context), <String>[
        'File: lib/src/components/card.dart — one file, no companions; the '
            'registry manifest lists exactly one entry under "files".',
        'Flutter imports: package:flutter/widgets.dart only.',
        'Foundation imports: foundation/shadows.dart (ElShadowSpec, the '
            'ring), foundation/spacing.dart (el()), foundation/theme.dart, '
            'foundation/typography.dart (ElComponentType.cardTitle / '
            'textSm), theme_scope.dart (ElText, ElTheme).',
        'No effect, motion, or sibling-component import: card.dart composes '
            'nothing else in the corpus.',
        'registryDependencies, resolved automatically by `elattar add '
            'card`: source-foundation — copied verbatim from '
            'registry/components/card.json.',
      ]),
      SizedBox(height: el(2)),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: ElWidths.prose),
        child: DocsLinkRow(
          links: <DocsLink>[
            DocsLink(label: 'Button', route: '/components/button'),
            DocsLink(label: 'Badge', route: '/components/badge'),
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
      _bullets(ElTheme.of(context), <String>[
        'Every colour is read live off ElTheme.of(context) at build time '
            'when fill or ringColor is left null: theme.card for the fill, '
            'theme.foreground at 10% alpha for the ring, theme.muted at 50% '
            'alpha for the footer band, theme.border for the footer\'s top '
            'rule. Flipping ElThemeController re-resolves every one on the '
            'next frame.',
        'The ring is a shadow, not a border: ElShadowSpec draws an outset '
            '1px spread at ElCard.ringWidth, which is why a card in an '
            "82-token column measures the full 82 rather than 80 — a real "
            'border would have cost the box a pixel each side.',
        'Shape: ElRadii.xl, always. card.dart exposes no radius override; '
            'a caller wanting a different corner composes its own '
            'DecoratedBox instead.',
        'fill and ringColor are the only two theming escape hatches: both '
            'default to the live theme and both are read once per build, '
            'never cached.',
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
