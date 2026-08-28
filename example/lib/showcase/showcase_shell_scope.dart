/// Shell geometry made available to showcase pages.
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

/// Shares the compact dock's scroll clearance without reserving shell layout.
///
/// Pages that scroll under the compact dock add [bottomOverlayClearanceOf] to
/// their own scroll padding. The shell itself deliberately keeps the [IndexedStack]
/// full-height so destination surfaces continue beneath the fixed dock.
class ShowcaseShellScope extends InheritedWidget {
  const ShowcaseShellScope({
    super.key,
    required this.compact,
    required super.child,
  });

  final bool compact;

  /// The dock's content height plus its visual breathing room.
  static double get compactDockClearance =>
      LayoutHeights.siteHeader + space(12);

  static double bottomOverlayClearanceOf(BuildContext context) {
    final ShowcaseShellScope? scope = context
        .dependOnInheritedWidgetOfExactType<ShowcaseShellScope>();
    return scope?.compact == true ? compactDockClearance : 0;
  }

  @override
  bool updateShouldNotify(ShowcaseShellScope oldWidget) =>
      compact != oldWidget.compact;
}
