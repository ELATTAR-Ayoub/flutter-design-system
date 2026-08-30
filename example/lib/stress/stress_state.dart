/// The sealed read/write state model the UI director prescribes.
///
/// Copied from `skills/elattar-flutter-ui-director/templates/ui-state.md`.
/// It is product code: no widgets, no design-system imports, and it ships with
/// the app rather than the package.
library;

import 'stress_error.dart';

/// Every asynchronous surface is in exactly one of these.
///
/// `loading` and `refreshing` differ by whether data is already on screen.
/// `empty` and `noResults` differ by whether a filter caused it. Both
/// distinctions decide what the user sees, so neither may be collapsed.
sealed class UiState<T> {
  const UiState();

  const factory UiState.idle() = UiIdle<T>;
  const factory UiState.loading() = UiLoading<T>;
  const factory UiState.refreshing(T data) = UiRefreshing<T>;
  const factory UiState.ready(T data, {bool loadingMore}) = UiReady<T>;
  const factory UiState.empty() = UiEmpty<T>;
  const factory UiState.noResults() = UiNoResults<T>;
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

/// Collapses a successful collection response into a state.
///
/// Doing it here rather than in a widget is what stops a `data` branch from
/// rendering an empty list as a blank panel.
UiState<List<T>> collectionState<T>(
  List<T> items, {
  required bool filtered,
}) {
  if (items.isNotEmpty) return UiState<List<T>>.ready(items);
  return filtered ? UiState<List<T>>.noResults() : UiState<List<T>>.empty();
}

/// Writes, not reads.
enum SubmitState { idle, submitting, succeeded, failed }

extension SubmitStateX on SubmitState {
  bool get isBusy => this == SubmitState.submitting;

  /// Guard every submit handler with this so a second press cannot fire.
  bool get canSubmit => this != SubmitState.submitting;
}
