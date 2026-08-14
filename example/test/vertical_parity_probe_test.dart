// parity probe — the Flutter half of the vertical-metric comparison against
// the web reference.
//
// Pumps each of the four foundation pages inside the real [DocsShell] at the
// 1440 frame with the reference's own font binaries loaded (without them the
// test engine measures Ahem and every line height is fiction), then walks the
// render tree and prints one line per box:
//
//     PARITY|<page>|<depth>|<widget>|<top>|<height>|<left>|<width>|<text>
//
// Coordinates are relative to the page widget's own box — which is the content
// column, the same origin `scratchpad/measure-vertical.js` uses on the web
// side, so the two dumps line up landmark for landmark.
//
// The dump only runs under `PARITY_DUMP=1`; the standing assertion is that the
// column really is 1080px wide at 1440, because every line-wrap point (and so
// every height below it) depends on that.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/main.dart';
import 'package:example/nav.dart';
import 'package:example/shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader;
import 'package:flutter_test/flutter_test.dart';

/// The frame the reference is designed against.
const Size _viewport = Size(1440, 900);

/// `--width-content` — what the assertions below guard, first.
const double _contentWidth = 1080;

/// The reference's own reading-column height per route, in CSS pixels.
///
/// Measured off `http://localhost:3000` at 1440×900, dark, fonts loaded, with
/// `getBoundingClientRect()` on `main > div.mx-auto.max-w-(--width-content)`
/// (`scratchpad/measure-vertical.js`, 2026-08-14). A page that drifts from
/// these is a page that no longer stacks the way the reference stacks — which
/// is the whole failure this file exists to catch, since the drift is
/// invisible per element and only shows up as an accumulated offset.
const Map<String, double> _referenceHeight = <String, double>{
  'overview': 2402.66,
  'colors': 3781.83,
  'typography': 6039.94,
  'spacing': 4159.36,
};

/// Half a CSS pixel: below the smallest thing either engine can paint, and
/// wider than the 1/64px grid Chrome quantises its own layout to.
const double _tolerance = 0.5;

Future<void> _loadFont(String family, String file) async {
  final ByteData bytes = ByteData.sublistView(
    File('../assets/fonts/$file').readAsBytesSync(),
  );
  final FontLoader loader = FontLoader('packages/elattar_design_system/$family')
    ..addFont(Future<ByteData>.value(bytes));
  await loader.load();
}

/// One box in the render tree, in the page's own coordinates.
class _Box {
  _Box(this.depth, this.widget, this.rect);

  final int depth;
  final String widget;
  final Rect rect;
  final List<_Box> children = <_Box>[];

  /// Text this box paints itself; empty for everything that is not a paragraph.
  String own = '';

  /// The port of `Node.textContent`: own text, or the concatenation below.
  ///
  /// A paragraph's own text carries `U+FFFC` where a `WidgetSpan` sits, and
  /// those spans are this box's children — the inline code chips. Splicing
  /// their text back in is what makes the string comparable to the browser's
  /// `textContent`, which knows nothing about the distinction.
  String get text {
    if (own.isEmpty) {
      return children
          .map((_Box b) => b.text)
          .where((String s) => s.isNotEmpty)
          .join(' ');
    }
    if (!own.contains('￼')) return own;
    int next = 0;
    return own.replaceAllMapped(
      RegExp('￼'),
      (Match _) => next < children.length ? children[next++].text : '',
    );
  }
}

String _normalise(String s) => s.replaceAll(RegExp(r'\s+'), ' ').trim();

/// Walks [root]'s element subtree, one [_Box] per render box.
_Box _walk(Element root, RenderBox origin) {
  late _Box tree;

  void visit(Element element, _Box? parent, int depth) {
    _Box? node = parent;
    int childDepth = depth;

    // Only the element that *owns* a render object, so the dump is the render
    // tree rather than every composing widget above it repeating the same box:
    // `Element.renderObject` walks down to the nearest one.
    final RenderObject? object =
        element is RenderObjectElement ? element.renderObject : null;
    if (object is RenderBox && object.hasSize && object.attached) {
      final Offset offset = object.localToGlobal(Offset.zero, ancestor: origin);
      node = _Box(
        depth,
        element.widget.runtimeType.toString(),
        offset & object.size,
      );
      if (parent == null) {
        tree = node;
      } else {
        parent.children.add(node);
      }
      childDepth = depth + 1;
    }

    final Widget widget = element.widget;
    if (widget is RichText && node != null) {
      node.own = _normalise(widget.text.toPlainText());
    }

    element.visitChildren((Element child) => visit(child, node, childDepth));
  }

  visit(root, null, 0);
  return tree;
}

void _print(String page, _Box box) {
  void emit(_Box node) {
    final String text = _normalise(node.text.replaceAll('￼', ''));
    // ignore: avoid_print
    print(
      'PARITY|$page|${node.depth}|${node.widget}'
      '|${node.rect.top.toStringAsFixed(3)}|${node.rect.height.toStringAsFixed(3)}'
      '|${node.rect.left.toStringAsFixed(3)}|${node.rect.width.toStringAsFixed(3)}'
      '|${text.length > 90 ? text.substring(0, 90) : text}',
    );
    node.children.forEach(emit);
  }

  emit(box);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await _loadFont('InterLocal', 'InterVariable.ttf');
    await _loadFont('GeistMono', 'GeistMono-Variable.ttf');
    await _loadFont('Redaction35', 'Redaction35-Italic.ttf');
  });

  final Map<String, String> routes = <String, String>{
    'overview': dsRoot,
    'colors': '$dsRoot/colors',
    'typography': '$dsRoot/typography',
    'spacing': '$dsRoot/spacing',
  };

  for (final MapEntry<String, String> entry in routes.entries) {
    testWidgets('parity probe: ${entry.key}', (WidgetTester tester) async {
      tester.view.physicalSize = _viewport;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final DsThemeController theme = DsThemeController();
      final AppRouter router = AppRouter(route: entry.value);
      addTearDown(theme.dispose);
      addTearDown(router.dispose);

      final Widget page = pageFor(entry.value);
      await tester.pumpWidget(
        DsTheme(
          controller: theme,
          child: AppRouterScope(
            router: router,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: DocsShell(route: entry.value, child: page),
            ),
          ),
        ),
      );
      await tester.pump();

      final Finder finder = find.byWidget(page);
      final RenderBox origin = tester.renderObject<RenderBox>(finder);
      expect(
        origin.size.width,
        _contentWidth,
        reason: 'the reading column is --width-content at the 1440 frame',
      );
      expect(
        origin.size.height,
        closeTo(_referenceHeight[entry.key]!, _tolerance),
        reason: '${entry.key} no longer stacks to the reference\'s height',
      );

      if (Platform.environment['PARITY_DUMP'] == '1') {
        _print(entry.key, _walk(tester.element(finder), origin));
      }
    });
  }
}
