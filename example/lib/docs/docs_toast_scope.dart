// example/lib/docs/docs_toast_scope.dart
/// Threads the documentation app's [ToastController] down to any control
/// that wants to confirm an action with a toast.
///
/// `lib/src/components/ui/toaster.dart` ships [Toaster] (the overlay host) and
/// [ToastController] (the imperative queue a caller fires into), but
/// neither exposes an inherited lookup of its own — there is no
/// `Toaster.of(context)`. Reaching for a top-level global instead would
/// work, but it is not deliberate: any widget in the tree could import it and
/// fire into it, with no way to tell from the constructor call alone whether
/// a given control is actually wired to the app's toaster or to nothing.
/// This is that lookup instead, scoped to the one controller [DocsApp]
/// (`example/lib/main.dart`) owns and disposes.
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

/// Publishes the app's [ToastController] to descendants.
///
/// [maybeOf] is an imperative read, not a subscription: it does not call
/// [BuildContext.dependOnInheritedWidgetOfExactType], so looking it up from
/// an event handler (a button's `onPressed`, a `Future` continuation) never
/// asserts and never registers a rebuild dependency a fired-and-forgotten
/// toast has no use for.
class DocsToastScope extends InheritedWidget {
  const DocsToastScope({
    super.key,
    required this.controller,
    required super.child,
  });

  /// The one controller [Toaster] is mounted with at the app root.
  final ToastController controller;

  /// The controller in scope, or null off any subtree [DocsToastScope] does
  /// not cover — a bare widget test that pumps a control on its own, or a
  /// preview rendered outside the app shell. A control that reads this must
  /// degrade silently on null rather than assume the toaster exists.
  static ToastController? maybeOf(BuildContext context) {
    final InheritedElement? element = context
        .getElementForInheritedWidgetOfExactType<DocsToastScope>();
    return (element?.widget as DocsToastScope?)?.controller;
  }

  @override
  bool updateShouldNotify(DocsToastScope oldWidget) =>
      controller != oldWidget.controller;
}
