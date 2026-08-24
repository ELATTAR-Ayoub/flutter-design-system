/// Public documentation page for the `nav_user` component.
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
/// Section order follows `components_docs/button/page.dart`: an unheaded live
/// demo, Installation, Usage, this component's own sections, API Reference
/// last of those, then States / Accessibility / Responsive / Dependencies /
/// Theming / Source.
///
/// [ComponentDocEntry.description] is the page's only hero text.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

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
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Installation', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'Sitting in a sidebar footer', anchor: 'footer'),
      DocsTocEntry(title: 'Naming the account', anchor: 'account'),
      DocsTocEntry(title: 'Filling the menu', anchor: 'menu'),
      DocsTocEntry(title: 'Where the menu opens', anchor: 'placement'),
      DocsTocEntry(
        title: 'API Reference',
        anchor: 'api',
        children: <DocsTocEntry>[
          DocsTocEntry(title: 'ElNavUser', anchor: 'api-elnavuser'),
          DocsTocEntry(
            title: 'ElNavUserAccount',
            anchor: 'api-elnavuseraccount',
          ),
          DocsTocEntry(title: 'ElNavUserItem', anchor: 'api-elnavuseritem'),
        ],
      ),
      DocsTocEntry(title: 'States', anchor: 'states'),
      DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
      DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
      DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
      DocsTocEntry(title: 'Theming', anchor: 'theming'),
      DocsTocEntry(title: 'Source', anchor: 'source'),
    ],
    previous: const DocsPageLink(
      title: 'Native Select',
      route: '/components/native_select',
    ),
    next: const DocsPageLink(
      title: 'Navigation Menu',
      route: '/components/navigation-menu',
    ),
    onNavigate: onNavigate,
    child: const _ArticleContent(),
  );
}

class _ArticleContent extends StatelessWidget {
  const _ArticleContent();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      key: const ValueKey<String>('nav-user-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _liveDemo(),
        SizedBox(height: el(6)),
        _install(),
        SizedBox(height: el(6)),
        _usage(),
        SizedBox(height: el(6)),
        _footer(theme),
        _account(),
        _menu(theme),
        _placement(theme),
        _api(),
        _states(),
        _accessibility(theme),
        _responsive(theme),
        _dependencies(theme),
        _theming(theme),
        _source(),
      ],
    );
  }

  /// The live demo that opens the page: no [ElSection], no anchor, no TOC
  /// entry, matching every other page in the corpus.
  Widget _liveDemo() => DocsCodeExample(
    title: 'Nav User',
    description:
        'One row: a 32px avatar, a two-line identity, and a chevron. Click '
        'it and the same identity reappears at the head of the menu it '
        'opens.',
    preview: const KeyedSubtree(
      key: ValueKey<String>('nav-user-preview'),
      child: _NavUserPreview(),
    ),
    manualFiles: const <DocsCodeFile>[
      DocsCodeFile(
        path: 'nav_user_preview.dart',
        title: 'Account row with three items',
        code: _usageCode,
      ),
    ],
  );

  Widget _install() => ElSection(
    id: 'install',
    title: 'Installation',
    description:
        'nav_user ships in the registry, so `elattar add nav_user` '
        'is not available: install by copying the source file manually.',
    child: DocsInstallFacts(
      title: 'Installation facts',
      facts: <DocsInstallFact>[
        const DocsInstallFact(
          label: 'Registry item',
          value: 'registry/components/nav_user.json',
          description:
              'No registry/components/nav_user.json exists. This is a '
              'source-only component today, and the command a manifest '
              'would enable is deliberately not shown.',
        ),
        const DocsInstallFact(
          label: 'Manual copy target',
          value: 'lib/components/ui/nav_user.dart',
          description: 'Where the CLI itself would place the file.',
        ),
        const DocsInstallFact(
          label: 'Foundation',
          value: 'source only',
          description: 'No package-backed alternative is offered yet.',
        ),
        const DocsInstallFact(
          label: 'Would-be dependencies',
          value:
              'source-foundation, avatar, dropdown_menu, menu, popover, '
              'sidebar, icon',
          description:
              'The six component files nav_user.dart imports, plus the '
              'foundation. This is the heaviest dependency list of the '
              'three components split out of the old carousel page: copy '
              'every one of them before this file will compile.',
        ),
        const DocsInstallFact(
          label: 'Assets',
          value: 'none',
          description:
              'No bundled images. The optional avatar is an ImageProvider '
              'the caller supplies.',
        ),
        const DocsInstallFact(
          label: 'Platforms',
          value: 'Android, iOS, Web, macOS, Windows, Linux',
          description:
              'No platform-conditional code. The one branch in the file is '
              'a sidebar-scope flag, not a platform check: see Where the '
              'menu opens.',
        ),
        const DocsInstallFact(
          label: 'Verified',
          value: 'docs specimen only',
          description:
              "This page's live specimens and example/test/components_docs/"
              'nav_user_test.dart. No dedicated package-level unit test '
              'exists yet.',
        ),
      ],
    ),
  );

  Widget _usage() => ElSection(
    id: 'usage',
    title: 'Usage',
    description:
        'The smallest correct import and construction. Both parameters are '
        'required and neither has a default.',
    child: ElPanel(
      label: 'DART',
      note: 'MINIMAL',
      child: DocsSelectableCodeBlock(code: _usageCode),
    ),
  );

  Widget _footer(ElThemeData theme) => ElSection(
    id: 'footer',
    title: 'Sitting in a sidebar footer',
    description:
        'This is the account block a sidebar footer is incomplete without, '
        'and the footer is the place it is built for. ElNavUser returns a '
        'ElSidebarMenu holding one ElSidebarMenuItem, so it drops straight '
        'into ElSidebarFooter beside whatever else lives down there.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ElPanel(
          label: 'DART',
          note: 'ANATOMY',
          child: DocsSelectableCodeBlock(code: _footerCode),
        ),
        SizedBox(height: el(6)),
        ElText('In a footer', ElType.label),
        SizedBox(height: el(2)),
        ElText(
          'The trigger is a ElSidebarMenuButton at size lg, which is what '
          'sets the row height: a 32px avatar inside vertical padding and a '
          'hairline border comes to 50px, measured on the reference footer '
          'at 1440 by 900. The identity column truncates rather than '
          'wrapping, so a long name or a long address shortens instead of '
          'growing the row.',
          ElType.small,
          color: theme.mutedForeground,
        ),
        SizedBox(height: el(4)),
        ElPanel(
          label: 'SIDEBAR FOOTER',
          child: KeyedSubtree(
            key: const ValueKey<String>('nav-user-example:footer'),
            child: ElSidebarFooter(children: const <Widget>[_NavUserPreview()]),
          ),
        ),
      ],
    ),
  );

  Widget _account() => ElSection(
    id: 'account',
    title: 'Naming the account',
    description:
        'ElNavUserAccount carries the name and the email address, and an '
        'optional avatar image. When there is no image, or when one fails '
        'to load, the avatar falls back to initials: the first letter of '
        'each of the first two words of the name, uppercased. That is what '
        'the specimen below shows, since it passes no image.',
    child: DocsCodeExample(
      title: 'Initials fallback',
      preview: const KeyedSubtree(
        key: ValueKey<String>('nav-user-example:initials'),
        child: _NavUserPreview(name: 'Marguerite Okonkwo Adeyemi'),
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(path: 'nav_user_account.dart', code: _accountCode),
      ],
    ),
  );

  Widget _menu(ElThemeData theme) => ElSection(
    id: 'menu',
    title: 'Filling the menu',
    description:
        'items has no default, on purpose: a default list would put '
        'invented product actions into a chassis meant to travel into the '
        'next project. Every row is the caller\'s. ElNavUser only decides '
        'the arrangement.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _bullets(theme, <String>[
          'The list is partitioned, not reordered arbitrarily: items where '
              'destructive is false come first as one ElMenuGroup, then a '
              'separator, then the destructive ones. Interleaving them in '
              'the source list will not interleave them on screen.',
          'The account identity is repeated at the head of the menu as a '
              'ElMenuLabel, above the first separator. There is no '
              'parameter to suppress it.',
          'A destructive row renders through '
              'ElMenuItemVariant.destructive: the same tone dropdown_menu '
              'documents. Sign out and delete are what it is for.',
          'icon takes a lucide glyph (ElLucideGlyph), not a rendered '
              'widget. The reference takes an element because functions '
              'cannot cross its RSC boundary; there is no such boundary '
              'here, so the honest shape is the glyph itself.',
          'onSelect is optional. A row with a null onSelect still renders, '
              'through whatever ElMenuItem does with a null callback: this '
              'component adds no disabled treatment of its own.',
          'The menu itself is a ElDropdownMenu filled with ElMenuLabel, '
              'ElMenuSeparator, ElMenuGroup, and ElMenuItem rows, the '
              'shared menu engine documented in full on the Dropdown Menu '
              'page. Nothing about that engine is re-explained here.',
        ]),
        SizedBox(height: el(4)),
        ElPanel(
          label: 'DART',
          note: 'ROWS',
          child: DocsSelectableCodeBlock(code: _menuCode),
        ),
      ],
    ),
  );

  Widget _placement(ElThemeData theme) => ElSection(
    id: 'placement',
    title: 'Where the menu opens',
    description:
        'One branch, and it is not a platform check. ElNavUser reads '
        'ElSidebarScope.maybeOf(context) and asks whether the surrounding '
        'sidebar considers itself mobile.',
    child: _bullets(theme, <String>[
      'Inside a sidebar reporting isMobile: true, the menu opens below the '
          'row (ElPopoverSide.bottom), because there is no room beside it.',
      'Everywhere else, including with no sidebar scope at all, it opens to '
          'the right (ElPopoverSide.right). maybeOf returning null is '
          'treated as not-mobile, which is why the bare specimens on this '
          'page open sideways.',
      'Alignment is ElPopoverAlign.end in both cases, so the menu lines up '
          'with the bottom of the row it belongs to.',
      'Width is ElNavUser.menuMinWidth, a static getter equal to el(56), '
          "which is the floor beneath the trigger's own width rather than a "
          'fixed size.',
      'The trigger passes ElDropdownMenu.pressScaleSuppressed, so the row '
          'does not dip on press the way an ordinary button does, and '
          'expanded is driven from ElMenuTriggerScope.openOf(context): the '
          'row stays lit while the menu is open.',
    ]),
  );

  Widget _api() => ElSection(
    id: 'api',
    title: 'API Reference',
    description:
        'Every constructor parameter and public member of the three '
        'exported classes, read straight off '
        'lib/src/components/nav_user.dart. The private _IdentityText widget '
        'is not part of the API and is not listed.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        KeyedSubtree(
          key: docsAnchorKey('api-elnavuser'),
          child: const DocsApiTable(title: 'ElNavUser', facts: _navUserFacts),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elnavuseraccount'),
          child: const DocsApiTable(
            title: 'ElNavUserAccount',
            facts: _accountFacts,
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elnavuseritem'),
          child: const DocsApiTable(title: 'ElNavUserItem', facts: _itemFacts),
        ),
      ],
    ),
  );

  Widget _states() => ElSection(
    id: 'states',
    title: 'States',
    description:
        'ElNavUser holds no state of its own: it is a StatelessWidget, and '
        'every state below belongs to the trigger button, the dropdown, or '
        'the avatar it composes.',
    child: const DocsStateMatrix(facts: _stateFacts),
  );

  Widget _accessibility(ElThemeData theme) => ElSection(
    id: 'accessibility',
    title: 'Accessibility',
    child: _bullets(theme, <String>[
      'The row is a real ElSidebarMenuButton, so it is focusable and '
          'keyboard-activatable on the same terms as any button in this '
          'system.',
      'Accessible name: the trigger passes tooltip: user.name. The visible '
          'name and email are ordinary ElText, so both are read as well.',
      'Keyboard traversal inside the menu is ElDropdownMenu\'s, not this '
          "component's: see the Dropdown Menu page for what the shared "
          'engine wires up.',
      'The identity block is repeated at the head of the open menu, which '
          'means a screen-reader user hears the name and address twice: '
          'once on the trigger, once at the top of the menu. That is the '
          'reference shape, deliberately kept.',
      'Known gap: expanded on the trigger is visual only. It holds the '
          "row's hover fill open while the menu is open but is not "
          'surfaced as a Semantics expanded flag, so the open state looks '
          'lit without being announced. This is ElButton\'s documented gap, '
          'inherited here rather than introduced.',
      'Known gap: the avatar fallback is initials, which read aloud as '
          'letters. Nothing supplies an image alternative text, because '
          'ElNavUserAccount has no field for one.',
      'The chevron is decorative and carries no label of its own '
          '(aria-hidden in the reference).',
    ]),
  );

  Widget _responsive(ElThemeData theme) => ElSection(
    id: 'responsive',
    title: 'Responsive',
    child: _bullets(theme, <String>[
      'No breakpoint is read anywhere in nav_user.dart. The only '
          'adaptation is the sidebar scope\'s own isMobile flag, which the '
          'sidebar decides and this component merely consults: see Where '
          'the menu opens.',
      'The row fills the width it is given and the identity column '
          'truncates to one line each (maxLines: 1, ellipsis, softWrap: '
          'false), so a narrow rail shortens the text instead of growing '
          'the row.',
      'The menu width floors at el(56) but follows the trigger when the '
          'trigger is wider, so it does not shrink below readability in a '
          'narrow footer.',
      'Row height does not change with viewport: it comes from '
          'ElSidebarMenuButtonSize.lg, a fixed rung.',
      'Platform parity: the same widget tree on Android, iOS, Web, macOS, '
          'Windows, and Linux. No dart:io Platform branch in the file.',
    ]),
  );

  Widget _dependencies(ElThemeData theme) => ElSection(
    id: 'dependencies',
    title: 'Dependencies',
    child: _bullets(theme, <String>[
      'File: lib/src/components/nav_user.dart, one file, holding '
          'ElNavUser, ElNavUserAccount, ElNavUserItem, and the private '
          '_IdentityText.',
      'Flutter import: package:flutter/widgets.dart only.',
      'Foundation imports: foundation/spacing.dart (el()), '
          'foundation/theme.dart (ElThemeData), foundation/typography.dart '
          '(ElType, ElComponentType), theme_scope.dart (ElText, ElTheme).',
      'Component imports, all six: avatar.dart (ElAvatar and the '
          'avatarFallback spec), dropdown_menu.dart (ElDropdownMenu and '
          'its pressScaleSuppressed flag), icon.dart with '
          'icon_paths.g.dart (the chevron glyph), menu.dart (ElMenuChild, '
          'ElMenuLabel, ElMenuSeparator, ElMenuGroup, ElMenuItem, '
          'ElMenuItemVariant, ElMenuTriggerScope), popover.dart '
          '(ElPopoverSide, ElPopoverAlign), sidebar.dart (ElSidebarScope, '
          'ElSidebarMenu, ElSidebarMenuItem, ElSidebarMenuButton, '
          'ElSidebarMenuRow).',
      'The account menu is therefore not its own engine: it is the shared '
          'ElDropdownMenu plus ElMenu* row types that the Dropdown Menu '
          'page documents. This page depends on that engine and does not '
          'restate it.',
      'Registry dependencies: none, from the shipped manifest.',
      'Assets: none. Fonts: none beyond the system type scale. Shaders: '
          'none.',
    ]),
  );

  Widget _theming(ElThemeData theme) => ElSection(
    id: 'theming',
    title: 'Theming',
    child: _bullets(theme, <String>[
      'The two lines of the identity read their colours live off '
          'ElTheme.of(context): theme.foreground for the name, '
          'theme.mutedForeground for the email. Those are the only two '
          'colours the file names.',
      'Everything else is inherited paint: the row fill, border, and '
          'focus ring come from ElSidebarMenuButton, the avatar circle and '
          'its fallback from ElAvatar, and the menu surface from '
          'ElDropdownMenu.',
      'Type is ElType.nav for the name and ElType.caption for the email, '
          'matching the measured 13.5 and 10.5 of the reference footer. '
          'Neither is overridable.',
      'The destructive row takes its tone from '
          'ElMenuItemVariant.destructive, so it flips with the theme along '
          'with the rest of the menu.',
      'Flipping ElThemeController re-resolves every one of these on the '
          'next frame; nothing is cached.',
      'Geometry is not themeable: the menu floor (el(56)) and the gap '
          'between avatar and text in the menu head (el(2)) are fixed '
          'against the 4px grid.',
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
          description: 'No dedicated nav_user test in the package suite yet.',
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
          description: 'Where this component was documented before 2026-08-24.',
        ),
      ],
    ),
  );
}

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
