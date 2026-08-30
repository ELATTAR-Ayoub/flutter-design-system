/// Shared state renderers for the stress-test pages.
///
/// Each one is the single place a state is drawn, so three pages cannot drift
/// into three different ideas of what "failed" looks like.
library;

import 'package:flutter/semantics.dart' show SemanticsService;
import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart'
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
        TableColumnWidth;

import 'stress_error.dart';

/// Announces an asynchronous outcome, which a sighted user reads from the
/// screen and everyone else does not get at all.
void announce(BuildContext context, String message) {
  SemanticsService.sendAnnouncement(
    View.of(context),
    message,
    Directionality.of(context),
  );
}

/// Skeletons in the shape of the rows they replace, so nothing jumps on
/// arrival.
class RegionSkeleton extends StatelessWidget {
  const RegionSkeleton({super.key, this.rows = 4, this.rowHeight});

  final int rows;
  final double? rowHeight;

  @override
  Widget build(BuildContext context) {
    final double height = rowHeight ?? space(14);
    return Semantics(
      label: 'Loading',
      liveRegion: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          for (int i = 0; i < rows; i++)
            Padding(
              padding: EdgeInsets.only(bottom: space(2)),
              child: Skeleton(height: height),
            ),
        ],
      ),
    );
  }
}

/// The empty and no-results presentation. Both take one action, and the caller
/// decides which words and which way out.
class RegionEmpty extends StatelessWidget {
  const RegionEmpty({
    super.key,
    required this.glyph,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.onAction,
    this.actionVariant = ButtonVariant.primary,
  });

  final IconGlyph glyph;
  final String title;
  final String description;
  final String actionLabel;
  final VoidCallback? onAction;
  final ButtonVariant actionVariant;

  @override
  Widget build(BuildContext context) => Empty(
    children: <Widget>[
      EmptyHeader(
        children: <Widget>[
          EmptyMedia(glyph: glyph),
          EmptyTitle(title),
          EmptyDescription(description),
        ],
      ),
      EmptyContent(
        children: <Widget>[
          Button(
            variant: actionVariant,
            onPressed: onAction,
            child: StyledText(actionLabel, TextStyles.buttonLabel),
          ),
        ],
      ),
    ],
  );
}

/// A failure inside one region. The rest of the page keeps working.
///
/// Order is fixed: what happened, what it means, the one next step, and only
/// then the technical details, collapsed.
class RegionFailure extends StatefulWidget {
  const RegionFailure({super.key, required this.error, this.onRetry});

  final AppError error;
  final VoidCallback? onRetry;

  @override
  State<RegionFailure> createState() => _RegionFailureState();
}

class _RegionFailureState extends State<RegionFailure> {
  bool _showDiagnostics = false;

  @override
  Widget build(BuildContext context) {
    final AppError error = widget.error;
    if (error.isSilent) return const SizedBox.shrink();

    final bool canRetry = error.retryable && widget.onRetry != null;

    return Semantics(
      liveRegion: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Alert(
            title: error.title,
            description: error.body,
            variant: switch (error.kind) {
              ErrorKind.offline || ErrorKind.rateLimited =>
                AlertVariant.warning,
              _ => AlertVariant.destructive,
            },
            icon: Icon(switch (error.kind) {
              ErrorKind.offline => IconGlyph.alertTriangle,
              ErrorKind.rateLimited => IconGlyph.hourglass,
              _ => IconGlyph.octagonX,
            }),
            action: canRetry
                ? Button(
                    variant: ButtonVariant.outline,
                    size: ButtonSize.sm,
                    onPressed: widget.onRetry,
                    child: StyledText(
                      error.nextStep,
                      TextStyles.buttonLabelSm,
                    ),
                  )
                : null,
          ),
          // Every failure carries one next step, retryable or not. Tying the
          // next step to the retry button loses it exactly where it matters
          // most: a declined card, a forbidden page, a conflict.
          if (!canRetry && error.nextStep.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: space(2)),
              child: StyledText(error.nextStep, TextStyles.body),
            ),
          if (error.diagnostics != null) ...<Widget>[
            SizedBox(height: space(2)),
            Collapsible(
              open: _showDiagnostics,
              trigger: Align(
                alignment: Alignment.centerLeft,
                child: Button(
                  variant: ButtonVariant.ghost,
                  size: ButtonSize.sm,
                  onPressed: () =>
                      setState(() => _showDiagnostics = !_showDiagnostics),
                  child: StyledText(
                    _showDiagnostics
                        ? 'Hide technical details'
                        : 'Technical details',
                    TextStyles.buttonLabelSm,
                  ),
                ),
              ),
              content: Padding(
                padding: EdgeInsets.only(top: space(2)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    StyledText(error.diagnostics!, TextStyles.code),
                    ?switch (error.correlationId) {
                      final String id => StyledText(
                        'Reference $id',
                        TextStyles.caption,
                      ),
                      _ => null,
                    },
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A page that cannot render at all. Navigation stays reachable and there is a
/// way back.
class PageFailure extends StatelessWidget {
  const PageFailure({super.key, required this.error, required this.onBack});

  final AppError error;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => RegionEmpty(
    glyph: switch (error.kind) {
      ErrorKind.forbidden || ErrorKind.unauthenticated => IconGlyph.lock,
      _ => IconGlyph.search,
    },
    title: error.title,
    description: error.body ?? '',
    actionLabel: error.nextStep,
    onAction: onBack,
    actionVariant: ButtonVariant.outline,
  );
}

/// A region heading that survives every state, so the page does not reflow when
/// data arrives.
class RegionHeader extends StatelessWidget {
  const RegionHeader({
    super.key,
    required this.title,
    this.description,
    this.trailing,
    this.refreshing = false,
  });

  final String title;
  final String? description;
  final Widget? trailing;

  /// Refresh keeps the data and adds this, rather than swapping back to
  /// skeletons.
  final bool refreshing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: space(3)),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Flexible(child: StyledText(title, TextStyles.h3)),
                  if (refreshing) ...<Widget>[
                    SizedBox(width: space(2)),
                    Semantics(
                      label: 'Refreshing',
                      child: Spinner(size: space(4)),
                    ),
                  ],
                ],
              ),
              ?switch (description) {
                final String text => StyledText(text, TextStyles.small),
                _ => null,
              },
            ],
          ),
        ),
        ?trailing,
      ],
    ),
  );
}
