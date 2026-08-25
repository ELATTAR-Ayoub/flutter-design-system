/// What the shipped texture has to be true of, asserted rather than eyeballed.
///
/// The file this replaces was a byte copy of unknown origin, so the only way
/// to defend the replacement is to state its properties and check them. Each
/// test below names the line in `shaders/orb.frag` that needs the property.
library;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:test/test.dart';

import '../bin/generate.dart' show sha256Hex;
import '../lib/perlin.dart';

/// The pixel bytes the checked-in seed produces.
///
/// Deliberately the hash of the *field*, not of the PNG. The field is fully
/// determined by this repository's own arithmetic, so it is a fair thing to
/// pin. The PNG additionally depends on the SDK's zlib, which is free to
/// change its output without changing a single pixel — pinning that would be
/// pinning someone else's implementation detail and would fail as a
/// mysterious asset error on an SDK bump.
const String expectedFieldSha256 =
    '53a048aa5a339ee3c52a55133e138db3de86921af704e5f2e7c0bc6ae775a230';

void main() {
  final Uint8List field = generateField();

  group('the field the orb samples', () {
    test('is 256x256, one byte per pixel', () {
      expect(textureSize, 256);
      expect(field.length, textureSize * textureSize);
    });

    test('is identical on every run from the same seed', () {
      expect(generateField(), field);
      expect(generateField(seed: textureSeed), field);
    });

    test('changes when the seed changes', () {
      // Guards against a generator that ignores its seed and would therefore
      // be reproducible for the wrong reason.
      expect(generateField(seed: textureSeed + 1), isNot(field));
    });

    test('has the checked-in hash', () {
      expect(sha256Hex(field), expectedFieldSha256);
    });
  });

  group('tiles seamlessly', () {
    // `sampleNoise` wraps with `fract(uv)` (shaders/orb.frag:83) and the call
    // sites at :169-170 and :222 sample along a time axis that runs far past
    // 1.0, so the wrap edge is crossed continuously while the orb animates. A
    // discontinuity there is a once-per-period flicker.
    //
    // The bar: the step across the wrap must be no worse than the largest step
    // *inside* the field. Anything smaller would be asserting the seam is
    // better than the texture, which is not a thing to require.
    int maxDelta(int Function(int index) a, int Function(int index) b) {
      int worst = 0;
      for (int i = 0; i < textureSize; i++) {
        final int delta = (a(i) - b(i)).abs();
        if (delta > worst) worst = delta;
      }
      return worst;
    }

    int at(int x, int y) => field[y * textureSize + x];

    int worstInteriorRowStep() {
      int worst = 0;
      for (int y = 0; y < textureSize - 1; y++) {
        for (int x = 0; x < textureSize; x++) {
          final int delta = (at(x, y) - at(x, y + 1)).abs();
          if (delta > worst) worst = delta;
        }
      }
      return worst;
    }

    int worstInteriorColumnStep() {
      int worst = 0;
      for (int y = 0; y < textureSize; y++) {
        for (int x = 0; x < textureSize - 1; x++) {
          final int delta = (at(x, y) - at(x + 1, y)).abs();
          if (delta > worst) worst = delta;
        }
      }
      return worst;
    }

    test('top and bottom edges join like any interior row', () {
      final int seam = maxDelta(
        (int x) => at(x, textureSize - 1),
        (int x) => at(x, 0),
      );
      expect(seam, lessThanOrEqualTo(worstInteriorRowStep()));
    });

    test('left and right edges join like any interior column', () {
      final int seam = maxDelta(
        (int y) => at(textureSize - 1, y),
        (int y) => at(0, y),
      );
      expect(seam, lessThanOrEqualTo(worstInteriorColumnStep()));
    });
  });

  group('is usable noise, not just any noise', () {
    test('is smooth: no neighbour jumps like white noise would', () {
      int worst = 0;
      for (int y = 0; y < textureSize; y++) {
        for (int x = 0; x < textureSize; x++) {
          final int here = field[y * textureSize + x];
          final int right = field[y * textureSize + (x + 1) % textureSize];
          final int down = field[((y + 1) % textureSize) * textureSize + x];
          worst = <int>[
            worst,
            (here - right).abs(),
            (here - down).abs(),
          ].reduce((int a, int b) => a > b ? a : b);
        }
      }
      // White noise on 0..255 averages a neighbour delta near 85. Gradient
      // noise at these frequencies stays an order of magnitude below that.
      expect(worst, lessThan(24));
    });

    test('is centred near mid-grey', () {
      // The samples drive an oval's half-axes at shaders/orb.frag:223-224,
      // where a biased field reads as a permanently lopsided orb.
      final double mean =
          field.fold<int>(0, (int a, int b) => a + b) / field.length;
      expect(mean, closeTo(127.5, 8.0));
    });

    test('uses a wide range without clipping flat', () {
      final int lowest = field.reduce((int a, int b) => a < b ? a : b);
      final int highest = field.reduce((int a, int b) => a > b ? a : b);
      expect(highest - lowest, greaterThan(140));

      // A field that clamped hard would pile up on 0 and 255. A handful of
      // touched extremes is fine; a plateau is not.
      final int atFloor = field.where((int v) => v == 0).length;
      final int atCeiling = field.where((int v) => v == 255).length;
      expect(atFloor + atCeiling, lessThan(field.length ~/ 200));
    });
  });

  group('the PNG container', () {
    final Uint8List png = encodePng(field);

    test('is a well-formed 8-bit RGBA PNG of the right size', () {
      expect(png.sublist(0, 8), <int>[
        0x89,
        0x50,
        0x4E,
        0x47,
        0x0D,
        0x0A,
        0x1A,
        0x0A,
      ]);
      expect(utf8.decode(png.sublist(12, 16)), 'IHDR');
      final ByteData header = png.buffer.asByteData();
      expect(header.getUint32(16), textureSize);
      expect(header.getUint32(20), textureSize);
      expect(png[24], 8, reason: 'bit depth');
      // Colour type 6 is what the replaced file used; keeping it makes this a
      // drop-in for `voice_orb.dart`'s decode path.
      expect(png[25], 6, reason: 'colour type');
      expect(png[28], 0, reason: 'interlace');
    });

    test('decodes back to exactly the field it was given', () {
      expect(_decodeRedChannel(png), field);
    });

    test('is byte-identical on every encode', () {
      expect(encodePng(field), png);
    });
  });
}

/// A minimal PNG reader for the one shape [encodePng] emits.
///
/// Written here rather than pulled in as a dependency: a decoder that shares
/// no code with the encoder is the only way this test proves a round trip
/// instead of proving the two agree with each other.
Uint8List _decodeRedChannel(Uint8List png) {
  int offset = 8;
  final BytesBuilder compressed = BytesBuilder(copy: false);
  while (offset < png.length) {
    final ByteData view = png.buffer.asByteData();
    final int length = view.getUint32(offset);
    final String type = utf8.decode(png.sublist(offset + 4, offset + 8));
    if (type == 'IDAT') {
      compressed.add(png.sublist(offset + 8, offset + 8 + length));
    }
    offset += 12 + length;
  }

  final List<int> raw = ZLibDecoder().convert(compressed.takeBytes());
  final Uint8List out = Uint8List(textureSize * textureSize);
  const int stride = textureSize * 4 + 1;
  for (int y = 0; y < textureSize; y++) {
    expect(raw[y * stride], 0, reason: 'row $y should use filter type None');
    for (int x = 0; x < textureSize; x++) {
      out[y * textureSize + x] = raw[y * stride + 1 + x * 4];
    }
  }
  return out;
}
