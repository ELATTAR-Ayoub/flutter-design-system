/// Public documentation page for the `collapsible` component —
/// `lib/src/components/collapsible.dart`'s [DsCollapsible] and the shared
/// [DsUnfold] expand/collapse animation it mounts.
///
/// Reshaped to mirror `https://ui.shadcn.com/docs/components/base/collapsible`
/// section for section: a [DocsLayout] shell around a column of [DsSection]s,
/// each self-registering its own scroll anchor, in the shadcn page's own
/// order (live demo, Installation, Usage, Composition, its own examples,
/// API Reference) followed by this system's six extra sections (States,
/// Accessibility, Responsive, Dependencies, Theming, Source).
///
/// Three shadcn sections have no [DsSection] here, and each says why in its
/// own place rather than only in this comment:
/// * **Controlled State**: DsCollapsible has no uncontrolled mode to
///   contrast it against, it is controlled on every specimen on this page
///   already, see Usage's own note.
/// * **Basic** and **Settings Panel**: both are, on the reference, another
///   trigger-plus-chevron-plus-card disclosure, the exact shape Preview
///   already shows live: a second near-identical specimen would not answer
///   a new question.
/// * **File Tree**: nesting one DsCollapsible inside another's `content` is
///   unremarkable widget composition (content takes any Widget, see API
///   Reference), not a distinct capability worth its own specimen.
/// * **RTL**: DsCollapsible makes no directional layout choice of its own
///   (`Column` and `Align(alignment: Alignment.topCenter)` are both
///   direction neutral), so there is nothing component-specific to
///   demonstrate beyond Flutter's ambient `Directionality`, already covered
///   generically in Responsive.
///
/// **Variants and sizes**: `DsCollapsible` declares no variant or size enum,
/// so that note lives in the hero paragraph (`collapsibleExpandedDescription`
/// in `meta.dart`) rather than standing alone as a section.
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
        description: entry.description,
      ),
      breadcrumbs: const <DsBreadcrumbEntry>[
        DsBreadcrumbEntry.link('Components'),
        DsBreadcrumbEntry.page('Collapsible'),
      ],
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Installation', anchor: 'install'),
        DocsTocEntry(title: 'Usage', anchor: 'usage'),
        DocsTocEntry(title: 'Composition', anchor: 'composition'),
        DocsTocEntry(
          title: 'Independent instances',
          anchor: 'independent-instances',
        ),
        DocsTocEntry(title: 'API Reference', anchor: 'api'),
        DocsTocEntry(title: 'States', anchor: 'states'),
        DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
        DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
        DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
        DocsTocEntry(title: 'Theming', anchor: 'theming'),
        DocsTocEntry(title: 'Source', anchor: 'source'),
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
      // Unheaded hero paragraph, the same convention `button/page.dart`'s
      // own `_heroExpansion` establishes: elaborates on the intro's short
      // description without claiming a heading or a TOC anchor of its own,
      // so the required section order starts clean at Preview.
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: DsWidths.prose),
        child: DsText(collapsibleExpandedDescription, DsType.body),
      ),
      SizedBox(height: ds(8)),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: DsWidths.prose),
        child: DsText(
          'An independent "Advanced filters" disclosure: tap the trigger '
            'to expand or collapse the panel beneath it. Reduced motion '
            'collapses the tween to a single frame; the panel still opens '
            'and closes correctly.',
          DsType.body,
        ),
      ),
      SizedBox(height: ds(6)),
      DocsCodeExample(
          title: 'Collapsible specimen',
          preview: const _CollapsiblePreview(),
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(
              path: 'lib/components/ui/collapsible.dart',
              code:
                  "import 'package:flutter/widgets.dart';\n\n"
                  '// No registry manifest yet: copy '
                  'lib/src/components/collapsible.dart verbatim. It imports '
                  'only the source foundation (motion + theme), so nothing '
                  'else has to travel with it.',
            ),
          ],
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
              value: 'Stable: package export',
              description:
                  'Exported from the maintained package today; not yet '
                  'mirrored into the CLI registry.',
            ),
            const DocsInstallFact(
              label: 'Platforms',
              value: 'Android, iOS, Web, macOS, Windows, Linux',
              description:
                  'A plain Flutter widget tree: no platform channels, '
                  'plugins, or shaders to gate any target.',
            ),
          ],
        ),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'usage',
        title: 'Usage',
        description:
            'Controlled only, always: DsCollapsible keeps no open/closed '
            'state of its own, so there is no separate "uncontrolled" '
            'variant to opt into. The open flag below is the whole '
            'contract.',
        child: DsPanel(
          label: 'DART',
          note: 'COMPOSE',
          child: DocsSelectableCodeBlock(code: _usageCode),
        ),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'composition',
        title: 'Composition',
        description:
            'DsCollapsible has no compound/context API to diagram, unlike '
            'the Radix primitives it mirrors: it is one StatelessWidget '
            'that stacks exactly two children.',
        child: DsPanel(
          label: 'HIERARCHY',
          note: 'ONE WIDGET, TWO SLOTS',
          child: DocsSelectableCodeBlock(code: _compositionTree),
        ),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'independent-instances',
        title: 'Independent instances',
        description:
            'Two independent sections on one page, each with its own open '
            'flag. Opening one never touches the other: the functional '
            'difference from Accordion\'s coordinated set.',
        child: const DocsCodeExample(
          title: 'Two independent disclosures',
          preview: _IndependentPairPreview(),
        ),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'api',
        title: 'API Reference',
        description:
            'Every public constructor parameter in collapsible.dart, '
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
                      'already wired to flip open: a DsButton with an '
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
              title: 'DsUnfold: the shared expand/collapse animation',
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
                  'open: false and settled, DsUnfold renders '
                  'SizedBox.shrink(); the panel is not mounted at all.',
              userSignal:
                  'Only the trigger occupies space; no empty clipped box '
                  'is left behind.',
            ),
            DocsStateFact(
              state: 'Open',
              treatment:
                  'open: true: the panel unfolds on --ease-spring over '
                  'DsDurations.jelly (420ms) and settles with a slight '
                  'overshoot.',
              userSignal:
                  'Content opacity moves in exact lock-step with height, so '
                  'it never reads as spilling out of the panel.',
            ),
            DocsStateFact(
              state: 'Focus-visible',
              treatment:
                  'Owned entirely by the trigger widget, DsCollapsible '
                  'paints no focus ring of its own.',
              userSignal:
                  'Whatever focus treatment the trigger already has, for '
                  'example DsButton\'s token-based ring.',
            ),
            DocsStateFact(
              state: 'Disabled',
              treatment:
                  'N/A on this widget, DsCollapsible has no disabled '
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
                  'The panel still appears and disappears correctly: only '
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
                  'off-screen content: the same contract as an unmounted '
                  'Radix Content without forceMount.',
            ),
            DocsInstallFact(
              label: 'Non-color signal',
              value: 'Owned by the trigger',
              description:
                  'DsCollapsible paints nothing of its own; an open/closed '
                  'indicator such as a chevron belongs to the trigger: see '
                  'the chevron in the live preview above.',
            ),
          ],
        ),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'responsive',
        title: 'Responsive',
        child: DsPanel(
          label: 'LAYOUT',
          note: 'ALL BREAKPOINTS',
          child: DsText(
            'DsCollapsible has no breakpoint logic: it is a '
            'Column(mainAxisSize: min) that sizes to whatever width its '
            'parent gives it, so a phone-width trigger and a desktop-width '
            'trigger behave identically: only the trigger and content '
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
        title: 'Dependencies',
        child: DocsInstallFacts(
          title: 'Dependencies',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Files',
              value: entry.sourcePath,
              description: 'One file: no companion sources.',
            ),
            DocsInstallFact(
              label: 'Foundation dependencies',
              value: entry.dependencies.join(', '),
              description:
                  'Only lib/src/foundation/motion.dart (durations, curves) '
                  'and theme_scope.dart (dsAnimationDuration). No other '
                  'component file is imported.',
            ),
            const DocsInstallFact(
              label: 'Assets, fonts, shaders',
              value: 'None',
              description:
                  'No images, fonts, or fragment shaders of any kind.',
            ),
          ],
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
            'radius, or shadow token directly: every visible pixel belongs '
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
      SizedBox(height: ds(6)),
      DsSection(
        id: 'source',
        title: 'Source',
        child: DocsInstallFacts(
          title: 'Source references',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Package file',
              value: entry.sourcePath,
              description: 'The authoritative Flutter source for this page.',
            ),
            DocsInstallFact(
              label: 'Exports',
              value: entry.exports.join(', '),
              description:
                  'Both classes ship from the public barrel '
                  '(package:elattar_design_system/elattar_design_system.dart).',
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
            const DocsInstallFact(
              label: 'Docs source',
              value: 'example/lib/components_docs/collapsible/page.dart',
              description:
                  'Report an issue or propose an edit against this file in '
                  'the flutter-design-system repository.',
            ),
          ],
        ),
      ),
    ],
  );
}

/// The reference's own Composition section: a plain hierarchy, not a live
/// specimen, mirroring `Collapsible / ├── CollapsibleTrigger / └──
/// CollapsibleContent`. DsCollapsible has one fewer level than the Radix
/// primitives it stands in for: [DsCollapsible.trigger] is any widget the
/// caller supplies directly (there is no `CollapsibleTrigger asChild`
/// wrapper to name), and content only gains a level because [DsUnfold] is a
/// distinct, independently documented class.
const String _compositionTree = '''DsCollapsible
├── trigger      (any Widget, caller-supplied)
└── DsUnfold
    └── content  (any Widget, caller-supplied)''';

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

/// Mirrors the already-shipped, already-tested "Collapsible: advanced
/// filters" specimen in `example/lib/pages/navigation.dart`
/// (`_DisclosureSectionState`) rather than inventing a new one: the same
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

/// Two `DsCollapsible`s, each with its own `bool` flag: the Independent
/// instances section's live proof that opening one never reaches into the
/// other, which is the whole functional distinction from `DsAccordion`.
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
      key: const ValueKey<String>('collapsible-doc-independent'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsCollapsible(
          open: _a,
          trigger: DsButton(
            key: const ValueKey<String>(
              'collapsible-doc-independent-a-trigger',
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
            key: const ValueKey<String>('collapsible-doc-independent-a-panel'),
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
              'collapsible-doc-independent-b-trigger',
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
            key: const ValueKey<String>('collapsible-doc-independent-b-panel'),
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
