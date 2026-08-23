/// Public documentation page for the `collapsible` component —
/// `lib/src/components/collapsible.dart`'s [DsCollapsible] and the shared
/// [DsUnfold] expand/collapse animation it mounts.
///
/// Structured after IA §9.1's eighteen-section template
/// (`docs/superpowers/plans/2026-08-21-public-website-ui-information-
/// architecture.md`), the same way `dialog_page.dart` composes it: a
/// [DocsLayout] shell around a column of [DsSection]s, each self-registering
/// its own scroll anchor.
///
/// Two sections the template names are folded rather than given their own
/// anchor, and both say why in their own copy rather than only in a code
/// comment:
/// * **Variants and sizes** — `DsCollapsible` declares no variant or size
///   enum, so the note lives inside Overview instead of standing alone.
/// * **Status/version/platform metadata** — folded into Install, next to the
///   CLI fact it has to sit beside anyway (there is no working
///   `elattar add collapsible` yet — see that section's own note).
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import '../catalog.dart' show ComponentDocEntry;
import 'meta.dart';

class CollapsibleDocPage extends StatelessWidget {
  const CollapsibleDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    final ComponentDocEntry entry = collapsibleDoc;
    return DocsLayout(
      route: entry.route,
      intro: DocsPageIntro(
        eyebrow: 'COMPONENTS / BASE',
        title: entry.title,
        description:
            'One independent disclosure: a trigger and the panel it shows or '
            'hides, with no relationship to anything else on the page. Reach '
            'for Accordion instead when several related disclosures need to '
            'behave as one coordinated set — a FAQ where opening a question '
            'can close the one before it. Reach for Collapsible for a single '
            'section that opens and closes entirely on its own, such as an '
            'advanced-filters panel tucked under a toolbar.',
      ),
      breadcrumbs: const <DsBreadcrumbEntry>[
        DsBreadcrumbEntry.link('Components'),
        DsBreadcrumbEntry.page('Collapsible'),
      ],
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Overview', anchor: 'overview'),
        DocsTocEntry(title: 'Preview', anchor: 'preview'),
        DocsTocEntry(title: 'Install', anchor: 'install'),
        DocsTocEntry(title: 'Usage', anchor: 'usage'),
        DocsTocEntry(title: 'API', anchor: 'api'),
        DocsTocEntry(title: 'States', anchor: 'states'),
        DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
        DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
        DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
        DocsTocEntry(title: 'Composition', anchor: 'composition'),
        DocsTocEntry(title: 'Theming', anchor: 'theming'),
      ],
      previous: const DocsPageLink(
        title: 'Select',
        route: '/components/select',
      ),
      onNavigate: onNavigate,
      child: _CollapsibleArticle(entry: entry),
    );
  }
}

class _CollapsibleArticle extends StatelessWidget {
  const _CollapsibleArticle({required this.entry});

  final ComponentDocEntry entry;

  @override
  Widget build(BuildContext context) => Column(
    key: const ValueKey<String>('collapsible-doc-article'),
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DsSection(
        id: 'overview',
        title: 'Overview',
        description:
            'DsCollapsible is deliberately thin: it owns the open/closed '
            'stacking and the shared unfold animation, nothing else.',
        child: DsPanel(
          label: 'WHEN TO REACH FOR IT',
          note: 'VS ACCORDION',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DsText(
                'Both components share one animation (DsUnfold, documented '
                'below) and one visual mechanic — a trigger that flips a '
                'boolean and a panel that unfolds under it. What differs is '
                'coordination. Accordion manages a set of items and decides '
                'which one is open; opening a new item can close another. '
                'Collapsible manages exactly one open flag that only the '
                'caller changes, so two Collapsibles on the same page never '
                'know about each other — see Composition below for that '
                'proven live, not just claimed.',
                DsType.small,
              ),
              SizedBox(height: ds(4)),
              DsText(
                'Variants and sizes: not applicable. DsCollapsible declares '
                'no variant or size enum of its own — the trigger and the '
                'content are entirely caller-supplied widgets (see API), so '
                'visual variety belongs to composition, not to parameters on '
                'this component.',
                DsType.small,
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'preview',
        title: 'Preview',
        description:
            'An independent "Advanced filters" disclosure — tap the trigger '
            'to expand or collapse the panel beneath it. Reduced motion '
            'collapses the tween to a single frame; the panel still opens '
            'and closes correctly.',
        child: DocsCodeExample(
          title: 'Collapsible specimen',
          preview: const _CollapsiblePreview(),
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(
              path: 'lib/components/ui/collapsible.dart',
              code:
                  "import 'package:flutter/widgets.dart';\n\n"
                  '// No registry manifest yet — copy '
                  'lib/src/components/collapsible.dart verbatim. It imports '
                  'only the source foundation (motion + theme), so nothing '
                  'else has to travel with it.',
            ),
          ],
        ),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'install',
        title: 'Installation',
        child: DocsInstallFacts(
          facts: <DocsInstallFact>[
            const DocsInstallFact(
              label: 'CLI',
              value: 'Not available yet',
              description:
                  'Collapsible has no registry/components/collapsible.json '
                  'manifest, so `elattar add collapsible` does not exist. '
                  'Install manually until a Wave 1 registry item ships.',
            ),
            DocsInstallFact(
              label: 'Manual target',
              value: 'lib/components/ui/${entry.name}.dart',
              description:
                  'Copy ${entry.sourcePath} verbatim into that destination.',
            ),
            const DocsInstallFact(
              label: 'Status',
              value: 'Stable — package export',
              description:
                  'Exported from the maintained package today; not yet '
                  'mirrored into the CLI registry.',
            ),
            const DocsInstallFact(
              label: 'Platforms',
              value: 'Android, iOS, Web, macOS, Windows, Linux',
              description:
                  'A plain Flutter widget tree — no platform channels, '
                  'plugins, or shaders to gate any target.',
            ),
          ],
        ),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'usage',
        title: 'Usage',
        child: DsPanel(
          label: 'DART',
          note: 'COMPOSE',
          child: DocsSelectableCodeBlock(code: _usageCode),
        ),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'api',
        title: 'API',
        description:
            'Every public constructor parameter in collapsible.dart — '
            'nothing here is inferred from the reference, only from the '
            'Dart source.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const <Widget>[
            DocsApiTable(
              title: 'DsCollapsible',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'open',
                  type: 'bool',
                  description:
                      'Required, no default. Controlled: true expands the '
                      'panel, false collapses it. DsCollapsible keeps no '
                      'open/closed state of its own.',
                ),
                DocsApiFact(
                  name: 'trigger',
                  type: 'Widget',
                  description:
                      'Required, no default. The caller\'s own control, '
                      'already wired to flip open — a DsButton with an '
                      'onPressed callback in every specimen on this page.',
                ),
                DocsApiFact(
                  name: 'content',
                  type: 'Widget',
                  description:
                      'Required, no default. The panel body. Its own top '
                      'padding, if it needs any, is the caller\'s to add.',
                ),
              ],
            ),
            SizedBox(height: 24),
            DocsApiTable(
              title: 'DsUnfold — the shared expand/collapse animation',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'open',
                  type: 'bool',
                  description:
                      'Required, no default. Same controlled contract as '
                      'DsCollapsible.open, which forwards its value here '
                      'unchanged.',
                ),
                DocsApiFact(
                  name: 'child',
                  type: 'Widget',
                  description:
                      'Required, no default. Measured at its own natural '
                      'height, then clipped as the panel animates open or '
                      'shut. DsCollapsible passes its content here.',
                ),
              ],
            ),
          ],
        ),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'states',
        title: 'States',
        description:
            'Selected, pressed, loading, empty, error and success are '
            'omitted: selection and press feedback belong to whatever '
            'trigger widget the caller supplies, and a synchronous, purely '
            'visual disclosure has no async lifecycle to report against.',
        child: const DocsStateMatrix(
          facts: <DocsStateFact>[
            DocsStateFact(
              state: 'Rest / closed',
              treatment:
                  'open: false and settled — DsUnfold renders '
                  'SizedBox.shrink(); the panel is not mounted at all.',
              userSignal:
                  'Only the trigger occupies space; no empty clipped box '
                  'is left behind.',
            ),
            DocsStateFact(
              state: 'Open',
              treatment:
                  'open: true — the panel unfolds on --ease-spring over '
                  'DsDurations.jelly (420ms) and settles with a slight '
                  'overshoot.',
              userSignal:
                  'Content opacity moves in exact lock-step with height, so '
                  'it never reads as spilling out of the panel.',
            ),
            DocsStateFact(
              state: 'Focus-visible',
              treatment:
                  'Owned entirely by the trigger widget — DsCollapsible '
                  'paints no focus ring of its own.',
              userSignal:
                  'Whatever focus treatment the trigger already has, for '
                  'example DsButton\'s token-based ring.',
            ),
            DocsStateFact(
              state: 'Disabled',
              treatment:
                  'N/A on this widget — DsCollapsible has no disabled '
                  'concept. Disable the trigger instead (DsButton\'s '
                  'onPressed: null), which stops open from ever changing.',
              userSignal: 'Whatever a disabled trigger already signals.',
            ),
            DocsStateFact(
              state: 'Reduced motion',
              treatment:
                  'MediaQuery.disableAnimations collapses DsDurations.jelly '
                  'and DsDurations.base to Duration.zero through '
                  'dsAnimationDuration, so the tween is skipped.',
              userSignal:
                  'The panel still appears and disappears correctly — only '
                  'the easing and overshoot are gone.',
            ),
          ],
        ),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'accessibility',
        title: 'Accessibility',
        child: const DocsInstallFacts(
          title: 'Accessibility',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Semantic role',
              value: 'None of its own',
              description:
                  'DsCollapsible adds no Semantics node. The trigger '
                  'supplies interactive semantics (a DsButton trigger is '
                  'already an accessible button), and the content simply '
                  'mounts or unmounts.',
            ),
            DocsInstallFact(
              label: 'Keyboard',
              value: 'Whatever the trigger provides',
              description:
                  'A DsButton trigger is focusable and activates on Enter '
                  'or Space through its own button semantics; '
                  'DsCollapsible intercepts no keys itself.',
            ),
            DocsInstallFact(
              label: 'Focus behavior',
              value: 'Never moves on toggle',
              description:
                  'Opening or closing the panel only mounts or unmounts the '
                  'content beneath the trigger; focus stays on the trigger '
                  'throughout.',
            ),
            DocsInstallFact(
              label: 'Screen reader',
              value: 'Content is removed, not just hidden, when closed',
              description:
                  'DsUnfold returns SizedBox.shrink() while closed and '
                  'settled, so assistive technology never lands on '
                  'off-screen content — the same contract as an unmounted '
                  'Radix Content without forceMount.',
            ),
            DocsInstallFact(
              label: 'Non-color signal',
              value: 'Owned by the trigger',
              description:
                  'DsCollapsible paints nothing of its own; an open/closed '
                  'indicator such as a chevron belongs to the trigger — see '
                  'the chevron in the live preview above.',
            ),
          ],
        ),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'responsive',
        title: 'Responsive and platform behavior',
        child: DsPanel(
          label: 'LAYOUT',
          note: 'ALL BREAKPOINTS',
          child: DsText(
            'DsCollapsible has no breakpoint logic: it is a '
            'Column(mainAxisSize: min) that sizes to whatever width its '
            'parent gives it, so a phone-width trigger and a desktop-width '
            'trigger behave identically — only the trigger and content '
            'widgets the caller composes decide how that width is used. It '
            'touches no platform channel, plugin, or shader, so it runs the '
            'same way on every target the package supports.',
            DsType.small,
          ),
        ),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'dependencies',
        title: 'Dependencies, files, and verification',
        child: DocsInstallFacts(
          title: 'Dependencies, files, and verification',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Dependencies',
              value: entry.dependencies.join(', '),
              description:
                  'Only lib/src/foundation/motion.dart (durations, curves) '
                  'and theme_scope.dart (dsAnimationDuration). No other '
                  'component file is imported.',
            ),
            DocsInstallFact(
              label: 'Exports',
              value: entry.exports.join(', '),
              description:
                  'Both classes ship from the public barrel '
                  '(package:elattar_design_system/elattar_design_system.dart).',
            ),
            const DocsInstallFact(
              label: 'Assets',
              value: 'None',
              description: 'No images or bundled files of any kind.',
            ),
            const DocsInstallFact(
              label: 'Shaders',
              value: 'None',
              description: 'No fragment shader dependency.',
            ),
            DocsInstallFact(
              label: 'Source',
              value: entry.sourcePath,
              description:
                  'The authoritative implementation this page documents.',
            ),
            const DocsInstallFact(
              label: 'Tests',
              value: 'test/navigation_test.dart, this page\'s own suite',
              description:
                  'Package-level coverage for DsUnfold\'s height/opacity '
                  'tween and DsCollapsible\'s trigger/panel stacking lives '
                  'in test/navigation_test.dart ("Collapsible and the shared '
                  'unfold"); example/test/components_docs/collapsible_test.dart '
                  'covers this documentation page.',
            ),
          ],
        ),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'composition',
        title: 'Composition',
        description:
            'Two independent sections on one page, each with its own open '
            'flag. Opening one never touches the other — the functional '
            'difference from Accordion\'s coordinated set.',
        child: const DocsCodeExample(
          title: 'Two independent disclosures',
          preview: _IndependentPairPreview(),
        ),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'theming',
        title: 'Theming',
        child: DsPanel(
          label: 'TOKENS',
          note: 'MOTION ONLY',
          child: DsText(
            'DsCollapsible paints nothing itself, so it consumes no color, '
            'radius, or shadow token directly — every visible pixel belongs '
            'to the trigger and content widgets the caller supplies, which '
            'already read DsTheme.of(context) on their own. The only tokens '
            'this file touches are motion: DsDurations.jelly (420ms open) '
            'and DsDurations.base (250ms close), eased on DsCurves.spring '
            'opening and DsCurves.inOut closing, both gated by '
            'dsAnimationDuration for reduced motion. There is no source-mode '
            'theming knob because there is nothing here to theme.',
            DsType.small,
          ),
        ),
      ),
    ],
  );
}

const String _usageCode = '''bool open = false;

DsCollapsible(
  open: open,
  trigger: DsButton(
    variant: DsButtonVariant.outline,
    onPressed: () => setState(() => open = !open),
    child: const Text('Advanced filters'),
  ),
  content: const Text('Volatility'),
)''';

/// Mirrors the already-shipped, already-tested "Collapsible — advanced
/// filters" specimen in `example/lib/pages/navigation.dart`
/// (`_DisclosureSectionState`) rather than inventing a new one — the same
/// real Dart against the real API, just re-hosted for this page.
class _CollapsiblePreview extends StatefulWidget {
  const _CollapsiblePreview();

  @override
  State<_CollapsiblePreview> createState() => _CollapsiblePreviewState();
}

class _CollapsiblePreviewState extends State<_CollapsiblePreview> {
  bool _open = false;

  static const List<String> _filterRows = <String>[
    'Volatility',
    'Print run size',
    'Pack type',
    'Card set',
  ];

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return DsCollapsible(
      open: _open,
      trigger: DsButton(
        variant: DsButtonVariant.outline,
        onPressed: () => setState(() => _open = !_open),
        child: Row(
          // `className="w-full justify-between"`.
          children: <Widget>[
            const Text('Advanced filters'),
            const Spacer(),
            DsIcon(
              DsIconGlyph.chevronRight,
              size: DsIconSize.sm,
              tone: DsIconTone.subtle,
            ),
          ],
        ),
      ),
      content: Padding(
        // `className="pt-4"` on the content.
        padding: EdgeInsets.only(top: ds(4)),
        child: Container(
          padding: EdgeInsets.all(ds(4)),
          decoration: BoxDecoration(
            color: theme.card,
            borderRadius: BorderRadius.circular(DsRadii.lg),
            border: Border.all(color: theme.border, width: DsWidths.hairline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (int i = 0; i < _filterRows.length; i++) ...<Widget>[
                if (i > 0) SizedBox(height: ds(3)),
                DsText(_filterRows[i], DsType.small),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Two `DsCollapsible`s, each with its own `bool` flag — the composition
/// section's live proof that opening one never reaches into the other, which
/// is the whole functional distinction from `DsAccordion`.
class _IndependentPairPreview extends StatefulWidget {
  const _IndependentPairPreview();

  @override
  State<_IndependentPairPreview> createState() =>
      _IndependentPairPreviewState();
}

class _IndependentPairPreviewState extends State<_IndependentPairPreview> {
  bool _a = false;
  bool _b = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey<String>('collapsible-doc-composition'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsCollapsible(
          open: _a,
          trigger: DsButton(
            key: const ValueKey<String>(
              'collapsible-doc-composition-a-trigger',
            ),
            variant: DsButtonVariant.ghost,
            onPressed: () => setState(() => _a = !_a),
            child: Row(
              children: <Widget>[
                const Text('Shipping details'),
                const Spacer(),
                DsIcon(
                  DsIconGlyph.chevronRight,
                  size: DsIconSize.sm,
                  tone: DsIconTone.subtle,
                ),
              ],
            ),
          ),
          content: Padding(
            key: const ValueKey<String>('collapsible-doc-composition-a-panel'),
            padding: EdgeInsets.only(top: ds(3)),
            child: DsText(
              'Ships within two business days once graded.',
              DsType.small,
            ),
          ),
        ),
        SizedBox(height: ds(3)),
        DsCollapsible(
          open: _b,
          trigger: DsButton(
            key: const ValueKey<String>(
              'collapsible-doc-composition-b-trigger',
            ),
            variant: DsButtonVariant.ghost,
            onPressed: () => setState(() => _b = !_b),
            child: Row(
              children: <Widget>[
                const Text('Return policy'),
                const Spacer(),
                DsIcon(
                  DsIconGlyph.chevronRight,
                  size: DsIconSize.sm,
                  tone: DsIconTone.subtle,
                ),
              ],
            ),
          ),
          content: Padding(
            key: const ValueKey<String>('collapsible-doc-composition-b-panel'),
            padding: EdgeInsets.only(top: ds(3)),
            child: DsText(
              'Sell-back is credited immediately; nothing here reacts to '
              'the section above opening or closing.',
              DsType.small,
            ),
          ),
        ),
      ],
    );
  }
}
