/// Public documentation page for the `collapsible` component —
/// `lib/src/components/collapsible.dart`'s [ElCollapsible] and the shared
/// [ElUnfold] expand/collapse animation it mounts (the same animation
/// `ElAccordion` mounts per open item).
///
/// **Re-housed onto the kit.** This page used to hand-compose `ElSection`
/// panels; it now declares a `ComponentDocSpec`
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// `ComponentDocPage`, the shape `button` established. Every specimen
/// widget and every code string below is the same one the hand-composed
/// page carried, with two gaps closed: the hero live demo was a
/// heading-less `DocsCodeExample` before and is now the page's own
/// `Preview` `ShowcaseSection`, and the "Independent instances" example was
/// specimen-only before (no `code:` string) — a `ShowcaseSection` is a
/// specimen AND its source, so it now carries the real construction that
/// produces it.
///
/// **Composition stays a `SnippetSection`.** The reference's own
/// Composition section is `Collapsible / ├── CollapsibleTrigger / └──
/// CollapsibleContent`, an ASCII structural sketch, not compilable Dart —
/// and ElCollapsible has no compound/context API to diagram in the first
/// place, unlike the Radix primitives it mirrors: it is one
/// `StatelessWidget` that stacks exactly two children. Staging a second,
/// identical-looking live specimen next to Preview would show nothing new,
/// so this section keeps its honest code-only shape rather than
/// manufacturing a redundant stage.
///
/// **Section order**, matching `button`'s own house shape: Preview,
/// Installation, Usage, Composition, Independent instances, then the eight
/// disclosures. New: a Keyboard disclosure, between Accessibility and
/// Responsive — collapsible.dart itself wires no key handling at all
/// (there is no `Focus` or `GestureDetector` anywhere in the file):
/// whatever the caller passes as `trigger` owns activation entirely, which
/// this page's specimens exercise through a real `ElButton` trigger.
///
/// **Skipped, honestly**, unchanged from the original page's own ruling:
/// * **Controlled State**: ElCollapsible has no uncontrolled mode to
///   contrast it against, it is controlled on every specimen on this page
///   already, see Usage's own note.
/// * **Basic** and **Settings Panel**: both are, on the reference, another
///   trigger-plus-chevron-plus-card disclosure, the exact shape Preview
///   already shows live: a second near-identical specimen would not answer
///   a new question.
/// * **File Tree**: nesting one ElCollapsible inside another's `content` is
///   unremarkable widget composition (content takes any Widget, see API
///   Reference), not a distinct capability worth its own specimen.
/// * **RTL**: ElCollapsible makes no directional layout choice of its own
///   (`Column` and `Align(alignment: Alignment.topCenter)` are both
///   direction neutral), so there is nothing component-specific to
///   demonstrate beyond Flutter's ambient `Directionality`, already covered
///   generically in Responsive.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import 'meta.dart';

final ComponentDocSpec collapsibleDocSpec = ComponentDocSpec(
  name: 'collapsible',
  title: collapsibleDoc.title,
  description: collapsibleDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'An independent "Advanced filters" disclosure: tap the trigger '
          'to expand or collapse the panel beneath it. Reduced motion '
          'collapses the tween to a single frame; the panel still opens '
          'and closes correctly.',
      specimen: _CollapsiblePreview(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          '`elattar add collapsible` installs the component and its '
          'declared dependency closure. No registry/components/'
          'collapsible.json exists yet: collapsible is already reachable '
          'today through the published package, exported from the barrel, '
          'but not yet through the CLI. The Manual tab copies the source '
          'directly.',
      command: collapsibleDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/collapsible.dart',
          title: '1. Copy the source',
          description:
              'Copy ${collapsibleDoc.sourcePath} into components/ui and '
              'keep its relative imports pointed at the same foundation '
              'files.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// No registry manifest yet: copy lib/src/components/'
              'collapsible.dart into your project directly.',
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'Controlled only, always: ElCollapsible keeps no open/closed '
          'state of its own, so there is no separate "uncontrolled" '
          'variant to opt into. The open flag below is the whole '
          'contract.',
      code: _usageCode,
    ),
    SnippetSection(
      id: 'composition',
      title: 'Composition',
      description:
          'A structural sketch, not compilable source: ElCollapsible has '
          'no compound/context API to diagram, unlike the Radix '
          'primitives it mirrors, it is one StatelessWidget that stacks '
          'exactly two children. There is nothing new to stage live here '
          'that Preview above does not already show.',
      code: _compositionTree,
    ),
    ShowcaseSection(
      id: 'independent-instances',
      title: 'Independent instances',
      description:
          'Two independent sections on one page, each with its own open '
          'flag. Opening one never touches the other: the functional '
          'difference from Accordion\'s coordinated set.',
      specimen: _IndependentPairPreview(),
      code: _independentCode,
      label: 'Independent instances specimen view',
      minHeight: el(96),
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every public constructor parameter in collapsible.dart: '
          'nothing here is inferred from the reference, only from the '
          'Dart source.',
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Selected, pressed, loading, empty, error and success are '
          'omitted: selection and press feedback belong to whatever '
          'trigger widget the caller supplies, and a synchronous, purely '
          'visual disclosure has no async lifecycle to report against.',
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
          'collapsible.dart wires no key handling of its own — every '
          'fact here is about what does NOT happen, read off '
          'ElCollapsible.build directly.',
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
      description:
          "Elattar's own technical-transparency panel: what this "
          'component needs to install and run.',
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
        title: 'Source references',
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Package file',
            value: collapsibleDoc.sourcePath,
            description: 'The authoritative Flutter source for this page.',
          ),
          DocsInstallFact(
            label: 'Exports',
            value: collapsibleDoc.exports.join(', '),
            description:
                'Both classes ship from the public barrel '
                '(package:elattar_design_system/elattar_design_system.dart).',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: "test/navigation_test.dart ('Collapsible and the shared "
                "unfold')",
            description:
                'Package-level coverage for ElUnfold\'s height/opacity '
                'tween and ElCollapsible\'s trigger/panel stacking.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/collapsible_test.dart',
            description: 'Covers this documentation page.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/collapsible/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class CollapsibleDocPage extends StatelessWidget {
  const CollapsibleDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: collapsibleDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: collapsibleDoc.title,
      description: collapsibleDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Collapsible'),
    ],
    toc: collapsibleDocSpec.toc,
    previous: const DocsPageLink(
      title: 'Select',
      route: '/components/select',
    ),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('collapsible-doc-article'),
      child: ComponentDocPage(spec: collapsibleDocSpec, header: false),
    ),
  );
}

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: const <Widget>[
      DocsApiTable(
        title: 'ElCollapsible',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'open',
            type: 'bool',
            description:
                'Required, no default. Controlled: true expands the '
                'panel, false collapses it. ElCollapsible keeps no '
                'open/closed state of its own.',
          ),
          DocsApiFact(
            name: 'trigger',
            type: 'Widget',
            description:
                'Required, no default. The caller\'s own control, already '
                'wired to flip open: a ElButton with an onPressed '
                'callback in every specimen on this page.',
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
        title: 'ElUnfold: the shared expand/collapse animation',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'open',
            type: 'bool',
            description:
                'Required, no default. Same controlled contract as '
                'ElCollapsible.open, which forwards its value here '
                'unchanged.',
          ),
          DocsApiFact(
            name: 'child',
            type: 'Widget',
            description:
                'Required, no default. Measured at its own natural '
                'height, then clipped as the panel animates open or '
                'shut. ElCollapsible passes its content here.',
          ),
        ],
      ),
    ],
  );
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Semantic role: none of its own. ElCollapsible adds no Semantics '
            'node. The trigger supplies interactive semantics (a ElButton '
            'trigger is already an accessible button), and the content '
            'simply mounts or unmounts.',
        'Focus behavior: never moves on toggle. Opening or closing the '
            'panel only mounts or unmounts the content beneath the '
            'trigger; focus stays on the trigger throughout.',
        'Screen reader: content is removed, not just hidden, when closed. '
            'ElUnfold returns SizedBox.shrink() while closed and settled, '
            'so assistive technology never lands on off-screen content: '
            'the same contract as an unmounted Radix Content without '
            'forceMount.',
        'Non-color signal: owned by the trigger. ElCollapsible paints '
            'nothing of its own; an open/closed indicator such as a '
            'chevron belongs to the trigger, see the chevron in the live '
            'Preview specimen above.',
        'See Keyboard below for what activates the trigger, and what '
            'collapsible.dart itself contributes to that (nothing).',
      ]);
}

/// Read directly off `ElCollapsible.build`
/// (`lib/src/components/collapsible.dart`): a bare `Column` stacking
/// `trigger` and an `ElUnfold`, with no `Focus` widget and no
/// `GestureDetector` of its own anywhere in the file.
class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Activation: entirely delegated. collapsible.dart wires no key '
            'handling of its own: ElCollapsible.build is a Column '
            'stacking trigger and an ElUnfold, nothing else. Whatever '
            'widget the caller passes as trigger owns focus and '
            'activation completely.',
        'On this page: every specimen passes a real ElButton as trigger, '
            'so Enter, NumpadEnter and Space activate it through '
            'button.dart\'s own key handling, and Tab traversal follows '
            'button.dart\'s own canRequestFocus rule. A trigger built any '
            'other way (a bare GestureDetector, say) inherits none of '
            'that for free.',
        'No custom ordering: collapsible.dart wires no '
            'FocusTraversalPolicy of its own; Tab and Shift+Tab walk '
            'whatever order the surrounding page already declares.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No breakpoint branching anywhere in collapsible.dart: it is a '
            'Column(mainAxisSize: min) that sizes to whatever width its '
            'parent gives it, so a phone-width trigger and a '
            'desktop-width trigger behave identically.',
        'Only the trigger and content widgets the caller composes decide '
            'how that width is used.',
        'Platform parity: Android, iOS, Web, macOS, Windows, and Linux '
            'all render the same widget tree: no platform channel, '
            'plugin, or shader anywhere in the file.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DocsInstallFacts(
        title: 'Dependencies',
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Files',
            value: collapsibleDoc.sourcePath,
            description: 'One file: no companion sources.',
          ),
          DocsInstallFact(
            label: 'Foundation dependencies',
            value: collapsibleDoc.dependencies.join(', '),
            description:
                'Only lib/src/foundation/motion.dart (durations, curves) '
                'and theme_scope.dart (elAnimationDuration). No '
                'component or effect file is imported.',
          ),
          const DocsInstallFact(
            label: 'Assets, fonts, shaders',
            value: 'None',
            description: 'No images, fonts, or fragment shaders of any '
                'kind.',
          ),
        ],
      ),
      SizedBox(height: el(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Accordion', route: '/components/accordion'),
          DocsLink(label: 'Button', route: '/components/button'),
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
        'ElCollapsible paints nothing itself, so it consumes no color, '
            'radius, or shadow token directly: every visible pixel '
            'belongs to the trigger and content widgets the caller '
            'supplies, which already read ElTheme.of(context) on their '
            'own.',
        'The only tokens this file touches are motion: ElDurations.jelly '
            '(420ms open) and ElDurations.base (250ms close), eased on '
            'ElCurves.spring opening and ElCurves.inOut closing, both '
            'gated by elAnimationDuration for reduced motion.',
        'There is no source-mode theming knob because there is nothing '
            'here to theme.',
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

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest / closed',
    treatment:
        'open: false and settled, ElUnfold renders SizedBox.shrink(); '
        'the panel is not mounted at all.',
    userSignal:
        'Only the trigger occupies space; no empty clipped box is left '
        'behind.',
  ),
  DocsStateFact(
    state: 'Open',
    treatment:
        'open: true: the panel unfolds on --ease-spring over '
        'ElDurations.jelly (420ms) and settles with a slight overshoot.',
    userSignal:
        'Content opacity moves in exact lock-step with height, so it '
        'never reads as spilling out of the panel.',
  ),
  DocsStateFact(
    state: 'Focus-visible',
    treatment:
        'Owned entirely by the trigger widget, ElCollapsible paints no '
        'focus ring of its own.',
    userSignal:
        'Whatever focus treatment the trigger already has, for example '
        'ElButton\'s token-based ring.',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment:
        'N/A on this widget, ElCollapsible has no disabled concept. '
        'Disable the trigger instead (ElButton\'s onPressed: null), '
        'which stops open from ever changing.',
    userSignal: 'Whatever a disabled trigger already signals.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'MediaQuery.disableAnimations collapses ElDurations.jelly and '
        'ElDurations.base to Duration.zero through elAnimationDuration, '
        'so the tween is skipped.',
    userSignal:
        'The panel still appears and disappears correctly: only the '
        'easing and overshoot are gone.',
  ),
];

/* ── Showcase specimens ─────────────────────────────────────────────────── */

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
    final ElThemeData theme = ElTheme.of(context);
    return ElCollapsible(
      open: _open,
      trigger: ElButton(
        variant: ElButtonVariant.outline,
        onPressed: () => setState(() => _open = !_open),
        child: Row(
          // `className="w-full justify-between"`.
          children: <Widget>[
            const Text('Advanced filters'),
            const Spacer(),
            ElIcon(
              ElIconGlyph.chevronRight,
              size: ElIconSize.sm,
              tone: ElIconTone.subtle,
            ),
          ],
        ),
      ),
      content: Padding(
        // `className="pt-4"` on the content.
        padding: EdgeInsets.only(top: el(4)),
        child: Container(
          padding: EdgeInsets.all(el(4)),
          decoration: BoxDecoration(
            color: theme.card,
            borderRadius: BorderRadius.circular(ElRadii.lg),
            border: Border.all(color: theme.border, width: ElWidths.hairline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (int i = 0; i < _filterRows.length; i++) ...<Widget>[
                if (i > 0) SizedBox(height: el(3)),
                ElText(_filterRows[i], ElType.small),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

const String _previewCode = '''
bool open = false;

ElCollapsible(
  open: open,
  trigger: ElButton(
    variant: ElButtonVariant.outline,
    onPressed: () => setState(() => open = !open),
    child: Row(
      children: [
        const Text('Advanced filters'),
        const Spacer(),
        const ElIcon(ElIconGlyph.chevronRight, size: ElIconSize.sm),
      ],
    ),
  ),
  content: Padding(
    padding: EdgeInsets.only(top: el(4)),
    child: Container(
      padding: EdgeInsets.all(el(4)),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(ElRadii.lg),
        border: Border.all(color: theme.border, width: ElWidths.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text('Volatility'),
          SizedBox(height: 12),
          Text('Print run size'),
        ],
      ),
    ),
  ),
)''';

const String _usageCode = '''bool open = false;

ElCollapsible(
  open: open,
  trigger: ElButton(
    variant: ElButtonVariant.outline,
    onPressed: () => setState(() => open = !open),
    child: const Text('Advanced filters'),
  ),
  content: const Text('Volatility'),
)''';

/// The reference's own Composition section: a plain hierarchy, not a live
/// specimen, mirroring `Collapsible / ├── CollapsibleTrigger / └──
/// CollapsibleContent`. ElCollapsible has one fewer level than the Radix
/// primitives it stands in for: [ElCollapsible.trigger] is any widget the
/// caller supplies directly (there is no `CollapsibleTrigger asChild`
/// wrapper to name), and content only gains a level because [ElUnfold] is a
/// distinct, independently documented class.
const String _compositionTree = '''ElCollapsible
├── trigger      (any Widget, caller-supplied)
└── ElUnfold
    └── content  (any Widget, caller-supplied)''';

/// Two `ElCollapsible`s, each with its own `bool` flag: the Independent
/// instances section's live proof that opening one never reaches into the
/// other, which is the whole functional distinction from `ElAccordion`.
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
        ElCollapsible(
          open: _a,
          trigger: ElButton(
            key: const ValueKey<String>(
              'collapsible-doc-independent-a-trigger',
            ),
            variant: ElButtonVariant.ghost,
            onPressed: () => setState(() => _a = !_a),
            child: Row(
              children: <Widget>[
                const Text('Shipping details'),
                const Spacer(),
                ElIcon(
                  ElIconGlyph.chevronRight,
                  size: ElIconSize.sm,
                  tone: ElIconTone.subtle,
                ),
              ],
            ),
          ),
          content: Padding(
            key: const ValueKey<String>('collapsible-doc-independent-a-panel'),
            padding: EdgeInsets.only(top: el(3)),
            child: ElText(
              'Ships within two business days once graded.',
              ElType.small,
            ),
          ),
        ),
        SizedBox(height: el(3)),
        ElCollapsible(
          open: _b,
          trigger: ElButton(
            key: const ValueKey<String>(
              'collapsible-doc-independent-b-trigger',
            ),
            variant: ElButtonVariant.ghost,
            onPressed: () => setState(() => _b = !_b),
            child: Row(
              children: <Widget>[
                const Text('Return policy'),
                const Spacer(),
                ElIcon(
                  ElIconGlyph.chevronRight,
                  size: ElIconSize.sm,
                  tone: ElIconTone.subtle,
                ),
              ],
            ),
          ),
          content: Padding(
            key: const ValueKey<String>('collapsible-doc-independent-b-panel'),
            padding: EdgeInsets.only(top: el(3)),
            child: ElText(
              'Sell-back is credited immediately; nothing here reacts to '
              'the section above opening or closing.',
              ElType.small,
            ),
          ),
        ),
      ],
    );
  }
}

const String _independentCode = '''
bool shippingOpen = false;
bool returnsOpen = false;

Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    ElCollapsible(
      open: shippingOpen,
      trigger: ElButton(
        variant: ElButtonVariant.ghost,
        onPressed: () => setState(() => shippingOpen = !shippingOpen),
        child: const Text('Shipping details'),
      ),
      content: const Text('Ships within two business days once graded.'),
    ),
    const SizedBox(height: 12),
    ElCollapsible(
      open: returnsOpen,
      trigger: ElButton(
        variant: ElButtonVariant.ghost,
        onPressed: () => setState(() => returnsOpen = !returnsOpen),
        child: const Text('Return policy'),
      ),
      content: const Text(
        'Sell-back is credited immediately; nothing here reacts to the '
        'section above opening or closing.',
      ),
    ),
  ],
)''';
