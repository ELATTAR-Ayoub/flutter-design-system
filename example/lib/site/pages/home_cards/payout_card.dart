/// A live payout-threshold card: a currency select, a slider-driven amount,
/// notes, and a save/reset footer, built only from real design-system components.
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

/// Defaults every field and control returns to on reset.
const String _defaultCurrency = 'usd';
const double _defaultAmount = 2500;

const List<SelectOption<String>> _currencies = <SelectOption<String>>[
  SelectOption<String>(value: 'usd', label: 'USD - United States dollar'),
  SelectOption<String>(value: 'eur', label: 'EUR - Euro'),
  SelectOption<String>(value: 'gbp', label: 'GBP - Pound sterling'),
  SelectOption<String>(value: 'jpy', label: 'JPY - Japanese yen'),
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
    await Future<void>.delayed(MotionDurations.slow);
    if (!mounted) return;
    setState(() {
      _saving = false;
      _savedAmount = pending;
    });
  }

  /// Spread, not wrapped: [Card] reads `children.last is CardFooter` to
  /// decide whether to drop its own bottom padding, and a `Column` around the
  /// pair would hide the footer from that test and swallow the card's own
  /// inter-slot spacing.
  List<Widget> _dismissedBody(ThemeTokens theme) => <Widget>[
    CardContent(
      child: StyledText(
        'Payout settings hidden.',
        TextStyles.small,
        color: theme.mutedForeground,
      ),
    ),
    CardFooter(
      child: Button(
        key: const ValueKey<String>('home-payout-restore'),
        variant: ButtonVariant.ghost,
        onPressed: () => setState(() => _dismissed = false),
        child: const Text('Restore'),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final double? savedAmount = _savedAmount;

    return Card(
      children: <Widget>[
        CardHeader(
          title: const CardTitle('Payout threshold'),
          description: const CardDescription(
            'Set the minimum balance required before a payout is triggered.',
          ),
          action: Button(
            key: const ValueKey<String>('home-payout-dismiss'),
            variant: ButtonVariant.ghost,
            size: ButtonSize.icon,
            label: 'Dismiss payout settings',
            onPressed: () => setState(() => _dismissed = true),
            child: const Icon(IconGlyph.x, size: IconSize.sm),
          ),
        ),
        if (_dismissed)
          ..._dismissedBody(theme)
        else ...<Widget>[
          CardContent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Field(
                  label: 'Preferred currency',
                  child: Select<String>(
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
                SizedBox(height: space(4)),
                // A label/value pair, `Wrap` rather than `Row`: at a large
                // accessibility text scale the big `numberLg` figure alone
                // can outgrow the card, so the value drops to its own line
                // under the label instead of forcing the row wider than the
                // card. At ordinary widths both fit on one line, same as the
                // `Row` this replaces.
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.end,
                  runSpacing: space(1),
                  children: <Widget>[
                    StyledText('Minimum payout amount', TextStyles.small),
                    StyledText(_formatAmount(_amount), TextStyles.numberLg),
                  ],
                ),
                SizedBox(height: space(2)),
                Slider(
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
                SizedBox(height: space(2)),
                // `Wrap`, not `Row` + `Spacer`: at 200% text scale the two
                // labels alone can exceed the card's width, and a `Spacer`
                // gives nothing back when that happens. `Wrap` keeps them on
                // one line whenever there is room and drops the second to
                // its own line otherwise.
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  runSpacing: space(1),
                  children: <Widget>[
                    StyledText(
                      '\$50 (min)',
                      TextStyles.small,
                      color: theme.mutedForeground,
                    ),
                    StyledText(
                      '\$10,000 (max)',
                      TextStyles.small,
                      color: theme.mutedForeground,
                    ),
                  ],
                ),
                SizedBox(height: space(4)),
                Field(
                  label: 'Notes',
                  child: Textarea(
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
          CardFooter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (savedAmount != null) ...<Widget>[
                  StyledText(
                    'Threshold saved at ${_formatAmount(savedAmount)}.',
                    TextStyles.small,
                    color: theme.mutedForeground,
                  ),
                  SizedBox(height: space(3)),
                ],
                // The actions wrap rather than clip: two labels at a large
                // text scale do not share one line on a phone.
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: space(2),
                  runSpacing: space(2),
                  children: <Widget>[
                    Button(
                      key: const ValueKey<String>('home-payout-reset'),
                      variant: ButtonVariant.ghost,
                      onPressed: _saving ? null : _reset,
                      child: const Text('Reset'),
                    ),
                    Button(
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
