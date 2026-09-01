# Template: a page

The frame, header, and toolbar render in every state. Only the content regions
swap. Repository mode imports; translate in consumer mode.

```dart
import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart' hide Icon, SafeArea;

class InvoicesPage extends StatefulWidget {
  const InvoicesPage({super.key});

  @override
  State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  UiState<List<Invoice>> _invoices = const UiState<List<Invoice>>.idle();
  InvoiceFilters _filters = const InvoiceFilters();
  SubmitState _create = SubmitState.idle;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool refresh = false}) async {
    final List<Invoice>? current = _invoices.dataOrNull;
    setState(() {
      _invoices = refresh && current != null
          ? UiState<List<Invoice>>.refreshing(current)
          : const UiState<List<Invoice>>.loading();
    });
    try {
      final List<Invoice> items = await repository.invoices(_filters);
      if (!mounted) return;
      setState(() {
        _invoices = items.isNotEmpty
            ? UiState<List<Invoice>>.ready(items)
            : _filters.isActive
                ? const UiState<List<Invoice>>.noResults()
                : const UiState<List<Invoice>>.empty();
      });
      // Announce the result count for assistive technology.
      announceCount(context, items.length);
    } catch (error, stack) {
      if (!mounted) return;
      setState(() {
        _invoices = UiState<List<Invoice>>.failed(
          AppError.from(error, stack),
          stale: current,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool narrow = MediaQuery.sizeOf(context).width < Breakpoints.md;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Header: from route state, never from the request. Renders in
          // every state, including loading and failure.
          _Header(
            onCreate: _create.canSubmit ? _createInvoice : null,
            busy: _create.isBusy,
          ),

          // Toolbar: disabled during first load, never hidden.
          _Filters(
            filters: _filters,
            enabled: _invoices is! UiLoading<List<Invoice>>,
            narrow: narrow,
            onChanged: (InvoiceFilters next) {
              setState(() => _filters = next);
              _load(refresh: true);
            },
          ),

          Expanded(
            child: ScrollArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Each region owns its own states.
                  InvoicesSection(
                    state: _invoices,
                    filtered: _filters.isActive,
                    onRetry: () => _load(refresh: true),
                    onClearFilters: () {
                      setState(() => _filters = const InvoiceFilters());
                      _load(refresh: true);
                    },
                    onCreate: _createInvoice,
                  ),
                  SizedBox(height: space(4)),
                  // A second region fails independently of the first.
                  const OverdueSummarySection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createInvoice() async {
    if (!_create.canSubmit) return; // no double submit
    setState(() => _create = SubmitState.submitting);
    try {
      final Invoice created = await repository.create();
      if (!mounted) return;
      setState(() => _create = SubmitState.succeeded);
      // Feedback: the result is off screen, so it is a toast with undo.
      ToastScope.of(context).success(
        'Invoice ${created.number} created',
        action: ToastAction(
          label: 'Undo',
          onPressed: () => repository.delete(created.id),
        ),
      );
      await _load(refresh: true);
    } catch (error, stack) {
      if (!mounted) return;
      final AppError failure = AppError.from(error, stack);
      setState(() => _create = SubmitState.failed);
      if (failure.channel == ErrorChannel.silent) return;
      ToastScope.of(context).error(
        failure.title,
        description: failure.body,
        action: failure.retryable
            ? ToastAction(label: 'Retry', onPressed: _createInvoice)
            : null,
      );
    }
  }
}
```

## Page level failure

Only when the page cannot render at all: an invalid route parameter, a deleted
record, or missing access. Navigation stays reachable and there is a way back.

```dart
Widget pageLevelFailure(BuildContext context, AppError error) => Empty(
  children: <Widget>[
    EmptyHeader(
      children: <Widget>[
        EmptyMedia(
          glyph: error.kind == ErrorKind.forbidden
              ? IconGlyph.lock
              : IconGlyph.search,
        ),
        EmptyTitle(error.title),
        if (error.body != null) EmptyDescription(error.body!),
      ],
    ),
    EmptyContent(
      children: <Widget>[
        Button(
          variant: ButtonVariant.outline,
          onPressed: () => Navigator.of(context).maybePop(),
          child: StyledText(error.nextStep, TextStyles.nav),
        ),
      ],
    ),
  ],
);
```

## App root

One `Toaster` and one `ToastController` for the whole app, mounted above the
routes. `ToastScope` here is your own inherited widget over that single
controller: do not create a controller per page.

## What this template is demonstrating

- Frame, header, and toolbar are outside every state branch.
- Two regions fail independently.
- Filters disable during first load rather than disappearing.
- The create action cannot be submitted twice, and it toasts with undo.
- Failures are mapped at the boundary, never formatted in the widget.
- A result count is announced after a filter change.
- Narrow and wide differ in structure, decided by `Breakpoints`.
