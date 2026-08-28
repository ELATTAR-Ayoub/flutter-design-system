/// Public documentation page for the `alert` component.
///
/// **Re-housed onto the kit.** This page used to hand-compose [Section]
/// panels against a shadcn-parity frame; it now declares a
/// [ComponentDocSpec] (`example/lib/docs/component_doc_page.dart`) and hands
/// it to [ComponentDocPage], the same shape `button`, `field` and `popover`
/// established. Every specimen widget and every code string below is the
/// same one the hand-composed page carried; new in this pass: a live
/// specimen for Stacked alerts (a code-only panel before), and a dedicated
/// Keyboard disclosure.
///
/// **Section shape**, matching the house order: Preview (the five-variant
/// grid, promoted from an unheaded live demo to a real rail entry),
/// Installation, Usage (trimmed to the smallest correct example — the
/// second "with an icon, a variant, and an action" panel the old Usage
/// section carried is the same code the Action section already shows live,
/// so it is not repeated), Composition (code-only: the anatomy comment
/// tree, nothing new to render beyond what Preview already shows),
/// Basic / Destructive / Action / Success / Warning / Info / Stacked
/// alerts / RTL, then the eight disclosures.
///
/// **Corrected, not carried over.** The old page's Installation and
/// Dependencies sections both stated "no CLI item exists for alert yet" —
/// false: `registry/components/alert.json` exists and resolves
/// `feedback-surface` and `source-foundation` automatically, exactly as
/// `alert/meta.dart`'s own [alertDoc.dependencies] already listed. Both
/// sections here say so honestly instead.
///
/// **Skipped, honestly.** `Custom colors` has no [Alert] equivalent: its
/// only colour control point is `variant`, one of five predetermined
/// ink/bloom pairs, not an arbitrary override. Recorded as a note inside API
/// Reference rather than a whole top-level section for one skip.
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

final ComponentDocSpec alertDocSpec = ComponentDocSpec(
  name: 'alert',
  title: alertDoc.title,
  description: alertDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'Every AlertVariant value, in the reference\'s own declaration '
          'order. Each gets its own dedicated specimen further down the '
          'page.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: space(160),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'alert has a real registry manifest, `elattar add alert` installs '
          'lib/src/components/alert.dart and resolves feedback-surface and '
          'source-foundation automatically. The Manual tab is for a '
          'project not using the CLI.',
      command: alertDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/alert.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/alert.dart's generated "
              '@ui/alert.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated alert.dart payload here when using '
              'manual mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so Alert and AlertVariant are '
              'reachable the same way the CLI path already makes them.',
          code: "export 'alert.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct construction: title is the only required '
          'field. Every example below only adds named arguments on top of '
          'this.',
      code: _smallestUsageCode,
    ),
    SnippetSection(
      id: 'composition',
      title: 'Composition',
      description:
          'Alert folds Icon, AlertTitle, AlertDescription, and '
          'AlertAction into four constructor slots on one widget, rather '
          'than four composable subcomponents. Nothing new to render here '
          'beyond what Preview already shows live, so this is the anatomy '
          'as Dart, not a second stage.',
      code: _compositionAnatomyCode,
    ),
    ShowcaseSection(
      id: 'basic',
      title: 'Basic',
      description:
          'AlertVariant.normal, the constructor\'s own default: an icon, '
          'a title, and a description.',
      specimen: _BasicSpecimen(),
      code: _basicCode,
      label: 'Basic specimen view',
    ),
    ShowcaseSection(
      id: 'destructive',
      title: 'Destructive',
      description:
          'AlertVariant.destructive on its own: compare with Action '
          'below, which adds an action slot on top of the same variant.',
      specimen: _DestructiveSpecimen(),
      code: _destructiveCode,
      label: 'Destructive specimen view',
    ),
    ShowcaseSection(
      id: 'action',
      title: 'Action',
      description:
          'The action slot sits 8px from the top and right of the border '
          'box, and it always reserves an 80px-wide right lane once '
          'action is non-null -- unconditionally, whether or not a button '
          'of that size would actually have collided with the text '
          '(supervisor ruling F10).',
      specimen: _ActionSpecimen(),
      code: _actionCode,
      label: 'Action specimen view',
    ),
    ShowcaseSection(
      id: 'success',
      title: 'Success',
      description:
          'AlertVariant.success, for a confirmation that already '
          'happened. No counterpart example on the reference page, which '
          'only demos default and destructive by name.',
      specimen: _SuccessSpecimen(),
      code: _successCode,
      label: 'Success specimen view',
    ),
    ShowcaseSection(
      id: 'warning',
      title: 'Warning',
      description:
          'AlertVariant.warning, for a condition that needs attention '
          'but has not failed outright.',
      specimen: _WarningSpecimen(),
      code: _warningCode,
      label: 'Warning specimen view',
    ),
    ShowcaseSection(
      id: 'info',
      title: 'Info',
      description: 'AlertVariant.info, for a low-stakes announcement.',
      specimen: _InfoSpecimen(),
      code: _infoCode,
      label: 'Info specimen view',
    ),
    ShowcaseSection(
      id: 'stacked-alerts',
      title: 'Stacked alerts',
      description:
          'Stacking more than one alert reads as a list of conditions, '
          'not a traffic light, because every variant shares the same '
          'card fill -- only the icon and the bloom move.',
      specimen: _StackedSpecimen(),
      code: _stackedCode,
      label: 'Stacked alerts specimen view',
      minHeight: space(120),
    ),
    ShowcaseSection(
      id: 'rtl',
      title: 'RTL',
      description:
          'Alert reads Directionality.of(context) the way any Row does, '
          'so the icon and text column swap sides under RTL. DOCUMENTED '
          'DRIFT: the padding (EdgeInsets.fromLTRB) and the action slot\'s '
          'Positioned(top, right) are both physical, not directional -- '
          'unlike the reference\'s logical pr-20 / top-2 right-2 CSS, '
          'neither one mirrors to the left edge under RTL.',
      specimen: _RtlSpecimen(),
      code: _rtlCode,
      label: 'RTL specimen view',
      minHeight: space(120),
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every Alert constructor parameter and static member, and '
          'every AlertVariant value, read directly from '
          'lib/src/components/alert.dart.',
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Alert is a synchronous, presentational primitive -- it holds '
          'no internal state and listens to no gestures. Rows that do not '
          'apply are marked N/A with the reason, rather than inventing '
          'asynchronous behavior for a synchronous widget.',
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
      description:
          'Alert wires no key handling of its own anywhere in '
          'alert.dart: every fact here is about what does NOT happen on '
          'the alert body itself.',
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
            value: alertDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'none yet',
            description:
                'No test in the root package exercises Alert directly '
                'today; this documentation page\'s own specimen-mount '
                'test is the only coverage that currently exists.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/alert_test.dart',
            description:
                'Covers this page: the article mounts, every '
                'AlertVariant this page claims to show, the full API '
                'table, and both themes at two viewport widths.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/alert/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class AlertDocPage extends StatelessWidget {
  const AlertDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: alertDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENT · ALERT',
      title: alertDoc.title,
      description: alertDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Alert'),
    ],
    toc: alertDocSpec.toc,
    previous: const DocsPageLink(
      title: 'Accordion',
      route: '/components/accordion',
    ),
    next: const DocsPageLink(title: 'Avatar', route: '/components/avatar'),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('alert-doc-article'),
      child: ComponentDocPage(spec: alertDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

/// Every [AlertVariant] value, in the reference's own declaration order --
/// the same specimen the "Manual" tab's [_previewCode] reproduces.
class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const KeyedSubtree(
        key: ValueKey<String>('alert-preview:normal'),
        child: Alert(
          icon: Icon(IconGlyph.bell),
          title: 'Heads up',
          description: 'You can revert this later from Settings → Preferences.',
        ),
      ),
      SizedBox(height: space(4)),
      KeyedSubtree(
        key: const ValueKey<String>('alert-preview:destructive'),
        child: Alert(
          variant: AlertVariant.destructive,
          icon: const Icon(IconGlyph.circleX),
          title: 'Payment failed',
          description: 'We could not process your card ending in 4242.',
          action: Button(
            variant: ButtonVariant.secondary,
            size: ButtonSize.sm,
            onPressed: () {},
            child: const Text('Retry'),
          ),
        ),
      ),
      SizedBox(height: space(4)),
      const KeyedSubtree(
        key: ValueKey<String>('alert-preview:success'),
        child: Alert(
          variant: AlertVariant.success,
          icon: Icon(IconGlyph.circleCheck),
          title: 'Changes saved',
          description: 'Your profile was updated successfully.',
        ),
      ),
      SizedBox(height: space(4)),
      const KeyedSubtree(
        key: ValueKey<String>('alert-preview:warning'),
        child: Alert(
          variant: AlertVariant.warning,
          icon: Icon(IconGlyph.alertTriangle),
          title: 'Withdrawal under review',
          description:
              'Large withdrawals are held for a security review before '
              'they clear.',
        ),
      ),
      SizedBox(height: space(4)),
      const KeyedSubtree(
        key: ValueKey<String>('alert-preview:info'),
        child: Alert(
          variant: AlertVariant.info,
          icon: Icon(IconGlyph.info),
          title: 'New feature available',
          description: 'The command palette is now available via Cmd+K.',
        ),
      ),
    ],
  );
}

class _BasicSpecimen extends StatelessWidget {
  const _BasicSpecimen();

  @override
  Widget build(BuildContext context) => const KeyedSubtree(
    key: ValueKey<String>('alert-example:basic'),
    child: Alert(
      icon: Icon(IconGlyph.bell),
      title: 'Heads up',
      description: 'You can revert this later from Settings → Preferences.',
    ),
  );
}

class _DestructiveSpecimen extends StatelessWidget {
  const _DestructiveSpecimen();

  @override
  Widget build(BuildContext context) => const KeyedSubtree(
    key: ValueKey<String>('alert-example:destructive'),
    child: Alert(
      variant: AlertVariant.destructive,
      icon: Icon(IconGlyph.circleX),
      title: 'Payment failed',
      description: 'We could not process your card ending in 4242.',
    ),
  );
}

class _ActionSpecimen extends StatelessWidget {
  const _ActionSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('alert-example:action'),
    child: Alert(
      variant: AlertVariant.destructive,
      icon: const Icon(IconGlyph.circleX),
      title: 'Payment failed',
      description: 'We could not process your card ending in 4242.',
      action: Button(
        variant: ButtonVariant.secondary,
        size: ButtonSize.sm,
        onPressed: () {},
        child: const Text('Retry'),
      ),
    ),
  );
}

class _SuccessSpecimen extends StatelessWidget {
  const _SuccessSpecimen();

  @override
  Widget build(BuildContext context) => const KeyedSubtree(
    key: ValueKey<String>('alert-example:success'),
    child: Alert(
      variant: AlertVariant.success,
      icon: Icon(IconGlyph.circleCheck),
      title: 'Changes saved',
      description: 'Your profile was updated successfully.',
    ),
  );
}

class _WarningSpecimen extends StatelessWidget {
  const _WarningSpecimen();

  @override
  Widget build(BuildContext context) => const KeyedSubtree(
    key: ValueKey<String>('alert-example:warning'),
    child: Alert(
      variant: AlertVariant.warning,
      icon: Icon(IconGlyph.alertTriangle),
      title: 'Withdrawal under review',
      description:
          'Large withdrawals are held for a security review before they '
          'clear.',
    ),
  );
}

class _InfoSpecimen extends StatelessWidget {
  const _InfoSpecimen();

  @override
  Widget build(BuildContext context) => const KeyedSubtree(
    key: ValueKey<String>('alert-example:info'),
    child: Alert(
      variant: AlertVariant.info,
      icon: Icon(IconGlyph.info),
      title: 'New feature available',
      description: 'The command palette is now available via Cmd+K.',
    ),
  );
}

/// New: a live rendering of the code-only "Stacked alerts" panel the old
/// page carried -- the same two alerts [_stackedCode] shows as text.
class _StackedSpecimen extends StatelessWidget {
  const _StackedSpecimen();

  @override
  Widget build(BuildContext context) => Column(
    key: const ValueKey<String>('alert-example:stacked'),
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const Alert(
        variant: AlertVariant.warning,
        icon: Icon(IconGlyph.alertTriangle),
        title: 'Withdrawal under review',
        description:
            'Large withdrawals are held for a security review before '
            'they clear.',
      ),
      SizedBox(height: space(4)),
      const Alert(
        variant: AlertVariant.info,
        icon: Icon(IconGlyph.info),
        title: 'New feature available',
        description: 'The command palette is now available via Cmd+K.',
      ),
    ],
  );
}

/// The RTL section's own specimen: the same two alerts [_PreviewSpecimen]
/// already carries, wrapped in a right-to-left [Directionality] so the row
/// flip is real and live, not merely described.
class _RtlSpecimen extends StatelessWidget {
  const _RtlSpecimen();

  @override
  Widget build(BuildContext context) => Directionality(
    key: const ValueKey<String>('alert-example:rtl'),
    textDirection: TextDirection.rtl,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Alert(
          icon: Icon(IconGlyph.bell),
          title: 'تنبيه',
          description: 'يمكنك التراجع عن هذا لاحقًا من الإعدادات.',
        ),
        SizedBox(height: space(4)),
        Alert(
          variant: AlertVariant.destructive,
          icon: const Icon(IconGlyph.circleX),
          title: 'فشل الدفع',
          description: 'تعذر معالجة بطاقتك المنتهية بـ 4242.',
          action: Button(
            variant: ButtonVariant.secondary,
            size: ButtonSize.sm,
            onPressed: () {},
            child: const Text('إعادة المحاولة'),
          ),
        ),
      ],
    ),
  );
}

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsApiTable(
        title: 'Alert',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'title',
            type: 'String',
            description:
                'Required. The AlertTitle text, column 2, font-medium.',
          ),
          DocsApiFact(
            name: 'description',
            type: 'String?',
            description:
                'Optional, defaults to null. When null, the gap-1 row and '
                'the muted description block do not render at all.',
          ),
          DocsApiFact(
            name: 'icon',
            type: 'Widget?',
            description:
                'Optional, defaults to null. The leading size-4 glyph, '
                'recolored by variant through the surrounding '
                'DefaultTextStyle. Alert does not choose an icon for a '
                'variant -- the caller supplies one, or none.',
          ),
          DocsApiFact(
            name: 'action',
            type: 'Widget?',
            description:
                'Optional, defaults to null. Positioned 8px from the top '
                'and right of the border box. Its presence also switches '
                "the base's right padding from 16px to a fixed 80px lane, "
                'unconditionally.',
          ),
          DocsApiFact(
            name: 'variant',
            type: 'AlertVariant',
            description:
                'Optional, defaults to AlertVariant.normal. Selects the '
                'icon ink color and the --bloom-1/--bloom-2 pair; fill, '
                'border, radius, and padding never change.',
          ),
          DocsApiFact(
            name: 'Alert.actionInset (static)',
            type: 'double',
            description:
                'space(2) -- the 8px offset the action slot sits from the '
                'border box on both axes.',
          ),
          DocsApiFact(
            name: 'Alert.actionLane (static)',
            type: 'double',
            description:
                'space(20) -- the fixed 80px right-padding lane substituted '
                'for the base 16px whenever action is non-null.',
          ),
        ],
      ),
      SizedBox(height: space(6)),
      const DocsApiTable(
        title: 'AlertVariant',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'normal',
            type: 'AlertVariant',
            description:
                'cva key "default" (the label getter renames it -- '
                'default is a Dart keyword). Ink: theme.mutedForeground. '
                'Bloom: --color-action-bright / --color-action.',
          ),
          DocsApiFact(
            name: 'destructive',
            type: 'AlertVariant',
            description:
                'Ink: theme.destructiveText. Bloom: theme.destructive / '
                '--color-action.',
          ),
          DocsApiFact(
            name: 'success',
            type: 'AlertVariant',
            description:
                'Ink: theme.successText. Bloom: --color-success / '
                '--color-value.',
          ),
          DocsApiFact(
            name: 'warning',
            type: 'AlertVariant',
            description:
                'Ink: theme.warningText. Bloom: --color-warning / '
                '--color-action.',
          ),
          DocsApiFact(
            name: 'info',
            type: 'AlertVariant',
            description:
                'Ink: theme.infoText. Bloom: --color-info / --color-action.',
          ),
        ],
      ),
      SizedBox(height: space(4)),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
        child: Builder(
          builder: (BuildContext context) {
            final ThemeTokens theme = ThemeScope.of(context);
            return StyledText(
              'Custom colors -- SKIPPED. The reference\'s Custom Colors '
              'example overrides an alert\'s classes directly to swap in '
              'an ad hoc palette. Alert has no equivalent hook: its only '
              'color control point is variant, which selects one of five '
              'predetermined ink/bloom pairs from ThemeTokens rather than '
              'accepting an arbitrary Color. Faking a freeform override '
              'here would document a capability this widget does not '
              'have, so this section is skipped rather than approximated '
              'with another variant swatch.',
              TextStyles.small,
              color: theme.mutedForeground,
            );
          },
        ),
      ),
    ],
  );
}

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest',
    treatment:
        'Bordered card, one shared fill across every variant; the bloom '
        'runs its idle drift.',
    userSignal: 'Icon ink and bloom color name the variant.',
  ),
  DocsStateFact(
    state: 'Hover / Focus-visible / Pressed / Selected',
    treatment:
        'N/A -- Alert has no MouseRegion, FocusNode, or GestureDetector '
        'of its own.',
    userSignal:
        'A widget mounted in the action slot carries its own hover, '
        'focus, and press states independently; Alert does not style '
        'them.',
  ),
  DocsStateFact(
    state: 'Loading',
    treatment:
        'N/A -- Alert is synchronous and presentational; it has no '
        'loading affordance to invent.',
    userSignal: 'Not applicable.',
  ),
  DocsStateFact(
    state: 'Empty',
    treatment:
        'N/A -- title is a required constructor parameter, so there is '
        'no valid contentless alert to render.',
    userSignal: 'Not applicable.',
  ),
  DocsStateFact(
    state: 'Error / Success / Warning / Info',
    treatment:
        'A compile-time variant choice (AlertVariant), not a runtime '
        'transition -- see Basic, Destructive, Success, Warning, and Info '
        'above.',
    userSignal: 'The caller re-renders with a different variant value.',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment:
        'N/A on the alert body -- there is no interactive affordance to '
        'disable. A widget in the action slot can disable itself (for '
        'example onPressed: null) independently.',
    userSignal: 'Not applicable.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'FeedbackSurface settles its drift, hover swell, and starfield to '
        'their resting frame under MediaQuery.disableAnimations.',
    userSignal: 'Fill, border, ink, and text are unaffected.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Semantic role: Semantics(container: true, liveRegion: true) '
            'wraps the whole surface -- the same assertive-live-region '
            'announcement role="alert" gives implicitly on the reference, '
            'with no separate aria-live or aria-atomic attribute needed.',
        'Required labels: title is the only required accessible content; '
            'it renders as real text, so it is read by default without an '
            'explicit label override.',
        'Focus behavior: Alert never requests focus on mount, unlike a '
            'dialog -- it does not interrupt whatever the user was doing.',
        'Touch target: N/A for the alert body itself. The action slot '
            'inherits whatever touch target its own widget defines -- '
            'Alert does not resize it.',
        'Non-color signals: every specimen on this page pairs its '
            'variant\'s ink color with a distinct icon glyph and with '
            'title/description text, so meaning never rides on hue alone '
            '-- but that is the caller\'s discipline, not something '
            'Alert enforces: icon is an arbitrary optional Widget?, not '
            'derived from variant.',
        'Error wiring: N/A -- Alert has no form-field validation '
            'hookup; that is a field.dart concern. An alert is how a page '
            'states a condition, not how a field reports one.',
        'Screen-reader announcements: liveRegion: true asks the platform '
            'accessibility service to announce the alert\'s text when it '
            'first mounts.',
        'Known platform differences: live-region announcement timing is '
            'the platform accessibility service\'s call (TalkBack, '
            'VoiceOver, web ARIA), not something this widget schedules -- '
            'there is no cross-platform timing guarantee to promise here.',
      ]);
}

/// New: split out of the old combined Accessibility section, matching
/// `button`, `field` and `popover`'s own dedicated Keyboard disclosure.
/// Read directly off `alert.dart`, which wires no `Focus`, `FocusNode`, or
/// `onKeyEvent` anywhere on the alert body itself.
class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No key handling of its own: Alert wires no Focus or '
            'onKeyEvent anywhere. The alert body is never in the tab '
            'order and answers no key press.',
        'action keeps whatever tab order and key bindings its own widget '
            'already had: Alert adds no key handling to it. A Button '
            'passed there (every shipped consumer) carries its own Tab '
            'stop and its own Enter/Space activation, unaffected by the '
            'alert around it.',
        'No FocusTraversalPolicy of its own: Alert declares none. Tab '
            'and Shift+Tab walk whatever order the surrounding page '
            'already declares; the only thing ever reachable inside an '
            'alert is action, when one is supplied.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Alert has no breakpoint logic of its own -- its width is '
            'whatever its parent gives it, and title/description text '
            'simply wraps to more lines as that width shrinks.',
        'The one width-sensitive detail is Alert.actionLane: when '
            'action is present, the right padding is a fixed 80px lane, '
            'applied unconditionally rather than sized to the button, so '
            'the same alert can wrap its description column differently '
            'at different container widths purely because the lane '
            'always reserves the same space.',
        'Platform parity: pure flutter/widgets.dart and dart:ui -- no '
            'platform channel, so every Flutter target renders it '
            'identically.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DocsInstallFacts(
        facts: <DocsInstallFact>[
          const DocsInstallFact(
            label: 'Registry item',
            value: 'alert',
            description:
                'registry/components/alert.json exists and is '
                'installable through the CLI today.',
          ),
          const DocsInstallFact(
            label: 'Destination',
            value: 'lib/components/ui/alert.dart',
            description:
                'The same lib/components/ui/ target every component '
                'installs to.',
          ),
          const DocsInstallFact(
            label: 'Files',
            value: 'lib/src/components/alert.dart',
            description: 'One file; Alert and AlertVariant both live here.',
          ),
          const DocsInstallFact(
            label: 'Package imports',
            value:
                'effects/feedback_surface.dart, foundation/spacing.dart, '
                'foundation/theme.dart, foundation/typography.dart, '
                'theme_scope.dart',
            description:
                'FeedbackSurface paints the fill and its idle animation; '
                'the rest are the shared spacing, theme, typography, and '
                'theme-mode primitives every component reads.',
          ),
          DocsInstallFact(
            label: 'Dependencies',
            value: alertDoc.dependencies.join(', '),
            description:
                "registry/components/alert.json's own "
                'registryDependencies, resolved automatically by '
                '`elattar add alert`.',
          ),
          const DocsInstallFact(
            label: 'Assets, fonts, shaders',
            value: 'none',
            description:
                'The bloom paints with dart:ui gradients (Paint.shader '
                'from a RadialGradient), not a compiled fragment shader '
                '-- no asset declaration is needed in pubspec.yaml.',
          ),
          const DocsInstallFact(
            label: 'Platforms',
            value: 'Android, iOS, Web, macOS, Windows, Linux',
            description:
                'Pure flutter/widgets.dart and dart:ui -- no platform '
                'channel, so every Flutter target renders it identically.',
          ),
        ],
      ),
      SizedBox(height: space(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Alert Dialog', route: '/components/alert-dialog'),
          DocsLink(
            label: 'Bloom Cosmic',
            route: '/components/feedback_surface',
          ),
          DocsLink(label: 'Toaster', route: '/components/toaster'),
        ],
      ),
      SizedBox(height: space(4)),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
        child: Builder(
          builder: (BuildContext context) {
            final ThemeTokens theme = ThemeScope.of(context);
            return StyledText(
              'Reach for an alert dialog instead when the situation blocks '
              'the page and demands one answer before the user can '
              'continue -- a confirmation, an irreversible action. It '
              'shares DialogContent\'s own panel and its scrim; Alert '
              'has neither. Reach for a toaster instead when the message '
              'is transient -- it announces once near a screen corner and '
              'clears itself on a timer. Alert never times out and '
              'never floats; it lays out like any other block in the '
              'page\'s own flow.',
              TextStyles.small,
              color: theme.mutedForeground,
            );
          },
        ),
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Every variant renders the same border, the same --card fill, '
            'and the same text color; a variant spends exactly one token '
            'pair -- the icon ink (theme.mutedForeground, destructiveText, '
            'successText, warningText, or infoText) and the bloom\'s two '
            'stops (--bloom-1 / --bloom-2) -- both read from ThemeTokens '
            'rather than hardcoded.',
        'That is a deliberate reversal of tinting the whole card: five '
            'differently-tinted cards stacked on a page read as a '
            'traffic light rather than as one component, and body text '
            'is the least legible place to spend a hue.',
        'Flip ThemeController between light and dark and every '
            'variant\'s ink and bloom follow the active theme '
            'automatically -- nothing on this page opts out.',
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

const String _previewCode = '''
Alert(
  icon: const Icon(IconGlyph.bell),
  title: 'Heads up',
  description: 'You can revert this later from Settings → Preferences.',
)

Alert(
  variant: AlertVariant.destructive,
  icon: const Icon(IconGlyph.circleX),
  title: 'Payment failed',
  description: 'We could not process your card ending in 4242.',
  action: Button(
    variant: ButtonVariant.secondary,
    size: ButtonSize.sm,
    onPressed: () {},
    child: const Text('Retry'),
  ),
)

Alert(
  variant: AlertVariant.success,
  icon: const Icon(IconGlyph.circleCheck),
  title: 'Changes saved',
  description: 'Your profile was updated successfully.',
)

Alert(
  variant: AlertVariant.warning,
  icon: const Icon(IconGlyph.alertTriangle),
  title: 'Withdrawal under review',
  description: 'Large withdrawals are held for a security review before they clear.',
)

Alert(
  variant: AlertVariant.info,
  icon: const Icon(IconGlyph.info),
  title: 'New feature available',
  description: 'The command palette is now available via Cmd+K.',
)
''';

const String _smallestUsageCode = '''Alert(
  title: 'Heads up',
)''';

const String _compositionAnatomyCode = '''Alert(
  icon: ...,          // optional leading glyph, size-4, recolored by variant
  title: '...',       // required -- the only field with no default
  description: '...', // optional, the row omits itself entirely when null
  action: ...,        // optional trailing slot, pinned top-right
  variant: AlertVariant.normal, // selects icon ink + the two bloom stops only
)''';

const String _basicCode = '''Alert(
  icon: const Icon(IconGlyph.bell),
  title: 'Heads up',
  description: 'You can revert this later from Settings → Preferences.',
)''';

const String _destructiveCode = '''Alert(
  variant: AlertVariant.destructive,
  icon: const Icon(IconGlyph.circleX),
  title: 'Payment failed',
  description: 'We could not process your card ending in 4242.',
)''';

const String _actionCode = '''Alert(
  variant: AlertVariant.destructive,
  icon: const Icon(IconGlyph.circleX),
  title: 'Payment failed',
  description: 'We could not process your card ending in 4242.',
  action: Button(
    variant: ButtonVariant.secondary,
    size: ButtonSize.sm,
    onPressed: () {},
    child: const Text('Retry'),
  ),
)''';

const String _successCode = '''Alert(
  variant: AlertVariant.success,
  icon: const Icon(IconGlyph.circleCheck),
  title: 'Changes saved',
  description: 'Your profile was updated successfully.',
)''';

const String _warningCode = '''Alert(
  variant: AlertVariant.warning,
  icon: const Icon(IconGlyph.alertTriangle),
  title: 'Withdrawal under review',
  description: 'Large withdrawals are held for a security review before they clear.',
)''';

const String _infoCode = '''Alert(
  variant: AlertVariant.info,
  icon: const Icon(IconGlyph.info),
  title: 'New feature available',
  description: 'The command palette is now available via Cmd+K.',
)''';

const String _stackedCode = '''Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: <Widget>[
    Alert(
      variant: AlertVariant.warning,
      icon: const Icon(IconGlyph.alertTriangle),
      title: 'Withdrawal under review',
      description: 'Large withdrawals are held for a security review before they clear.',
    ),
    SizedBox(height: space(4)),
    Alert(
      variant: AlertVariant.info,
      icon: const Icon(IconGlyph.info),
      title: 'New feature available',
      description: 'The command palette is now available via Cmd+K.',
    ),
  ],
)''';

const String _rtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: Alert(
    icon: const Icon(IconGlyph.bell),
    title: 'تنبيه',
    description: 'يمكنك التراجع عن هذا لاحقًا من الإعدادات.',
  ),
)''';
