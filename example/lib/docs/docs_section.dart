// example/lib/docs/docs_section.dart
/// A documentation section, and the anchor a table of contents scrolls to.
///
/// These were one class. They are two because 92 files call the old one and
/// only its presentation is being rebuilt: keeping the anchor registry
/// separate means the rebuild touches no call site.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

/// Registers [child] under [id] so [scrollTo] can find it later.
class DocsAnchor extends StatelessWidget {
  const DocsAnchor({super.key, required this.id, required this.child});

  final String id;
  final Widget child;

  /// One key per id, kept so a later lookup finds the same object.
  ///
  /// Not a `GlobalObjectKey`: its equality is identity on the value, and two
  /// interpolated strings with the same characters are not the same object —
  /// the lookup would silently miss.
  static final Map<String, GlobalKey<State<StatefulWidget>>> _keys =
      <String, GlobalKey<State<StatefulWidget>>>{};

  static GlobalKey<State<StatefulWidget>> keyFor(String id) =>
      _keys.putIfAbsent(id, () => GlobalKey<State<StatefulWidget>>());

  /// Scrolls to the section registered under [id], resting
  /// `ElWidths.scrollOffset` below the viewport top.
  static Future<void> scrollTo(String id) async {
    final BuildContext? target = keyFor(id).currentContext;
    if (target == null) return;
    final ScrollableState? scrollable = Scrollable.maybeOf(target);
    if (scrollable == null) return;

    final RenderObject? box = target.findRenderObject();
    final RenderObject? viewport = scrollable.context.findRenderObject();
    if (box is! RenderBox || viewport is! RenderBox) return;

    final double delta =
        box.localToGlobal(Offset.zero, ancestor: viewport).dy -
        ElWidths.scrollOffset;
    final ScrollPosition position = scrollable.position;
    await position.animateTo(
      (position.pixels + delta).clamp(
        position.minScrollExtent,
        position.maxScrollExtent,
      ),
      duration: elAnimationDuration(target, ElDurations.slow),
      curve: ElCurves.inOut,
    );
  }

  @override
  Widget build(BuildContext context) =>
      KeyedSubtree(key: keyFor(id), child: child);
}

/// A titled section of a documentation page.
class DocsSection extends StatelessWidget {
  const DocsSection({
    super.key,
    required this.id,
    required this.title,
    this.description,
    required this.child,
    this.heading = true,
  });

  final String id;
  final String title;
  final String? description;
  final Widget child;

  /// Whether to print [title] above [child].
  ///
  /// False for a section whose body already carries the title as part of its
  /// own control — a [DocsDisclosure], whose trigger row IS the heading, with
  /// the chevron beside it. Rendering both printed the title twice: once as
  /// this section's `.type-h3`, and again as the trigger's `.type-h4`
  /// directly beneath it, on all eight trailing disclosures of all
  /// ninety-nine component pages.
  ///
  /// The anchor, the spacing and [description] are unaffected — only the
  /// heading line is dropped, so the rail still scrolls here and a
  /// description still introduces what the disclosure holds before a reader
  /// opens it.
  final bool heading;

  /// The gap under the whole section.
  static double get spacing => el(20);

  /// The gap between the heading block and the section's body.
  static double get headingGap => el(6);

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return DocsAnchor(
      id: id,
      child: Padding(
        padding: EdgeInsets.only(bottom: spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (heading || description != null)
              Padding(
                padding: EdgeInsets.only(bottom: headingGap),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // An `h2` wearing `.type-h3`, intentionally.
                    if (heading)
                      ElText(title, ElType.h3, color: theme.foreground),
                    if (description != null) ...<Widget>[
                      if (heading) SizedBox(height: el(2)),
                      // Full width. The old private measure cap left a gap on
                      // the right of every section.
                      ElText(description!, ElType.small),
                    ],
                  ],
                ),
              ),
            child,
          ],
        ),
      ),
    );
  }
}
