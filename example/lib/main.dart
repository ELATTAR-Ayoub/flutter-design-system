/// The docs app — `app/layout.tsx` plus the routing Next.js does by folder.
///
/// Two things sit **above** the [WidgetsApp], as they do above `<body>` in the
/// reference: the theme scope and the router. `next-themes` writes its class
/// onto `<html>`, so a portal — a sheet, a dialog — resolves tokens exactly
/// like the page under it. In Flutter a pushed route is a sibling of the home
/// widget, not a descendant, so anything it needs to read has to be above
/// [MaterialApp].
///
/// A third thing sits above it on a phone, and it is not a widget: see [main].
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, SystemUiMode;

import 'nav.dart';
import 'pages/agent_avatar.dart';
import 'pages/agent_voice.dart';
import 'pages/buttons.dart';
import 'pages/charts.dart';
import 'pages/chat.dart';
import 'pages/colors.dart';
import 'pages/composer.dart';
import 'pages/console.dart';
import 'pages/data.dart';
import 'pages/dialogs.dart';
import 'pages/feedback.dart';
import 'pages/forms.dart';
import 'pages/history.dart';
import 'pages/icons.dart';
import 'pages/inputs.dart';
import 'pages/layout.dart';
import 'pages/menus.dart';
import 'pages/motion.dart';
import 'pages/navigation.dart';
import 'pages/overview.dart';
import 'pages/placeholder.dart';
import 'pages/selection.dart';
import 'pages/selects.dart';
import 'pages/shadows.dart';
import 'pages/sidebar.dart';
import 'pages/sidebar_demo.dart';
import 'pages/spacing.dart';
import 'pages/transcript.dart';
import 'pages/typography.dart';
import 'shell.dart';

/// `::selection { background: color-mix(in oklab, var(--color-action) 35%,
/// transparent); color: var(--foreground) }`.
const double _selectionAlpha = 0.35;

/// Boots the app, and on a phone asks the platform for the window the design
/// depends on.
///
/// USER-ORDERED MOBILE ADAPTATION (2026-08-16), and the half of [DsSafeArea]'s
/// ruling that a widget cannot state: *backgrounds paint edge-to-edge.* A page
/// glow that stops at the status bar is not the design, so the app draws
/// **under** both system bars ([SystemUiMode.edgeToEdge]) and the widgets below
/// keep their content out of them by reading the insets that mode reports.
/// Android 15 imposes edge-to-edge whether or not this is called; saying it
/// here is what makes the same window appear on Android 10–14, and what stops
/// the two halves of the ruling from being separately true.
///
/// No `MediaQuery` wrapper joins the tree for it. [WidgetsApp] installs
/// [MediaQueryData.fromView], which takes its geometry — `padding`,
/// `viewPadding`, `viewInsets` — from the window rather than from any ancestor,
/// so the insets are already the platform's by the time any of this reads them;
/// a wrapper above [MaterialApp] would be overwritten one layer down and is the
/// wrong instinct to leave lying around. (Contrast `disableAnimations`, which
/// *is* inherited from an ancestor — see [_DocsHome.reduceMotion].)
///
/// Guarded to the two platforms that have system bars. The call is a platform
/// channel message, and on the web — where the capture rig runs — there is no
/// handler for it to reach.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS)) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
  runApp(const DocsApp());
}

/// Holds the two things that outlive every page.
class DocsApp extends StatefulWidget {
  const DocsApp({super.key, this.reduceMotion, this.clock});

  /// Overrides the `?motion=` boot parameter — see
  /// [_DocsAppState._reduceMotion] for what it does and why it exists.
  ///
  /// Null, the default and what `main` boots with, reads the URL. A test
  /// cannot set `Uri.base`, so this is the seam it sets instead.
  final bool? reduceMotion;

  /// Overrides the `?clock=` boot parameter — see [_DocsAppState._clock].
  ///
  /// Same shape and same reason as [reduceMotion]: null reads the URL, and a
  /// test that cannot set `Uri.base` sets this instead.
  final DateTime? clock;

  /// Parses `?clock=<ISO-8601>` into the instant the app calls "now".
  ///
  /// Public because both the boot path and its test read it, and because it is
  /// the one place the parameter's contract lives. Anything [DateTime.tryParse]
  /// rejects — and the empty string, and an absent parameter — returns null,
  /// which leaves the app on the real wall clock. A boot flag that silently
  /// froze the app on the wrong month because someone typed a bad date would
  /// be worse than one that ignores itself.
  ///
  /// That last part needs a second check. [DateTime.tryParse] accepts
  /// `2026-13-45` and **rolls it over** into February 2027 rather than
  /// rejecting it, and this parameter's whole job is to decide which month a
  /// calendar opens on — so the calendar fields are compared back against the
  /// string that produced them, and a value that did not survive the round
  /// trip is treated as a typo.
  ///
  /// A `Z`-suffixed or offset-bearing value is converted **to local time**:
  /// [DsClock] is a calendar clock, and the point of freezing it is that both
  /// renderers agree on which day it is.
  static DateTime? parseClock(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final DateTime? parsed = DateTime.tryParse(raw);
    if (parsed == null) return null;
    // The date half only — the time half cannot roll a month over, and an
    // offset-bearing value is *supposed* to land on a different calendar day.
    if (raw.length >= 10 && !parsed.isUtc && !raw.contains('+')) {
      if (DsDateFormat.dayKey(parsed) != raw.substring(0, 10)) return null;
    }
    return parsed.isUtc ? parsed.toLocal() : parsed;
  }

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

  /// `?clock=<ISO-8601>` — the fourth boot parameter, and the second one that
  /// changes what paints.
  ///
  /// **Why (supervisor ruling L2).** `react-day-picker`'s `getInitialMonth` is
  /// `month || defaultMonth || today`, and the selects page passes neither of
  /// the first two to any of its three calendars — so all three open on the
  /// reader's current month and the page's rendered height moves with the
  /// wall clock: a four-, five- or six-week month differs by one 36px row per
  /// calendar. The port reproduces that, because it is what the page does.
  ///
  /// A vertical-parity probe cannot pin a route whose height depends on the
  /// date, so the capture harness freezes the clock on **both** sides: Chrome
  /// gets a `Date` shim injected with `evaluateOnNewDocument`, and this side
  /// gets this parameter. Pass the same ISO-8601 instant to both and the two
  /// renderers agree on the month, the week count, the `today` cell and the
  /// document height.
  ///
  /// It reaches the tree as a [DsClock] above [MaterialApp] — above, not
  /// below, for the reason the library note gives: a pushed route is a sibling
  /// of `home` rather than a descendant, and a calendar inside a sheet must
  /// resolve the same "now" as one on the page.
  ///
  /// Null — no parameter, or one [DocsApp.parseClock] rejects — leaves every
  /// calendar on [DateTime.now], which is the behaviour of every build before
  /// this seam existed.
  late final DateTime? _clock =
      widget.clock ?? DocsApp.parseClock(Uri.base.queryParameters['clock']);

  @override
  void dispose() {
    _theme.dispose();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget app = DsTheme(
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

    final DateTime? frozen = _clock;
    if (frozen == null) return app;
    // Above [MaterialApp], beside the theme scope and the router — the three
    // things that outlive every page, and the three a pushed route has to be
    // able to read. See [_clock].
    return DsClock(now: frozen, child: app);
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

    // `/sidebar-demo` is the one route that is **not** under `/design-system`,
    // and the reason is upstream's: `app/design-system/layout.tsx` supplies the
    // docs chrome, a nested route cannot opt out of a parent layout, and a
    // `fixed inset-y-0 h-svh` panel rendered inside the docs would land on top
    // of the documentation's own sidebar. So it sits at the root, where the
    // only layout is theme + tooltips + toaster — which here is everything
    // above this line. It is deliberately absent from `pageFor`: that switch is
    // the docs route table, and `shell_test` spends it against the nav, where
    // this href by construction does not appear.
    final Widget home = DefaultSelectionStyle(
      selectionColor: DsPalette.action.withValues(alpha: _selectionAlpha),
      cursorColor: theme.foreground,
      child: route == sidebarDemoRoute
          ? const SidebarDemoPage()
          : DocsShell(route: route, child: pageFor(route)),
    );

    if (!reduceMotion) return home;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(disableAnimations: true),
      child: home,
    );
  }
}

/// The twenty-seven real routes; every other href in the nav gets a
/// [PlaceholderPage].
///
/// Public because the shell test drives it directly, and because it is the one
/// place the route table lives.
///
/// The arms follow the nav's own order (`nav.ts` foundations: colors →
/// typography → spacing → shadows → motion → icons, then base components:
/// buttons → inputs → forms → selects → selection → dialogs → menus →
/// navigation → feedback → chat → data → charts → layout → sidebar, then the
/// agent family: console → avatar → composer → transcript → history → voice),
/// so this switch reads as the sidebar reads. `selects` sitting between `forms`
/// and `selection` is the registry's order, not an alphabetisation; `feedback`
/// sits between `navigation` and `chat` for the same reason. The agent block's
/// order is the registry's too, and it is **not** the order the pages were
/// built in: `avatar` sits second because `nav.ts` puts it there.
///
/// With the agent family landed, Foundations, Base **and** Agent are all built,
/// so the placeholder is reached only by the Site group and by the four group
/// index routes. `shell_test` is what says that out loud.
Widget pageFor(String route) {
  return switch (route) {
    dsRoot => const OverviewPage(),
    '$dsRoot/colors' => const ColorsPage(),
    '$dsRoot/typography' => const TypographyPage(),
    '$dsRoot/spacing' => const SpacingPage(),
    '$dsRoot/shadows' => const ShadowsPage(),
    '$dsRoot/motion' => const MotionPage(),
    '$dsRoot/icons' => const IconsPage(),
    '$dsRoot/components/base/buttons' => const ButtonsPage(),
    '$dsRoot/components/base/inputs' => const InputsPage(),
    '$dsRoot/components/base/forms' => const FormsPage(),
    '$dsRoot/components/base/selects' => const SelectsPage(),
    '$dsRoot/components/base/selection' => const SelectionPage(),
    '$dsRoot/components/base/dialogs' => const DialogsPage(),
    '$dsRoot/components/base/menus' => const MenusPage(),
    '$dsRoot/components/base/navigation' => const NavigationPage(),
    '$dsRoot/components/base/feedback' => const FeedbackPage(),
    '$dsRoot/components/base/chat' => const ChatPage(),
    '$dsRoot/components/base/data' => const DataPage(),
    '$dsRoot/components/base/charts' => const ChartsPage(),
    '$dsRoot/components/base/layout' => const LayoutPage(),
    '$dsRoot/components/base/sidebar' => const SidebarPage(),
    '$dsRoot/components/agent/console' => const ConsolePage(),
    '$dsRoot/components/agent/avatar' => const AgentAvatarPage(),
    '$dsRoot/components/agent/composer' => const ComposerPage(),
    '$dsRoot/components/agent/transcript' => const TranscriptPage(),
    '$dsRoot/components/agent/history' => const HistoryPage(),
    '$dsRoot/components/agent/voice' => const AgentVoicePage(),
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
