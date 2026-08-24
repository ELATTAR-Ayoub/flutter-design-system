import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Selection and feedback: the three toggles, the select, the alert and the
/// toast host. One state matrix each, pinned against `forms-map.md` and the six
/// reference sources it cites.

Widget host(Widget child, {ElThemeMode mode = ElThemeMode.dark}) {
  return MediaQuery(
    data: const MediaQueryData(size: Size(1440, 900)),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: ElTheme(
        controller: ElThemeController(mode: mode),
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
Widget overlayHost(Widget child, {ElThemeMode mode = ElThemeMode.dark}) {
  _hosted = child;
  return MediaQuery(
    data: const MediaQueryData(size: Size(1440, 900)),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: ElTheme(
        controller: ElThemeController(mode: mode),
        child: Overlay(
          initialEntries: <OverlayEntry>[
            OverlayEntry(builder: (BuildContext _) => Center(child: _hosted)),
          ],
        ),
      ),
    ),
  );
}

ElThemeData themeIn(WidgetTester t, Type of) =>
    ElTheme.of(t.element(find.byType(of).first));

/// The socket a control paints — the first [ElMachineSurface] inside it, which
/// is the control's own surface rather than an indicator's.
ElMachineSurface socketOf(WidgetTester t, Type of) =>
    t.widget<ElMachineSurface>(
      find
          .descendant(
            of: find.byType(of),
            matching: find.byType(ElMachineSurface),
          )
          .first,
    );

Color borderOf(ElMachineSurface surface) =>
    (surface.border! as Border).top.color;

/// The `ring-3` layer `ElButton.withFocusRing` prepends: zero offset, zero
/// blur, 3px spread.
Color ringOf(ElMachineSurface surface, ElThemeData theme) =>
    surface.spec.layers.first.color(theme);

/// `z.boolean().refine(v => v, …)` — the one rule the `terms` field carries.
bool _accepted(bool value) => value;

/// The [FocusNode] a radio item's own [Focus] carries — the ones with a key
/// handler, which the `Visibility` wrappers inside an indicator do not have.
FocusNode itemFocus(WidgetTester t, int index) => t
    .widgetList<Focus>(
      find.descendant(
        of: find.byType(ElRadioGroup<String>),
        matching: find.byType(Focus),
      ),
    )
    .where((Focus f) => f.onKeyEvent != null)
    .elementAt(index)
    .focusNode!;

void main() {
  group('ElCheckbox', () {
    testWidgets('is 20px on a 6px corner', (WidgetTester t) async {
      await t.pumpWidget(host(const ElCheckbox()));
      expect(t.getSize(find.byType(ElSelectionControl)), const Size(20, 20));
      expect(ElCheckbox.size, 20);
      expect(socketOf(t, ElCheckbox).radius, BorderRadius.circular(ElRadii.sm));
    });

    testWidgets('the socket lights on check: pressed → btn-primary', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(const ElCheckbox()));
      final ElThemeData theme = themeIn(t, ElCheckbox);
      expect(
        socketOf(t, ElCheckbox).spec.layers.skip(1).toList(),
        ElShadows.pressed.layers,
      );
      expect(socketOf(t, ElCheckbox).fill, theme.card);
      expect(borderOf(socketOf(t, ElCheckbox)), theme.input);

      await t.pumpWidget(
        host(const ElCheckbox(state: ElCheckboxState.checked)),
      );
      await t.pump(ElDurations.transitionDefault);
      expect(
        socketOf(t, ElCheckbox).spec.layers.skip(1).toList(),
        ElShadows.btnPrimary.layers,
      );
      expect(socketOf(t, ElCheckbox).fill, theme.primary);
      expect(borderOf(socketOf(t, ElCheckbox)), theme.primary);
    });

    /// The mark's own player, told apart from [ElJellyReplay]'s by its
    /// duration: a draw runs 280ms or 200ms, the squash 600.
    Finder markPlayer() => find.byWidgetPredicate(
      (Widget w) =>
          w is ElKeyframePlayer &&
          (w.duration == ElCheckDraw.duration ||
              w.duration == ElDashDraw.duration),
    );

    testWidgets('mounts no indicator while unchecked, and one when lit', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(const ElCheckbox()));
      expect(markPlayer(), findsNothing);

      // Exactly ONE mark is mounted at a time. The old model mounted both and
      // hid one, which is what made a swap reveal a finished stroke.
      await t.pumpWidget(
        host(const ElCheckbox(state: ElCheckboxState.checked)),
      );
      expect(markPlayer(), findsOneWidget);
      await t.pump(ElJelly.duration);

      await t.pumpWidget(
        host(const ElCheckbox(state: ElCheckboxState.indeterminate)),
      );
      expect(markPlayer(), findsOneWidget);
      await t.pump(ElJelly.duration);

      // Going out is an unmount, not a reverse draw and not a fade.
      await t.pumpWidget(host(const ElCheckbox()));
      await t.pump();
      expect(
        markPlayer(),
        findsNothing,
        reason: 'unchecking unmounts the indicator outright — measured',
      );
    });

    testWidgets('every reveal re-draws its mark from zero', (
      WidgetTester t,
    ) async {
      // MEASURED (behaviour audit, second pass): a hidden mark carries no
      // animation of its own, and restoring it starts a brand-new one. So a
      // swap between the two lit states re-runs the arriving mark's draw in
      // full rather than revealing a stroke that already finished. A fresh
      // Element is exactly what a fresh CSS animation is here — the player is
      // re-keyed, so it cannot resume.
      await t.pumpWidget(
        host(const ElCheckbox(state: ElCheckboxState.checked)),
      );
      await t.pump(ElCheckDraw.duration);
      await t.pump(ElJelly.duration);
      final Element tick = t.element(markPlayer());
      expect(
        t.widget<ElKeyframePlayer>(markPlayer()).duration,
        ElCheckDraw.duration,
      );

      // checked -> indeterminate re-runs `dash-draw`, all 200ms of it.
      await t.pumpWidget(
        host(const ElCheckbox(state: ElCheckboxState.indeterminate)),
      );
      await t.pump();
      expect(
        t.element(markPlayer()),
        isNot(tick),
        reason: 'a fresh player, not the finished bar re-shown',
      );
      expect(
        t.widget<ElKeyframePlayer>(markPlayer()).duration,
        ElDashDraw.duration,
      );
      await t.pump(ElDashDraw.duration);
      await t.pump(ElJelly.duration);

      // …and indeterminate -> checked re-runs `check-draw`.
      final Element bar = t.element(markPlayer());
      await t.pumpWidget(
        host(const ElCheckbox(state: ElCheckboxState.checked)),
      );
      await t.pump();
      expect(
        t.element(markPlayer()),
        isNot(bar),
        reason: 'the tick starts over too',
      );
      expect(
        t.widget<ElKeyframePlayer>(markPlayer()).duration,
        ElCheckDraw.duration,
      );
      await t.pump(ElCheckDraw.duration);
      await t.pump(ElJelly.duration);
    });

    testWidgets('the tick draws itself on over 280ms', (WidgetTester t) async {
      expect(ElCheckDraw.duration, ElDurations.checkDraw);
      expect(ElCheckDraw.drawnFractionAt(0), 0);
      expect(ElCheckDraw.drawnFractionAt(1), 1);
      expect(ElDashDraw.duration, ElDurations.dashDraw);

      await t.pumpWidget(
        host(const ElCheckbox(state: ElCheckboxState.checked)),
      );
      await t.pump(const Duration(milliseconds: 140));
      // Mid-flight: part of the stroke, not all of it.
      final double half = ElCheckDraw.drawnFractionAt(0.5);
      expect(half, greaterThan(0));
      expect(half, lessThan(1));
      await t.pump(ElCheckDraw.duration);
    });

    testWidgets('a click toggles the way Radix does', (WidgetTester t) async {
      expect(
        ElCheckbox.nextAfter(ElCheckboxState.unchecked),
        ElCheckboxState.checked,
      );
      expect(
        ElCheckbox.nextAfter(ElCheckboxState.indeterminate),
        ElCheckboxState.checked,
      );
      expect(
        ElCheckbox.nextAfter(ElCheckboxState.checked),
        ElCheckboxState.unchecked,
      );

      ElCheckboxState? seen;
      await t.pumpWidget(
        host(
          ElCheckbox(
            state: ElCheckboxState.unchecked,
            onChanged: (ElCheckboxState next) => seen = next,
          ),
        ),
      );
      await t.tap(find.byType(ElCheckbox));
      expect(seen, ElCheckboxState.checked);
    });

    testWidgets(
      'answers a pointer 42 × 34 — the pseudo-element, not the paint',
      (WidgetTester t) async {
        int taps = 0;
        await t.pumpWidget(
          host(ElCheckbox(onChanged: (ElCheckboxState _) => taps++)),
        );
        // The box is 20 × 20 and takes 20 × 20 of layout…
        expect(t.getSize(find.byType(ElHitArea)), const Size(20, 20));
        final Offset centre = t.getCenter(find.byType(ElCheckbox));

        // …and `-inset-x-3 -inset-y-2` grows from the **padding** box — 18 × 18
        // inside the 1px border — so the target is 42 × 34 and reaches 21px and
        // 17px from the centre. Probed on the live reference, whose `::after`
        // computes to exactly `42px × 34px`.
        await t.tapAt(centre + const Offset(20.9, 0));
        await t.tapAt(centre + const Offset(0, 16.9));
        expect(taps, 2);

        // A tenth of a pixel past it, nothing. The bracket is tight on purpose:
        // the border-box reading this port shipped first would answer here.
        await t.tapAt(centre + const Offset(21.1, 0));
        await t.tapAt(centre + const Offset(0, 17.1));
        expect(
          taps,
          2,
          reason: 'the expander grows from 18 × 18, not from 20 × 20',
        );
      },
    );

    testWidgets('jelly never fires on mount, and fires both ways', (
      WidgetTester t,
    ) async {
      // Read on a switch rather than a checkbox: a switch mounts no keyframe
      // player of its own, so every one found belongs to the replay.
      await t.pumpWidget(host(const ElSwitch(value: false)));
      expect(
        find.byType(ElKeyframePlayer),
        findsNothing,
        reason: 'a MutationObserver does not report initial state',
      );

      await t.pumpWidget(host(const ElSwitch(value: true)));
      expect(find.byType(ElKeyframePlayer), findsOneWidget);
      await t.pumpAndSettle();

      // …and again on the way back.
      await t.pumpWidget(host(const ElSwitch(value: false)));
      expect(find.byType(ElKeyframePlayer), findsOneWidget);
      await t.pumpAndSettle();
      expect(ElJelly.duration, ElDurations.animJelly);
    });

    testWidgets('aria-invalid beats focus-visible — F5, drift 6', (
      WidgetTester t,
    ) async {
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);

      await t.pumpWidget(
        host(
          ElCheckbox(
            invalid: true,
            focusNode: node,
            onChanged: (ElCheckboxState _) {},
          ),
        ),
      );
      final ElThemeData theme = themeIn(t, ElCheckbox);
      await t.pump(ElDurations.transitionDefault);
      final Color restBorder = borderOf(socketOf(t, ElCheckbox));
      final Color restRing = ringOf(socketOf(t, ElCheckbox), theme);
      expect(restBorder, theme.destructive);

      node.requestFocus();
      await t.pump();
      await t.pumpAndSettle();
      // Focusing an errored control produces no visible change at all.
      expect(borderOf(socketOf(t, ElCheckbox)), restBorder);
      expect(ringOf(socketOf(t, ElCheckbox), theme), restRing);
    });

    testWidgets('focus rings at ring/50 when valid', (WidgetTester t) async {
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      await t.pumpWidget(
        host(ElCheckbox(focusNode: node, onChanged: (ElCheckboxState _) {})),
      );
      final ElThemeData theme = themeIn(t, ElCheckbox);
      node.requestFocus();
      await t.pump();
      await t.pumpAndSettle();
      expect(borderOf(socketOf(t, ElCheckbox)), theme.ring);
      expect(ringOf(socketOf(t, ElCheckbox), theme).a, closeTo(0.50, 0.001));
    });

    testWidgets('Space and Enter operate it', (WidgetTester t) async {
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      int taps = 0;
      await t.pumpWidget(
        host(
          ElCheckbox(focusNode: node, onChanged: (ElCheckboxState _) => taps++),
        ),
      );
      node.requestFocus();
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.space);
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(taps, 2);
    });

    testWidgets('disabled dims to 50% and ignores a pointer', (
      WidgetTester t,
    ) async {
      int taps = 0;
      await t.pumpWidget(
        host(
          ElCheckbox(enabled: false, onChanged: (ElCheckboxState _) => taps++),
        ),
      );
      expect(
        t
            .widget<Opacity>(
              find
                  .descendant(
                    of: find.byType(ElCheckbox),
                    matching: find.byType(Opacity),
                  )
                  .first,
            )
            .opacity,
        0.50,
      );
      await t.tap(find.byType(ElCheckbox), warnIfMissed: false);
      expect(taps, 0);
    });
  });

  group('ElRadioGroup', () {
    Widget group(
      String? value,
      ValueChanged<String>? onChanged, {
      double? gap,
    }) => host(
      SizedBox(
        width: 200,
        child: ElRadioGroup<String>(
          value: value,
          onChanged: onChanged,
          gap: gap,
          children: const <Widget>[
            ElRadioGroupItem<String>(value: 'daily', label: 'Daily'),
            ElRadioGroupItem<String>(value: 'weekly', label: 'Weekly'),
          ],
        ),
      ),
    );

    testWidgets('items are 20px circles', (WidgetTester t) async {
      await t.pumpWidget(group(null, (String _) {}));
      expect(
        t.getSize(find.byType(ElSelectionControl).first),
        const Size(20, 20),
      );
      expect(ElRadioGroupItem.size, 20);
      expect(
        socketOf(t, ElRadioGroupItem<String>).radius,
        BorderRadius.circular(10),
      );
    });

    testWidgets('gap-2 by default, gap-3 as the composed form passes', (
      WidgetTester t,
    ) async {
      expect(ElRadioGroup.defaultGap, 8);
      await t.pumpWidget(group(null, (String _) {}));
      final double a =
          t.getTopLeft(find.byType(ElRadioGroupItem<String>).at(1)).dy -
          t.getBottomLeft(find.byType(ElRadioGroupItem<String>).at(0)).dy;
      expect(a, 8);

      await t.pumpWidget(group(null, (String _) {}, gap: 12));
      final double b =
          t.getTopLeft(find.byType(ElRadioGroupItem<String>).at(1)).dy -
          t.getBottomLeft(find.byType(ElRadioGroupItem<String>).at(0)).dy;
      expect(b, 12);
    });

    testWidgets('the dot mounts only when checked, at 8px on e1', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(group(null, (String _) {}));
      final Finder surfaces = find.descendant(
        of: find.byType(ElRadioGroupItem<String>).at(0),
        matching: find.byType(ElMachineSurface),
      );
      // Only the socket, while nothing is chosen.
      expect(surfaces, findsOneWidget);

      await t.pumpWidget(group('daily', (String _) {}));
      expect(surfaces, findsNWidgets(2));
      final ElMachineSurface dot = t.widget<ElMachineSurface>(surfaces.last);
      expect(dot.spec.layers, ElShadows.e1.layers);
      await t.pumpAndSettle();
      expect(t.getSize(surfaces.last), const Size(8, 8));
    });

    testWidgets('dot-pop overshoots to 1.35 at 55%', (WidgetTester t) async {
      expect(ElDotPop.duration, ElDurations.dotPop);
      expect(ElDotPop.curve, ElCurves.spring);
      expect(ElDotPop.scale.transform(0), 0);
      expect(ElDotPop.scale.transform(0.55), closeTo(1.35, 0.001));
      expect(ElDotPop.scale.transform(1), 1);
    });

    testWidgets('the socket lights on selection', (WidgetTester t) async {
      await t.pumpWidget(group('daily', (String _) {}));
      final ElThemeData theme = themeIn(t, ElRadioGroupItem<String>);
      await t.pump(ElDurations.transitionDefault);
      expect(socketOf(t, ElRadioGroupItem<String>).fill, theme.primary);
      expect(
        socketOf(t, ElRadioGroupItem<String>).spec.layers.skip(1).toList(),
        ElShadows.btnPrimary.layers,
      );
    });

    testWidgets('arrows move and select, and they wrap', (
      WidgetTester t,
    ) async {
      String? value = 'daily';
      await t.pumpWidget(group(value, (String next) => value = next));
      // Flutter does not move focus on a pointer tap — the same predicate
      // `ElButton` relies on for `:focus-visible` — so the tab stop is asked
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

    testWidgets('the group is one tab stop — roving tabindex', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(group('weekly', (String _) {}));
      final List<Focus> nodes = t
          .widgetList<Focus>(
            find.descendant(
              of: find.byType(ElRadioGroup<String>),
              matching: find.byType(Focus),
            ),
          )
          .where((Focus f) => f.onKeyEvent != null)
          .toList();
      expect(nodes.length, 2);
      expect(nodes[0].skipTraversal, isTrue);
      expect(nodes[1].skipTraversal, isFalse);
    });

    testWidgets('a null onChanged disables every item', (WidgetTester t) async {
      await t.pumpWidget(group(null, null));
      expect(
        t
            .widget<Opacity>(
              find
                  .descendant(
                    of: find.byType(ElRadioGroupItem<String>).at(0),
                    matching: find.byType(Opacity),
                  )
                  .first,
            )
            .opacity,
        0.50,
        reason:
            'a group with no setter is a disabled group — disabled:opacity-50',
      );
      await t.tap(
        find.byType(ElRadioGroupItem<String>).at(0),
        warnIfMissed: false,
      );
    });
  });

  group('ElSwitch', () {
    testWidgets('44 × 24 with a 20px thumb, 36 × 20 with a 16px one', (
      WidgetTester t,
    ) async {
      expect(ElSwitchSize.md.trackWidth, 44);
      expect(ElSwitchSize.md.trackHeight, 24);
      expect(ElSwitchSize.md.thumbSize, 20);
      expect(ElSwitchSize.md.travel, 20);
      expect(ElSwitchSize.md.label, 'default');
      expect(ElSwitchSize.sm.trackWidth, 36);
      expect(ElSwitchSize.sm.trackHeight, 20);
      expect(ElSwitchSize.sm.thumbSize, 16);
      expect(ElSwitchSize.sm.travel, 16);

      await t.pumpWidget(host(const ElSwitch(value: false)));
      expect(t.getSize(find.byType(ElSelectionControl)), const Size(44, 24));
    });

    testWidgets('the thumb travels 20px and ends flush with the border', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(const ElSwitch(value: false)));
      final Finder thumb = find
          .descendant(
            of: find.byType(ElSwitch),
            matching: find.byType(ElMachineSurface),
          )
          .last;
      final double trackLeft = t.getTopLeft(find.byType(ElSwitch)).dx;
      // border 1 + padding 2.
      expect(t.getTopLeft(thumb).dx - trackLeft, 3);

      await t.pumpWidget(host(const ElSwitch(value: true)));
      await t.pumpAndSettle();
      // 20px of travel on a 38px content box: the knob spends its left-hand
      // air and lands against the inner edge of the border.
      expect(t.getTopLeft(thumb).dx - trackLeft, 23);
      expect(t.getBottomRight(thumb).dx - trackLeft, 43);
    });

    testWidgets('the track is recessed and the knob is raised', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(const ElSwitch(value: false)));
      final ElThemeData theme = themeIn(t, ElSwitch);
      expect(socketOf(t, ElSwitch).fill, theme.muted);
      expect(
        socketOf(t, ElSwitch).spec.layers.skip(1).toList(),
        ElShadows.pressed.layers,
      );

      final ElMachineSurface thumb = t.widget<ElMachineSurface>(
        find
            .descendant(
              of: find.byType(ElSwitch),
              matching: find.byType(ElMachineSurface),
            )
            .last,
      );
      expect(thumb.spec.layers, ElShadows.btn.layers);
      expect(thumb.fill, theme.foreground);

      await t.pumpWidget(host(const ElSwitch(value: true)));
      await t.pumpAndSettle();
      expect(socketOf(t, ElSwitch).fill, theme.primary);
      expect(
        socketOf(t, ElSwitch).spec.layers.skip(1).toList(),
        ElShadows.btnPrimary.layers,
      );
      // The knob is raised in both states — that opposition is the point.
      expect(
        t
            .widget<ElMachineSurface>(
              find
                  .descendant(
                    of: find.byType(ElSwitch),
                    matching: find.byType(ElMachineSurface),
                  )
                  .last,
            )
            .spec
            .layers,
        ElShadows.btn.layers,
      );
    });

    testWidgets('answers a pointer 66 × 38', (WidgetTester t) async {
      int taps = 0;
      await t.pumpWidget(
        host(ElSwitch(value: false, onChanged: (bool _) => taps++)),
      );
      final Offset centre = t.getCenter(find.byType(ElSwitch));

      // The same padding-box rule on a 44 × 24 track: 42 × 22 inside the
      // border, grown to 66 × 38, so the target reaches 33px and 19px from the
      // centre. Probed `::after` = `66px × 38px`.
      await t.tapAt(centre + const Offset(32.9, 0));
      await t.tapAt(centre + const Offset(0, 18.9));
      expect(taps, 2);

      await t.tapAt(centre + const Offset(33.1, 0));
      await t.tapAt(centre + const Offset(0, 19.1));
      expect(
        taps,
        2,
        reason: 'measured 66 x 38, not the border box reading of 68 x 40',
      );
    });

    testWidgets('the thumb runs on the spring, the track does not', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(const ElSwitch(value: false)));
      final TweenAnimationBuilder<double> thumb = t
          .widget<TweenAnimationBuilder<double>>(
            find.byType(TweenAnimationBuilder<double>),
          );
      expect(thumb.curve, ElCurves.spring);
      expect(thumb.duration, ElDurations.transitionDefault);

      final TweenAnimationBuilder<Color?> track = t
          .widget<TweenAnimationBuilder<Color?>>(
            find.byType(TweenAnimationBuilder<Color?>).first,
          );
      expect(track.curve, ElCurves.out);
      expect(track.duration, ElDurations.transitionDefault);
    });
  });

  group('ElSelect', () {
    List<ElSelectOption<String>> options() => const <ElSelectOption<String>>[
      ElSelectOption<String>(value: 'free', label: 'Free'),
      ElSelectOption<String>(value: 'pro', label: 'Pro'),
      ElSelectOption<String>(value: 'vault', label: 'Vault'),
    ];

    Widget select(String? value, ValueChanged<String>? onChanged) =>
        overlayHost(
          SizedBox(
            width: 448,
            child: ElSelect<String>(
              options: options(),
              value: value,
              onChanged: onChanged,
              placeholder: 'Choose a plan',
              expand: true,
            ),
          ),
        );

    testWidgets('the trigger is 40px on a pill over a socket', (
      WidgetTester t,
    ) async {
      expect(ElSelectSize.md.height, 40);
      expect(ElSelectSize.sm.height, 32);
      expect(ElSelectSize.md.label, 'default');

      await t.pumpWidget(select(null, (String _) {}));
      expect(t.getSize(find.byType(ElSelect<String>)).height, 40);
      expect(
        socketOf(t, ElSelect<String>).spec.layers.skip(1).toList(),
        ElShadows.pressed.layers,
      );
      expect(
        socketOf(t, ElSelect<String>).radius,
        BorderRadius.circular(ElRadii.pill),
      );
    });

    testWidgets('the placeholder is muted until something is chosen', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(select(null, (String _) {}));
      final ElThemeData theme = themeIn(t, ElSelect<String>);
      expect(find.text('Choose a plan'), findsOneWidget);
      expect(
        t.widget<ElText>(find.byType(ElText).first).color,
        theme.mutedForeground,
      );

      await t.pumpWidget(select('pro', (String _) {}));
      expect(find.text('Pro'), findsOneWidget);
      expect(
        t.widget<ElText>(find.byType(ElText).first).color,
        theme.foreground,
      );
    });

    testWidgets('a click opens a menu of every option', (WidgetTester t) async {
      await t.pumpWidget(select(null, (String _) {}));
      expect(find.text('Free'), findsNothing);

      await t.tap(find.byType(ElSelect<String>));
      await t.pump();
      expect(find.text('Free'), findsOneWidget);
      expect(find.text('Pro'), findsOneWidget);
      expect(find.text('Vault'), findsOneWidget);
    });

    testWidgets('the menu does not animate — drift 10', (WidgetTester t) async {
      await t.pumpWidget(select(null, (String _) {}));
      await t.tap(find.byType(ElSelect<String>));
      await t.pump();
      final Size opened = t.getSize(find.text('Free'));
      // One frame later, with no time elapsed, the menu is already whole.
      await t.pump();
      expect(t.getSize(find.text('Free')), opened);
    });

    testWidgets('a row is py-2 pl-3 pr-9 on a text-sm line box', (
      WidgetTester t,
    ) async {
      expect(ElSelect.itemHeight, closeTo(13 * (1.25 / 0.875) + 16, 0.001));

      await t.pumpWidget(select(null, (String _) {}));
      await t.tap(find.byType(ElSelect<String>));
      await t.pump();
      final Rect row = t.getRect(
        find
            .ancestor(of: find.text('Free'), matching: find.byType(Padding))
            .first,
      );
      // The `ElText` box is the CSS line box; the paragraph inside it is
      // shorter by the half-leading, so the padding is read off the former.
      final Rect text = t.getRect(
        find.ancestor(of: find.text('Free'), matching: find.byType(ElText)),
      );
      expect(text.left - row.left, 12);
      expect(row.right - text.right, closeTo(36, 0.001));
      expect(text.top - row.top, closeTo(8, 0.001));
    });

    testWidgets('the keyboard walks it and Enter commits', (
      WidgetTester t,
    ) async {
      String? picked;
      await t.pumpWidget(select(null, (String value) => picked = value));
      await t.tap(find.byType(ElSelect<String>));
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
      await t.tap(find.byType(ElSelect<String>));
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await t.pump();
      expect(find.text('Vault'), findsNothing);
      expect(picked, isNull);
    });

    testWidgets('the content wears shadow-md under a 1px ring', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(select(null, (String _) {}));
      await t.tap(find.byType(ElSelect<String>));
      await t.pump();
      final ElMachineSurface content = t.widget<ElMachineSurface>(
        find.byType(ElMachineSurface).last,
      );
      expect(content.spec.layers.skip(1).toList(), ElShadows.tailwindMd.layers);
      expect(content.spec.layers.first.spread, ElWidths.hairline);
      expect(content.radius, BorderRadius.circular(ElRadii.lg));
    });

    testWidgets('aria-invalid beats focus on the trigger too', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        overlayHost(
          ElSelect<String>(
            options: options(),
            value: null,
            onChanged: (String _) {},
            invalid: true,
          ),
        ),
      );
      final ElThemeData theme = themeIn(t, ElSelect<String>);
      await t.pumpAndSettle();
      // `Select` is the only control with `dark:` overrides on the invalid
      // state — `border-destructive/50` and `ring-destructive/40`.
      expect(
        borderOf(socketOf(t, ElSelect<String>)),
        theme.destructive.withValues(alpha: 0.50),
      );
      expect(
        ringOf(socketOf(t, ElSelect<String>), theme).a,
        closeTo(0.40, 0.001),
      );
    });

    testWidgets('dark is the only theme with a hover fill — drift 17/18', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        overlayHost(
          ElSelect<String>(
            options: options(),
            value: null,
            onChanged: (String _) {},
          ),
          mode: ElThemeMode.light,
        ),
      );
      final ElThemeData light = themeIn(t, ElSelect<String>);
      expect(socketOf(t, ElSelect<String>).fill, light.card);

      await t.pumpWidget(
        overlayHost(
          ElSelect<String>(
            options: options(),
            value: null,
            onChanged: (String _) {},
          ),
        ),
      );
      final ElThemeData dark = themeIn(t, ElSelect<String>);
      await t.pump(ElDurations.base);
      expect(
        socketOf(t, ElSelect<String>).fill,
        dark.input.withValues(alpha: 0.30),
      );
    });
  });

  group('ElAlert', () {
    testWidgets('every variant shares the surface and spends one colour', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          const SizedBox(
            width: 448,
            child: ElAlert(title: 'Could not save', description: 'Try again.'),
          ),
        ),
      );
      final ElThemeData theme = themeIn(t, ElAlert);
      const Map<ElAlertVariant, String> labels = <ElAlertVariant, String>{
        ElAlertVariant.normal: 'default',
        ElAlertVariant.destructive: 'destructive',
        ElAlertVariant.success: 'success',
        ElAlertVariant.warning: 'warning',
        ElAlertVariant.info: 'info',
      };
      expect(labels.length, ElAlertVariant.values.length);
      for (final MapEntry<ElAlertVariant, String> e in labels.entries) {
        expect(e.key.label, e.value);
      }
      expect(ElAlertVariant.normal.inkOf(theme), theme.mutedForeground);
      expect(ElAlertVariant.destructive.inkOf(theme), theme.destructiveInk);
      expect(ElAlertVariant.success.inkOf(theme), theme.successInk);
      expect(ElAlertVariant.warning.inkOf(theme), theme.warningInk);
      expect(ElAlertVariant.info.inkOf(theme), theme.infoInk);
    });

    testWidgets('16 / 14 padding on a 12px corner, 12px beside the glyph', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          SizedBox(
            width: 448,
            child: ElAlert(
              variant: ElAlertVariant.destructive,
              icon: const ElIcon(ElIconGlyph.info),
              title: 'Could not save',
              description: 'That handle belongs to someone else.',
            ),
          ),
        ),
      );
      final Rect alert = t.getRect(find.byType(ElAlert));
      final Rect icon = t.getRect(find.byType(ElIcon));
      // px-4 plus the 1px border.
      expect(icon.left - alert.left, closeTo(17, 0.001));
      // py-3.5 plus the border, plus the glyph's own translate-y-0.5.
      expect(icon.top - alert.top, closeTo(17, 0.001));

      final Rect title = t.getRect(find.text('Could not save'));
      expect(title.left - icon.right, closeTo(12, 0.001));
      expect(
        t.widget<ElBloomCosmic>(find.byType(ElBloomCosmic)).radius,
        BorderRadius.circular(ElRadii.lg),
      );
    });

    testWidgets('the title is 13/500 and the description 13 muted', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          const SizedBox(
            width: 448,
            child: ElAlert(title: 'Could not save', description: 'Try again.'),
          ),
        ),
      );
      final ElThemeData theme = themeIn(t, ElAlert);
      final ElText title = t.widget<ElText>(find.byType(ElText).first);
      expect(title.spec.size, 13);
      expect(title.spec.variations.first.value, 500);
      expect(title.color, theme.cardForeground);

      final ElText body = t.widget<ElText>(find.byType(ElText).last);
      expect(body.spec.size, 13);
      expect(body.spec.variations.first.value, 400);
      expect(body.color, theme.mutedForeground);
    });

    testWidgets('role="alert" is a live region', (WidgetTester t) async {
      final SemanticsHandle handle = t.ensureSemantics();
      await t.pumpWidget(
        host(
          const SizedBox(width: 448, child: ElAlert(title: 'Could not save')),
        ),
      );
      expect(
        t.getSemantics(find.byType(ElAlert)).flagsCollection.isLiveRegion,
        isTrue,
      );
      handle.dispose();
    });
  });

  group('ElBloomCosmic', () {
    testWidgets('the blend and the void are the theme\'s, and they agree', (
      WidgetTester t,
    ) async {
      // Each ramp ends on the identity operand of its own blend, which is what
      // makes the gradients disappear instead of leaving an edge.
      expect(ElBloomCosmic.blendFor(ElThemeKind.dark), BlendMode.screen);
      expect(ElBloomCosmic.voidFor(ElThemeKind.dark).r, 0);
      expect(ElBloomCosmic.voidFor(ElThemeKind.dark).g, 0);
      expect(ElBloomCosmic.voidFor(ElThemeKind.dark).b, 0);

      expect(ElBloomCosmic.blendFor(ElThemeKind.light), BlendMode.multiply);
      expect(ElBloomCosmic.voidFor(ElThemeKind.light).r, 1);
      expect(ElBloomCosmic.voidFor(ElThemeKind.light).g, 1);
      expect(ElBloomCosmic.voidFor(ElThemeKind.light).b, 1);
    });

    testWidgets('the named pairs are the declarations they transcribe', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(const SizedBox.shrink()));
      final ElThemeData theme = ElTheme.of(t.element(find.byType(Center)));
      final BorderRadius r = BorderRadius.circular(ElRadii.lg);
      const Widget child = SizedBox.shrink();

      final ElBloomCosmic action = ElBloomCosmic.action(
        radius: r,
        fill: theme.card,
        child: child,
      );
      expect(action.bloom1(theme), ElPalette.actionBright);
      expect(action.bloom2(theme), ElPalette.action);

      final ElBloomCosmic destructive = ElBloomCosmic.destructive(
        radius: r,
        fill: theme.card,
        child: child,
      );
      expect(destructive.bloom1(theme), theme.destructive);
      expect(destructive.bloom2(theme), ElPalette.action);

      final ElBloomCosmic success = ElBloomCosmic.success(
        radius: r,
        fill: theme.card,
        child: child,
      );
      expect(success.bloom1(theme), ElPalette.success);
      expect(success.bloom2(theme), ElPalette.value);

      // DRIFT: the Alert's warning was moved off the value ramp and the
      // toast's never was.
      final ElBloomCosmic warning = ElBloomCosmic.warning(
        radius: r,
        fill: theme.card,
        child: child,
      );
      expect(warning.bloom1(theme), ElPalette.warning);
      expect(warning.bloom2(theme), ElPalette.action);

      final ElBloomCosmic toastWarning = ElBloomCosmic.toastWarning(
        radius: r,
        fill: theme.card,
        child: child,
      );
      expect(toastWarning.bloom1(theme), ElPalette.valueBright);
      expect(toastWarning.bloom2(theme), ElPalette.valueDark);
    });
  });

  group('ElToast', () {
    testWidgets('356 wide, 16 of padding, 12 beside the glyph, on e3', (
      WidgetTester t,
    ) async {
      expect(ElToaster.width, 356);
      expect(ElToaster.gap, 14);
      expect(ElToaster.viewportOffset, 24);
      expect(ElToaster.visibleLimit, 3);
      expect(ElToaster.lifetime, const Duration(seconds: 4));

      await t.pumpWidget(
        host(
          SizedBox(
            width: ElToaster.width,
            child: const ElToast(
              message: ElToastMessage(
                title: 'Saved as @ayoub',
                type: ElToastType.info,
              ),
            ),
          ),
        ),
      );
      final ElMachineSurface surface = t.widget<ElMachineSurface>(
        find.byType(ElMachineSurface),
      );
      expect(surface.spec.layers, ElShadows.e3.layers);
      expect(surface.radius, BorderRadius.circular(ElRadii.lg));

      final Rect toast = t.getRect(find.byType(ElToast));
      final Rect icon = t.getRect(find.byType(ElIcon));
      expect(toast.width, 356);
      // padding 16 + border 1.
      expect(icon.left - toast.left, closeTo(17, 0.001));
      // …and the glyph's own 2px optical nudge on top.
      expect(icon.top - toast.top, closeTo(19, 0.001));
      expect(
        t.getRect(find.text('Saved as @ayoub')).left - icon.right,
        closeTo(12, 0.001),
      );
    });

    testWidgets('the glyph carries the only colour, and it is an -ink token', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(const SizedBox.shrink()));
      final ElThemeData theme = ElTheme.of(t.element(find.byType(Center)));
      expect(ElToastType.success.inkOf(theme), theme.successInk);
      expect(ElToastType.error.inkOf(theme), theme.destructiveInk);
      expect(ElToastType.warning.inkOf(theme), theme.warningInk);
      expect(ElToastType.info.inkOf(theme), theme.infoInk);
      expect(ElToastType.loading.inkOf(theme), theme.actionInk);
      expect(ElToastType.normal.inkOf(theme), theme.mutedForeground);
      expect(ElToastType.normal.label, 'default');
    });

    testWidgets('GAP CLOSED: TOAST_ICONS maps all five types', (
      WidgetTester t,
    ) async {
      // Was a KNOWN GAP: `circleCheck` and `octagonX` had no geometry, so
      // `ElToastType.glyph` answered null for success and error and this test
      // pinned the null. Both paths landed with the icon writer; wave B2 flips
      // the getter and this pin with it.
      expect(ElToastType.success.glyph, ElIconGlyph.circleCheck);
      expect(ElToastType.info.glyph, ElIconGlyph.info);
      expect(ElToastType.warning.glyph, ElIconGlyph.alertTriangle);
      expect(ElToastType.error.glyph, ElIconGlyph.octagonX);
      expect(ElToastType.loading.glyph, ElIconGlyph.loaderCircle);

      // The one remaining null is not a gap: `TOAST_ICONS` has no `default`
      // key, so an untyped toast renders with no icon slot at all — while a
      // call site may still put one there.
      expect(ElToastType.normal.glyph, isNull);
      expect(
        const ElToastMessage(title: 'Added to favourites').resolvedGlyph,
        isNull,
      );
      expect(
        const ElToastMessage(
          title: 'Added to favourites',
          glyph: ElIconGlyph.check,
        ).resolvedGlyph,
        ElIconGlyph.check,
      );

      await t.pumpWidget(
        host(
          SizedBox(
            width: ElToaster.width,
            child: const ElToast(
              message: ElToastMessage(
                title: 'Saved',
                type: ElToastType.success,
              ),
            ),
          ),
        ),
      );
      expect(find.byType(ElIcon), findsOneWidget);
    });
  });

  // The Slot merge, on the four controls that are not an `<input>`.
  //
  // `FormControl` is a `Slot`: it stamps `id`, `aria-invalid` and
  // `aria-describedby` onto whatever it wraps — *"input, trigger, switch or
  // checkbox alike"*. Flutter's analogue is context, so each of these reads
  // `ElFieldScope` and lets its own props win where both speak.
  group('ElFieldScope adoption', () {
    /// A control inside a field that says everything a field can say.
    Widget inField(
      Widget control, {
      required FocusNode node,
      bool valid = false,
    }) => host(
      SizedBox(
        width: 448,
        child: ElField(
          label: 'Price alerts',
          description: 'Receipts and nothing else.',
          errors: valid ? const <String>[] : const <String>['Pick one.'],
          enabled: false,
          focusNode: node,
          child: control,
        ),
      ),
    );

    /// What the control passes into its own [Semantics].
    ///
    /// Read off the widget rather than the semantics tree: a control's
    /// annotation sits *inside* its [ElHitArea] (the expander has to be
    /// outermost, or a pointer in the pseudo-element's margin is rejected
    /// before it arrives), so walking up from the control's own render object
    /// lands on the field's container node instead of on this one.
    SemanticsProperties announced(WidgetTester t, Finder of) => t
        .widgetList<Semantics>(
          find.descendant(of: of, matching: find.byType(Semantics)),
        )
        .first
        .properties;

    /// Whether the enclosing field's node is the one the control's own [Focus]
    /// carries — which is what makes `ElForm.focusFirstError` land on it.
    bool adopted(WidgetTester t, Finder of, FocusNode node) => t
        .widgetList<Focus>(
          find.descendant(of: of, matching: find.byType(Focus)),
        )
        .any((Focus f) => identical(f.focusNode, node));

    testWidgets('ElCheckbox takes label, description, enabled, invalid, node', (
      WidgetTester t,
    ) async {
      final SemanticsHandle semantics = t.ensureSemantics();
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);

      await t.pumpWidget(
        inField(const ElCheckbox(state: ElCheckboxState.unchecked), node: node),
      );
      await t.pumpAndSettle();
      final ElThemeData theme = themeIn(t, ElCheckbox);

      final SemanticsProperties said = announced(t, find.byType(ElCheckbox));
      expect(said.label!, contains('Price alerts'));
      expect(said.hint!, contains('Receipts and nothing else.'));
      expect(
        said.hint!,
        contains('Pick one.'),
        reason: 'description then error, in the order the id list encodes',
      );

      // `data-[disabled=true]` on the field disables the control, and the
      // control cannot opt back in.
      expect(
        t
            .widget<Opacity>(
              find
                  .descendant(
                    of: find.byType(ElCheckbox),
                    matching: find.byType(Opacity),
                  )
                  .first,
            )
            .opacity,
        0.50,
      );
      // `aria-invalid` reaches the paint, not only the field's own container.
      expect(borderOf(socketOf(t, ElCheckbox)), theme.destructive);
      expect(adopted(t, find.byType(ElCheckbox), node), isTrue);
      semantics.dispose();
    });

    testWidgets('ElSwitch takes label, description, enabled, invalid, node', (
      WidgetTester t,
    ) async {
      final SemanticsHandle semantics = t.ensureSemantics();
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);

      await t.pumpWidget(inField(const ElSwitch(value: false), node: node));
      await t.pumpAndSettle();
      final ElThemeData theme = themeIn(t, ElSwitch);

      final SemanticsProperties said = announced(t, find.byType(ElSwitch));
      expect(said.label!, contains('Price alerts'));
      expect(said.hint!, contains('Receipts and nothing else.'));
      expect(borderOf(socketOf(t, ElSwitch)), theme.destructive);
      expect(
        t
            .widget<Opacity>(
              find
                  .descendant(
                    of: find.byType(ElSwitch),
                    matching: find.byType(Opacity),
                  )
                  .first,
            )
            .opacity,
        0.50,
      );
      expect(adopted(t, find.byType(ElSwitch), node), isTrue);
      semantics.dispose();
    });

    testWidgets('ElSelect takes label, description, enabled, invalid, node', (
      WidgetTester t,
    ) async {
      final SemanticsHandle semantics = t.ensureSemantics();
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);

      await t.pumpWidget(
        host(
          SizedBox(
            width: 448,
            child: ElField(
              label: 'Plan',
              description: 'Pick one you can afford.',
              errors: const <String>['Pick a plan.'],
              enabled: false,
              focusNode: node,
              child: ElSelect<String>(
                options: const <ElSelectOption<String>>[
                  ElSelectOption<String>(value: 'free', label: 'Free'),
                ],
                value: null,
                onChanged: (String _) {},
                placeholder: 'Choose a plan',
                expand: true,
              ),
            ),
          ),
        ),
      );
      await t.pumpAndSettle();
      final ElThemeData theme = themeIn(t, ElSelect<String>);

      final SemanticsProperties said = announced(
        t,
        find.byType(ElSelect<String>),
      );
      expect(said.label!, contains('Plan'));
      expect(said.hint!, contains('Pick one you can afford.'));
      expect(said.hint!, contains('Pick a plan.'));
      // Dark substitutes `border-destructive/50` for the opaque border.
      expect(
        borderOf(socketOf(t, ElSelect<String>)),
        theme.destructive.withValues(alpha: 0.50),
      );
      expect(adopted(t, find.byType(ElSelect<String>), node), isTrue);
      semantics.dispose();
    });

    testWidgets(
      'ElRadioGroup takes the legend and the node; items take the rest',
      (WidgetTester t) async {
        final SemanticsHandle semantics = t.ensureSemantics();
        final FocusNode node = FocusNode();
        addTearDown(node.dispose);

        await t.pumpWidget(
          host(
            SizedBox(
              width: 448,
              child: ElField(
                label: 'Payout rhythm',
                description: 'How often you get paid.',
                errors: const <String>['Pick a payout rhythm.'],
                focusNode: node,
                child: ElRadioGroup<String>(
                  value: null,
                  onChanged: (String _) {},
                  children: const <Widget>[
                    ElRadioGroupItem<String>(value: 'daily', label: 'Daily'),
                    ElRadioGroupItem<String>(value: 'weekly', label: 'Weekly'),
                  ],
                ),
              ),
            ),
          ),
        );
        await t.pumpAndSettle();
        final ElThemeData theme = themeIn(t, ElRadioGroupItem<String>);

        // `FormControl` wraps the RadioGroup, not the items, so the legend and
        // the description are announced on the group.
        final SemanticsProperties group = announced(
          t,
          find.byType(ElRadioGroup<String>),
        );
        expect(group.label!, contains('Payout rhythm'));
        expect(group.hint!, contains('How often you get paid.'));
        expect(group.hint!, contains('Pick a payout rhythm.'));

        // …while each item keeps its own name, never the legend.
        expect(
          announced(t, find.byType(ElRadioGroupItem<String>).at(0)).label,
          'Daily',
        );
        expect(
          announced(t, find.byType(ElRadioGroupItem<String>).at(1)).label,
          'Weekly',
        );

        // The group's `aria-invalid` paints on every item.
        expect(
          borderOf(socketOf(t, ElRadioGroupItem<String>)),
          theme.destructive,
        );

        // The field's node lands on the group and never on two Focus widgets at
        // once — the group holds it and passes the focus to the tab stop.
        expect(adopted(t, find.byType(ElRadioGroup<String>), node), isTrue);
        node.requestFocus();
        await t.pumpAndSettle();
        // `hasFocus` stays true — the item is a descendant of this node — but the
        // group never keeps the focus itself.
        expect(
          node.hasPrimaryFocus,
          isFalse,
          reason: 'the group hands the focus straight on',
        );
        expect(
          t
              .widgetList<Focus>(
                find.descendant(
                  of: find.byType(ElRadioGroupItem<String>).at(0),
                  matching: find.byType(Focus),
                ),
              )
              .any((Focus f) => f.focusNode?.hasPrimaryFocus ?? false),
          isTrue,
          reason: 'the first enabled item is the roving tab stop',
        );
        semantics.dispose();
      },
    );

    testWidgets('a disabled field disables its radio items', (
      WidgetTester t,
    ) async {
      int changes = 0;
      await t.pumpWidget(
        host(
          SizedBox(
            width: 448,
            child: ElField(
              label: 'Payout rhythm',
              enabled: false,
              child: ElRadioGroup<String>(
                value: null,
                onChanged: (String _) => changes++,
                children: const <Widget>[
                  ElRadioGroupItem<String>(value: 'daily', label: 'Daily'),
                ],
              ),
            ),
          ),
        ),
      );
      await t.tap(find.byType(ElRadioGroupItem<String>), warnIfMissed: false);
      expect(changes, 0);
      expect(
        t
            .widget<Opacity>(
              find
                  .descendant(
                    of: find.byType(ElRadioGroupItem<String>),
                    matching: find.byType(Opacity),
                  )
                  .first,
            )
            .opacity,
        0.50,
      );
    });

    testWidgets('ElForm.focusFirstError lands on a checkbox — ruling F4', (
      WidgetTester t,
    ) async {
      // The composed form's `terms`: the reference cannot focus it at all,
      // because a hand-wired Checkbox exposes no ref for `shouldFocusError` to
      // call (forms-map drift 7). Here it is a field like any other.
      //
      // Both orientations, because the composed form's `terms` is a
      // **horizontal** field and that branch once published no `ElFieldScope`
      // at all — it put its raw `child` in the Row where the vertical branch
      // put the scope-wrapped control, so the checkbox adopted nothing and a
      // failed submit focused nothing. Fixed in `field.dart`; asserted on both
      // branches here so the shape this ruling is about is the shape that is
      // measured.
      for (final ElFieldOrientation orientation in ElFieldOrientation.values) {
        final ElFormField<bool> terms = ElFormField<bool>(
          name: 'terms',
          initialValue: false,
          rules: <ElRule<bool>>[
            const ElRule<bool>(_accepted, 'You have to accept the terms.'),
          ],
        );
        final ElForm form = ElForm(fields: <ElFormFieldBase>[terms]);
        addTearDown(form.dispose);

        await t.pumpWidget(
          host(
            SizedBox(
              width: 448,
              child: ListenableBuilder(
                listenable: form,
                builder: (BuildContext context, Widget? _) => ElField(
                  key: ValueKey<ElFieldOrientation>(orientation),
                  label: 'I accept the terms',
                  errors: terms.errors,
                  focusNode: terms.focusNode,
                  orientation: orientation,
                  child: ElCheckbox(
                    state: terms.value
                        ? ElCheckboxState.checked
                        : ElCheckboxState.unchecked,
                    onChanged: (ElCheckboxState next) =>
                        terms.value = next == ElCheckboxState.checked,
                  ),
                ),
              ),
            ),
          ),
        );

        final String why = orientation.name;
        expect(terms.focusNode.hasFocus, isFalse, reason: why);
        await form.submit();
        await t.pumpAndSettle();

        expect(terms.errors, <String>[
          'You have to accept the terms.',
        ], reason: why);
        expect(terms.focusNode.hasFocus, isTrue, reason: why);
        expect(
          adopted(t, find.byType(ElCheckbox), terms.focusNode),
          isTrue,
          reason:
              '$why: the node a failed submit focuses IS the '
              'checkbox\'s own',
        );
      }
    });
  });

  // `<label for>` ACTIVATES its control — it does not merely focus it. Each
  // control registers what activating it means on the scope's
  // `ElFieldActivator`, and `ElFieldLabel` reads that at tap time.
  //
  // Every case below taps a **real** `ElFieldLabel` inside a **real**
  // `ElField`, wrapped around the real control, so the pair is what is
  // measured rather than either half against a stub.
  group('ElFieldLabel activation', () {
    /// Taps the visible label text, which is what a reader clicks.
    Future<void> tapLabel(WidgetTester t, String text) async {
      await t.tap(find.text(text));
      await t.pump();
    }

    testWidgets('a label tap ticks a real ElCheckbox', (WidgetTester t) async {
      ElCheckboxState state = ElCheckboxState.unchecked;
      await t.pumpWidget(
        host(
          SizedBox(
            width: 448,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) => ElField(
                label: 'I accept the terms',
                orientation: ElFieldOrientation.horizontal,
                child: ElCheckbox(
                  state: state,
                  onChanged: (ElCheckboxState next) =>
                      setState(() => state = next),
                ),
              ),
            ),
          ),
        ),
      );

      await tapLabel(t, 'I accept the terms');
      expect(
        state,
        ElCheckboxState.checked,
        reason: 'the label activated, it did not merely focus',
      );

      // …and back again: activation is the toggle, not "set true".
      await tapLabel(t, 'I accept the terms');
      expect(state, ElCheckboxState.unchecked);
      await t.pumpAndSettle();
    });

    testWidgets('a label tap flips a real ElSwitch', (WidgetTester t) async {
      bool on = false;
      await t.pumpWidget(
        host(
          SizedBox(
            width: 448,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) => ElField(
                label: 'Price alerts',
                orientation: ElFieldOrientation.horizontal,
                child: ElSwitch(
                  value: on,
                  onChanged: (bool next) => setState(() => on = next),
                ),
              ),
            ),
          ),
        ),
      );

      await tapLabel(t, 'Price alerts');
      expect(on, isTrue);
      await tapLabel(t, 'Price alerts');
      expect(on, isFalse);
      await t.pumpAndSettle();
    });

    testWidgets('a label tap opens a real ElSelect', (WidgetTester t) async {
      await t.pumpWidget(
        overlayHost(
          SizedBox(
            width: 448,
            child: ElField(
              label: 'Plan',
              child: ElSelect<String>(
                options: const <ElSelectOption<String>>[
                  ElSelectOption<String>(value: 'free', label: 'Free'),
                  ElSelectOption<String>(value: 'pro', label: 'Pro'),
                ],
                value: null,
                onChanged: (String _) {},
                placeholder: 'Choose a plan',
                expand: true,
              ),
            ),
          ),
        ),
      );
      expect(find.text('Free'), findsNothing);

      await tapLabel(t, 'Plan');
      expect(find.text('Free'), findsOneWidget);
      expect(find.text('Pro'), findsOneWidget);
      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await t.pumpAndSettle();
    });

    testWidgets('a legend tap focuses the radio tab stop and selects nothing', (
      WidgetTester t,
    ) async {
      String? value;
      await t.pumpWidget(
        host(
          SizedBox(
            width: 448,
            child: ElField(
              label: 'Payout rhythm',
              child: ElRadioGroup<String>(
                value: value,
                onChanged: (String next) => value = next,
                children: const <Widget>[
                  ElRadioGroupItem<String>(value: 'daily', label: 'Daily'),
                  ElRadioGroupItem<String>(value: 'weekly', label: 'Weekly'),
                ],
              ),
            ),
          ),
        ),
      );

      await tapLabel(t, 'Payout rhythm');
      await t.pumpAndSettle();

      // Focus moved to the item the roving tabindex is on…
      expect(
        t
            .widgetList<Focus>(
              find.descendant(
                of: find.byType(ElRadioGroupItem<String>).at(0),
                matching: find.byType(Focus),
              ),
            )
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
      await t.pumpWidget(
        host(
          SizedBox(
            width: 448,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) =>
                  ElRadioGroup<String>(
                    value: value,
                    onChanged: (String next) => setState(() => value = next),
                    children: const <Widget>[
                      ElField(
                        label: 'Daily',
                        orientation: ElFieldOrientation.horizontal,
                        child: ElRadioGroupItem<String>(value: 'daily'),
                      ),
                      ElField(
                        label: 'Weekly',
                        orientation: ElFieldOrientation.horizontal,
                        child: ElRadioGroupItem<String>(value: 'weekly'),
                      ),
                    ],
                  ),
            ),
          ),
        ),
      );

      await tapLabel(t, 'Weekly');
      expect(value, 'weekly');
      await t.pumpAndSettle();
    });

    testWidgets('a disabled field registers nothing', (WidgetTester t) async {
      ElCheckboxState state = ElCheckboxState.unchecked;
      await t.pumpWidget(
        host(
          SizedBox(
            width: 448,
            child: ElField(
              label: 'I accept the terms',
              enabled: false,
              orientation: ElFieldOrientation.horizontal,
              child: ElCheckbox(
                state: state,
                onChanged: (ElCheckboxState next) => state = next,
              ),
            ),
          ),
        ),
      );

      await t.tap(find.text('I accept the terms'), warnIfMissed: false);
      await t.pump();
      expect(
        state,
        ElCheckboxState.unchecked,
        reason: 'a stale toggle must not outlive the state that allowed it',
      );
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
          find.descendant(of: find.byType(of), matching: find.byType(Focus)),
        )
        .firstWhere((Focus f) => f.onKeyEvent != null);

    /// `disabled:opacity-50` / `data-disabled:opacity-50`, as the socket dims.
    double opacityOf(WidgetTester t) => t
        .widget<Opacity>(
          find
              .descendant(
                of: find.byType(ElCheckbox),
                matching: find.byType(Opacity),
              )
              .first,
        )
        .opacity;

    /// Whether a pointer reaches the control at all.
    bool ignoresPointer(WidgetTester t) => t
        .widget<IgnorePointer>(
          find
              .descendant(
                of: find.byType(ElCheckbox),
                matching: find.byType(IgnorePointer),
              )
              .first,
        )
        .ignoring;

    /// What the control hands its own [Semantics] — read off the widget for the
    /// reason the adoption group records: the annotation sits *inside*
    /// [ElHitArea], so walking the semantics tree lands somewhere else.
    SemanticsProperties announced(WidgetTester t, Finder of) => t
        .widgetList<Semantics>(
          find.descendant(of: of, matching: find.byType(Semantics)),
        )
        .first
        .properties;

    /// A checkbox whose focus this test owns, so "has the focus" and "is
    /// painted as though it had the focus" can be told apart.
    Widget ringBox(FocusNode node, {bool? force, bool invalid = false}) => host(
      ElCheckbox(
        focusNode: node,
        forceFocusRing: force,
        invalid: invalid,
        onChanged: (ElCheckboxState _) {},
      ),
    );

    testWidgets('operable, inert and disabled are three distinct states', (
      WidgetTester t,
    ) async {
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
        })
      >
      cases =
          <
            ({
              String name,
              bool enabled,
              bool inert,
              double opacity,
              bool focusable,
              bool operable,
            })
          >[
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
          })
          c
          in cases) {
        final FocusNode node = FocusNode(debugLabel: c.name);
        addTearDown(node.dispose);
        int taps = 0;
        final String why = c.name;

        await t.pumpWidget(
          host(
            ElCheckbox(
              key: ValueKey<String>(c.name),
              state: ElCheckboxState.indeterminate,
              enabled: c.enabled,
              inert: c.inert,
              focusNode: node,
              onChanged: (ElCheckboxState _) => taps++,
            ),
          ),
        );
        await t.pumpAndSettle();

        expect(
          opacityOf(t),
          c.opacity,
          reason:
              '$why: only `disabled` dims — a control held at a value is '
              'painted at full strength',
        );
        expect(
          ignoresPointer(t),
          !c.operable,
          reason:
              '$why: anything that cannot be operated is deaf to a '
              'pointer',
        );
        expect(
          controlFocus(t, ElCheckbox).canRequestFocus,
          c.focusable,
          reason:
              '$why: `disabled` leaves the tab order and a missing '
              'handler does not',
        );

        node.requestFocus();
        await t.pump();
        expect(
          node.hasPrimaryFocus,
          c.focusable,
          reason:
              '$why: and the flag is not merely declared — the focus '
              'either lands or it does not',
        );

        await t.tap(find.byType(ElCheckbox), warnIfMissed: false);
        await t.pump();
        expect(
          taps,
          c.operable ? 1 : 0,
          reason:
              '$why: a click on an inert box changes nothing, exactly as '
              'a controlled Radix checkbox with no handler does',
        );

        // The keyboard says the same thing the pointer does — which matters
        // most for the inert case, the one control here that can be focused
        // and still must not answer Space.
        await t.sendKeyEvent(LogicalKeyboardKey.space);
        await t.pump();
        expect(
          taps,
          c.operable ? 2 : 0,
          reason: '$why: Enter and Space follow operability, not focus',
        );
        await t.pumpAndSettle();
      }
    });

    testWidgets('the Indeterminate cell is announced as an enabled checkbox', (
      WidgetTester t,
    ) async {
      // `<Checkbox checked="indeterminate" aria-label="Indeterminate"/>`:
      // controlled, no `onCheckedChange`, and — the point — no `disabled`.
      final SemanticsHandle semantics = t.ensureSemantics();
      await t.pumpWidget(
        host(
          const ElCheckbox(
            state: ElCheckboxState.indeterminate,
            inert: true,
            label: 'Indeterminate',
          ),
        ),
      );
      await t.pumpAndSettle();

      final SemanticsProperties said = announced(t, find.byType(ElCheckbox));
      expect(
        said.enabled,
        isTrue,
        reason:
            'the reference measures `disabled: false`; DRIFT 7 is that '
            'assistive technology is told no more than a reader is',
      );
      expect(said.mixed, isTrue, reason: 'data-state="indeterminate"');
      expect(said.checked, isFalse);
      expect(said.label, 'Indeterminate');

      // …against the state it must not be confused with.
      await t.pumpWidget(
        host(
          const ElCheckbox(
            state: ElCheckboxState.indeterminate,
            enabled: false,
            label: 'Disabled',
          ),
        ),
      );
      await t.pumpAndSettle();
      expect(
        announced(t, find.byType(ElCheckbox)).enabled,
        isFalse,
        reason: '`disabled` is announced, and inert is not',
      );
      semantics.dispose();
    });

    testWidgets('an inert box registers no activation on its field label', (
      WidgetTester t,
    ) async {
      // `<label for>` activates the control it points at — and a control Radix
      // holds at a value has no activation to offer, so the words are inert
      // too.
      ElCheckboxState state = ElCheckboxState.indeterminate;
      await t.pumpWidget(
        host(
          SizedBox(
            width: 448,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) => ElField(
                label: 'Partial bulk selection',
                orientation: ElFieldOrientation.horizontal,
                child: ElCheckbox(
                  state: state,
                  inert: true,
                  onChanged: (ElCheckboxState next) =>
                      setState(() => state = next),
                ),
              ),
            ),
          ),
        ),
      );

      await t.tap(find.text('Partial bulk selection'), warnIfMissed: false);
      await t.pump();
      expect(
        state,
        ElCheckboxState.indeterminate,
        reason: 'the box is held at its prop value from every direction',
      );
      await t.pumpAndSettle();
    });

    testWidgets('forceFocusRing paints a ring nothing is focused for', (
      WidgetTester t,
    ) async {
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);

      await t.pumpWidget(ringBox(node, force: true));
      final ElThemeData theme = themeIn(t, ElCheckbox);
      await t.pumpAndSettle();
      expect(
        node.hasPrimaryFocus,
        isFalse,
        reason:
            'the cell is a lie painted with class names — nothing on the '
            'reference page has the focus either',
      );
      expect(
        borderOf(socketOf(t, ElCheckbox)),
        theme.ring,
        reason:
            '`border-ring`, with tw-merge having deleted `border-input` '
            'from the string outright',
      );
      expect(
        ringOf(socketOf(t, ElCheckbox), theme).a,
        closeTo(0.50, 0.001),
        reason: '`ring-3 ring-ring/50`',
      );

      // `false` withholds the ring from a control that genuinely has the focus.
      await t.pumpWidget(ringBox(node, force: false));
      node.requestFocus();
      await t.pumpAndSettle();
      expect(node.hasPrimaryFocus, isTrue, reason: 'the focus is real here');
      expect(
        borderOf(socketOf(t, ElCheckbox)),
        theme.input,
        reason: 'and the socket is still at rest',
      );
      expect(
        ringOf(socketOf(t, ElCheckbox), theme).a,
        closeTo(0, 0.001),
        reason:
            'the resting ring is the hue at zero alpha, and a 3px spread '
            'of nothing paints nothing',
      );

      // `null` — the default — follows the real focus, in both directions.
      await t.pumpWidget(ringBox(node));
      await t.pumpAndSettle();
      expect(
        borderOf(socketOf(t, ElCheckbox)),
        theme.ring,
        reason: 'still focused, and now the ring is allowed to say so',
      );
      expect(ringOf(socketOf(t, ElCheckbox), theme).a, closeTo(0.50, 0.001));

      node.unfocus();
      await t.pumpAndSettle();
      expect(
        borderOf(socketOf(t, ElCheckbox)),
        theme.input,
        reason: 'and back to rest when the focus leaves',
      );
    });

    testWidgets('aria-invalid still beats a forced ring — F5 order kept', (
      WidgetTester t,
    ) async {
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);

      await t.pumpWidget(ringBox(node, force: true, invalid: true));
      final ElThemeData theme = themeIn(t, ElCheckbox);
      await t.pumpAndSettle();
      expect(
        borderOf(socketOf(t, ElCheckbox)),
        theme.destructive,
        reason:
            'the invalid branch is tested first in both colour targets, '
            'so a forced ring is as invisible as a real focus is',
      );
      expect(
        ringOf(socketOf(t, ElCheckbox), theme),
        theme.destructive.withValues(alpha: 0.20),
        reason: '`aria-invalid:ring-3 ring-destructive/20`',
      );
    });

    testWidgets('the radio matrix gets the same painted ring', (
      WidgetTester t,
    ) async {
      // The second of the page's two fakes, and the reason the flag exists at
      // all: Flutter has exactly one focus and this page renders two focused
      // controls.
      await t.pumpWidget(
        host(
          SizedBox(
            width: 200,
            child: ElRadioGroup<String>(
              value: null,
              onChanged: (String _) {},
              children: const <Widget>[
                ElRadioGroupItem<String>(
                  value: 'a',
                  forceFocusRing: true,
                  label: 'Focus',
                ),
              ],
            ),
          ),
        ),
      );
      final ElThemeData theme = themeIn(t, ElRadioGroupItem<String>);
      await t.pumpAndSettle();
      expect(
        borderOf(socketOf(t, ElRadioGroupItem<String>)),
        theme.ring,
        reason: 'the item wears `border-ring` with nothing focused',
      );
      expect(
        ringOf(socketOf(t, ElRadioGroupItem<String>), theme).a,
        closeTo(0.50, 0.001),
        reason:
            '`ring-3 ring-ring/50`, character-identical to the checkbox '
            'cell',
      );
    });

    testWidgets('ElFieldLabel takes a spec, and `normal` is font-normal', (
      WidgetTester t,
    ) async {
      // `<FieldLabel htmlFor={…} className="font-normal">` — probed on the
      // filter list at 13px, a 17.875px line box, weight 400, `--foreground`.
      expect(ElFieldLabel.normal.family, ElComponentType.fieldLabel.family);
      expect(
        ElFieldLabel.normal.size,
        ElComponentType.fieldLabel.size,
        reason: '`font-normal` declares one property: `text-sm` survives it',
      );
      expect(
        ElFieldLabel.normal.height,
        ElComponentType.fieldLabel.height,
        reason: '…and so does `leading-snug`, which is the whole point',
      );
      expect(
        ElFieldLabel.normal.variations.first.value,
        ElComponentType.textSm.variations.first.value,
        reason:
            'the weight is borrowed from the token that already records '
            'the 400 `html` gives, never typed into this layer',
      );

      await t.pumpWidget(
        host(
          SizedBox(
            width: 448,
            child: ElFieldLabel('Available now', spec: ElFieldLabel.normal),
          ),
        ),
      );
      final TextStyle overridden = t
          .widget<Text>(find.text('Available now'))
          .style!;
      expect(
        overridden.fontWeight,
        FontWeight.w400,
        reason: 'the resolved style, read off the tree',
      );
      expect(overridden.fontSize, 13);
      expect(overridden.height, closeTo(1.375, 0.000001));
      expect(
        t.getSize(find.byType(ElText)).height,
        closeTo(17.875, 0.001),
        reason: 'the probed line box: 13 × 1.375',
      );

      // …and the default is what `Label` types itself in, unchanged.
      await t.pumpWidget(
        host(const SizedBox(width: 448, child: ElFieldLabel('Available now'))),
      );
      final TextStyle byDefault = t
          .widget<Text>(find.text('Available now'))
          .style!;
      expect(
        byDefault.fontWeight,
        FontWeight.w500,
        reason: '`Label`\'s own `font-medium`, with nothing overriding it',
      );
      expect(
        byDefault.fontSize,
        overridden.fontSize,
        reason: 'and the two differ in nothing but the weight',
      );
      expect(byDefault.height, overridden.height);
    });
  });

  // RETUNED BY WAVE B2 — supervisor ruling F4. These four pinned a toaster
  // that stacked at full size with a flat gap and no entrance, so each of them
  // read the toast on the frame it was queued. A sonner toast is not there yet
  // on that frame: it mounts at `translateY(100%)` / `opacity: 0`, flips
  // `data-mounted` one frame later, and only then travels. Its height is not
  // known on that frame either — the host measures it out of layout, exactly as
  // sonner reads `getBoundingClientRect()` out of an effect, so nothing is
  // positioned or hit-testable until the measurement lands.
  //
  // Every change below is one of those two facts and nothing else: the
  // assertions are the same assertions. Bite-proven — all three of the pins
  // that needed a pump failed first against the new behaviour (the entrance
  // put the anchor 28.57px low, and the tap missed a stack that had not been
  // measured yet), which is what says they were pinning the old choreography
  // rather than the contract.
  group('ElToaster', () {
    Widget toaster(ElToastController controller) => host(
      SizedBox(
        width: 1440,
        height: 900,
        child: ElToaster(controller: controller),
      ),
    );

    /// The mount frame, the measure-then-lay-out round trip, and the entrance.
    ///
    /// No `pumpAndSettle`: a toast carries a `ElBloomCosmic`, which runs two
    /// forever loops, so a settle would never return.
    Future<void> arrive(WidgetTester t) async {
      await t.pump(); // data-mounted flips, the height is reported
      await t.pump(); // the entrance retargets off the reported height
      await t.pump(ElToaster.transition);
    }

    testWidgets('shows nothing until something is queued', (
      WidgetTester t,
    ) async {
      final ElToastController controller = ElToastController();
      addTearDown(controller.dispose);
      await t.pumpWidget(toaster(controller));
      expect(find.byType(ElToast), findsNothing);

      controller.success('Saved as @ayoub');
      await t.pump();
      expect(find.byType(ElToast), findsOneWidget);
      expect(find.text('Saved as @ayoub'), findsOneWidget);
      // The lifetime clock is a ticker now, because sonner's hover-pause
      // stores a remainder and a remainder is what a ticker already holds — so
      // it starts on the frame after it is armed, the way sonner's own
      // `startTimer` runs after paint.
      await t.pump();
      await t.pump(ElToaster.lifetime);
      await t.pump(ElToaster.unmountDelay);
      expect(find.byType(ElToast), findsNothing);
    });

    testWidgets('three are visible and the rest queue', (WidgetTester t) async {
      final ElToastController controller = ElToastController();
      addTearDown(controller.dispose);
      await t.pumpWidget(toaster(controller));
      for (int i = 0; i < 5; i++) {
        controller.error('Could not claim that handle $i');
      }
      await t.pump();
      expect(controller.length, 5);
      expect(controller.visibleCount, 3);
      expect(find.byType(ElToast), findsNWidgets(3));
      // Newest sits closest to the corner.
      expect(find.text('Could not claim that handle 4'), findsOneWidget);
      expect(find.text('Could not claim that handle 0'), findsNothing);
      controller.clear();
      await t.pump();
    });

    testWidgets('a tap dismisses over the unmount window', (
      WidgetTester t,
    ) async {
      final ElToastController controller = ElToastController();
      addTearDown(controller.dispose);
      await t.pumpWidget(toaster(controller));
      controller.success('Preferences saved');
      await arrive(t);

      await t.tap(find.byType(ElToast));
      await t.pump();
      // Still mounted, on its way out.
      expect(find.byType(ElToast), findsOneWidget);
      await t.pump(ElToaster.unmountDelay);
      expect(find.byType(ElToast), findsNothing);
      expect(controller.length, 0);
    });

    testWidgets('anchors bottom-right, 24px in', (WidgetTester t) async {
      final ElToastController controller = ElToastController();
      addTearDown(controller.dispose);
      await t.pumpWidget(toaster(controller));
      controller.success('Account saved');
      await arrive(t);

      final Rect frame = t.getRect(find.byType(ElToaster));
      final Rect toast = t.getRect(find.byType(ElToast));
      expect(frame.right - toast.right, 24);
      expect(frame.bottom - toast.bottom, closeTo(24, 1e-9));
      controller.clear();
      await t.pump();
    });
  });
}
