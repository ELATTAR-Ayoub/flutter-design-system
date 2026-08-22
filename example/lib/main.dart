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
import 'package:flutter/rendering.dart' show debugPaintBaselinesEnabled;
import 'package:flutter/services.dart'
    show SystemChrome, SystemUiMode, rootBundle;

import 'nav.dart';
import 'components_docs/button_card_pages.dart';
import 'components_docs/dialog_page.dart';
import 'components_docs/input_select_pages.dart';
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
import 'showcase/showcase_app.dart';
import 'shots_docs/catalog.dart';
import 'shots_docs/shot_detail_page.dart';
import 'shots_docs/shot_preview_host.dart';
import 'shots_docs/shots_index_page.dart';
import 'skills_docs/catalog.dart';
import 'skills_docs/skills_page.dart';
import 'site/pages/public_pages.dart';
import 'site/site_routes.dart';
import 'site/site_shell.dart';

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
void main() => runDocsApp();

/// Boots either the documentation index or a named integrated route.
///
/// [showcase_main.dart] uses this seam so the APK can open on Signal Studio
/// while retaining the same router, theme, and return path as the docs app.
void runDocsApp({String? initialRoute}) {
  WidgetsFlutterBinding.ensureInitialized();
  // Flutter Inspector persists "Show baselines" through the VM service while
  // a debug session is alive. Reset it on every fresh boot so the diagnostic
  // ideographic/alphabetic rules can never be mistaken for product styling.
  // This assignment is assert-scoped and therefore absent from release AOT.
  assert(() {
    debugPaintBaselinesEnabled = false;
    return true;
  }());
  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS)) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
  // Warms the Shot sources so `/shots/<slug>` has a filled file tree on its
  // first frame instead of the "not loaded" placeholder for a beat. Three
  // small text files; the strings land in the asset bundle's own cache, which
  // is what the page reads a moment later.
  for (final ShotDocEntry entry in shotDocs) {
    shotSourceFor(entry);
  }
  // Same, for `/skills` — eight Markdown files under 20 KB in total.
  for (final SkillDocEntry entry in skillDocs) {
    skillSourceFor(entry);
  }
  runApp(DocsApp(initialRoute: initialRoute));
}

/// Holds the two things that outlive every page.
class DocsApp extends StatefulWidget {
  const DocsApp({super.key, this.reduceMotion, this.clock, this.initialRoute});

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

  /// Opens a known route without replacing the app or nesting a router.
  ///
  /// Null preserves the URL-driven documentation boot contract.
  final String? initialRoute;

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
  late final AppRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter(
      route:
          widget.initialRoute ??
          Uri.base.queryParameters['route'] ??
          (kIsWeb ? homeRoute : dsRoot),
    );
  }

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

    // Resolved before the switch because its arm has to win before the
    // `siteRouteFor` guard is consulted — see the arm's own note below.
    final Widget? shotPreview = shotPreviewHostForRoute(route);

    final Widget home = DefaultSelectionStyle(
      selectionColor: DsPalette.action.withValues(alpha: _selectionAlpha),
      cursorColor: theme.foreground,
      child: switch (route) {
        // ABOVE the `siteRouteFor` guard, deliberately. `/shots/<slug>/preview`
        // begins with the public shots prefix, so a guard that resolved it as a
        // site destination first would wrap the composition in the header,
        // footer and search chrome the preview exists to omit. It sits outside
        // the guard for the same reason `showcaseRoute` and `sidebarDemoRoute`
        // do: it is a full-bleed surface, not a page inside the site shell.
        _ when shotPreview != null => shotPreview,
        _ when siteRouteFor(route) != null => SiteShell(
          route: route,
          child: publicPageFor(
            route,
            onNavigate: AppRouter.of(context).navigate,
          ),
        ),
        showcaseRoute => SignalStudioShowcase(
          onOpenDesignSystem: () => AppRouter.of(context).navigate(dsRoot),
        ),
        sidebarDemoRoute => const SidebarDemoPage(),
        _ => DocsShell(route: route, child: pageFor(route)),
      },
    );

    if (!reduceMotion) return home;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(disableAnimations: true),
      child: home,
    );
  }
}

/// Resolves public website destinations without changing the
/// established design-system specimen route table in [pageFor].
Widget publicPageFor(String route, {PublicNavigate? onNavigate}) {
  final ShotDocEntry? shot = shotDocForRoute(route);
  if (shot != null) {
    return _ShotDetailRoute(entry: shot, onNavigate: onNavigate);
  }
  // Resolved from the catalog, exactly as the Shot above it is, and NOT as a
  // `skillsRoute` arm in the switch below. [SkillDocEntry.route] is the literal
  // `/skills` — there is one skill, and no index/detail split to model — so the
  // catalog is already the authority on which entry answers this path, and a
  // switch arm would be a second statement of the same fact. `/skills` is still
  // a first-class site destination: `site_routes.dart` lists it, and
  // `public_pages_test.dart` asserts this call resolves it to a [SkillsPage].
  final SkillDocEntry? skill = skillDocForRoute(route);
  if (skill != null) {
    return _SkillsRoute(entry: skill, onNavigate: onNavigate);
  }
  return switch (route) {
    homeRoute => PublicHomePage(onNavigate: onNavigate),
    docsRoute => PublicDocsPage(onNavigate: onNavigate),
    componentsRoute => PublicComponentsPage(onNavigate: onNavigate),
    shotsRoute => ShotsIndexPage(onNavigate: onNavigate),
    '/components/button' => const ButtonDocPage(),
    '/components/input' => const InputDocPage(),
    '/components/card' => const CardDocPage(),
    '/components/dialog' => const DialogDocPage(),
    '/components/select' => const SelectDocPage(),
    _ => PublicHomePage(onNavigate: onNavigate),
  };
}

/// The asset key for a repository-relative Shot source path.
///
/// [ShotDocEntry.sourcePaths] is rooted at the **repository**, because that is
/// what the registry manifests and the source guard need. An asset key is
/// rooted at the package that declares the asset, which for these files is
/// `example/`. Stripping that one segment is the whole translation, and doing
/// it here keeps `shots_docs/catalog.dart` the single authority on layout.
String shotSourceAssetKey(String sourcePath) {
  const String packageRoot = 'example/';
  if (!sourcePath.startsWith(packageRoot)) {
    throw ArgumentError.value(
      sourcePath,
      'sourcePath',
      'Expected a path inside the example package',
    );
  }
  return sourcePath.substring(packageRoot.length);
}

/// The real source of every file in [entry], keyed by plain file name — the
/// shape [ShotDetailPage.fileSource] takes.
///
/// The compositions are declared as assets in `example/pubspec.yaml`, so the
/// bytes the page renders are the bytes the generator hashes and the CLI
/// copies: there is no second copy of a Shot's source anywhere, and therefore
/// nothing that can drift from it. Reading the files with `dart:io` instead is
/// not an option — a widget cannot reach the filesystem on web or mobile, which
/// is precisely where this page is read.
///
/// Deliberately *not* memoised here. [rootBundle] is a `CachingAssetBundle` and
/// already holds the decoded string, so a second call costs one small map; a
/// second cache would only add a way to hand out a `Future` created in a scope
/// that has since ended — which in a widget test means a load that never
/// completes.
Future<Map<String, String>> shotSourceFor(ShotDocEntry entry) async {
  final Map<String, String> files = <String, String>{};
  final List<String> paths = entry.sourcePaths;
  for (int index = 0; index < entry.files.length; index++) {
    final String key = shotSourceAssetKey(paths[index]);
    try {
      files[entry.files[index]] = await rootBundle.loadString(key);
    } catch (error) {
      // A file the bundle does not carry falls through to ShotDetailPage's own
      // placeholder rather than taking the page down. The undeclared-asset case
      // is caught at test time by `shots_catalog_parity_test.dart`, which fails
      // when a catalog entry has no asset entry in `example/pubspec.yaml`.
      debugPrint('Shot source "$key" is not in the asset bundle: $error');
    }
  }
  return files;
}

/// [ShotDetailPage] with its file tree filled from the asset bundle.
///
/// The page itself takes the source as data — deliberately, so it stays a pure
/// widget — which leaves someone to do the loading. That is this, at the same
/// layer that already owns routing the page in.
class _ShotDetailRoute extends StatefulWidget {
  const _ShotDetailRoute({required this.entry, this.onNavigate});

  final ShotDocEntry entry;
  final PublicNavigate? onNavigate;

  @override
  State<_ShotDetailRoute> createState() => _ShotDetailRouteState();
}

class _ShotDetailRouteState extends State<_ShotDetailRoute> {
  late Future<Map<String, String>> _source = shotSourceFor(widget.entry);

  @override
  void didUpdateWidget(covariant _ShotDetailRoute oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.entry.name != widget.entry.name) {
      _source = shotSourceFor(widget.entry);
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<Map<String, String>>(
    future: _source,
    builder:
        (BuildContext context, AsyncSnapshot<Map<String, String>> snapshot) =>
            ShotDetailPage(
              entry: widget.entry,
              fileSource: snapshot.data ?? const <String, String>{},
              onNavigate: widget.onNavigate,
            ),
  );
}

/// The asset key for a repository-relative skill source path.
///
/// [SkillDocEntry.sourcePaths] is rooted at the **repository** — `skills/<slug>/…`
/// — because that directory is the skill's single source of truth: the same
/// bytes the repository's own agents read through `AGENTS.md`, the plugin route
/// installs, and a manual copy copies (Decision 005). Nothing may duplicate it.
///
/// That directory sits *above* `example/`, and a Flutter asset path may not
/// climb above its own project root, so the docs app cannot declare it. The
/// **package** can: `skills/` is inside `elattar_design_system`'s root,
/// `example/` depends on that package, and a package's assets are bundled into
/// every dependent app under `packages/<name>/<path>` — the mechanism the orb's
/// perlin field already uses. Prefixing is therefore the whole translation, and
/// `pubspec.yaml` at the repository root is where the two lines that enable it
/// live.
String skillSourceAssetKey(String sourcePath) {
  const String skillRoot = 'skills/';
  if (!sourcePath.startsWith(skillRoot)) {
    throw ArgumentError.value(
      sourcePath,
      'sourcePath',
      'Expected a path under the repository\'s skills/ directory',
    );
  }
  return 'packages/elattar_design_system/$sourcePath';
}

/// The real source of every file in [entry], keyed by the path relative to the
/// skill's own directory — the shape [SkillsPage.fileSource] takes.
///
/// Same contract, and same reasoning, as [shotSourceFor]: the page renders the
/// bytes on disk rather than a transcription of them, so there is no second
/// copy to drift and no generation step to forget.
/// `example/test/public_pages_test.dart` asserts that equality against
/// `dart:io`, which is the only thing standing between this loader and a page
/// that quietly shows stale text.
///
/// Deliberately *not* memoised, for the reason [shotSourceFor] records.
Future<Map<String, String>> skillSourceFor(SkillDocEntry entry) async {
  final Map<String, String> files = <String, String>{};
  final List<String> paths = entry.sourcePaths;
  for (int index = 0; index < entry.files.length; index++) {
    final String key = skillSourceAssetKey(paths[index]);
    try {
      files[entry.files[index]] = await rootBundle.loadString(key);
    } catch (error) {
      // A file the bundle does not carry falls through to SkillsPage's own
      // placeholder rather than taking the page down. The undeclared-asset case
      // is caught at test time by `public_pages_test.dart`.
      debugPrint('Skill source "$key" is not in the asset bundle: $error');
    }
  }
  return files;
}

/// [SkillsPage] with its file tree filled from the asset bundle.
///
/// The mirror of [_ShotDetailRoute], and for the same reason: the page takes
/// its source as data so it stays a pure widget, which leaves the loading to
/// the layer that already owns routing the page in.
class _SkillsRoute extends StatefulWidget {
  const _SkillsRoute({required this.entry, this.onNavigate});

  final SkillDocEntry entry;
  final PublicNavigate? onNavigate;

  @override
  State<_SkillsRoute> createState() => _SkillsRouteState();
}

class _SkillsRouteState extends State<_SkillsRoute> {
  late Future<Map<String, String>> _source = skillSourceFor(widget.entry);

  @override
  void didUpdateWidget(covariant _SkillsRoute oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.entry.slug != widget.entry.slug) {
      _source = skillSourceFor(widget.entry);
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<Map<String, String>>(
    future: _source,
    builder:
        (BuildContext context, AsyncSnapshot<Map<String, String>> snapshot) =>
            SkillsPage(
              entry: widget.entry,
              fileSource: snapshot.data ?? const <String, String>{},
              onNavigate: widget.onNavigate,
            ),
  );
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
