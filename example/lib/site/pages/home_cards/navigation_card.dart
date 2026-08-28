/// A workspace-navigation card: two `SidebarGroup`s of menu rows with one
/// active row shared between them.
///
/// The sidebar's group and menu pieces resolve their chrome through
/// `SidebarChrome.maybeOf`, so they render outside a `SidebarProvider`;
/// `Sidebar` itself does not, and would paint a fixed-width panel here.
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

/// One nav row: its label, glyph, and (for the badged one) a count.
class _NavRow {
  const _NavRow(this.label, this.glyph, {this.badge});

  final String label;
  final IconGlyph glyph;
  final String? badge;
}

const List<_NavRow> _overviewRows = <_NavRow>[
  _NavRow('Analytics', IconGlyph.activity),
  _NavRow('Transactions', IconGlyph.creditCard),
  _NavRow('Investments', IconGlyph.trendingUp),
  _NavRow('Accounts', IconGlyph.wallet),
];

const List<_NavRow> _accountRows = <_NavRow>[
  _NavRow('Profile', IconGlyph.user),
  _NavRow('Billing', IconGlyph.circleDollarSign, badge: '3'),
  _NavRow('Notifications', IconGlyph.bell),
  _NavRow('Security', IconGlyph.shield),
];

class NavigationCard extends StatefulWidget {
  const NavigationCard({super.key});

  @override
  State<NavigationCard> createState() => _NavigationCardState();
}

class _NavigationCardState extends State<NavigationCard> {
  String _active = 'Analytics';

  Widget _row(_NavRow row) => SidebarMenuItem(
    button: SidebarMenuButton(
      key: ValueKey<String>('home-navigation-${row.label}'),
      isActive: _active == row.label,
      tooltip: row.label,
      onPressed: () => setState(() => _active = row.label),
      child: SidebarMenuRow(
        leading: Icon(row.glyph, sizePx: Button.iconPxFor(ButtonSize.sm)),
        label: SidebarMenuLabel(row.label),
      ),
    ),
    badge: row.badge == null ? null : SidebarMenuBadge(row.badge!),
  );

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Card(
      children: <Widget>[
        const CardHeader(
          title: CardTitle('Workspace navigation'),
          description: CardDescription(
            'A sidebar menu, active row and all, outside a sidebar.',
          ),
        ),
        CardContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SidebarGroup(
                children: <Widget>[
                  const SidebarGroupLabel('Overview'),
                  SidebarGroupContent(
                    child: SidebarMenu(
                      children: <Widget>[
                        for (final _NavRow row in _overviewRows) _row(row),
                      ],
                    ),
                  ),
                ],
              ),
              SidebarGroup(
                children: <Widget>[
                  const SidebarGroupLabel('Account'),
                  SidebarGroupContent(
                    child: SidebarMenu(
                      children: <Widget>[
                        for (final _NavRow row in _accountRows) _row(row),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: space(3)),
              StyledText(
                'Showing $_active.',
                TextStyles.small,
                color: theme.mutedForeground,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
