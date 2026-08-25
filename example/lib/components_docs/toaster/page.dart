/// Public documentation page for the `toaster` component.
///
/// **Re-housed onto the kit.** This page used to hand-compose [ElSection]
/// panels; it now declares a [ComponentDocSpec]
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// [ComponentDocPage], the same shape `button`, `field`, `popover` and
/// `alert` established. Every specimen widget and every code string below is
/// the same one the hand-composed page carried, with two additions: Types
/// now mounts a real live specimen (a dedicated [ElToastController] firing
/// all six [ElToastType] values, including `loading` and `normal`, neither
/// of which the Preview specimen's own five buttons ever exercised), and a
/// dedicated Keyboard disclosure, split out of the old combined
/// Accessibility section.
///
/// **Section shape**, matching the house order: Preview, Installation,
/// Usage (trimmed to the smallest correct example), Types (now live), then
/// Action and Promise, both kept as code-only [SnippetSection]s — Preview's
/// own "Show error + action" and "Show promise" controls already fire the
/// exact same calls live, so a second live demo per section would repeat
/// the same overlay rather than show anything new; each says so in its own
/// description — then the eight disclosures. "When to use it", the old
/// page's own decision-guidance section naming ElAlert and ElAlertDialog as
/// this component's nearest neighbours, is folded into the Dependencies
/// disclosure as prose plus a real [DocsLinkRow], the same shape `alert`'s
/// own page folds its Purpose prose into.
///
/// **Corrected, not carried over.** The old page's Installation and
/// Dependencies sections both stated "no CLI item exists for toaster yet"
/// — false: `registry/components/toaster.json` exists and resolves
/// `bloom-cosmic`, `icon`, `machine-surface`, `safe-area` and
/// `source-foundation` automatically, exactly as `toaster/meta.dart`'s own
/// [toasterDoc.dependencies] already listed. Both sections here say so
/// honestly instead.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import 'meta.dart';

final ComponentDocSpec toasterDocSpec = ComponentDocSpec(
  name: 'toaster',
  title: toasterDoc.title,
  description: toasterDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'Each control calls a different ElToastController method; '
          '"Clear all" calls ElToastController.clear(). Resize the window '
          'below 600px (ElToaster.mobileBreakpoint) to see the compact, '
          'top-anchored, full-width treatment take over.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: el(150),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'toaster has a real registry manifest, `elattar add toaster` '
          'installs lib/src/components/toaster.dart and resolves '
          'bloom-cosmic, icon, machine-surface, safe-area and '
          'source-foundation automatically. The Manual tab is for a '
          'project not using the CLI.',
      command: toasterDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/toaster.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/toaster.dart's generated "
              '@ui/toaster.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated toaster.dart payload here when using '
              'manual mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ElToaster, ElToastController and '
              'the rest of the toast family are reachable the same way '
              'the CLI path already makes them.',
          code: "export 'toaster.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct pair: a host mounted once, and a call '
          'fired from anywhere that holds the controller. Every example '
          'below only changes what is fired into it.',
      code: _smallestUsageCode,
    ),
    ShowcaseSection(
      id: 'types',
      title: 'Types',
      description:
          'Six ElToastType values (five typed, one default), each '
          'selecting an icon glyph, an ink color, and the bloom\'s two '
          'stops -- the card fill, border, radius and padding never '
          'change. This is the only live demonstration on the page of '
          'loading and normal: Preview above never fires either.',
      specimen: _TypesSpecimen(),
      code: _typesCode,
      label: 'Types specimen view',
      minHeight: el(120),
    ),
    SnippetSection(
      id: 'action',
      title: 'Action',
      description:
          'Pass action to any ElToastController call to add a pill at '
          'the far right of the row. Pressing it runs onPressed first '
          'and dismisses the toast right after, whether or not '
          'onPressed is null. Preview\'s own "Show error + action" '
          'control above fires this exact call live; nothing here would '
          'show differently a second time.',
      code: _actionUsageCode,
    ),
    SnippetSection(
      id: 'promise',
      title: 'Promise',
      description:
          'ElToastController.promise shows the loading message '
          'immediately and swaps the settled one into the SAME toast '
          'when the future completes -- same id, same box, same '
          'position in the stack, no exit and no second entrance. The '
          '4000ms clock only starts once it has settled, because a '
          'loading toast has none. Preview\'s own "Show promise" '
          'control above fires the first call live. Call settle by '
          'hand instead when the async flow does not fit a single '
          'Future, exactly as the manual flow below does -- not '
          'exercised live on this page, since a save flow composes '
          'arbitrarily and this page tests the primitive, not a real '
          'save.',
      code: '$_promiseUsageCode\n\n$_compositionCode',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every ElToaster constructor parameter and static member, '
          'every ElToastType value, every ElToastController method, and '
          'every ElToastMessage / ElToastAction field, read directly '
          'from lib/src/components/toaster.dart. ElToastController also '
          'exposes length, visibleCount, and messageOf(id) under '
          '@visibleForTesting -- test-only introspection, not part of '
          'the surface a call site is meant to drive, so they are noted '
          'here rather than tabled.',
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Unlike ElAlert, ElToaster is not purely presentational -- it '
          'owns a lifetime clock, a hover-pause, and a swipe gesture. '
          'Rows that do not apply are marked N/A with the reason.',
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
          'A real gap, stated plainly rather than assumed away: a '
          'toast\'s action pill cannot currently be reached or pressed '
          'from a keyboard at all.',
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
            value: toasterDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/feedback_effects_test.dart',
            description:
                'Exercises ElToaster\'s full choreography directly -- the '
                'stack collapse, the hover-expand, all three exits, the '
                'swipe gesture, and the timers -- rasterized and '
                'geometry-checked, not just mounted.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/toaster_test.dart',
            description:
                "This page's own specimen and metadata tests, focused on "
                'the imperative API surface and the live-region '
                'announcement.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/toaster/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class ToasterDocPage extends StatelessWidget {
  const ToasterDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: toasterDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENT · TOASTER',
      title: toasterDoc.title,
      description: toasterDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Toaster'),
    ],
    toc: toasterDocSpec.toc,
    // toaster is the last entry in Wave 3's own list
    // (docs/superpowers/plans/2026-08-23-phase-j-full-component-
    // documentation.md): nothing to link forward to yet.
    previous: const DocsPageLink(title: 'Tabs', route: '/components/tabs'),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('toaster-doc-article'),
      child: ComponentDocPage(spec: toasterDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

/// A real [ElToastController], fired into by real controls, over a real
/// [ElToaster] -- mounted the same `Positioned.fill` inside a `Stack` way
/// `site_shell.dart`'s `SiteShell` and `showcase_app.dart`'s
/// `SignalStudioApp` both mount it. Owns and disposes its own controller
/// rather than reaching into the site's shared `siteToasts` singleton, so
/// this specimen never leaks a toast onto another page.
class _PreviewSpecimen extends StatefulWidget {
  const _PreviewSpecimen();

  @override
  State<_PreviewSpecimen> createState() => _PreviewSpecimenState();
}

class _PreviewSpecimenState extends State<_PreviewSpecimen> {
  final ElToastController _controller = ElToastController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      Wrap(
        spacing: el(3),
        runSpacing: el(3),
        children: <Widget>[
          ElButton(
            variant: ElButtonVariant.secondary,
            size: ElButtonSize.sm,
            onPressed: () => _controller.success(
              'Changes saved',
              description: 'Your profile was updated successfully.',
            ),
            child: const Text('Show success'),
          ),
          ElButton(
            variant: ElButtonVariant.secondary,
            size: ElButtonSize.sm,
            onPressed: () => _controller.error(
              'Payment failed',
              description: 'We could not process your card ending in 4242.',
              action: ElToastAction(label: 'Retry', onPressed: () {}),
            ),
            child: const Text('Show error + action'),
          ),
          ElButton(
            variant: ElButtonVariant.secondary,
            size: ElButtonSize.sm,
            onPressed: () => _controller.info(
              'New feature available',
              description: 'The command palette is now available via Cmd+K.',
            ),
            child: const Text('Show info'),
          ),
          ElButton(
            variant: ElButtonVariant.secondary,
            size: ElButtonSize.sm,
            onPressed: () => _controller.warning(
              'Withdrawal under review',
              description:
                  'Large withdrawals are held for a security review '
                  'before they clear.',
            ),
            child: const Text('Show warning'),
          ),
          ElButton(
            variant: ElButtonVariant.secondary,
            size: ElButtonSize.sm,
            onPressed: () => _controller.promise<void>(
              Future<void>.delayed(ElDurations.reward),
              loading: 'Saving…',
              success: 'Saved',
              error: 'Could not save',
            ),
            child: const Text('Show promise'),
          ),
          ElButton(
            variant: ElButtonVariant.outline,
            size: ElButtonSize.sm,
            onPressed: _controller.clear,
            child: const Text('Clear all'),
          ),
        ],
      ),
      SizedBox(height: el(6)),
      SizedBox(
        height: el(105),
        child: Stack(
          children: <Widget>[
            Positioned.fill(child: ElToaster(controller: _controller)),
          ],
        ),
      ),
    ],
  );
}

const String _previewCode = '''
final ElToastController controller = ElToastController();

// Mounted once, near the app root:
Stack(
  children: [
    // ...the rest of the app...
    Positioned.fill(child: ElToaster(controller: controller)),
  ],
)

// Fired from anywhere that holds `controller`:
controller.success(
  'Changes saved',
  description: 'Your profile was updated successfully.',
);

controller.error(
  'Payment failed',
  description: 'We could not process your card ending in 4242.',
  action: ElToastAction(label: 'Retry', onPressed: retry),
);

controller.info(
  'New feature available',
  description: 'The command palette is now available via Cmd+K.',
);

controller.warning(
  'Withdrawal under review',
  description: 'Large withdrawals are held for a security review before they clear.',
);

controller.promise<void>(
  saveProfile(),
  loading: 'Saving…',
  success: 'Saved',
  error: 'Could not save',
);

controller.clear();
''';

const String _smallestUsageCode =
    '''final ElToastController toasts = ElToastController();

// Mounted once, near the app root:
Positioned.fill(child: ElToaster(controller: toasts))

// Fired from anywhere that holds `toasts`:
toasts.success('Changes saved');''';

/// New: a live demonstration of every [ElToastType], including `loading`
/// and `normal`, neither of which [_PreviewSpecimen]'s own five buttons
/// ever fire.
class _TypesSpecimen extends StatefulWidget {
  const _TypesSpecimen();

  @override
  State<_TypesSpecimen> createState() => _TypesSpecimenState();
}

class _TypesSpecimenState extends State<_TypesSpecimen> {
  final ElToastController _controller = ElToastController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      Wrap(
        spacing: el(3),
        runSpacing: el(3),
        children: <Widget>[
          ElButton(
            key: const ValueKey<String>('toaster-example:types-success'),
            variant: ElButtonVariant.secondary,
            size: ElButtonSize.sm,
            onPressed: () => _controller.success('Sync complete'),
            child: const Text('success'),
          ),
          ElButton(
            key: const ValueKey<String>('toaster-example:types-info'),
            variant: ElButtonVariant.secondary,
            size: ElButtonSize.sm,
            onPressed: () => _controller.info('New feature available'),
            child: const Text('info'),
          ),
          ElButton(
            key: const ValueKey<String>('toaster-example:types-warning'),
            variant: ElButtonVariant.secondary,
            size: ElButtonSize.sm,
            onPressed: () => _controller.warning('Withdrawal under review'),
            child: const Text('warning'),
          ),
          ElButton(
            key: const ValueKey<String>('toaster-example:types-error'),
            variant: ElButtonVariant.secondary,
            size: ElButtonSize.sm,
            onPressed: () => _controller.error('Payment failed'),
            child: const Text('error'),
          ),
          ElButton(
            key: const ValueKey<String>('toaster-example:types-loading'),
            variant: ElButtonVariant.secondary,
            size: ElButtonSize.sm,
            onPressed: () => _controller.loading('Uploading…'),
            child: const Text('loading'),
          ),
          ElButton(
            key: const ValueKey<String>('toaster-example:types-normal'),
            variant: ElButtonVariant.secondary,
            size: ElButtonSize.sm,
            onPressed: () =>
                _controller.show(const ElToastMessage(title: 'Note')),
            child: const Text('normal (default)'),
          ),
        ],
      ),
      SizedBox(height: el(5)),
      SizedBox(
        height: el(90),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: ElToaster(
                key: const ValueKey<String>('toaster-example:types-host'),
                controller: _controller,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

const String _typesCode = '''toasts.success('Sync complete');       // ElToastType.success
toasts.info('New feature available');  // ElToastType.info
toasts.warning('Withdrawal under review'); // ElToastType.warning
toasts.error('Payment failed');        // ElToastType.error
toasts.loading('Uploading…');          // ElToastType.loading -- no clock
toasts.show(const ElToastMessage(title: 'Note')); // ElToastType.normal (the default)''';

const String _actionUsageCode = '''toasts.error(
  'Payment failed',
  description: 'We could not process your card ending in 4242.',
  action: ElToastAction(label: 'Retry', onPressed: retryPayment),
);''';

const String _promiseUsageCode = '''toasts.promise<void>(
  saveProfile(),
  loading: 'Saving…',
  success: 'Saved',
  error: 'Could not save',
);''';

const String _compositionCode =
    '''Future<void> handleSave(ElToastController toasts) async {
  final int id = toasts.loading('Saving…');
  try {
    await saveProfile();
    toasts.settle(id, const ElToastMessage(
      title: 'Saved',
      type: ElToastType.success,
      promise: true,
    ));
  } catch (_) {
    toasts.settle(id, const ElToastMessage(
      title: 'Could not save',
      type: ElToastType.error,
      promise: true,
    ));
  }
}''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsApiTable(
        title: 'ElToaster -- the overlay host (constructor)',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'controller',
            type: 'ElToastController',
            description:
                'Required. The queue this host paints from -- fire real '
                'toasts into it by calling its show / success / error / '
                'info / warning / loading / promise methods from '
                'anywhere that holds a reference.',
          ),
          DocsApiFact(
            name: 'position',
            type: 'ElToastPosition',
            description:
                'Optional, defaults to ElToastPosition.bottomRight. The '
                'wide-viewport corner only -- at or below '
                'ElToaster.mobileBreakpoint (600px) the stack always '
                're-anchors to the top edge regardless of this value; '
                'see Responsive below.',
          ),
        ],
      ),
      SizedBox(height: el(8)),
      const DocsApiTable(title: 'ElToastType', facts: _toastTypeFacts),
      SizedBox(height: el(8)),
      const DocsApiTable(
        title: 'ElToaster -- static timing & layout constants',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'ElToaster.width (static)',
            type: 'double',
            description:
                '356 -- the fixed toast width on a wide viewport '
                '(sonner\'s width: var(--width, 22.25rem)).',
          ),
          DocsApiFact(
            name: 'ElToaster.gap (static)',
            type: 'double',
            description:
                '14 -- the vertical space between two stacked toasts '
                '(sonner\'s GAP).',
          ),
          DocsApiFact(
            name: 'ElToaster.viewportOffset (static)',
            type: 'double',
            description:
                '24 -- the inset from each edge of the anchored corner '
                'on a wide viewport (sonner\'s VIEWPORT_OFFSET).',
          ),
          DocsApiFact(
            name: 'ElToaster.mobileViewportOffset (static)',
            type: 'double',
            description:
                '16 -- the inset on every edge once compact, replacing '
                'viewportOffset on all four sides at once (sonner\'s '
                'MOBILE_VIEWPORT_OFFSET).',
          ),
          DocsApiFact(
            name: 'ElToaster.mobileBreakpoint (static)',
            type: 'double',
            description:
                '600 -- sonner\'s one and only breakpoint '
                '(@media (max-width: 600px), inclusive).',
          ),
          DocsApiFact(
            name: 'ElToaster.visibleLimit (static)',
            type: 'int',
            description:
                '3 -- at most this many toasts are painted at once '
                '(sonner\'s VISIBLE_TOASTS_AMOUNT); anything past the '
                'third waits its turn with its clock unstarted.',
          ),
          DocsApiFact(
            name: 'ElToaster.lifetime (static)',
            type: 'Duration',
            description:
                'Duration(seconds: 4) -- 4000ms. Sonner\'s '
                'TOAST_LIFETIME, and ElToastMessage.duration\'s own '
                'default.',
          ),
          DocsApiFact(
            name: 'ElToaster.unmountDelay (static)',
            type: 'Duration',
            description:
                'Duration(milliseconds: 200) -- 200ms. How long a ' // allow-hardcoded: prose describing ElToaster.unmountDelay, not a value used
                'dismissed toast stays mounted after '
                'ElToastController.dismiss before it is actually '
                'removed (sonner\'s TIME_BEFORE_UNMOUNT); every exit '
                'transition runs longer than this, so every one is cut '
                'off partway.',
          ),
          DocsApiFact(
            name: 'ElToaster.transition (static)',
            type: 'Duration',
            description:
                'Duration(milliseconds: 400) -- 400ms. The window ' // allow-hardcoded: prose describing ElToaster.transition, not a value used
                'the entrance, the collapse, the expand, and two of the '
                'three exits all ride.',
          ),
          DocsApiFact(
            name: 'ElToaster.collapsedExitTransform (static)',
            type: 'Duration',
            description:
                'Duration(milliseconds: 500) -- 500ms. The transform ' // allow-hardcoded: prose describing ElToaster.collapsedExitTransform, not a value used
                'half of a back toast\'s collapsed exit; its opacity '
                'half is unmountDelay\'s 200ms.',
          ),
          DocsApiFact(
            name: 'ElToaster.swipeOutDuration (static)',
            type: 'Duration',
            description:
                'Duration(milliseconds: 200) -- 200ms. The ' // allow-hardcoded: prose describing ElToaster.swipeOutDuration, not a value used
                'thrown-away animation once a swipe clears the '
                'threshold.',
          ),
          DocsApiFact(
            name: 'ElToaster.swipeThreshold (static)',
            type: 'double',
            description:
                '45 -- a swipe must travel this many px (or clear '
                'swipeVelocity) to dismiss; short of it, the toast '
                'snaps back with no transition at all.',
          ),
          DocsApiFact(
            name: 'ElToaster.swipeVelocity (static)',
            type: 'double',
            description:
                '110 -- the release-velocity gate, in px per second '
                '(sonner\'s 0.11 px/ms).',
          ),
          DocsApiFact(
            name: 'ElToaster.stackScaleStep (static)',
            type: 'double',
            description:
                '0.05 -- each collapsed back toast scales down by one '
                'more of these (1 minus 0.05 times its index).',
          ),
          DocsApiFact(
            name: 'ElToaster.collapsedExitTravel (static)',
            type: 'double',
            description:
                '0.40 -- how far, as a fraction of its own box, a back '
                'toast in a collapsed stack falls on its way out.',
          ),
          DocsApiFact(
            name: 'ElToaster.isCompact (static)',
            type: 'bool Function(double viewportWidth)',
            description:
                'Whether a viewport this wide takes the compact, '
                'top-anchored treatment.',
          ),
          DocsApiFact(
            name: 'ElToaster.positionFor (static)',
            type: 'ElToastPosition Function(ElToastPosition, double)',
            description:
                'The resolved corner for a viewport this wide -- '
                'position itself above mobileBreakpoint, its '
                'topAnchored twin at or below it.',
          ),
          DocsApiFact(
            name: 'ElToaster.offsetFor (static)',
            type: 'double Function(double viewportWidth)',
            description:
                'viewportOffset or mobileViewportOffset, whichever this '
                'width takes.',
          ),
          DocsApiFact(
            name: 'ElToaster.widthFor (static)',
            type: 'double Function(double viewportWidth)',
            description:
                '356, or the full compact width minus two '
                'mobileViewportOffset insets, never negative.',
          ),
          DocsApiFact(
            name: 'ElToaster.paddingFor (static)',
            type:
                'EdgeInsets Function(double, EdgeInsets, ElToastPosition)',
            description:
                'offsetFor on every edge, plus MediaQueryData.padding on '
                'the one edge the stack is actually anchored to.',
          ),
          DocsApiFact(
            name: 'ElToaster.dampen (static)',
            type: 'double Function(double delta)',
            description:
                'The drag dampening applied against the corner\'s own '
                'two directions: delta / (1.5 + |delta| / 20).',
          ),
        ],
      ),
      SizedBox(height: el(8)),
      const DocsApiTable(
        title: 'ElToastController -- the imperative API ("toast(...)")',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'show',
            type: 'int Function(ElToastMessage message)',
            description:
                'Queues message and returns its id -- the one primitive '
                'every typed helper below calls.',
          ),
          DocsApiFact(
            name: 'success',
            type:
                'int Function(String title, {String? description, '
                'ElIconGlyph? glyph, ElToastAction? action})',
            description: 'toast.success(title).',
          ),
          DocsApiFact(
            name: 'error',
            type:
                'int Function(String title, {String? description, '
                'ElIconGlyph? glyph, ElToastAction? action})',
            description: 'toast.error(title).',
          ),
          DocsApiFact(
            name: 'info',
            type:
                'int Function(String title, {String? description, '
                'ElIconGlyph? glyph, ElToastAction? action})',
            description: 'toast.info(title).',
          ),
          DocsApiFact(
            name: 'warning',
            type:
                'int Function(String title, {String? description, '
                'ElIconGlyph? glyph, ElToastAction? action})',
            description: 'toast.warning(title).',
          ),
          DocsApiFact(
            name: 'loading',
            type:
                'int Function(String title, {String? description, '
                'ElIconGlyph? glyph, ElToastAction? action})',
            description:
                'toast.loading(title) -- the one call that leaves a '
                'toast on screen indefinitely, with no clock. Dismiss '
                'it, or settle it with promise or settle.',
          ),
          DocsApiFact(
            name: 'promise',
            type:
                'int Function<T>(Future<T> future, {required String '
                'loading, required String success, required String '
                'error, String? loadingDescription, String? '
                'successDescription, String? errorDescription})',
            description:
                'Shows the loading message immediately and swaps the '
                'settled one into the SAME toast when future completes '
                '-- same id, same box, same position in the stack, no '
                'exit and no second entrance. The 4000ms clock only '
                'starts once it has settled, because a loading toast '
                'has none.',
          ),
          DocsApiFact(
            name: 'settle',
            type: 'void Function(int id, ElToastMessage next)',
            description:
                'Replaces a live toast\'s message in place, the way '
                'promise does. A no-op once the toast has gone.',
          ),
          DocsApiFact(
            name: 'dismiss',
            type: 'void Function(int id)',
            description:
                'toast.dismiss(id) -- starts the 200ms unmount window '
                '(ElToaster.unmountDelay).',
          ),
          DocsApiFact(
            name: 'clear',
            type: 'void Function()',
            description:
                'toast.dismiss() with no id -- clears every queued '
                'toast at once.',
          ),
        ],
      ),
      SizedBox(height: el(8)),
      const DocsApiTable(
        title: 'ElToastMessage -- one queued toast (constructor)',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'title',
            type: 'String',
            description:
                'Required. The only thing every toast carries, and the '
                'accessible label a screen reader announces -- see '
                'Accessibility.',
          ),
          DocsApiFact(
            name: 'description',
            type: 'String?',
            description:
                'Optional, defaults to null. A second line under the '
                'title, in the muted-foreground color.',
          ),
          DocsApiFact(
            name: 'type',
            type: 'ElToastType',
            description:
                'Optional, defaults to ElToastType.normal. Selects the '
                'icon, its ink color, and the bloom\'s two stops -- see '
                'Types.',
          ),
          DocsApiFact(
            name: 'glyph',
            type: 'ElIconGlyph?',
            description:
                'Optional, defaults to null. Overrides type\'s own icon '
                '-- a different glyph on a typed toast, or any glyph at '
                'all on an untyped one.',
          ),
          DocsApiFact(
            name: 'duration',
            type: 'Duration',
            description:
                'Optional, defaults to ElToaster.lifetime '
                '(Duration(seconds: 4), 4000ms). Ignored entirely while '
                'type is ElToastType.loading, which has no clock.',
          ),
          DocsApiFact(
            name: 'promise',
            type: 'bool',
            description:
                'Optional, defaults to false. Set for every state of a '
                'ElToastController.promise toast, loading and settled '
                'alike -- what turns its glyph swap into a cross-fade '
                'instead of a cut.',
          ),
          DocsApiFact(
            name: 'action',
            type: 'ElToastAction?',
            description:
                'Optional, defaults to null. The action pill at the far '
                'right of the row -- see Action.',
          ),
        ],
      ),
      SizedBox(height: el(8)),
      const DocsApiTable(
        title: 'ElToastAction -- the optional action pill (constructor)',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'label',
            type: 'String',
            description: 'Required. The pill\'s text.',
          ),
          DocsApiFact(
            name: 'onPressed',
            type: 'VoidCallback?',
            description:
                'Optional, defaults to null. Runs first; the toast '
                'dismisses right after, whether or not this is null.',
          ),
        ],
      ),
    ],
  );
}

const List<DocsApiFact> _toastTypeFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'success',
    type: 'ElToastType',
    description:
        'data-type="success". Icon: ElIconGlyph.circleCheck. Ink: '
        'theme.successInk. Bloom: --color-success / --color-value.',
  ),
  DocsApiFact(
    name: 'info',
    type: 'ElToastType',
    description:
        'data-type="info". Icon: ElIconGlyph.info. Ink: theme.infoInk.',
  ),
  DocsApiFact(
    name: 'warning',
    type: 'ElToastType',
    description:
        'data-type="warning". Icon: ElIconGlyph.alertTriangle. Ink: '
        'theme.warningInk. Its bloom pair (ElBloomCosmic.toastWarning) '
        'is the one variant that does not match ElAlert\'s own warning '
        'bloom.',
  ),
  DocsApiFact(
    name: 'error',
    type: 'ElToastType',
    description:
        'data-type="error". Icon: ElIconGlyph.octagonX. Ink: '
        'theme.destructiveInk.',
  ),
  DocsApiFact(
    name: 'loading',
    type: 'ElToastType',
    description:
        'data-type="loading". Icon: ElIconGlyph.loaderCircle, and it '
        'does not spin -- the source ships it with no spin animation, '
        'confirmed against the live reference too. The one type with '
        'no auto-dismiss clock at all.',
  ),
  DocsApiFact(
    name: 'normal',
    type: 'ElToastType',
    description:
        'The default (label reads "default" -- default is a Dart '
        'keyword). No data-type attribute is ever set, and no icon '
        'slot renders at all unless the message supplies its own glyph '
        '-- TOAST_ICONS has no default key on the reference either.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest',
    treatment:
        'A queued toast enters over ElToaster.transition (400ms) and '
        'its 4000ms auto-dismiss clock (ElToaster.lifetime) starts the '
        'moment it becomes one of the ElToaster.visibleLimit (3) '
        'visible toasts -- a queued fourth toast does not count down '
        'while it waits.',
    userSignal:
        'The stack collapses to a scaled, blanked silhouette behind '
        'the front toast; only the front one is legible.',
  ),
  DocsStateFact(
    state: 'Hover',
    treatment:
        'Hovering anywhere over the stack expands every toast to its '
        'own natural height and pauses every visible toast\'s clock at '
        'whatever time remains -- not a restart. Leaving resumes from '
        'that remainder.',
    userSignal:
        'Content fades back in on every toast, not only the one under '
        'the pointer, because the whole stack expands together.',
  ),
  DocsStateFact(
    state: 'Focus-visible',
    treatment:
        'N/A -- no toast, and no part of it, requests focus; nothing '
        'in toaster.dart calls FocusScope or FocusNode.requestFocus.',
    userSignal: 'Whatever the user was doing keeps its own focus.',
  ),
  DocsStateFact(
    state: 'Pressed',
    treatment:
        'A tap anywhere on the toast body dismisses it immediately '
        '(the port\'s own addition -- sonner itself has no '
        'tap-to-dismiss). A drag past ElToaster.swipeThreshold (45px) '
        'or ElToaster.swipeVelocity throws it out on the swiped axis; '
        'short of that it snaps back with no transition at all.',
    userSignal:
        'The action pill, when present, runs its own onPressed first '
        'and dismisses the toast right after -- whether or not '
        'onPressed is null.',
  ),
  DocsStateFact(
    state: 'Selected',
    treatment: 'N/A -- a toast is not a selectable item.',
    userSignal: 'Not applicable.',
  ),
  DocsStateFact(
    state: 'Loading',
    treatment:
        'ElToastType.loading is the one type with no clock at all -- '
        'it stays on screen until ElToastController.dismiss, or until '
        'promise / settle replaces it in place.',
    userSignal:
        'Its glyph (ElIconGlyph.loaderCircle) holds still -- the '
        'source ships it with no spin animation.',
  ),
  DocsStateFact(
    state: 'Empty',
    treatment:
        'N/A -- title is a required, non-null String on '
        'ElToastMessage; there is no contentless toast to render.',
    userSignal: 'Not applicable.',
  ),
  DocsStateFact(
    state: 'Error / Success',
    treatment:
        'A compile-time type choice (ElToastType.error / .success on '
        'ElToastMessage), not a runtime transition on the same toast '
        '-- unless ElToastController.promise or settle swaps one type '
        'into the other in place.',
    userSignal:
        'Icon glyph, its ink color, and the bloom\'s two stops change; '
        'the card fill, border and text color never do.',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment:
        'N/A on the toast body -- nothing here is a form control. '
        'ElToastAction.onPressed is itself nullable; the pill still '
        'dismisses the toast when pressed even when it is null.',
    userSignal: 'Not applicable.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'Every transition above collapses to its final frame '
        'immediately, but the 4000ms auto-dismiss clock is not gated '
        'on it -- sonner\'s own reduced-motion block removes '
        'transitions, not timers, so a reduced-motion toast still '
        'expires on its own real schedule.',
    userSignal:
        'A toast appears already at its resting position and opacity, '
        'with no visible entrance, and still clears itself on '
        'schedule.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Semantic role: Semantics(container: true, liveRegion: true, '
            'label: message.title) wraps the whole toast surface -- a '
            'live-region announcement with no separate aria-live or '
            'aria-atomic attribute to reason about. It does announce, '
            'and it never steals focus while doing it -- see Focus '
            'behavior below.',
        'Required labels: title is the only required accessible '
            'content. container: true makes this node a semantics '
            'boundary, and the title/description ElText children below '
            'it are not boundaries of their own, so their literal text '
            'merges upward into this one node rather than staying '
            'separate -- verified on this page\'s own live-specimen '
            'test: the announced SemanticsNode.label for a '
            'titled-and-described toast reads the explicit label, then '
            'the title again, then the description, in that order. The '
            'title is effectively announced twice.',
        'Focus behavior: a toast never requests focus on mount or on '
            'entry -- nothing in toaster.dart calls FocusScope or '
            'FocusNode.requestFocus -- so it never interrupts whatever '
            'the user was doing, unlike a dialog.',
        'Touch target: the toast body\'s own dismiss-on-tap region is '
            'the whole 356px-wide card. The action pill\'s own box is '
            '32px tall, under the common 44px touch-target guideline.',
        'Non-color signals: every typed toast (success / info / '
            'warning / error / loading) pairs its ink color with a '
            'distinct icon glyph and with the title/description text, '
            'so meaning never rides on hue alone. The untyped default '
            'carries no icon slot at all, so an untyped toast\'s only '
            'signal is its text.',
        'Error wiring: N/A -- no form-field validation hookup; a toast '
            'states an outcome after the fact, it does not validate a '
            'field.',
        'Screen-reader announcements: liveRegion: true asks the '
            'platform accessibility service to announce the toast when '
            'it mounts -- confirmed on this page\'s own live-specimen '
            'test via flagsCollection.isLiveRegion. The announced '
            'content is not just the title: it is the explicit label '
            'merged with every literal Text descendant beneath it (see '
            'Required labels above), so a described toast is heard as '
            'its title, its title again, then its description.',
        'Known platform differences: live-region announcement timing '
            'is the platform accessibility service\'s call (TalkBack, '
            'VoiceOver, web ARIA), not something this widget schedules '
            '-- the same disclaimer ElAlert\'s own page states for its '
            'role="alert" region.',
      ]);
}

/// New: split out of the old combined Accessibility section, matching
/// `button`, `field`, `popover` and `alert`'s own dedicated Keyboard
/// disclosure.
class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No key handling of its own: the toast body has no FocusNode, '
            'and toaster.dart wires no Focus or onKeyEvent anywhere on '
            'it.',
        'The action pill is rendered by hand rather than as a real '
            'ElButton, because sonner renders [data-button] itself, and '
            'it wires only a MouseRegion and a GestureDetector, with no '
            'Focus or onKeyEvent of its own. A toast\'s action cannot '
            'currently be reached or pressed from a keyboard -- a real '
            'gap, stated plainly rather than assumed away.',
        'No Tab trap and no FocusTraversalPolicy: a toast never enters '
            'the tab order at all, so there is nothing to trap traversal '
            'inside of.',
        'Nothing here dismisses on Escape: unlike ElPopover or '
            'ElDialogContent, a toast\'s only dismissals are its own '
            'clock, a tap, a swipe, or a direct '
            'ElToastController.dismiss/clear call.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'ElToaster.position (default ElToastPosition.bottomRight) '
            'chooses the corner only on a wide viewport. At or below '
            'ElToaster.mobileBreakpoint (600px, inclusive -- a '
            'max-width query) the stack always re-anchors to the top '
            'edge, keeping the side it was on -- a deliberate departure '
            'the source states plainly: sonner\'s own live app never '
            'repositions its toaster on mobile at all, so the compact '
            'top anchor is a design order here, not something measured '
            'off the reference.',
        'Going compact also widens every toast: width drops from the '
            'fixed ElToaster.width (356px) to the full viewport minus '
            'two ElToaster.mobileViewportOffset (16px) insets, '
            'replacing the wide viewport\'s ElToaster.viewportOffset '
            '(24px) on every edge at once.',
        'The anchored edge additionally pays MediaQueryData.padding on '
            'top of that inset (ElToaster.paddingFor), so a '
            'top-anchored compact stack clears a phone\'s status bar '
            'and a bottom-anchored one clears its gesture bar; the '
            'other three edges keep the un-padded number, since the '
            'stack never reaches them. Preview\'s own live specimen '
            'demonstrates the swap directly -- compare it at 390x844 '
            'against 1440x900.',
        'Platform parity: dart:async, dart:math, and flutter/'
            'widgets.dart, flutter/gestures.dart, flutter/rendering.dart, '
            'flutter/scheduler.dart -- no platform channel, so every '
            'Flutter target renders and drives the same choreography.',
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
            value: 'toaster',
            description:
                'registry/components/toaster.json exists and is '
                'installable through the CLI today.',
          ),
          const DocsInstallFact(
            label: 'Destination',
            value: 'lib/components/ui/toaster.dart',
            description:
                'The same lib/components/ui/ target every component '
                'installs to.',
          ),
          const DocsInstallFact(
            label: 'Files',
            value: 'lib/src/components/toaster.dart',
            description:
                'One file; every public class -- ElToaster, ElToast, '
                'ElToastController, ElToastMessage, ElToastAction, '
                'ElToastType, ElToastPosition -- lives here.',
          ),
          const DocsInstallFact(
            label: 'Package imports',
            value:
                'dart:async, dart:math, effects/bloom_cosmic.dart, '
                'effects/machine_surface.dart, foundation/colors.dart, '
                'foundation/motion.dart, foundation/shadows.dart, '
                'foundation/spacing.dart, foundation/theme.dart, '
                'foundation/typography.dart, theme_scope.dart, '
                'el_safe_area.dart, icon.dart, icon_paths.dart',
            description:
                'ElBloomCosmic paints the fill and its idle/hover/'
                'starfield animation; ElMachineSurface paints the '
                'border and the e3 shadow; ElSafeArea supplies the '
                'system-bar insets the compact anchor pays.',
          ),
          DocsInstallFact(
            label: 'Dependencies',
            value: toasterDoc.dependencies.join(', '),
            description:
                "registry/components/toaster.json's own "
                'registryDependencies, resolved automatically by '
                '`elattar add toaster`.',
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
                'No platform channel, so every Flutter target renders '
                'and drives the same choreography.',
          ),
        ],
      ),
      SizedBox(height: el(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Alert', route: '/components/alert'),
          DocsLink(
            label: 'Alert Dialog',
            route: '/components/alert_dialog',
          ),
        ],
      ),
      SizedBox(height: el(4)),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: ElWidths.prose),
        child: Builder(
          builder: (BuildContext context) {
            final ElThemeData theme = ElTheme.of(context);
            return ElText(
              'A message that announces itself once, near a screen '
              'corner, and clears itself on a timer -- never a '
              'question, and never part of the page\'s own content. '
              'Reach for an alert instead when the message belongs to '
              'the page\'s own content and should stay exactly where '
              'it is mounted until whatever renders it removes it: an '
              'alert never times out and never floats. Reach for an '
              'alert dialog instead when the situation blocks the page '
              'and demands one answer before the user can continue -- '
              'a confirmation, an irreversible action: it shares '
              'ElDialogContent\'s own panel and its scrim, both of '
              'which a toast has neither of.',
              ElType.small,
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
      _bullets(ElTheme.of(context), <String>[
        'Every toast shares one card surface -- the same --popover '
            'fill, the same 1px border, the same e3 shadow -- and a '
            'type spends exactly the same one token pair ElAlert\'s own '
            'variants do: the icon\'s ink color and the bloom\'s two '
            'stops, both read from ElThemeData. Title and description '
            'colors never move with type; only the glyph does.',
        'Flip ElThemeController between light and dark and every '
            'visible toast\'s ink and bloom follow the active theme '
            'immediately -- nothing on this page opts out, matching '
            'ElAlert\'s own theming note.',
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
