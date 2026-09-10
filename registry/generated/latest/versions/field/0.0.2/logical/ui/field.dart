/// `components/ui/field.tsx` — label, control, description, error, and the
/// wiring that makes a screen reader read them as one thing.
///
/// The geometry is four gaps and three line-heights (`forms-map.md` §3.2,
/// measured):
///
/// | part | resolved |
/// |---|---|
/// | `FieldGroup` | column, **20px** between fields, full width (16px when nested) |
/// | `Field` | column, **8px**, and `width: 100%` forced on every direct child |
/// | `FieldLabel` | 13 / **1.375** / 500, `width: fit-content`, `user-select: none` |
/// | `FieldDescription` | 13 / **1.5** / 400 / `--muted-foreground` |
/// | `FieldError` | 13 / **1.428571** / 400 / `--destructive-ink`, `role="alert"` |
///
/// **Three different line-heights on three consecutive lines.** The family
/// types itself out of Tailwind's `text-sm` rung with `leading-*` overrides and
/// never touches a `.type-*` class, which is why [TextStyles.small],
/// [TextStyles.small] and [TextStyles.small] are three different specs here
/// rather than one.
///
/// ## The wiring contract
///
/// The web builds an id graph — `useId()` per field instance, then
/// `htmlFor`/`id`, `aria-describedby` and `aria-invalid` pointing into it
/// (`form.tsx:101–114`). Flutter has no id graph and no way to grow one. The
/// translation (inputs-map §7.2, forms-map §3.5) collapses it into **one merged
/// semantics node per field**:
///
/// | web | here |
/// |---|---|
/// | `<label for=id>` | the label string is fed to the control as its accessible name, and the visible label is excluded from semantics so it is not announced twice |
/// | `aria-describedby` → description | folded into `Semantics(hint:)` |
/// | `aria-describedby` → description **+** message | concatenated, description first — the DOM order the id list encodes |
/// | `aria-invalid` | `Semantics(validationResult: SemanticsValidationResult.invalid)` |
/// | `role="alert"` on `FieldError` | `Semantics(liveRegion: true)`, on the error subtree only |
/// | `role="group"` on `Field` | the field's own container node |
///
/// The threading itself is [FieldScope]. A Radix `Slot` merges props onto
/// whatever child it is given; the Flutter analogue of that is context, so a
/// control reads what the field knows instead of the field reaching into the
/// control. Order of precedence is the Slot's own: **the child's own props
/// win** (`form.tsx` merge order, forms-map §3.1).
///
/// DOCUMENTED DRIFT (inputs-map drift 11): `fieldVariants` carries
/// `data-[invalid=true]:text-destructive-ink` for the whole group, and the
/// **inputs** page never sets `data-invalid` on any `Field` — it puts
/// `aria-invalid` on the control instead, so no label there ever turns red
/// despite the API row claiming Field *"handles the invalid colouring for the
/// whole group"*. The **forms** page does set it (`data-invalid={fieldState
/// .invalid}`), and there it fires. Both behaviours fall out of one switch:
/// [Field.invalid] colours the subtree, and a page that marks only its
/// control leaves the field valid.
library;

import 'package:flutter/semantics.dart';
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

import '../../design_system/foundation/spacing.dart';
import '../../design_system/foundation/surfaces.dart';
import '../../design_system/foundation/theme.dart';
import '../../design_system/foundation/typography.dart';
import '../../design_system/foundation/text_layout.dart';
import '../../design_system/foundation/theme_scope.dart';
import './validation_rule.dart';

/// What activating a field **does** — a one-slot holder a control fills in.
///
/// `<label for=id>` does not focus the control it points at, it **activates**
/// it: clicking the word "I accept the terms" ticks the checkbox. Flutter has
/// no id graph to forward a click along, and a label cannot know what
/// activating an arbitrary control means, so the control says so.
///
/// Mutable on purpose, and deliberately not part of [FieldScope]'s equality:
/// a control registers during its own `build`, which is after the scope above
/// it was built. A `ValueNotifier` would be the same holder plus a notification
/// nobody listens for — the label reads the callback at tap time, not at build
/// time, so there is nothing to rebuild.
///
/// ```dart
/// // In a control's build, once it knows what it would do:
/// FieldScope.maybeOf(context)?.activator?.callback = _toggle;
/// ```
///
/// A control that leaves it null is not broken: a text field's activation *is*
/// focus, and [FieldLabel] falls back to the scope's focus node.
class FieldActivator {
  /// What a tap on the label should do. Null until a control registers.
  VoidCallback? callback;
}

/// What a `Field` threads down to the control inside it.
///
/// Everything the id graph would have carried, in the one direction Flutter can
/// carry it. A control opts in by reading it; nothing is forced on a child that
/// does not.
class FieldScope extends InheritedWidget {
  const FieldScope({
    super.key,
    this.label,
    this.describedBy,
    this.invalid = false,
    this.enabled = true,
    this.focusNode,
    this.activator,
    required super.child,
  });

  /// The visible label's text, to be announced as the control's name — the
  /// `<label for=…>` translation.
  final String? label;

  /// Description, then error message, in DOM order. What `aria-describedby`
  /// resolves to, as one string.
  final String? describedBy;

  /// `aria-invalid` on the control.
  final bool invalid;

  /// A disabled field disables its control; a control cannot opt back in.
  final bool enabled;

  /// The node the label focuses and a failed submit lands on.
  final FocusNode? focusNode;

  /// Where the control registers what activating this field does.
  ///
  /// A [Field] supplies one; a scope built by hand may leave it null, which
  /// is how a caller keeps [FieldLabel] from attaching any recogniser of its
  /// own and takes the tap with a handler of its own instead.
  final FieldActivator? activator;

  static FieldScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<FieldScope>();

  @override
  bool updateShouldNotify(FieldScope old) =>
      old.label != label ||
      old.describedBy != describedBy ||
      old.invalid != invalid ||
      old.enabled != enabled ||
      old.focusNode != focusNode ||
      !identical(old.activator, activator);
}

/// `fieldVariants`' `orientation`.
enum FieldOrientation {
  /// `flex-col *:w-full` — the default, and every field on both ported pages
  /// except the switch and the checkbox.
  vertical,

  /// `flex-row items-center`, with the label taking `flex: auto` so the control
  /// sits hard against the trailing edge.
  horizontal,
}

/// `FieldGroup` — `flex w-full flex-col gap-5`.
class FieldGroup extends StatelessWidget {
  const FieldGroup({super.key, required this.children, this.nested = false});

  final List<Widget> children;

  /// `*:data-[slot=field-group]:gap-4` — a group inside a group closes up from
  /// 20px to 16.
  final bool nested;

  /// `gap-5` — 20px between fields, the measure both pages' panels are built
  /// on.
  static double get gap => space(5);

  /// `gap-4` — 16px, the nested step.
  static double get nestedGap => space(4);

  @override
  Widget build(BuildContext context) {
    return _Stack(gap: nested ? nestedGap : gap, children: children);
  }
}

/// `FieldSet` — `flex flex-col gap-4`, closing to `gap-3` around a selection
/// group.
///
/// **A rendered `<legend>` is not a flex item** *(oracle-confirmed: the measured
/// gap between "Payout rhythm" and its radios is 6px, not 6 + the fieldset's
/// own 12)*. CSS lifts a `<legend>` out of the fieldset's anonymous flex content
/// box and renders it over the border, so the box's `gap` never applies to it
/// and only its own `mb-1.5` does. A leading [FieldLegend] child is therefore
/// special-cased to that 6px; every other gap in the set is the normal one.
class FieldSet extends StatelessWidget {
  const FieldSet({
    super.key,
    required this.children,
    this.tightForGroup = false,
  });

  final List<Widget> children;

  /// `has-[>[data-slot=radio-group]]:gap-3` /
  /// `has-[>[data-slot=checkbox-group]]:gap-3` — 16px drops to 12 when a radio
  /// or checkbox group is a **direct** child.
  ///
  /// A `has-` selector inspects the subtree; Flutter cannot, and type-sniffing
  /// the children would couple this file to components another owner builds.
  /// So the caller states it, which is also what the selector means.
  final bool tightForGroup;

  /// `gap-4` — 16px.
  static double get gap => space(4);

  /// `gap-3` — 12px, the selection-group step.
  static double get groupGap => space(3);

  @override
  Widget build(BuildContext context) {
    final double normal = tightForGroup ? groupGap : gap;
    // The one thing a `has-` selector could tell CSS that a parent can tell
    // itself: whether its own first child is the legend. A type check, for the
    // same reason `InputGroupAddon` sniffs for a button — the selector is
    // about a direct child's identity, which is exactly what this reads.
    final bool leadingLegend =
        children.isNotEmpty && children.first is FieldLegend;

    final List<Widget> rows = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      if (i > 0) {
        rows.add(
          SizedBox(
            height: i == 1 && leadingLegend ? FieldLegend.spaceBelow : normal,
          ),
        );
      }
      rows.add(children[i]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: rows,
    );
  }
}

/// `FieldLegend variant="label"` — `mb-1.5 font-medium text-sm`.
///
/// The page's one legend sits over a radio group, because `<label for>` may
/// only point at a labelable element and a RadioGroup container is a `div`, so
/// `FormLabel`'s `htmlFor` would announce nothing (`page.tsx:322–325`).
class FieldLegend extends StatelessWidget {
  const FieldLegend(this.text, {super.key});

  final String text;

  /// `mb-1.5` — 6px, **on top of** the enclosing `FieldSet`'s own flex gap. A
  /// margin and a gap both apply in CSS, so the legend clears its group by 22px
  /// and not by 16.
  static double get spaceBelow => space(1.5);

  @override
  Widget build(BuildContext context) {
    // 13 / 500 / 1.428571: `font-medium` at `text-sm`, with **no** `leading-*`
    // override, so it keeps the utility's own ratio rather than the label's
    // 1.375. Composed from the two specs that each carry half of it rather than
    // typing a third — the size and weight are [TextStyles.small]'s,
    // the leading is [TextStyles.small]'s.
    final TextStyle style = StyledText.styleOf(context, TextStyles.small);
    return Align(
      alignment: AlignmentDirectional.centerStart,
      // Shrink-wrap the height: these align horizontally, and a block element
      // in a flex column is its content's height and never its container's. In
      // a `Field`'s Column the constraint is unbounded and an [Align] already
      // wraps; anywhere the height is bounded it would otherwise swallow it.
      heightFactor: 1,
      // [LineBox] rather than a bare [Text], for the reason every rendered
      // string in this port carries one: the engine rounds a line's ascent and
      // descent to whole pixels before adding them, so a paragraph quantizes UP
      // to the next half pixel and the declared box is not what renders. This
      // is the one spec composed at a call site rather than named in the
      // foundation, so it reaches for `LineBox` directly where the others go
      // through `StyledText`.
      child: LineBox(
        style: style,
        child: Text(text, style: style),
      ),
    );
  }
}

/// One field: a label, the control it names, and what is said about it.
///
/// The four slots are passed as data rather than composed as children so the
/// field can publish [FieldScope] and place the description's conditional
/// gap. [FieldLabel], [FieldDescription] and [FieldError] stay public for
/// the compositions this shape does not cover.
class Field extends StatefulWidget {
  const Field({
    super.key,
    required this.child,
    this.label,
    this.description,
    this.errors = const <String>[],
    this.invalid,
    this.enabled = true,
    this.focusNode,
    this.orientation = FieldOrientation.vertical,
  });

  /// The control.
  final Widget child;

  /// `FieldLabel`'s text. Rendered visibly **and** announced as the control's
  /// accessible name — one string, one announcement.
  final String? label;

  /// `FieldDescription`'s text.
  final String? description;

  /// `FieldError`'s messages. Empty renders nothing at all: `FieldError`
  /// returns `null` when valid, and a zero-height live region that exists on
  /// every field is the anti-pattern the page's own Note names.
  final List<String> errors;

  /// `data-invalid` on the field. Defaults to "there are messages".
  ///
  /// Separable because the reference separates them: the inputs page marks the
  /// control and leaves the field valid, which is why no label turns red there.
  final bool? invalid;

  /// `data-[disabled=true]`.
  final bool enabled;

  /// The node the label focuses, and the one a failed submit lands on.
  final FocusNode? focusNode;

  final FieldOrientation orientation;

  /// `gap-2` — 8px between label, control and what follows.
  static double get gap => space(2);

  /// `nth-last-2:-mt-1` — the description tucks 4px closer to the control the
  /// moment an error appears below it *(measured: forms-map §3.2 records the
  /// rule emitted as `margin-top: calc(var(--spacing) * -1)`)*.
  ///
  /// `FieldError` renders `null` when valid, so the description's position in
  /// the child list — and therefore which of `last:mt-0` and `nth-last-2:-mt-1`
  /// matches — changes with validity. Nothing animates it; it is a relayout.
  static double get describedGap => gap - space(1);

  @override
  State<Field> createState() => _FieldState();
}

class _FieldState extends State<Field> {
  /// Stateful for exactly this: the holder has to outlive a rebuild, or the
  /// control would register into an object the label no longer reads.
  final FieldActivator _activator = FieldActivator();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final String? label = widget.label;
    final String? description = widget.description;
    final List<String> messages = Validators.dedupe(widget.errors);
    final bool isInvalid = widget.invalid ?? messages.isNotEmpty;
    final double gap = Field.gap;

    // `aria-describedby="{id}-description {id}-message"` — one id list, read in
    // DOM order, so one string in the same order.
    final String described = <String>[?description, ...messages].join(' ');

    final Widget control = FieldScope(
      label: label,
      describedBy: described.isEmpty ? null : described,
      invalid: isInvalid,
      enabled: widget.enabled,
      focusNode: widget.focusNode,
      activator: _activator,
      child: widget.child,
    );

    final Widget? labelWidget = label == null
        ? null
        // The activator is handed over rather than read from context: the scope
        // wraps the control alone, so the label is its sibling and cannot see
        // it. Same reason `focusNode` has always been passed here.
        : FieldLabel(
            label,
            focusNode: widget.focusNode,
            activator: _activator,
            enabled: widget.enabled,
          );

    final List<Widget> rows = <Widget>[];
    switch (widget.orientation) {
      case FieldOrientation.vertical:
        if (labelWidget != null) {
          rows
            ..add(labelWidget)
            ..add(SizedBox(height: gap));
        }
        rows.add(control);
      case FieldOrientation.horizontal:
        rows.add(
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // **Control first.** All three horizontal fields on the reference
              // put the control in the DOM before its label — a radio, a switch
              // and a checkbox each sit at the LEFT of their row — and
              // `*:data-[slot=field-label]:flex-auto` then grows the label into
              // the slack beside it. That growth is not decoration: it is what
              // makes the rest of the row a click target.
              //
              // `control`, never the bare `child`: the scope has to wrap the
              // control on BOTH branches. This is the branch the switch and the
              // checkbox live on, so a field that publishes nothing here is a
              // field whose focus-on-error and accessible name go missing on
              // exactly the controls that need them most.
              control,
              if (labelWidget != null) SizedBox(width: gap),
              if (labelWidget != null) Expanded(child: labelWidget),
            ],
          ),
        );
    }

    if (description != null) {
      rows
        ..add(SizedBox(height: messages.isEmpty ? gap : Field.describedGap))
        // Excluded because the string is already the control's `hint`, which
        // is where `aria-describedby` lands. Left in, it merges into this
        // field's one node as part of the control's NAME — "Email Receipts and
        // nothing else." — which is neither what the web announces nor what a
        // name is for. The standalone [FieldDescription] announces itself
        // normally; only the copy this field has already folded is silenced.
        ..add(ExcludeSemantics(child: FieldDescription(description)));
    }
    if (messages.isNotEmpty) {
      rows
        ..add(SizedBox(height: gap))
        ..add(FieldError(messages));
    }

    Widget field = Column(
      // `*:w-full` — every direct child stretches to the field's measure.
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: rows,
    );

    if (isInvalid) {
      // `data-[invalid=true]:text-destructive-ink` sets `color` on the whole
      // subtree. Who actually changes is decided by who declares a colour of
      // their own: the label and the control's typed text inherit and turn; the
      // description, the error and the placeholder all state theirs and do not
      // (forms-map §3.2).
      field = DefaultTextStyle.merge(
        style: TextStyle(color: theme.destructiveText),
        child: field,
      );
    }

    // `role="group"`, and the field's own `aria-invalid`.
    //
    // The control inside publishes a validation result too, from the same
    // scope, and a merge keeps the parent's — so stating it here costs nothing
    // and buys the case that matters: a control that does **not** read
    // [FieldScope] still ends up inside a node a screen reader hears as
    // invalid. An error nobody is told about is the one drift class this port
    // does not ship, and it must not depend on every control opting in.
    return Semantics(
      container: true,
      validationResult: isInvalid
          ? SemanticsValidationResult.invalid
          : SemanticsValidationResult.none,
      child: field,
    );
  }
}

/// `FieldLabel` → `Label` — 13 / 1.375 / 500, `width: fit-content`.
///
/// `w-fit` is not cosmetic: it narrows the click target to the words, so a
/// click 400px to the right of "Email" inside a 512px field does not focus the
/// input. Tapping the text does, which is the whole of what `htmlFor` buys and
/// the only part of it Flutter can reproduce.
/// ## What a tap does, in order
///
/// `<label for=id>` **activates** the control it points at — clicking the words
/// "I accept the terms" ticks the checkbox, it does not merely focus it. So the
/// tap resolves down a ladder, and the first rung that answers wins:
///
/// | rung | when | what happens |
/// |---|---|---|
/// | [onTap] | the caller states its own handler | it is called, and nothing else is |
/// | [FieldScope.activator] | a control registered a callback | the control is **activated** |
/// | [FieldScope.focusNode] | a node is offered, no activator | the control is focused |
/// | — | none of those | **no recogniser is attached at all** |
///
/// The last rung is not a fallthrough, it is a feature: a caller composing its
/// own row wraps the label in a handler of its own and hands it a scope with
/// neither activator nor node, and the label then contests nothing. An inner
/// recogniser would win the gesture arena over an ancestor's and leave the row
/// focusing where it should be toggling.
class FieldLabel extends StatelessWidget {
  const FieldLabel(
    this.text, {
    super.key,
    this.spec,
    this.focusNode,
    this.activator,
    this.enabled = true,
    this.onTap,
  });

  final String text;

  /// The type this label is typed in, defaulting to [medium].
  ///
  /// A hook rather than a `weight:` or a `bold:` flag, because what the class
  /// list does is substitute one resolved style for another: the selection
  /// page's filter rows pass `className="font-normal"`, which overrides only
  /// `Label`'s `font-medium` and leaves `text-sm leading-snug` standing
  /// (`selection/page.tsx:100`). [normal] is that exact substitution; anything
  /// else a call site needs is another spec.
  final TextStyleToken? spec;

  /// The default: the supporting-copy role at medium weight, so a label reads
  /// as the name of the control under it rather than as more copy beside it.
  static final TextStyleToken medium = TextStyles.small.derive(
    name: 'field-label',
    wght: 500,
  );

  /// The role itself, for a label that is one of many in a list — a filter
  /// row's checkbox labels, where medium on every line is noise.
  static final TextStyleToken normal = TextStyles.small;

  /// Focused on tap, when no activator is registered. Falls back to the
  /// enclosing [FieldScope]'s node.
  final FocusNode? focusNode;

  /// Where the control registered what activating this field does.
  ///
  /// Passed explicitly by [Field], because the label is a **sibling** of the
  /// scope rather than a descendant of it — the scope wraps the control alone,
  /// so that a control reads it and the label's own text does not. A standalone
  /// label inside a hand-built scope falls back to reading it from context,
  /// exactly as [focusNode] does.
  final FieldActivator? activator;

  final bool enabled;

  /// The caller's own tap handler, which outranks both rungs below it.
  ///
  /// Supplying it is how a call site says "activation here is mine" — for a
  /// control this component cannot know how to operate, or a row that wants one
  /// handler over both halves of itself.
  final VoidCallback? onTap;

  /// `group-data-[disabled=true]/field:opacity-50`.
  static const double disabledOpacity = SurfaceOpacity.disabled;

  @override
  Widget build(BuildContext context) {
    final FieldScope? scope = FieldScope.maybeOf(context);
    final FocusNode? node = focusNode ?? scope?.focusNode;
    final FieldActivator? holder = activator ?? scope?.activator;

    // Resolved at tap time, not at build time: a control registers during its
    // own build, which runs after this one, so reading `activator.callback`
    // here would always find it empty on the first frame.
    VoidCallback? action;
    if (onTap != null) {
      action = onTap;
    } else if (holder != null) {
      action = () {
        final VoidCallback? registered = holder.callback;
        if (registered != null) {
          registered();
        } else {
          // A text control registers nothing, because focus IS its activation.
          node?.requestFocus();
        }
      };
    } else if (node != null) {
      action = node.requestFocus;
    }

    // No colour: `Label` declares none, so it inherits — which is what lets
    // `Field`'s invalid colouring reach it.
    //
    // [StyledText] and not a bare [Text]: it wraps the paragraph in a [LineBox],
    // which holds the line to `font-size × line-height` instead of the engine's
    // rounded metrics. A bare `Text` renders this label 18.0 tall against a
    // declared 17.875 — an eighth of a pixel that a column of sixteen fields
    // turns into two.
    Widget label = StyledText(text, spec ?? FieldLabel.medium);

    if (action != null && enabled) {
      label = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: action,
        child: label,
      );
    }

    if (!enabled) {
      label = Opacity(opacity: disabledOpacity, child: label);
    }

    return Align(
      alignment: AlignmentDirectional.centerStart,
      // Shrink-wrap the height: these align horizontally, and a block element
      // in a flex column is its content's height and never its container's. In
      // a `Field`'s Column the constraint is unbounded and an [Align] already
      // wraps; anywhere the height is bounded it would otherwise swallow it.
      heightFactor: 1,
      // The string is already the control's accessible name. Announcing it here
      // too would read the field's label twice, which is exactly what a correct
      // `<label for>` does *not* do.
      child: ExcludeSemantics(child: label),
    );
  }
}

/// `FieldDescription` — the supporting-copy role in muted ink.
///
/// The ink is stated here rather than inherited: a description stays secondary
/// even when the field around it turns invalid and tints its label and value.
class FieldDescription extends StatelessWidget {
  const FieldDescription(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => StyledText(
    text,
    TextStyles.small,
    color: ThemeScope.of(context).mutedForeground,
    align: TextAlign.start,
  );
}

/// `FieldError` — 13 / 1.428571 / 400 / `--destructive-ink`, `role="alert"`.
///
/// One message renders as a bare string; two or more render as a bulleted list
/// (`ul.ml-4.list-disc.gap-1`). The list branch fires in exactly one place in
/// the corpus — the password form under `criteriaMode: "all"` — and it is the
/// entire reason §3 of the forms page exists.
class FieldError extends StatelessWidget {
  const FieldError(this.messages, {super.key});

  final List<String> messages;

  /// `ml-4` — 16px. With Preflight zeroing the list's padding, this margin is
  /// where the disc markers hang: the item text starts at 16px and the marker
  /// paints to the left of it, inside the indent.
  static double get listIndent => space(4);

  /// `gap-1` — 4px between items.
  static double get itemGap => space(1);

  @override
  Widget build(BuildContext context) {
    final List<String> unique = Validators.dedupe(messages);
    // `FieldError` returns `null` when there is nothing to say. Not a
    // zero-height box carrying a live region — an empty live region on every
    // field is the anti-pattern the page's own Note names and `donts[1]`
    // forbids.
    if (unique.isEmpty) return const SizedBox.shrink();

    final ThemeTokens theme = ThemeScope.of(context);

    // [StyledText], never a bare [Text]: every string goes through a [LineBox] so
    // the paragraph measures `font-size × line-height` rather than the engine's
    // rounded ascent-plus-descent. Bare, this renders 19.0 against a declared
    // 18.5714 — and in the list branch **every item** quantizes, so a
    // four-message password error drifts by nearly two pixels on its own.
    StyledText ink(String message) =>
        StyledText(message, TextStyles.small, color: theme.destructiveText);

    final Widget content = unique.length == 1
        ? ink(unique.single)
        : _Stack(
            gap: itemGap,
            children: <Widget>[
              for (final String message in unique)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: listIndent,
                      child: Align(
                        alignment: AlignmentDirectional.topEnd,
                        // `list-style-type: disc`. A bullet glyph is the
                        // closest Flutter has to a CSS marker box, which is
                        // generated content no widget tree contains. It is
                        // line-boxed like the text beside it, or the row would
                        // take the marker's rounding instead.
                        child: ink('•'),
                      ),
                    ),
                    Expanded(child: ink(message)),
                  ],
                ),
            ],
          );

    // `role="alert"` — announced when it appears, which is the whole contract.
    return Semantics(
      container: true,
      liveRegion: true,
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        // As above: the error is a block whose height is its messages, not
        // whatever room it is offered.
        heightFactor: 1,
        child: content,
      ),
    );
  }
}

/// A column with one gap between every pair of children, and none at the ends.
///
/// `Column(spacing:)` would do it in one line, but a `SizedBox` per gap is what
/// the rest of this port uses and what its geometry tests read.
class _Stack extends StatelessWidget {
  const _Stack({required this.gap, required this.children});

  final double gap;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final List<Widget> rows = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      if (i > 0) rows.add(SizedBox(height: gap));
      rows.add(children[i]);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: rows,
    );
  }
}
