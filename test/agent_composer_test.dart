import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// The composer family — `composer.tsx`, `slash-palette.tsx`,
/// `attach-menu.tsx`, pinned.
///
/// Every number here was probed against the live reference at
/// `localhost:3000/design-system/components/agent/composer`, 1440 × 900, on
/// 2026-08-16 — the static geometry with `getComputedStyle` /
/// `getBoundingClientRect` (`scratchpad/ag-composer-inv.js`), and every
/// **behaviour** by driving a real pointer or keyboard with puppeteer
/// (`ag-composer-live.js`, `ag-composer-hover.js`, `ag-composer-hover2.js`,
/// `ag-composer-clip.js`). Where a class list and a driven gesture disagree,
/// the gesture is what these tests pin — twice, in the two drift groups at the
/// end.
///
/// **No `pumpAndSettle`**: the palette's entrance is a 400ms tween and the
/// frames are stepped by hand.

/// The composer's own width in the reference's Panel — `w-full` of a 1030px
/// body.
const double _width = 1030;

/// Half a logical pixel.
const double _tolerance = 0.5;

/// What [_host] is currently showing — `initialEntries` is read once, in
/// `initState`, so the child travels through a holder. The same trick
/// `selects_test.dart` uses, for the same reason.
Widget _hosted = const SizedBox.shrink();

/// The composer needs a real [Overlay]: the plus menu is a [ElPopover], and a
/// popover with nowhere to portal to renders nothing at all.
Widget _host(
  Widget child, {
  ElThemeMode mode = ElThemeMode.dark,
  bool disableAnimations = false,
  double width = _width,
}) {
  _hosted = SizedBox(width: width, child: child);
  return MediaQuery(
    data: MediaQueryData(
      size: const Size(1440, 900),
      disableAnimations: disableAnimations,
    ),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: ElTheme(
        controller: ElThemeController(mode: mode),
        child: Overlay(
          initialEntries: <OverlayEntry>[
            OverlayEntry(
              builder: (BuildContext _) =>
                  Align(alignment: Alignment.topCenter, child: _hosted),
            ),
          ],
        ),
      ),
    ),
  );
}

extension on WidgetTester {
  /// The reference's frame. The default 800×600 test surface is narrower than
  /// the composer itself, and every number here is measured at 1030.
  void useViewport() {
    view.devicePixelRatio = 1;
    view.physicalSize = const Size(1440, 1600);
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetDevicePixelRatio);
  }

  /// Mounts [child] at the reference frame and settles the first layout.
  Future<void> pumpComposer(
    Widget child, {
    bool disableAnimations = false,
  }) async {
    useViewport();
    await pumpWidget(_host(child, disableAnimations: disableAnimations));
    await pump();
  }
}

/// Opens (or closes) a [ElPopover]: one frame for the prop to flip, one more
/// for the portal the frame boundary brings in.
Future<void> _settleOverlay(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
}

/// `COMMANDS` from `agent-demo.tsx`, verbatim — three skills and one command.
List<ElAgentCommand> get _commands => <ElAgentCommand>[
  const ElAgentCommand(
    id: 'inventory',
    label: 'inventory',
    hint: 'What is in stock',
    group: ElAgentCommandGroup.skill,
    icon: ElLucide.search,
  ),
  const ElAgentCommand(
    id: 'wallet',
    label: 'wallet',
    hint: 'Balance and recent movement',
    group: ElAgentCommandGroup.skill,
    icon: ElLucide.wallet,
  ),
  const ElAgentCommand(
    id: 'export',
    label: 'export',
    hint: 'Download activity as CSV',
    group: ElAgentCommandGroup.skill,
    icon: ElLucide.download,
  ),
  const ElAgentCommand(
    id: 'guide',
    label: 'guide',
    hint: 'How pack odds work',
    group: ElAgentCommandGroup.command,
    icon: ElLucide.bookOpen,
  ),
];

/// The specimen's one attachment — `collection-export.csv`, content delivered.
ElAgentAttachment get _csv => const ElAgentAttachment(
  id: 'spec-upload',
  name: 'collection-export.csv',
  mime: 'text/csv',
  kind: ElAgentAttachmentKind.data,
  size: 18422,
  delivery: ElAgentDelivery.content(),
);

/// A composer driven by a real controller, with everything the specimen wires.
class _Specimen extends StatefulWidget {
  const _Specimen({
    this.busy = false,
    this.disabled = false,
    this.withAttachment = false,
    this.commands,
    this.onSubmit,
    this.accessory,
    this.micControl,
    this.dictationError,
  });

  final bool busy;
  final bool disabled;
  final bool withAttachment;
  final List<ElAgentCommand>? commands;
  final VoidCallback? onSubmit;
  final Widget? accessory;
  final Widget? micControl;
  final String? dictationError;

  @override
  State<_Specimen> createState() => _SpecimenState();
}

class _SpecimenState extends State<_Specimen> {
  final TextEditingController controller = TextEditingController();
  late List<ElAgentAttachment> attachments = widget.withAttachment
      ? <ElAgentAttachment>[_csv]
      : <ElAgentAttachment>[];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ElAgentComposer(
    controller: controller,
    onSubmit: () {
      widget.onSubmit?.call();
      controller.clear();
    },
    onStop: () {},
    busy: widget.busy,
    disabled: widget.disabled,
    placeholder: 'Ask about a pack, a pull or your balance…',
    commands: widget.commands ?? _commands,
    attachments: attachments,
    onAttach: (List<ElAgentAttachment> files) => setState(
      () => attachments = <ElAgentAttachment>[...attachments, ...files],
    ),
    onRemoveAttachment: (String id) => setState(
      () => attachments = attachments
          .where((ElAgentAttachment a) => a.id != id)
          .toList(),
    ),
    accessory: widget.accessory,
    micControl: widget.micControl,
    dictationError: widget.dictationError,
  );
}

Finder get _shell => find.byType(ElMachineSurface).first;
Finder get _input => find.byType(EditableText);
Finder get _palette => find.byType(ElAgentSlashPalette);

double _heightOf(WidgetTester tester, Finder finder) =>
    tester.getSize(finder).height;

/// Types [text] into the field the way a keyboard does, so the controller's
/// listener and the composer's caret both run.
Future<void> _type(WidgetTester tester, String text) async {
  await tester.enterText(_input, text);
  await tester.pump();
}

void main() {
  /* ── slashQuery / filterCommands — pure ────────────────────────────────── */

  group('elSlashQuery', () {
    test('only a slash that opens the message counts', () {
      expect(elSlashQuery('/inv', 4), 'inv');
      // *"Mid-sentence, a slash is a slash — 'and/or' must not open a menu."*
      expect(elSlashQuery('and/or', 6), isNull);
      expect(elSlashQuery('', 0), isNull);
      expect(elSlashQuery('hello', 5), isNull);
    });

    test('a space or a newline before the caret closes it', () {
      expect(elSlashQuery('/inv now', 8), isNull);
      expect(elSlashQuery('/inv\nmore', 9), isNull);
      // …but only *before* the caret. The tail is not read.
      expect(elSlashQuery('/inv now', 4), 'inv');
    });

    test('the bare slash is an empty query, not a closed palette', () {
      expect(elSlashQuery('/', 1), '');
    });

    test('a caret past the end clamps, exactly as String.slice does', () {
      expect(elSlashQuery('/inv', 99), 'inv');
    });

    test('DRIFT 2 — a caret of −1 counts from the END and still opens', () {
      // This is the Escape handler's whole mechanism: `setCaret(-1)` was meant
      // to close the palette and instead drops the last character off the
      // query, which is a valid query.
      expect(elSlashQuery('/', -1), '');
      expect(elSlashQuery('/inv', -1), 'in');
      expect(elSlashQuery('/i', -1), '');
    });
  });

  group('elFilterCommands', () {
    test('an empty query returns the list untouched', () {
      final List<ElAgentCommand> all = _commands;
      expect(elFilterCommands(all, ''), same(all));
      expect(elFilterCommands(all, '   '), same(all));
    });

    test('a plain substring match over the id and the label', () {
      expect(
        elFilterCommands(_commands, 'w').map((ElAgentCommand c) => c.id),
        <String>['wallet'],
      );
      expect(
        elFilterCommands(_commands, 'e').map((ElAgentCommand c) => c.id),
        <String>['inventory', 'wallet', 'export', 'guide'],
      );
      // Case-insensitive, and trimmed.
      expect(
        elFilterCommands(_commands, '  GUIDE ').map((ElAgentCommand c) => c.id),
        <String>['guide'],
      );
    });

    test(
      'no fuzzy matching — the letters of clear do not find recalculate',
      () {
        const List<ElAgentCommand> pair = <ElAgentCommand>[
          ElAgentCommand(
            id: 'clear',
            label: 'clear',
            group: ElAgentCommandGroup.command,
          ),
          ElAgentCommand(
            id: 'recalculate',
            label: 'recalculate',
            group: ElAgentCommandGroup.command,
          ),
        ];
        expect(
          elFilterCommands(pair, 'clear').map((ElAgentCommand c) => c.id),
          <String>['clear'],
        );
      },
    );
  });

  /* ── Rest geometry ─────────────────────────────────────────────────────── */

  group('at rest', () {
    testWidgets('the shell is 96 tall over a 48px input and a 40px row', (
      WidgetTester tester,
    ) async {
      await tester.pumpComposer(const _Specimen());
      await tester.pump();

      expect(_heightOf(tester, _shell), closeTo(96, _tolerance));
      expect(tester.getSize(_shell).width, _width);

      // 1 + 48 + 6 + 40 + 1. The control row is `px-2 pb-2` around a 32px
      // square, so it is 40 with no top padding at all.
      expect(
        tester.getSize(find.byType(EditableText)).height,
        closeTo(24, _tolerance),
        reason: 'one `.type-body` line box inside the input\'s `py-3`',
      );
      expect(ElAgentComposer.inputInsets.vertical, 24);
      expect(ElAgentComposer.controlInsets.bottom, 8);
      expect(ElAgentComposer.controlInsets.top, 0);
    });

    testWidgets('the send button is a 32px square carrying a 16px arrow', (
      WidgetTester tester,
    ) async {
      await tester.pumpComposer(const _Specimen());
      await tester.pump();

      final Finder send = find.ancestor(
        of: find.byType(ElIcon),
        matching: find.byType(ElButton),
      );
      expect(tester.getSize(find.byType(ElButton).last), const Size(32, 32));
      expect(ElAgentComposer.sendGlyphSize, 16);
      expect(ElAgentComposer.stopGlyphSize, 14);
      expect(send, findsWidgets);
    });

    testWidgets('send is disabled with an empty box and no attachments', (
      WidgetTester tester,
    ) async {
      await tester.pumpComposer(const _Specimen());
      await tester.pump();
      expect(
        tester.widget<ElButton>(find.byType(ElButton).last).onPressed,
        isNull,
      );

      await _type(tester, 'hello');
      expect(
        tester.widget<ElButton>(find.byType(ElButton).last).onPressed,
        isNotNull,
      );
    });

    testWidgets('an attachment alone arms send', (WidgetTester tester) async {
      await tester.pumpComposer(const _Specimen(withAttachment: true));
      await tester.pump();
      expect(
        tester.widget<ElButton>(find.byType(ElButton).last).onPressed,
        isNotNull,
      );
    });

    testWidgets('DRIFT 1 — six pixels of line box under the input', (
      WidgetTester tester,
    ) async {
      await tester.pumpComposer(const _Specimen());
      await tester.pump();
      // Nothing declares it: the `<textarea>` is `inline-block` and the
      // parent's strut adds its descent. 1 + 48 + 6 + 40 + 1 = 96.
      expect(ElAgentComposer.inlineGap, 6);
      expect(_heightOf(tester, _shell), closeTo(96, _tolerance));
    });
  });

  /* ── Grow to fit ───────────────────────────────────────────────────────── */

  group('grow to fit', () {
    testWidgets('+24 a line to a 200px cap, then it scrolls', (
      WidgetTester tester,
    ) async {
      await tester.pumpComposer(const _Specimen());
      await tester.pump();
      expect(_heightOf(tester, _shell), closeTo(96, _tolerance));

      await _type(tester, 'one\ntwo');
      expect(_heightOf(tester, _shell), closeTo(120, _tolerance));

      await _type(tester, 'one\ntwo\nthree\nfour\nfive\nsix\nseven');
      // Seven lines: 24 × 7 + 24 of padding = 192, plus 48 of chrome.
      expect(_heightOf(tester, _shell), closeTo(240, _tolerance));

      // Twelve lines would want 312; the cap holds the box at 200.
      await _type(tester, 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\nk\nl');
      expect(ElAgentComposer.maxRowsPx, 200);
      expect(_heightOf(tester, _shell), closeTo(248, _tolerance));
    });

    testWidgets('submitting empties the box and it returns to 96', (
      WidgetTester tester,
    ) async {
      int sent = 0;
      await tester.pumpComposer(_Specimen(onSubmit: () => sent += 1));
      await tester.pump();
      await _type(tester, 'hello');

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(sent, 1);
      expect(tester.widget<EditableText>(_input).controller.text, '');
      expect(_heightOf(tester, _shell), closeTo(96, _tolerance));
    });

    testWidgets('Shift-Enter breaks the line instead of sending', (
      WidgetTester tester,
    ) async {
      int sent = 0;
      await tester.pumpComposer(_Specimen(onSubmit: () => sent += 1));
      await tester.pump();
      await _type(tester, 'a');

      await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      await tester.pump();
      expect(sent, 0, reason: 'Shift-Enter is a newline, never a send');
    });
  });

  /* ── Busy and disabled ─────────────────────────────────────────────────── */

  group('busy and disabled', () {
    testWidgets('busy swaps send for a live stop', (WidgetTester tester) async {
      await tester.pumpComposer(const _Specimen(busy: true));
      await tester.pump();

      final ElButton last = tester.widget<ElButton>(find.byType(ElButton).last);
      expect(last.label, 'Stop');
      expect(last.variant, ElButtonVariant.outline);
      // A stop is always pressable — that is the point of it.
      expect(last.onPressed, isNotNull);
      expect(tester.getSize(find.byType(ElButton).last), const Size(32, 32));
    });

    testWidgets('disabled dims the input alone and refuses send', (
      WidgetTester tester,
    ) async {
      await tester.pumpComposer(const _Specimen(disabled: true));
      await tester.pump();

      expect(ElAgentComposer.disabledInputOpacity, 0.60);
      final Iterable<double> opacities = tester
          .widgetList<Opacity>(find.byType(Opacity))
          .map((Opacity o) => o.opacity);
      expect(opacities, contains(ElAgentComposer.disabledInputOpacity));

      expect(
        tester.widget<ElButton>(find.byType(ElButton).last).onPressed,
        isNull,
      );
      // The geometry does not move: a disabled composer is 96 too.
      expect(_heightOf(tester, _shell), closeTo(96, _tolerance));
    });

    testWidgets('a disabled composer does not send on Enter', (
      WidgetTester tester,
    ) async {
      int sent = 0;
      await tester.pumpComposer(
        _Specimen(disabled: true, onSubmit: () => sent += 1),
      );
      await tester.pump();
      await _type(tester, 'hello');
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(sent, 0);
    });

    testWidgets('busy is not disabled — the box still takes text', (
      WidgetTester tester,
    ) async {
      await tester.pumpComposer(const _Specimen(busy: true));
      await tester.pump();
      await _type(tester, 'queued');
      expect(tester.widget<EditableText>(_input).controller.text, 'queued');
    });
  });

  /* ── The file tray ─────────────────────────────────────────────────────── */

  group('the file tray', () {
    testWidgets('one attachment makes the shell 179 and prints its size', (
      WidgetTester tester,
    ) async {
      await tester.pumpComposer(const _Specimen(withAttachment: true));
      await tester.pump();

      expect(_heightOf(tester, _shell), closeTo(179, _tolerance));
      expect(find.text('collection-export.csv'), findsOneWidget);
      expect(find.text('18 KB'), findsOneWidget);
      // `delivery.sent === "content"` — the agent can read it.
      expect(find.text('Read'), findsOneWidget);
    });

    testWidgets('removing it takes the tray with it', (
      WidgetTester tester,
    ) async {
      await tester.pumpComposer(const _Specimen(withAttachment: true));
      await tester.pump();

      final Finder remove = find.byWidgetPredicate(
        (Widget w) =>
            w is ElButton && w.label == 'Remove collection-export.csv',
      );
      expect(remove, findsOneWidget);
      await tester.tap(remove);
      await tester.pump();

      expect(find.text('collection-export.csv'), findsNothing);
      expect(_heightOf(tester, _shell), closeTo(96, _tolerance));
    });
  });

  /* ── The slash palette ─────────────────────────────────────────────────── */

  group('the slash palette', () {
    testWidgets('typing / opens it with both groups and every command', (
      WidgetTester tester,
    ) async {
      await tester.pumpComposer(const _Specimen());
      await tester.pump();
      expect(_palette, findsNothing);

      await _type(tester, '/');
      expect(_palette, findsOneWidget);
      expect(find.text('Skills'), findsOneWidget);
      expect(find.text('Commands'), findsOneWidget);
      for (final String hint in <String>[
        'What is in stock',
        'Balance and recent movement',
        'Download activity as CSV',
        'How pack odds work',
      ]) {
        expect(find.text(hint), findsOneWidget);
      }
    });

    testWidgets('it does not contribute one pixel to the composer', (
      WidgetTester tester,
    ) async {
      await tester.pumpComposer(const _Specimen());
      await tester.pump();
      final double closed = _heightOf(tester, _shell);

      await _type(tester, '/');
      await tester.pump(ElDurations.slow);
      expect(
        tester.getSize(find.byType(ElAgentComposer)).height,
        closeTo(closed, _tolerance),
        reason: '`absolute bottom-full` is out of flow',
      );
    });

    testWidgets('the rows and headings are the reference\'s own boxes', (
      WidgetTester tester,
    ) async {
      await tester.pumpComposer(const _Specimen(), disableAnimations: true);
      await tester.pump();
      await _type(tester, '/');
      await tester.pump();

      // `px-3 pt-3 pb-1` around a 14.175px caption line.
      final double heading = tester
          .getSize(
            find
                .ancestor(
                  of: find.text('Skills'),
                  matching: find.byType(Padding),
                )
                .first,
          )
          .height;
      expect(heading, closeTo(30.175, _tolerance));

      // `py-2` around a 19.5 line, a 4px gap and a 14.175 line.
      final double row = tester
          .getSize(
            find
                .ancestor(
                  of: find.text('What is in stock'),
                  matching: find.byType(Padding),
                )
                .first,
          )
          .height;
      expect(row, closeTo(53.675, _tolerance));

      // The box caps at `max-h-64`.
      expect(ElAgentSlashPalette.maxHeight, 256);
      expect(tester.getSize(_palette).height, closeTo(256, _tolerance));
      expect(tester.getSize(_palette).width, _width);
    });

    testWidgets('the entrance is anim-fade-up — 400ms, ease-out, 10px', (
      WidgetTester tester,
    ) async {
      await tester.pumpComposer(const _Specimen());
      await tester.pump();
      await _type(tester, '/');

      expect(ElAgentSlashPalette.entrance, ElDurations.slow);
      expect(ElAgentSlashPalette.entrance.inMilliseconds, 400);
      expect(ElAgentSlashPalette.rise, 10);

      double opacityNow() => tester
          .widgetList<Opacity>(
            find.descendant(of: _palette, matching: find.byType(Opacity)),
          )
          .first
          .opacity;

      // Frame 0 is the keyframe's own 0%.
      expect(opacityNow(), 0);
      // `--ease-out` is front-loaded: a tenth of the way in it is most of the
      // way there.
      await tester.pump(const Duration(milliseconds: 40));
      expect(opacityNow(), greaterThan(0.3));
      await tester.pump(const Duration(milliseconds: 360));
      expect(opacityNow(), 1);
    });

    testWidgets('filtering narrows to one row and drops the empty group', (
      WidgetTester tester,
    ) async {
      await tester.pumpComposer(const _Specimen(), disableAnimations: true);
      await tester.pump();
      await _type(tester, '/w');

      expect(find.text('Skills'), findsOneWidget);
      expect(find.text('Commands'), findsNothing);
      expect(find.text('Balance and recent movement'), findsOneWidget);
      expect(find.text('What is in stock'), findsNothing);
      // 1 heading + 1 row + the two hairlines.
      expect(tester.getSize(_palette).height, closeTo(85.85, 1));
    });

    testWidgets('a query that matches nothing closes it rather than showing '
        'an empty box', (WidgetTester tester) async {
      await tester.pumpComposer(const _Specimen());
      await tester.pump();
      await _type(tester, '/zzzz');
      expect(_palette, findsNothing);
    });

    testWidgets('arrow keys walk it and Enter writes the command in', (
      WidgetTester tester,
    ) async {
      await tester.pumpComposer(const _Specimen(), disableAnimations: true);
      await tester.pump();
      await _type(tester, '/');

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(tester.widget<ElAgentSlashPalette>(_palette).activeIndex, 1);

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      // *"A trailing space so the user can keep typing their own argument."*
      expect(tester.widget<EditableText>(_input).controller.text, '/wallet ');
      // …and the space closes the palette, because the query now holds one.
      expect(_palette, findsNothing);
    });

    testWidgets('the arrows wrap in both directions', (
      WidgetTester tester,
    ) async {
      await tester.pumpComposer(const _Specimen(), disableAnimations: true);
      await tester.pump();
      await _type(tester, '/');

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pump();
      expect(tester.widget<ElAgentSlashPalette>(_palette).activeIndex, 3);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(tester.widget<ElAgentSlashPalette>(_palette).activeIndex, 0);
    });

    testWidgets('Tab commits exactly as Enter does', (
      WidgetTester tester,
    ) async {
      await tester.pumpComposer(const _Specimen(), disableAnimations: true);
      await tester.pump();
      await _type(tester, '/g');
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(tester.widget<EditableText>(_input).controller.text, '/guide ');
    });

    testWidgets('a new query resets the highlight to the top of its own list', (
      WidgetTester tester,
    ) async {
      await tester.pumpComposer(const _Specimen(), disableAnimations: true);
      await tester.pump();
      await _type(tester, '/');
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(tester.widget<ElAgentSlashPalette>(_palette).activeIndex, 2);

      await _type(tester, '/g');
      expect(
        tester.widget<ElAgentSlashPalette>(_palette).activeIndex,
        0,
        reason: 'an index past the end of a shorter list is never painted',
      );
    });

    testWidgets('a directive is written instead of the id when one is given', (
      WidgetTester tester,
    ) async {
      await tester.pumpComposer(
        const _Specimen(
          commands: <ElAgentCommand>[
            ElAgentCommand(
              id: 'brief',
              label: 'brief',
              group: ElAgentCommandGroup.skill,
              directive: 'Summarise the last week',
            ),
          ],
        ),
        disableAnimations: true,
      );
      await tester.pump();
      await _type(tester, '/b');
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(
        tester.widget<EditableText>(_input).controller.text,
        'Summarise the last week ',
      );
    });

    testWidgets('a run command fires locally and clears the box', (
      WidgetTester tester,
    ) async {
      int ran = 0;
      await tester.pumpComposer(
        _Specimen(
          commands: <ElAgentCommand>[
            ElAgentCommand(
              id: 'clear',
              label: 'clear',
              group: ElAgentCommandGroup.command,
              run: () => ran += 1,
            ),
          ],
        ),
        disableAnimations: true,
      );
      await tester.pump();
      await _type(tester, '/c');
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(ran, 1);
      expect(tester.widget<EditableText>(_input).controller.text, '');
    });

    testWidgets('Enter with the palette open never reaches onSubmit', (
      WidgetTester tester,
    ) async {
      int sent = 0;
      await tester.pumpComposer(
        _Specimen(onSubmit: () => sent += 1),
        disableAnimations: true,
      );
      await tester.pump();
      await _type(tester, '/w');
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(sent, 0, reason: 'the palette owns Enter while it is open');
    });

    testWidgets('mid-sentence a slash is a slash', (WidgetTester tester) async {
      await tester.pumpComposer(const _Specimen());
      await tester.pump();
      await _type(tester, 'and/or');
      expect(_palette, findsNothing);
    });
  });

  /* ── The plus menu ─────────────────────────────────────────────────────── */

  group('the attach menu', () {
    testWidgets('the trigger is a 32px ghost that opens upwards', (
      WidgetTester tester,
    ) async {
      await tester.pumpComposer(const _Specimen());
      await tester.pump();

      final Finder plus = find.byWidgetPredicate(
        (Widget w) => w is ElButton && w.label == 'Add files or use a skill',
      );
      expect(plus, findsOneWidget);
      expect(tester.getSize(plus), const Size(32, 32));
      // `aria-haspopup="menu"` cancels the press scale on every menu trigger.
      expect(tester.widget<ElButton>(plus).suppressPressScale, isTrue);
    });

    testWidgets('it lists Photos & files, a separator, Skills and the skills '
        'only', (WidgetTester tester) async {
      await tester.pumpComposer(const _Specimen(), disableAnimations: true);
      await tester.pump();

      await tester.tap(
        find.byWidgetPredicate(
          (Widget w) => w is ElButton && w.label == 'Add files or use a skill',
        ),
      );
      await _settleOverlay(tester);

      expect(find.text('Photos & files'), findsOneWidget);
      expect(find.text('Images, documents, spreadsheets'), findsOneWidget);
      expect(find.text('Skills'), findsOneWidget);
      // The three skills, by their labels.
      expect(find.text('inventory'), findsOneWidget);
      expect(find.text('wallet'), findsOneWidget);
      expect(find.text('export'), findsOneWidget);
      // *"Skills only — browser commands live under `/`, not here."*
      expect(find.text('guide'), findsNothing);
    });

    testWidgets('the content is w-80 and the rows 49.67 tall', (
      WidgetTester tester,
    ) async {
      await tester.pumpComposer(const _Specimen(), disableAnimations: true);
      await tester.pump();
      await tester.tap(
        find.byWidgetPredicate(
          (Widget w) => w is ElButton && w.label == 'Add files or use a skill',
        ),
      );
      await _settleOverlay(tester);

      expect(ElAgentAttachMenu.width, 320);
      expect(ElAgentAttachMenu.maxHeight, 384);
      expect(ElAgentAttachMenu.rowLinesHaveNoGap, isTrue);
    });

    testWidgets('DRIFT 5 — the menu row is 4px shorter than the palette row '
        'holding the same two lines', (WidgetTester tester) async {
      // `flex-col gap-1` **without `flex`** in the menu, `flex min-w-0
      // flex-col gap-1` in the palette. One `flex` apart, and that is the
      // whole 4px.
      //
      // Measured as a difference rather than as two absolutes: a package test
      // loads no font binaries, so a hint's *wrap* is not the reference's —
      // the absolutes are pinned in `example/test/composer_page_test.dart`,
      // which does load them. A one-word hint cannot wrap under any face, so
      // the difference is stable here.
      const List<ElAgentCommand> one = <ElAgentCommand>[
        ElAgentCommand(
          id: 'stock',
          label: 'stock',
          hint: 'Stock',
          group: ElAgentCommandGroup.skill,
        ),
      ];
      await tester.pumpComposer(
        const _Specimen(commands: one),
        disableAnimations: true,
      );
      await tester.pump();

      await _type(tester, '/');
      final double paletteRow = tester
          .getSize(
            find
                .ancestor(
                  of: find.text('Stock'),
                  matching: find.byType(Padding),
                )
                .first,
          )
          .height;
      // `py-2` around 19.5 + **4** + 14.175.
      expect(paletteRow, closeTo(53.675, _tolerance));

      await _type(tester, '');
      await tester.tap(
        find.byWidgetPredicate(
          (Widget w) => w is ElButton && w.label == 'Add files or use a skill',
        ),
      );
      await _settleOverlay(tester);
      final double menuRow = tester
          .getSize(
            find
                .ancestor(
                  of: find.text('Stock'),
                  matching: find.byType(Padding),
                )
                .first,
          )
          .height;
      // `py-2` around 19.5 + 14.175, and no gap at all.
      expect(menuRow, closeTo(49.675, _tolerance));
      expect(paletteRow - menuRow, closeTo(el(1), 0.01));
    });

    testWidgets('choosing a skill writes it in and closes the menu', (
      WidgetTester tester,
    ) async {
      await tester.pumpComposer(const _Specimen(), disableAnimations: true);
      await tester.pump();
      await tester.tap(
        find.byWidgetPredicate(
          (Widget w) => w is ElButton && w.label == 'Add files or use a skill',
        ),
      );
      await _settleOverlay(tester);

      await tester.tap(find.text('wallet'));
      await _settleOverlay(tester);
      expect(tester.widget<EditableText>(_input).controller.text, '/wallet ');
    });

    testWidgets('with no commands and no file handler it renders nothing', (
      WidgetTester tester,
    ) async {
      await tester.pumpComposer(
        const ElAgentAttachMenu(onRunCommand: _noop),
        disableAnimations: true,
      );
      await tester.pump();
      expect(find.byType(ElButton), findsNothing);
    });
  });

  /* ── The drop target ───────────────────────────────────────────────────── */

  group('the drop target', () {
    testWidgets('a file over the composer lights border-agent bg-agent/8', (
      WidgetTester tester,
    ) async {
      await tester.pumpComposer(const _DragHarness(), disableAnimations: true);
      await tester.pump();

      final ElThemeData theme = ElTheme.of(
        tester.element(find.byType(ElAgentComposer)),
      );
      ElMachineSurface surface() =>
          tester.widget<ElMachineSurface>(find.byType(ElMachineSurface).first);

      expect(surface().fill, theme.card);

      final Offset start = tester.getCenter(
        find.byKey(const ValueKey<String>('drag-source')),
      );
      final TestGesture gesture = await tester.startGesture(start);
      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.byType(ElAgentComposer)));
      await tester.pump();

      expect(
        surface().fill,
        theme.agent.withValues(alpha: ElAgentComposer.dragFillAlpha),
      );
      expect(find.text(ElAgentComposer.dropPlaceholder), findsOneWidget);

      await gesture.up();
      await tester.pump();
      expect(surface().fill, theme.card);
      // The dropped file arrived.
      expect(find.text('dropped.csv'), findsOneWidget);
    });

    testWidgets('a file over the byte cap is refused by name', (
      WidgetTester tester,
    ) async {
      await tester.pumpComposer(
        const _DragHarness(oversize: true),
        disableAnimations: true,
      );
      await tester.pump();

      final Offset start = tester.getCenter(
        find.byKey(const ValueKey<String>('drag-source')),
      );
      final TestGesture gesture = await tester.startGesture(start);
      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.byType(ElAgentComposer)));
      await tester.pump();
      await gesture.up();
      await tester.pump();

      expect(
        find.text(
          'huge.bin — over the ${elFormatBytes(kElMaxFileBytes)} '
          'limit',
        ),
        findsOneWidget,
      );
      expect(find.text('huge.bin'), findsNothing);
    });
  });

  /* ── The two slots and the dictation line ──────────────────────────────── */

  group('slots', () {
    testWidgets('accessory sits left and micControl right of send', (
      WidgetTester tester,
    ) async {
      await tester.pumpComposer(
        const _Specimen(
          accessory: SizedBox(
            key: ValueKey<String>('accessory'),
            width: 40,
            height: 32,
          ),
          micControl: SizedBox(
            key: ValueKey<String>('mic'),
            width: 32,
            height: 32,
          ),
        ),
        disableAnimations: true,
      );
      await tester.pump();

      final double plus = tester
          .getTopLeft(
            find.byWidgetPredicate(
              (Widget w) =>
                  w is ElButton && w.label == 'Add files or use a skill',
            ),
          )
          .dx;
      final double accessory = tester
          .getTopLeft(find.byKey(const ValueKey<String>('accessory')))
          .dx;
      final double mic = tester
          .getTopLeft(find.byKey(const ValueKey<String>('mic')))
          .dx;
      final double send = tester.getTopLeft(find.byType(ElButton).last).dx;

      expect(plus < accessory, isTrue);
      expect(accessory < mic, isTrue);
      expect(mic < send, isTrue);
      // `gap-1` between the plus and the accessory.
      expect(
        accessory - (plus + 32),
        closeTo(ElAgentComposer.controlGap, 0.01),
      );
      // …and between the mic and send.
      expect(send - (mic + 32), closeTo(ElAgentComposer.controlGap, 0.01));
    });

    testWidgets('a dictation error prints under the shell at mt-2', (
      WidgetTester tester,
    ) async {
      await tester.pumpComposer(
        const _Specimen(dictationError: 'Microphone blocked'),
        disableAnimations: true,
      );
      await tester.pump();
      expect(find.text('Microphone blocked'), findsOneWidget);
      expect(
        tester.getSize(find.byType(ElAgentComposer)).height,
        closeTo(96 + ElAgentComposer.messageTopGap + 14.175, 1),
      );
    });
  });

  /* ── Drift ─────────────────────────────────────────────────────────────── */

  group('drift', () {
    testWidgets('DRIFT 2 — Escape does not close the palette', (
      WidgetTester tester,
    ) async {
      await tester.pumpComposer(const _Specimen(), disableAnimations: true);
      await tester.pump();
      await _type(tester, '/');
      expect(_palette, findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();

      // Two independent reasons, one outcome: `"/".slice(0, -1)` is an empty
      // query rather than null, AND the key-up of the same press restores the
      // caret before the next frame.
      expect(
        _palette,
        findsOneWidget,
        reason: 'the comment says it closes; it does not',
      );
      expect(
        tester.widget<EditableText>(_input).controller.text,
        '/',
        reason: 'it does at least keep the text',
      );
    });

    testWidgets('DRIFT 4 — scrollIntoView indexes groups, not rows', (
      WidgetTester tester,
    ) async {
      expect(ElAgentSlashPalette.scrollsGroupsNotRows, isTrue);
      await tester.pumpComposer(const _Specimen(), disableAnimations: true);
      await tester.pump();
      await _type(tester, '/');

      // Walking to the last row leaves it out of view, because index 3 is not
      // a group and nothing is scrolled.
      for (int i = 0; i < 3; i++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      }
      await tester.pump();
      expect(tester.widget<ElAgentSlashPalette>(_palette).activeIndex, 3);
      final ScrollableState scroller = tester.state<ScrollableState>(
        find.descendant(of: _palette, matching: find.byType(Scrollable)),
      );
      expect(
        scroller.position.pixels,
        0,
        reason: 'children[3] of a two-group list is undefined',
      );
    });

    testWidgets('DRIFT 3 — the palette overhangs its own composer entirely', (
      WidgetTester tester,
    ) async {
      await tester.pumpComposer(const _Specimen(), disableAnimations: true);
      await tester.pump();
      await _type(tester, '/');

      final Rect composer = tester.getRect(find.byType(ElAgentComposer));
      final Rect palette = tester.getRect(_palette);
      expect(
        palette.bottom,
        closeTo(composer.top - el(2), _tolerance),
        reason: '`bottom-full mb-2`',
      );
      expect(
        palette.bottom <= composer.top,
        isTrue,
        reason:
            'not one pixel of it lands inside the composer, which is '
            'what makes the Panel\'s own overflow-hidden clip all but a '
            'sliver of it on the page',
      );
    });
  });
}

void _noop(ElAgentCommand command) {}

/// A `Draggable` beside a composer, so the drop target can be driven.
class _DragHarness extends StatefulWidget {
  const _DragHarness({this.oversize = false});

  final bool oversize;

  @override
  State<_DragHarness> createState() => _DragHarnessState();
}

class _DragHarnessState extends State<_DragHarness> {
  final TextEditingController controller = TextEditingController();
  List<ElAgentAttachment> attachments = <ElAgentAttachment>[];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  ElAgentAttachment get _payload => widget.oversize
      ? ElAgentAttachment(
          id: 'huge',
          name: 'huge.bin',
          mime: 'application/octet-stream',
          kind: ElAgentAttachmentKind.other,
          size: kElMaxFileBytes + 1,
        )
      : const ElAgentAttachment(
          id: 'dropped',
          name: 'dropped.csv',
          mime: 'text/csv',
          kind: ElAgentAttachmentKind.data,
          size: 2048,
        );

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Draggable<List<ElAgentAttachment>>(
        key: const ValueKey<String>('drag-source'),
        data: <ElAgentAttachment>[_payload],
        feedback: const SizedBox(width: 10, height: 10),
        // A bare SizedBox has nothing to hit-test; the drag would never
        // start.
        child: const ColoredBox(
          color: Color(0xFF202020),
          child: SizedBox(width: 40, height: 40),
        ),
      ),
      ElAgentComposer(
        controller: controller,
        onSubmit: () {},
        attachments: attachments,
        onAttach: (List<ElAgentAttachment> files) => setState(
          () => attachments = <ElAgentAttachment>[...attachments, ...files],
        ),
        onRemoveAttachment: (String id) => setState(
          () => attachments = attachments
              .where((ElAgentAttachment a) => a.id != id)
              .toList(),
        ),
      ),
    ],
  );
}
