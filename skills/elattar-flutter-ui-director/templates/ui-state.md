# Template: `UiState`

Copy into product code once per app, for example `lib/ui/ui_state.dart`. This is
product code, not a system component: it holds no widgets and ships with the
app, not the package.

```dart
import 'app_error.dart';

/// Every asynchronous surface is in exactly one of these.
///
/// `loading` and `refreshing` differ by whether data is already on screen.
/// `empty` and `noResults` differ by whether a filter caused it. Both
/// distinctions decide what the user sees, so neither may be collapsed.
sealed class UiState<T> {
  const UiState();

  /// Nothing requested yet.
  const factory UiState.idle() = UiIdle<T>;

  /// First load. No previous data.
  const factory UiState.loading() = UiLoading<T>;

  /// Reloading with data already on screen.
  const factory UiState.refreshing(T data) = UiRefreshing<T>;

  /// Data present and non empty.
  const factory UiState.ready(T data, {bool loadingMore}) = UiReady<T>;

  /// Succeeded, and legitimately nothing exists yet.
  const factory UiState.empty() = UiEmpty<T>;

  /// Succeeded, and a filter or search removed everything.
  const factory UiState.noResults() = UiNoResults<T>;

  /// Failed. Never carries a raw exception.
  const factory UiState.failed(AppError error, {T? stale}) = UiFailed<T>;

  /// The data to paint, if any. Non null while refreshing and while showing a
  /// failure over stale data.
  T? get dataOrNull => switch (this) {
    UiRefreshing<T>(:final T data) => data,
    UiReady<T>(:final T data) => data,
    UiFailed<T>(:final T? stale) => stale,
    _ => null,
  };
}

final class UiIdle<T> extends UiState<T> {
  const UiIdle();
}

final class UiLoading<T> extends UiState<T> {
  const UiLoading();
}

final class UiRefreshing<T> extends UiState<T> {
  const UiRefreshing(this.data);
  final T data;
}

final class UiReady<T> extends UiState<T> {
  const UiReady(this.data, {this.loadingMore = false});
  final T data;

  /// Appending the next page. The rows already on screen do not move.
  final bool loadingMore;
}

final class UiEmpty<T> extends UiState<T> {
  const UiEmpty();
}

final class UiNoResults<T> extends UiState<T> {
  const UiNoResults();
}

final class UiFailed<T> extends UiState<T> {
  const UiFailed(this.error, {this.stale});
  final AppError error;

  /// Data from a previous successful load, kept visible where that is honest.
  final T? stale;
}

/// Writes, not reads.
enum SubmitState { idle, submitting, succeeded, failed }

extension SubmitStateX on SubmitState {
  bool get isBusy => this == SubmitState.submitting;

  /// Guard every submit handler with this so a second press cannot fire.
  bool get canSubmit => this != SubmitState.submitting;
}
```

## Choosing the variant

Collapse a successful list response into a state at the boundary, never in the
widget:

```dart
UiState<List<Invoice>> toState(
  List<Invoice> items, {
  required bool filtered,
  T? previous,
}) {
  if (items.isNotEmpty) return UiState.ready(items);
  return filtered ? const UiState.noResults() : const UiState.empty();
}
```

## Mapping from Bloc or Riverpod

Keep your container and map into these variants at the edge of the widget layer.

```dart
UiState<List<Invoice>> fromAsync(
  AsyncValue<List<Invoice>> value, {
  required bool filtered,
}) => value.when(
  loading: () => value.hasValue
      ? UiState.refreshing(value.requireValue)
      : const UiState.loading(),
  data: (List<Invoice> items) => toState(items, filtered: filtered),
  error: (Object e, StackTrace s) =>
      UiState.failed(AppError.from(e, s), stale: value.valueOrNull),
);
```

The split is the point. A `data` branch that renders a list without checking for
empty, and a `loading` branch that blanks existing data, are the two defects
this model exists to prevent.
