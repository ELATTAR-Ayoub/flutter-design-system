/// Public documentation page for the `disabled` component.
///
/// **Why `ShowcaseSection`, not `EffectSection`.** `Disabled`
/// (`lib/src/components/ui/disabled.dart`) is applied to a host the same way
/// `Press` is, but unlike `Press` its whole point is a state a reader can
/// flip and watch settle — the fade, the tooltip, the tap hook — so each
/// specimen here is a live, stateful host rather than a static before/after
/// pair, and `ShowcaseSection` is the shape that stages one.
///
/// **House shape.** Preview, Installation, Usage, then one section per facet
/// `Disabled` actually has — the reason tooltip, the tap hook, the pointer
/// block — then the same eight disclosures every page carries.
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

final ComponentDocSpec disabledDocSpec = ComponentDocSpec(
  name: 'disabled',
  title: 'Disabled',
  description: disabledDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'A disabled Button next to an enabled one. The disabled button '
          'dims to SurfaceOpacity.disabled, ignores pointer input and shows '
          'its disabledReason as a tooltip on hover.',
      specimen: const _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: 160,
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'disabled has a real registry manifest, `elattar add '
          'disabled` installs lib/src/components/ui/disabled.dart and '
          'resolves its two registryDependencies, tooltip and '
          'source-foundation, automatically. The Manual tab is for a '
          'project not using the CLI.',
      command: disabledDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/disabled.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/ui/disabled.dart's generated "
              '@ui/disabled.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated disabled source here when using manual '
              'mode.',
        ),
        DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so Disabled is reachable the same way '
              'the CLI path already makes it.',
          code: "export 'disabled.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'Every disableable control in this system wraps its child in '
          'Disabled rather than hand-rolling an Opacity plus an '
          'IgnorePointer.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'reason-tooltip',
      title: 'Reason tooltip',
      description:
          'reason shows on hover with a pointer, and on tap on a touch '
          'device, telling the reader why the control is inert. Null shows '
          'nothing at all — the field is fixed once by the caller, since '
          'the wrapped tree never changes shape when disabled toggles.',
      specimen: const _ReasonTooltipSpecimen(),
      code: _reasonTooltipCode,
      label: 'Reason tooltip specimen view',
      minHeight: 160,
    ),
    ShowcaseSection(
      id: 'tap-while-disabled',
      title: 'Tap while disabled',
      description:
          'onDisabledTap fires when a pointer taps the control while '
          'disabled; the child underneath never sees the tap. Useful for a '
          'surface that wants to react to the attempt itself — logging it, '
          'nudging a related field — rather than staying silent.',
      specimen: const _TapWhileDisabledSpecimen(),
      code: _tapWhileDisabledCode,
      label: 'Tap while disabled specimen view',
      minHeight: 160,
    ),
    DisclosureSection(
      id: 'pointer-block',
      title: 'Pointer block',
      child: const _PointerBlockContent(),
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter Disabled declares, read off '
          'lib/src/components/ui/disabled.dart.',
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
            value: disabledDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/disabled_state_test.dart',
            description:
                'Guards that every disableable component in this package '
                'goes through Disabled and takes a disabledReason.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/disabled_test.dart',
            description:
                'Covers this page: the article mounts, the full API '
                'table, a live tap on the "Tap while disabled" specimen, '
                'a live hover on the Preview specimen, and both themes.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/disabled/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class DisabledDocPage extends StatelessWidget {
  const DisabledDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: disabledDoc.route,
    intro: DocsPageIntro(
      title: disabledDoc.title,
      description: disabledDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Disabled'),
    ],
    toc: disabledDocSpec.toc,
    previous: null,
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('disabled-doc-article'),
      child: ComponentDocPage(spec: disabledDocSpec, header: false),
    ),
  );
}

/* ── Specimens ───────────────────────────────────────────────────────────── */

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: space(2)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Button(
            key: const ValueKey<String>('disabled-example:disabled-button'),
            onPressed: null,
            disabledReason: 'Connect a wallet to continue',
            child: const Text('Connect wallet'),
          ),
          SizedBox(width: space(4)),
          Button(
            key: const ValueKey<String>('disabled-example:enabled-button'),
            onPressed: () {},
            child: const Text('Connect wallet'),
          ),
        ],
      ),
    ),
  );
}

const String _previewCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    '// Disabled: dims, ignores pointer input, shows the reason on hover.\n'
    'Button(\n'
    '  onPressed: null,\n'
    "  disabledReason: 'Connect a wallet to continue',\n"
    "  child: const Text('Connect wallet'),\n"
    ')\n\n'
    '// Enabled, for comparison.\n'
    'Button(\n'
    '  onPressed: () {},\n'
    "  child: const Text('Connect wallet'),\n"
    ')';

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

Disabled(
  disabled: !canSubmit,
  reason: 'Fill in every required field first',
  child: const SubmitRow(),
)''';

class _ReasonTooltipSpecimen extends StatelessWidget {
  const _ReasonTooltipSpecimen();

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 280,
    child: Field(
      label: 'Email',
      child: Input(
        key: const ValueKey<String>('disabled-example:reason-tooltip-input'),
        enabled: false,
        disabledReason: 'Locked after verification',
        placeholder: 'you@example.com',
      ),
    ),
  );
}

const String _reasonTooltipCode = '''
Field(
  label: 'Email',
  child: Input(
    enabled: false,
    disabledReason: 'Locked after verification',
    placeholder: 'you@example.com',
  ),
)''';

class _TapWhileDisabledSpecimen extends StatefulWidget {
  const _TapWhileDisabledSpecimen();

  @override
  State<_TapWhileDisabledSpecimen> createState() =>
      _TapWhileDisabledSpecimenState();
}

class _TapWhileDisabledSpecimenState extends State<_TapWhileDisabledSpecimen> {
  int _taps = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Disabled(
          key: const ValueKey<String>('disabled-example:tap-while-disabled'),
          disabled: true,
          reason: 'Nothing to save yet',
          onDisabledTap: () => setState(() => _taps++),
          child: Button(onPressed: () {}, child: const Text('Save')),
        ),
        SizedBox(height: space(2)),
        StyledText(
          'Disabled taps: $_taps',
          TextStyles.small,
          color: theme.mutedForeground,
        ),
      ],
    );
  }
}

const String _tapWhileDisabledCode = '''
int taps = 0;

Disabled(
  disabled: true,
  reason: 'Nothing to save yet',
  onDisabledTap: () => setState(() => taps++),
  child: Button(onPressed: () {}, child: const Text('Save')),
)''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _PointerBlockContent extends StatelessWidget {
  const _PointerBlockContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'blockPointer defaults to true: while disabled, the child sits '
            'behind an IgnorePointer and never sees a tap, drag or hover.',
        'A menu row gates its own input instead — it needs the hover and '
            'focus states a disabled row still shows, just no activation — '
            'so it passes blockPointer: false and relies on its own enabled '
            'check to refuse the action.',
      ]);
}

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) =>
      const DocsApiTable(title: 'Disabled', facts: _apiFacts);
}

const List<DocsApiFact> _apiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'disabled',
    type: 'bool',
    description:
        'Required. Whether the child is faded, pointer-blocked and '
        'cursor-swapped. The tree shape never changes when this toggles, so '
        'the fade animates and the child keeps its own State.',
  ),
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description: 'Required. The control being disabled.',
  ),
  DocsApiFact(
    name: 'reason',
    type: 'String?',
    description:
        'Optional. Defaults to null. Shown as a tooltip on hover '
        '(pointer) or tap (touch) while disabled; null shows nothing. '
        'Fixed once by the caller, since whether the outer Tooltip exists '
        'at all cannot change after the first build.',
  ),
  DocsApiFact(
    name: 'onDisabledTap',
    type: 'VoidCallback?',
    description:
        'Optional. Defaults to null. Called when a pointer taps the '
        'control while disabled; fires only while disabled, and the child '
        'never sees the tap.',
  ),
  DocsApiFact(
    name: 'blockPointer',
    type: 'bool',
    description:
        'Optional. Defaults to true. Whether the child stops receiving '
        'pointer input while disabled. Menu rows that gate input '
        'themselves pass false.',
  ),
  DocsApiFact(
    name: 'duration',
    type: 'Duration?',
    description:
        'Optional. Defaults to null, which resolves to '
        'MotionDurations.fast. How long the fade takes. Button passes its '
        'own measured spring duration instead.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Enabled',
    treatment:
        'TweenAnimationBuilder settles at opacity 1; pointer input '
        'passes straight through to child.',
    userSignal:
        'The control looks and behaves exactly as if Disabled were '
        'not there.',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment:
        'The tween animates to SurfaceOpacity.disabled over '
        'duration (or MotionDurations.fast) eased by '
        'MotionCurves.emphasized; blockPointer wraps child in an '
        'IgnorePointer; the cursor swaps to SystemMouseCursors.basic.',
    userSignal:
        'The control fades to a dimmed, inert look and the cursor '
        'stops hinting that it is clickable.',
  ),
  DocsStateFact(
    state: 'Disabled with reason',
    treatment:
        'A Tooltip wraps the faded result, hidden while enabled and '
        'shown while disabled — on hover for a mouse, on tap for touch.',
    userSignal:
        'Hovering or tapping the dimmed control surfaces why it is '
        'inert.',
  ),
  DocsStateFact(
    state: 'Tapped while disabled',
    treatment:
        'The GestureDetector\'s onTap is wired to onDisabledTap only '
        'while disabled; the wrapped child never receives the gesture.',
    userSignal:
        'A tap on the dimmed control fires the caller\'s hook '
        'instead of doing nothing.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Disabled renders no Semantics node of its own: the reason is a '
            'visual tooltip, not an accessible label. The wrapped '
            'control\'s own Semantics(enabled: false) carries the disabled '
            'state to assistive technology.',
        'A caller that wants the reason announced as well should still '
            'route it through the control\'s own disabledReason parameter '
            '(Button, Input and friends already do), not through Disabled '
            'directly.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Disabled declares no Focus and no key handling of its own: a '
            'disabled control\'s own focus behaviour — refusing focus, '
            'skipping Tab order — comes from the wrapped control, exactly '
            'as its enabled behaviour does.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No breakpoint branching anywhere in disabled.dart: BuildContext '
            'width is never read.',
        'Disabled imposes no size of its own — the fade and pointer block '
            'paint at whatever size child\'s own constraints give it.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ThemeScope.of(context), <String>[
        'File: lib/src/components/ui/disabled.dart: one file, no '
            'companions.',
        'Flutter imports: package:flutter/foundation.dart (clampDouble) '
            'and package:flutter/widgets.dart.',
        'Foundation imports: foundation/motion.dart (effectiveMotionDuration, '
            'MotionCurves), foundation/surfaces.dart (SurfaceOpacity) and '
            'theme_scope.dart.',
        'Component import: tooltip.dart, for the reason bubble.',
        'registryDependencies, resolved automatically by `elattar add '
            'disabled`: tooltip and source-foundation — copied verbatim '
            'from registry/components/disabled.json.',
        'Real use in this corpus: sixteen components used to hand-roll '
            'this fade-plus-block themselves before Disabled existed; every '
            'one of them now composes it.',
      ]),
      SizedBox(height: space(2)),
      DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Tooltip', route: '/components/tooltip'),
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
      _bullets(ThemeScope.of(context), <String>[
        'Disabled reads one token, SurfaceOpacity.disabled, for the fade '
            'target; it paints no color of its own, so every hue a reader '
            'sees on this page\'s specimens comes from the wrapped control.',
        'duration resolves through effectiveMotionDuration on every build, so '
            'MediaQuery.disableAnimations collapses it to zero: a toggle '
            'under reduced motion snaps straight to its end opacity instead '
            'of fading.',
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
