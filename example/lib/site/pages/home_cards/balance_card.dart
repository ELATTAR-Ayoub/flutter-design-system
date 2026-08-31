/// A live card built only from real design-system components: a claimable balance
/// with a claim flow that flips the figure, the badge and the footer once it
/// resolves.
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

@immutable
class _BalanceLine {
  const _BalanceLine({required this.label, required this.amount});

  final String label;
  final String amount;
}

const List<_BalanceLine> _balanceLines = <_BalanceLine>[
  _BalanceLine(label: 'Net royalties', amount: '\$1,248.75'),
  _BalanceLine(label: 'Processing fee', amount: '-\$37.46'),
];

const String _unclaimedFigure = '\$1,211.29';
const String _unclaimedTotal = '\$1,211.29 USD';
const String _claimedFigure = '\$0.00';
const String _claimedTotal = '\$0.00 USD';

class BalanceCard extends StatefulWidget {
  const BalanceCard({super.key});

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  bool _claiming = false;
  bool _claimed = false;

  Future<void> _claim() async {
    setState(() => _claiming = true);
    await Future<void>.delayed(MotionDurations.slow);
    if (!mounted) return;
    setState(() {
      _claiming = false;
      _claimed = true;
    });
  }

  void _reset() => setState(() => _claimed = false);

  @override
  Widget build(BuildContext context) {
    final String figure = _claimed ? _claimedFigure : _unclaimedFigure;
    final String total = _claimed ? _claimedTotal : _unclaimedTotal;

    return Card(
      children: <Widget>[
        const CardHeader(
          title: CardTitle('Claimable balance'),
          description: CardDescription(
            'Royalties cleared and ready to withdraw.',
          ),
        ),
        CardContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              StyledText(figure, TextStyles.numberLg),
              SizedBox(height: space(2)),
              // The Column stretches, and a stretched badge is a full-width
              // lozenge; Align gives it back its own intrinsic width.
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Badge(
                  label: _claimed ? 'Claimed' : 'Pending setup',
                  variant: _claimed
                      ? BadgeVariant.success
                      : BadgeVariant.primary,
                ),
              ),
              SizedBox(height: space(4)),
              Table(
                header: const <TableCellSpec>[
                  TableCellSpec(child: Text('Line item')),
                  TableCellSpec(child: Text('Amount'), align: TableAlign.end),
                ],
                rows: <TableRowSpec>[
                  for (final _BalanceLine line in _balanceLines)
                    TableRowSpec(
                      cells: <TableCellSpec>[
                        TableCellSpec(child: Text(line.label)),
                        TableCellSpec(
                          child: Text(line.amount),
                          align: TableAlign.end,
                        ),
                      ],
                    ),
                  TableRowSpec(
                    cells: <TableCellSpec>[
                      const TableCellSpec(child: Text('Total ready to claim')),
                      TableCellSpec(child: Text(total), align: TableAlign.end),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        CardFooter(
          child: _claimed
              ? Button(
                  key: const ValueKey<String>('home-balance-restart'),
                  variant: ButtonVariant.ghost,
                  contentAlignment: AlignmentDirectional.center,
                  onPressed: _reset,
                  child: const Text('Start another claim'),
                )
              : Button(
                  key: const ValueKey<String>('home-balance-claim'),
                  loading: _claiming,
                  contentAlignment: AlignmentDirectional.center,
                  onPressed: _claiming ? null : _claim,
                  child: const Text('Claim balance'),
                ),
        ),
      ],
    );
  }
}
