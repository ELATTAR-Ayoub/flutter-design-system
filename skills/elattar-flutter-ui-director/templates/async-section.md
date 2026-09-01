# Template: an async section

One region, every state, no missing branch. Copy this shape for any part of a
page that reads data. Paths and imports are repository mode; translate through
[system-map.md](../references/system-map.md) in consumer mode.

Glyph names below are real members of `IconGlyph`. Pick the one that fits your
domain rather than reusing these.

```dart
import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart' hide Icon, SafeArea;

import '../ui/app_error.dart';
import '../ui/ui_state.dart';

/// A section owns its own states. A failure here never blanks the page.
class InvoicesSection extends StatelessWidget {
  const InvoicesSection({
    super.key,
    required this.state,
    required this.filtered,
    required this.onRetry,
    required this.onClearFilters,
    required this.onCreate,
  });

  final UiState<List<Invoice>> state;

  /// Decides between the empty and the no results wording.
  final bool filtered;

  final VoidCallback onRetry;
  final VoidCallback onClearFilters;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    // The heading and frame render in every state, so the page does not
    // reflow when data arrives.
    return Card(
      children: <Widget>[
        const CardHeader(
          title: CardTitle('Invoices'),
          description: CardDescription('Everything billed this month.'),
        ),
        CardContent(child: _body(context)),
      ],
    );
  }

  Widget _body(BuildContext context) => switch (state) {
    UiIdle<List<Invoice>>() || UiLoading<List<Invoice>>() => const _Skeleton(),

    // Refreshing keeps the rows on screen. It never swaps back to skeletons.
    UiRefreshing<List<Invoice>>(:final List<Invoice> data) => _List(
      items: data,
      refreshing: true,
    ),

    UiReady<List<Invoice>>(:final List<Invoice> data, :final bool loadingMore) =>
      _List(items: data, loadingMore: loadingMore),

    UiEmpty<List<Invoice>>() => Empty(
      children: <Widget>[
        const EmptyHeader(
          children: <Widget>[
            EmptyMedia(glyph: IconGlyph.plus),
            EmptyTitle('No invoices yet'),
            EmptyDescription('Invoices appear here once a client is billed.'),
          ],
        ),
        EmptyContent(
          children: <Widget>[
            Button(
              onPressed: onCreate,
              child: const StyledText('Create invoice', TextStyles.nav),
            ),
          ],
        ),
      ],
    ),

    // A different state, different copy, and a different way out.
    UiNoResults<List<Invoice>>() => Empty(
      children: <Widget>[
        const EmptyHeader(
          children: <Widget>[
            EmptyMedia(glyph: IconGlyph.search),
            EmptyTitle('No invoices match these filters'),
            EmptyDescription('Try a wider date range, or clear the filters.'),
          ],
        ),
        EmptyContent(
          children: <Widget>[
            Button(
              variant: ButtonVariant.outline,
              onPressed: onClearFilters,
              child: const StyledText('Clear filters', TextStyles.nav),
            ),
          ],
        ),
      ],
    ),

    UiFailed<List<Invoice>>(:final AppError error, :final List<Invoice>? stale) =>
      _Failed(error: error, stale: stale, onRetry: onRetry),
  };
}

/// Skeletons take the shape of the real rows, so nothing jumps on arrival.
class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      for (int i = 0; i < 5; i++)
        Padding(
          padding: EdgeInsets.only(bottom: space(2)),
          child: Skeleton(height: space(12)),
        ),
    ],
  );
}

class _Failed extends StatelessWidget {
  const _Failed({required this.error, required this.stale, required this.onRetry});

  final AppError error;
  final List<Invoice>? stale;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (error.channel == ErrorChannel.silent) return const SizedBox.shrink();
    final Widget alert = Alert(
      title: error.title,
      description: error.body,
      variant: error.kind == ErrorKind.offline
          ? AlertVariant.warning
          : AlertVariant.destructive,
      action: error.retryable
          ? Button(
              variant: ButtonVariant.outline,
              size: ButtonSize.sm,
              onPressed: onRetry,
              child: StyledText(error.nextStep, TextStyles.small),
            )
          : null,
    );
    // Keep stale data visible where that is honest, with the warning above it.
    final List<Invoice>? kept = stale;
    if (kept == null || kept.isEmpty) return alert;
    return Column(
      children: <Widget>[
        alert,
        SizedBox(height: space(3)),
        _List(items: kept),
      ],
    );
  }
}
```

## What this template is demonstrating

- Every variant of `UiState` has a branch. The switch is exhaustive, so adding a
  state is a compile error rather than a blank screen.
- The heading and frame render in every state.
- `empty` and `noResults` have different copy and different actions.
- Failure keeps stale data where that is honest, and always offers the retry.
- Skeletons take the shape of the content they replace.
- Nothing here builds a string from an exception.
