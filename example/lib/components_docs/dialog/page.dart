/// Public documentation page for the `dialog` component.
///
/// **Re-housed onto the kit.** This page used to be `DialogDocPage`,
/// hand-composing `Section` panels inside
/// `example/lib/components_docs/dialog_page.dart` and living outside
/// `componentDocs`. It now declares a `ComponentDocSpec`
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// `ComponentDocPage`, the same shape `button`, `field`, `input` and
/// `select` already carry. The live preview — both the normal and media
/// dialog, opened from the same `_DialogPreview` `Wrap` the old page used —
/// moved unchanged into `_PreviewSpecimen` below; the house shape then
/// wants a `ShowcaseSection` per variant `DialogVariant` actually has, so
/// Normal and Media below Preview are new, each isolating one of the two
/// specimens the old page only ever showed side by side.
///
/// **Section order**, matching the house shape: Preview, Installation,
/// Usage (the smallest correct construction, code-only), Normal, Media,
/// then the eight disclosures. New: a Keyboard disclosure, between
/// Accessibility and Responsive, read directly off
/// `OverlayPortalState._onKey` and `_onPop`.
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

final ComponentDocSpec dialogDocSpec = ComponentDocSpec(
  name: 'dialog',
  title: dialogDoc.title,
  description: dialogDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'Open each specimen to inspect the overlay, close affordance, '
          'focus scope, and jelly transition. Normal and media share the '
          'same OverlayPortal.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: space(160),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'dialog has a real registry manifest: elattar add dialog '
          'installs lib/src/components/ui/dialog.dart and resolves button, '
          'icon, surface, and source-foundation automatically. '
          'The Manual tab is for a project not using the CLI.',
      command: dialogDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/dialog.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/ui/dialog.dart's generated "
              '@ui/dialog.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated dialog source here when using manual '
              'mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so Dialog and its eleven companion '
              'classes are reachable the same way the CLI path already '
              'makes them.',
          code: "export 'dialog.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct composition: a trigger builder and a '
          'content builder, both handed the callback that closes the '
          'portal.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'normal',
      title: 'Normal',
      description:
          'DialogVariant.normal, the constructor default: a banded '
          'header and footer around a lit body, sm:max-w-sm (384) wide.',
      specimen: _NormalDialogSpecimen(),
      code: _normalCode,
      label: 'Normal dialog specimen view',
    ),
    ShowcaseSection(
      id: 'media',
      title: 'Media',
      description:
          'DialogVariant.media: a full-bleed 16:9 DialogMedia slot '
          'leads the panel, both bands lose their fill and rule, and the '
          'panel widens to sm:max-w-md (448).',
      specimen: _MediaDialogSpecimen(),
      code: _mediaCode,
      label: 'Media dialog specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter every one of dialog\'s twelve '
          'exports declares: the dialog-specific composition first, then '
          'the shared portal machinery a sheet and a drawer ride too.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'Dialog', anchor: 'api-eldialog'),
        DocsTocEntry(title: 'DialogVariant', anchor: 'api-eldialogvariant'),
        DocsTocEntry(title: 'DialogContent', anchor: 'api-eldialogcontent'),
        DocsTocEntry(
          title: 'DialogContentGroup',
          anchor: 'api-eldialogcontentgroup',
        ),
        DocsTocEntry(title: 'DialogHeader', anchor: 'api-eldialogheader'),
        DocsTocEntry(title: 'DialogFooter', anchor: 'api-eldialogfooter'),
        DocsTocEntry(title: 'DialogTitle', anchor: 'api-eldialogtitle'),
        DocsTocEntry(
          title: 'DialogDescription',
          anchor: 'api-eldialogdescription',
        ),
        DocsTocEntry(title: 'DialogMedia', anchor: 'api-eldialogmedia'),
        DocsTocEntry(title: 'OverlayPortal', anchor: 'api-elmodalportal'),
        DocsTocEntry(title: 'DialogOverlay', anchor: 'api-eldialogoverlay'),
        DocsTocEntry(title: 'OpenTransition', anchor: 'api-eljellytransition'),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Read off OverlayPortalState.build/open/close and '
          'DialogContent.build, not inferred.',
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
          'Read directly off OverlayPortalState._onKey and _onPop: '
          'Escape and back are deliberately not the same contract, see '
          'dialog.dart\'s own library doc.',
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
            value: dialogDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/dialogs_test.dart',
            description:
                'Dialog is covered there (44 Dialog references at '
                'the time this page was written).',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/dialog_test.dart',
            description:
                'Covers this page: the article mounts, every Dialog '
                'and DialogContent constructor parameter this page '
                'claims to document, and a live open/close cycle of '
                'both variants.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/dialog/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class DialogDocPage extends StatelessWidget {
  const DialogDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: dialogDoc.route,
    intro: DocsPageIntro(
      title: dialogDoc.title,
      description: dialogDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Dialog'),
    ],
    toc: dialogDocSpec.toc,
    previous: const DocsPageLink(
      title: 'Command',
      route: '/components/command',
    ),
    next: const DocsPageLink(
      title: 'Dropdown Menu',
      route: '/components/dropdown-menu',
    ),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('dialog-doc-article'),
      child: ComponentDocPage(spec: dialogDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */
// `_PreviewSpecimen` is the old page's `_DialogPreview` carried unchanged.
// `_NormalDialogSpecimen` and `_MediaDialogSpecimen` isolate its two
// halves so each variant gets its own house-shape section, built from the
// exact same Dialog composition.

class _PreviewSpecimen extends StatefulWidget {
  const _PreviewSpecimen();

  @override
  State<_PreviewSpecimen> createState() => _PreviewSpecimenState();
}

class _PreviewSpecimenState extends State<_PreviewSpecimen> {
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: space(3),
    runSpacing: space(3),
    children: <Widget>[
      Dialog(
        trigger: (BuildContext context, VoidCallback open) =>
            Button(onPressed: open, child: const Text('Open normal')),
        content: (BuildContext context, VoidCallback close) => DialogContent(
          onClose: close,
          children: <Widget>[
            const DialogHeader(
              children: <Widget>[
                DialogTitle('Confirm action'),
                DialogDescription('This is a live modal preview.'),
              ],
            ),
            DialogFooter(
              children: <Widget>[
                Button(onPressed: close, child: Text('Cancel')),
              ],
            ),
          ],
        ),
      ),
      Dialog(
        trigger: (BuildContext context, VoidCallback open) => Button(
          variant: ButtonVariant.outline,
          onPressed: open,
          child: const Text('Open media'),
        ),
        content: (BuildContext context, VoidCallback close) => DialogContent(
          variant: DialogVariant.media,
          showCloseButton: false,
          children: <Widget>[
            DialogMedia(
              child: ColoredBox(
                color: Palette.action,
                child: Center(child: Icon(IconGlyph.sparkles)),
              ),
            ),
            const DialogHeader(
              children: <Widget>[
                DialogTitle('A visual lead'),
                DialogDescription('Media dialogs use the same close flow.'),
              ],
            ),
            DialogFooter(
              children: <Widget>[
                Button(onPressed: close, child: Text('Continue')),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

const String _previewCode = '''Dialog(
  trigger: (context, open) =>
      Button(onPressed: open, child: const Text('Open normal')),
  content: (context, close) => DialogContent(
    onClose: close,
    children: [
      DialogHeader(children: [
        DialogTitle('Confirm action'),
        DialogDescription('This is a live modal preview.'),
      ]),
      DialogFooter(children: [
        Button(onPressed: close, child: const Text('Cancel')),
      ]),
    ],
  ),
)''';

const String _usageCode = '''Dialog(
  trigger: (context, open) => Button(
    onPressed: open,
    child: const Text('Open dialog'),
  ),
  content: (context, close) => DialogContent(
    onClose: close,
    children: <Widget>[
      DialogHeader(children: <Widget>[
        DialogTitle('Confirm action'),
        DialogDescription('Review the change before continuing.'),
      ]),
      DialogFooter(children: <Widget>[
        Button(onPressed: close, child: const Text('Cancel')),
      ]),
    ],
  ),
)''';

class _NormalDialogSpecimen extends StatelessWidget {
  const _NormalDialogSpecimen();

  @override
  Widget build(BuildContext context) => Dialog(
    trigger: (BuildContext context, VoidCallback open) => Button(
      key: const ValueKey<String>('dialog-example:normal-trigger'),
      onPressed: open,
      child: const Text('Open normal'),
    ),
    content: (BuildContext context, VoidCallback close) => DialogContent(
      key: const ValueKey<String>('dialog-example:normal-content'),
      onClose: close,
      children: <Widget>[
        const DialogHeader(
          children: <Widget>[
            DialogTitle('Confirm action'),
            DialogDescription('This is a live modal preview.'),
          ],
        ),
        DialogFooter(
          children: <Widget>[Button(onPressed: close, child: Text('Cancel'))],
        ),
      ],
    ),
  );
}

const String _normalCode = '''Dialog(
  trigger: (context, open) =>
      Button(onPressed: open, child: const Text('Open normal')),
  content: (context, close) => DialogContent(
    onClose: close,
    children: [
      DialogHeader(children: [
        DialogTitle('Confirm action'),
        DialogDescription('This is a live modal preview.'),
      ]),
      DialogFooter(children: [
        Button(onPressed: close, child: const Text('Cancel')),
      ]),
    ],
  ),
)''';

class _MediaDialogSpecimen extends StatelessWidget {
  const _MediaDialogSpecimen();

  @override
  Widget build(BuildContext context) => Dialog(
    trigger: (BuildContext context, VoidCallback open) => Button(
      key: const ValueKey<String>('dialog-example:media-trigger'),
      variant: ButtonVariant.outline,
      onPressed: open,
      child: const Text('Open media'),
    ),
    content: (BuildContext context, VoidCallback close) => DialogContent(
      key: const ValueKey<String>('dialog-example:media-content'),
      variant: DialogVariant.media,
      showCloseButton: false,
      children: <Widget>[
        DialogMedia(
          child: ColoredBox(
            color: Palette.action,
            child: Center(child: Icon(IconGlyph.sparkles)),
          ),
        ),
        const DialogHeader(
          children: <Widget>[
            DialogTitle('A visual lead'),
            DialogDescription('Media dialogs use the same close flow.'),
          ],
        ),
        DialogFooter(
          children: <Widget>[Button(onPressed: close, child: Text('Continue'))],
        ),
      ],
    ),
  );
}

const String _mediaCode = '''Dialog(
  trigger: (context, open) => Button(
    variant: ButtonVariant.outline,
    onPressed: open,
    child: const Text('Open media'),
  ),
  content: (context, close) => DialogContent(
    variant: DialogVariant.media,
    showCloseButton: false,
    children: [
      DialogMedia(child: /* artwork */),
      DialogHeader(children: [
        DialogTitle('A visual lead'),
        DialogDescription('Media dialogs use the same close flow.'),
      ]),
      DialogFooter(children: [
        Button(onPressed: close, child: const Text('Continue')),
      ]),
    ],
  ),
)''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-eldialog',
        child: DocsApiTable(title: 'Dialog', facts: _dialogFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-eldialogvariant',
        child: DocsApiTable(title: 'DialogVariant', facts: _dialogVariantFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-eldialogcontent',
        child: DocsApiTable(title: 'DialogContent', facts: _dialogContentFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-eldialogcontentgroup',
        child: DocsApiTable(
          title: 'DialogContentGroup',
          facts: _dialogContentGroupFacts,
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-eldialogheader',
        child: DocsApiTable(title: 'DialogHeader', facts: _dialogHeaderFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-eldialogfooter',
        child: DocsApiTable(title: 'DialogFooter', facts: _dialogFooterFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-eldialogtitle',
        child: DocsApiTable(title: 'DialogTitle', facts: _dialogTitleFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-eldialogdescription',
        child: DocsApiTable(
          title: 'DialogDescription',
          facts: _dialogDescriptionFacts,
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-eldialogmedia',
        child: DocsApiTable(title: 'DialogMedia', facts: _dialogMediaFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elmodalportal',
        child: DocsApiTable(title: 'OverlayPortal', facts: _modalPortalFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-eldialogoverlay',
        child: DocsApiTable(title: 'DialogOverlay', facts: _dialogOverlayFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-eljellytransition',
        child: DocsApiTable(
          title: 'OpenTransition',
          facts: _jellyTransitionFacts,
        ),
      ),
    ],
  );
}

const List<DocsApiFact> _dialogFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'trigger',
    type: 'ModalTriggerBuilder',
    description: 'Required. Builds the control that opens the portal.',
  ),
  DocsApiFact(
    name: 'content',
    type: 'ModalContentBuilder',
    description:
        "Required. Builds the panel and receives the portal's own "
        'close callback.',
  ),
  DocsApiFact(
    name: 'onOpenChange',
    type: 'ValueChanged<bool>?',
    description: 'Optional. Fires with the new state on open and close.',
  ),
];

const List<DocsApiFact> _dialogVariantFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'normal',
    type: 'enum value',
    description:
        'The constructor default: a banded header and footer around a '
        'lit body.',
  ),
  DocsApiFact(
    name: 'media',
    type: 'enum value',
    description:
        'gap-0 overflow-hidden p-0 sm:max-w-md: the full-bleed visual '
        'lead. Both bands lose their fill, rule, and negative margins.',
  ),
];

const List<DocsApiFact> _dialogContentFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'children',
    type: 'List<Widget>',
    description:
        "Required. The grid's children, in order. A DialogHeader "
        'first and a DialogFooter last is the anatomy, but nothing '
        'here enforces it.',
  ),
  DocsApiFact(
    name: 'variant',
    type: 'DialogVariant',
    description: 'Optional. Defaults to DialogVariant.normal.',
  ),
  DocsApiFact(
    name: 'showCloseButton',
    type: 'bool',
    description:
        'Optional. Defaults to true. Also drops the header\'s reserved '
        'lane for it when false.',
  ),
  DocsApiFact(
    name: 'onClose',
    type: 'VoidCallback?',
    description:
        "Optional. Wired by Dialog; the close button's own X "
        'calls it.',
  ),
  DocsApiFact(
    name: 'DialogContent.maxWidth',
    type: 'static double',
    description: 'sm:max-w-sm — 384, the normal variant.',
  ),
  DocsApiFact(
    name: 'DialogContent.mediaMaxWidth',
    type: 'static double',
    description: 'sm:max-w-md — 448, the media variant.',
  ),
  DocsApiFact(
    name: 'DialogContent.padding',
    type: 'static double',
    description: 'p-4 / gap-4 — zero on the media variant.',
  ),
  DocsApiFact(
    name: 'DialogContent.radius',
    type: 'static double',
    description: 'rounded-xl.',
  ),
  DocsApiFact(
    name: 'DialogContent.ringSpec',
    type: 'static ShadowStyle',
    description:
        'ring-1 ring-foreground/10, and nothing under it — a dialog '
        'needs no elevation because the scrim already separates it.',
  ),
];

const List<DocsApiFact> _dialogContentGroupFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'showCloseButton',
    type: 'bool',
    description:
        "Required. The group/dialog-content the bands read their "
        'group-data hooks off.',
  ),
  DocsApiFact(name: 'variant', type: 'DialogVariant', description: 'Required.'),
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description: 'Required. The InheritedWidget\'s subtree.',
  ),
];

const List<DocsApiFact> _dialogHeaderFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'children',
    type: 'List<Widget>',
    description:
        'Required. flex flex-col gap-2 — typically a '
        'DialogTitle and a DialogDescription.',
  ),
  DocsApiFact(
    name: 'DialogHeader.closeButtonLane',
    type: 'static double',
    description:
        'pr-12 — the lane the absolutely-positioned close button '
        'lands in.',
  ),
];

const List<DocsApiFact> _dialogFooterFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'children',
    type: 'List<Widget>',
    description:
        'Required. Laid out as a trailing-aligned row, typically the '
        "dialog's own CTAs.",
  ),
];

const List<DocsApiFact> _dialogTitleFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'text (positional)',
    type: 'String',
    description: 'Required. font-heading text-base leading-none font-medium.',
  ),
];

const List<DocsApiFact> _dialogDescriptionFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'text (positional)',
    type: 'String',
    description: 'Required. text-sm text-muted-foreground.',
  ),
];

const List<DocsApiFact> _dialogMediaFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description:
        'Required. The artwork, clipped to a 16:9 box: relative '
        'aspect-video overflow-hidden bg-muted.',
  ),
  DocsApiFact(
    name: 'DialogMedia.aspect',
    type: 'static const double',
    description: '16 / 9.',
  ),
];

const List<DocsApiFact> _modalPortalFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'trigger',
    type: 'ModalTriggerBuilder',
    description: 'Required. Builds the control that opens the portal.',
  ),
  DocsApiFact(
    name: 'content',
    type: 'ModalContentBuilder',
    description: "Required. Builds the overlay's content.",
  ),
  DocsApiFact(
    name: 'transition',
    type: 'ModalTransitionBuilder',
    description: 'Required. Wraps content in its enter/exit animation.',
  ),
  DocsApiFact(
    name: 'alignment',
    type: 'Alignment',
    description:
        'Optional. Defaults to Alignment.center. Where content sits in '
        'the theatre — an edge for a sheet or a drawer.',
  ),
  DocsApiFact(
    name: 'enterDuration',
    type: 'Duration',
    description:
        'Optional. Defaults to MotionDurations.open (420ms). Leaving should '
        'never take as long as arriving.',
  ),
  DocsApiFact(
    name: 'exitDuration',
    type: 'Duration',
    description: 'Optional. Defaults to MotionDurations.normal (250ms).',
  ),
  DocsApiFact(
    name: 'overlayDuration',
    type: 'Duration',
    description:
        'Optional. Defaults to MotionDurations.overlayEnter (320ms). The '
        "scrim's own clock, separate from the content's.",
  ),
  DocsApiFact(
    name: 'overlayCurve',
    type: 'Curve',
    description: 'Optional. Defaults to MotionCurves.enter.',
  ),
  DocsApiFact(
    name: 'dismissOnOverlayTap',
    type: 'bool',
    description:
        'Optional. Defaults to true. False on the one composition that '
        'must not close by tapping outside: the alert dialog.',
  ),
  DocsApiFact(
    name: 'clampToViewport',
    type: 'bool',
    description:
        'Optional. Defaults to true. USER-ORDERED MOBILE ADAPTATION: '
        "whether CompactDialogLayout's 90vw x 75vh box applies on a phone. "
        'Off for the sheet and the drawer, which clamp themselves.',
  ),
  DocsApiFact(
    name: 'onOpenChange',
    type: 'ValueChanged<bool>?',
    description: 'Optional. Fires on every open and close.',
  ),
];

const List<DocsApiFact> _dialogOverlayFacts = <DocsApiFact>[
  DocsApiFact(
    name: '(no parameters)',
    type: '—',
    description:
        'const DialogOverlay() is the whole of it: fixed inset-0 '
        'bg-background/15 under a 4px backdrop blur, shared byte-for-byte '
        'with the alert dialog, sheet, and drawer.',
  ),
];

const List<DocsApiFact> _jellyTransitionFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'animation',
    type: 'Animation<double>',
    description: 'Required. Runs 0 → 1 on open and 1 → 0 on close.',
  ),
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description: 'Required. The panel this transition wraps.',
  ),
  DocsApiFact(
    name: 'OpenTransition.sample(progress, {entering})',
    type: 'static ({double scale, double shift, double opacity})',
    description:
        'The keyframe state at progress along whichever of the two '
        'keyframe lists (in/out) is running.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Closed',
    treatment:
        'The overlay is not mounted at all: OverlayPortal builds '
        'nothing extra.',
    userSignal: 'Only the trigger is visible.',
  ),
  DocsStateFact(
    state: 'Open',
    treatment:
        'The scrim fades in over 320ms; the panel plays anim-jelly-in '
        'over 420ms on a spring, focus moves into a FocusScope.',
    userSignal: 'Title, body and actions are all visible and reachable.',
  ),
  DocsStateFact(
    state: 'Closing',
    treatment:
        'anim-jelly-out runs over 250ms on ease-in-out, deliberately '
        'shorter than the entrance: leaving should never take as long '
        'as arriving.',
    userSignal: 'The panel shrinks and fades out faster than it opened.',
  ),
  DocsStateFact(
    state: 'Long content',
    treatment:
        'The body sits in a loosely-fit SingleChildScrollView; the '
        'header and footer bands stay pinned outside it.',
    userSignal:
        'Title and actions remain reachable while the body '
        'scrolls.',
  ),
  DocsStateFact(
    state: 'Compact (≤600px viewport)',
    treatment:
        'USER-ORDERED MOBILE ADAPTATION: CompactDialogLayout clamps the '
        'panel to 90vw x 75vh; above the breakpoint every measured '
        'desktop pin is untouched.',
    userSignal: 'The panel never reaches either edge of a phone screen.',
  ),
  DocsStateFact(
    state: 'Media',
    treatment:
        'Full-bleed DialogMedia slot, wider panel (448), the close '
        'button rendered over the artwork with a blurred backdrop '
        'instead of on a band.',
    userSignal: 'Artwork leads the panel and is clipped to its corners.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'A FocusScope wraps the panel and moves focus into it on open, '
            'autofocusing the first tabbable child.',
        'The close button is labelled "Close" (Semantics via Button\'s '
            'own label), not left to an icon alone.',
        'dismissOnOverlayTap gates whether tapping outside the panel '
            'dismisses it — off for the alert dialog, which must be '
            'answered rather than dismissed.',
        'Every open OverlayPortal registers on one static stack so '
            'Android\'s back button dismisses exactly the topmost one — '
            'see Keyboard below for what Escape does instead.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Escape closes whichever modal has focus, including the alert '
            'dialog — a documented drift from that variant\'s own copy, '
            'which promises no escape-to-cancel by accident.',
        'Tab is trapped inside the FocusScope while a modal is open: '
            'focus cannot land on anything behind the overlay.',
        'No arrow-key navigation of any kind: a dialog holds prose and '
            'buttons, not a list of rows.',
        'Enter and Space activate whichever Button inside the panel '
            'currently has focus — ordinary button semantics, not a '
            'dialog-specific binding.',
        'Back and Escape are deliberately NOT the same contract: Escape '
            'is transcribed from the reference; the Android back button '
            'is a USER-ORDERED ADAPTATION that always dismisses, with no '
            'exception, because leaving the app is never the intent '
            'behind a back press aimed at an overlay.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'USER-ORDERED MOBILE ADAPTATION 1 — CompactDialogLayout: at or below '
            '600 logical pixels the panel is held inside a 90vw x 75vh '
            'box and its body scrolls inside it. Desktop geometry above '
            'the breakpoint is a no-op: every measured pin still holds.',
        'USER-ORDERED MOBILE ADAPTATION 2 — the Android back button '
            'dismisses the topmost open portal, which OverlayPortal '
            'alone (not being a Navigator route) would otherwise let '
            'the platform walk straight past.',
        'No dart:io Platform branch anywhere in dialog.dart: the same '
            'widget tree renders on every platform, the two adaptations '
            'above included.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DocsInstallFacts(
        facts: <DocsInstallFact>[
          const DocsInstallFact(
            label: 'Registry item',
            value: 'registry/components/dialog.json',
            description: 'Installable through the CLI today.',
          ),
          const DocsInstallFact(
            label: 'Destination',
            value: 'lib/components/ui/dialog.dart',
            description:
                'The same lib/components/ui/ target every component '
                'installs to.',
          ),
          DocsInstallFact(
            label: 'Dependencies',
            value: dialogDoc.dependencies.join(', '),
            description:
                "The manifest's registryDependencies, resolved "
                'automatically. button supplies every trigger and '
                'footer CTA; icon supplies the close glyph; '
                'surface paints the panel.',
          ),
          const DocsInstallFact(
            label: 'Shared machinery',
            value: 'OverlayPortal, DialogOverlay, OpenTransition',
            description:
                'The same portal a sheet and a drawer ride: neither of '
                'those files repeats this one\'s focus-trap, back-button, '
                'or compact-clamp logic.',
          ),
        ],
      ),
      SizedBox(height: space(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Button', route: '/components/button'),
          DocsLink(label: 'Icon', route: '/components/icon'),
          DocsLink(label: 'Surface', route: '/components/surface'),
          DocsLink(label: 'Alert dialog', route: '/components/alert-dialog'),
          DocsLink(label: 'Sheet', route: '/components/sheet'),
          DocsLink(label: 'Drawer', route: '/components/drawer'),
        ],
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) => DocsInstallFacts(
    title: 'What actually varies with the theme',
    facts: const <DocsInstallFact>[
      DocsInstallFact(
        label: 'theme.popover',
        value: 'Panel fill',
        description: 'Painted through Surface.',
      ),
      DocsInstallFact(
        label: 'theme.foreground',
        value: 'Panel ring, 10% alpha',
        description:
            'The only elevation the panel carries: no shadow '
            'under it.',
      ),
      DocsInstallFact(
        label: 'theme.muted',
        value: 'Header and footer band fill, 50% alpha',
        description:
            'Both bands are muted so the body reads as the only '
            'lit surface.',
      ),
      DocsInstallFact(
        label: 'theme.border',
        value: 'Band rule',
        description:
            'The 1px line that closes each band, matching the '
            'header top / footer bottom.',
      ),
      DocsInstallFact(
        label: 'theme.background',
        value: 'Overlay tint, 15% alpha',
        description: 'Behind a 4px backdrop blur.',
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
