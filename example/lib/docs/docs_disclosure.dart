/// The collapsible every text-or-table section of a documentation page uses.
///
/// Closed by default, including the API reference. A component page is read
/// for its specimens; the reference is what you open when you have a
/// question, and eight open reference tables between you and the next
/// specimen is not a page anybody scrolls.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

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
  static double get triggerHeight => el(12);

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
    duration: ElDurations.base,
    value: _open ? 1 : 0,
  );

  late final Animation<double> _turns = Tween<double>(
    begin: 0,
    end: DocsDisclosure.openTurns,
  ).animate(CurvedAnimation(parent: _chevron, curve: ElCurves.inOut));

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
    final ElThemeData theme = ElTheme.of(context);

    return ElCollapsible(
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
                ElText(widget.title, ElType.h4, color: theme.foreground),
                RotationTransition(
                  turns: _turns,
                  child: ElIcon.lucide(
                    ElLucide.chevronDown,
                    size: ElIconSize.md,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      content: Padding(
        padding: EdgeInsets.only(top: el(4)),
        child: widget.child,
      ),
    );
  }
}
