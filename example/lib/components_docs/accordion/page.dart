/// Public component documentation for the accordion component.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

class AccordionDocPage extends StatelessWidget {
  const AccordionDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    return DocsLayout(
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
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Installation', anchor: 'install'),
        DocsTocEntry(title: 'Usage', anchor: 'usage'),
        DocsTocEntry(title: 'Composition', anchor: 'composition'),
        DocsTocEntry(title: 'Basic', anchor: 'basic'),
        DocsTocEntry(title: 'Card', anchor: 'card'),
        DocsTocEntry(title: 'API Reference', anchor: 'api'),
        DocsTocEntry(title: 'States', anchor: 'states'),
        DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
        DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
        DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
        DocsTocEntry(title: 'Theming', anchor: 'theming'),
        DocsTocEntry(title: 'Source', anchor: 'source'),
      ],
      // Forward references into the same wave: `select` already routes
      // (Phase F); `alert` lands alongside `accordion` once every Wave 1
      // worker's page is wired in by the supervisor.
      previous: const DocsPageLink(
        title: 'Select',
        route: '/components/select',
      ),
      next: const DocsPageLink(title: 'Alert', route: '/components/alert'),
      onNavigate: onNavigate,
      child: const _AccordionArticle(),
    );
  }
}

class _AccordionArticle extends StatelessWidget {
  const _AccordionArticle();

  @override
  Widget build(BuildContext context) => Column(
    key: const ValueKey<String>('accordion-doc-article'),
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: ElWidths.prose),
        child: ElText(
          'type="single" collapsible: one open panel, or none. Opening a '
          'second panel closes whichever was open; tapping the open '
          'panel\'s own trigger closes it too.',
          ElType.body,
        ),
      ),
      SizedBox(height: el(6)),
      DocsCodeExample(
        title: 'Accordion specimen',
        description:
            'A three-item accordion with the first panel open by default.',
        preview: const _AccordionPreview(),
        manualFiles: const <DocsCodeFile>[
          DocsCodeFile(path: 'accordion_preview.dart', code: _previewCode),
        ],
      ),
      SizedBox(height: el(2)),
      ElSection(
        id: 'install',
        title: 'Installation',
        description:
            'accordion is already reachable today through the published '
            'package: it is exported from the barrel: but it is not yet '
            'installable through the elattar CLI.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElPanel(
              label: 'PACKAGE IMPORT',
              note: 'DART',
              child: const DocsSelectableCodeBlock(
                code:
                    "import 'package:elattar_design_system/"
                    "elattar_design_system.dart';\n",
              ),
            ),
            SizedBox(height: el(4)),
            DocsInstallFacts(
              title: 'Manual and CLI facts',
              facts: <DocsInstallFact>[
                const DocsInstallFact(
                  label: 'CLI',
                  value: 'elattar add accordion',
                  description:
                      'Installs registry/components/accordion.json and its '
                      'declared dependency closure.',
                ),
                DocsInstallFact(
                  label: 'Manual copy target',
                  value: 'lib/components/ui/accordion.dart',
                  description:
                      'Copy ${accordionDoc.sourcePath} into components/ui '
                      'and keep its relative imports pointed at the same '
                      'foundation and sibling-component files.',
                ),
                DocsInstallFact(
                  label: 'Registry dependencies',
                  value: accordionDoc.dependencies.join(', '),
                  description:
                      'What a future registry manifest would need to list '
                      'as registryDependencies, read directly from the shipped manifest.',
                ),
              ],
            ),
          ],
        ),
      ),
      SizedBox(height: el(2)),
      ElSection(
        id: 'usage',
        title: 'Usage',
        description:
            'ElAccordion is always controlled: the caller owns openIndex '
            'and threads it back through onChanged. There is no '
            'uncontrolled or auto-managed variant.',
        child: ElPanel(
          label: 'DART',
          note: 'MINIMAL USAGE',
          child: const DocsSelectableCodeBlock(code: _usageCode),
        ),
      ),
      SizedBox(height: el(2)),
      ElSection(
        id: 'composition',
        title: 'Composition',
        description:
            'ElAccordion takes data, not children: items is a '
            'List<ElAccordionItem>, each one a title and a content widget, '
            'rather than a tree of separate Accordion/AccordionItem/'
            'AccordionTrigger sub-widgets to assemble by hand. content still '
            'accepts any Widget, not just a string: this specimen nests more '
            'than one paragraph inside a single panel.',
        child: DocsCodeExample(
          title: 'Multi-paragraph content',
          preview: const _AccordionCompositionPreview(),
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(
              path: 'accordion_composition.dart',
              code: _compositionCode,
            ),
          ],
        ),
      ),
      SizedBox(height: el(2)),
      ElSection(
        id: 'basic',
        title: 'Basic',
        description:
            'A basic accordion that shows one item at a time, the first '
            'item open by default: the same collapsible behavior as the '
            'preview above, with different copy.',
        child: DocsCodeExample(
          title: 'Shipping and returns',
          preview: const _AccordionBasicPreview(),
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(path: 'accordion_basic.dart', code: _basicCode),
          ],
        ),
      ),
      SizedBox(height: el(2)),
      ElSection(
        id: 'card',
        title: 'Card',
        description:
            'ElAccordion has no surface of its own: wrap it in ElCard when '
            'the FAQ needs a header and an edge, same as any other content.',
        child: DocsCodeExample(
          title: 'Accordion inside a card',
          preview: const _AccordionCardPreview(),
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(path: 'accordion_card.dart', code: _cardCode),
          ],
        ),
      ),
      SizedBox(height: el(2)),
      ElSection(
        id: 'api',
        title: 'API Reference',
        description:
            'Every public constructor parameter on ElAccordion and '
            'ElAccordionItem, plus the fixed layout constants that stand in '
            'for a variant or size enum, since ElAccordion has neither.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const DocsApiTable(
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
                      'Which item is open, or null for none. Required, '
                      'the caller must state "nothing open" explicitly '
                      'rather than leaving it implicit.',
                ),
                DocsApiFact(
                  name: 'onChanged',
                  type: 'ValueChanged<int?>',
                  description:
                      'Reports the new openIndex. Tapping the already-open '
                      'item reports null, not its own index: that is '
                      'what "collapsible" means here.',
                ),
              ],
            ),
            SizedBox(height: el(4)),
            const DocsApiTable(
              title: 'ElAccordionItem',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'title',
                  type: 'String',
                  description:
                      'The trigger\'s label and its only accessible name, '
                      'there is no separate label parameter.',
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
            SizedBox(height: el(4)),
            const DocsApiTable(
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
                      '16px chevron size: the icon widget\'s own default, '
                      'not an accordion-specific variant. ElAccordion '
                      'exposes no variant or size enum: every accordion '
                      'renders through this same trigger and padding '
                      'ladder.',
                ),
              ],
            ),
          ],
        ),
      ),
      SizedBox(height: el(2)),
      ElSection(
        id: 'states',
        title: 'States',
        child: const DocsStateMatrix(
          facts: <DocsStateFact>[
            DocsStateFact(
              state: 'Rest',
              treatment: 'Closed panel; chevron-down; transparent border.',
              userSignal:
                  'Trigger reads as an inert row until interacted with.',
            ),
            DocsStateFact(
              state: 'Hover',
              treatment: 'The label alone gains an underline.',
              userSignal: 'No background or surface change on hover.',
            ),
            DocsStateFact(
              state: 'Focus-visible',
              treatment:
                  'A hairline border fades in to the ring color, animated '
                  'on the same duration as every other focus ring.',
              userSignal:
                  'Focus is reached by Tab; the trigger never calls '
                  'requestFocus() on tap, so pointer interaction alone '
                  'does not paint the ring.',
            ),
            DocsStateFact(
              state: 'Pressed',
              treatment:
                  'No dedicated pressed/scale treatment is wired for this '
                  'trigger.',
              userSignal:
                  'A tap resolves directly into the open/close transition '
                  'instead of a press-down affordance.',
            ),
            DocsStateFact(
              state: 'Selected (open)',
              treatment:
                  'The chevron swaps from chevron-down to chevron-up: a '
                  'glyph swap, not a rotation: and the content mounts and '
                  'plays its unfold animation.',
              userSignal:
                  'Semantics(expanded: true) is published alongside the '
                  'visual swap, so the state is never color-only.',
            ),
            DocsStateFact(
              state: 'Empty',
              treatment: 'items: const [] renders a zero-height column.',
              userSignal:
                  'No built-in placeholder copy: compose one yourself if '
                  'an empty accordion needs messaging.',
            ),
            DocsStateFact(
              state: 'Disabled, N/A',
              treatment:
                  'ElAccordion and ElAccordionItem expose no enabled or '
                  'disabled parameter.',
              userSignal:
                  'A caller wanting a disabled row has to gate it outside '
                  'the component.',
            ),
            DocsStateFact(
              state: 'Loading, N/A',
              treatment:
                  'The toggle is synchronous; there is nothing to await.',
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
                  'Both the focus-ring transition and the panel\'s open/'
                  'close animation route through elAnimationDuration.',
              userSignal:
                  'That duration collapses to zero when the platform\'s '
                  'disable-animations flag is on: transitions still '
                  'happen, instantly.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(2)),
      ElSection(
        id: 'accessibility',
        title: 'Accessibility',
        child: const _Bullets(
          items: <String>[
            'Each trigger publishes one merged Semantics node: '
                'button: true, expanded: <open state>, label: <title>.',
            'title is the only accessible name a trigger has: there is '
                'no separate label parameter, so it cannot be left as '
                'placeholder-style copy.',
            'Keyboard: Tab moves focus between triggers and paints the '
                'ring. Enter and Space are not wired to activation: only '
                'a pointer or touch tap toggles the panel today.',
            'The measured trigger height is about 40.56px, under the '
                'common 44–48px touch-target guidance; treat tap targets '
                'accordingly on touch platforms.',
            'Open/closed state is never color-only: the chevron glyph '
                'swap is the non-color signal alongside the Semantics '
                'expanded flag.',
            'No error or validation wiring applies to a disclosure list.',
          ],
        ),
      ),
      SizedBox(height: el(2)),
      ElSection(
        id: 'responsive',
        title: 'Responsive',
        child: const _Bullets(
          items: <String>[
            'ElAccordion is a stretched Column with no breakpoints of its '
                'own: it always fills the width its parent gives it.',
            'A trigger title has no maxLines or overflow set, so a long '
                'question wraps onto more than one line instead of '
                'truncating.',
            'The chevron aligns with the first line of a wrapped title '
                '(items-start), not the vertical center of the block.',
          ],
        ),
      ),
      SizedBox(height: el(2)),
      ElSection(
        id: 'dependencies',
        title: 'Dependencies',
        child: DocsInstallFacts(
          title: 'Dependencies',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Files',
              value: accordionDoc.sourcePath,
              description: 'One file: no companion sources.',
            ),
            DocsInstallFact(
              label: 'Component dependencies',
              value:
                  'button (focus-ring statics), collapsible (ElUnfold), '
                  'icon (chevron glyphs)',
              description: 'Sibling components imported directly.',
            ),
            DocsInstallFact(
              label: 'Foundation dependencies',
              value: 'source-foundation, machine-surface',
              description:
                  'Colors, motion, shadows, spacing, theme, typography, '
                  'and the ElMachineSurface effect used for the focus ring.',
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
      ),
      SizedBox(height: el(2)),
      ElSection(
        id: 'theming',
        title: 'Theming',
        child: const _Bullets(
          items: <String>[
            'theme.border paints the 1px seam under every item but the '
                'last (not-last:border-b).',
            'theme.foreground paints both the trigger label and the '
                'chevron: the reference\'s own muted-foreground variant '
                'on the chevron is dead CSS, so this port renders the '
                'measured color rather than the unreachable one.',
            'theme.ring, at the system\'s standard 0.50 alpha, is the only '
                'color the focus state adds; there is no separate hover '
                'or pressed fill.',
            'ElShadows.none is the trigger\'s resting elevation: the '
                'focus ring is the only shadow layer it ever gains.',
          ],
        ),
      ),
      SizedBox(height: el(2)),
      ElSection(
        id: 'source',
        title: 'Source',
        child: DocsInstallFacts(
          title: 'Source references',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Package file',
              value: accordionDoc.sourcePath,
              description: 'The authoritative Flutter source for this page.',
            ),
            DocsInstallFact(
              label: 'Exports',
              value: accordionDoc.exports.join(', '),
              description: 'Public symbols available after import.',
            ),
            const DocsInstallFact(
              label: 'Tests',
              value: 'example/test/components_docs/accordion_test.dart',
              description: 'This page\'s own test coverage.',
            ),
            const DocsInstallFact(
              label: 'Docs source',
              value: 'example/lib/components_docs/accordion/page.dart',
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

class _Bullets extends StatelessWidget {
  const _Bullets({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return ElPanel(
      label: 'GUIDANCE',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (int index = 0; index < items.length; index++) ...<Widget>[
            if (index > 0) SizedBox(height: el(3)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: el(1.5)),
                  child: Container(
                    width: el(1.5),
                    height: el(1.5),
                    decoration: BoxDecoration(
                      color: theme.actionInk,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                SizedBox(width: el(3)),
                Expanded(child: ElText(items[index], ElType.small)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

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
