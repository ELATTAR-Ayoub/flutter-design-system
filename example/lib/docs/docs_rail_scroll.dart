/// One remembered scroll offset for the documentation left rail, owned above
/// the page that renders it.
///
/// The rail is the same list on every documentation page — the same four
/// groups, the same ninety-nine rows, only the centre column changes — but
/// `DocsLayout` is rebuilt from scratch on every route, so its
/// `ScrollController` was too. Scrolling down to Voice Indicator, clicking
/// it, and finding the rail back at Accordion made the rail feel like it
/// reloaded when only the article should have.
///
/// `SiteShell` outlives a route change (it is the same element, handed a new
/// `route`, which is exactly what its own `didUpdateWidget` relies on to send
/// the article back to its top). So the offset lives there, in a store the
/// shell owns and every `DocsLayout` beneath it reads and writes.
///
/// Deliberately not a `ChangeNotifier`: nothing rebuilds when the offset
/// changes. It is read once, when a rail mounts, and written as the reader
/// scrolls. A notifier here would rebuild the whole page on every scroll
/// frame for no visible effect.
library;

import 'package:flutter/widgets.dart';

/// The mutable cell [DocsRailScrollScope] hands down.
class DocsRailScrollStore {
  /// Where the rail was left, or null if it has not been scrolled yet in
  /// this session — the difference between "restore 0" and "nothing to
  /// restore, so show the reader where they are instead".
  double? offset;
}

/// Provides one [DocsRailScrollStore] to every `DocsLayout` below it.
class DocsRailScrollScope extends InheritedWidget {
  const DocsRailScrollScope({
    super.key,
    required this.store,
    required super.child,
  });

  final DocsRailScrollStore store;

  /// The ambient store, or null outside a `SiteShell` — a widget test that
  /// pumps one page on its own has nothing to remember across, and gets the
  /// cold-load behaviour instead of an error.
  static DocsRailScrollStore? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DocsRailScrollScope>()?.store;

  @override
  bool updateShouldNotify(DocsRailScrollScope oldWidget) =>
      !identical(store, oldWidget.store);
}
