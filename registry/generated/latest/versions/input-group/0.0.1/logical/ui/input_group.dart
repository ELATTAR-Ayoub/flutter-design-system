/// `components/ui/input-group.tsx` — the socket, and the control stripped bare
/// inside it.
///
/// Ruling I2: the reference **strips rather than extends**. `InputGroupInput`
/// is an `Input` with `border-0 bg-transparent shadow-none ring-0 rounded-none
/// focus-visible:ring-0 aria-invalid:ring-0` bolted on, so every pixel of the
/// pill — border, socket, focus ring, error ring — is painted by the wrapper.
/// That is why `ElInput` gained a `bare` mode and not a pair of addon slots.
///
/// ## The group is deliberately not the input's recipe
///
/// | state | bare `Input` | `InputGroup` |
/// |---|---|---|
/// | focus | border `--primary`@50%, ring `--ring`@**35%** | border **`--ring`**, ring `--ring`@**50%** |
/// | invalid | ring `--destructive`@20%, **no `dark:` variant** | 20% light / **40% dark** |
/// | disabled | opacity **0.45** | opacity **0.50** |
///
/// Both rows are visible side by side on the validation section of the inputs
/// page — fields 1 and 2 differ in nothing but whether an addon happens to be
/// present (inputs-map drifts 6 and 7). Ported as they are.
///
/// ## The clearance rule (inputs-map §4.2)
///
/// Four `has-*` selectors at (0,2,1) beat the input's own `px-4` at (0,1,0):
///
/// | condition | the direct-child input's padding |
/// |---|---|
/// | a child is `data-align="inline-start"` | `padding-left: 8px`, from 16 |
/// | a child is `data-align="inline-end"` | `padding-right: 8px`, from 16 |
///
/// The 16px exists because *a pill's corner eats ~20px on a 40px control*
/// (`input.tsx` JSDoc). When an addon sits on that side it supplies the
/// clearance itself with its own `pl-4`/`pr-4`, so the input's padding stops
/// being the gap to the curve and becomes the gap to the addon — 8px. Only that
/// side changes. And `has-[>button]:-ml-0.5` pulls **−2px** when the addon
/// holds a button, so an addon-with-button clears at 14 rather than 16.
///
/// ## Icon sizes inside a group — drift 9, and why it needs no code
///
/// `InputGroupAddon` carries `[&>svg:not([class*='size-'])]:size-4`, and `Icon`
/// emits its size as presentational **attributes**, never as a class — so the
/// CSS (16px) beats the attributes (14px) while `strokeWidth` stays computed
/// from the requested 14, giving 2.4. An addon icon therefore paints **16×16 at
/// stroke 2.4**.
///
/// In this port that is `ElIcon(size: ElIconSize.md)` and nothing else:
/// `ElIcon.strokeFor(16)` is 2.4 for the same reason `strokeFor(14)` is —
/// 48/16 = 3 and 48/14 = 3.43 are both above the 2.6 threshold, so the ternary
/// snaps to the identical rung. The drift collapses to an identity.
///
/// Inside an `InputGroupButton` the answer is the other one: its `xs` size adds
/// `[&>svg:not(…)]:size-3.5`, which *(measured)* wins over the Button base's
/// `size-4`, so a button icon paints **14×14** — `ElIcon(size: ElIconSize.sm)`.
library;

import 'package:flutter/widgets.dart';

import '../effects/machine_surface.dart';
import '../foundation/colors.dart';
import '../foundation/motion.dart';
import '../foundation/shadows.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../motion/press.dart';
import '../theme_scope.dart';
import 'button.dart';
import 'field.dart';
import 'input.dart';

/// `has-[[data-slot=input-group-control]:focus-visible]:ring-ring/50` — the
/// button's alpha, not the bare input's 35.
const double _focusRingAlpha = 0.50;

/// `has-[[data-slot][aria-invalid=true]]:ring-destructive/20`, and its
/// `dark:` override at 40. The bare `Input` declares no `dark:` variant at all.
const double _invalidRingAlpha = 0.20;
const double _invalidRingAlphaDark = 0.40;

/// `has-disabled:opacity-50` — five points weaker than the bare field's 45.
const double _disabledOpacity = 0.50;

/// `disabled:opacity-45`, off `Button`'s own base list. An addon button is a
/// button first: it fades at the button's 45 even inside a group that fades at
/// 50.
const double _buttonDisabledOpacity = 0.45;

/// What the group tells the control and the addons about itself.
class _GroupScope extends InheritedWidget {
  const _GroupScope({
    required this.hasStartAddon,
    required this.hasEndAddon,
    required this.invalid,
    required this.enabled,
    required this.controlFocusNode,
    required super.child,
  });

  /// `has-[>[data-align=inline-start]]` — drives the control's left clearance.
  final bool hasStartAddon;

  /// `has-[>[data-align=inline-end]]`.
  final bool hasEndAddon;

  final bool invalid;
  final bool enabled;

  /// The node an addon click focuses, and the one the control adopts.
  final FocusNode controlFocusNode;

  static _GroupScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_GroupScope>();

  @override
  bool updateShouldNotify(_GroupScope old) =>
      old.hasStartAddon != hasStartAddon ||
      old.hasEndAddon != hasEndAddon ||
      old.invalid != invalid ||
      old.enabled != enabled ||
      old.controlFocusNode != controlFocusNode;
}

/// `InputGroup` — a 40px pill that paints for whatever control sits in it.
class ElInputGroup extends StatefulWidget {
  const ElInputGroup({
    super.key,
    required this.child,
    this.startAddon,
    this.endAddon,
    this.invalid = false,
    this.enabled = true,
    this.focusNode,
  });

  /// The control. `ElInputGroupInput` in every case on the ported pages.
  ///
  /// `flex-1` — it takes whatever the addons leave.
  final Widget child;

  /// `<InputGroupAddon align="inline-start">`, which CSS `order-first` pins to
  /// the leading edge regardless of DOM position. Explicit slots rather than a
  /// child list, because the clearance rule needs to know which sides are
  /// occupied and `order` is not something a Flutter parent can read back.
  final Widget? startAddon;

  /// `<InputGroupAddon align="inline-end">` — `order-last`.
  final Widget? endAddon;

  /// `has-[[data-slot][aria-invalid=true]]`. ORed with the enclosing
  /// [ElFieldScope]'s, since a `ElField` marking its control marks the group
  /// the control is in.
  final bool invalid;

  /// `has-disabled`.
  final bool enabled;

  /// The control's focus node.
  ///
  /// Defaults to the enclosing [ElFieldScope]'s so that a form's
  /// focus-on-error lands inside the group, and only owns one when there is no
  /// field above it.
  final FocusNode? focusNode;

  /// `h-10` — level with a bare `ElInput` and a default `ElButton`.
  static double get height => ElInput.height;

  /// `pl-4` / `pr-4` on the addon — the clearance the addon supplies itself.
  static double get addonInset => el(4);

  /// `has-[>button]:-ml-0.5` / `-mr-0.5` — an addon holding a button pulls 2px
  /// back, clearing at 14 instead of 16.
  static double get addonButtonPull => el(0.5);

  /// The control's own padding on a side an addon occupies: `pl-2` / `pr-2`.
  static double get clearance => el(2);

  @override
  State<ElInputGroup> createState() => _ElInputGroupState();
}

class _ElInputGroupState extends State<ElInputGroup> {
  FocusNode? _ownedFocusNode;
  FocusNode? _scopeFocusNode;

  /// Tracks descendant focus — the `has-[…:focus-visible]` predicate.
  bool _focusWithin = false;

  FocusNode get _controlFocusNode =>
      widget.focusNode ?? _scopeFocusNode ?? (_ownedFocusNode ??= FocusNode());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scopeFocusNode = ElFieldScope.maybeOf(context)?.focusNode;
  }

  @override
  void dispose() {
    _ownedFocusNode?.dispose();
    super.dispose();
  }

  void _setFocusWithin(bool value) {
    if (_focusWithin == value) return;
    setState(() => _focusWithin = value);
  }

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final ElFieldScope? field = ElFieldScope.maybeOf(context);

    final bool invalid = widget.invalid || (field?.invalid ?? false);
    final bool enabled = widget.enabled && (field?.enabled ?? true);

    // `dark:has-[[data-slot][aria-invalid=true]]:ring-destructive/40` — the one
    // place in this family where the error ring changes with the theme.
    final double invalidAlpha = ElTheme.kindOf(context) == ElThemeKind.dark
        ? _invalidRingAlphaDark
        : _invalidRingAlpha;

    // `aria-invalid` beats `focus-visible` here for the same reason it does on
    // the bare field: later in the emitted stylesheet at equal specificity.
    final Color border = invalid
        ? theme.destructive
        : _focusWithin
        ? theme.ring
        : theme.input;
    final Color ring = invalid
        ? theme.destructive.withValues(alpha: invalidAlpha)
        : _focusWithin
        ? theme.ring.withValues(alpha: _focusRingAlpha)
        : theme.ring.withValues(alpha: 0);

    // `transition-[box-shadow,border-color]` — note the absence of
    // `background-color`, which the bare `Input` does transition. At the
    // framework default: the `duration-base` class beside it emits nothing.
    final Duration duration = elAnimationDuration(
      context,
      ElDurations.transitionDefault,
    );

    Widget group = _GroupScope(
      hasStartAddon: widget.startAddon != null,
      hasEndAddon: widget.endAddon != null,
      invalid: invalid,
      enabled: enabled,
      controlFocusNode: _controlFocusNode,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (widget.startAddon != null) widget.startAddon!,
          // `flex-1`.
          Expanded(child: widget.child),
          if (widget.endAddon != null) widget.endAddon!,
        ],
      ),
    );

    group = TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: border),
      duration: duration,
      curve: ElCurves.out,
      builder: (BuildContext context, Color? b, Widget? child) =>
          TweenAnimationBuilder<Color?>(
            tween: ColorTween(end: ring),
            duration: duration,
            curve: ElCurves.out,
            builder: (BuildContext context, Color? r, Widget? child) {
              final Color ringColor = r ?? ring;
              return ElMachineSurface(
                spec: ringColor.a == 0
                    ? ElShadows.pressed
                    : ElButton.withFocusRing(ElShadows.pressed, ringColor),
                radius: BorderRadius.circular(ElRadii.pill),
                fill: theme.card,
                border: Border.all(
                  color: b ?? border,
                  width: ElWidths.hairline,
                ),
                // Threaded through both builders unrebuilt, so it is the `group`
                // handed to the outer `child:` and never null.
                child: child!,
              );
            },
            child: child,
          ),
      child: group,
    );

    group = SizedBox(height: ElInputGroup.height, child: group);

    // `has-disabled:opacity-50`. The control inside keeps its own
    // `disabled:opacity-45` as well — two opacities that multiply, exactly as
    // the two class lists do. Unreachable on both ported pages; neither has a
    // disabled group.
    group = Opacity(
      opacity: enabled ? 1 : _disabledOpacity,
      child: IgnorePointer(ignoring: !enabled, child: group),
    );

    // `has-[[data-slot=input-group-control]:focus-visible]` — a node that never
    // takes focus itself but reports when anything under it has.
    group = Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onFocusChange: _setFocusWithin,
      child: group,
    );

    // `role="group"`.
    return Semantics(container: true, child: group);
  }
}

/// `InputGroupInput` — `ElInput` with the strip list applied and the clearance
/// rule resolved.
///
/// Everything it takes, it forwards; the two things it decides are [ElInput.bare]
/// and [ElInput.padding], and both are read off the enclosing group.
class ElInputGroupInput extends StatelessWidget {
  const ElInputGroupInput({
    super.key,
    this.controller,
    this.initialValue,
    this.placeholder,
    this.onChanged,
    this.onSubmitted,
    this.readOnly = false,
    this.obscureText = false,
    this.keyboardType,
    this.autofillHints,
    this.textSpec,
    this.label,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String? placeholder;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool readOnly;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<String>? autofillHints;

  /// [ElComponentType.inputNum] / [ElComponentType.inputSerial] — the I7
  /// collapse, already resolved in the foundation layer.
  final ElTypeSpec? textSpec;

  final String? label;

  @override
  Widget build(BuildContext context) {
    final _GroupScope? group = _GroupScope.maybeOf(context);
    assert(
      group != null,
      'ElInputGroupInput paints nothing on its own — the group is what draws '
      'the pill. Put it in a ElInputGroup, or use a bare ElInput.',
    );

    final EdgeInsets base = ElInput.insets;
    return ElInput(
      controller: controller,
      initialValue: initialValue,
      focusNode: group?.controlFocusNode,
      placeholder: placeholder,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      readOnly: readOnly,
      obscureText: obscureText,
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      textSpec: textSpec,
      label: label,
      bare: true,
      padding: EdgeInsetsDirectional.fromSTEB(
        (group?.hasStartAddon ?? false) ? ElInputGroup.clearance : base.left,
        // `py-1` survives the strip — only the horizontal padding is contested.
        base.top,
        (group?.hasEndAddon ?? false) ? ElInputGroup.clearance : base.right,
        base.bottom,
      ),
    );
  }
}

/// `InputGroupAddon` — `flex h-auto cursor-text items-center justify-center
/// gap-2 py-1.5 text-sm font-medium text-muted-foreground select-none`, plus
/// the side's own `pl-4`/`pr-4`.
///
/// Clicking one focuses the control, unless the click landed on a button
/// (`input-group.tsx:57–62`). That is the whole of its behaviour.
class ElInputGroupAddon extends StatelessWidget {
  const ElInputGroupAddon({
    super.key,
    required this.child,
    this.align = ElInputGroupAlign.start,
    this.holdsButton,
  });

  /// A [ElInputGroupText], a `ElIcon`, or a [ElInputGroupButton].
  final Widget child;

  final ElInputGroupAlign align;

  /// `has-[>button]:-ml-0.5` / `-mr-0.5`.
  ///
  /// Inferred from [child] when omitted; state it to override. A `has-`
  /// selector inspects the subtree and Flutter cannot, so the inference is a
  /// direct type check against the one widget the selector can match.
  final bool? holdsButton;

  /// `py-1.5` — 6px. `h-auto` inside a centred 40px row, so it only bites when
  /// the content is taller than the pill's inner height.
  static double get insetY => el(1.5);

  /// `gap-2` — 8px between an addon's own children, when it has more than one.
  static double get gap => el(2);

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final _GroupScope? group = _GroupScope.maybeOf(context);
    final bool button = holdsButton ?? child is ElInputGroupButton;

    // `pl-4` / `pr-4`, less the 2px pull when a button is what is being
    // cleared.
    final double inset =
        ElInputGroup.addonInset - (button ? ElInputGroup.addonButtonPull : 0);

    Widget addon = Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
        align == ElInputGroupAlign.start ? inset : 0,
        insetY,
        align == ElInputGroupAlign.end ? inset : 0,
        insetY,
      ),
      child: Center(widthFactor: 1, child: child),
    );

    // `text-sm font-medium text-muted-foreground` — an ambient style, because
    // the addon types its children rather than its own text. `ElIcon` at
    // `ElIconTone.inherit` reads it too, which is what `[&>svg]` inherits on
    // the web.
    addon = DefaultTextStyle.merge(
      style: ElText.styleOf(
        context,
        ElComponentType.buttonLabel,
        color: theme.mutedForeground,
      ),
      child: addon,
    );

    // `cursor-text`, and the click handler that focuses the control
    // (`input-group.tsx:57–62`). `opaque` because the web's handler is on the
    // whole addon `div`, padding included — a click in the 16px clearance
    // focuses the field just as a click on the glyph does.
    //
    // The reference then opts out when the click landed on a button
    // (`e.target.closest("button")`). Flutter's gesture arena settles that for
    // free: the button's own recognizer is added first — hit-test results run
    // innermost outward — so it takes the tap and this one is swept away.
    addon = MouseRegion(
      cursor: SystemMouseCursors.text,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: group?.controlFocusNode.requestFocus,
        child: addon,
      ),
    );

    // `role="group"`.
    return Semantics(container: true, child: addon);
  }
}

/// `data-align` — the two inline values. The two block values
/// (`block-start`/`block-end`, which turn the group into a column) are not
/// reached by either ported page and are not built.
enum ElInputGroupAlign {
  /// `inline-start` — `order-first pl-4`.
  start,

  /// `inline-end` — `order-last pr-4`.
  end,
}

/// `InputGroupText` — `flex items-center gap-2 text-sm text-muted-foreground`.
///
/// *(Measured)* it computes **13px at a line-height of 18.5714px** — ruling
/// I7's collapse, seen directly. `text-sm` is a utility carrying the surviving
/// `--text-sm--line-height` (Tailwind's stock `calc(1.25 / 0.875)` on the
/// repointed 13px size), and a `.type-num` or `.type-num-sm` class stacked
/// beside it lives in `@layer components`, so the utility wins **both** the
/// size and the leading. The mono family, tabular figures, 600 weight and
/// −0.01em tracking survive; 15px and 1.2 do not, and neither does
/// `type-num-sm`'s 12px.
///
/// [ElComponentType.inputNum] and [ElComponentType.inputSerial] are that
/// collapse resolved. Passing [ElType.numBase] here would render two pixels
/// large and is the one mistake this doc exists to prevent.
class ElInputGroupText extends StatelessWidget {
  const ElInputGroupText(this.text, {super.key, this.spec});

  final String text;

  /// The `.type-*` class stacked on the span's `text-sm`. Defaults to the bare
  /// rung.
  final ElTypeSpec? spec;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return ElText(
      text,
      spec ?? ElComponentType.textSm,
      color: theme.mutedForeground,
    );
  }
}

/// The `inputGroupButtonVariants` size rungs (`input-group.tsx:68–84`) the port
/// has consumers for.
///
/// The cva declares four — `xs`, `sm`, `icon-xs`, `icon-sm`. `sm` is the empty
/// string (it adds nothing at all to the base) and `icon-sm` is `size-8 p-0`,
/// which no ported page reaches; both stay recorded, not built, on the same
/// rule that scoped `ElInputGroupAlign` to its two inline values.
enum ElInputGroupButtonSize {
  /// `h-6 gap-1 rounded-[calc(var(--radius)-3px)] px-1.5
  /// [&>svg:not([class*='size-'])]:size-3.5` — the cva's `defaultVariants`,
  /// and the rung the inputs page's password toggle wears.
  ///
  /// Its `size-3.5` beats the `Button` base's `size-4`, so an icon in this rung
  /// paints **14×14** — `ElIcon(size: ElIconSize.sm)`.
  xs,

  /// `size-6 rounded-[calc(var(--radius)-3px)] p-0 has-[>svg]:p-0` — a **24 ×
  /// 24 square with no padding at all**, worn by the combobox's trigger
  /// (`combobox.tsx:71–79`).
  ///
  /// It declares no `[&>svg]` size of its own, so the `Button` base's `size-4`
  /// stands and an icon here paints **16×16** — one rung larger than [xs] on a
  /// button two pixels *narrower*.
  iconXs,
}

/// `InputGroupButton` — a ghost `Button` at 24px with a 7px corner.
///
/// `size` is `Omit`ted from the props, so the reference builds a `Button` at
/// `size="default"` and then overrides height, gap, padding and radius through
/// its own `cva`. The geometry therefore belongs to *this* file rather than to
/// the button's size ladder, which is why it is stated here:
/// **24px tall, 7px radius, 13px text, `variant="ghost"`, `shadow-none`** —
/// with the base list's `btn-spring`, `active:scale-95` and
/// `focus-visible:border-ring ring-3 ring-ring/50` all surviving. What the two
/// rungs disagree about is width: [ElInputGroupButtonSize.xs] is
/// `px-1.5`-wide-as-its-content, [ElInputGroupButtonSize.iconXs] is a square.
///
/// A 7px radius on a control inside a 999px pill is the only non-pill,
/// non-ladder corner in the system ([ElRadii.addonButton]).
///
/// It reproduces `ElButton`'s ghost row rather than wrapping [ElButton],
/// because at the time of writing `ElButton` exposes neither this height nor a
/// radius override — both live in another owner's file this wave. The three
/// lines of colour table below are the duplication that buys the independence;
/// if `ElButton` later takes a radius, this collapses onto it.
class ElInputGroupButton extends StatefulWidget {
  const ElInputGroupButton({
    super.key,
    required this.child,
    this.onPressed,
    this.label,
    this.toggled,
    this.focusNode,
    this.size = ElInputGroupButtonSize.xs,
    this.cancelPressFill = false,
  });

  final Widget child;

  /// `null` disables it: `disabled:pointer-events-none disabled:opacity-45`.
  final VoidCallback? onPressed;

  /// The accessible name, for the icon-only case.
  final String? label;

  /// `aria-pressed` — the password toggle is a real control with a pressed
  /// state, not a decorative icon, and the field's own description says so.
  final bool? toggled;

  final FocusNode? focusNode;

  /// The cva rung. `defaultVariants.size` is `xs`.
  final ElInputGroupButtonSize size;

  /// `data-pressed:bg-transparent` — a **call-site** class, not part of any
  /// rung.
  ///
  /// The combobox trigger (`combobox.tsx:77`) stamps it, and it inverts the
  /// ghost variant's usual arc: pressing *cancels* the fill instead of
  /// deepening it, so the pressed state is the resting one and only the scale
  /// moves. Kept as a flag rather than a colour, because the reference names a
  /// behaviour and not a value.
  final bool cancelPressFill;

  /// `h-6` / `size-6` — 24px, both rungs.
  static double get height => el(6);

  /// `px-1.5` — 6px, on [ElInputGroupButtonSize.xs] only.
  static double get paddingX => el(1.5);

  /// The rung's horizontal padding: `px-1.5` for `xs`, `p-0` for `icon-xs`.
  static double paddingXFor(ElInputGroupButtonSize size) =>
      size == ElInputGroupButtonSize.iconXs ? 0 : paddingX;

  /// `gap-1` — 4px. Exposed rather than applied, the same contract
  /// [ElButton.gapFor] uses: this widget takes one child, and a button with
  /// both an icon and a label composes its own row.
  static double get gap => el(1);

  @override
  State<ElInputGroupButton> createState() => _ElInputGroupButtonState();
}

class _ElInputGroupButtonState extends State<ElInputGroupButton> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  bool get _enabled => widget.onPressed != null;

  void _set(void Function() change) => setState(change);

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);

    /// `size-6` — the `icon-xs` rung is a square, the `xs` rung is not.
    final bool square = widget.size == ElInputGroupButtonSize.iconXs;

    // `variant="ghost"`: no fill, no border, no elevation until touched.
    // `active` outranks `hover` — Tailwind orders it later — so a press shows
    // `--muted` even though the pointer is necessarily hovering. Unless the
    // call site cancelled it, in which case the press paints nothing and the
    // hover underneath it is cancelled too: `bg-transparent` is a fill, and it
    // wins outright.
    final Color fill = _pressed
        ? (widget.cancelPressFill ? elTransparent : theme.muted)
        : _hovered
        ? theme.secondary
        : elTransparent;
    final Color ink = _hovered || _pressed
        ? theme.foreground
        : theme.mutedForeground;
    final Color border = _focused ? theme.ring : elTransparent;

    final Duration duration = elAnimationDuration(
      context,
      // `btn-spring`'s `:active { transition-duration: --duration-tick }`.
      _pressed ? ElDurations.tick : ElDurations.base,
    );

    Widget button = TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: fill),
      duration: duration,
      curve: ElCurves.spring,
      builder: (BuildContext context, Color? f, Widget? _) =>
          TweenAnimationBuilder<Color?>(
            tween: ColorTween(end: ink),
            duration: duration,
            curve: ElCurves.spring,
            builder: (BuildContext context, Color? c, Widget? _) =>
                TweenAnimationBuilder<Color?>(
                  tween: ColorTween(end: border),
                  duration: duration,
                  curve: ElCurves.spring,
                  builder: (BuildContext context, Color? b, Widget? _) {
                    return ElMachineSurface(
                      // `shadow-none` at rest; the focus ring is the only layer this
                      // button ever paints.
                      spec: _focused
                          ? ElButton.withFocusRing(
                              ElShadows.none,
                              theme.ring.withValues(alpha: _focusRingAlpha),
                            )
                          : ElShadows.none,
                      radius: BorderRadius.circular(ElRadii.addonButton),
                      fill: f ?? fill,
                      border: Border.all(
                        color: b ?? border,
                        width: ElWidths.hairline,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: ElInputGroupButton.paddingXFor(
                            widget.size,
                          ),
                        ),
                        child: Center(
                          // `size-6` is a fixed square; `h-6 px-1.5` is as wide as its
                          // content, which is what `widthFactor: 1` says.
                          widthFactor: square ? null : 1,
                          child: DefaultTextStyle(
                            style: ElText.styleOf(
                              context,
                              ElComponentType.buttonLabel,
                              color: c ?? ink,
                            ),
                            child: widget.child,
                          ),
                        ),
                      ),
                    );
                  },
                ),
          ),
    );

    button = square
        ? SizedBox.square(dimension: ElInputGroupButton.height, child: button)
        : SizedBox(height: ElInputGroupButton.height, child: button);

    button = ElPress(
      scale: ElTransforms.buttonScale,
      downDuration: ElDurations.tick,
      upDuration: ElDurations.base,
      onTap: widget.onPressed,
      child: Listener(
        onPointerDown: (_) => _set(() => _pressed = true),
        onPointerUp: (_) => _set(() => _pressed = false),
        onPointerCancel: (_) => _set(() => _pressed = false),
        child: MouseRegion(
          cursor: _enabled ? SystemMouseCursors.click : MouseCursor.defer,
          onEnter: (_) => _set(() => _hovered = true),
          onExit: (_) => _set(() => _hovered = false),
          child: button,
        ),
      ),
    );

    button = Focus(
      focusNode: widget.focusNode,
      canRequestFocus: _enabled,
      onFocusChange: (bool value) => _set(() => _focused = value),
      child: button,
    );

    button = Opacity(
      opacity: _enabled ? 1 : _buttonDisabledOpacity,
      child: IgnorePointer(ignoring: !_enabled, child: button),
    );

    if (widget.label == null && widget.toggled == null) return button;
    return Semantics(
      button: true,
      label: widget.label,
      // `aria-pressed`.
      toggled: widget.toggled,
      child: button,
    );
  }
}
