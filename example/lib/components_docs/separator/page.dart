/// Public documentation page for the `separator` component alone.
///
/// **Re-housed onto the kit.** This page used to hand-compose `Section`
/// panels (plus a manual `_sidebar` list standing in for the shared
/// `aspect_ratio` / `separator` / neighbour group); it now declares a
/// `ComponentDocSpec` (`example/lib/docs/component_doc_page.dart`) and
/// hands it to `ComponentDocPage`, the shape `button` established. The
/// hand-written `_sidebar` list is dropped along with it: `DocsLayout`
/// already synthesizes its own sidebar from the shared catalog once
/// neither `sidebar` nor `sidebarGroups` is supplied, which is what every
/// migrated page today relies on.
///
/// **Split from a merged page**, unchanged from the original ruling:
/// `separator/page.dart` used to document `separator`, `empty`, and `kbd`
/// together, because each was "too small for a page of its own." `empty`
/// and `kbd` now have real pages of their own
/// (`lib/components_docs/empty/`, `lib/components_docs/kbd/`); this file
/// keeps only what belongs to `Separator`.
///
/// **Reference shape**, mirrored from shadcn's own
/// `ui.shadcn.com/docs/components/base/separator`: Installation, Usage,
/// Vertical, Menu, List, RTL, API Reference. shadcn's page has no
/// Composition section (only `empty`, `kbd`, and `item` do, each with
/// several part-widgets to assemble); `Separator` is a single leaf, so
/// this page carries none either. The reference's own unheaded live demo
/// (Horizontal + Vertical) is now `Preview`, this page's first
/// `ShowcaseSection`, so it finally owns a rail entry — the same promotion
/// `button` and `field` made.
///
/// **A hairline and nothing else.** `Separator` is a single
/// `StatelessWidget` with no gesture handler, no `Focus` node, and no
/// `Semantics` node anywhere in `separator.dart`: States, Accessibility,
/// and Keyboard below each say so in one honest sentence rather than
/// reaching for content that is not there. That is the point of the
/// required-disclosure rule, not a shortfall of it.
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

final ComponentDocSpec separatorDocSpec = ComponentDocSpec(
  name: 'separator',
  title: separatorDoc.title,
  description: separatorDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'Separator renders one 1px hairline in theme.border, on '
          'whichever axis orientation names: the long axis is left unset '
          'so the parent constraint fills it, exactly like the '
          'reference\'s w-full / self-stretch. Reach for it, instead of '
          'plain whitespace, when the boundary itself must stay visible '
          'even on a quick scan.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          '`elattar add separator` installs the component and its '
          'declared dependency closure. No registry/components/'
          'separator.json exists yet: copy lib/src/components/'
          'separator.dart manually until it does.',
      command: separatorDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/separator.dart',
          title: '1. Copy the source',
          description:
              'Copy ${separatorDoc.sourcePath} into components/ui and keep '
              'its relative imports pointed at the same foundation files.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// No registry manifest yet: copy lib/src/components/'
              'separator.dart into your project directly.',
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description: 'The smallest correct call, then the named constructor.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'vertical',
      title: 'Vertical',
      description:
          'The named constructor for the cross-axis rule: a row of short '
          'labels, each divided from the next by Separator.vertical() '
          'inside a fixed-height ancestor. Vertical has no length of its '
          'own either: it self-stretches to whatever height the row '
          'gives it.',
      specimen: _VerticalSpecimen(),
      code: _verticalCode,
      label: 'Vertical specimen view',
    ),
    ShowcaseSection(
      id: 'menu',
      title: 'Menu',
      description:
          'Vertical rules between menu items that each carry their own '
          'one-line description: a top nav or a mega menu\'s own shape.',
      specimen: _MenuSpecimen(),
      code: _menuCode,
      label: 'Menu specimen view',
    ),
    ShowcaseSection(
      id: 'list',
      title: 'List',
      description:
          'Horizontal rules between stacked rows: the default '
          'orientation\'s own shape, dividing a settings list where each '
          'row must read as a discrete unit on a quick scan.',
      specimen: _ListSpecimen(),
      code: _listCode,
      label: 'List specimen view',
    ),
    ShowcaseSection(
      id: 'rtl',
      title: 'RTL',
      description:
          'Separator paints no direction-specific layout of its own: '
          'horizontal is a plain width/height box with no start/end '
          'split, and vertical self-stretches regardless of text '
          'direction. The List shape above, rendered under a '
          'right-to-left Directionality, proves it: the same rows, the '
          'same rule between them.',
      specimen: _RtlSpecimen(),
      code: _rtlCode,
      label: 'RTL specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Separator\'s only constructor parameter, its only enum, and '
          'its one static token.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'Separator', anchor: 'api-elseparator'),
        DocsTocEntry(
          title: 'SeparatorOrientation',
          anchor: 'api-elseparatororientation',
        ),
        DocsTocEntry(
          title: 'Separator static tokens',
          anchor: 'api-elseparator-static',
        ),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Separator is a static, presentational StatelessWidget: no '
          'onPressed/enabled, no GestureDetector, no FocusNode, no async '
          'flag anywhere in its build method.',
      child: _OneSentence(
        'It paints exactly one thing, its resting theme.border fill: '
        'hover, focus, pressed, selected, disabled, loading, and reduced '
        'motion have no code path to produce them here.',
      ),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      child: _OneSentence(
        'build() returns a bare SizedBox wrapping a ColoredBox, no '
        'Semantics widget appears anywhere in separator.dart, so a '
        'divider is hidden from assistive technology by omission rather '
        'than an explicit exclusion — the same outcome Radix reaches by '
        'defaulting a decorative separator to aria-hidden.',
      ),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      child: _OneSentence(
        'Separator is never focusable: no Focus widget, no FocusNode, '
        'and no key handling exist anywhere in separator.dart, because a '
        'decorative hairline has nothing to activate.',
      ),
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
                'Covers this page: the API tables, a live specimen of '
                'every exported class, and the separator specimen\'s '
                'colour actually changing across a live theme flip.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/separator/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

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
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Separator'),
    ],
    toc: separatorDocSpec.toc,
    previous: const DocsPageLink(
      title: 'Progress',
      route: '/components/progress',
    ),
    next: const DocsPageLink(title: 'Skeleton', route: '/components/skeleton'),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('separator-doc-article'),
      child: ComponentDocPage(spec: separatorDocSpec, header: false),
    ),
  );
}

/* ── Disclosure content ─────────────────────────────────────────────────── */

/// One honest sentence, for a disclosure this component has nothing more
/// to say under — the point of the required-disclosure rule, not a
/// shortfall of it. Still wrapped to the reading measure like every other
/// disclosure's prose.
class _OneSentence extends StatelessWidget {
  const _OneSentence(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
    child: StyledText(
      text,
      TextStyles.small,
      color: ThemeScope.of(context).mutedForeground,
    ),
  );
}

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elseparator',
        child: DocsApiTable(
          title: 'Separator',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'orientation',
              type: 'SeparatorOrientation',
              description:
                  'Optional. Defaults to '
                  'SeparatorOrientation.horizontal. '
                  'Separator.vertical() is a named constructor '
                  'equivalent to passing SeparatorOrientation.vertical '
                  'here.',
            ),
          ],
        ),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elseparatororientation',
        child: DocsApiTable(
          title: 'SeparatorOrientation',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'horizontal',
              type: 'the default',
              description:
                  '1px tall, full parent width. Used between stacked '
                  'rows: see List.',
            ),
            DocsApiFact(
              name: 'vertical',
              type: 'Separator.vertical()',
              description:
                  '1px wide, stretches to the parent\'s height (needs a '
                  'bounded-height ancestor, e.g. a fixed-height Row): '
                  'see Vertical and Menu.',
            ),
          ],
        ),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elseparator-static',
        child: DocsApiTable(
          title: 'Separator static tokens',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'Separator.thickness',
              type: 'static double',
              description:
                  'The rule\'s thickness on its short axis, '
                  'BorderWidths.hairline (1px). The long axis is left null '
                  'on purpose so the parent\'s own constraint fills it.',
            ),
          ],
        ),
      ),
    ],
  );
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No responsive branching: BuildContext width is never read for a '
            'layout decision; the same widget tree renders at 390px and '
            '1440px.',
        'No length of its own on the long axis by design: width is null '
            'when horizontal, height is null when vertical, so the rule '
            'always fills whatever the parent gives it; only the 1px '
            'short-axis thickness is fixed.',
        'Platform parity: Android, iOS, Web, macOS, Windows, and Linux '
            'all render the same widget tree: no platform-conditional '
            'code exists in separator.dart.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DocsInstallFacts(
        title: 'Dependencies',
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Files',
            value: separatorDoc.sourcePath,
            description: 'One file: no companion sources.',
          ),
          const DocsInstallFact(
            label: 'Imports',
            value:
                'foundation/spacing.dart (space(), LayoutWidths), '
                'foundation/theme.dart (ThemeTokens), theme_scope.dart '
                '(ThemeScope)',
            description: 'No component or effect dependency.',
          ),
          const DocsInstallFact(
            label: 'registryDependencies',
            value: 'source-foundation',
            description:
                'Resolved automatically by `elattar add separator` — '
                'copied verbatim from the manifest.',
          ),
          const DocsInstallFact(
            label: 'Assets, fonts, shaders',
            value: 'None',
            description:
                'A flat ColoredBox fill: no image, font, or '
                'shader asset of any kind.',
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
                'dedicated package-level unit test and no registry '
                'fixture install exist yet.',
          ),
        ],
      ),
      SizedBox(height: space(2)),
      DocsLinkRow(
        links: <DocsLink>[
          DocsLink(
            label: 'Source Foundation',
            route: '/components/source_foundation',
          ),
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
        'Paints exactly one colour: ThemeScope.of(context).border. Flipping '
            'ThemeController between light and dark re-resolves it '
            'live: nothing is cached (see the Preview specimen, which '
            'the docs test flips in place).',
        'No colour-override parameter of its own: every colour is '
            'theme-derived, never a bare Color argument.',
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

/// One menu item for [_MenuSpecimen]: a label over a one-line muted
/// description, centred in the fixed-height row the vertical rules sit in.
Widget _menuItem(ThemeTokens theme, String label, String description) => Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    StyledText(label, TextStyles.small, color: theme.foreground),
    SizedBox(height: space(1)),
    StyledText(description, TextStyles.caption, color: theme.mutedForeground),
  ],
);

/* ── Showcase specimens ─────────────────────────────────────────────────── */

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        StyledText('Horizontal', TextStyles.section),
        SizedBox(height: space(3)),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: SizedBox(
            width: Containers.md,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                StyledText('Available balance', TextStyles.small),
                SizedBox(height: space(4)),
                KeyedSubtree(
                  key: const ValueKey<String>('separator-preview:horizontal'),
                  child: const Separator(),
                ),
                SizedBox(height: space(4)),
                StyledText('Bonus balance', TextStyles.small),
              ],
            ),
          ),
        ),
        SizedBox(height: space(8)),
        StyledText('Vertical', TextStyles.section),
        SizedBox(height: space(3)),
        SizedBox(
          height: space(6),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                StyledText(
                  '412 packs',
                  TextStyles.numberSm,
                  color: theme.foreground,
                ),
                SizedBox(width: space(4)),
                KeyedSubtree(
                  key: const ValueKey<String>('separator-preview:vertical'),
                  child: const Separator.vertical(),
                ),
                SizedBox(width: space(4)),
                StyledText(
                  '1,284 cards',
                  TextStyles.numberSm,
                  color: theme.foreground,
                ),
                SizedBox(width: space(4)),
                const Separator.vertical(),
                SizedBox(width: space(4)),
                StyledText(
                  '8 sets',
                  TextStyles.numberSm,
                  color: theme.foreground,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

const String _previewCode = '''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text('Available balance'),
    SizedBox(height: 16),
    Separator(),
    SizedBox(height: 16),
    Text('Bonus balance'),
    SizedBox(height: 32),
    SizedBox(
      height: 24,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('412 packs'),
          SizedBox(width: 16),
          Separator.vertical(),
          SizedBox(width: 16),
          Text('1,284 cards'),
          SizedBox(width: 16),
          Separator.vertical(),
          SizedBox(width: 16),
          Text('8 sets'),
        ],
      ),
    ),
  ],
)''';

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

// Horizontal, the default.
Separator()

// The named constructor for the cross-axis rule.
Separator.vertical()''';

class _VerticalSpecimen extends StatelessWidget {
  const _VerticalSpecimen();

  @override
  Widget build(BuildContext context) => SizedBox(
    height: space(5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        StyledText('Blog', TextStyles.small),
        SizedBox(width: space(4)),
        const KeyedSubtree(
          key: ValueKey<String>('separator-example:vertical-1'),
          child: Separator.vertical(),
        ),
        SizedBox(width: space(4)),
        StyledText('Docs', TextStyles.small),
        SizedBox(width: space(4)),
        const KeyedSubtree(
          key: ValueKey<String>('separator-example:vertical-2'),
          child: Separator.vertical(),
        ),
        SizedBox(width: space(4)),
        StyledText('Source', TextStyles.small),
      ],
    ),
  );
}

const String _verticalCode = '''SizedBox(
  height: space(5),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      StyledText('Blog', TextStyles.small),
      SizedBox(width: space(4)),
      const Separator.vertical(),
      SizedBox(width: space(4)),
      StyledText('Docs', TextStyles.small),
      SizedBox(width: space(4)),
      const Separator.vertical(),
      SizedBox(width: space(4)),
      StyledText('Source', TextStyles.small),
    ],
  ),
)''';

class _MenuSpecimen extends StatelessWidget {
  const _MenuSpecimen();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return SizedBox(
      height: space(10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _menuItem(theme, 'Docs', 'Guides and API'),
            SizedBox(width: space(4)),
            const KeyedSubtree(
              key: ValueKey<String>('separator-example:menu-1'),
              child: Separator.vertical(),
            ),
            SizedBox(width: space(4)),
            _menuItem(theme, 'Blog', 'Release notes'),
            SizedBox(width: space(4)),
            const KeyedSubtree(
              key: ValueKey<String>('separator-example:menu-2'),
              child: Separator.vertical(),
            ),
            SizedBox(width: space(4)),
            _menuItem(theme, 'Source', 'Open on GitHub'),
          ],
        ),
      ),
    );
  }
}

const String _menuCode = '''SizedBox(
  height: space(10),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      menuItem('Docs', 'Guides and API'),
      SizedBox(width: space(4)),
      const Separator.vertical(),
      SizedBox(width: space(4)),
      menuItem('Blog', 'Release notes'),
      SizedBox(width: space(4)),
      const Separator.vertical(),
      SizedBox(width: space(4)),
      menuItem('Source', 'Open on GitHub'),
    ],
  ),
)''';

class _ListSpecimen extends StatelessWidget {
  const _ListSpecimen();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: Containers.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          StyledText('Profile', TextStyles.small, color: theme.foreground),
          SizedBox(height: space(3)),
          const KeyedSubtree(
            key: ValueKey<String>('separator-example:list-1'),
            child: Separator(),
          ),
          SizedBox(height: space(3)),
          StyledText('Billing', TextStyles.small, color: theme.foreground),
          SizedBox(height: space(3)),
          const KeyedSubtree(
            key: ValueKey<String>('separator-example:list-2'),
            child: Separator(),
          ),
          SizedBox(height: space(3)),
          StyledText(
            'Notifications',
            TextStyles.small,
            color: theme.foreground,
          ),
        ],
      ),
    );
  }
}

const String _listCode = '''Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    StyledText('Profile', TextStyles.small),
    SizedBox(height: space(3)),
    const Separator(),
    SizedBox(height: space(3)),
    StyledText('Billing', TextStyles.small),
    SizedBox(height: space(3)),
    const Separator(),
    SizedBox(height: space(3)),
    StyledText('Notifications', TextStyles.small),
  ],
)''';

class _RtlSpecimen extends StatelessWidget {
  const _RtlSpecimen();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Containers.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            StyledText(
              'الملف الشخصي',
              TextStyles.small,
              color: theme.foreground,
            ),
            SizedBox(height: space(3)),
            const KeyedSubtree(
              key: ValueKey<String>('rtl-example:separator'),
              child: Separator(),
            ),
            SizedBox(height: space(3)),
            StyledText('الفواتير', TextStyles.small, color: theme.foreground),
          ],
        ),
      ),
    );
  }
}

const String _rtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      StyledText('الملف الشخصي', TextStyles.small),
      SizedBox(height: space(3)),
      const Separator(),
      SizedBox(height: space(3)),
      StyledText('الفواتير', TextStyles.small),
    ],
  ),
)''';
