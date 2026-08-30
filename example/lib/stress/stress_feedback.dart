/// One toast controller for the whole feature, reachable from any depth.
///
/// The repository already ships this pattern as `ShowcaseFeedback`; this is the
/// same shape for the stress-test app, kept separate so the two never share a
/// queue.
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

class StressFeedback extends InheritedWidget {
  const StressFeedback({
    super.key,
    required this.controller,
    required super.child,
  });

  final ToastController controller;

  static ToastController of(BuildContext context) {
    final StressFeedback? scope = context
        .dependOnInheritedWidgetOfExactType<StressFeedback>();
    assert(scope != null, 'StressFeedback is missing above this widget.');
    return scope!.controller;
  }

  /// Reports a failure through the action channel.
  ///
  /// A cancelled request shows nothing, which is the whole reason
  /// [ErrorKind.cancelled] exists.
  static void reportError(
    BuildContext context,
    AppError error, {
    VoidCallback? onRetry,
  }) {
    if (error.isSilent) return;
    of(context).error(
      error.title,
      description: error.body,
      action: error.retryable && onRetry != null
          ? ToastAction(label: 'Retry', onPressed: onRetry)
          : null,
    );
  }

  @override
  bool updateShouldNotify(StressFeedback oldWidget) =>
      controller != oldWidget.controller;
}
