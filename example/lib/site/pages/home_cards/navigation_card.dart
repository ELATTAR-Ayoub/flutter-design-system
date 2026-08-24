/// A workspace-navigation card: two `ElSidebarGroup`s of menu rows with one
/// active row shared between them.
///
/// The sidebar's group and menu pieces resolve their chrome through
/// `ElSidebarChrome.maybeOf`, so they render outside a `ElSidebarProvider`;
/// `ElSidebar` itself does not, and would paint a fixed-width panel here.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

/// One nav row: its label, glyph, and (for the badged one) a count.
class _NavRow {
  const _NavRow(this.label, this.glyph, {this.badge});

  final String label;
  final ElIconGlyph glyph;
  final String? badge;
}

const List<_NavRow> _overviewRows = <_NavRow>[
  _NavRow('Analytics', ElIconGlyph.activity),
  _NavRow('Transactions', ElIconGlyph.creditCard),
  _NavRow('Investments', ElIconGlyph.trendingUp),
  _NavRow('Accounts', ElIconGlyph.wallet),
];

const List<_NavRow> _accountRows = <_NavRow>[
  _NavRow('Profile', ElIconGlyph.user),
  _NavRow('Billing', ElIconGlyph.circleDollarSign, badge: '3'),
  _NavRow('Notifications', ElIconGlyph.bell),
  _NavRow('Security', ElIconGlyph.shield),
];

class NavigationCard extends StatefulWidget {
  const NavigationCard({super.key});

  @override
  State<NavigationCard> createState() => _NavigationCardState();
}

class _NavigationCardState extends State<NavigationCard> {
  String _active = 'Analytics';

  Widget _row(_NavRow row) => ElSidebarMenuItem(
    button: ElSidebarMenuButton(
      key: ValueKey<String>('home-navigation-${row.label}'),
      isActive: _active == row.label,
      tooltip: row.label,
      onPressed: () => setState(() => _active = row.label),
      child: ElSidebarMenuRow(
        leading: ElIcon(row.glyph, sizePx: ElButton.iconPxFor(ElButtonSize.sm)),
        label: ElSidebarMenuLabel(row.label),
      ),
    ),
    badge: row.badge == null ? null : ElSidebarMenuBadge(row.badge!),
  );

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return ElCard(
      children: <Widget>[
        const ElCardHeader(
          title: ElCardTitle('Workspace navigation'),
          description: ElCardDescription(
            'A sidebar menu, active row and all, outside a sidebar.',
          ),
        ),
        ElCardContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElSidebarGroup(
                children: <Widget>[
                  const ElSidebarGroupLabel('Overview'),
                  ElSidebarGroupContent(
                    child: ElSidebarMenu(
                      children: <Widget>[
                        for (final _NavRow row in _overviewRows) _row(row),
                      ],
                    ),
                  ),
                ],
              ),
              ElSidebarGroup(
                children: <Widget>[
                  const ElSidebarGroupLabel('Account'),
                  ElSidebarGroupContent(
                    child: ElSidebarMenu(
                      children: <Widget>[
                        for (final _NavRow row in _accountRows) _row(row),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: el(3)),
              ElText(
                'Showing $_active.',
                ElType.small,
                color: theme.mutedForeground,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
