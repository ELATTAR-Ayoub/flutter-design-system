/// The chrome-free host for `/shots/<slug>/preview`.
///
/// One Shot, on the page background, and nothing else: no site header, no
/// footer, no search, no breadcrumb. It is what an `<iframe>` on the Shot's
/// detail page points at, and what a reader opens when they want the
/// composition without the documentation around it.
///
/// This file is **documentation chrome**, not registry payload: it lives in
/// `shots_docs/`, the generator never hashes it, and it is never copied into a
/// consumer project. The compositions it mounts live in `example/lib/shots/`
/// and are the shipped half.
///
/// The route arm must sit **above** the `siteRouteFor` guard in `main.dart`.
/// `/shots/<slug>/preview` starts with `/shots`, so a guard that matches the
/// public shots section first would wrap this in the very chrome it exists to
/// omit.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../shots/dashboard_overview/dashboard_overview_shot.dart';
import '../shots/settings_profile/settings_profile_shot.dart';
import '../shots/sign_in_flow/sign_in_flow_shot.dart';
import 'catalog.dart';

/// The composition registered under [name], or null when nothing is.
///
/// Keyed by the catalog's own slug, so the switch and
/// `shots_docs/catalog.dart` cannot disagree about what a Shot is called.
Widget? shotPreviewFor(String name) => switch (name) {
  'settings-profile' => const SettingsProfileShot(),
  'sign-in-flow' => const SignInFlowShot(),
  'dashboard-overview' => const DashboardOverviewShot(),
  _ => null,
};

/// The host for [route], or null when [route] is not a Shot preview route.
///
/// One call, so the Wave 2 route arm is a single line and the preview route's
/// spelling stays the catalog's business.
Widget? shotPreviewHostForRoute(String route) {
  final ShotDocEntry? entry = shotDocForPreviewRoute(route);
  return entry == null ? null : ShotPreviewHost(name: entry.name);
}

/// Renders exactly one Shot, with no site chrome around it.
class ShotPreviewHost extends StatelessWidget {
  const ShotPreviewHost({super.key, required this.name, this.shot});

  /// The catalog slug of the Shot to mount — `settings-profile`,
  /// `sign-in-flow`, `dashboard-overview`.
  final String name;

  /// A composition supplied directly, bypassing [shotPreviewFor].
  ///
  /// The seam a focused test uses to mount a Shot in a known state without
  /// teaching the registry about a fixture.
  final Widget? shot;

  /// The key the preview's scroller carries, so a harness can find the frame
  /// without depending on which Shot is inside it.
  static const ValueKey<String> viewportKey = ValueKey<String>(
    'shot-preview-viewport',
  );

  /// The air around the composition: one step narrower on a phone.
  static double gutterFor(double width) =>
      width < DsBreakpoints.sm ? ds(4) : ds(6);

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final double gutter = gutterFor(MediaQuery.sizeOf(context).width);
    final Widget? composition = shot ?? shotPreviewFor(name);

    return DefaultTextStyle(
      // `<body class="… text-foreground">`, the same line `shell.dart:165`
      // gives the documentation shell and `showcase/showcase_app.dart:151`
      // gives Signal Studio. This route is a top-level surface with no
      // `Material` above it, so without this every [DsText] in the mounted
      // composition inherits [WidgetsApp]'s fallback style — error-red ink
      // under a double yellow underline — because [DsText] builds with
      // `inherit: true` and never declares a `decoration`, and because its
      // [DsTypeColor.none] classes read their ink straight off
      // `DefaultTextStyle.of(context).style.color`.
      style: DsText.styleOf(context, DsType.body, color: theme.foreground),
      child: ColoredBox(
        color: theme.background,
        child: SafeArea(
          child: composition == null
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(gutter),
                    child: DsText(
                      'No Shot is registered under "$name".',
                      DsType.body,
                      color: theme.mutedForeground,
                      align: TextAlign.center,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  key: viewportKey,
                  padding: EdgeInsets.all(gutter),
                  child: composition,
                ),
        ),
      ),
    );
  }
}
