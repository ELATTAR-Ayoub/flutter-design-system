/// Elattar's own license, embedded so `init` can write it anywhere.
///
/// The CLI installs a `LICENSES/ELATTAR-MIT.txt` into every project it
/// initialises, because the components it copies in are substantial portions
/// of MIT-licensed software and MIT's one condition is that the notice travels
/// with them. Nothing else in a consumer project would carry it: the installed
/// sources become that project's own code, and the repository they came from
/// may never be cloned.
///
/// Embedded as a constant rather than read from a file. A CLI activated from
/// pub.dev has no repository beside it to read a `LICENSE` out of, and a
/// notice that silently failed to install in exactly the case the release
/// plan calls the primary distribution route would be worse than none.
///
/// `test/license_notice_test.dart` compares these bytes against the package's
/// own `LICENSE` and against the repository root's, so the three cannot drift.
library;

/// The full text of the repository's `LICENSE`, byte for byte.
const String elattarMitNotice = r'''
MIT License

Copyright (c) 2026 ELATTAR Ayoub

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
''';

/// Where [elattarMitNotice] installs, as a logical registry target.
///
/// A logical target rather than a path so it maps through the same
/// `LogicalTargetMapper` as every registry-delivered notice, and lands beside
/// them instead of in a second location that only `init` knows about.
const String elattarMitNoticeTarget = '@license/ELATTAR-MIT.txt';
