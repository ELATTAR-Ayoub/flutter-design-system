/// `components/ui/input-otp.tsx` + the `input-otp` package it is markup for.
///
/// The shadcn file renders boxes; **`OTPInput` supplies the whole mechanism**,
/// and the mechanism is the part that has to be ported. What the package
/// actually builds (inputs-map §6.1) is a relative container holding the slot
/// markup, plus one real `<input>` stretched over the entire strip at
/// `position: absolute; inset: 0` with `color: transparent; caret-color:
/// transparent; pointer-events: all`, while the container itself is
/// `pointer-events: none`.
///
/// Three consequences the port reproduces:
///
/// 1. **The visible boxes are pure paint.** They receive no events. All input
///    goes to one invisible field, and that field covering the strip is what
///    makes the whole thing one hit target.
/// 2. **The real caret is never drawn.** `caret-color: transparent`; the caret
///    you see is a `<div>` (§6.3) animated by `anim-caret`.
/// 3. **A focused OTP shows no global focus outline.** The package's inline
///    `outline: 0 solid transparent` outranks the stylesheet's
///    `:focus-visible { outline: 2px … }`, so only the active slot's 3px ring
///    appears.
///
/// Six focusable fields would be the obvious build and it is the wrong one
/// (§15.3): the selection semantics — `onFocus` setting the range to
/// `[min(len, max−1), len]`, and a collapsed mid-value caret expanding to a
/// one-character range — are what land the ring on the right box, and they only
/// exist because there is exactly one selection.
///
/// DOCUMENTED DRIFT (inputs-map drift 13): **the digits are not mono.**
/// `InputOTPSlot` is `text-sm` — Inter 13/400 — with no `type-num*` class,
/// while the section description says *"using the numerical mono foundation"*.
/// The only mono in the whole component is the invisible overlay's
/// `font-family: monospace`, which paints nothing.
///
/// DOCUMENTED DRIFT (inputs-map drift 14): `.cn-input-otp` on the container
/// matches no rule anywhere in the project or its dependencies. Ported as the
/// no-op it is.
///
/// DOCUMENTED DRIFT (inputs-map drift 15): the group's
/// `has-aria-invalid:border-destructive` is inert — the group has no
/// border-width, so only its ring ever shows.
library;

import 'dart:math' as math;

import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../effects/machine_surface.dart';
import '../foundation/colors.dart';
import '../foundation/motion.dart';
import '../foundation/shadows.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../motion/keyframes.dart';
import '../theme_scope.dart';
import 'button.dart';
import 'field.dart';
import 'icon.dart';
import 'icon_paths.dart';

/// `data-[active=true]:ring-ring/50`.
const double _activeRingAlpha = 0.50;

/// `has-aria-invalid:ring-destructive/20`, and `dark:` at 40 — the group ring
/// follows `DsInputGroup`'s theme-split, not the bare field's flat 20.
const double _invalidRingAlpha = 0.20;
const double _invalidRingAlphaDark = 0.40;

/// `dark:bg-input/30` — the slot fill. **Light has none**: the boxes are
/// transparent there and read only by their hairlines.
const double _slotFillAlphaDark = 0.30;

/// `has-disabled:opacity-50`.
const double _disabledOpacity = 0.50;

/// `@keyframes pulls-caret` (globals.css L2454–2457), as a fraction of the
/// cycle:
///
/// | % | opacity |
/// |---|---|
/// | 0, 50 | 1 |
/// | 50.01, 100 | 0 |
///
/// A **1000ms square wave — 500ms on, 500ms off, hard cut, no fade.**
/// `steps(1, end)` makes every gap a hold and the 50 / 50.01 pair makes the cut
/// unambiguous even without it, so this is modelled as a discrete lookup rather
/// than as a tween through a step curve — the shape `DsSignOn.frameAt` already
/// established for a table that never interpolates.
const double _caretLitFraction = 0.5;

/// A six-digit verification field: painted boxes over one hidden input.
class DsInputOtp extends StatefulWidget {
  DsInputOtp({
    super.key,
    this.maxLength = 6,
    this.groups = const <int>[3, 3],
    this.controller,
    this.initialValue,
    this.focusNode,
    this.onChanged,
    this.enabled = true,
    this.invalid = false,
    this.label,
  })  : assert(
          controller == null || initialValue == null,
          'A controller already carries the value — seed it there instead.',
        ),
        assert(
          groups.fold<int>(0, (int a, int b) => a + b) == maxLength,
          'The groups have to spend exactly maxLength slots.',
        );

  /// `maxLength` — the digit count.
  final int maxLength;

  /// How the slots are grouped, with an `InputOTPSeparator` between each pair.
  ///
  /// `[3, 3]` on both demos: *"Six digits, grouped three and three."*
  final List<int> groups;

  final TextEditingController? controller;

  /// The seed. The page's second demo is controlled precisely because
  /// `defaultValue` alongside the package's own `value` makes React warn about
  /// a component switching between controlled and uncontrolled
  /// (`page.tsx:80–81`); Flutter has no such hazard, so a seed is a seed.
  final String? initialValue;

  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;

  /// `has-disabled:opacity-50`.
  final bool enabled;

  /// Paints the error state: destructive slot borders plus the group's ring.
  ///
  /// The reference wires no `aria-invalid` into this component at all — the
  /// classes are there and nothing on the inputs page reaches them. This is
  /// that dormant path made callable, at the values §6.2 records for it.
  final bool invalid;

  final String? label;

  /// `size-8` on the slot — 32px, `box-sizing: border-box`.
  static double get slotSize => ds(8);

  /// The separator's width: a 16px glyph in a box with no padding of its own.
  static double get separatorWidth => DsIcon.pxFor(DsIconSize.md);

  /// The whole strip: `96 + 16 + 96` = **208px** at the default shape.
  ///
  /// Borders live inside the slot boxes, so a group is exactly its slot count
  /// times 32 and nothing is added for the hairlines between them.
  static double widthFor(List<int> groups) =>
      groups.fold<double>(0, (double w, int n) => w + n * slotSize) +
      (groups.length - 1) * separatorWidth;

  @override
  State<DsInputOtp> createState() => _DsInputOtpState();
}

class _DsInputOtpState extends State<DsInputOtp> {
  final GlobalKey<EditableTextState> _editableKey =
      GlobalKey<EditableTextState>();

  TextEditingController? _ownedController;
  FocusNode? _ownedFocusNode;
  FocusNode? _scopeFocusNode;
  FocusNode? _hookedNode;

  TextEditingController get _controller =>
      widget.controller ??
      (_ownedController ??=
          TextEditingController(text: widget.initialValue ?? ''));

  FocusNode get _focusNode =>
      widget.focusNode ?? _scopeFocusNode ?? (_ownedFocusNode ??= FocusNode());

  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onValueChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scopeFocusNode = DsFieldScope.maybeOf(context)?.focusNode;
    _syncFocusHook();
  }

  @override
  void didUpdateWidget(DsInputOtp old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      (old.controller ?? _ownedController)?.removeListener(_onValueChanged);
      _controller.addListener(_onValueChanged);
    }
    _syncFocusHook();
  }

  void _syncFocusHook() {
    final FocusNode node = _focusNode;
    if (identical(_hookedNode, node)) return;
    _hookedNode?.removeListener(_onFocusChanged);
    node.addListener(_onFocusChanged);
    _hookedNode = node;
    _onFocusChanged();
  }

  @override
  void dispose() {
    _controller.removeListener(_onValueChanged);
    _hookedNode?.removeListener(_onFocusChanged);
    _ownedController?.dispose();
    _ownedFocusNode?.dispose();
    super.dispose();
  }

  void _onValueChanged() {
    if (mounted) setState(() {});
  }

  void _onFocusChanged() {
    if (!mounted || _focused == _focusNode.hasFocus) return;
    setState(() => _focused = _focusNode.hasFocus);
    if (!_focused) return;
    // The package's own `onFocus`:
    //   setSelectionRange(min(value.length, maxLength - 1), value.length)
    // On an empty field that is `[0, 0]` and slot 0 goes active; on a full one
    // it is `[5, 6]`, which is why a complete code shows a ring on its LAST box
    // rather than past the end.
    final int length = _controller.text.length;
    _controller.selection = TextSelection(
      baseOffset: math.min(length, widget.maxLength - 1),
      extentOffset: length,
    );
  }

  /// The selection the slot reducer actually sees.
  ///
  /// The package's `selectionchange` handler expands a collapsed caret sitting
  /// *inside* the value to a one-character range, so that clicking into the
  /// middle rings the box you clicked rather than the gap before it. Modelled
  /// as a read rather than a write: the expansion changes nothing but which
  /// slot reports active, and writing it back would re-enter the controller's
  /// own notification.
  TextSelection get _selection {
    final TextSelection selection = _controller.selection;
    if (selection.isValid &&
        selection.isCollapsed &&
        selection.baseOffset < _controller.text.length) {
      return TextSelection(
        baseOffset: selection.baseOffset,
        extentOffset: selection.baseOffset + 1,
      );
    }
    return selection;
  }

  /// The package's slot reducer, transcribed (§6.3):
  ///
  /// ```
  /// isActive = isFocused && selStart !== null && selEnd !== null
  ///            && ((selStart === selEnd && i === selStart)
  ///                || (i >= selStart && i < selEnd))
  /// ```
  bool _isActive(int index) {
    if (!_focused) return false;
    final TextSelection selection = _selection;
    if (!selection.isValid) return false;
    final int start = selection.start;
    final int end = selection.end;
    if (start == end) return index == start;
    return index >= start && index < end;
  }

  /// `char = value[i] ?? null`.
  String? _charAt(int index) {
    final String value = _controller.text;
    return index < value.length ? value[index] : null;
  }

  @override
  Widget build(BuildContext context) {
    final DsFieldScope? scope = DsFieldScope.maybeOf(context);

    final bool invalid = widget.invalid || (scope?.invalid ?? false);
    final bool enabled = widget.enabled && (scope?.enabled ?? true);
    final String? label = widget.label ?? scope?.label;
    final String? hint = scope?.describedBy;

    final List<Widget> strip = <Widget>[];
    int slot = 0;
    for (int g = 0; g < widget.groups.length; g++) {
      if (g > 0) strip.add(const DsInputOtpSeparator());
      strip.add(_group(first: slot, count: widget.groups[g], invalid: invalid));
      slot += widget.groups[g];
    }

    // `color: transparent; caret-color: transparent` — the field is real, and
    // it paints nothing. Everything visible is the boxes behind it.
    final Widget hidden = EditableText(
      key: _editableKey,
      controller: _controller,
      focusNode: _focusNode,
      readOnly: !enabled,
      style: DsText.styleOf(context, DsComponentType.textSm,
          color: dsTransparent),
      cursorColor: dsTransparent,
      backgroundCursorColor: dsTransparent,
      selectionColor: dsTransparent,
      showCursor: false,
      enableInteractiveSelection: false,
      // `spellCheck={false}` (`input-otp.tsx:24`), `inputMode="numeric"` and
      // `autoComplete="one-time-code"` (package).
      autocorrect: false,
      enableSuggestions: false,
      keyboardType: TextInputType.number,
      autofillHints: const <String>[AutofillHints.oneTimeCode],
      inputFormatters: <TextInputFormatter>[
        LengthLimitingTextInputFormatter(widget.maxLength),
      ],
      onChanged: widget.onChanged,
    );

    Widget field = Stack(
      // The active slot's 3px ring reaches past the strip, and so does the
      // group's error ring. Neither may be trimmed to the row's box.
      clipBehavior: Clip.none,
      children: <Widget>[
        // `pointer-events: none` on the container: the boxes are paint.
        IgnorePointer(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: strip,
          ),
        ),
        // `position: absolute; inset: 0; pointer-events: all` — one hit target
        // over the whole strip.
        Positioned.fill(child: hidden),
      ],
    );

    field = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _editableKey.currentState?.requestKeyboard(),
      child: MouseRegion(
        // `cursor: text` on the container.
        cursor: enabled ? SystemMouseCursors.text : MouseCursor.defer,
        child: field,
      ),
    );

    field = Opacity(
      opacity: enabled ? 1 : _disabledOpacity,
      child: IgnorePointer(ignoring: !enabled, child: field),
    );

    // The strip is intrinsically sized; giving it its own width keeps a caller
    // that stretches it from stretching the boxes.
    field = SizedBox(
      width: DsInputOtp.widthFor(widget.groups),
      height: DsInputOtp.slotSize,
      child: field,
    );

    return Semantics(
      textField: true,
      label: label,
      hint: hint,
      enabled: enabled,
      validationResult: invalid
          ? SemanticsValidationResult.invalid
          : SemanticsValidationResult.none,
      child: field,
    );
  }

  /// One `InputOTPGroup` — `flex items-center rounded-lg`, plus the invalid
  /// ring it is the only carrier of.
  Widget _group({required int first, required int count, required bool invalid}) {
    final DsThemeData theme = DsTheme.of(context);
    final double width = count * DsInputOtp.slotSize;

    // `z-10` on the active slot exists so its 3px ring paints over its
    // neighbours' borders instead of under them. Paint order is Flutter's only
    // z-index, so the active slot is simply drawn last.
    final List<int> order = <int>[
      for (int i = first; i < first + count; i++)
        if (!_isActive(i)) i,
      for (int i = first; i < first + count; i++)
        if (_isActive(i)) i,
    ];

    Widget group = SizedBox(
      width: width,
      height: DsInputOtp.slotSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          for (final int i in order)
            PositionedDirectional(
              start: (i - first) * DsInputOtp.slotSize,
              top: 0,
              width: DsInputOtp.slotSize,
              height: DsInputOtp.slotSize,
              child: DsInputOtpSlot(
                char: _charAt(i),
                active: _isActive(i),
                invalid: invalid,
                first: i == first,
                last: i == first + count - 1,
              ),
            ),
        ],
      ),
    );

    if (invalid) {
      final double alpha = DsTheme.kindOf(context) == DsThemeKind.dark
          ? _invalidRingAlphaDark
          : _invalidRingAlpha;
      group = DsMachineSurface(
        // `has-aria-invalid:ring-3 ring-destructive/20`. The group's own
        // `has-aria-invalid:border-destructive` never shows — it declares no
        // border-width — so no border is painted here either.
        spec: DsButton.withFocusRing(
          DsShadows.none,
          theme.destructive.withValues(alpha: alpha),
        ),
        radius: BorderRadius.circular(DsRadii.lg),
        child: group,
      );
    }

    return group;
  }
}

/// `InputOTPSlot` — a 32px box that paints one character, its state, and
/// nothing else.
///
/// Public because it is the only way to render a specimen of a state the live
/// strip cannot be talked into: **both demos on the page are static as
/// rendered** (drift 16) — the active ring and the caret are focus-only, and
/// nothing autofocuses.
class DsInputOtpSlot extends StatelessWidget {
  const DsInputOtpSlot({
    super.key,
    this.char,
    this.active = false,
    this.invalid = false,
    this.first = false,
    this.last = false,
  });

  /// `char` — null renders an empty box.
  final String? char;

  /// `data-active` — the slot the selection is on.
  final bool active;

  /// `aria-invalid`.
  final bool invalid;

  /// `:first-child` — takes the left border and the left corners.
  final bool first;

  /// `:last-child` — takes the right corners.
  final bool last;

  /// `hasFakeCaret = isActive && char === null`.
  bool get showsCaret => active && char == null;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final bool dark = DsTheme.kindOf(context) == DsThemeKind.dark;

    // `data-[active=true]:aria-invalid:border-destructive` — invalid keeps the
    // destructive border even while active, and only the ring changes.
    final Color borderColor = invalid
        ? theme.destructive
        : active
            ? theme.ring
            : theme.input;
    final Color ring = active
        ? (invalid
            ? theme.destructive.withValues(
                alpha: dark ? _invalidRingAlphaDark : _invalidRingAlpha)
            : theme.ring.withValues(alpha: _activeRingAlpha))
        : theme.ring.withValues(alpha: 0);

    final BorderSide side =
        BorderSide(color: borderColor, width: DsWidths.hairline);
    final BorderRadius radius = BorderRadius.horizontal(
      // `first:rounded-l-lg`, `last:rounded-r-lg`; every inner corner is square.
      left: Radius.circular(first ? DsRadii.lg : 0),
      right: Radius.circular(last ? DsRadii.lg : 0),
    );

    // `transition-all` with no duration class at all, so this is the
    // framework default outright (L395–396).
    final Duration duration =
        dsAnimationDuration(context, DsDurations.transitionDefault);

    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: borderColor),
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
                ? DsShadows.none
                : DsButton.withFocusRing(DsShadows.none, ringColor),
            radius: radius,
            // `dark:bg-input/30`, and nothing at all on light.
            fill: dark
                ? theme.input.withValues(alpha: _slotFillAlphaDark)
                : null,
            // `border-y border-r`, and `first:border-l`. The left border is
            // omitted on every slot but the first, so adjacent boxes share one
            // hairline instead of stacking two.
            border: Border(
              top: side.copyWith(color: b ?? borderColor),
              right: side.copyWith(color: b ?? borderColor),
              bottom: side.copyWith(color: b ?? borderColor),
              left: first
                  ? side.copyWith(color: b ?? borderColor)
                  : BorderSide.none,
            ),
            child: child!,
          );
        },
        child: child,
      ),
      child: _content(context, theme),
    );
  }

  Widget _content(BuildContext context, DsThemeData theme) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        if (char != null)
          // `text-sm` — Inter 13/400 at `--foreground`. Not mono; see drift 13.
          DsText(char!, DsComponentType.textSm, color: theme.foreground),
        if (showsCaret) const _FakeCaret(),
      ],
    );
  }
}

/// The caret the package draws because the real one is transparent:
/// `<div class="h-4 w-px anim-caret bg-foreground">`, centred in the slot.
class _FakeCaret extends StatelessWidget {
  const _FakeCaret();

  /// `h-4` — 16px, half the slot's height.
  static double get height => ds(4);

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return DsKeyframePlayer(
      duration: DsDurations.caret,
      repeat: true,
      // No fill mode is declared on `anim-caret`, so under reduced motion the
      // caret reverts to the element's own resting style — **opacity 1, steady,
      // visible** (inputs-map §6.3). `DsKeyframeFill.none` freezes the player at
      // stop 0, which is exactly that.
      fill: DsKeyframeFill.none,
      builder: (BuildContext context, double t, Widget? child) => Opacity(
        opacity: t < _caretLitFraction ? 1 : 0,
        child: child,
      ),
      child: SizedBox(
        // `w-px` — one logical pixel, not one hairline token: the caret is
        // a rule the stylesheet sizes in `px` directly.
        width: DsWidths.hairline,
        height: _FakeCaret.height,
        child: ColoredBox(color: theme.foreground),
      ),
    );
  }
}

/// `InputOTPSeparator` — `role="separator"` around one `Minus` glyph.
class DsInputOtpSeparator extends StatelessWidget {
  const DsInputOtpSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    // `role="separator"` has no Flutter counterpart worth inventing, and a
    // dash announced between two halves of a code is noise (inputs-map §7.2).
    return const ExcludeSemantics(
      // Default size and tone: 16px at `text-current`, which inherits
      // `--foreground` — and turns with a `DsField`'s invalid colouring, the
      // same as `currentColor` does.
      child: DsIcon(DsIconGlyph.minus),
    );
  }
}
