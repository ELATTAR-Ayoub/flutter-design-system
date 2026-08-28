/// `components/agent/parts/slash-palette.tsx` — the `/` menu.
///
/// Two kinds of thing live in here and the difference matters:
///
///   A **command** runs in the browser. `/clear`, `/stop`, `/voice` — the agent
///   never hears about them.
///
///   A **skill** is something the agent can actually do. These are not invented
///   by the console: they are the scope's real registered tools, fetched from
///   the server, so the palette cannot offer a capability the agent does not
///   have. Choosing one writes a directive into the composer that the agent
///   then acts on, which keeps the conversation a conversation — the user can
///   still edit the sentence before sending it.
///
/// Filtering is a plain substring match over the id and the label. Fuzzy
/// matching looks clever and then ranks `/clear` below `/recalculate` because
/// both contain the letters c-l-e-a-r, so it is not used here.
///
/// ## Measured
///
/// Every number is a computed style read off
/// `/design-system/components/agent/composer` at 1440×900 on 2026-08-16
/// (`scratchpad/ag-composer-live.js`, `ag-composer-hover2.js`,
/// `ag-composer-clip.js`).
///
/// | | value |
/// |---|---|
/// | box | `w-full` of the composer, `max-h-64` **256**, `rounded-lg` 12, 1px `--border`, `--popover`, `shadow-e3` |
/// | entrance | `anim-fade-up` → **`pulls-fade-up` 400ms `cubic-bezier(.22,1,.36,1)` both**, `translateY(10px)` → none, opacity 0 → 1 |
/// | group heading | `px-3 pt-3 pb-1` `.type-caption` — 10.5/14.175/500, **30.175** tall |
/// | row | `items-start gap-3 px-3 py-2`, **53.675** tall, `--accent` when active |
/// | row glyph | 16px at `mt-1`, `--agent`, stroke **2** (lucide's own, not the `Icon` wrapper's 2.4) |
/// | row text | `.type-small` over `.type-caption`, `flex-col gap-1` — 19.5 + 4 + 14.175 |
///
/// The entrance was the probe's first correction: `anim-fade-up` names no
/// duration or easing at its call site, and the utility resolves to a **400ms**
/// `--ease-out` run of a keyframe called `pulls-fade-up` — not the 250ms
/// class-list default the duration-word sweep leaves everywhere else.
library;

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Icon,
        OverlayPortal,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;

import '../../design_system/foundation/colors.dart';
import '../../design_system/foundation/motion.dart';
import '../../design_system/foundation/shadows.dart';
import '../../design_system/foundation/spacing.dart';
import '../../design_system/foundation/theme.dart';
import '../../design_system/foundation/typography.dart';
import '../../design_system/foundation/theme_scope.dart';
import './icon.dart';
import './icon_paths.dart';
import './icon_paths.g.dart';

/// `AgentCommand["group"]` — the two kinds, and the whole difference between
/// them is who runs them.
enum AgentCommandGroup {
  /// Runs in the browser. Never reaches the agent.
  command,

  /// Something the agent can actually do.
  skill,
}

/// `AgentCommand` (`slash-palette.tsx` L28).
@immutable
class AgentCommand {
  const AgentCommand({
    required this.id,
    required this.label,
    this.hint,
    required this.group,
    this.icon,
    this.run,
    this.directive,
  });

  final String id;
  final String label;
  final String? hint;
  final AgentCommandGroup group;

  /// *"The glyph shown in the plus menu and this palette. Usually derived from
  /// the state the command's tool maps to — see `state-icons.ts` — so one
  /// capability carries one mark everywhere it appears."*
  ///
  /// A [LucideGlyph] rather than the icons page's curated [IconGlyph]: the
  /// reference's type is `LucideIcon`, which is the whole set, and
  /// `state-icons.ts` reaches for glyphs the whitelist does not carry.
  final LucideGlyph? icon;

  /// *"Runs in the browser. Mutually exclusive with [directive]."*
  final VoidCallback? run;

  /// *"Text written into the composer for the user to send."*
  final String? directive;
}

/// `String.prototype.slice(0, end)`, whose negative and out-of-range ends Dart's
/// [String.substring] does not have.
///
/// Load-bearing rather than pedantic: the composer's Escape handler sets the
/// caret to **−1**, and what `slice` does with that is exactly what makes
/// Escape fail to close the palette — see [slashQuery] and the composer's
/// drift register.
String _sliceTo(String value, int end) {
  final int resolved = end < 0
      ? (value.length + end < 0 ? 0 : value.length + end)
      : (end > value.length ? value.length : end);
  return value.substring(0, resolved);
}

/// `slashQuery` — *"The open query, or null when the palette should be
/// closed."*
///
/// *"Only a `/` that opens the message counts. Mid-sentence, a slash is a slash
/// — 'and/or' must not open a menu."*
String? slashQuery(String value, int caret) {
  if (!value.startsWith('/')) return null;
  final String upToCaret = _sliceTo(value, caret);
  if (upToCaret.contains(' ') || upToCaret.contains('\n')) return null;
  // `upToCaret.slice(1)` — empty in, empty out, which `substring(1)` would
  // throw on.
  return upToCaret.length <= 1 ? '' : upToCaret.substring(1);
}

/// `filterCommands` — a plain substring match over the id and the label.
List<AgentCommand> filterCommands(List<AgentCommand> commands, String query) {
  final String q = query.trim().toLowerCase();
  if (q.isEmpty) return commands;
  return commands
      .where(
        (AgentCommand c) =>
            c.id.toLowerCase().contains(q) || c.label.toLowerCase().contains(q),
      )
      .toList();
}

/// One `{title, items}` pair, in the order the palette renders them.
@immutable
class _Group {
  const _Group(this.title, this.items);

  final String title;
  final List<AgentCommand> items;
}

/// The `/` palette.
///
/// Stateless the way the reference's function component is: the open query, the
/// matches and the highlight all belong to the composer, which is the one place
/// the keyboard is routed. The two things this widget owns for itself — the
/// entrance and the scroll position — are internal, and both are reproduced
/// down to their bugs (see [AgentSlashPalette.scrollsGroupsNotRows]).
class AgentSlashPalette extends StatelessWidget {
  const AgentSlashPalette({
    super.key,
    required this.commands,
    required this.activeIndex,
    required this.onSelect,
    required this.onHover,
  });

  /// Already filtered — the composer runs [filterCommands].
  final List<AgentCommand> commands;

  final int activeIndex;
  final ValueChanged<AgentCommand> onSelect;
  final ValueChanged<int> onHover;

  /// `max-h-64`.
  static double get maxHeight => space(64);

  /// `mb-2` — the gap between the palette's bottom edge and the composer's top.
  static double get bottomGap => space(2);

  /// `anim-fade-up` — *(measured)* `pulls-fade-up 0.4s cubic-bezier(0.22, 1,
  /// 0.36, 1) both`. The class names neither number; the utility carries both.
  static Duration get entrance => MotionDurations.slow;

  /// The keyframe's own `translateY(10px)` at 0%.
  static double get rise => space(2.5);

  /// `px-3 pt-3 pb-1` on the group heading.
  static EdgeInsets get headingInsets =>
      EdgeInsets.fromLTRB(space(3), space(3), space(3), space(1));

  /// `px-3 py-2` on a row.
  static EdgeInsets get rowInsets =>
      EdgeInsets.symmetric(horizontal: space(3), vertical: space(2));

  /// `gap-3` between the glyph and the text column.
  static double get rowGap => space(3);

  /// `gap-1` between the two lines of the text column.
  static double get lineGap => space(1);

  /// `mt-1` on the glyph — it hangs one step below the first line's cap.
  static double get glyphTopInset => space(1);

  /// `size-4`.
  static double get glyphSize => space(4);

  /// lucide's own authored `stroke-width` in the 24-unit viewBox.
  ///
  /// A palette row renders `command.icon` — the raw lucide component — rather
  /// than `components/ui/icon.tsx`'s wrapper, so it keeps lucide's stroke
  /// instead of the wrapper's derived one. *(Measured: **2** here against
  /// **2.4** on the `Icon`-wrapped glyph two rows away in the plus menu.)*
  ///
  /// Spelled as the formula evaluated at its own grid, which is the theme
  /// toggle's idiom for the same fact.
  static double get lucideStroke => Icon.strokeFor(IconPaths.viewBox);

  /// **DRIFT.** *(Probed.)* `scrollIntoView` indexes the wrong list.
  ///
  /// `listRef` is on the **outer** `<ul>`, whose children are the two group
  /// `<li>`s, so `list.children[activeIndex]` is a *group* and not a row:
  /// index 0 scrolls the Skills group into view, index 1 the Commands group,
  /// and every index from 2 up resolves to `undefined` and scrolls nothing.
  /// Keyboard-walking past the second row therefore never brings the highlight
  /// back into view — while moving the pointer onto the **first** row scrolls
  /// the list under the pointer, which is how the probe found it.
  ///
  /// Reproduced exactly, including the no-op above index 1.
  static const bool scrollsGroupsNotRows = true;

  /// `[{ title: "Skills", … }, { title: "Commands", … }].filter(g =>
  /// g.items.length)` — Skills first, whatever order the caller's list is in,
  /// and a group with nothing in it does not print its heading.
  List<_Group> get _groups => <_Group>[
    _Group(
      'Skills',
      commands
          .where((AgentCommand c) => c.group == AgentCommandGroup.skill)
          .toList(),
    ),
    _Group(
      'Commands',
      commands
          .where((AgentCommand c) => c.group == AgentCommandGroup.command)
          .toList(),
    ),
  ].where((_Group g) => g.items.isNotEmpty).toList();

  @override
  Widget build(BuildContext context) {
    if (commands.isEmpty) return const SizedBox.shrink();
    return _PaletteBox(
      groups: _groups,
      activeIndex: activeIndex,
      onSelect: onSelect,
      onHover: onHover,
    );
  }
}

/// The scrolling box, and the one piece of state the palette owns.
class _PaletteBox extends StatefulWidget {
  const _PaletteBox({
    required this.groups,
    required this.activeIndex,
    required this.onSelect,
    required this.onHover,
  });

  final List<_Group> groups;
  final int activeIndex;
  final ValueChanged<AgentCommand> onSelect;
  final ValueChanged<int> onHover;

  @override
  State<_PaletteBox> createState() => _PaletteBoxState();
}

class _PaletteBoxState extends State<_PaletteBox> {
  final ScrollController _scroller = ScrollController();

  /// One key per **group**, because that is what the reference indexes — see
  /// [AgentSlashPalette.scrollsGroupsNotRows].
  final List<GlobalKey> _groupKeys = <GlobalKey>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollActiveIntoView(),
    );
  }

  @override
  void didUpdateWidget(_PaletteBox old) {
    super.didUpdateWidget(old);
    if (old.activeIndex != widget.activeIndex) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollActiveIntoView(),
      );
    }
  }

  @override
  void dispose() {
    _scroller.dispose();
    super.dispose();
  }

  /// `active?.scrollIntoView({ block: "nearest" })`, on the element the
  /// reference actually reaches — the **group** at `activeIndex`, or nothing
  /// at all once the index runs past the group count.
  ///
  /// `block: "nearest"` is the minimal scroll that makes the box whole: if it
  /// is already fully in view, nothing moves.
  void _scrollActiveIntoView() {
    if (!mounted || !_scroller.hasClients) return;
    final int i = widget.activeIndex;
    if (i < 0 || i >= _groupKeys.length) return;
    final BuildContext? target = _groupKeys[i].currentContext;
    final RenderObject? box = target?.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return;
    final RenderAbstractViewport? viewport = RenderAbstractViewport.maybeOf(
      box,
    );
    if (viewport == null) return;

    final double leading = viewport.getOffsetToReveal(box, 0).offset;
    final double trailing = viewport.getOffsetToReveal(box, 1).offset;
    final double current = _scroller.offset;
    final double? next = current > leading
        ? leading
        : (current < trailing ? trailing : null);
    if (next == null) return;
    _scroller.jumpTo(
      next.clamp(
        _scroller.position.minScrollExtent,
        _scroller.position.maxScrollExtent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    while (_groupKeys.length < widget.groups.length) {
      _groupKeys.add(GlobalKey());
    }

    int index = -1;
    final List<Widget> rows = <Widget>[];
    for (int g = 0; g < widget.groups.length; g++) {
      final _Group group = widget.groups[g];
      rows.add(
        KeyedSubtree(
          key: _groupKeys[g],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: AgentSlashPalette.headingInsets,
                child: StyledText(
                  group.title,
                  TextStyles.caption,
                  color: theme.mutedForeground,
                ),
              ),
              for (final AgentCommand command in group.items)
                Builder(
                  builder: (BuildContext context) {
                    index += 1;
                    final int i = index;
                    return _PaletteRow(
                      command: command,
                      active: i == widget.activeIndex,
                      onHover: () => widget.onHover(i),
                      onSelect: () => widget.onSelect(command),
                    );
                  },
                ),
            ],
          ),
        ),
      );
    }

    final Widget box = DecoratedBox(
      decoration: BoxDecoration(
        color: theme.popover,
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(color: theme.border, width: BorderWidths.hairline),
        boxShadow: Shadows.lg.outerShadows(theme),
      ),
      child: ClipRRect(
        // `overflow-y-auto` on a `rounded-lg` box — the rows stop at the curve.
        borderRadius: BorderRadius.circular(Radii.lg - BorderWidths.hairline),
        child: Padding(
          padding: const EdgeInsets.all(BorderWidths.hairline),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight:
                  AgentSlashPalette.maxHeight - BorderWidths.hairline * 2,
            ),
            child: SingleChildScrollView(
              controller: _scroller,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: rows,
              ),
            ),
          ),
        ),
      ),
    );

    // `anim-fade-up`. A tween rather than a controller: the palette mounts once
    // per open — React keeps the same element while `paletteOpen` stays true,
    // and so does the element tree here — so the entrance must run on mount and
    // never again as the matches are filtered under it.
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: effectiveMotionDuration(context, AgentSlashPalette.entrance),
      curve: MotionCurves.enter,
      builder: (BuildContext context, double t, Widget? child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, AgentSlashPalette.rise * (1 - t)),
          child: child,
        ),
      ),
      child: box,
    );
  }
}

/// One `role="option"` row.
class _PaletteRow extends StatelessWidget {
  const _PaletteRow({
    required this.command,
    required this.active,
    required this.onHover,
    required this.onSelect,
  });

  final AgentCommand command;
  final bool active;
  final VoidCallback onHover;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final LucideGlyph? glyph = command.icon;

    return Semantics(
      button: true,
      selected: active,
      child: MouseRegion(
        onEnter: (PointerEnterEvent _) => onHover(),
        child: Listener(
          // `onMouseDown` rather than `onClick`: the composer has focus, and a
          // click would blur it first, closing the palette out from under the
          // press.
          onPointerDown: (PointerDownEvent _) => onSelect(),
          behavior: HitTestBehavior.opaque,
          child: ColoredBox(
            // `bg-accent` on the active row, and nothing on the rest.
            color: active ? theme.accent : transparent,
            child: Padding(
              padding: AgentSlashPalette.rowInsets,
              child: Row(
                // `items-start`.
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (glyph != null) ...<Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        top: AgentSlashPalette.glyphTopInset,
                      ),
                      // `text-agent` — a colour utility on the glyph, which
                      // `IconTone.inherit` reads off the ambient text style
                      // exactly as `text-current` does.
                      child: DefaultTextStyle.merge(
                        style: TextStyle(color: theme.agentAccent),
                        child: Icon.lucide(
                          glyph,
                          sizePx: AgentSlashPalette.glyphSize,
                          strokeOverride: AgentSlashPalette.lucideStroke,
                        ),
                      ),
                    ),
                    SizedBox(width: AgentSlashPalette.rowGap),
                  ],
                  // `flex min-w-0 flex-col gap-1` — a flex item with no
                  // `flex-1`, so the column is content-wide and shrinks only
                  // when it has to.
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        RichText(
                          TextSpan(
                            children: <InlineSpan>[
                              TextSpan(
                                text: '/',
                                style: StyledText.styleOf(
                                  context,
                                  TextStyles.small,
                                  color: theme.agentAccent,
                                ),
                              ),
                              TextSpan(text: command.id),
                            ],
                          ),
                          TextStyles.small,
                          color: theme.foreground,
                        ),
                        if (command.hint != null) ...<Widget>[
                          SizedBox(height: AgentSlashPalette.lineGap),
                          StyledText(
                            command.hint!,
                            TextStyles.caption,
                            color: theme.mutedForeground,
                            // `line-clamp-2`.
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
