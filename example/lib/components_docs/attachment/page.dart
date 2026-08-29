/// Public documentation page for the `attachment` component.
///
/// Written from nothing: no page existed for this registry item before this
/// file. Read end to end from `lib/src/components/ui/attachment.dart` (1320
/// lines) and from the working specimens already live in
/// `example/lib/pages/chat.dart`'s `_AttachmentSection` and `_Tray`, whose
/// state grid, size row, media-variant row, preview-and-download row and
/// scrolling group are reproduced below rather than invented — only the
/// sample card image is swapped for a plain coloured box, so this page
/// stays self-contained and does not depend on an app asset.
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

final ComponentDocSpec attachmentDocSpec = ComponentDocSpec(
  name: 'attachment',
  title: 'Attachment',
  description: attachmentDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'All five AttachmentState values, on the same file. Each '
          'card owns its own glyph: a spinner while uploading or '
          'processing, an alert glyph on error, a document glyph '
          'otherwise.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'attachment has a real registry manifest, `elattar add '
          'attachment` installs lib/src/components/ui/attachment.dart and '
          'resolves all five registryDependencies automatically. The '
          'Manual tab is for a project not using the CLI.',
      command: attachmentDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/attachment.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/ui/attachment.dart's generated "
              '@ui/attachment.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated attachment source here when using '
              'manual mode.',
        ),
        DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so Attachment and every part it '
              'composes are reachable the same way the CLI path already '
              'makes them.',
          code: "export 'attachment.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct import and construction: one card, one '
          'glyph. Every example below only adds to this.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'orientation-size',
      title: 'Orientation & size',
      description:
          'Horizontal (the default, min-w-40) at all three sizes: md, '
          'sm, xs. Vertical (below) starts at w-24 and widens to w-30 '
          'once it carries a title.',
      specimen: _OrientationSizeSpecimen(),
      code: _orientationSizeCode,
      label: 'Orientation and size specimen view',
    ),
    ShowcaseSection(
      id: 'media',
      title: 'Media',
      description:
          "AttachmentMediaVariant.icon (the default) centres a glyph "
          'in a coloured well; .image fills the well and dims to 60% '
          'opacity until the state is done or idle — "which is what '
          'makes an upload look like it is still arriving."',
      specimen: _MediaSpecimen(),
      code: _mediaCode,
      label: 'Media specimen view',
    ),
    ShowcaseSection(
      id: 'preview-download',
      title: 'Preview and download',
      description:
          'Two parameters on components that already existed, not two '
          'new ones. preview makes the well expandable — pressing it '
          'opens the media over the dimmed page. downloadName turns an '
          'action into the save control: the glyph rolls to a check for '
          '1600ms and never claims "Saved," only "Saving."',
      specimen: _PreviewDownloadSpecimen(),
      code: _previewDownloadCode,
      label: 'Preview and download specimen view',
    ),
    ShowcaseSection(
      id: 'group',
      title: 'Group',
      description:
          'AttachmentGroup scrolls sideways, snaps each card\'s '
          'measured left edge to a 4px inset, and fades both edges up '
          'to 40px — drag the tray to see the snap and the fade move '
          'together.',
      specimen: _GroupSpecimen(),
      code: _groupCode,
      label: 'Group specimen view',
      minHeight: space(48),
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter each exported class declares, '
          'every enum value, and the public static helpers callers '
          'actually reach for: one table per class or small family of '
          'classes.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'Attachment', anchor: 'api-elattachment'),
        DocsTocEntry(
          title: 'Attachment statics',
          anchor: 'api-elattachment-static',
        ),
        DocsTocEntry(title: 'AttachmentState', anchor: 'api-elattachmentstate'),
        DocsTocEntry(
          title: 'Size · Orientation · Media variant',
          anchor: 'api-elattachment-enums',
        ),
        DocsTocEntry(title: 'AttachmentScope', anchor: 'api-elattachmentscope'),
        DocsTocEntry(title: 'AttachmentMedia', anchor: 'api-elattachmentmedia'),
        DocsTocEntry(
          title: 'Content · Title · Description · Shimmer',
          anchor: 'api-elattachment-content',
        ),
        DocsTocEntry(
          title: 'Actions · Action · Trigger · Group',
          anchor: 'api-elattachment-actions',
        ),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Read off _AttachmentState.build, _DashedBorderBox and '
          '_AttachmentActionState directly, not inferred.',
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
          'attachment.dart wires no key handling of its own anywhere in '
          'the file — every fact here is either inherited from Button '
          'or about what does not happen.',
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
            value: attachmentDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/chat_test.dart',
            description:
                'Covers Attachment live, composed inside the chat '
                'page\'s own attachment section (19 references) — there '
                'is no dedicated attachment_test.dart in the package yet.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/attachment_test.dart',
            description:
                'Covers this page: the article mounts, the full API '
                'table, and every specimen this page claims to show.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/attachment/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class AttachmentDocPage extends StatelessWidget {
  const AttachmentDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: attachmentDoc.route,
    intro: DocsPageIntro(
      title: attachmentDoc.title,
      description: attachmentDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Attachment'),
    ],
    toc: attachmentDocSpec.toc,
    previous: null,
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('attachment-doc-article'),
      child: ComponentDocPage(spec: attachmentDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

/// `ATTACHMENT_STATES`, `chat.dart`'s own list, reproduced.
const List<(AttachmentState, String, String)> _attachmentStates =
    <(AttachmentState, String, String)>[
      (AttachmentState.idle, 'idle', 'dashed: nothing chosen yet'),
      (AttachmentState.uploading, 'uploading', 'spinner + shimmer'),
      (AttachmentState.processing, 'processing', 'sent, being read'),
      (AttachmentState.error, 'error', 'border and media turn'),
      (AttachmentState.done, 'done', 'the resting state'),
    ];

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: space(4),
    runSpacing: space(4),
    crossAxisAlignment: WrapCrossAlignment.start,
    children: <Widget>[
      for (final (AttachmentState state, String label, String note)
          in _attachmentStates)
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            KeyedSubtree(
              key: ValueKey<String>('attachment-preview:$label'),
              child: Attachment(
                state: state,
                size: AttachmentSize.sm,
                orientation: AttachmentOrientation.vertical,
                media: AttachmentMedia(
                  child: switch (state) {
                    AttachmentState.uploading ||
                    AttachmentState.processing => const Spinner(),
                    AttachmentState.error => const Icon.lucide(
                      Lucide.circleAlert,
                      sizePx: 24,
                    ),
                    _ => const Icon.lucide(Lucide.sheet, sizePx: 24),
                  },
                ),
                content: AttachmentContent(
                  title: const AttachmentTitle('rarity-table.csv'),
                  description: AttachmentDescription(
                    state == AttachmentState.error ? 'Upload failed' : '18 KB',
                  ),
                ),
              ),
            ),
            SizedBox(height: space(2)),
            StyledText(
              '$label · $note',
              TextStyles.small,
              color: ThemeScope.of(context).mutedForeground,
            ),
          ],
        ),
    ],
  );
}

const String _previewCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    'Attachment(\n'
    '  state: AttachmentState.uploading,\n'
    '  size: AttachmentSize.sm,\n'
    '  orientation: AttachmentOrientation.vertical,\n'
    '  media: const AttachmentMedia(child: Spinner()),\n'
    '  content: AttachmentContent(\n'
    "    title: const AttachmentTitle('rarity-table.csv'),\n"
    "    description: AttachmentDescription('18 KB'),\n"
    '  ),\n'
    ')';

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

Attachment(
  media: AttachmentMedia(
    child: Icon.lucide(Lucide.fileText, sizePx: 16),
  ),
  content: const AttachmentContent(
    title: AttachmentTitle('report.pdf'),
    description: AttachmentDescription('2.6 MB'),
  ),
)''';

class _OrientationSizeSpecimen extends StatelessWidget {
  const _OrientationSizeSpecimen();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Wrap(
        spacing: space(3),
        runSpacing: space(3),
        children: <Widget>[
          for (final AttachmentSize size in AttachmentSize.values)
            KeyedSubtree(
              key: ValueKey<String>('attachment-example:size-${size.name}'),
              child: Attachment(
                size: size,
                media: AttachmentMedia(
                  child: Icon.lucide(
                    Lucide.fileText,
                    sizePx: AttachmentMedia.glyphFor(
                      size,
                      AttachmentOrientation.horizontal,
                    ),
                  ),
                ),
                content: AttachmentContent(
                  title: const AttachmentTitle('eclipse-vault-notes.pdf'),
                  description: AttachmentDescription('size=${size.label}'),
                ),
                actions: AttachmentActions(
                  children: <Widget>[
                    AttachmentAction(
                      label: 'Remove eclipse-vault-notes.pdf',
                      onPressed: () {},
                      child: Icon.lucide(
                        Lucide.x,
                        sizePx: Button.iconPxFor(ButtonSize.iconXs),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      SizedBox(height: space(4)),
      Wrap(
        spacing: space(3),
        runSpacing: space(3),
        children: <Widget>[
          KeyedSubtree(
            key: const ValueKey<String>('attachment-example:vertical-empty'),
            child: Attachment(
              orientation: AttachmentOrientation.vertical,
              media: const AttachmentMedia(
                child: Icon.lucide(Lucide.image, sizePx: 24),
              ),
            ),
          ),
          KeyedSubtree(
            key: const ValueKey<String>('attachment-example:vertical-titled'),
            child: Attachment(
              orientation: AttachmentOrientation.vertical,
              media: const AttachmentMedia(
                child: Icon.lucide(Lucide.image, sizePx: 24),
              ),
              content: const AttachmentContent(
                title: AttachmentTitle('slab-front.heic'),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

const String _orientationSizeCode =
    'for (final size in AttachmentSize.values)\n'
    '  Attachment(\n'
    '    size: size,\n'
    '    media: AttachmentMedia(\n'
    '      child: Icon.lucide(Lucide.fileText,\n'
    '        sizePx: AttachmentMedia.glyphFor(size, AttachmentOrientation.horizontal)),\n'
    '    ),\n'
    '    content: AttachmentContent(\n'
    "      title: const AttachmentTitle('eclipse-vault-notes.pdf'),\n"
    "      description: AttachmentDescription('size=\${size.label}'),\n"
    '    ),\n'
    '  )\n\n'
    '// w-24, widening to w-30 once content is given.\n'
    'const Attachment(\n'
    '  orientation: AttachmentOrientation.vertical,\n'
    '  media: AttachmentMedia(child: Icon(...)),\n'
    ')';

class _MediaSpecimen extends StatelessWidget {
  const _MediaSpecimen();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Wrap(
      spacing: space(3),
      runSpacing: space(3),
      children: <Widget>[
        KeyedSubtree(
          key: const ValueKey<String>('attachment-example:media-image'),
          child: Attachment(
            orientation: AttachmentOrientation.vertical,
            media: AttachmentMedia(
              variant: AttachmentMediaVariant.image,
              child: ColoredBox(color: theme.primary),
            ),
            content: const AttachmentContent(
              title: AttachmentTitle('sample-card.png'),
              description: AttachmentDescription('412 KB'),
            ),
          ),
        ),
        KeyedSubtree(
          key: const ValueKey<String>('attachment-example:media-icon'),
          child: Attachment(
            orientation: AttachmentOrientation.vertical,
            media: const AttachmentMedia(
              child: Icon.lucide(Lucide.image, sizePx: 24),
            ),
            content: const AttachmentContent(
              title: AttachmentTitle('slab-front.heic'),
              description: AttachmentDescription('No preview'),
            ),
          ),
        ),
        KeyedSubtree(
          key: const ValueKey<String>('attachment-example:media-uploading'),
          child: Attachment(
            state: AttachmentState.uploading,
            orientation: AttachmentOrientation.vertical,
            media: AttachmentMedia(
              variant: AttachmentMediaVariant.image,
              child: ColoredBox(color: theme.primary),
            ),
            content: const AttachmentContent(
              title: AttachmentTitle('sample-card.png'),
              description: AttachmentDescription('Uploading…'),
            ),
          ),
        ),
      ],
    );
  }
}

const String _mediaCode =
    '// variant: image fills the well and dims to 60% opacity until\n'
    '// the state is done or idle.\n'
    'Attachment(\n'
    '  orientation: AttachmentOrientation.vertical,\n'
    '  media: AttachmentMedia(\n'
    '    variant: AttachmentMediaVariant.image,\n'
    '    child: Image(...),\n'
    '  ),\n'
    '  content: const AttachmentContent(\n'
    "    title: AttachmentTitle('sample-card.png'),\n"
    "    description: AttachmentDescription('412 KB'),\n"
    '  ),\n'
    ')';

class _PreviewDownloadSpecimen extends StatelessWidget {
  const _PreviewDownloadSpecimen();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Wrap(
      spacing: space(3),
      runSpacing: space(3),
      crossAxisAlignment: WrapCrossAlignment.start,
      children: <Widget>[
        KeyedSubtree(
          key: const ValueKey<String>('attachment-example:preview'),
          child: Attachment(
            orientation: AttachmentOrientation.vertical,
            media: AttachmentMedia(
              variant: AttachmentMediaVariant.image,
              previewName: 'sample-card.png',
              previewDescription: '412 KB',
              preview: ColoredBox(color: theme.primary),
              child: ColoredBox(color: theme.primary),
            ),
            content: const AttachmentContent(
              title: AttachmentTitle('sample-card.png'),
              description: AttachmentDescription('412 KB · press to expand'),
            ),
          ),
        ),
        KeyedSubtree(
          key: const ValueKey<String>('attachment-example:download'),
          child: Attachment(
            media: const AttachmentMedia(
              child: Icon.lucide(Lucide.fileText, sizePx: 16),
            ),
            content: const AttachmentContent(
              title: AttachmentTitle('grading-report.pdf'),
              description: AttachmentDescription('2.6 MB'),
            ),
            actions: AttachmentActions(
              children: <Widget>[
                AttachmentAction(
                  downloadName: 'grading-report.pdf',
                  onDownload: (String name) {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

const String _previewDownloadCode =
    '// preview makes the well expandable — pressing it opens the\n'
    '// media over the dimmed page.\n'
    'AttachmentMedia(\n'
    "  previewName: 'sample-card.png',\n"
    "  previewDescription: '412 KB',\n"
    '  preview: Image(...), // the full-size media\n'
    '  child: Image(...), // the thumbnail\n'
    ')\n\n'
    '// downloadName turns an action into the save control: the glyph\n'
    '// rolls to a check for 1600ms, and onDownload fires "Saving",\n'
    '// never "Saved" — a plain download anchor gives no completion event.\n'
    'AttachmentAction(\n'
    "  downloadName: 'grading-report.pdf',\n"
    '  onDownload: (name) => showToast(\'Saving \$name\'),\n'
    ')';

class _GroupSpecimen extends StatelessWidget {
  const _GroupSpecimen();

  static const List<String> _names = <String>[
    'rarity-table.csv',
    'eclipse-vault-notes.pdf',
    'grading-report.pdf',
    'pull-rates-q3.csv',
    'slab-front.png',
    'slab-back.png',
  ];

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('attachment-example:group'),
    child: AttachmentGroup(
      children: <Widget>[
        for (final String name in _names)
          Attachment(
            size: AttachmentSize.sm,
            media: AttachmentMedia(
              child: Icon.lucide(
                Lucide.fileText,
                sizePx: AttachmentMedia.glyphFor(
                  AttachmentSize.sm,
                  AttachmentOrientation.horizontal,
                ),
              ),
            ),
            content: AttachmentContent(
              title: AttachmentTitle(name),
              description: const AttachmentDescription('Ready'),
            ),
          ),
      ],
    ),
  );
}

const String _groupCode =
    'AttachmentGroup(\n'
    '  children: [\n'
    '    for (final name in names)\n'
    '      Attachment(\n'
    '        size: AttachmentSize.sm,\n'
    '        media: AttachmentMedia(child: Icon.lucide(Lucide.fileText, sizePx: 14)),\n'
    '        content: AttachmentContent(\n'
    '          title: AttachmentTitle(name),\n'
    "          description: const AttachmentDescription('Ready'),\n"
    '        ),\n'
    '      ),\n'
    '  ],\n'
    ')';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elattachment',
        child: DocsApiTable(title: 'Attachment', facts: _attachmentFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elattachment-static',
        child: DocsApiTable(
          title: 'Attachment statics',
          facts: _attachmentStaticFacts,
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elattachmentstate',
        child: DocsApiTable(
          title: 'AttachmentState',
          facts: _attachmentStateFacts,
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elattachment-enums',
        child: DocsApiTable(
          title: 'Size · Orientation · Media variant',
          facts: _smallEnumFacts,
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elattachmentscope',
        child: DocsApiTable(title: 'AttachmentScope', facts: _scopeFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elattachmentmedia',
        child: DocsApiTable(title: 'AttachmentMedia', facts: _mediaFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elattachment-content',
        child: DocsApiTable(
          title: 'Content · Title · Description · Shimmer',
          facts: _contentFacts,
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elattachment-actions',
        child: DocsApiTable(
          title: 'Actions · Action · Trigger · Group',
          facts: _actionsFacts,
        ),
      ),
    ],
  );
}

const List<DocsApiFact> _attachmentFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'media',
    type: 'Widget (required)',
    description: 'The thumbnail well — an AttachmentMedia in practice.',
  ),
  DocsApiFact(
    name: 'content',
    type: 'Widget?',
    description:
        'Optional. Defaults to null. Title and description, laid out '
        'flex-1 min-w-0 so truncate has something to bite in a '
        'horizontal card.',
  ),
  DocsApiFact(
    name: 'actions',
    type: 'Widget?',
    description:
        'Optional. Defaults to null. A relative sibling in a '
        'horizontal card; absolutely positioned top-right in a vertical '
        'one.',
  ),
  DocsApiFact(
    name: 'state',
    type: 'AttachmentState',
    description:
        'Optional. Defaults to AttachmentState.done. See the table '
        'below.',
  ),
  DocsApiFact(
    name: 'size',
    type: 'AttachmentSize',
    description:
        'Optional. Defaults to AttachmentSize.md. Drives padding, '
        'gap and radius — see the enums table below.',
  ),
  DocsApiFact(
    name: 'orientation',
    type: 'AttachmentOrientation',
    description:
        'Optional. Defaults to AttachmentOrientation.horizontal '
        '(min-w-40, a row). vertical is a w-24 tile that widens to '
        'w-30 once content is given.',
  ),
];

const List<DocsApiFact> _attachmentStaticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'Attachment.paddingFor(size)',
    type: 'static double',
    description: '8 / 6 / 4 — the rule that wins over four dead class lists.',
  ),
  DocsApiFact(
    name: 'Attachment.gapFor(size)',
    type: 'static double',
    description: '8 / 10 / 6 — sm is the widest gap of the three.',
  ),
  DocsApiFact(
    name: 'Attachment.radiusFor(size)',
    type: 'static double',
    description: 'Radii.xl, Radii.lg on xs.',
  ),
  DocsApiFact(
    name: 'Attachment.horizontalMinWidth',
    type: 'static double',
    description: '160 — the horizontal card\'s floor width.',
  ),
  DocsApiFact(
    name: 'Attachment.verticalWidth',
    type: 'static double',
    description: '96 — a vertical card with no content.',
  ),
  DocsApiFact(
    name: 'Attachment.verticalWidthWithContent',
    type: 'static double',
    description: '120 — a vertical card once it carries a title.',
  ),
  DocsApiFact(
    name: 'Attachment.focusRingAlpha',
    type: 'static const double',
    description: '0.50 — the focus-within ring alpha.',
  ),
  DocsApiFact(
    name: 'Attachment.errorBorderAlpha',
    type: 'static const double',
    description: '0.30 — the error-state border alpha.',
  ),
];

const List<DocsApiFact> _attachmentStateFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'idle',
    type: 'enum value',
    description: 'A dashed border. Nothing chosen yet.',
  ),
  DocsApiFact(
    name: 'uploading',
    type: 'enum value',
    description: 'Spinner in the well, the title on a shimmer.',
  ),
  DocsApiFact(
    name: 'processing',
    type: 'enum value',
    description: 'Sent, being read. Same treatment as uploading.',
  ),
  DocsApiFact(
    name: 'error',
    type: 'enum value',
    description:
        'border-destructive/30, and the media well turns '
        'bg-destructive/10 text-destructive-ink.',
  ),
  DocsApiFact(
    name: 'done',
    type: 'enum value',
    description: 'The resting state, and the constructor default.',
  ),
];

const List<DocsApiFact> _smallEnumFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'AttachmentSize.md',
    type: 'enum value',
    description:
        '13px text, 40px well. Named md because default is a '
        'Dart keyword.',
  ),
  DocsApiFact(
    name: 'AttachmentSize.sm',
    type: 'enum value',
    description: '12px, 32px.',
  ),
  DocsApiFact(
    name: 'AttachmentSize.xs',
    type: 'enum value',
    description: '12px, 28px, and a tighter radius.',
  ),
  DocsApiFact(
    name: 'AttachmentOrientation.horizontal',
    type: 'enum value',
    description: 'The default: a row with a 160px floor.',
  ),
  DocsApiFact(
    name: 'AttachmentOrientation.vertical',
    type: 'enum value',
    description: 'A 96px tile that widens to 120 once titled.',
  ),
  DocsApiFact(
    name: 'AttachmentMediaVariant.icon',
    type: 'enum value',
    description: 'The default: centres child in a coloured well.',
  ),
  DocsApiFact(
    name: 'AttachmentMediaVariant.image',
    type: 'enum value',
    description:
        'Expects a real image child and dims it to 60% until the '
        'state is done or idle.',
  ),
];

const List<DocsApiFact> _scopeFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'AttachmentScope.of(context)',
    type: 'static AttachmentScope',
    description:
        'What every slot inside an Attachment reads to find its own '
        'state, size and orientation — asserts if nothing is above it.',
  ),
  DocsApiFact(
    name: 'state',
    type: 'AttachmentState',
    description: 'The enclosing Attachment\'s own state, republished.',
  ),
  DocsApiFact(
    name: 'size',
    type: 'AttachmentSize',
    description: 'Republished for a slot to read.',
  ),
  DocsApiFact(
    name: 'orientation',
    type: 'AttachmentOrientation',
    description: 'Republished for a slot to read.',
  ),
];

const List<DocsApiFact> _mediaFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'child',
    type: 'Widget (required)',
    description: 'The glyph, or the image, depending on variant.',
  ),
  DocsApiFact(
    name: 'variant',
    type: 'AttachmentMediaVariant',
    description: 'Optional. Defaults to .icon.',
  ),
  DocsApiFact(
    name: 'preview',
    type: 'Widget?',
    description:
        'Optional. Defaults to null. Supplying it makes the well '
        'expandable: an overlay trigger opens it over the dimmed page '
        'through the shared dialog portal. Null leaves the well static.',
  ),
  DocsApiFact(
    name: 'previewName',
    type: 'String?',
    description:
        'Optional. Defaults to null (renders as "media"). The '
        'accessible title for the preview panel.',
  ),
  DocsApiFact(
    name: 'previewDescription',
    type: 'String?',
    description:
        'Optional. Defaults to null. A second, screen-reader-only line.',
  ),
  DocsApiFact(
    name: 'AttachmentMedia.wellFor(size)',
    type: 'static double?',
    description: '40 / 32 / 28 — null on a vertical md, which fills instead.',
  ),
  DocsApiFact(
    name: 'AttachmentMedia.radiusFor(size)',
    type: 'static double',
    description: 'Radii.lg, Radii.md on xs.',
  ),
  DocsApiFact(
    name: 'AttachmentMedia.glyphFor(size, orientation)',
    type: 'static double',
    description:
        '14 on xs (wins even in a vertical card); 24 vertical, 16 '
        'horizontal otherwise.',
  ),
  DocsApiFact(
    name: 'AttachmentMedia.imageDimmed',
    type: 'static const double',
    description: '0.60 — the image variant\'s dimmed opacity.',
  ),
  DocsApiFact(
    name: 'AttachmentMedia.errorWellAlpha',
    type: 'static const double',
    description: '0.10 — the well fill alpha in the error state.',
  ),
  DocsApiFact(
    name: 'AttachmentMedia.previewMaxWidth',
    type: 'static double',
    description: '768 — the preview panel\'s own max-w-3xl.',
  ),
  DocsApiFact(
    name: 'AttachmentMedia.previewMaxHeightFraction',
    type: 'static const double',
    description: '0.70 — max-h-[70vh] on the previewed media.',
  ),
  DocsApiFact(
    name: 'AttachmentMedia.previewRingAlpha',
    type: 'static const double',
    description: '0.10 — the preview panel\'s whole box-shadow.',
  ),
  DocsApiFact(
    name: 'AttachmentMedia.previewCloseInset',
    type: 'static double',
    description: '12 — top-3 right-3 on the close control.',
  ),
];

const List<DocsApiFact> _contentFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'AttachmentContent.title',
    type: 'Widget (required)',
    description: 'An AttachmentTitle in practice.',
  ),
  DocsApiFact(
    name: 'AttachmentContent.description',
    type: 'Widget?',
    description: 'Optional. Defaults to null.',
  ),
  DocsApiFact(
    name: 'AttachmentContent.verticalInset',
    type: 'static double',
    description: '4 — the horizontal px content gets in a vertical card.',
  ),
  DocsApiFact(
    name: 'AttachmentTitle(text)',
    type: 'String (positional, required)',
    description:
        'Truncates to one line; shimmers while the state is uploading '
        'or processing (AttachmentStatusText).',
  ),
  DocsApiFact(
    name: 'AttachmentDescription(text)',
    type: 'String (positional, required)',
    description:
        'Truncates to one line; theme.destructiveText in the error '
        'state (no opacity — measured to clear AA where the reference\'s '
        'own 80%-alpha ink fails it).',
  ),
  DocsApiFact(
    name: 'AttachmentDescription.topGap',
    type: 'static double',
    description: '2 — mt-0.5 above the description line.',
  ),
  DocsApiFact(
    name: 'AttachmentStatusText.child',
    type: 'Widget (required)',
    description: 'What the highlight band sweeps across — a Text in practice.',
  ),
  DocsApiFact(
    name: 'AttachmentStatusText.period',
    type: 'static const Duration',
    description: '2 seconds — one full sweep, looping.',
  ),
  DocsApiFact(
    name: 'AttachmentStatusText.spreadChars',
    type: 'static const double',
    description: '3 — the ch half of the band\'s width, font-relative.',
  ),
  DocsApiFact(
    name: 'AttachmentStatusText.spreadPx',
    type: 'static double',
    description: '40 — the fixed px half of the band\'s width.',
  ),
  DocsApiFact(
    name: 'AttachmentStatusText.angleDegrees',
    type: 'static const double',
    description: '20 — added to the gradient axis\'s own 90°.',
  ),
  DocsApiFact(
    name: 'AttachmentStatusText.lightHighlightAlpha',
    type: 'static const double',
    description: '0.20 — the light theme\'s highlight alpha over the ink.',
  ),
];

const List<DocsApiFact> _actionsFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'AttachmentActions.children',
    type: 'List<Widget> (required)',
    description: 'The cluster on the right, usually AttachmentAction rows.',
  ),
  DocsApiFact(
    name: 'AttachmentActions.verticalGap',
    type: 'static double',
    description: '4 — gap-1 between actions, vertical cards only.',
  ),
  DocsApiFact(
    name: 'AttachmentAction.child',
    type: 'Widget?',
    description:
        'Optional. Defaults to null. The glyph — null on the download '
        'form, which supplies its own icon swap.',
  ),
  DocsApiFact(
    name: 'AttachmentAction.onPressed',
    type: 'VoidCallback?',
    description: 'Optional. Defaults to null.',
  ),
  DocsApiFact(
    name: 'AttachmentAction.label',
    type: 'String?',
    description: 'Optional. Defaults to null. The accessible name.',
  ),
  DocsApiFact(
    name: 'AttachmentAction.downloadName',
    type: 'String?',
    description:
        'Optional. Defaults to null. Non-null turns this into the '
        'save control.',
  ),
  DocsApiFact(
    name: 'AttachmentAction.onDownload',
    type: 'void Function(String name)?',
    description:
        'Optional. Defaults to null. Fired with downloadName when the '
        'save control is pressed — for the caller\'s own "Saving '
        '<name>" toast, never "Saved."',
  ),
  DocsApiFact(
    name: 'AttachmentAction.savingWindow',
    type: 'static const Duration',
    description: '1600ms — how long the check glyph holds before rolling back.',
  ),
  DocsApiFact(
    name: 'AttachmentTrigger.onPressed',
    type: 'VoidCallback (required)',
    description:
        'The overlay control that makes a whole attachment pressable '
        'without nesting a button inside a button.',
  ),
  DocsApiFact(
    name: 'AttachmentTrigger.cursor',
    type: 'MouseCursor',
    description: 'Optional. Defaults to SystemMouseCursors.click.',
  ),
  DocsApiFact(
    name: 'AttachmentTrigger.label',
    type: 'String?',
    description: 'Optional. Defaults to null. The accessible name.',
  ),
  DocsApiFact(
    name: 'AttachmentGroup.children',
    type: 'List<Widget> (required)',
    description: 'The row of cards, each keeping its own measured width.',
  ),
  DocsApiFact(
    name: 'AttachmentGroup.gap',
    type: 'static double',
    description: '12 — gap-3 between cards.',
  ),
  DocsApiFact(
    name: 'AttachmentGroup.paddingY',
    type: 'static double',
    description: '4 — py-1 above and below the row.',
  ),
  DocsApiFact(
    name: 'AttachmentGroup.scrollPadding',
    type: 'static double',
    description: '4 — the inset a snapped card\'s leading edge lands at.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'idle',
    treatment: 'A dashed border, painted by a stroked, dashed RRect path.',
    userSignal: 'An empty tray waiting for a file.',
  ),
  DocsStateFact(
    state: 'uploading / processing',
    treatment:
        'A spinner (or caller-supplied glyph) in the well; the title '
        'wraps in AttachmentStatusText, sweeping a highlight band every 2s.',
    userSignal: 'A moving highlight across the file name.',
  ),
  DocsStateFact(
    state: 'error',
    treatment:
        'border-destructive at 30% alpha; the well fills '
        'destructive at 10% and its ink turns destructiveText; the '
        'description switches to the caller\'s error text.',
    userSignal: 'A red-rimmed card with a red-tinted well.',
  ),
  DocsStateFact(
    state: 'done',
    treatment: 'The default: a solid theme.border rim, no shimmer.',
    userSignal: 'The resting card.',
  ),
  DocsStateFact(
    state: 'Focus-within',
    treatment:
        'A 1px ring at theme.ring 50% alpha appears the instant any '
        'descendant (a trigger, an action) gains focus — Focus'
        '.onFocusChange on the card\'s own wrapper, not a hover.',
    userSignal: 'A faint ring around the whole card.',
  ),
  DocsStateFact(
    state: 'Saving (an action with downloadName)',
    treatment:
        'The download glyph rolls to a check through IconSwap for '
        '1600ms (AttachmentAction.savingWindow), then rolls back.',
    userSignal: 'A brief checkmark where the download glyph was.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'AttachmentStatusText stills at its first frame (the band entirely '
        'off the left edge) under MediaQuery.disableAnimations; the '
        'group\'s snap-scroll animateTo also collapses through '
        'effectiveMotionDuration.',
    userSignal: 'No sweep on an uploading title; a snap lands instantly.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'AttachmentTrigger (the expandable-preview overlay) is a '
            'Semantics(button: true, label: label) over an otherwise '
            'invisible hit area — the accessible name is "Open <name> '
            'full size".',
        'AttachmentAction composes Button, so it inherits '
            'Semantics(button: true) and whatever label the caller '
            'passes, or "Download <downloadName>" on the save form when '
            'none is given.',
        'The media preview panel (_AttachmentPreview) wraps itself in a '
            'Semantics(container: true, label: "<name>. <description>"), '
            'the port\'s equivalent of the reference\'s sr-only dialog '
            'header.',
        'Known gap: neither the shimmer sweep nor the saving check-mark '
            'swap is announced to a screen reader — both are purely '
            'visual state changes with no accompanying Semantics update.',
        'Known gap: AttachmentTitle and AttachmentDescription carry '
            'no Semantics of their own beyond the plain text a screen '
            'reader already gets from StyledText — there is no live region '
            'announcing a state change from uploading to error, for '
            'instance.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'attachment.dart wires no Focus.onKeyEvent anywhere: the card '
            'itself (_AttachmentState) only listens for '
            'onFocusChange, to paint the focus-within ring.',
        'Every interactive part is an Button underneath — '
            'AttachmentAction directly, AttachmentTrigger through a '
            'plain GestureDetector rather than a button — so Enter, '
            'NumpadEnter and Space activate a focused action the same '
            'way they activate any Button; the trigger overlay '
            'answers only to a tap, not a key.',
        'No custom FocusTraversalPolicy: Tab and Shift+Tab walk '
            'whatever order the surrounding page declares.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No MediaQuery.sizeOf breakpoint branch anywhere in '
            'attachment.dart: every measurement (paddingFor, gapFor, '
            'radiusFor, wellFor, glyphFor) is keyed only to '
            'AttachmentSize and AttachmentOrientation, never to '
            'viewport.',
        'AttachmentGroup answers to its own available width through '
            'ordinary scrolling, not a breakpoint: the fade fraction '
            '(min(12%, 40px)) is computed from the container\'s own '
            'measured width inside a LayoutBuilder.',
        'A horizontal card grows past its 160px floor with '
            'IntrinsicWidth rather than an Expanded, so it works inside '
            'a Wrap, which needs no bounded width, the way a bare '
            'Expanded would not.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ThemeScope.of(context), <String>[
        'File: lib/src/components/ui/attachment.dart — one file, no '
            'companions; the registry manifest lists exactly one entry '
            'under "files".',
        'Flutter imports: dart:math, dart:ui, package:flutter/'
            'gestures.dart (PointerDeviceKind), package:flutter/'
            'widgets.dart.',
        'Foundation imports: foundation/motion.dart (effectiveMotionDuration), '
            'foundation/shadows.dart, foundation/spacing.dart (space()), '
            'foundation/theme.dart, foundation/typography.dart, '
            'theme_scope.dart.',
        'Component imports: button.dart (Button, the actions), '
            'dialog.dart (OverlayPortal, OpenTransition — the preview '
            'panel), icon.dart, icon_paths.g.dart, icon_swap.dart '
            '(IconSwap — the download/saved glyph roll).',
        'registryDependencies, resolved automatically by `elattar add '
            'attachment`: button, dialog, icon, icon-swap, '
            'source-foundation — copied verbatim from '
            'registry/components/attachment.json.',
      ]),
      SizedBox(height: space(3)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Button', route: '/components/button'),
          DocsLink(label: 'Dialog', route: '/components/dialog'),
          DocsLink(label: 'Icon', route: '/components/icon'),
          DocsLink(label: 'Icon Swap', route: '/components/icon_swap'),
        ],
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Every colour is read live off ThemeScope.of(context) at build '
            'time: theme.card (the fill), theme.border / theme.destructive '
            '(the rim), theme.muted (the icon well), theme.destructiveText '
            '(the error description) and theme.ring (the focus-within '
            'ring).',
        'The shimmer highlight is theme-aware in a different way: dark '
            'resolves to a measured near-white, light to theme.foreground '
            'at 20% alpha — a relative-colour rule, not a token lookup.',
        'The preview panel\'s ring (foreground/10) and its close '
            'button (a secondary Button, chosen specifically because '
            'a ghost control would disappear into the photograph under '
            'it) both read theme live as well.',
        'Flipping ThemeController re-resolves every one of these on '
            'the next frame: nothing here is cached.',
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
