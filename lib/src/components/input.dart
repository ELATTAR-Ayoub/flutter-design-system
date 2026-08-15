/// `components/ui/input.tsx` — the sunken field.
///
/// One idea, and the shadows page is built around it: **controls you operate
/// stand proud, fields you type into are recessed.** The input carries
/// `--shadow-pressed` permanently — *"it is a socket, and it never rises"* —
/// so there is no hover state at all, and focus changes only the ring.
///
/// Every class, resolved (shadows-map §5.5):
///
/// | class | value |
/// |---|---|
/// | `h-10` | 40px — level with a default `Button`, which the JSDoc says outright |
/// | `w-full min-w-0` | the caller supplies the measure; the reference caps it at `max-w-sm` |
/// | `rounded-pill` | 999px → 20px stadium ends on a 40px control |
/// | `border border-input` | 1px |
/// | `bg-card` | — |
/// | `px-4 py-1` | 16px / 4px. The JSDoc explains 16 rather than 12–14: *a pill's corner eats ~20px on a 40px control* |
/// | `text-sm` | 13px, no `font-weight` of its own → `html`'s 400 |
/// | `shadow-pressed` | permanent |
/// | `outline-none` | — |
/// | `transition-[box-shadow,border-color,background-color] duration-base ease-out` | 250ms on `--ease-out` |
/// | `placeholder:text-muted-foreground` | — |
/// | `focus-visible:border-primary/50` | note `--primary`, not `--ring` |
/// | `focus-visible:ring-3 focus-visible:ring-ring/35` | **added to** `shadow-pressed`, not replacing it: the ring lives in `--tw-ring-shadow` and the socket in `--tw-shadow` |
///
/// DOCUMENTED DRIFT (shadows-map §12.7): the component's JSDoc claims *"a
/// placeholder at 60% muted"*. The class is `placeholder:text-muted-foreground`
/// at full opacity — the prose describes an intent the class never carried.
/// The class is what renders here.
library;

import 'package:flutter/widgets.dart';

import '../effects/machine_surface.dart';
import '../foundation/motion.dart';
import '../foundation/shadows.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../theme_scope.dart';
import 'button.dart';

/// `focus-visible:border-primary/50`.
const double _focusBorderAlpha = 0.50;

/// `focus-visible:ring-ring/35` — three quarters of a button's ring alpha,
/// because a field is already describing itself with a socket.
const double _focusRingAlpha = 0.35;

/// `disabled:opacity-45`, shared with `Button`'s base class list.
const double _disabledOpacity = 0.45;

/// The selection wash. `globals.css` sets no `::selection` rule on the field,
/// so this is the app-level selection colour the example already installs.
const double _selectionAlpha = 0.30;

/// A genuinely editable pill field.
///
/// Editable, keyboard-focusable, with a real caret — *"everything is a live
/// component"*. The shadows page's own section description promises "focus the
/// field", so the field is focusable in fact and not in appearance.
class DsInput extends StatefulWidget {
  const DsInput({
    super.key,
    this.controller,
    this.focusNode,
    this.placeholder,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.label,
  });

  /// Supply one to read or seed the text; otherwise the field owns its own and
  /// disposes it.
  final TextEditingController? controller;

  /// Supply one to drive focus from outside; otherwise the field owns its own.
  final FocusNode? focusNode;

  /// `placeholder="…"` — shown whenever the value is empty, focused or not,
  /// exactly as `::placeholder` behaves.
  final String? placeholder;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  /// `disabled` — `disabled:pointer-events-none disabled:opacity-45`.
  final bool enabled;

  /// The accessible name, for a field with no visible `<label>`.
  final String? label;

  /// `h-10` — 40px, deliberately level with a default `DsButton`.
  static double get height => ds(10);

  @override
  State<DsInput> createState() => _DsInputState();
}

class _DsInputState extends State<DsInput> {
  final GlobalKey<EditableTextState> _editableKey =
      GlobalKey<EditableTextState>();

  TextEditingController? _ownedController;
  FocusNode? _ownedFocusNode;

  TextEditingController get _controller =>
      widget.controller ?? (_ownedController ??= TextEditingController());

  FocusNode get _focusNode =>
      widget.focusNode ?? (_ownedFocusNode ??= FocusNode());

  bool _focused = false;

  @override
  void initState() {
    super.initState();
    // The placeholder appears and disappears with the value, so the field has
    // to rebuild on every edit even when the caller owns the controller.
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(DsInput old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      (old.controller ?? _ownedController)?.removeListener(_onTextChanged);
      _controller.addListener(_onTextChanged);
    }
    if (old.focusNode != widget.focusNode) {
      (old.focusNode ?? _ownedFocusNode)?.removeListener(_onFocusChanged);
      _focusNode.addListener(_onFocusChanged);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _ownedController?.dispose();
    _ownedFocusNode?.dispose();
    super.dispose();
  }

  void _onTextChanged() => setState(() {});

  void _onFocusChanged() {
    if (_focused == _focusNode.hasFocus) return;
    setState(() => _focused = _focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final BorderRadius radius = BorderRadius.circular(DsRadii.pill);

    // `text-sm` with no `font-weight` of its own, so it inherits `html`'s 400
    // — the identical declaration `SheetContent` carries, which is why this
    // reads the existing spec rather than restating 13px/400 outside the
    // foundation layer. A dedicated `inputText` spec is a rename away and
    // belongs in `typography.dart` the next time that file is opened.
    final TextStyle textStyle = DsText.styleOf(
      context,
      DsComponentType.sheetBody,
      color: theme.foreground,
    );

    final Widget editable = EditableText(
      key: _editableKey,
      controller: _controller,
      focusNode: _focusNode,
      readOnly: !widget.enabled,
      style: textStyle,
      cursorColor: theme.foreground,
      // iOS's floating-cursor ghost. Never seen on the docs surface, but
      // [EditableText] requires it.
      backgroundCursorColor: theme.mutedForeground,
      selectionColor: theme.primary.withValues(alpha: _selectionAlpha),
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
    );

    final Widget placeholder = widget.placeholder == null
        ? const SizedBox.shrink()
        : DsText(
            widget.placeholder!,
            DsComponentType.sheetBody,
            color: theme.mutedForeground,
            maxLines: 1,
            overflow: TextOverflow.clip,
            softWrap: false,
          );

    Widget field = TweenAnimationBuilder<double>(
      // `transition-[box-shadow,border-color,background-color]` at
      // `--duration-base` on `--ease-out`. One progress value drives both the
      // border tint and the ring's alpha, because they change together and
      // only together.
      tween: Tween<double>(end: _focused ? 1 : 0),
      duration: dsAnimationDuration(context, DsDurations.base),
      curve: DsCurves.out,
      builder: (BuildContext context, double t, Widget? child) {
        final Color border = Color.lerp(
          theme.input,
          theme.primary.withValues(alpha: _focusBorderAlpha),
          t,
        )!;
        // The ring is ADDED to `shadow-pressed`, never replacing it — the
        // socket is what makes the field read as editable and it never rises.
        final DsShadowSpec spec = t == 0
            ? DsShadows.pressed
            : DsButton.withFocusRing(
                DsShadows.pressed,
                theme.ring.withValues(alpha: _focusRingAlpha * t),
              );

        return DsMachineSurface(
          spec: spec,
          radius: radius,
          fill: theme.card,
          border: Border.all(color: border, width: DsWidths.hairline),
          child: Padding(
            // `px-4 py-1`. The surface has already inset this child by the
            // border's width, the way `box-sizing: border-box` does.
            padding: EdgeInsets.symmetric(
              horizontal: ds(4),
              vertical: ds(1),
            ),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: child,
            ),
          ),
        );
      },
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: <Widget>[
          // `w-full`: the field fills whatever measure the caller allows.
          SizedBox(width: double.infinity, child: editable),
          if (_controller.text.isEmpty)
            IgnorePointer(child: placeholder),
        ],
      ),
    );

    field = SizedBox(height: DsInput.height, child: field);

    // [EditableText] does not handle its own pointer gestures — `TextField`
    // wraps it in a selection gesture detector, and this port has no Material
    // dependency — so the tap that focuses the field is wired here. Focus
    // lands the caret at the end of the value, which is what a click on an
    // empty pill should do.
    field = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _editableKey.currentState?.requestKeyboard(),
      child: MouseRegion(
        cursor: widget.enabled ? SystemMouseCursors.text : MouseCursor.defer,
        child: field,
      ),
    );

    field = Opacity(
      opacity: widget.enabled ? 1 : _disabledOpacity,
      child: IgnorePointer(ignoring: !widget.enabled, child: field),
    );

    if (widget.label == null) return field;
    return Semantics(textField: true, label: widget.label, child: field);
  }
}
