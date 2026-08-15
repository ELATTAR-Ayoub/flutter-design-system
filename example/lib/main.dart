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
import 'pages/icons.dart';
import 'pages/motion.dart';
import 'pages/overview.dart';
import 'pages/placeholder.dart';
import 'pages/shadows.dart';
import 'pages/spacing.dart';
import 'pages/typography.dart';
import 'shell.dart';

/// `::selection { background: color-mix(in oklab, var(--color-action) 35%,
/// transparent); color: var(--foreground) }`.
const double _selectionAlpha = 0.35;

void main() => runApp(const DocsApp());

/// Holds the two things that outlive every page.
class DocsApp extends StatefulWidget {
  const DocsApp({super.key, this.reduceMotion});

  /// Overrides the `?motion=` boot parameter — see
  /// [_DocsAppState._reduceMotion] for what it does and why it exists.
  ///
  /// Null, the default and what `main` boots with, reads the URL. A test
  /// cannot set `Uri.base`, so this is the seam it sets instead.
  final bool? reduceMotion;

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

  /// `?motion=reduced` — the third boot parameter, and the only one that
  /// changes what paints rather than only what is on screen at boot.
  ///
  /// The verification harness captures a tall page in two shots and stitches
  /// them, so anything still moving between the shots tears the seam. On the
  /// web side Chrome's emulated `prefers-reduced-motion` freezes the
  /// reference's CSS outright. That emulation never reaches Flutter web, which
  /// reads `disableAnimations` off the platform's accessibility features and
  /// not off a media query — so on this side the same state is plumbed by
  /// hand, forcing [MediaQueryData.disableAnimations] on the tree below. That
  /// is the flag `dsAnimationDuration` resolves against, so every duration in
  /// the package collapses to zero exactly as `prefers-reduced-motion` makes
  /// it, and exactly as the page tests' own harness does.
  ///
  /// It earns its keep only on the pages holding a looping effect — shadows'
  /// `foil-value`, and motion's ratchet, shimmer and live dot. A page that is
  /// wholly static (icons) converges to the pixel without it.
  late final bool _reduceMotion =
      widget.reduceMotion ?? Uri.base.queryParameters['motion'] == 'reduced';

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
        child: MaterialApp(
          // `metadata.title` in `app/layout.tsx`.
          title: "Elattar's Design System",
          debugShowCheckedModeBanner: false,
          home: _DocsHome(reduceMotion: _reduceMotion),
        ),
      ),
    );
  }
}

class _DocsHome extends StatelessWidget {
  const _DocsHome({required this.reduceMotion});

  /// See [_DocsAppState._reduceMotion].
  ///
  /// Applied on this layer — the one [DefaultSelectionStyle] already sits on —
  /// because it is the layer the page tests override and the one the capture
  /// rig was specified against. One consequence is worth knowing: a pushed
  /// route is a sibling of `home` rather than a descendant (see the library
  /// note above), so a sheet or dialog opened over the page does **not**
  /// inherit this. Nothing the rig captures is inside one. Moving the override
  /// above [MaterialApp] would reach them as well — `MediaQueryData.fromView`
  /// takes `disableAnimations` from an ancestor when there is one — if that is
  /// ever wanted.
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    // Depends on the router, so a `navigate()` rebuilds the shell and the page
    // together.
    final String route = AppRouter.of(context).route;

    final Widget home = DefaultSelectionStyle(
      selectionColor: DsPalette.action.withValues(alpha: _selectionAlpha),
      cursorColor: theme.foreground,
      child: DocsShell(route: route, child: pageFor(route)),
    );

    if (!reduceMotion) return home;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(disableAnimations: true),
      child: home,
    );
  }
}

/// The seven real routes; every other href in the nav gets a
/// [PlaceholderPage].
///
/// Public because the shell test drives it directly, and because it is the one
/// place the route table lives.
///
/// The arms follow the nav's own order (`nav.ts` foundations: colors →
/// typography → spacing → shadows → motion → icons), so this switch reads as
/// the sidebar reads.
Widget pageFor(String route) {
  return switch (route) {
    dsRoot => const OverviewPage(),
    '$dsRoot/colors' => const ColorsPage(),
    '$dsRoot/typography' => const TypographyPage(),
    '$dsRoot/spacing' => const SpacingPage(),
    '$dsRoot/shadows' => const ShadowsPage(),
    '$dsRoot/motion' => const MotionPage(),
    '$dsRoot/icons' => const IconsPage(),
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
