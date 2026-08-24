/// Public component documentation for the alert component.
///
/// Reshaped to the shadcn parity frame (Phase J supervisor's shadcn-parity
/// pass): the reader knows https://ui.shadcn.com/docs/components/base/alert
/// and finds the same answers, in the same order, on this page. That page's
/// own top-level examples are Basic, Destructive, Action, Custom Colors, and
/// RTL, none of them grouped under one "Variants" heading, so this page
/// mirrors that shape instead of the single API-table "Variants" section an
/// earlier draft used. Custom Colors has no counterpart here: ElAlert has no
/// style-override hook, only [ElAlertVariant] -- see the Custom colors note
/// inside API reference below for why that section is skipped rather than
/// faked.
/// Composed from the Phase C docs primitives (`docs_layout.dart`,
/// `docs_code.dart`, `docs_facts.dart`, `kit.dart`'s `ElSection`/`ElPanel`)
/// the same way `dialog_page.dart` does. Every usage example below is real
/// Dart against [ElAlert]'s actual constructor: nothing here manufactures a
/// shadcn example the Dart API does not support.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

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
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Alert'),
    ],
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Installation', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'Composition', anchor: 'composition'),
      DocsTocEntry(title: 'Basic', anchor: 'basic'),
      DocsTocEntry(title: 'Destructive', anchor: 'destructive'),
      DocsTocEntry(title: 'Action', anchor: 'action'),
      DocsTocEntry(title: 'Success', anchor: 'success'),
      DocsTocEntry(title: 'Warning', anchor: 'warning'),
      DocsTocEntry(title: 'Info', anchor: 'info'),
      DocsTocEntry(title: 'Stacked alerts', anchor: 'stacked-alerts'),
      DocsTocEntry(title: 'RTL', anchor: 'rtl'),
      DocsTocEntry(title: 'API Reference', anchor: 'api'),
      DocsTocEntry(title: 'States', anchor: 'states'),
      DocsTocEntry(title: 'Accessibility', anchor: 'a11y'),
      DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
      DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
      DocsTocEntry(title: 'Theming', anchor: 'theming'),
      DocsTocEntry(title: 'Source', anchor: 'source'),
    ],
    previous: const DocsPageLink(
      title: 'Accordion',
      route: '/components/accordion',
    ),
    next: const DocsPageLink(title: 'Avatar', route: '/components/avatar'),
    onNavigate: onNavigate,
    child: const _AlertArticle(),
  );
}

class _AlertArticle extends StatelessWidget {
  const _AlertArticle();

  @override
  Widget build(BuildContext context) => Column(
    key: const ValueKey<String>('alert-doc-article'),
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      // Ours only: expanded purpose and decision guidance. shadcn's own
      // alert page carries no equivalent -- added in our own house style
      // rather than dropped, per the parity brief's "ours only" allowance.
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: ElWidths.prose),
        child: ElText(
          'A condition worth explaining, not a question and not a '
          'one-off confirmation.',
          ElType.body,
        ),
      ),
      SizedBox(height: el(6)),
      const _Prose(<String>[
        'ElAlert renders an inline, persistent region on the page '
            'itself: role="alert" on the reference, Semantics(container: '
            'true, liveRegion: true) here. No scrim, no auto-dismiss, no '
            'portal. It stays exactly where it is mounted until whatever '
            'renders it removes it -- the caller owns its lifetime, '
            'ElAlert has none of its own.',
        'Reach for an alert dialog instead when the situation blocks '
            'the page and demands one answer before the user can '
            'continue -- a confirmation, an irreversible action. It '
            'shares ElDialogContent\'s own panel and its scrim; ElAlert '
            'has neither.',
        'Reach for a toaster (ElToaster) instead when the message is '
            'transient -- it announces once near a screen corner and '
            'clears itself on a timer. ElAlert never times out and '
            'never floats; it lays out like any other block in the '
            'page\'s own flow.',
      ]),

      // Ours only: status/version/platform metadata.
      const DocsInstallFacts(
        title: 'Status facts',
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Status',
            value: 'Registry install available',
            description:
                'Ships in the package today; elattar add alert is not '
                'wired up yet -- see Installation below.',
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
                'Pure flutter/widgets.dart and dart:ui -- no platform '
                'channel, so every Flutter target renders it '
                'identically.',
          ),
        ],
      ),

      // shadcn: the live demo that opens the page, before any heading.
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: ElWidths.prose),
        child: ElText(
          'One card surface, five variants -- the destructive specimen '
          'also carries an action. Each variant gets its own dedicated '
          'specimen further down.',
          ElType.body,
        ),
      ),
      SizedBox(height: el(6)),
      DocsCodeExample(
        title: 'Live specimen',
        description:
            'Every ElAlertVariant value, in the reference\'s own '
            'declaration order.',
        preview: const _AlertPreview(),
        manualFiles: const <DocsCodeFile>[
          DocsCodeFile(
            path: 'preview.dart',
            title: 'Specimen source',
            description: 'The exact Dart that produced the preview above.',
            code: _previewCode,
          ),
        ],
      ),

      // shadcn: Installation, Command and Manual tabs.
      ElSection(
        id: 'install',
        title: 'Installation',
        description:
            'alert ships in the registry, so `elattar add alert` installs it '
            'and everything it depends on. Copying the source by hand still '
            'works if you would rather not add the CLI.',
        child: DocsCodeExample(
          title: 'Manual installation',
          description:
              'Copy the component source into your project; its relative '
              'imports resolve once the file sits beside the rest of the '
              'package foundation.',
          manualFiles: <DocsCodeFile>[
            DocsCodeFile(
              path: alertDoc.sourcePath,
              title: 'lib/components/ui/alert.dart',
              description:
                  'Paste the full alert.dart source here; its imports '
                  '(effects/bloom_cosmic.dart, foundation/*, '
                  'theme_scope.dart) resolve once the file sits beside the '
                  'rest of components/ui.',
              code:
                  "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
                  '// Copy the generated alert.dart payload here. No CLI item\n'
                  '// exists for alert yet -- see the Status panel above.',
            ),
          ],
        ),
      ),

      // shadcn: Usage -- imports plus basic construction.
      ElSection(
        id: 'usage',
        title: 'Usage',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElPanel(
              label: 'DART',
              note: 'SMALLEST CORRECT EXAMPLE',
              child: const DocsSelectableCodeBlock(code: _smallestUsageCode),
            ),
            SizedBox(height: el(5)),
            ElPanel(
              label: 'DART',
              note: 'WITH AN ICON, A VARIANT, AND AN ACTION',
              child: const DocsSelectableCodeBlock(code: _actionUsageCode),
            ),
          ],
        ),
      ),

      // shadcn: Composition -- the widget-hierarchy tree. ElAlert is one
      // widget with four optional-content slots, not a family of separate
      // subcomponents the way Icon/AlertTitle/AlertDescription/AlertAction
      // are on the reference; this is that same anatomy read off the one
      // constructor instead of off four JSX tags.
      ElSection(
        id: 'composition',
        title: 'Composition',
        description:
            'ElAlert folds Icon, AlertTitle, AlertDescription, and '
            'AlertAction into four constructor slots on one widget, '
            'rather than four composable subcomponents.',
        child: ElPanel(
          label: 'DART',
          note: 'ANATOMY',
          child: const DocsSelectableCodeBlock(code: _compositionAnatomyCode),
        ),
      ),

      // shadcn: Basic -- the default variant, icon + title + description.
      ElSection(
        id: 'basic',
        title: 'Basic',
        description:
            'ElAlertVariant.normal, the constructor\'s own default: an '
            'icon, a title, and a description.',
        child: DocsCodeExample(
          title: 'Basic',
          preview: const Center(child: _BasicPreview()),
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(
              path: 'alert_basic.dart',
              title: 'Basic',
              code: _basicCode,
            ),
          ],
        ),
      ),

      // shadcn: Destructive -- the error-styled variant, no action.
      ElSection(
        id: 'destructive',
        title: 'Destructive',
        description:
            'ElAlertVariant.destructive on its own: compare with Action '
            'below, which adds an action slot on top of the same variant.',
        child: DocsCodeExample(
          title: 'Destructive',
          preview: const Center(child: _DestructivePreview()),
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(
              path: 'alert_destructive.dart',
              title: 'Destructive',
              code: _destructiveCode,
            ),
          ],
        ),
      ),

      // shadcn: Action -- an interactive element positioned in the alert.
      ElSection(
        id: 'action',
        title: 'Action',
        description:
            'The action slot sits 8px from the top and right of the '
            'border box, and it always reserves an 80px-wide right lane '
            'once action is non-null -- unconditionally, whether or not a '
            'button of that size would actually have collided with the '
            'text (supervisor ruling F10).',
        child: DocsCodeExample(
          title: 'Action',
          preview: const Center(child: _ActionPreview()),
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(
              path: 'alert_action.dart',
              title: 'Action',
              code: _actionCode,
            ),
          ],
        ),
      ),

      // Ours only: ElAlertVariant.success has no counterpart example on the
      // reference page, which only demos default and destructive by name.
      ElSection(
        id: 'success',
        title: 'Success',
        description:
            'ElAlertVariant.success, for a confirmation that already '
            'happened.',
        child: DocsCodeExample(
          title: 'Success',
          preview: const Center(child: _SuccessPreview()),
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(
              path: 'alert_success.dart',
              title: 'Success',
              code: _successCode,
            ),
          ],
        ),
      ),

      // Ours only: ElAlertVariant.warning.
      ElSection(
        id: 'warning',
        title: 'Warning',
        description:
            'ElAlertVariant.warning, for a condition that needs attention '
            'but has not failed outright.',
        child: DocsCodeExample(
          title: 'Warning',
          preview: const Center(child: _WarningPreview()),
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(
              path: 'alert_warning.dart',
              title: 'Warning',
              code: _warningCode,
            ),
          ],
        ),
      ),

      // Ours only: ElAlertVariant.info.
      ElSection(
        id: 'info',
        title: 'Info',
        description: 'ElAlertVariant.info, for a low-stakes announcement.',
        child: DocsCodeExample(
          title: 'Info',
          preview: const Center(child: _InfoPreview()),
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(
              path: 'alert_info.dart',
              title: 'Info',
              code: _infoCode,
            ),
          ],
        ),
      ),

      // Ours only: stacking more than one alert. No counterpart section on
      // the reference page.
      ElSection(
        id: 'stacked-alerts',
        title: 'Stacked alerts',
        description:
            'Stacking more than one alert reads as a list of conditions, '
            'not a traffic light, because every variant shares the same '
            'card fill -- only the icon and the bloom move.',
        child: ElPanel(
          label: 'DART',
          note: 'STACKED IN A REVIEW FLOW',
          child: const DocsSelectableCodeBlock(code: _stackedCode),
        ),
      ),

      // shadcn: RTL.
      ElSection(
        id: 'rtl',
        title: 'RTL',
        description:
            'ElAlert reads Directionality.of(context) the way any Row '
            'does, so the icon and text column swap sides under RTL. '
            'DOCUMENTED DRIFT: the padding (EdgeInsets.fromLTRB) and the '
            'action slot\'s Positioned(top, right) are both physical, not '
            'directional -- unlike the reference\'s logical pr-20 / '
            'top-2 right-2 CSS, neither one mirrors to the left edge '
            'under RTL.',
        child: DocsCodeExample(
          title: 'RTL',
          preview: const Center(child: _RtlPreview()),
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(path: 'alert_rtl.dart', title: 'RTL', code: _rtlCode),
          ],
        ),
      ),

      // shadcn: API Reference -- one prop table per class in the family.
      // ElAlert has no separate AlertTitle/AlertDescription/AlertAction
      // classes to give their own tables to, so the two tables here are
      // ElAlert's own constructor/statics and the ElAlertVariant enum.
      ElSection(
        id: 'api',
        title: 'API reference',
        description:
            'Every ElAlert constructor parameter and static member, and '
            'every ElAlertVariant value, read directly from '
            'lib/src/components/alert.dart.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const DocsApiTable(
              title: 'ElAlert',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'title',
                  type: 'String',
                  description:
                      'Required. The AlertTitle text, column 2, '
                      'font-medium.',
                ),
                DocsApiFact(
                  name: 'description',
                  type: 'String?',
                  description:
                      'Optional, defaults to null. When null, the gap-1 '
                      'row and the muted description block do not render '
                      'at all.',
                ),
                DocsApiFact(
                  name: 'icon',
                  type: 'Widget?',
                  description:
                      'Optional, defaults to null. The leading size-4 '
                      'glyph, recolored by variant through the '
                      'surrounding DefaultTextStyle. ElAlert does not '
                      'choose an icon for a variant -- the caller '
                      'supplies one, or none.',
                ),
                DocsApiFact(
                  name: 'action',
                  type: 'Widget?',
                  description:
                      'Optional, defaults to null. Positioned 8px from '
                      'the top and right of the border box. Its presence '
                      'also switches the base\'s right padding from 16px '
                      'to a fixed 80px lane, unconditionally.',
                ),
                DocsApiFact(
                  name: 'variant',
                  type: 'ElAlertVariant',
                  description:
                      'Optional, defaults to ElAlertVariant.normal. '
                      'Selects the icon ink color and the '
                      '--bloom-1/--bloom-2 pair; fill, border, radius, '
                      'and padding never change.',
                ),
                DocsApiFact(
                  name: 'ElAlert.actionInset (static)',
                  type: 'double',
                  description:
                      'el(2) -- the 8px offset the action slot sits from '
                      'the border box on both axes.',
                ),
                DocsApiFact(
                  name: 'ElAlert.actionLane (static)',
                  type: 'double',
                  description:
                      'el(20) -- the fixed 80px right-padding lane '
                      'substituted for the base 16px whenever action is '
                      'non-null.',
                ),
              ],
            ),
            SizedBox(height: el(6)),
            const DocsApiTable(
              title: 'ElAlertVariant',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'normal',
                  type: 'ElAlertVariant',
                  description:
                      'cva key "default" (the label getter renames it -- '
                      'default is a Dart keyword). Ink: '
                      'theme.mutedForeground. Bloom: '
                      '--color-action-bright / --color-action.',
                ),
                DocsApiFact(
                  name: 'destructive',
                  type: 'ElAlertVariant',
                  description:
                      'Ink: theme.destructiveInk. Bloom: '
                      'theme.destructive / --color-action.',
                ),
                DocsApiFact(
                  name: 'success',
                  type: 'ElAlertVariant',
                  description:
                      'Ink: theme.successInk. Bloom: --color-success / '
                      '--color-value.',
                ),
                DocsApiFact(
                  name: 'warning',
                  type: 'ElAlertVariant',
                  description:
                      'Ink: theme.warningInk. Bloom: --color-warning / '
                      '--color-action.',
                ),
                DocsApiFact(
                  name: 'info',
                  type: 'ElAlertVariant',
                  description:
                      'Ink: theme.infoInk. Bloom: --color-info / '
                      '--color-action.',
                ),
              ],
            ),
            SizedBox(height: el(4)),
            ElPanel(
              label: 'CUSTOM COLORS',
              note: 'SKIPPED',
              child: const _Prose(<String>[
                'The reference\'s Custom Colors example overrides an '
                    'alert\'s classes directly to swap in an ad hoc '
                    'palette. ElAlert has no equivalent hook: its only '
                    'color control point is variant, which selects one of '
                    'five predetermined ink/bloom pairs from ElThemeData '
                    'rather than accepting an arbitrary Color. Faking a '
                    'freeform override here would document a capability '
                    'this widget does not have, so this section is '
                    'skipped rather than approximated with another '
                    'variant swatch.',
              ]),
            ),
          ],
        ),
      ),

      // Ours: States and feedback.
      ElSection(
        id: 'states',
        title: 'States and feedback',
        description:
            'ElAlert is a synchronous, presentational primitive -- it '
            'holds no internal state and listens to no gestures. Rows '
            'that do not apply are marked N/A with the reason, rather '
            'than inventing asynchronous behavior for a synchronous '
            'widget.',
        child: const DocsStateMatrix(
          facts: <DocsStateFact>[
            DocsStateFact(
              state: 'Rest',
              treatment:
                  'Bordered card, one shared fill across every variant; '
                  'the bloom runs its idle drift.',
              userSignal: 'Icon ink and bloom color name the variant.',
            ),
            DocsStateFact(
              state: 'Hover / Focus-visible / Pressed / Selected',
              treatment:
                  'N/A -- ElAlert has no MouseRegion, FocusNode, or '
                  'GestureDetector of its own.',
              userSignal:
                  'A widget mounted in the action slot carries its own '
                  'hover, focus, and press states independently; ElAlert '
                  'does not style them.',
            ),
            DocsStateFact(
              state: 'Loading',
              treatment:
                  'N/A -- ElAlert is synchronous and presentational; it '
                  'has no loading affordance to invent.',
              userSignal: 'Not applicable.',
            ),
            DocsStateFact(
              state: 'Empty',
              treatment:
                  'N/A -- title is a required constructor parameter, so '
                  'there is no valid contentless alert to render.',
              userSignal: 'Not applicable.',
            ),
            DocsStateFact(
              state: 'Error / Success / Warning / Info',
              treatment:
                  'A compile-time variant choice (ElAlertVariant), not a '
                  'runtime transition -- see Basic, Destructive, Success, '
                  'Warning, and Info above.',
              userSignal:
                  'The caller re-renders with a different variant value.',
            ),
            DocsStateFact(
              state: 'Disabled',
              treatment:
                  'N/A on the alert body -- there is no interactive '
                  'affordance to disable. A widget in the action slot can '
                  'disable itself (for example onPressed: null) '
                  'independently.',
              userSignal: 'Not applicable.',
            ),
            DocsStateFact(
              state: 'Reduced motion',
              treatment:
                  'ElBloomCosmic settles its drift, hover swell, and '
                  'starfield to their resting frame under '
                  'MediaQuery.disableAnimations.',
              userSignal: 'Fill, border, ink, and text are unaffected.',
            ),
          ],
        ),
      ),

      // Ours: Accessibility and keyboard behavior.
      ElSection(
        id: 'a11y',
        title: 'Accessibility and keyboard behavior',
        child: const _LabeledFacts(<(String, String)>[
          (
            'Semantic role',
            'Semantics(container: true, liveRegion: true) wraps the whole '
                'surface -- the same assertive-live-region announcement '
                'role="alert" gives implicitly on the reference, with no '
                'separate aria-live or aria-atomic attribute needed.',
          ),
          (
            'Required labels',
            'title is the only required accessible content; it renders '
                'as real text, so it is read by default without an '
                'explicit label override.',
          ),
          (
            'Keyboard interactions',
            'None on the alert body -- it holds no FocusNode. When '
                'action is supplied, that child widget (for example '
                'ElButton) carries its own Tab stop and its own '
                'Enter/Space activation; ElAlert neither adds nor removes '
                'it.',
          ),
          (
            'Focus behavior',
            'ElAlert never requests focus on mount, unlike a dialog -- it '
                'does not interrupt whatever the user was doing.',
          ),
          (
            'Touch target',
            'N/A for the alert body itself. The action slot inherits '
                'whatever touch target its own widget defines -- ElAlert '
                'does not resize it.',
          ),
          (
            'Non-color signals',
            'Every specimen on this page pairs its variant\'s ink color '
                'with a distinct icon glyph and with title/description '
                'text, so meaning never rides on hue alone -- but that is '
                'the caller\'s discipline, not something ElAlert enforces: '
                'icon is an arbitrary optional Widget?, not derived from '
                'variant.',
          ),
          (
            'Error wiring',
            'N/A -- ElAlert has no form-field validation hookup; that is '
                'a field.dart concern. An alert is how a page states a '
                'condition, not how a field reports one.',
          ),
          (
            'Screen-reader announcements',
            'liveRegion: true asks the platform accessibility service to '
                'announce the alert\'s text when it first mounts.',
          ),
          (
            'Known platform differences',
            'Live-region announcement timing is the platform '
                'accessibility service\'s call (TalkBack, VoiceOver, web '
                'ARIA), not something this widget schedules -- there is '
                'no cross-platform timing guarantee to promise here.',
          ),
        ]),
      ),

      // Ours: Responsive/platform behavior.
      ElSection(
        id: 'responsive',
        title: 'Responsive and platform behavior',
        child: const _Prose(<String>[
          'ElAlert has no breakpoint logic of its own -- its width is '
              'whatever its parent gives it, and title/description text '
              'simply wraps to more lines as that width shrinks.',
          'The one width-sensitive detail is ElAlert.actionLane: when '
              'action is present, the right padding is a fixed 80px lane, '
              'applied unconditionally rather than sized to the button, '
              'so the same alert can wrap its description column '
              'differently at different container widths purely because '
              'the lane always reserves the same space.',
        ]),
      ),

      // Ours: Dependencies, files, assets, fonts, and shaders.
      ElSection(
        id: 'dependencies',
        title: 'Dependencies, files, assets, fonts, and shaders',
        child: const DocsInstallFacts(
          title: 'Source dependencies',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Files',
              value: 'lib/src/components/alert.dart',
              description:
                  'One file; ElAlert and ElAlertVariant both live here.',
            ),
            DocsInstallFact(
              label: 'Package imports',
              value:
                  'effects/bloom_cosmic.dart, foundation/spacing.dart, '
                  'foundation/theme.dart, foundation/typography.dart, '
                  'theme_scope.dart',
              description:
                  'ElBloomCosmic paints the fill and its idle animation; '
                  'the rest are the shared spacing, theme, typography, '
                  'and theme-mode primitives every component reads.',
            ),
            DocsInstallFact(
              label: 'Registry dependencies',
              value: 'none declared -- alert ships in the registry',
              description:
                  'A real registry/components/alert.json is a later '
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

      // Ours: Theming notes.
      ElSection(
        id: 'theming',
        title: 'Theming notes',
        child: const _Prose(<String>[
          'Every variant renders the same border, the same --card fill, '
              'and the same text color; a variant spends exactly one '
              'token pair -- the icon ink (theme.mutedForeground, '
              'destructiveInk, successInk, warningInk, or infoInk) and '
              'the bloom\'s two stops (--bloom-1 / --bloom-2) -- both '
              'read from ElThemeData rather than hardcoded.',
          'That is a deliberate reversal of tinting the whole card: five '
              'differently-tinted cards stacked on a page read as a '
              'traffic light rather than as one component, and body text '
              'is the least legible place to spend a hue. Flip '
              'ElThemeController between light and dark and every '
              'variant\'s ink and bloom follow the active theme '
              'automatically -- nothing on this page opts out.',
        ]),
      ),

      // Ours: Source, tests, report issue, and edit docs.
      ElSection(
        id: 'source',
        title: 'Source, tests, and reporting an issue',
        child: DocsInstallFacts(
          title: 'Source facts',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Source',
              value: alertDoc.sourcePath,
              description:
                  'The authoritative implementation this page documents.',
            ),
            const DocsInstallFact(
              label: 'Package tests',
              value: 'none yet',
              description:
                  'No test in the root package exercises ElAlert '
                  'directly today; this documentation page\'s own '
                  'specimen-mount test is the only coverage that '
                  'currently exists.',
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
      // Previous/Next component navigation is DocsLayout's own chrome
      // (see the `previous`/`next` arguments above).
    ],
  );
}

/// Every [ElAlertVariant] value, in the reference's own declaration order --
/// the same specimen the "Manual" tab's [_previewCode] reproduces.
class _AlertPreview extends StatelessWidget {
  const _AlertPreview();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const ElAlert(
        icon: ElIcon(ElIconGlyph.bell),
        title: 'Heads up',
        description: 'You can revert this later from Settings → Preferences.',
      ),
      SizedBox(height: el(4)),
      ElAlert(
        variant: ElAlertVariant.destructive,
        icon: const ElIcon(ElIconGlyph.circleX),
        title: 'Payment failed',
        description: 'We could not process your card ending in 4242.',
        action: ElButton(
          variant: ElButtonVariant.secondary,
          size: ElButtonSize.sm,
          onPressed: () {},
          child: const Text('Retry'),
        ),
      ),
      SizedBox(height: el(4)),
      const ElAlert(
        variant: ElAlertVariant.success,
        icon: ElIcon(ElIconGlyph.circleCheck),
        title: 'Changes saved',
        description: 'Your profile was updated successfully.',
      ),
      SizedBox(height: el(4)),
      const ElAlert(
        variant: ElAlertVariant.warning,
        icon: ElIcon(ElIconGlyph.alertTriangle),
        title: 'Withdrawal under review',
        description:
            'Large withdrawals are held for a security review before '
            'they clear.',
      ),
      SizedBox(height: el(4)),
      const ElAlert(
        variant: ElAlertVariant.info,
        icon: ElIcon(ElIconGlyph.info),
        title: 'New feature available',
        description: 'The command palette is now available via Cmd+K.',
      ),
    ],
  );
}

/// The Basic section's own specimen: [ElAlertVariant.normal], carried
/// verbatim from [_AlertPreview]'s first entry.
class _BasicPreview extends StatelessWidget {
  const _BasicPreview();

  @override
  Widget build(BuildContext context) => const ElAlert(
    icon: ElIcon(ElIconGlyph.bell),
    title: 'Heads up',
    description: 'You can revert this later from Settings → Preferences.',
  );
}

/// The Destructive section's own specimen: [ElAlertVariant.destructive]
/// with no action slot, so it reads distinctly from Action below.
class _DestructivePreview extends StatelessWidget {
  const _DestructivePreview();

  @override
  Widget build(BuildContext context) => const ElAlert(
    variant: ElAlertVariant.destructive,
    icon: ElIcon(ElIconGlyph.circleX),
    title: 'Payment failed',
    description: 'We could not process your card ending in 4242.',
  );
}

/// The Action section's own specimen: carried verbatim from
/// [_AlertPreview]'s destructive-plus-action entry.
class _ActionPreview extends StatelessWidget {
  const _ActionPreview();

  @override
  Widget build(BuildContext context) => ElAlert(
    variant: ElAlertVariant.destructive,
    icon: const ElIcon(ElIconGlyph.circleX),
    title: 'Payment failed',
    description: 'We could not process your card ending in 4242.',
    action: ElButton(
      variant: ElButtonVariant.secondary,
      size: ElButtonSize.sm,
      onPressed: () {},
      child: const Text('Retry'),
    ),
  );
}

/// The Success section's own specimen, carried verbatim from
/// [_AlertPreview].
class _SuccessPreview extends StatelessWidget {
  const _SuccessPreview();

  @override
  Widget build(BuildContext context) => const ElAlert(
    variant: ElAlertVariant.success,
    icon: ElIcon(ElIconGlyph.circleCheck),
    title: 'Changes saved',
    description: 'Your profile was updated successfully.',
  );
}

/// The Warning section's own specimen, carried verbatim from
/// [_AlertPreview].
class _WarningPreview extends StatelessWidget {
  const _WarningPreview();

  @override
  Widget build(BuildContext context) => const ElAlert(
    variant: ElAlertVariant.warning,
    icon: ElIcon(ElIconGlyph.alertTriangle),
    title: 'Withdrawal under review',
    description:
        'Large withdrawals are held for a security review before they '
        'clear.',
  );
}

/// The Info section's own specimen, carried verbatim from [_AlertPreview].
class _InfoPreview extends StatelessWidget {
  const _InfoPreview();

  @override
  Widget build(BuildContext context) => const ElAlert(
    variant: ElAlertVariant.info,
    icon: ElIcon(ElIconGlyph.info),
    title: 'New feature available',
    description: 'The command palette is now available via Cmd+K.',
  );
}

/// The RTL section's own specimen: the same two alerts [_AlertPreview]
/// already carries, wrapped in a right-to-left [Directionality] so the row
/// flip is real and live, not merely described.
class _RtlPreview extends StatelessWidget {
  const _RtlPreview();

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const ElAlert(
          icon: ElIcon(ElIconGlyph.bell),
          title: 'تنبيه',
          description: 'يمكنك التراجع عن هذا لاحقًا من الإعدادات.',
        ),
        SizedBox(height: el(4)),
        ElAlert(
          variant: ElAlertVariant.destructive,
          icon: const ElIcon(ElIconGlyph.circleX),
          title: 'فشل الدفع',
          description: 'تعذر معالجة بطاقتك المنتهية بـ 4242.',
          action: ElButton(
            variant: ElButtonVariant.secondary,
            size: ElButtonSize.sm,
            onPressed: () {},
            child: const Text('إعادة المحاولة'),
          ),
        ),
      ],
    ),
  );
}

/// Left-aligned paragraphs, constrained to the article's prose measure.
class _Prose extends StatelessWidget {
  const _Prose(this.paragraphs);

  final List<String> paragraphs;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: ElWidths.prose),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (int i = 0; i < paragraphs.length; i++) ...<Widget>[
          if (i > 0) SizedBox(height: el(4)),
          ElText(paragraphs[i], ElType.body),
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
    constraints: const BoxConstraints(maxWidth: ElWidths.prose),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (int i = 0; i < entries.length; i++) ...<Widget>[
          if (i > 0) SizedBox(height: el(4)),
          ElText(entries[i].$1, ElType.label),
          SizedBox(height: el(1)),
          ElText(entries[i].$2, ElType.body),
        ],
      ],
    ),
  );
}

const String _previewCode = '''
ElAlert(
  icon: const ElIcon(ElIconGlyph.bell),
  title: 'Heads up',
  description: 'You can revert this later from Settings → Preferences.',
)

ElAlert(
  variant: ElAlertVariant.destructive,
  icon: const ElIcon(ElIconGlyph.circleX),
  title: 'Payment failed',
  description: 'We could not process your card ending in 4242.',
  action: ElButton(
    variant: ElButtonVariant.secondary,
    size: ElButtonSize.sm,
    onPressed: () {},
    child: const Text('Retry'),
  ),
)

ElAlert(
  variant: ElAlertVariant.success,
  icon: const ElIcon(ElIconGlyph.circleCheck),
  title: 'Changes saved',
  description: 'Your profile was updated successfully.',
)

ElAlert(
  variant: ElAlertVariant.warning,
  icon: const ElIcon(ElIconGlyph.alertTriangle),
  title: 'Withdrawal under review',
  description: 'Large withdrawals are held for a security review before they clear.',
)

ElAlert(
  variant: ElAlertVariant.info,
  icon: const ElIcon(ElIconGlyph.info),
  title: 'New feature available',
  description: 'The command palette is now available via Cmd+K.',
)
''';

const String _smallestUsageCode = '''ElAlert(
  title: 'Heads up',
)''';

const String _actionUsageCode = '''ElAlert(
  variant: ElAlertVariant.destructive,
  icon: const ElIcon(ElIconGlyph.circleX),
  title: 'Payment failed',
  description: 'We could not process your card ending in 4242.',
  action: ElButton(
    variant: ElButtonVariant.secondary,
    size: ElButtonSize.sm,
    onPressed: () {},
    child: const Text('Retry'),
  ),
)''';

const String _compositionAnatomyCode = '''ElAlert(
  icon: ...,          // optional leading glyph, size-4, recolored by variant
  title: '...',       // required -- the only field with no default
  description: '...', // optional, the row omits itself entirely when null
  action: ...,        // optional trailing slot, pinned top-right
  variant: ElAlertVariant.normal, // selects icon ink + the two bloom stops only
)''';

const String _basicCode = '''ElAlert(
  icon: const ElIcon(ElIconGlyph.bell),
  title: 'Heads up',
  description: 'You can revert this later from Settings → Preferences.',
)''';

const String _destructiveCode = '''ElAlert(
  variant: ElAlertVariant.destructive,
  icon: const ElIcon(ElIconGlyph.circleX),
  title: 'Payment failed',
  description: 'We could not process your card ending in 4242.',
)''';

const String _actionCode = '''ElAlert(
  variant: ElAlertVariant.destructive,
  icon: const ElIcon(ElIconGlyph.circleX),
  title: 'Payment failed',
  description: 'We could not process your card ending in 4242.',
  action: ElButton(
    variant: ElButtonVariant.secondary,
    size: ElButtonSize.sm,
    onPressed: () {},
    child: const Text('Retry'),
  ),
)''';

const String _successCode = '''ElAlert(
  variant: ElAlertVariant.success,
  icon: const ElIcon(ElIconGlyph.circleCheck),
  title: 'Changes saved',
  description: 'Your profile was updated successfully.',
)''';

const String _warningCode = '''ElAlert(
  variant: ElAlertVariant.warning,
  icon: const ElIcon(ElIconGlyph.alertTriangle),
  title: 'Withdrawal under review',
  description: 'Large withdrawals are held for a security review before they clear.',
)''';

const String _infoCode = '''ElAlert(
  variant: ElAlertVariant.info,
  icon: const ElIcon(ElIconGlyph.info),
  title: 'New feature available',
  description: 'The command palette is now available via Cmd+K.',
)''';

const String _stackedCode = '''Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: <Widget>[
    ElAlert(
      variant: ElAlertVariant.warning,
      icon: const ElIcon(ElIconGlyph.alertTriangle),
      title: 'Withdrawal under review',
      description: 'Large withdrawals are held for a security review before they clear.',
    ),
    SizedBox(height: el(4)),
    ElAlert(
      variant: ElAlertVariant.info,
      icon: const ElIcon(ElIconGlyph.info),
      title: 'New feature available',
      description: 'The command palette is now available via Cmd+K.',
    ),
  ],
)''';

const String _rtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: ElAlert(
    icon: const ElIcon(ElIconGlyph.bell),
    title: 'تنبيه',
    description: 'يمكنك التراجع عن هذا لاحقًا من الإعدادات.',
  ),
)''';
