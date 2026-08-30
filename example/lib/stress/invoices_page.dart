/// Invoices and billing.
///
/// Two regions that load, fail and recover independently: the summary can
/// succeed while the list fails, and the reverse. One write path, "Pay now",
/// carries submitting, success and failure, and cannot be submitted twice.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Form,
        FormField,
        Icon,
        OverlayPortal,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;

import 'stress_error.dart';
import 'stress_feedback.dart';
import 'stress_repository.dart';
import 'stress_state.dart';
import 'stress_ui.dart';

/// The status filter. `all` is the unfiltered case, which is what separates an
/// empty account from an over-filtered list.
enum InvoiceFilter { all, paid, due, pastDue }

extension on InvoiceFilter {
  String get label => switch (this) {
    InvoiceFilter.all => 'All invoices',
    InvoiceFilter.paid => 'Paid',
    InvoiceFilter.due => 'Due',
    InvoiceFilter.pastDue => 'Past due',
  };

  bool get isActive => this != InvoiceFilter.all;
}

extension InvoiceStatusPresentation on InvoiceStatus {
  /// Never color alone: the word travels with the color, everywhere.
  String get label => switch (this) {
    InvoiceStatus.paid => 'Paid',
    InvoiceStatus.due => 'Due',
    InvoiceStatus.pastDue => 'Past due',
    InvoiceStatus.draft => 'Draft',
  };

  BadgeVariant get variant => switch (this) {
    InvoiceStatus.paid => BadgeVariant.secondary,
    InvoiceStatus.due => BadgeVariant.outline,
    InvoiceStatus.pastDue => BadgeVariant.destructive,
    InvoiceStatus.draft => BadgeVariant.outline,
  };

  IconGlyph get glyph => switch (this) {
    InvoiceStatus.paid => IconGlyph.circleCheck,
    InvoiceStatus.due => IconGlyph.clock,
    InvoiceStatus.pastDue => IconGlyph.alertTriangle,
    InvoiceStatus.draft => IconGlyph.filter,
  };
}

class InvoicesPage extends StatefulWidget {
  const InvoicesPage({super.key, required this.repository});

  final StressRepository repository;

  @override
  State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  UiState<BillingSummary> _summary = const UiState<BillingSummary>.idle();
  UiState<List<Invoice>> _invoices = const UiState<List<Invoice>>.idle();
  InvoiceFilter _filter = InvoiceFilter.all;

  /// Keyed by invoice number so two rows cannot share one busy state.
  final Map<String, SubmitState> _payments = <String, SubmitState>{};

  @override
  void initState() {
    super.initState();
    _loadSummary();
    _loadInvoices();
  }

  Future<void> _loadSummary({bool refresh = false}) async {
    final BillingSummary? current = _summary.dataOrNull;
    setState(() {
      _summary = refresh && current != null
          ? UiState<BillingSummary>.refreshing(current)
          : const UiState<BillingSummary>.loading();
    });
    try {
      final BillingSummary data = await widget.repository.summary();
      if (!mounted) return;
      setState(() => _summary = UiState<BillingSummary>.ready(data));
    } on Object catch (error) {
      if (!mounted) return;
      setState(
        () => _summary = UiState<BillingSummary>.failed(
          AppError.from(error),
          stale: current,
        ),
      );
    }
  }

  Future<void> _loadInvoices({bool refresh = false}) async {
    final List<Invoice>? current = _invoices.dataOrNull;
    setState(() {
      _invoices = refresh && current != null
          ? UiState<List<Invoice>>.refreshing(current)
          : const UiState<List<Invoice>>.loading();
    });
    try {
      final List<Invoice> items = await widget.repository.invoices(
        filtered: _filter.isActive,
      );
      if (!mounted) return;
      setState(
        () => _invoices = collectionState<Invoice>(
          items,
          filtered: _filter.isActive,
        ),
      );
      announce(
        context,
        items.isEmpty ? 'No invoices' : '${items.length} invoices',
      );
    } on Object catch (error) {
      if (!mounted) return;
      setState(
        () => _invoices = UiState<List<Invoice>>.failed(
          AppError.from(error),
          stale: current,
        ),
      );
    }
  }

  void _setFilter(InvoiceFilter next) {
    if (next == _filter) return;
    setState(() => _filter = next);
    _loadInvoices(refresh: true);
  }

  SubmitState _paymentOf(String number) =>
      _payments[number] ?? SubmitState.idle;

  Future<void> _pay(Invoice invoice) async {
    // No double submit: the guard is the state, not a disabled paint.
    if (!_paymentOf(invoice.number).canSubmit) return;
    setState(() => _payments[invoice.number] = SubmitState.submitting);
    try {
      await widget.repository.pay(invoice.number);
      if (!mounted) return;
      setState(() => _payments[invoice.number] = SubmitState.succeeded);
      StressFeedback.of(context).success(
        'Invoice ${invoice.number} paid',
        description: 'Your receipt is on its way to you.',
      );
      announce(context, 'Invoice ${invoice.number} paid');
      await _loadSummary(refresh: true);
      await _loadInvoices(refresh: true);
    } on Object catch (error) {
      if (!mounted) return;
      final AppError failure = AppError.from(error);
      setState(() => _payments[invoice.number] = SubmitState.failed);
      if (failure.isSilent) return;
      // A declined card is a decision, not a retry, so it lands inline on the
      // row rather than in a toast that disappears.
      setState(() => _paymentFailures[invoice.number] = failure);
      announce(context, failure.title);
    }
  }

  final Map<String, AppError> _paymentFailures = <String, AppError>{};

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool wide = constraints.maxWidth >= Breakpoints.md;
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: space(wide ? 6 : 4)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // The header renders in every state, including while both
                // regions are loading and while both have failed.
                _Header(wide: wide, onRefresh: () {
                  _loadSummary(refresh: true);
                  _loadInvoices(refresh: true);
                }),
                Expanded(
                  // Not ScrollArea: it wraps its child in an IntrinsicWidth,
                  // which lets a wide table size past the viewport and puts
                  // the right-hand controls out of reach.
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _SummaryRegion(
                          state: _summary,
                          // Computed here, above the ScrollArea: its
                          // IntrinsicWidth cannot contain a LayoutBuilder.
                          figuresInRow:
                              constraints.maxWidth >= Breakpoints.sm,
                          onRetry: () => _loadSummary(refresh: true),
                        ),
                        SizedBox(height: space(6)),
                        _InvoicesRegion(
                          state: _invoices,
                          filter: _filter,
                          wide: wide,
                          paymentOf: _paymentOf,
                          failureOf: (String number) =>
                              _paymentFailures[number],
                          onFilterChanged: _setFilter,
                          onRetry: () => _loadInvoices(refresh: true),
                          onPay: _pay,
                        ),
                        // Clears the compact dock and the home indicator.
                        SizedBox(height: space(10)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.wide, required this.onRefresh});

  final bool wide;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: space(5)),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StyledText('Billing', TextStyles.h2),
              StyledText(
                'Invoices, payment method, and what is due next.',
                TextStyles.small,
              ),
            ],
          ),
        ),
        Button(
          variant: ButtonVariant.outline,
          size: wide ? ButtonSize.md : ButtonSize.sm,
          onPressed: onRefresh,
          label: 'Refresh billing',
          child: const Icon(IconGlyph.refreshCw),
        ),
      ],
    ),
  );
}

/* ── Summary ─────────────────────────────────────────────────────────────── */

class _SummaryRegion extends StatelessWidget {
  const _SummaryRegion({
    required this.state,
    required this.figuresInRow,
    required this.onRetry,
  });

  final UiState<BillingSummary> state;
  final bool figuresInRow;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Card(
    children: <Widget>[
      const CardHeader(
        title: CardTitle('This billing period'),
        description: CardDescription('What is owed and when it is taken.'),
      ),
      CardContent(child: _body(context)),
    ],
  );

  Widget _body(BuildContext context) => switch (state) {
    UiIdle<BillingSummary>() ||
    UiLoading<BillingSummary>() => const RegionSkeleton(rows: 2),
    UiRefreshing<BillingSummary>(:final BillingSummary data) => _Figures(
      summary: data,
      inRow: figuresInRow,
      refreshing: true,
    ),
    UiReady<BillingSummary>(:final BillingSummary data) => _Figures(
      summary: data,
      inRow: figuresInRow,
    ),
    // A summary is one record: there is no filtered case, and an account with
    // no billing at all reads as an empty state, not an error.
    UiEmpty<BillingSummary>() ||
    UiNoResults<BillingSummary>() => RegionEmpty(
      glyph: IconGlyph.creditCard,
      title: 'No billing yet',
      description: 'Add a payment method to start a billing period.',
      actionLabel: 'Add payment method',
      onAction: onRetry,
    ),
    UiFailed<BillingSummary>(
      :final AppError error,
      :final BillingSummary? stale,
    ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          RegionFailure(error: error, onRetry: onRetry),
          if (stale != null) ...<Widget>[
            SizedBox(height: space(4)),
            _Figures(summary: stale, inRow: figuresInRow, stale: true),
          ],
        ],
      ),
  };
}

class _Figures extends StatelessWidget {
  const _Figures({
    required this.summary,
    required this.inRow,
    this.refreshing = false,
    this.stale = false,
  });

  final BillingSummary summary;

  /// Three across when there is room, stacked when there is not. Decided by
  /// the page, because a LayoutBuilder cannot live inside a ScrollArea.
  final bool inRow;

  final bool refreshing;
  final bool stale;

  @override
  Widget build(BuildContext context) {
    final List<Widget> figures = <Widget>[
      Stat(
        label: 'Amount due',
        value: summary.amountDue,
        hint: stale ? 'Last known figure' : null,
      ),
      Stat(label: 'Next charge', value: summary.nextCharge),
      Stat(label: 'Payment method', value: summary.paymentMethod),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (refreshing)
          Padding(
            padding: EdgeInsets.only(bottom: space(3)),
            child: Row(
              children: <Widget>[
                Spinner(size: space(4)),
                SizedBox(width: space(2)),
                StyledText('Updating', TextStyles.caption),
              ],
            ),
          ),
        if (inRow)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for (int i = 0; i < figures.length; i++) ...<Widget>[
                if (i > 0) SizedBox(width: space(6)),
                Expanded(child: figures[i]),
              ],
            ],
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              for (int i = 0; i < figures.length; i++) ...<Widget>[
                if (i > 0) SizedBox(height: space(4)),
                figures[i],
              ],
            ],
          ),
      ],
    );
  }
}

/* ── Invoices ────────────────────────────────────────────────────────────── */

class _InvoicesRegion extends StatelessWidget {
  const _InvoicesRegion({
    required this.state,
    required this.filter,
    required this.wide,
    required this.paymentOf,
    required this.failureOf,
    required this.onFilterChanged,
    required this.onRetry,
    required this.onPay,
  });

  final UiState<List<Invoice>> state;
  final InvoiceFilter filter;
  final bool wide;
  final SubmitState Function(String) paymentOf;
  final AppError? Function(String) failureOf;
  final ValueChanged<InvoiceFilter> onFilterChanged;
  final VoidCallback onRetry;
  final ValueChanged<Invoice> onPay;

  bool get _loadingFirstTime =>
      state is UiIdle<List<Invoice>> || state is UiLoading<List<Invoice>>;

  @override
  Widget build(BuildContext context) => Card(
    children: <Widget>[
      CardHeader(
        title: const CardTitle('Invoices'),
        description: const CardDescription('Every invoice on this account.'),
        action: _Filters(
          filter: filter,
          wide: wide,
          // Disabled during the first load, not hidden: the toolbar is
          // structure and structure does not flicker.
          enabled: !_loadingFirstTime,
          onChanged: onFilterChanged,
        ),
      ),
      CardContent(child: _body(context)),
    ],
  );

  Widget _body(BuildContext context) => switch (state) {
    UiIdle<List<Invoice>>() || UiLoading<List<Invoice>>() =>
      const RegionSkeleton(),

    UiRefreshing<List<Invoice>>(:final List<Invoice> data) => _List(
      invoices: data,
      wide: wide,
      refreshing: true,
      paymentOf: paymentOf,
      failureOf: failureOf,
      onPay: onPay,
    ),

    UiReady<List<Invoice>>(:final List<Invoice> data) => _List(
      invoices: data,
      wide: wide,
      paymentOf: paymentOf,
      failureOf: failureOf,
      onPay: onPay,
    ),

    UiEmpty<List<Invoice>>() => RegionEmpty(
      glyph: IconGlyph.wallet,
      title: 'No invoices yet',
      description: 'Invoices appear here at the end of each billing period.',
      actionLabel: 'Read about billing',
      onAction: onRetry,
    ),

    // A different state, different words, and a way back rather than a way
    // forward.
    UiNoResults<List<Invoice>>() => RegionEmpty(
      glyph: IconGlyph.search,
      title: 'No invoices match this filter',
      description: 'Nothing on this account has that status right now.',
      actionLabel: 'Clear filter',
      actionVariant: ButtonVariant.outline,
      onAction: () => onFilterChanged(InvoiceFilter.all),
    ),

    UiFailed<List<Invoice>>(
      :final AppError error,
      :final List<Invoice>? stale,
    ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          RegionFailure(error: error, onRetry: onRetry),
          if (stale != null && stale.isNotEmpty) ...<Widget>[
            SizedBox(height: space(4)),
            _List(
              invoices: stale,
              wide: wide,
              paymentOf: paymentOf,
              failureOf: failureOf,
              onPay: onPay,
            ),
          ],
        ],
      ),
  };
}

class _Filters extends StatelessWidget {
  const _Filters({
    required this.filter,
    required this.wide,
    required this.enabled,
    required this.onChanged,
  });

  final InvoiceFilter filter;
  final bool wide;
  final bool enabled;
  final ValueChanged<InvoiceFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    if (wide) {
      // Inline above the content.
      return Select<InvoiceFilter>(
        value: filter,
        enabled: enabled,
        label: 'Filter invoices by status',
        options: <SelectChild<InvoiceFilter>>[
          for (final InvoiceFilter option in InvoiceFilter.values)
            SelectOption<InvoiceFilter>(
              value: option,
              label: option.label,
            ),
        ],
        onChanged: (InvoiceFilter? next) {
          if (next != null) onChanged(next);
        },
      );
    }

    // Narrow: one control, and the active count is visible on it.
    return SheetOverlay(
      side: SheetSide.bottom,
      trigger: (BuildContext context, VoidCallback open) => Button(
        variant: ButtonVariant.outline,
        size: ButtonSize.sm,
        onPressed: enabled ? open : null,
        label: filter.isActive
            ? 'Filter invoices, 1 active'
            : 'Filter invoices',
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(IconGlyph.filter, size: IconSize.sm),
            SizedBox(width: space(2)),
            StyledText('Filter', TextStyles.buttonLabelSm),
            if (filter.isActive) ...<Widget>[
              SizedBox(width: space(2)),
              const Badge(label: '1'),
            ],
          ],
        ),
      ),
      content: (BuildContext context, VoidCallback close) => SheetContent(
        side: SheetSide.bottom,
        onClose: close,
        children: <Widget>[
          const SheetHeader(
            children: <Widget>[
              SheetTitle('Filter invoices'),
              SheetDescription('Show only invoices with one status.'),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(space(4)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                for (final InvoiceFilter option in InvoiceFilter.values)
                  Padding(
                    padding: EdgeInsets.only(bottom: space(2)),
                    child: Button(
                      variant: option == filter
                          ? ButtonVariant.secondary
                          : ButtonVariant.ghost,
                      expanded: true,
                      onPressed: () {
                        onChanged(option);
                        close();
                      },
                      child: StyledText(option.label, TextStyles.buttonLabel),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _List extends StatelessWidget {
  const _List({
    required this.invoices,
    required this.wide,
    required this.paymentOf,
    required this.failureOf,
    required this.onPay,
    this.refreshing = false,
  });

  final List<Invoice> invoices;
  final bool wide;
  final bool refreshing;
  final SubmitState Function(String) paymentOf;
  final AppError? Function(String) failureOf;
  final ValueChanged<Invoice> onPay;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      if (refreshing)
        Padding(
          padding: EdgeInsets.only(bottom: space(3)),
          child: Row(
            children: <Widget>[
              Spinner(size: space(4)),
              SizedBox(width: space(2)),
              StyledText('Updating invoices', TextStyles.caption),
            ],
          ),
        ),
      if (wide) _table(context) else _stack(context),
    ],
  );

  Widget _table(BuildContext context) => Table(
    caption: 'Invoices on this account',
    header: <TableCellSpec>[
      TableCellSpec(child: StyledText('Invoice', TextStyles.tableHead)),
      TableCellSpec(child: StyledText('Issued', TextStyles.tableHead)),
      TableCellSpec(
        align: TableAlign.end,
        child: StyledText('Amount', TextStyles.tableHead),
      ),
      TableCellSpec(child: StyledText('Status', TextStyles.tableHead)),
      TableCellSpec(
        align: TableAlign.end,
        child: StyledText('Actions', TextStyles.tableHead),
      ),
    ],
    rows: <TableRowSpec>[
      for (final Invoice invoice in invoices)
        TableRowSpec(
          cells: <TableCellSpec>[
            TableCellSpec(
              child: StyledText(invoice.number, TextStyles.identifier),
            ),
            TableCellSpec(child: StyledText(invoice.issued, TextStyles.small)),
            TableCellSpec(
              align: TableAlign.end,
              child: StyledText(invoice.amount, TextStyles.numberSm),
            ),
            TableCellSpec(child: _StatusBadge(status: invoice.status)),
            TableCellSpec(
              align: TableAlign.end,
              child: _RowActions(
                invoice: invoice,
                submit: paymentOf(invoice.number),
                onPay: onPay,
              ),
            ),
          ],
        ),
    ],
  );

  /// Narrow rows carry only what a person scans for: number, amount, status.
  Widget _stack(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      for (final Invoice invoice in invoices) ...<Widget>[
        Item(
          content: ItemContent(
            children: <Widget>[
              ItemTitle(invoice.number),
              ItemDescription(invoice.amount),
            ],
          ),
          actions: ItemActions(
            children: <Widget>[_StatusBadge(status: invoice.status)],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: space(3)),
          child: _RowActions(
            invoice: invoice,
            submit: paymentOf(invoice.number),
            onPay: onPay,
          ),
        ),
        if (failureOf(invoice.number) != null)
          Padding(
            padding: EdgeInsets.only(bottom: space(3)),
            child: RegionFailure(error: failureOf(invoice.number)!),
          ),
      ],
    ],
  );
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final InvoiceStatus status;

  @override
  Widget build(BuildContext context) => Badge(
    label: status.label,
    glyph: Icon(status.glyph, size: IconSize.xs),
    variant: status.variant,
  );
}

class _RowActions extends StatelessWidget {
  const _RowActions({
    required this.invoice,
    required this.submit,
    required this.onPay,
  });

  final Invoice invoice;
  final SubmitState submit;
  final ValueChanged<Invoice> onPay;

  /// The result of a download lands outside this screen, so the feedback is a
  /// toast rather than an inline change nobody would see.
  void _download(BuildContext context) {
    StressFeedback.of(context).success(
      'Downloading ${invoice.number}',
      description: 'The PDF is saving to your downloads.',
    );
  }

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Button(
        variant: ButtonVariant.ghost,
        size: ButtonSize.sm,
        onPressed: () => _download(context),
        label: 'Download invoice ${invoice.number}',
        child: const Icon(IconGlyph.download, size: IconSize.sm),
      ),
      if (invoice.status == InvoiceStatus.pastDue) ...<Widget>[
        SizedBox(width: space(2)),
        Button(
          size: ButtonSize.sm,
          loading: submit.isBusy,
          onPressed: submit.canSubmit ? () => onPay(invoice) : null,
          child: StyledText(
            submit == SubmitState.failed ? 'Try again' : 'Pay now',
            TextStyles.buttonLabelSm,
          ),
        ),
      ],
    ],
  );
}
