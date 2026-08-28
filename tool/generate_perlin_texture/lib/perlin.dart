/// The voice orb's perlin field, generated rather than copied.
///
/// `assets/textures/perlin-noise.png` used to be a byte copy of a file whose
/// original this repository could not name. It is 45 KB of smooth grayscale
/// noise — the cheapest possible thing to regenerate and the most expensive
/// possible thing to clear, so it is regenerated here.
///
/// What the shader actually requires of it (`shaders/orb.frag`):
///
///  * **Only the red channel is read.** `sampleNoise` returns a `vec4` and
///    every call site takes `.r` (`:169-170`, `:222`).
///  * **It must tile seamlessly.** `sampleNoise` wraps with `fract(uv)`
///    (`:83`) — upstream's `RepeatWrapping`, done in the shader — and the
///    call sites sample along a time axis that runs well past 1.0. A visible
///    seam would strobe once per period.
///  * **It must be smooth and roughly centred.** The samples drive an oval's
///    half-axes (`:223-224`) and a flow distortion (`:207`); a field with a
///    lumpy histogram or hard edges shows up as stutter, not as texture.
///
/// So the generator is classic Perlin gradient noise summed over four octaves,
/// with every octave's lattice period an exact divisor of the image width.
/// That is what makes the result tileable *by construction* rather than by
/// blending edges afterwards: sampling at `x + width` reads the same lattice
/// cell as sampling at `x`.
library;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

/// The generated texture's edge length, in pixels.
///
/// Matches the replaced file exactly (256x256, 8-bit, RGBA), so nothing
/// downstream has to learn a new size.
const int textureSize = 256;

/// The seed the shipped texture is generated from.
///
/// Any 32-bit value produces a valid field; this one is checked in so the
/// output is reproducible. Changing it changes the shipped pixels and the
/// recorded hash in `THIRD_PARTY_NOTICES.md`, and is a deliberate visual
/// change, not a refactor.
const int textureSeed = 0x1EA77A12;

/// Lattice cells across the image in the lowest-frequency octave.
const int baseFrequency = 4;

/// How many times the frequency doubles. Four octaves at 4, 8, 16 and 32
/// cells: fine enough to read as texture at 256px, coarse enough that the
/// orb's own animation stays the dominant motion.
const int octaves = 4;

/// Amplitude falloff per octave.
const double persistence = 0.5;

/// How far the normalised field is stretched around mid-grey.
///
/// Chosen to reproduce the *character* of the file being replaced rather than
/// a taste: that file measured min 49, max 200, mean 127.5 — a span of 151 on
/// a 0..255 axis. 0.83 lands this generator's span in the same place, which
/// keeps the orb's ring displacement and oval sizing in the range the shader's
/// own constants were tuned against.
const double contrast = 0.83;

/// A deterministic 32-bit xorshift PRNG.
///
/// `Random(seed)` would also be reproducible, but only for as long as the SDK
/// keeps its algorithm. This file's whole purpose is a byte-stable artifact,
/// so the generator owns its own arithmetic.
class _XorShift32 {
  _XorShift32(int seed) : _state = seed == 0 ? 0x9E3779B9 : seed & 0xFFFFFFFF;

  int _state;

  int next() {
    int x = _state;
    x ^= (x << 13) & 0xFFFFFFFF;
    x ^= x >> 17;
    x ^= (x << 5) & 0xFFFFFFFF;
    _state = x & 0xFFFFFFFF;
    return _state;
  }

  /// A double in `[0, 1)`.
  double nextDouble() => next() / 0x100000000;
}

/// Perlin's smoothstep-of-a-smoothstep fade, `6t^5 - 15t^4 + 10t^3`.
///
/// The point of the quintic over a plain smoothstep is that its *second*
/// derivative is zero at the lattice points too, so cell boundaries do not
/// show up as faint creases under the orb's colour ramp.
double _fade(double t) => t * t * t * (t * (t * 6.0 - 15.0) + 10.0);

double _lerp(double a, double b, double t) => a + (b - a) * t;

/// One octave of tileable 2D gradient noise, in `[-1, 1]`.
///
/// [period] is both the lattice size and the wrap modulus: gradients are
/// looked up at `i % period`, so the field repeats exactly every [period]
/// cells and therefore exactly once across the image.
class _TileableGradientNoise {
  _TileableGradientNoise({required this.period, required int seed}) {
    final _XorShift32 random = _XorShift32(seed);
    _gradients = Float64List(period * period * 2);
    for (int i = 0; i < period * period; i++) {
      // A uniform direction on the unit circle. Unit-length gradients keep
      // every octave's contribution in the same range, which is what makes
      // the amplitude weights below mean what they say.
      final double angle = random.nextDouble() * 2.0 * 3.141592653589793;
      _gradients[i * 2] = _cos(angle);
      _gradients[i * 2 + 1] = _sin(angle);
    }
  }

  final int period;
  late final Float64List _gradients;

  double _dot(int cellX, int cellY, double dx, double dy) {
    final int index = ((cellY % period) * period + (cellX % period)) * 2;
    return _gradients[index] * dx + _gradients[index + 1] * dy;
  }

  /// Samples at ([x], [y]) measured in lattice cells.
  double sample(double x, double y) {
    final int x0 = x.floor();
    final int y0 = y.floor();
    final double fx = x - x0;
    final double fy = y - y0;
    final double u = _fade(fx);
    final double v = _fade(fy);

    final double n00 = _dot(x0, y0, fx, fy);
    final double n10 = _dot(x0 + 1, y0, fx - 1.0, fy);
    final double n01 = _dot(x0, y0 + 1, fx, fy - 1.0);
    final double n11 = _dot(x0 + 1, y0 + 1, fx - 1.0, fy - 1.0);

    return _lerp(_lerp(n00, n10, u), _lerp(n01, n11, u), v);
  }
}

// `dart:math`'s sin/cos are the platform's, and this generator refuses to
// depend on a platform for a checked-in artifact. These are the standard
// Taylor series, range-reduced, which is ample for choosing gradient
// directions.
double _cos(double x) => _sin(x + 1.5707963267948966);

double _sin(double x) {
  const double twoPi = 6.283185307179586;
  double t = x % twoPi;
  if (t > 3.141592653589793) t -= twoPi;
  if (t < -3.141592653589793) t += twoPi;
  final double t2 = t * t;
  double term = t;
  double sum = t;
  for (int i = 1; i <= 8; i++) {
    term *= -t2 / ((2 * i) * (2 * i + 1));
    sum += term;
  }
  return sum;
}

/// Generates the field as one byte per pixel, row-major, in `[0, 255]`.
///
/// Returned separately from the PNG so tests can assert the *pixels* — which
/// this file fully determines — without asserting the compressed container,
/// which a future zlib would be free to encode differently.
Uint8List generateField({
  int size = textureSize,
  int seed = textureSeed,
  int frequency = baseFrequency,
  int octaveCount = octaves,
}) {
  final List<_TileableGradientNoise> layers = <_TileableGradientNoise>[];
  final List<double> amplitudes = <double>[];
  double amplitude = 1.0;
  double totalAmplitude = 0.0;
  for (int octave = 0; octave < octaveCount; octave++) {
    layers.add(
      _TileableGradientNoise(
        period: frequency << octave,
        // Each octave gets its own gradient table. Deriving the seed from the
        // octave index rather than reusing one stream keeps the octaves
        // independent whatever `octaveCount` is.
        seed: (seed + octave * 0x9E3779B1) & 0xFFFFFFFF,
      ),
    );
    amplitudes.add(amplitude);
    totalAmplitude += amplitude;
    amplitude *= persistence;
  }

  final Uint8List pixels = Uint8List(size * size);
  for (int y = 0; y < size; y++) {
    for (int x = 0; x < size; x++) {
      double value = 0.0;
      for (int octave = 0; octave < octaveCount; octave++) {
        final int period = layers[octave].period;
        value +=
            layers[octave].sample(x * period / size, y * period / size) *
            amplitudes[octave];
      }
      // fBm of unit gradients lands well inside [-1, 1]; map to [0, 1]
      // centred on 0.5. [contrast] is a fixed constant rather than a rescale
      // by the observed extremes, which would make the output depend on the
      // seed and stop being reproducible for a caller who changes it.
      final double normalized = (value / totalAmplitude) * contrast + 0.5;
      final double clamped = normalized < 0.0
          ? 0.0
          : (normalized > 1.0 ? 1.0 : normalized);
      pixels[y * size + x] = (clamped * 255.0).round().clamp(0, 255);
    }
  }
  return pixels;
}

int _crc32(List<int> bytes) {
  int crc = 0xFFFFFFFF;
  for (final int byte in bytes) {
    crc ^= byte;
    for (int i = 0; i < 8; i++) {
      crc = (crc & 1) != 0 ? (crc >> 1) ^ 0xEDB88320 : crc >> 1;
    }
  }
  return (crc ^ 0xFFFFFFFF) & 0xFFFFFFFF;
}

void _writeChunk(BytesBuilder out, String type, List<int> data) {
  final Uint8List header = Uint8List(4)
    ..buffer.asByteData().setUint32(0, data.length);
  final List<int> typed = <int>[...ascii.encode(type), ...data];
  final Uint8List crc = Uint8List(4)
    ..buffer.asByteData().setUint32(0, _crc32(typed));
  out
    ..add(header)
    ..add(typed)
    ..add(crc);
}

/// Encodes [pixels] as an 8-bit RGBA PNG, grey replicated across RGB.
///
/// RGBA rather than greyscale because that is what the replaced file was
/// (colour type 6), and `voice_indicator.dart` decodes it through Flutter's own
/// image pipeline, which hands the shader an RGBA sampler either way. Keeping
/// the colour type identical means the replacement is a drop-in.
Uint8List encodePng(Uint8List pixels, {int size = textureSize}) {
  final BytesBuilder raw = BytesBuilder(copy: false);
  for (int y = 0; y < size; y++) {
    raw.addByte(0); // filter type 0 (None), so the bytes stay inspectable
    for (int x = 0; x < size; x++) {
      final int value = pixels[y * size + x];
      raw
        ..addByte(value)
        ..addByte(value)
        ..addByte(value)
        ..addByte(255);
    }
  }

  final BytesBuilder out = BytesBuilder(copy: false)
    ..add(<int>[0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]);

  final Uint8List ihdr = Uint8List(13);
  final ByteData header = ihdr.buffer.asByteData();
  header
    ..setUint32(0, size)
    ..setUint32(4, size);
  ihdr[8] = 8; // bit depth
  ihdr[9] = 6; // colour type: truecolour with alpha
  ihdr[10] = 0; // deflate
  ihdr[11] = 0; // adaptive filtering
  ihdr[12] = 0; // no interlace
  _writeChunk(out, 'IHDR', ihdr);

  _writeChunk(
    out,
    'IDAT',
    ZLibEncoder(level: 9, gzip: false).convert(raw.takeBytes()),
  );
  _writeChunk(out, 'IEND', const <int>[]);

  return out.takeBytes();
}
