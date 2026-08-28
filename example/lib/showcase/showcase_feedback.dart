/// Shared transient feedback for the Signal Studio showcase.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Form,
        FormField,
        Icon,
        OverlayPortal,
        RadioGroup,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;

/// Makes the app-owned toast queue available to each showcase destination.
///
/// The toaster itself is mounted exactly once by [SignalStudioApp] so route
/// changes do not discard consequential feedback.
class ShowcaseFeedback extends InheritedWidget {
  const ShowcaseFeedback({
    super.key,
    required this.controller,
    required super.child,
  });

  final ToastController controller;

  static ToastController of(BuildContext context) {
    final ShowcaseFeedback? scope = context
        .dependOnInheritedWidgetOfExactType<ShowcaseFeedback>();
    assert(scope != null, 'No ShowcaseFeedback found above this destination.');
    return scope!.controller;
  }

  @override
  bool updateShouldNotify(ShowcaseFeedback oldWidget) =>
      oldWidget.controller != controller;
}
