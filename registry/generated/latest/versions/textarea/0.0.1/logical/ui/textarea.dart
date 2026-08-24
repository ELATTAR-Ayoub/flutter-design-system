/// `components/ui/textarea.tsx` — the same socket, the wrong shape for a pill.
///
/// Every class it shares with `Input` it shares exactly: `border-input`,
/// `bg-card`, `shadow-pressed`, the 250ms `--ease-out` transition, the
/// `focus-visible:border-primary/50` + `ring-ring/35` pair, the
/// `aria-invalid:border-destructive` + `ring-destructive/20` pair with no
/// `dark:` variant. Four things differ, and all four are consequences of
/// holding more than one line (inputs-map §5.1, §12.3):
///
/// | | `Input` | `Textarea` |
/// |---|---|---|
/// | radius | `rounded-pill` **999** | `rounded-lg` **12** |
/// | height | fixed `h-10` 40 | `min-h-20` **80**, `field-sizing: content`, no max |
/// | padding | `px-4 py-1` 16/4 | `px-3.5 py-2.5` **14/10** |
/// | leading | none of its own | `leading-relaxed` **1.625** → a 21.125px line box |
/// | disabled | adds `pointer-events-none` | **does not** |
///
/// **The lg-radius exception.** Everything else in the family is
/// `rounded-pill`: `Input` 999, `InputGroup` 999, `InputGroupButton` 7. The
/// textarea is the family's only member on the radius ladder, and the reason is
/// geometric rather than stylistic — a pill's radius is half its height, and
/// half of 80px is a 40px sweep that would swallow the first and last lines of
/// a multi-line field. It is a hard exception, not a parameter default, which
/// is why there is no `radius` on this widget.
///
/// DOCUMENTED DIVERGENCE: Preflight's `textarea { resize: vertical }` is UA
/// chrome with no Flutter counterpart and is dropped (inputs-map §15.1). So is
/// `rows`, which the composed form passes as `rows={3}` — `field-sizing:
/// content` sizes the box from its value and `min-h-20` is the floor, so the
/// attribute contributes nothing to the rendered height either.
library;

import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';

import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../theme_scope.dart';
import 'field.dart';
import 'input.dart';

/// `disabled:opacity-45` — the same 45 the bare field uses, and deliberately
/// not `ElInputGroup`'s 50 (inputs-map drift 7).
const double _disabledOpacity = 0.45;

/// A field that grows with what is typed into it.
class ElTextarea extends StatefulWidget {
  const ElTextarea({
    super.key,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.placeholder,
    this.onChanged,
    this.enabled = true,
    this.readOnly = false,
    this.invalid = false,
    this.label,
    this.hint,
  }) : assert(
         controller == null || initialValue == null,
         'A controller already carries the value — seed it there instead.',
       );

  final TextEditingController? controller;

  /// `defaultValue`, read once when the field builds its own controller.
  final String? initialValue;

  final FocusNode? focusNode;

  final String? placeholder;
  final ValueChanged<String>? onChanged;

  /// `disabled` — 45% opacity and not editable. Unlike `Input`, the class list
  /// carries **no `pointer-events-none`**, so a disabled textarea still takes
  /// the pointer; only `cursor-not-allowed` marks it.
  final bool enabled;

  final bool readOnly;

  /// `aria-invalid`. ORed with the enclosing [ElFieldScope]'s, and it beats
  /// focus on both properties they share (forms-map §3.3).
  final bool invalid;

  final String? label;
  final String? hint;

  /// `min-h-20` — 80px, the floor. There is no ceiling: `field-sizing: content`
  /// grows the box with the value and the class list declares no `max-h`.
  static double get minHeight => el(20);

  /// `px-3.5 py-2.5` — 14px / 10px.
  static EdgeInsets get insets =>
      EdgeInsets.symmetric(horizontal: el(3.5), vertical: el(2.5));

  @override
  State<ElTextarea> createState() => _ElTextareaState();
}

class _ElTextareaState extends State<ElTextarea> {
  final GlobalKey<EditableTextState> _editableKey =
      GlobalKey<EditableTextState>();

  TextEditingController? _ownedController;
  FocusNode? _ownedFocusNode;
  FocusNode? _scopeFocusNode;
  FocusNode? _hookedNode;

  TextEditingController get _controller =>
      widget.controller ??
      (_ownedController ??= TextEditingController(
        text: widget.initialValue ?? '',
      ));

  FocusNode get _focusNode =>
      widget.focusNode ?? _scopeFocusNode ?? (_ownedFocusNode ??= FocusNode());

  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scopeFocusNode = ElFieldScope.maybeOf(context)?.focusNode;
    _syncFocusHook();
  }

  @override
  void didUpdateWidget(ElTextarea old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      (old.controller ?? _ownedController)?.removeListener(_onTextChanged);
      _controller.addListener(_onTextChanged);
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
    _controller.removeListener(_onTextChanged);
    _hookedNode?.removeListener(_onFocusChanged);
    _ownedController?.dispose();
    _ownedFocusNode?.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (mounted) setState(() {});
  }

  void _onFocusChanged() {
    if (!mounted || _focused == _focusNode.hasFocus) return;
    setState(() => _focused = _focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final ElFieldScope? scope = ElFieldScope.maybeOf(context);

    final bool invalid = widget.invalid || (scope?.invalid ?? false);
    final bool enabled = widget.enabled && (scope?.enabled ?? true);
    final String? label = widget.label ?? scope?.label;
    final String? hint = widget.hint ?? scope?.describedBy;

    // `textarea { color: inherit }`, exactly as on the input — which is what
    // carries `Field`'s invalid colouring into the typed text.
    final TextStyle textStyle = ElText.styleOf(
      context,
      ElComponentType.textareaBody,
    );

    final Widget editable = EditableText(
      key: _editableKey,
      controller: _controller,
      focusNode: _focusNode,
      readOnly: widget.readOnly || !enabled,
      // `field-sizing: content`: no line cap, so the box is whatever the value
      // needs and [ElTextarea.minHeight] is the floor under it.
      maxLines: null,
      minLines: null,
      keyboardType: TextInputType.multiline,
      style: textStyle,
      cursorColor: theme.foreground,
      backgroundCursorColor: theme.mutedForeground,
      selectionColor: theme.primary.withValues(
        alpha: ElFieldSurface.selectionAlpha,
      ),
      onChanged: widget.onChanged,
    );

    Widget body = Stack(
      alignment: AlignmentDirectional.topStart,
      children: <Widget>[
        SizedBox(width: double.infinity, child: editable),
        if (_controller.text.isEmpty && widget.placeholder != null)
          // Positioned so it never contributes to the box's height — the value
          // alone decides that, which is what `field-sizing: content` means.
          Positioned.fill(
            child: IgnorePointer(
              child: Align(
                alignment: AlignmentDirectional.topStart,
                child: ElText(
                  widget.placeholder!,
                  ElComponentType.textareaBody,
                  color: theme.mutedForeground,
                ),
              ),
            ),
          ),
      ],
    );

    body = ConstrainedBox(
      // `min-h-20` is on the border box, so the floor goes outside the surface
      // — the border and the padding are paid for from inside the 80px.
      constraints: BoxConstraints(minHeight: ElTextarea.minHeight),
      child: ElFieldSurface(
        radius: BorderRadius.circular(ElRadii.lg),
        focused: _focused,
        invalid: invalid,
        child: Padding(padding: ElTextarea.insets, child: body),
      ),
    );

    body = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _editableKey.currentState?.requestKeyboard(),
      child: MouseRegion(
        cursor: enabled
            ? SystemMouseCursors.text
            : SystemMouseCursors.forbidden,
        child: body,
      ),
    );

    // `disabled:opacity-45` — and **no** `IgnorePointer`. The class list omits
    // `pointer-events-none` where the input's carries it, so a disabled
    // textarea still receives the pointer and shows `cursor-not-allowed` for it.
    body = Opacity(opacity: enabled ? 1 : _disabledOpacity, child: body);

    if (label != null || hint != null || invalid) {
      body = Semantics(
        textField: true,
        multiline: true,
        label: label,
        hint: hint,
        readOnly: widget.readOnly,
        enabled: enabled,
        validationResult: invalid
            ? SemanticsValidationResult.invalid
            : SemanticsValidationResult.none,
        child: body,
      );
    }

    // USER-ORDERED MOBILE ADAPTATION — the family's one hook, from
    // [ElFieldVisibility]. This widget keeps its own copy of the focus plumbing
    // (it always has, because the surface is shared and the state is not), so
    // it wears the mechanism rather than restating it.
    return ElFieldVisibility(focusNode: _focusNode, child: body);
  }
}
