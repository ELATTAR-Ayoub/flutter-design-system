/// Public documentation page for the `sheet` component.
///
/// **Split from a combined page.** `sheet` and `drawer` used to share one
/// page and one [ComponentDocEntry] because they read as the same idea at
/// different edges. The owner asked for one component per page instead: this
/// file documents `lib/src/components/ui/sheet.dart` alone.
/// `lib/src/components/ui/drawer.dart` has its own page and its own directory,
/// `../drawer/page.dart`, not this one.
///
/// **Re-housed onto the kit.** This page used to hand-compose [Section]
/// panels shaped to mirror shadcn's own sheet page section for section; it
/// now declares a [ComponentDocSpec]
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// [ComponentDocPage], the same shape `button` and `alert_dialog`
/// established. Every specimen widget and every code string below is the
/// one the hand-composed page carried; new in this pass: the unheaded live
/// demo is now its own Preview `ShowcaseSection`, and a dedicated Keyboard
/// disclosure is split out of the old combined "Accessibility and keyboard
/// behavior" section.
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
import '../../docs/docs_section.dart' show DocsAnchor;
import 'meta.dart';

final ComponentDocSpec sheetDocSpec = ComponentDocSpec(
  name: 'sheet',
  title: sheetDoc.title,
  description: sheetDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'Every edge SheetOverlay supports. Open one, then dismiss it '
          'by tapping the scrim, pressing Escape, or the close button.',
      specimen: _SheetSidesPreview(keyPrefix: 'sheet-preview'),
      code: _sheetUsageCode,
      label: 'Sheet specimen',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'Already reachable today through both the published package and '
          'the registry: it is barrel-exported and elattar add sheet '
          'resolves its shipped manifest, whose registryDependencies are '
          '${sheetDoc.dependencies.join(', ')}.',
      command: sheetDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/sheet.dart',
          description:
              'Copy ${sheetDoc.sourcePath} into components/ui and keep '
              'its relative imports pointed at the same foundation and '
              'sibling-component files (dialog.dart in particular: see '
              'Dependencies).',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated sheet source here when using manual '
              'mode.',
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'Uncontrolled, like Dialog: the open/close boolean lives '
          'inside OverlayPortal and the trigger only ever gets a '
          'callback. SheetOverlay exposes no onOpenChange callback the '
          "way Dialog does: a real gap against the dialog's own API, "
          'not an omission from this page.',
      code: _sheetUsageCode,
    ),
    SnippetSection(
      id: 'composition',
      title: 'Composition',
      description:
          'children accepts any Widget, not just header/footer/title/'
          "description: the reference's own filter sheet on the dialogs "
          'page (example/lib/pages/dialogs.dart) puts a live Slider '
          'straight inside a SheetContent.',
      code: _compositionCode,
    ),
    ShowcaseSection(
      id: 'side',
      title: 'Side',
      description:
          'SheetSide chooses which edge the panel anchors to and '
          "slides from: top, right (the component's own default), "
          'bottom, or left. SheetSide.bottom is NOT the same component '
          'as Drawer: a bottom-side sheet has no grip handle and no drag '
          'gesture, and animates on the 320ms overlay ease-out curve, '
          "not the drawer's 500ms cubic-bezier. See the Drawer page for "
          'that component.',
      specimen: _SheetSidesPreview(keyPrefix: 'sheet-example-side'),
      code: _sideCode,
      label: 'Side specimen view',
    ),
    ShowcaseSection(
      id: 'no-close-button',
      title: 'No close button',
      description:
          'showCloseButton: false on SheetContent drops the labelled X '
          "in the corner entirely: no X mounts, and the header's own "
          'right padding collapses from 48px back down to 16px, the same '
          'padding it reserves on every other side. The caller becomes '
          'responsible for supplying its own way to close the panel.',
      specimen: _NoCloseButtonPreview(),
      code: _noCloseButtonCode,
      label: 'No close button specimen view',
      minHeight: space(64),
    ),
    ShowcaseSection(
      id: 'rtl',
      title: 'RTL',
      description:
          'DOCUMENTED DRIFT: side is a physical edge, not a logical '
          'start/end. SheetSide.left always renders against the '
          "screen's physical left, even under a right-to-left "
          'Directionality, because SheetOverlay aligns with '
          'Alignment.centerLeft/centerRight rather than an '
          "AlignmentDirectional pair. Only the panel's own text (title, "
          'description, and any body content) picks up RTL reading order '
          'and cross-axis alignment automatically. A caller building a '
          'fully mirrored RTL layout has to flip left and right '
          'explicitly at the call site; SheetOverlay does not do it '
          'for them.',
      specimen: _RtlPreview(),
      code: _rtlCode,
      label: 'RTL specimen view',
      minHeight: space(64),
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every public constructor parameter declared on every public '
          'class or enum in lib/src/components/ui/sheet.dart: one table '
          'each.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'SheetOverlay', anchor: 'api-elsheetoverlay'),
        DocsTocEntry(title: 'SheetContent', anchor: 'api-elsheetcontent'),
        DocsTocEntry(
          title: 'SheetContent static helpers',
          anchor: 'api-elsheetcontent-static',
        ),
        DocsTocEntry(title: 'SheetHeader', anchor: 'api-elsheetheader'),
        DocsTocEntry(title: 'SheetFooter', anchor: 'api-elsheetfooter'),
        DocsTocEntry(title: 'SheetTitle', anchor: 'api-elsheettitle'),
        DocsTocEntry(
          title: 'SheetDescription',
          anchor: 'api-elsheetdescription',
        ),
        DocsTocEntry(title: 'SheetSide', anchor: 'api-elsheetside'),
        DocsTocEntry(title: 'SheetTransition', anchor: 'api-elsheettransition'),
        DocsTocEntry(
          title: 'SheetContentGroup',
          anchor: 'api-elsheetcontentgroup',
        ),
        DocsTocEntry(
          title: 'Sheet static helpers',
          anchor: 'api-elsheet-static',
        ),
        DocsTocEntry(title: 'SheetPanel', anchor: 'api-elsheetpanel'),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Read straight off SheetOverlay, SheetContent, and the '
          'shared OverlayPortal both ride.',
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
          'sheet.dart wires no key handling of its own: every fact here '
          'belongs to the shared OverlayPortal it rides '
          '(lib/src/components/ui/dialog.dart).',
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
            value: sheetDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/dialogs_test.dart, test/sidebar_test.dart',
            description:
                'SheetOverlay and Sheet.showLeft are covered inside '
                'these two suites; there is no dedicated sheet_test.dart '
                'in the package itself.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/sheet_test.dart',
            description:
                'Covers this page: the article mounts, every documented '
                'constructor parameter appears in an API table, the '
                'section order matches this file, and a live '
                'SheetOverlay actually opens and dismisses.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/sheet/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class SheetDocPage extends StatelessWidget {
  const SheetDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: sheetDoc.route,
    intro: DocsPageIntro(
      title: sheetDoc.title,
      description: sheetDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Sheet'),
    ],
    toc: sheetDocSpec.toc,
    previous: const DocsPageLink(title: 'Dialog', route: '/components/dialog'),
    next: const DocsPageLink(title: 'Sidebar', route: '/components/sidebar'),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('sheet-doc-article'),
      child: ComponentDocPage(spec: sheetDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

const String _sheetUsageCode = '''SheetOverlay(
  side: SheetSide.right,
  trigger: (context, open) => Button(
    onPressed: open,
    child: const Text('Open filters'),
  ),
  content: (context, close) => SheetContent(
    onClose: close,
    children: <Widget>[
      SheetHeader(children: <Widget>[
        SheetTitle('Filter packs'),
        SheetDescription('184 packs match your current filters.'),
      ]),
      SheetFooter(children: <Widget>[
        Button(onPressed: close, child: const Text('Apply filters')),
      ]),
    ],
  ),
)''';

/// A trimmed, real excerpt of `example/lib/pages/dialogs.dart`'s own filter
/// sheet: proof that `children` takes live, stateful controls and not only
/// the header/footer/title/description anatomy.
const String _compositionCode = '''SheetContent(
  side: side,
  onClose: close,
  children: <Widget>[
    SheetHeader(children: <Widget>[
      SheetTitle('Filter packs'),
      SheetDescription('184 packs match your current filters.'),
    ]),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: space(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          StyledText('Price range', TextStyles.small),
          SizedBox(height: space(4)),
          Slider(
            values: price,
            max: 500,
            step: 5,
            onChanged: (values) => setState(() => price = values),
          ),
        ],
      ),
    ),
    SheetFooter(children: <Widget>[
      Button(onPressed: () {}, child: const Text('Apply filters')),
    ]),
  ],
)''';

const String _sideCode = '''SheetOverlay(
  side: SheetSide.left,
  trigger: (context, open) => Button(
    onPressed: open,
    child: const Text('Open left'),
  ),
  content: (context, close) => SheetContent(
    side: SheetSide.left,
    onClose: close,
    children: const <Widget>[
      SheetHeader(children: <Widget>[
        SheetTitle('Notification settings'),
      ]),
    ],
  ),
)''';

const String _noCloseButtonCode = '''SheetContent(
  showCloseButton: false,
  children: <Widget>[
    SheetHeader(children: <Widget>[
      SheetTitle('Share link'),
      SheetDescription('Anyone with this link can view this document.'),
    ]),
  ],
)''';

const String _rtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: SheetContent(
    children: <Widget>[
      SheetHeader(children: <Widget>[
        SheetTitle('مشاركة الرابط'),
        SheetDescription('يمكن لأي شخص لديه هذا الرابط عرض هذا المستند.'),
      ]),
    ],
  ),
)''';

/// One [SheetOverlay] per [SheetSide] value, keyed by [keyPrefix] so the
/// same specimen can mount twice on this page (the Preview hero and the
/// Side section's own live example) without a duplicate-key collision.
class _SheetSidesPreview extends StatelessWidget {
  const _SheetSidesPreview({required this.keyPrefix});

  final String keyPrefix;

  Widget _specimen(SheetSide side) => SheetOverlay(
    side: side,
    trigger: (BuildContext context, VoidCallback open) => Button(
      key: ValueKey<String>('$keyPrefix:${side.name}'),
      variant: ButtonVariant.outline,
      onPressed: open,
      child: Text('Open ${side.name}'),
    ),
    content: (BuildContext context, VoidCallback close) => SheetContent(
      side: side,
      onClose: close,
      children: <Widget>[
        const SheetHeader(
          children: <Widget>[
            SheetTitle('Notification settings'),
            SheetDescription('Choose what you want to hear about.'),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: space(4)),
          child: StyledText(
            'This panel opened from the ${side.name} edge.',
            TextStyles.body,
          ),
        ),
        SheetFooter(
          children: <Widget>[
            Button(onPressed: close, child: const Text('Save changes')),
          ],
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: space(3),
    runSpacing: space(3),
    children: <Widget>[
      for (final SheetSide side in SheetSide.values) _specimen(side),
    ],
  );
}

/// The No close button section's own live specimen: a static, unopened
/// [SheetContent] (no [SheetOverlay]/[OverlayPortal] needed, since the
/// panel is presentational and does not require an [Overlay] ancestor) with
/// showCloseButton: false. side: bottom so its width stays natural instead
/// of SheetContent's own double.infinity height on a horizontal side.
///
/// A bottom-side [SheetContent] still builds a `Column` with the default
/// `mainAxisSize.max`, which asserts if the incoming height is unbounded —
/// as it is here, one level inside the showcase stage's own scroll body — so
/// this wraps it in a fixed-height [SizedBox] first, the same way a bounded
/// viewport height would in the real, portal-mounted case. That stand-in
/// height is scaled by the ambient [TextScaler]: a real, portal-mounted
/// sheet gets the actual device viewport, dwarfing this fixed box, so it is
/// this specimen's artificially small height — not the title/description
/// text — that is the synthetic constraint. Scaling it keeps the header
/// readable instead of overflowing as the text grows.
class _NoCloseButtonPreview extends StatelessWidget {
  const _NoCloseButtonPreview();

  @override
  Widget build(BuildContext context) => SizedBox(
    height: space(64) * MediaQuery.textScalerOf(context).scale(1),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
      child: const SheetContent(
        key: ValueKey<String>('sheet-no-close-button'),
        side: SheetSide.bottom,
        showCloseButton: false,
        children: <Widget>[
          SheetHeader(
            children: <Widget>[
              SheetTitle('Share link'),
              SheetDescription('Anyone with this link can view this document.'),
            ],
          ),
        ],
      ),
    ),
  );
}

/// The RTL section's own live specimen: the same static-panel, fixed-height
/// technique as [_NoCloseButtonPreview], wrapped in a right-to-left
/// [Directionality] so the text-direction flip is real and live, not merely
/// described. Arabic title/description prove the text itself reads RTL; the
/// panel keeps its own physical [SheetSide.bottom] regardless,
/// illustrating the documented-drift claim in this section's description.
class _RtlPreview extends StatelessWidget {
  const _RtlPreview();

  @override
  Widget build(BuildContext context) => SizedBox(
    // Same textScaler-scaled stand-in height as [_NoCloseButtonPreview].
    height: space(64) * MediaQuery.textScalerOf(context).scale(1),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
      child: const Directionality(
        textDirection: TextDirection.rtl,
        child: SheetContent(
          key: ValueKey<String>('sheet-rtl'),
          side: SheetSide.bottom,
          children: <Widget>[
            SheetHeader(
              children: <Widget>[
                SheetTitle('مشاركة الرابط'),
                SheetDescription(
                  'يمكن لأي شخص لديه هذا الرابط عرض هذا المستند.',
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elsheetoverlay',
        child: DocsApiTable(title: 'SheetOverlay', facts: _overlayFacts),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elsheetcontent',
        child: DocsApiTable(title: 'SheetContent', facts: _contentFacts),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elsheetcontent-static',
        child: DocsApiTable(
          title: 'SheetContent static helpers',
          facts: _contentStaticFacts,
        ),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elsheetheader',
        child: DocsApiTable(title: 'SheetHeader', facts: _headerFacts),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elsheetfooter',
        child: DocsApiTable(title: 'SheetFooter', facts: _footerFacts),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elsheettitle',
        child: DocsApiTable(title: 'SheetTitle', facts: _titleFacts),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elsheetdescription',
        child: DocsApiTable(
          title: 'SheetDescription',
          facts: _descriptionFacts,
        ),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elsheetside',
        child: DocsApiTable(title: 'SheetSide (enum)', facts: _sideFacts),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elsheettransition',
        child: DocsApiTable(title: 'SheetTransition', facts: _transitionFacts),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elsheetcontentgroup',
        child: DocsApiTable(
          title: 'SheetContentGroup',
          facts: _contentGroupFacts,
        ),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elsheet-static',
        child: DocsApiTable(
          title: 'Sheet static helpers',
          facts: _dsSheetStaticFacts,
        ),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elsheetpanel',
        child: DocsApiTable(title: 'SheetPanel', facts: _panelFacts),
      ),
    ],
  );
}

const List<DocsApiFact> _overlayFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'trigger',
    type: 'ModalTriggerBuilder',
    description: 'Required. Builds the control that opens the portal.',
  ),
  DocsApiFact(
    name: 'content',
    type: 'ModalContentBuilder',
    description: 'Required. Builds the panel and receives its close callback.',
  ),
  DocsApiFact(
    name: 'side',
    type: 'SheetSide',
    description:
        'Optional. Defaults to SheetSide.right, the component\'s own '
        'default. Which edge the panel anchors to and slides from.',
  ),
];

const List<DocsApiFact> _contentFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'children',
    type: 'List<Widget>',
    description:
        'Required. The column\'s contents, in order. A SheetFooter '
        'among them is pushed to the bottom automatically (mt-auto).',
  ),
  DocsApiFact(
    name: 'side',
    type: 'SheetSide',
    description:
        'Optional. Defaults to SheetSide.right. Which edge to render '
        'the panel against; also decides which side gets the hairline '
        'border and which safe-area edges are excluded.',
  ),
  DocsApiFact(
    name: 'showCloseButton',
    type: 'bool',
    description:
        'Optional. Defaults to true. Adds the labelled X in the corner; '
        'when true, the header also reserves 48px of right padding '
        'instead of 16px.',
  ),
  DocsApiFact(
    name: 'onClose',
    type: 'VoidCallback?',
    description:
        'Optional. Defaults to null. Wired by SheetOverlay\'s portal; '
        'the close button calls it.',
  ),
  DocsApiFact(
    name: 'width',
    type: 'double?',
    description:
        'Optional. Defaults to null, which falls back to '
        'SheetContent.maxWidth (384px), then SheetContent.widthFor\'s '
        'compact clamp. Overrides the panel\'s width on a horizontal '
        'side only.',
  ),
  DocsApiFact(
    name: 'fill',
    type: 'Color?',
    description:
        'Optional. Defaults to null, which falls back to theme.popover. '
        'Overrides the panel\'s background colour.',
  ),
];

const List<DocsApiFact> _contentStaticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'SheetContent.maxWidth',
    type: 'static double',
    description:
        '384px (Containers.sm): the horizontal panel\'s default width '
        'before the width override or the compact-viewport clamp.',
  ),
  DocsApiFact(
    name: 'SheetContent.gap',
    type: 'static double',
    description: '16px (space(4)) between children in the column.',
  ),
  DocsApiFact(
    name: 'SheetContent.widthFor(width, viewport)',
    type: 'static double Function(double, Size)',
    description:
        'Clamps a horizontal panel to 90% of viewport width '
        '(CompactDialogLayout.maxWidthFraction) at or below the 600px '
        'compact breakpoint (CompactDialogLayout.breakpoint).',
  ),
];

const List<DocsApiFact> _headerFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'children',
    type: 'List<Widget>',
    description:
        'Required. The header\'s stacked contents (2px gap between '
        'them). Painted as a muted band (theme.muted at 50% alpha) with '
        'a bottom hairline rule.',
  ),
];

const List<DocsApiFact> _footerFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'children',
    type: 'List<Widget>',
    description:
        'Required. The footer\'s stacked CTAs (8px gap): a column, not '
        'a row, since a sheet\'s actions stack. Painted as the same '
        'muted band with a top hairline rule, pushed to the bottom of '
        'the panel.',
  ),
];

const List<DocsApiFact> _titleFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'text',
    type: 'String (positional)',
    description:
        'Required. The title\'s only content, rendered in '
        'theme.foreground.',
  ),
];

const List<DocsApiFact> _descriptionFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'text',
    type: 'String (positional)',
    description:
        'Required. The description\'s only content, rendered in '
        'theme.mutedForeground.',
  ),
];

const List<DocsApiFact> _sideFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'top',
    type: 'SheetSide',
    description: 'Panel spans the top edge, sized by height.',
  ),
  DocsApiFact(
    name: 'right',
    type: 'SheetSide',
    description:
        'The constructor default on both SheetOverlay and '
        'SheetContent. Panel pins to the trailing edge, sized by '
        'width.',
  ),
  DocsApiFact(
    name: 'bottom',
    type: 'SheetSide',
    description:
        'Panel spans the bottom edge, sized by height. Not the same '
        'component as Drawer: see the Drawer page.',
  ),
  DocsApiFact(
    name: 'left',
    type: 'SheetSide',
    description: 'Panel pins to the leading edge, sized by width.',
  ),
  DocsApiFact(
    name: 'isHorizontal',
    type: 'bool getter',
    description:
        'True for left and right: the two sides whose panel is sized '
        'by width rather than height.',
  ),
];

const List<DocsApiFact> _transitionFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'animation',
    type: 'Animation<double>',
    description:
        'Required. The enter/exit driver SheetOverlay wires in '
        'through OverlayPortal\'s transition builder; not something a '
        'typical caller constructs directly.',
  ),
  DocsApiFact(
    name: 'side',
    type: 'SheetSide',
    description:
        'Required. Which axis and direction to translate the slide-in '
        'along.',
  ),
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description: 'Required. The content being animated (the panel).',
  ),
  DocsApiFact(
    name: 'SheetTransition.fraction',
    type: 'static double',
    description:
        '0.1: the enter/exit travel, as a fraction of the panel\'s own '
        'size on its axis (a FractionalTranslation, not a pixel '
        'offset).',
  ),
];

const List<DocsApiFact> _contentGroupFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'showCloseButton',
    type: 'bool',
    description:
        'Required. The value SheetHeader reads (via '
        'SheetContentGroup.maybeOf) to decide its own right-padding '
        'reservation; set by SheetContent, not usually constructed '
        'directly.',
  ),
  DocsApiFact(
    name: 'child',
    type: 'Widget (via super.child)',
    description: 'Required. The subtree the group scopes over.',
  ),
];

const List<DocsApiFact> _dsSheetStaticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'Sheet.showLeft(context, {...})',
    type: 'static Future<void>',
    description:
        'Pushes a left-hand sheet as a real Navigator route (a '
        'PopupRoute) and completes when it closes: a different '
        'mounting strategy from SheetOverlay\'s OverlayPortal. '
        'example/lib/shell.dart\'s mobile navigation calls this, not '
        'SheetOverlay.',
  ),
  DocsApiFact(
    name: 'builder',
    type: 'WidgetBuilder',
    description: 'Required. Builds the sheet\'s content.',
  ),
  DocsApiFact(
    name: 'width',
    type: 'double',
    description:
        'Optional. Defaults to LayoutWidths.sidebarMobile (288px), '
        'deliberately wider than the 256px docked sidebar.',
  ),
  DocsApiFact(
    name: 'showCloseButton',
    type: 'bool',
    description: 'Optional. Defaults to true.',
  ),
];

const List<DocsApiFact> _panelFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'width',
    type: 'double',
    description:
        'Required. The panel\'s fixed width; full height, pinned to '
        'the left edge.',
  ),
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description: 'Required. The panel\'s content.',
  ),
  DocsApiFact(
    name: 'showCloseButton',
    type: 'bool',
    description: 'Optional. Defaults to true. Adds the labelled X, top-right.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Closed',
    treatment: 'Portal content is not mounted.',
    userSignal: 'Trigger remains available.',
  ),
  DocsStateFact(
    state: 'Open',
    treatment:
        'Scrim fades in on --duration-overlay (320ms); panel slides in '
        '10% of its own size on the same clock and --ease-out, fading '
        'in alongside it.',
    userSignal: 'Title, description, and CTAs are visible.',
  ),
  DocsStateFact(
    state: 'Escape / back',
    treatment:
        'Dismisses on Escape (OverlayPortal\'s FocusScope) and on '
        'Android back / predictive back (the shared PopScope stack).',
    userSignal: 'The page remains in place.',
  ),
  DocsStateFact(
    state: 'Scrim tap',
    treatment:
        'Dismisses on a tap outside the panel: dismissOnOverlayTap is '
        'not set to false, so OverlayPortal\'s true default applies.',
    userSignal: 'Any tap outside the panel closes it.',
  ),
  DocsStateFact(
    state: 'Long content',
    treatment:
        'SheetContent does not wrap its body children in a Flexible '
        '+ SingleChildScrollView the way DialogContent does. A '
        'caller with content taller than the panel needs to wrap the '
        'middle children in a Scrollable itself.',
    userSignal:
        'Overflow is a real risk on a short viewport unless the caller '
        'adds their own scroll region: a gap against '
        'DialogContent\'s built-in scrolling body, not a designed '
        'behavior.',
  ),
  DocsStateFact(
    state: 'Disabled, N/A',
    treatment: 'Exposes no enabled/disabled parameter of its own.',
    userSignal:
        'A caller wanting a disabled trigger gates Button\'s own '
        'onPressed outside this widget.',
  ),
  DocsStateFact(
    state: 'Loading / Empty / Error / Success, N/A',
    treatment: 'A structural overlay with no async or validation concept.',
    userSignal: 'None of the four states apply directly.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'Rides OverlayPortal, whose durations resolve through '
        'effectiveMotionDuration(context, ...): collapsing to zero under '
        'the platform\'s disable-animations flag.',
    userSignal: 'The transition still happens, instantly.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Focus moves INTO the panel on open: OverlayPortal wraps the '
            'content in FocusScope(autofocus: true), so the '
            'FocusScopeNode itself (not a leaf widget) claims primary '
            'focus the moment the overlay mounts.',
        'Closing DOES return focus to the trigger that opened the '
            'overlay, even though OverlayPortal contains no explicit '
            '"restore focus" code of its own: Flutter\'s FocusManager '
            'falls back to the enclosing scope\'s previously-focused '
            'child once the overlay\'s own FocusScope is removed from '
            'the tree, as long as the trigger\'s FocusNode is still '
            'mounted when the overlay closes.',
        'The close button carries an explicit accessible label '
            '("Close") via Button\'s own label parameter.',
        'SheetContent does not wrap its body in a '
            'Semantics(scopesRoute: true) / named-route announcement '
            'the way a platform sheet convention would; SheetTitle '
            'and SheetDescription are plain StyledText, not wired to the '
            'panel as an accessible name/description pair.',
        'SheetContent insets its body from the device\'s safe areas '
            'via SafeArea, excluding the edge the panel detaches '
            'from (top on a bottom sheet, bottom on a top sheet, both '
            'on left/right).',
      ]);
}

/// `sheet.dart` wires no key handling of its own — every fact here belongs
/// to the shared `OverlayPortal` it rides (`lib/src/components/ui/dialog.dart`).
class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Focus is trapped while open in the sense that matters for Tab '
            'traversal: once Tab moves focus to a real control inside '
            'the panel, further presses cycle inside the panel rather '
            'than reaching page content behind the scrim.',
        'Escape closes the topmost open overlay '
            '(OverlayPortalState\'s static stack), matching dialog\'s '
            'own Escape contract.',
        'Android back / predictive back dismisses the topmost overlay '
            'unconditionally, the same USER-ORDERED MOBILE ADAPTATION '
            'dialog.dart documents, shared by every OverlayPortal '
            'consumer.',
        'No custom ordering: sheet.dart declares no '
            'FocusTraversalPolicy of its own. Tab and Shift+Tab walk '
            'whatever order the panel\'s own children (the close '
            'button, then header, body, and footer content) declare.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Opts OUT of OverlayPortal\'s compact viewport clamp '
            '(clampToViewport: false): a centred dialog is capped to '
            '90vw x 75vh on a phone, but an edge-anchored panel is '
            'already viewport-relative by definition, so that cap '
            'would crop it instead of protecting it.',
        'Clamps its own horizontal width instead, through '
            'SheetContent.widthFor: 384px everywhere above the 600px '
            'compact breakpoint (CompactDialogLayout.breakpoint), 90% of '
            'viewport width (CompactDialogLayout.maxWidthFraction) at or '
            'below it.',
        'A vertical sheet (top or bottom) has no analogous height '
            'clamp of its own: its content sizes the panel directly, '
            'so tall content on a short viewport can overflow (see '
            'the "Long content" state above).',
        'No breakpoint branching for the layout decision itself: the '
            'same widget tree renders at 390px and 1440px, only the '
            'resolved width value changes.',
        'Platform parity: Android, iOS, Web, macOS, Windows, and '
            'Linux all render the same widget tree: no dart:io '
            'Platform branch anywhere in the file.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _bullets(theme, <String>[
          'File: lib/src/components/ui/sheet.dart: one file, no '
              'companions.',
          'Flutter imports: dart:ui (ImageFilter, the mobile-nav '
              'backdrop blur only), package:flutter/widgets.dart.',
          'Foundation imports: foundation/motion.dart, '
              'foundation/shadows.dart, foundation/spacing.dart (space(), '
              'LayoutWidths, Containers), foundation/theme.dart, '
              'foundation/typography.dart, theme_scope.dart (StyledText, '
              'ThemeScope).',
          'Component imports: button.dart (Button: the close '
              'affordance), dialog.dart (OverlayPortal, '
              'ModalTriggerBuilder, ModalContentBuilder, '
              'CompactDialogLayout), el_safe_area.dart (SafeArea), '
              'icon.dart and icon_paths.dart (Icon, the X glyph).',
          'registryDependencies, read directly from the shipped '
              'manifest: ${sheetDoc.dependencies.join(', ')}.',
          'Assets, fonts, shaders: none.',
        ]),
        const DocsLinkRow(
          links: <DocsLink>[
            DocsLink(label: 'Button', route: '/components/button'),
            DocsLink(label: 'Icon', route: '/components/icon'),
            DocsLink(label: 'Dialog', route: '/components/dialog'),
            DocsLink(label: 'Safe Area', route: '/components/safe_area'),
            DocsLink(
              label: 'Source Foundation',
              route: '/components/source_foundation',
            ),
          ],
        ),
      ],
    );
  }
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ThemeScope.of(context), <String>[
        'theme.popover fills the panel by default; SheetContent\'s '
            'fill parameter is the only override point.',
        'theme.border paints the single hairline seam on the edge the '
            'panel detaches from the page along: right sheet, left '
            'edge; left sheet, right edge; and so on.',
        'Shadows.tailwindLg is the panel\'s one elevation layer, the '
            'same shadow spec dialog\'s content uses.',
        'theme.muted at the system\'s standard 0.5 alpha bands '
            'SheetHeader and SheetFooter: the same muted-band '
            'anatomy DialogHeader/DialogFooter use.',
        'No radius at all: every side is a hard-edged rectangle flush '
            'with the viewport edge. (Drawer, the sibling component, '
            'rounds only its top corners: see the Drawer page.)',
        'Every colour is read live off ThemeScope.of(context) at build '
            'time. Flipping ThemeController re-resolves every one '
            'on the next frame: nothing is cached.',
      ]),
      SizedBox(height: space(2)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Drawer', route: '/components/drawer'),
        ],
      ),
    ],
  );
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
