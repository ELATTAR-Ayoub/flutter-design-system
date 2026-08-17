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
/// | `transition-[box-shadow,border-color,background-color] duration-base ease-out` | 250ms on `--ease-out` — from `--default-transition-duration`; `duration-base` emits nothing ([DsDurations.transitionDefault]) |
/// | `placeholder:text-muted-foreground` | — |
/// | `focus-visible:border-primary/50` | note `--primary`, not `--ring` |
/// | `focus-visible:ring-3 focus-visible:ring-ring/35` | **added to** `shadow-pressed`, not replacing it: the ring lives in `--tw-ring-shadow` and the socket in `--tw-shadow` |
/// | `aria-invalid:border-destructive` + `ring-3 ring-destructive/20` | no `dark:` variant on the bare field |
/// | `disabled:pointer-events-none disabled:cursor-not-allowed disabled:opacity-45` | — |
///
/// **Ruling I2 — this stays the bare pill.** The reference splits addons out
/// rather than folding them in: `InputGroupInput` *strips* this component
/// (`border-0 shadow-none ring-0 bg-transparent rounded-none`) and lets the
/// wrapper paint everything. So [DsInput] grows a [DsInput.bare] mode and a
/// [DsInput.padding] override — the two things the strip list amounts to — and
/// nothing resembling a prefix or suffix slot. `DsInputGroup` is the socket.
///
/// DOCUMENTED DRIFT (shadows-map §12.7): the component's JSDoc claims *"a
/// placeholder at 60% muted"*. The class is `placeholder:text-muted-foreground`
/// at full opacity — the prose describes an intent the class never carried.
/// The class is what renders here.
///
/// DOCUMENTED DIVERGENCE: `.type-serial`'s `text-transform: uppercase` is a
/// *rendering* transform on the web — it never touches the value. Flutter's
/// [EditableText] has no text-transform, and an input formatter would change
/// the value, which is exactly what the reference does not do. So a serial
/// field renders what was typed. Nothing on the ported pages shows it: the
/// invite-code field carries a placeholder that is already uppercase and no
/// seeded value.
///
/// USER-ORDERED MOBILE ADAPTATION: this file also owns [DsFieldVisibility], the
/// whole family's one keyboard-avoidance mechanism — the field surface is
/// shared here, so the focus plumbing that keeps a focused field off the
/// software keyboard is shared here too. It is inert wherever there is no
/// software keyboard, so nothing on a desktop frame changes by a pixel.
library;

// `rendering.dart` for [RenderAbstractViewport], which [DsFieldVisibility]
// measures the keyboard against; it re-exports `semantics.dart`, which this
// file used to import for [SemanticsValidationResult] alone.
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../effects/machine_surface.dart';
import '../foundation/motion.dart';
import '../foundation/shadows.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../theme_scope.dart';
import 'button.dart';
import 'field.dart';

/// `focus-visible:border-primary/50`.
const double _focusBorderAlpha = 0.50;

/// `focus-visible:ring-ring/35` — three quarters of a button's ring alpha,
/// because a field is already describing itself with a socket.
const double _focusRingAlpha = 0.35;

/// `aria-invalid:ring-destructive/20`. The bare field declares **no `dark:`
/// variant**, so this alpha is both themes — unlike `DsInputGroup`, which rings
/// at 40% on dark. Same error state, two reds, depending only on whether an
/// addon happens to be present (inputs-map drift 6).
const double _invalidRingAlpha = 0.20;

/// `disabled:opacity-45`, shared with `Button`'s base class list.
const double _disabledOpacity = 0.45;

/// A genuinely editable pill field.
///
/// Editable, keyboard-focusable, with a real caret — *"everything is a live
/// component"*. The shadows page's own section description promises "focus the
/// field", so the field is focusable in fact and not in appearance.
class DsInput extends StatefulWidget {
  const DsInput({
    super.key,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.placeholder,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.invalid = false,
    this.obscureText = false,
    this.keyboardType,
    this.autofillHints,
    this.textSpec,
    this.label,
    this.hint,
    this.bare = false,
    this.padding,
    this.boxHeight,
    this.fill,
    this.flat = false,
    this.radius,
  }) : assert(
          controller == null || initialValue == null,
          'A controller already carries the value — seed it there instead.',
        );

  /// Supply one to read or seed the text; otherwise the field owns its own and
  /// disposes it.
  final TextEditingController? controller;

  /// `defaultValue` — the seed for the field's **own** controller.
  ///
  /// Uncontrolled, exactly as the attribute is: it is read once, when the
  /// controller is created, and a later change to it does nothing. Every seeded
  /// specimen in the state grid uses this rather than holding a controller the
  /// page has no other use for.
  final String? initialValue;

  /// Supply one to drive focus from outside; otherwise the field owns its own.
  ///
  /// A [DsFieldScope]'s node wins over the owned one and loses to this — the
  /// child's own props beat what the slot merges in, which is the order
  /// `FormControl`'s Radix `Slot` uses (forms-map §3.1).
  final FocusNode? focusNode;

  /// `placeholder="…"` — shown whenever the value is empty, focused or not,
  /// exactly as `::placeholder` behaves.
  final String? placeholder;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  /// `disabled` — `disabled:pointer-events-none disabled:opacity-45`.
  ///
  /// ANDed with the scope's: a field inside a disabled group is disabled, and
  /// there is no way to opt back in, which is what a `:disabled` cascade does.
  final bool enabled;

  /// `readOnly` — the value is selectable but not editable.
  ///
  /// `input.tsx` has **no `read-only:` variant**, so this changes nothing
  /// visually on its own; the state grid's Read-only cell gets its muted ink
  /// from a `text-muted-foreground` class, which is page-local paint and not a
  /// property of this component (inputs-map §3.1 cell 8).
  final bool readOnly;

  /// `aria-invalid` — the single switch for the error appearance.
  ///
  /// ORed with the scope's, so a `DsField` carrying an error marks its control
  /// without the call site restating it — the `FormControl` contract.
  ///
  /// The paint **beats focus**: the `aria-invalid:` rules are emitted after the
  /// `focus-visible:` ones at equal (0,2,0) specificity (forms-map §3.3,
  /// measured), so a focused invalid field is pixel-identical to an unfocused
  /// one. Ruling F5 keeps that visible.
  final bool invalid;

  /// `type="password"`.
  final bool obscureText;

  /// `type` / `inputMode` — what the mobile keyboard opens as.
  final TextInputType? keyboardType;

  /// `autoComplete="…"`.
  final List<String>? autofillHints;

  /// The `.type-*` class stacked on the field's own `text-sm`.
  ///
  /// Ruling I7: a `.type-*` class lives in `@layer components` and `text-sm` is
  /// a utility, so **the utility wins the properties they share** and the class
  /// contributes only what it alone declares. [DsComponentType.inputNum] and
  /// [DsComponentType.inputSerial] are those two collapses already resolved in
  /// the foundation layer; passing [DsType.numBase] here would render 15px and
  /// be wrong by two pixels.
  ///
  /// Defaults to [DsComponentType.sheetBody] — the bare `text-sm`, 13/400.
  final DsTypeSpec? textSpec;

  /// The accessible name, for a field with no visible `<label>`.
  ///
  /// A [DsFieldScope] supplies it from the visible `DsFieldLabel`, which is the
  /// `<label for=…>` translation: one string, announced once.
  final String? label;

  /// What `aria-describedby` points at, folded into `Semantics(hint:)`.
  ///
  /// Flutter has no id graph, so the description — and the error after it, in
  /// the DOM order the id list encodes — collapses into the one channel that
  /// reads after the label (inputs-map §7.2).
  final String? hint;

  /// `InputGroupInput`'s strip list: `rounded-none border-0 bg-transparent
  /// shadow-none ring-0 focus-visible:border-transparent focus-visible:ring-0
  /// aria-invalid:ring-0`.
  ///
  /// With all of that gone the surface paints nothing at all, so it is not
  /// built: what is left is a padded, editable line that the wrapper decorates.
  /// It also drops the fixed [height] — `h-10` inside a 40px group with a 1px
  /// border overflows the line box by a pixel each way in the browser, and a
  /// field that fills its socket lands the text on the same centre line.
  final bool bare;

  /// Overrides `px-4 py-1`.
  ///
  /// This is the group's clearance rule (inputs-map §4.2) arriving from
  /// outside: four `has-*` selectors at (0,2,1) beat the input's own `px-4` at
  /// (0,1,0) and drop the padding to 8px on whichever side an addon occupies.
  /// `DsInputGroupInput` computes it; nothing else should need to.
  final EdgeInsetsGeometry? padding;

  /// Overrides `h-10`.
  ///
  /// One consumer: `SidebarInput`, which is `Input` plus `h-8 w-full
  /// bg-background shadow-none` — a 32px field, because a sidebar header is
  /// not a form. Named [boxHeight] rather than `height` because [height] is
  /// already the class's own static reading of `h-10`, and Dart will not let a
  /// class hold both.
  final double? boxHeight;

  /// Overrides the socket's `bg-card` fill.
  ///
  /// `SidebarInput`'s `bg-background`: the panel is already `--sidebar` (which
  /// **is** `--card`), so a field wearing the same fill would have no socket at
  /// all. Sinking it to `--background` is what makes the well read as a well.
  final Color? fill;

  /// `shadow-none` — drops `shadow-pressed`, keeping the focus ring.
  ///
  /// The two are different Tailwind slots: `shadow-none` clears `--tw-shadow`
  /// and says nothing about `--tw-ring-shadow`. *(Measured on `SidebarInput`:
  /// five fully transparent `box-shadow` layers at rest — the four framework
  /// placeholders and nothing else — with the ring still arriving on focus.)*
  final bool flat;

  /// Overrides the socket's `rounded-pill`.
  ///
  /// One consumer: the agent's history card, whose inline rename field is
  /// `h-6 rounded-sm px-1.5 py-0 shadow-none` — *(measured 348 × 24 at
  /// `border-radius: 6px`)*. A pill on a 24px box would be a lozenge sitting
  /// inside a 12px-cornered row, which is the same argument `SidebarMenuButton`
  /// makes against [DsButton.radius].
  final BorderRadius? radius;

  /// `h-10` — 40px, deliberately level with a default `DsButton`.
  static double get height => ds(10);

  /// `px-4 py-1` — the field's own padding, before any clearance override.
  static EdgeInsets get insets =>
      EdgeInsets.symmetric(horizontal: ds(4), vertical: ds(1));

  @override
  State<DsInput> createState() => _DsInputState();
}

class _DsInputState extends State<DsInput> {
  final GlobalKey<EditableTextState> _editableKey =
      GlobalKey<EditableTextState>();

  TextEditingController? _ownedController;
  FocusNode? _ownedFocusNode;

  /// The node the scope offers, cached so [dispose] can unhook the same object
  /// it hooked — a scope change swaps it mid-life.
  FocusNode? _scopeFocusNode;

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
    // The placeholder appears and disappears with the value, so the field has
    // to rebuild on every edit even when the caller owns the controller.
    _controller.addListener(_onTextChanged);
  }

  /// The node [_onFocusChanged] is currently attached to.
  ///
  /// Tracked by identity rather than by "is a listener attached", because three
  /// separate things can swap the resolved node — a new `focusNode` prop, a new
  /// [DsFieldScope], or the first fall-through to the owned one — and every one
  /// of them has to detach the old object and attach the new.
  FocusNode? _hookedNode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scopeFocusNode = DsFieldScope.maybeOf(context)?.focusNode;
    _syncFocusHook();
  }

  @override
  void didUpdateWidget(DsInput old) {
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
    final DsThemeData theme = DsTheme.of(context);
    final DsFieldScope? scope = DsFieldScope.maybeOf(context);

    // The slot merge (`FormControl`): the scope supplies what the id graph
    // would have wired, and the child's own props win where both speak.
    final bool invalid = widget.invalid || (scope?.invalid ?? false);
    final bool enabled = widget.enabled && (scope?.enabled ?? true);
    final String? label = widget.label ?? scope?.label;
    final String? hint = widget.hint ?? scope?.describedBy;

    final DsTypeSpec spec = widget.textSpec ?? DsComponentType.sheetBody;

    // `input { color: inherit }` (Preflight L243–252), never overridden by the
    // component. Passing no colour is how [DsText.styleOf] spells that, and it
    // is load-bearing twice: `Field`'s `data-[invalid=true]:text-destructive-ink`
    // turns the typed text red through it (forms-map §3.2), and the state
    // grid's Read-only cell gets its muted ink the same way.
    final TextStyle textStyle = DsText.styleOf(context, spec);

    final Widget editable = EditableText(
      key: _editableKey,
      controller: _controller,
      focusNode: _focusNode,
      readOnly: widget.readOnly || !enabled,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      autofillHints: widget.autofillHints,
      style: textStyle,
      cursorColor: theme.foreground,
      // iOS's floating-cursor ghost. Never seen on the docs surface, but
      // [EditableText] requires it.
      backgroundCursorColor: theme.mutedForeground,
      selectionColor:
          theme.primary.withValues(alpha: DsFieldSurface.selectionAlpha),
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
    );

    final Widget placeholder = widget.placeholder == null
        ? const SizedBox.shrink()
        : DsText(
            widget.placeholder!,
            spec,
            color: theme.mutedForeground,
            maxLines: 1,
            overflow: TextOverflow.clip,
            softWrap: false,
          );

    final Widget line = Stack(
      alignment: AlignmentDirectional.centerStart,
      children: <Widget>[
        // `w-full`: the field fills whatever measure the caller allows.
        SizedBox(width: double.infinity, child: editable),
        if (_controller.text.isEmpty) IgnorePointer(child: placeholder),
      ],
    );

    final EdgeInsetsGeometry padding = widget.padding ?? DsInput.insets;

    Widget field;
    if (widget.bare) {
      // Everything the strip list removes is removed, which leaves no surface
      // to paint — so none is built.
      field = Padding(
        padding: padding,
        child: Align(alignment: AlignmentDirectional.centerStart, child: line),
      );
    } else {
      field = _Socket(
        focused: _focused,
        invalid: invalid,
        padding: padding,
        fill: widget.fill,
        flat: widget.flat,
        radius: widget.radius,
        child: line,
      );
      field = SizedBox(height: widget.boxHeight ?? DsInput.height, child: field);
    }

    // [EditableText] does not handle its own pointer gestures — `TextField`
    // wraps it in a selection gesture detector, and this port has no Material
    // dependency — so the tap that focuses the field is wired here. Focus
    // lands the caret at the end of the value, which is what a click on an
    // empty pill should do.
    field = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _editableKey.currentState?.requestKeyboard(),
      child: MouseRegion(
        cursor: enabled ? SystemMouseCursors.text : MouseCursor.defer,
        child: field,
      ),
    );

    field = Opacity(
      opacity: enabled ? 1 : _disabledOpacity,
      child: IgnorePointer(ignoring: !enabled, child: field),
    );

    if (label != null || hint != null || invalid) {
      field = Semantics(
        textField: true,
        label: label,
        hint: hint,
        readOnly: widget.readOnly,
        enabled: enabled,
        // `aria-invalid`. `.valid` is deliberately never used: the web emits
        // `aria-invalid="false"` on a valid field, which announces nothing, and
        // `.valid` would announce a state the reference does not
        // (forms-map §3.5).
        validationResult: invalid
            ? SemanticsValidationResult.invalid
            : SemanticsValidationResult.none,
        child: field,
      );
    }

    // USER-ORDERED MOBILE ADAPTATION — see [DsFieldVisibility]. Outermost, so
    // what gets revealed is the whole control including its socket, and free on
    // every desktop frame.
    return DsFieldVisibility(focusNode: _focusNode, child: field);
  }
}

/// The pill, its permanent socket, and the one ring that ever joins it.
///
/// Split out of [DsInput] so `DsTextarea` can wear the identical recipe at a
/// different radius and height without either restating it — the reference
/// keeps the two class lists in lockstep too, and §12.3's "identical except"
/// table is exactly this widget's parameter list.
class DsFieldSurface extends StatelessWidget {
  const DsFieldSurface({
    super.key,
    required this.radius,
    required this.focused,
    required this.invalid,
    required this.child,
    this.fill,
    this.flat = false,
  });

  /// The selection wash — `::selection` at `globals.css:1007–1010`, the
  /// app-level rule that reaches every field in this family because none of
  /// them overrides it.
  ///
  /// Was 0.30 on `DsInput` while the stylesheet and the example app's own
  /// `DefaultSelectionStyle` both said 0.35; one field in the system selected
  /// differently from every other. Ruling I10, fixed here so the textarea
  /// cannot drift from the input again.
  ///
  /// `::selection` also sets `color: var(--foreground)`. Flutter cannot
  /// recolour selected glyphs — [EditableText] paints one wash behind unchanged
  /// text — so that half has no counterpart and is recorded, not approximated.
  static const double selectionAlpha = 0.35;

  final BorderRadius radius;

  /// `:focus-visible` on the control itself.
  final bool focused;

  /// `aria-invalid` — beats [focused] on both properties they share.
  final bool invalid;

  /// Overrides `bg-card` — see [DsInput.fill].
  final Color? fill;

  /// `shadow-none`: the socket goes, the ring stays — see [DsInput.flat].
  final bool flat;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    // `aria-invalid:` is emitted after `focus-visible:` at equal specificity,
    // so it wins outright: an errored field shows no focus ring at all, only
    // its own (forms-map §3.3, ruling F5).
    final Color border = invalid
        ? theme.destructive
        : focused
            ? theme.primary.withValues(alpha: _focusBorderAlpha)
            : theme.input;
    final Color ring = invalid
        ? theme.destructive.withValues(alpha: _invalidRingAlpha)
        : focused
            ? theme.ring.withValues(alpha: _focusRingAlpha)
            // Not `dsTransparent`: a ring fading out through black would tint
            // the pixels it is leaving. Its own hue at zero alpha fades to
            // nothing, which is what an alpha transition does in CSS.
            : theme.ring.withValues(alpha: 0);

    // `transition-[box-shadow,border-color,background-color]` at the
    // framework default on `--ease-out` — the `duration-base` class beside
    // it emits nothing. The border tint and the ring change together and
    // only together, so they ride one duration.
    final Duration duration =
        dsAnimationDuration(context, DsDurations.transitionDefault);

    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: border),
      duration: duration,
      curve: DsCurves.out,
      builder: (BuildContext context, Color? b, Widget? _) =>
          TweenAnimationBuilder<Color?>(
        tween: ColorTween(end: ring),
        duration: duration,
        curve: DsCurves.out,
        builder: (BuildContext context, Color? r, Widget? _) {
          // The ring is ADDED to `shadow-pressed`, never replacing it — the
          // socket is what makes the field read as editable and it never rises.
          final Color ringColor = r ?? ring;
          final DsShadowSpec base = flat ? DsShadows.none : DsShadows.pressed;
          final DsShadowSpec spec = ringColor.a == 0
              ? base
              : DsButton.withFocusRing(base, ringColor);

          return DsMachineSurface(
            spec: spec,
            radius: radius,
            fill: fill ?? theme.card,
            border: Border.all(color: b ?? border, width: DsWidths.hairline),
            child: child,
          );
        },
      ),
    );
  }
}

/* ── USER-ORDERED MOBILE ADAPTATION: a focused field is never behind the
      software keyboard ──────────────────────────────────────────────────── */

/// Keeps the focused field visible above the software keyboard.
///
/// **USER-ORDERED MOBILE ADAPTATION.** This translates nothing: the reference
/// never needed it, because the *browser* does it. A phone browser shrinks the
/// visual viewport when the on-screen keyboard opens and scrolls the focused
/// `<input>` back into it, and no rule in `globals.css` asks for that — it is
/// UA behaviour the web design system inherits for free. A Flutter widget layer
/// with no `Scaffold` beneath it inherits nothing, so on a phone the console's
/// composer was typed into from behind the keyboard.
///
/// **One place, so the class of bug cannot come back.** Every field in the
/// family — [DsInput], `DsTextarea`, `DsInputOtp`, the agent composer — wraps
/// itself in one of these and passes the focus node it actually resolved. A
/// control added later inherits the behaviour by using the same plumbing rather
/// than by remembering a rule; the mechanism is not restated anywhere.
///
/// **Desktop is byte-identical.** Every path is gated on
/// `MediaQuery.viewInsets.bottom > 0`, which is the one honest signal that a
/// software keyboard is on screen. With none, this widget builds its child and
/// does nothing else: it owns no render object, adds no padding, changes no
/// constraint, and never touches a scroll position. It is not a layout widget.
///
/// **Two triggers, because focus and the keyboard are not the same moment.** On
/// a real device the tap focuses the field and the keyboard animates in
/// *afterwards*, so the reveal that matters is the inset change, not the focus
/// gain. Focusing a second field while the keyboard is already up is the other
/// order, and both are handled.
///
/// **It composes with whoever else made room.** The reveal asks how much of the
/// enclosing viewport the keyboard is actually standing on, so a scroller an
/// ancestor has already lifted clear of the keyboard — [DsAgentConsole]'s own
/// composer lift, a sheet that resized — contributes zero occlusion and the
/// field is merely brought inside the viewport with a margin. Nothing
/// double-counts.
class DsFieldVisibility extends StatefulWidget {
  const DsFieldVisibility({
    super.key,
    required this.focusNode,
    required this.child,
  });

  /// The node whose focus decides when to reveal.
  ///
  /// A field that resolves its node from three places — its own prop, the
  /// [DsFieldScope]'s, the one it owns — passes whichever won, so the reveal
  /// follows the same node the caret does.
  final FocusNode focusNode;

  final Widget child;

  /// The clearance left between the field and the edge it is pushed off — the
  /// `gap-2` rung, the smallest gap in the system that reads as deliberate
  /// rather than as a rounding error.
  static double get margin => ds(2);

  /// How long the reveal takes.
  ///
  /// [DsDurations.fast] rather than the transition default: the OS keyboard is
  /// already sliding up over it, and a field that arrives first reads as having
  /// been in the clear all along.
  static Duration get travel => DsDurations.fast;

  @override
  State<DsFieldVisibility> createState() => _DsFieldVisibilityState();
}

class _DsFieldVisibilityState extends State<DsFieldVisibility> {
  /// `MediaQuery.viewInsets.bottom` — how much of the window the keyboard has
  /// taken.
  ///
  /// Cached from [didChangeDependencies] rather than read where it is used: the
  /// reveal runs from a focus listener and a post-frame callback, and neither is
  /// a place to be registering an inherited-widget dependency.
  double _keyboardInset = 0;

  /// `MediaQuery.size.height`, cached for the same reason. The keyboard's top
  /// edge is this minus [_keyboardInset], in the global coordinates
  /// `localToGlobal` speaks.
  double _windowHeight = 0;

  bool _focused = false;
  bool _scheduled = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChanged);
    _focused = widget.focusNode.hasFocus;
  }

  @override
  void didUpdateWidget(DsFieldVisibility old) {
    super.didUpdateWidget(old);
    if (identical(old.focusNode, widget.focusNode)) return;
    old.focusNode.removeListener(_onFocusChanged);
    widget.focusNode.addListener(_onFocusChanged);
    _focused = widget.focusNode.hasFocus;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _windowHeight = MediaQuery.maybeSizeOf(context)?.height ?? 0;
    final double next = MediaQuery.maybeViewInsetsOf(context)?.bottom ?? 0;
    final bool opened = next > _keyboardInset;
    _keyboardInset = next;
    // The keyboard arrives *after* the tap that focused the field, so on a real
    // device this — not the focus gain — is the trigger that does the work.
    if (opened && _focused) _schedule();
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChanged);
    super.dispose();
  }

  void _onFocusChanged() {
    final bool focused = widget.focusNode.hasFocus;
    if (focused == _focused) return;
    _focused = focused;
    // Focus alone is not the trigger. With no keyboard on screen there is
    // nothing for the field to be hidden behind, and a desktop field must not
    // move a pixel — which is the whole of the desktop guarantee.
    if (focused && _keyboardInset > 0) _schedule();
  }

  /// Runs the reveal after the frame that provoked it, so it measures the
  /// layout the user is about to see rather than the one being replaced.
  void _schedule() {
    if (_scheduled) return;
    _scheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((Duration _) {
      _scheduled = false;
      _reveal();
    });
  }

  void _reveal() {
    if (!mounted || _keyboardInset <= 0) return;
    final RenderObject? box = context.findRenderObject();
    if (box == null || !box.attached) return;

    // Every scroller between the field and the root, innermost first — the walk
    // `Scrollable.ensureVisible` makes, and for its reason: a field inside a
    // scrolling card inside a scrolling page needs both of them to move.
    RenderObject target = box;
    BuildContext host = context;
    ScrollableState? scrollable = Scrollable.maybeOf(host);
    while (scrollable != null) {
      _revealIn(scrollable, target);
      host = scrollable.context;
      final RenderObject? outer = host.findRenderObject();
      if (outer == null) return;
      target = outer;
      scrollable = Scrollable.maybeOf(host);
    }
  }

  /// Scrolls one viewport just far enough that [target] clears both its own
  /// edges and the keyboard, and not one pixel further.
  void _revealIn(ScrollableState scrollable, RenderObject target) {
    final ScrollPosition position = scrollable.position;
    // A horizontal scroller cannot move anything out from under a keyboard that
    // occupies the bottom of the window, and a position with no dimensions yet
    // has nothing to say.
    if (position.axis != Axis.vertical || !position.hasPixels) return;
    if (!position.hasContentDimensions) return;

    final RenderAbstractViewport? viewport =
        RenderAbstractViewport.maybeOf(target);
    if (viewport == null) return;

    final double margin = DsFieldVisibility.margin;
    final Rect bounds = target.paintBounds;
    // The rect is the field's own box grown by the margin, and grown again at
    // the bottom by however much of THIS viewport the keyboard covers. Revealing
    // the grown rect at the viewport's trailing edge therefore lands the real
    // field a margin above the keyboard's top edge.
    final Rect rect = Rect.fromLTRB(
      bounds.left,
      bounds.top - margin,
      bounds.right,
      bounds.bottom + margin + _occlusionOf(viewport),
    );

    final double leading = viewport.getOffsetToReveal(target, 0, rect: rect).offset;
    final double trailing =
        viewport.getOffsetToReveal(target, 1, rect: rect).offset;
    final double pixels = position.pixels;

    final double wanted;
    if (pixels > leading) {
      // Off the top: scroll back down to it.
      wanted = leading;
    } else if (pixels < trailing) {
      // Under the keyboard, or off the bottom: scroll up.
      wanted = trailing;
    } else {
      // Already in the clear — and this is the branch that runs on every
      // already-visible field, which is why nothing moves when nothing must.
      return;
    }

    final double landing =
        wanted.clamp(position.minScrollExtent, position.maxScrollExtent);
    if (landing == pixels) return;

    final Duration travel =
        dsAnimationDuration(context, DsFieldVisibility.travel);
    // `prefers-reduced-motion` collapses the beat to nothing, and a driven
    // scroll activity refuses a zero duration — so at zero it is a jump, which
    // is what "no animation" means for a scroll offset.
    if (travel == Duration.zero) {
      position.jumpTo(landing);
      return;
    }
    position.animateTo(landing, duration: travel, curve: DsCurves.out);
  }

  /// How much of [viewport]'s own box the keyboard is standing on.
  ///
  /// Zero once something above has already made the room — which is what lets
  /// the console's composer lift and this reveal run at the same time without
  /// paying for the keyboard twice.
  ///
  /// Typed [RenderObject] rather than [RenderAbstractViewport] so the `is
  /// RenderBox` test can promote: `RenderBox` is not a subtype of the viewport
  /// interface, and Dart only promotes downwards.
  double _occlusionOf(RenderObject viewport) {
    if (viewport is! RenderBox || !viewport.hasSize) return 0;
    final double keyboardTop = _windowHeight - _keyboardInset;
    final double viewportBottom =
        viewport.localToGlobal(Offset.zero).dy + viewport.size.height;
    final double overlap = viewportBottom - keyboardTop;
    return overlap > 0 ? overlap : 0;
  }

  // No render object, no padding, no constraint: the child is returned exactly
  // as it arrived. Everything this widget does, it does to a scroll offset.
  @override
  Widget build(BuildContext context) => widget.child;
}

/// [DsFieldSurface] at the pill radius, with the field's own padding inside it.
class _Socket extends StatelessWidget {
  const _Socket({
    required this.focused,
    required this.invalid,
    required this.padding,
    required this.child,
    this.fill,
    this.flat = false,
    this.radius,
  });

  final bool focused;
  final bool invalid;
  final EdgeInsetsGeometry padding;
  final Color? fill;
  final bool flat;
  final Widget child;

  /// [DsInput.radius] — null keeps the pill.
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) {
    return DsFieldSurface(
      radius: radius ?? BorderRadius.circular(DsRadii.pill),
      focused: focused,
      invalid: invalid,
      fill: fill,
      flat: flat,
      child: Padding(
        // The surface has already inset this child by the border's width, the
        // way `box-sizing: border-box` does.
        padding: padding,
        child: Align(alignment: AlignmentDirectional.centerStart, child: child),
      ),
    );
  }
}
