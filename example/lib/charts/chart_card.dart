// example/lib/charts/chart_card.dart
/// One gallery card: the reference's own card, with this system's parts.
///
/// The toolbar sits above the card rather than in [CardHeader]'s action slot.
/// That slot is real and unused on sixty-six of the seventy, but the four
/// interactive specimens need it for their range picker, and a top-right
/// corner that means "copy this" on most cards and "change the range" on the
/// rest is worse than a strip that always means the same thing.
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

import '../docs/docs_copy_button.dart';
import '../docs/docs_snippet.dart';
import 'chart_ink.dart';
import 'chart_sources.g.dart';
import 'chart_specimen.dart';
import 'chart_states.dart';

class ChartSpecimenCard extends StatelessWidget {
  const ChartSpecimenCard({
    super.key,
    required this.specimen,
    required this.ink,
    this.writer,
  });

  final ChartSpecimen specimen;
  final ChartInk ink;

  /// Injected so a test can observe a copy without a platform channel.
  final DocsClipboardWriter? writer;

  String get _source =>
      chartSources[specimen.id] ?? '// no source generated for ${specimen.id}';

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _Toolbar(
          id: specimen.id,
          source: _source,
          title: specimen.title,
          writer: writer,
        ),
        SizedBox(height: space(2)),
        Card(
          children: <Widget>[
            CardHeader(
              title: CardTitle(specimen.title),
              description: CardDescription(specimen.note),
            ),
            CardContent(
              child: ChartStateSwitch(
                groupLabel: '${specimen.title} — chart state',
                skeleton: specimen.skeleton,
                child: Builder(
                  builder: (BuildContext context) =>
                      specimen.build(context, ink),
                ),
              ),
            ),
            if (specimen.copy.hasFooter)
              CardFooter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          child: StyledText(
                            specimen.copy.trend,
                            TextStyles.small,
                          ),
                        ),
                        SizedBox(width: space(2)),
                        Icon.lucide(Lucide.trendingUp, size: IconSize.sm),
                      ],
                    ),
                    SizedBox(height: space(1)),
                    StyledText(
                      specimen.copy.range,
                      TextStyles.small,
                      color: theme.mutedForeground,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// The strip above the card: the registry id, then Copy and View Code.
class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.id,
    required this.source,
    required this.title,
    required this.writer,
  });

  final String id;
  final String source;
  final String title;
  final DocsClipboardWriter? writer;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Row(
      children: <Widget>[
        Expanded(
          child: StyledText(
            id,
            TextStyles.code,
            color: theme.mutedForeground,
          ),
        ),
        DocsCopyButton(text: source, writer: writer),
        SizedBox(width: space(2)),
        SheetOverlay(
          side: SheetSide.right,
          trigger: (BuildContext context, VoidCallback open) => Button(
            variant: ButtonVariant.secondary,
            size: ButtonSize.sm,
            onPressed: open,
            child: const Text('View Code'),
          ),
          content: (BuildContext context, VoidCallback close) => SheetContent(
            side: SheetSide.right,
            width: _sheetWidth(context),
            onClose: close,
            // No [SheetHeader]/[SheetFooter] band here to carry padding of
            // its own, so the body pays it directly — same `px-4` convention
            // as the sheet doc page's and dialogs page's own bare-content
            // rows (`example/lib/components_docs/sheet/page.dart`,
            // `example/lib/pages/dialogs.dart`), with a top/bottom edge
            // added since there is no header/footer band to supply it.
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(space(4), space(4), space(4), 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    StyledText(title, TextStyles.h4),
                    SizedBox(height: space(1)),
                    StyledText(
                      id,
                      TextStyles.code,
                      color: theme.mutedForeground,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(space(4), 0, space(4), space(4)),
                  child: SingleChildScrollView(
                    child: DocsSnippet(code: source, language: 'dart'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// `SheetContent`'s own `sm:max-w-sm` is 384, too narrow for source. The
  /// sheet takes half the viewport, floored at the container scale the code
  /// blocks elsewhere on the site read at.
  double _sheetWidth(BuildContext context) {
    final double half = MediaQuery.sizeOf(context).width / 2;
    return half < Containers.sm ? Containers.sm : half;
  }
}
