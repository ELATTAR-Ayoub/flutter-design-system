/// Public documentation page for the `hover-builder` component.
///
/// **Why `EffectSection`, not `ShowcaseSection`.** [HoverBuilder] has no
/// variant enum and renders nothing of its own — its class doc calls it
/// "deliberately dumb": it reports a hover boolean to `builder` and the
/// caller decides what hovering looks like. A `ShowcaseSection` stages a
/// specimen; `EffectSection` names the host the lift is applied to, which is
/// the only way to show what the effect actually does to something.
///
/// **One exported class.** The old lift-card wrapper's baked-in lift/shadow/border
/// card this page used to also document, is gone — its one consumer now
/// composes [HoverBuilder] with [Press] directly, the same way any other
/// caller does. Preview and Index Card below show that composition; Bare
/// HoverBuilder shows [HoverBuilder] on its own, undressed.
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
          'Hover either card. The left one composes HoverBuilder with a '
          'AnimatedContainer that rises onto Shadows.lg and tints its border '
          'on MotionCurves.standard. The right one is a plain, static '
          'DecoratedBox with no MouseRegion at all.',
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
              'Add the export line so HoverBuilder is reachable the same way '
              'the CLI path already makes it.',
          code: "export 'hover_builder.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'HoverBuilder reports the hover boolean; the caller composes it '
          'with Press and an AnimatedContainer for the rise, the shadow and '
          'the optional border tint.',
      code: _usageCode,
    ),
    EffectSection(
      id: 'index-card',
      title: 'Index Card',
      description:
          "The shape example/lib/kit.dart's IndexCard composes from "
          'HoverBuilder and Press: theme.card fill, theme.border resting, '
          'theme.actionText on hover, Radii.xl corners, padded content — '
          "this system's own docs overview cards.",
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
      description: 'Every constructor parameter HoverBuilder declares.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'HoverBuilder', anchor: 'api-elhoverbuilder'),
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
                'HoverBuilder has its own group in the shared motion suite: '
                'there is no dedicated hover_builder_test.dart in the '
                'package yet.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/hover_builder_test.dart',
            description:
                'Covers this page: the article mounts, the API table, a '
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
  TextStyles.small,
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
    '// Lifts on hover — HoverBuilder composed with an AnimatedContainer\n'
    'HoverBuilder(\n'
    '  cursor: SystemMouseCursors.click,\n'
    '  builder: (context, hovered) => AnimatedContainer(\n'
    '    duration: effectiveMotionDuration(context, MotionDurations.normal),\n'
    '    curve: MotionCurves.standard,\n'
    '    padding: EdgeInsets.all(space(5)),\n'
    '    decoration: BoxDecoration(\n'
    '      color: theme.card,\n'
    '      border: Border.all(color: theme.border),\n'
    '      borderRadius: BorderRadius.circular(Radii.xl),\n'
    '      boxShadow: hovered ? Shadows.lg.outerShadows(theme) : null,\n'
    '    ),\n'
    "    child: const Text('Card'),\n"
    '  ),\n'
    ')\n\n'
    '// Static — no HoverBuilder, no MouseRegion, the plain comparison\n'
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
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return HoverBuilder(
      cursor: SystemMouseCursors.click,
      builder: (BuildContext context, bool hovered) => AnimatedContainer(
        duration: effectiveMotionDuration(context, MotionDurations.normal),
        curve: MotionCurves.standard,
        padding: EdgeInsets.all(space(5)),
        decoration: BoxDecoration(
          color: theme.card,
          border: Border.all(
            color: hovered ? theme.actionText : theme.border,
            width: BorderWidths.hairline,
          ),
          borderRadius: BorderRadius.circular(Radii.xl),
          boxShadow: hovered ? Shadows.lg.outerShadows(theme) : null,
        ),
        child: StyledText('Card', TextStyles.body, color: theme.foreground),
      ),
    );
  }
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
        child: HoverBuilder(
          cursor: SystemMouseCursors.click,
          builder: (BuildContext context, bool hovered) => Press(
            onTap: () {},
            showFocusRing: false,
            child: AnimatedContainer(
              duration: effectiveMotionDuration(
                context,
                MotionDurations.normal,
              ),
              curve: MotionCurves.standard,
              padding: EdgeInsets.all(space(5)),
              decoration: BoxDecoration(
                color: theme.card,
                border: Border.all(
                  color: hovered ? theme.actionText : theme.border,
                  width: BorderWidths.hairline,
                ),
                borderRadius: BorderRadius.circular(Radii.xl),
                boxShadow: hovered ? Shadows.lg.outerShadows(theme) : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  StyledText('Motion', TextStyles.h4, color: theme.foreground),
                  SizedBox(height: space(2)),
                  StyledText(
                    'Active indicator, content change, hover builder — the '
                    'primitives every interactive surface composes from.',
                    TextStyles.small,
                    color: theme.mutedForeground,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const String _indexCardCode =
    'HoverBuilder(\n'
    '  cursor: SystemMouseCursors.click,\n'
    '  builder: (context, hovered) => Press(\n'
    '    onTap: () => AppRouter.of(context).navigate(href),\n'
    '    showFocusRing: false,\n'
    '    child: AnimatedContainer(\n'
    '      duration: effectiveMotionDuration(context, MotionDurations.normal),\n'
    '      curve: MotionCurves.standard,\n'
    '      decoration: BoxDecoration(\n'
    '        color: theme.card,\n'
    '        border: Border.all(\n'
    '          color: hovered ? theme.actionText : theme.border,\n'
    '        ),\n'
    '        borderRadius: BorderRadius.circular(Radii.xl),\n'
    '        boxShadow: hovered ? Shadows.lg.outerShadows(theme) : null,\n'
    '      ),\n'
    '      padding: EdgeInsets.all(space(5)),\n'
    '      child: Column(\n'
    '        crossAxisAlignment: CrossAxisAlignment.start,\n'
    '        children: [\n'
    "        StyledText(title, TextStyles.h4),\n"
    "        StyledText(blurb, TextStyles.small),\n"
    '        ],\n'
    '      ),\n'
    '    ),\n'
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
        builder: (BuildContext context, bool hovered) => Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
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

HoverBuilder(
  cursor: SystemMouseCursors.click,
  builder: (context, hovered) => Press(
    onTap: () => onTap(),
    child: AnimatedContainer(
      duration: effectiveMotionDuration(context, MotionDurations.normal),
      curve: MotionCurves.standard,
      padding: EdgeInsets.all(space(5)),
      child: const Text('Card'),
    ),
  ),
)''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => const DocsAnchor(
    id: 'api-elhoverbuilder',
    child: DocsApiTable(title: 'HoverBuilder', facts: _hoverBuilderApiFacts),
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
        'A composition that wraps the builder output in Press (as both '
            'specimens above do) inherits Press\'s own semantics — a '
            'focusable, announced button — for free; a composition that '
            'uses a bare GestureDetector instead gets none of that.',
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
        'HoverBuilder itself takes no focus and handles no key: no Focus, '
            'no FocusNode, no onKeyEvent in hover_builder.dart.',
        'A caller that needs Enter/Space to activate the same action wraps '
            'the builder output in Press, which owns focus, the ring and '
            'both activation intents — the composition both specimens '
            'above use.',
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
    'The rise a caller builds on top (as both specimens above do) is a '
        'fixed amount regardless of card size or viewport.',
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
    'File: lib/src/components/ui/hover_builder.dart: one file, one class, no '
        'companions; the registry manifest lists exactly one entry '
        'under "files".',
    'Flutter imports: package:flutter/widgets.dart only — HoverBuilder '
        'itself reads no foundation token; a caller supplies whatever '
        'motion, colour and shadow tokens its own hover treatment needs, '
        'as both specimens above do.',
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
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'HoverBuilder itself paints no colour — it is MouseRegion plus '
            'whatever builder returns.',
        'Both specimens above resolve every colour live off '
            'ThemeScope.of(context): theme.card fill, theme.border resting, '
            'theme.actionText on hover — a caller opts into the tint '
            'explicitly, there is no default swap to fall back on.',
        'The shadow the Index Card facet applies is Shadows.lg, the token the '
            'web `lift` utility itself names; an AnimatedContainer '
            'interpolating boxShadow from null fades the shadow in rather '
            'than popping it.',
        'One AnimatedContainer, one curve: both the border tint and the '
            'shadow ride MotionCurves.standard over '
            'effectiveMotionDuration(context, MotionDurations.normal), re-read '
            'on every hover so reduced motion collapses the whole change.',
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

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest',
    treatment:
        'HoverBuilder reports hovered: false; the specimens above render '
        'their AnimatedContainer at its resting decoration — no shadow, '
        'border at theme.border.',
    userSignal: 'The card sits flat, at its resting border colour.',
  ),
  DocsStateFact(
    state: 'Hover',
    treatment:
        'MouseRegion.onEnter flips hovered to true; the AnimatedContainer '
        'interpolates its decoration toward the hover values over '
        'effectiveMotionDuration(context, MotionDurations.normal) on '
        'MotionCurves.standard.',
    userSignal:
        'The card gains Shadows.lg, fading in from empty rather than '
        'snapping to full ink; the border colour crossfades toward '
        'theme.actionText.',
  ),
  DocsStateFact(
    state: 'Unhover',
    treatment:
        'MouseRegion.onExit flips hovered back to false; the same '
        'AnimatedContainer interpolates back to its resting decoration.',
    userSignal: 'The card settles back flat, shadow and border together.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'effectiveMotionDuration(context, MotionDurations.normal) is '
        're-read on every build, so a hover that starts after the OS '
        'switch flips lands on Duration.zero.',
    userSignal: 'The card snaps to its hovered (or rest) state instantly.',
  ),
];
