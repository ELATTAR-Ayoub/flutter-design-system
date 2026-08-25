/// Public documentation page for the `kbd` component.
///
/// **Re-housed onto the kit.** This page used to hand-compose [ElSection]
/// panels; it now declares a [ComponentDocSpec]
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// [ComponentDocPage], the same shape `button`, `field`, `popover`, and
/// `hover_card` established. Every specimen widget and every code string
/// below is the one the hand-composed page carried; the unheaded live demo
/// above Installation is now the page's own `Preview` `ShowcaseSection`, so
/// it finally owns a rail entry, and a dedicated Keyboard disclosure is
/// split out of the combined Accessibility section's own "Keyboard" bullet.
///
/// **Corrected, not carried across.** The hand-composed page's own doc
/// comment and Installation section both said "`kbd` has no
/// `registry/components/kbd.json` yet" and that its dependencies were "not
/// resolved automatically today; copy the imports by hand." Both were
/// false the whole time this page existed: `registry/components/kbd.json`
/// is a real manifest — `files`, `registryDependencies:
/// [machine-surface, source-foundation]`, a `documentationRoute` — and
/// `elattar add kbd` installs from it and resolves that dependency closure
/// today. Installation below says so.
///
/// **Reference shape**, unchanged from before, mirrored from shadcn's own
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

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import '../../kit.dart' show ElRow;
import 'meta.dart';

/// The declaration: every section this page shows, in TOC order. `final`,
/// not `const`: `InstallSection.command` reads `kbdDoc.command`, a computed
/// getter, which is not a constant expression.
final ComponentDocSpec kbdDocSpec = ComponentDocSpec(
  name: 'kbd',
  title: kbdDoc.title,
  description: kbdDoc.description,
  sections: <DocsPageSection>[
    const ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'ElKbd renders a 20px-tall, 20px-minimum-wide key cap: muted '
          'fill, 6px corners, 12px/500 label, inert to touch and text '
          'selection. Reach for it when the content is a literal key the '
          'reader would press, Ctrl, K, Esc: never a status word (that is '
          'ElBadge) or a code snippet. ElKbdGroup composes several keys '
          'into one shortcut and merges their semantics into a single '
          'announcement.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Kbd specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'kbd has a real registry manifest, `elattar add kbd` installs '
          'lib/src/components/kbd.dart and resolves machine-surface and '
          'source-foundation automatically. The Manual tab is for a '
          'project not using the CLI.',
      command: kbdDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/kbd.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/kbd.dart's generated @ui/kbd.dart "
              'payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated kbd source here when using manual '
              'mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ElKbd and ElKbdGroup are reachable '
              'the same way the CLI path already makes them.',
          code: "export 'kbd.dart';",
        ),
      ],
    ),
    const SnippetSection(
      id: 'usage',
      title: 'Usage',
      description: 'A single key, then a chord.',
      code: _usageCode,
    ),
    const SnippetSection(
      id: 'composition',
      title: 'Composition',
      description:
          'ElKbd has no size or variant axis: ElKbdGroup composes many '
          'keys, it is not a variant of ElKbd. A part tree, not a runnable '
          'snippet: there is nothing to stage live beyond the Preview '
          'specimen above.',
      code: _compositionTreeCode,
    ),
    ShowcaseSection(
      id: 'group',
      title: 'Group',
      description:
          'ElKbdGroup composes several keys into one shortcut, read by '
          'assistive tech as a single combination rather than unrelated '
          'letters (see Accessibility).',
      specimen: const _GroupSpecimen(),
      code: _groupCode,
      label: 'Group specimen view',
    ),
    ShowcaseSection(
      id: 'button',
      title: 'Button',
      description:
          "A ElKbd composed inside a ElButton's own child, so the key cap "
          'rides along with the label as one control.',
      specimen: const _ButtonSpecimen(),
      code: _buttonCode,
      label: 'Button specimen view',
    ),
    ShowcaseSection(
      id: 'input-group',
      title: 'Input group',
      description:
          'A ElKbd inside a ElInputGroupAddon, hinting at the shortcut '
          'that focuses the field it sits in.',
      specimen: const _InputGroupSpecimen(),
      code: _inputGroupCode,
      label: 'Input group specimen view',
    ),
    ShowcaseSection(
      id: 'rtl',
      title: 'RTL',
      description:
          'ElKbd paints no direction-specific layout of its own: it is a '
          'content-wide box with a fixed floor, and it reads '
          'right-to-left under a plain Directionality.',
      specimen: const _RtlSpecimen(),
      code: _rtlCode,
      label: 'RTL specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'ElKbd', anchor: 'api-elkbd'),
        DocsTocEntry(title: 'ElKbdGroup', anchor: 'api-elkbdgroup'),
      ],
      child: const _ApiReferenceContent(),
    ),
    const DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'ElKbd and ElKbdGroup are static, presentational '
          'StatelessWidgets: neither owns onPressed/enabled, a '
          'GestureDetector, a FocusNode, or an async flag.',
      child: DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(id: 'accessibility', title: 'Accessibility', child: const _AccessibilityContent()),
    DisclosureSection(id: 'keyboard', title: 'Keyboard', child: const _KeyboardContent()),
    DisclosureSection(id: 'responsive', title: 'Responsive', child: const _ResponsiveContent()),
    DisclosureSection(id: 'dependencies', title: 'Dependencies', child: const _DependenciesContent()),
    DisclosureSection(id: 'theming', title: 'Theming', child: const _ThemingContent()),
    DisclosureSection(
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
                'No dedicated unit test exists for kbd.dart in the '
                'package test suite as of this page.',
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
    ),
  ],
);

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
    toc: kbdDocSpec.toc,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('kbd-doc-article'),
      child: ComponentDocPage(spec: kbdDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
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
  );
}

class _GroupSpecimen extends StatelessWidget {
  const _GroupSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('kbd-example:group'),
    child: ElRow(
      children: <Widget>[
        const ElKbdGroup(children: <Widget>[ElKbd('⌘'), ElKbd('K')]),
        ElText('Open the command palette', ElType.small),
      ],
    ),
  );
}

class _ButtonSpecimen extends StatelessWidget {
  const _ButtonSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
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
  );
}

class _InputGroupSpecimen extends StatelessWidget {
  const _InputGroupSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('kbd-example:input-group'),
    child: ElInputGroup(
      endAddon: const ElInputGroupAddon(
        align: ElInputGroupAlign.end,
        child: ElKbd('⌘K'),
      ),
      child: const ElInputGroupInput(placeholder: 'Search...'),
    ),
  );
}

class _RtlSpecimen extends StatelessWidget {
  const _RtlSpecimen();

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: KeyedSubtree(
      key: const ValueKey<String>('rtl-example:kbd'),
      child: ElRow(
        children: <Widget>[
          const ElKbdGroup(children: <Widget>[ElKbd('Ctrl'), ElKbd('K')]),
          ElText(
            'فتح البحث',
            ElType.small,
            color: ElTheme.of(context).foreground,
          ),
        ],
      ),
    ),
  );
}

const String _previewCode = '''ElRow(
  children: [
    ElKbdGroup(children: [ElKbd('Ctrl'), ElKbd('K')]),
    ElText('Open search', ElType.small),
  ],
)

ElRow(
  children: [
    ElKbd('Esc'),
    ElText('Close this dialog', ElType.small),
  ],
)''';

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

ElKbd('Escape')

ElKbdGroup(
  children: [ElKbd('Ctrl'), ElKbd('K')],
)''';

const String _compositionTreeCode = '''ElKbdGroup
├─ ElKbd
└─ ElKbd    (one or more)''';

const String _groupCode = '''ElRow(
  children: [
    ElKbdGroup(children: [ElKbd('⌘'), ElKbd('K')]),
    ElText('Open the command palette', ElType.small),
  ],
)''';

const String _buttonCode = '''ElButton(
  onPressed: () {},
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      ElText('Save', ElComponentType.buttonLabel),
      SizedBox(width: el(2)),
      const ElKbd('⌘S'),
    ],
  ),
)''';

const String _inputGroupCode = '''ElInputGroup(
  endAddon: ElInputGroupAddon(
    align: ElInputGroupAlign.end,
    child: const ElKbd('⌘K'),
  ),
  child: const ElInputGroupInput(placeholder: 'Search...'),
)''';

const String _rtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: ElRow(
    children: [
      ElKbdGroup(children: [ElKbd('Ctrl'), ElKbd('K')]),
      ElText('فتح البحث', ElType.small),
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
        id: 'api-elkbd',
        child: DocsApiTable(
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
      const DocsAnchor(
        id: 'api-elkbdgroup',
        child: DocsApiTable(
          title: 'ElKbdGroup',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'children',
              type: 'List<Widget>',
              description:
                  'Required. The keys, in order: typically ElKbd widgets, '
                  'merged into a single Semantics node (see '
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
  );
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
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
        'Touch target: not applicable: inert to touch by design '
            '(IgnorePointer).',
        'No tooltip integration: kbd.dart\'s own doc comment records a '
            'tooltip-context recolour class as not built, because this port '
            'has no widget-content Tooltip for the context selector to '
            'match against (see the Tooltip note in this page\'s library '
            'doc).',
        'Known platform differences: none: no platform branch in kbd.dart.',
      ]);
}

/// Split out of Accessibility's own "Keyboard" bullet. Read straight off
/// `kbd.dart`: neither `ElKbd` nor `ElKbdGroup` wires a `Focus` widget or a
/// `FocusNode` anywhere in the file.
class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Never focusable: no Focus widget or FocusNode exists on either '
            'ElKbd or ElKbdGroup, so neither ever appears in Tab order and '
            'neither can carry a focus ring.',
        'No key events: with nothing to focus, there is nothing here to '
            'wire an onKeyEvent handler to either. A ElKbd rendering '
            '"Ctrl" is inert static content, not a control that responds '
            'to the key it names.',
        'Composed inside an interactive control (see Button and Input '
            'group above), the surrounding widget owns all keyboard '
            'behaviour; the key cap itself contributes only its paint.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No responsive branching: BuildContext width is never read for a '
            'layout decision; the same widget tree renders at 390px and '
            '1440px.',
        'Fixed 20px-tall, 20px-minimum-wide box with a 20px floor: the '
            'same footprint at 390px and 1440px; only the legend string '
            'changes the width it occupies. ElKbdGroup wraps on a new line '
            'if space is tight.',
        'Platform parity: Android, iOS, Web, macOS, Windows, and Linux all '
            'render the same widget tree.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'File: lib/src/components/kbd.dart, one file, no companions; the '
            'registry manifest lists exactly one entry under "files".',
        'Imports: effects/machine_surface.dart (ElMachineSurface), '
            'foundation/shadows.dart (ElShadows.none), '
            'foundation/spacing.dart, foundation/theme.dart, '
            'foundation/typography.dart (ElComponentType.kbdKey), '
            'theme_scope.dart.',
        'registryDependencies, resolved automatically by `elattar add '
            'kbd`: machine-surface, source-foundation: copied verbatim '
            'from registry/components/kbd.json.',
        'Assets: none. Fonts: none beyond the system type scale every '
            'ElText call already depends on. Shaders: none: the machine '
            'surface renders ElShadows.none, a flat fill and border, not a '
            'fragment-shader paint.',
      ]);
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
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
    state: 'Rest',
    treatment:
        'Paints a flat theme.muted fill with theme.mutedForeground text, '
        '6px corners.',
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
];
