/// Public documentation page for the `press-motion` motion primitive.
///
/// **Why `EffectSection`, not `ShowcaseSection`.** `ElPress`
/// (`lib/src/motion/press.dart`) carries no variant enum and paints nothing
/// of its own: it reads a `child` and wraps it in a `Listener` plus a
/// `Transform.scale`, so the thing worth looking at is what it does to a
/// host, not a specimen of the widget in isolation. Every non-Preview
/// section here stages a host with and without the wrapper, exactly as the
/// brief for this page asks.
///
/// **House shape, motion edition.** Preview, Installation, Usage, then one
/// `EffectSection` per facet `ElPress` actually has — the default squish and
/// the three token scales a caller can substitute for it — then the same
/// eight disclosures every page carries. The States disclosure is the one
/// that carries real content: read straight off `_ElPressState.build` and
/// the two `Duration` fields the constructor exposes, not inferred.
///
/// **`pumpAndSettle` never appears in this page's own test.** A press-down
/// is a one-shot `AnimationController.forward()`/`reverse()`, not a
/// perpetual ticker, so nothing here loops forever — but the house rule is
/// never to reach for `pumpAndSettle` on a documentation page regardless,
/// and this page's test follows it with `tester.pump()` and bounded
/// `tester.pump(duration)` calls instead, the same idiom
/// `test/motion_test.dart`'s own `ElPress` group uses.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import 'meta.dart';

final ComponentDocSpec pressMotionDocSpec = ComponentDocSpec(
  name: 'press_motion',
  title: 'Press Motion',
  description: pressMotionDoc.description,
  sections: <DocsPageSection>[
    EffectSection(
      id: 'preview',
      title: 'Preview',
      description:
          'Press either chip. The left one is wrapped in ElPress: the '
          'instant a pointer goes down it squishes to ElTransforms.'
          'pressScale (0.94) over ElDurations.pressDown (40ms), then '
          'springs back over ElDurations.base (250ms) on release — the '
          'asymmetry the source calls "the whole feel." The right one is '
          'the same chip, unwrapped, for comparison against no press '
          'feedback at all.',
      host: const _PreviewHost(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'press-motion has a real registry manifest, `elattar add '
          'press-motion` installs lib/src/motion/press.dart and resolves '
          'its one registryDependency, source-foundation, automatically. '
          'The Manual tab is for a project not using the CLI.',
      command: pressMotionDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/motion/press.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/motion/press.dart's generated "
              '@motion/press.dart payload into your motion folder.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated press source here when using manual '
              'mode.',
        ),
        DocsCodeFile(
          path: 'lib/motion/motion.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ElPress is reachable the same way '
              'the CLI path already makes it.',
          code: "export 'press.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'Put ElPress on anything clickable that is not already a '
          'ElButton — the logo, a chip, a nav row, a theme-toggle option.',
      code: _usageCode,
    ),
    EffectSection(
      id: 'custom-scale',
      title: 'Custom Scale',
      description:
          'scale defaults to ElTransforms.pressScale (0.94), the bare '
          '`press` utility\'s own squish. A caller substitutes a sibling '
          'token for a different feel: ElButton itself passes '
          'ElTransforms.buttonScale (0.95, less travel — it already moves '
          'via its own shadow swap), and `click-spring` surfaces reach for '
          'ElTransforms.clickSpringScale (0.9, more travel, for a small '
          'target that wants an emphatic click).',
      host: const _CustomScaleHost(),
      code: _customScaleCode,
      label: 'Custom scale specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter ElPress declares, read off '
          'lib/src/motion/press.dart.',
      child: const _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      child: DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      child: const _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      child: const _KeyboardContent(),
    ),
    DisclosureSection(
      id: 'responsive',
      title: 'Responsive',
      child: const _ResponsiveContent(),
    ),
    DisclosureSection(
      id: 'dependencies',
      title: 'Dependencies',
      child: const _DependenciesContent(),
    ),
    DisclosureSection(
      id: 'theming',
      title: 'Theming',
      child: const _ThemingContent(),
    ),
    DisclosureSection(
      id: 'source',
      title: 'Source',
      child: DocsInstallFacts(
        title: 'Reference',
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Source',
            value: pressMotionDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/motion_test.dart',
            description:
                'The "ElPress" group covers the squish, the asymmetric '
                'durations, a cancelled press, onTap, and a custom scale.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/press_motion_test.dart',
            description:
                'Covers this page: the article mounts, the full API '
                'table, a live pointer-down/up sequence on the Preview '
                'specimen, and both themes — never with pumpAndSettle.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/press_motion/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class PressMotionDocPage extends StatelessWidget {
  const PressMotionDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: pressMotionDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / MOTION',
      title: pressMotionDoc.title,
      description: pressMotionDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Press Motion'),
    ],
    toc: pressMotionDocSpec.toc,
    previous: null,
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('press-motion-doc-article'),
      child: ComponentDocPage(spec: pressMotionDocSpec, header: false),
    ),
  );
}

/* ── Shared specimen shape ──────────────────────────────────────────────── */

double get _chipHeight => el(10);

class _CaptionedPair extends StatelessWidget {
  const _CaptionedPair({
    required this.leftCaption,
    required this.left,
    required this.rightCaption,
    required this.right,
  });

  final String leftCaption;
  final Widget left;
  final String rightCaption;
  final Widget right;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: el(2)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _Captioned(caption: leftCaption, child: left),
          SizedBox(width: el(8)),
          _Captioned(caption: rightCaption, child: right),
        ],
      ),
    ),
  );
}

class _Captioned extends StatelessWidget {
  const _Captioned({required this.caption, required this.child});

  final String caption;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      child,
      SizedBox(height: el(2)),
      ElText(caption, ElType.section, color: ElTheme.of(context).mutedForeground),
    ],
  );
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Container(
      height: _chipHeight,
      padding: EdgeInsets.symmetric(horizontal: el(5)),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(ElRadii.pill),
        border: Border.all(color: theme.border, width: ElWidths.hairline),
      ),
      child: ElText(label, ElType.small, color: theme.foreground),
    );
  }
}

/* ── Specimens ───────────────────────────────────────────────────────────── */

class _PreviewHost extends StatelessWidget {
  const _PreviewHost();

  @override
  Widget build(BuildContext context) => _CaptionedPair(
    leftCaption: 'ElPress(child: chip)',
    left: SizedBox(
      key: const ValueKey<String>('press-motion-example:wrapped'),
      child: ElPress(child: const _Chip(label: 'Press me')),
    ),
    rightCaption: 'chip, unwrapped',
    right: const SizedBox(
      key: ValueKey<String>('press-motion-example:bare'),
      child: _Chip(label: 'Nothing happens'),
    ),
  );
}

const String _previewCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    '// Without: no feedback at all on pointer-down.\n'
    "Text('Nothing happens')\n\n"
    '// With: ElPress squishes the child on pointer-down and springs it\n'
    '// back on release.\n'
    'ElPress(\n'
    "  child: const Text('Press me'),\n"
    ')';

class _CustomScaleHost extends StatelessWidget {
  const _CustomScaleHost();

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: el(2)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _Captioned(
            caption: 'pressScale (0.94, default)',
            child: SizedBox(
              key: const ValueKey<String>('press-motion-example:press-scale'),
              child: ElPress(child: const _Chip(label: 'press')),
            ),
          ),
          SizedBox(width: el(8)),
          _Captioned(
            caption: 'buttonScale (0.95)',
            child: SizedBox(
              key: const ValueKey<String>('press-motion-example:button-scale'),
              child: ElPress(
                scale: ElTransforms.buttonScale,
                child: const _Chip(label: 'button'),
              ),
            ),
          ),
          SizedBox(width: el(8)),
          _Captioned(
            caption: 'clickSpringScale (0.9)',
            child: SizedBox(
              key: const ValueKey<String>(
                'press-motion-example:click-spring-scale',
              ),
              child: ElPress(
                scale: ElTransforms.clickSpringScale,
                child: const _Chip(label: 'click-spring'),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

const String _customScaleCode =
    '// The bare press utility.\n'
    'ElPress(child: const Text(\'press\'))\n\n'
    '// What ElButton itself passes.\n'
    'ElPress(scale: ElTransforms.buttonScale, child: const Text(\'button\'))\n\n'
    '// click-spring: a smaller target, more travel.\n'
    'ElPress(\n'
    '  scale: ElTransforms.clickSpringScale,\n'
    "  child: const Text('click-spring'),\n"
    ')';

/* ── Disclosure content ─────────────────────────────────────────────────── */

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

ElPress(
  onTap: () {},
  child: const Text('Press me'),
)''';

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) =>
      const DocsApiTable(title: 'ElPress', facts: _apiFacts);
}

const List<DocsApiFact> _apiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'scale',
    type: 'double',
    description:
        'Optional. Defaults to ElTransforms.pressScale (0.94), the `:active`'
        ' scale a bare `press` utility carries. ElButton passes '
        'ElTransforms.buttonScale; `click-spring` surfaces pass '
        'ElTransforms.clickSpringScale.',
  ),
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description: 'Required. The widget that gets squished.',
  ),
  DocsApiFact(
    name: 'onTap',
    type: 'VoidCallback?',
    description:
        'Optional. Defaults to null. Lets a pressable surface skip '
        'wrapping itself in a second GestureDetector: when supplied, '
        'ElPress adds its own on top of the press-tracking Listener.',
  ),
  DocsApiFact(
    name: 'behavior',
    type: 'HitTestBehavior',
    description:
        'Optional. Defaults to HitTestBehavior.opaque. Passed straight '
        "through to both the internal Listener and, when onTap is set, "
        'the GestureDetector.',
  ),
  DocsApiFact(
    name: 'downDuration',
    type: 'Duration',
    description:
        'Optional. Defaults to ElDurations.pressDown (40ms) — how long '
        'the squish-in takes.',
  ),
  DocsApiFact(
    name: 'upDuration',
    type: 'Duration',
    description:
        'Optional. Defaults to ElDurations.base (250ms) — how long the '
        'spring-back takes. The asymmetry against downDuration is the '
        'whole feel: instant in, springy out.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest',
    treatment: 'AnimationController.value == 0; child painted at scale 1.',
    userSignal: 'Nothing pressed yet.',
  ),
  DocsStateFact(
    state: 'Pointer down',
    treatment:
        'Listener.onPointerDown calls controller.forward(): the '
        'controller runs 0 → 1 over downDuration (elAnimationDuration-'
        'resolved, so it collapses to zero under reduced motion), eased '
        'by ElCurves.spring. Transform.scale reads '
        '1 + (scale - 1) * progress, so a spring overshoot past 1.0 '
        'carries the visible scale a hair beyond target and back — the '
        'build() comment says explicitly not to clamp it.',
    userSignal: 'The child squishes toward `scale`, springing slightly '
        'past it before settling, the instant a pointer touches it.',
  ),
  DocsStateFact(
    state: 'Pointer up',
    treatment:
        'Listener.onPointerUp calls controller.reverse(): 1 → 0 over '
        'upDuration, eased by ElCurves.spring.flipped — the reverse '
        'curve is a genuinely different curve object, not the same '
        'curve replayed backwards, because a CurvedAnimation would '
        'otherwise play the easing\'s overshoot as a lag instead of a '
        'spring.',
    userSignal: 'The child springs back to scale 1 over 250ms, six times '
        'slower than it went down.',
  ),
  DocsStateFact(
    state: 'Pointer cancel',
    treatment: 'Listener.onPointerCancel routes to the same _release as '
        'onPointerUp: identical reverse().',
    userSignal:
        'A press that never completes still springs back, exactly as a '
        'released one does.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'ElPress renders no Semantics node of its own: build() returns a '
            'Listener (plus an optional GestureDetector) wrapping an '
            'AnimatedBuilder, none of which declare accessibility '
            'metadata. Whatever semantics child carries pass through '
            'untouched.',
        'onTap, when supplied, is a real interaction a screen reader can '
            'still reach: a GestureDetector\'s tap is exposed to assistive '
            'technology the same way any Flutter tap target is, but the '
            'accessible name and role are entirely child\'s, not '
            'ElPress\'s.',
        'The squish itself carries no announcement: nothing here tells '
            'assistive tech that the surface is animating, matching every '
            'other bare transform in this system.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'ElPress declares no Focus, no FocusNode and no onKeyEvent of '
            'its own: press.dart has no keyboard story at all. Pressing '
            'Enter or Space on a focused child that happens to be a real '
            'button will fire that child\'s own key handling, not this '
            'wrapper\'s — the squish only plays for a pointer down/up, '
            'because it is driven by Listener\'s pointer callbacks, never '
            'by a key event.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No breakpoint branching anywhere in press.dart: BuildContext '
            'width is never read for a layout decision.',
        'ElPress imposes no size of its own — Transform.scale paints '
            'child at whatever size child\'s own constraints give it, so '
            'the squish scales with the host exactly as it would with no '
            'wrapper present.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ElTheme.of(context), <String>[
        'File: lib/src/motion/press.dart: one file, no companions.',
        'Flutter imports: package:flutter/widgets.dart only.',
        'Foundation imports: foundation/motion.dart (ElTransforms, '
            'ElDurations, ElCurves, elAnimationDuration) and '
            'theme_scope.dart, for the same helper.',
        'registryDependencies, resolved automatically by `elattar add '
            'press-motion`: source-foundation — copied verbatim from '
            'registry/motion/press.json.',
        'Real use in this corpus: the source\'s own doc names the logo, '
            'a chip, a nav row and a theme-toggle option — anything '
            'clickable that is not already a ElButton, which reaches for '
            'ElTransforms.buttonScale on its own surface instead of '
            'wrapping itself in a second ElPress.',
      ]),
      SizedBox(height: el(2)),
      DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Button', route: '/components/button'),
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
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'ElPress reads no Color at all: it never calls ElTheme.of(context) '
            'and paints nothing beyond a Transform.scale around child. '
            'Every colour a reader sees on this page\'s specimens comes '
            'from the chip host this page builds around it, not from '
            'ElPress itself.',
        'The two durations it does read — downDuration and upDuration — '
            'are resolved through elAnimationDuration on every build, so '
            'MediaQuery.disableAnimations collapses both to zero: a '
            'press under reduced motion snaps to scale instantly and '
            'snaps back instantly, rather than skipping the effect '
            'outright.',
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
