/// A live card built only from real `El*` components: a claimable balance
/// with a claim flow that flips the figure, the badge and the footer once it
/// resolves.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

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
    await Future<void>.delayed(ElDurations.slow);
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

    return ElCard(
      children: <Widget>[
        const ElCardHeader(
          title: ElCardTitle('Claimable balance'),
          description: ElCardDescription(
            'Royalties cleared and ready to withdraw.',
          ),
        ),
        ElCardContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElText(figure, ElType.numLg),
              SizedBox(height: el(2)),
              // The Column stretches, and a stretched badge is a full-width
              // lozenge; Align gives it back its own intrinsic width.
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: ElBadge(
                  label: _claimed ? 'Claimed' : 'Pending setup',
                  variant: _claimed
                      ? ElBadgeVariant.success
                      : ElBadgeVariant.primary,
                ),
              ),
              SizedBox(height: el(4)),
              ElTable(
                header: const <ElTableCellSpec>[
                  ElTableCellSpec(child: Text('Line item')),
                  ElTableCellSpec(
                    child: Text('Amount'),
                    align: ElTableAlign.end,
                  ),
                ],
                rows: <ElTableRowSpec>[
                  for (final _BalanceLine line in _balanceLines)
                    ElTableRowSpec(
                      cells: <ElTableCellSpec>[
                        ElTableCellSpec(child: Text(line.label)),
                        ElTableCellSpec(
                          child: Text(line.amount),
                          align: ElTableAlign.end,
                        ),
                      ],
                    ),
                  ElTableRowSpec(
                    cells: <ElTableCellSpec>[
                      const ElTableCellSpec(
                        child: Text('Total ready to claim'),
                      ),
                      ElTableCellSpec(
                        child: Text(total),
                        align: ElTableAlign.end,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        ElCardFooter(
          child: _claimed
              ? ElButton(
                  key: const ValueKey<String>('home-balance-restart'),
                  variant: ElButtonVariant.ghost,
                  contentAlignment: AlignmentDirectional.center,
                  onPressed: _reset,
                  child: const Text('Start another claim'),
                )
              : ElButton(
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
