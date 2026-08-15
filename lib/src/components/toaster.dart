/// `components/ui/sonner.tsx` + the `.cn-toast` block (`app/globals.css`
/// L2584–2812) — the toast surface and its host.
///
/// The split the reference makes is the split kept here: sonner's `<Toaster/>`
/// is mounted **once** in the root layout (`app/layout.tsx:39`,
/// `position="bottom-right"`) and every page just calls `toast.success(…)`.
/// The Flutter analogue is a widget in the package and its mounting in the
/// example's shell — supervisor ruling F8 — so this file ships [DsToaster] and
/// [DsToastController] and mounts neither.
///
/// **Every visual decision lives in `.cn-toast`,** and the comment in
/// `sonner.tsx` says why: *"so the live toast and the DS preview share one
/// definition."*
///
/// | property | declaration | value |
/// |---|---|---|
/// | layout | `display: flex; align-items: flex-start` | icon beside content, both top-aligned |
/// | gap | `calc(var(--spacing) * 3)` | **12px** |
/// | width | `var(--width, 22.25rem)` | **356px** |
/// | padding | `calc(var(--spacing) * 4)` | **16px** |
/// | border | `1px solid var(--border)` | — |
/// | radius | `var(--radius-lg)` | 12px |
/// | fill | `background-color: var(--popover)` | *not* the `background` shorthand — the comment explains that the shorthand would reset `background-image` too |
/// | elevation | `box-shadow: var(--shadow-e3)` | — |
/// | type | `var(--text-small)` / `1.5` | 13px |
/// | clip | `overflow: hidden` | *"the bloom needs something to clip against"* |
/// | icon | `margin-top: calc(var(--spacing) * 0.5)`, 16px glyph | *"optically centres the glyph on the first line of the title"* |
/// | content | `flex-direction: column; gap: calc(var(--spacing) * 1)` | 4px |
/// | title | 13px / **500** / `--foreground` | — |
/// | description | 13px / `--muted-foreground` | — |
///
/// **The glyph's colour is the only colour a toast carries**, and it is always
/// an `-ink` token — see [DsToastType.inkOf]. The bloom's two hues are the
/// only other thing `data-type` changes.
///
/// **Runtime contract**, from sonner's own constants rather than from its CSS:
/// [visibleLimit] 3, [lifetime] 4000ms, [gap] 14px, [viewportOffset] 24px,
/// [width] 356px, and 200ms between a dismissal and the unmount. Newest sits
/// closest to the corner; anything past the third waits its turn.
///
/// Not ported, and recorded rather than guessed:
///  * sonner's own enter/exit choreography lives in its package stylesheet, not
///    in `globals.css`, and is not transcribed anywhere in the maps. A toast
///    therefore arrives without motion and leaves over the 200ms unmount
///    window, which is the part of the contract this port can state honestly.
///    The rest belongs with the `feedback` page.
///  * swipe-to-dismiss (`SWIPE_THRESHOLD` 45) and hover-to-pause. A tap
///    dismisses.
///  * `[data-button]` — the action pill. No call site on the forms page.
///  * the starfield on `[data-content]`. See `DsBloomCosmic`.
///
/// **KNOWN GAP — two glyphs.** `TOAST_ICONS` maps success to lucide's
/// `CircleCheck` and error to `OctagonX`, and `DsIconGlyph` carries neither;
/// `icon_paths.dart` is another task's file this wave. [DsToastType.glyph]
/// therefore answers `null` for those two and [DsToast.glyph] overrides it, so
/// a call site can supply the geometry the moment it lands. Everything else —
/// the ink, the bloom, the anatomy — is complete.
library;

import 'dart:async';

import 'package:flutter/widgets.dart';

import '../effects/bloom_cosmic.dart';
import '../effects/machine_surface.dart';
import '../foundation/motion.dart';
import '../foundation/shadows.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../theme_scope.dart';
import 'icon.dart';
import 'icon_paths.dart';

/// `width: var(--width, 22.25rem)`.
const double _width = 356;

/// sonner's `GAP` — the space between two stacked toasts.
const double _gap = 14;

/// sonner's `VIEWPORT_OFFSET` — 24px from both edges of the corner it sits in.
const double _offset = 24;

/// sonner's `VISIBLE_TOASTS_AMOUNT`.
const int _visible = 3;

/// sonner's `TOAST_LIFETIME`.
const Duration _lifetime = Duration(seconds: 4);

/// sonner's `TIME_BEFORE_UNMOUNT` — how long a dismissed toast stays in the
/// tree after it has been told to go.
///
/// It is numerically `--duration-dash-draw` and unrelated to it; putting it on
/// the duration scale would let a retimed checkbox retime the toast queue.
const Duration _unmount = Duration(milliseconds: 200); // allow-hardcoded: sonner's TIME_BEFORE_UNMOUNT, a runtime constant, not a --duration-* token

/// `data-type` — the five sonner types, plus the untyped default.
enum DsToastType {
  /// `data-type="success"` — `CircleCheck`, `--success-ink`, and a bloom of
  /// `--color-success` over `--color-value`.
  success,

  /// `data-type="info"` — `Info`, `--info-ink`.
  info,

  /// `data-type="warning"` — `TriangleAlert`, `--warning-ink`.
  warning,

  /// `data-type="error"` — `OctagonX`, `--destructive-ink`.
  error,

  /// `data-type="loading"` — `Loader2`, `--action-ink`.
  loading,

  /// No `data-type` at all: the glyph slot's own
  /// `color: var(--muted-foreground)` stands, and the bloom keeps the
  /// utility's default pair.
  normal;

  /// The key sonner spells this type with. [normal] has no attribute at all.
  String get label => this == DsToastType.normal ? 'default' : name;

  /// The glyph slot's colour — *"always an `-ink` token"*.
  Color inkOf(DsThemeData theme) => switch (this) {
        DsToastType.success => theme.successInk,
        DsToastType.info => theme.infoInk,
        DsToastType.warning => theme.warningInk,
        DsToastType.error => theme.destructiveInk,
        DsToastType.loading => theme.actionInk,
        DsToastType.normal => theme.mutedForeground,
      };

  /// `TOAST_ICONS[type]`, where this package has the geometry.
  ///
  /// `CircleCheck` and `OctagonX` are not in `DsIconGlyph` yet — see the KNOWN
  /// GAP note on this library. A `null` here is a missing transcript, not a
  /// toast without an icon.
  DsIconGlyph? get glyph => switch (this) {
        DsToastType.info => DsIconGlyph.info,
        DsToastType.warning => DsIconGlyph.alertTriangle,
        DsToastType.loading => DsIconGlyph.loaderCircle,
        DsToastType.success || DsToastType.error || DsToastType.normal => null,
      };
}

/// One queued toast.
@immutable
class DsToastMessage {
  const DsToastMessage({
    required this.title,
    this.description,
    this.type = DsToastType.normal,
    this.glyph,
    this.duration = _lifetime,
  });

  /// `[data-title]` — the only thing every toast on the forms page carries.
  final String title;

  /// `[data-description]`.
  final String? description;

  final DsToastType type;

  /// Overrides [DsToastType.glyph]; supply it for the two types whose lucide
  /// geometry this package does not carry yet.
  final DsIconGlyph? glyph;

  /// `TOAST_LIFETIME` unless the call site says otherwise.
  final Duration duration;
}

/// A live toast: an id, its message, and whether it is on its way out.
class _LiveToast {
  _LiveToast(this.id, this.message);

  final int id;
  final DsToastMessage message;
  bool leaving = false;
}

/// `toast.success(…)` and friends — the queue behind a [DsToaster].
///
/// Owned by whatever mounts the toaster, so a page can hold one and fire into
/// it, exactly as `toast` is a module-level singleton on the web.
class DsToastController extends ChangeNotifier {
  final List<_LiveToast> _toasts = <_LiveToast>[];
  int _nextId = 0;

  /// Every toast currently in the tree, oldest first. At most [_visible] of
  /// them are on screen; the rest are queued.
  @visibleForTesting
  int get length => _toasts.length;

  /// How many are actually painted.
  @visibleForTesting
  int get visibleCount => _toasts.length < _visible ? _toasts.length : _visible;

  /// `toast(…)` — returns the id, so a caller can dismiss it early.
  int show(DsToastMessage message) {
    final int id = _nextId++;
    _toasts.add(_LiveToast(id, message));
    notifyListeners();
    return id;
  }

  /// `toast.success(title)`.
  int success(String title, {String? description, DsIconGlyph? glyph}) =>
      show(DsToastMessage(
        title: title,
        description: description,
        type: DsToastType.success,
        glyph: glyph,
      ));

  /// `toast.error(title)`.
  int error(String title, {String? description, DsIconGlyph? glyph}) =>
      show(DsToastMessage(
        title: title,
        description: description,
        type: DsToastType.error,
        glyph: glyph,
      ));

  /// `toast.dismiss(id)` — starts the 200ms unmount window.
  void dismiss(int id) {
    for (final _LiveToast toast in _toasts) {
      if (toast.id != id || toast.leaving) continue;
      toast.leaving = true;
      notifyListeners();
      return;
    }
  }

  /// Called by the host once a leaving toast's window has closed.
  void _remove(int id) {
    final int before = _toasts.length;
    _toasts.removeWhere((_LiveToast t) => t.id == id);
    if (_toasts.length != before) notifyListeners();
  }

  /// `toast.dismiss()` with no argument — clears everything at once.
  void clear() {
    if (_toasts.isEmpty) return;
    _toasts.clear();
    notifyListeners();
  }
}

/// The corner sonner is anchored in. The root layout passes `bottom-right`.
enum DsToastPosition {
  bottomRight,
  bottomLeft,
  topRight,
  topLeft;

  bool get isBottom =>
      this == DsToastPosition.bottomRight || this == DsToastPosition.bottomLeft;

  bool get isRight =>
      this == DsToastPosition.bottomRight || this == DsToastPosition.topRight;
}

/// `<Toaster position="bottom-right" />` — the host.
///
/// Mount it **once**, above everything else, the way the root layout does. It
/// paints nothing until a toast is queued and never intercepts a pointer
/// outside a toast's own box.
class DsToaster extends StatefulWidget {
  const DsToaster({
    super.key,
    required this.controller,
    this.position = DsToastPosition.bottomRight,
  });

  final DsToastController controller;

  final DsToastPosition position;

  /// `width: 22.25rem`.
  static double get width => _width;

  /// sonner's `GAP`.
  static double get gap => _gap;

  /// sonner's `VIEWPORT_OFFSET`.
  static double get viewportOffset => _offset;

  /// sonner's `VISIBLE_TOASTS_AMOUNT`.
  static int get visibleLimit => _visible;

  /// sonner's `TOAST_LIFETIME`.
  static Duration get lifetime => _lifetime;

  /// sonner's `TIME_BEFORE_UNMOUNT`.
  static Duration get unmountDelay => _unmount;

  @override
  State<DsToaster> createState() => _DsToasterState();
}

class _DsToasterState extends State<DsToaster> {
  /// The lifetime clock of every toast that has been on screen, keyed by id so
  /// a rebuild cannot restart one.
  final Map<int, Timer> _timed = <int, Timer>{};

  /// The unmount clock of every toast on its way out, for the same reason.
  final Map<int, Timer> _retiring = <int, Timer>{};

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
  }

  @override
  void didUpdateWidget(DsToaster old) {
    super.didUpdateWidget(old);
    if (old.controller == widget.controller) return;
    old.controller.removeListener(_onChanged);
    widget.controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    for (final Timer timer in _timed.values) {
      timer.cancel();
    }
    for (final Timer timer in _retiring.values) {
      timer.cancel();
    }
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  /// Starts a toast's lifetime the first time it becomes visible — a queued
  /// fourth toast does not start counting down behind the other three.
  void _tick(_LiveToast toast) {
    if (_timed.containsKey(toast.id)) return;
    _timed[toast.id] = Timer(toast.message.duration, () {
      if (!mounted) return;
      widget.controller.dismiss(toast.id);
    });
  }

  void _retire(_LiveToast toast) {
    if (_retiring.containsKey(toast.id)) return;
    _retiring[toast.id] = Timer(_unmount, () {
      if (!mounted) return;
      _timed.remove(toast.id)?.cancel();
      _retiring.remove(toast.id);
      widget.controller._remove(toast.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<_LiveToast> all = widget.controller._toasts;
    if (all.isEmpty) return const SizedBox.shrink();

    // The three most recent are on screen; the rest wait.
    final List<_LiveToast> shown =
        all.length <= _visible ? all : all.sublist(all.length - _visible);
    for (final _LiveToast toast in shown) {
      if (toast.leaving) {
        _retire(toast);
      } else {
        _tick(toast);
      }
    }

    // Newest closest to the corner: at the bottom for a bottom-* position, at
    // the top otherwise.
    final List<_LiveToast> ordered = widget.position.isBottom
        ? shown
        : shown.reversed.toList(growable: false);

    final Widget column = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (int i = 0; i < ordered.length; i++) ...<Widget>[
          if (i > 0) SizedBox(height: _gap),
          _Leaving(
            leaving: ordered[i].leaving,
            child: DsToast(
              message: ordered[i].message,
              onDismiss: () => widget.controller.dismiss(ordered[i].id),
            ),
          ),
        ],
      ],
    );

    // Give this widget a full-size slot — `Positioned.fill` inside the shell's
    // `Stack`, or an `Overlay` entry — and it anchors itself in the corner the
    // way sonner's fixed viewport does.
    return Align(
      alignment: switch (widget.position) {
        DsToastPosition.bottomRight => AlignmentDirectional.bottomEnd,
        DsToastPosition.bottomLeft => AlignmentDirectional.bottomStart,
        DsToastPosition.topRight => AlignmentDirectional.topEnd,
        DsToastPosition.topLeft => AlignmentDirectional.topStart,
      },
      child: Padding(
        padding: const EdgeInsets.all(_offset),
        child: SizedBox(width: _width, child: column),
      ),
    );
  }
}

/// The 200ms window sonner keeps a dismissed toast in the tree for.
class _Leaving extends StatelessWidget {
  const _Leaving({required this.leaving, required this.child});

  final bool leaving;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: leaving ? 0 : 1,
      duration: dsAnimationDuration(context, _unmount),
      curve: DsCurves.out,
      child: child,
    );
  }
}

/// `.cn-toast` — the surface, on its own, for a host or a static preview.
class DsToast extends StatelessWidget {
  const DsToast({super.key, required this.message, this.onDismiss});

  final DsToastMessage message;

  /// A tap dismisses. sonner's swipe and its close button are not ported —
  /// see the library note.
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final BorderRadius radius = BorderRadius.circular(DsRadii.lg);
    final DsIconGlyph? glyph = message.glyph ?? message.type.glyph;

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DsText(message.title, DsComponentType.buttonLabel,
            color: theme.foreground),
        if (message.description != null) ...<Widget>[
          // `[data-content] { gap: calc(var(--spacing) * 1) }`.
          SizedBox(height: ds(1)),
          DsText(
            message.description!,
            DsComponentType.sheetBody,
            color: theme.mutedForeground,
          ),
        ],
      ],
    );

    if (glyph != null) {
      content = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            // `[data-icon] { margin-top: calc(var(--spacing) * 0.5) }`.
            padding: EdgeInsets.only(top: ds(0.5)),
            child: DsIcon(glyph, sizePx: ds(4)),
          ),
          // `gap: calc(var(--spacing) * 3)`.
          SizedBox(width: ds(3)),
          Expanded(child: content),
        ],
      );
    }

    // The glyph is `color: var(--<type>-ink)` and nothing else in the toast is
    // coloured by its type at all.
    content = DefaultTextStyle.merge(
      style: TextStyle(color: message.type.inkOf(theme)),
      child: content,
    );

    Widget toast = Padding(
      // `padding: calc(var(--spacing) * 4)`.
      padding: EdgeInsets.all(ds(4)),
      child: content,
    );

    toast = _bloomFor(message.type, radius: radius, fill: theme.popover,
        child: toast);

    // `box-shadow: var(--shadow-e3)` and `border: 1px solid var(--border)`,
    // outside the bloom's clip because `overflow: hidden` clips to the padding
    // box.
    toast = DsMachineSurface(
      spec: DsShadows.e3,
      radius: radius,
      border: Border.all(color: theme.border, width: DsWidths.hairline),
      child: toast,
    );

    return Semantics(
      container: true,
      liveRegion: true,
      label: message.title,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onDismiss,
        child: toast,
      ),
    );
  }

  /// `.cn-toast[data-type="…"]`'s `--bloom-1` / `--bloom-2` pair.
  ///
  /// Four of the five agree with the Alert variant of the same name. `warning`
  /// does not — see `DsBloomCosmic.toastWarning`.
  static Widget _bloomFor(
    DsToastType type, {
    required BorderRadius radius,
    required Color fill,
    required Widget child,
  }) =>
      switch (type) {
        DsToastType.success =>
          DsBloomCosmic.success(radius: radius, fill: fill, child: child),
        DsToastType.info =>
          DsBloomCosmic.info(radius: radius, fill: fill, child: child),
        DsToastType.warning =>
          DsBloomCosmic.toastWarning(radius: radius, fill: fill, child: child),
        DsToastType.error =>
          DsBloomCosmic.destructive(radius: radius, fill: fill, child: child),
        DsToastType.loading =>
          DsBloomCosmic.loading(radius: radius, fill: fill, child: child),
        DsToastType.normal =>
          DsBloomCosmic.action(radius: radius, fill: fill, child: child),
      };
}
