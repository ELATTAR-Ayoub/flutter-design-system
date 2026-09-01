import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/rendering.dart' hide ScrollDirection;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Form,
        FormField,
        Icon,
        OverlayPortal,
        RadioGroup,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;
import 'package:flutter_test/flutter_test.dart';

/// Selection and feedback: the three toggles, the select, the alert and the
/// toast host. One state matrix each, pinned against `forms-map.md` and the six
/// reference sources it cites.

Widget host(Widget child, {ColorMode mode = ColorMode.dark}) {
  return MediaQuery(
    data: const MediaQueryData(size: Size(1440, 900)),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: ThemeScope(
        controller: ThemeController(mode: mode),
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
Widget overlayHost(Widget child, {ColorMode mode = ColorMode.dark}) {
  _hosted = child;
  return MediaQuery(
    data: const MediaQueryData(size: Size(1440, 900)),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: ThemeScope(
        controller: ThemeController(mode: mode),
        child: Overlay(
          initialEntries: <OverlayEntry>[
            OverlayEntry(builder: (BuildContext _) => Center(child: _hosted)),
          ],
        ),
      ),
    ),
  );
}

ThemeTokens themeIn(WidgetTester t, Type of) =>
    ThemeScope.of(t.element(find.byType(of).first));

/// The socket a control paints — the first [Surface] inside it, which
/// is the control's own surface rather than an indicator's.
Surface socketOf(WidgetTester t, Type of) => t.widget<Surface>(
  find.descendant(of: find.byType(of), matching: find.byType(Surface)).first,
);

Color borderOf(Surface surface) => (surface.border! as Border).top.color;

/// The `ring-3` layer `Button.withFocusRing` prepends: zero offset, zero
/// blur, 3px spread.
Color ringOf(Surface surface, ThemeTokens theme) =>
    surface.spec.layers.first.color(theme);

/// `z.boolean().refine(v => v, …)` — the one rule the `terms` field carries.
bool _accepted(bool value) => value;

/// The [FocusNode] a radio item's own [Focus] carries — the ones with a key
/// handler, which the `Visibility` wrappers inside an indicator do not have.
FocusNode itemFocus(WidgetTester t, int index) => t
    .widgetList<Focus>(
      find.descendant(
        of: find.byType(RadioGroup<String>),
        matching: find.byType(Focus),
      ),
    )
    .where((Focus f) => f.onKeyEvent != null)
    .elementAt(index)
    .focusNode!;

void main() {
  group('Checkbox', () {
    testWidgets('is 20px on a 6px corner', (WidgetTester t) async {
      await t.pumpWidget(host(const Checkbox()));
      expect(t.getSize(find.byType(SelectionControl)), const Size(20, 20));
      expect(Checkbox.size, 20);
      expect(socketOf(t, Checkbox).radius, BorderRadius.circular(Radii.sm));
    });

    testWidgets('the socket lights on check: pressed → btn-primary', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(const Checkbox()));
      final ThemeTokens theme = themeIn(t, Checkbox);
      expect(
        socketOf(t, Checkbox).spec.layers.skip(1).toList(),
        Shadows.inset.layers,
      );
      expect(socketOf(t, Checkbox).fill, theme.card);
      expect(borderOf(socketOf(t, Checkbox)), theme.input);

      await t.pumpWidget(host(const Checkbox(state: CheckboxState.checked)));
      await t.pump(MotionDurations.normal);
      expect(
        socketOf(t, Checkbox).spec.layers.skip(1).toList(),
        Shadows.controlPrimary.layers,
      );
      expect(socketOf(t, Checkbox).fill, theme.primary);
      expect(borderOf(socketOf(t, Checkbox)), theme.primary);
    });

    /// The mark's own player, told apart from [StateChangeFeedback]'s by its
    /// duration: a draw runs 280ms or 200ms, the squash 600.
    Finder markPlayer() => find.byWidgetPredicate(
      (Widget w) =>
          w is KeyframePlayer &&
          (w.duration == CheckmarkDrawMotion.duration ||
              w.duration == DashDrawMotion.duration),
    );

    testWidgets('mounts no indicator while unchecked, and one when lit', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(const Checkbox()));
      expect(markPlayer(), findsNothing);

      // Exactly ONE mark is mounted at a time. The old model mounted both and
      // hid one, which is what made a swap reveal a finished stroke.
      await t.pumpWidget(host(const Checkbox(state: CheckboxState.checked)));
      expect(markPlayer(), findsOneWidget);
      await t.pump(StateChangeMotion.duration);

      await t.pumpWidget(
        host(const Checkbox(state: CheckboxState.indeterminate)),
      );
      expect(markPlayer(), findsOneWidget);
      await t.pump(StateChangeMotion.duration);

      // Going out is an unmount, not a reverse draw and not a fade.
      await t.pumpWidget(host(const Checkbox()));
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
      await t.pumpWidget(host(const Checkbox(state: CheckboxState.checked)));
      await t.pump(CheckmarkDrawMotion.duration);
      await t.pump(StateChangeMotion.duration);
      final Element tick = t.element(markPlayer());
      expect(
        t.widget<KeyframePlayer>(markPlayer()).duration,
        CheckmarkDrawMotion.duration,
      );

      // checked -> indeterminate re-runs `dash-draw`, all 200ms of it.
      await t.pumpWidget(
        host(const Checkbox(state: CheckboxState.indeterminate)),
      );
      await t.pump();
      expect(
        t.element(markPlayer()),
        isNot(tick),
        reason: 'a fresh player, not the finished bar re-shown',
      );
      expect(
        t.widget<KeyframePlayer>(markPlayer()).duration,
        DashDrawMotion.duration,
      );
      await t.pump(DashDrawMotion.duration);
      await t.pump(StateChangeMotion.duration);

      // …and indeterminate -> checked re-runs `check-draw`.
      final Element bar = t.element(markPlayer());
      await t.pumpWidget(host(const Checkbox(state: CheckboxState.checked)));
      await t.pump();
      expect(
        t.element(markPlayer()),
        isNot(bar),
        reason: 'the tick starts over too',
      );
      expect(
        t.widget<KeyframePlayer>(markPlayer()).duration,
        CheckmarkDrawMotion.duration,
      );
      await t.pump(CheckmarkDrawMotion.duration);
      await t.pump(StateChangeMotion.duration);
    });

    testWidgets('the tick draws itself on over 280ms', (WidgetTester t) async {
      expect(CheckmarkDrawMotion.duration, MotionDurations.checkDraw);
      expect(CheckmarkDrawMotion.drawnFractionAt(0), 0);
      expect(CheckmarkDrawMotion.drawnFractionAt(1), 1);
      expect(DashDrawMotion.duration, MotionDurations.dashDraw);

      await t.pumpWidget(host(const Checkbox(state: CheckboxState.checked)));
      await t.pump(const Duration(milliseconds: 140));
      // Mid-flight: part of the stroke, not all of it.
      final double half = CheckmarkDrawMotion.drawnFractionAt(0.5);
      expect(half, greaterThan(0));
      expect(half, lessThan(1));
      await t.pump(CheckmarkDrawMotion.duration);
    });

    testWidgets('a click toggles the way Radix does', (WidgetTester t) async {
      expect(
        Checkbox.nextAfter(CheckboxState.unchecked),
        CheckboxState.checked,
      );
      expect(
        Checkbox.nextAfter(CheckboxState.indeterminate),
        CheckboxState.checked,
      );
      expect(
        Checkbox.nextAfter(CheckboxState.checked),
        CheckboxState.unchecked,
      );

      CheckboxState? seen;
      await t.pumpWidget(
        host(
          Checkbox(
            state: CheckboxState.unchecked,
            onChanged: (CheckboxState next) => seen = next,
          ),
        ),
      );
      await t.tap(find.byType(Checkbox));
      expect(seen, CheckboxState.checked);
    });

    testWidgets(
      'answers a pointer 42 × 34 — the pseudo-element, not the paint',
      (WidgetTester t) async {
        int taps = 0;
        await t.pumpWidget(
          host(Checkbox(onChanged: (CheckboxState _) => taps++)),
        );
        // The box is 20 × 20 and takes 20 × 20 of layout…
        expect(t.getSize(find.byType(HitArea)), const Size(20, 20));
        final Offset centre = t.getCenter(find.byType(Checkbox));

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
      await t.pumpWidget(host(const Switch(value: false)));
      expect(
        find.byType(KeyframePlayer),
        findsNothing,
        reason: 'a MutationObserver does not report initial state',
      );

      await t.pumpWidget(host(const Switch(value: true)));
      expect(find.byType(KeyframePlayer), findsOneWidget);
      await t.pumpAndSettle();

      // …and again on the way back.
      await t.pumpWidget(host(const Switch(value: false)));
      expect(find.byType(KeyframePlayer), findsOneWidget);
      await t.pumpAndSettle();
      expect(StateChangeMotion.duration, MotionDurations.stateChange);
    });

    testWidgets('aria-invalid beats focus-visible — F5, drift 6', (
      WidgetTester t,
    ) async {
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);

      await t.pumpWidget(
        host(
          Checkbox(
            invalid: true,
            focusNode: node,
            onChanged: (CheckboxState _) {},
          ),
        ),
      );
      final ThemeTokens theme = themeIn(t, Checkbox);
      await t.pump(MotionDurations.normal);
      final Color restBorder = borderOf(socketOf(t, Checkbox));
      final Color restRing = ringOf(socketOf(t, Checkbox), theme);
      expect(restBorder, theme.destructive);

      node.requestFocus();
      await t.pump();
      await t.pumpAndSettle();
      // Focusing an errored control produces no visible change at all.
      expect(borderOf(socketOf(t, Checkbox)), restBorder);
      expect(ringOf(socketOf(t, Checkbox), theme), restRing);
    });

    testWidgets('focus rings at ring/50 when valid', (WidgetTester t) async {
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      await t.pumpWidget(
        host(Checkbox(focusNode: node, onChanged: (CheckboxState _) {})),
      );
      final ThemeTokens theme = themeIn(t, Checkbox);
      node.requestFocus();
      await t.pump();
      await t.pumpAndSettle();
      expect(borderOf(socketOf(t, Checkbox)), theme.ring);
      expect(ringOf(socketOf(t, Checkbox), theme).a, closeTo(0.50, 0.001));
    });

    testWidgets('Space and Enter operate it', (WidgetTester t) async {
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      int taps = 0;
      await t.pumpWidget(
        host(Checkbox(focusNode: node, onChanged: (CheckboxState _) => taps++)),
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
        host(Checkbox(enabled: false, onChanged: (CheckboxState _) => taps++)),
      );
      expect(
        t
            .widget<Opacity>(
              find
                  .descendant(
                    of: find.byType(Checkbox),
                    matching: find.byType(Opacity),
                  )
                  .first,
            )
            .opacity,
        0.50,
      );
      await t.tap(find.byType(Checkbox), warnIfMissed: false);
      expect(taps, 0);
    });
  });

  group('RadioGroup', () {
    Widget group(
      String? value,
      ValueChanged<String>? onChanged, {
      double? gap,
    }) => host(
      SizedBox(
        width: 200,
        child: RadioGroup<String>(
          value: value,
          onChanged: onChanged,
          gap: gap,
          children: const <Widget>[
            RadioGroupItem<String>(value: 'daily', label: 'Daily'),
            RadioGroupItem<String>(value: 'weekly', label: 'Weekly'),
          ],
        ),
      ),
    );

    testWidgets('items are 20px circles', (WidgetTester t) async {
      await t.pumpWidget(group(null, (String _) {}));
      expect(
        t.getSize(find.byType(SelectionControl).first),
        const Size(20, 20),
      );
      expect(RadioGroupItem.size, 20);
      expect(
        socketOf(t, RadioGroupItem<String>).radius,
        BorderRadius.circular(10),
      );
    });

    testWidgets('gap-2 by default, gap-3 as the composed form passes', (
      WidgetTester t,
    ) async {
      expect(RadioGroup.defaultGap, 8);
      await t.pumpWidget(group(null, (String _) {}));
      final double a =
          t.getTopLeft(find.byType(RadioGroupItem<String>).at(1)).dy -
          t.getBottomLeft(find.byType(RadioGroupItem<String>).at(0)).dy;
      expect(a, 8);

      await t.pumpWidget(group(null, (String _) {}, gap: 12));
      final double b =
          t.getTopLeft(find.byType(RadioGroupItem<String>).at(1)).dy -
          t.getBottomLeft(find.byType(RadioGroupItem<String>).at(0)).dy;
      expect(b, 12);
    });

    testWidgets('the dot mounts only when checked, at 8px on e1', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(group(null, (String _) {}));
      final Finder surfaces = find.descendant(
        of: find.byType(RadioGroupItem<String>).at(0),
        matching: find.byType(Surface),
      );
      // Only the socket, while nothing is chosen.
      expect(surfaces, findsOneWidget);

      await t.pumpWidget(group('daily', (String _) {}));
      expect(surfaces, findsNWidgets(2));
      final Surface dot = t.widget<Surface>(surfaces.last);
      expect(dot.spec.layers, Shadows.sm.layers);
      await t.pumpAndSettle();
      expect(t.getSize(surfaces.last), const Size(8, 8));
    });

    testWidgets('dot-pop overshoots to 1.35 at 55%', (WidgetTester t) async {
      expect(DotSelectionMotion.duration, MotionDurations.dotPop);
      expect(DotSelectionMotion.curve, MotionCurves.emphasized);
      expect(DotSelectionMotion.scale.transform(0), 0);
      expect(DotSelectionMotion.scale.transform(0.55), closeTo(1.35, 0.001));
      expect(DotSelectionMotion.scale.transform(1), 1);
    });

    testWidgets('the socket lights on selection', (WidgetTester t) async {
      await t.pumpWidget(group('daily', (String _) {}));
      final ThemeTokens theme = themeIn(t, RadioGroupItem<String>);
      await t.pump(MotionDurations.normal);
      expect(socketOf(t, RadioGroupItem<String>).fill, theme.primary);
      expect(
        socketOf(t, RadioGroupItem<String>).spec.layers.skip(1).toList(),
        Shadows.controlPrimary.layers,
      );
    });

    testWidgets('arrows move and select, and they wrap', (
      WidgetTester t,
    ) async {
      String? value = 'daily';
      await t.pumpWidget(group(value, (String next) => value = next));
      // Flutter does not move focus on a pointer tap — the same predicate
      // `Button` relies on for `:focus-visible` — so the tab stop is asked
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
              of: find.byType(RadioGroup<String>),
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
                    of: find.byType(RadioGroupItem<String>).at(0),
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
        find.byType(RadioGroupItem<String>).at(0),
        warnIfMissed: false,
      );
    });
  });

  group('Switch', () {
    testWidgets('44 × 24 with a 20px thumb, 36 × 20 with a 16px one', (
      WidgetTester t,
    ) async {
      expect(SwitchSize.md.trackWidth, 44);
      expect(SwitchSize.md.trackHeight, 24);
      expect(SwitchSize.md.thumbSize, 20);
      expect(SwitchSize.md.travel, 20);
      expect(SwitchSize.md.label, 'default');
      expect(SwitchSize.sm.trackWidth, 36);
      expect(SwitchSize.sm.trackHeight, 20);
      expect(SwitchSize.sm.thumbSize, 16);
      expect(SwitchSize.sm.travel, 16);

      await t.pumpWidget(host(const Switch(value: false)));
      expect(t.getSize(find.byType(SelectionControl)), const Size(44, 24));
    });

    testWidgets('the thumb travels 20px and ends flush with the border', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(const Switch(value: false)));
      final Finder thumb = find
          .descendant(of: find.byType(Switch), matching: find.byType(Surface))
          .last;
      final double trackLeft = t.getTopLeft(find.byType(Switch)).dx;
      // border 1 + padding 2.
      expect(t.getTopLeft(thumb).dx - trackLeft, 3);

      await t.pumpWidget(host(const Switch(value: true)));
      await t.pumpAndSettle();
      // 20px of travel on a 38px content box: the knob spends its left-hand
      // air and lands against the inner edge of the border.
      expect(t.getTopLeft(thumb).dx - trackLeft, 23);
      expect(t.getBottomRight(thumb).dx - trackLeft, 43);
    });

    testWidgets('the track is recessed and the knob is raised', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(const Switch(value: false)));
      final ThemeTokens theme = themeIn(t, Switch);
      expect(socketOf(t, Switch).fill, theme.muted);
      expect(
        socketOf(t, Switch).spec.layers.skip(1).toList(),
        Shadows.inset.layers,
      );

      final Surface thumb = t.widget<Surface>(
        find
            .descendant(of: find.byType(Switch), matching: find.byType(Surface))
            .last,
      );
      expect(thumb.spec.layers, Shadows.control.layers);
      expect(thumb.fill, theme.foreground);

      await t.pumpWidget(host(const Switch(value: true)));
      await t.pumpAndSettle();
      expect(socketOf(t, Switch).fill, theme.primary);
      expect(
        socketOf(t, Switch).spec.layers.skip(1).toList(),
        Shadows.controlPrimary.layers,
      );
      // The knob is raised in both states — that opposition is the point.
      expect(
        t
            .widget<Surface>(
              find
                  .descendant(
                    of: find.byType(Switch),
                    matching: find.byType(Surface),
                  )
                  .last,
            )
            .spec
            .layers,
        Shadows.control.layers,
      );
    });

    testWidgets('answers a pointer 66 × 38', (WidgetTester t) async {
      int taps = 0;
      await t.pumpWidget(
        host(Switch(value: false, onChanged: (bool _) => taps++)),
      );
      final Offset centre = t.getCenter(find.byType(Switch));

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
      await t.pumpWidget(host(const Switch(value: false)));
      final TweenAnimationBuilder<double> thumb = t
          .widget<TweenAnimationBuilder<double>>(
            find.byType(TweenAnimationBuilder<double>),
          );
      expect(thumb.curve, MotionCurves.emphasized);
      expect(thumb.duration, MotionDurations.normal);

      final TweenAnimationBuilder<Color?> track = t
          .widget<TweenAnimationBuilder<Color?>>(
            find.byType(TweenAnimationBuilder<Color?>).first,
          );
      expect(track.curve, MotionCurves.enter);
      expect(track.duration, MotionDurations.normal);
    });
  });

  group('Select', () {
    List<SelectOption<String>> options() => const <SelectOption<String>>[
      SelectOption<String>(value: 'free', label: 'Free'),
      SelectOption<String>(value: 'pro', label: 'Pro'),
      SelectOption<String>(value: 'vault', label: 'Vault'),
    ];

    Widget select(String? value, ValueChanged<String>? onChanged) =>
        overlayHost(
          SizedBox(
            width: 448,
            child: Select<String>(
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
      expect(SelectSize.md.height, 40);
      expect(SelectSize.sm.height, 32);
      expect(SelectSize.md.label, 'default');

      await t.pumpWidget(select(null, (String _) {}));
      expect(t.getSize(find.byType(Select<String>)).height, 40);
      expect(
        socketOf(t, Select<String>).spec.layers.skip(1).toList(),
        Shadows.inset.layers,
      );
      expect(
        socketOf(t, Select<String>).radius,
        BorderRadius.circular(Radii.full),
      );
    });

    testWidgets('the placeholder is muted until something is chosen', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(select(null, (String _) {}));
      final ThemeTokens theme = themeIn(t, Select<String>);
      expect(find.text('Choose a plan'), findsOneWidget);
      expect(
        t.widget<StyledText>(find.byType(StyledText).first).color,
        theme.mutedForeground,
      );

      await t.pumpWidget(select('pro', (String _) {}));
      expect(find.text('Pro'), findsOneWidget);
      expect(
        t.widget<StyledText>(find.byType(StyledText).first).color,
        theme.foreground,
      );
    });

    testWidgets('a click opens a menu of every option', (WidgetTester t) async {
      await t.pumpWidget(select(null, (String _) {}));
      expect(find.text('Free'), findsNothing);

      await t.tap(find.byType(Select<String>));
      await t.pump();
      expect(find.text('Free'), findsOneWidget);
      expect(find.text('Pro'), findsOneWidget);
      expect(find.text('Vault'), findsOneWidget);
    });

    testWidgets('the menu does not animate — drift 10', (WidgetTester t) async {
      await t.pumpWidget(select(null, (String _) {}));
      await t.tap(find.byType(Select<String>));
      await t.pump();
      final Size opened = t.getSize(find.text('Free'));
      // One frame later, with no time elapsed, the menu is already whole.
      await t.pump();
      expect(t.getSize(find.text('Free')), opened);
    });

    testWidgets('a row is py-2 pl-3 pr-9 on a text-sm line box, centred in the '
        'touch-floored row', (WidgetTester t) async {
      // TARGET SIZING: the reference reads `py-2` around one line box
      // (40px total); the row's real layout is floored at
      // TouchTargets.minimum (44) — see `lib/src/components/ui/select.dart`.
      expect(Select.itemHeight, TouchTargets.minimum);

      await t.pumpWidget(select(null, (String _) {}));
      await t.tap(find.byType(Select<String>));
      await t.pump();
      final Rect row = t.getRect(
        find
            .ancestor(of: find.text('Free'), matching: find.byType(Padding))
            .first,
      );
      // The `StyledText` box is the CSS line box; the paragraph inside it is
      // shorter by the half-leading, so the padding is read off the former.
      final Rect text = t.getRect(
        find.ancestor(of: find.text('Free'), matching: find.byType(StyledText)),
      );
      expect(text.left - row.left, 12);
      expect(row.right - text.right, closeTo(36, 0.001));
      // The row's padded box is forced to the floored row height, so the
      // 4px of slack over the reference's 40px is split evenly above and
      // below the line box by the row's own vertical centring: `py-2` (8)
      // plus half of (44 − 40).
      expect(text.top - row.top, closeTo(10, 0.001));
    });

    testWidgets('the keyboard walks it and Enter commits', (
      WidgetTester t,
    ) async {
      String? picked;
      await t.pumpWidget(select(null, (String value) => picked = value));
      await t.tap(find.byType(Select<String>));
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
      await t.tap(find.byType(Select<String>));
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
      await t.tap(find.byType(Select<String>));
      await t.pump();
      final Surface content = t.widget<Surface>(find.byType(Surface).last);
      expect(content.spec.layers.skip(1).toList(), Shadows.popover.layers);
      expect(content.spec.layers.first.spread, BorderWidths.hairline);
      expect(content.radius, BorderRadius.circular(Radii.lg));
    });

    testWidgets('aria-invalid beats focus on the trigger too', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        overlayHost(
          Select<String>(
            options: options(),
            value: null,
            onChanged: (String _) {},
            invalid: true,
          ),
        ),
      );
      final ThemeTokens theme = themeIn(t, Select<String>);
      await t.pumpAndSettle();
      // `Select` is the only control with `dark:` overrides on the invalid
      // state — `border-destructive/50` and `ring-destructive/40`.
      expect(
        borderOf(socketOf(t, Select<String>)),
        theme.destructive.withValues(alpha: 0.50),
      );
      expect(
        ringOf(socketOf(t, Select<String>), theme).a,
        closeTo(0.40, 0.001),
      );
    });

    testWidgets('dark is the only theme with a hover fill — drift 17/18', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        overlayHost(
          Select<String>(
            options: options(),
            value: null,
            onChanged: (String _) {},
          ),
          mode: ColorMode.light,
        ),
      );
      final ThemeTokens light = themeIn(t, Select<String>);
      expect(socketOf(t, Select<String>).fill, light.card);

      await t.pumpWidget(
        overlayHost(
          Select<String>(
            options: options(),
            value: null,
            onChanged: (String _) {},
          ),
        ),
      );
      final ThemeTokens dark = themeIn(t, Select<String>);
      await t.pump(MotionDurations.normal);
      expect(
        socketOf(t, Select<String>).fill,
        dark.input.withValues(alpha: 0.30),
      );
    });
  });

  group('Alert', () {
    testWidgets('every variant shares the surface and spends one colour', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          const SizedBox(
            width: 448,
            child: Alert(title: 'Could not save', description: 'Try again.'),
          ),
        ),
      );
      final ThemeTokens theme = themeIn(t, Alert);
      const Map<AlertVariant, String> labels = <AlertVariant, String>{
        AlertVariant.normal: 'default',
        AlertVariant.destructive: 'destructive',
        AlertVariant.success: 'success',
        AlertVariant.warning: 'warning',
        AlertVariant.info: 'info',
      };
      expect(labels.length, AlertVariant.values.length);
      for (final MapEntry<AlertVariant, String> e in labels.entries) {
        expect(e.key.label, e.value);
      }
      expect(AlertVariant.normal.inkOf(theme), theme.mutedForeground);
      expect(AlertVariant.destructive.inkOf(theme), theme.destructiveText);
      expect(AlertVariant.success.inkOf(theme), theme.successText);
      expect(AlertVariant.warning.inkOf(theme), theme.warningText);
      expect(AlertVariant.info.inkOf(theme), theme.infoText);
    });

    testWidgets('16 / 14 padding on a 12px corner, 12px beside the glyph', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          SizedBox(
            width: 448,
            child: Alert(
              variant: AlertVariant.destructive,
              icon: const Icon(IconGlyph.info),
              title: 'Could not save',
              description: 'That handle belongs to someone else.',
            ),
          ),
        ),
      );
      final Rect alert = t.getRect(find.byType(Alert));
      final Rect icon = t.getRect(find.byType(Icon));
      // px-4 plus the 1px border.
      expect(icon.left - alert.left, closeTo(17, 0.001));
      // py-3.5 plus the border, plus the glyph's own translate-y-0.5.
      expect(icon.top - alert.top, closeTo(17, 0.001));

      final Rect title = t.getRect(find.text('Could not save'));
      expect(title.left - icon.right, closeTo(12, 0.001));
      expect(
        t.widget<FeedbackSurface>(find.byType(FeedbackSurface)).radius,
        BorderRadius.circular(Radii.lg),
      );
    });

    testWidgets('the title is 13/500 and the description 13 muted', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        host(
          const SizedBox(
            width: 448,
            child: Alert(title: 'Could not save', description: 'Try again.'),
          ),
        ),
      );
      final ThemeTokens theme = themeIn(t, Alert);
      final StyledText title = t.widget<StyledText>(
        find.byType(StyledText).first,
      );
      expect(title.spec, same(TextStyles.h4));
      expect(title.color, theme.cardForeground);

      final StyledText body = t.widget<StyledText>(
        find.byType(StyledText).last,
      );
      expect(body.spec.step, TextStyles.body.step);
      expect(body.color, theme.mutedForeground);
    });

    testWidgets('role="alert" is a live region', (WidgetTester t) async {
      final SemanticsHandle handle = t.ensureSemantics();
      await t.pumpWidget(
        host(const SizedBox(width: 448, child: Alert(title: 'Could not save'))),
      );
      expect(
        t.getSemantics(find.byType(Alert)).flagsCollection.isLiveRegion,
        isTrue,
      );
      handle.dispose();
    });
  });

  group('FeedbackSurface', () {
    testWidgets('the blend and the void are the theme\'s, and they agree', (
      WidgetTester t,
    ) async {
      // Each ramp ends on the identity operand of its own blend, which is what
      // makes the gradients disappear instead of leaving an edge.
      expect(
        FeedbackSurface.blendFor(ResolvedColorMode.dark),
        BlendMode.screen,
      );
      expect(FeedbackSurface.voidFor(ResolvedColorMode.dark).r, 0);
      expect(FeedbackSurface.voidFor(ResolvedColorMode.dark).g, 0);
      expect(FeedbackSurface.voidFor(ResolvedColorMode.dark).b, 0);

      expect(
        FeedbackSurface.blendFor(ResolvedColorMode.light),
        BlendMode.multiply,
      );
      expect(FeedbackSurface.voidFor(ResolvedColorMode.light).r, 1);
      expect(FeedbackSurface.voidFor(ResolvedColorMode.light).g, 1);
      expect(FeedbackSurface.voidFor(ResolvedColorMode.light).b, 1);
    });

    testWidgets('the named pairs are the declarations they transcribe', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(host(const SizedBox.shrink()));
      final ThemeTokens theme = ThemeScope.of(t.element(find.byType(Center)));
      final BorderRadius r = BorderRadius.circular(Radii.lg);
      const Widget child = SizedBox.shrink();

      final FeedbackSurface action = FeedbackSurface(
        variant: FeedbackVariant.neutral,
        radius: r,
        fill: theme.card,
        child: child,
      );
      expect(action.bloom1(theme), Palette.actionBright);
      expect(action.bloom2(theme), Palette.action);

      final FeedbackSurface destructive = FeedbackSurface(
        variant: FeedbackVariant.error,
        radius: r,
        fill: theme.card,
        child: child,
      );
      expect(destructive.bloom1(theme), theme.destructive);
      expect(destructive.bloom2(theme), Palette.action);

      final FeedbackSurface success = FeedbackSurface(
        variant: FeedbackVariant.success,
        radius: r,
        fill: theme.card,
        child: child,
      );
      expect(success.bloom1(theme), Palette.success);
      expect(success.bloom2(theme), Palette.value);

      final FeedbackSurface warning = FeedbackSurface(
        variant: FeedbackVariant.warning,
        radius: r,
        fill: theme.card,
        child: child,
      );
      expect(warning.bloom1(theme), Palette.warning);
      expect(warning.bloom2(theme), Palette.action);
    });
  });

  group('Toast', () {
    testWidgets('356 wide, 16 of padding, 12 beside the glyph, on e3', (
      WidgetTester t,
    ) async {
      expect(Toaster.width, 356);
      expect(Toaster.gap, 14);
      expect(Toaster.viewportOffset, 24);
      expect(Toaster.visibleLimit, 3);
      expect(Toaster.lifetime, const Duration(seconds: 4));

      await t.pumpWidget(
        host(
          SizedBox(
            width: Toaster.width,
            child: const Toast(
              message: ToastMessage(
                title: 'Saved as @ayoub',
                type: ToastType.info,
              ),
            ),
          ),
        ),
      );
      final Surface surface = t.widget<Surface>(find.byType(Surface));
      expect(surface.spec.layers, Shadows.lg.layers);
      expect(surface.radius, BorderRadius.circular(Radii.lg));

      final Rect toast = t.getRect(find.byType(Toast));
      final Rect icon = t.getRect(find.byType(Icon));
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
      final ThemeTokens theme = ThemeScope.of(t.element(find.byType(Center)));
      expect(ToastType.success.inkOf(theme), theme.successText);
      expect(ToastType.error.inkOf(theme), theme.destructiveText);
      expect(ToastType.warning.inkOf(theme), theme.warningText);
      expect(ToastType.info.inkOf(theme), theme.infoText);
      expect(ToastType.loading.inkOf(theme), theme.actionText);
      expect(ToastType.normal.inkOf(theme), theme.mutedForeground);
      expect(ToastType.normal.label, 'default');
    });

    testWidgets('GAP CLOSED: TOAST_ICONS maps all five types', (
      WidgetTester t,
    ) async {
      // Was a KNOWN GAP: `circleCheck` and `octagonX` had no geometry, so
      // `ToastType.glyph` answered null for success and error and this test
      // pinned the null. Both paths landed with the icon writer; wave B2 flips
      // the getter and this pin with it.
      expect(ToastType.success.glyph, IconGlyph.circleCheck);
      expect(ToastType.info.glyph, IconGlyph.info);
      expect(ToastType.warning.glyph, IconGlyph.alertTriangle);
      expect(ToastType.error.glyph, IconGlyph.octagonX);
      expect(ToastType.loading.glyph, IconGlyph.loaderCircle);

      // The one remaining null is not a gap: `TOAST_ICONS` has no `default`
      // key, so an untyped toast renders with no icon slot at all — while a
      // call site may still put one there.
      expect(ToastType.normal.glyph, isNull);
      expect(
        const ToastMessage(title: 'Added to favourites').resolvedGlyph,
        isNull,
      );
      expect(
        const ToastMessage(
          title: 'Added to favourites',
          glyph: IconGlyph.check,
        ).resolvedGlyph,
        IconGlyph.check,
      );

      await t.pumpWidget(
        host(
          SizedBox(
            width: Toaster.width,
            child: const Toast(
              message: ToastMessage(title: 'Saved', type: ToastType.success),
            ),
          ),
        ),
      );
      expect(find.byType(Icon), findsOneWidget);
    });
  });

  // The Slot merge, on the four controls that are not an `<input>`.
  //
  // `FormControl` is a `Slot`: it stamps `id`, `aria-invalid` and
  // `aria-describedby` onto whatever it wraps — *"input, trigger, switch or
  // checkbox alike"*. Flutter's analogue is context, so each of these reads
  // `FieldScope` and lets its own props win where both speak.
  group('FieldScope adoption', () {
    /// A control inside a field that says everything a field can say.
    Widget inField(
      Widget control, {
      required FocusNode node,
      bool valid = false,
    }) => host(
      SizedBox(
        width: 448,
        child: Field(
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
    /// annotation sits *inside* its [HitArea] (the expander has to be
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
    /// carries — which is what makes `Form.focusFirstError` land on it.
    bool adopted(WidgetTester t, Finder of, FocusNode node) => t
        .widgetList<Focus>(
          find.descendant(of: of, matching: find.byType(Focus)),
        )
        .any((Focus f) => identical(f.focusNode, node));

    testWidgets('Checkbox takes label, description, enabled, invalid, node', (
      WidgetTester t,
    ) async {
      final SemanticsHandle semantics = t.ensureSemantics();
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);

      await t.pumpWidget(
        inField(const Checkbox(state: CheckboxState.unchecked), node: node),
      );
      await t.pumpAndSettle();
      final ThemeTokens theme = themeIn(t, Checkbox);

      final SemanticsProperties said = announced(t, find.byType(Checkbox));
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
                    of: find.byType(Checkbox),
                    matching: find.byType(Opacity),
                  )
                  .first,
            )
            .opacity,
        0.50,
      );
      // `aria-invalid` reaches the paint, not only the field's own container.
      expect(borderOf(socketOf(t, Checkbox)), theme.destructive);
      expect(adopted(t, find.byType(Checkbox), node), isTrue);
      semantics.dispose();
    });

    testWidgets('Switch takes label, description, enabled, invalid, node', (
      WidgetTester t,
    ) async {
      final SemanticsHandle semantics = t.ensureSemantics();
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);

      await t.pumpWidget(inField(const Switch(value: false), node: node));
      await t.pumpAndSettle();
      final ThemeTokens theme = themeIn(t, Switch);

      final SemanticsProperties said = announced(t, find.byType(Switch));
      expect(said.label!, contains('Price alerts'));
      expect(said.hint!, contains('Receipts and nothing else.'));
      expect(borderOf(socketOf(t, Switch)), theme.destructive);
      expect(
        t
            .widget<Opacity>(
              find
                  .descendant(
                    of: find.byType(Switch),
                    matching: find.byType(Opacity),
                  )
                  .first,
            )
            .opacity,
        0.50,
      );
      expect(adopted(t, find.byType(Switch), node), isTrue);
      semantics.dispose();
    });

    testWidgets('Select takes label, description, enabled, invalid, node', (
      WidgetTester t,
    ) async {
      final SemanticsHandle semantics = t.ensureSemantics();
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);

      await t.pumpWidget(
        host(
          SizedBox(
            width: 448,
            child: Field(
              label: 'Plan',
              description: 'Pick one you can afford.',
              errors: const <String>['Pick a plan.'],
              enabled: false,
              focusNode: node,
              child: Select<String>(
                options: const <SelectOption<String>>[
                  SelectOption<String>(value: 'free', label: 'Free'),
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
      final ThemeTokens theme = themeIn(t, Select<String>);

      final SemanticsProperties said = announced(
        t,
        find.byType(Select<String>),
      );
      expect(said.label!, contains('Plan'));
      expect(said.hint!, contains('Pick one you can afford.'));
      expect(said.hint!, contains('Pick a plan.'));
      // Dark substitutes `border-destructive/50` for the opaque border.
      expect(
        borderOf(socketOf(t, Select<String>)),
        theme.destructive.withValues(alpha: 0.50),
      );
      expect(adopted(t, find.byType(Select<String>), node), isTrue);
      semantics.dispose();
    });

    testWidgets('RadioGroup takes the legend and the node; items take the rest', (
      WidgetTester t,
    ) async {
      final SemanticsHandle semantics = t.ensureSemantics();
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);

      await t.pumpWidget(
        host(
          SizedBox(
            width: 448,
            child: Field(
              label: 'Payout rhythm',
              description: 'How often you get paid.',
              errors: const <String>['Pick a payout rhythm.'],
              focusNode: node,
              child: RadioGroup<String>(
                value: null,
                onChanged: (String _) {},
                children: const <Widget>[
                  RadioGroupItem<String>(value: 'daily', label: 'Daily'),
                  RadioGroupItem<String>(value: 'weekly', label: 'Weekly'),
                ],
              ),
            ),
          ),
        ),
      );
      await t.pumpAndSettle();
      final ThemeTokens theme = themeIn(t, RadioGroupItem<String>);

      // `FormControl` wraps the RadioGroup, not the items, so the legend and
      // the description are announced on the group.
      final SemanticsProperties group = announced(
        t,
        find.byType(RadioGroup<String>),
      );
      expect(group.label!, contains('Payout rhythm'));
      expect(group.hint!, contains('How often you get paid.'));
      expect(group.hint!, contains('Pick a payout rhythm.'));

      // …while each item keeps its own name, never the legend.
      expect(
        announced(t, find.byType(RadioGroupItem<String>).at(0)).label,
        'Daily',
      );
      expect(
        announced(t, find.byType(RadioGroupItem<String>).at(1)).label,
        'Weekly',
      );

      // The group's `aria-invalid` paints on every item.
      expect(borderOf(socketOf(t, RadioGroupItem<String>)), theme.destructive);

      // The field's node lands on the group and never on two Focus widgets at
      // once — the group holds it and passes the focus to the tab stop.
      expect(adopted(t, find.byType(RadioGroup<String>), node), isTrue);
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
                of: find.byType(RadioGroupItem<String>).at(0),
                matching: find.byType(Focus),
              ),
            )
            .any((Focus f) => f.focusNode?.hasPrimaryFocus ?? false),
        isTrue,
        reason: 'the first enabled item is the roving tab stop',
      );
      semantics.dispose();
    });

    testWidgets('a disabled field disables its radio items', (
      WidgetTester t,
    ) async {
      int changes = 0;
      await t.pumpWidget(
        host(
          SizedBox(
            width: 448,
            child: Field(
              label: 'Payout rhythm',
              enabled: false,
              child: RadioGroup<String>(
                value: null,
                onChanged: (String _) => changes++,
                children: const <Widget>[
                  RadioGroupItem<String>(value: 'daily', label: 'Daily'),
                ],
              ),
            ),
          ),
        ),
      );
      await t.tap(find.byType(RadioGroupItem<String>), warnIfMissed: false);
      expect(changes, 0);
      expect(
        t
            .widget<Opacity>(
              find
                  .descendant(
                    of: find.byType(RadioGroupItem<String>),
                    matching: find.byType(Opacity),
                  )
                  .first,
            )
            .opacity,
        0.50,
      );
    });

    testWidgets('Form.focusFirstError lands on a checkbox — ruling F4', (
      WidgetTester t,
    ) async {
      // The composed form's `terms`: the reference cannot focus it at all,
      // because a hand-wired Checkbox exposes no ref for `shouldFocusError` to
      // call (forms-map drift 7). Here it is a field like any other.
      //
      // Both orientations, because the composed form's `terms` is a
      // **horizontal** field and that branch once published no `FieldScope`
      // at all — it put its raw `child` in the Row where the vertical branch
      // put the scope-wrapped control, so the checkbox adopted nothing and a
      // failed submit focused nothing. Fixed in `field.dart`; asserted on both
      // branches here so the shape this ruling is about is the shape that is
      // measured.
      for (final FieldOrientation orientation in FieldOrientation.values) {
        final FormField<bool> terms = FormField<bool>(
          name: 'terms',
          initialValue: false,
          rules: <ValidationRule<bool>>[
            const ValidationRule<bool>(
              _accepted,
              'You have to accept the terms.',
            ),
          ],
        );
        final Form form = Form(fields: <FormFieldBase>[terms]);
        addTearDown(form.dispose);

        await t.pumpWidget(
          host(
            SizedBox(
              width: 448,
              child: ListenableBuilder(
                listenable: form,
                builder: (BuildContext context, Widget? _) => Field(
                  key: ValueKey<FieldOrientation>(orientation),
                  label: 'I accept the terms',
                  errors: terms.errors,
                  focusNode: terms.focusNode,
                  orientation: orientation,
                  child: Checkbox(
                    state: terms.value
                        ? CheckboxState.checked
                        : CheckboxState.unchecked,
                    onChanged: (CheckboxState next) =>
                        terms.value = next == CheckboxState.checked,
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
          adopted(t, find.byType(Checkbox), terms.focusNode),
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
  // `FieldActivator`, and `FieldLabel` reads that at tap time.
  //
  // Every case below taps a **real** `FieldLabel` inside a **real**
  // `Field`, wrapped around the real control, so the pair is what is
  // measured rather than either half against a stub.
  group('FieldLabel activation', () {
    /// Taps the visible label text, which is what a reader clicks.
    Future<void> tapLabel(WidgetTester t, String text) async {
      await t.tap(find.text(text));
      await t.pump();
    }

    testWidgets('a label tap ticks a real Checkbox', (WidgetTester t) async {
      CheckboxState state = CheckboxState.unchecked;
      await t.pumpWidget(
        host(
          SizedBox(
            width: 448,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) => Field(
                label: 'I accept the terms',
                orientation: FieldOrientation.horizontal,
                child: Checkbox(
                  state: state,
                  onChanged: (CheckboxState next) =>
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
        CheckboxState.checked,
        reason: 'the label activated, it did not merely focus',
      );

      // …and back again: activation is the toggle, not "set true".
      await tapLabel(t, 'I accept the terms');
      expect(state, CheckboxState.unchecked);
      await t.pumpAndSettle();
    });

    testWidgets('a label tap flips a real Switch', (WidgetTester t) async {
      bool on = false;
      await t.pumpWidget(
        host(
          SizedBox(
            width: 448,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) => Field(
                label: 'Price alerts',
                orientation: FieldOrientation.horizontal,
                child: Switch(
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

    testWidgets('a label tap opens a real Select', (WidgetTester t) async {
      await t.pumpWidget(
        overlayHost(
          SizedBox(
            width: 448,
            child: Field(
              label: 'Plan',
              child: Select<String>(
                options: const <SelectOption<String>>[
                  SelectOption<String>(value: 'free', label: 'Free'),
                  SelectOption<String>(value: 'pro', label: 'Pro'),
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
            child: Field(
              label: 'Payout rhythm',
              child: RadioGroup<String>(
                value: value,
                onChanged: (String next) => value = next,
                children: const <Widget>[
                  RadioGroupItem<String>(value: 'daily', label: 'Daily'),
                  RadioGroupItem<String>(value: 'weekly', label: 'Weekly'),
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
                of: find.byType(RadioGroupItem<String>).at(0),
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
                  RadioGroup<String>(
                    value: value,
                    onChanged: (String next) => setState(() => value = next),
                    children: const <Widget>[
                      Field(
                        label: 'Daily',
                        orientation: FieldOrientation.horizontal,
                        child: RadioGroupItem<String>(value: 'daily'),
                      ),
                      Field(
                        label: 'Weekly',
                        orientation: FieldOrientation.horizontal,
                        child: RadioGroupItem<String>(value: 'weekly'),
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
      CheckboxState state = CheckboxState.unchecked;
      await t.pumpWidget(
        host(
          SizedBox(
            width: 448,
            child: Field(
              label: 'I accept the terms',
              enabled: false,
              orientation: FieldOrientation.horizontal,
              child: Checkbox(
                state: state,
                onChanged: (CheckboxState next) => state = next,
              ),
            ),
          ),
        ),
      );

      await t.tap(find.text('I accept the terms'), warnIfMissed: false);
      await t.pump();
      expect(
        state,
        CheckboxState.unchecked,
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
                of: find.byType(Checkbox),
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
                of: find.byType(Checkbox),
                matching: find.byType(IgnorePointer),
              )
              .first,
        )
        .ignoring;

    /// What the control hands its own [Semantics] — read off the widget for the
    /// reason the adoption group records: the annotation sits *inside*
    /// [HitArea], so walking the semantics tree lands somewhere else.
    SemanticsProperties announced(WidgetTester t, Finder of) => t
        .widgetList<Semantics>(
          find.descendant(of: of, matching: find.byType(Semantics)),
        )
        .first
        .properties;

    /// A checkbox whose focus this test owns, so "has the focus" and "is
    /// painted as though it had the focus" can be told apart.
    Widget ringBox(FocusNode node, {bool? force, bool invalid = false}) => host(
      Checkbox(
        focusNode: node,
        forceFocusRing: force,
        invalid: invalid,
        onChanged: (CheckboxState _) {},
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
            Checkbox(
              key: ValueKey<String>(c.name),
              state: CheckboxState.indeterminate,
              enabled: c.enabled,
              inert: c.inert,
              focusNode: node,
              onChanged: (CheckboxState _) => taps++,
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
          controlFocus(t, Checkbox).canRequestFocus,
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

        await t.tap(find.byType(Checkbox), warnIfMissed: false);
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
          const Checkbox(
            state: CheckboxState.indeterminate,
            inert: true,
            label: 'Indeterminate',
          ),
        ),
      );
      await t.pumpAndSettle();

      final SemanticsProperties said = announced(t, find.byType(Checkbox));
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
          const Checkbox(
            state: CheckboxState.indeterminate,
            enabled: false,
            label: 'Disabled',
          ),
        ),
      );
      await t.pumpAndSettle();
      expect(
        announced(t, find.byType(Checkbox)).enabled,
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
      CheckboxState state = CheckboxState.indeterminate;
      await t.pumpWidget(
        host(
          SizedBox(
            width: 448,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) => Field(
                label: 'Partial bulk selection',
                orientation: FieldOrientation.horizontal,
                child: Checkbox(
                  state: state,
                  inert: true,
                  onChanged: (CheckboxState next) =>
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
        CheckboxState.indeterminate,
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
      final ThemeTokens theme = themeIn(t, Checkbox);
      await t.pumpAndSettle();
      expect(
        node.hasPrimaryFocus,
        isFalse,
        reason:
            'the cell is a lie painted with class names — nothing on the '
            'reference page has the focus either',
      );
      expect(
        borderOf(socketOf(t, Checkbox)),
        theme.ring,
        reason:
            '`border-ring`, with tw-merge having deleted `border-input` '
            'from the string outright',
      );
      expect(
        ringOf(socketOf(t, Checkbox), theme).a,
        closeTo(0.50, 0.001),
        reason: '`ring-3 ring-ring/50`',
      );

      // `false` withholds the ring from a control that genuinely has the focus.
      await t.pumpWidget(ringBox(node, force: false));
      node.requestFocus();
      await t.pumpAndSettle();
      expect(node.hasPrimaryFocus, isTrue, reason: 'the focus is real here');
      expect(
        borderOf(socketOf(t, Checkbox)),
        theme.input,
        reason: 'and the socket is still at rest',
      );
      expect(
        ringOf(socketOf(t, Checkbox), theme).a,
        closeTo(0, 0.001),
        reason:
            'the resting ring is the hue at zero alpha, and a 3px spread '
            'of nothing paints nothing',
      );

      // `null` — the default — follows the real focus, in both directions.
      await t.pumpWidget(ringBox(node));
      await t.pumpAndSettle();
      expect(
        borderOf(socketOf(t, Checkbox)),
        theme.ring,
        reason: 'still focused, and now the ring is allowed to say so',
      );
      expect(ringOf(socketOf(t, Checkbox), theme).a, closeTo(0.50, 0.001));

      node.unfocus();
      await t.pumpAndSettle();
      expect(
        borderOf(socketOf(t, Checkbox)),
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
      final ThemeTokens theme = themeIn(t, Checkbox);
      await t.pumpAndSettle();
      expect(
        borderOf(socketOf(t, Checkbox)),
        theme.destructive,
        reason:
            'the invalid branch is tested first in both colour targets, '
            'so a forced ring is as invisible as a real focus is',
      );
      expect(
        ringOf(socketOf(t, Checkbox), theme),
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
            child: RadioGroup<String>(
              value: null,
              onChanged: (String _) {},
              children: const <Widget>[
                RadioGroupItem<String>(
                  value: 'a',
                  forceFocusRing: true,
                  label: 'Focus',
                ),
              ],
            ),
          ),
        ),
      );
      final ThemeTokens theme = themeIn(t, RadioGroupItem<String>);
      await t.pumpAndSettle();
      expect(
        borderOf(socketOf(t, RadioGroupItem<String>)),
        theme.ring,
        reason: 'the item wears `border-ring` with nothing focused',
      );
      expect(
        ringOf(socketOf(t, RadioGroupItem<String>), theme).a,
        closeTo(0.50, 0.001),
        reason:
            '`ring-3 ring-ring/50`, character-identical to the checkbox '
            'cell',
      );
    });

    testWidgets('FieldLabel takes a spec, and `normal` is font-normal', (
      WidgetTester t,
    ) async {
      // `<FieldLabel htmlFor={…} className="font-normal">` — probed on the
      // filter list at 13px, a 17.875px line box, weight 400, `--foreground`.
      expect(FieldLabel.normal.family, TextStyles.small.family);
      expect(
        FieldLabel.normal.step,
        TextStyles.small.step,
        reason: 'a field label reads at the supporting-copy role',
      );
      expect(
        FieldLabel.normal.variations.first.value,
        TextStyles.small.variations.first.value,
        reason:
            'the weight is borrowed from the token that already records '
            'the 400 `html` gives, never typed into this layer',
      );

      await t.pumpWidget(
        host(
          SizedBox(
            width: 448,
            child: FieldLabel('Available now', spec: FieldLabel.normal),
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
      expect(overridden.fontSize, TextStyles.small.step.size);
      expect(overridden.height, closeTo(TextStyles.small.step.ratio, 1e-6));
      expect(
        t.getSize(find.byType(StyledText)).height,
        closeTo(TextStyles.small.step.leading, 0.001),
        reason: 'the supporting-copy line box',
      );

      // …and the default is what `Label` types itself in, unchanged.
      await t.pumpWidget(
        host(const SizedBox(width: 448, child: FieldLabel('Available now'))),
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
  group('Toaster', () {
    Widget toaster(ToastController controller) => host(
      SizedBox(
        width: 1440,
        height: 900,
        child: Toaster(controller: controller),
      ),
    );

    /// The mount frame, the measure-then-lay-out round trip, and the entrance.
    ///
    /// No `pumpAndSettle`: a toast carries a `FeedbackSurface`, which runs two
    /// forever loops, so a settle would never return.
    Future<void> arrive(WidgetTester t) async {
      await t.pump(); // data-mounted flips, the height is reported
      await t.pump(); // the entrance retargets off the reported height
      await t.pump(Toaster.transition);
    }

    testWidgets('shows nothing until something is queued', (
      WidgetTester t,
    ) async {
      final ToastController controller = ToastController();
      addTearDown(controller.dispose);
      await t.pumpWidget(toaster(controller));
      expect(find.byType(Toast), findsNothing);

      controller.success('Saved as @ayoub');
      await t.pump();
      expect(find.byType(Toast), findsOneWidget);
      expect(find.text('Saved as @ayoub'), findsOneWidget);
      // The lifetime clock is a ticker now, because sonner's hover-pause
      // stores a remainder and a remainder is what a ticker already holds — so
      // it starts on the frame after it is armed, the way sonner's own
      // `startTimer` runs after paint.
      await t.pump();
      await t.pump(Toaster.lifetime);
      await t.pump(Toaster.unmountDelay);
      expect(find.byType(Toast), findsNothing);
    });

    testWidgets('three are visible and the rest queue', (WidgetTester t) async {
      final ToastController controller = ToastController();
      addTearDown(controller.dispose);
      await t.pumpWidget(toaster(controller));
      for (int i = 0; i < 5; i++) {
        controller.error('Could not claim that handle $i');
      }
      await t.pump();
      expect(controller.length, 5);
      expect(controller.visibleCount, 3);
      expect(find.byType(Toast), findsNWidgets(3));
      // Newest sits closest to the corner.
      expect(find.text('Could not claim that handle 4'), findsOneWidget);
      expect(find.text('Could not claim that handle 0'), findsNothing);
      controller.clear();
      await t.pump();
    });

    testWidgets('a tap dismisses over the unmount window', (
      WidgetTester t,
    ) async {
      final ToastController controller = ToastController();
      addTearDown(controller.dispose);
      await t.pumpWidget(toaster(controller));
      controller.success('Preferences saved');
      await arrive(t);

      await t.tap(find.byType(Toast));
      await t.pump();
      // Still mounted, on its way out.
      expect(find.byType(Toast), findsOneWidget);
      await t.pump(Toaster.unmountDelay);
      expect(find.byType(Toast), findsNothing);
      expect(controller.length, 0);
    });

    testWidgets('anchors bottom-right, 24px in', (WidgetTester t) async {
      final ToastController controller = ToastController();
      addTearDown(controller.dispose);
      await t.pumpWidget(toaster(controller));
      controller.success('Account saved');
      await arrive(t);

      final Rect frame = t.getRect(find.byType(Toaster));
      final Rect toast = t.getRect(find.byType(Toast));
      expect(frame.right - toast.right, 24);
      expect(frame.bottom - toast.bottom, closeTo(24, 1e-9));
      controller.clear();
      await t.pump();
    });
  });
}
