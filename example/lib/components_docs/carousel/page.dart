/// Public documentation page for the `carousel`, `nav_user`, and `marker` components.
///
/// Mirrors `badge/page.dart`'s use of the Phase C docs primitives and
/// `DsSection` for titled, anchor-registered content blocks.
///
/// None of the three has a registry manifest yet — every install-facing
/// panel below says so honestly rather than presenting a CLI command that
/// would fail.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

class CarouselDocPage extends StatelessWidget {
  const CarouselDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: carouselDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / LAYOUT & UI',
      title: carouselDoc.title,
      description: carouselDoc.description,
    ),
    breadcrumbs: const <DsBreadcrumbEntry>[
      DsBreadcrumbEntry.link('Components'),
      DsBreadcrumbEntry.page('Carousel, Nav User, Marker'),
    ],
    sidebar: _sidebar,
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Overview', anchor: 'overview'),
      DocsTocEntry(title: 'Preview', anchor: 'preview'),
      DocsTocEntry(title: 'Install', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'API', anchor: 'api'),
      DocsTocEntry(title: 'Variants', anchor: 'variants'),
      DocsTocEntry(title: 'States', anchor: 'states'),
      DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
      DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
      DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
      DocsTocEntry(title: 'Composition', anchor: 'composition'),
      DocsTocEntry(title: 'Theming', anchor: 'theming'),
      DocsTocEntry(title: 'Source', anchor: 'source'),
    ],
    previous: const DocsPageLink(title: 'Avatar', route: '/components/avatar'),
    next: const DocsPageLink(title: 'Badge', route: '/components/badge'),
    onNavigate: onNavigate,
    child: const _ArticleContent(),
  );
}

const List<DocsSidebarEntry> _sidebar = <DocsSidebarEntry>[
  DocsSidebarEntry(title: 'Carousel', route: '/components/carousel'),
  DocsSidebarEntry(title: 'Nav User', route: '/components/nav-user'),
  DocsSidebarEntry(title: 'Marker', route: '/components/marker'),
];

class _ArticleContent extends StatelessWidget {
  const _ArticleContent();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      key: const ValueKey<String>('carousel-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _overview(theme),
        _preview(),
        _install(),
        _usage(),
        _api(),
        _variants(),
        _states(),
        _accessibility(theme),
        _responsive(theme),
        _dependencies(theme),
        _composition(),
        _theming(theme),
        _source(),
      ],
    );
  }

  Widget _overview(DsThemeData theme) => DsSection(
    id: 'overview',
    title: 'Overview',
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: DsWidths.prose),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText(
            'Three components for layout and navigation: DsCarousel renders a '
            'horizontally scrollable container with Embla physics, previous/next '
            'buttons, and keyboard arrow navigation. DsNavUser is the account '
            'footer block a sidebar is incomplete without — avatar, name, email, '
            'and a dropdown menu. DsMarker is a quiet row separator for lists, '
            'labeling transitions like "Today", "Context cleared", or "3 messages '
            'hidden".',
            DsType.body,
          ),
          SizedBox(height: ds(4)),
          DsText(
            'Status: stable primitives, not yet registered in the CLI (see '
            'Install). Platforms: Android, iOS, Web, macOS, Windows, Linux — '
            'the same six every widget in this package targets.',
            DsType.small,
            color: theme.mutedForeground,
          ),
        ],
      ),
    ),
  );

  Widget _preview() => DsSection(
    id: 'preview',
    title: 'Preview',
    description: 'Live specimens of each component in their default state.',
    child: DocsCodeExample(
      title: 'Component specimens',
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/carousel.dart',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Carousel, nav_user, and marker have no registry manifest yet\n'
              '// — copy from the package source directly.',
        ),
      ],
      preview: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText('Carousel with 5 slides', DsType.label),
          SizedBox(height: ds(3)),
          _CarouselPreview(),
          SizedBox(height: ds(6)),
          DsText('Nav User in sidebar context', DsType.label),
          SizedBox(height: ds(3)),
          _NavUserPreview(),
          SizedBox(height: ds(6)),
          DsText('Marker variants', DsType.label),
          SizedBox(height: ds(3)),
          _MarkerVariantsPreview(),
        ],
      ),
    ),
  );

  Widget _install() => DsSection(
    id: 'install',
    title: 'Installation',
    description:
        'None of these components has a registry manifest yet, so '
        '`elattar add carousel` is not available — install by copying source files manually.',
    child: DocsInstallFacts(
      title: 'Installation facts',
      facts: <DocsInstallFact>[
        const DocsInstallFact(
          label: 'Registry items',
          value: 'not yet registered',
          description:
              'No registry/components/carousel.json, nav_user.json, or '
              'marker.json exist. These are source-only components today.',
        ),
        const DocsInstallFact(
          label: 'Destinations',
          value: 'lib/components/ui/{carousel,nav_user,marker}.dart',
          description: 'Where manual copies of the source belong.',
        ),
        const DocsInstallFact(
          label: 'Foundation',
          value: 'source only',
          description: 'No package-backed alternative is offered yet.',
        ),
        const DocsInstallFact(
          label: 'Dependencies',
          value: 'source-foundation, button, icon, avatar, dropdown_menu',
          description:
              'What a future manifest would need to resolve — colors, '
              'shadows, spacing, theme, typography, button, icon, and '
              'other UI components. None of this is resolved automatically '
              'today; copy the imports by hand.',
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
              'All effects are widget-based or CSS-derived, not shaders.',
        ),
        DocsInstallFact(
          label: 'Platforms',
          value: 'Android, iOS, Web, macOS, Windows, Linux',
          description: 'No platform-conditional code in any of the three.',
        ),
        const DocsInstallFact(
          label: 'Verified',
          value: 'docs specimen only',
          description:
              'This page\'s live preview and example/test/components_docs/'
              'carousel_test.dart. No dedicated package-level unit test exists yet.',
        ),
      ],
    ),
  );

  Widget _usage() => DsSection(
    id: 'usage',
    title: 'Usage',
    description: 'The smallest correct call for each component.',
    child: DsPanel(
      label: 'DART',
      note: 'COMPOSE',
      child: DocsSelectableCodeBlock(code: _usageCode),
    ),
  );

  Widget _api() => DsSection(
    id: 'api',
    title: 'API',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsApiTable(
          title: 'DsCarousel properties',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'basis',
              type: 'double',
              description:
                  'Required. The item\'s share of the track as a '
                  'fraction — 0.5 for 2 columns, 0.333 for 3.',
            ),
            DocsApiFact(
              name: 'items',
              type: 'List<Widget>',
              description:
                  'Required. The carousel slides, each wrapped automatically.',
            ),
            DocsApiFact(
              name: 'padding',
              type: 'EdgeInsets',
              description:
                  'The frame padding the carousel applies for itself. '
                  'Pass the panel\'s padding and set panel flush: true.',
            ),
            DocsApiFact(
              name: 'previousLabel',
              type: 'String',
              description:
                  'Accessibility label for the previous button. Defaults to '
                  '"Previous slide".',
            ),
            DocsApiFact(
              name: 'nextLabel',
              type: 'String',
              description:
                  'Accessibility label for the next button. Defaults to '
                  '"Next slide".',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsCarouselController',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'selectedIndex',
              type: 'int (read-only)',
              description: 'The current slide index.',
            ),
            DocsApiFact(
              name: 'canScrollPrev',
              type: 'bool (read-only)',
              description:
                  'Whether the previous button should be enabled. False at '
                  'index 0.',
            ),
            DocsApiFact(
              name: 'canScrollNext',
              type: 'bool (read-only)',
              description:
                  'Whether the next button should be enabled. False at the '
                  'last snap.',
            ),
            DocsApiFact(
              name: 'snaps',
              type: 'List<double> (read-only)',
              description:
                  'Every snap point the carousel can rest at (trimmed).',
            ),
            DocsApiFact(
              name: 'scrollTo(int)',
              type: 'void',
              description: 'Scroll to a specific index.',
            ),
            DocsApiFact(
              name: 'scrollPrev()',
              type: 'void',
              description: 'Scroll to the previous slide.',
            ),
            DocsApiFact(
              name: 'scrollNext()',
              type: 'void',
              description: 'Scroll to the next slide.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsNavUser properties',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'user',
              type: 'DsNavUserAccount',
              description:
                  'Required. The account details — name, email, optional avatar image.',
            ),
            DocsApiFact(
              name: 'items',
              type: 'List<DsNavUserItem>',
              description:
                  'Required. Menu items shown in the dropdown, split into '
                  'normal and destructive sections.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsNavUserAccount properties',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'name',
              type: 'String',
              description: 'The user\'s display name.',
            ),
            DocsApiFact(
              name: 'email',
              type: 'String',
              description: 'The user\'s email address.',
            ),
            DocsApiFact(
              name: 'avatar',
              type: 'ImageProvider<Object>?',
              description:
                  'Optional avatar image. Falls back to initials if omitted.',
            ),
            DocsApiFact(
              name: 'initials',
              type: 'String (read-only)',
              description:
                  'First letter of each of the first two words in the name, '
                  'uppercased.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsMarker properties',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'label',
              type: 'String',
              description: 'Required. The separator label text.',
            ),
            DocsApiFact(
              name: 'variant',
              type: 'DsMarkerVariant',
              description:
                  'Defaults to normal. Controls the visual treatment — bare, '
                  'separator (with rules), or border.',
            ),
            DocsApiFact(
              name: 'icon',
              type: 'Widget?',
              description: 'Optional leading icon (forced to 16px square).',
            ),
          ],
        ),
      ],
    ),
  );

  Widget _variants() => DsSection(
    id: 'variants',
    title: 'Variants and configuration',
    description:
        'DsCarousel has no size variants. DsMarker has three variants.',
    child: const DocsApiTable(
      title: 'DsMarkerVariant',
      facts: <DocsApiFact>[
        DocsApiFact(
          name: 'normal',
          type: 'default',
          description:
              'Bare row — for a container that already frames it. No rules '
              'or borders.',
        ),
        DocsApiFact(
          name: 'separator',
          type: 'divider',
          description:
              'Rule — label — rule. Divides before from after, the rules '
              'flex to fill available width.',
        ),
        DocsApiFact(
          name: 'border',
          type: 'border',
          description:
              'Label with a 1px bottom border. Heads what follows, good for '
              'section breaks.',
        ),
      ],
    ),
  );

  Widget _states() => DsSection(
    id: 'states',
    title: 'States and feedback',
    description:
        'DsCarousel animates location changes via an Embla-like integrator. '
        'DsNavUser and DsMarker are static.',
    child: const DocsStateMatrix(
      facts: <DocsStateFact>[
        DocsStateFact(
          state: 'Rest',
          treatment:
              'Carousel rests at a snap point. NavUser shows avatar, name, '
              'email. Marker shows label.',
          userSignal: 'Visual state only.',
        ),
        DocsStateFact(
          state: 'Carousel scrolling',
          treatment:
              'Location animates toward target via an integrator loop. '
              'Previous/next buttons enable/disable based on canScrollPrev/Next.',
          userSignal: 'Smooth motion. Buttons enable/disable.',
        ),
        DocsStateFact(
          state: 'Carousel dragging',
          treatment:
              'Target follows the pointer 1:1. Release snaps to nearest '
              'stop.',
          userSignal: 'Pointer drag. Snap on release.',
        ),
        DocsStateFact(
          state: 'Reduced motion',
          treatment:
              'Carousel lands on target instantly (no integrator animation). '
              'NavUser and Marker unaffected.',
          userSignal: 'No motion, instant jumps.',
        ),
      ],
    ),
  );

  Widget _accessibility(DsThemeData theme) => DsSection(
    id: 'accessibility',
    title: 'Accessibility and keyboard behavior',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DsText('Carousel:', DsType.label),
        SizedBox(height: ds(2)),
        ..._bulletWidgets(theme, <String>[
          'Keyboard: ArrowLeft/ArrowRight navigate prev/next; also handled '
              'via the real button focus paths.',
          'Previous and next controls: Real focusable DsButton widgets with '
              'semantic labels ("Previous slide", "Next slide" by default).',
          'Slide count announcement: Not implemented — no live region or '
              'ARIA attribute announces the current slide index or total count. '
              'The carousel has a generic label ("carousel") only.',
          'Autoplay: No autoplay mechanism exists in the source — there is no '
              'auto-scrolling Timer or animation loop. No pause control needed.',
          'Button state: Previous button disabled at index 0; next button '
              'disabled at the last snap.',
        ]),
        SizedBox(height: ds(4)),
        DsText('Nav User:', DsType.label),
        SizedBox(height: ds(2)),
        ..._bulletWidgets(theme, <String>[
          'The account row carries an accessible name via tooltip (user.name) '
              'and the menu structure. The button is a DsSidebarMenuButton with '
              'size lg.',
          'Dropdown menu contains a menu header repeating the identity, '
              'followed by menu items separated by destructive actions.',
          'The component itself does not announce a semantic role beyond its '
              'menu parent.',
        ]),
        SizedBox(height: ds(4)),
        DsText('Marker:', DsType.label),
        SizedBox(height: ds(2)),
        ..._bulletWidgets(theme, <String>[
          'Static presentational widget — no interaction, focus, or animation.',
          'Rendered as ordinary text, not as a semantic boundary or landmark. '
              'Screenreader reads the label text as prose.',
          'Use in a list or timeline where the label semantically marks a '
              'transition (e.g., "Today", "Messages hidden").',
        ]),
      ],
    ),
  );

  Widget _responsive(DsThemeData theme) => DsSection(
    id: 'responsive',
    title: 'Responsive and platform behavior',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DsText('Carousel:', DsType.label),
        SizedBox(height: ds(2)),
        ..._bulletWidgets(theme, <String>[
          'Basis determines the item width as a fraction of the track. Change '
              'basis between breakpoints to adjust columns (0.5 = 2 col, 0.333 '
              '= 3 col).',
          'Previous/next buttons hang outside the carousel by --reach (12px ds '
              'unit). Arrows clipped by the panel\'s overflow-hidden.',
          'Keyboard and drag work identically on all platforms.',
        ]),
        SizedBox(height: ds(4)),
        DsText('Nav User:', DsType.label),
        SizedBox(height: ds(2)),
        ..._bulletWidgets(theme, <String>[
          'On mobile (inside a DsSidebarScope with isMobile: true), the '
              'dropdown opens below (DsPopoverSide.bottom). On desktop, it opens '
              'to the right.',
          'Responsive inside DsSidebar — works identically on all platforms.',
        ]),
        SizedBox(height: ds(4)),
        DsText('Marker:', DsType.label),
        SizedBox(height: ds(2)),
        ..._bulletWidgets(theme, <String>[
          'No responsive branching — rendered identically at all widths.',
          'In separator variant, the two rules flex to fill available space; '
              'the label stays flexible.',
        ]),
      ],
    ),
  );

  Widget _dependencies(DsThemeData theme) => DsSection(
    id: 'dependencies',
    title: 'Dependencies, files, and assets',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DsText('Files:', DsType.label),
        SizedBox(height: ds(2)),
        ..._bulletWidgets(theme, <String>[
          'lib/src/components/carousel.dart — Carousel, DsCarouselController, '
              '_Track, _Arrow.',
          'lib/src/components/nav_user.dart — DsNavUser, DsNavUserAccount, '
              'DsNavUserItem, _IdentityText.',
          'lib/src/components/marker.dart — DsMarker, DsMarkerVariant.',
        ]),
        SizedBox(height: ds(4)),
        DsText('Foundation imports:', DsType.label),
        SizedBox(height: ds(2)),
        ..._bulletWidgets(theme, <String>[
          'foundation/spacing.dart (ds()).',
          'foundation/theme.dart (DsThemeData, DsTheme).',
          'foundation/typography.dart (DsType, DsComponentType, DsText).',
          'foundation/colors.dart (for theme color access).',
        ]),
        SizedBox(height: ds(4)),
        DsText('Component imports:', DsType.label),
        SizedBox(height: ds(2)),
        ..._bulletWidgets(theme, <String>[
          'Carousel: button.dart, icon.dart, icon_paths.g.dart.',
          'NavUser: avatar.dart, dropdown_menu.dart, menu.dart, popover.dart, '
              'sidebar.dart.',
          'Marker: none beyond foundation.',
        ]),
        SizedBox(height: ds(4)),
        DsText(
          'Assets: none. Fonts: none beyond the system type scale. '
          'Shaders: none.',
          DsType.small,
          color: theme.mutedForeground,
        ),
      ],
    ),
  );

  Widget _composition() => DsSection(
    id: 'composition',
    title: 'Composition examples',
    description:
        'Real shapes these components are composed into elsewhere in this package.',
    child: DocsCodeExample(
      title: 'Composed with other primitives',
      preview: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText('Carousel in a layout panel', DsType.label),
          SizedBox(height: ds(2)),
          DsText(
            'Pass the panel\'s padding and set flush: true so arrows can hang out.',
            DsType.small,
          ),
          SizedBox(height: ds(4)),
          DsPanel(
            label: 'CAROUSEL INSIDE PANEL',
            flush: true,
            child: DsCarousel(
              basis: 0.4,
              padding: EdgeInsets.all(ds(6)),
              items: <Widget>[
                for (int i = 0; i < 5; i++)
                  _DummySlide(label: 'Slide ${i + 1}'),
              ],
            ),
          ),
        ],
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'carousel_in_panel.dart',
          code: '''// Carousel panel composition
DsPanel(
  label: 'Featured',
  flush: true,
  child: DsCarousel(
    basis: 0.4,
    padding: EdgeInsets.all(ds(6)),
    items: <Widget>[
      // slides here
    ],
  ),
)''',
        ),
      ],
    ),
  );

  Widget _theming(DsThemeData theme) => DsSection(
    id: 'theming',
    title: 'Theming notes',
    child: _bullets(theme, <String>[
      'Carousel: Previous/next buttons resolve their colors from DsButton '
          '(outline variant). Flipping DsThemeController updates both.',
      'Nav User: Avatar, name, email colors all theme-resolved. Dropdown menu '
          'inherits theme.',
      'Marker: Label color is theme.mutedForeground. Rules use theme.border. '
          'All re-resolve when theme flips.',
    ]),
  );

  Widget _source() => DsSection(
    id: 'source',
    title: 'Source, tests, and docs',
    child: DocsInstallFacts(
      title: 'Reference',
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'Carousel source',
          value: carouselDoc.sourcePath,
          description: 'Authoritative implementation.',
        ),
        const DocsInstallFact(
          label: 'Nav User source',
          value: 'lib/src/components/nav_user.dart',
          description: 'Authoritative implementation.',
        ),
        const DocsInstallFact(
          label: 'Marker source',
          value: 'lib/src/components/marker.dart',
          description: 'Authoritative implementation.',
        ),
        const DocsInstallFact(
          label: 'Package tests',
          value: 'none yet',
          description: 'No dedicated unit tests in the package suite yet.',
        ),
        const DocsInstallFact(
          label: 'Docs test',
          value: 'example/test/components_docs/carousel_test.dart',
          description:
              'Covers this page: live specimens, API table verification, '
              'and theme switching on real sizes.',
        ),
        const DocsInstallFact(
          label: 'Edit these docs',
          value: 'example/lib/components_docs/carousel/page.dart',
          description: 'This file.',
        ),
      ],
    ),
  );
}

class _CarouselPreview extends StatefulWidget {
  const _CarouselPreview();

  @override
  State<_CarouselPreview> createState() => _CarouselPreviewState();
}

class _CarouselPreviewState extends State<_CarouselPreview>
    with SingleTickerProviderStateMixin {
  late final DsCarouselController _controller = DsCarouselController(
    vsync: this,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.instant = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    return DsCarousel(
      basis: 0.4,
      padding: EdgeInsets.all(ds(6)),
      items: <Widget>[
        for (int i = 0; i < 5; i++) _DummySlide(label: 'Slide ${i + 1}'),
      ],
    );
  }
}

class _DummySlide extends StatelessWidget {
  const _DummySlide({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.secondary,
        borderRadius: BorderRadius.circular(ds(2)),
      ),
      child: Center(child: DsText(label, DsType.body)),
    );
  }
}

class _NavUserPreview extends StatelessWidget {
  const _NavUserPreview();

  @override
  Widget build(BuildContext context) {
    return DsNavUser(
      user: const DsNavUserAccount(
        name: 'Alex Johnson',
        email: 'alex@example.com',
      ),
      items: <DsNavUserItem>[
        DsNavUserItem(label: 'Profile', icon: DsLucide.user),
        DsNavUserItem(label: 'Settings', icon: DsLucide.settings),
        DsNavUserItem(
          label: 'Sign out',
          icon: DsLucide.logOut,
          destructive: true,
        ),
      ],
    );
  }
}

class _MarkerVariantsPreview extends StatelessWidget {
  const _MarkerVariantsPreview();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DsMarker(variant: DsMarkerVariant.normal, label: 'Normal variant'),
        SizedBox(height: ds(4)),
        DsMarker(
          variant: DsMarkerVariant.separator,
          label: 'Separator with rules',
        ),
        SizedBox(height: ds(4)),
        DsMarker(
          variant: DsMarkerVariant.border,
          label: 'Border bottom variant',
        ),
      ],
    );
  }
}

List<Widget> _bulletWidgets(DsThemeData theme, List<String> lines) {
  final List<Widget> widgets = <Widget>[];
  for (final String line in lines) {
    widgets.add(
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: DsWidths.prose),
        child: DsText('•  $line', DsType.small, color: theme.mutedForeground),
      ),
    );
    widgets.add(SizedBox(height: ds(2)));
  }
  return widgets;
}

Widget _bullets(DsThemeData theme, List<String> lines) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: _bulletWidgets(theme, lines),
);

const String _usageCode = '''
// Carousel with 5 slides at 40% width each
DsCarousel(
  basis: 0.4,
  items: <Widget>[
    for (int i = 0; i < 5; i++)
      SomeCard(title: 'Slide \${i + 1}'),
  ],
)

// Nav User in sidebar footer
DsNavUser(
  user: const DsNavUserAccount(
    name: 'Alex Johnson',
    email: 'alex@example.com',
  ),
  items: <DsNavUserItem>[
    DsNavUserItem(label: 'Profile'),
    DsNavUserItem(
      label: 'Sign out',
      destructive: true,
    ),
  ],
)

// Marker separating list sections
DsMarker(
  variant: DsMarkerVariant.separator,
  label: 'Today',
)''';
