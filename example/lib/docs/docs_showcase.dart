// example/lib/docs/docs_showcase.dart
/// The specimen frame, and the Preview↔Code toggle over it.
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

import 'docs_snippet.dart';

/// The neutral stage a specimen is judged on.
///
/// Separate from [DocsShowcase] so a specimen that needs its own alignment —
/// a full-width bar, a stacked group — can use the stage without the toggle.
class DocsShowcaseFrame extends StatelessWidget {
  const DocsShowcaseFrame({
    super.key,
    required this.child,
    this.alignment = Alignment.center,
    required this.minHeight,
  });

  final Widget child;
  final Alignment alignment;
  final double minHeight;

  /// The stage's inner padding, so a specimen never touches the border.
  static double get padding => space(6);

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Container(
      constraints: BoxConstraints(minHeight: minHeight),
      width: double.infinity,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: theme.background,
        border: Border.all(color: theme.border, width: BorderWidths.hairline),
        borderRadius: BorderRadius.circular(Radii.lg),
      ),
      child: Align(alignment: alignment, child: child),
    );
  }
}

/// A specimen and its source, one visible at a time.
class DocsShowcase extends StatefulWidget {
  const DocsShowcase({
    super.key,
    required this.specimen,
    required this.code,
    this.alignment = Alignment.center,
    this.label,
    this.minHeight,
  });

  /// The live component, rendered in the Preview pane.
  final Widget specimen;

  /// The source that produces [specimen], rendered in the Code pane.
  final String code;

  final Alignment alignment;

  /// The toggle group's accessible name. Defaults to `'Specimen view'`, the
  /// name every showcase used before this field existed: a page with many
  /// showcases on it should pass its own, since a screen reader otherwise
  /// hears the same name once per showcase.
  final String? label;

  /// This stage's own minimum, overriding the breakpoint default.
  ///
  /// Null keeps [minHeightFor], which is what every call site wanted before
  /// this field existed. A section passes its own when its specimen has a
  /// size of its own worth respecting: a chart, a dialog and a sheet want
  /// the room; a lone pill does not, and 640 of it read as a mistake.
  final double? minHeight;

  /// The stage's default minimum.
  ///
  /// **Was 640** — the reading column's own measure, on the reasoning that a
  /// specimen judged in a shorter box reads as cramped. Held against a real
  /// page that turned out to be the wrong default by an order of magnitude:
  /// the Button page put sixteen single pills each in the middle of its own
  /// 640 box and stood 17,925px tall, which reads as a page of empty rooms
  /// rather than as generous framing. The default is now the shorter
  /// measure, and a section that genuinely needs the height asks for it —
  /// [minHeight] — so one tall specimen costs one line instead of every
  /// short one costing 400px.
  static double get tallMinHeight => space(96);

  /// Kept as its own name because [EffectSection] and the narrow branch both
  /// mean *this* measure specifically, not "whatever the default happens to
  /// be": if a later change raises [tallMinHeight] again, an effect's host
  /// and a phone's stage should not follow it up.
  static double get shortMinHeight => space(96);

  static double minHeightFor(double viewportWidth) =>
      viewportWidth < Breakpoints.sm ? shortMinHeight : tallMinHeight;

  @override
  State<DocsShowcase> createState() => _DocsShowcaseState();
}

class _DocsShowcaseState extends State<DocsShowcase> {
  /// Per instance, not per page: a reader who opens the code for one variant
  /// has said nothing about the next one.
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final double minHeight =
        widget.minHeight ??
        DocsShowcase.minHeightFor(MediaQuery.sizeOf(context).width);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: ToggleGroup(
            label: widget.label ?? 'Specimen view',
            items: const <ToggleGroupItem>[
              ToggleGroupItem(label: 'Preview'),
              ToggleGroupItem(label: 'Code'),
            ],
            selectedIndex: _selected,
            // Null means the tapped option was already selected. A view
            // toggle has no deselected state, so that is a no-op here.
            onChanged: (int? index) =>
                setState(() => _selected = index ?? _selected),
          ),
        ),
        SizedBox(height: space(3)),
        if (_selected == 0)
          DocsShowcaseFrame(
            alignment: widget.alignment,
            minHeight: minHeight,
            child: widget.specimen,
          )
        else
          DocsSnippet(code: widget.code, maxHeight: minHeight),
      ],
    );
  }
}
