/// A live payout-threshold card: a currency select, a slider-driven amount,
/// notes, and a save/reset footer, built only from real `El*` components.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

/// Defaults every field and control returns to on reset.
const String _defaultCurrency = 'usd';
const double _defaultAmount = 2500;

const List<ElSelectOption<String>> _currencies = <ElSelectOption<String>>[
  ElSelectOption<String>(value: 'usd', label: 'USD - United States dollar'),
  ElSelectOption<String>(value: 'eur', label: 'EUR - Euro'),
  ElSelectOption<String>(value: 'gbp', label: 'GBP - Pound sterling'),
  ElSelectOption<String>(value: 'jpy', label: 'JPY - Japanese yen'),
];

/// Formats a whole-dollar amount with thousands separators, e.g. `$2,500`.
String _formatAmount(double amount) {
  final String digits = amount.round().toString();
  final StringBuffer grouped = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    final int fromEnd = digits.length - i;
    if (i > 0 && fromEnd % 3 == 0) grouped.write(',');
    grouped.write(digits[i]);
  }
  return '\$$grouped';
}

/// Payout threshold: currency, a minimum amount slider, notes, and a save.
class PayoutCard extends StatefulWidget {
  const PayoutCard({super.key});

  @override
  State<PayoutCard> createState() => _PayoutCardState();
}

class _PayoutCardState extends State<PayoutCard> {
  String _currency = _defaultCurrency;
  double _amount = _defaultAmount;
  final TextEditingController _notes = TextEditingController();
  bool _dismissed = false;
  bool _saving = false;
  double? _savedAmount;

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  void _reset() {
    setState(() {
      _currency = _defaultCurrency;
      _amount = _defaultAmount;
      _notes.clear();
      _savedAmount = null;
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final double pending = _amount;
    await Future<void>.delayed(ElDurations.slow);
    if (!mounted) return;
    setState(() {
      _saving = false;
      _savedAmount = pending;
    });
  }

  /// Spread, not wrapped: [ElCard] reads `children.last is ElCardFooter` to
  /// decide whether to drop its own bottom padding, and a `Column` around the
  /// pair would hide the footer from that test and swallow the card's own
  /// inter-slot spacing.
  List<Widget> _dismissedBody(ElThemeData theme) => <Widget>[
    ElCardContent(
      child: ElText(
        'Payout settings hidden.',
        ElType.small,
        color: theme.mutedForeground,
      ),
    ),
    ElCardFooter(
      child: ElButton(
        key: const ValueKey<String>('home-payout-restore'),
        variant: ElButtonVariant.ghost,
        onPressed: () => setState(() => _dismissed = false),
        child: const Text('Restore'),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final double? savedAmount = _savedAmount;

    return ElCard(
      children: <Widget>[
        ElCardHeader(
          title: const ElCardTitle('Payout threshold'),
          description: const ElCardDescription(
            'Set the minimum balance required before a payout is triggered.',
          ),
          action: ElButton(
            key: const ValueKey<String>('home-payout-dismiss'),
            variant: ElButtonVariant.ghost,
            size: ElButtonSize.icon,
            label: 'Dismiss payout settings',
            onPressed: () => setState(() => _dismissed = true),
            child: const ElIcon(ElIconGlyph.x, size: ElIconSize.sm),
          ),
        ),
        if (_dismissed)
          ..._dismissedBody(theme)
        else ...<Widget>[
          ElCardContent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElField(
                  label: 'Preferred currency',
                  child: ElSelect<String>(
                    key: const ValueKey<String>('home-payout-currency'),
                    options: _currencies,
                    value: _currency,
                    expand: true,
                    onChanged: (String value) => setState(() {
                      _currency = value;
                      _savedAmount = null;
                    }),
                  ),
                ),
                SizedBox(height: el(4)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: ElText('Minimum payout amount', ElType.small),
                    ),
                    ElText(_formatAmount(_amount), ElType.numLg),
                  ],
                ),
                SizedBox(height: el(2)),
                ElSlider(
                  key: const ValueKey<String>('home-payout-slider'),
                  values: <double>[_amount],
                  min: 50,
                  max: 10000,
                  step: 50,
                  label: 'Minimum payout amount',
                  onChanged: (List<double> next) => setState(() {
                    _amount = next.first;
                    _savedAmount = null;
                  }),
                ),
                SizedBox(height: el(2)),
                Row(
                  children: <Widget>[
                    ElText(
                      '\$50 (min)',
                      ElType.caption,
                      color: theme.mutedForeground,
                    ),
                    const Spacer(),
                    ElText(
                      '\$10,000 (max)',
                      ElType.caption,
                      color: theme.mutedForeground,
                    ),
                  ],
                ),
                SizedBox(height: el(4)),
                ElField(
                  label: 'Notes',
                  child: ElTextarea(
                    key: const ValueKey<String>('home-payout-notes'),
                    controller: _notes,
                    placeholder: 'Add any notes for this payout',
                    onChanged: (_) {
                      if (_savedAmount != null) {
                        setState(() => _savedAmount = null);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          ElCardFooter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (savedAmount != null) ...<Widget>[
                  ElText(
                    'Threshold saved at ${_formatAmount(savedAmount)}.',
                    ElType.small,
                    color: theme.mutedForeground,
                  ),
                  SizedBox(height: el(3)),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ElButton(
                      key: const ValueKey<String>('home-payout-reset'),
                      variant: ElButtonVariant.ghost,
                      onPressed: _saving ? null : _reset,
                      child: const Text('Reset'),
                    ),
                    SizedBox(width: el(2)),
                    ElButton(
                      key: const ValueKey<String>('home-payout-save'),
                      loading: _saving,
                      onPressed: _saving ? null : _save,
                      child: const Text('Save threshold'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
