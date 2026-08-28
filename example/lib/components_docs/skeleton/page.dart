/// Public documentation page for the `skeleton` component.
///
/// **Re-housed onto the kit.** This page used to hand-compose `Section`
/// panels; it now declares a `ComponentDocSpec`
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// `ComponentDocPage`, the shape `button` established. Every specimen widget
/// and every code string the old page carried moves across unchanged; what
/// is new is a code string beside every showcase that used to be a bare
/// `DocsCodeExample` preview with no source shown (Preview, Text, Form,
/// Table, RTL, Avoiding layout shift all lacked one), the promotion of the
/// unheaded top-of-page demo to a real `Preview` section with its own rail
/// entry, and a Keyboard disclosure between Accessibility and Responsive.
///
/// **New route, split out of `progress`.** `Skeleton` used to share the
/// `/components/progress` route with `Progress`, its sections prefixed
/// `Skeleton: ` to tell them apart from the sibling component's own. This
/// page still mirrors ONLY `https://ui.shadcn.com/docs/components/base/
/// skeleton`'s own section list: Installation, Usage, Avatar, Card, Text,
/// Form, Table, RTL.
///
/// **Ours only.** `Avoiding layout shift` has no shadcn counterpart section:
/// it was already a built composition on the pre-split page, showing a real
/// swap from placeholder to loaded content without the row resizing, rather
/// than a shape gallery alone. Kept for the same reason.
///
/// **The manifest is real.** `registry/components/skeleton.json` ships
/// today: `elattar add skeleton` installs `lib/src/components/skeleton.dart`
/// and resolves `keyframes` and `source-foundation` automatically. The
/// Manual tab below is for a project not using the CLI.
///
/// **Motion.** `Skeleton`'s shimmer is a genuinely infinite
/// `AnimationController.repeat()` (`KeyframePlayer` with `repeat: true`),
/// gated through `effectiveMotionDuration` (`theme_scope.dart`) to a fully
/// stopped controller under `MediaQuery.disableAnimations`: confirmed by the
/// package's own `test/feedback_effects_test.dart` rasterised reduced-motion
/// case, and re-confirmed by this page's own docs test.
///
/// **Narrow-viewport trap, inherited.** `_SkeletonTableDemo`'s row of three
/// cell-shaped bars measures wider than the 298px a docs panel leaves at a
/// 390px viewport; it is wrapped in `SingleChildScrollView(scrollDirection:
/// Axis.horizontal)`, the same mitigation `separator/page.dart`'s own wide
/// specimens use, rather than an unwrapped fixed-width `Row`.
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

final ComponentDocSpec skeletonDocSpec = ComponentDocSpec(
  name: 'skeleton',
  title: skeletonDoc.title,
  description: skeletonDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'A Skeleton avatar plus two text lines standing in for content '
          'that has not arrived yet: the same shape the reference\'s own '
          'top-of-page demo uses.',
      specimen: _TopDemo(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'skeleton has a real registry manifest, `elattar add skeleton` '
          'installs lib/src/components/skeleton.dart and resolves keyframes '
          'and source-foundation automatically. The Manual tab is for a '
          'project not using the CLI.',
      command: skeletonDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/skeleton.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/skeleton.dart's generated "
              '@ui/skeleton.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated skeleton source here when using '
              'manual mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so Skeleton is reachable the same way '
              'the CLI path already makes it.',
          code: "export 'skeleton.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description: 'A block, a circle, and an inline run of placeholder text.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'avatar',
      title: 'Avatar',
      description:
          'A circular placeholder sized like the avatar it stands in for: '
          'radius: Radii.full turns the box into a circle the moment '
          'width and height are equal.',
      specimen: const KeyedSubtree(
        key: ValueKey<String>('skeleton-preview:avatar'),
        child: Skeleton(width: 40, height: 40, radius: Radii.full),
      ),
      code: _avatarCode,
      label: 'Avatar specimen view',
    ),
    ShowcaseSection(
      id: 'card',
      title: 'Card',
      description:
          'A block placeholder sized like the card it precedes: the '
          'caller picks the exact width and height, Skeleton has no '
          'card-shaped default of its own.',
      specimen: const KeyedSubtree(
        key: ValueKey<String>('skeleton-preview:card'),
        child: Skeleton(width: 320, height: 128),
      ),
      code: _cardCode,
      label: 'Card specimen view',
    ),
    ShowcaseSection(
      id: 'text',
      title: 'Text',
      description:
          'Two block lines for a paragraph placeholder, rounded-md (the '
          'default radius), and one inline Skeleton.span standing in for '
          'a run of text inside a sentence rather than a block: the only '
          'way to exercise that factory.',
      specimen: _TextSpecimen(),
      code: _textCode,
      label: 'Text specimen view',
    ),
    ShowcaseSection(
      id: 'form',
      title: 'Form',
      description:
          'A label-then-field pair, twice, plus a pill-shaped submit-button '
          'placeholder: the caller sizes each box to match the real form '
          'control it precedes, the same discipline every other shape on '
          'this page follows.',
      specimen: _SkeletonFormDemo(),
      code: _formCode,
      label: 'Form specimen view',
    ),
    ShowcaseSection(
      id: 'table',
      title: 'Table',
      description:
          'Three rows of three cell-shaped bars: a table\'s loading state '
          'is the same "match the footprint" rule as everything else on '
          'this page, applied once per cell instead of once per block.',
      specimen: _SkeletonTableDemo(),
      code: _tableCode,
      label: 'Table specimen view',
    ),
    ShowcaseSection(
      id: 'rtl',
      title: 'RTL',
      description:
          'Skeleton carries no text of its own, so nothing inside it '
          'mirrors on its own account: the surrounding Row does, because '
          'Row asks the ambient Directionality which edge is "start". The '
          'avatar sits on the visual right and the two lines run right to '
          'left here, purely from the parent Row, not from anything '
          'Skeleton itself does.',
      specimen: _SkeletonRtlDemo(),
      code: _rtlCode,
      label: 'RTL specimen view',
    ),
    ShowcaseSection(
      id: 'layout-shift',
      title: 'Avoiding layout shift',
      description:
          'Not part of the shadcn counterpart\'s own section list: added '
          'because a shape gallery alone does not show the actual reason a '
          'skeleton is sized like its content. Press the button to swap '
          'the placeholders for real content in place: the row never '
          'resizes, because the skeleton was already sized to match it.',
      specimen: _LoadingCardComposition(),
      code: _layoutShiftCode,
      label: 'Avoiding layout shift specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Skeleton has no variant enum at all: its "variant" is whatever '
          'width, height and radius the caller passes, because it must '
          'match the exact footprint of the content it stands in for.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'Skeleton', anchor: 'api-elskeleton'),
        DocsTocEntry(
          title: 'Skeleton static members',
          anchor: 'api-elskeleton-static',
        ),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'A presentational StatelessWidget with no onPressed, no '
          'GestureDetector, and no FocusNode: most of the usual state '
          'matrix does not apply, so the rows that are genuinely N/A are '
          'grouped below with the reason instead of invented.',
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
        'Skeleton is never in the tab order: no Focus widget, no '
        'FocusNode, and no key handling exist anywhere in skeleton.dart, '
        'consistent with it not being interactive content.',
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
            value: skeletonDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/feedback_effects_test.dart',
            description:
                'group(\'Skeleton\'): the rasterised sweep, and the '
                'rasterised reduced-motion case that proves a still frame.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/skeleton_test.dart',
            description:
                'Covers this page: the API tables, live specimens in every '
                'shape, the pager, and a dedicated reduced-motion case.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/skeleton/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class SkeletonDocPage extends StatelessWidget {
  const SkeletonDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: skeletonDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: skeletonDoc.title,
      description: skeletonDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Skeleton'),
    ],
    toc: skeletonDocSpec.toc,
    previous: const DocsPageLink(
      title: 'Progress',
      route: '/components/progress',
    ),
    next: const DocsPageLink(
      title: 'Separator',
      route: '/components/separator',
    ),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('skeleton-doc-article'),
      child: ComponentDocPage(spec: skeletonDocSpec, header: false),
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
    constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
    child: StyledText(
      text,
      TextStyles.small,
      color: ThemeScope.of(context).mutedForeground,
    ),
  );
}

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsAnchor(
          id: 'api-elskeleton',
          child: DocsApiTable(
            title: 'Skeleton',
            facts: <DocsApiFact>[
              DocsApiFact(
                name: 'width',
                type: 'double?',
                description:
                    'The box\'s width, or null to take the incoming '
                    'constraint (the caller\'s footprint, not a default '
                    'shape).',
              ),
              DocsApiFact(
                name: 'height',
                type: 'double?',
                description:
                    'The box\'s height, or null to take the incoming '
                    'constraint.',
              ),
              DocsApiFact(
                name: 'radius',
                type: 'double?',
                description:
                    'Overrides Skeleton.defaultRadius (10px). Set to '
                    'Radii.full for an avatar circle or a pill-shaped '
                    'placeholder.',
              ),
            ],
          ),
        ),
        SizedBox(height: space(6)),
        const DocsAnchor(
          id: 'api-elskeleton-static',
          child: DocsApiTable(
            title: 'Skeleton static members',
            facts: <DocsApiFact>[
              DocsApiFact(
                name: 'Skeleton.defaultRadius',
                type: 'static double',
                description: 'Radii.md (10px): the box\'s resting corner.',
              ),
              DocsApiFact(
                name: 'Skeleton.span',
                type:
                    'static InlineSpan Function({double? width, double? '
                    'height, double? radius})',
                description:
                    'Returns a WidgetSpan wrapping a Skeleton, aligned '
                    'to PlaceholderAlignment.middle, for a placeholder '
                    'standing in for a run of text inside a paragraph '
                    'rather than a block. See Text\'s inline specimen.',
              ),
            ],
          ),
        ),
        SizedBox(height: space(3)),
        StyledText(
          'radius is Skeleton\'s only real choice: Skeleton.defaultRadius '
          '(10px) fits a block or a text-line placeholder; radius: '
          'Radii.full turns the same widget into a circle or a pill.',
          TextStyles.small,
          color: theme.mutedForeground,
        ),
      ],
    );
  }
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Semantic role: NONE. Skeleton builds no Semantics node, no '
            'ExcludeSemantics, and no liveRegion announcement anywhere in '
            'its source. This is a real gap, not a documented design '
            'choice: a placeholder standing in for content a user is '
            'waiting on gets no "loading" or "busy" announcement at all.',
        'What a screen reader actually gets: because the widget\'s leaf is '
            'a childless CustomPaint inside a SizedBox, Flutter contributes '
            'no semantic information for it by default, so in practice it '
            'is silently skipped, which is closer to "hidden" than '
            '"announced as busy", but that is an accident of how empty '
            'render objects are treated, not something Skeleton '
            'declares.',
        'Recommended mitigation at the call site until this grows its own '
            'semantics: wrap a loading region in Semantics(label: '
            "'Loading', liveRegion: true) around the whole skeleton group, "
            'the same way a caller already owns the swap between skeleton '
            'and real content.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No breakpoint reads from BuildContext, and no platform branch: '
            'the same widget tree renders at 390px and 1440px and on '
            'every target platform.',
        'Skeleton\'s geometry is entirely the caller\'s: width and '
            'height default to null, which takes the incoming constraint '
            'exactly the way an unconstrained Container would. Responsive '
            'behavior for a skeleton composition is a property of the '
            'layout around it, not of Skeleton itself.',
        'Platform parity: Android, iOS, Web, macOS, Windows and Linux all '
            'render the same widget tree.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DocsInstallFacts(
        title: 'Dependencies',
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Files',
            value: skeletonDoc.sourcePath,
            description: 'One file, private _ShimmerPainter included.',
          ),
          const DocsInstallFact(
            label: 'Imports',
            value:
                'foundation/spacing.dart (space(), Radii), '
                'foundation/theme.dart (ThemeTokens), '
                'motion/keyframes.dart (KeyframePlayer, LoadingShimmerMotion), '
                'theme_scope.dart (ThemeScope)',
            description:
                'KeyframePlayer and LoadingShimmerMotion are the same '
                'looping-animation engine every "pulls-*" motion in this '
                'system reuses. No other component dependency.',
          ),
          const DocsInstallFact(
            label: 'registryDependencies',
            value: 'keyframes, source-foundation',
            description:
                'Resolved automatically by `elattar add skeleton` — '
                'copied verbatim from the manifest.',
          ),
          const DocsInstallFact(
            label: 'Assets, fonts, shaders',
            value: 'None',
            description:
                'The sweep is a Canvas.drawRect painted with a '
                'LinearGradient shader object, not an asset-backed '
                'fragment shader.',
          ),
          const DocsInstallFact(
            label: 'Platforms',
            value: 'Android, iOS, Web, macOS, Windows, Linux',
            description: 'No platform-conditional code in skeleton.dart.',
          ),
          const DocsInstallFact(
            label: 'Verified',
            value: 'package tests + docs specimen',
            description:
                'test/feedback_effects_test.dart\'s group(\'Skeleton\') '
                'rasterises the sweep and proves reduced motion holds a '
                'fully static frame; this page\'s own skeleton_test.dart '
                're-proves the settle without rasterising, by pumping '
                'bounded frames.',
          ),
        ],
      ),
      SizedBox(height: space(2)),
      DocsLinkRow(
        links: <DocsLink>[
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
    'The shimmer gradient is theme.popover → theme.accent → '
        'theme.popover (LoadingShimmerMotion.gradient(theme)): both stops resolve '
        'from the live theme, so light and dark each get their own '
        'correctly contrasted sweep with no override needed.',
    'Skeleton declares no colour parameter of its own: the gradient '
        'is entirely theme-derived, consistent with every other '
        'primitive on this page.',
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

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Loading (its only state)',
    treatment:
        'The shimmer runs forever via KeyframePlayer(repeat: true) until '
        'the caller stops rendering the skeleton and renders real content '
        'instead: Skeleton has no "done" flag of its own.',
    userSignal:
        'A continuously sweeping highlight signals "still working" for as '
        'long as the widget is on screen; the caller\'s own state (not a '
        'Skeleton parameter) decides when that ends.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'MediaQuery.disableAnimations collapses the animation to '
        'Duration.zero via effectiveMotionDuration: KeyframePlayer stops its '
        'controller outright (fill: none reverts it to t=0, its resting '
        'frame) rather than merely animating fast.',
    userSignal:
        'The skeleton holds one still frame instead of sweeping: confirmed '
        'by this page\'s docs test and by '
        'test/feedback_effects_test.dart\'s rasterised case.',
  ),
  DocsStateFact(
    state: 'Hover / Focus-visible / Pressed / Selected / Empty / Disabled',
    treatment:
        'N/A: the widget carries no gesture, focus, or async-flag '
        'parameter to hold any of these; it is pure paint from its '
        'constructor arguments.',
    userSignal:
        'It does not respond to pointer or keyboard input; there is '
        'nothing to hover, focus, press, select, or disable.',
  ),
];

/* ── Showcase specimens ─────────────────────────────────────────────────── */

/// The unheaded top-of-page demo: one representative [Skeleton] group (an
/// avatar plus two text lines, the same shape the reference's own default
/// demo uses).
class _TopDemo extends StatelessWidget {
  const _TopDemo();

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      const Skeleton(width: 48, height: 48, radius: Radii.full),
      SizedBox(width: space(3)),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Skeleton(height: 16),
            SizedBox(height: space(2)),
            const Skeleton(height: 16, width: 200),
          ],
        ),
      ),
    ],
  );
}

/// The inline [Skeleton.span] specimen, standing in for a run of text
/// inside a sentence rather than a block.
class _SkeletonInlineDemo extends StatelessWidget {
  const _SkeletonInlineDemo();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final TextStyle bodyStyle = StyledText.styleOf(
      context,
      TextStyles.body,
      color: theme.foreground,
    );
    return Text.rich(
      TextSpan(
        style: bodyStyle,
        children: <InlineSpan>[
          const TextSpan(text: 'The next release ships in '),
          Skeleton.span(width: 64, height: 14),
          const TextSpan(text: ' weeks, after code freeze.'),
        ],
      ),
    );
  }
}

/// The two text-line skeletons plus the inline specimen, combined into one
/// specimen for the Text section: both pieces move across unchanged from the
/// pre-kit page, which showed them as two separate unheaded demos.
class _TextSpecimen extends StatelessWidget {
  const _TextSpecimen();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const KeyedSubtree(
        key: ValueKey<String>('skeleton-preview:line-1'),
        child: Skeleton(width: 220, height: 14),
      ),
      SizedBox(height: space(2)),
      const KeyedSubtree(
        key: ValueKey<String>('skeleton-preview:line-2'),
        child: Skeleton(width: 160, height: 14),
      ),
      SizedBox(height: space(5)),
      const _SkeletonInlineDemo(),
    ],
  );
}

/// Two label-then-field pairs and a submit-button placeholder: a form's
/// loading state, sized like the controls it precedes.
class _SkeletonFormDemo extends StatelessWidget {
  const _SkeletonFormDemo();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const KeyedSubtree(
        key: ValueKey<String>('skeleton-preview:form-name-label'),
        child: Skeleton(width: 90, height: 12),
      ),
      SizedBox(height: space(2)),
      const KeyedSubtree(
        key: ValueKey<String>('skeleton-preview:form-name-input'),
        child: Skeleton(width: 280, height: 36),
      ),
      SizedBox(height: space(4)),
      const KeyedSubtree(
        key: ValueKey<String>('skeleton-preview:form-email-label'),
        child: Skeleton(width: 90, height: 12),
      ),
      SizedBox(height: space(2)),
      const KeyedSubtree(
        key: ValueKey<String>('skeleton-preview:form-email-input'),
        child: Skeleton(width: 280, height: 36),
      ),
      SizedBox(height: space(4)),
      const KeyedSubtree(
        key: ValueKey<String>('skeleton-preview:form-submit'),
        child: Skeleton(width: 110, height: 36, radius: Radii.full),
      ),
    ],
  );
}

/// Three rows of three cell-shaped bars: a table's loading state. Each row
/// is one conceptual table row, so it is wrapped in the page's established
/// horizontal-scroll mitigation rather than wrapped onto a second line,
/// which would misrepresent a single table row as two.
class _SkeletonTableDemo extends StatelessWidget {
  const _SkeletonTableDemo();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      for (int row = 0; row < 3; row++) ...<Widget>[
        if (row > 0) SizedBox(height: space(3)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            key: ValueKey<String>('skeleton-preview:table-row-$row'),
            children: <Widget>[
              const Skeleton(width: 140, height: 14),
              SizedBox(width: space(4)),
              const Skeleton(width: 90, height: 14),
              SizedBox(width: space(4)),
              const Skeleton(width: 60, height: 14),
            ],
          ),
        ),
      ],
    ],
  );
}

/// An avatar-plus-two-lines row rendered under an ambient RTL
/// [Directionality]: the surrounding [Row] mirrors, exactly as `RTL`'s own
/// description explains.
class _SkeletonRtlDemo extends StatelessWidget {
  const _SkeletonRtlDemo();

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Row(
      children: <Widget>[
        const Skeleton(width: 40, height: 40, radius: Radii.full),
        SizedBox(width: space(3)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Skeleton(height: 14),
              SizedBox(height: space(2)),
              const Skeleton(height: 14, width: 160),
            ],
          ),
        ),
      ],
    ),
  );
}

/// A settings-row shape that swaps a [Skeleton] avatar and two text-line
/// skeletons for real content, without the row changing size: the reason
/// `skeleton.dart`'s own class doc gives for why the geometry is always the
/// caller's.
class _LoadingCardComposition extends StatefulWidget {
  const _LoadingCardComposition();

  @override
  State<_LoadingCardComposition> createState() =>
      _LoadingCardCompositionState();
}

class _LoadingCardCompositionState extends State<_LoadingCardComposition> {
  bool _loaded = false;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 40,
              height: 40,
              child: _loaded
                  ? DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.muted,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          IconGlyph.user,
                          size: IconSize.sm,
                          tone: IconTone.muted,
                        ),
                      ),
                    )
                  : const Skeleton(width: 40, height: 40, radius: Radii.full),
            ),
            SizedBox(width: space(3)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _loaded
                    ? <Widget>[
                        StyledText(
                          'Amara Chen',
                          TextStyles.section,
                          color: theme.foreground,
                        ),
                        SizedBox(height: space(1)),
                        StyledText(
                          'Design lead: active 2 minutes ago',
                          TextStyles.small,
                          color: theme.mutedForeground,
                        ),
                      ]
                    : const <Widget>[
                        Skeleton(width: 140, height: 14),
                        SizedBox(height: 8),
                        Skeleton(width: 200, height: 12),
                      ],
              ),
            ),
          ],
        ),
        SizedBox(height: space(4)),
        Button(
          key: const ValueKey<String>('skeleton-doc-toggle-loaded'),
          variant: ButtonVariant.outline,
          size: ButtonSize.sm,
          label: _loaded ? 'Show skeleton again' : 'Show loaded content',
          onPressed: () => setState(() => _loaded = !_loaded),
          child: StyledText(
            _loaded ? 'Show skeleton again' : 'Show loaded content',
            TextStyles.buttonLabel,
          ),
        ),
      ],
    );
  }
}

/* ── Code strings ───────────────────────────────────────────────────────── */

const String _usageCode = '''
// A block the exact size of the card that will replace it.
Skeleton(width: 320, height: 128)

// A circular avatar placeholder.
Skeleton(width: 40, height: 40, radius: Radii.full)

// Inline, standing in for a run of text.
Text.rich(
  TextSpan(
    style: StyledText.styleOf(context, TextStyles.body),
    children: <InlineSpan>[
      const TextSpan(text: 'Ready in '),
      Skeleton.span(width: 64, height: 14),
    ],
  ),
)''';

const String _previewCode = '''Row(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Skeleton(width: 48, height: 48, radius: Radii.full),
    SizedBox(width: 12),
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Skeleton(height: 16),
          SizedBox(height: 8),
          Skeleton(height: 16, width: 200),
        ],
      ),
    ),
  ],
)''';

const String _avatarCode =
    'Skeleton(width: 40, height: 40, radius: Radii.full)';

const String _cardCode = 'Skeleton(width: 320, height: 128)';

const String _textCode = '''Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Skeleton(width: 220, height: 14),
    SizedBox(height: 8),
    Skeleton(width: 160, height: 14),
  ],
)

// Inline, standing in for a run of text inside a sentence.
Text.rich(
  TextSpan(
    style: StyledText.styleOf(context, TextStyles.body),
    children: [
      TextSpan(text: 'The next release ships in '),
      Skeleton.span(width: 64, height: 14),
      TextSpan(text: ' weeks, after code freeze.'),
    ],
  ),
)''';

const String _formCode = '''Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Skeleton(width: 90, height: 12),
    SizedBox(height: 8),
    Skeleton(width: 280, height: 36),
    SizedBox(height: 16),
    Skeleton(width: 90, height: 12),
    SizedBox(height: 8),
    Skeleton(width: 280, height: 36),
    SizedBox(height: 16),
    Skeleton(width: 110, height: 36, radius: Radii.full),
  ],
)''';

const String _tableCode = '''Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    for (int row = 0; row < 3; row++)
      Row(
        children: [
          Skeleton(width: 140, height: 14),
          SizedBox(width: 16),
          Skeleton(width: 90, height: 14),
          SizedBox(width: 16),
          Skeleton(width: 60, height: 14),
        ],
      ),
  ],
)''';

const String _rtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: Row(
    children: [
      Skeleton(width: 40, height: 40, radius: Radii.full),
      SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Skeleton(height: 14),
            SizedBox(height: 8),
            Skeleton(height: 14, width: 160),
          ],
        ),
      ),
    ],
  ),
)''';

const String _layoutShiftCode = '''class _LoadingCard extends StatefulWidget {
  @override
  State<_LoadingCard> createState() => _LoadingCardState();
}

class _LoadingCardState extends State<_LoadingCard> {
  bool _loaded = false;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: [
          _loaded
              ? CircleAvatar(child: Icon(Icons.person))
              : Skeleton(width: 40, height: 40, radius: Radii.full),
          if (!_loaded) ...[
            Skeleton(width: 140, height: 14),
            Skeleton(width: 200, height: 12),
          ] else ...[
            Text('Amara Chen'),
            Text('Design lead: active 2 minutes ago'),
          ],
        ],
      ),
      Button(
        onPressed: () => setState(() => _loaded = !_loaded),
        child: Text(_loaded ? 'Show skeleton again' : 'Show loaded content'),
      ),
    ],
  );
}''';
