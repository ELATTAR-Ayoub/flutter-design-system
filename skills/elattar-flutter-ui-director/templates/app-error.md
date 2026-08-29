# Template: `AppError`

Copy into product code once per app, for example `lib/ui/app_error.dart`.
Map exceptions here, at the data boundary. No widget may build a string from an
exception.

```dart
/// The closed set of failures the UI knows how to present.
enum ErrorKind {
  offline,
  timeout,
  unauthenticated,
  forbidden,
  notFound,
  conflict,
  validation,
  rateLimited,
  server,
  cancelled,
  unknown,
}

/// Where a failure is allowed to appear. See references/errors.md.
enum ErrorChannel { field, section, action, page, dialog, silent }

/// A failure translated for a person.
///
/// [title], [body], and [nextStep] are user copy. [diagnostics] is not: it is
/// shown only behind a collapsed "Technical details" disclosure, and logged.
class AppError {
  const AppError({
    required this.kind,
    required this.title,
    required this.nextStep,
    this.body,
    this.channel = ErrorChannel.section,
    this.retryable = false,
    this.fieldErrors = const <String, String>{},
    this.retryAfter,
    this.diagnostics,
    this.correlationId,
  });

  final ErrorKind kind;
  final String title;
  final String? body;

  /// Exactly one action, phrased as a verb.
  final String nextStep;

  final ErrorChannel channel;
  final bool retryable;

  /// Field name to message, for [ErrorKind.validation].
  final Map<String, String> fieldErrors;

  /// How long until a retry is allowed, for [ErrorKind.rateLimited].
  final Duration? retryAfter;

  /// Never user copy. Logged, and revealed only on request.
  final String? diagnostics;
  final String? correlationId;

  /// The single entry point. Extend the switch with your own transport's
  /// exception types; keep the returned kinds inside [ErrorKind].
  factory AppError.from(Object error, [StackTrace? stack]) {
    // Replace these guards with your transport's real types.
    final String raw = error.toString();
    if (_isCancellation(error)) return AppError.of(ErrorKind.cancelled);
    if (_isSocketFailure(error)) {
      return AppError.of(ErrorKind.offline, diagnostics: raw);
    }
    if (_isTimeout(error)) {
      return AppError.of(ErrorKind.timeout, diagnostics: raw);
    }
    final int? status = _statusOf(error);
    if (status != null) {
      return AppError.ofStatus(status, diagnostics: raw);
    }
    return AppError.of(ErrorKind.unknown, diagnostics: raw);
  }

  factory AppError.ofStatus(int status, {String? diagnostics}) =>
      AppError.of(switch (status) {
        401 => ErrorKind.unauthenticated,
        403 => ErrorKind.forbidden,
        404 => ErrorKind.notFound,
        409 => ErrorKind.conflict,
        422 => ErrorKind.validation,
        429 => ErrorKind.rateLimited,
        >= 500 => ErrorKind.server,
        _ => ErrorKind.unknown,
      }, diagnostics: diagnostics);

  /// The copy table from references/errors.md. Adapt the nouns to your domain
  /// and keep the shape: what happened, what it means, one next step.
  factory AppError.of(ErrorKind kind, {String? diagnostics}) => switch (kind) {
    ErrorKind.offline => AppError(
      kind: kind,
      title: 'You are offline',
      body: 'Showing the last data we loaded. New changes are not saved yet.',
      nextStep: 'Reconnect, then retry',
      retryable: true,
      diagnostics: diagnostics,
    ),
    ErrorKind.timeout => AppError(
      kind: kind,
      title: 'This is taking too long',
      body: 'The server did not answer in time. Nothing was changed.',
      nextStep: 'Try again',
      retryable: true,
      diagnostics: diagnostics,
    ),
    ErrorKind.unauthenticated => AppError(
      kind: kind,
      title: 'Your session expired',
      body: 'You were signed out for security. Your work is kept.',
      nextStep: 'Sign in',
      channel: ErrorChannel.page,
      diagnostics: diagnostics,
    ),
    ErrorKind.forbidden => AppError(
      kind: kind,
      title: 'You do not have access to this',
      body: 'Your account is missing the permission this page needs.',
      nextStep: 'Ask an admin for access',
      channel: ErrorChannel.page,
      diagnostics: diagnostics,
    ),
    ErrorKind.notFound => AppError(
      kind: kind,
      title: 'This item no longer exists',
      body: 'It may have been deleted or moved.',
      nextStep: 'Go back to the list',
      channel: ErrorChannel.page,
      diagnostics: diagnostics,
    ),
    ErrorKind.conflict => AppError(
      kind: kind,
      title: 'Someone else changed this',
      body: 'Your copy and the saved copy are different.',
      nextStep: 'Review both, then choose one',
      channel: ErrorChannel.dialog,
      diagnostics: diagnostics,
    ),
    ErrorKind.validation => AppError(
      kind: kind,
      title: 'Check the highlighted fields',
      body: 'Nothing was saved.',
      nextStep: 'Fix the fields, then save',
      channel: ErrorChannel.field,
      diagnostics: diagnostics,
    ),
    ErrorKind.rateLimited => AppError(
      kind: kind,
      title: 'Too many requests',
      body: 'You reached the limit for now.',
      nextStep: 'Wait a moment, then retry',
      retryable: true,
      diagnostics: diagnostics,
    ),
    ErrorKind.server => AppError(
      kind: kind,
      title: 'Something went wrong on our side',
      body: 'Your data is safe. Nothing was changed.',
      nextStep: 'Try again, or contact support',
      retryable: true,
      diagnostics: diagnostics,
    ),
    ErrorKind.cancelled => AppError(
      kind: kind,
      title: '',
      nextStep: '',
      channel: ErrorChannel.silent,
    ),
    ErrorKind.unknown => AppError(
      kind: kind,
      title: 'Something went wrong',
      body: 'We could not complete that. Nothing was changed.',
      nextStep: 'Try again',
      retryable: true,
      diagnostics: diagnostics,
    ),
  };
}

bool _isCancellation(Object error) => false; // your transport's type
bool _isSocketFailure(Object error) => false; // your transport's type
bool _isTimeout(Object error) => false; // your transport's type
int? _statusOf(Object error) => null; // your transport's status accessor
```

## Rendering it

```dart
Widget buildError(BuildContext context, AppError error, VoidCallback onRetry) {
  if (error.channel == ErrorChannel.silent) return const SizedBox.shrink();
  return Alert(
    title: error.title,
    description: error.body,
    variant: AlertVariant.destructive,
    action: error.retryable
        ? Button(
            variant: ButtonVariant.outline,
            size: ButtonSize.sm,
            onPressed: onRetry,
            child: StyledText(error.nextStep, TextStyles.buttonLabelSm),
          )
        : null,
  );
}
```

For an action level failure, use the toaster instead, and keep the retry real:

```dart
controller.error(
  error.title,
  description: error.body,
  action: error.retryable
      ? ToastAction(label: 'Retry', onPressed: retry)
      : null,
);
```

Diagnostics go inside a `Collapsible` labelled "Technical details", placed after
the next step, and are always logged in full with the correlation id.
