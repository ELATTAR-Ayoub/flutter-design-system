/// Writes `assets/textures/perlin-noise.png` from the checked-in seed.
///
///     dart run tool/generate_perlin_texture/bin/generate.dart .
///
/// Takes the repository root as its one argument so it behaves like
/// `tool/registry_builder/bin/build.dart` beside it. Prints the size, seed and
/// resulting hashes; `THIRD_PARTY_NOTICES.md` records the same values.
library;

import 'dart:io';
import 'dart:typed_data';

import '../lib/perlin.dart';

const String _relativeTarget = 'assets/textures/perlin-noise.png';

int main(List<String> arguments) {
  final String root = arguments.isEmpty ? '.' : arguments.first;
  final File target = File('$root/$_relativeTarget');
  if (!target.parent.existsSync()) {
    stderr.writeln('No such directory: ${target.parent.path}');
    stderr.writeln('Pass the repository root, e.g. `dart run ... .`');
    return 66;
  }

  final Uint8List pixels = generateField();
  final Uint8List png = encodePng(pixels);
  target.writeAsBytesSync(png);

  stdout
    ..writeln('Wrote ${target.path}')
    ..writeln('  size    $textureSize x $textureSize, 8-bit RGBA')
    ..writeln('  seed    0x${textureSeed.toRadixString(16).toUpperCase()}')
    ..writeln('  octaves $octaves from ${baseFrequency} cells, persistence $persistence')
    ..writeln('  pixels  ${pixels.length} bytes, sha256 ${sha256Hex(pixels)}')
    ..writeln('  file    ${png.length} bytes, sha256 ${sha256Hex(png)}');
  return 0;
}

/// A local sha256 so this tool depends on nothing.
///
/// `tool/registry_builder/lib/generator.dart` carries its own for the same
/// reason; this one is deliberately a separate copy rather than a shared
/// dependency between two otherwise-unrelated single-purpose tools.
String sha256Hex(List<int> input) {
  const List<int> k = <int>[
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
    0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
    0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
    0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
    0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
    0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
    0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
    0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
    0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
  ];
  final List<int> h = <int>[
    0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
    0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19,
  ];

  final List<int> message = <int>[...input, 0x80];
  while (message.length % 64 != 56) {
    message.add(0);
  }
  final int bitLength = input.length * 8;
  for (int i = 7; i >= 0; i--) {
    message.add((bitLength >> (i * 8)) & 0xFF);
  }

  int rotr(int value, int bits) =>
      ((value >> bits) | (value << (32 - bits))) & 0xFFFFFFFF;

  final List<int> w = List<int>.filled(64, 0);
  for (int chunk = 0; chunk < message.length; chunk += 64) {
    for (int i = 0; i < 16; i++) {
      final int o = chunk + i * 4;
      w[i] = (message[o] << 24) |
          (message[o + 1] << 16) |
          (message[o + 2] << 8) |
          message[o + 3];
    }
    for (int i = 16; i < 64; i++) {
      final int s0 = rotr(w[i - 15], 7) ^ rotr(w[i - 15], 18) ^ (w[i - 15] >> 3);
      final int s1 = rotr(w[i - 2], 17) ^ rotr(w[i - 2], 19) ^ (w[i - 2] >> 10);
      w[i] = (w[i - 16] + s0 + w[i - 7] + s1) & 0xFFFFFFFF;
    }

    int a = h[0], b = h[1], c = h[2], d = h[3];
    int e = h[4], f = h[5], g = h[6], hh = h[7];

    for (int i = 0; i < 64; i++) {
      final int s1 = rotr(e, 6) ^ rotr(e, 11) ^ rotr(e, 25);
      final int ch = (e & f) ^ (~e & g);
      final int temp1 = (hh + s1 + ch + k[i] + w[i]) & 0xFFFFFFFF;
      final int s0 = rotr(a, 2) ^ rotr(a, 13) ^ rotr(a, 22);
      final int maj = (a & b) ^ (a & c) ^ (b & c);
      final int temp2 = (s0 + maj) & 0xFFFFFFFF;

      hh = g;
      g = f;
      f = e;
      e = (d + temp1) & 0xFFFFFFFF;
      d = c;
      c = b;
      b = a;
      a = (temp1 + temp2) & 0xFFFFFFFF;
    }

    h[0] = (h[0] + a) & 0xFFFFFFFF;
    h[1] = (h[1] + b) & 0xFFFFFFFF;
    h[2] = (h[2] + c) & 0xFFFFFFFF;
    h[3] = (h[3] + d) & 0xFFFFFFFF;
    h[4] = (h[4] + e) & 0xFFFFFFFF;
    h[5] = (h[5] + f) & 0xFFFFFFFF;
    h[6] = (h[6] + g) & 0xFFFFFFFF;
    h[7] = (h[7] + hh) & 0xFFFFFFFF;
  }

  return h.map((int v) => v.toRadixString(16).padLeft(8, '0')).join();
}
