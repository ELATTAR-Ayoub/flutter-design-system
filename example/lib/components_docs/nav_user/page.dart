/// Public documentation page for the `nav_user` component.
///
/// **Re-housed onto the kit.** This page used to hand-compose [ElSection]
/// panels; it now declares a [ComponentDocSpec]
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// [ComponentDocPage], the same shape `button`, `popover` and `field`
/// established. Every specimen widget and every code string below is the one
/// the hand-composed page carried. New in this pass: the unheaded live demo
/// at the top of the old page is promoted to a real `ShowcaseSection`,
/// `Preview`, so it finally owns a rail entry; a dedicated Keyboard
/// disclosure is split out of the old Accessibility section's "keyboard
/// traversal" bullet; and Dependencies now links sideways through
/// [DocsLink] to the five sibling pages this component actually composes,
/// rather than naming them in plain text.
///
/// **The stale "no manifest" claim is corrected.** The page this replaces
/// said flatly that no `registry/components/nav_user.json` (nor
/// `nav-user.json`) existed and that the install command it would enable was
/// "deliberately not shown". That is no longer true: `nav-user.json` is a
/// real, shipped manifest today, `registry/generated/latest/registry.json`
/// carries `nav-user`, and `elattar add nav-user` is the genuine command —
/// so Installation below renders it for real, through
/// `InstallSection.command: navUserDoc.command`, never a literal.
///
/// **Split, 2026-08-24.** `ElNavUser`, `ElNavUserAccount`, and
/// `ElNavUserItem` used to be documented inside
/// `components_docs/carousel/page.dart` under a single "Nav user" section.
/// They are their own barrel export and now own this page; nothing about
/// carousel or marker appears here.
///
/// **No shadcn counterpart.** `nav-user` is not in shadcn's documented
/// component set at all, so this page is not shaped to a reference page and
/// its sections are not named after shadcn headings. They are named for what
/// this component actually does, taken from `lib/src/components/nav_user.dart`'s
/// own library note: an account block for a sidebar footer, whose shape is
/// fixed everywhere it appears and which encodes no product meaning.
///
/// **The menu engine is documented elsewhere.** The dropdown is a real
/// `ElDropdownMenu` filled with `ElMenuLabel` / `ElMenuSeparator` /
/// `ElMenuGroup` / `ElMenuItem` rows: the same shared menu engine
/// `components_docs/dropdown_menu/page.dart` documents in depth. This page
/// records the dependency and the arguments `ElNavUser` passes, and does not
/// re-explain the engine.
///
/// [ComponentDocEntry.description] is the page's only rendered description:
/// the short, one-sentence form (nav/search, and this page's own hero
/// paragraph).
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import 'meta.dart';

final ComponentDocSpec navUserDocSpec = ComponentDocSpec(
  name: 'nav-user',
  title: navUserDoc.title,
  description: navUserDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'One row: a 32px avatar, a two-line identity, and a chevron. '
          'Click it and the same identity reappears at the head of the '
          'menu it opens.',
      specimen: const KeyedSubtree(
        key: ValueKey<String>('nav-user-preview'),
        child: _NavUserPreview(),
      ),
      code: _usageCode,
      label: 'Nav User specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'nav-user has a real registry manifest, `elattar add nav-user` '
          'installs lib/src/components/nav_user.dart and resolves all six '
          'registryDependencies automatically. The Manual tab is for a '
          'project not using the CLI.',
      command: navUserDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/nav_user.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/nav_user.dart's generated "
              '@ui/nav_user.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated nav_user source here when using '
              'manual mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ElNavUser and its two supporting '
              'classes are reachable the same way the CLI path already '
              'makes them.',
          code: "export 'nav_user.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct import and construction. Both parameters '
          'are required and neither has a default.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'footer',
      title: 'Sitting in a sidebar footer',
      description:
          'This is the account block a sidebar footer is incomplete '
          'without, and the footer is the place it is built for. ElNavUser '
          'returns a ElSidebarMenu holding one ElSidebarMenuItem, so it '
          'drops straight into ElSidebarFooter beside whatever else lives '
          'down there. The trigger is a ElSidebarMenuButton at size lg, '
          'which is what sets the row height: a 32px avatar inside '
          'vertical padding and a hairline border comes to 50px, measured '
          'on the reference footer at 1440 by 900. The identity column '
          'truncates rather than wrapping, so a long name or a long '
          'address shortens instead of growing the row.',
      specimen: const KeyedSubtree(
        key: ValueKey<String>('nav-user-example:footer'),
        child: _FooterSpecimen(),
      ),
      code: _footerCode,
      label: 'Sidebar footer specimen view',
    ),
    ShowcaseSection(
      id: 'account',
      title: 'Naming the account',
      description:
          'ElNavUserAccount carries the name and the email address, and an '
          'optional avatar image. When there is no image, or when one '
          'fails to load, the avatar falls back to initials: the first '
          'letter of each of the first two words of the name, uppercased. '
          'That is what the specimen below shows, since it passes no '
          'image.',
      specimen: const KeyedSubtree(
        key: ValueKey<String>('nav-user-example:initials'),
        child: _NavUserPreview(name: 'Marguerite Okonkwo Adeyemi'),
      ),
      code: _accountCode,
      label: 'Initials fallback specimen view',
    ),
    SnippetSection(
      id: 'menu',
      title: 'Filling the menu',
      description:
          'items has no default, on purpose: a default list would put '
          'invented product actions into a chassis meant to travel into '
          'the next project. Every row is the caller\'s own. The list is '
          'partitioned, not reordered arbitrarily: items where destructive '
          'is false come first as one ElMenuGroup, then a separator, then '
          'the destructive ones; interleaving them in the source list will '
          'not interleave them on screen. The account identity repeats at '
          'the head of the menu as a ElMenuLabel, above the first '
          'separator, with no parameter to suppress it. A destructive row '
          'renders through ElMenuItemVariant.destructive, the same tone '
          'dropdown_menu documents: sign out and delete are what it is '
          'for. icon takes a lucide glyph (ElLucideGlyph), not a rendered '
          'widget: the reference takes an element because functions '
          'cannot cross its RSC boundary, and there is no such boundary '
          'here. onSelect is optional: a row with a null onSelect still '
          'renders, since this component adds no disabled treatment of '
          'its own. The menu itself is a ElDropdownMenu filled with '
          'ElMenuLabel, ElMenuSeparator, ElMenuGroup, and ElMenuItem '
          'rows, the shared menu engine documented in full on the '
          'Dropdown Menu page.',
      code: _menuCode,
    ),
    SnippetSection(
      id: 'placement',
      title: 'Where the menu opens',
      description:
          'One branch, and it is not a platform check. ElNavUser reads '
          'ElSidebarScope.maybeOf(context) and asks whether the '
          'surrounding sidebar considers itself mobile. Inside a sidebar '
          'reporting isMobile: true, the menu opens below the row '
          '(ElPopoverSide.bottom), because there is no room beside it; '
          'everywhere else, including with no sidebar scope at all, it '
          'opens to the right (ElPopoverSide.right) — maybeOf returning '
          'null is treated as not-mobile, which is why the bare specimens '
          'on this page open sideways. Alignment is ElPopoverAlign.end in '
          'both cases, so the menu lines up with the bottom of the row it '
          'belongs to. Width is ElNavUser.menuMinWidth, a static getter '
          "equal to el(56), the floor beneath the trigger's own width "
          'rather than a fixed size. The trigger passes '
          'ElDropdownMenu.pressScaleSuppressed, so the row does not dip '
          'on press the way an ordinary button does, and expanded is '
          'driven from ElMenuTriggerScope.openOf(context): the row stays '
          'lit while the menu is open.',
      code: _placementCode,
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter and public member of the three '
          'exported classes, read straight off '
          'lib/src/components/nav_user.dart. The private _IdentityText '
          'widget is not part of the API and is not listed.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'ElNavUser', anchor: 'api-elnavuser'),
        DocsTocEntry(
          title: 'ElNavUserAccount',
          anchor: 'api-elnavuseraccount',
        ),
        DocsTocEntry(title: 'ElNavUserItem', anchor: 'api-elnavuseritem'),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'ElNavUser holds no state of its own: it is a StatelessWidget, '
          'and every state below belongs to the trigger button, the '
          'dropdown, or the avatar it composes.',
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
          'Read straight off nav_user.dart, menu.dart, and sidebar.dart, '
          'not inferred: nav_user.dart itself wires no key handling.',
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
            value: navUserDoc.sourcePath,
            description:
                'Authoritative implementation, including its own measured '
                'library note: the truth this page was written from.',
          ),
          const DocsInstallFact(
            label: 'Menu engine',
            value: 'lib/src/components/dropdown_menu.dart, menu.dart',
            description:
                'The shared engine this component composes. Documented on '
                'the Dropdown Menu page, not here.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'none yet',
            description:
                'No dedicated nav_user test in the package suite yet.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/nav_user_test.dart',
            description:
                'Covers this page: the article mounts, the section order, '
                'all three API tables, the live specimens, opening the '
                'account menu, and a theme flip.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/nav_user/page.dart',
            description: 'This file.',
          ),
          const DocsInstallFact(
            label: 'Split from',
            value: 'example/lib/components_docs/carousel/page.dart',
            description:
                'Where this component was documented before 2026-08-24.',
          ),
        ],
      ),
    ),
  ],
);

class NavUserDocPage extends StatelessWidget {
  const NavUserDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: navUserDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / LAYOUT & UI',
      title: navUserDoc.title,
      description: navUserDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Nav User'),
    ],
    toc: navUserDocSpec.toc,
    previous: const DocsPageLink(
      title: 'Native Select',
      route: '/components/native_select',
    ),
    next: const DocsPageLink(
      title: 'Navigation Menu',
      route: '/components/navigation-menu',
    ),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('nav-user-doc-article'),
      child: ComponentDocPage(spec: navUserDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

/// The page's one specimen shape: an account with three rows, one of them
/// destructive. [name] varies only so the initials section can show a longer
/// one.
class _NavUserPreview extends StatelessWidget {
  const _NavUserPreview({this.name = 'Alex Johnson'});

  final String name;

  @override
  Widget build(BuildContext context) => ElNavUser(
    user: ElNavUserAccount(name: name, email: 'alex@example.com'),
    items: <ElNavUserItem>[
      ElNavUserItem(label: 'Profile', icon: ElLucide.user),
      ElNavUserItem(label: 'Settings', icon: ElLucide.settings),
      ElNavUserItem(
        label: 'Sign out',
        icon: ElLucide.logOut,
        destructive: true,
      ),
    ],
  );
}

class _FooterSpecimen extends StatelessWidget {
  const _FooterSpecimen();

  @override
  Widget build(BuildContext context) =>
      ElSidebarFooter(children: const <Widget>[_NavUserPreview()]);
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

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elnavuser',
        child: DocsApiTable(title: 'ElNavUser', facts: _navUserFacts),
      ),
      SizedBox(height: el(6)),
      const DocsAnchor(
        id: 'api-elnavuseraccount',
        child: DocsApiTable(
          title: 'ElNavUserAccount',
          facts: _accountFacts,
        ),
      ),
      SizedBox(height: el(6)),
      const DocsAnchor(
        id: 'api-elnavuseritem',
        child: DocsApiTable(title: 'ElNavUserItem', facts: _itemFacts),
      ),
    ],
  );
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'The row is a real ElSidebarMenuButton, so it is focusable and '
            'keyboard-activatable on the same terms as any button in this '
            'system.',
        'Accessible name: the trigger passes tooltip: user.name. The '
            'visible name and email are ordinary ElText, so both are read '
            'as well.',
        'The identity block is repeated at the head of the open menu, '
            'which means a screen-reader user hears the name and address '
            'twice: once on the trigger, once at the top of the menu. '
            'That is the reference shape, deliberately kept.',
        'Known gap: expanded on the trigger is visual only. It holds the '
            "row's hover fill open while the menu is open but is not "
            'surfaced as a Semantics expanded flag, so the open state '
            "looks lit without being announced. This is ElButton's "
            'documented gap, inherited here rather than introduced.',
        'Known gap: the avatar fallback is initials, which read aloud as '
            'letters. Nothing supplies an image alternative text, because '
            'ElNavUserAccount has no field for one.',
        'The chevron is decorative and carries no label of its own '
            '(aria-hidden in the reference).',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'nav_user.dart wires no key handling of its own: every keystroke '
            'below belongs to the trigger button or to the shared menu '
            'engine it opens.',
        'The trigger is a real ElSidebarMenuButton, focusable and '
            'activatable with Enter or Space like any button in this '
            'system.',
        'Once the menu is open, keyboard traversal is ElDropdownMenu / '
            "menu.dart's own engine (documented in full on the Dropdown "
            'Menu page): ArrowDown/ArrowUp move the highlighted row, '
            'Home/End jump to the first or last row, Enter/Space or a '
            'single printable character (typeahead) commits the '
            'highlighted row, and Escape or Tab closes the menu.',
        'ArrowRight and ArrowLeft, which the shared engine reserves for '
            'opening and closing a submenu, do nothing here: this '
            'composition has no ElMenuGroup row that opens a submenu of '
            'its own.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No breakpoint is read anywhere in nav_user.dart. The only '
            "adaptation is the sidebar scope's own isMobile flag, which "
            'the sidebar decides and this component merely consults: see '
            'Where the menu opens.',
        'The row fills the width it is given and the identity column '
            'truncates to one line each (maxLines: 1, ellipsis, softWrap: '
            'false), so a narrow rail shortens the text instead of '
            'growing the row.',
        'The menu width floors at el(56) but follows the trigger when '
            'the trigger is wider, so it does not shrink below '
            'readability in a narrow footer.',
        'Row height does not change with viewport: it comes from '
            'ElSidebarMenuButtonSize.lg, a fixed rung.',
        'Platform parity: the same widget tree on Android, iOS, Web, '
            'macOS, Windows, and Linux. No dart:io Platform branch in the '
            'file.',
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
            value: 'nav-user',
            description:
                'registry/components/nav-user.json exists and is '
                'installable through the CLI today.',
          ),
          const DocsInstallFact(
            label: 'Destination',
            value: 'lib/components/ui/nav_user.dart',
            description:
                'The same lib/components/ui/ target every component '
                'installs to, in both foundation modes.',
          ),
          const DocsInstallFact(
            label: 'Foundation',
            value: 'source or package compatible',
            description:
                'The manifest names only source-foundation plus five '
                'sibling components: nothing here is package-mode-only.',
          ),
          DocsInstallFact(
            label: 'Dependencies',
            value: navUserDoc.dependencies.join(', '),
            description:
                "The manifest's registryDependencies, resolved "
                'automatically by the registry client: the heaviest '
                'dependency list of the three components split out of '
                'the old carousel page.',
          ),
          const DocsInstallFact(
            label: 'Assets',
            value: 'none',
            description:
                'No bundled images. The optional avatar is an '
                'ImageProvider the caller supplies.',
          ),
          const DocsInstallFact(
            label: 'Shaders',
            value: 'none',
            description: 'Not applicable.',
          ),
          const DocsInstallFact(
            label: 'Platforms',
            value: 'Android, iOS, Web, macOS, Windows, Linux',
            description:
                'No platform-conditional code. The one branch in the '
                'file is a sidebar-scope flag, not a platform check: see '
                'Where the menu opens.',
          ),
          const DocsInstallFact(
            label: 'Verified',
            value: 'docs specimen only',
            description:
                "This page's live specimens and "
                'example/test/components_docs/nav_user_test.dart. No '
                'dedicated package-level unit test exists yet.',
          ),
        ],
      ),
      SizedBox(height: el(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Avatar', route: '/components/avatar'),
          DocsLink(label: 'Dropdown Menu', route: '/components/dropdown-menu'),
          DocsLink(label: 'Icon', route: '/components/icon'),
          DocsLink(label: 'Popover', route: '/components/popover'),
          DocsLink(label: 'Sidebar', route: '/components/sidebar'),
        ],
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'The two lines of the identity read their colours live off '
            'ElTheme.of(context): theme.foreground for the name, '
            'theme.mutedForeground for the email. Those are the only two '
            'colours the file names.',
        'Everything else is inherited paint: the row fill, border, and '
            'focus ring come from ElSidebarMenuButton, the avatar circle '
            'and its fallback from ElAvatar, and the menu surface from '
            'ElDropdownMenu.',
        'Type is ElType.nav for the name and ElType.caption for the '
            'email, matching the measured 13.5 and 10.5 of the reference '
            'footer. Neither is overridable.',
        'The destructive row takes its tone from '
            'ElMenuItemVariant.destructive, so it flips with the theme '
            'along with the rest of the menu.',
        'Flipping ElThemeController re-resolves every one of these on '
            'the next frame; nothing is cached.',
        'Geometry is not themeable: the menu floor (el(56)) and the gap '
            'between avatar and text in the menu head (el(2)) are fixed '
            'against the 4px grid.',
      ]);
}

/* ── Code ────────────────────────────────────────────────────────────────── */

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

ElNavUser(
  user: const ElNavUserAccount(
    name: 'Alex Johnson',
    email: 'alex@example.com',
  ),
  items: <ElNavUserItem>[
    ElNavUserItem(label: 'Profile', icon: ElLucide.user),
    ElNavUserItem(label: 'Settings', icon: ElLucide.settings),
    ElNavUserItem(
      label: 'Sign out',
      icon: ElLucide.logOut,
      destructive: true,
    ),
  ],
)''';

const String _footerCode = '''ElSidebar(
  children: <Widget>[
    ElSidebarHeader(children: <Widget>[...]),
    ElSidebarContent(children: <Widget>[...]),
    ElSidebarFooter(
      children: <Widget>[
        ElNavUser(user: account, items: items),
      ],
    ),
  ],
)''';

const String _accountCode = '''// With an image.
ElNavUserAccount(
  name: 'Alex Johnson',
  email: 'alex@example.com',
  avatar: const NetworkImage('https://example.com/alex.png'),
)

// Without one: ElAvatar shows account.initials instead.
const ElNavUserAccount(
  name: 'Marguerite Okonkwo Adeyemi',
  email: 'alex@example.com',
) // initials == 'MO'
''';

const String _menuCode =
    '''// Order in the list does not decide order on screen: every
// non-destructive row is grouped first, then a separator, then
// every destructive one.
ElNavUser(
  user: account,
  items: <ElNavUserItem>[
    ElNavUserItem(
      label: 'Sign out',
      icon: ElLucide.logOut,
      destructive: true,   // still renders last
      onSelect: signOut,
    ),
    ElNavUserItem(
      label: 'Profile',
      icon: ElLucide.user, // a glyph, not a widget
      onSelect: openProfile,
    ),
    ElNavUserItem(label: 'Settings'), // no glyph, no callback
  ],
)''';

/// A real excerpt of `ElNavUser.build` (`lib/src/components/nav_user.dart`),
/// not an invented one.
const String _placementCode =
    '''// Inside ElNavUser.build:
final bool mobile = ElSidebarScope.maybeOf(context)?.isMobile ?? false;

ElDropdownMenu(
  side: mobile ? ElPopoverSide.bottom : ElPopoverSide.right,
  align: ElPopoverAlign.end,
  width: ElNavUser.menuMinWidth, // el(56)
  children: rows,
  trigger: trigger,
)''';

const List<DocsApiFact> _navUserFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'user',
    type: 'ElNavUserAccount',
    description:
        'Required, no default. The account the row shows and the menu '
        'repeats at its head.',
  ),
  DocsApiFact(
    name: 'items',
    type: 'List<ElNavUserItem>',
    description:
        'Required, and deliberately without a default: a default list '
        'would put invented product actions into the chassis. Partitioned '
        'into non-destructive rows, then a separator, then destructive '
        'rows.',
  ),
  DocsApiFact(
    name: 'ElNavUser.menuMinWidth',
    type: 'static double',
    description:
        'el(56). The floor beneath the trigger\'s own width, passed to '
        "ElDropdownMenu as its width: the reference's min-w-56.",
  ),
];

const List<DocsApiFact> _accountFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'name',
    type: 'String',
    description:
        'Required, no default. Rendered as ElType.nav in theme.foreground, '
        'one line, ellipsised. Also the trigger tooltip and the menu '
        'label.',
  ),
  DocsApiFact(
    name: 'email',
    type: 'String',
    description:
        'Required, no default. Rendered as ElType.caption in '
        'theme.mutedForeground, one line, ellipsised.',
  ),
  DocsApiFact(
    name: 'avatar',
    type: 'ImageProvider<Object>?',
    description:
        'Optional. Defaults to null, which shows initials instead. The '
        "reference's AvatarImage src.",
  ),
  DocsApiFact(
    name: 'initials',
    type: 'String (read-only getter)',
    description:
        'The first letter of each of the first two whitespace-separated '
        'words of name, uppercased. Used when there is no avatar image, or '
        'when one fails to load.',
  ),
];

const List<DocsApiFact> _itemFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'label',
    type: 'String',
    description: "Required, no default. The row's visible text.",
  ),
  DocsApiFact(
    name: 'icon',
    type: 'ElLucideGlyph?',
    description:
        'Optional. Defaults to null, for a row with no glyph. A lucide '
        'glyph, not a rendered widget: passed through to ElMenuItem as '
        'lucideIcon.',
  ),
  DocsApiFact(
    name: 'onSelect',
    type: 'VoidCallback?',
    description:
        'Optional. Defaults to null. Handed to ElMenuItem unchanged; this '
        'class adds no disabled treatment of its own for a null one.',
  ),
  DocsApiFact(
    name: 'destructive',
    type: 'bool',
    description:
        'Optional. Defaults to false. True moves the row below a '
        'separator, out of the ElMenuGroup, and renders it through '
        'ElMenuItemVariant.destructive. Sign out and delete.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest',
    treatment:
        'The row shows avatar, name, email, and the chevron. The trigger '
        'is an unexpanded ElSidebarMenuButton at size lg.',
    userSignal: 'A quiet account row on the sidebar floor.',
  ),
  DocsStateFact(
    state: 'Hover and focus',
    treatment:
        "ElSidebarMenuButton's own hover fill and focus ring. nav_user "
        'adds nothing and overrides nothing.',
    userSignal: 'A lit row under the pointer, a ring under the keyboard.',
  ),
  DocsStateFact(
    state: 'Pressed',
    treatment:
        'The usual press scale is cancelled: the trigger passes '
        'ElDropdownMenu.pressScaleSuppressed, because the row opens '
        'something rather than acting.',
    userSignal: 'No dip. The menu appears instead.',
  ),
  DocsStateFact(
    state: 'Menu open',
    treatment:
        'expanded is driven from ElMenuTriggerScope.openOf(context), so '
        "the row holds its hover fill while the menu is up. Visual only: "
        'see the known gap in Accessibility.',
    userSignal: 'The row stays lit for as long as the menu is.',
  ),
  DocsStateFact(
    state: 'No avatar image',
    treatment:
        'ElAvatar falls back to ElNavUserAccount.initials with the '
        'avatarFallback component spec. The same fallback covers an image '
        'that fails to load.',
    userSignal: 'Two uppercase letters in the avatar circle.',
  ),
  DocsStateFact(
    state: 'Long name or address',
    treatment:
        'Both lines are maxLines: 1 with ellipsis and softWrap: false, so '
        'the identity column truncates rather than wrapping.',
    userSignal: 'Shortened text, an unchanged row height.',
  ),
  DocsStateFact(
    state: 'Empty items list',
    treatment:
        'Both the non-destructive group and the destructive tail are '
        'conditional, so an empty list yields a menu holding only the '
        'identity label. The row still renders and still opens.',
    userSignal: 'A menu with nothing to choose.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'Nothing in nav_user.dart animates. Whatever the trigger button '
        'and the dropdown do under MediaQuery.disableAnimations is theirs.',
    userSignal: 'No change originating here.',
  ),
];
