/// The docs app — `app/layout.tsx` plus the routing Next.js does by folder.
///
/// Two things sit **above** the [WidgetsApp], as they do above `<body>` in the
/// reference: the theme scope and the router. `next-themes` writes its class
/// onto `<html>`, so a portal — a sheet, a dialog — resolves tokens exactly
/// like the page under it. In Flutter a pushed route is a sibling of the home
/// widget, not a descendant, so anything it needs to read has to be above
/// [MaterialApp].
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/material.dart';

import 'nav.dart';
import 'pages/colors.dart';
import 'pages/overview.dart';
import 'pages/placeholder.dart';
import 'pages/spacing.dart';
import 'pages/typography.dart';
import 'shell.dart';

/// `::selection { background: color-mix(in oklab, var(--color-action) 35%,
/// transparent); color: var(--foreground) }`.
const double _selectionAlpha = 0.35;

void main() => runApp(const DocsApp());

/// Holds the two things that outlive every page.
class DocsApp extends StatefulWidget {
  const DocsApp({super.key});

  @override
  State<DocsApp> createState() => _DocsAppState();
}

class _DocsAppState extends State<DocsApp> {
  /// `defaultTheme="dark"` — the controller's own default.
  ///
  /// Boot state may be overridden by URL query parameters (`?route=…&theme=…`)
  /// — deep-link plumbing for the side-by-side verification harness. It sets
  /// only the initial controller values; nothing rendered differs from the
  /// reference.
  final DsThemeController _theme = DsThemeController(
    mode: switch (Uri.base.queryParameters['theme']) {
      'light' => DsThemeMode.light,
      'system' => DsThemeMode.system,
      _ => DsThemeMode.dark,
    },
  );
  late final AppRouter _router = AppRouter(
    route: Uri.base.queryParameters['route'] ?? dsRoot,
  );

  @override
  void dispose() {
    _theme.dispose();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DsTheme(
      controller: _theme,
      child: AppRouterScope(
        router: _router,
        child: const MaterialApp(
          // `metadata.title` in `app/layout.tsx`.
          title: "Elattar's Design System",
          debugShowCheckedModeBanner: false,
          home: _DocsHome(),
        ),
      ),
    );
  }
}

class _DocsHome extends StatelessWidget {
  const _DocsHome();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    // Depends on the router, so a `navigate()` rebuilds the shell and the page
    // together.
    final String route = AppRouter.of(context).route;

    return DefaultSelectionStyle(
      selectionColor: DsPalette.action.withValues(alpha: _selectionAlpha),
      cursorColor: theme.foreground,
      child: DocsShell(route: route, child: pageFor(route)),
    );
  }
}

/// The four real routes; every other href in the nav gets a [PlaceholderPage].
///
/// Public because the shell test drives it directly, and because it is the one
/// place the route table lives.
Widget pageFor(String route) {
  return switch (route) {
    dsRoot => const OverviewPage(),
    '$dsRoot/colors' => const ColorsPage(),
    '$dsRoot/typography' => const TypographyPage(),
    '$dsRoot/spacing' => const SpacingPage(),
    _ => _placeholderFor(route),
  };
}

/// Names the placeholder from the nav registry rather than from a second list
/// — a route that is in the tree cannot render an unnamed page.
Widget _placeholderFor(String route) {
  for (final DsGroup group in dsGroups) {
    if (route == group.href) {
      return PlaceholderPage(
        eyebrow: "Elattar's Design System",
        title: group.title,
      );
    }
    for (final DsCategory category in group.categories) {
      if (categoryHref(group, category) == route) {
        return PlaceholderPage(eyebrow: group.title, title: category.title);
      }
    }
  }
  return const PlaceholderPage(eyebrow: 'Design System', title: 'Not found');
}
