/// Public documentation page for the `collapsible` component —
/// `lib/src/components/ui/collapsible.dart`'s [Collapsible] and the shared
/// [Unfold] expand/collapse animation it mounts (the same animation
/// `Accordion` mounts per open item).
///
/// **Re-housed onto the kit.** This page used to hand-compose `Section`
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
/// and Collapsible has no compound/context API to diagram in the first
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
/// this page's specimens exercise through a real `Button` trigger.
///
/// **Skipped, honestly**, unchanged from the original page's own ruling:
/// * **Controlled State**: Collapsible has no uncontrolled mode to
///   contrast it against, it is controlled on every specimen on this page
///   already, see Usage's own note.
/// * **Basic** and **Settings Panel**: both are, on the reference, another
///   trigger-plus-chevron-plus-card disclosure, the exact shape Preview
///   already shows live: a second near-identical specimen would not answer
///   a new question.
/// * **File Tree**: nesting one Collapsible inside another's `content` is
///   unremarkable widget composition (content takes any Widget, see API
///   Reference), not a distinct capability worth its own specimen.
/// * **RTL**: Collapsible makes no directional layout choice of its own
///   (`Column` and `Align(alignment: Alignment.topCenter)` are both
///   direction neutral), so there is nothing component-specific to
///   demonstrate beyond Flutter's ambient `Directionality`, already covered
///   generically in Responsive.
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
              '// No registry manifest yet: copy lib/src/components/ui/'
              'collapsible.dart into lib/components/ui/ in your project.',
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'Controlled only, always: Collapsible keeps no open/closed '
          'state of its own, so there is no separate "uncontrolled" '
          'variant to opt into. The open flag below is the whole '
          'contract.',
      code: _usageCode,
    ),
    SnippetSection(
      id: 'composition',
      title: 'Composition',
      description:
          'A structural sketch, not compilable source: Collapsible has '
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
      minHeight: space(96),
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
          'Collapsible.build directly.',
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
            value:
                "test/navigation_test.dart ('Collapsible and the shared "
                "unfold')",
            description:
                'Package-level coverage for Unfold\'s height/opacity '
                'tween and Collapsible\'s trigger/panel stacking.',
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
      title: collapsibleDoc.title,
      description: collapsibleDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Collapsible'),
    ],
    toc: collapsibleDocSpec.toc,
    previous: const DocsPageLink(title: 'Select', route: '/components/select'),
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
        title: 'Collapsible',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'open',
            type: 'bool',
            description:
                'Required, no default. Controlled: true expands the '
                'panel, false collapses it. Collapsible keeps no '
                'open/closed state of its own.',
          ),
          DocsApiFact(
            name: 'trigger',
            type: 'Widget',
            description:
                'Required, no default. The caller\'s own control, already '
                'wired to flip open: a Button with an onPressed '
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
        title: 'Unfold: the shared expand/collapse animation',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'open',
            type: 'bool',
            description:
                'Required, no default. Same controlled contract as '
                'Collapsible.open, which forwards its value here '
                'unchanged.',
          ),
          DocsApiFact(
            name: 'child',
            type: 'Widget',
            description:
                'Required, no default. Measured at its own natural '
                'height, then clipped as the panel animates open or '
                'shut. Collapsible passes its content here.',
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
      _bullets(ThemeScope.of(context), <String>[
        'Semantic role: none of its own. Collapsible adds no Semantics '
            'node. The trigger supplies interactive semantics (a Button '
            'trigger is already an accessible button), and the content '
            'simply mounts or unmounts.',
        'Focus behavior: never moves on toggle. Opening or closing the '
            'panel only mounts or unmounts the content beneath the '
            'trigger; focus stays on the trigger throughout.',
        'Screen reader: content is removed, not just hidden, when closed. '
            'Unfold returns SizedBox.shrink() while closed and settled, '
            'so assistive technology never lands on off-screen content: '
            'the same contract as an unmounted Radix Content without '
            'forceMount.',
        'Non-color signal: owned by the trigger. Collapsible paints '
            'nothing of its own; an open/closed indicator such as a '
            'chevron belongs to the trigger, see the chevron in the live '
            'Preview specimen above.',
        'See Keyboard below for what activates the trigger, and what '
            'collapsible.dart itself contributes to that (nothing).',
      ]);
}

/// Read directly off `Collapsible.build`
/// (`lib/src/components/ui/collapsible.dart`): a bare `Column` stacking
/// `trigger` and an `Unfold`, with no `Focus` widget and no
/// `GestureDetector` of its own anywhere in the file.
class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Activation: entirely delegated. collapsible.dart wires no key '
            'handling of its own: Collapsible.build is a Column '
            'stacking trigger and an Unfold, nothing else. Whatever '
            'widget the caller passes as trigger owns focus and '
            'activation completely.',
        'On this page: every specimen passes a real Button as trigger, '
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
      _bullets(ThemeScope.of(context), <String>[
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
                'Only lib/src/design_system/foundation/motion.dart (durations, curves) '
                'and theme_scope.dart (effectiveMotionDuration). No '
                'component or effect file is imported.',
          ),
          const DocsInstallFact(
            label: 'Assets, fonts, shaders',
            value: 'None',
            description:
                'No images, fonts, or fragment shaders of any '
                'kind.',
          ),
        ],
      ),
      SizedBox(height: space(4)),
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
  Widget build(
    BuildContext context,
  ) => _bullets(ThemeScope.of(context), <String>[
    'Collapsible paints nothing itself, so it consumes no color, '
        'radius, or shadow token directly: every visible pixel '
        'belongs to the trigger and content widgets the caller '
        'supplies, which already read ThemeScope.of(context) on their '
        'own.',
    'The only tokens this file touches are motion: MotionDurations.open '
        '(420ms open) and MotionDurations.normal (250ms close), eased on '
        'MotionCurves.emphasized opening and MotionCurves.move closing, both '
        'gated by effectiveMotionDuration for reduced motion.',
    'There is no source-mode theming knob because there is nothing '
        'here to theme.',
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

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest / closed',
    treatment:
        'open: false and settled, Unfold renders SizedBox.shrink(); '
        'the panel is not mounted at all.',
    userSignal:
        'Only the trigger occupies space; no empty clipped box is left '
        'behind.',
  ),
  DocsStateFact(
    state: 'Open',
    treatment:
        'open: true: the panel unfolds on --ease-spring over '
        'MotionDurations.open (420ms) and settles with a slight overshoot.',
    userSignal:
        'Content opacity moves in exact lock-step with height, so it '
        'never reads as spilling out of the panel.',
  ),
  DocsStateFact(
    state: 'Focus-visible',
    treatment:
        'Owned entirely by the trigger widget, Collapsible paints no '
        'focus ring of its own.',
    userSignal:
        'Whatever focus treatment the trigger already has, for example '
        'Button\'s token-based ring.',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment:
        'N/A on this widget, Collapsible has no disabled concept. '
        'Disable the trigger instead (Button\'s onPressed: null), '
        'which stops open from ever changing.',
    userSignal: 'Whatever a disabled trigger already signals.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'MediaQuery.disableAnimations collapses MotionDurations.open and '
        'MotionDurations.normal to Duration.zero through effectiveMotionDuration, '
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
    final ThemeTokens theme = ThemeScope.of(context);
    return Collapsible(
      open: _open,
      trigger: Button(
        variant: ButtonVariant.outline,
        onPressed: () => setState(() => _open = !_open),
        child: Row(
          // `className="w-full justify-between"`. `Expanded` + ellipsis
          // rather than `Spacer` so the label yields to the trailing chevron
          // instead of overflowing at large text scales.
          children: <Widget>[
            const Expanded(
              child: Text('Advanced filters', overflow: TextOverflow.ellipsis),
            ),
            Icon(
              IconGlyph.chevronRight,
              size: IconSize.sm,
              tone: IconTone.subtle,
            ),
          ],
        ),
      ),
      content: Padding(
        // `className="pt-4"` on the content.
        padding: EdgeInsets.only(top: space(4)),
        child: Container(
          padding: EdgeInsets.all(space(4)),
          decoration: BoxDecoration(
            color: theme.card,
            borderRadius: BorderRadius.circular(Radii.lg),
            border: Border.all(
              color: theme.border,
              width: BorderWidths.hairline,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (int i = 0; i < _filterRows.length; i++) ...<Widget>[
                if (i > 0) SizedBox(height: space(3)),
                StyledText(_filterRows[i], TextStyles.small),
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

Collapsible(
  open: open,
  trigger: Button(
    variant: ButtonVariant.outline,
    onPressed: () => setState(() => open = !open),
    child: Row(
      children: [
        const Text('Advanced filters'),
        const Spacer(),
        const Icon(IconGlyph.chevronRight, size: IconSize.sm),
      ],
    ),
  ),
  content: Padding(
    padding: EdgeInsets.only(top: space(4)),
    child: Container(
      padding: EdgeInsets.all(space(4)),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(color: theme.border, width: BorderWidths.hairline),
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

Collapsible(
  open: open,
  trigger: Button(
    variant: ButtonVariant.outline,
    onPressed: () => setState(() => open = !open),
    child: const Text('Advanced filters'),
  ),
  content: const Text('Volatility'),
)''';

/// The reference's own Composition section: a plain hierarchy, not a live
/// specimen, mirroring `Collapsible / ├── CollapsibleTrigger / └──
/// CollapsibleContent`. Collapsible has one fewer level than the Radix
/// primitives it stands in for: [Collapsible.trigger] is any widget the
/// caller supplies directly (there is no `CollapsibleTrigger asChild`
/// wrapper to name), and content only gains a level because [Unfold] is a
/// distinct, independently documented class.
const String _compositionTree = '''Collapsible
├── trigger      (any Widget, caller-supplied)
└── Unfold
    └── content  (any Widget, caller-supplied)''';

/// Two `Collapsible`s, each with its own `bool` flag: the Independent
/// instances section's live proof that opening one never reaches into the
/// other, which is the whole functional distinction from `Accordion`.
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
        Collapsible(
          open: _a,
          trigger: Button(
            key: const ValueKey<String>(
              'collapsible-doc-independent-a-trigger',
            ),
            variant: ButtonVariant.ghost,
            onPressed: () => setState(() => _a = !_a),
            child: Row(
              // `Expanded` + ellipsis rather than `Spacer`, matching the
              // preview trigger above, so the label yields to the chevron.
              children: <Widget>[
                const Expanded(
                  child: Text(
                    'Shipping details',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  IconGlyph.chevronRight,
                  size: IconSize.sm,
                  tone: IconTone.subtle,
                ),
              ],
            ),
          ),
          content: Padding(
            key: const ValueKey<String>('collapsible-doc-independent-a-panel'),
            padding: EdgeInsets.only(top: space(3)),
            child: StyledText(
              'Ships within two business days once graded.',
              TextStyles.small,
            ),
          ),
        ),
        SizedBox(height: space(3)),
        Collapsible(
          open: _b,
          trigger: Button(
            key: const ValueKey<String>(
              'collapsible-doc-independent-b-trigger',
            ),
            variant: ButtonVariant.ghost,
            onPressed: () => setState(() => _b = !_b),
            child: Row(
              // Same `Expanded` + ellipsis treatment as the two triggers
              // above.
              children: <Widget>[
                const Expanded(
                  child: Text('Return policy', overflow: TextOverflow.ellipsis),
                ),
                Icon(
                  IconGlyph.chevronRight,
                  size: IconSize.sm,
                  tone: IconTone.subtle,
                ),
              ],
            ),
          ),
          content: Padding(
            key: const ValueKey<String>('collapsible-doc-independent-b-panel'),
            padding: EdgeInsets.only(top: space(3)),
            child: StyledText(
              'Sell-back is credited immediately; nothing here reacts to '
              'the section above opening or closing.',
              TextStyles.small,
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
    Collapsible(
      open: shippingOpen,
      trigger: Button(
        variant: ButtonVariant.ghost,
        onPressed: () => setState(() => shippingOpen = !shippingOpen),
        child: const Text('Shipping details'),
      ),
      content: const Text('Ships within two business days once graded.'),
    ),
    const SizedBox(height: 12),
    Collapsible(
      open: returnsOpen,
      trigger: Button(
        variant: ButtonVariant.ghost,
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
