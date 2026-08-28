/// The three-way theme control, `components/space/theme-toggle.tsx`.
///
/// The reference's own reasoning, kept because it is the design decision:
/// *"A two-way switch would have been smaller, but it cannot express 'follow
/// the OS': and a system that ships two themes and no way to defer to the
/// platform is making a decision on the user's behalf that is not its to
/// make."*
///
/// **The selection travels, because RULES §4 says it must.** Each option
/// paints no background of its own; one pill moves between them
/// ([ActiveIndicator]) and lands with a squash. The web arrived here after
/// shipping the forbidden version: every option owning `bg-card shadow-e1`
/// when checked, one blinking on as another blinked off: for a long time.
///
/// The control reads the chosen **mode**, not the resolved theme: `System` has
/// to look selected while it is painting dark.
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

/// `size-7`: one option.
final double _optionPx = space(7);

/// `size-3.5`: the glyph inside it.
final double _iconPx = space(3.5);

/// These three icons are rendered **directly** in the reference
/// (`<SunIcon className="size-3.5"/>`), not through `Icon`, so they keep
/// lucide's own authored `stroke-width` instead of the size ladder's: which
/// at 14px would have snapped to 2.4.
final double _iconStroke = Icon.strokeFor(IconPaths.viewBox);

/// `p-0.5` on the container.
final EdgeInsets _containerPadding = EdgeInsets.all(space(0.5));

class _Option {
  const _Option(this.mode, this.label, this.glyph);

  final ColorMode mode;
  final String label;
  final IconGlyph glyph;
}

const List<_Option> _options = <_Option>[
  _Option(ColorMode.light, 'Light', IconGlyph.sun),
  _Option(ColorMode.system, 'System', IconGlyph.monitor),
  _Option(ColorMode.dark, 'Dark', IconGlyph.moon),
];

/// Light · System · Dark.
class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final ThemeController controller = ThemeScope.controllerOf(context);
    final ColorMode mode = ThemeScope.modeOf(context);

    return Semantics(
      container: true,
      label: 'Colour theme',
      child: Container(
        decoration: BoxDecoration(
          color: theme.muted,
          borderRadius: BorderRadius.circular(Radii.full),
          border: Border.all(color: theme.border, width: BorderWidths.hairline),
        ),
        child: ActiveIndicator(
          activeIndex: _options.indexWhere(
            (_Option option) => option.mode == mode,
          ),
          padding: _containerPadding,
          // `gap-px`.
          gap: BorderWidths.hairline,
          // **The pill snaps here, and only here.**
          //
          // Clicking an option flips the theme, and `next-themes` writes
          // `transition: none !important` onto `<html>` for roughly 14ms so
          // the whole document does not cross-fade at once. The pill's
          // transform commits inside that freeze, so its travel never runs —
          // measured on a real theme click, where the pill is at its new home
          // on the first frame with no spring between.
          //
          // The arrival squash is unaffected: the class goes back on in the
          // same batch and plays its full 600ms once the freeze lifts. So this
          // control is a snap plus a jelly, never a travel. The nav rail's
          // pill flips no theme, is not frozen, and keeps its 250ms spring.
          moveDuration: Duration.zero,
          indicator: Surface(
            spec: Shadows.sm,
            radius: BorderRadius.circular(Radii.full),
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
    final ThemeTokens theme = ThemeScope.of(context);
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
        child: Press(
          onTap: widget.onTap,
          // **The squish SNAPS on this control, and only on this one.**
          //
          // The option's class list is `press … transition-colors
          // duration-fast ease-out`. The `press` utility declares the whole
          // `transition` shorthand, `transition: transform
          // var(--duration-base) var(--ease-spring)`: and `transition-colors`
          // is emitted later at equal specificity, so it REPLACES that
          // shorthand's `transition-property` with the colour list. `transform`
          // is not in that list, so `:active { transform: scale(0.94) }`
          // arrives and leaves with nothing interpolating it.
          //
          // Measured, not read off the cascade: a real pointer press driven on
          // the live reference and sampled every frame reported
          // `none → matrix(0.94, 0, 0, 0.94, 0, 0) → none`, each change landing
          // in a single frame, with **zero** intermediate matrices across 73
          // samples. The 250ms that the class list does buy belongs to the
          // glyph's colour, which is tweened separately below.
          //
          // Zero on both legs rather than a different widget: the asymmetry
          // [Press] exists to express is real everywhere else, and every
          // other call site keeps it.
          downDuration: Duration.zero,
          upDuration: Duration.zero,
          child: SizedBox(
            width: _optionPx,
            height: _optionPx,
            child: Center(
              child: TweenAnimationBuilder<Color?>(
                tween: ColorTween(end: ink),
                // `transition-colors duration-fast ease-out`: and
                // `duration-fast` emits no CSS, so this is the framework
                // default, probed at 0.25s.
                duration: effectiveMotionDuration(
                  context,
                  MotionDurations.normal,
                ),
                curve: MotionCurves.enter,
                builder: (BuildContext context, Color? colour, Widget? child) =>
                    DefaultTextStyle.merge(
                      style: TextStyle(color: colour),
                      child: child!,
                    ),
                child: Icon(
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
