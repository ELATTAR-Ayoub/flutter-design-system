// example/lib/docs/docs_showcase.dart
/// The specimen frame, and the Preview↔Code toggle over it.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

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
  static double get padding => el(6);

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Container(
      constraints: BoxConstraints(minHeight: minHeight),
      width: double.infinity,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: theme.background,
        border: Border.all(color: theme.border, width: ElWidths.hairline),
        borderRadius: BorderRadius.circular(ElRadii.lg),
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

  /// The stage height. 640 is the reading column's own measure, and a
  /// specimen judged in a shorter box reads as cramped.
  static double get tallMinHeight => el(160);

  /// Below `ElBreakpoints.sm` a 640 stage is taller than the whole viewport
  /// minus header and toggle, which would push the control off screen.
  static double get shortMinHeight => el(96);

  static double minHeightFor(double viewportWidth) =>
      viewportWidth < ElBreakpoints.sm ? shortMinHeight : tallMinHeight;

  @override
  State<DocsShowcase> createState() => _DocsShowcaseState();
}

class _DocsShowcaseState extends State<DocsShowcase> {
  /// Per instance, not per page: a reader who opens the code for one variant
  /// has said nothing about the next one.
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final double minHeight = DocsShowcase.minHeightFor(
      MediaQuery.sizeOf(context).width,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: ElToggleGroup(
            label: widget.label ?? 'Specimen view',
            items: const <ElToggleGroupItem>[
              ElToggleGroupItem(label: 'Preview'),
              ElToggleGroupItem(label: 'Code'),
            ],
            selectedIndex: _selected,
            // Null means the tapped option was already selected. A view
            // toggle has no deselected state, so that is a no-op here.
            onChanged: (int? index) =>
                setState(() => _selected = index ?? _selected),
          ),
        ),
        SizedBox(height: el(3)),
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
