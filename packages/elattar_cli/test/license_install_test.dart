/// A consumer must not be able to end up holding third-party source without
/// the notice that permits it — and must not be able to lose their own
/// license files to an Elattar install.
///
/// Every test here drives `Installer.plan` directly against a temporary
/// project, because the questions are all about what lands on disk and what
/// survives, not about command parsing.
library;

import 'dart:io';

import 'package:test/test.dart';

import '../lib/src/install/installer.dart';
import '../lib/src/install/models.dart';
import '../lib/src/install/target_mapper.dart';
import '../lib/src/license_notice.dart';

/// A stand-in for the repository the registry reads sources out of.
class _Fixture {
  _Fixture() : root = Directory.systemTemp.createTempSync('elattar-license-') {
    repository = Directory('${root.path}/repo')..createSync(recursive: true);
    project = Directory('${root.path}/app')..createSync(recursive: true);
    _write('third_party/pretend/LICENSE', _pretendNotice);
    _write('lib/src/components/thing.dart', "class Thing {}\n");
    _write('lib/src/other/other.dart', "class Other {}\n");
  }

  final Directory root;
  late final Directory repository;
  late final Directory project;

  static const String _pretendNotice =
      'ISC License\n\nCopyright (c) 2026 Somebody Else\n\n'
      'Permission to use, copy, modify, and/or distribute this software for '
      'any purpose with or without fee is hereby granted.\n';

  void _write(String relative, String content) {
    final File file = File('${repository.path}/$relative')
      ..parent.createSync(recursive: true);
    file.writeAsStringSync(content);
  }

  String projectFile(String relative) => '${project.path}/$relative';

  File licence(String name) => File(projectFile('LICENSES/$name'));

  void dispose() => root.deleteSync(recursive: true);
}

InstallItem _itemWithNotice({String name = 'thing'}) => InstallItem(
  name: name,
  version: '0.0.1',
  files: const <InstallFile>[
    InstallFile(
      source: 'lib/src/components/thing.dart',
      target: '@ui/thing.dart',
      sha256: 'unused-by-the-installer',
    ),
  ],
  licenses: const <InstallResource>[
    InstallResource(
      source: 'third_party/pretend/LICENSE',
      target: '@license/Pretend-ISC.txt',
      sha256: 'unused-by-the-installer',
    ),
  ],
);

InstallItem _itemWithoutNotice() => const InstallItem(
  name: 'other',
  version: '0.0.1',
  files: <InstallFile>[
    InstallFile(
      source: 'lib/src/other/other.dart',
      target: '@ui/other.dart',
      sha256: 'unused-by-the-installer',
    ),
  ],
);

void _apply(
  _Fixture fixture, {
  required List<InstallItem> items,
  bool overwrite = false,
  Map<String, String> textNotices = const <String, String>{},
}) {
  final Installer installer = Installer();
  final InstallPlan plan = installer.plan(
    projectRoot: fixture.project,
    repositoryRoot: fixture.repository,
    items: items,
    overwrite: overwrite,
    textNotices: textNotices,
  );
  installer.apply(plan);
}

void main() {
  late _Fixture fixture;

  setUp(() => fixture = _Fixture());
  tearDown(() => fixture.dispose());

  group('where a notice lands', () {
    test('@license/ maps to LICENSES/ at the project root', () {
      const LogicalTargetMapper mapper = LogicalTargetMapper();
      expect(
        mapper
            .destination('/tmp/app', '@license/Lucide-ISC.txt')
            .replaceAll('\\', '/'),
        endsWith('LICENSES/Lucide-ISC.txt'),
      );
      expect(licensesDirectory, 'LICENSES');
    });

    test('it is outside lib/ and outside the asset bundle', () {
      const LogicalTargetMapper mapper = LogicalTargetMapper();
      final String destination = mapper
          .destination('/tmp/app', '@license/Lucide-ISC.txt')
          .replaceAll('\\', '/');
      expect(destination, isNot(contains('/lib/')));
      expect(destination, isNot(contains('/assets/')));
    });
  });

  group('installing an item that carries a notice', () {
    test('writes the notice byte for byte beside the source', () {
      _apply(fixture, items: <InstallItem>[_itemWithNotice()]);
      expect(fixture.licence('Pretend-ISC.txt').existsSync(), isTrue);
      expect(
        fixture.licence('Pretend-ISC.txt').readAsBytesSync(),
        File(
          '${fixture.repository.path}/third_party/pretend/LICENSE',
        ).readAsBytesSync(),
      );
    });

    test('does not register the notice as a Flutter asset', () {
      // A license belongs in the repository, not compiled into the shipped
      // binary. If this ever regresses, every consumer app grows by the size
      // of every notice for no benefit.
      _apply(fixture, items: <InstallItem>[_itemWithNotice()]);
      final String pubspec = File(
        fixture.projectFile('pubspec.yaml'),
      ).readAsStringSync();
      expect(pubspec, isNot(contains('LICENSES')));
    });

    test('a second identical install is a no-op, not a conflict', () {
      _apply(fixture, items: <InstallItem>[_itemWithNotice()]);
      final DateTime first = fixture
          .licence('Pretend-ISC.txt')
          .statSync()
          .modified;

      final Installer installer = Installer();
      final InstallPlan plan = installer.plan(
        projectRoot: fixture.project,
        repositoryRoot: fixture.repository,
        items: <InstallItem>[_itemWithNotice()],
      );
      expect(plan.conflicts, isEmpty);
      expect(
        plan.operations.where(
          (InstallOperation operation) =>
              operation.destination.contains('Pretend-ISC.txt'),
        ),
        isEmpty,
        reason: 'an unchanged notice should not be queued for rewriting',
      );
      expect(fixture.licence('Pretend-ISC.txt').statSync().modified, first);
    });

    test('two items declaring the same notice both install cleanly', () {
      // Deduplication is deliberately not applied to notices: every item that
      // redistributes third-party material declares its own. Installing both
      // must therefore be conflict-free rather than a double-write error.
      final Installer installer = Installer();
      final InstallPlan plan = installer.plan(
        projectRoot: fixture.project,
        repositoryRoot: fixture.repository,
        items: <InstallItem>[
          _itemWithNotice(),
          _itemWithNotice(name: 'thing-again'),
        ],
      );
      expect(plan.conflicts, isEmpty);
      installer.apply(plan);
      expect(fixture.licence('Pretend-ISC.txt').existsSync(), isTrue);
    });
  });

  group('partial installs', () {
    test('an item with no third-party material writes no notice', () {
      _apply(fixture, items: <InstallItem>[_itemWithoutNotice()]);
      expect(fixture.licence('Pretend-ISC.txt').existsSync(), isFalse);
    });

    test('installing the vendored item later still delivers its notice', () {
      _apply(fixture, items: <InstallItem>[_itemWithoutNotice()]);
      expect(fixture.licence('Pretend-ISC.txt').existsSync(), isFalse);
      _apply(fixture, items: <InstallItem>[_itemWithNotice()]);
      expect(fixture.licence('Pretend-ISC.txt').existsSync(), isTrue);
    });
  });

  group('--overwrite', () {
    test('restores a notice the consumer edited', () {
      _apply(fixture, items: <InstallItem>[_itemWithNotice()]);
      fixture.licence('Pretend-ISC.txt').writeAsStringSync('mine now\n');

      _apply(fixture, items: <InstallItem>[_itemWithNotice()], overwrite: true);
      expect(
        fixture.licence('Pretend-ISC.txt').readAsStringSync(),
        contains('Permission to use, copy, modify'),
      );
    });

    test('refuses rather than clobbers an edited notice without the flag', () {
      _apply(fixture, items: <InstallItem>[_itemWithNotice()]);
      fixture.licence('Pretend-ISC.txt').writeAsStringSync('mine now\n');

      final InstallPlan plan = Installer().plan(
        projectRoot: fixture.project,
        repositoryRoot: fixture.repository,
        items: <InstallItem>[_itemWithNotice()],
      );
      expect(plan.conflicts, isNotEmpty);
      expect(plan.canApply, isFalse);
      expect(
        fixture.licence('Pretend-ISC.txt').readAsStringSync(),
        'mine now\n',
      );
    });

    test('does not delete license files Elattar never installed', () {
      // The consumer's own `LICENSES/` entries are theirs. `--overwrite`
      // rewrites the destinations the plan names and touches nothing else;
      // a clearing pass over the directory would silently destroy a
      // project's own licensing record.
      _apply(fixture, items: <InstallItem>[_itemWithNotice()]);
      final File theirs = fixture.licence('MY-COMPANY-EULA.txt')
        ..writeAsStringSync('all rights reserved by us\n');

      _apply(fixture, items: <InstallItem>[_itemWithNotice()], overwrite: true);
      expect(theirs.existsSync(), isTrue);
      expect(theirs.readAsStringSync(), 'all rights reserved by us\n');
    });
  });

  group('Elattar\'s own MIT notice', () {
    test('the embedded constant is exactly the repository LICENSE', () {
      // The one copy that reaches a consumer of a pub.dev-installed CLI, so
      // it is compared against the real file rather than spot-checked.
      //
      // Deliberately not guarded by an `existsSync` early return: a test that
      // quietly passes when its subject is missing is the failure mode this
      // release is trying to remove, not one to reproduce. `dart test` runs
      // with this package as the working directory, so the repository root is
      // two levels up.
      final File license = File('../../LICENSE');
      expect(
        license.existsSync(),
        isTrue,
        reason: 'the repository LICENSE is the source this constant copies',
      );
      expect(elattarMitNotice, license.readAsStringSync());
    });

    test('it carries the confirmed copyright line and the MIT conditions', () {
      expect(elattarMitNotice, startsWith('MIT License'));
      expect(elattarMitNotice, contains('Copyright (c) 2026 ELATTAR Ayoub'));
      expect(
        elattarMitNotice,
        contains('Permission is hereby granted, free of charge'),
      );
      expect(elattarMitNotice, endsWith('SOFTWARE.\n'));
    });

    test('a mutation installs it into a project that has no LICENSES/', () {
      _apply(
        fixture,
        items: <InstallItem>[_itemWithoutNotice()],
        textNotices: const <String, String>{
          elattarMitNoticeTarget: elattarMitNotice,
        },
      );
      expect(
        fixture.licence('ELATTAR-MIT.txt').readAsStringSync(),
        elattarMitNotice,
      );
    });

    test('a later mutation restores it if the consumer deleted it', () {
      _apply(
        fixture,
        items: <InstallItem>[_itemWithoutNotice()],
        textNotices: const <String, String>{
          elattarMitNoticeTarget: elattarMitNotice,
        },
      );
      fixture.licence('ELATTAR-MIT.txt').deleteSync();

      _apply(
        fixture,
        items: <InstallItem>[_itemWithNotice()],
        textNotices: const <String, String>{
          elattarMitNoticeTarget: elattarMitNotice,
        },
      );
      expect(fixture.licence('ELATTAR-MIT.txt').existsSync(), isTrue);
    });
  });
}
