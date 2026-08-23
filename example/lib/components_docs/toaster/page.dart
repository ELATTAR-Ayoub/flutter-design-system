/// Public component documentation for the toaster component.
///
/// Follows `docs/superpowers/plans/2026-08-21-public-website-ui-information-
/// architecture.md` §9.1's eighteen-section template, composed from the
/// Phase C docs primitives the same way `alert/page.dart` does — the alert,
/// alert-dialog and toaster trio share one decision-guidance story, and this
/// page's Purpose section agrees with alert's own rather than restating it.
///
/// [DsToaster] and [DsToastController] are the Flutter analogue of sonner's
/// own split — `lib/src/components/toaster.dart`'s own library doc states it
/// plainly: a host mounted once, and a controller a caller fires into from
/// anywhere. Both halves are documented in full below: the host's own two
/// constructor parameters, its 21 static timing-and-layout constants, and
/// every method [DsToastController] exposes as the actual imperative surface
/// (`controller.success(...)` and friends) — nothing here manufactures a
/// shadcn/sonner example the Dart API does not support.
///
/// The live specimen mounts [DsToaster] the same way the real app does —
/// `Positioned.fill` inside a `Stack`, exactly as `example/lib/site/
/// site_shell.dart`'s `SiteShell` and `example/lib/showcase/
/// showcase_app.dart`'s `SignalStudioApp` both mount it — over a
/// [DsToastController] this page owns and disposes itself, rather than
/// reaching into the site's shared `siteToasts` singleton.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

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
    breadcrumbs: const <DsBreadcrumbEntry>[
      DsBreadcrumbEntry.link('Components'),
      DsBreadcrumbEntry.page('Toaster'),
    ],
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Purpose', anchor: 'purpose'),
      DocsTocEntry(title: 'Status', anchor: 'status'),
      DocsTocEntry(title: 'Preview', anchor: 'preview'),
      DocsTocEntry(title: 'Install', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'API', anchor: 'api'),
      DocsTocEntry(title: 'Variants', anchor: 'variants'),
      DocsTocEntry(title: 'States', anchor: 'states'),
      DocsTocEntry(title: 'Accessibility', anchor: 'a11y'),
      DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
      DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
      DocsTocEntry(title: 'Composition', anchor: 'composition'),
      DocsTocEntry(title: 'Theming', anchor: 'theming'),
      DocsTocEntry(title: 'Source', anchor: 'source'),
    ],
    // toaster is the last entry in Wave 3's own list
    // (docs/superpowers/plans/2026-08-23-phase-j-full-component-
    // documentation.md) — nothing to link forward to yet.
    previous: const DocsPageLink(title: 'Tabs', route: '/components/tabs'),
    onNavigate: onNavigate,
    child: const _ToasterArticle(),
  );
}

class _ToasterArticle extends StatelessWidget {
  const _ToasterArticle();

  @override
  Widget build(BuildContext context) => Column(
    key: const ValueKey<String>('toaster-doc-article'),
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      // 4. Expanded purpose and decision guidance.
      DsSection(
        id: 'purpose',
        title: 'Purpose and when to use it',
        description:
            'A message that announces itself once, near a screen corner, '
            'and clears itself on a timer -- never a question, and never '
            'part of the page\'s own content.',
        child: const _Prose(<String>[
          'DsToaster and DsToastController together are the Flutter '
              'analogue of sonner\'s own split: DsToaster is a host, '
              'mounted once near the app root -- Positioned.fill inside a '
              'Stack, exactly as this page\'s own Preview does it -- and it '
              'paints nothing until something is queued. Every toast is '
              'fired into it from anywhere by holding a reference to the '
              'DsToastController it is mounted with, the way toast(...) is '
              'a module-level singleton on the web. At most '
              'DsToaster.visibleLimit (3) are ever on screen at once; a '
              'fourth toast waits its turn with its own auto-dismiss clock '
              'unstarted.',
          'Reach for an alert (DsAlert) instead when the message belongs '
              'to the page\'s own content and should stay exactly where '
              'it is mounted until whatever renders it removes it. DsAlert '
              'never times out and never floats -- it lays out like any '
              'other block in the page\'s own flow, and the caller owns '
              'its lifetime; DsToaster owns a toast\'s lifetime instead, '
              'on a real clock (DsToaster.lifetime, 4000ms by default).',
          'Reach for an alert dialog instead when the situation blocks '
              'the page and demands one answer before the user can '
              'continue -- a confirmation, an irreversible action. It '
              'shares DsDialogContent\'s own panel and its scrim, both of '
              'which a toast has neither of: a toast never intercepts a '
              'pointer outside its own box, and it clears itself without '
              'asking.',
        ]),
      ),

      // 5. Status/version/platform metadata.
      DsSection(
        id: 'status',
        title: 'Status',
        child: const DocsInstallFacts(
          title: 'Status facts',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Status',
              value: 'Source-available, not registry-listed',
              description:
                  'Ships in the package today; elattar add toaster is not '
                  'wired up yet -- see Install below.',
            ),
            DocsInstallFact(
              label: 'Version',
              value: '0.0.1',
              description: 'Tracks the package version in pubspec.yaml.',
            ),
            DocsInstallFact(
              label: 'Platforms',
              value: 'Android, iOS, Web, macOS, Windows, Linux',
              description:
                  'dart:async, dart:math, and flutter/widgets.dart, '
                  'flutter/gestures.dart, flutter/rendering.dart, '
                  'flutter/scheduler.dart -- no platform channel, so every '
                  'Flutter target renders and drives the same choreography.',
            ),
          ],
        ),
      ),

      // 6. Primary live specimen with Preview/Code tabs.
      DsSection(
        id: 'preview',
        title: 'Preview',
        description:
            'A real DsToastController, fired into by the controls below, '
            'over a real DsToaster mounted the same Positioned.fill-inside-'
            'a-Stack way the public site\'s own shell mounts it. Nothing '
            'paints until a control is pressed -- DsToaster.build returns '
            'an empty box while its controller is queue-empty, the same as '
            'it does at the app root.',
        child: DocsCodeExample(
          title: 'Live specimen',
          description:
              'Each control calls a different DsToastController method; '
              '"Clear all" calls DsToastController.clear(). Resize the '
              'window below 600px (DsToaster.mobileBreakpoint) to see the '
              'compact, top-anchored, full-width treatment take over.',
          preview: const _ToasterPreview(),
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(
              path: 'preview.dart',
              title: 'Specimen source',
              description: 'The exact Dart that produced the preview above.',
              code: _previewCode,
            ),
          ],
        ),
      ),

      // 7. Installation with Command/Manual tabs.
      DsSection(
        id: 'install',
        title: 'Installation',
        description:
            'toaster has no registry/components/toaster.json manifest yet, '
            'so elattar add toaster is not yet available -- copy the '
            'component source file directly until that manifest lands.',
        child: DocsCodeExample(
          title: 'Manual installation',
          description:
              'Copy the component source into your project; its relative '
              'imports resolve once the file sits beside the rest of the '
              'package foundation and components.',
          manualFiles: <DocsCodeFile>[
            DocsCodeFile(
              path: toasterDoc.sourcePath,
              title: 'lib/components/ui/toaster.dart',
              description:
                  'Paste the full toaster.dart source here; its imports '
                  '(effects/bloom_cosmic.dart, effects/machine_surface.dart, '
                  'foundation/*, theme_scope.dart, ds_safe_area.dart, '
                  'icon.dart, icon_paths.dart) resolve once the file sits '
                  'beside the rest of components/ui.',
              code:
                  "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
                  '// Copy the generated toaster.dart payload here. No CLI item\n'
                  '// exists for toaster yet -- see the Status panel above.',
            ),
          ],
        ),
      ),

      // 8. Usage.
      DsSection(
        id: 'usage',
        title: 'Usage',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DsPanel(
              label: 'DART',
              note: 'SMALLEST CORRECT EXAMPLE',
              child: const DocsSelectableCodeBlock(code: _smallestUsageCode),
            ),
            SizedBox(height: ds(5)),
            DsPanel(
              label: 'DART',
              note: 'WITH A DESCRIPTION, AN ACTION, AND A PROMISE',
              child: const DocsSelectableCodeBlock(code: _actionUsageCode),
            ),
          ],
        ),
      ),

      // 9. API reference -- both halves of the split: the host widget and
      // the imperative controller/message/action surface it is fired into.
      DsSection(
        id: 'api',
        title: 'API reference',
        description:
            'Every DsToaster constructor parameter and static member, '
            'every DsToastController method, and every DsToastMessage / '
            'DsToastAction field, read directly from '
            'lib/src/components/toaster.dart. DsToastController also '
            'exposes length, visibleCount, and messageOf(id) under '
            '@visibleForTesting -- test-only introspection, not part of '
            'the surface a call site is meant to drive, so they are noted '
            'here rather than tabled.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const DocsApiTable(
              title: 'DsToaster -- the overlay host (constructor)',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'controller',
                  type: 'DsToastController',
                  description:
                      'Required. The queue this host paints from -- fire '
                      'real toasts into it by calling its show / success / '
                      'error / info / warning / loading / promise methods '
                      'from anywhere that holds a reference.',
                ),
                DocsApiFact(
                  name: 'position',
                  type: 'DsToastPosition',
                  description:
                      'Optional, defaults to DsToastPosition.bottomRight. '
                      'The wide-viewport corner only -- at or below '
                      'DsToaster.mobileBreakpoint (600px) the stack always '
                      're-anchors to the top edge regardless of this '
                      'value; see Responsive below.',
                ),
              ],
            ),
            SizedBox(height: ds(8)),
            const DocsApiTable(
              title: 'DsToaster -- static timing & layout constants',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'DsToaster.width (static)',
                  type: 'double',
                  description:
                      '356 -- the fixed toast width on a wide viewport '
                      '(sonner\'s width: var(--width, 22.25rem)).',
                ),
                DocsApiFact(
                  name: 'DsToaster.gap (static)',
                  type: 'double',
                  description:
                      '14 -- the vertical space between two stacked '
                      'toasts (sonner\'s GAP).',
                ),
                DocsApiFact(
                  name: 'DsToaster.viewportOffset (static)',
                  type: 'double',
                  description:
                      '24 -- the inset from each edge of the anchored '
                      'corner on a wide viewport (sonner\'s '
                      'VIEWPORT_OFFSET).',
                ),
                DocsApiFact(
                  name: 'DsToaster.mobileViewportOffset (static)',
                  type: 'double',
                  description:
                      '16 -- the inset on every edge once compact, '
                      'replacing viewportOffset on all four sides at once '
                      '(sonner\'s MOBILE_VIEWPORT_OFFSET).',
                ),
                DocsApiFact(
                  name: 'DsToaster.mobileBreakpoint (static)',
                  type: 'double',
                  description:
                      '600 -- sonner\'s one and only breakpoint '
                      '(@media (max-width: 600px), inclusive).',
                ),
                DocsApiFact(
                  name: 'DsToaster.visibleLimit (static)',
                  type: 'int',
                  description:
                      '3 -- at most this many toasts are painted at once '
                      '(sonner\'s VISIBLE_TOASTS_AMOUNT); anything past '
                      'the third waits its turn with its clock unstarted.',
                ),
                DocsApiFact(
                  name: 'DsToaster.lifetime (static)',
                  type: 'Duration',
                  description:
                      'Duration(seconds: 4) -- 4000ms. Sonner\'s '
                      'TOAST_LIFETIME, and DsToastMessage.duration\'s own '
                      'default.',
                ),
                DocsApiFact(
                  name: 'DsToaster.unmountDelay (static)',
                  type: 'Duration',
                  description:
                      'Duration(milliseconds: 200) -- 200ms. How long a '
                      'dismissed toast stays mounted after '
                      'DsToastController.dismiss before it is actually '
                      'removed (sonner\'s TIME_BEFORE_UNMOUNT); every exit '
                      'transition runs longer than this, so every one is '
                      'cut off partway.',
                ),
                DocsApiFact(
                  name: 'DsToaster.transition (static)',
                  type: 'Duration',
                  description:
                      'Duration(milliseconds: 400) -- 400ms. The window '
                      'the entrance, the collapse, the expand, and two of '
                      'the three exits all ride.',
                ),
                DocsApiFact(
                  name: 'DsToaster.collapsedExitTransform (static)',
                  type: 'Duration',
                  description:
                      'Duration(milliseconds: 500) -- 500ms. The transform '
                      'half of a back toast\'s collapsed exit; its opacity '
                      'half is unmountDelay\'s 200ms.',
                ),
                DocsApiFact(
                  name: 'DsToaster.swipeOutDuration (static)',
                  type: 'Duration',
                  description:
                      'Duration(milliseconds: 200) -- 200ms. The '
                      'thrown-away animation once a swipe clears the '
                      'threshold.',
                ),
                DocsApiFact(
                  name: 'DsToaster.swipeThreshold (static)',
                  type: 'double',
                  description:
                      '45 -- a swipe must travel this many px (or clear '
                      'swipeVelocity) to dismiss; short of it, the toast '
                      'snaps back with no transition at all.',
                ),
                DocsApiFact(
                  name: 'DsToaster.swipeVelocity (static)',
                  type: 'double',
                  description:
                      '110 -- the release-velocity gate, in px per second '
                      '(sonner\'s 0.11 px/ms).',
                ),
                DocsApiFact(
                  name: 'DsToaster.stackScaleStep (static)',
                  type: 'double',
                  description:
                      '0.05 -- each collapsed back toast scales down by '
                      'one more of these (1 minus 0.05 times its index).',
                ),
                DocsApiFact(
                  name: 'DsToaster.collapsedExitTravel (static)',
                  type: 'double',
                  description:
                      '0.40 -- how far, as a fraction of its own box, a '
                      'back toast in a collapsed stack falls on its way '
                      'out.',
                ),
                DocsApiFact(
                  name: 'DsToaster.isCompact (static)',
                  type: 'bool Function(double viewportWidth)',
                  description:
                      'Whether a viewport this wide takes the compact, '
                      'top-anchored treatment.',
                ),
                DocsApiFact(
                  name: 'DsToaster.positionFor (static)',
                  type: 'DsToastPosition Function(DsToastPosition, double)',
                  description:
                      'The resolved corner for a viewport this wide -- '
                      'position itself above mobileBreakpoint, its '
                      'topAnchored twin at or below it.',
                ),
                DocsApiFact(
                  name: 'DsToaster.offsetFor (static)',
                  type: 'double Function(double viewportWidth)',
                  description:
                      'viewportOffset or mobileViewportOffset, whichever '
                      'this width takes.',
                ),
                DocsApiFact(
                  name: 'DsToaster.widthFor (static)',
                  type: 'double Function(double viewportWidth)',
                  description:
                      '356, or the full compact width minus two '
                      'mobileViewportOffset insets, never negative.',
                ),
                DocsApiFact(
                  name: 'DsToaster.paddingFor (static)',
                  type:
                      'EdgeInsets Function(double, EdgeInsets, '
                      'DsToastPosition)',
                  description:
                      'offsetFor on every edge, plus '
                      'MediaQueryData.padding on the one edge the stack '
                      'is actually anchored to.',
                ),
                DocsApiFact(
                  name: 'DsToaster.dampen (static)',
                  type: 'double Function(double delta)',
                  description:
                      'The drag dampening applied against the corner\'s '
                      'own two directions: delta / (1.5 + |delta| / 20).',
                ),
              ],
            ),
            SizedBox(height: ds(8)),
            const DocsApiTable(
              title: 'DsToastController -- the imperative API ("toast(...)")',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'show',
                  type: 'int Function(DsToastMessage message)',
                  description:
                      'Queues message and returns its id -- the one '
                      'primitive every typed helper below calls.',
                ),
                DocsApiFact(
                  name: 'success',
                  type:
                      'int Function(String title, {String? description, '
                      'DsIconGlyph? glyph, DsToastAction? action})',
                  description: 'toast.success(title).',
                ),
                DocsApiFact(
                  name: 'error',
                  type:
                      'int Function(String title, {String? description, '
                      'DsIconGlyph? glyph, DsToastAction? action})',
                  description: 'toast.error(title).',
                ),
                DocsApiFact(
                  name: 'info',
                  type:
                      'int Function(String title, {String? description, '
                      'DsIconGlyph? glyph, DsToastAction? action})',
                  description: 'toast.info(title).',
                ),
                DocsApiFact(
                  name: 'warning',
                  type:
                      'int Function(String title, {String? description, '
                      'DsIconGlyph? glyph, DsToastAction? action})',
                  description: 'toast.warning(title).',
                ),
                DocsApiFact(
                  name: 'loading',
                  type:
                      'int Function(String title, {String? description, '
                      'DsIconGlyph? glyph, DsToastAction? action})',
                  description:
                      'toast.loading(title) -- the one call that leaves a '
                      'toast on screen indefinitely, with no clock. '
                      'Dismiss it, or settle it with promise or settle.',
                ),
                DocsApiFact(
                  name: 'promise',
                  type:
                      'int Function<T>(Future<T> future, {required '
                      'String loading, required String success, required '
                      'String error, String? loadingDescription, String? '
                      'successDescription, String? errorDescription})',
                  description:
                      'Shows the loading message immediately and swaps '
                      'the settled one into the SAME toast when future '
                      'completes -- same id, same box, same position in '
                      'the stack, no exit and no second entrance. The '
                      '4000ms clock only starts once it has settled, '
                      'because a loading toast has none.',
                ),
                DocsApiFact(
                  name: 'settle',
                  type: 'void Function(int id, DsToastMessage next)',
                  description:
                      'Replaces a live toast\'s message in place, the way '
                      'promise does. A no-op once the toast has gone.',
                ),
                DocsApiFact(
                  name: 'dismiss',
                  type: 'void Function(int id)',
                  description:
                      'toast.dismiss(id) -- starts the 200ms unmount '
                      'window (DsToaster.unmountDelay).',
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
            SizedBox(height: ds(8)),
            const DocsApiTable(
              title: 'DsToastMessage -- one queued toast (constructor)',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'title',
                  type: 'String',
                  description:
                      'Required. The only thing every toast carries, and '
                      'the accessible label a screen reader announces -- '
                      'see Accessibility.',
                ),
                DocsApiFact(
                  name: 'description',
                  type: 'String?',
                  description:
                      'Optional, defaults to null. A second line under '
                      'the title, in the muted-foreground color.',
                ),
                DocsApiFact(
                  name: 'type',
                  type: 'DsToastType',
                  description:
                      'Optional, defaults to DsToastType.normal. Selects '
                      'the icon, its ink color, and the bloom\'s two '
                      'stops -- see Variants.',
                ),
                DocsApiFact(
                  name: 'glyph',
                  type: 'DsIconGlyph?',
                  description:
                      'Optional, defaults to null. Overrides type\'s own '
                      'icon -- a different glyph on a typed toast, or any '
                      'glyph at all on an untyped one.',
                ),
                DocsApiFact(
                  name: 'duration',
                  type: 'Duration',
                  description:
                      'Optional, defaults to DsToaster.lifetime '
                      '(Duration(seconds: 4), 4000ms). Ignored entirely '
                      'while type is DsToastType.loading, which has no '
                      'clock.',
                ),
                DocsApiFact(
                  name: 'promise',
                  type: 'bool',
                  description:
                      'Optional, defaults to false. Set for every state '
                      'of a DsToastController.promise toast, loading and '
                      'settled alike -- what turns its glyph swap into a '
                      'cross-fade instead of a cut.',
                ),
                DocsApiFact(
                  name: 'action',
                  type: 'DsToastAction?',
                  description:
                      'Optional, defaults to null. The action pill at the '
                      'far right of the row.',
                ),
              ],
            ),
            SizedBox(height: ds(8)),
            const DocsApiTable(
              title: 'DsToastAction -- the optional action pill (constructor)',
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
                      'dismisses right after, whether or not this is '
                      'null.',
                ),
              ],
            ),
          ],
        ),
      ),

      // 10. Variants and sizes -- DsToastType is the variant axis DsAlert's
      // DsAlertVariant plays for alert.
      DsSection(
        id: 'variants',
        title: 'Variants',
        description:
            'Six DsToastType values (five typed, one default), each '
            'selecting an icon glyph, an ink color, and the bloom\'s two '
            'stops -- the card fill, border, radius and padding never '
            'change. DsToaster has no size axis; every toast is '
            'DsToaster.width (356px) wide on a wide viewport.',
        child: const DocsApiTable(
          title: 'DsToastType',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'success',
              type: 'DsToastType',
              description:
                  'data-type="success". Icon: DsIconGlyph.circleCheck. '
                  'Ink: theme.successInk. Bloom: --color-success / '
                  '--color-value.',
            ),
            DocsApiFact(
              name: 'info',
              type: 'DsToastType',
              description:
                  'data-type="info". Icon: DsIconGlyph.info. Ink: '
                  'theme.infoInk.',
            ),
            DocsApiFact(
              name: 'warning',
              type: 'DsToastType',
              description:
                  'data-type="warning". Icon: DsIconGlyph.alertTriangle. '
                  'Ink: theme.warningInk. Its bloom pair '
                  '(DsBloomCosmic.toastWarning) is the one variant that '
                  'does not match DsAlert\'s own warning bloom.',
            ),
            DocsApiFact(
              name: 'error',
              type: 'DsToastType',
              description:
                  'data-type="error". Icon: DsIconGlyph.octagonX. Ink: '
                  'theme.destructiveInk.',
            ),
            DocsApiFact(
              name: 'loading',
              type: 'DsToastType',
              description:
                  'data-type="loading". Icon: DsIconGlyph.loaderCircle, '
                  'and it does not spin -- the source ships it with no '
                  'spin animation, confirmed against the live reference '
                  'too. The one type with no auto-dismiss clock at all.',
            ),
            DocsApiFact(
              name: 'normal',
              type: 'DsToastType',
              description:
                  'The default (label reads "default" -- default is a '
                  'Dart keyword). No data-type attribute is ever set, and '
                  'no icon slot renders at all unless the message '
                  'supplies its own glyph -- TOAST_ICONS has no default '
                  'key on the reference either.',
            ),
          ],
        ),
      ),

      // 11. States and feedback.
      DsSection(
        id: 'states',
        title: 'States and feedback',
        description:
            'Unlike DsAlert, DsToaster is not purely presentational -- it '
            'owns a lifetime clock, a hover-pause, and a swipe gesture. '
            'Rows that do not apply are marked N/A with the reason.',
        child: const DocsStateMatrix(
          facts: <DocsStateFact>[
            DocsStateFact(
              state: 'Rest',
              treatment:
                  'A queued toast enters over DsToaster.transition '
                  '(400ms) and its 4000ms auto-dismiss clock '
                  '(DsToaster.lifetime) starts the moment it becomes one '
                  'of the DsToaster.visibleLimit (3) visible toasts -- a '
                  'queued fourth toast does not count down while it '
                  'waits.',
              userSignal:
                  'The stack collapses to a scaled, blanked silhouette '
                  'behind the front toast; only the front one is legible.',
            ),
            DocsStateFact(
              state: 'Hover',
              treatment:
                  'Hovering anywhere over the stack expands every toast '
                  'to its own natural height and pauses every visible '
                  'toast\'s clock at whatever time remains -- not a '
                  'restart. Leaving resumes from that remainder.',
              userSignal:
                  'Content fades back in on every toast, not only the '
                  'one under the pointer, because the whole stack expands '
                  'together.',
            ),
            DocsStateFact(
              state: 'Focus-visible',
              treatment:
                  'N/A -- no toast, and no part of it, requests focus; '
                  'nothing in toaster.dart calls FocusScope or '
                  'FocusNode.requestFocus.',
              userSignal: 'Whatever the user was doing keeps its own focus.',
            ),
            DocsStateFact(
              state: 'Pressed',
              treatment:
                  'A tap anywhere on the toast body dismisses it '
                  'immediately (the port\'s own addition -- sonner itself '
                  'has no tap-to-dismiss). A drag past '
                  'DsToaster.swipeThreshold (45px) or DsToaster.'
                  'swipeVelocity throws it out on the swiped axis; short '
                  'of that it snaps back with no transition at all.',
              userSignal:
                  'The action pill, when present, runs its own '
                  'onPressed first and dismisses the toast right after -- '
                  'whether or not onPressed is null.',
            ),
            DocsStateFact(
              state: 'Selected',
              treatment: 'N/A -- a toast is not a selectable item.',
              userSignal: 'Not applicable.',
            ),
            DocsStateFact(
              state: 'Loading',
              treatment:
                  'DsToastType.loading is the one type with no clock at '
                  'all -- it stays on screen until DsToastController.'
                  'dismiss, or until promise / settle replaces it in '
                  'place.',
              userSignal:
                  'Its glyph (DsIconGlyph.loaderCircle) holds still -- '
                  'the source ships it with no spin animation.',
            ),
            DocsStateFact(
              state: 'Empty',
              treatment:
                  'N/A -- title is a required, non-null String on '
                  'DsToastMessage; there is no contentless toast to '
                  'render.',
              userSignal: 'Not applicable.',
            ),
            DocsStateFact(
              state: 'Error / Success',
              treatment:
                  'A compile-time type choice (DsToastType.error / '
                  '.success on DsToastMessage), not a runtime transition '
                  'on the same toast -- unless DsToastController.promise '
                  'or settle swaps one type into the other in place.',
              userSignal:
                  'Icon glyph, its ink color, and the bloom\'s two stops '
                  'change; the card fill, border and text color never do.',
            ),
            DocsStateFact(
              state: 'Disabled',
              treatment:
                  'N/A on the toast body -- nothing here is a form '
                  'control. DsToastAction.onPressed is itself nullable; '
                  'the pill still dismisses the toast when pressed even '
                  'when it is null.',
              userSignal: 'Not applicable.',
            ),
            DocsStateFact(
              state: 'Reduced motion',
              treatment:
                  'Every transition above collapses to its final frame '
                  'immediately, but the 4000ms auto-dismiss clock is not '
                  'gated on it -- sonner\'s own reduced-motion block '
                  'removes transitions, not timers, so a reduced-motion '
                  'toast still expires on its own real schedule.',
              userSignal:
                  'A toast appears already at its resting position and '
                  'opacity, with no visible entrance, and still clears '
                  'itself on schedule.',
            ),
          ],
        ),
      ),

      // 12. Accessibility and keyboard behavior.
      DsSection(
        id: 'a11y',
        title: 'Accessibility and keyboard behavior',
        child: const _LabeledFacts(<(String, String)>[
          (
            'Semantic role',
            'Semantics(container: true, liveRegion: true, label: '
                'message.title) wraps the whole toast surface -- a '
                'live-region announcement with no separate aria-live or '
                'aria-atomic attribute to reason about. It does announce, '
                'and it never steals focus while doing it -- see Focus '
                'behavior below.',
          ),
          (
            'Required labels',
            'title is the only required accessible content. container: '
                'true makes this node a semantics boundary, and the '
                'title/description DsText children below it are not '
                'boundaries of their own, so their literal text merges '
                'upward into this one node rather than staying separate -- '
                'verified on this page\'s own live-specimen test: the '
                'announced SemanticsNode.label for a titled-and-described '
                'toast reads the explicit label, then the title again, '
                'then the description, in that order. The title is '
                'effectively announced twice.',
          ),
          (
            'Keyboard interactions',
            'None. The toast body has no FocusNode, and the action '
                'pill -- rendered by hand rather than as a real DsButton, '
                'because sonner renders [data-button] itself -- wires '
                'only a MouseRegion and a GestureDetector, with no Focus '
                'or onKeyEvent of its own. A toast\'s action cannot '
                'currently be reached or pressed from a keyboard; that '
                'is a real gap, stated plainly rather than assumed away.',
          ),
          (
            'Focus behavior',
            'A toast never requests focus on mount or on entry -- '
                'nothing in toaster.dart calls FocusScope or '
                'FocusNode.requestFocus -- so it never interrupts '
                'whatever the user was doing, unlike a dialog.',
          ),
          (
            'Touch target',
            'The toast body\'s own dismiss-on-tap region is the whole '
                '356px-wide card. The action pill\'s own box is 32px '
                'tall, under the common 44px touch-target guideline.',
          ),
          (
            'Non-color signals',
            'Every typed toast (success / info / warning / error / '
                'loading) pairs its ink color with a distinct icon glyph '
                'and with the title/description text, so meaning never '
                'rides on hue alone. The untyped default carries no icon '
                'slot at all, so an untyped toast\'s only signal is its '
                'text.',
          ),
          (
            'Error wiring',
            'N/A -- no form-field validation hookup; a toast states an '
                'outcome after the fact, it does not validate a field.',
          ),
          (
            'Screen-reader announcements',
            'liveRegion: true asks the platform accessibility service '
                'to announce the toast when it mounts -- confirmed on '
                'this page\'s own live-specimen test via '
                'flagsCollection.isLiveRegion. The announced content is not '
                'just the title: it is the explicit label merged with '
                'every literal Text descendant beneath it (see Required '
                'labels above), so a described toast is heard as its '
                'title, its title again, then its description.',
          ),
          (
            'Known platform differences',
            'Live-region announcement timing is the platform '
                'accessibility service\'s call (TalkBack, VoiceOver, web '
                'ARIA), not something this widget schedules -- the same '
                'disclaimer DsAlert\'s own page states for its '
                'role="alert" region.',
          ),
        ]),
      ),

      // 13. Responsive/platform behavior.
      DsSection(
        id: 'responsive',
        title: 'Responsive and platform behavior',
        child: const _Prose(<String>[
          'DsToaster.position (default DsToastPosition.bottomRight) '
              'chooses the corner only on a wide viewport. At or below '
              'DsToaster.mobileBreakpoint (600px, inclusive -- a '
              'max-width query) the stack always re-anchors to the top '
              'edge, keeping the side it was on -- a deliberate '
              'departure the source states plainly: sonner\'s own live '
              'app never repositions its toaster on mobile at all, so '
              'the compact top anchor is a design order here, not '
              'something measured off the reference.',
          'Going compact also widens every toast: width drops from the '
              'fixed DsToaster.width (356px) to the full viewport minus '
              'two DsToaster.mobileViewportOffset (16px) insets, '
              'replacing the wide viewport\'s DsToaster.viewportOffset '
              '(24px) on every edge at once.',
          'The anchored edge additionally pays MediaQueryData.padding '
              'on top of that inset (DsToaster.paddingFor), so a '
              'top-anchored compact stack clears a phone\'s status bar '
              'and a bottom-anchored one clears its gesture bar; the '
              'other three edges keep the un-padded number, since the '
              'stack never reaches them. This page\'s own live specimen '
              'demonstrates the swap directly -- compare it at 390x844 '
              'against 1440x900.',
        ]),
      ),

      // 14. Dependencies, files, assets, fonts, and shaders.
      DsSection(
        id: 'dependencies',
        title: 'Dependencies, files, assets, fonts, and shaders',
        child: const DocsInstallFacts(
          title: 'Source dependencies',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Files',
              value: 'lib/src/components/toaster.dart',
              description:
                  'One file; every public class -- DsToaster, DsToast, '
                  'DsToastController, DsToastMessage, DsToastAction, '
                  'DsToastType, DsToastPosition -- lives here.',
            ),
            DocsInstallFact(
              label: 'Package imports',
              value:
                  'dart:async, dart:math, effects/bloom_cosmic.dart, '
                  'effects/machine_surface.dart, foundation/colors.dart, '
                  'foundation/motion.dart, foundation/shadows.dart, '
                  'foundation/spacing.dart, foundation/theme.dart, '
                  'foundation/typography.dart, theme_scope.dart, '
                  'ds_safe_area.dart, icon.dart, icon_paths.dart',
              description:
                  'DsBloomCosmic paints the fill and its idle/hover/'
                  'starfield animation; DsMachineSurface paints the '
                  'border and the e3 shadow; DsSafeArea supplies the '
                  'system-bar insets the compact anchor pays.',
            ),
            DocsInstallFact(
              label: 'Registry dependencies',
              value: 'none declared -- toaster has no registry manifest yet',
              description:
                  'A real registry/components/toaster.json is a later '
                  'pass; see Installation above.',
            ),
            DocsInstallFact(
              label: 'Assets, fonts, shaders',
              value: 'none',
              description:
                  'The bloom paints with dart:ui gradients '
                  '(Paint.shader from a RadialGradient), not a compiled '
                  'fragment shader -- no asset declaration is needed in '
                  'pubspec.yaml.',
            ),
          ],
        ),
      ),

      // 15. Composition examples.
      DsSection(
        id: 'composition',
        title: 'Composition examples',
        description:
            'A realistic sequence -- an optimistic save, then a typed '
            'result -- fired from a handler that holds the same '
            'controller DsToaster is mounted with.',
        child: DsPanel(
          label: 'DART',
          note: 'A SAVE FLOW',
          child: const DocsSelectableCodeBlock(code: _compositionCode),
        ),
      ),

      // 16. Theming notes.
      DsSection(
        id: 'theming',
        title: 'Theming notes',
        child: const _Prose(<String>[
          'Every toast shares one card surface -- the same --popover '
              'fill, the same 1px border, the same e3 shadow -- and a '
              'type spends exactly the same one token pair DsAlert\'s own '
              'variants do: the icon\'s ink color and the bloom\'s two '
              'stops, both read from DsThemeData. Title and description '
              'colors never move with type; only the glyph does.',
          'Flip DsThemeController between light and dark and every '
              'visible toast\'s ink and bloom follow the active theme '
              'immediately -- nothing on this page opts out, matching '
              'DsAlert\'s own theming note.',
        ]),
      ),

      // 17. Source, tests, report issue, and edit docs.
      DsSection(
        id: 'source',
        title: 'Source, tests, and reporting an issue',
        child: DocsInstallFacts(
          title: 'Source facts',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Source',
              value: toasterDoc.sourcePath,
              description:
                  'The authoritative implementation this page documents.',
            ),
            const DocsInstallFact(
              label: 'Package tests',
              value: 'test/feedback_effects_test.dart',
              description:
                  'Exercises DsToaster\'s full choreography directly -- '
                  'the stack collapse, the hover-expand, all three exits, '
                  'the swipe gesture, and the timers -- rasterized and '
                  'geometry-checked, not just mounted. This documentation '
                  'page\'s own specimen and metadata tests are additional '
                  'coverage focused on the imperative API surface and the '
                  'live-region announcement.',
            ),
            const DocsInstallFact(
              label: 'Report an issue / edit these docs',
              value: 'N/A -- not wired up',
              description:
                  'The public site has no issue-tracker or edit-this-page '
                  'link mounted yet, so nothing here would resolve; '
                  'stated honestly rather than pointed at a URL that '
                  'does not exist.',
            ),
          ],
        ),
      ),
      // 18. Previous/Next component navigation is DocsLayout's own chrome
      // (see the `previous` argument above).
    ],
  );
}

/// A real [DsToastController], fired into by real controls, over a real
/// [DsToaster] -- mounted the same `Positioned.fill` inside a `Stack` way
/// `site_shell.dart`'s `SiteShell` and `showcase_app.dart`'s
/// `SignalStudioApp` both mount it. Owns and disposes its own controller
/// rather than reaching into the site's shared `siteToasts` singleton, so
/// this specimen never leaks a toast onto another page.
class _ToasterPreview extends StatefulWidget {
  const _ToasterPreview();

  @override
  State<_ToasterPreview> createState() => _ToasterPreviewState();
}

class _ToasterPreviewState extends State<_ToasterPreview> {
  final DsToastController _controller = DsToastController();

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
        spacing: ds(3),
        runSpacing: ds(3),
        children: <Widget>[
          DsButton(
            variant: DsButtonVariant.secondary,
            size: DsButtonSize.sm,
            onPressed: () => _controller.success(
              'Changes saved',
              description: 'Your profile was updated successfully.',
            ),
            child: const Text('Show success'),
          ),
          DsButton(
            variant: DsButtonVariant.secondary,
            size: DsButtonSize.sm,
            onPressed: () => _controller.error(
              'Payment failed',
              description: 'We could not process your card ending in 4242.',
              action: DsToastAction(label: 'Retry', onPressed: () {}),
            ),
            child: const Text('Show error + action'),
          ),
          DsButton(
            variant: DsButtonVariant.secondary,
            size: DsButtonSize.sm,
            onPressed: () => _controller.info(
              'New feature available',
              description: 'The command palette is now available via Cmd+K.',
            ),
            child: const Text('Show info'),
          ),
          DsButton(
            variant: DsButtonVariant.secondary,
            size: DsButtonSize.sm,
            onPressed: () => _controller.warning(
              'Withdrawal under review',
              description:
                  'Large withdrawals are held for a security review '
                  'before they clear.',
            ),
            child: const Text('Show warning'),
          ),
          DsButton(
            variant: DsButtonVariant.secondary,
            size: DsButtonSize.sm,
            onPressed: () => _controller.promise<void>(
              Future<void>.delayed(const Duration(milliseconds: 1200)),
              loading: 'Saving…',
              success: 'Saved',
              error: 'Could not save',
            ),
            child: const Text('Show promise'),
          ),
          DsButton(
            variant: DsButtonVariant.outline,
            size: DsButtonSize.sm,
            onPressed: _controller.clear,
            child: const Text('Clear all'),
          ),
        ],
      ),
      SizedBox(height: ds(6)),
      SizedBox(
        height: ds(105),
        child: Stack(
          children: <Widget>[
            Positioned.fill(child: DsToaster(controller: _controller)),
          ],
        ),
      ),
    ],
  );
}

/// Left-aligned paragraphs, constrained to the article's prose measure.
class _Prose extends StatelessWidget {
  const _Prose(this.paragraphs);

  final List<String> paragraphs;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: DsWidths.prose),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (int i = 0; i < paragraphs.length; i++) ...<Widget>[
          if (i > 0) SizedBox(height: ds(4)),
          DsText(paragraphs[i], DsType.body),
        ],
      ],
    ),
  );
}

/// A label/value list for accessibility-style facts that don't fit
/// [DocsApiFact]'s (name, type, description) shape.
class _LabeledFacts extends StatelessWidget {
  const _LabeledFacts(this.entries);

  final List<(String, String)> entries;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: DsWidths.prose),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (int i = 0; i < entries.length; i++) ...<Widget>[
          if (i > 0) SizedBox(height: ds(4)),
          DsText(entries[i].$1, DsType.label),
          SizedBox(height: ds(1)),
          DsText(entries[i].$2, DsType.body),
        ],
      ],
    ),
  );
}

const String _previewCode = '''
final DsToastController controller = DsToastController();

// Mounted once, near the app root:
Stack(
  children: [
    // ...the rest of the app...
    Positioned.fill(child: DsToaster(controller: controller)),
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
  action: DsToastAction(label: 'Retry', onPressed: retry),
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
    '''final DsToastController toasts = DsToastController();

// Mounted once, near the app root:
Positioned.fill(child: DsToaster(controller: toasts))

// Fired from anywhere that holds `toasts`:
toasts.success('Changes saved');''';

const String _actionUsageCode = '''toasts.error(
  'Payment failed',
  description: 'We could not process your card ending in 4242.',
  action: DsToastAction(label: 'Retry', onPressed: retryPayment),
);

toasts.promise<void>(
  saveProfile(),
  loading: 'Saving…',
  success: 'Saved',
  error: 'Could not save',
);''';

const String _compositionCode =
    '''Future<void> handleSave(DsToastController toasts) async {
  final int id = toasts.loading('Saving…');
  try {
    await saveProfile();
    toasts.settle(id, const DsToastMessage(
      title: 'Saved',
      type: DsToastType.success,
      promise: true,
    ));
  } catch (_) {
    toasts.settle(id, const DsToastMessage(
      title: 'Could not save',
      type: DsToastType.error,
      promise: true,
    ));
  }
}''';
