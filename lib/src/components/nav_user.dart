/// `components/ui/nav-user.tsx` — *"the account block a sidebar footer is
/// incomplete without."*
///
/// It lives in `ui/` upstream *"because its shape is fixed everywhere it
/// appears and it encodes no product meaning — §5's test is money, scarcity,
/// chance and progression, and an account row is none of them."*
///
/// One `SidebarMenuButton size="lg"` holding an avatar, a two-line identity
/// block and a chevron, opening a menu that repeats the same identity at its
/// head. Measured on the page's footer specimens (1440 × 900, 2026-08-16): the
/// row is **50px** — a 32px avatar in `py-2` inside a 1px border — the name is
/// `.type-nav` at 13.5/500 and the email `.type-caption` at 10.5/500.
///
/// **`items` has no default, on purpose.** *"A default list would put invented
/// product actions ('Upgrade to Pro', 'Billing') into the chassis §10 says
/// travels into the next project."*
library;

import 'package:flutter/widgets.dart';

import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../theme_scope.dart';
import 'avatar.dart';
import 'dropdown_menu.dart';
import 'icon.dart';
import 'icon_paths.g.dart';
import 'menu.dart';
import 'popover.dart';
import 'sidebar.dart';

/// The account whose name and email the row shows. *"Sample data, never a
/// default."*
@immutable
class DsNavUserAccount {
  const DsNavUserAccount({
    required this.name,
    required this.email,
    this.avatar,
  });

  final String name;
  final String email;

  /// `AvatarImage src`.
  final ImageProvider<Object>? avatar;

  /// *"Initials, for when there is no avatar image — or when one fails to
  /// load."* The first letter of each of the first two words, uppercased.
  String get initials => name
      .split(RegExp(r'\s+'))
      .take(2)
      .map((String part) => part.isEmpty ? '' : part[0].toUpperCase())
      .join();
}

/// One row of the account menu.
@immutable
class DsNavUserItem {
  const DsNavUserItem({
    required this.label,
    this.icon,
    this.onSelect,
    this.destructive = false,
  });

  final String label;

  /// A lucide glyph. The reference takes a *rendered element* rather than a
  /// component reference, because *"functions cannot cross the RSC boundary"*;
  /// there is no such boundary here, so the honest shape is the glyph.
  final DsLucideGlyph? icon;

  final VoidCallback? onSelect;

  /// *"Rendered in the destructive tone, below a separator. Sign out, delete."*
  final bool destructive;
}

/// The footer's account block.
class DsNavUser extends StatelessWidget {
  const DsNavUser({super.key, required this.user, required this.items});

  final DsNavUserAccount user;

  final List<DsNavUserItem> items;

  /// `min-w-56` on the content — the floor beneath the trigger's own width.
  static double get menuMinWidth => ds(56);

  @override
  Widget build(BuildContext context) {
    final DsSidebarScope? scope = DsSidebarScope.maybeOf(context);
    final bool mobile = scope?.isMobile ?? false;

    final List<DsNavUserItem> normal =
        items.where((DsNavUserItem i) => !i.destructive).toList();
    final List<DsNavUserItem> destructive =
        items.where((DsNavUserItem i) => i.destructive).toList();

    final List<DsMenuChild> rows = <DsMenuChild>[
      DsMenuLabel(user.name, child: _identity()),
      if (normal.isNotEmpty) ...<DsMenuChild>[
        const DsMenuSeparator(),
        DsMenuGroup(
          children: <DsMenuChild>[
            for (final DsNavUserItem item in normal)
              DsMenuItem(
                label: item.label,
                lucideIcon: item.icon,
                onSelect: item.onSelect,
              ),
          ],
        ),
      ],
      if (destructive.isNotEmpty) ...<DsMenuChild>[
        const DsMenuSeparator(),
        for (final DsNavUserItem item in destructive)
          DsMenuItem(
            label: item.label,
            lucideIcon: item.icon,
            variant: DsMenuItemVariant.destructive,
            onSelect: item.onSelect,
          ),
      ],
    ];

    return DsSidebarMenu(
      children: <Widget>[
        DsSidebarMenuItem(
          button: DsDropdownMenu(
            // *"On mobile it drops below, because there is no room beside."*
            side: mobile ? DsPopoverSide.bottom : DsPopoverSide.right,
            align: DsPopoverAlign.end,
            width: menuMinWidth,
            children: rows,
            trigger: DsSidebarMenuButton(
              size: DsSidebarMenuButtonSize.lg,
              tooltip: user.name,
              suppressPressScale: DsDropdownMenu.pressScaleSuppressed,
              expanded: DsMenuTriggerScope.openOf(context),
              child: DsSidebarMenuRow(
                size: DsSidebarMenuButtonSize.lg,
                leading: DsAvatar(
                  fallback: user.initials,
                  image: user.avatar,
                  fallbackSpec: DsComponentType.avatarFallback,
                ),
                label: _IdentityText(user: user),
                // `<Icon icon={ChevronsUpDown} className="ml-auto …" />`.
                trailing: const DsIcon.lucide(DsLucide.chevronsUpDown),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// *"The identity block, repeated in the trigger and at the top of the
  /// menu."*
  Widget _identity() => Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DsAvatar(
            fallback: user.initials,
            image: user.avatar,
            fallbackSpec: DsComponentType.avatarFallback,
          ),
          // `flex items-center gap-2` around the pair in the menu head.
          SizedBox(width: ds(2)),
          Flexible(child: _IdentityText(user: user)),
        ],
      );
}

/// The two-line column: a `--foreground` name over a muted email, both
/// truncating.
class _IdentityText extends StatelessWidget {
  const _IdentityText({required this.user});

  final DsNavUserAccount user;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DsText(
          user.name,
          DsType.nav,
          color: theme.foreground,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        ),
        DsText(
          user.email,
          DsType.caption,
          color: theme.mutedForeground,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        ),
      ],
    );
  }
}
