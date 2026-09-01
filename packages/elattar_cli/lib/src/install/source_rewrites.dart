/// Value rewrites applied to package source as it is copied into a consumer.
///
/// `DartImportTransformer` rewrites directive URIs, which covers everything
/// the analyzer can see. A small number of *values* in the package source are
/// just as package-scoped as an import and just as wrong once the file lives
/// in a consumer project, but they are ordinary Dart expressions, so no amount
/// of import rewriting reaches them and no analyzer can flag them.
///
/// The case this exists for is `Fonts.package`. Inside this package the
/// three faces are declared in the PACKAGE pubspec, so `flutter_tools` bundles
/// them under `packages/elattar_design_system/<Family>` and every `TextStyle`
/// carries `package: Fonts.package` to reach them. A consumer declares the
/// same faces in its OWN pubspec, where that prefix resolves to nothing: the
/// text compiles, analyzes clean, and renders in the platform fallback face.
///
/// Each rewrite is keyed on a logical registry target and matches an exact
/// **run of lines** that must occur exactly once. Matching lines rather than a
/// raw substring keeps the table independent of the checkout's line endings
/// (this repository checks out CRLF on Windows and LF on CI), and requiring a
/// unique match means a rewrite whose anchor has drifted fails the install
/// loudly instead of silently shipping the wrong glyphs. A font family is a
/// string; this seam has to be guarded by construction, not by analysis.
library;

/// One exact replacement of a run of source lines in one registry file.
class SourceRewrite {
  const SourceRewrite({
    required this.target,
    required this.original,
    required this.replacement,
    required this.reason,
  });

  /// The logical registry target this rewrite applies to, e.g.
  /// `@foundation/typography.dart`.
  final String target;

  /// The package-source lines to replace, without line terminators. Matched
  /// exactly and required to occur exactly once in the file.
  final List<String> original;

  /// The consumer-side lines written in their place.
  final List<String> replacement;

  /// Why the package-side text cannot survive the copy. Quoted in the failure
  /// message when [original] no longer matches.
  final String reason;
}

/// The logical target carrying `Fonts`.
const String typographyTarget = '@foundation/typography.dart';

/// Every rewrite the installer applies. Additions belong here, not in ad-hoc
/// string surgery at a call site.
const List<SourceRewrite> installSourceRewrites = <SourceRewrite>[
  SourceRewrite(
    target: typographyTarget,
    original: <String>[
      '  /// The name of this package, threaded into every [TextStyle] this file',
      '  /// builds.',
      '  ///',
      '  /// The faces are declared in the PACKAGE pubspec, so `flutter_tools` bundles',
      '  /// them for every dependent app under the prefixed family',
      '  /// `packages/elattar_design_system/<Family>`. `TextStyle(package: …)` applies',
      '  /// exactly that prefix, which is why [TextStyleToken.family] stays the bare',
      '  /// family name and the resolvers pass this: call sites never think about',
      '  /// prefixing.',
      "  static const String package = 'elattar_design_system';",
    ],
    replacement: <String>[
      '  /// No package prefix — rewritten by `elattar` on install.',
      '  ///',
      '  /// In the design-system package the two faces above are declared in',
      '  /// the PACKAGE pubspec, so `flutter_tools` bundles them under',
      '  /// `packages/<name>/<Family>` and every [TextStyle] passes the package',
      '  /// name to reach them. This project declares the same faces in its own',
      '  /// pubspec, where that prefix resolves to nothing at all: text would',
      '  /// compile, analyze clean, and render in the platform fallback face.',
      '  /// Null is what [TextStyle.package] needs for an unprefixed family.',
      '  static const String? package = null;',
    ],
    reason:
        'Fonts.package prefixes every font family with '
        '"packages/elattar_design_system/", which resolves to nothing in a '
        'consumer project that declares the same faces itself',
  ),
];

/// Applies [installSourceRewrites] to copied package source.
class SourceRewriter {
  const SourceRewriter({this.rewrites = installSourceRewrites});

  final List<SourceRewrite> rewrites;

  /// Returns [content] with every rewrite registered for [target] applied.
  ///
  /// Throws [StateError] when a registered rewrite does not match exactly
  /// once: a silently skipped rewrite is precisely the failure this exists to
  /// prevent.
  String rewrite({required String target, required String content}) {
    String result = content;
    for (final SourceRewrite rewrite in rewrites) {
      if (rewrite.target != target) continue;
      result = _apply(rewrite, result);
    }
    return result;
  }

  String _apply(SourceRewrite rewrite, String content) {
    final String terminator = content.contains('\r\n') ? '\r\n' : '\n';
    final List<String> lines = content.split(terminator);
    final List<int> matches = <int>[];
    for (int i = 0; i + rewrite.original.length <= lines.length; i++) {
      bool matched = true;
      for (int j = 0; j < rewrite.original.length; j++) {
        if (lines[i + j] != rewrite.original[j]) {
          matched = false;
          break;
        }
      }
      if (matched) matches.add(i);
    }
    if (matches.length != 1) {
      throw StateError(
        'Install rewrite for ${rewrite.target} matched ${matches.length} '
        'times, expected exactly 1.\n'
        'Looked for:\n${rewrite.original.join('\n')}\n'
        'Why this rewrite exists: ${rewrite.reason}.\n'
        'The package source has changed shape. Update '
        '`installSourceRewrites` in '
        'packages/elattar_cli/lib/src/install/source_rewrites.dart.',
      );
    }
    lines.replaceRange(
      matches.single,
      matches.single + rewrite.original.length,
      rewrite.replacement,
    );
    return lines.join(terminator);
  }
}
