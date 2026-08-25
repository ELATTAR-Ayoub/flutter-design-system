/// Public documentation page for the `agent-attachments` component.
///
/// `agent_attachments.dart` declares three widgets — [ElAgentAttachmentCard],
/// [ElAgentAttachmentList], [ElAgentDeliveryBadge] — and two top-level
/// functions, [elAgentAttachmentGlyph] and [elAgentAttachmentIsVideo]. API
/// Reference gives each its own table, with a rail sub-anchor per table.
///
/// **The domain type lives elsewhere.** [ElAgentAttachment],
/// [ElAgentAttachmentKind], [ElAgentDelivery] and [ElAgentDeliverySent] are
/// declared in `agent_core.dart`, not in this file — this file only
/// consumes them to draw a card. The manifest's own `registryDependencies`
/// lists `agent-core` for exactly that reason, and this page's Dependencies
/// disclosure names it in prose without a link: `agent-core` carries no
/// documentation page of its own yet.
///
/// `ElAgentAttachment` carries no upload lifecycle of its own — no `error`,
/// no `uploading`, nothing between "picked" and "gone" — so every specimen
/// on this page is `ElAttachmentState.done` underneath: the source's own
/// library note says the primitive's other two states are real, but this
/// domain type cannot produce them.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import 'meta.dart';

final ComponentDocSpec agentAttachmentsDocSpec = ComponentDocSpec(
  name: 'agent_attachments',
  title: 'Agent Attachments',
  description:
      'A file the user picked and a file the agent produced draw through '
      'the same card — plus a delivery badge that says whether the '
      "model's bytes, or only its filename, actually reached it.",
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'ElAgentAttachmentList over the three delivery outcomes '
          '[ElAgentDeliveryBadge] can draw: content (inlined and read), '
          'reference (name only), and produced (the agent\'s own output — '
          'no badge at all, delivery does not apply to a file the agent '
          'made itself).',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: el(64),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'agent-attachments has a real registry manifest, `elattar add '
          'agent-attachments` installs lib/src/components/'
          'agent_attachments.dart and resolves all seven '
          'registryDependencies automatically. The Manual tab is for a '
          'project not using the CLI.',
      command: agentAttachmentsDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/agent_attachments.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/agent_attachments.dart's generated "
              '@ui/agent_attachments.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated agent_attachments source here when '
              'using manual mode.',
        ),
        DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ElAgentAttachmentCard, '
              'ElAgentAttachmentList and ElAgentDeliveryBadge are reachable '
              'the same way the CLI path already makes them.',
          code: "export 'agent_attachments.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct import and construction. Both list and '
          'card render nothing (SizedBox.shrink()) when there is nothing '
          'to show — an empty attachments list is an empty widget, not an '
          'empty box.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'delivery-badge',
      title: 'Delivery badge',
      description:
          'ElAgentDeliveryBadge in isolation, one per ElAgentDeliverySent '
          'value. content reads "Read"; reference shows an info glyph and '
          '"Name only" behind a tooltip carrying delivery.reason; produced '
          'renders SizedBox.shrink() — nothing at all, on purpose.',
      specimen: _DeliveryBadgeSpecimen(),
      code: _deliveryBadgeCode,
      label: 'Delivery badge specimen view',
    ),
    ShowcaseSection(
      id: 'image',
      title: 'Image attachment',
      description:
          'An attachment whose kind is image and whose url is non-null '
          'gets the large-image treatment instead of ElAgentAttachmentCard '
          "'s 40px well — capped in height, and clickable to open full "
          'size in a modal. The picture itself is a placeholder painter: '
          "this domain's own url field is a plain String with no decoder "
          'this port can read, so a real caller supplies imageBuilder.',
      specimen: _ImageSpecimen(),
      code: _imageCode,
      label: 'Image attachment specimen view',
      minHeight: el(80),
    ),
    ShowcaseSection(
      id: 'remove',
      title: 'Remove',
      description:
          'onRemove given: every card and every image caption swaps its '
          'download action for a remove action. The two are never both '
          'offered on the same attachment — see the API table below.',
      specimen: _RemoveSpecimen(),
      code: _removeCode,
      label: 'Remove specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter and public static each of the '
          'three exported widgets declares, plus the two top-level '
          'functions.',
      children: const <DocsTocEntry>[
        DocsTocEntry(
          title: 'ElAgentAttachmentCard',
          anchor: 'api-elagentattachmentcard',
        ),
        DocsTocEntry(
          title: 'ElAgentAttachmentList',
          anchor: 'api-elagentattachmentlist',
        ),
        DocsTocEntry(
          title: 'ElAgentDeliveryBadge',
          anchor: 'api-elagentdeliverybadge',
        ),
        DocsTocEntry(
          title: 'Top-level functions',
          anchor: 'api-top-level-functions',
        ),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Read off ElAgentAttachmentCard.build, _ImageAttachment.build '
          'and ElAgentDeliveryBadge.build, not inferred.',
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
            value: agentAttachmentsDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/agent_attachments_test.dart',
            description:
                'Covers this page: the article mounts, the full API table, '
                'and every live specimen this page claims to show.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/agent_attachments/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class AgentAttachmentsDocPage extends StatelessWidget {
  const AgentAttachmentsDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: agentAttachmentsDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / AGENT',
      title: agentAttachmentsDoc.title,
      description: agentAttachmentsDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Agent Attachments'),
    ],
    toc: agentAttachmentsDocSpec.toc,
    previous: null,
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('agent-attachments-doc-article'),
      child: ComponentDocPage(spec: agentAttachmentsDocSpec, header: false),
    ),
  );
}

/* ── Sample data ─────────────────────────────────────────────────────────── */

const ElAgentAttachment _contentAttachment = ElAgentAttachment(
  id: 'attach-content',
  name: 'inventory-export.csv',
  mime: 'text/csv',
  kind: ElAgentAttachmentKind.data,
  size: 18422,
  delivery: ElAgentDelivery.content(),
);

const ElAgentAttachment _referenceAttachment = ElAgentAttachment(
  id: 'attach-reference',
  name: 'condition-report.pdf',
  mime: 'application/pdf',
  kind: ElAgentAttachmentKind.document,
  size: 2620000,
  delivery: ElAgentDelivery.reference(
    'This file is not text, so its contents could not be inlined.',
  ),
);

const ElAgentAttachment _producedAttachment = ElAgentAttachment(
  id: 'attach-produced',
  name: 'summary-30d.csv',
  mime: 'text/csv',
  kind: ElAgentAttachmentKind.data,
  size: 4821,
  delivery: ElAgentDelivery.produced(),
);

const String _pictureUrl =
    'data:image/svg+xml;utf8,agent-attachments-doc-specimen';

const ElAgentAttachment _imageAttachment = ElAgentAttachment(
  id: 'attach-image',
  name: 'shelf-photo.png',
  mime: 'image/png',
  kind: ElAgentAttachmentKind.image,
  size: 184220,
  url: _pictureUrl,
  delivery: ElAgentDelivery.content(),
);

/// The seam [ElAgentAttachmentList.imageBuilder] exists for: `url` is a
/// plain String and the one specimen in the corpus is a data URI this port
/// cannot decode, so every image on this page is this placeholder rather
/// than a real decoded picture.
Widget _placeholderPicture(BuildContext context, ElAgentAttachment attachment) {
  final ElThemeData theme = ElTheme.of(context);
  return ColoredBox(
    color: theme.accent,
    child: SizedBox(
      width: el(160),
      height: el(90),
      child: Center(
        child: ElIcon.lucide(
          ElLucide.image,
          sizePx: el(10),
          tone: ElIconTone.muted,
        ),
      ),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) => const ElAgentAttachmentList(
    key: ValueKey<String>('agent-attachments-preview:list'),
    attachments: <ElAgentAttachment>[
      _contentAttachment,
      _referenceAttachment,
      _producedAttachment,
    ],
  );
}

const String _previewCode = '''
ElAgentAttachmentList(
  attachments: [contentFile, referenceFile, producedFile],
)''';

class _DeliveryBadgeSpecimen extends StatelessWidget {
  const _DeliveryBadgeSpecimen();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    Widget labelled(String label, String key, ElAgentAttachment attachment) =>
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElText(label, ElType.section, color: theme.mutedForeground),
            SizedBox(height: el(2)),
            ElAgentDeliveryBadge(
              key: ValueKey<String>(key),
              attachment: attachment,
            ),
          ],
        );

    return Wrap(
      spacing: el(8),
      runSpacing: el(4),
      crossAxisAlignment: WrapCrossAlignment.start,
      children: <Widget>[
        labelled(
          'content',
          'agent-attachments-example:delivery-content',
          _contentAttachment,
        ),
        labelled(
          'reference',
          'agent-attachments-example:delivery-reference',
          _referenceAttachment,
        ),
        labelled(
          'produced (renders nothing)',
          'agent-attachments-example:delivery-produced',
          _producedAttachment,
        ),
      ],
    );
  }
}

const String _deliveryBadgeCode = '''
ElAgentDeliveryBadge(attachment: contentFile);   // "Read"
ElAgentDeliveryBadge(attachment: referenceFile); // info glyph + "Name only"
ElAgentDeliveryBadge(attachment: producedFile);  // SizedBox.shrink()''';

class _ImageSpecimen extends StatelessWidget {
  const _ImageSpecimen();

  @override
  Widget build(BuildContext context) => SizedBox(
    key: const ValueKey<String>('agent-attachments-example:image'),
    width: el(80),
    child: ElAgentAttachmentList(
      attachments: const <ElAgentAttachment>[_imageAttachment],
      imageBuilder: _placeholderPicture,
      onDownload: (String _) {},
    ),
  );
}

const String _imageCode = '''
ElAgentAttachmentList(
  attachments: [imageFile], // kind: image, url: non-null
  imageBuilder: (context, attachment) => yourDecodedImage(attachment),
  onDownload: (name) => showSavingToast(name),
)''';

class _RemoveSpecimen extends StatefulWidget {
  const _RemoveSpecimen();

  @override
  State<_RemoveSpecimen> createState() => _RemoveSpecimenState();
}

class _RemoveSpecimenState extends State<_RemoveSpecimen> {
  List<ElAgentAttachment> _attachments = const <ElAgentAttachment>[
    _contentAttachment,
    _referenceAttachment,
  ];

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ElAgentAttachmentList(
          key: const ValueKey<String>('agent-attachments-example:remove-list'),
          attachments: _attachments,
          onRemove: (String id) => setState(
            () => _attachments = _attachments
                .where((ElAgentAttachment a) => a.id != id)
                .toList(),
          ),
        ),
        SizedBox(height: el(3)),
        ElText(
          _attachments.isEmpty ? 'All attachments removed.' : ' ',
          ElType.small,
          key: const ValueKey<String>(
            'agent-attachments-example:remove-status',
          ),
          color: theme.mutedForeground,
        ),
      ],
    );
  }
}

const String _removeCode = '''
ElAgentAttachmentList(
  attachments: attachments,
  onRemove: (id) => setState(
    () => attachments = attachments.where((a) => a.id != id).toList(),
  ),
)''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

ElAgentAttachmentList(attachments: attachments)''';

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elagentattachmentcard',
        child: DocsApiTable(
          title: 'ElAgentAttachmentCard',
          facts: _cardFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elagentattachmentlist',
        child: DocsApiTable(
          title: 'ElAgentAttachmentList',
          facts: _listFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elagentdeliverybadge',
        child: DocsApiTable(
          title: 'ElAgentDeliveryBadge',
          facts: _badgeFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-top-level-functions',
        child: DocsApiTable(
          title: 'Top-level functions',
          facts: _functionFacts,
        ),
      ),
    ],
  );
}

const List<DocsApiFact> _cardFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'attachment',
    type: 'ElAgentAttachment',
    description: 'Required. The file this card draws.',
  ),
  DocsApiFact(
    name: 'onRemove',
    type: 'void Function(String id)?',
    description:
        'Optional. Shows a remove action instead of a download one. '
        'Never both — see the Remove specimen above.',
  ),
  DocsApiFact(
    name: 'onDownload',
    type: 'void Function(String name)?',
    description:
        "Optional. Where a caller raises its own confirmation — this "
        'primitive triggers a browser download and gives no completion '
        'event of its own.',
  ),
  DocsApiFact(
    name: 'imageBuilder',
    type: 'Widget Function(BuildContext, ElAgentAttachment)?',
    description:
        'Optional. Renders the thumbnail for an image attachment with a '
        'url. With no builder the well is a plain --muted plate at the '
        'same height.',
  ),
  DocsApiFact(
    name: 'descriptionGap',
    type: 'double',
    description:
        'Static. el(2) — 8. Between the formatted size string and the '
        'delivery badge.',
  ),
];

const List<DocsApiFact> _listFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'attachments',
    type: 'List<ElAgentAttachment>',
    description: 'Required. Images with a url lay out separately from '
        'everything else — see the Image attachment specimen above.',
  ),
  DocsApiFact(
    name: 'onRemove',
    type: 'void Function(String id)?',
    description:
        'Optional. Set by the composer tray, the only place a file can '
        'be taken back. Forwarded to every card and every image caption.',
  ),
  DocsApiFact(
    name: 'compact',
    type: 'bool',
    description:
        'Optional. Defaults to false. Caps an image well at el(32) '
        '(compact — a composer tray) instead of el(80) (a transcript).',
  ),
  DocsApiFact(
    name: 'imageBuilder',
    type: 'Widget Function(BuildContext, ElAgentAttachment)?',
    description: 'Optional. Forwarded to every image in the list.',
  ),
  DocsApiFact(
    name: 'onDownload',
    type: 'void Function(String name)?',
    description: 'Optional. Forwarded to every card and every image '
        'caption.',
  ),
  DocsApiFact(
    name: 'gap',
    type: 'double',
    description:
        'Static. el(2) — 8. Between the image group and the rest group, '
        'and inside each group\'s own grid.',
  ),
];

const List<DocsApiFact> _badgeFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'attachment',
    type: 'ElAgentAttachment',
    description:
        'Required. Only attachment.delivery is read: null or '
        'ElAgentDeliverySent.produced both render SizedBox.shrink().',
  ),
  DocsApiFact(
    name: 'gap',
    type: 'double',
    description: 'Static. el(1) — 4. Between the info glyph and the words '
        'on the reference badge.',
  ),
  DocsApiFact(
    name: 'tooltipMaxWidth',
    type: 'double',
    description:
        'Static. ElContainers.xs. What ElTooltip\'s own content already '
        'caps itself at — the source notes the value is asked for but is '
        'a no-op against the tooltip\'s own ceiling.',
  ),
];

const List<DocsApiFact> _functionFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'elAgentAttachmentGlyph(kind)',
    type: 'ElLucideGlyph Function(ElAgentAttachmentKind)',
    description:
        'One glyph per ElAgentAttachmentKind value: image, fileText '
        '(document), sheet (data), fileCode (code), music2 (audio), file '
        '(other).',
  ),
  DocsApiFact(
    name: 'elAgentAttachmentIsVideo(attachment)',
    type: 'bool Function(ElAgentAttachment)',
    description:
        'attachment.mime.startsWith(\'video/\'). Video is not its own '
        'ElAgentAttachmentKind — the domain classifies it other — so the '
        'lightbox asks the MIME type directly instead.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'ElAgentAttachmentCard composes the vendored attachment.dart '
            'primitive: its own accessibility contract (title, '
            'description, action Semantics) is that primitive\'s, not '
            'reauthored here.',
        'A remove action carries label: "Remove \${attachment.name}": the '
            'accessible name states which file, not just "Remove".',
        'The full-size image trigger carries label: "Open '
            '\${attachment.name} full size" and cursor: '
            'SystemMouseCursors.zoomIn — a sighted, mouse-using reader '
            'gets a hint no keyboard-only signal accompanies (see '
            'Keyboard).',
        'The close control inside the opened preview is a real ElButton '
            'labelled "Close": the same activation keys (Enter, '
            'NumpadEnter, Space) as every other button on this system.',
        'A delivery badge in the reference state wraps its icon-and-text '
            'row in an ElTooltip carrying delivery.reason: the reason is '
            'available on hover/focus, not printed as visible text.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Download and remove are both real ElButton / ElAttachmentAction '
            'controls: Tab reaches them, Enter / NumpadEnter / Space '
            'activate them, the same as every button on this system.',
        'The full-size image trigger (ElAttachmentTrigger) opens on tap; '
            'this file gives it no separate keyboard binding of its own '
            'beyond whatever ElAttachmentTrigger itself wires — read that '
            "primitive's own page for the exact contract.",
        'No custom FocusTraversalPolicy anywhere in '
            'agent_attachments.dart: Tab and Shift+Tab walk whatever order '
            'the surrounding page already declares.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'ElAgentAttachmentList reads MediaQuery.sizeOf(context).width '
            'once: at or above ElBreakpoints.sm, images lay out two per '
            'row when there is more than one; below it, and for the '
            'non-image group always, one per row.',
        'compact switches the image well\'s own cap between el(32) (a '
            'composer tray) and el(80) (a transcript) — a caller\'s own '
            'choice, not a breakpoint.',
        'The full-size preview panel caps its own height at a fraction '
            'of MediaQuery.sizeOf(context).height, so a tall screenshot '
            'never grows past the viewport regardless of its native size.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ElTheme.of(context), <String>[
        'File: lib/src/components/agent_attachments.dart. No companion '
            'parts.',
        'Flutter imports: package:flutter/widgets.dart.',
        'Foundation imports: shadows.dart, spacing.dart (el()), '
            'theme.dart, typography.dart, theme_scope.dart.',
        'Component imports: agent_core.dart (ElAgentAttachment, '
            'ElAgentAttachmentKind, ElAgentDelivery, ElAgentDeliverySent, '
            'elFormatBytes — the domain type, declared elsewhere), '
            'attachment.dart (ElAttachment and every part it composes), '
            'button.dart, dialog.dart (ElModalPortal, ElJellyTransition), '
            'icon.dart, icon_paths.g.dart, tooltip.dart (ElTooltip).',
        'registryDependencies, resolved automatically by `elattar add '
            'agent-attachments`: agent-core, attachment, button, dialog, '
            'icon, source-foundation, tooltip — copied verbatim from '
            'registry/components/agent-attachments.json.',
        'semanticDependencies (the manifest\'s own, narrower field): '
            'agent-core, attachment, button, dialog, icon, tooltip.',
        'agent-core carries no documentation page of its own yet in this '
            'rollout, so it is named here in prose only, not as a link.',
      ]),
      SizedBox(height: el(2)),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: ElWidths.prose),
        child: DocsLinkRow(
          links: <DocsLink>[
            DocsLink(label: 'Button', route: '/components/button'),
            DocsLink(label: 'Dialog', route: '/components/dialog'),
            DocsLink(label: 'Icon', route: '/components/icon'),
            DocsLink(label: 'Tooltip', route: '/components/tooltip'),
          ],
        ),
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Every colour is read live off ElTheme.of(context) at build time: '
            'theme.muted (an icon well\'s plate), theme.mutedForeground '
            '(the size string and an image caption), theme.card and '
            'theme.border (the image caption\'s own frame), '
            'theme.successInk ("Read"), theme.warningInk ("Name only"). '
            'Flipping ElThemeController re-resolves every one on the '
            'next frame.',
        'The full-size preview panel\'s own ring is theme.foreground at a '
            'fixed alpha (ElAttachmentMedia.previewRingAlpha) rather than '
            'theme.border — a deliberate escalation for an overlay that '
            'sits above everything else.',
        'No override hatch of its own: neither ElAgentAttachmentCard nor '
            'ElAgentAttachmentList takes a colour or shape parameter — '
            'every visible fill and radius comes from attachment.dart\'s '
            'own primitives underneath.',
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
    state: 'Generic file',
    treatment: 'ElAttachmentMediaVariant.icon: elAgentAttachmentGlyph(kind) '
        'centred in a 40px well.',
    userSignal: 'The document and data cards in Preview above.',
  ),
  DocsStateFact(
    state: 'Image, no url',
    treatment: 'Falls through to the generic file treatment: isImage '
        'requires both kind == image AND url != null.',
    userSignal: 'A picked-but-not-yet-uploaded image reads as a plain file '
        'row, not a broken picture.',
  ),
  DocsStateFact(
    state: 'Image, with url',
    treatment: 'The large-image treatment: a --muted well capped at '
        'el(32) or el(80) depending on compact, clickable when a picture '
        'was actually supplied by imageBuilder.',
    userSignal: 'See the Image attachment specimen above.',
  ),
  DocsStateFact(
    state: 'Delivery: content',
    treatment: 'ElAgentDeliveryBadge renders "Read" in theme.successInk.',
    userSignal: 'The model received these bytes.',
  ),
  DocsStateFact(
    state: 'Delivery: reference',
    treatment: 'An info glyph plus "Name only" in theme.warningInk, '
        'wrapped in an ElTooltip carrying delivery.reason.',
    userSignal: 'Only the filename reached the model, not the contents.',
  ),
  DocsStateFact(
    state: 'Delivery: produced or null',
    treatment: 'ElAgentDeliveryBadge.build returns SizedBox.shrink().',
    userSignal: 'No badge at all: delivery does not apply to a file the '
        'agent made itself.',
  ),
  DocsStateFact(
    state: 'Remove vs download',
    treatment: 'onRemove != null shows a remove action; onRemove == null '
        'and attachment.url != null shows a download action. Never both '
        'on the same attachment.',
    userSignal: 'See the Remove specimen above.',
  ),
  DocsStateFact(
    state: 'Empty list',
    treatment: 'ElAgentAttachmentList.build returns SizedBox.shrink() when '
        'attachments is empty.',
    userSignal: 'Nothing renders at all, not an empty frame.',
  ),
];
