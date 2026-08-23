/// Public component documentation for the alert component.
///
/// Follows `docs/superpowers/plans/2026-08-21-public-website-ui-information-
/// architecture.md` §9.1's eighteen-section template, composed from the
/// Phase C docs primitives (`docs_layout.dart`, `docs_code.dart`,
/// `docs_facts.dart`, `kit.dart`'s `DsSection`/`DsPanel`) the same way
/// `dialog_page.dart` does. Every usage example below is real Dart against
/// [DsAlert]'s actual constructor — nothing here manufactures a shadcn
/// example the Dart API does not support.
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
    breadcrumbs: const <DsBreadcrumbEntry>[
      DsBreadcrumbEntry.link('Components'),
      DsBreadcrumbEntry.page('Alert'),
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
      // 4. Expanded purpose and decision guidance.
      DsSection(
        id: 'purpose',
        title: 'Purpose and when to use it',
        description:
            'A condition worth explaining, not a question and not a '
            'one-off confirmation.',
        child: const _Prose(<String>[
          'DsAlert renders an inline, persistent region on the page '
              'itself: role="alert" on the reference, Semantics(container: '
              'true, liveRegion: true) here. No scrim, no auto-dismiss, no '
              'portal. It stays exactly where it is mounted until whatever '
              'renders it removes it -- the caller owns its lifetime, '
              'DsAlert has none of its own.',
          'Reach for an alert dialog instead when the situation blocks '
              'the page and demands one answer before the user can '
              'continue -- a confirmation, an irreversible action. It '
              'shares DsDialogContent\'s own panel and its scrim; DsAlert '
              'has neither.',
          'Reach for a toaster (DsToaster) instead when the message is '
              'transient -- it announces once near a screen corner and '
              'clears itself on a timer. DsAlert never times out and '
              'never floats; it lays out like any other block in the '
              'page\'s own flow.',
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
                  'Ships in the package today; elattar add alert is not '
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
                  'Pure flutter/widgets.dart and dart:ui -- no platform '
                  'channel, so every Flutter target renders it '
                  'identically.',
            ),
          ],
        ),
      ),

      // 6. Primary live specimen with Preview/Code tabs.
      DsSection(
        id: 'preview',
        title: 'Preview',
        description:
            'One card surface, five variants -- the destructive specimen '
            'also carries an action.',
        child: DocsCodeExample(
          title: 'Live specimen',
          description:
              'Every DsAlertVariant value, in the reference\'s own '
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
      ),

      // 7. Installation with Command/Manual tabs.
      DsSection(
        id: 'install',
        title: 'Installation',
        description:
            'alert has no registry/components/alert.json manifest yet, so '
            'elattar add alert is not yet available -- copy the source '
            'file directly until that manifest lands.',
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
              note: 'WITH AN ICON, A VARIANT, AND AN ACTION',
              child: const DocsSelectableCodeBlock(code: _actionUsageCode),
            ),
          ],
        ),
      ),

      // 9. API reference.
      DsSection(
        id: 'api',
        title: 'API reference',
        description:
            'Every DsAlert constructor parameter and static member, read '
            'directly from lib/src/components/alert.dart.',
        child: const DocsApiTable(
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
                  'Optional, defaults to null. When null, the gap-1 row '
                  'and the muted description block do not render at all.',
            ),
            DocsApiFact(
              name: 'icon',
              type: 'Widget?',
              description:
                  'Optional, defaults to null. The leading size-4 glyph, '
                  'recolored by variant through the surrounding '
                  'DefaultTextStyle. DsAlert does not choose an icon for a '
                  'variant -- the caller supplies one, or none.',
            ),
            DocsApiFact(
              name: 'action',
              type: 'Widget?',
              description:
                  'Optional, defaults to null. Positioned 8px from the '
                  'top and right of the border box. Its presence also '
                  'switches the base\'s right padding from 16px to a '
                  'fixed 80px lane, unconditionally.',
            ),
            DocsApiFact(
              name: 'variant',
              type: 'DsAlertVariant',
              description:
                  'Optional, defaults to DsAlertVariant.normal. Selects '
                  'the icon ink color and the --bloom-1/--bloom-2 pair; '
                  'fill, border, radius, and padding never change.',
            ),
            DocsApiFact(
              name: 'DsAlert.actionInset (static)',
              type: 'double',
              description:
                  'ds(2) -- the 8px offset the action slot sits from the '
                  'border box on both axes.',
            ),
            DocsApiFact(
              name: 'DsAlert.actionLane (static)',
              type: 'double',
              description:
                  'ds(20) -- the fixed 80px right-padding lane substituted '
                  'for the base 16px whenever action is non-null.',
            ),
          ],
        ),
      ),

      // 10. Variants and sizes.
      DsSection(
        id: 'variants',
        title: 'Variants',
        description:
            'Five cva variants, in the reference\'s own declaration order. '
            'Each sets exactly three things -- the icon ink color and the '
            'two bloom stops -- and nothing else in the surface moves. '
            'DsAlert has no size axis of its own; it fills whatever width '
            'its parent gives it.',
        child: const DocsApiTable(
          title: 'DsAlertVariant',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'normal',
              type: 'DsAlertVariant',
              description:
                  'cva key "default" (the label getter renames it -- '
                  'default is a Dart keyword). Ink: theme.mutedForeground. '
                  'Bloom: --color-action-bright / --color-action.',
            ),
            DocsApiFact(
              name: 'destructive',
              type: 'DsAlertVariant',
              description:
                  'Ink: theme.destructiveInk. Bloom: theme.destructive / '
                  '--color-action.',
            ),
            DocsApiFact(
              name: 'success',
              type: 'DsAlertVariant',
              description:
                  'Ink: theme.successInk. Bloom: --color-success / '
                  '--color-value.',
            ),
            DocsApiFact(
              name: 'warning',
              type: 'DsAlertVariant',
              description:
                  'Ink: theme.warningInk. Bloom: --color-warning / '
                  '--color-action.',
            ),
            DocsApiFact(
              name: 'info',
              type: 'DsAlertVariant',
              description:
                  'Ink: theme.infoInk. Bloom: --color-info / '
                  '--color-action.',
            ),
          ],
        ),
      ),

      // 11. States and feedback.
      DsSection(
        id: 'states',
        title: 'States and feedback',
        description:
            'DsAlert is a synchronous, presentational primitive -- it '
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
                  'N/A -- DsAlert has no MouseRegion, FocusNode, or '
                  'GestureDetector of its own.',
              userSignal:
                  'A widget mounted in the action slot carries its own '
                  'hover, focus, and press states independently; DsAlert '
                  'does not style them.',
            ),
            DocsStateFact(
              state: 'Loading',
              treatment:
                  'N/A -- DsAlert is synchronous and presentational; it '
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
                  'A compile-time variant choice (DsAlertVariant), not a '
                  'runtime transition -- see Variants above.',
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
                  'DsBloomCosmic settles its drift, hover swell, and '
                  'starfield to their resting frame under '
                  'MediaQuery.disableAnimations.',
              userSignal: 'Fill, border, ink, and text are unaffected.',
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
                'DsButton) carries its own Tab stop and its own '
                'Enter/Space activation; DsAlert neither adds nor removes '
                'it.',
          ),
          (
            'Focus behavior',
            'DsAlert never requests focus on mount, unlike a dialog -- it '
                'does not interrupt whatever the user was doing.',
          ),
          (
            'Touch target',
            'N/A for the alert body itself. The action slot inherits '
                'whatever touch target its own widget defines -- DsAlert '
                'does not resize it.',
          ),
          (
            'Non-color signals',
            'Every specimen on this page pairs its variant\'s ink color '
                'with a distinct icon glyph and with title/description '
                'text, so meaning never rides on hue alone -- but that is '
                'the caller\'s discipline, not something DsAlert enforces: '
                'icon is an arbitrary optional Widget?, not derived from '
                'variant.',
          ),
          (
            'Error wiring',
            'N/A -- DsAlert has no form-field validation hookup; that is '
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

      // 13. Responsive/platform behavior.
      DsSection(
        id: 'responsive',
        title: 'Responsive and platform behavior',
        child: const _Prose(<String>[
          'DsAlert has no breakpoint logic of its own -- its width is '
              'whatever its parent gives it, and title/description text '
              'simply wraps to more lines as that width shrinks.',
          'The one width-sensitive detail is DsAlert.actionLane: when '
              'action is present, the right padding is a fixed 80px lane, '
              'applied unconditionally rather than sized to the button, '
              'so the same alert can wrap its description column '
              'differently at different container widths purely because '
              'the lane always reserves the same space.',
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
              value: 'lib/src/components/alert.dart',
              description:
                  'One file; DsAlert and DsAlertVariant both live here.',
            ),
            DocsInstallFact(
              label: 'Package imports',
              value:
                  'effects/bloom_cosmic.dart, foundation/spacing.dart, '
                  'foundation/theme.dart, foundation/typography.dart, '
                  'theme_scope.dart',
              description:
                  'DsBloomCosmic paints the fill and its idle animation; '
                  'the rest are the shared spacing, theme, typography, '
                  'and theme-mode primitives every component reads.',
            ),
            DocsInstallFact(
              label: 'Registry dependencies',
              value: 'none declared -- alert has no registry manifest yet',
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

      // 15. Composition examples.
      DsSection(
        id: 'composition',
        title: 'Composition examples',
        description:
            'Stacking more than one alert reads as a list of conditions, '
            'not a traffic light, because every variant shares the same '
            'card fill -- only the icon and the bloom move.',
        child: DsPanel(
          label: 'DART',
          note: 'STACKED IN A REVIEW FLOW',
          child: const DocsSelectableCodeBlock(code: _compositionCode),
        ),
      ),

      // 16. Theming notes.
      DsSection(
        id: 'theming',
        title: 'Theming notes',
        child: const _Prose(<String>[
          'Every variant renders the same border, the same --card fill, '
              'and the same text color; a variant spends exactly one '
              'token pair -- the icon ink (theme.mutedForeground, '
              'destructiveInk, successInk, warningInk, or infoInk) and '
              'the bloom\'s two stops (--bloom-1 / --bloom-2) -- both '
              'read from DsThemeData rather than hardcoded.',
          'That is a deliberate reversal of tinting the whole card: five '
              'differently-tinted cards stacked on a page read as a '
              'traffic light rather than as one component, and body text '
              'is the least legible place to spend a hue. Flip '
              'DsThemeController between light and dark and every '
              'variant\'s ink and bloom follow the active theme '
              'automatically -- nothing on this page opts out.',
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
              value: alertDoc.sourcePath,
              description:
                  'The authoritative implementation this page documents.',
            ),
            const DocsInstallFact(
              label: 'Package tests',
              value: 'none yet',
              description:
                  'No test in the root package exercises DsAlert '
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
      // 18. Previous/Next component navigation is DocsLayout's own chrome
      // (see the `previous`/`next` arguments above).
    ],
  );
}

/// Every [DsAlertVariant] value, in the reference's own declaration order --
/// the same specimen the "Manual" tab's [_previewCode] reproduces.
class _AlertPreview extends StatelessWidget {
  const _AlertPreview();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DsAlert(
        icon: DsIcon(DsIconGlyph.bell),
        title: 'Heads up',
        description: 'You can revert this later from Settings → Preferences.',
      ),
      SizedBox(height: ds(4)),
      DsAlert(
        variant: DsAlertVariant.destructive,
        icon: const DsIcon(DsIconGlyph.circleX),
        title: 'Payment failed',
        description: 'We could not process your card ending in 4242.',
        action: DsButton(
          variant: DsButtonVariant.secondary,
          size: DsButtonSize.sm,
          onPressed: () {},
          child: const Text('Retry'),
        ),
      ),
      SizedBox(height: ds(4)),
      const DsAlert(
        variant: DsAlertVariant.success,
        icon: DsIcon(DsIconGlyph.circleCheck),
        title: 'Changes saved',
        description: 'Your profile was updated successfully.',
      ),
      SizedBox(height: ds(4)),
      const DsAlert(
        variant: DsAlertVariant.warning,
        icon: DsIcon(DsIconGlyph.alertTriangle),
        title: 'Withdrawal under review',
        description:
            'Large withdrawals are held for a security review before '
            'they clear.',
      ),
      SizedBox(height: ds(4)),
      const DsAlert(
        variant: DsAlertVariant.info,
        icon: DsIcon(DsIconGlyph.info),
        title: 'New feature available',
        description: 'The command palette is now available via Cmd+K.',
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
DsAlert(
  icon: const DsIcon(DsIconGlyph.bell),
  title: 'Heads up',
  description: 'You can revert this later from Settings → Preferences.',
)

DsAlert(
  variant: DsAlertVariant.destructive,
  icon: const DsIcon(DsIconGlyph.circleX),
  title: 'Payment failed',
  description: 'We could not process your card ending in 4242.',
  action: DsButton(
    variant: DsButtonVariant.secondary,
    size: DsButtonSize.sm,
    onPressed: () {},
    child: const Text('Retry'),
  ),
)

DsAlert(
  variant: DsAlertVariant.success,
  icon: const DsIcon(DsIconGlyph.circleCheck),
  title: 'Changes saved',
  description: 'Your profile was updated successfully.',
)

DsAlert(
  variant: DsAlertVariant.warning,
  icon: const DsIcon(DsIconGlyph.alertTriangle),
  title: 'Withdrawal under review',
  description: 'Large withdrawals are held for a security review before they clear.',
)

DsAlert(
  variant: DsAlertVariant.info,
  icon: const DsIcon(DsIconGlyph.info),
  title: 'New feature available',
  description: 'The command palette is now available via Cmd+K.',
)
''';

const String _smallestUsageCode = '''DsAlert(
  title: 'Heads up',
)''';

const String _actionUsageCode = '''DsAlert(
  variant: DsAlertVariant.destructive,
  icon: const DsIcon(DsIconGlyph.circleX),
  title: 'Payment failed',
  description: 'We could not process your card ending in 4242.',
  action: DsButton(
    variant: DsButtonVariant.secondary,
    size: DsButtonSize.sm,
    onPressed: () {},
    child: const Text('Retry'),
  ),
)''';

const String _compositionCode = '''Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: <Widget>[
    DsAlert(
      variant: DsAlertVariant.warning,
      icon: const DsIcon(DsIconGlyph.alertTriangle),
      title: 'Withdrawal under review',
      description: 'Large withdrawals are held for a security review before they clear.',
    ),
    SizedBox(height: ds(4)),
    DsAlert(
      variant: DsAlertVariant.info,
      icon: const DsIcon(DsIconGlyph.info),
      title: 'New feature available',
      description: 'The command palette is now available via Cmd+K.',
    ),
  ],
)''';
