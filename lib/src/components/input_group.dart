/// `components/ui/input-group.tsx` — the socket, and the control stripped bare
/// inside it.
///
/// Ruling I2: the reference **strips rather than extends**. `InputGroupInput`
/// is an `Input` with `border-0 bg-transparent shadow-none ring-0 rounded-none
/// focus-visible:ring-0 aria-invalid:ring-0` bolted on, so every pixel of the
/// pill — border, socket, focus ring, error ring — is painted by the wrapper.
/// That is why `DsInput` gained a `bare` mode and not a pair of addon slots.
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
/// In this port that is `DsIcon(size: DsIconSize.md)` and nothing else:
/// `DsIcon.strokeFor(16)` is 2.4 for the same reason `strokeFor(14)` is —
/// 48/16 = 3 and 48/14 = 3.43 are both above the 2.6 threshold, so the ternary
/// snaps to the identical rung. The drift collapses to an identity.
///
/// Inside an `InputGroupButton` the answer is the other one: its `xs` size adds
/// `[&>svg:not(…)]:size-3.5`, which *(measured)* wins over the Button base's
/// `size-4`, so a button icon paints **14×14** — `DsIcon(size: DsIconSize.sm)`.
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
class DsInputGroup extends StatefulWidget {
  const DsInputGroup({
    super.key,
    required this.child,
    this.startAddon,
    this.endAddon,
    this.invalid = false,
    this.enabled = true,
    this.focusNode,
  });

  /// The control. `DsInputGroupInput` in every case on the ported pages.
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
  /// [DsFieldScope]'s, since a `DsField` marking its control marks the group
  /// the control is in.
  final bool invalid;

  /// `has-disabled`.
  final bool enabled;

  /// The control's focus node.
  ///
  /// Defaults to the enclosing [DsFieldScope]'s so that a form's
  /// focus-on-error lands inside the group, and only owns one when there is no
  /// field above it.
  final FocusNode? focusNode;

  /// `h-10` — level with a bare `DsInput` and a default `DsButton`.
  static double get height => DsInput.height;

  /// `pl-4` / `pr-4` on the addon — the clearance the addon supplies itself.
  static double get addonInset => ds(4);

  /// `has-[>button]:-ml-0.5` / `-mr-0.5` — an addon holding a button pulls 2px
  /// back, clearing at 14 instead of 16.
  static double get addonButtonPull => ds(0.5);

  /// The control's own padding on a side an addon occupies: `pl-2` / `pr-2`.
  static double get clearance => ds(2);

  @override
  State<DsInputGroup> createState() => _DsInputGroupState();
}

class _DsInputGroupState extends State<DsInputGroup> {
  FocusNode? _ownedFocusNode;
  FocusNode? _scopeFocusNode;

  /// Tracks descendant focus — the `has-[…:focus-visible]` predicate.
  bool _focusWithin = false;

  FocusNode get _controlFocusNode =>
      widget.focusNode ?? _scopeFocusNode ?? (_ownedFocusNode ??= FocusNode());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scopeFocusNode = DsFieldScope.maybeOf(context)?.focusNode;
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
    final DsThemeData theme = DsTheme.of(context);
    final DsFieldScope? field = DsFieldScope.maybeOf(context);

    final bool invalid = widget.invalid || (field?.invalid ?? false);
    final bool enabled = widget.enabled && (field?.enabled ?? true);

    // `dark:has-[[data-slot][aria-invalid=true]]:ring-destructive/40` — the one
    // place in this family where the error ring changes with the theme.
    final double invalidAlpha = DsTheme.kindOf(context) == DsThemeKind.dark
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
    final Duration duration =
        dsAnimationDuration(context, DsDurations.transitionDefault);

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
      curve: DsCurves.out,
      builder: (BuildContext context, Color? b, Widget? child) =>
          TweenAnimationBuilder<Color?>(
        tween: ColorTween(end: ring),
        duration: duration,
        curve: DsCurves.out,
        builder: (BuildContext context, Color? r, Widget? child) {
          final Color ringColor = r ?? ring;
          return DsMachineSurface(
            spec: ringColor.a == 0
                ? DsShadows.pressed
                : DsButton.withFocusRing(DsShadows.pressed, ringColor),
            radius: BorderRadius.circular(DsRadii.pill),
            fill: theme.card,
            border: Border.all(color: b ?? border, width: DsWidths.hairline),
            // Threaded through both builders unrebuilt, so it is the `group`
            // handed to the outer `child:` and never null.
            child: child!,
          );
        },
        child: child,
      ),
      child: group,
    );

    group = SizedBox(height: DsInputGroup.height, child: group);

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

/// `InputGroupInput` — `DsInput` with the strip list applied and the clearance
/// rule resolved.
///
/// Everything it takes, it forwards; the two things it decides are [DsInput.bare]
/// and [DsInput.padding], and both are read off the enclosing group.
class DsInputGroupInput extends StatelessWidget {
  const DsInputGroupInput({
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

  /// [DsComponentType.inputNum] / [DsComponentType.inputSerial] — the I7
  /// collapse, already resolved in the foundation layer.
  final DsTypeSpec? textSpec;

  final String? label;

  @override
  Widget build(BuildContext context) {
    final _GroupScope? group = _GroupScope.maybeOf(context);
    assert(
      group != null,
      'DsInputGroupInput paints nothing on its own — the group is what draws '
      'the pill. Put it in a DsInputGroup, or use a bare DsInput.',
    );

    final EdgeInsets base = DsInput.insets;
    return DsInput(
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
        (group?.hasStartAddon ?? false) ? DsInputGroup.clearance : base.left,
        // `py-1` survives the strip — only the horizontal padding is contested.
        base.top,
        (group?.hasEndAddon ?? false) ? DsInputGroup.clearance : base.right,
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
class DsInputGroupAddon extends StatelessWidget {
  const DsInputGroupAddon({
    super.key,
    required this.child,
    this.align = DsInputGroupAlign.start,
    this.holdsButton,
  });

  /// A [DsInputGroupText], a `DsIcon`, or a [DsInputGroupButton].
  final Widget child;

  final DsInputGroupAlign align;

  /// `has-[>button]:-ml-0.5` / `-mr-0.5`.
  ///
  /// Inferred from [child] when omitted; state it to override. A `has-`
  /// selector inspects the subtree and Flutter cannot, so the inference is a
  /// direct type check against the one widget the selector can match.
  final bool? holdsButton;

  /// `py-1.5` — 6px. `h-auto` inside a centred 40px row, so it only bites when
  /// the content is taller than the pill's inner height.
  static double get insetY => ds(1.5);

  /// `gap-2` — 8px between an addon's own children, when it has more than one.
  static double get gap => ds(2);

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final _GroupScope? group = _GroupScope.maybeOf(context);
    final bool button = holdsButton ?? child is DsInputGroupButton;

    // `pl-4` / `pr-4`, less the 2px pull when a button is what is being
    // cleared.
    final double inset =
        DsInputGroup.addonInset - (button ? DsInputGroup.addonButtonPull : 0);

    Widget addon = Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
        align == DsInputGroupAlign.start ? inset : 0,
        insetY,
        align == DsInputGroupAlign.end ? inset : 0,
        insetY,
      ),
      child: Center(widthFactor: 1, child: child),
    );

    // `text-sm font-medium text-muted-foreground` — an ambient style, because
    // the addon types its children rather than its own text. `DsIcon` at
    // `DsIconTone.inherit` reads it too, which is what `[&>svg]` inherits on
    // the web.
    addon = DefaultTextStyle.merge(
      style: DsText.styleOf(
        context,
        DsComponentType.buttonLabel,
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
enum DsInputGroupAlign {
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
/// [DsComponentType.inputNum] and [DsComponentType.inputSerial] are that
/// collapse resolved. Passing [DsType.numBase] here would render two pixels
/// large and is the one mistake this doc exists to prevent.
class DsInputGroupText extends StatelessWidget {
  const DsInputGroupText(this.text, {super.key, this.spec});

  final String text;

  /// The `.type-*` class stacked on the span's `text-sm`. Defaults to the bare
  /// rung.
  final DsTypeSpec? spec;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return DsText(
      text,
      spec ?? DsComponentType.textSm,
      color: theme.mutedForeground,
    );
  }
}

/// `InputGroupButton` — a ghost `Button` at 24×auto with a 7px corner.
///
/// `size` is `Omit`ted from the props, so the reference builds a `Button` at
/// `size="default"` and then overrides height, gap, padding and radius through
/// its own `cva`. The geometry therefore belongs to *this* file rather than to
/// the button's size ladder, which is why it is stated here:
/// **24px tall, 6px horizontal padding, 4px gap, 7px radius, 13px text,
/// `variant="ghost"`, `shadow-none`** — with the base list's `btn-spring`,
/// `active:scale-95` and `focus-visible:ring-3 ring-ring/50` all surviving.
///
/// A 7px radius on a control inside a 999px pill is the only non-pill,
/// non-ladder corner in the system ([DsRadii.addonButton]).
///
/// It reproduces `DsButton`'s ghost row rather than wrapping [DsButton],
/// because at the time of writing `DsButton` exposes neither this height nor a
/// radius override — both live in another owner's file this wave. The three
/// lines of colour table below are the duplication that buys the independence;
/// if `DsButton` later takes a radius, this collapses onto it.
class DsInputGroupButton extends StatefulWidget {
  const DsInputGroupButton({
    super.key,
    required this.child,
    this.onPressed,
    this.label,
    this.toggled,
    this.focusNode,
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

  /// `h-6` — 24px.
  static double get height => ds(6);

  /// `px-1.5` — 6px.
  static double get paddingX => ds(1.5);

  /// `gap-1` — 4px. Exposed rather than applied, the same contract
  /// [DsButton.gapFor] uses: this widget takes one child, and a button with
  /// both an icon and a label composes its own row.
  static double get gap => ds(1);

  @override
  State<DsInputGroupButton> createState() => _DsInputGroupButtonState();
}

class _DsInputGroupButtonState extends State<DsInputGroupButton> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  bool get _enabled => widget.onPressed != null;

  void _set(void Function() change) => setState(change);

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    // `variant="ghost"`: no fill, no border, no elevation until touched.
    // `active` outranks `hover` — Tailwind orders it later — so a press shows
    // `--muted` even though the pointer is necessarily hovering.
    final Color fill = _pressed
        ? theme.muted
        : _hovered
            ? theme.secondary
            : dsTransparent;
    final Color ink =
        _hovered || _pressed ? theme.foreground : theme.mutedForeground;
    final Color border = _focused ? theme.ring : dsTransparent;

    final Duration duration = dsAnimationDuration(
      context,
      // `btn-spring`'s `:active { transition-duration: --duration-tick }`.
      _pressed ? DsDurations.tick : DsDurations.base,
    );

    Widget button = TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: fill),
      duration: duration,
      curve: DsCurves.spring,
      builder: (BuildContext context, Color? f, Widget? _) =>
          TweenAnimationBuilder<Color?>(
        tween: ColorTween(end: ink),
        duration: duration,
        curve: DsCurves.spring,
        builder: (BuildContext context, Color? c, Widget? _) =>
            TweenAnimationBuilder<Color?>(
          tween: ColorTween(end: border),
          duration: duration,
          curve: DsCurves.spring,
          builder: (BuildContext context, Color? b, Widget? _) {
            return DsMachineSurface(
              // `shadow-none` at rest; the focus ring is the only layer this
              // button ever paints.
              spec: _focused
                  ? DsButton.withFocusRing(
                      DsShadows.none,
                      theme.ring.withValues(alpha: _focusRingAlpha),
                    )
                  : DsShadows.none,
              radius: BorderRadius.circular(DsRadii.addonButton),
              fill: f ?? fill,
              border:
                  Border.all(color: b ?? border, width: DsWidths.hairline),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: DsInputGroupButton.paddingX,
                ),
                child: Center(
                  widthFactor: 1,
                  child: DefaultTextStyle(
                    style: DsText.styleOf(
                      context,
                      DsComponentType.buttonLabel,
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

    button = SizedBox(height: DsInputGroupButton.height, child: button);

    button = DsPress(
      scale: DsTransforms.buttonScale,
      downDuration: DsDurations.tick,
      upDuration: DsDurations.base,
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
