import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Selection and feedback: the three toggles, the select, the alert and the
/// toast host. One state matrix each, pinned against `forms-map.md` and the six
/// reference sources it cites.

Widget host(Widget child, {DsThemeMode mode = DsThemeMode.dark}) {
  return MediaQuery(
    data: const MediaQueryData(size: Size(1440, 900)),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: DsTheme(
        controller: DsThemeController(mode: mode),
        child: Center(child: child),
      ),
    ),
  );
}

/// What [overlayHost] is currently showing.
///
/// `Overlay.initialEntries` is read once, in `initState`, so a second
/// `pumpWidget` with a new entry is silently ignored and the first tree stays
/// on screen. The entry therefore closes over this holder instead: the entry
/// object survives, its builder re-runs on every rebuild, and it reads whatever
/// the latest call passed.
Widget _hosted = const SizedBox.shrink();

/// A host with an [Overlay], for the one component that portals.
Widget overlayHost(Widget child, {DsThemeMode mode = DsThemeMode.dark}) {
  _hosted = child;
  return MediaQuery(
    data: const MediaQueryData(size: Size(1440, 900)),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: DsTheme(
        controller: DsThemeController(mode: mode),
        child: Overlay(
          initialEntries: <OverlayEntry>[
            OverlayEntry(builder: (BuildContext _) => Center(child: _hosted)),
          ],
        ),
      ),
    ),
  );
}

DsThemeData themeIn(WidgetTester t, Type of) => DsTheme.of(
      t.element(find.byType(of).first),
    );

/// The socket a control paints — the first [DsMachineSurface] inside it, which
/// is the control's own surface rather than an indicator's.
DsMachineSurface socketOf(WidgetTester t, Type of) => t.widget<DsMachineSurface>(
      find
          .descendant(of: find.byType(of), matching: find.byType(DsMachineSurface))
          .first,
    );

Color borderOf(DsMachineSurface surface) =>
    (surface.border! as Border).top.color;

/// The `ring-3` layer `DsButton.withFocusRing` prepends: zero offset, zero
/// blur, 3px spread.
Color ringOf(DsMachineSurface surface, DsThemeData theme) =>
    surface.spec.layers.first.color(theme);

/// `z.boolean().refine(v => v, …)` — the one rule the `terms` field carries.
bool _accepted(bool value) => value;

/// The [FocusNode] a radio item's own [Focus] carries — the ones with a key
/// handler, which the `Visibility` wrappers inside an indicator do not have.
FocusNode itemFocus(WidgetTester t, int index) => t
    .widgetList<Focus>(find.descendant(
        of: find.byType(DsRadioGroup<String>), matching: find.byType(Focus)))
    .where((Focus f) => f.onKeyEvent != null)
    .elementAt(index)
    .focusNode!;

void main() {
  group('DsCheckbox', () {
    testWidgets('is 20px on a 6px corner', (WidgetTester t) async {
      await t.pumpWidget(host(const DsCheckbox()));
      expect(t.getSize(find.byType(DsSelectionControl)), const Size(20, 20));
      expect(DsCheckbox.size, 20);
      expect(socketOf(t, DsCheckbox).radius, BorderRadius.circular(DsRadii.sm));
    });

    testWidgets('the socket lights on check: pressed → btn-primary',
        (WidgetTester t) async {
      await t.pumpWidget(host(const DsCheckbox()));
      final DsThemeData theme = themeIn(t, DsCheckbox);
      expect(socketOf(t, DsCheckbox).spec.layers.skip(1).toList(),
          DsShadows.pressed.layers);
      expect(socketOf(t, DsCheckbox).fill, theme.card);
      expect(borderOf(socketOf(t, DsCheckbox)), theme.input);

      await t.pumpWidget(
          host(const DsCheckbox(state: DsCheckboxState.checked)));
      await t.pump(DsDurations.transitionDefault);
      expect(socketOf(t, DsCheckbox).spec.layers.skip(1).toList(),
          DsShadows.btnPrimary.layers);
      expect(socketOf(t, DsCheckbox).fill, theme.primary);
      expect(borderOf(socketOf(t, DsCheckbox)), theme.primary);
    });

    /// The mark's own player, told apart from [DsJellyReplay]'s by its
    /// duration: a draw runs 280ms or 200ms, the squash 600.
    Finder markPlayer() => find.byWidgetPredicate(
          (Widget w) =>
              w is DsKeyframePlayer &&
              (w.duration == DsCheckDraw.duration ||
                  w.duration == DsDashDraw.duration),
        );

    testWidgets('mounts no indicator while unchecked, and one when lit',
        (WidgetTester t) async {
      await t.pumpWidget(host(const DsCheckbox()));
      expect(markPlayer(), findsNothing);

      // Exactly ONE mark is mounted at a time. The old model mounted both and
      // hid one, which is what made a swap reveal a finished stroke.
      await t.pumpWidget(
          host(const DsCheckbox(state: DsCheckboxState.checked)));
      expect(markPlayer(), findsOneWidget);
      await t.pump(DsJelly.duration);

      await t.pumpWidget(
          host(const DsCheckbox(state: DsCheckboxState.indeterminate)));
      expect(markPlayer(), findsOneWidget);
      await t.pump(DsJelly.duration);

      // Going out is an unmount, not a reverse draw and not a fade.
      await t.pumpWidget(host(const DsCheckbox()));
      await t.pump();
      expect(markPlayer(), findsNothing,
          reason: 'unchecking unmounts the indicator outright — measured');
    });

    testWidgets('every reveal re-draws its mark from zero',
        (WidgetTester t) async {
      // MEASURED (behaviour audit, second pass): a hidden mark carries no
      // animation of its own, and restoring it starts a brand-new one. So a
      // swap between the two lit states re-runs the arriving mark's draw in
      // full rather than revealing a stroke that already finished. A fresh
      // Element is exactly what a fresh CSS animation is here — the player is
      // re-keyed, so it cannot resume.
      await t.pumpWidget(
          host(const DsCheckbox(state: DsCheckboxState.checked)));
      await t.pump(DsCheckDraw.duration);
      await t.pump(DsJelly.duration);
      final Element tick = t.element(markPlayer());
      expect(t.widget<DsKeyframePlayer>(markPlayer()).duration,
          DsCheckDraw.duration);

      // checked -> indeterminate re-runs `dash-draw`, all 200ms of it.
      await t.pumpWidget(
          host(const DsCheckbox(state: DsCheckboxState.indeterminate)));
      await t.pump();
      expect(t.element(markPlayer()), isNot(tick),
          reason: 'a fresh player, not the finished bar re-shown');
      expect(t.widget<DsKeyframePlayer>(markPlayer()).duration,
          DsDashDraw.duration);
      await t.pump(DsDashDraw.duration);
      await t.pump(DsJelly.duration);

      // …and indeterminate -> checked re-runs `check-draw`.
      final Element bar = t.element(markPlayer());
      await t.pumpWidget(
          host(const DsCheckbox(state: DsCheckboxState.checked)));
      await t.pump();
      expect(t.element(markPlayer()), isNot(bar),
          reason: 'the tick starts over too');
      expect(t.widget<DsKeyframePlayer>(markPlayer()).duration,
          DsCheckDraw.duration);
      await t.pump(DsCheckDraw.duration);
      await t.pump(DsJelly.duration);
    });

    testWidgets('the tick draws itself on over 280ms',
        (WidgetTester t) async {
      expect(DsCheckDraw.duration, DsDurations.checkDraw);
      expect(DsCheckDraw.drawnFractionAt(0), 0);
      expect(DsCheckDraw.drawnFractionAt(1), 1);
      expect(DsDashDraw.duration, DsDurations.dashDraw);

      await t.pumpWidget(
          host(const DsCheckbox(state: DsCheckboxState.checked)));
      await t.pump(const Duration(milliseconds: 140));
      // Mid-flight: part of the stroke, not all of it.
      final double half = DsCheckDraw.drawnFractionAt(0.5);
      expect(half, greaterThan(0));
      expect(half, lessThan(1));
      await t.pump(DsCheckDraw.duration);
    });

    testWidgets('a click toggles the way Radix does', (WidgetTester t) async {
      expect(DsCheckbox.nextAfter(DsCheckboxState.unchecked),
          DsCheckboxState.checked);
      expect(DsCheckbox.nextAfter(DsCheckboxState.indeterminate),
          DsCheckboxState.checked);
      expect(DsCheckbox.nextAfter(DsCheckboxState.checked),
          DsCheckboxState.unchecked);

      DsCheckboxState? seen;
      await t.pumpWidget(host(DsCheckbox(
        state: DsCheckboxState.unchecked,
        onChanged: (DsCheckboxState next) => seen = next,
      )));
      await t.tap(find.byType(DsCheckbox));
      expect(seen, DsCheckboxState.checked);
    });

    testWidgets('answers a pointer 44 × 36 — the pseudo-element, not the paint',
        (WidgetTester t) async {
      int taps = 0;
      await t.pumpWidget(host(DsCheckbox(
        onChanged: (DsCheckboxState _) => taps++,
      )));
      // The box is 20 × 20 and takes 20 × 20 of layout…
      expect(t.getSize(find.byType(DsHitArea)), const Size(20, 20));
      final Offset centre = t.getCenter(find.byType(DsCheckbox));
      // …and answers 12px out on each side and 8px above and below.
      await t.tapAt(centre + const Offset(21, 0));
      await t.tapAt(centre + const Offset(0, 17));
      expect(taps, 2);
      // Past the pseudo-element, nothing.
      await t.tapAt(centre + const Offset(23, 0));
      expect(taps, 2);
    });

    testWidgets('jelly never fires on mount, and fires both ways',
        (WidgetTester t) async {
      // Read on a switch rather than a checkbox: a switch mounts no keyframe
      // player of its own, so every one found belongs to the replay.
      await t.pumpWidget(host(const DsSwitch(value: false)));
      expect(
        find.byType(DsKeyframePlayer),
        findsNothing,
        reason: 'a MutationObserver does not report initial state',
      );

      await t.pumpWidget(host(const DsSwitch(value: true)));
      expect(find.byType(DsKeyframePlayer), findsOneWidget);
      await t.pumpAndSettle();

      // …and again on the way back.
      await t.pumpWidget(host(const DsSwitch(value: false)));
      expect(find.byType(DsKeyframePlayer), findsOneWidget);
      await t.pumpAndSettle();
      expect(DsJelly.duration, DsDurations.animJelly);
    });

    testWidgets('aria-invalid beats focus-visible — F5, drift 6',
        (WidgetTester t) async {
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);

      await t.pumpWidget(host(DsCheckbox(
        invalid: true,
        focusNode: node,
        onChanged: (DsCheckboxState _) {},
      )));
      final DsThemeData theme = themeIn(t, DsCheckbox);
      await t.pump(DsDurations.transitionDefault);
      final Color restBorder = borderOf(socketOf(t, DsCheckbox));
      final Color restRing = ringOf(socketOf(t, DsCheckbox), theme);
      expect(restBorder, theme.destructive);

      node.requestFocus();
      await t.pump();
      await t.pumpAndSettle();
      // Focusing an errored control produces no visible change at all.
      expect(borderOf(socketOf(t, DsCheckbox)), restBorder);
      expect(ringOf(socketOf(t, DsCheckbox), theme), restRing);
    });

    testWidgets('focus rings at ring/50 when valid', (WidgetTester t) async {
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      await t.pumpWidget(host(DsCheckbox(
        focusNode: node,
        onChanged: (DsCheckboxState _) {},
      )));
      final DsThemeData theme = themeIn(t, DsCheckbox);
      node.requestFocus();
      await t.pump();
      await t.pumpAndSettle();
      expect(borderOf(socketOf(t, DsCheckbox)), theme.ring);
      expect(ringOf(socketOf(t, DsCheckbox), theme).a, closeTo(0.50, 0.001));
    });

    testWidgets('Space and Enter operate it', (WidgetTester t) async {
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      int taps = 0;
      await t.pumpWidget(host(DsCheckbox(
        focusNode: node,
        onChanged: (DsCheckboxState _) => taps++,
      )));
      node.requestFocus();
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.space);
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(taps, 2);
    });

    testWidgets('disabled dims to 50% and ignores a pointer',
        (WidgetTester t) async {
      int taps = 0;
      await t.pumpWidget(host(DsCheckbox(
        enabled: false,
        onChanged: (DsCheckboxState _) => taps++,
      )));
      expect(
        t
            .widget<Opacity>(find
                .descendant(
                    of: find.byType(DsCheckbox), matching: find.byType(Opacity))
                .first)
            .opacity,
        0.50,
      );
      await t.tap(find.byType(DsCheckbox), warnIfMissed: false);
      expect(taps, 0);
    });
  });

  group('DsRadioGroup', () {
    Widget group(
      String? value,
      ValueChanged<String>? onChanged, {
      double? gap,
    }) =>
        host(SizedBox(
          width: 200,
          child: DsRadioGroup<String>(
            value: value,
            onChanged: onChanged,
            gap: gap,
            children: const <Widget>[
              DsRadioGroupItem<String>(value: 'daily', label: 'Daily'),
              DsRadioGroupItem<String>(value: 'weekly', label: 'Weekly'),
            ],
          ),
        ));

    testWidgets('items are 20px circles', (WidgetTester t) async {
      await t.pumpWidget(group(null, (String _) {}));
      expect(t.getSize(find.byType(DsSelectionControl).first),
          const Size(20, 20));
      expect(DsRadioGroupItem.size, 20);
      expect(socketOf(t, DsRadioGroupItem<String>).radius, BorderRadius.circular(10));
    });

    testWidgets('gap-2 by default, gap-3 as the composed form passes',
        (WidgetTester t) async {
      expect(DsRadioGroup.defaultGap, 8);
      await t.pumpWidget(group(null, (String _) {}));
      final double a = t.getTopLeft(find.byType(DsRadioGroupItem<String>).at(1)).dy -
          t.getBottomLeft(find.byType(DsRadioGroupItem<String>).at(0)).dy;
      expect(a, 8);

      await t.pumpWidget(group(null, (String _) {}, gap: 12));
      final double b = t.getTopLeft(find.byType(DsRadioGroupItem<String>).at(1)).dy -
          t.getBottomLeft(find.byType(DsRadioGroupItem<String>).at(0)).dy;
      expect(b, 12);
    });

    testWidgets('the dot mounts only when checked, at 8px on e1',
        (WidgetTester t) async {
      await t.pumpWidget(group(null, (String _) {}));
      final Finder surfaces = find.descendant(
        of: find.byType(DsRadioGroupItem<String>).at(0),
        matching: find.byType(DsMachineSurface),
      );
      // Only the socket, while nothing is chosen.
      expect(surfaces, findsOneWidget);

      await t.pumpWidget(group('daily', (String _) {}));
      expect(surfaces, findsNWidgets(2));
      final DsMachineSurface dot = t.widget<DsMachineSurface>(surfaces.last);
      expect(dot.spec.layers, DsShadows.e1.layers);
      await t.pumpAndSettle();
      expect(t.getSize(surfaces.last), const Size(8, 8));
    });

    testWidgets('dot-pop overshoots to 1.35 at 55%', (WidgetTester t) async {
      expect(DsDotPop.duration, DsDurations.dotPop);
      expect(DsDotPop.curve, DsCurves.spring);
      expect(DsDotPop.scale.transform(0), 0);
      expect(DsDotPop.scale.transform(0.55), closeTo(1.35, 0.001));
      expect(DsDotPop.scale.transform(1), 1);
    });

    testWidgets('the socket lights on selection', (WidgetTester t) async {
      await t.pumpWidget(group('daily', (String _) {}));
      final DsThemeData theme = themeIn(t, DsRadioGroupItem<String>);
      await t.pump(DsDurations.transitionDefault);
      expect(socketOf(t, DsRadioGroupItem<String>).fill, theme.primary);
      expect(socketOf(t, DsRadioGroupItem<String>).spec.layers.skip(1).toList(),
          DsShadows.btnPrimary.layers);
    });

    testWidgets('arrows move and select, and they wrap',
        (WidgetTester t) async {
      String? value = 'daily';
      await t.pumpWidget(group(value, (String next) => value = next));
      // Flutter does not move focus on a pointer tap — the same predicate
      // `DsButton` relies on for `:focus-visible` — so the tab stop is asked
      // for directly, which is what a Tab into the group produces.
      itemFocus(t, 0).requestFocus();
      await t.pump();

      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      expect(value, 'weekly');
      await t.pumpWidget(group(value, (String next) => value = next));
      // …and past the end, back to the start.
      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      expect(value, 'daily');
    });

    testWidgets('the group is one tab stop — roving tabindex',
        (WidgetTester t) async {
      await t.pumpWidget(group('weekly', (String _) {}));
      final List<Focus> nodes = t
          .widgetList<Focus>(find.descendant(
              of: find.byType(DsRadioGroup<String>),
              matching: find.byType(Focus)))
          .where((Focus f) => f.onKeyEvent != null)
          .toList();
      expect(nodes.length, 2);
      expect(nodes[0].skipTraversal, isTrue);
      expect(nodes[1].skipTraversal, isFalse);
    });

    testWidgets('a null onChanged disables every item',
        (WidgetTester t) async {
      await t.pumpWidget(group(null, null));
      expect(
        t
            .widget<Opacity>(find
                .descendant(
                    of: find.byType(DsRadioGroupItem<String>).at(0),
                    matching: find.byType(Opacity))
                .first)
            .opacity,
        0.50,
        reason: 'a group with no setter is a disabled group — disabled:opacity-50',
      );
      await t.tap(find.byType(DsRadioGroupItem<String>).at(0), warnIfMissed: false);
    });
  });

  group('DsSwitch', () {
    testWidgets('44 × 24 with a 20px thumb, 36 × 20 with a 16px one',
        (WidgetTester t) async {
      expect(DsSwitchSize.md.trackWidth, 44);
      expect(DsSwitchSize.md.trackHeight, 24);
      expect(DsSwitchSize.md.thumbSize, 20);
      expect(DsSwitchSize.md.travel, 20);
      expect(DsSwitchSize.md.label, 'default');
      expect(DsSwitchSize.sm.trackWidth, 36);
      expect(DsSwitchSize.sm.trackHeight, 20);
      expect(DsSwitchSize.sm.thumbSize, 16);
      expect(DsSwitchSize.sm.travel, 16);

      await t.pumpWidget(host(const DsSwitch(value: false)));
      expect(t.getSize(find.byType(DsSelectionControl)), const Size(44, 24));
    });

    testWidgets('the thumb travels 20px and ends flush with the border',
        (WidgetTester t) async {
      await t.pumpWidget(host(const DsSwitch(value: false)));
      final Finder thumb = find
          .descendant(
              of: find.byType(DsSwitch), matching: find.byType(DsMachineSurface))
          .last;
      final double trackLeft = t.getTopLeft(find.byType(DsSwitch)).dx;
      // border 1 + padding 2.
      expect(t.getTopLeft(thumb).dx - trackLeft, 3);

      await t.pumpWidget(host(const DsSwitch(value: true)));
      await t.pumpAndSettle();
      // 20px of travel on a 38px content box: the knob spends its left-hand
      // air and lands against the inner edge of the border.
      expect(t.getTopLeft(thumb).dx - trackLeft, 23);
      expect(t.getBottomRight(thumb).dx - trackLeft, 43);
    });

    testWidgets('the track is recessed and the knob is raised',
        (WidgetTester t) async {
      await t.pumpWidget(host(const DsSwitch(value: false)));
      final DsThemeData theme = themeIn(t, DsSwitch);
      expect(socketOf(t, DsSwitch).fill, theme.muted);
      expect(socketOf(t, DsSwitch).spec.layers.skip(1).toList(),
          DsShadows.pressed.layers);

      final DsMachineSurface thumb = t.widget<DsMachineSurface>(find
          .descendant(
              of: find.byType(DsSwitch), matching: find.byType(DsMachineSurface))
          .last);
      expect(thumb.spec.layers, DsShadows.btn.layers);
      expect(thumb.fill, theme.foreground);

      await t.pumpWidget(host(const DsSwitch(value: true)));
      await t.pumpAndSettle();
      expect(socketOf(t, DsSwitch).fill, theme.primary);
      expect(socketOf(t, DsSwitch).spec.layers.skip(1).toList(),
          DsShadows.btnPrimary.layers);
      // The knob is raised in both states — that opposition is the point.
      expect(
        t
            .widget<DsMachineSurface>(find
                .descendant(
                    of: find.byType(DsSwitch),
                    matching: find.byType(DsMachineSurface))
                .last)
            .spec
            .layers,
        DsShadows.btn.layers,
      );
    });

    testWidgets('answers a pointer 68 × 40', (WidgetTester t) async {
      int taps = 0;
      await t.pumpWidget(host(DsSwitch(
        value: false,
        onChanged: (bool _) => taps++,
      )));
      final Offset centre = t.getCenter(find.byType(DsSwitch));
      await t.tapAt(centre + const Offset(33, 0));
      await t.tapAt(centre + const Offset(0, 19));
      expect(taps, 2);
      await t.tapAt(centre + const Offset(35, 0));
      expect(taps, 2);
    });

    testWidgets('the thumb runs on the spring, the track does not',
        (WidgetTester t) async {
      await t.pumpWidget(host(const DsSwitch(value: false)));
      final TweenAnimationBuilder<double> thumb =
          t.widget<TweenAnimationBuilder<double>>(
        find.byType(TweenAnimationBuilder<double>),
      );
      expect(thumb.curve, DsCurves.spring);
      expect(thumb.duration, DsDurations.transitionDefault);

      final TweenAnimationBuilder<Color?> track =
          t.widget<TweenAnimationBuilder<Color?>>(
        find.byType(TweenAnimationBuilder<Color?>).first,
      );
      expect(track.curve, DsCurves.out);
      expect(track.duration, DsDurations.transitionDefault);
    });
  });

  group('DsSelect', () {
    List<DsSelectOption<String>> options() => const <DsSelectOption<String>>[
          DsSelectOption<String>(value: 'free', label: 'Free'),
          DsSelectOption<String>(value: 'pro', label: 'Pro'),
          DsSelectOption<String>(value: 'vault', label: 'Vault'),
        ];

    Widget select(String? value, ValueChanged<String>? onChanged) =>
        overlayHost(SizedBox(
          width: 448,
          child: DsSelect<String>(
            options: options(),
            value: value,
            onChanged: onChanged,
            placeholder: 'Choose a plan',
            expand: true,
          ),
        ));

    testWidgets('the trigger is 40px on a pill over a socket',
        (WidgetTester t) async {
      expect(DsSelectSize.md.height, 40);
      expect(DsSelectSize.sm.height, 32);
      expect(DsSelectSize.md.label, 'default');

      await t.pumpWidget(select(null, (String _) {}));
      expect(t.getSize(find.byType(DsSelect<String>)).height, 40);
      expect(socketOf(t, DsSelect<String>).spec.layers.skip(1).toList(),
          DsShadows.pressed.layers);
      expect(socketOf(t, DsSelect<String>).radius,
          BorderRadius.circular(DsRadii.pill));
    });

    testWidgets('the placeholder is muted until something is chosen',
        (WidgetTester t) async {
      await t.pumpWidget(select(null, (String _) {}));
      final DsThemeData theme = themeIn(t, DsSelect<String>);
      expect(find.text('Choose a plan'), findsOneWidget);
      expect(
        t.widget<DsText>(find.byType(DsText).first).color,
        theme.mutedForeground,
      );

      await t.pumpWidget(select('pro', (String _) {}));
      expect(find.text('Pro'), findsOneWidget);
      expect(t.widget<DsText>(find.byType(DsText).first).color, theme.foreground);
    });

    testWidgets('a click opens a menu of every option', (WidgetTester t) async {
      await t.pumpWidget(select(null, (String _) {}));
      expect(find.text('Free'), findsNothing);

      await t.tap(find.byType(DsSelect<String>));
      await t.pump();
      expect(find.text('Free'), findsOneWidget);
      expect(find.text('Pro'), findsOneWidget);
      expect(find.text('Vault'), findsOneWidget);
    });

    testWidgets('the menu does not animate — drift 10', (WidgetTester t) async {
      await t.pumpWidget(select(null, (String _) {}));
      await t.tap(find.byType(DsSelect<String>));
      await t.pump();
      final Size opened = t.getSize(find.text('Free'));
      // One frame later, with no time elapsed, the menu is already whole.
      await t.pump();
      expect(t.getSize(find.text('Free')), opened);
    });

    testWidgets('a row is py-2 pl-3 pr-9 on a text-sm line box',
        (WidgetTester t) async {
      expect(DsSelect.itemHeight, closeTo(13 * (1.25 / 0.875) + 16, 0.001));

      await t.pumpWidget(select(null, (String _) {}));
      await t.tap(find.byType(DsSelect<String>));
      await t.pump();
      final Rect row = t.getRect(find.ancestor(
        of: find.text('Free'),
        matching: find.byType(Padding),
      ).first);
      // The `DsText` box is the CSS line box; the paragraph inside it is
      // shorter by the half-leading, so the padding is read off the former.
      final Rect text = t.getRect(find.ancestor(
        of: find.text('Free'),
        matching: find.byType(DsText),
      ));
      expect(text.left - row.left, 12);
      expect(row.right - text.right, closeTo(36, 0.001));
      expect(text.top - row.top, closeTo(8, 0.001));
    });

    testWidgets('the keyboard walks it and Enter commits',
        (WidgetTester t) async {
      String? picked;
      await t.pumpWidget(select(null, (String value) => picked = value));
      await t.tap(find.byType(DsSelect<String>));
      await t.pump();

      await t.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      await t.pump();
      expect(picked, 'pro');
      expect(find.text('Vault'), findsNothing, reason: 'committing closes');
    });

    testWidgets('Escape closes without choosing', (WidgetTester t) async {
      String? picked;
      await t.pumpWidget(select(null, (String value) => picked = value));
      await t.tap(find.byType(DsSelect<String>));
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await t.pump();
      expect(find.text('Vault'), findsNothing);
      expect(picked, isNull);
    });

    testWidgets('the content wears shadow-md under a 1px ring',
        (WidgetTester t) async {
      await t.pumpWidget(select(null, (String _) {}));
      await t.tap(find.byType(DsSelect<String>));
      await t.pump();
      final DsMachineSurface content = t.widget<DsMachineSurface>(
        find.byType(DsMachineSurface).last,
      );
      expect(content.spec.layers.skip(1).toList(), DsShadows.tailwindMd.layers);
      expect(content.spec.layers.first.spread, DsWidths.hairline);
      expect(content.radius, BorderRadius.circular(DsRadii.lg));
    });

    testWidgets('aria-invalid beats focus on the trigger too',
        (WidgetTester t) async {
      await t.pumpWidget(overlayHost(DsSelect<String>(
        options: options(),
        value: null,
        onChanged: (String _) {},
        invalid: true,
      )));
      final DsThemeData theme = themeIn(t, DsSelect<String>);
      await t.pumpAndSettle();
      // `Select` is the only control with `dark:` overrides on the invalid
      // state — `border-destructive/50` and `ring-destructive/40`.
      expect(borderOf(socketOf(t, DsSelect<String>)),
          theme.destructive.withValues(alpha: 0.50));
      expect(ringOf(socketOf(t, DsSelect<String>), theme).a,
          closeTo(0.40, 0.001));
    });

    testWidgets('dark is the only theme with a hover fill — drift 17/18',
        (WidgetTester t) async {
      await t.pumpWidget(overlayHost(
        DsSelect<String>(
          options: options(),
          value: null,
          onChanged: (String _) {},
        ),
        mode: DsThemeMode.light,
      ));
      final DsThemeData light = themeIn(t, DsSelect<String>);
      expect(socketOf(t, DsSelect<String>).fill, light.card);

      await t.pumpWidget(overlayHost(DsSelect<String>(
        options: options(),
        value: null,
        onChanged: (String _) {},
      )));
      final DsThemeData dark = themeIn(t, DsSelect<String>);
      await t.pump(DsDurations.base);
      expect(socketOf(t, DsSelect<String>).fill,
          dark.input.withValues(alpha: 0.30));
    });
  });

  group('DsAlert', () {
    testWidgets('every variant shares the surface and spends one colour',
        (WidgetTester t) async {
      await t.pumpWidget(host(const SizedBox(
        width: 448,
        child: DsAlert(title: 'Could not save', description: 'Try again.'),
      )));
      final DsThemeData theme = themeIn(t, DsAlert);
      const Map<DsAlertVariant, String> labels = <DsAlertVariant, String>{
        DsAlertVariant.normal: 'default',
        DsAlertVariant.destructive: 'destructive',
        DsAlertVariant.success: 'success',
        DsAlertVariant.warning: 'warning',
        DsAlertVariant.info: 'info',
      };
      expect(labels.length, DsAlertVariant.values.length);
      for (final MapEntry<DsAlertVariant, String> e in labels.entries) {
        expect(e.key.label, e.value);
      }
      expect(DsAlertVariant.normal.inkOf(theme), theme.mutedForeground);
      expect(DsAlertVariant.destructive.inkOf(theme), theme.destructiveInk);
      expect(DsAlertVariant.success.inkOf(theme), theme.successInk);
      expect(DsAlertVariant.warning.inkOf(theme), theme.warningInk);
      expect(DsAlertVariant.info.inkOf(theme), theme.infoInk);
    });

    testWidgets('16 / 14 padding on a 12px corner, 12px beside the glyph',
        (WidgetTester t) async {
      await t.pumpWidget(host(SizedBox(
        width: 448,
        child: DsAlert(
          variant: DsAlertVariant.destructive,
          icon: const DsIcon(DsIconGlyph.info),
          title: 'Could not save',
          description: 'That handle belongs to someone else.',
        ),
      )));
      final Rect alert = t.getRect(find.byType(DsAlert));
      final Rect icon = t.getRect(find.byType(DsIcon));
      // px-4 plus the 1px border.
      expect(icon.left - alert.left, closeTo(17, 0.001));
      // py-3.5 plus the border, plus the glyph's own translate-y-0.5.
      expect(icon.top - alert.top, closeTo(17, 0.001));

      final Rect title = t.getRect(find.text('Could not save'));
      expect(title.left - icon.right, closeTo(12, 0.001));
      expect(
        t.widget<DsBloomCosmic>(find.byType(DsBloomCosmic)).radius,
        BorderRadius.circular(DsRadii.lg),
      );
    });

    testWidgets('the title is 13/500 and the description 13 muted',
        (WidgetTester t) async {
      await t.pumpWidget(host(const SizedBox(
        width: 448,
        child: DsAlert(title: 'Could not save', description: 'Try again.'),
      )));
      final DsThemeData theme = themeIn(t, DsAlert);
      final DsText title = t.widget<DsText>(find.byType(DsText).first);
      expect(title.spec.size, 13);
      expect(title.spec.variations.first.value, 500);
      expect(title.color, theme.cardForeground);

      final DsText body = t.widget<DsText>(find.byType(DsText).last);
      expect(body.spec.size, 13);
      expect(body.spec.variations.first.value, 400);
      expect(body.color, theme.mutedForeground);
    });

    testWidgets('role="alert" is a live region', (WidgetTester t) async {
      final SemanticsHandle handle = t.ensureSemantics();
      await t.pumpWidget(host(const SizedBox(
        width: 448,
        child: DsAlert(title: 'Could not save'),
      )));
      expect(
        t.getSemantics(find.byType(DsAlert)).flagsCollection.isLiveRegion,
        isTrue,
      );
      handle.dispose();
    });
  });

  group('DsBloomCosmic', () {
    testWidgets('the blend and the void are the theme\'s, and they agree',
        (WidgetTester t) async {
      // Each ramp ends on the identity operand of its own blend, which is what
      // makes the gradients disappear instead of leaving an edge.
      expect(DsBloomCosmic.blendFor(DsThemeKind.dark), BlendMode.screen);
      expect(DsBloomCosmic.voidFor(DsThemeKind.dark).r, 0);
      expect(DsBloomCosmic.voidFor(DsThemeKind.dark).g, 0);
      expect(DsBloomCosmic.voidFor(DsThemeKind.dark).b, 0);

      expect(DsBloomCosmic.blendFor(DsThemeKind.light), BlendMode.multiply);
      expect(DsBloomCosmic.voidFor(DsThemeKind.light).r, 1);
      expect(DsBloomCosmic.voidFor(DsThemeKind.light).g, 1);
      expect(DsBloomCosmic.voidFor(DsThemeKind.light).b, 1);
    });

    testWidgets('the named pairs are the declarations they transcribe',
        (WidgetTester t) async {
      await t.pumpWidget(host(const SizedBox.shrink()));
      final DsThemeData theme = DsTheme.of(t.element(find.byType(Center)));
      final BorderRadius r = BorderRadius.circular(DsRadii.lg);
      const Widget child = SizedBox.shrink();

      final DsBloomCosmic action =
          DsBloomCosmic.action(radius: r, fill: theme.card, child: child);
      expect(action.bloom1(theme), DsPalette.actionBright);
      expect(action.bloom2(theme), DsPalette.action);

      final DsBloomCosmic destructive =
          DsBloomCosmic.destructive(radius: r, fill: theme.card, child: child);
      expect(destructive.bloom1(theme), theme.destructive);
      expect(destructive.bloom2(theme), DsPalette.action);

      final DsBloomCosmic success =
          DsBloomCosmic.success(radius: r, fill: theme.card, child: child);
      expect(success.bloom1(theme), DsPalette.success);
      expect(success.bloom2(theme), DsPalette.value);

      // DRIFT: the Alert's warning was moved off the value ramp and the
      // toast's never was.
      final DsBloomCosmic warning =
          DsBloomCosmic.warning(radius: r, fill: theme.card, child: child);
      expect(warning.bloom1(theme), DsPalette.warning);
      expect(warning.bloom2(theme), DsPalette.action);

      final DsBloomCosmic toastWarning =
          DsBloomCosmic.toastWarning(radius: r, fill: theme.card, child: child);
      expect(toastWarning.bloom1(theme), DsPalette.valueBright);
      expect(toastWarning.bloom2(theme), DsPalette.valueDark);
    });
  });

  group('DsToast', () {
    testWidgets('356 wide, 16 of padding, 12 beside the glyph, on e3',
        (WidgetTester t) async {
      expect(DsToaster.width, 356);
      expect(DsToaster.gap, 14);
      expect(DsToaster.viewportOffset, 24);
      expect(DsToaster.visibleLimit, 3);
      expect(DsToaster.lifetime, const Duration(seconds: 4));

      await t.pumpWidget(host(SizedBox(
        width: DsToaster.width,
        child: const DsToast(
          message: DsToastMessage(
            title: 'Saved as @ayoub',
            type: DsToastType.info,
          ),
        ),
      )));
      final DsMachineSurface surface =
          t.widget<DsMachineSurface>(find.byType(DsMachineSurface));
      expect(surface.spec.layers, DsShadows.e3.layers);
      expect(surface.radius, BorderRadius.circular(DsRadii.lg));

      final Rect toast = t.getRect(find.byType(DsToast));
      final Rect icon = t.getRect(find.byType(DsIcon));
      expect(toast.width, 356);
      // padding 16 + border 1.
      expect(icon.left - toast.left, closeTo(17, 0.001));
      // …and the glyph's own 2px optical nudge on top.
      expect(icon.top - toast.top, closeTo(19, 0.001));
      expect(t.getRect(find.text('Saved as @ayoub')).left - icon.right,
          closeTo(12, 0.001));
    });

    testWidgets('the glyph carries the only colour, and it is an -ink token',
        (WidgetTester t) async {
      await t.pumpWidget(host(const SizedBox.shrink()));
      final DsThemeData theme = DsTheme.of(t.element(find.byType(Center)));
      expect(DsToastType.success.inkOf(theme), theme.successInk);
      expect(DsToastType.error.inkOf(theme), theme.destructiveInk);
      expect(DsToastType.warning.inkOf(theme), theme.warningInk);
      expect(DsToastType.info.inkOf(theme), theme.infoInk);
      expect(DsToastType.loading.inkOf(theme), theme.actionInk);
      expect(DsToastType.normal.inkOf(theme), theme.mutedForeground);
      expect(DsToastType.normal.label, 'default');
    });

    testWidgets('KNOWN GAP: two lucide glyphs are not in the package yet',
        (WidgetTester t) async {
      // `icon_paths.dart` is another task's file this wave; the map records
      // `CircleCheck` and `OctagonX` as owed. A call site can supply them.
      expect(DsToastType.info.glyph, DsIconGlyph.info);
      expect(DsToastType.warning.glyph, DsIconGlyph.alertTriangle);
      expect(DsToastType.loading.glyph, DsIconGlyph.loaderCircle);
      expect(DsToastType.success.glyph, isNull);
      expect(DsToastType.error.glyph, isNull);

      await t.pumpWidget(host(SizedBox(
        width: DsToaster.width,
        child: const DsToast(
          message: DsToastMessage(
            title: 'Saved',
            type: DsToastType.success,
            glyph: DsIconGlyph.check,
          ),
        ),
      )));
      expect(find.byType(DsIcon), findsOneWidget);
    });
  });

  // The Slot merge, on the four controls that are not an `<input>`.
  //
  // `FormControl` is a `Slot`: it stamps `id`, `aria-invalid` and
  // `aria-describedby` onto whatever it wraps — *"input, trigger, switch or
  // checkbox alike"*. Flutter's analogue is context, so each of these reads
  // `DsFieldScope` and lets its own props win where both speak.
  group('DsFieldScope adoption', () {
    /// A control inside a field that says everything a field can say.
    Widget inField(Widget control, {required FocusNode node, bool valid = false}) =>
        host(SizedBox(
          width: 448,
          child: DsField(
            label: 'Price alerts',
            description: 'Receipts and nothing else.',
            errors: valid ? const <String>[] : const <String>['Pick one.'],
            enabled: false,
            focusNode: node,
            child: control,
          ),
        ));

    /// What the control passes into its own [Semantics].
    ///
    /// Read off the widget rather than the semantics tree: a control's
    /// annotation sits *inside* its [DsHitArea] (the expander has to be
    /// outermost, or a pointer in the pseudo-element's margin is rejected
    /// before it arrives), so walking up from the control's own render object
    /// lands on the field's container node instead of on this one.
    SemanticsProperties announced(WidgetTester t, Finder of) => t
        .widgetList<Semantics>(
            find.descendant(of: of, matching: find.byType(Semantics)))
        .first
        .properties;

    /// Whether the enclosing field's node is the one the control's own [Focus]
    /// carries — which is what makes `DsForm.focusFirstError` land on it.
    bool adopted(WidgetTester t, Finder of, FocusNode node) => t
        .widgetList<Focus>(find.descendant(of: of, matching: find.byType(Focus)))
        .any((Focus f) => identical(f.focusNode, node));

    testWidgets('DsCheckbox takes label, description, enabled, invalid, node',
        (WidgetTester t) async {
      final SemanticsHandle semantics = t.ensureSemantics();
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);

      await t.pumpWidget(inField(
        const DsCheckbox(state: DsCheckboxState.unchecked),
        node: node,
      ));
      await t.pumpAndSettle();
      final DsThemeData theme = themeIn(t, DsCheckbox);

      final SemanticsProperties said = announced(t, find.byType(DsCheckbox));
      expect(said.label!, contains('Price alerts'));
      expect(said.hint!, contains('Receipts and nothing else.'));
      expect(said.hint!, contains('Pick one.'),
          reason: 'description then error, in the order the id list encodes');

      // `data-[disabled=true]` on the field disables the control, and the
      // control cannot opt back in.
      expect(
        t
            .widget<Opacity>(find
                .descendant(
                    of: find.byType(DsCheckbox), matching: find.byType(Opacity))
                .first)
            .opacity,
        0.50,
      );
      // `aria-invalid` reaches the paint, not only the field's own container.
      expect(borderOf(socketOf(t, DsCheckbox)), theme.destructive);
      expect(adopted(t, find.byType(DsCheckbox), node), isTrue);
      semantics.dispose();
    });

    testWidgets('DsSwitch takes label, description, enabled, invalid, node',
        (WidgetTester t) async {
      final SemanticsHandle semantics = t.ensureSemantics();
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);

      await t.pumpWidget(inField(const DsSwitch(value: false), node: node));
      await t.pumpAndSettle();
      final DsThemeData theme = themeIn(t, DsSwitch);

      final SemanticsProperties said = announced(t, find.byType(DsSwitch));
      expect(said.label!, contains('Price alerts'));
      expect(said.hint!, contains('Receipts and nothing else.'));
      expect(borderOf(socketOf(t, DsSwitch)), theme.destructive);
      expect(
        t
            .widget<Opacity>(find
                .descendant(
                    of: find.byType(DsSwitch), matching: find.byType(Opacity))
                .first)
            .opacity,
        0.50,
      );
      expect(adopted(t, find.byType(DsSwitch), node), isTrue);
      semantics.dispose();
    });

    testWidgets('DsSelect takes label, description, enabled, invalid, node',
        (WidgetTester t) async {
      final SemanticsHandle semantics = t.ensureSemantics();
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);

      await t.pumpWidget(host(SizedBox(
        width: 448,
        child: DsField(
          label: 'Plan',
          description: 'Pick one you can afford.',
          errors: const <String>['Pick a plan.'],
          enabled: false,
          focusNode: node,
          child: DsSelect<String>(
            options: const <DsSelectOption<String>>[
              DsSelectOption<String>(value: 'free', label: 'Free'),
            ],
            value: null,
            onChanged: (String _) {},
            placeholder: 'Choose a plan',
            expand: true,
          ),
        ),
      )));
      await t.pumpAndSettle();
      final DsThemeData theme = themeIn(t, DsSelect<String>);

      final SemanticsProperties said =
          announced(t, find.byType(DsSelect<String>));
      expect(said.label!, contains('Plan'));
      expect(said.hint!, contains('Pick one you can afford.'));
      expect(said.hint!, contains('Pick a plan.'));
      // Dark substitutes `border-destructive/50` for the opaque border.
      expect(borderOf(socketOf(t, DsSelect<String>)),
          theme.destructive.withValues(alpha: 0.50));
      expect(adopted(t, find.byType(DsSelect<String>), node), isTrue);
      semantics.dispose();
    });

    testWidgets('DsRadioGroup takes the legend and the node; items take the rest',
        (WidgetTester t) async {
      final SemanticsHandle semantics = t.ensureSemantics();
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);

      await t.pumpWidget(host(SizedBox(
        width: 448,
        child: DsField(
          label: 'Payout rhythm',
          description: 'How often you get paid.',
          errors: const <String>['Pick a payout rhythm.'],
          focusNode: node,
          child: DsRadioGroup<String>(
            value: null,
            onChanged: (String _) {},
            children: const <Widget>[
              DsRadioGroupItem<String>(value: 'daily', label: 'Daily'),
              DsRadioGroupItem<String>(value: 'weekly', label: 'Weekly'),
            ],
          ),
        ),
      )));
      await t.pumpAndSettle();
      final DsThemeData theme = themeIn(t, DsRadioGroupItem<String>);

      // `FormControl` wraps the RadioGroup, not the items, so the legend and
      // the description are announced on the group.
      final SemanticsProperties group =
          announced(t, find.byType(DsRadioGroup<String>));
      expect(group.label!, contains('Payout rhythm'));
      expect(group.hint!, contains('How often you get paid.'));
      expect(group.hint!, contains('Pick a payout rhythm.'));

      // …while each item keeps its own name, never the legend.
      expect(announced(t, find.byType(DsRadioGroupItem<String>).at(0)).label,
          'Daily');
      expect(announced(t, find.byType(DsRadioGroupItem<String>).at(1)).label,
          'Weekly');

      // The group's `aria-invalid` paints on every item.
      expect(borderOf(socketOf(t, DsRadioGroupItem<String>)), theme.destructive);

      // The field's node lands on the group and never on two Focus widgets at
      // once — the group holds it and passes the focus to the tab stop.
      expect(adopted(t, find.byType(DsRadioGroup<String>), node), isTrue);
      node.requestFocus();
      await t.pumpAndSettle();
      // `hasFocus` stays true — the item is a descendant of this node — but the
      // group never keeps the focus itself.
      expect(node.hasPrimaryFocus, isFalse,
          reason: 'the group hands the focus straight on');
      expect(
        t
            .widgetList<Focus>(find.descendant(
                of: find.byType(DsRadioGroupItem<String>).at(0),
                matching: find.byType(Focus)))
            .any((Focus f) => f.focusNode?.hasPrimaryFocus ?? false),
        isTrue,
        reason: 'the first enabled item is the roving tab stop',
      );
      semantics.dispose();
    });

    testWidgets('a disabled field disables its radio items',
        (WidgetTester t) async {
      int changes = 0;
      await t.pumpWidget(host(SizedBox(
        width: 448,
        child: DsField(
          label: 'Payout rhythm',
          enabled: false,
          child: DsRadioGroup<String>(
            value: null,
            onChanged: (String _) => changes++,
            children: const <Widget>[
              DsRadioGroupItem<String>(value: 'daily', label: 'Daily'),
            ],
          ),
        ),
      )));
      await t.tap(find.byType(DsRadioGroupItem<String>), warnIfMissed: false);
      expect(changes, 0);
      expect(
        t
            .widget<Opacity>(find
                .descendant(
                    of: find.byType(DsRadioGroupItem<String>),
                    matching: find.byType(Opacity))
                .first)
            .opacity,
        0.50,
      );
    });

    testWidgets('DsForm.focusFirstError lands on a checkbox — ruling F4',
        (WidgetTester t) async {
      // The composed form's `terms`: the reference cannot focus it at all,
      // because a hand-wired Checkbox exposes no ref for `shouldFocusError` to
      // call (forms-map drift 7). Here it is a field like any other.
      //
      // Both orientations, because the composed form's `terms` is a
      // **horizontal** field and that branch once published no `DsFieldScope`
      // at all — it put its raw `child` in the Row where the vertical branch
      // put the scope-wrapped control, so the checkbox adopted nothing and a
      // failed submit focused nothing. Fixed in `field.dart`; asserted on both
      // branches here so the shape this ruling is about is the shape that is
      // measured.
      for (final DsFieldOrientation orientation in DsFieldOrientation.values) {
        final DsFormField<bool> terms = DsFormField<bool>(
          name: 'terms',
          initialValue: false,
          rules: <DsRule<bool>>[
            const DsRule<bool>(_accepted, 'You have to accept the terms.'),
          ],
        );
        final DsForm form = DsForm(fields: <DsFormFieldBase>[terms]);
        addTearDown(form.dispose);

        await t.pumpWidget(host(SizedBox(
          width: 448,
          child: ListenableBuilder(
            listenable: form,
            builder: (BuildContext context, Widget? _) => DsField(
              key: ValueKey<DsFieldOrientation>(orientation),
              label: 'I accept the terms',
              errors: terms.errors,
              focusNode: terms.focusNode,
              orientation: orientation,
              child: DsCheckbox(
                state: terms.value
                    ? DsCheckboxState.checked
                    : DsCheckboxState.unchecked,
                onChanged: (DsCheckboxState next) =>
                    terms.value = next == DsCheckboxState.checked,
              ),
            ),
          ),
        )));

        final String why = orientation.name;
        expect(terms.focusNode.hasFocus, isFalse, reason: why);
        await form.submit();
        await t.pumpAndSettle();

        expect(terms.errors, <String>['You have to accept the terms.'],
            reason: why);
        expect(terms.focusNode.hasFocus, isTrue, reason: why);
        expect(adopted(t, find.byType(DsCheckbox), terms.focusNode), isTrue,
            reason: '$why: the node a failed submit focuses IS the '
                'checkbox\'s own');
      }
    });
  });

  // `<label for>` ACTIVATES its control — it does not merely focus it. Each
  // control registers what activating it means on the scope's
  // `DsFieldActivator`, and `DsFieldLabel` reads that at tap time.
  //
  // Every case below taps a **real** `DsFieldLabel` inside a **real**
  // `DsField`, wrapped around the real control, so the pair is what is
  // measured rather than either half against a stub.
  group('DsFieldLabel activation', () {
    /// Taps the visible label text, which is what a reader clicks.
    Future<void> tapLabel(WidgetTester t, String text) async {
      await t.tap(find.text(text));
      await t.pump();
    }

    testWidgets('a label tap ticks a real DsCheckbox', (WidgetTester t) async {
      DsCheckboxState state = DsCheckboxState.unchecked;
      await t.pumpWidget(host(SizedBox(
        width: 448,
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) => DsField(
            label: 'I accept the terms',
            orientation: DsFieldOrientation.horizontal,
            child: DsCheckbox(
              state: state,
              onChanged: (DsCheckboxState next) =>
                  setState(() => state = next),
            ),
          ),
        ),
      )));

      await tapLabel(t, 'I accept the terms');
      expect(state, DsCheckboxState.checked,
          reason: 'the label activated, it did not merely focus');

      // …and back again: activation is the toggle, not "set true".
      await tapLabel(t, 'I accept the terms');
      expect(state, DsCheckboxState.unchecked);
      await t.pumpAndSettle();
    });

    testWidgets('a label tap flips a real DsSwitch', (WidgetTester t) async {
      bool on = false;
      await t.pumpWidget(host(SizedBox(
        width: 448,
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) => DsField(
            label: 'Price alerts',
            orientation: DsFieldOrientation.horizontal,
            child: DsSwitch(
              value: on,
              onChanged: (bool next) => setState(() => on = next),
            ),
          ),
        ),
      )));

      await tapLabel(t, 'Price alerts');
      expect(on, isTrue);
      await tapLabel(t, 'Price alerts');
      expect(on, isFalse);
      await t.pumpAndSettle();
    });

    testWidgets('a label tap opens a real DsSelect', (WidgetTester t) async {
      await t.pumpWidget(overlayHost(SizedBox(
        width: 448,
        child: DsField(
          label: 'Plan',
          child: DsSelect<String>(
            options: const <DsSelectOption<String>>[
              DsSelectOption<String>(value: 'free', label: 'Free'),
              DsSelectOption<String>(value: 'pro', label: 'Pro'),
            ],
            value: null,
            onChanged: (String _) {},
            placeholder: 'Choose a plan',
            expand: true,
          ),
        ),
      )));
      expect(find.text('Free'), findsNothing);

      await tapLabel(t, 'Plan');
      expect(find.text('Free'), findsOneWidget);
      expect(find.text('Pro'), findsOneWidget);
      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await t.pumpAndSettle();
    });

    testWidgets('a legend tap focuses the radio tab stop and selects nothing',
        (WidgetTester t) async {
      String? value;
      await t.pumpWidget(host(SizedBox(
        width: 448,
        child: DsField(
          label: 'Payout rhythm',
          child: DsRadioGroup<String>(
            value: value,
            onChanged: (String next) => value = next,
            children: const <Widget>[
              DsRadioGroupItem<String>(value: 'daily', label: 'Daily'),
              DsRadioGroupItem<String>(value: 'weekly', label: 'Weekly'),
            ],
          ),
        ),
      )));

      await tapLabel(t, 'Payout rhythm');
      await t.pumpAndSettle();

      // Focus moved to the item the roving tabindex is on…
      expect(
        t
            .widgetList<Focus>(find.descendant(
                of: find.byType(DsRadioGroupItem<String>).at(0),
                matching: find.byType(Focus)))
            .any((Focus f) => f.focusNode?.hasPrimaryFocus ?? false),
        isTrue,
      );
      // …and the selection is untouched, which is what `<label for>` does to a
      // radiogroup. Selecting here would be a behaviour the web does not have.
      expect(value, isNull);
    });

    testWidgets('a per-radio label selects that radio', (WidgetTester t) async {
      // The reference's other shape: one labelled field per option, where
      // `<label for="payout-daily">` selects that radio outright.
      String? value;
      await t.pumpWidget(host(SizedBox(
        width: 448,
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) =>
              DsRadioGroup<String>(
            value: value,
            onChanged: (String next) => setState(() => value = next),
            children: const <Widget>[
              DsField(
                label: 'Daily',
                orientation: DsFieldOrientation.horizontal,
                child: DsRadioGroupItem<String>(value: 'daily'),
              ),
              DsField(
                label: 'Weekly',
                orientation: DsFieldOrientation.horizontal,
                child: DsRadioGroupItem<String>(value: 'weekly'),
              ),
            ],
          ),
        ),
      )));

      await tapLabel(t, 'Weekly');
      expect(value, 'weekly');
      await t.pumpAndSettle();
    });

    testWidgets('a disabled field registers nothing', (WidgetTester t) async {
      DsCheckboxState state = DsCheckboxState.unchecked;
      await t.pumpWidget(host(SizedBox(
        width: 448,
        child: DsField(
          label: 'I accept the terms',
          enabled: false,
          orientation: DsFieldOrientation.horizontal,
          child: DsCheckbox(
            state: state,
            onChanged: (DsCheckboxState next) => state = next,
          ),
        ),
      )));

      await t.tap(find.text('I accept the terms'), warnIfMissed: false);
      await t.pump();
      expect(state, DsCheckboxState.unchecked,
          reason: 'a stale toggle must not outlive the state that allowed it');
    });
  });

  // The three cells a state MATRIX renders and a real form never asks for —
  // ruling S4.
  //
  // `<Checkbox checked="indeterminate"/>` with no `onCheckedChange`, the two
  // `className="border-ring ring-3 ring-ring/50"` fakes, and
  // `<FieldLabel className="font-normal">`. Each is a documented package prop
  // rather than something the page fakes locally, because `selects` and
  // `feedback` render the same three cells again.
  group('Matrix-only states — ruling S4', () {
    /// The control's **own** [Focus] — the one carrying a key handler, which
    /// the `Visibility` wrappers inside a mounted indicator do not have.
    Focus controlFocus(WidgetTester t, Type of) => t
        .widgetList<Focus>(
            find.descendant(of: find.byType(of), matching: find.byType(Focus)))
        .firstWhere((Focus f) => f.onKeyEvent != null);

    /// `disabled:opacity-50` / `data-disabled:opacity-50`, as the socket dims.
    double opacityOf(WidgetTester t) => t
        .widget<Opacity>(find
            .descendant(
                of: find.byType(DsCheckbox), matching: find.byType(Opacity))
            .first)
        .opacity;

    /// Whether a pointer reaches the control at all.
    bool ignoresPointer(WidgetTester t) => t
        .widget<IgnorePointer>(find
            .descendant(
                of: find.byType(DsCheckbox), matching: find.byType(IgnorePointer))
            .first)
        .ignoring;

    /// What the control hands its own [Semantics] — read off the widget for the
    /// reason the adoption group records: the annotation sits *inside*
    /// [DsHitArea], so walking the semantics tree lands somewhere else.
    SemanticsProperties announced(WidgetTester t, Finder of) => t
        .widgetList<Semantics>(
            find.descendant(of: of, matching: find.byType(Semantics)))
        .first
        .properties;

    /// A checkbox whose focus this test owns, so "has the focus" and "is
    /// painted as though it had the focus" can be told apart.
    Widget ringBox(FocusNode node, {bool? force, bool invalid = false}) =>
        host(DsCheckbox(
          focusNode: node,
          forceFocusRing: force,
          invalid: invalid,
          onChanged: (DsCheckboxState _) {},
        ));

    testWidgets('operable, inert and disabled are three distinct states',
        (WidgetTester t) async {
      // Measured on the reference's Indeterminate cell: `disabled: false`,
      // `opacity: 1` — and measured in this tree BEFORE the flag existed:
      // opacity already 1.0, IgnorePointer already true, but
      // `Focus.canRequestFocus` FALSE. Focusability was the only real gap, and
      // this table is what pins all three states apart.
      //
      // Every case is handed a live `onChanged`, so `inert` is measured
      // *beating* a handler rather than merely coinciding with a missing one.
      const List<
          ({
            String name,
            bool enabled,
            bool inert,
            double opacity,
            bool focusable,
            bool operable,
          })> cases = <({
        String name,
        bool enabled,
        bool inert,
        double opacity,
        bool focusable,
        bool operable,
      })>[
        (
          name: 'operable',
          enabled: true,
          inert: false,
          opacity: 1,
          focusable: true,
          operable: true,
        ),
        (
          name: 'inert',
          enabled: true,
          inert: true,
          opacity: 1,
          focusable: true,
          operable: false,
        ),
        (
          name: 'disabled',
          enabled: false,
          inert: false,
          opacity: 0.50,
          focusable: false,
          operable: false,
        ),
      ];

      for (final ({
            String name,
            bool enabled,
            bool inert,
            double opacity,
            bool focusable,
            bool operable,
          }) c in cases) {
        final FocusNode node = FocusNode(debugLabel: c.name);
        addTearDown(node.dispose);
        int taps = 0;
        final String why = c.name;

        await t.pumpWidget(host(DsCheckbox(
          key: ValueKey<String>(c.name),
          state: DsCheckboxState.indeterminate,
          enabled: c.enabled,
          inert: c.inert,
          focusNode: node,
          onChanged: (DsCheckboxState _) => taps++,
        )));
        await t.pumpAndSettle();

        expect(opacityOf(t), c.opacity,
            reason: '$why: only `disabled` dims — a control held at a value is '
                'painted at full strength');
        expect(ignoresPointer(t), !c.operable,
            reason: '$why: anything that cannot be operated is deaf to a '
                'pointer');
        expect(controlFocus(t, DsCheckbox).canRequestFocus, c.focusable,
            reason: '$why: `disabled` leaves the tab order and a missing '
                'handler does not');

        node.requestFocus();
        await t.pump();
        expect(node.hasPrimaryFocus, c.focusable,
            reason: '$why: and the flag is not merely declared — the focus '
                'either lands or it does not');

        await t.tap(find.byType(DsCheckbox), warnIfMissed: false);
        await t.pump();
        expect(taps, c.operable ? 1 : 0,
            reason: '$why: a click on an inert box changes nothing, exactly as '
                'a controlled Radix checkbox with no handler does');

        // The keyboard says the same thing the pointer does — which matters
        // most for the inert case, the one control here that can be focused
        // and still must not answer Space.
        await t.sendKeyEvent(LogicalKeyboardKey.space);
        await t.pump();
        expect(taps, c.operable ? 2 : 0,
            reason: '$why: Enter and Space follow operability, not focus');
        await t.pumpAndSettle();
      }
    });

    testWidgets('the Indeterminate cell is announced as an enabled checkbox',
        (WidgetTester t) async {
      // `<Checkbox checked="indeterminate" aria-label="Indeterminate"/>`:
      // controlled, no `onCheckedChange`, and — the point — no `disabled`.
      final SemanticsHandle semantics = t.ensureSemantics();
      await t.pumpWidget(host(const DsCheckbox(
        state: DsCheckboxState.indeterminate,
        inert: true,
        label: 'Indeterminate',
      )));
      await t.pumpAndSettle();

      final SemanticsProperties said = announced(t, find.byType(DsCheckbox));
      expect(said.enabled, isTrue,
          reason: 'the reference measures `disabled: false`; DRIFT 7 is that '
              'assistive technology is told no more than a reader is');
      expect(said.mixed, isTrue, reason: 'data-state="indeterminate"');
      expect(said.checked, isFalse);
      expect(said.label, 'Indeterminate');

      // …against the state it must not be confused with.
      await t.pumpWidget(host(const DsCheckbox(
        state: DsCheckboxState.indeterminate,
        enabled: false,
        label: 'Disabled',
      )));
      await t.pumpAndSettle();
      expect(announced(t, find.byType(DsCheckbox)).enabled, isFalse,
          reason: '`disabled` is announced, and inert is not');
      semantics.dispose();
    });

    testWidgets('an inert box registers no activation on its field label',
        (WidgetTester t) async {
      // `<label for>` activates the control it points at — and a control Radix
      // holds at a value has no activation to offer, so the words are inert
      // too.
      DsCheckboxState state = DsCheckboxState.indeterminate;
      await t.pumpWidget(host(SizedBox(
        width: 448,
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) => DsField(
            label: 'Partial bulk selection',
            orientation: DsFieldOrientation.horizontal,
            child: DsCheckbox(
              state: state,
              inert: true,
              onChanged: (DsCheckboxState next) => setState(() => state = next),
            ),
          ),
        ),
      )));

      await t.tap(find.text('Partial bulk selection'), warnIfMissed: false);
      await t.pump();
      expect(state, DsCheckboxState.indeterminate,
          reason: 'the box is held at its prop value from every direction');
      await t.pumpAndSettle();
    });

    testWidgets('forceFocusRing paints a ring nothing is focused for',
        (WidgetTester t) async {
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);

      await t.pumpWidget(ringBox(node, force: true));
      final DsThemeData theme = themeIn(t, DsCheckbox);
      await t.pumpAndSettle();
      expect(node.hasPrimaryFocus, isFalse,
          reason: 'the cell is a lie painted with class names — nothing on the '
              'reference page has the focus either');
      expect(borderOf(socketOf(t, DsCheckbox)), theme.ring,
          reason: '`border-ring`, with tw-merge having deleted `border-input` '
              'from the string outright');
      expect(ringOf(socketOf(t, DsCheckbox), theme).a, closeTo(0.50, 0.001),
          reason: '`ring-3 ring-ring/50`');

      // `false` withholds the ring from a control that genuinely has the focus.
      await t.pumpWidget(ringBox(node, force: false));
      node.requestFocus();
      await t.pumpAndSettle();
      expect(node.hasPrimaryFocus, isTrue, reason: 'the focus is real here');
      expect(borderOf(socketOf(t, DsCheckbox)), theme.input,
          reason: 'and the socket is still at rest');
      expect(ringOf(socketOf(t, DsCheckbox), theme).a, closeTo(0, 0.001),
          reason: 'the resting ring is the hue at zero alpha, and a 3px spread '
              'of nothing paints nothing');

      // `null` — the default — follows the real focus, in both directions.
      await t.pumpWidget(ringBox(node));
      await t.pumpAndSettle();
      expect(borderOf(socketOf(t, DsCheckbox)), theme.ring,
          reason: 'still focused, and now the ring is allowed to say so');
      expect(ringOf(socketOf(t, DsCheckbox), theme).a, closeTo(0.50, 0.001));

      node.unfocus();
      await t.pumpAndSettle();
      expect(borderOf(socketOf(t, DsCheckbox)), theme.input,
          reason: 'and back to rest when the focus leaves');
    });

    testWidgets('aria-invalid still beats a forced ring — F5 order kept',
        (WidgetTester t) async {
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);

      await t.pumpWidget(ringBox(node, force: true, invalid: true));
      final DsThemeData theme = themeIn(t, DsCheckbox);
      await t.pumpAndSettle();
      expect(borderOf(socketOf(t, DsCheckbox)), theme.destructive,
          reason: 'the invalid branch is tested first in both colour targets, '
              'so a forced ring is as invisible as a real focus is');
      expect(ringOf(socketOf(t, DsCheckbox), theme),
          theme.destructive.withValues(alpha: 0.20),
          reason: '`aria-invalid:ring-3 ring-destructive/20`');
    });

    testWidgets('the radio matrix gets the same painted ring',
        (WidgetTester t) async {
      // The second of the page's two fakes, and the reason the flag exists at
      // all: Flutter has exactly one focus and this page renders two focused
      // controls.
      await t.pumpWidget(host(SizedBox(
        width: 200,
        child: DsRadioGroup<String>(
          value: null,
          onChanged: (String _) {},
          children: const <Widget>[
            DsRadioGroupItem<String>(
              value: 'a',
              forceFocusRing: true,
              label: 'Focus',
            ),
          ],
        ),
      )));
      final DsThemeData theme = themeIn(t, DsRadioGroupItem<String>);
      await t.pumpAndSettle();
      expect(borderOf(socketOf(t, DsRadioGroupItem<String>)), theme.ring,
          reason: 'the item wears `border-ring` with nothing focused');
      expect(ringOf(socketOf(t, DsRadioGroupItem<String>), theme).a,
          closeTo(0.50, 0.001),
          reason: '`ring-3 ring-ring/50`, character-identical to the checkbox '
              'cell');
    });

    testWidgets('DsFieldLabel takes a spec, and `normal` is font-normal',
        (WidgetTester t) async {
      // `<FieldLabel htmlFor={…} className="font-normal">` — probed on the
      // filter list at 13px, a 17.875px line box, weight 400, `--foreground`.
      expect(DsFieldLabel.normal.family, DsComponentType.fieldLabel.family);
      expect(DsFieldLabel.normal.size, DsComponentType.fieldLabel.size,
          reason: '`font-normal` declares one property: `text-sm` survives it');
      expect(DsFieldLabel.normal.height, DsComponentType.fieldLabel.height,
          reason: '…and so does `leading-snug`, which is the whole point');
      expect(DsFieldLabel.normal.variations.first.value,
          DsComponentType.textSm.variations.first.value,
          reason: 'the weight is borrowed from the token that already records '
              'the 400 `html` gives, never typed into this layer');

      await t.pumpWidget(host(SizedBox(
        width: 448,
        child: DsFieldLabel('Available now', spec: DsFieldLabel.normal),
      )));
      final TextStyle overridden =
          t.widget<Text>(find.text('Available now')).style!;
      expect(overridden.fontWeight, FontWeight.w400,
          reason: 'the resolved style, read off the tree');
      expect(overridden.fontSize, 13);
      expect(overridden.height, closeTo(1.375, 0.000001));
      expect(t.getSize(find.byType(DsText)).height, closeTo(17.875, 0.001),
          reason: 'the probed line box: 13 × 1.375');

      // …and the default is what `Label` types itself in, unchanged.
      await t.pumpWidget(host(const SizedBox(
        width: 448,
        child: DsFieldLabel('Available now'),
      )));
      final TextStyle byDefault =
          t.widget<Text>(find.text('Available now')).style!;
      expect(byDefault.fontWeight, FontWeight.w500,
          reason: '`Label`\'s own `font-medium`, with nothing overriding it');
      expect(byDefault.fontSize, overridden.fontSize,
          reason: 'and the two differ in nothing but the weight');
      expect(byDefault.height, overridden.height);
    });
  });

  group('DsToaster', () {
    Widget toaster(DsToastController controller) => host(
          SizedBox(
            width: 1440,
            height: 900,
            child: DsToaster(controller: controller),
          ),
        );

    testWidgets('shows nothing until something is queued',
        (WidgetTester t) async {
      final DsToastController controller = DsToastController();
      addTearDown(controller.dispose);
      await t.pumpWidget(toaster(controller));
      expect(find.byType(DsToast), findsNothing);

      controller.success('Saved as @ayoub', glyph: DsIconGlyph.check);
      await t.pump();
      expect(find.byType(DsToast), findsOneWidget);
      expect(find.text('Saved as @ayoub'), findsOneWidget);
      await t.pump(DsToaster.lifetime);
      await t.pump(DsToaster.unmountDelay);
      expect(find.byType(DsToast), findsNothing);
    });

    testWidgets('three are visible and the rest queue',
        (WidgetTester t) async {
      final DsToastController controller = DsToastController();
      addTearDown(controller.dispose);
      await t.pumpWidget(toaster(controller));
      for (int i = 0; i < 5; i++) {
        controller.error('Could not claim that handle $i',
            glyph: DsIconGlyph.x);
      }
      await t.pump();
      expect(controller.length, 5);
      expect(controller.visibleCount, 3);
      expect(find.byType(DsToast), findsNWidgets(3));
      // Newest sits closest to the corner.
      expect(find.text('Could not claim that handle 4'), findsOneWidget);
      expect(find.text('Could not claim that handle 0'), findsNothing);
      controller.clear();
      await t.pump();
    });

    testWidgets('a tap dismisses over the unmount window',
        (WidgetTester t) async {
      final DsToastController controller = DsToastController();
      addTearDown(controller.dispose);
      await t.pumpWidget(toaster(controller));
      controller.success('Preferences saved', glyph: DsIconGlyph.check);
      await t.pump();

      await t.tap(find.byType(DsToast));
      await t.pump();
      // Still mounted, on its way out.
      expect(find.byType(DsToast), findsOneWidget);
      await t.pump(DsToaster.unmountDelay);
      expect(find.byType(DsToast), findsNothing);
      expect(controller.length, 0);
    });

    testWidgets('anchors bottom-right, 24px in', (WidgetTester t) async {
      final DsToastController controller = DsToastController();
      addTearDown(controller.dispose);
      await t.pumpWidget(toaster(controller));
      controller.success('Account saved', glyph: DsIconGlyph.check);
      await t.pump();

      final Rect frame = t.getRect(find.byType(DsToaster));
      final Rect toast = t.getRect(find.byType(DsToast));
      expect(frame.right - toast.right, 24);
      expect(frame.bottom - toast.bottom, 24);
      controller.clear();
      await t.pump();
    });
  });
}
