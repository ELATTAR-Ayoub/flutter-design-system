/// Public documentation page for the `hover-builder` component.
///
/// **Why `EffectSection`, not `ShowcaseSection`.** Neither `HoverBuilder` nor
/// `InteractiveCard` has a variant enum, and `HoverBuilder` in particular renders
/// nothing of its own — its class doc calls it "deliberately dumb": it
/// reports a hover boolean to `builder` and the caller decides what hovering
/// looks like. A `ShowcaseSection` stages a specimen; `EffectSection` names
/// the host the lift is applied to, which is the only way to show what the
/// effect actually does to something.
///
/// **Two exported classes, one page.** [HoverBuilder] is the trigger, [InteractiveCard]
/// is "the shape every docs card takes… so it ships rather than being
/// re-typed per page" (the source's own words) — both documented here, with
/// two API tables under one API Reference disclosure via `children:`.
///
/// **Section list.** Preview contrasts a lifting card against a static one.
/// Index Card reproduces the real shape `example/lib/kit.dart`'s
/// `IndexCard` builds on `InteractiveCard` — a title-and-blurb tile with a
/// border tint on hover, the composition this system's own docs site cards
/// use. Bare Lift shows [HoverBuilder] on its own, undressed: the source names
/// exactly this case — "on an index card it also slides an arrow and
/// recolours it, and baking one appearance in would put those in the wrong
/// place" — so this facet is that arrow, built by the caller, not by
/// [HoverBuilder] itself.
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

final ComponentDocSpec hoverBuilderDocSpec = ComponentDocSpec(
  name: 'hover_builder',
  title: 'Hover Builder',
  description:
      'A hover rise — translateY(-3px) onto a deeper shadow, with an '
      'optional border-colour swap — for a card or tile that answers the '
      'pointer the way the whole docs site\'s own cards do.',
  sections: <DocsPageSection>[
    EffectSection(
      id: 'preview',
      title: 'Preview',
      description:
          'Hover either card. The left one is an InteractiveCard: it rises onto '
          'shadow-e3 and its border tints on ease-standard while transform '
          'and shadow ride ease-out — two easings, one shared controller. '
          'The right one is a plain, static DecoratedBox with no MouseRegion '
          'at all.',
      host: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'hover-builder has a real registry manifest: `elattar add hover-builder` installs '
          'lib/src/components/ui/hover_builder.dart and resolves its one registryDependency '
          'automatically. The Manual tab is for a project not using the '
          'CLI.',
      command: hoverBuilderDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/hover_builder.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/ui/hover_builder.dart's generated @ui/hover_builder.dart "
              'payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated hover-builder source here when using manual '
              'mode.',
        ),
        DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so HoverBuilder and InteractiveCard are reachable '
              'the same way the CLI path already makes them.',
          code: "export 'hover_builder.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'InteractiveCard is the standard appearance: pass what changes '
          '(padding, contents, onTap) and it handles the rise, the shadow '
          'and the optional border tint.',
      code: _usageCode,
    ),
    EffectSection(
      id: 'index-card',
      title: 'Index Card',
      description:
          "The shape example/lib/kit.dart's IndexCard builds on top of "
          'InteractiveCard: theme.card fill, theme.border resting, theme.'
          'actionText on hover, Radii.xl corners, padded content — this '
          "system's own docs overview cards.",
      host: _IndexCardSpecimen(),
      code: _indexCardCode,
      label: 'Index Card specimen view',
    ),
    EffectSection(
      id: 'bare',
      title: 'Bare HoverBuilder',
      description:
          'HoverBuilder undressed: no card, no shadow, no border — just the hover '
          'boolean, handed to a builder that slides an arrow and recolours '
          'the label. Neither is anything HoverBuilder itself animates; both are '
          'the caller\'s own AnimatedPadding and colour swap, reacting to '
          'the flag HoverBuilder reports.',
      host: _BareHoverBuilderSpecimen(),
      code: _bareHoverBuilderCode,
      label: 'Bare HoverBuilder specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter HoverBuilder declares, and every one '
          'InteractiveCard declares — two tables, since the file exports two '
          'classes.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'HoverBuilder', anchor: 'api-elhoverbuilder'),
        DocsTocEntry(title: 'InteractiveCard', anchor: 'api-elinteractivecard'),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
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
            value: hoverBuilderDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/motion_test.dart',
            description:
                'Both HoverBuilder and InteractiveCard have their own groups in the '
                'shared motion suite: there is no dedicated hover_builder_test.dart '
                'in the package yet.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/hover_builder_test.dart',
            description:
                'Covers this page: the article mounts, both API tables, a '
                'live hover on each specimen, and both themes.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/hover_builder/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class HoverBuilderDocPage extends StatelessWidget {
  const HoverBuilderDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: hoverBuilderDoc.route,
    intro: DocsPageIntro(
      title: hoverBuilderDoc.title,
      description: hoverBuilderDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Hover Builder'),
    ],
    toc: hoverBuilderDocSpec.toc,
    previous: const DocsPageLink(
      title: 'Icon Swap',
      route: '/components/icon_swap',
    ),
    next: const DocsPageLink(
      title: 'Active Indicator',
      route: '/components/active_indicator',
    ),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('hover-builder-doc-article'),
      child: ComponentDocPage(spec: hoverBuilderDocSpec, header: false),
    ),
  );
}

/* ── Effect specimens ───────────────────────────────────────────────────── */

Widget _caption(BuildContext context, String label) => StyledText(
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
              _caption(context, 'Lifts on hover'),
              SizedBox(height: space(3)),
              const KeyedSubtree(
                key: ValueKey<String>('hover-builder-preview:lifts'),
                child: _LiftingCard(),
              ),
            ],
          ),
          SizedBox(width: space(8)),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _caption(context, 'Static'),
              SizedBox(height: space(3)),
              const KeyedSubtree(
                key: ValueKey<String>('hover-builder-preview:static'),
                child: _StaticCard(),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

const String _previewCode =
    '// Lifts on hover — the effect this page documents\n'
    'InteractiveCard(\n'
    '  padding: EdgeInsets.all(space(5)),\n'
    '  builder: (context, hovered) => const Text(\'Card\'),\n'
    ')\n\n'
    '// Static — no InteractiveCard, no MouseRegion, the plain comparison\n'
    'DecoratedBox(\n'
    '  decoration: BoxDecoration(\n'
    '    color: theme.card,\n'
    '    border: Border.all(color: theme.border),\n'
    '    borderRadius: BorderRadius.circular(Radii.xl),\n'
    '  ),\n'
    '  child: Padding(\n'
    '    padding: EdgeInsets.all(space(5)),\n'
    "    child: const Text('Card'),\n"
    '  ),\n'
    ')';

class _LiftingCard extends StatelessWidget {
  const _LiftingCard();

  @override
  Widget build(BuildContext context) => InteractiveCard(
    padding: EdgeInsets.all(space(5)),
    builder: (BuildContext context, bool hovered) => const Text('Card'),
  );
}

class _StaticCard extends StatelessWidget {
  const _StaticCard();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.card,
        border: Border.all(color: theme.border, width: BorderWidths.hairline),
        borderRadius: BorderRadius.circular(Radii.xl),
      ),
      child: Padding(
        padding: EdgeInsets.all(space(5)),
        child: StyledText('Card', TextStyles.body, color: theme.foreground),
      ),
    );
  }
}

class _IndexCardSpecimen extends StatelessWidget {
  const _IndexCardSpecimen();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return KeyedSubtree(
      key: const ValueKey<String>('hover-builder-example:index-card'),
      child: SizedBox(
        width: space(80),
        child: InteractiveCard(
          radius: BorderRadius.circular(Radii.xl),
          fill: theme.card,
          borderColor: theme.border,
          hoverBorderColor: theme.actionText,
          padding: EdgeInsets.all(space(5)),
          onTap: () {},
          builder: (BuildContext context, bool hovered) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              StyledText('Motion', TextStyles.h4, color: theme.foreground),
              SizedBox(height: space(2)),
              StyledText(
                'Active indicator, content change, hover builder — the primitives '
                'every interactive surface composes from.',
                TextStyles.small,
                color: theme.mutedForeground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const String _indexCardCode =
    'InteractiveCard(\n'
    '  radius: BorderRadius.circular(Radii.xl),\n'
    '  fill: theme.card,\n'
    '  borderColor: theme.border,\n'
    '  hoverBorderColor: theme.actionText,\n'
    '  padding: EdgeInsets.all(space(5)),\n'
    '  onTap: () => AppRouter.of(context).navigate(href),\n'
    '  builder: (context, hovered) => Column(\n'
    '    crossAxisAlignment: CrossAxisAlignment.start,\n'
    '    children: [\n'
    "      StyledText(title, TextStyles.h4),\n"
    "      StyledText(blurb, TextStyles.small),\n"
    '    ],\n'
    '  ),\n'
    ')';

class _BareHoverBuilderSpecimen extends StatelessWidget {
  const _BareHoverBuilderSpecimen();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return KeyedSubtree(
      key: const ValueKey<String>('hover-builder-example:bare'),
      child: HoverBuilder(
        cursor: SystemMouseCursors.click,
        builder: (BuildContext context, bool hovered) => Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            StyledText(
              'Learn more',
              TextStyles.body,
              color: hovered ? theme.actionText : theme.foreground,
            ),
            AnimatedPadding(
              duration: MotionDurations.normal,
              curve: MotionCurves.enter,
              padding: EdgeInsets.only(left: hovered ? space(2) : space(1)),
              child: Icon.lucide(
                Lucide.arrowRight,
                tone: hovered ? IconTone.action : IconTone.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const String _bareHoverBuilderCode =
    'HoverBuilder(\n'
    '  builder: (context, hovered) => Row(\n'
    '    mainAxisSize: MainAxisSize.min,\n'
    '    children: [\n'
    "      StyledText('Learn more', TextStyles.body,\n"
    '          color: hovered ? theme.actionText : theme.foreground),\n'
    '      AnimatedPadding(\n'
    '        duration: MotionDurations.normal,\n'
    '        curve: MotionCurves.enter,\n'
    '        padding: EdgeInsets.only(left: hovered ? space(2) : space(1)),\n'
    '        child: Icon.lucide(Lucide.arrowRight,\n'
    '            tone: hovered ? IconTone.action : IconTone.normal),\n'
    '      ),\n'
    '    ],\n'
    '  ),\n'
    ')';

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

InteractiveCard(
  padding: EdgeInsets.all(space(5)),
  onTap: () => onTap(),
  builder: (context, hovered) => const Text('Card'),
)''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elhoverbuilder',
        child: DocsApiTable(
          title: 'HoverBuilder',
          facts: _hoverBuilderApiFacts,
        ),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elinteractivecard',
        child: DocsApiTable(
          title: 'InteractiveCard',
          facts: _interactiveCardApiFacts,
        ),
      ),
    ],
  );
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'HoverBuilder sets no Semantics node: it is a MouseRegion around '
            'whatever builder returns, and contributes no accessible name '
            'or role of its own.',
        'InteractiveCard wraps its content in a bare GestureDetector(onTap: …) '
            'with no Semantics(button: true) of its own either — a screen '
            'reader does not learn this region is tappable unless whatever '
            'builder returns supplies that itself.',
        'The hover visuals (rise, shadow, border tint) are purely visual: '
            'nothing here is surfaced to assistive technology, the same '
            'way a CSS :hover rule carries no semantic signal on its own.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ThemeScope.of(context), <String>[
        'Neither class takes focus or handles a key: no Focus, no '
            'FocusNode, no onKeyEvent anywhere in hover_builder.dart.',
        'InteractiveCard.onTap fires only from GestureDetector\'s pointer tap — '
            'there is no keyboard path to it at all. A caller that needs '
            'Enter/Space to activate the same action must wrap it in its '
            'own Focus/Actions, or reach for a real pressable (Button) '
            'instead.',
        'The lift itself is pointer-only in the most literal sense: '
            'MouseRegion.onEnter/onExit are what drive _hovered, and '
            'neither fires from keyboard traversal.',
      ]),
      SizedBox(height: space(2)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Button', route: '/components/button'),
        ],
      ),
    ],
  );
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(
    BuildContext context,
  ) => _bullets(ThemeScope.of(context), <String>[
    'No breakpoint branching anywhere in hover_builder.dart: BuildContext width '
        'is never read.',
    'MotionTransforms.liftY (the -3px rise) is a fixed token regardless of '
        'card size or viewport.',
    'Touch parity is not addressed: MouseRegion.onEnter/onExit do not '
        'fire from a touch tap on a platform with no hover concept, so '
        'a touch-only visitor never sees the rise at all — only '
        'whatever onTap does.',
  ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(
    BuildContext context,
  ) => _bullets(ThemeScope.of(context), <String>[
    'File: lib/src/components/ui/hover_builder.dart: one file, two classes, no '
        'companions; the registry manifest lists exactly one entry '
        'under "files".',
    'Flutter imports: package:flutter/widgets.dart only.',
    'Foundation imports: foundation/colors.dart (transparent), '
        'foundation/motion.dart (MotionDurations, MotionCurves, '
        'effectiveMotionDuration, MotionTransforms.liftY), foundation/'
        'shadows.dart (Shadows.lg), foundation/spacing.dart, '
        'foundation/theme.dart, theme_scope.dart (ThemeScope).',
    'registryDependencies, resolved automatically by `elattar add '
        'hover-builder`: source-foundation — copied verbatim from '
        'registry/components/hover-builder.json.',
    'Not a dependency of hover_builder.dart itself, but its real consumers in '
        'the corpus: example/lib/kit.dart\'s IndexCard, the layout '
        'and motion pages\' own prev/next and demo cards — all site '
        'chrome under example/lib/, none of it a documented registry '
        'component to link here.',
  ]);
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(
    BuildContext context,
  ) => _bullets(ThemeScope.of(context), <String>[
    'HoverBuilder itself paints no colour — it is MouseRegion plus '
        'whatever builder returns.',
    'InteractiveCard resolves every colour live off ThemeScope.of(context) '
        'when a parameter is left null: fill defaults to theme.card, '
        'borderColor to theme.border. hoverBorderColor defaults to '
        'borderColor — i.e. no swap — so a caller opts into a tint '
        'explicitly, as the Index Card facet above does with theme.'
        'actionText.',
    'shadow defaults to Shadows.lg, the token the lift utility '
        'itself names; box-shadow: none interpolates as a fully '
        'transparent shadow of zero size rather than snapping to full '
        'ink at zero blur, which is why the shadow fades in rather '
        'than popping.',
    'Two easings on one controller: transform and shadow ride '
        'MotionCurves.enter, but border-colour rides MotionCurves.standard — '
        'both over the same MotionDurations.normal-driven AnimationController, '
        're-read through effectiveMotionDuration on every hover so reduced '
        'motion collapses all three legs together.',
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

const List<DocsApiFact> _hoverBuilderApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'builder',
    type: 'Widget Function(BuildContext, bool hovered)',
    description:
        'Required. Built with the live hover state. HoverBuilder decides '
        'nothing about appearance — it only reports whether the pointer '
        'is inside.',
  ),
  DocsApiFact(
    name: 'cursor',
    type: 'MouseCursor',
    description: 'Optional. Defaults to MouseCursor.defer.',
  ),
];

const List<DocsApiFact> _interactiveCardApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'builder',
    type: 'Widget Function(BuildContext, bool hovered)',
    description:
        'Required. Built with the live hover state, the same flag driving '
        'the lift.',
  ),
  DocsApiFact(
    name: 'radius',
    type: 'BorderRadius?',
    description: 'Optional. Defaults to Radii.xl (16px), the card corner.',
  ),
  DocsApiFact(
    name: 'fill',
    type: 'Color?',
    description: 'Optional. Defaults to theme.card.',
  ),
  DocsApiFact(
    name: 'borderColor',
    type: 'Color?',
    description: 'Optional. Defaults to theme.border.',
  ),
  DocsApiFact(
    name: 'hoverBorderColor',
    type: 'Color?',
    description:
        'Optional. Defaults to borderColor — i.e. no swap. The index '
        'cards this file cites pass an action tint.',
  ),
  DocsApiFact(
    name: 'shadow',
    type: 'ShadowStyle?',
    description:
        'Optional. Defaults to Shadows.lg, which is what the lift '
        'utility itself names.',
  ),
  DocsApiFact(
    name: 'padding',
    type: 'EdgeInsetsGeometry',
    description: 'Optional. Defaults to EdgeInsets.zero.',
  ),
  DocsApiFact(
    name: 'onTap',
    type: 'VoidCallback?',
    description:
        'Optional. Fires from a bare GestureDetector — see Keyboard below '
        'for what that does and does not reach.',
  ),
  DocsApiFact(
    name: 'cursor',
    type: 'MouseCursor',
    description:
        'Optional. Defaults to SystemMouseCursors.click. Actually applied '
        'only when onTap is non-null; otherwise HoverBuilder receives '
        'MouseCursor.defer regardless of what is passed here.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest',
    treatment:
        '_controller at 0: no translation, InteractiveCard\'s _shadowAt returns '
        'an empty shadow list, border at its resting colour.',
    userSignal: 'The card sits flat, at its resting border colour.',
  ),
  DocsStateFact(
    state: 'Hover',
    treatment:
        '_hover(true) calls _controller.forward() over '
        'effectiveMotionDuration(context, MotionDurations.normal); _rise and _tint '
        'are CurvedAnimations off the same controller, MotionCurves.enter and '
        'MotionCurves.standard respectively.',
    userSignal:
        'The card rises translateY(-3px) (MotionTransforms.liftY) onto the '
        'shadow token, fading in from empty rather than snapping to full '
        'ink; the border colour crossfades toward hoverBorderColor on its '
        'own, slightly different curve.',
  ),
  DocsStateFact(
    state: 'Unhover',
    treatment:
        '_hover(false) calls _controller.reverse(); both CurvedAnimations '
        'carry an explicit reverseCurve (each curve\'s own .flipped), so '
        'the return trip is not just the forward curve played backwards.',
    userSignal: 'The card settles back flat, shadow and border together.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        '_hover re-reads _controller.duration through effectiveMotionDuration '
        'on every call, so a hover that starts after the OS switch flips '
        'lands on Duration.zero.',
    userSignal: 'The card snaps to its hovered (or rest) state instantly.',
  ),
];
