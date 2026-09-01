/// Guards the one property this whole tool exists for: a missing or
/// malformed `ELATTAR_SITE_ORIGIN` / `ELATTAR_SITE_BASE_HREF` must fail here,
/// loudly, before `flutter build web` ever runs — not ship as a white screen.
library;

import 'package:test/test.dart';

import '../lib/build_site.dart';

void main() {
  group('parseDotEnv', () {
    test('parses KEY=VALUE lines and ignores comments and blanks', () {
      final Map<String, String> env = parseDotEnv('''
# a comment
ELATTAR_SITE_ORIGIN=https://example.test

ELATTAR_SITE_BASE_HREF=/sub/
''');
      expect(env['ELATTAR_SITE_ORIGIN'], 'https://example.test');
      expect(env['ELATTAR_SITE_BASE_HREF'], '/sub/');
      expect(env.length, 2);
    });

    test('strips matching surrounding quotes', () {
      final Map<String, String> env = parseDotEnv(
        'A="quoted"\nB=\'single\'\nC=bare\n',
      );
      expect(env['A'], 'quoted');
      expect(env['B'], 'single');
      expect(env['C'], 'bare');
    });
  });

  group('resolveVar precedence', () {
    test('real environment wins over .env, which wins over the default', () {
      expect(
        resolveVar(
          key: 'K',
          processEnv: <String, String>{'K': 'from-process'},
          dotEnv: <String, String>{'K': 'from-file'},
          fallback: 'from-default',
        ),
        'from-process',
      );
      expect(
        resolveVar(
          key: 'K',
          processEnv: const <String, String>{},
          dotEnv: <String, String>{'K': 'from-file'},
          fallback: 'from-default',
        ),
        'from-file',
      );
      expect(
        resolveVar(
          key: 'K',
          processEnv: const <String, String>{},
          dotEnv: const <String, String>{},
          fallback: 'from-default',
        ),
        'from-default',
      );
    });
  });

  group('validateOrigin', () {
    test('accepts a bare https origin', () {
      expect(
        () => validateOrigin('https://flutter.elattar.dev'),
        returnsNormally,
      );
    });

    test('rejects an empty value', () {
      expect(() => validateOrigin(''), throwsA(isA<BuildConfigException>()));
    });

    test('rejects a scheme-less host', () {
      expect(
        () => validateOrigin('flutter.elattar.dev'),
        throwsA(isA<BuildConfigException>()),
      );
    });

    test('rejects a non-http(s) scheme', () {
      expect(
        () => validateOrigin('ftp://flutter.elattar.dev'),
        throwsA(isA<BuildConfigException>()),
      );
    });

    test('rejects a trailing slash', () {
      expect(
        () => validateOrigin('https://flutter.elattar.dev/'),
        throwsA(isA<BuildConfigException>()),
      );
    });
  });

  group('validateBaseHref', () {
    test('accepts the domain-root default', () {
      expect(() => validateBaseHref('/'), returnsNormally);
    });

    test('accepts a subpath', () {
      expect(
        () => validateBaseHref('/flutter-design-system/'),
        returnsNormally,
      );
    });

    test('rejects a value missing the leading slash', () {
      expect(
        () => validateBaseHref('flutter-design-system/'),
        throwsA(isA<BuildConfigException>()),
      );
    });

    test('rejects a value missing the trailing slash', () {
      expect(
        () => validateBaseHref('/flutter-design-system'),
        throwsA(isA<BuildConfigException>()),
      );
    });

    test('rejects an empty value', () {
      expect(() => validateBaseHref(''), throwsA(isA<BuildConfigException>()));
    });
  });

  group('SiteBuildConfig.resolve', () {
    test('falls back to the documented defaults with nothing set', () {
      final SiteBuildConfig config = SiteBuildConfig.resolve(
        processEnv: const <String, String>{},
        dotEnv: const <String, String>{},
        registryVersion: '0.0.1',
      );
      expect(config.origin, defaultSiteOrigin);
      expect(config.baseHref, defaultBaseHref);
    });

    test(
      'throws BuildConfigException on a malformed origin rather than building',
      () {
        expect(
          () => SiteBuildConfig.resolve(
            processEnv: const <String, String>{
              'ELATTAR_SITE_ORIGIN': 'not a url',
            },
            dotEnv: const <String, String>{},
            registryVersion: '0.0.1',
          ),
          throwsA(isA<BuildConfigException>()),
        );
      },
    );
  });

  group('extractCliVersion', () {
    test('reads the version out of identity.dart-shaped source', () {
      expect(
        extractCliVersion("const String cliVersion = '0.0.1';\n"),
        '0.0.1',
      );
    });

    test('throws if the constant is not found, rather than guessing', () {
      expect(
        () => extractCliVersion('// no such constant here\n'),
        throwsA(isA<BuildConfigException>()),
      );
    });
  });
}
