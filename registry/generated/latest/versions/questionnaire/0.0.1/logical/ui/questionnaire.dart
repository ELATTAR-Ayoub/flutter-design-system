/// `components/ui/questionnaire.tsx` over `@shadcn/react/questionnaire` — a
/// structured question, answered inline.
///
/// **It is a wizard.** One item is on screen at a time; the rest are
/// `display:none`. That is not a styling detail — it is what `Progress`,
/// `Previous`, `Skip`, `Next` and `Submit` all exist to move, and a port that
/// stacked the items would have nothing for four of its five controls to do.
///
/// The primitive's own rules, taken from its compiled source rather than from
/// the wrapper's class list:
///
///  * `Previous` is visible when `total > 1 && !first`.
///  * `Skip` is visible when the active item is **not** required.
///  * `Next` is visible when `total > 1 && !last`; `Submit` when `last`.
///  * `Next`/`Submit` **validate first**: a required item with no answer sets
///    `invalid` on the item and stays put.
///  * `Error` with no children renders the primitive's own default —
///    **`Choose an answer to continue.`** when the item is required, and
///    `Choose an answer or skip this question.` when it is not. The transcript
///    page mounts a bare `<QuestionnaireError />` under a required item, so
///    that first string is on screen and is reproduced here.
///  * The keyboard handler is `onKeyDown` on the **root form**, not on the
///    document — so the shortcut only fires while focus is inside this
///    questionnaire, which is what lets five specimens share one page.
///
/// ## Measured anatomy (dark, 1440×900)
///
///  * Root `flex flex-col gap-4`; progress `min-h-4 w-fit min-w-[14ch]` at
///    108×16, reading `Question 1 of 3`.
///  * Item is a `<fieldset>` and Title is its `<legend>` — **which is not a
///    flex item**. It sits above the content box and contributes only its own
///    `mb-4`, and only when no `Description` follows it. Measured: item 1 is
///    20.63 + 16 + 148 = 184.63, item 2 is 20.63 + 18.6 + 16 + 32 = 87.2 with
///    no gap at all between title and description.
///  * Choice row 44 tall: `min-h-11 rounded-lg border border-input px-3 py-2.5
///    gap-2.5 items-start`, indicator 20×20 on `translate-y-0.5`, shortcut
///    `Kbd` 20×20.
///  * Error carries `mt-2` **on top of** the 16px column gap — 24 above it.
///  * Actions `grid min-h-11 grid-cols-[minmax(0,1fr)_auto_auto] gap-2
///    sm:min-h-8`, measured 40 tall because the buttons are the default rung.
///    The gaps are paid even for a collapsed track: with only `Next` showing,
///    it still starts 16px short of where a two-track row would put it.
library;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../foundation/colors.dart';
import '../foundation/motion.dart';
import '../foundation/shadows.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../motion/keyframes.dart';
import '../theme_scope.dart';
import 'button.dart';
import 'input.dart';
import 'kbd.dart';

/* ── Vocabulary ──────────────────────────────────────────────────────────── */

/// `shortcuts` on the root — which key set the choices advertise.
enum ElQuestionnaireShortcuts {
  /// No binding, and no badge.
  none,

  /// `A`, `B`, `C`, …
  letters,

  /// `1`, `2`, `3`, …
  numbers;

  /// The key a choice at [index] answers to, or null when nothing is bound.
  String? keyFor(int index) => switch (this) {
    ElQuestionnaireShortcuts.none => null,
    ElQuestionnaireShortcuts.letters =>
      index < 26 ? String.fromCharCode('A'.codeUnitAt(0) + index) : null,
    ElQuestionnaireShortcuts.numbers => index < 9 ? '${index + 1}' : null,
  };
}

/// What one item is registered as, read off the child list before any of it
/// renders — the progress bar is the first child and has to know the count.
@immutable
class _ItemMeta {
  const _ItemMeta(this.name, {required this.required, required this.invalid});

  final String name;
  final bool required;

  /// The item's own `invalid` prop, which forces the state without validating.
  final bool invalid;
}

/// The wizard's mutable half.
class ElQuestionnaireController extends ChangeNotifier {
  int _index = 0;

  /// Which item is on screen, 0-based.
  int get index => _index;

  final Map<String, String> _values = <String, String>{};
  final Set<String> _skipped = <String>{};
  final Set<String> _invalid = <String>{};
  final Map<String, TextEditingController> _text =
      <String, TextEditingController>{};

  String? valueOf(String name) => _values[name];
  bool isSkipped(String name) => _skipped.contains(name);
  bool isInvalid(String name) => _invalid.contains(name);

  /// The field controller for a text item, created on first ask.
  TextEditingController textFor(String name) =>
      _text.putIfAbsent(name, TextEditingController.new);

  void setValue(String name, String value) {
    _values[name] = value;
    _skipped.remove(name);
    _invalid.remove(name);
    notifyListeners();
  }

  void skip(String name) {
    _skipped.add(name);
    _invalid.remove(name);
    notifyListeners();
  }

  void goTo(int index) {
    if (index == _index) return;
    _index = index;
    notifyListeners();
  }

  /// True when the item has something the transport can send.
  bool _answered(String name) {
    final String? value = _values[name] ?? _text[name]?.text;
    return value != null && value.trim().isNotEmpty;
  }

  /// The primitive's `validate()` — sets `invalid` and reports it.
  bool validate(String name, {required bool required}) {
    if (!required || _answered(name) || _skipped.contains(name)) {
      _invalid.remove(name);
      notifyListeners();
      return true;
    }
    _invalid.add(name);
    notifyListeners();
    return false;
  }

  @override
  void dispose() {
    for (final TextEditingController c in _text.values) {
      c.dispose();
    }
    super.dispose();
  }
}

class _QScope extends InheritedWidget {
  const _QScope({
    required this.controller,
    required this.items,
    required this.shortcuts,
    required this.revision,
    required this.onNext,
    required this.onPrevious,
    required this.onSkip,
    required this.onSubmit,
    required super.child,
  });

  final ElQuestionnaireController controller;
  final List<_ItemMeta> items;
  final ElQuestionnaireShortcuts shortcuts;

  /// Bumped on every controller notification, so a descendant that only reads
  /// state still rebuilds.
  final int revision;

  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onSkip;
  final VoidCallback onSubmit;

  static _QScope of(BuildContext context) {
    final _QScope? scope = context
        .dependOnInheritedWidgetOfExactType<_QScope>();
    assert(scope != null, 'This part must sit inside a ElQuestionnaire.');
    return scope!;
  }

  _ItemMeta? get active =>
      controller.index < items.length ? items[controller.index] : null;

  bool get first => controller.index == 0;
  bool get last => controller.index >= items.length - 1;
  int get total => items.length;

  @override
  bool updateShouldNotify(_QScope old) =>
      old.revision != revision ||
      old.items.length != items.length ||
      old.shortcuts != shortcuts;
}

/* ── Root ────────────────────────────────────────────────────────────────── */

/// `<Questionnaire>` — `flex w-full min-w-0 flex-col gap-4`, on a `<form>`.
class ElQuestionnaire extends StatefulWidget {
  const ElQuestionnaire({
    super.key,
    required this.children,
    this.shortcuts = ElQuestionnaireShortcuts.none,
    this.onSubmit,
    this.gap,
    this.controller,
    this.focusNode,
  });

  /// `gap-4`.
  static double get defaultGap => el(4);

  final List<Widget> children;
  final ElQuestionnaireShortcuts shortcuts;

  /// Fires once every item validates and `Submit` is pressed. The reference's
  /// specimens all `preventDefault()` here; a real integration posts.
  final VoidCallback? onSubmit;

  /// Overrides `gap-4` — the state-grid cells pass `gap-3`.
  final double? gap;

  final ElQuestionnaireController? controller;
  final FocusNode? focusNode;

  @override
  State<ElQuestionnaire> createState() => _ElQuestionnaireState();
}

class _ElQuestionnaireState extends State<ElQuestionnaire> {
  late ElQuestionnaireController _controller =
      widget.controller ?? ElQuestionnaireController();
  late final FocusNode _node =
      widget.focusNode ?? FocusNode(debugLabel: 'ElQuestionnaire');
  int _revision = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_bump);
  }

  @override
  void didUpdateWidget(ElQuestionnaire old) {
    super.didUpdateWidget(old);
    if (widget.controller != null && widget.controller != _controller) {
      _controller.removeListener(_bump);
      _controller = widget.controller!;
      _controller.addListener(_bump);
    }
  }

  void _bump() {
    if (mounted) setState(() => _revision += 1);
  }

  @override
  void dispose() {
    _controller.removeListener(_bump);
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _node.dispose();
    super.dispose();
  }

  List<_ItemMeta> get _items => <_ItemMeta>[
    for (final Widget child in widget.children)
      if (child is ElQuestionnaireItem)
        _ItemMeta(child.name, required: child.required, invalid: child.invalid),
  ];

  void _goPrevious() {
    if (_controller.index <= 0) return;
    _controller.goTo(_controller.index - 1);
  }

  void _goNext() {
    final List<_ItemMeta> items = _items;
    if (_controller.index >= items.length - 1) return;
    final _ItemMeta step = items[_controller.index];
    if (!_controller.validate(step.name, required: step.required)) return;
    _controller.goTo(_controller.index + 1);
  }

  /// `Submit`'s own handler: validate, then either advance or post.
  void _submit() {
    final List<_ItemMeta> items = _items;
    if (items.isEmpty) return;
    final _ItemMeta step = items[_controller.index];
    if (!_controller.validate(step.name, required: step.required)) return;
    if (_controller.index >= items.length - 1) {
      widget.onSubmit?.call();
      return;
    }
    _controller.goTo(_controller.index + 1);
  }

  void _skip() {
    final List<_ItemMeta> items = _items;
    if (items.isEmpty) return;
    final _ItemMeta item = items[_controller.index];
    if (item.required) return;
    _controller.skip(item.name);
    if (_controller.index >= items.length - 1) {
      widget.onSubmit?.call();
      return;
    }
    _controller.goTo(_controller.index + 1);
  }

  /// The root's `onKeyDown`. Scoped to the form, exactly as the primitive is.
  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final List<_ItemMeta> items = _items;
    if (items.isEmpty) return KeyEventResult.ignored;

    if (event.logicalKey == LogicalKeyboardKey.enter) {
      _submit();
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      _goPrevious();
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      _goNext();
      return KeyEventResult.handled;
    }

    final String? typed = event.character?.toUpperCase();
    if (typed == null || typed.isEmpty) return KeyEventResult.ignored;
    final String name = items[_controller.index].name;
    final List<String>? choices = _choiceValues[name];
    if (choices == null) return KeyEventResult.ignored;
    for (int i = 0; i < choices.length; i += 1) {
      if (widget.shortcuts.keyFor(i) == typed) {
        _controller.setValue(name, choices[i]);
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  /// Which values the current item's choices carry, registered by
  /// [ElQuestionnaireChoices] as it builds.
  final Map<String, List<String>> _choiceValues = <String, List<String>>{};

  void _registerChoices(String item, List<String> values) {
    _choiceValues[item] = values;
  }

  @override
  Widget build(BuildContext context) {
    final double gap = widget.gap ?? ElQuestionnaire.defaultGap;
    // A CSS flex `gap` is not paid around a `display: none` item, and every
    // item but the active one is exactly that. Measured: the demo's form is
    // 272.63 with two gaps, not 336.63 with four.
    final List<Widget> visible = <Widget>[];
    int seen = 0;
    for (final Widget child in widget.children) {
      if (child is ElQuestionnaireItem) {
        final int index = seen;
        seen += 1;
        if (index != _controller.index) continue;
      }
      visible.add(child);
    }
    final List<Widget> laid = <Widget>[];
    for (int i = 0; i < visible.length; i += 1) {
      laid.add(visible[i]);
      if (i != visible.length - 1) laid.add(SizedBox(height: gap));
    }

    return _ChoiceRegistrar(
      register: _registerChoices,
      child: _QScope(
        controller: _controller,
        items: _items,
        shortcuts: widget.shortcuts,
        revision: _revision,
        onNext: _goNext,
        onPrevious: _goPrevious,
        onSkip: _skip,
        onSubmit: _submit,
        child: Focus(
          focusNode: _node,
          skipTraversal: true,
          onKeyEvent: _onKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: laid,
          ),
        ),
      ),
    );
  }
}

/// Carries the registration callback down without widening [_QScope]'s
/// equality — the map is mutated during build and must not itself be a
/// rebuild trigger.
class _ChoiceRegistrar extends InheritedWidget {
  const _ChoiceRegistrar({required this.register, required super.child});

  final void Function(String item, List<String> values) register;

  static _ChoiceRegistrar? maybeOf(BuildContext context) =>
      context.getInheritedWidgetOfExactType<_ChoiceRegistrar>();

  @override
  bool updateShouldNotify(_ChoiceRegistrar old) => false;
}

/* ── Progress ────────────────────────────────────────────────────────────── */

/// `<QuestionnaireProgress>` — `Question X of Y`, in a row it reserves before
/// the text arrives.
class ElQuestionnaireProgress extends StatelessWidget {
  const ElQuestionnaireProgress({super.key});

  /// `min-h-4` — 16px, the measured line height of `text-xs` here, so the
  /// label reserves its row before the text streams in.
  static double get minHeight => el(4);

  /// `min-w-[14ch]`, measured 108px against Inter's tabular digits.
  static double get minWidthChars => 14;

  /// `text-xs font-medium tabular-nums`.
  static final ElTypeSpec type = ElTypeSpec(
    family: ElFonts.sans,
    size: ElComponentType.messageMeta.size,
    height: ElComponentType.messageMeta.height,
    wght: 500,
    tabular: true,
  );

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final _QScope scope = _QScope.of(context);
    final int total = scope.total;
    final String label = total > 0
        ? 'Question ${scope.controller.index + 1} of $total'
        : '';

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: minHeight),
        child: Semantics(
          label: 'Questionnaire progress',
          value: label,
          child: ElText(label, type, color: theme.mutedForeground),
        ),
      ),
    );
  }
}

/* ── Item ────────────────────────────────────────────────────────────────── */

/// `<QuestionnaireItem>` — a `<fieldset>`, `flex min-w-0 flex-col gap-4`.
///
/// [title] is the `<legend>` and is deliberately **not** one of [children]: a
/// rendered legend sits outside the fieldset's content box, contributes no flex
/// gap, and carries `mb-4` only when no [description] follows it.
class ElQuestionnaireItem extends StatelessWidget {
  const ElQuestionnaireItem({
    super.key,
    required this.name,
    this.title,
    this.description,
    this.required = false,
    this.invalid = false,
    this.children = const <Widget>[],
  });

  /// `gap-4`.
  static double get gap => el(4);

  /// The legend's `mb-4`, paid only when no description follows.
  static double get titleGap => el(4);

  final String name;
  final Widget? title;
  final Widget? description;
  final bool required;

  /// Forces the invalid state without validating — the reference's own
  /// `invalid` prop, which the state-grid cell uses.
  final bool invalid;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final _QScope scope = _QScope.of(context);
    final int index = scope.items.indexWhere(
      (_ItemMeta item) => item.name == name,
    );
    // `display: none` on every item but the active one.
    if (index != scope.controller.index) return const SizedBox.shrink();

    final bool invalidNow = invalid || scope.controller.isInvalid(name);
    // `Error` is `hidden` until the item is invalid, and a hidden flex item
    // takes no gap with it — the same rule the root applies to the items it is
    // not showing.
    final List<Widget> flow = <Widget>[
      ?description,
      for (final Widget child in children)
        if (child is! ElQuestionnaireError || invalidNow) child,
    ];
    final List<Widget> laid = <Widget>[];
    for (int i = 0; i < flow.length; i += 1) {
      laid.add(flow[i]);
      if (i != flow.length - 1) laid.add(SizedBox(height: gap));
    }

    return _ItemScope(
      name: name,
      required: required,
      invalid: invalidNow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (title != null)
            Padding(
              padding: EdgeInsets.only(
                bottom: description == null ? titleGap : 0,
              ),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: title,
              ),
            ),
          ...laid,
        ],
      ),
    );
  }
}

class _ItemScope extends InheritedWidget {
  const _ItemScope({
    required this.name,
    required this.required,
    required this.invalid,
    required super.child,
  });

  final String name;
  final bool required;
  final bool invalid;

  static _ItemScope of(BuildContext context) {
    final _ItemScope? scope = context
        .dependOnInheritedWidgetOfExactType<_ItemScope>();
    assert(scope != null, 'This part must sit inside a ElQuestionnaireItem.');
    return scope!;
  }

  @override
  bool updateShouldNotify(_ItemScope old) =>
      old.name != name || old.required != required || old.invalid != invalid;
}

/// `<QuestionnaireTitle>` — `font-heading text-base leading-snug font-medium`,
/// numerically `CardTitle`'s rung and declared separately in the reference too.
class ElQuestionnaireTitle extends StatelessWidget {
  const ElQuestionnaireTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => ElText(
    text,
    ElComponentType.cardTitle,
    color: ElTheme.of(context).foreground,
  );
}

/// `<QuestionnaireDescription>` — `text-sm text-pretty text-muted-foreground`.
class ElQuestionnaireDescription extends StatelessWidget {
  const ElQuestionnaireDescription(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => ElText(
    text,
    ElComponentType.bubbleReactions,
    color: ElTheme.of(context).mutedForeground,
  );
}

/* ── Choices ─────────────────────────────────────────────────────────────── */

/// `<QuestionnaireChoices>` — `grid min-w-0 gap-2`.
class ElQuestionnaireChoices extends StatelessWidget {
  const ElQuestionnaireChoices({super.key, required this.children});

  /// `gap-2`.
  static double get gap => el(2);

  final List<ElQuestionnaireChoice> children;

  @override
  Widget build(BuildContext context) {
    final _ItemScope item = _ItemScope.of(context);
    _ChoiceRegistrar.maybeOf(context)?.register(item.name, <String>[
      for (final ElQuestionnaireChoice c in children) c.value,
    ]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < children.length; i += 1)
          Padding(
            padding: EdgeInsets.only(
              bottom: i == children.length - 1 ? 0 : gap,
            ),
            child: _ChoiceIndex(index: i, child: children[i]),
          ),
      ],
    );
  }
}

class _ChoiceIndex extends InheritedWidget {
  const _ChoiceIndex({required this.index, required super.child});

  final int index;

  static int of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ChoiceIndex>()?.index ?? 0;

  @override
  bool updateShouldNotify(_ChoiceIndex old) => old.index != index;
}

/// `<QuestionnaireChoice>` — the full-width selectable row.
///
/// `rounded-lg` stays: this is the same shape as an `Item` and a `ToggleGroup`
/// item — both keep the container ladder rather than the pill §3 reserves for
/// free-standing buttons, inputs, badges and chips.
class ElQuestionnaireChoice extends StatefulWidget {
  const ElQuestionnaireChoice({
    super.key,
    required this.value,
    required this.label,
    this.description,
    this.defaultChecked = false,
    this.disabled = false,
  });

  /// `min-h-11`.
  static double get minHeight => el(11);

  /// `px-3 py-2.5`.
  static double get padX => el(3);
  static double get padY => el(2.5);

  /// `gap-2.5`.
  static double get gap => el(2.5);

  /// `size-5` on the indicator, and its `translate-y-0.5`.
  static double get indicator => el(5);
  static double get indicatorDrop => el(0.5);

  /// `size-2` on the checked dot.
  static double get dot => el(2);

  /// `data-disabled:opacity-50`. Declared here rather than read off
  /// `ElButton`'s own 0.45: that one is a *measured* disabled button, and this
  /// is the utility's nominal half, which is what the class says.
  static const double disabledOpacity = 0.50;

  /// `dark:bg-input/20` at rest, `data-checked:border-primary/40`,
  /// `hover:bg-muted/50`.
  static const double restFillAlpha = 0.20;
  static const double checkedRimAlpha = 0.40;
  static const double hoverFillAlpha = 0.50;

  final String value;
  final String label;
  final String? description;
  final bool defaultChecked;
  final bool disabled;

  @override
  State<ElQuestionnaireChoice> createState() => _ElQuestionnaireChoiceState();
}

class _ElQuestionnaireChoiceState extends State<ElQuestionnaireChoice> {
  bool _hovered = false;
  bool _seeded = false;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final _QScope scope = _QScope.of(context);
    final _ItemScope item = _ItemScope.of(context);
    final int index = _ChoiceIndex.of(context);

    // `defaultChecked` seeds the controller once, the way an uncontrolled
    // input's default value reaches React state on mount.
    if (widget.defaultChecked &&
        !_seeded &&
        scope.controller.valueOf(item.name) == null) {
      _seeded = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) scope.controller.setValue(item.name, widget.value);
      });
    }

    final bool checked = scope.controller.valueOf(item.name) == widget.value;
    final String? shortcut = scope.shortcuts.keyFor(index);

    final Color fill = checked
        ? theme.muted
        : _hovered
        ? theme.muted.withValues(alpha: ElQuestionnaireChoice.hoverFillAlpha)
        : theme.kind == ElThemeKind.dark
        ? theme.input.withValues(alpha: ElQuestionnaireChoice.restFillAlpha)
        : elTransparent;

    final Color rim = item.invalid
        ? theme.destructive
        : checked
        ? theme.primary.withValues(alpha: ElQuestionnaireChoice.checkedRimAlpha)
        : theme.input;

    return MouseRegion(
      cursor: widget.disabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.disabled
            ? null
            : () => scope.controller.setValue(item.name, widget.value),
        child: Opacity(
          opacity: widget.disabled ? ElQuestionnaireChoice.disabledOpacity : 1,
          child: AnimatedContainer(
            duration: elAnimationDuration(
              context,
              ElDurations.transitionDefault,
            ),
            curve: ElCurves.out,
            constraints: BoxConstraints(
              minHeight: ElQuestionnaireChoice.minHeight,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: ElQuestionnaireChoice.padX,
              vertical: ElQuestionnaireChoice.padY,
            ),
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(ElRadii.lg),
              border: Border.all(color: rim, width: ElWidths.hairline),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: ElQuestionnaireChoice.indicatorDrop,
                  ),
                  child: _RadioControl(checked: checked, invalid: item.invalid),
                ),
                SizedBox(width: ElQuestionnaireChoice.gap),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ElText(
                        widget.label,
                        ElComponentType.itemTitle,
                        color: theme.foreground,
                        fontSize: ElType.small.size,
                      ),
                      if (widget.description != null) ...<Widget>[
                        SizedBox(height: ElQuestionnaireChoice.indicatorDrop),
                        ElText(
                          widget.description!,
                          ElComponentType.itemTitle,
                          color: theme.mutedForeground,
                        ),
                      ],
                    ],
                  ),
                ),
                if (shortcut != null) ...<Widget>[
                  SizedBox(width: ElQuestionnaireChoice.gap),
                  Padding(
                    padding: EdgeInsets.only(
                      top: ElQuestionnaireChoice.indicatorDrop,
                    ),
                    // Reuses `Kbd` rather than hand-rolling a bordered box in
                    // an arbitrary 0.625rem — the shortcut badge on a choice is
                    // the same object as the shortcut hint everywhere else in
                    // the system, so it should look like one.
                    child: ElKbd(shortcut),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// `radioControlClassName` plus the checked and invalid overrides — a pure
/// visual, which is why the questionnaire draws it rather than mounting a
/// `ElRadioGroupItem` (that one owns its own gesture, focus and group).
class _RadioControl extends StatelessWidget {
  const _RadioControl({required this.checked, required this.invalid});

  final bool checked;
  final bool invalid;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final double size = ElQuestionnaireChoice.indicator;

    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: checked ? theme.primary : theme.card,
          shape: BoxShape.circle,
          border: Border.all(
            color: invalid
                ? theme.destructive
                : checked
                ? theme.primary
                : theme.input,
            width: ElWidths.hairline,
          ),
          boxShadow: checked
              ? ElShadows.btnPrimary.outerShadows(theme)
              : ElShadows.pressed.outerShadows(theme),
        ),
        child: checked ? const _Dot() : null,
      ),
    );
  }
}

/// `<RadioIndicator>` — `anim-dot-pop block size-2 rounded-full
/// bg-primary-foreground shadow-e1`.
class _Dot extends StatefulWidget {
  const _Dot();

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: ElDotPop.duration,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (elAnimationDuration(context, ElDotPop.duration) == Duration.zero) {
      _c.value = 1;
    } else if (!_c.isAnimating && _c.value == 0) {
      _c.forward();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Center(
      child: AnimatedBuilder(
        animation: _c,
        builder: (BuildContext context, Widget? child) => Opacity(
          opacity: ElDotPop.opacity.transform(_c.value),
          child: Transform.scale(
            scale: ElDotPop.scale.transform(_c.value),
            child: child,
          ),
        ),
        child: Container(
          width: ElQuestionnaireChoice.dot,
          height: ElQuestionnaireChoice.dot,
          decoration: BoxDecoration(
            color: theme.primaryForeground,
            shape: BoxShape.circle,
            boxShadow: ElShadows.e1.outerShadows(theme),
          ),
        ),
      ),
    );
  }
}

/* ── Input ───────────────────────────────────────────────────────────────── */

/// `<QuestionnaireInput>` — a control, so §3 puts it on the pill.
///
/// `h-8 min-h-11 rounded-pill border border-input bg-transparent px-2.5 py-1
/// text-base sm:min-h-0 md:text-sm dark:bg-input/30`. Measured 1030×32 at the
/// desktop frame, where `sm:min-h-0` has already released the 44px floor.
class ElQuestionnaireInput extends StatelessWidget {
  const ElQuestionnaireInput({super.key, this.placeholder, this.keyboardType});

  /// `h-8`.
  static double get height => el(8);

  /// `px-2.5 py-1`.
  static EdgeInsets get insets =>
      EdgeInsets.symmetric(horizontal: el(2.5), vertical: el(1));

  /// `min-h-11` below the `sm` breakpoint.
  static double get touchFloor => el(11);

  /// `dark:bg-input/30`.
  static const double darkFillAlpha = 0.30;

  final String? placeholder;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final _QScope scope = _QScope.of(context);
    final _ItemScope item = _ItemScope.of(context);
    final bool wide = MediaQuery.sizeOf(context).width >= ElBreakpoints.sm;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: wide ? height : touchFloor),
      child: ElInput(
        controller: scope.controller.textFor(item.name),
        placeholder: placeholder,
        keyboardType: keyboardType,
        invalid: item.invalid,
        boxHeight: height,
        padding: insets,
        radius: BorderRadius.circular(ElRadii.pill),
        textSpec: ElComponentType.bubbleReactions,
        fill: theme.kind == ElThemeKind.dark
            ? theme.input.withValues(alpha: darkFillAlpha)
            : elTransparent,
        onChanged: (String value) =>
            scope.controller.setValue(item.name, value),
      ),
    );
  }
}

/* ── Error ───────────────────────────────────────────────────────────────── */

/// `<QuestionnaireError>` — `mt-2 text-sm text-destructive-ink`, hidden until
/// the item is invalid.
///
/// **DRIFT, reproduced.** With no children the primitive supplies its own
/// string, and the transcript page mounts exactly that under a required item —
/// so the first question's error reads `Choose an answer to continue.` and no
/// page source says so.
class ElQuestionnaireError extends StatelessWidget {
  const ElQuestionnaireError({super.key, this.text});

  /// `mt-2`.
  static double get topGap => el(2);

  /// The primitive's own defaults.
  static const String requiredDefault = 'Choose an answer to continue.';
  static const String optionalDefault =
      'Choose an answer or skip this question.';

  final String? text;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final _ItemScope item = _ItemScope.of(context);
    if (!item.invalid) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: topGap),
      child: Semantics(
        liveRegion: true,
        child: ElText(
          text ?? (item.required ? requiredDefault : optionalDefault),
          ElComponentType.bubbleReactions,
          color: theme.destructiveInk,
        ),
      ),
    );
  }
}

/* ── Actions ─────────────────────────────────────────────────────────────── */

/// `<QuestionnaireActions>` — `grid min-h-11 grid-cols-[minmax(0,1fr)_auto_auto]
/// items-center gap-2 sm:min-h-8`.
///
/// The gaps are paid even when a track collapses, which is what a CSS grid
/// does and what makes `Next` alone still start 16px short of the right edge
/// less its own width.
class ElQuestionnaireActions extends StatelessWidget {
  const ElQuestionnaireActions({super.key, required this.children});

  /// `gap-2`.
  static double get gap => el(2);

  /// `min-h-11 sm:min-h-8`.
  static double get minHeight => el(11);
  static double get minHeightWide => el(8);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final bool wide = MediaQuery.sizeOf(context).width >= ElBreakpoints.sm;

    final List<Widget> lead = <Widget>[];
    Widget? middle;
    Widget? trailing;
    for (final Widget child in children) {
      if (child is ElQuestionnaireSkip) {
        middle = child;
      } else if (child is ElQuestionnaireNext ||
          child is ElQuestionnaireSubmit) {
        // `Next` and `Submit` share `col-start-3`, and exactly one of them is
        // ever visible.
        trailing = trailing == null
            ? child
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[trailing, child],
              );
      } else {
        lead.add(child);
      }
    }

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: wide ? minHeightWide : minHeight),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Row(mainAxisSize: MainAxisSize.min, children: lead),
            ),
          ),
          SizedBox(width: gap),
          ?middle,
          SizedBox(width: gap),
          ?trailing,
        ],
      ),
    );
  }
}

/// The shared body of the four action buttons.
class _Action extends StatelessWidget {
  const _Action({
    required this.visible,
    required this.label,
    required this.variant,
    required this.onPressed,
  });

  final bool visible;
  final String label;
  final ElButtonVariant variant;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // `hidden` + `inert` — the control is out of the layout entirely, which is
    // what the measured 0×0 boxes on step 1 are.
    if (!visible) return const SizedBox.shrink();
    return ElButton(variant: variant, onPressed: onPressed, child: Text(label));
  }
}

/// `<QuestionnairePrevious>` — visible when `total > 1 && !first`.
class ElQuestionnairePrevious extends StatelessWidget {
  const ElQuestionnairePrevious({super.key, this.label = 'Previous'});

  final String label;

  @override
  Widget build(BuildContext context) {
    final _QScope scope = _QScope.of(context);
    return _Action(
      visible: scope.total > 1 && !scope.first,
      label: label,
      variant: ElButtonVariant.outline,
      onPressed: scope.onPrevious,
    );
  }
}

/// `<QuestionnaireSkip>` — visible when the active item is **not** required.
class ElQuestionnaireSkip extends StatelessWidget {
  const ElQuestionnaireSkip({super.key, this.label = 'Skip'});

  final String label;

  @override
  Widget build(BuildContext context) {
    final _QScope scope = _QScope.of(context);
    return _Action(
      visible: scope.active?.required == false,
      label: label,
      variant: ElButtonVariant.outline,
      onPressed: scope.onSkip,
    );
  }
}

/// `<QuestionnaireNext>` — visible when `total > 1 && !last`. Carries
/// `aria-keyshortcuts="Enter"`.
class ElQuestionnaireNext extends StatelessWidget {
  const ElQuestionnaireNext({super.key, this.label = 'Next'});

  final String label;

  @override
  Widget build(BuildContext context) {
    final _QScope scope = _QScope.of(context);
    return _Action(
      visible: scope.total > 1 && !scope.last,
      label: label,
      variant: ElButtonVariant.primary,
      onPressed: scope.onNext,
    );
  }
}

/// `<QuestionnaireSubmit>` — visible on the last step.
class ElQuestionnaireSubmit extends StatelessWidget {
  const ElQuestionnaireSubmit({super.key, this.label = 'Submit'});

  final String label;

  @override
  Widget build(BuildContext context) {
    final _QScope scope = _QScope.of(context);
    return _Action(
      visible: scope.total > 0 && scope.last,
      label: label,
      variant: ElButtonVariant.primary,
      onPressed: scope.onSubmit,
    );
  }
}
