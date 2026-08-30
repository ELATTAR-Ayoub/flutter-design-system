/// The stress-test app: three product pages, one theme, one toaster.
///
/// The scenario control is a test rig, not product furniture: it is how a
/// reviewer reaches the failure and empty states without a real backend.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/material.dart'
    hide
        AspectRatio,
        Form,
        FormField,
        Icon,
        OverlayPortal,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth,
        AlertDialog,
        Badge,
        Card,
        Checkbox,
        Dialog,
        DropdownMenu,
        Drawer,
        Slider,
        Switch,
        TextFormField,
        Tooltip;

import 'agent_console_page.dart';
import 'invoices_page.dart';
import 'stress_feedback.dart';
import 'stress_repository.dart';
import 'team_page.dart';

enum StressPage { invoices, team, console }

extension on StressPage {
  String get label => switch (this) {
    StressPage.invoices => 'Billing',
    StressPage.team => 'Team',
    StressPage.console => 'Console',
  };
}

class StressApp extends StatefulWidget {
  const StressApp({
    super.key,
    this.initialPage = StressPage.invoices,
    this.repository,
    this.failMidStream = false,
    this.reduceMotion,
    this.initialMode = ColorMode.dark,
  });

  final StressPage initialPage;

  /// Injected so a test can script every outcome.
  final StressRepository? repository;

  final bool failMidStream;
  final bool? reduceMotion;

  /// Both themes are a verification axis, so a test can start in either.
  final ColorMode initialMode;

  @override
  State<StressApp> createState() => _StressAppState();
}

class _StressAppState extends State<StressApp> {
  late final ThemeController _theme = ThemeController(
    mode: widget.initialMode,
  );
  final ToastController _toasts = ToastController();
  late final StressRepository _repository =
      widget.repository ?? StressRepository();
  late StressPage _page = widget.initialPage;

  @override
  void dispose() {
    _theme.dispose();
    _toasts.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget app = ThemeScope(
      controller: _theme,
      child: MaterialApp(
        title: 'UI director stress test',
        debugShowCheckedModeBanner: false,
        home: StressFeedback(
          controller: _toasts,
          child: _Shell(
            page: _page,
            onPageChanged: (StressPage next) => setState(() => _page = next),
            repository: _repository,
            failMidStream: widget.failMidStream,
            toasts: _toasts,
            theme: _theme,
          ),
        ),
      ),
    );

    if (widget.reduceMotion == true) {
      final MediaQueryData data =
          MediaQuery.maybeOf(context) ??
          MediaQueryData.fromView(
            WidgetsBinding.instance.platformDispatcher.views.first,
          );
      app = MediaQuery(
        data: data.copyWith(disableAnimations: true),
        child: app,
      );
    }
    return app;
  }
}

class _Shell extends StatelessWidget {
  const _Shell({
    required this.page,
    required this.onPageChanged,
    required this.repository,
    required this.failMidStream,
    required this.toasts,
    required this.theme,
  });

  final StressPage page;
  final ValueChanged<StressPage> onPageChanged;
  final StressRepository repository;
  final bool failMidStream;
  final ToastController toasts;
  final ThemeController theme;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens tokens = ThemeScope.of(context);

    return ColoredBox(
      color: tokens.background,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Navigation is structure: it renders in every page state,
              // including while a page is loading or has failed.
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    space(4),
                    space(3),
                    space(4),
                    space(0),
                  ),
                  child: Row(
                    children: <Widget>[
                      // The destinations scroll rather than overflow: at 390
                      // points the row does not fit, and a clipped nav is a
                      // navigation bug, not a cosmetic one.
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              for (final StressPage destination
                                  in StressPage.values)
                                Padding(
                                  padding: EdgeInsets.only(right: space(2)),
                                  child: Button(
                                    variant: destination == page
                                        ? ButtonVariant.secondary
                                        : ButtonVariant.ghost,
                                    size: ButtonSize.sm,
                                    onPressed: () => onPageChanged(destination),
                                    child: StyledText(
                                      destination.label,
                                      TextStyles.buttonLabelSm,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      Button(
                        variant: ButtonVariant.ghost,
                        size: ButtonSize.sm,
                        onPressed: () => theme.setMode(
                          theme.mode == ColorMode.dark
                              ? ColorMode.light
                              : ColorMode.dark,
                        ),
                        label: 'Switch theme',
                        child: const Icon(IconGlyph.moon, size: IconSize.sm),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: switch (page) {
                  StressPage.invoices => InvoicesPage(repository: repository),
                  StressPage.team => TeamPage(repository: repository),
                  StressPage.console => AgentConsolePage(
                    failMidStream: failMidStream,
                  ),
                },
              ),
            ],
          ),
          Positioned.fill(child: Toaster(controller: toasts)),
        ],
      ),
    );
  }
}
