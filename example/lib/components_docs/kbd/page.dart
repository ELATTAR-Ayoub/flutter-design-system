/// Public documentation page for the `kbd` component.
///
/// **Reference shape**, mirrored from shadcn's own
/// `ui.shadcn.com/docs/components/base/kbd`, fetched fresh: Installation,
/// Usage, Composition, Group, Button, Tooltip, Input Group, RTL, API
/// Reference.
///
/// **Skipped, honestly**, one of those nine: **Tooltip**. shadcn's demo
/// composes a `<Kbd>` as arbitrary *content* inside a `<TooltipContent>`.
/// `ElTooltip`'s content slot (`label`) is typed `String`, not `Widget` —
/// unlike the reference's own Tooltip, which takes children — so a real
/// `ElKbd` cannot be rendered inside a `ElTooltip` bubble in this port.
/// `kbd.dart`'s own doc comment already records the adjacent half of this
/// gap: the `in-data-[slot=tooltip-content]:…` recolour rule is "recorded
/// rather than built: … this port has no tooltip for the context selector to
/// match against." What IS buildable — ElKbd composed as the tooltip's own
/// *trigger* child — is a different composition than the reference's demo,
/// so faking a "Tooltip" section around it would misrepresent the gap. The
/// **Button** section below already demonstrates ElKbd riding along inside
/// another interactive control, which is the closest honest cousin.
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

class KbdDocPage extends StatelessWidget {
  const KbdDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: kbdDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: kbdDoc.title,
      description: kbdDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Kbd'),
    ],
    sidebar: _sidebar,
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Installation', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'Composition', anchor: 'composition'),
      DocsTocEntry(title: 'Group', anchor: 'group'),
      DocsTocEntry(title: 'Button', anchor: 'button'),
      DocsTocEntry(title: 'Input group', anchor: 'input-group'),
      DocsTocEntry(title: 'RTL', anchor: 'rtl'),
      DocsTocEntry(title: 'API Reference', anchor: 'api'),
      DocsTocEntry(title: 'States', anchor: 'states'),
      DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
      DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
      DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
      DocsTocEntry(title: 'Theming', anchor: 'theming'),
      DocsTocEntry(title: 'Source', anchor: 'source'),
    ],
    onNavigate: onNavigate,
    child: const _KbdArticle(),
  );
}

const List<DocsSidebarEntry> _sidebar = <DocsSidebarEntry>[
  DocsSidebarEntry(title: 'Accordion', route: '/components/accordion'),
  DocsSidebarEntry(title: 'Alert', route: '/components/alert'),
  DocsSidebarEntry(title: 'Avatar', route: '/components/avatar'),
  DocsSidebarEntry(title: 'Badge', route: '/components/badge'),
  DocsSidebarEntry(title: 'Breadcrumb', route: '/components/breadcrumb'),
  DocsSidebarEntry(title: 'Checkbox', route: '/components/checkbox'),
  DocsSidebarEntry(title: 'Collapsible', route: '/components/collapsible'),
  DocsSidebarEntry(title: 'Empty', route: '/components/empty'),
  DocsSidebarEntry(title: 'Item', route: '/components/item'),
  DocsSidebarEntry(title: 'Kbd', route: '/components/kbd', selected: true),
  DocsSidebarEntry(title: 'Progress', route: '/components/progress'),
  DocsSidebarEntry(title: 'Separator', route: '/components/separator'),
  DocsSidebarEntry(title: 'Skeleton', route: '/components/skeleton'),
  DocsSidebarEntry(title: 'Stat', route: '/components/stat'),
  DocsSidebarEntry(title: 'Switch', route: '/components/switch'),
  DocsSidebarEntry(title: 'Toggle', route: '/components/toggle'),
  DocsSidebarEntry(title: 'Tooltip', route: '/components/tooltip'),
];

class _KbdArticle extends StatelessWidget {
  const _KbdArticle();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      key: const ValueKey<String>('kbd-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _preview(),
        SizedBox(height: el(6)),
        _install(),
        SizedBox(height: el(6)),
        _usage(),
        _composition(),
        _group(),
        _button(),
        _inputGroup(),
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

  Widget _preview() => DocsCodeExample(
    title: 'Kbd',
    description:
        'ElKbd renders a 20px-tall, 20px-minimum-wide key cap: muted fill, '
        '6px corners, 12px/500 label, inert to touch and text selection. '
        'Reach for it when the content is a literal key the reader would '
        'press, Ctrl, K, Esc: never a status word (that is ElBadge) or a '
        'code snippet. ElKbdGroup composes several keys into one shortcut '
        'and merges their semantics into a single announcement.',
    manualFiles: const <DocsCodeFile>[
      DocsCodeFile(
        path: 'lib/components/ui/kbd.dart',
        code:
            "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
            '// Install with: elattar add kbd',
      ),
    ],
    preview: KeyedSubtree(
      key: const ValueKey<String>('kbd-preview'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ElRow(
            children: <Widget>[
              const ElKbdGroup(children: <Widget>[ElKbd('Ctrl'), ElKbd('K')]),
              ElText('Open search', ElType.small),
            ],
          ),
          SizedBox(height: el(4)),
          ElRow(
            children: <Widget>[
              const ElKbd('Esc'),
              ElText('Close this dialog', ElType.small),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _install() => ElSection(
    id: 'install',
    title: 'Installation',
    description:
        '`elattar add kbd` installs the component and its declared '
        'dependency closure.',
    child: DocsInstallFacts(
      title: 'Installation facts',
      facts: <DocsInstallFact>[
        const DocsInstallFact(
          label: 'Registry item',
          value: 'registry/components/kbd.json',
          description: 'Shipped and resolved by `elattar add kbd`.',
        ),
        const DocsInstallFact(
          label: 'Destination',
          value: 'lib/components/ui/kbd.dart',
          description: 'Where a manual copy of the source file belongs.',
        ),
        const DocsInstallFact(
          label: 'Foundation',
          value: 'source only',
          description: 'No package-backed alternative is offered yet.',
        ),
        const DocsInstallFact(
          label: 'Dependencies',
          value: 'source-foundation, machine-surface',
          description:
              'ElKbd needs spacing/theme/typography plus the '
              'machine-surface effect for its fill, though it paints '
              'through it with ElShadows.none (see Theming). Not resolved '
              'automatically today; copy the imports by hand.',
        ),
        const DocsInstallFact(
          label: 'Assets',
          value: 'none',
          description: 'No images, icon fonts, or binary assets.',
        ),
        const DocsInstallFact(
          label: 'Shaders',
          value: 'none',
          description:
              'The machine surface renders ElShadows.none: a flat fill '
              'and border, not a fragment-shader paint.',
        ),
        const DocsInstallFact(
          label: 'Platforms',
          value: 'Android, iOS, Web, macOS, Windows, Linux',
          description: 'No platform-conditional code in kbd.dart.',
        ),
        const DocsInstallFact(
          label: 'Verified',
          value: 'docs specimen only',
          description:
              'This page\'s live preview and '
              'example/test/components_docs/kbd_test.dart. No dedicated '
              'package-level unit test and no registry fixture install '
              'exist yet.',
        ),
      ],
    ),
  );

  Widget _usage() => ElSection(
    id: 'usage',
    title: 'Usage',
    description: 'A single key, then a chord.',
    child: ElPanel(
      label: 'DART',
      note: 'COMPOSE',
      child: DocsSelectableCodeBlock(code: _usageCode),
    ),
  );

  Widget _composition() => ElSection(
    id: 'composition',
    title: 'Composition',
    description:
        'ElKbd has no size or variant axis: ElKbdGroup composes many keys, '
        'it is not a variant of ElKbd.',
    child: DocsCodeExample(
      title: 'The part tree',
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'kbd_tree.txt',
          code: '''ElKbdGroup
├─ ElKbd
└─ ElKbd    (one or more)''',
        ),
      ],
    ),
  );

  Widget _group() => ElSection(
    id: 'group',
    title: 'Group',
    description:
        'ElKbdGroup composes several keys into one shortcut, read by '
        'assistive tech as a single combination rather than unrelated '
        'letters (see Accessibility).',
    child: DocsCodeExample(
      title: 'A two-key shortcut',
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'kbd_group.dart',
          code: '''ElRow(
  children: [
    ElKbdGroup(children: [ElKbd('⌘'), ElKbd('K')]),
    ElText('Open the command palette', ElType.small),
  ],
)''',
        ),
      ],
      preview: KeyedSubtree(
        key: const ValueKey<String>('kbd-example:group'),
        child: ElRow(
          children: <Widget>[
            const ElKbdGroup(children: <Widget>[ElKbd('⌘'), ElKbd('K')]),
            ElText('Open the command palette', ElType.small),
          ],
        ),
      ),
    ),
  );

  Widget _button() => ElSection(
    id: 'button',
    title: 'Button',
    description:
        'A ElKbd composed inside a ElButton\'s own child, so the key cap '
        'rides along with the label as one control.',
    child: DocsCodeExample(
      title: 'A button that names its own shortcut',
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'kbd_button.dart',
          code: '''ElButton(
  onPressed: () {},
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      ElText('Save', ElComponentType.buttonLabel),
      SizedBox(width: el(2)),
      const ElKbd('⌘S'),
    ],
  ),
)''',
        ),
      ],
      preview: KeyedSubtree(
        key: const ValueKey<String>('kbd-example:button'),
        child: ElButton(
          onPressed: () {},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElText('Save', ElComponentType.buttonLabel),
              SizedBox(width: el(2)),
              const ElKbd('⌘S'),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _inputGroup() => ElSection(
    id: 'input-group',
    title: 'Input group',
    description:
        'A ElKbd inside a ElInputGroupAddon, hinting at the shortcut that '
        'focuses the field it sits in.',
    child: DocsCodeExample(
      title: 'A search field that names its own shortcut',
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'kbd_input_group.dart',
          code: '''ElInputGroup(
  endAddon: ElInputGroupAddon(
    align: ElInputGroupAlign.end,
    child: const ElKbd('⌘K'),
  ),
  child: const ElInputGroupInput(placeholder: 'Search...'),
)''',
        ),
      ],
      preview: KeyedSubtree(
        key: const ValueKey<String>('kbd-example:input-group'),
        child: ElInputGroup(
          endAddon: const ElInputGroupAddon(
            align: ElInputGroupAlign.end,
            child: ElKbd('⌘K'),
          ),
          child: const ElInputGroupInput(placeholder: 'Search...'),
        ),
      ),
    ),
  );

  Widget _rtl(ElThemeData theme) => ElSection(
    id: 'rtl',
    title: 'RTL',
    description:
        'ElKbd paints no direction-specific layout of its own: it is a '
        'content-wide box with a fixed floor, and it reads right-to-left '
        'under a plain Directionality.',
    child: ElPanel(
      label: 'PREVIEW',
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: KeyedSubtree(
          key: const ValueKey<String>('rtl-example:kbd'),
          child: ElRow(
            children: <Widget>[
              const ElKbdGroup(children: <Widget>[ElKbd('Ctrl'), ElKbd('K')]),
              ElText('فتح البحث', ElType.small, color: theme.foreground),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _api(ElThemeData theme) => ElSection(
    id: 'api',
    title: 'API Reference',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        KeyedSubtree(
          key: docsAnchorKey('api-elkbd'),
          child: const DocsApiTable(
            title: 'ElKbd',
            facts: <DocsApiFact>[
              DocsApiFact(
                name: 'text',
                type: 'String (positional)',
                description: 'Required. The legend, as authored, "Ctrl", "K".',
              ),
            ],
          ),
        ),
        SizedBox(height: el(4)),
        const DocsApiTable(
          title: 'ElKbd static tokens',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'ElKbd.height',
              type: 'static double',
              description: '20px tall.',
            ),
            DocsApiFact(
              name: 'ElKbd.minWidth',
              type: 'static double',
              description: '20px, the floor a one-character key sits on.',
            ),
            DocsApiFact(
              name: 'ElKbd.paddingX',
              type: 'static double',
              description: '4px horizontal padding.',
            ),
            DocsApiFact(
              name: 'ElKbd.gap',
              type: 'static double',
              description:
                  '4px, exposed for a caller composing an icon beside the '
                  'text; nothing on this page uses it, since no ElKbd call '
                  'site in the corpus holds a glyph.',
            ),
          ],
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elkbdgroup'),
          child: const DocsApiTable(
            title: 'ElKbdGroup',
            facts: <DocsApiFact>[
              DocsApiFact(
                name: 'children',
                type: 'List<Widget>',
                description:
                    'Required. The keys, in order: typically ElKbd '
                    'widgets, merged into a single Semantics node (see '
                    'Accessibility).',
              ),
            ],
          ),
        ),
        SizedBox(height: el(4)),
        const DocsApiTable(
          title: 'ElKbdGroup static tokens',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'ElKbdGroup.gap',
              type: 'static double',
              description: '4px between keys in a group.',
            ),
          ],
        ),
      ],
    ),
  );

  Widget _states() => ElSection(
    id: 'states',
    title: 'States',
    description:
        'ElKbd and ElKbdGroup are static, presentational StatelessWidgets: '
        'neither owns onPressed/enabled, a GestureDetector, a FocusNode, '
        'or an async flag.',
    child: const DocsStateMatrix(
      facts: <DocsStateFact>[
        DocsStateFact(
          state: 'Rest',
          treatment:
              'Paints a flat theme.muted fill with theme.mutedForeground '
              'text, 6px corners.',
          userSignal: 'The resting paint is the only paint.',
        ),
        DocsStateFact(
          state: 'Hover / Focus-visible / Pressed / Selected / Disabled',
          treatment:
              'N/A: neither owns a GestureDetector, FocusNode, or '
              'onPressed/enabled parameter.',
          userSignal:
              'IgnorePointer makes the "not interactive" contract explicit.',
        ),
        DocsStateFact(
          state: 'Reduced motion',
          treatment:
              'N/A: no AnimationController and no motion token appears in '
              'kbd.dart.',
          userSignal: 'Nothing animates, so nothing needs to still.',
        ),
      ],
    ),
  );

  Widget _accessibility(ElThemeData theme) => ElSection(
    id: 'accessibility',
    title: 'Accessibility',
    child: _bullets(theme, <String>[
      'Semantic role: none of its own, ElKbd wraps its text in '
          'IgnorePointer and SelectionContainer.disabled only; no '
          'Semantics override. The legend reaches assistive tech as '
          'ordinary static text.',
      'The gap: nothing marks it as "a key you press." There is no '
          'semanticLabel such as "key: Esc" and no custom Semantics role: '
          'a screen reader reads "Esc" exactly as it would read the word '
          '"Esc" anywhere else on the page, with no signal that it names '
          'a keyboard key rather than being prose.',
      'One deliberate exception: ElKbdGroup wraps its children in '
          'MergeSemantics, so a grouped shortcut *does* fold into a '
          'single announcement instead of two separate stops ("Ctrl K" as '
          'one node, not "Ctrl" then "K"). The source\'s own comment '
          'frames this directly: a nested kbd is "one keyboard object, '
          'not a container of two."',
      'pointer-events-none / select-none, matched exactly: IgnorePointer '
          'keeps it out of hit-testing, and SelectionContainer.disabled '
          'keeps it out of a SelectionArea\'s copy.',
      'Keyboard: never focusable: no Focus widget or FocusNode exists.',
      'Touch target: not applicable: inert to touch by design '
          '(IgnorePointer).',
      'No tooltip integration: kbd.dart\'s own doc comment records a '
          'tooltip-context recolour class as not built, because this port '
          'has no widget-content Tooltip for the context selector to '
          'match against (see the Tooltip note in this page\'s library '
          'doc).',
      'Known platform differences: none: no platform branch in kbd.dart.',
    ]),
  );

  Widget _responsive(ElThemeData theme) => ElSection(
    id: 'responsive',
    title: 'Responsive',
    child: _bullets(theme, <String>[
      'No responsive branching: BuildContext width is never read for a '
          'layout decision; the same widget tree renders at 390px and '
          '1440px.',
      'Fixed 20px-tall, 20px-minimum-wide box with a 20px floor: the '
          'same footprint at 390px and 1440px; only the legend string '
          'changes the width it occupies. ElKbdGroup wraps on a new line '
          'if space is tight.',
      'Platform parity: Android, iOS, Web, macOS, Windows, and Linux all '
          'render the same widget tree.',
    ]),
  );

  Widget _dependencies(ElThemeData theme) => ElSection(
    id: 'dependencies',
    title: 'Dependencies',
    child: _bullets(theme, <String>[
      'File: lib/src/components/kbd.dart, one file, no companions.',
      'Imports: effects/machine_surface.dart (ElMachineSurface), '
          'foundation/shadows.dart (ElShadows.none), '
          'foundation/spacing.dart, foundation/theme.dart, '
          'foundation/typography.dart (ElComponentType.kbdKey), '
          'theme_scope.dart. Depends on the machine-surface effect, '
          'though it paints through it with no elevation.',
      'Assets: none. Fonts: none beyond the system type scale every '
          'ElText call already depends on. Shaders: none.',
    ]),
  );

  Widget _theming(ElThemeData theme) => ElSection(
    id: 'theming',
    title: 'Theming',
    child: _bullets(theme, <String>[
      'The one object in this system that owns an elevation token and '
          'never wears it: ElShadows.key and ElShadows.keyDown exist for '
          'exactly this object (documented one foundations page away, on '
          'Shadows, as a raised key with a side wall that travels into '
          'its socket) but ElKbd\'s ElMachineSurface call passes '
          'ElShadows.none explicitly: no border, no shadow, no press. It '
          'ships flat. The token set is aspirational; the component that '
          'renders is not using it.',
      'Fill (theme.muted) and ink (theme.mutedForeground) are the only '
          'theme-resolved colours it carries: both re-resolve on a live '
          'theme flip.',
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
          value: kbdDoc.sourcePath,
          description:
              'Authoritative implementation: the truth this page was '
              'written from.',
        ),
        const DocsInstallFact(
          label: 'Package tests',
          value: 'none yet',
          description:
              'No dedicated unit test exists for kbd.dart in the package '
              'test suite as of this page.',
        ),
        const DocsInstallFact(
          label: 'Docs test',
          value: 'example/test/components_docs/kbd_test.dart',
          description:
              'Covers this page: the API tables, live specimens, and '
              'both themes.',
        ),
        const DocsInstallFact(
          label: 'Edit these docs',
          value: 'example/lib/components_docs/kbd/page.dart',
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

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

ElKbd('Escape')

ElKbdGroup(
  children: [ElKbd('Ctrl'), ElKbd('K')],
)''';
