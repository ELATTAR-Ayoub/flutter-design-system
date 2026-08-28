/// The collapsible every text-or-table section of a documentation page uses.
///
/// Closed by default, including the API reference. A component page is read
/// for its specimens; the reference is what you open when you have a
/// question, and eight open reference tables between you and the next
/// specimen is not a page anybody scrolls.
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

class DocsDisclosure extends StatefulWidget {
  const DocsDisclosure({
    super.key,
    required this.title,
    required this.child,
    this.initiallyOpen = false,
  });

  final String title;
  final Widget child;
  final bool initiallyOpen;

  /// The trigger row, so a test can measure and activate the real control
  /// rather than the text inside it.
  static const ValueKey<String> triggerKey = ValueKey<String>(
    'docs-disclosure-trigger',
  );

  /// The trigger row's height.
  static double get triggerHeight => space(12);

  /// A half turn: chevron down closed, chevron up open.
  static const double openTurns = 0.5;

  @override
  State<DocsDisclosure> createState() => _DocsDisclosureState();
}

class _DocsDisclosureState extends State<DocsDisclosure>
    with SingleTickerProviderStateMixin {
  late bool _open = widget.initiallyOpen;

  late final AnimationController _chevron = AnimationController(
    vsync: this,
    duration: MotionDurations.normal,
    value: _open ? 1 : 0,
  );

  late final Animation<double> _turns = Tween<double>(
    begin: 0,
    end: DocsDisclosure.openTurns,
  ).animate(CurvedAnimation(parent: _chevron, curve: MotionCurves.move));

  @override
  void dispose() {
    _chevron.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _open = !_open);
    if (_open) {
      _chevron.forward();
    } else {
      _chevron.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Collapsible(
      open: _open,
      trigger: Semantics(
        button: true,
        expanded: _open,
        label: widget.title,
        child: GestureDetector(
          key: DocsDisclosure.triggerKey,
          behavior: HitTestBehavior.opaque,
          onTap: _toggle,
          child: SizedBox(
            width: double.infinity,
            height: DocsDisclosure.triggerHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // [Expanded] and a single ellipsised line, because the
                // trigger's height is fixed at [triggerHeight] and its width
                // is the reading column's. An unconstrained title in this
                // Row overflowed on a phone the moment a page used one
                // longer than about thirty characters — a real
                // `RenderFlex overflowed` at 390px, found by a page whose
                // disclosure was called "What this port leaves out". Every
                // page shares this widget, so that was a defect waiting for
                // whichever of the ninety-nine wrote a long enough heading,
                // and the fix belongs here rather than in a title.
                //
                // The full title is never lost: the [Semantics] wrapper
                // above carries it as this control's label, so a screen
                // reader still hears all of it.
                Expanded(
                  child: StyledText(
                    widget.title,
                    TextStyles.h4,
                    color: theme.foreground,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: space(2)),
                RotationTransition(
                  turns: _turns,
                  child: Icon.lucide(Lucide.chevronDown, size: IconSize.md),
                ),
              ],
            ),
          ),
        ),
      ),
      content: Padding(
        padding: EdgeInsets.only(top: space(4)),
        child: widget.child,
      ),
    );
  }
}
