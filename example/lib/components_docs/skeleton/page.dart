/// Public documentation page for the `skeleton` component.
///
/// **New route, split out of `progress`.** `ElSkeleton` used to share the
/// `/components/progress` route with `ElProgress`, its sections prefixed
/// `Skeleton: ` to tell them apart from the sibling component's own. This
/// page mirrors ONLY `https://ui.shadcn.com/docs/components/base/skeleton`'s
/// own section list, fetched fresh: Installation, Usage, Avatar, Card, Text,
/// Form, Table, RTL. Every section title below drops the redundant
/// `Skeleton: ` prefix now that the page documents one component only. A
/// live demo renders ahead of any heading, the same as the reference's own
/// top-of-page preview: no Overview, Status, or Preview heading precedes
/// Installation.
///
/// **Ours only.** `Avoiding layout shift` has no shadcn counterpart section:
/// it was already a built composition on the pre-split page, showing a real
/// swap from placeholder to loaded content without the row resizing, rather
/// than a shape gallery alone. Kept for the same reason.
///
/// The registry manifest ships with the CLI and installs through
/// `elattar add skeleton`.
///
/// **Motion.** `ElSkeleton`'s shimmer is a genuinely infinite
/// `AnimationController.repeat()` (`ElKeyframePlayer` with `repeat: true`),
/// gated through `elAnimationDuration` (`theme_scope.dart`) to a fully
/// stopped controller under `MediaQuery.disableAnimations`: confirmed by the
/// package's own `test/feedback_effects_test.dart` rasterised reduced-motion
/// case, and re-confirmed by this page's own docs test. See that test's
/// dedicated reduced-motion case for how this page verifies it without ever
/// calling `tester.pumpAndSettle()` against a looping controller.
///
/// **Narrow-viewport trap, inherited.** `_SkeletonTableDemo`'s row of three
/// cell-shaped bars measures wider than the 298px a docs panel leaves at a
/// 390px viewport; it is wrapped in `SingleChildScrollView(scrollDirection:
/// Axis.horizontal)`, the same mitigation the pre-split page already used
/// (and `pagination/page.dart`'s Responsive section and `separator/page.dart`
/// use elsewhere), rather than an unwrapped fixed-width `Row`.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

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
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Skeleton'),
    ],
    sidebar: _sidebar,
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Installation', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'Avatar', anchor: 'avatar'),
      DocsTocEntry(title: 'Card', anchor: 'card'),
      DocsTocEntry(title: 'Text', anchor: 'text'),
      DocsTocEntry(title: 'Form', anchor: 'form'),
      DocsTocEntry(title: 'Table', anchor: 'table'),
      DocsTocEntry(title: 'RTL', anchor: 'rtl'),
      DocsTocEntry(title: 'Avoiding layout shift', anchor: 'layout-shift'),
      DocsTocEntry(title: 'API Reference', anchor: 'api'),
      DocsTocEntry(title: 'States', anchor: 'states'),
      DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
      DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
      DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
      DocsTocEntry(title: 'Theming', anchor: 'theming'),
      DocsTocEntry(title: 'Source', anchor: 'source'),
    ],
    previous: const DocsPageLink(
      title: 'Progress',
      route: '/components/progress',
    ),
    next: const DocsPageLink(
      title: 'Separator',
      route: '/components/separator',
    ),
    onNavigate: onNavigate,
    child: const _SkeletonArticle(),
  );
}

/// `progress` and `skeleton`'s own small family: see `progress/page.dart`'s
/// own note on why this is scoped to the two siblings rather than the full
/// component list.
const List<DocsSidebarEntry> _sidebar = <DocsSidebarEntry>[
  DocsSidebarEntry(title: 'Progress', route: '/components/progress'),
  DocsSidebarEntry(
    title: 'Skeleton',
    route: '/components/skeleton',
    selected: true,
  ),
];

class _SkeletonArticle extends StatelessWidget {
  const _SkeletonArticle();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      key: const ValueKey<String>('skeleton-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // The live demo, ahead of any heading: the same shape the reference
        // opens with. No ElSection wraps it, so it carries no Overview/
        // Status/Preview heading before Installation.
        const DocsCodeExample(
          title: 'Skeleton',
          description:
              'A ElSkeleton avatar plus two text lines standing in for '
              'content that has not arrived yet.',
          preview: _TopDemo(),
        ),
        SizedBox(height: el(6)),
        _install(),
        _usage(),
        _avatar(),
        _card(),
        _text(),
        _form(),
        _table(),
        _rtl(),
        _layoutShift(),
        _apiReference(theme),
        _states(),
        _accessibility(theme),
        _responsive(theme),
        _dependencies(theme),
        _theming(theme),
        _source(),
      ],
    );
  }

  Widget _install() => ElSection(
    id: 'install',
    title: 'Installation',
    description:
        '`elattar add skeleton` installs the component and its declared '
        'dependency closure.',
    child: DocsInstallFacts(
      title: 'Installation facts',
      facts: <DocsInstallFact>[
        const DocsInstallFact(
          label: 'Registry item',
          value: 'registry/components/skeleton.json',
          description:
              'Shipped and resolved by `elattar add skeleton`. This is a '
              'source-only component today.',
        ),
        const DocsInstallFact(
          label: 'Destination',
          value: 'lib/components/ui/skeleton.dart',
          description: 'Where a manual copy of the source belongs.',
        ),
        const DocsInstallFact(
          label: 'Foundation',
          value: 'source only',
          description: 'No package-backed alternative is offered yet.',
        ),
        const DocsInstallFact(
          label: 'Dependencies',
          value: 'source-foundation',
          description:
              'foundation/theme.dart for the popover/accent gradient '
              'stops and motion/keyframes.dart for ElShimmer and '
              'ElKeyframePlayer, the shared looping-animation engine every '
              '"pulls-*" motion in this system reuses.',
        ),
        const DocsInstallFact(
          label: 'Assets',
          value: 'none',
          description: 'No images, icon fonts, or binary assets.',
        ),
        const DocsInstallFact(
          label: 'Shaders',
          value: 'none',
          description:
              'The sweep is a Canvas.drawRect painted with a '
              'LinearGradient shader object, not an asset-backed fragment '
              'shader.',
        ),
        DocsInstallFact(
          label: 'Platforms',
          value: 'Android, iOS, Web, macOS, Windows, Linux',
          description: 'No platform-conditional code in skeleton.dart.',
        ),
        const DocsInstallFact(
          label: 'Verified',
          value: 'package tests + docs specimen',
          description:
              'test/feedback_effects_test.dart, group(\'ElSkeleton\'), '
              'rasterises the sweep and proves reduced motion holds a '
              'fully static frame (zero changed pixels 470ms apart). This '
              'page\'s own skeleton_test.dart re-proves the settle without '
              'rasterising, by pumping bounded frames. No registry fixture '
              'install exists.',
        ),
      ],
    ),
  );

  Widget _usage() => ElSection(
    id: 'usage',
    title: 'Usage',
    description: 'A block, a circle, and an inline run of placeholder text.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: ElWidths.prose),
          child: ElText(
            'ElSkeleton renders a box the exact size of the thing that has '
            'not arrived yet, with a shimmering highlight sweeping across '
            'it forever, until the caller swaps it for real content. Reach '
            'for it when you already know the SHAPE of what is arriving: a '
            'card, an avatar plus two lines, a table row. A generic grey '
            'rectangle where a specific shape belongs causes a layout '
            'jump, which reads as more broken than either a progress bar '
            '(documented on its own page) or a spinner would.',
            ElType.body,
          ),
        ),
        SizedBox(height: el(5)),
        ElPanel(
          label: 'DART',
          note: 'MINIMAL',
          child: DocsSelectableCodeBlock(code: _usageCode),
        ),
      ],
    ),
  );

  Widget _avatar() => const ElSection(
    id: 'avatar',
    title: 'Avatar',
    description:
        'A circular placeholder sized like the avatar it stands in for: '
        'radius: ElRadii.pill turns the box into a circle the moment width '
        'and height are equal.',
    child: DocsCodeExample(
      title: 'Avatar skeleton',
      preview: KeyedSubtree(
        key: ValueKey<String>('skeleton-preview:avatar'),
        child: ElSkeleton(width: 40, height: 40, radius: ElRadii.pill),
      ),
    ),
  );

  Widget _card() => const ElSection(
    id: 'card',
    title: 'Card',
    description:
        'A block placeholder sized like the card it precedes: the caller '
        'picks the exact width and height, ElSkeleton has no card-shaped '
        'default of its own.',
    child: DocsCodeExample(
      title: 'Card skeleton',
      preview: KeyedSubtree(
        key: ValueKey<String>('skeleton-preview:card'),
        child: ElSkeleton(width: 320, height: 128),
      ),
    ),
  );

  Widget _text() => ElSection(
    id: 'text',
    title: 'Text',
    description:
        'Two block lines for a paragraph placeholder, rounded-md (the '
        'default radius), and one inline ElSkeleton.span standing in for a '
        'run of text inside a sentence rather than a block: the only way '
        'to exercise that factory.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DocsCodeExample(
          title: 'Text line skeletons',
          preview: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const KeyedSubtree(
                key: ValueKey<String>('skeleton-preview:line-1'),
                child: ElSkeleton(width: 220, height: 14),
              ),
              SizedBox(height: el(2)),
              const KeyedSubtree(
                key: ValueKey<String>('skeleton-preview:line-2'),
                child: ElSkeleton(width: 160, height: 14),
              ),
            ],
          ),
        ),
        SizedBox(height: el(5)),
        const DocsCodeExample(
          title: 'Inline skeleton',
          description:
              'ElSkeleton.span, aligned to PlaceholderAlignment.middle, '
              'standing in for a run of text.',
          preview: _SkeletonInlineDemo(),
        ),
      ],
    ),
  );

  Widget _form() => const ElSection(
    id: 'form',
    title: 'Form',
    description:
        'A label-then-field pair, twice, plus a pill-shaped submit-button '
        'placeholder: the caller sizes each box to match the real form '
        'control it precedes, the same discipline every other shape on '
        'this page follows.',
    child: DocsCodeExample(
      title: 'Form skeleton',
      preview: _SkeletonFormDemo(),
    ),
  );

  Widget _table() => const ElSection(
    id: 'table',
    title: 'Table',
    description:
        'Three rows of three cell-shaped bars: a table\'s loading state '
        'is the same "match the footprint" rule as everything else on '
        'this page, applied once per cell instead of once per block.',
    child: DocsCodeExample(
      title: 'Table skeleton',
      preview: _SkeletonTableDemo(),
    ),
  );

  Widget _rtl() => const ElSection(
    id: 'rtl',
    title: 'RTL',
    description:
        'ElSkeleton carries no text of its own, so nothing inside it '
        'mirrors on its own account: the surrounding Row does, because Row '
        'asks the ambient Directionality which edge is "start". The '
        'avatar sits on the visual right and the two lines run right to '
        'left here, purely from the parent Row, not from anything '
        'ElSkeleton itself does.',
    child: DocsCodeExample(
      title: 'Skeleton row under RTL',
      preview: _SkeletonRtlDemo(),
    ),
  );

  Widget _layoutShift() => const ElSection(
    id: 'layout-shift',
    title: 'Avoiding layout shift',
    description:
        'Not part of the shadcn counterpart\'s own section list: added '
        'because a shape gallery alone does not show the actual reason a '
        'skeleton is sized like its content. Press the button to swap the '
        'placeholders for real content in place: the row never resizes, '
        'because the skeleton was already sized to match it.',
    child: DocsCodeExample(
      title: 'A card that avoids layout shift',
      preview: _LoadingCardComposition(),
    ),
  );

  Widget _apiReference(ElThemeData theme) => ElSection(
    id: 'api',
    title: 'API Reference',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsApiTable(
          title: 'ElSkeleton properties',
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
                  'Overrides ElSkeleton.defaultRadius (10px). Set to '
                  'ElRadii.pill for an avatar circle or a pill-shaped '
                  'placeholder.',
            ),
          ],
        ),
        SizedBox(height: el(6)),
        const DocsApiTable(
          title: 'ElSkeleton static members',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'ElSkeleton.defaultRadius',
              type: 'static double',
              description: 'ElRadii.md (10px): the box\'s resting corner.',
            ),
            DocsApiFact(
              name: 'ElSkeleton.span',
              type:
                  'static InlineSpan Function({double? width, double? '
                  'height, double? radius})',
              description:
                  'Returns a WidgetSpan wrapping a ElSkeleton, aligned to '
                  'PlaceholderAlignment.middle, for a placeholder standing '
                  'in for a run of text inside a paragraph rather than a '
                  'block. See Text\'s inline specimen.',
            ),
          ],
        ),
        SizedBox(height: el(3)),
        ElText(
          'Skeleton has no variant enum at all: its "variant" is whatever '
          'width, height and radius the caller passes, because it must '
          'match the exact footprint of the content it stands in for. The '
          'corner is its only real choice: ElSkeleton.defaultRadius (10px) '
          'fits a block or a text-line placeholder; radius: ElRadii.pill '
          'turns the same widget into a circle or a pill.',
          ElType.small,
          color: theme.mutedForeground,
        ),
      ],
    ),
  );

  Widget _states() => ElSection(
    id: 'states',
    title: 'States',
    description:
        'A presentational StatelessWidget with no onPressed, no '
        'GestureDetector, and no FocusNode: most of IA §9.7\'s rows do not '
        'apply, so the ones that are genuinely N/A are grouped below with '
        'the reason instead of invented.',
    child: const DocsStateMatrix(
      facts: <DocsStateFact>[
        DocsStateFact(
          state: 'Loading (its only state)',
          treatment:
              'The shimmer runs forever via ElKeyframePlayer(repeat: true) '
              'until the caller stops rendering the skeleton and renders '
              'real content instead: ElSkeleton has no "done" flag of its '
              'own.',
          userSignal:
              'A continuously sweeping highlight signals "still working" '
              'for as long as the widget is on screen; the caller\'s own '
              'state (not a ElSkeleton parameter) decides when that ends.',
        ),
        DocsStateFact(
          state: 'Reduced motion',
          treatment:
              'MediaQuery.disableAnimations collapses the animation to '
              'Duration.zero via elAnimationDuration: ElKeyframePlayer '
              'stops its controller outright (fill: none reverts it to '
              't=0, its resting frame) rather than merely animating fast.',
          userSignal:
              'The skeleton holds one still frame instead of sweeping: '
              'confirmed by this page\'s docs test and by '
              'test/feedback_effects_test.dart\'s rasterised case.',
        ),
        DocsStateFact(
          state:
              'Hover / Focus-visible / Pressed / Selected / Empty / '
              'Disabled',
          treatment:
              'N/A: the widget carries no gesture, focus, or async-flag '
              'parameter to hold any of these; it is pure paint from its '
              'constructor arguments.',
          userSignal:
              'It does not respond to pointer or keyboard input; there is '
              'nothing to hover, focus, press, select, or disable.',
        ),
      ],
    ),
  );

  Widget _accessibility(ElThemeData theme) => ElSection(
    id: 'accessibility',
    title: 'Accessibility',
    child: _bullets(theme, <String>[
      'Semantic role: NONE. ElSkeleton builds no Semantics node, no '
          'ExcludeSemantics, and no liveRegion announcement anywhere in '
          'its source. This is a real gap, not a documented design choice '
          'the way ElBadge\'s silence is: a placeholder standing in for '
          'content a user is waiting on gets no "loading" or "busy" '
          'announcement at all.',
      'What a screen reader actually gets: because the widget\'s leaf is '
          'a childless CustomPaint inside a SizedBox, Flutter contributes '
          'no semantic information for it by default, so in practice it '
          'is silently skipped, which is closer to "hidden" than '
          '"announced as busy", but that is an accident of how empty '
          'render objects are treated, not something ElSkeleton declares. '
          'A screen reader user gets neither a "content is loading" cue '
          'nor a guarantee the region is excluded on purpose.',
      'Recommended mitigation at the call site until this grows its own '
          'semantics: wrap a loading region in Semantics(label: '
          "'Loading', liveRegion: true) (or a ElEmpty/ElAlert busy "
          'announcement) around the whole skeleton group, the same way a '
          'caller already owns the swap between skeleton and real '
          'content.',
      'Keyboard interactions: none, ElSkeleton is never in the tab '
          'order, consistent with it not being interactive content.',
    ]),
  );

  Widget _responsive(ElThemeData theme) => ElSection(
    id: 'responsive',
    title: 'Responsive',
    child: _bullets(theme, <String>[
      'No breakpoint reads from BuildContext, and no platform branch: the '
          'same widget tree renders at 390px and 1440px and on every '
          'target platform.',
      'ElSkeleton\'s geometry is entirely the caller\'s: width and height '
          'default to null, which takes the incoming constraint exactly '
          'the way an unconstrained Container would. Responsive behavior '
          'for a skeleton composition is a property of the layout around '
          'it, not of ElSkeleton itself.',
      'Platform parity: Android, iOS, Web, macOS, Windows and Linux all '
          'render the same widget tree.',
    ]),
  );

  Widget _dependencies(ElThemeData theme) => ElSection(
    id: 'dependencies',
    title: 'Dependencies',
    child: _bullets(theme, <String>[
      'File: lib/src/components/skeleton.dart (one file, private '
          '_ShimmerPainter included).',
      'Foundation imports: foundation/spacing.dart (el(), ElRadii), '
          'foundation/theme.dart (ElThemeData).',
      'Motion import: motion/keyframes.dart (ElKeyframePlayer, '
          'ElShimmer): the same looping-animation engine every "pulls-*" '
          'infinite motion in this system shares.',
      'Scope import: theme_scope.dart (ElTheme).',
      'Assets/fonts/shaders: none: the sweep is a LinearGradient shader '
          'object drawn by CustomPainter, not a bundled asset.',
    ]),
  );

  Widget _theming(ElThemeData theme) => ElSection(
    id: 'theming',
    title: 'Theming',
    child: _bullets(theme, <String>[
      'The shimmer gradient is theme.popover → theme.accent → '
          'theme.popover (ElShimmer.gradient(theme)): both stops resolve '
          'from the live theme, so light and dark each get their own '
          'correctly contrasted sweep with no override needed.',
      'ElSkeleton declares no colour parameter of its own: the gradient '
          'is entirely theme-derived, consistent with every other '
          'primitive on this page.',
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
          value: skeletonDoc.sourcePath,
          description:
              'Authoritative implementation: the truth this page was '
              'written from.',
        ),
        const DocsInstallFact(
          label: 'Package tests',
          value: 'test/feedback_effects_test.dart',
          description:
              'group(\'ElSkeleton\'): the rasterised sweep, and the '
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
  );
}

/// The unheaded top-of-page demo: one representative [ElSkeleton] group (an
/// avatar plus two text lines, the same shape the reference's own default
/// demo uses).
class _TopDemo extends StatelessWidget {
  const _TopDemo();

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      const ElSkeleton(width: 48, height: 48, radius: ElRadii.pill),
      SizedBox(width: el(3)),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const ElSkeleton(height: 16),
            SizedBox(height: el(2)),
            const ElSkeleton(height: 16, width: 200),
          ],
        ),
      ),
    ],
  );
}

/// The inline [ElSkeleton.span] specimen, standing in for a run of text
/// inside a sentence rather than a block.
class _SkeletonInlineDemo extends StatelessWidget {
  const _SkeletonInlineDemo();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final TextStyle bodyStyle = ElText.styleOf(
      context,
      ElType.body,
      color: theme.foreground,
    );
    return Text.rich(
      TextSpan(
        style: bodyStyle,
        children: <InlineSpan>[
          const TextSpan(text: 'The next release ships in '),
          ElSkeleton.span(width: 64, height: 14),
          const TextSpan(text: ' weeks, after code freeze.'),
        ],
      ),
    );
  }
}

/// Two label-then-field pairs and a submit-button placeholder: a form's
/// loading state, sized like the controls it precedes.
class _SkeletonFormDemo extends StatelessWidget {
  const _SkeletonFormDemo();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const KeyedSubtree(
        key: ValueKey<String>('skeleton-preview:form-name-label'),
        child: ElSkeleton(width: 90, height: 12),
      ),
      SizedBox(height: el(2)),
      const KeyedSubtree(
        key: ValueKey<String>('skeleton-preview:form-name-input'),
        child: ElSkeleton(width: 280, height: 36),
      ),
      SizedBox(height: el(4)),
      const KeyedSubtree(
        key: ValueKey<String>('skeleton-preview:form-email-label'),
        child: ElSkeleton(width: 90, height: 12),
      ),
      SizedBox(height: el(2)),
      const KeyedSubtree(
        key: ValueKey<String>('skeleton-preview:form-email-input'),
        child: ElSkeleton(width: 280, height: 36),
      ),
      SizedBox(height: el(4)),
      const KeyedSubtree(
        key: ValueKey<String>('skeleton-preview:form-submit'),
        child: ElSkeleton(width: 110, height: 36, radius: ElRadii.pill),
      ),
    ],
  );
}

/// Three rows of three cell-shaped bars: a table's loading state. Each row
/// is one conceptual table row, so it is wrapped in the page's established
/// horizontal-scroll mitigation (see `pagination/page.dart`'s Responsive
/// section and `separator/page.dart`'s own wide specimen) rather than
/// wrapped onto a second line, which would misrepresent a single table row
/// as two. The 322px this row measures against the 298px a docs panel leaves
/// at a 390px viewport is what makes the wrap necessary, not decoration.
class _SkeletonTableDemo extends StatelessWidget {
  const _SkeletonTableDemo();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      for (int row = 0; row < 3; row++) ...<Widget>[
        if (row > 0) SizedBox(height: el(3)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            key: ValueKey<String>('skeleton-preview:table-row-$row'),
            children: <Widget>[
              const ElSkeleton(width: 140, height: 14),
              SizedBox(width: el(4)),
              const ElSkeleton(width: 90, height: 14),
              SizedBox(width: el(4)),
              const ElSkeleton(width: 60, height: 14),
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
        const ElSkeleton(width: 40, height: 40, radius: ElRadii.pill),
        SizedBox(width: el(3)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const ElSkeleton(height: 14),
              SizedBox(height: el(2)),
              const ElSkeleton(height: 14, width: 160),
            ],
          ),
        ),
      ],
    ),
  );
}

/// A settings-row shape that swaps a [ElSkeleton] avatar and two text-line
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
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        child: ElIcon(
                          ElIconGlyph.user,
                          size: ElIconSize.sm,
                          tone: ElIconTone.muted,
                        ),
                      ),
                    )
                  : const ElSkeleton(
                      width: 40,
                      height: 40,
                      radius: ElRadii.pill,
                    ),
            ),
            SizedBox(width: el(3)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _loaded
                    ? <Widget>[
                        ElText(
                          'Amara Chen',
                          ElType.section,
                          color: theme.foreground,
                        ),
                        SizedBox(height: el(1)),
                        ElText(
                          'Design lead: active 2 minutes ago',
                          ElType.small,
                          color: theme.mutedForeground,
                        ),
                      ]
                    : const <Widget>[
                        ElSkeleton(width: 140, height: 14),
                        SizedBox(height: 8),
                        ElSkeleton(width: 200, height: 12),
                      ],
              ),
            ),
          ],
        ),
        SizedBox(height: el(4)),
        ElButton(
          key: const ValueKey<String>('skeleton-doc-toggle-loaded'),
          variant: ElButtonVariant.outline,
          size: ElButtonSize.sm,
          label: _loaded ? 'Show skeleton again' : 'Show loaded content',
          onPressed: () => setState(() => _loaded = !_loaded),
          child: ElText(
            _loaded ? 'Show skeleton again' : 'Show loaded content',
            ElComponentType.buttonLabel,
          ),
        ),
      ],
    );
  }
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

const String _usageCode = '''
// A block the exact size of the card that will replace it.
ElSkeleton(width: 320, height: 128)

// A circular avatar placeholder.
ElSkeleton(width: 40, height: 40, radius: ElRadii.pill)

// Inline, standing in for a run of text.
Text.rich(
  TextSpan(
    style: ElText.styleOf(context, ElType.body),
    children: <InlineSpan>[
      const TextSpan(text: 'Ready in '),
      ElSkeleton.span(width: 64, height: 14),
    ],
  ),
)''';
