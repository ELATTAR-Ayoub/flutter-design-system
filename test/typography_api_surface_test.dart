/// What the typography layer publishes, pinned on purpose.
///
/// The barrel exports whole files, so anything public in `typography.dart` or
/// `theme_scope.dart` is public in the package whether or not anyone decided it
/// should be. That is how machinery leaks into an API: not by a decision, but
/// by the absence of one.
///
/// This test is the decision. It lists the typography surface a consumer is
/// entitled to and fails when the tree grows a public name that is not on the
/// list — which is a prompt to either add it deliberately or make it private,
/// never to widen the list on the way past.
///
/// It reads the source rather than using reflection: `dart:mirrors` is
/// unavailable under Flutter, and the source is the thing being reviewed.
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The public members of `TextStyles`.
///
/// Seventeen roles, three sets, and the catalog. A caller reaches a group by
/// name — `TextStyles.wordRoles` — rather than by holding a `TypeGroup`, which
/// is why there is no `ofGroup` here.
const Set<String> _textStylesMembers = <String>{
  // The seventeen roles.
  'display', 'h1', 'h2', 'h3', 'h4', 'lead', 'body', 'small', 'nav', 'badge',
  'code', 'identifier',
  'numberSm', 'numberBase', 'numberMd', 'numberLg', 'numberXl',
  // The typeset, as sets.
  'wordRoles', 'codeRoles', 'numericRoles', 'all',
};

/// The public members of `TextStyleToken`.
///
/// `derive` is on the list deliberately: component anatomy — a button label at
/// medium weight, a table cell with tabular figures — is built by deriving from
/// a role, and a consumer writing their own component needs the same seam the
/// package's components use. It is not a way to invent a size: it keeps the
/// role's steps and changes only what it is asked to.
const Set<String> _tokenMembers = <String>{
  'name',
  'group',
  'family',
  'mobile',
  'tablet',
  'desktop',
  'step',
  'stepFor',
  'isStatic',
  'wght',
  'weight',
  'variations',
  'tracking',
  'tabular',
  'fontStyle',
  'resolveWidth',
  'resolveStep',
  'resolveInline',
  'derive',
};

/// Top-level public declarations in `typography.dart`.
///
/// `TypeGroup` is here as the label a role carries, not as a lookup key — see
/// [_textStylesMembers]. `TypeStep` is a value a caller reads a size and a line
/// height out of.
const Set<String> _typographyTopLevel = <String>{
  'Fonts',
  'TypeGroup',
  'TypeStep',
  'TextStyleToken',
  'TextStyles',
};

/// Top-level public declarations in `theme_scope.dart`.
const Set<String> _scopeTopLevel = <String>{
  'ColorMode',
  'ThemeController',
  'ThemeScope',
  'TypeWidthScope',
  'StyledText',
  'RichText',
  'effectiveMotionDuration',
};

String _read(String path) => File(path).readAsStringSync();

/// Public top-level `class`/`enum`/`mixin`/function names in [source].
Set<String> _topLevelNames(String source) {
  final Set<String> found = <String>{};
  for (final RegExpMatch m in RegExp(
    r'^(?:abstract )?(?:final )?(?:sealed )?(?:class|enum|mixin) '
    r'([A-Za-z_][A-Za-z0-9_]*)',
    multiLine: true,
  ).allMatches(source)) {
    found.add(m.group(1)!);
  }
  for (final RegExpMatch m in RegExp(
    r'^[A-Za-z_][A-Za-z0-9_<>?, ]* ([a-z][A-Za-z0-9_]*)\(',
    multiLine: true,
  ).allMatches(source)) {
    found.add(m.group(1)!);
  }
  return found.where((String n) => !n.startsWith('_')).toSet();
}

/// Public member names declared inside `class [name]` in [source].
Set<String> _classMembers(String source, String name) {
  final int start = source.indexOf('class $name {');
  expect(start, greaterThanOrEqualTo(0), reason: '$name not found');
  final int end = source.indexOf('\n}', start);
  final String body = source.substring(start, end);
  final Set<String> found = <String>{};
  for (final RegExpMatch m in RegExp(
    r'^  (?:static )?(?:final |const )?'
    r'[A-Za-z_][A-Za-z0-9_<>?, ]*? ([a-zA-Z_][A-Za-z0-9_]*)\s*(?:=|;|\()',
    multiLine: true,
  ).allMatches(body)) {
    found.add(m.group(1)!);
  }
  for (final RegExpMatch m in RegExp(
    r'^  [A-Za-z_][A-Za-z0-9_<>?, ]*? get ([a-zA-Z_][A-Za-z0-9_]*)',
    multiLine: true,
  ).allMatches(body)) {
    found.add(m.group(1)!);
  }
  return found.where((String n) => !n.startsWith('_')).toSet();
}

void main() {
  const String typographyPath =
      'lib/src/design_system/foundation/typography.dart';
  const String scopePath = 'lib/src/design_system/foundation/theme_scope.dart';

  group('the typography surface is the one that was approved', () {
    test('typography.dart publishes exactly five top-level names', () {
      expect(_topLevelNames(_read(typographyPath)), _typographyTopLevel);
    });

    test('theme_scope.dart publishes exactly its scope and text surface', () {
      expect(_topLevelNames(_read(scopePath)), _scopeTopLevel);
    });

    test('TextStyles publishes the seventeen roles and the three sets', () {
      final Set<String> members = _classMembers(
        _read(typographyPath),
        'TextStyles',
      );
      expect(members, _textStylesMembers);
      expect(
        members,
        isNot(contains('ofGroup')),
        reason: 'a group is reached by its set, not by holding a TypeGroup',
      );
    });

    test('TextStyleToken publishes its steps, its metadata, and derive', () {
      expect(
        _classMembers(_read(typographyPath), 'TextStyleToken'),
        _tokenMembers,
      );
    });
  });

  group('the guard would notice a leak', () {
    test('a new public class in typography.dart would fail the list', () {
      const String sample = 'class TypeRamp {\n}\n';
      expect(_topLevelNames(sample), contains('TypeRamp'));
      expect(_typographyTopLevel, isNot(contains('TypeRamp')));
    });

    test('a private declaration is not surface', () {
      expect(_topLevelNames('class _Hidden {\n}\n'), isEmpty);
    });
  });
}
