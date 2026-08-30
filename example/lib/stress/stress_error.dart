/// Failures translated for people.
///
/// Copied from `skills/elattar-flutter-ui-director/templates/app-error.md`.
/// Every exception is mapped here, at the data boundary. No widget in this
/// feature builds a string from an exception.
library;

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

/// Where a failure is allowed to appear.
enum ErrorChannel { field, section, action, page, dialog, silent }

/// A failure, written for a person.
///
/// [title], [body] and [nextStep] are user copy. [diagnostics] is not: it sits
/// behind a collapsed disclosure and in the log.
class AppError {
  const AppError({
    required this.kind,
    required this.title,
    required this.nextStep,
    this.body,
    this.channel = ErrorChannel.section,
    this.retryable = false,
    this.fieldErrors = const <String, String>{},
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

  /// Never user copy.
  final String? diagnostics;
  final String? correlationId;

  bool get isSilent => channel == ErrorChannel.silent;

  /// The single entry point from the transport layer.
  factory AppError.from(Object error) {
    if (error is TransportFailure) {
      return AppError.of(
        error.kind,
        diagnostics: error.diagnostics,
        correlationId: error.correlationId,
        fieldErrors: error.fieldErrors,
        title: error.titleOverride,
        body: error.bodyOverride,
        nextStep: error.nextStepOverride,
      );
    }
    return AppError.of(ErrorKind.unknown, diagnostics: error.toString());
  }

  /// The copy table from `references/errors.md`. Overrides exist so a specific
  /// failure can be more useful than the generic one, never less.
  factory AppError.of(
    ErrorKind kind, {
    String? diagnostics,
    String? correlationId,
    Map<String, String> fieldErrors = const <String, String>{},
    String? title,
    String? body,
    String? nextStep,
  }) {
    final AppError base = switch (kind) {
      ErrorKind.offline => const AppError(
        kind: ErrorKind.offline,
        title: 'You are offline',
        body: 'Showing the last data we loaded. New changes are not saved yet.',
        nextStep: 'Reconnect, then retry',
        retryable: true,
      ),
      ErrorKind.timeout => const AppError(
        kind: ErrorKind.timeout,
        title: 'This is taking too long',
        body: 'The server did not answer in time. Nothing was changed.',
        nextStep: 'Try again',
        retryable: true,
      ),
      ErrorKind.unauthenticated => const AppError(
        kind: ErrorKind.unauthenticated,
        title: 'Your session expired',
        body: 'You were signed out for security. Your work is kept.',
        nextStep: 'Sign in',
        channel: ErrorChannel.page,
      ),
      ErrorKind.forbidden => const AppError(
        kind: ErrorKind.forbidden,
        title: 'You do not have access to this',
        body: 'Your account is missing the permission this page needs.',
        nextStep: 'Ask an admin for access',
        channel: ErrorChannel.page,
      ),
      ErrorKind.notFound => const AppError(
        kind: ErrorKind.notFound,
        title: 'This item no longer exists',
        body: 'It may have been deleted or moved.',
        nextStep: 'Go back to the list',
        channel: ErrorChannel.page,
      ),
      ErrorKind.conflict => const AppError(
        kind: ErrorKind.conflict,
        title: 'Someone else changed this',
        body: 'Your copy and the saved copy are different.',
        nextStep: 'Review both, then choose one',
        channel: ErrorChannel.dialog,
      ),
      ErrorKind.validation => const AppError(
        kind: ErrorKind.validation,
        title: 'Check the highlighted fields',
        body: 'Nothing was saved.',
        nextStep: 'Fix the fields, then save',
        channel: ErrorChannel.field,
      ),
      ErrorKind.rateLimited => const AppError(
        kind: ErrorKind.rateLimited,
        title: 'Too many requests',
        body: 'You reached the limit for now.',
        nextStep: 'Wait a moment, then retry',
        retryable: true,
      ),
      ErrorKind.server => const AppError(
        kind: ErrorKind.server,
        title: 'Something went wrong on our side',
        body: 'Your data is safe. Nothing was changed.',
        nextStep: 'Try again, or contact support',
        retryable: true,
      ),
      ErrorKind.cancelled => const AppError(
        kind: ErrorKind.cancelled,
        title: '',
        nextStep: '',
        channel: ErrorChannel.silent,
      ),
      ErrorKind.unknown => const AppError(
        kind: ErrorKind.unknown,
        title: 'Something went wrong',
        body: 'We could not complete that. Nothing was changed.',
        nextStep: 'Try again',
        retryable: true,
      ),
    };

    return AppError(
      kind: base.kind,
      title: title ?? base.title,
      body: body ?? base.body,
      nextStep: nextStep ?? base.nextStep,
      channel: base.channel,
      retryable: base.retryable,
      fieldErrors: fieldErrors.isEmpty ? base.fieldErrors : fieldErrors,
      diagnostics: diagnostics,
      correlationId: correlationId,
    );
  }
}

/// What the fake transport throws. A real app's transport exception replaces it;
/// only [AppError.from] has to change.
class TransportFailure implements Exception {
  const TransportFailure(
    this.kind, {
    required this.diagnostics,
    this.correlationId,
    this.fieldErrors = const <String, String>{},
    this.titleOverride,
    this.bodyOverride,
    this.nextStepOverride,
  });

  final ErrorKind kind;

  /// The raw backend string. Deliberately ugly, because the point is that it
  /// never reaches user copy.
  final String diagnostics;

  final String? correlationId;
  final Map<String, String> fieldErrors;
  final String? titleOverride;
  final String? bodyOverride;
  final String? nextStepOverride;

  @override
  String toString() => 'TransportFailure(${kind.name}): $diagnostics';
}
