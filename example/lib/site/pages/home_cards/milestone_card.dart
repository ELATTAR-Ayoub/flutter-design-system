/// A savings-goal card: a name, a target amount, a target date, and a submit
/// that paces the goal once the form is valid.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/material.dart';

/// A milestone-setting form, built the same way as the home grid's other live
/// cards: real state, real validation, real components.
class MilestoneCard extends StatefulWidget {
  const MilestoneCard({super.key});

  @override
  State<MilestoneCard> createState() => _MilestoneCardState();
}

class _MilestoneCardState extends State<MilestoneCard> {
  static final List<ElRule<String>> _nameRules = <ElRule<String>>[
    ElRule.minLength(2, 'Give the goal a name.'),
  ];

  static final List<ElRule<String>> _amountRules = <ElRule<String>>[
    ElRule<String>(_isDollarAmount, 'Enter an amount in dollars.'),
  ];

  static const List<ElSelectOption<String>> _dates = <ElSelectOption<String>>[
    ElSelectOption<String>(value: 'dec-2025', label: 'Dec 2025'),
    ElSelectOption<String>(value: 'mar-2026', label: 'Mar 2026'),
    ElSelectOption<String>(value: 'jun-2026', label: 'Jun 2026'),
    ElSelectOption<String>(value: 'dec-2026', label: 'Dec 2026'),
  ];

  static bool _isDollarAmount(String value) {
    final String stripped = value
        .replaceAll(r'$', '')
        .replaceAll(',', '')
        .trim();
    if (stripped.isEmpty) return false;
    return double.tryParse(stripped) != null;
  }

  late final TextEditingController _name = TextEditingController()
    ..addListener(_onEdited);
  late final TextEditingController _amount = TextEditingController()
    ..addListener(_onEdited);
  String _date = _dates.first.value;
  bool _submitted = false;
  bool _loading = false;
  bool _created = false;

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    super.dispose();
  }

  void _onEdited() {
    if (!_created) return;
    setState(() => _created = false);
  }

  List<String> get _nameIssues => ElRules.check<String>(_name.text, _nameRules);
  List<String> get _amountIssues =>
      ElRules.check<String>(_amount.text, _amountRules);
  bool get _valid => _nameIssues.isEmpty && _amountIssues.isEmpty;

  String get _dateLabel => _dates
      .firstWhere((ElSelectOption<String> option) => option.value == _date)
      .label;

  Future<void> _create() async {
    setState(() => _submitted = true);
    if (!_valid) return;
    setState(() => _loading = true);
    await Future<void>.delayed(ElDurations.slow);
    if (!mounted) return;
    setState(() {
      _loading = false;
      _created = true;
    });
  }

  void _cancel() {
    _name.clear();
    _amount.clear();
    setState(() {
      _date = _dates.first.value;
      _submitted = false;
      _created = false;
    });
  }

  Widget _fields(BuildContext context) {
    final bool show = _submitted;
    final Widget amountField = ElField(
      label: 'Target amount',
      errors: show ? _amountIssues : const <String>[],
      enabled: !_loading,
      child: ElInput(
        key: const ValueKey<String>('home-milestone-amount'),
        controller: _amount,
        placeholder: r'$15,000',
        keyboardType: TextInputType.number,
      ),
    );
    final Widget dateField = ElField(
      label: 'Target date',
      enabled: !_loading,
      child: ElSelect<String>(
        key: const ValueKey<String>('home-milestone-date'),
        options: _dates,
        value: _date,
        expand: true,
        onChanged: (String value) => setState(() {
          _date = value;
          _created = false;
        }),
      ),
    );

    return ElFieldSet(
      children: <Widget>[
        ElField(
          label: 'Goal name',
          errors: show ? _nameIssues : const <String>[],
          enabled: !_loading,
          child: ElInput(
            key: const ValueKey<String>('home-milestone-name'),
            controller: _name,
            placeholder: 'e.g. new car, home downpayment',
          ),
        ),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth >= el(70)) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(child: amountField),
                  SizedBox(width: ElFieldSet.gap),
                  Expanded(child: dateField),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                amountField,
                SizedBox(height: ElFieldSet.gap),
                dateField,
              ],
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElCard(
      children: <Widget>[
        const ElCardHeader(
          title: ElCardTitle('Set a new milestone'),
          description: ElCardDescription(
            'Define your financial target and we will help you pace your '
            'savings.',
          ),
        ),
        ElCardContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (_created) ...<Widget>[
                ElAlert(
                  key: const ValueKey<String>('home-milestone-success'),
                  variant: ElAlertVariant.success,
                  icon: const ElIcon(ElIconGlyph.circleCheck),
                  title: '${_name.text} is on track.',
                  description: 'We will pace it to $_dateLabel.',
                ),
                SizedBox(height: ElFieldSet.gap),
              ],
              _fields(context),
            ],
          ),
        ),
        ElCardFooter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: ElButton(
                  key: const ValueKey<String>('home-milestone-create'),
                  loading: _loading,
                  contentAlignment: AlignmentDirectional.center,
                  onPressed: _loading || _created ? null : _create,
                  child: const Text('Create goal'),
                ),
              ),
              SizedBox(height: el(2)),
              SizedBox(
                width: double.infinity,
                child: ElButton(
                  key: const ValueKey<String>('home-milestone-cancel'),
                  variant: ElButtonVariant.outline,
                  contentAlignment: AlignmentDirectional.center,
                  onPressed: _loading ? null : _cancel,
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
