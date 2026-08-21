/// Public component documentation for the dialog component.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../docs/docs_code.dart';
import '../docs/docs_facts.dart';
import '../docs/docs_layout.dart';
import '../kit.dart';
import 'catalog.dart';

class DialogDocPage extends StatelessWidget {
  const DialogDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    final ComponentDocEntry entry = componentDoc('dialog');
    return DocsLayout(
      route: entry.route,
      intro: DocsPageIntro(
        eyebrow: 'COMPONENTS / OVERLAYS',
        title: entry.title,
        description:
            'A focused modal surface for tasks that need attention without leaving the current page. Compose a normal dialog or a full-bleed media variant from the same portal.',
      ),
      breadcrumbs: const <DsBreadcrumbEntry>[
        DsBreadcrumbEntry.link('Components'),
        DsBreadcrumbEntry.page('Dialog'),
      ],
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Preview', anchor: 'preview'),
        DocsTocEntry(title: 'Install', anchor: 'install'),
        DocsTocEntry(title: 'API', anchor: 'api'),
        DocsTocEntry(title: 'States', anchor: 'states'),
        DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
      ],
      previous: const DocsPageLink(title: 'Card', route: '/components/card'),
      next: const DocsPageLink(title: 'Select', route: '/components/select'),
      onNavigate: onNavigate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DsSection(
            id: 'preview',
            title: 'Preview',
            description:
                'Open each specimen to inspect the overlay, close affordance, focus scope, and responsive content behavior.',
            child: const DocsCodeExample(
              title: 'Dialog specimens',
              description: 'Normal and media variants use the same portal.',
              preview: _DialogPreview(),
              command: DocsCodeCommand(command: 'elattar add dialog'),
              manualFiles: <DocsCodeFile>[
                DocsCodeFile(
                  path: 'lib/components/ui/dialog.dart',
                  code:
                      "import 'package:flutter/widgets.dart';\n\n// Install the registry item with: elattar add dialog",
                ),
              ],
            ),
          ),
          DsSection(
            id: 'install',
            title: 'Installation',
            child: DocsInstallFacts(
              facts: <DocsInstallFact>[
                DocsInstallFact(
                  label: 'CLI',
                  value: entry.command,
                  description:
                      'Copies the source into lib/components/ui and resolves its foundation dependencies.',
                ),
                DocsInstallFact(
                  label: 'Manual',
                  value: entry.sourcePath,
                  description:
                      'Copy the source file and preserve the generated relative imports.',
                ),
                const DocsInstallFact(
                  label: 'Version',
                  value: '0.0.1',
                  description: 'Registry schema v1 component manifest.',
                ),
              ],
            ),
          ),
          DsSection(
            id: 'usage',
            title: 'Usage',
            child: DsPanel(
              label: 'DART',
              note: 'COMPOSE',
              child: DocsSelectableCodeBlock(code: _usageCode),
            ),
          ),
          DsSection(
            id: 'api',
            title: 'API',
            child: DocsApiTable(
              facts: const <DocsApiFact>[
                DocsApiFact(
                  name: 'trigger',
                  type: 'Widget Function(BuildContext, VoidCallback)',
                  description: 'Builds the control that opens the portal.',
                ),
                DocsApiFact(
                  name: 'content',
                  type: 'Widget Function(BuildContext, VoidCallback)',
                  description:
                      'Builds the panel and receives its close callback.',
                ),
                DocsApiFact(
                  name: 'variant',
                  type: 'DsDialogVariant',
                  description: 'normal or media anatomy.',
                ),
                DocsApiFact(
                  name: 'showCloseButton',
                  type: 'bool',
                  description:
                      'Adds the labelled close affordance; defaults to true.',
                ),
                DocsApiFact(
                  name: 'onOpenChange',
                  type: 'ValueChanged<bool>?',
                  description: 'Observes open and close transitions.',
                ),
              ],
            ),
          ),
          DsSection(
            id: 'states',
            title: 'States and accessibility',
            child: DocsStateMatrix(
              facts: const <DocsStateFact>[
                DocsStateFact(
                  state: 'Closed',
                  treatment: 'Portal content is not mounted.',
                  userSignal: 'Trigger remains available.',
                ),
                DocsStateFact(
                  state: 'Open',
                  treatment: 'Scrim, focus scope, and animated panel mount.',
                  userSignal: 'Title and actions are visible.',
                ),
                DocsStateFact(
                  state: 'Escape / back',
                  treatment: 'Topmost modal closes first.',
                  userSignal: 'The page remains in place.',
                ),
                DocsStateFact(
                  state: 'Long content',
                  treatment: 'Body scrolls while bands stay pinned.',
                  userSignal: 'Title and actions remain reachable.',
                ),
                DocsStateFact(
                  state: 'Media',
                  treatment:
                      'Full-bleed media slot, wider panel, optional close button.',
                  userSignal: 'Artwork is clipped to the panel.',
                ),
              ],
            ),
          ),
          DsSection(
            id: 'dependencies',
            title: 'Dependencies and source',
            child: DocsInstallFacts(
              facts: <DocsInstallFact>[
                DocsInstallFact(
                  label: 'Dependencies',
                  value: entry.dependencies.join(', '),
                  description:
                      'Resolved by the registry before the dialog source is copied.',
                ),
                DocsInstallFact(
                  label: 'Exports',
                  value: entry.exports.join(', '),
                  description:
                      'Public symbols available from the installed component.',
                ),
                DocsInstallFact(
                  label: 'Source',
                  value: entry.sourcePath,
                  description:
                      'Authoritative package source used by the registry.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const String _usageCode = '''DsDialog(
  trigger: (context, open) => DsButton(
    onPressed: open,
    child: const Text('Open dialog'),
  ),
  content: (context, close) => DsDialogContent(
    onClose: close,
    children: <Widget>[
      DsDialogHeader(children: <Widget>[
        DsDialogTitle('Confirm action'),
        DsDialogDescription('Review the change before continuing.'),
      ]),
      DsDialogFooter(children: <Widget>[
        DsButton(onPressed: close, child: const Text('Cancel')),
      ]),
    ],
  ),
)''';

class _DialogPreview extends StatefulWidget {
  const _DialogPreview();

  @override
  State<_DialogPreview> createState() => _DialogPreviewState();
}

class _DialogPreviewState extends State<_DialogPreview> {
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: ds(3),
    runSpacing: ds(3),
    children: <Widget>[
      DsDialog(
        trigger: (BuildContext context, VoidCallback open) =>
            DsButton(onPressed: open, child: const Text('Open normal')),
        content: (BuildContext context, VoidCallback close) => DsDialogContent(
          onClose: close,
          children: <Widget>[
            const DsDialogHeader(
              children: <Widget>[
                DsDialogTitle('Confirm action'),
                DsDialogDescription('This is a live modal preview.'),
              ],
            ),
            DsDialogFooter(
              children: <Widget>[
                DsButton(onPressed: close, child: Text('Cancel')),
              ],
            ),
          ],
        ),
      ),
      DsDialog(
        trigger: (BuildContext context, VoidCallback open) => DsButton(
          variant: DsButtonVariant.outline,
          onPressed: open,
          child: const Text('Open media'),
        ),
        content: (BuildContext context, VoidCallback close) => DsDialogContent(
          variant: DsDialogVariant.media,
          showCloseButton: false,
          children: <Widget>[
            DsDialogMedia(
              child: ColoredBox(
                color: DsPalette.action,
                child: Center(child: DsIcon(DsIconGlyph.sparkles)),
              ),
            ),
            const DsDialogHeader(
              children: <Widget>[
                DsDialogTitle('A visual lead'),
                DsDialogDescription('Media dialogs use the same close flow.'),
              ],
            ),
            DsDialogFooter(
              children: <Widget>[
                DsButton(onPressed: close, child: Text('Continue')),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
