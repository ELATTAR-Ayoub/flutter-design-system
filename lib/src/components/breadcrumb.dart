/// `components/ui/breadcrumb.tsx` — the trail back out of a detail page.
///
/// The page's own framing: *"Used on pack detail pages, where the user arrived
/// from a filtered marketplace and needs a way back to it."* And the rule under
/// the specimen: *"The current page is a `BreadcrumbPage`, not a link — it
/// carries `aria-current` and is not clickable."*
///
/// **Resolved, measured on the live reference at 1440 × 900 (2026-08-16):**
///
/// | slot | class list | measured |
/// |---|---|---|
/// | `nav` | `aria-label="breadcrumb"` only | a bare block |
/// | `ol` | `flex flex-wrap items-center gap-1.5 text-sm wrap-break-word text-muted-foreground` | 6px gaps, 13px / 18.5714 line box, `--muted-foreground` |
/// | `li` | `inline-flex items-center gap-1` | 4px — **and inert**: every item on this page holds exactly one child |
/// | `a` | `transition-colors hover:text-foreground` | `--muted-foreground` → `--foreground` over 0.25s `--ease-out` |
/// | `span` (page) | `font-normal text-foreground` | 13px / **400** — the one place the trail is not muted |
/// | `li` (separator) | `[&>svg]:size-3.5` around a default-size `Icon` | a **14px** chevron |
///
/// The separator is the port's clearest small drift and it is reproduced
/// exactly: `<Icon icon={ChevronRightIcon} />` takes `Icon`'s own `md` default,
/// so the SVG carries `width="16" height="16"` **and** computes its
/// `strokeWidth` from 16 — while `[&>svg]:size-3.5` wins the box at 14. Buttons
/// map drift 6, from the other side. It is invisible only because
/// [DsIcon.strokeFor] snaps 14 and 16 to the same 2.4.
///
/// **Direction is context, not a second component** (§2 of the page). The RTL
/// specimen is this exact composition inside a `DirectionProvider` — in Flutter
/// a [Directionality] — and every box in it flips because the row is laid out
/// in the reading direction. The chevron does **not** flip: nothing in the
/// class list mirrors it, and the probe finds the same `chevron-right`
/// geometry pointing the same way in both specimens.
///
/// **`BreadcrumbEllipsis` is recorded, not built.** The file exports it; the
/// page renders no collapsed trail. The `asChild` precedent applies — a
/// parameter for a shape the reference never mounts would be a promise this
/// port has not measured.
library;

import 'package:flutter/widgets.dart';

import '../foundation/motion.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../theme_scope.dart';
import 'icon.dart';
import 'icon_paths.dart';

/// One crumb: a link back, or the page you are on.
@immutable
class DsBreadcrumbEntry {
  /// `BreadcrumbLink` — a step in the trail.
  const DsBreadcrumbEntry.link(this.label, {this.onTap}) : isPage = false;

  /// `BreadcrumbPage` — the current page. `role="link" aria-disabled="true"
  /// aria-current="page"`, and deliberately not clickable.
  const DsBreadcrumbEntry.page(this.label)
      : onTap = null,
        isPage = true;

  final String label;

  /// `href`. The page's own trail points its two links at `#`, so tapping them
  /// does nothing there either; null is that, spelled honestly.
  final VoidCallback? onTap;

  final bool isPage;
}

/// The trail. Separators are placed between adjacent entries.
///
/// The reference writes each `BreadcrumbSeparator` out by hand, and both
/// specimens put exactly one between every pair — so the port derives them
/// rather than making the caller interleave two kinds of thing into one list.
/// A caller cannot express "two crumbs with no separator", which the reference
/// never asks for.
class DsBreadcrumb extends StatelessWidget {
  const DsBreadcrumb({super.key, required this.items});

  final List<DsBreadcrumbEntry> items;

  /// `gap-1.5` on the list — both axes, since it is a `flex-wrap` row.
  static double get gap => ds(1.5);

  /// `[&>svg]:size-3.5` — the separator's own box.
  static double get separatorPx => ds(3.5);

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    final List<Widget> row = <Widget>[];
    for (int i = 0; i < items.length; i++) {
      if (i > 0) {
        row.add(
          // `role="presentation" aria-hidden="true"` — excluded, not labelled.
          ExcludeSemantics(
            child: DsIcon(
              DsIconGlyph.chevronRight,
              sizePx: separatorPx,
              tone: DsIconTone.inherit,
              // The stroke the reference computes from the size the *attribute*
              // declares, not the size the class forces. Both land on 2.4, so
              // this is a statement rather than a correction.
              strokeOverride: DsIcon.strokeFor(DsIcon.pxFor(DsIconSize.md)),
            ),
          ),
        );
      }
      row.add(_DsCrumb(entry: items[i]));
    }

    return Semantics(
      container: true,
      // `aria-label="breadcrumb"` on the `nav`.
      label: 'breadcrumb',
      explicitChildNodes: true,
      child: DefaultTextStyle(
        // `text-sm … text-muted-foreground` on the `ol`: an ambient style the
        // crumbs inherit and the current page overrides.
        style: DsText.styleOf(
          context,
          DsComponentType.textSm,
          color: theme.mutedForeground,
        ),
        // The separator's `tone: inherit` reads that same [DefaultTextStyle],
        // which is how a `currentColor` stroke inherits in CSS.
        child: Wrap(
          spacing: gap,
          runSpacing: gap,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: row,
        ),
      ),
    );
  }
}

/// One `li` and the link or span inside it.
class _DsCrumb extends StatefulWidget {
  const _DsCrumb({required this.entry});

  final DsBreadcrumbEntry entry;

  @override
  State<_DsCrumb> createState() => _DsCrumbState();
}

class _DsCrumbState extends State<_DsCrumb> {
  bool _hovered = false;

  void _hover(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    if (widget.entry.isPage) {
      return Semantics(
        link: true,
        enabled: false,
        child: DsText(
          widget.entry.label,
          // `font-normal` on a list already set to `text-sm`: 13px at the
          // inherited 400, which is exactly [DsComponentType.textSm]. The
          // declaration is a no-op against `html`'s own weight and is written
          // anyway — reproduced by naming the spec that already says it.
          DsComponentType.textSm,
          color: theme.foreground,
        ),
      );
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _hover(true),
      onExit: (_) => _hover(false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.entry.onTap,
        child: Semantics(
          link: true,
          child: TweenAnimationBuilder<Color?>(
            // `transition-colors` with no duration utility beside it at all —
            // the framework default in its purest form.
            tween: ColorTween(
              end: _hovered ? theme.foreground : theme.mutedForeground,
            ),
            duration:
                dsAnimationDuration(context, DsDurations.transitionDefault),
            curve: DsCurves.out,
            builder: (BuildContext context, Color? ink, Widget? _) => DsText(
              widget.entry.label,
              DsComponentType.textSm,
              color: ink ?? theme.mutedForeground,
            ),
          ),
        ),
      ),
    );
  }
}
