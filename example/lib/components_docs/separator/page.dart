/// Public documentation page for the `separator` component alone.
///
/// **Split from a merged page.** `separator/page.dart` used to document
/// `separator`, `empty`, and `kbd` together, because each was "too small for
/// a page of its own." `empty` and `kbd` now have real pages of their own
/// (`lib/components_docs/empty/`, `lib/components_docs/kbd/`); this file
/// keeps only what belongs to `ElSeparator`.
///
/// **Reference shape**, mirrored from shadcn's own
/// `ui.shadcn.com/docs/components/base/separator`, fetched fresh: Installation,
/// Usage, Vertical, Menu, List, RTL, API Reference — every one a top-level
/// section, the same flat shape `button/page.dart` established as this
/// corpus's reference. shadcn's page has no Composition section (only
/// `empty`, `kbd`, and `item` do, each with several part-widgets to
/// assemble); `ElSeparator` is a single leaf, so this page carries none
/// either. RTL was not on the old merged page, but `stat/page.dart` proved
/// the honest way to build one for a component with no direction-specific
/// layout of its own: wrap a real specimen in a bare [Directionality]. Done
/// the same way here.
///
/// [ComponentDocEntry.description] is the page's only rendered description;
/// no second hero paragraph renders beneath it.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

class SeparatorDocPage extends StatelessWidget {
  const SeparatorDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: separatorDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: separatorDoc.title,
      description: separatorDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Separator'),
    ],
    sidebar: _sidebar,
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Installation', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'Vertical', anchor: 'vertical'),
      DocsTocEntry(title: 'Menu', anchor: 'menu'),
      DocsTocEntry(title: 'List', anchor: 'list'),
      DocsTocEntry(title: 'RTL', anchor: 'rtl'),
      DocsTocEntry(title: 'API Reference', anchor: 'api'),
      DocsTocEntry(title: 'States', anchor: 'states'),
      DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
      DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
      DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
      DocsTocEntry(title: 'Theming', anchor: 'theming'),
      DocsTocEntry(title: 'Source', anchor: 'source'),
    ],
    previous: const DocsPageLink(
      title: 'Progress',
      route: '/components/progress',
    ),
    next: const DocsPageLink(title: 'Skeleton', route: '/components/skeleton'),
    onNavigate: onNavigate,
    child: const _SeparatorArticle(),
  );
}

/// The Wave 1 "base primitives" group this page belongs to (IA §7.3). Not
/// routes another worker's page is verified as wired: the supervisor
/// aggregates the real sidebar in `catalog.dart` and `site_routes.dart`.
const List<DocsSidebarEntry> _sidebar = <DocsSidebarEntry>[
  DocsSidebarEntry(title: 'Accordion', route: '/components/accordion'),
  DocsSidebarEntry(title: 'Alert', route: '/components/alert'),
  DocsSidebarEntry(title: 'Avatar', route: '/components/avatar'),
  DocsSidebarEntry(title: 'Badge', route: '/components/badge'),
  DocsSidebarEntry(title: 'Breadcrumb', route: '/components/breadcrumb'),
  DocsSidebarEntry(title: 'Checkbox', route: '/components/checkbox'),
  DocsSidebarEntry(title: 'Collapsible', route: '/components/collapsible'),
  DocsSidebarEntry(title: 'Progress', route: '/components/progress'),
  DocsSidebarEntry(
    title: 'Separator',
    route: '/components/separator',
    selected: true,
  ),
  DocsSidebarEntry(title: 'Skeleton', route: '/components/skeleton'),
  DocsSidebarEntry(title: 'Switch', route: '/components/switch'),
  DocsSidebarEntry(title: 'Toggle', route: '/components/toggle'),
  DocsSidebarEntry(title: 'Tooltip', route: '/components/tooltip'),
];

class _SeparatorArticle extends StatelessWidget {
  const _SeparatorArticle();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      key: const ValueKey<String>('separator-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _preview(theme),
        SizedBox(height: el(6)),
        _install(),
        SizedBox(height: el(6)),
        _usage(),
        _vertical(),
        _menu(theme),
        _list(theme),
        _rtl(theme),
        _api(theme),
        _states(),
        _accessibility(theme),
        _responsive(theme),
        _dependencies(theme),
        _theming(theme),
        _source(),
      ],
    );
  }

  /// The unheaded live demo shadcn renders above its first `<h2>`: no
  /// [ElSection], no heading, no TOC entry — [ComponentDocEntry.description]
  /// already carries the one-line summary in [DocsPageIntro].
  Widget _preview(ElThemeData theme) => DocsCodeExample(
    title: 'Separator',
    description:
        'ElSeparator renders one 1px hairline in theme.border, on whichever '
        'axis orientation names: the long axis is left unset so the parent '
        'constraint fills it, exactly like the reference\'s w-full / '
        'self-stretch. Reach for it, instead of plain whitespace, when the '
        'boundary itself must stay visible even on a quick scan.',
    manualFiles: const <DocsCodeFile>[
      DocsCodeFile(
        path: 'lib/components/ui/separator.dart',
        code:
            "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
            '// Install with: elattar add separator',
      ),
    ],
    preview: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ElText('Horizontal', ElType.label),
        SizedBox(height: el(3)),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: SizedBox(
            width: ElContainers.md,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElText('Available balance', ElType.small),
                SizedBox(height: el(4)),
                KeyedSubtree(
                  key: const ValueKey<String>('separator-preview:horizontal'),
                  child: const ElSeparator(),
                ),
                SizedBox(height: el(4)),
                ElText('Bonus balance', ElType.small),
              ],
            ),
          ),
        ),
        SizedBox(height: el(8)),
        ElText('Vertical', ElType.label),
        SizedBox(height: el(3)),
        SizedBox(
          height: el(6),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ElText('412 packs', ElType.numSm),
                SizedBox(width: el(4)),
                KeyedSubtree(
                  key: const ValueKey<String>('separator-preview:vertical'),
                  child: const ElSeparator.vertical(),
                ),
                SizedBox(width: el(4)),
                ElText('1,284 cards', ElType.numSm),
                SizedBox(width: el(4)),
                const ElSeparator.vertical(),
                SizedBox(width: el(4)),
                ElText('8 sets', ElType.numSm),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  Widget _install() => ElSection(
    id: 'install',
    title: 'Installation',
    description:
        '`elattar add separator` installs the component and its declared '
        'dependency closure.',
    child: DocsInstallFacts(
      title: 'Installation facts',
      facts: <DocsInstallFact>[
        const DocsInstallFact(
          label: 'Registry item',
          value: 'registry/components/separator.json',
          description: 'Shipped and resolved by `elattar add separator`.',
        ),
        const DocsInstallFact(
          label: 'Destination',
          value: 'lib/components/ui/separator.dart',
          description: 'Where a manual copy of the source file belongs.',
        ),
        const DocsInstallFact(
          label: 'Foundation',
          value: 'source only',
          description: 'No package-backed alternative is offered yet.',
        ),
        const DocsInstallFact(
          label: 'Dependencies',
          value: 'source-foundation only',
          description:
              'ElSeparator needs only spacing/theme tokens: no component or '
              'effect import.',
        ),
        const DocsInstallFact(
          label: 'Assets',
          value: 'none',
          description: 'No images, icon fonts, or binary assets.',
        ),
        const DocsInstallFact(
          label: 'Shaders',
          value: 'none',
          description: 'A ColoredBox fill, not a fragment-shader paint.',
        ),
        const DocsInstallFact(
          label: 'Platforms',
          value: 'Android, iOS, Web, macOS, Windows, Linux',
          description: 'No platform-conditional code in separator.dart.',
        ),
        const DocsInstallFact(
          label: 'Verified',
          value: 'docs specimen only',
          description:
              'This page\'s live preview and '
              'example/test/components_docs/separator_test.dart. No '
              'dedicated package-level unit test and no registry fixture '
              'install exist yet.',
        ),
      ],
    ),
  );

  Widget _usage() => ElSection(
    id: 'usage',
    title: 'Usage',
    description: 'The smallest correct call, then the named constructor.',
    child: ElPanel(
      label: 'DART',
      note: 'COMPOSE',
      child: DocsSelectableCodeBlock(code: _usageCode),
    ),
  );

  Widget _vertical() => ElSection(
    id: 'vertical',
    title: 'Vertical',
    description:
        'The named constructor for the cross-axis rule: a row of short '
        'labels, each divided from the next by ElSeparator.vertical() '
        'inside a fixed-height ancestor. Vertical has no length of its own '
        'either: it self-stretches to whatever height the row gives it.',
    child: DocsCodeExample(
      title: 'A row divided by vertical rules',
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'separator_vertical.dart',
          code: '''SizedBox(
  height: el(5),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      ElText('Blog', ElType.small),
      SizedBox(width: el(4)),
      const ElSeparator.vertical(),
      SizedBox(width: el(4)),
      ElText('Docs', ElType.small),
      SizedBox(width: el(4)),
      const ElSeparator.vertical(),
      SizedBox(width: el(4)),
      ElText('Source', ElType.small),
    ],
  ),
)''',
        ),
      ],
      preview: SizedBox(
        height: el(5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElText('Blog', ElType.small),
            SizedBox(width: el(4)),
            const KeyedSubtree(
              key: ValueKey<String>('separator-example:vertical-1'),
              child: ElSeparator.vertical(),
            ),
            SizedBox(width: el(4)),
            ElText('Docs', ElType.small),
            SizedBox(width: el(4)),
            const KeyedSubtree(
              key: ValueKey<String>('separator-example:vertical-2'),
              child: ElSeparator.vertical(),
            ),
            SizedBox(width: el(4)),
            ElText('Source', ElType.small),
          ],
        ),
      ),
    ),
  );

  Widget _menu(ElThemeData theme) => ElSection(
    id: 'menu',
    title: 'Menu',
    description:
        'Vertical rules between menu items that each carry their own '
        'one-line description: a top nav or a mega menu\'s own shape.',
    child: DocsCodeExample(
      title: 'Menu items divided by vertical rules',
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'separator_menu.dart',
          code: '''SizedBox(
  height: el(10),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      menuItem('Docs', 'Guides and API'),
      SizedBox(width: el(4)),
      const ElSeparator.vertical(),
      SizedBox(width: el(4)),
      menuItem('Blog', 'Release notes'),
      SizedBox(width: el(4)),
      const ElSeparator.vertical(),
      SizedBox(width: el(4)),
      menuItem('Source', 'Open on GitHub'),
    ],
  ),
)''',
        ),
      ],
      preview: SizedBox(
        height: el(10),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _menuItem(theme, 'Docs', 'Guides and API'),
              SizedBox(width: el(4)),
              const KeyedSubtree(
                key: ValueKey<String>('separator-example:menu-1'),
                child: ElSeparator.vertical(),
              ),
              SizedBox(width: el(4)),
              _menuItem(theme, 'Blog', 'Release notes'),
              SizedBox(width: el(4)),
              const KeyedSubtree(
                key: ValueKey<String>('separator-example:menu-2'),
                child: ElSeparator.vertical(),
              ),
              SizedBox(width: el(4)),
              _menuItem(theme, 'Source', 'Open on GitHub'),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _list(ElThemeData theme) => ElSection(
    id: 'list',
    title: 'List',
    description:
        'Horizontal rules between stacked rows: the default orientation\'s '
        'own shape, dividing a settings list where each row must read as a '
        'discrete unit on a quick scan.',
    child: DocsCodeExample(
      title: 'A stacked list divided by horizontal rules',
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'separator_list.dart',
          code: '''Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    ElText('Profile', ElType.small),
    SizedBox(height: el(3)),
    const ElSeparator(),
    SizedBox(height: el(3)),
    ElText('Billing', ElType.small),
    SizedBox(height: el(3)),
    const ElSeparator(),
    SizedBox(height: el(3)),
    ElText('Notifications', ElType.small),
  ],
)''',
        ),
      ],
      preview: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: ElContainers.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElText('Profile', ElType.small, color: theme.foreground),
            SizedBox(height: el(3)),
            const KeyedSubtree(
              key: ValueKey<String>('separator-example:list-1'),
              child: ElSeparator(),
            ),
            SizedBox(height: el(3)),
            ElText('Billing', ElType.small, color: theme.foreground),
            SizedBox(height: el(3)),
            const KeyedSubtree(
              key: ValueKey<String>('separator-example:list-2'),
              child: ElSeparator(),
            ),
            SizedBox(height: el(3)),
            ElText('Notifications', ElType.small, color: theme.foreground),
          ],
        ),
      ),
    ),
  );

  Widget _rtl(ElThemeData theme) => ElSection(
    id: 'rtl',
    title: 'RTL',
    description:
        'ElSeparator paints no direction-specific layout of its own: '
        'horizontal is a plain width/height box with no start/end split, and '
        'vertical self-stretches regardless of text direction. The List '
        'shape above, rendered under a right-to-left Directionality, proves '
        'it: the same three rows, the same rule between them.',
    child: ElPanel(
      label: 'PREVIEW',
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: ElContainers.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElText('الملف الشخصي', ElType.small, color: theme.foreground),
              SizedBox(height: el(3)),
              const KeyedSubtree(
                key: ValueKey<String>('rtl-example:separator'),
                child: ElSeparator(),
              ),
              SizedBox(height: el(3)),
              ElText('الفواتير', ElType.small, color: theme.foreground),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _api(ElThemeData theme) => ElSection(
    id: 'api',
    title: 'API Reference',
    description:
        'ElSeparator\'s only constructor parameter, its only enum, and its '
        'one static token.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        KeyedSubtree(
          key: docsAnchorKey('api-elseparator'),
          child: const DocsApiTable(
            title: 'ElSeparator',
            facts: <DocsApiFact>[
              DocsApiFact(
                name: 'orientation',
                type: 'ElSeparatorOrientation',
                description:
                    'Optional. Defaults to ElSeparatorOrientation.horizontal. '
                    'ElSeparator.vertical() is a named constructor equivalent '
                    'to passing ElSeparatorOrientation.vertical here.',
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elseparatororientation'),
          child: const DocsApiTable(
            title: 'ElSeparatorOrientation',
            facts: <DocsApiFact>[
              DocsApiFact(
                name: 'horizontal',
                type: 'the default',
                description:
                    '1px tall, full parent width. Used between stacked rows: '
                    'see List.',
              ),
              DocsApiFact(
                name: 'vertical',
                type: 'ElSeparator.vertical()',
                description:
                    '1px wide, stretches to the parent\'s height (needs a '
                    'bounded-height ancestor, e.g. a fixed-height Row): see '
                    'Vertical and Menu.',
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elseparator-static'),
          child: const DocsApiTable(
            title: 'ElSeparator static tokens',
            facts: <DocsApiFact>[
              DocsApiFact(
                name: 'ElSeparator.thickness',
                type: 'static double',
                description:
                    'The rule\'s thickness on its short axis, '
                    'ElWidths.hairline (1px). The long axis is left null on '
                    'purpose so the parent\'s own constraint fills it.',
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _states() => ElSection(
    id: 'states',
    title: 'States',
    description:
        'ElSeparator is a static, presentational StatelessWidget: no '
        'onPressed/enabled, no GestureDetector, no FocusNode, no async flag '
        'anywhere in its build method.',
    child: const DocsStateMatrix(
      facts: <DocsStateFact>[
        DocsStateFact(
          state: 'Rest',
          treatment: 'Paints its 1px theme.border fill. The only paint it has.',
          userSignal: 'The resting paint is the only paint.',
        ),
        DocsStateFact(
          state: 'Hover / Focus-visible / Pressed / Selected / Disabled',
          treatment:
              'N/A: no GestureDetector, FocusNode, or onPressed/enabled '
              'parameter exists.',
          userSignal: 'Nothing responds to a pointer or keyboard here.',
        ),
        DocsStateFact(
          state: 'Reduced motion',
          treatment:
              'N/A: no AnimationController and no motion token appears in '
              'the build method.',
          userSignal: 'Nothing animates, so nothing needs to still.',
        ),
      ],
    ),
  );

  Widget _accessibility(ElThemeData theme) => ElSection(
    id: 'accessibility',
    title: 'Accessibility',
    child: _bullets(theme, <String>[
      'Semantic role: none: build() returns a bare SizedBox wrapping a '
          'ColoredBox; no Semantics widget appears anywhere in '
          'separator.dart.',
      'Hidden from assistive tech, but by omission rather than a guard: '
          'the source\'s own doc comment says the port "hides both" '
          '(decorative and orientation) because "a Semantics divider node '
          'carries no information a Flutter reader can use": but the '
          'implementation reaches that outcome by simply never creating a '
          'semantics node, not via an explicit '
          'Semantics(excludeSemantics: true) or ExcludeSemantics wrapper. '
          'That hides it today (a bare SizedBox/ColoredBox produces no '
          'semantics node on its own), but there is no defensive marker '
          'keeping it hidden if an ancestor ever wraps it in a '
          'Semantics(container: true): a real, currently harmless gap, '
          'reported rather than silently fixed.',
      'Keyboard: never focusable: no Focus widget or FocusNode exists.',
      'Touch target: not applicable: a rule is not interactive and makes '
          'no target-size guarantee.',
      'Non-colour signal: none needed: it is decorative geometry, not a '
          'status signal.',
      'Known platform differences: none: no platform branch in '
          'separator.dart.',
    ]),
  );

  Widget _responsive(ElThemeData theme) => ElSection(
    id: 'responsive',
    title: 'Responsive',
    child: _bullets(theme, <String>[
      'No responsive branching: BuildContext width is never read for a '
          'layout decision; the same widget tree renders at 390px and '
          '1440px.',
      'No length of its own on the long axis by design: width is null '
          'when horizontal, height is null when vertical, so the rule '
          'always fills whatever the parent gives it; only the 1px '
          'short-axis thickness is fixed.',
      'Platform parity: Android, iOS, Web, macOS, Windows, and Linux all '
          'render the same widget tree: no platform-conditional code '
          'exists in separator.dart.',
    ]),
  );

  Widget _dependencies(ElThemeData theme) => ElSection(
    id: 'dependencies',
    title: 'Dependencies',
    child: _bullets(theme, <String>[
      'Files: one, lib/src/components/separator.dart, no companions.',
      'Imports: foundation/spacing.dart (el(), ElWidths), '
          'foundation/theme.dart (ElThemeData), theme_scope.dart '
          '(ElTheme). No component or effect dependency.',
      'Assets: none. Fonts: none. Shaders: none: a flat ColoredBox fill.',
    ]),
  );

  Widget _theming(ElThemeData theme) => ElSection(
    id: 'theming',
    title: 'Theming',
    child: _bullets(theme, <String>[
      'Paints exactly one colour: ElTheme.of(context).border. Flipping '
          'ElThemeController between light and dark re-resolves it live: '
          'nothing is cached (see the Preview specimen, which the docs '
          'test flips in place).',
      'No colour-override parameter of its own: every colour is '
          'theme-derived, never a bare Color argument.',
    ]),
  );

  Widget _source() => ElSection(
    id: 'source',
    title: 'Source',
    child: DocsInstallFacts(
      title: 'Reference',
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'Source',
          value: separatorDoc.sourcePath,
          description:
              'Authoritative implementation: the truth this page was '
              'written from.',
        ),
        const DocsInstallFact(
          label: 'Package tests',
          value: 'none yet',
          description:
              'No dedicated unit test exists for separator.dart in the '
              'package test suite as of this page.',
        ),
        const DocsInstallFact(
          label: 'Docs test',
          value: 'example/test/components_docs/separator_test.dart',
          description:
              'Covers this page: the API tables, a live specimen of every '
              'exported class, and the separator specimen\'s colour '
              'actually changing across a live theme flip.',
        ),
        const DocsInstallFact(
          label: 'Edit these docs',
          value: 'example/lib/components_docs/separator/page.dart',
          description: 'This file.',
        ),
      ],
    ),
  );
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

/// One menu item for [_SeparatorArticle._menu]: a label over a one-line
/// muted description, centred in the fixed-height row the vertical rules
/// sit in.
Widget _menuItem(ElThemeData theme, String label, String description) => Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    ElText(label, ElType.small, color: theme.foreground),
    SizedBox(height: el(1)),
    ElText(description, ElType.caption, color: theme.mutedForeground),
  ],
);

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

// Horizontal, the default.
ElSeparator()

// The named constructor for the cross-axis rule.
ElSeparator.vertical()''';
