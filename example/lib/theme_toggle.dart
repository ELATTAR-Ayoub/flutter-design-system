/// The three-way theme control — `components/ds/theme-toggle.tsx`.
///
/// The reference's own reasoning, kept because it is the design decision:
/// *"A two-way switch would have been smaller, but it cannot express 'follow
/// the OS' — and a system that ships two themes and no way to defer to the
/// platform is making a decision on the user's behalf that is not its to
/// make."*
///
/// **The selection travels, because RULES §4 says it must.** Each option
/// paints no background of its own; one pill moves between them
/// ([DsSlidingPillGroup]) and lands with a squash. The web arrived here after
/// shipping the forbidden version — every option owning `bg-card shadow-e1`
/// when checked, one blinking on as another blinked off — for a long time.
///
/// The control reads the chosen **mode**, not the resolved theme: `System` has
/// to look selected while it is painting dark.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

/// `size-7` — one option.
final double _optionPx = ds(7);

/// `size-3.5` — the glyph inside it.
final double _iconPx = ds(3.5);

/// These three icons are rendered **directly** in the reference
/// (`<SunIcon className="size-3.5"/>`), not through `Icon`, so they keep
/// lucide's own authored `stroke-width` instead of the size ladder's — which
/// at 14px would have snapped to 2.4.
final double _iconStroke = DsIcon.strokeFor(DsIconPaths.viewBox);

/// `p-0.5` on the container.
final EdgeInsets _containerPadding = EdgeInsets.all(ds(0.5));

class _Option {
  const _Option(this.mode, this.label, this.glyph);

  final DsThemeMode mode;
  final String label;
  final DsIconGlyph glyph;
}

const List<_Option> _options = <_Option>[
  _Option(DsThemeMode.light, 'Light', DsIconGlyph.sun),
  _Option(DsThemeMode.system, 'System', DsIconGlyph.monitor),
  _Option(DsThemeMode.dark, 'Dark', DsIconGlyph.moon),
];

/// Light · System · Dark.
class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final DsThemeController controller = DsTheme.controllerOf(context);
    final DsThemeMode mode = DsTheme.modeOf(context);

    return Semantics(
      container: true,
      label: 'Colour theme',
      child: Container(
        decoration: BoxDecoration(
          color: theme.muted,
          borderRadius: BorderRadius.circular(DsRadii.pill),
          border: Border.all(color: theme.border, width: DsWidths.hairline),
        ),
        child: DsSlidingPillGroup(
          activeIndex:
              _options.indexWhere((_Option option) => option.mode == mode),
          padding: _containerPadding,
          // `gap-px`.
          gap: DsWidths.hairline,
          pill: DsMachineSurface(
            spec: DsShadows.e1,
            radius: BorderRadius.circular(DsRadii.pill),
            fill: theme.card,
            child: const SizedBox.expand(),
          ),
          children: <Widget>[
            for (final _Option option in _options)
              _ThemeOption(
                option: option,
                active: option.mode == mode,
                onTap: () => controller.setMode(option.mode),
              ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOption extends StatefulWidget {
  const _ThemeOption({
    required this.option,
    required this.active,
    required this.onTap,
  });

  final _Option option;
  final bool active;
  final VoidCallback onTap;

  @override
  State<_ThemeOption> createState() => _ThemeOptionState();
}

class _ThemeOptionState extends State<_ThemeOption> {
  bool _hovered = false;

  void _hover(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    // `text-foreground` when checked; `text-muted-foreground
    // hover:text-foreground` otherwise.
    final Color ink = widget.active || _hovered
        ? theme.foreground
        : theme.mutedForeground;

    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: widget.active,
      label: widget.option.label,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => _hover(true),
        onExit: (_) => _hover(false),
        child: DsPress(
          onTap: widget.onTap,
          child: SizedBox(
            width: _optionPx,
            height: _optionPx,
            child: Center(
              child: TweenAnimationBuilder<Color?>(
                tween: ColorTween(end: ink),
                // `transition-colors duration-fast ease-out` — and
                // `duration-fast` emits no CSS, so this is the framework
                // default, probed at 0.25s.
                duration: dsAnimationDuration(
                  context,
                  DsDurations.transitionDefault,
                ),
                curve: DsCurves.out,
                builder: (BuildContext context, Color? colour, Widget? child) =>
                    DefaultTextStyle.merge(
                  style: TextStyle(color: colour),
                  child: child!,
                ),
                child: DsIcon(
                  widget.option.glyph,
                  sizePx: _iconPx,
                  strokeOverride: _iconStroke,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
