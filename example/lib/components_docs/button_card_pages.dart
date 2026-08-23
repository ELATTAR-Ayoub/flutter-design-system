/// Documentation pages for the first two public component entries.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../docs/docs_code.dart';
import '../docs/docs_facts.dart';
import '../docs/docs_layout.dart';
import 'catalog.dart';

class ButtonDocPage extends StatelessWidget {
  const ButtonDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    final ComponentDocEntry entry = componentDoc('button');
    return DocsLayout(
      route: entry.route,
      intro: DocsPageIntro(
        eyebrow: 'COMPONENT · BUTTON',
        title: entry.title,
        description: entry.description,
      ),
      breadcrumbs: const <DsBreadcrumbEntry>[
        DsBreadcrumbEntry.link('Components'),
        DsBreadcrumbEntry.page('Button'),
      ],
      sidebar: _sidebar(entry.route),
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Preview', anchor: 'preview'),
        DocsTocEntry(title: 'Variants', anchor: 'variants'),
        DocsTocEntry(title: 'States', anchor: 'states'),
        DocsTocEntry(title: 'Install', anchor: 'install'),
        DocsTocEntry(title: 'API', anchor: 'api'),
      ],
      previous: const DocsPageLink(title: 'Card', route: '/components/card'),
      next: const DocsPageLink(title: 'Input', route: '/components/input'),
      onNavigate: onNavigate,
      child: _ButtonArticle(entry: entry),
    );
  }
}

class CardDocPage extends StatelessWidget {
  const CardDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    final ComponentDocEntry entry = componentDoc('card');
    return DocsLayout(
      route: entry.route,
      intro: DocsPageIntro(
        eyebrow: 'COMPONENT · CARD',
        title: entry.title,
        description: entry.description,
      ),
      breadcrumbs: const <DsBreadcrumbEntry>[
        DsBreadcrumbEntry.link('Components'),
        DsBreadcrumbEntry.page('Card'),
      ],
      sidebar: _sidebar(entry.route),
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Preview', anchor: 'preview'),
        DocsTocEntry(title: 'Anatomy', anchor: 'anatomy'),
        DocsTocEntry(title: 'Install', anchor: 'install'),
        DocsTocEntry(title: 'API', anchor: 'api'),
      ],
      previous: const DocsPageLink(
        title: 'Button',
        route: '/components/button',
      ),
      next: const DocsPageLink(title: 'Dialog', route: '/components/dialog'),
      onNavigate: onNavigate,
      child: _CardArticle(entry: entry),
    );
  }
}

List<DocsSidebarEntry> _sidebar(String route) => <DocsSidebarEntry>[
  DocsSidebarEntry(
    title: 'Button',
    route: '/components/button',
    selected: route == '/components/button',
  ),
  DocsSidebarEntry(
    title: 'Card',
    route: '/components/card',
    selected: route == '/components/card',
  ),
  const DocsSidebarEntry(title: 'Input', route: '/components/input'),
  const DocsSidebarEntry(title: 'Dialog', route: '/components/dialog'),
  const DocsSidebarEntry(title: 'Select', route: '/components/select'),
];

class _ButtonArticle extends StatelessWidget {
  const _ButtonArticle({required this.entry});

  final ComponentDocEntry entry;

  @override
  Widget build(BuildContext context) => Column(
    key: const ValueKey<String>('button-doc-article'),
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      _Anchor(
        'preview',
        child: DocsCodeExample(
          title: 'Live preview',
          description:
              'A primary action with an accessible label and focusable semantics.',
          preview: Wrap(
            spacing: ds(3),
            runSpacing: ds(3),
            children: <Widget>[
              DsButton(onPressed: () {}, child: const Text('Save changes')),
              DsButton(
                variant: DsButtonVariant.outline,
                onPressed: () {},
                child: const Text('Cancel'),
              ),
              DsButton(
                size: DsButtonSize.icon,
                label: 'Open menu',
                onPressed: () {},
                child: const DsIcon(DsIconGlyph.menu),
              ),
            ],
          ),
          command: DocsCodeCommand(command: entry.command),
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(
              path: 'lib/components/ui/button.dart',
              code:
                  "import 'package:elattar_design_system/elattar_design_system.dart';\n\n// Copy the generated button source here when using manual mode.",
            ),
          ],
        ),
      ),
      SizedBox(height: ds(6)),
      _Anchor(
        'variants',
        child: const DocsApiTable(
          title: 'Variants and sizes',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'variant',
              type: 'DsButtonVariant',
              description:
                  'primary, premium, secondary, outline, ghost, destructive, link.',
            ),
            DocsApiFact(
              name: 'size',
              type: 'DsButtonSize',
              description: 'xs, sm, md, lg, xl, iconXs, iconSm, icon, iconLg.',
            ),
            DocsApiFact(
              name: 'emphasis',
              type: 'DsButtonEmphasis',
              description: 'none or caps for uppercase CTA treatment.',
            ),
          ],
        ),
      ),
      SizedBox(height: ds(6)),
      _Anchor(
        'states',
        child: const DocsStateMatrix(
          facts: <DocsStateFact>[
            DocsStateFact(
              state: 'Disabled',
              treatment: 'Set onPressed to null.',
              userSignal: 'Non-actionable, 45% opacity.',
            ),
            DocsStateFact(
              state: 'Loading',
              treatment: 'Set loading to true.',
              userSignal: 'Spinner prepended and semantics disabled.',
            ),
            DocsStateFact(
              state: 'Focus',
              treatment: 'Use keyboard traversal or focusNode.',
              userSignal: 'Visible token-based focus ring.',
            ),
            DocsStateFact(
              state: 'Pressed',
              treatment: 'Pointer press applies the button scale.',
              userSignal: 'Immediate physical press feedback.',
            ),
          ],
        ),
      ),
      SizedBox(height: ds(6)),
      _Anchor(
        'install',
        child: DocsInstallFacts(
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'CLI',
              value: entry.command,
              description:
                  'Installs the component and its declared motion, icon, spinner, and surface dependencies.',
            ),
            const DocsInstallFact(
              label: 'Manual target',
              value: 'lib/components/ui/button.dart',
              description:
                  'Copy the generated @ui/button.dart payload into components/ui.',
            ),
            DocsInstallFact(
              label: 'Registry dependencies',
              value: entry.dependencies.join(', '),
              description: 'Resolved automatically by the registry client.',
            ),
          ],
        ),
      ),
      SizedBox(height: ds(6)),
      _Anchor(
        'api',
        child: const DocsApiTable(
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'child',
              type: 'Widget',
              description: 'Required button content.',
            ),
            DocsApiFact(
              name: 'onPressed',
              type: 'VoidCallback?',
              description: 'Null disables the control.',
            ),
            DocsApiFact(
              name: 'label',
              type: 'String?',
              description:
                  'Accessible name, especially for icon-only controls.',
            ),
            DocsApiFact(
              name: 'loading',
              type: 'bool',
              description: 'Prepends a spinner and disables interaction.',
            ),
            DocsApiFact(
              name: 'surface',
              type: 'DsButtonSurface?',
              description: 'Optional semantic fill, border, and ink overrides.',
            ),
          ],
        ),
      ),
    ],
  );
}

class _CardArticle extends StatelessWidget {
  const _CardArticle({required this.entry});

  final ComponentDocEntry entry;

  @override
  Widget build(BuildContext context) => Column(
    key: const ValueKey<String>('card-doc-article'),
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      _Anchor(
        'preview',
        child: DocsCodeExample(
          title: 'Live preview',
          description:
              'A structured surface composed from header, content, and footer regions.',
          preview: DsCard(
            children: <Widget>[
              const DsCardHeader(
                title: DsCardTitle('Account'),
                description: DsCardDescription('Manage your account settings.'),
              ),
              const DsCardContent(
                child: Text('Your profile and security settings live here.'),
              ),
              DsCardFooter(
                child: DsButton(
                  onPressed: () {},
                  child: const Text('Save changes'),
                ),
              ),
            ],
          ),
          command: DocsCodeCommand(command: entry.command),
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(
              path: 'lib/components/ui/card.dart',
              code:
                  "import 'package:elattar_design_system/elattar_design_system.dart';\n\n// Copy the generated card source here when using manual mode.",
            ),
          ],
        ),
      ),
      SizedBox(height: ds(6)),
      _Anchor(
        'anatomy',
        child: const DocsApiTable(
          title: 'Anatomy',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'DsCardHeader',
              type: 'Widget',
              description: 'Title, optional description, and optional action.',
            ),
            DocsApiFact(
              name: 'DsCardContent',
              type: 'Widget',
              description: 'Horizontal card spacing around arbitrary content.',
            ),
            DocsApiFact(
              name: 'DsCardFooter',
              type: 'Widget',
              description: 'Muted footer band with a top rule.',
            ),
          ],
        ),
      ),
      SizedBox(height: ds(6)),
      _Anchor(
        'install',
        child: DocsInstallFacts(
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'CLI',
              value: entry.command,
              description:
                  'Installs the card source and foundation dependency.',
            ),
            const DocsInstallFact(
              label: 'Manual target',
              value: 'lib/components/ui/card.dart',
              description:
                  'Copy the generated @ui/card.dart payload into components/ui.',
            ),
            DocsInstallFact(
              label: 'Registry dependencies',
              value: entry.dependencies.join(', '),
              description: 'Resolved automatically by the registry client.',
            ),
          ],
        ),
      ),
      SizedBox(height: ds(6)),
      _Anchor(
        'api',
        child: const DocsApiTable(
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'children',
              type: 'List<Widget>',
              description: 'Ordered card regions.',
            ),
            DocsApiFact(
              name: 'fill',
              type: 'Color?',
              description: 'Optional theme-aware surface override.',
            ),
            DocsApiFact(
              name: 'ringColor',
              type: 'Color?',
              description: 'Optional theme-aware ring override.',
            ),
            DocsApiFact(
              name: 'title / description / action',
              type: 'Widget?',
              description: 'Header composition slots.',
            ),
          ],
        ),
      ),
    ],
  );
}

class _Anchor extends StatelessWidget {
  const _Anchor(this.name, {required this.child});

  final String name;
  final Widget child;

  @override
  // `docs_layout.dart`'s [docsAnchorKey], not a second spelling of the same
  // string: the key this marks the section with is the key the table of
  // contents looks it up by, and the two may not drift.
  Widget build(BuildContext context) =>
      KeyedSubtree(key: docsAnchorKey(name), child: child);
}
