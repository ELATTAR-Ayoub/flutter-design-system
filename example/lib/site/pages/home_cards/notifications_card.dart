/// A live notification-preferences card: four checkbox rows built from
/// `Item`, a select-all/clear-all pair with a live count badge, and a
/// save footer, built only from real `El*` components.
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

/// One preference row: what it is called, what it does, and its default.
@immutable
class _NotificationItem {
  const _NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.defaultOn,
  });

  final String id;
  final String title;
  final String description;
  final bool defaultOn;
}

const List<_NotificationItem> _notificationItems = <_NotificationItem>[
  _NotificationItem(
    id: 'transaction',
    title: 'Transaction alerts',
    description: 'Deposits, withdrawals, and transfers.',
    defaultOn: true,
  ),
  _NotificationItem(
    id: 'security',
    title: 'Security alerts',
    description: 'Sign-ins from a new device or location.',
    defaultOn: true,
  ),
  _NotificationItem(
    id: 'product',
    title: 'Product updates',
    description: 'New components, releases, and changelog notes.',
    defaultOn: false,
  ),
  _NotificationItem(
    id: 'weekly',
    title: 'Weekly digest',
    description: 'A Monday summary of the past seven days.',
    defaultOn: false,
  ),
];

/// Notification preferences: four toggleable rows and a save.
class NotificationsCard extends StatefulWidget {
  const NotificationsCard({super.key});

  @override
  State<NotificationsCard> createState() => _NotificationsCardState();
}

class _NotificationsCardState extends State<NotificationsCard> {
  late final Map<String, bool> _on = <String, bool>{
    for (final _NotificationItem item in _notificationItems)
      item.id: item.defaultOn,
  };
  bool _saving = false;
  bool _justSaved = false;

  int get _onCount => _on.values.where((bool value) => value).length;

  void _toggle(String id) => setState(() {
    _on[id] = !(_on[id] ?? false);
    _justSaved = false;
  });

  void _setAll(bool value) => setState(() {
    for (final _NotificationItem item in _notificationItems) {
      _on[item.id] = value;
    }
    _justSaved = false;
  });

  Future<void> _save() async {
    setState(() => _saving = true);
    await Future<void>.delayed(MotionDurations.slow);
    if (!mounted) return;
    setState(() {
      _saving = false;
      _justSaved = true;
    });
  }

  Widget _row(_NotificationItem item) {
    final bool value = _on[item.id] ?? false;
    return GestureDetector(
      key: ValueKey<String>('home-notifications-row-${item.id}'),
      behavior: HitTestBehavior.opaque,
      onTap: () => _toggle(item.id),
      child: Item(
        media: ItemMedia(
          child: Checkbox(
            key: ValueKey<String>('home-notifications-checkbox-${item.id}'),
            state: value ? CheckboxState.checked : CheckboxState.unchecked,
            // The row's GestureDetector covers the rest of the strip, but the
            // box keeps its own handler: without one it is a disabled control,
            // out of the tab order and announced as such.
            onChanged: (_) => _toggle(item.id),
            label: item.title,
          ),
        ),
        content: ItemContent(
          children: <Widget>[
            ItemTitle(item.title),
            ItemDescription(item.description),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Card(
      children: <Widget>[
        const CardHeader(
          title: CardTitle('Notifications'),
          description: CardDescription(
            'Choose which email and push alerts you want to receive.',
          ),
        ),
        CardContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Wrap(
                spacing: space(2),
                runSpacing: space(2),
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Button(
                    key: const ValueKey<String>(
                      'home-notifications-select-all',
                    ),
                    variant: ButtonVariant.ghost,
                    size: ButtonSize.sm,
                    onPressed: () => _setAll(true),
                    child: const Text('Select all'),
                  ),
                  Button(
                    key: const ValueKey<String>('home-notifications-clear-all'),
                    variant: ButtonVariant.ghost,
                    size: ButtonSize.sm,
                    onPressed: () => _setAll(false),
                    child: const Text('Clear all'),
                  ),
                  Badge(label: '$_onCount of 4 on'),
                ],
              ),
              SizedBox(height: space(3)),
              ItemGroup(
                children: <Widget>[
                  for (final _NotificationItem item in _notificationItems)
                    _row(item),
                ],
              ),
            ],
          ),
        ),
        CardFooter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (_justSaved) ...<Widget>[
                StyledText(
                  'Preferences saved.',
                  TextStyles.small,
                  color: theme.mutedForeground,
                ),
                SizedBox(height: space(3)),
              ],
              Button(
                key: const ValueKey<String>('home-notifications-save'),
                loading: _saving,
                contentAlignment: AlignmentDirectional.center,
                onPressed: _saving ? null : _save,
                child: const Text('Save preferences'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
