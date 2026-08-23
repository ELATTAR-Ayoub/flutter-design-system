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
      breadcrumbs: const <DsBreadcrumbEntry>[
        DsBreadcrumbEntry.link('Components'),
        DsBreadcrumbEntry.page('Accordion'),
      ],
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Purpose', anchor: 'purpose'),
        DocsTocEntry(title: 'Status', anchor: 'status'),
        DocsTocEntry(title: 'Preview', anchor: 'preview'),
        DocsTocEntry(title: 'Installation', anchor: 'install'),
        DocsTocEntry(title: 'Usage', anchor: 'usage'),
        DocsTocEntry(title: 'API', anchor: 'api'),
        DocsTocEntry(title: 'Variants and sizes', anchor: 'variants'),
        DocsTocEntry(title: 'States', anchor: 'states'),
        DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
        DocsTocEntry(title: 'Responsive behavior', anchor: 'responsive'),
        DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
        DocsTocEntry(title: 'Composition', anchor: 'composition'),
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
      DsSection(
        id: 'purpose',
        title: 'When to reach for it',
        description:
            'Three disclosure patterns live in this system and they are '
            'not interchangeable — picking the wrong one is the most '
            'common misuse.',
        child: const _DecisionGuide(),
      ),
      SizedBox(height: ds(2)),
      DsSection(
        id: 'status',
        title: 'Status',
        child: const DocsInstallFacts(
          title: 'Status',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Status',
              value: 'Experimental',
              description:
                  'No registry manifest yet — see Installation below for '
                  'what that does and does not block.',
            ),
            DocsInstallFact(
              label: 'Version',
              value: '0.0.1',
              description: 'Tracks the package version this page ships with.',
            ),
            DocsInstallFact(
              label: 'Platforms',
              value: 'Android, iOS, Web, macOS, Windows, Linux',
              description:
                  'Pure widgets layer — no platform channel of its own, so '
                  'behavior does not vary by platform.',
            ),
          ],
        ),
      ),
      SizedBox(height: ds(2)),
      DsSection(
        id: 'preview',
        title: 'Live preview',
        description:
            'type="single" collapsible — one open panel, or none. Opening a '
            'second panel closes whichever was open; tapping the open '
            'panel\'s own trigger closes it too.',
        child: DocsCodeExample(
          title: 'Accordion specimen',
          description:
              'A three-item accordion with the first panel open by default.',
          preview: const _AccordionPreview(),
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(path: 'accordion_preview.dart', code: _previewCode),
          ],
        ),
      ),
      SizedBox(height: ds(2)),
      DsSection(
        id: 'install',
        title: 'Installation',
        description:
            'accordion is already reachable today through the published '
            'package — it is exported from the barrel — but it is not yet '
            'installable through the elattar CLI.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DsPanel(
              label: 'PACKAGE IMPORT',
              note: 'DART',
              child: const DocsSelectableCodeBlock(
                code:
                    "import 'package:elattar_design_system/"
                    "elattar_design_system.dart';\n",
              ),
            ),
            SizedBox(height: ds(4)),
            DocsInstallFacts(
              title: 'Manual and CLI facts',
              facts: <DocsInstallFact>[
                const DocsInstallFact(
                  label: 'CLI',
                  value: 'Not available yet',
                  description:
                      'accordion has no registry/components manifest, so '
                      '"elattar add accordion" will fail until a later '
                      'pass adds one. Use the package import above, or '
                      'copy the source file manually, in the meantime.',
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
                      'as registryDependencies, resolved by hand today.',
                ),
              ],
            ),
          ],
        ),
      ),
      SizedBox(height: ds(2)),
      DsSection(
        id: 'usage',
        title: 'Usage',
        description:
            'DsAccordion is always controlled: the caller owns openIndex '
            'and threads it back through onChanged. There is no '
            'uncontrolled or auto-managed variant.',
        child: DsPanel(
          label: 'DART',
          note: 'MINIMAL USAGE',
          child: const DocsSelectableCodeBlock(code: _usageCode),
        ),
      ),
      SizedBox(height: ds(2)),
      DsSection(
        id: 'api',
        title: 'API',
        description:
            'Every public constructor parameter on DsAccordion and '
            'DsAccordionItem.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const DocsApiTable(
              title: 'DsAccordion',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'items',
                  type: 'List<DsAccordionItem>',
                  description: 'The ordered set of trigger/content pairs.',
                ),
                DocsApiFact(
                  name: 'openIndex',
                  type: 'int?',
                  description:
                      'Which item is open, or null for none. Required — '
                      'the caller must state "nothing open" explicitly '
                      'rather than leaving it implicit.',
                ),
                DocsApiFact(
                  name: 'onChanged',
                  type: 'ValueChanged<int?>',
                  description:
                      'Reports the new openIndex. Tapping the already-open '
                      'item reports null, not its own index — that is '
                      'what "collapsible" means here.',
                ),
              ],
            ),
            SizedBox(height: ds(4)),
            const DocsApiTable(
              title: 'DsAccordionItem',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'title',
                  type: 'String',
                  description:
                      'The trigger\'s label and its only accessible name — '
                      'there is no separate label parameter.',
                ),
                DocsApiFact(
                  name: 'content',
                  type: 'Widget',
                  description:
                      'The panel\'s child. Any widget, not just text — see '
                      'Composition below.',
                ),
              ],
            ),
          ],
        ),
      ),
      SizedBox(height: ds(2)),
      DsSection(
        id: 'variants',
        title: 'Variants and sizes',
        description:
            'N/A — DsAccordion exposes no variant or size enum. Every '
            'accordion in the corpus renders through the same trigger and '
            'padding ladder; nothing here varies by prop.',
        child: const DocsApiTable(
          title: 'Fixed layout tokens (not variants)',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'DsAccordion.triggerPaddingY',
              type: 'static double',
              description:
                  '10px of vertical padding on the trigger (py-2.5), '
                  'reusable if you need to match the rhythm elsewhere.',
            ),
            DocsApiFact(
              name: 'DsAccordion.contentPaddingBottom',
              type: 'static double',
              description: '10px under the open panel\'s content (pb-2.5).',
            ),
            DocsApiFact(
              name: 'DsAccordion.chevronPx',
              type: 'static double',
              description:
                  '16px chevron size — the icon widget\'s own default, '
                  'not an accordion-specific variant.',
            ),
          ],
        ),
      ),
      SizedBox(height: ds(2)),
      DsSection(
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
                  'The chevron swaps from chevron-down to chevron-up — a '
                  'glyph swap, not a rotation — and the content mounts and '
                  'plays its unfold animation.',
              userSignal:
                  'Semantics(expanded: true) is published alongside the '
                  'visual swap, so the state is never color-only.',
            ),
            DocsStateFact(
              state: 'Empty',
              treatment: 'items: const [] renders a zero-height column.',
              userSignal:
                  'No built-in placeholder copy — compose one yourself if '
                  'an empty accordion needs messaging.',
            ),
            DocsStateFact(
              state: 'Disabled — N/A',
              treatment:
                  'DsAccordion and DsAccordionItem expose no enabled or '
                  'disabled parameter.',
              userSignal:
                  'A caller wanting a disabled row has to gate it outside '
                  'the component.',
            ),
            DocsStateFact(
              state: 'Loading — N/A',
              treatment:
                  'The toggle is synchronous; there is nothing to await.',
              userSignal: 'No async state exists to invent here.',
            ),
            DocsStateFact(
              state: 'Error / Success — N/A',
              treatment: 'A disclosure list carries no validation concept.',
              userSignal: 'Neither state applies to this primitive.',
            ),
            DocsStateFact(
              state: 'Reduced motion',
              treatment:
                  'Both the focus-ring transition and the panel\'s open/'
                  'close animation route through dsAnimationDuration.',
              userSignal:
                  'That duration collapses to zero when the platform\'s '
                  'disable-animations flag is on — transitions still '
                  'happen, instantly.',
            ),
          ],
        ),
      ),
      SizedBox(height: ds(2)),
      DsSection(
        id: 'accessibility',
        title: 'Accessibility',
        child: const _Bullets(
          items: <String>[
            'Each trigger publishes one merged Semantics node: '
                'button: true, expanded: <open state>, label: <title>.',
            'title is the only accessible name a trigger has — there is '
                'no separate label parameter, so it cannot be left as '
                'placeholder-style copy.',
            'Keyboard: Tab moves focus between triggers and paints the '
                'ring. Enter and Space are not wired to activation — only '
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
      SizedBox(height: ds(2)),
      DsSection(
        id: 'responsive',
        title: 'Responsive behavior',
        child: const _Bullets(
          items: <String>[
            'DsAccordion is a stretched Column with no breakpoints of its '
                'own — it always fills the width its parent gives it.',
            'A trigger title has no maxLines or overflow set, so a long '
                'question wraps onto more than one line instead of '
                'truncating.',
            'The chevron aligns with the first line of a wrapped title '
                '(items-start), not the vertical center of the block.',
          ],
        ),
      ),
      SizedBox(height: ds(2)),
      DsSection(
        id: 'dependencies',
        title: 'Dependencies, files, and assets',
        child: DocsInstallFacts(
          title: 'Dependencies',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Files',
              value: accordionDoc.sourcePath,
              description: 'One file — no companion sources.',
            ),
            DocsInstallFact(
              label: 'Component dependencies',
              value:
                  'button (focus-ring statics), collapsible (DsUnfold), '
                  'icon (chevron glyphs)',
              description: 'Sibling components imported directly.',
            ),
            DocsInstallFact(
              label: 'Foundation dependencies',
              value: 'source-foundation, machine-surface',
              description:
                  'Colors, motion, shadows, spacing, theme, typography, '
                  'and the DsMachineSurface effect used for the focus ring.',
            ),
            const DocsInstallFact(
              label: 'Assets, fonts, shaders',
              value: 'None',
              description:
                  'No image, font, or shader assets — text renders through '
                  'the ambient typography tokens already loaded elsewhere.',
            ),
          ],
        ),
      ),
      SizedBox(height: ds(2)),
      DsSection(
        id: 'composition',
        title: 'Composition',
        description:
            'content takes any Widget, not just a string — this specimen '
            'nests more than one paragraph inside a single panel.',
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
      SizedBox(height: ds(2)),
      DsSection(
        id: 'theming',
        title: 'Theming notes',
        child: const _Bullets(
          items: <String>[
            'theme.border paints the 1px seam under every item but the '
                'last (not-last:border-b).',
            'theme.foreground paints both the trigger label and the '
                'chevron — the reference\'s own muted-foreground variant '
                'on the chevron is dead CSS, so this port renders the '
                'measured color rather than the unreachable one.',
            'theme.ring, at the system\'s standard 0.50 alpha, is the only '
                'color the focus state adds; there is no separate hover '
                'or pressed fill.',
            'DsShadows.none is the trigger\'s resting elevation — the '
                'focus ring is the only shadow layer it ever gains.',
          ],
        ),
      ),
      SizedBox(height: ds(2)),
      DsSection(
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

class _DecisionGuide extends StatelessWidget {
  const _DecisionGuide();

  @override
  Widget build(BuildContext context) => DsPanel(
    label: 'DECISION GUIDE',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const <Widget>[
        _ComparisonRow(
          name: 'Accordion (this component)',
          body:
              'A set of related disclosures — an FAQ list is the '
              'canonical case — where only one panel should stay open at '
              'a time.',
        ),
        _ComparisonRow(
          name: 'Collapsible',
          body:
              'One independent disclosure with nothing else to coordinate '
              'with, like a lone advanced-filters panel. Accordion is '
              'built on the same DsUnfold animation, so open/close pacing '
              'matches exactly.',
        ),
        _ComparisonRow(
          name: 'Tabs',
          body:
              'Replaces the visible content outright behind persistent, '
              'always-visible triggers. Reach for tabs when the choices '
              'are peers; reach for accordion when the content is meant '
              'to be read top-to-bottom with one section expanded at a '
              'time.',
        ),
      ],
    ),
  );
}

class _ComparisonRow extends StatelessWidget {
  const _ComparisonRow({required this.name, required this.body});

  final String name;
  final String body;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: ds(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText(name, DsType.label, color: theme.actionInk),
          SizedBox(height: ds(1.5)),
          DsText(body, DsType.small),
        ],
      ),
    );
  }
}

class _Bullets extends StatelessWidget {
  const _Bullets({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return DsPanel(
      label: 'GUIDANCE',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (int index = 0; index < items.length; index++) ...<Widget>[
            if (index > 0) SizedBox(height: ds(3)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: ds(1.5)),
                  child: Container(
                    width: ds(1.5),
                    height: ds(1.5),
                    decoration: BoxDecoration(
                      color: theme.actionInk,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                SizedBox(width: ds(3)),
                Expanded(child: DsText(items[index], DsType.small)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// The primary live specimen — three items, the first open by default,
/// matching the reference's own `defaultValue="odds"` mount.
class _AccordionPreview extends StatefulWidget {
  const _AccordionPreview();

  @override
  State<_AccordionPreview> createState() => _AccordionPreviewState();
}

class _AccordionPreviewState extends State<_AccordionPreview> {
  int? _openIndex = 0;

  static final List<DsAccordionItem> _items = <DsAccordionItem>[
    DsAccordionItem(
      title: 'What does single and collapsible mean here?',
      content: DsText(
        'Only one panel can stay open. Opening a second panel closes the '
        'first, and tapping an already-open trigger closes it, so the '
        'set can end with nothing expanded.',
        DsType.body,
      ),
    ),
    DsAccordionItem(
      title: 'Does the chevron rotate?',
      content: DsText(
        'No. The port renders two separate glyphs, chevron-down and '
        'chevron-up, and swaps which one is visible. Nothing on the '
        'icon animates a rotation.',
        DsType.body,
      ),
    ),
    DsAccordionItem(
      title: 'What happens with a long question?',
      content: DsText(
        'The label wraps onto more than one line if it needs to. The '
        'chevron stays aligned with the first line instead of '
        're-centering on the full block.',
        DsType.body,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DsAccordion(
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
    return DsAccordion(
      items: const <DsAccordionItem>[
        DsAccordionItem(
          title: 'What does single and collapsible mean here?',
          content: Text('Only one panel can stay open at a time.'),
        ),
        DsAccordionItem(
          title: 'Does the chevron rotate?',
          content: Text('No — it swaps between two glyphs.'),
        ),
      ],
      openIndex: _openIndex,
      onChanged: (int? next) => setState(() => _openIndex = next),
    );
  }
}''';

const String _usageCode = '''
DsAccordion(
  items: const <DsAccordionItem>[
    DsAccordionItem(
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

  late final List<DsAccordionItem> _items = <DsAccordionItem>[
    DsAccordionItem(
      title: 'Refund policy, in full',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DsText(
            'Refunds are issued to the original payment method within '
            'five business days of approval.',
            DsType.body,
          ),
          const SizedBox(height: 8),
          DsText(
            'Store credit is available immediately as an alternative, and '
            'never expires.',
            DsType.body,
          ),
        ],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DsAccordion(
      items: _items,
      openIndex: _openIndex,
      onChanged: (int? next) => setState(() => _openIndex = next),
    );
  }
}

const String _compositionCode = '''
DsAccordion(
  items: <DsAccordionItem>[
    DsAccordionItem(
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
