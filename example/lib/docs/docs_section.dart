// example/lib/docs/docs_section.dart
/// A documentation section, and the anchor a table of contents scrolls to.
///
/// These were one class. They are two because 92 files call the old one and
/// only its presentation is being rebuilt: keeping the anchor registry
/// separate means the rebuild touches no call site.
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
import 'package:flutter/widgets.dart' as flutter show ScrollPosition;

import 'docs_layout.dart' show docsAnchorKey;

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
  /// `ScrollOffsets.anchoredHeading` below the viewport top.
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
        ScrollOffsets.anchoredHeading;
    final flutter.ScrollPosition position = scrollable.position;
    await position.animateTo(
      (position.pixels + delta).clamp(
        position.minScrollExtent,
        position.maxScrollExtent,
      ),
      duration: effectiveMotionDuration(target, MotionDurations.slow),
      curve: MotionCurves.move,
    );
  }

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    // Two keys, because two mechanisms look for this target and neither can
    // see the other's. [scrollTo] resolves the [GlobalKey] registry above;
    // `docs_layout.dart` walks its own article for a `docsAnchorKey` value
    // key and never touches that registry, so a `DocsSection` carrying only
    // the global key was invisible to the table of contents, and every TOC
    // row on all seven `docs_pages/` articles resolved to nothing and
    // silently scrolled nowhere. Marking both makes one section answer both
    // callers without either learning about the other.
    key: docsAnchorKey(id),
    child: KeyedSubtree(key: keyFor(id), child: child),
  );
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
  static double get spacing => space(20);

  /// The gap between the heading block and the section's body.
  static double get headingGap => space(6);

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
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
                      StyledText(title, TextStyles.h3, color: theme.foreground),
                    if (description != null) ...<Widget>[
                      if (heading) SizedBox(height: space(2)),
                      // Full width. The old private measure cap left a gap on
                      // the right of every section.
                      StyledText(description!, TextStyles.small),
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
