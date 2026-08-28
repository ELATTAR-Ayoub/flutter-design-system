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
import 'package:flutter/material.dart'
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
        TableColumnWidth,
        ActionChip,
        AlertDialog,
        Badge,
        Card,
        CarouselController,
        Checkbox,
        Dialog,
        DropdownMenu,
        Drawer,
        DrawerHeader,
        Slider,
        Switch,
        TextFormField,
        Tooltip;
import 'package:flutter/rendering.dart' show debugPaintBaselinesEnabled;
import 'package:flutter/services.dart'
    show SystemChrome, SystemNavigator, SystemUiMode, rootBundle;
import 'package:flutter_web_plugins/url_strategy.dart' show usePathUrlStrategy;

import 'nav.dart';
import 'docs/docs_toast_scope.dart';
import 'docs_pages/catalog.dart';
import 'docs_pages/changelog_page.dart';
import 'docs_pages/cli_page.dart';
import 'docs_pages/installation_page.dart';
import 'docs_pages/introduction_page.dart';
import 'docs_pages/registry_page.dart';
import 'docs_pages/theming_page.dart';
import 'docs_pages/typeset_page.dart';
import 'components_docs/button/page.dart';
import 'components_docs/accordion/meta.dart' as accordion;
import 'components_docs/accordion/page.dart';
import 'components_docs/agent_attach_menu/meta.dart' as agent_attach_menu;
import 'components_docs/agent_attach_menu/page.dart';
import 'components_docs/agent_attachments/meta.dart' as agent_attachments;
import 'components_docs/agent_attachments/page.dart';
import 'components_docs/agent_avatar/meta.dart' as agent_avatar;
import 'components_docs/agent_avatar/page.dart';
import 'components_docs/agent_composer/meta.dart' as agent_composer;
import 'components_docs/agent_composer/page.dart';
import 'components_docs/agent_console/meta.dart' as agent_console;
import 'components_docs/agent_console/page.dart';
import 'components_docs/agent_core/meta.dart' as agent_core;
import 'components_docs/agent_core/page.dart';
import 'components_docs/agent_face/meta.dart' as agent_face;
import 'components_docs/agent_face/page.dart';
import 'components_docs/agent_history/meta.dart' as agent_history;
import 'components_docs/agent_history/page.dart';
import 'components_docs/agent_launcher/meta.dart' as agent_launcher;
import 'components_docs/agent_launcher/page.dart';
import 'components_docs/agent_markdown/meta.dart' as agent_markdown;
import 'components_docs/agent_markdown/page.dart';
import 'components_docs/agent_slash_palette/meta.dart' as agent_slash_palette;
import 'components_docs/agent_slash_palette/page.dart';
import 'components_docs/agent_transcript/meta.dart' as agent_transcript;
import 'components_docs/agent_transcript/page.dart';
import 'components_docs/alert/meta.dart' as alert;
import 'components_docs/alert/page.dart';
import 'components_docs/alert_dialog/meta.dart' as alert_dialog;
import 'components_docs/alert_dialog/page.dart';
import 'components_docs/avatar/meta.dart' as avatar;
import 'components_docs/avatar/page.dart';
import 'components_docs/badge/meta.dart' as badge;
import 'components_docs/badge/page.dart';
import 'components_docs/breadcrumb/meta.dart' as breadcrumb;
import 'components_docs/breadcrumb/page.dart';
import 'components_docs/bubble/meta.dart' as bubble;
import 'components_docs/bubble/page.dart';
import 'components_docs/calendar/meta.dart' as calendar;
import 'components_docs/calendar/page.dart';
import 'components_docs/card/meta.dart' as card;
import 'components_docs/card/page.dart';
import 'components_docs/carousel/meta.dart' as carousel;
import 'components_docs/carousel/page.dart';
import 'components_docs/chart/meta.dart' as chart;
import 'components_docs/chart/page.dart';
import 'components_docs/chart_cartesian/meta.dart' as chart_cartesian;
import 'components_docs/chart_cartesian/page.dart';
import 'components_docs/chart_geometry/meta.dart' as chart_geometry;
import 'components_docs/chart_geometry/page.dart';
import 'components_docs/chart_polar/meta.dart' as chart_polar;
import 'components_docs/chart_polar/page.dart';
import 'components_docs/checkbox/meta.dart' as checkbox;
import 'components_docs/checkbox/page.dart';
import 'components_docs/collapsible/meta.dart' as collapsible;
import 'components_docs/collapsible/page.dart';
import 'components_docs/command/meta.dart' as command;
import 'components_docs/command/page.dart';
import 'components_docs/dialog/meta.dart' as dialog;
import 'components_docs/dialog/page.dart';
import 'components_docs/dropdown_menu/meta.dart' as dropdown_menu;
import 'components_docs/dropdown_menu/page.dart';
import 'components_docs/field/meta.dart' as field;
import 'components_docs/field/page.dart';
import 'components_docs/icon/meta.dart' as icon;
import 'components_docs/icon/page.dart';
import 'components_docs/input/meta.dart' as input;
import 'components_docs/input/page.dart';
import 'components_docs/input_group/meta.dart' as input_group;
import 'components_docs/input_group/page.dart';
import 'components_docs/native_select/meta.dart' as native_select;
import 'components_docs/native_select/page.dart';
import 'components_docs/navigation_menu/meta.dart' as navigation_menu;
import 'components_docs/navigation_menu/page.dart';
import 'components_docs/pagination/meta.dart' as pagination;
import 'components_docs/pagination/page.dart';
import 'components_docs/popover/meta.dart' as popover;
import 'components_docs/popover/page.dart';
import 'components_docs/progress/meta.dart' as progress;
import 'components_docs/progress/page.dart';
import 'components_docs/radio/meta.dart' as radio;
import 'components_docs/radio/page.dart';
import 'components_docs/scroll_area/meta.dart' as scroll_area;
import 'components_docs/scroll_area/page.dart';
import 'components_docs/select/meta.dart' as select;
import 'components_docs/select/page.dart';
import 'components_docs/separator/meta.dart' as separator;
import 'components_docs/separator/page.dart';
import 'components_docs/sheet/meta.dart' as sheet;
import 'components_docs/sheet/page.dart';
import 'components_docs/sidebar/meta.dart' as sidebar;
import 'components_docs/sidebar/page.dart';
import 'components_docs/slider/meta.dart' as slider;
import 'components_docs/slider/page.dart';
import 'components_docs/stat/meta.dart' as stat;
import 'components_docs/stat/page.dart';
import 'components_docs/switch/meta.dart' as switch_;
import 'components_docs/switch/page.dart';
import 'components_docs/table/meta.dart' as table;
import 'components_docs/table/page.dart';
import 'components_docs/tabs/meta.dart' as tabs;
import 'components_docs/tabs/page.dart';
import 'components_docs/textarea/meta.dart' as textarea;
import 'components_docs/textarea/page.dart';
import 'components_docs/toaster/meta.dart' as toaster;
import 'components_docs/toaster/page.dart';
import 'components_docs/toggle/meta.dart' as toggle;
import 'components_docs/toggle/page.dart';
import 'components_docs/tooltip/meta.dart' as tooltip;
import 'components_docs/aspect_ratio/meta.dart' as aspect_ratio;
import 'components_docs/button/meta.dart' as button;
import 'components_docs/button_group/meta.dart' as button_group;
import 'components_docs/combobox/meta.dart' as combobox;
import 'components_docs/context_menu/meta.dart' as context_menu;
import 'components_docs/drawer/meta.dart' as drawer;
import 'components_docs/validation_rule/meta.dart' as rule;
import 'components_docs/empty/meta.dart' as empty;
import 'components_docs/form/meta.dart' as form;
import 'components_docs/hover_card/meta.dart' as hover_card;
import 'components_docs/input_otp/meta.dart' as input_otp;
import 'components_docs/item/meta.dart' as item;
import 'components_docs/kbd/meta.dart' as kbd;
import 'components_docs/marker/meta.dart' as marker;
import 'components_docs/menu/meta.dart' as menu;
import 'components_docs/menubar/meta.dart' as menubar;
import 'components_docs/message/meta.dart' as message;
import 'components_docs/message_scroller/meta.dart' as message_scroller;
import 'components_docs/user_menu/meta.dart' as user_menu;
import 'components_docs/resizable/meta.dart' as resizable;
import 'components_docs/selection_control/meta.dart' as selection_control;
import 'components_docs/skeleton/meta.dart' as skeleton;
import 'components_docs/spinner/meta.dart' as spinner;
import 'components_docs/toggle_group/meta.dart' as toggle_group;
import 'components_docs/tooltip/page.dart';
import 'components_docs/aspect_ratio/page.dart';
import 'components_docs/button_group/page.dart';
import 'components_docs/combobox/page.dart';
import 'components_docs/context_menu/page.dart';
import 'components_docs/drawer/page.dart';
import 'components_docs/validation_rule/page.dart';
import 'components_docs/empty/page.dart';
import 'components_docs/form/page.dart';
import 'components_docs/hover_card/page.dart';
import 'components_docs/input_otp/page.dart';
import 'components_docs/item/page.dart';
import 'components_docs/kbd/page.dart';
import 'components_docs/marker/page.dart';
import 'components_docs/menu/page.dart';
import 'components_docs/menubar/page.dart';
import 'components_docs/message/page.dart';
import 'components_docs/message_scroller/page.dart';
import 'components_docs/user_menu/page.dart';
import 'components_docs/resizable/page.dart';
import 'components_docs/selection_control/page.dart';
import 'components_docs/skeleton/page.dart';
import 'components_docs/spinner/page.dart';
import 'components_docs/toggle_group/page.dart';
import 'components_docs/attachment/meta.dart' as attachment;
import 'components_docs/attachment/page.dart';
import 'components_docs/questionnaire/meta.dart' as questionnaire;
import 'components_docs/questionnaire/page.dart';
import 'components_docs/voice/meta.dart' as voice;
import 'components_docs/voice/page.dart';
import 'components_docs/voice_indicator/meta.dart' as voice_indicator;
import 'components_docs/voice_indicator/page.dart';
import 'components_docs/icon_swap/meta.dart' as icon_swap;
import 'components_docs/icon_swap/page.dart';
import 'components_docs/hover_builder/meta.dart' as lift;
import 'components_docs/hover_builder/page.dart';
import 'components_docs/active_indicator/meta.dart' as active_indicator;
import 'components_docs/active_indicator/page.dart';
import 'components_docs/content_change/meta.dart' as content_change;
import 'components_docs/content_change/page.dart';
import 'components_docs/premium_surface/meta.dart' as premium_surface;
import 'components_docs/premium_surface/page.dart';
import 'components_docs/glass/meta.dart' as glass;
import 'components_docs/glass/page.dart';
import 'components_docs/surface/meta.dart' as surface;
import 'components_docs/surface/page.dart';
import 'components_docs/media_scrim/meta.dart' as media_scrim;
import 'components_docs/media_scrim/page.dart';
import 'components_docs/feedback_surface/meta.dart' as feedback_surface;
import 'components_docs/feedback_surface/page.dart';
import 'components_docs/background_effect/meta.dart' as background_effect;
import 'components_docs/background_effect/page.dart';
import 'components_docs/action_feedback/meta.dart' as action_feedback;
import 'components_docs/action_feedback/page.dart';
import 'components_docs/ambient_pattern/meta.dart' as starfield;
import 'components_docs/ambient_pattern/page.dart';
import 'components_docs/press/meta.dart' as press;
import 'components_docs/press/page.dart';
import 'components_docs/keyframes/meta.dart' as keyframes;
import 'components_docs/keyframes/page.dart';
import 'components_docs/safe_area/meta.dart' as safe_area;
import 'components_docs/safe_area/page.dart';
import 'components_docs/source_foundation/meta.dart' as source_foundation;
import 'components_docs/source_foundation/page.dart';
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
import 'pages/spacing.dart';
import 'pages/transcript.dart';
import 'pages/typography.dart';
import 'shell.dart';
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
/// USER-ORDERED MOBILE ADAPTATION (2026-08-16), and the half of [SafeArea]'s
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
  // `#/design-system/colors` -> `/design-system/colors`: the address bar the
  // reference (ui.shadcn.com) shows, and what makes a typed or reloaded path
  // resolvable at all rather than only a hash fragment the server never sees.
  // A no-op off the web: `flutter_web_plugins` gates the real implementation
  // behind its own `dart.library.ui_web` conditional export, the same seam
  // `scroll_bridge.dart` uses for `dart.library.js_interop`, so this call is
  // safe on the VM the widget tests run on without a stub of our own.
  // Selected BEFORE the URL strategy: setting a strategy recreates the
  // engine's browser-history object, and doing that after this call was
  // observed to drop back to single-entry.
  if (kIsWeb) SystemNavigator.selectMultiEntryHistory();
  usePathUrlStrategy();
  // And re-asserted once the first frame is up, because the selection is a
  // platform message and the engine may not have had a view to apply it to
  // this early. Selecting a mode already active is a no-op.
  if (kIsWeb) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemNavigator.selectMultiEntryHistory();
    });
  }
  // **Back must return to the previous page, not leave the site.**
  //
  // Flutter web boots in SINGLE-entry history mode, and in that mode
  // `SystemNavigator.routeInformationUpdated` — what `AppRouter.navigate`
  // calls on every in-app navigation — reaches the engine as a
  // `replaceState`, not a `pushState`. The address bar updates and a
  // reloaded or deep-linked URL still resolves, so the defect is invisible
  // from everything except the Back button: no history entry is ever
  // created, `history.length` never grows, and the first Back press takes
  // the reader off the documentation entirely.
  //
  // Measured, not inferred: driving the release build in headless Chrome,
  // clicking through to `/components/accordion` moved `location.pathname`
  // and left `history.length` at 3, and Back landed on `about:blank`.
  //
  // This opts into multi-entry history, which is what makes that same call
  // push. `MaterialApp.router` would do it as a side effect of adopting
  // Router; this app routes through its own `AppRouter` notifier
  // (`shell.dart`), so it asks directly. Web-only by nature — the channel
  // has no handler elsewhere — and guarded so the widget tests, which run on
  // the VM, do not send a message nothing answers.
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
  // Warms the Skill sources so `/skills` has a filled file tree on its first
  // frame instead of the "not loaded" placeholder for a beat — eight Markdown
  // files under 20 KB in total.
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
  /// [Clock] is a calendar clock, and the point of freezing it is that both
  /// renderers agree on which day it is.
  static DateTime? parseClock(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final DateTime? parsed = DateTime.tryParse(raw);
    if (parsed == null) return null;
    // The date half only — the time half cannot roll a month over, and an
    // offset-bearing value is *supposed* to land on a different calendar day.
    if (raw.length >= 10 && !parsed.isUtc && !raw.contains('+')) {
      if (DateFormat.dayKey(parsed) != raw.substring(0, 10)) return null;
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
  final ThemeController _theme = ThemeController(
    mode: switch (Uri.base.queryParameters['theme']) {
      'light' => ColorMode.light,
      'system' => ColorMode.system,
      _ => ColorMode.dark,
    },
  );
  late final AppRouter _router;

  /// Scoped to the app, not a top-level global: [DocsToastScope] is the
  /// deliberate thread down to [DocsCopyButton] and anything else that wants
  /// to confirm an action, and this state disposes it with everything else
  /// that outlives a page rather than leaking it for the app's lifetime.
  final ToastController _toasts = ToastController();

  @override
  void initState() {
    super.initState();
    _router = AppRouter(
      route:
          widget.initialRoute ??
          Uri.base.queryParameters['route'] ??
          _pathRoute() ??
          (kIsWeb ? homeRoute : elRoot),
    );
  }

  /// The address bar's own path: `/components/button` for a page reached by
  /// a typed URL, a bookmark or a hard reload, now that [usePathUrlStrategy]
  /// (see [runDocsApp]) puts the route there instead of behind a `#`.
  ///
  /// Checked after `?route=`, never before it: the GitHub Pages entry point
  /// stays authoritative when both are present, exactly as it was before this
  /// existed. Null for `/` and for the empty path — those already fall through
  /// to the same default the boot sequence used when there was no path
  /// signal at all — and null off the web, where [Uri.base] is a `file://` URI
  /// for the test binary rather than a route.
  static String? _pathRoute() {
    if (!kIsWeb) return null;
    final String path = Uri.base.path;
    if (path.isEmpty || path == '/') return null;
    return path;
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
  /// is the flag `effectiveMotionDuration` resolves against, so every duration in
  /// the package collapses to zero exactly as `prefers-reduced-motion` makes
  /// it, and exactly as the page tests' own harness does.
  ///
  /// It earns its keep only on the pages holding a looping effect — shadows'
  /// `premium-surface`, and motion's ratchet, shimmer and live dot. A page that is
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
  /// It reaches the tree as a [Clock] above [MaterialApp] — above, not
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
    _toasts.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget app = ThemeScope(
      controller: _theme,
      child: AppRouterScope(
        router: _router,
        // Reachable the same way the theme scope and the router are: above
        // [MaterialApp], because a pushed route is a sibling of `home` (see
        // the library note), not a descendant, so anything mounted only
        // inside `home` would not reach a toast fired from inside a sheet or
        // a dialog.
        child: DocsToastScope(
          controller: _toasts,
          child: MaterialApp(
            // `metadata.title` in `app/layout.tsx`.
            title: "Elattar's Design System",
            debugShowCheckedModeBanner: false,
            home: _DocsHome(reduceMotion: _reduceMotion),
            // `builder` runs below MaterialApp's own Localizations,
            // Directionality and MediaQuery but above its Navigator — the one
            // seam that wraps every route (`home` and anything pushed over
            // it) with something that still resolves text direction and
            // media queries, which mounting the host as a sibling of
            // MaterialApp itself would not.
            builder: (BuildContext context, Widget? child) => Stack(
              children: <Widget>[
                ?child,
                Positioned.fill(child: Toaster(controller: _toasts)),
              ],
            ),
          ),
        ),
      ),
    );

    final DateTime? frozen = _clock;
    if (frozen == null) return app;
    // Above [MaterialApp], beside the theme scope and the router — the three
    // things that outlive every page, and the three a pushed route has to be
    // able to read. See [_clock].
    return Clock(now: frozen, child: app);
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
    final ThemeTokens theme = ThemeScope.of(context);
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
      selectionColor: Palette.action.withValues(alpha: _selectionAlpha),
      cursorColor: theme.foreground,
      child: switch (route) {
        _ when siteRouteFor(route) != null => SiteShell(
          route: route,
          child: publicPageFor(
            route,
            onNavigate: AppRouter.of(context).navigate,
          ),
        ),
        // Only the home page and the documentation tree exist now. Every
        // other route, including the whole legacy `/space/...` gallery, the
        // showcase and the sidebar demo, resolves to the documentation shell
        // so a stale link lands somewhere real instead of opening a page that
        // is no longer part of the site.
        _ => SiteShell(
          route: docsRoute,
          child: publicPageFor(
            docsRoute,
            onNavigate: AppRouter.of(context).navigate,
          ),
        ),
      },
    );

    if (!reduceMotion) return home;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(disableAnimations: true),
      child: home,
    );
  }
}

/// One page constructor per per-component `meta.dart`/`page.dart` pair.
typedef _ComponentDocPageBuilder =
    Widget Function({ValueChanged<String>? onNavigate});

/// Maps every non-Phase-F component's route to its page constructor.
///
/// Keyed off each imported `<name>Doc.route` — never a hand-typed
/// `/components/<name>` literal — so a route can only drift from
/// `catalog.dart` if the `meta.dart` const it reads from does. `button` is
/// deliberately absent: it stays on its own switch arm below, unmigrated,
/// exactly as it was before this map existed. `input`, `dialog`, `card`, and
/// `select` used to be absent for the same reason and are now migrated: each
/// has a real `meta.dart`/`page.dart` pair and a map entry like every other
/// component here.
final Map<String, _ComponentDocPageBuilder> _componentDocPageBuilders =
    <String, _ComponentDocPageBuilder>{
      accordion.accordionDoc.route: ({onNavigate}) =>
          AccordionDocPage(onNavigate: onNavigate),
      agent_attach_menu.agentAttachMenuDoc.route: ({onNavigate}) =>
          AgentAttachMenuDocPage(onNavigate: onNavigate),
      agent_attachments.agentAttachmentsDoc.route: ({onNavigate}) =>
          AgentAttachmentsDocPage(onNavigate: onNavigate),
      agent_avatar.agentAvatarDoc.route: ({onNavigate}) =>
          AgentAvatarDocPage(onNavigate: onNavigate),
      agent_composer.agentComposerDoc.route: ({onNavigate}) =>
          AgentComposerDocPage(onNavigate: onNavigate),
      agent_console.agentConsoleDoc.route: ({onNavigate}) =>
          AgentConsoleDocPage(onNavigate: onNavigate),
      agent_core.agentCoreDoc.route: ({onNavigate}) =>
          AgentCoreDocPage(onNavigate: onNavigate),
      agent_face.agentFaceDoc.route: ({onNavigate}) =>
          AgentFaceDocPage(onNavigate: onNavigate),
      agent_history.agentHistoryDoc.route: ({onNavigate}) =>
          AgentHistoryDocPage(onNavigate: onNavigate),
      agent_launcher.agentLauncherDoc.route: ({onNavigate}) =>
          AgentLauncherDocPage(onNavigate: onNavigate),
      agent_markdown.agentMarkdownDoc.route: ({onNavigate}) =>
          AgentMarkdownDocPage(onNavigate: onNavigate),
      agent_slash_palette.agentSlashPaletteDoc.route: ({onNavigate}) =>
          AgentSlashPaletteDocPage(onNavigate: onNavigate),
      agent_transcript.agentTranscriptDoc.route: ({onNavigate}) =>
          AgentTranscriptDocPage(onNavigate: onNavigate),
      alert.alertDoc.route: ({onNavigate}) =>
          AlertDocPage(onNavigate: onNavigate),
      alert_dialog.alertDialogDoc.route: ({onNavigate}) =>
          AlertDialogDocPage(onNavigate: onNavigate),
      avatar.avatarDoc.route: ({onNavigate}) =>
          AvatarDocPage(onNavigate: onNavigate),
      badge.badgeDoc.route: ({onNavigate}) =>
          BadgeDocPage(onNavigate: onNavigate),
      breadcrumb.breadcrumbDoc.route: ({onNavigate}) =>
          BreadcrumbDocPage(onNavigate: onNavigate),
      bubble.bubbleDoc.route: ({onNavigate}) =>
          BubbleDocPage(onNavigate: onNavigate),
      calendar.calendarDoc.route: ({onNavigate}) =>
          CalendarDocPage(onNavigate: onNavigate),
      card.cardDoc.route: ({onNavigate}) => CardDocPage(onNavigate: onNavigate),
      carousel.carouselDoc.route: ({onNavigate}) =>
          CarouselDocPage(onNavigate: onNavigate),
      chart.chartDoc.route: ({onNavigate}) =>
          ChartDocPage(onNavigate: onNavigate),
      chart_cartesian.chartCartesianDoc.route: ({onNavigate}) =>
          ChartCartesianDocPage(onNavigate: onNavigate),
      chart_geometry.chartGeometryDoc.route: ({onNavigate}) =>
          ChartGeometryDocPage(onNavigate: onNavigate),
      chart_polar.chartPolarDoc.route: ({onNavigate}) =>
          ChartPolarDocPage(onNavigate: onNavigate),
      checkbox.checkboxDoc.route: ({onNavigate}) =>
          CheckboxDocPage(onNavigate: onNavigate),
      collapsible.collapsibleDoc.route: ({onNavigate}) =>
          CollapsibleDocPage(onNavigate: onNavigate),
      command.commandDoc.route: ({onNavigate}) =>
          CommandDocPage(onNavigate: onNavigate),
      dialog.dialogDoc.route: ({onNavigate}) =>
          DialogDocPage(onNavigate: onNavigate),
      dropdown_menu.dropdownMenuDoc.route: ({onNavigate}) =>
          DropdownMenuDocPage(onNavigate: onNavigate),
      field.fieldDoc.route: ({onNavigate}) =>
          FieldDocPage(onNavigate: onNavigate),
      icon.iconDoc.route: ({onNavigate}) => IconDocPage(onNavigate: onNavigate),
      input.inputDoc.route: ({onNavigate}) =>
          InputDocPage(onNavigate: onNavigate),
      input_group.inputGroupDoc.route: ({onNavigate}) =>
          InputGroupDocPage(onNavigate: onNavigate),
      native_select.nativeSelectDoc.route: ({onNavigate}) =>
          NativeSelectDocPage(onNavigate: onNavigate),
      navigation_menu.navigationMenuDoc.route: ({onNavigate}) =>
          NavigationMenuDocPage(onNavigate: onNavigate),
      pagination.paginationDoc.route: ({onNavigate}) =>
          PaginationDocPage(onNavigate: onNavigate),
      popover.popoverDoc.route: ({onNavigate}) =>
          PopoverDocPage(onNavigate: onNavigate),
      progress.progressDoc.route: ({onNavigate}) =>
          ProgressDocPage(onNavigate: onNavigate),
      radio.radioDoc.route: ({onNavigate}) =>
          RadioDocPage(onNavigate: onNavigate),
      scroll_area.scrollAreaDoc.route: ({onNavigate}) =>
          ScrollAreaDocPage(onNavigate: onNavigate),
      select.selectDoc.route: ({onNavigate}) =>
          SelectDocPage(onNavigate: onNavigate),
      separator.separatorDoc.route: ({onNavigate}) =>
          SeparatorDocPage(onNavigate: onNavigate),
      sheet.sheetDoc.route: ({onNavigate}) =>
          SheetDocPage(onNavigate: onNavigate),
      sidebar.sidebarDoc.route: ({onNavigate}) =>
          SidebarDocPage(onNavigate: onNavigate),
      slider.sliderDoc.route: ({onNavigate}) =>
          SliderDocPage(onNavigate: onNavigate),
      stat.statDoc.route: ({onNavigate}) => StatDocPage(onNavigate: onNavigate),
      switch_.switchDoc.route: ({onNavigate}) =>
          SwitchDocPage(onNavigate: onNavigate),
      table.tableDoc.route: ({onNavigate}) =>
          TableDocPage(onNavigate: onNavigate),
      tabs.tabsDoc.route: ({onNavigate}) => TabsDocPage(onNavigate: onNavigate),
      textarea.textareaDoc.route: ({onNavigate}) =>
          TextareaDocPage(onNavigate: onNavigate),
      toaster.toasterDoc.route: ({onNavigate}) =>
          ToasterDocPage(onNavigate: onNavigate),
      toggle.toggleDoc.route: ({onNavigate}) =>
          ToggleDocPage(onNavigate: onNavigate),
      tooltip.tooltipDoc.route: ({onNavigate}) =>
          TooltipDocPage(onNavigate: onNavigate),
      aspect_ratio.aspectRatioDoc.route: ({onNavigate}) =>
          AspectRatioDocPage(onNavigate: onNavigate),
      button.buttonDoc.route: ({onNavigate}) =>
          ButtonDocPage(onNavigate: onNavigate),
      button_group.buttonGroupDoc.route: ({onNavigate}) =>
          ButtonGroupDocPage(onNavigate: onNavigate),
      combobox.comboboxDoc.route: ({onNavigate}) =>
          ComboboxDocPage(onNavigate: onNavigate),
      context_menu.contextMenuDoc.route: ({onNavigate}) =>
          ContextMenuDocPage(onNavigate: onNavigate),
      drawer.drawerDoc.route: ({onNavigate}) =>
          DrawerDocPage(onNavigate: onNavigate),
      rule.validationRuleDoc.route: ({onNavigate}) =>
          ValidationRuleDocPage(onNavigate: onNavigate),
      empty.emptyDoc.route: ({onNavigate}) =>
          EmptyDocPage(onNavigate: onNavigate),
      form.formDoc.route: ({onNavigate}) => FormDocPage(onNavigate: onNavigate),
      hover_card.hoverCardDoc.route: ({onNavigate}) =>
          HoverCardDocPage(onNavigate: onNavigate),
      input_otp.inputOtpDoc.route: ({onNavigate}) =>
          InputOtpDocPage(onNavigate: onNavigate),
      item.itemDoc.route: ({onNavigate}) => ItemDocPage(onNavigate: onNavigate),
      kbd.kbdDoc.route: ({onNavigate}) => KbdDocPage(onNavigate: onNavigate),
      marker.markerDoc.route: ({onNavigate}) =>
          MarkerDocPage(onNavigate: onNavigate),
      menu.menuDoc.route: ({onNavigate}) => MenuDocPage(onNavigate: onNavigate),
      menubar.menubarDoc.route: ({onNavigate}) =>
          MenubarDocPage(onNavigate: onNavigate),
      message.messageDoc.route: ({onNavigate}) =>
          MessageDocPage(onNavigate: onNavigate),
      message_scroller.messageScrollerDoc.route: ({onNavigate}) =>
          MessageScrollerDocPage(onNavigate: onNavigate),
      user_menu.userMenuDoc.route: ({onNavigate}) =>
          UserMenuDocPage(onNavigate: onNavigate),
      resizable.resizableDoc.route: ({onNavigate}) =>
          ResizableDocPage(onNavigate: onNavigate),
      selection_control.selectionControlDoc.route: ({onNavigate}) =>
          SelectionControlDocPage(onNavigate: onNavigate),
      skeleton.skeletonDoc.route: ({onNavigate}) =>
          SkeletonDocPage(onNavigate: onNavigate),
      spinner.spinnerDoc.route: ({onNavigate}) =>
          SpinnerDocPage(onNavigate: onNavigate),
      toggle_group.toggleGroupDoc.route: ({onNavigate}) =>
          ToggleGroupDocPage(onNavigate: onNavigate),
      attachment.attachmentDoc.route: ({onNavigate}) =>
          AttachmentDocPage(onNavigate: onNavigate),
      questionnaire.questionnaireDoc.route: ({onNavigate}) =>
          QuestionnaireDocPage(onNavigate: onNavigate),
      voice.voiceDoc.route: ({onNavigate}) =>
          VoiceDocPage(onNavigate: onNavigate),
      voice_indicator.voiceIndicatorDoc.route: ({onNavigate}) =>
          VoiceIndicatorDocPage(onNavigate: onNavigate),
      icon_swap.iconSwapDoc.route: ({onNavigate}) =>
          IconSwapDocPage(onNavigate: onNavigate),
      lift.hoverBuilderDoc.route: ({onNavigate}) =>
          HoverBuilderDocPage(onNavigate: onNavigate),
      active_indicator.activeIndicatorDoc.route: ({onNavigate}) =>
          ActiveIndicatorDocPage(onNavigate: onNavigate),
      content_change.contentChangeDoc.route: ({onNavigate}) =>
          ContentChangeDocPage(onNavigate: onNavigate),
      premium_surface.premiumSurfaceDoc.route: ({onNavigate}) =>
          PremiumSurfaceDocPage(onNavigate: onNavigate),
      glass.glassDoc.route: ({onNavigate}) =>
          GlassDocPage(onNavigate: onNavigate),
      surface.surfaceDoc.route: ({onNavigate}) =>
          SurfaceDocPage(onNavigate: onNavigate),
      media_scrim.mediaScrimDoc.route: ({onNavigate}) =>
          MediaScrimDocPage(onNavigate: onNavigate),
      feedback_surface.feedbackSurfaceDoc.route: ({onNavigate}) =>
          FeedbackSurfaceDocPage(onNavigate: onNavigate),
      background_effect.backgroundEffectDoc.route: ({onNavigate}) =>
          BackgroundEffectDocPage(onNavigate: onNavigate),
      action_feedback.actionFeedbackDoc.route: ({onNavigate}) =>
          ActionFeedbackDocPage(onNavigate: onNavigate),
      starfield.ambientPatternDoc.route: ({onNavigate}) =>
          AmbientPatternDocPage(onNavigate: onNavigate),
      press.pressDoc.route: ({onNavigate}) =>
          PressDocPage(onNavigate: onNavigate),
      keyframes.keyframesDoc.route: ({onNavigate}) =>
          KeyframesDocPage(onNavigate: onNavigate),
      safe_area.safeAreaDoc.route: ({onNavigate}) =>
          SafeAreaDocPage(onNavigate: onNavigate),
      source_foundation.sourceFoundationDoc.route: ({onNavigate}) =>
          SourceFoundationDocPage(onNavigate: onNavigate),
    };

/// Resolves public website destinations without changing the
/// established design-system specimen route table in [pageFor].
Widget publicPageFor(String route, {PublicNavigate? onNavigate}) {
  // Resolved from the catalog, and NOT as a `skillsRoute` arm in the switch
  // below. [SkillDocEntry.route] is the literal
  // `/skills` — there is one skill, and no index/detail split to model — so the
  // catalog is already the authority on which entry answers this path, and a
  // switch arm would be a second statement of the same fact. `/skills` is still
  // a first-class site destination: `site_routes.dart` lists it, and
  // `public_pages_test.dart` asserts this call resolves it to a [SkillsPage].
  final SkillDocEntry? skill = skillDocForRoute(route);
  if (skill != null) {
    return _SkillsRoute(entry: skill, onNavigate: onNavigate);
  }
  // The ~35 non-Phase-F component docs resolve through the map above,
  // built once from the catalog, instead of 35 more switch arms below.
  final _ComponentDocPageBuilder? componentPage =
      _componentDocPageBuilders[route];
  if (componentPage != null) {
    return componentPage(onNavigate: onNavigate);
  }
  return switch (route) {
    homeRoute => PublicHomePage(onNavigate: onNavigate),
    docsRoute => PublicDocsPage(onNavigate: onNavigate),
    docsIntroductionRoute => IntroductionDocsPage(onNavigate: onNavigate),
    docsInstallationRoute => InstallationDocsPage(onNavigate: onNavigate),
    docsThemingRoute => ThemingDocsPage(onNavigate: onNavigate),
    docsCliRoute => CliDocsPage(onNavigate: onNavigate),
    docsTypesetRoute => TypesetDocsPage(onNavigate: onNavigate),
    docsRegistryRoute => RegistryDocsPage(onNavigate: onNavigate),
    docsChangelogRoute => ChangelogDocsPage(onNavigate: onNavigate),
    componentsRoute => PublicComponentsPage(onNavigate: onNavigate),
    '/components/button' => const ButtonDocPage(),
    // The deliberate fallback. Every route the site declares now resolves
    // above — `site_routes_test.dart` asserts that every entry in
    // `docsPageEntries` is reachable, which is what stopped three declared
    // routes from silently landing here.
    //
    // What remains is a genuinely unknown path: a stale bookmark, a typo, a
    // link from somewhere else. Sending that to the homepage is a choice, not
    // an oversight — a deep-linked static site has nowhere better to put it,
    // and a "not found" screen for a path the site never advertised is worse
    // for a reader than the front page. Tested below rather than assumed.
    _ => PublicHomePage(onNavigate: onNavigate),
  };
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
/// The page renders the bytes on disk rather than a transcription of them, so
/// there is no second copy to drift and no generation step to forget.
/// `example/test/public_pages_test.dart` asserts that equality against
/// `dart:io`, which is the only thing standing between this loader and a page
/// that quietly shows stale text.
///
/// Deliberately *not* memoised. [rootBundle] is a `CachingAssetBundle` and
/// already holds the decoded string, so a second call costs one small map; a
/// second cache would only add a way to hand out a `Future` created in a scope
/// that has since ended — which in a widget test means a load that never
/// completes.
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
/// The page takes its source as data — deliberately, so it stays a pure
/// widget — which leaves someone to do the loading. That is this, at the same
/// layer that already owns routing the page in.
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
    elRoot => const OverviewPage(),
    '$elRoot/colors' => const ColorsPage(),
    '$elRoot/typography' => const TypographyPage(),
    '$elRoot/spacing' => const SpacingPage(),
    '$elRoot/shadows' => const ShadowsPage(),
    '$elRoot/motion' => const MotionPage(),
    '$elRoot/icons' => const IconsPage(),
    '$elRoot/components/base/buttons' => const ButtonsPage(),
    '$elRoot/components/base/inputs' => const InputsPage(),
    '$elRoot/components/base/forms' => const FormsPage(),
    '$elRoot/components/base/selects' => const SelectsPage(),
    '$elRoot/components/base/selection' => const SelectionPage(),
    '$elRoot/components/base/dialogs' => const DialogsPage(),
    '$elRoot/components/base/menus' => const MenusPage(),
    '$elRoot/components/base/navigation' => const NavigationPage(),
    '$elRoot/components/base/feedback' => const FeedbackPage(),
    '$elRoot/components/base/chat' => const ChatPage(),
    '$elRoot/components/base/data' => const DataPage(),
    '$elRoot/components/base/charts' => const ChartsPage(),
    '$elRoot/components/base/layout' => const LayoutPage(),
    '$elRoot/components/base/sidebar' => const SidebarPage(),
    '$elRoot/components/agent/console' => const ConsolePage(),
    '$elRoot/components/agent/avatar' => const AgentAvatarPage(),
    '$elRoot/components/agent/composer' => const ComposerPage(),
    '$elRoot/components/agent/transcript' => const TranscriptPage(),
    '$elRoot/components/agent/history' => const HistoryPage(),
    '$elRoot/components/agent/voice' => const AgentVoicePage(),
    _ => _placeholderFor(route),
  };
}

/// Names the placeholder from the nav registry rather than from a second list
/// — a route that is in the tree cannot render an unnamed page.
Widget _placeholderFor(String route) {
  for (final Group group in elGroups) {
    if (route == group.href) {
      return PlaceholderPage(
        eyebrow: "Elattar's Design System",
        title: group.title,
      );
    }
    for (final Category category in group.categories) {
      if (categoryHref(group, category) == route) {
        return PlaceholderPage(eyebrow: group.title, title: category.title);
      }
    }
  }
  return const PlaceholderPage(eyebrow: 'Design System', title: 'Not found');
}
