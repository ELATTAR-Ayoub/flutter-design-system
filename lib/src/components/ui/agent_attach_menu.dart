/// `components/agent/parts/attach-menu.tsx` — the plus.
///
/// *"One control for 'add something to this message', which is two different
/// things that a user is choosing between rather than two buttons they have to
/// tell apart: a file from their machine, or a capability the agent has."*
///
/// *"The skills listed here are the same objects the `/` palette offers, from
/// the same fetched registry — the plus is a discoverable route to them and the
/// slash is the fast one. Neither invents a capability, and picking one in
/// either place runs the identical handler."*
///
/// *"The menu hides a section it cannot fill: no file handler, no Photos &
/// files; no skills, no skills group. A menu with one live row and a dead
/// heading is worse than a plain button."*
///
/// ## Measured
///
/// Read off `/design-system/components/agent/composer` at 1440×900 on
/// 2026-08-16 (`scratchpad/ag-composer-live.js`, `ag-composer-hover.js`), with
/// the menu open at `side="top" align="start"`:
///
/// | | value |
/// |---|---|
/// | content | `w-80` **320** × 263.69, `max-h-96` 384, `p-2`, `rounded-lg` 12, `shadow-md ring-1` |
/// | row | `px-3 py-2 gap-3 rounded-[10px]` — **49.67** tall, `--accent` when highlighted, **no transition** |
/// | row glyph | 16px, `--agent`; stroke **2.4** on the `Icon`-wrapped `ImageIcon`, **2** on the raw lucide skill glyphs |
/// | label | `px-3 py-2` at **12 / 16 / 500** — 32 tall |
/// | separator | `-mx-2 my-2 h-px` — a 1px rule occupying 17 and running the full 320 |
///
/// This file composes `menu.dart`'s [MenuSurface] and [MenuPointerDown]
/// over [Popover] rather than [DropdownMenu], and the reason is the row:
/// the reference overrides `DropdownMenuItem` with `className="gap-3"` and a
/// **two-line** child, which is 49.67px against the stock row's 34.57 and is
/// not a shape [MenuItem] has a slot for. The chrome, the placement, the
/// pointer-down opening and the trigger's `aria-expanded` are all the shipped
/// primitives; only the row is authored here, exactly as it is there.
library;

import 'package:flutter/gestures.dart';
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
import '../../design_system/foundation/spacing.dart';
import '../../design_system/foundation/theme.dart';
import '../../design_system/foundation/typography.dart';
import '../../design_system/foundation/theme_scope.dart';
import './agent_slash_palette.dart';
import './button.dart';
import './dropdown_menu.dart';
import './icon.dart';
import './icon_paths.g.dart';
import './menu.dart';
import './popover.dart';

/// The plus, and the menu under it.
class AgentAttachMenu extends StatelessWidget {
  const AgentAttachMenu({
    super.key,
    this.onPickFiles,
    this.commands,
    required this.onRunCommand,
    this.disabled = false,
  });

  /// *"Opens the file picker. Omitted when attachments are off."*
  final VoidCallback? onPickFiles;

  /// *"Skills only — browser commands live under `/`, not here."* The filter is
  /// this widget's, on the full list the composer holds.
  final List<AgentCommand>? commands;

  final ValueChanged<AgentCommand> onRunCommand;

  final bool disabled;

  /// `size-8` on the trigger — `size="icon"` asks for 40 and twMerge keeps 32.
  static ButtonSize get triggerSize => ButtonSize.iconSm;

  /// `w-80` on the content.
  static double get width => space(80);

  /// `max-h-96`.
  static double get maxHeight => space(96);

  /// `px-3 py-2` on a row.
  static EdgeInsets get rowInsets =>
      EdgeInsets.symmetric(horizontal: space(3), vertical: space(2));

  /// `gap-3` between a row's glyph and its text.
  static double get rowGap => space(3);

  /// `rounded-md` on a row — 10.
  static double get rowRadius => Radii.md;

  /// **DRIFT.** The two-line child is `<span className="min-w-0 flex-col
  /// gap-1">` — **with no `flex`**, so `flex-col` and `gap-1` are both inert
  /// and the two lines stack as plain blocks with **no gap between them**.
  ///
  /// *(Measured: the row's text block is 33.675 = 19.5 + 14.175, against the
  /// slash palette's 37.675 = 19.5 + 4 + 14.175 for the same construct one file
  /// over, where the `flex` is present.)* Reproduced: nothing separates the two
  /// lines here.
  static const bool rowLinesHaveNoGap = true;

  /// `[&_svg:not([class*='size-'])]:size-4` on the row.
  static double get glyphSize => space(4);

  List<AgentCommand> get _skills => (commands ?? const <AgentCommand>[])
      .where((AgentCommand c) => c.group == AgentCommandGroup.skill)
      .toList();

  @override
  Widget build(BuildContext context) {
    final List<AgentCommand> skills = _skills;
    // `if (!onPickFiles && !skills.length) return null;`
    if (onPickFiles == null && skills.isEmpty) return const SizedBox.shrink();

    return _AttachMenu(
      onPickFiles: onPickFiles,
      skills: skills,
      onRunCommand: onRunCommand,
      disabled: disabled,
    );
  }
}

class _AttachMenu extends StatefulWidget {
  const _AttachMenu({
    required this.onPickFiles,
    required this.skills,
    required this.onRunCommand,
    required this.disabled,
  });

  final VoidCallback? onPickFiles;
  final List<AgentCommand> skills;
  final ValueChanged<AgentCommand> onRunCommand;
  final bool disabled;

  @override
  State<_AttachMenu> createState() => _AttachMenuState();
}

class _AttachMenuState extends State<_AttachMenu> {
  bool _open = false;

  bool get _isOpen => _open && !widget.disabled;

  void _close() {
    if (!_open) return;
    setState(() => _open = false);
  }

  void _toggle() => setState(() => _open = !_open);

  /// Radix closes the menu after `onSelect` runs, and so does this.
  void _select(VoidCallback action) {
    _close();
    action();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final bool hasFiles = widget.onPickFiles != null;
    final bool hasSkills = widget.skills.isNotEmpty;

    return Popover(
      open: _isOpen,
      // `align="start" side="top"` — the composer's control row is at the
      // bottom of a tall page, so the menu opens upwards.
      side: PopoverSide.top,
      align: PopoverAlign.start,
      sideOffset: DropdownMenu.sideOffset,
      origin: PopoverAnchorMode.corner,
      slideSides: MenuMotion.slideSides,
      onDismiss: _close,
      anchor: MenuPointerDown(
        enabled: !widget.disabled,
        onPointerDown: _toggle,
        child: MenuTriggerScope(
          open: _isOpen,
          child: Button(
            variant: ButtonVariant.ghost,
            size: AgentAttachMenu.triggerSize,
            // `DropdownMenuTrigger` stamps `aria-haspopup="menu"`, which
            // cancels `active:not-aria-[haspopup]:scale-95` — GAP CLOSED 1 in
            // `dropdown_menu.dart`, and the same attribute here.
            suppressPressScale: true,
            label: 'Add files or use a skill',
            onPressed: widget.disabled ? null : () {},
            child: Icon.lucide(Lucide.plus, sizePx: AgentAttachMenu.glyphSize),
          ),
        ),
      ),
      content: (BuildContext context, PopoverAnchorMetrics metrics) {
        final double pad = Menu.contentPadding;
        return SizedBox(
          width: AgentAttachMenu.width,
          child: MenuSurface(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: AgentAttachMenu.maxHeight),
              // `overflow-y-auto`.
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: pad),
                    if (hasFiles)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: pad),
                        child: _MenuRow(
                          glyph: Lucide.image,
                          // `<Icon icon={ImageIcon}>` — the wrapper, so this
                          // one glyph carries the derived 2.4 stroke that the
                          // raw lucide skill glyphs below do not.
                          stroke: Icon.strokeFor(AgentAttachMenu.glyphSize),
                          title: 'Photos & files',
                          hint: 'Images, documents, spreadsheets',
                          truncateTitle: false,
                          onSelect: () => _select(widget.onPickFiles!),
                        ),
                      ),
                    // `{onPickFiles && skills.length ? <Separator/> : null}`.
                    if (hasFiles && hasSkills)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: pad),
                        // `-mx-2` cancels the content's `p-2`, so the rule runs
                        // the full 320.
                        child: SizedBox(
                          height: BorderWidths.hairline,
                          child: ColoredBox(color: theme.border),
                        ),
                      ),
                    if (hasSkills) ...<Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: pad + space(3),
                          vertical: pad,
                        ),
                        // PROBE CORRECTION: the label's `className="type-caption
                        // text-muted-foreground"` loses its size and leading to
                        // `DropdownMenuLabel`'s own `text-xs font-medium` —
                        // *(measured 12 / 16 / 500, not `.type-caption`'s
                        // 10.5 / 14.175)*. Only the colour half of the class
                        // survives.
                        child: StyledText(
                          'Skills',
                          TextStyles.menuHeading,
                          color: theme.mutedForeground,
                        ),
                      ),
                      for (final AgentCommand command in widget.skills)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: pad),
                          child: _MenuRow(
                            // `command.icon ?? SparklesIcon`.
                            glyph: command.icon ?? Lucide.sparkles,
                            stroke: AgentSlashPalette.lucideStroke,
                            title: command.label,
                            hint: command.hint,
                            truncateTitle: true,
                            onSelect: () =>
                                _select(() => widget.onRunCommand(command)),
                          ),
                        ),
                    ],
                    SizedBox(height: pad),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// One `DropdownMenuItem` as this call site authors it: a glyph, a title and a
/// hint, at `gap-3`.
class _MenuRow extends StatefulWidget {
  const _MenuRow({
    required this.glyph,
    required this.stroke,
    required this.title,
    required this.hint,
    required this.truncateTitle,
    required this.onSelect,
  });

  final LucideGlyph glyph;
  final double stroke;
  final String title;
  final String? hint;

  /// `truncate` on the skills' labels; the files row writes only `block`.
  final bool truncateTitle;

  final VoidCallback onSelect;

  @override
  State<_MenuRow> createState() => _MenuRowState();
}

class _MenuRowState extends State<_MenuRow> {
  bool _highlighted = false;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return MouseRegion(
      onEnter: (PointerEnterEvent _) => setState(() => _highlighted = true),
      onExit: (PointerExitEvent _) => setState(() => _highlighted = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onSelect,
        child: Semantics(
          button: true,
          child: DecoratedBox(
            decoration: BoxDecoration(
              // `data-highlighted:bg-accent`, and *(measured)* no transition on
              // it at all — the fill is the frame.
              color: _highlighted ? theme.accent : transparent,
              borderRadius: BorderRadius.circular(AgentAttachMenu.rowRadius),
            ),
            child: Padding(
              padding: AgentAttachMenu.rowInsets,
              child: Row(
                // `items-center` — the stock item's, not the palette's
                // `items-start`.
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  DefaultTextStyle.merge(
                    style: TextStyle(color: theme.agentAccent),
                    child: Icon.lucide(
                      widget.glyph,
                      sizePx: AgentAttachMenu.glyphSize,
                      strokeOverride: widget.stroke,
                    ),
                  ),
                  SizedBox(width: AgentAttachMenu.rowGap),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        StyledText(
                          widget.title,
                          TextStyles.small,
                          color: theme.foreground,
                          maxLines: widget.truncateTitle ? 1 : null,
                          overflow: widget.truncateTitle
                              ? TextOverflow.ellipsis
                              : null,
                          softWrap: widget.truncateTitle ? false : null,
                        ),
                        // No gap: `flex-col gap-1` without `flex` — see
                        // [AgentAttachMenu.rowLinesHaveNoGap].
                        if (widget.hint != null)
                          StyledText(
                            widget.hint!,
                            TextStyles.caption,
                            color: theme.mutedForeground,
                            // `line-clamp-2`.
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
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
