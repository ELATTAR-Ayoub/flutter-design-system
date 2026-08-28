/// A plain navigational link, for use inside a documentation article.
///
/// The `/components` index already had one: `public_pages.dart`'s private
/// `_ComponentLinkRow` — `Semantics(link: true)`, a click cursor, and a
/// [TweenAnimationBuilder] cross-fade from `mutedForeground` to `actionText`
/// on hover, the same idiom `docs_sidebar.dart`'s `_SidebarRow` and
/// `breadcrumb.dart` use. That shape was private to that one page, so every
/// cross-reference written *inside* an article — the Dependencies disclosure
/// naming the components a component is built from, a "see also" in prose,
/// the "ON THIS PAGE" rail's own rows — rendered as inert text that a reader
/// could not tell apart from a caption.
///
/// This is that link, extracted verbatim and parameterised, so the
/// affordance is the same everywhere a documentation page names something
/// else: hover changes the ink, the cursor is a pointer, and a screen reader
/// is told it is a link.
///
/// It carries no route table of its own. A caller either hands it [onTap]
/// directly (the rail, whose rows scroll rather than navigate — see the
/// library note in `docs_layout.dart`) or a [route], which is opened through
/// the ambient [AppRouterScope] exactly as the rails do.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
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

import '../shell.dart' show AppRouterScope;

/// One link.
///
/// Renders as a single inline-ish run of text, sized by [spec] (default
/// [TextStyles.small], the size every other navigational row in the
/// documentation shell uses). Pass [underline] for prose, where a run of
/// coloured text inside a sentence needs a second signal; leave it off in a
/// list or a rail, where position already says "these are links" — that is
/// the `/components` index's own choice and the reference's.
class DocsLink extends StatefulWidget {
  const DocsLink({
    super.key,
    required this.label,
    this.route,
    this.onTap,
    this.spec,
    this.underline = false,
    this.semanticsLabel,
  });

  /// The text as authored.
  final String label;

  /// Opened through [AppRouterScope] when tapped, unless [onTap] is given.
  ///
  /// Null for a link that does something other than route — a rail row that
  /// scrolls the article, say.
  final String? route;

  /// Runs instead of routing to [route]. Takes priority: a caller that hands
  /// both means the callback.
  final VoidCallback? onTap;

  /// The type class the label renders in. Defaults to [TextStyles.small], the
  /// size every other navigational row in the documentation shell uses.
  /// Nullable rather than defaulted in the constructor because [TextStyles.small]
  /// is not a compile-time constant, and a link ought to stay `const`-able.
  final TextStyleToken? spec;

  /// Draws a hairline under the label, in whatever ink the label currently
  /// carries, so a link inside a sentence is distinguishable without colour
  /// alone.
  final bool underline;

  /// Overrides what a screen reader announces. Defaults to [label].
  final String? semanticsLabel;

  @override
  State<DocsLink> createState() => _DocsLinkState();
}

class _DocsLinkState extends State<DocsLink> {
  bool _hovered = false;

  void _hover(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  /// Nothing to press when a caller supplied neither a callback nor a route
  /// — the link renders as plain text rather than lying about being one.
  bool get _enabled => widget.onTap != null || widget.route != null;

  void _tap() {
    final VoidCallback? onTap = widget.onTap;
    if (onTap != null) {
      onTap();
      return;
    }
    final String? route = widget.route;
    if (route == null) return;
    AppRouterScope.maybeOf(context)?.navigate(route);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final TextStyleToken spec = widget.spec ?? TextStyles.small;
    if (!_enabled) {
      return StyledText(widget.label, spec, color: theme.mutedForeground);
    }
    final Duration duration = effectiveMotionDuration(
      context,
      MotionDurations.normal,
    );
    return Semantics(
      link: true,
      // Only ever an override. Left null, the label comes from the [StyledText]
      // below and merges up, which is what `public_pages.dart`'s own link
      // does — setting it here as well announced the label twice.
      label: widget.semanticsLabel,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => _hover(true),
        onExit: (_) => _hover(false),
        child: GestureDetector(
          onTap: _tap,
          behavior: HitTestBehavior.opaque,
          child: TweenAnimationBuilder<Color?>(
            tween: ColorTween(
              end: _hovered ? theme.actionText : theme.mutedForeground,
            ),
            duration: duration,
            curve: MotionCurves.enter,
            builder: (BuildContext context, Color? ink, Widget? _) {
              final Color resolved = ink ?? theme.mutedForeground;
              final Widget text = StyledText(
                widget.label,
                spec,
                color: resolved,
              );
              if (!widget.underline) return text;
              return DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: resolved,
                      width: BorderWidths.hairline,
                    ),
                  ),
                ),
                child: text,
              );
            },
          ),
        ),
      ),
    );
  }
}

/// A wrapped row of [DocsLink]s — what a Dependencies disclosure lists.
///
/// A component page's Dependencies section names the other registry items a
/// component pulls in. Those were prose before this existed, which meant the
/// one place a reader most wants to jump sideways was the one place they
/// could not. Each entry here is a real link to that item's own page.
class DocsLinkRow extends StatelessWidget {
  const DocsLinkRow({super.key, required this.links});

  final List<DocsLink> links;

  @override
  Widget build(BuildContext context) {
    if (links.isEmpty) return const SizedBox.shrink();
    return Wrap(spacing: space(4), runSpacing: space(2), children: links);
  }
}
