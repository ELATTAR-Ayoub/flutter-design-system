/// Public documentation page for the `accordion` component.
///
/// **Re-housed onto the kit.** This page used to hand-compose `ElSection`
/// panels; it now declares a `ComponentDocSpec`
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// `ComponentDocPage`, the shape `button` established. Every specimen
/// widget and every code string below is the same one the hand-composed
/// page carried; only where it lives changed, plus the hero live demo,
/// which was a heading-less `DocsCodeExample` before and is now the page's
/// own `Preview` `ShowcaseSection`, so it finally owns a rail entry.
///
/// **Section order**: Preview, Installation, Usage, Composition, Basic,
/// Card, then the eight disclosures. New: a Keyboard disclosure, between
/// Accessibility and Responsive — read directly off
/// `_ElAccordionTriggerState.build` (`lib/src/components/accordion.dart`),
/// which wires a bare `GestureDetector.onTap` and a `Focus` widget for its
/// ring, but no `onKeyEvent` of any kind: the fact that used to live as one
/// bullet inside Accessibility now gets the section the house shape
/// promises it.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import 'meta.dart';

final ComponentDocSpec accordionDocSpec = ComponentDocSpec(
  name: 'accordion',
  title: accordionDoc.title,
  description: accordionDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'type="single" collapsible: one open panel, or none. Opening a '
          'second panel closes whichever was open; tapping the open '
          'panel\'s own trigger closes it too. The first panel is open by '
          'default, matching the reference\'s own defaultValue="odds" '
          'mount.',
      specimen: _AccordionPreview(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          '`elattar add accordion` installs the component and its declared '
          'dependency closure. No registry/components/accordion.json '
          'exists yet: accordion is already reachable today through the '
          'published package, exported from the barrel, but not yet '
          'through the CLI. The Manual tab copies the source directly.',
      command: accordionDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/accordion.dart',
          title: '1. Copy the source',
          description:
              'Copy ${accordionDoc.sourcePath} into components/ui and keep '
              'its relative imports pointed at the same foundation and '
              'sibling-component files.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// No registry manifest yet: copy lib/src/components/'
              'accordion.dart into your project directly.',
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'ElAccordion is always controlled: the caller owns openIndex and '
          'threads it back through onChanged. There is no uncontrolled or '
          'auto-managed variant.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'composition',
      title: 'Composition',
      description:
          'ElAccordion takes data, not children: items is a '
          'List<ElAccordionItem>, each one a title and a content widget, '
          'rather than a tree of separate Accordion/AccordionItem/'
          'AccordionTrigger sub-widgets to assemble by hand. content still '
          'accepts any Widget, not just a string: this specimen nests '
          'more than one paragraph inside a single panel.',
      specimen: _AccordionCompositionPreview(),
      code: _compositionCode,
      label: 'Composition specimen view',
    ),
    ShowcaseSection(
      id: 'basic',
      title: 'Basic',
      description:
          'A second FAQ set, the same single-open collapsible behavior as '
          'the Preview specimen above, with different copy.',
      specimen: _AccordionBasicPreview(),
      code: _basicCode,
      label: 'Basic specimen view',
    ),
    ShowcaseSection(
      id: 'card',
      title: 'Card',
      description:
          'ElAccordion has no surface of its own: wrap it in ElCard when '
          'the FAQ needs a header and an edge, same as any other content.',
      specimen: _AccordionCardPreview(),
      code: _cardCode,
      label: 'Card specimen view',
      minHeight: el(96),
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every public constructor parameter on ElAccordion and '
          'ElAccordionItem, plus the fixed layout constants that stand in '
          'for a variant or size enum, since ElAccordion has neither.',
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
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
          '_ElAccordionTriggerState wires the same Focus-ring idiom '
          'button.dart uses, but none of button.dart\'s key handling: '
          'every fact here is read off that class directly, not inferred.',
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
            value: accordionDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'none yet',
            description:
                'No dedicated unit test exists for accordion.dart in the '
                'package test suite as of this page.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/accordion_test.dart',
            description:
                'Covers this page: the article mounts, every documented '
                'section, the full API tables, and the live specimen '
                'opening, switching, and collapsing to nothing.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/accordion/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class AccordionDocPage extends StatelessWidget {
  const AccordionDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: accordionDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: accordionDoc.title,
      description: accordionDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Accordion'),
    ],
    toc: accordionDocSpec.toc,
    // Forward references into the same wave: `select` already routes
    // (Phase F); `alert` lands alongside `accordion` once every worker's
    // page is wired in by the supervisor.
    previous: const DocsPageLink(
      title: 'Select',
      route: '/components/select',
    ),
    next: const DocsPageLink(title: 'Alert', route: '/components/alert'),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('accordion-doc-article'),
      child: ComponentDocPage(spec: accordionDocSpec, header: false),
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
        title: 'ElAccordion',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'items',
            type: 'List<ElAccordionItem>',
            description: 'The ordered set of trigger/content pairs.',
          ),
          DocsApiFact(
            name: 'openIndex',
            type: 'int?',
            description:
                'Which item is open, or null for none. Required, the '
                'caller must state "nothing open" explicitly rather than '
                'leaving it implicit.',
          ),
          DocsApiFact(
            name: 'onChanged',
            type: 'ValueChanged<int?>',
            description:
                'Reports the new openIndex. Tapping the already-open item '
                'reports null, not its own index: that is what '
                '"collapsible" means here.',
          ),
        ],
      ),
      SizedBox(height: 24),
      DocsApiTable(
        title: 'ElAccordionItem',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'title',
            type: 'String',
            description:
                'The trigger\'s label and its only accessible name, there '
                'is no separate label parameter.',
          ),
          DocsApiFact(
            name: 'content',
            type: 'Widget',
            description:
                'The panel\'s child. Any widget, not just text: see '
                'Composition above.',
          ),
        ],
      ),
      SizedBox(height: 24),
      DocsApiTable(
        title: 'ElAccordion static layout tokens',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'ElAccordion.triggerPaddingY',
            type: 'static double',
            description:
                '10px of vertical padding on the trigger (py-2.5), '
                'reusable if you need to match the rhythm elsewhere.',
          ),
          DocsApiFact(
            name: 'ElAccordion.contentPaddingBottom',
            type: 'static double',
            description: '10px under the open panel\'s content (pb-2.5).',
          ),
          DocsApiFact(
            name: 'ElAccordion.chevronPx',
            type: 'static double',
            description:
                '16px chevron size: the icon widget\'s own default, not '
                'an accordion-specific variant. ElAccordion exposes no '
                'variant or size enum: every accordion renders through '
                'this same trigger and padding ladder.',
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
        'Each trigger publishes one merged Semantics node: button: true, '
            'expanded: <open state>, label: <title>.',
        'title is the only accessible name a trigger has: there is no '
            'separate label parameter, so it cannot be left as '
            'placeholder-style copy.',
        'The measured trigger height is about 40.56px, under the common '
            '44-48px touch-target guidance; treat tap targets accordingly '
            'on touch platforms.',
        'Open/closed state is never color-only: the chevron glyph swap is '
            'the non-color signal alongside the Semantics expanded flag.',
        'Focus ring: a hairline border fades in to theme.ring on the same '
            'transition every other focus ring in the system uses, and '
            'only on keyboard traversal: a bare pointer tap never calls '
            'requestFocus() on the node.',
        'No error or validation wiring applies to a disclosure list.',
        'See Keyboard below for what activates a focused trigger, and '
            'what does not.',
      ]);
}

/// Read directly off `_ElAccordionTriggerState.build`
/// (`lib/src/components/accordion.dart`): a bare `GestureDetector.onTap`
/// and a `Focus` widget kept only for the ring's `onFocusChange`, with no
/// `onKeyEvent` anywhere in the file.
class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Activation: none. accordion.dart wires no Focus.onKeyEvent and no '
            'onKey of any kind: Enter, NumpadEnter and Space do nothing to '
            'a focused trigger. Only a pointer or touch tap toggles a '
            'panel today.',
        'Tab order: every trigger stays in the default traversal order, '
            'open or closed: ElAccordion sets no FocusTraversalPolicy and '
            'removes nothing from Tab order the way a disabled control '
            'would.',
        'Pointer vs keyboard: a bare tap never calls requestFocus() on '
            'the trigger\'s Focus node; only keyboard traversal moves '
            'focus there, which is what lets the ring stand in for '
            ':focus-visible.',
        'Known gap, reported rather than fixed: button.dart, this '
            'component\'s closest kin (the same focus-ring '
            'TweenAnimationBuilder/ElMachineSurface idiom), activates on '
            'Enter and Space. accordion.dart does not.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'ElAccordion is a stretched Column with no breakpoints of its own: '
            'it always fills the width its parent gives it.',
        'A trigger title has no maxLines or overflow set, so a long '
            'question wraps onto more than one line instead of '
            'truncating.',
        'The chevron aligns with the first line of a wrapped title '
            '(items-start), not the vertical center of the block.',
        'Platform parity: Android, iOS, Web, macOS, Windows, and Linux '
            'all render the same widget tree: no dart:io Platform branch '
            'anywhere in the file.',
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
            value: accordionDoc.sourcePath,
            description: 'One file: no companion sources.',
          ),
          const DocsInstallFact(
            label: 'Component dependencies',
            value: 'button (focus-ring statics), collapsible (ElUnfold), '
                'icon (chevron glyphs)',
            description: 'Sibling components imported directly.',
          ),
          const DocsInstallFact(
            label: 'Foundation dependencies',
            value: 'source-foundation, machine-surface',
            description:
                'Colors, motion, shadows, spacing, theme, typography, and '
                'the ElMachineSurface effect used for the focus ring.',
          ),
          const DocsInstallFact(
            label: 'Assets, fonts, shaders',
            value: 'None',
            description:
                'No image, font, or shader assets: text renders through '
                'the ambient typography tokens already loaded elsewhere.',
          ),
        ],
      ),
      SizedBox(height: el(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Button', route: '/components/button'),
          DocsLink(label: 'Collapsible', route: '/components/collapsible'),
          DocsLink(label: 'Icon', route: '/components/icon'),
          DocsLink(
            label: 'Machine Surface',
            route: '/components/machine_surface',
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
      _bullets(ElTheme.of(context), <String>[
        'theme.border paints the 1px seam under every item but the last '
            '(not-last:border-b).',
        'theme.foreground paints both the trigger label and the chevron: '
            'the reference\'s own muted-foreground variant on the chevron '
            'is dead CSS, so this port renders the measured color rather '
            'than the unreachable one.',
        'theme.ring, at the system\'s standard 0.50 alpha, is the only '
            'color the focus state adds; there is no separate hover or '
            'pressed fill.',
        'ElShadows.none is the trigger\'s resting elevation: the focus '
            'ring is the only shadow layer it ever gains.',
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
    state: 'Rest',
    treatment: 'Closed panel; chevron-down; transparent border.',
    userSignal: 'Trigger reads as an inert row until interacted with.',
  ),
  DocsStateFact(
    state: 'Hover',
    treatment: 'The label alone gains an underline.',
    userSignal: 'No background or surface change on hover.',
  ),
  DocsStateFact(
    state: 'Focus-visible',
    treatment:
        'A hairline border fades in to the ring color, animated on the '
        'same duration as every other focus ring.',
    userSignal:
        'Focus is reached by Tab; the trigger never calls requestFocus() '
        'on tap, so pointer interaction alone does not paint the ring.',
  ),
  DocsStateFact(
    state: 'Pressed',
    treatment: 'No dedicated pressed/scale treatment is wired for this '
        'trigger.',
    userSignal:
        'A tap resolves directly into the open/close transition instead '
        'of a press-down affordance.',
  ),
  DocsStateFact(
    state: 'Selected (open)',
    treatment:
        'The chevron swaps from chevron-down to chevron-up: a glyph '
        'swap, not a rotation: and the content mounts and plays its '
        'unfold animation.',
    userSignal:
        'Semantics(expanded: true) is published alongside the visual '
        'swap, so the state is never color-only.',
  ),
  DocsStateFact(
    state: 'Empty',
    treatment: 'items: const [] renders a zero-height column.',
    userSignal:
        'No built-in placeholder copy: compose one yourself if an empty '
        'accordion needs messaging.',
  ),
  DocsStateFact(
    state: 'Disabled, N/A',
    treatment:
        'ElAccordion and ElAccordionItem expose no enabled or disabled '
        'parameter.',
    userSignal:
        'A caller wanting a disabled row has to gate it outside the '
        'component.',
  ),
  DocsStateFact(
    state: 'Loading, N/A',
    treatment: 'The toggle is synchronous; there is nothing to await.',
    userSignal: 'No async state exists to invent here.',
  ),
  DocsStateFact(
    state: 'Error / Success, N/A',
    treatment: 'A disclosure list carries no validation concept.',
    userSignal: 'Neither state applies to this primitive.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'Both the focus-ring transition and the panel\'s open/close '
        'animation route through elAnimationDuration.',
    userSignal:
        'That duration collapses to zero when the platform\'s '
        'disable-animations flag is on: transitions still happen, '
        'instantly.',
  ),
];

/* ── Showcase specimens ─────────────────────────────────────────────────── */

/// The primary live specimen: three items, the first open by default,
/// matching the reference's own `defaultValue="odds"` mount.
class _AccordionPreview extends StatefulWidget {
  const _AccordionPreview();

  @override
  State<_AccordionPreview> createState() => _AccordionPreviewState();
}

class _AccordionPreviewState extends State<_AccordionPreview> {
  int? _openIndex = 0;

  static final List<ElAccordionItem> _items = <ElAccordionItem>[
    ElAccordionItem(
      title: 'What does single and collapsible mean here?',
      content: ElText(
        'Only one panel can stay open. Opening a second panel closes the '
        'first, and tapping an already-open trigger closes it, so the '
        'set can end with nothing expanded.',
        ElType.body,
      ),
    ),
    ElAccordionItem(
      title: 'Does the chevron rotate?',
      content: ElText(
        'No. The port renders two separate glyphs, chevron-down and '
        'chevron-up, and swaps which one is visible. Nothing on the '
        'icon animates a rotation.',
        ElType.body,
      ),
    ),
    ElAccordionItem(
      title: 'What happens with a long question?',
      content: ElText(
        'The label wraps onto more than one line if it needs to. The '
        'chevron stays aligned with the first line instead of '
        're-centering on the full block.',
        ElType.body,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ElAccordion(
      items: _items,
      openIndex: _openIndex,
      onChanged: (int? next) => setState(() => _openIndex = next),
    );
  }
}

const String _previewCode = '''
class FaqAccordion extends StatefulWidget {
  const FaqAccordion({super.key});

  @override
  State<FaqAccordion> createState() => _FaqAccordionState();
}

class _FaqAccordionState extends State<FaqAccordion> {
  int? _openIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ElAccordion(
      items: const <ElAccordionItem>[
        ElAccordionItem(
          title: 'What does single and collapsible mean here?',
          content: Text('Only one panel can stay open at a time.'),
        ),
        ElAccordionItem(
          title: 'Does the chevron rotate?',
          content: Text('No: it swaps between two glyphs.'),
        ),
      ],
      openIndex: _openIndex,
      onChanged: (int? next) => setState(() => _openIndex = next),
    );
  }
}''';

const String _usageCode = '''
ElAccordion(
  items: const <ElAccordionItem>[
    ElAccordionItem(
      title: 'Shipping',
      content: Text('Orders ship within two business days.'),
    ),
  ],
  openIndex: openIndex, // int?, owned by the caller
  onChanged: (int? next) => setState(() => openIndex = next),
)''';

/// Demonstrates that `content` accepts an arbitrary [Widget]: this panel's
/// body is more than one paragraph.
class _AccordionCompositionPreview extends StatefulWidget {
  const _AccordionCompositionPreview();

  @override
  State<_AccordionCompositionPreview> createState() =>
      _AccordionCompositionPreviewState();
}

class _AccordionCompositionPreviewState
    extends State<_AccordionCompositionPreview> {
  int? _openIndex = 0;

  late final List<ElAccordionItem> _items = <ElAccordionItem>[
    ElAccordionItem(
      title: 'Refund policy, in full',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ElText(
            'Refunds are issued to the original payment method within '
            'five business days of approval.',
            ElType.body,
          ),
          const SizedBox(height: 8),
          ElText(
            'Store credit is available immediately as an alternative, and '
            'never expires.',
            ElType.body,
          ),
        ],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ElAccordion(
      items: _items,
      openIndex: _openIndex,
      onChanged: (int? next) => setState(() => _openIndex = next),
    );
  }
}

const String _compositionCode = '''
ElAccordion(
  items: <ElAccordionItem>[
    ElAccordionItem(
      title: 'Refund policy, in full',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: const <Widget>[
          Text('Refunds are issued to the original payment method within '
              'five business days of approval.'),
          SizedBox(height: 8),
          Text('Store credit is available immediately as an alternative, '
              'and never expires.'),
        ],
      ),
    ),
  ],
  openIndex: openIndex,
  onChanged: (int? next) => setState(() => openIndex = next),
)''';

/// The literal "Basic" example: a second, smaller FAQ set demonstrating the
/// exact same single-open behavior as [_AccordionPreview] with different
/// copy, mirroring the reference's own repeated first example.
class _AccordionBasicPreview extends StatefulWidget {
  const _AccordionBasicPreview();

  @override
  State<_AccordionBasicPreview> createState() => _AccordionBasicPreviewState();
}

class _AccordionBasicPreviewState extends State<_AccordionBasicPreview> {
  int? _openIndex = 0;

  static final List<ElAccordionItem> _items = <ElAccordionItem>[
    ElAccordionItem(
      title: 'How long does shipping take?',
      content: ElText(
        'Orders ship within two business days and arrive in five to seven.',
        ElType.body,
      ),
    ),
    ElAccordionItem(
      title: 'Can I return an item?',
      content: ElText(
        'Yes, within thirty days of delivery, unworn and in its original '
        'packaging.',
        ElType.body,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ElAccordion(
      items: _items,
      openIndex: _openIndex,
      onChanged: (int? next) => setState(() => _openIndex = next),
    );
  }
}

const String _basicCode = '''
ElAccordion(
  items: const <ElAccordionItem>[
    ElAccordionItem(
      title: 'How long does shipping take?',
      content: Text('Orders ship within two business days.'),
    ),
    ElAccordionItem(
      title: 'Can I return an item?',
      content: Text('Yes, within thirty days of delivery.'),
    ),
  ],
  openIndex: openIndex,
  onChanged: (int? next) => setState(() => openIndex = next),
)''';

/// `ElAccordion` has no surface of its own: this specimen wraps it in
/// [ElCard] to show the FAQ with a header and an edge.
class _AccordionCardPreview extends StatefulWidget {
  const _AccordionCardPreview();

  @override
  State<_AccordionCardPreview> createState() => _AccordionCardPreviewState();
}

class _AccordionCardPreviewState extends State<_AccordionCardPreview> {
  int? _openIndex = 0;

  static final List<ElAccordionItem> _items = <ElAccordionItem>[
    ElAccordionItem(
      title: 'What plans are available?',
      content: ElText(
        'Starter, Pro, and Enterprise. Every plan bills monthly and can be '
        'changed at any time.',
        ElType.body,
      ),
    ),
    ElAccordionItem(
      title: 'Can I cancel anytime?',
      content: ElText(
        'Yes. Cancelling stops the next renewal; the current period stays '
        'active until it ends.',
        ElType.body,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ElCard(
      children: <Widget>[
        ElCardHeader(
          title: const ElCardTitle('Subscription & Billing'),
          description: const ElCardDescription(
            'Common questions about plans and billing.',
          ),
        ),
        ElCardContent(
          child: ElAccordion(
            items: _items,
            openIndex: _openIndex,
            onChanged: (int? next) => setState(() => _openIndex = next),
          ),
        ),
      ],
    );
  }
}

const String _cardCode = '''
ElCard(
  children: [
    ElCardHeader(
      title: const ElCardTitle('Subscription & Billing'),
      description: const ElCardDescription(
        'Common questions about plans and billing.',
      ),
    ),
    ElCardContent(
      child: ElAccordion(
        items: const <ElAccordionItem>[
          ElAccordionItem(
            title: 'What plans are available?',
            content: Text('Starter, Pro, and Enterprise.'),
          ),
        ],
        openIndex: openIndex,
        onChanged: (int? next) => setState(() => openIndex = next),
      ),
    ),
  ],
)''';
