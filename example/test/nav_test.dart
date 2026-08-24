import 'package:example/nav.dart';
import 'package:flutter_test/flutter_test.dart';

/// Locks `example/lib/nav.dart` to `design-system/lib/el/nav.ts`.
///
/// The nav is the one file the whole docs app reads: sidebar order, index
/// cards, page headers and the page-foot prev/next all come out of it, so a
/// silent edit here would move four surfaces at once. These tests pin the
/// shape (counts, order, routes), a sample of the verbatim copy, and the two
/// error paths the reference declares.
void main() {
  group('shape', () {
    test('four groups, in source order', () {
      expect(elGroups.length, 4);
      expect(elGroups.map((ElGroup g) => g.id).toList(), <String>[
        'foundations',
        'base',
        'agent',
        'site',
      ]);
      expect(elGroups.map((ElGroup g) => g.title).toList(), <String>[
        'Foundations',
        'Base Components',
        'Agent',
        'Site Pages',
      ]);
    });

    test('category counts per group', () {
      expect(elGroupById('foundations').categories.length, 6);
      expect(elGroupById('base').categories.length, 14);
      expect(elGroupById('agent').categories.length, 6);
      expect(elGroupById('site').categories.length, 6);
    });

    test('foundations order drives the sidebar and the foot nav', () {
      expect(
        elGroupById('foundations').categories.map((ElCategory c) => c.slug),
        <String>[
          'colors',
          'typography',
          'spacing',
          'shadows',
          'motion',
          'icons',
        ],
      );
      expect(
        elGroupById('foundations').categories.map((ElCategory c) => c.title),
        <String>[
          'Colors',
          'Typography',
          'Spacing & Layout',
          'Shadows',
          'Motion',
          'Icons',
        ],
      );
    });
  });

  group('routes', () {
    test('group index hrefs', () {
      expect(elRoot, '/design-system');
      expect(elGroupById('foundations').href, '/design-system');
      expect(elGroupById('base').href, '/design-system/components/base');
      expect(elGroupById('agent').href, '/design-system/components/agent');
      expect(elGroupById('site').href, '/design-system/components/site');
    });

    test('foundations categories hang off the root, not a group segment', () {
      final ElCategoryHit hit = findCategory('foundations', 'colors');
      expect(categoryHref(hit.group, hit.category), '/design-system/colors');
    });

    test('every other group nests under its own index', () {
      final ElCategoryHit hit = findCategory('base', 'buttons');
      expect(
        categoryHref(hit.group, hit.category),
        '/design-system/components/base/buttons',
      );
    });

    test('every href in the tree is unique', () {
      final List<String> hrefs = <String>[
        for (final ElGroup group in elGroups)
          for (final ElCategory category in group.categories)
            categoryHref(group, category),
      ];
      expect(hrefs.length, 32);
      expect(hrefs.toSet().length, hrefs.length);
    });

    test('every title and slug in the tree is non-empty', () {
      for (final ElGroup group in elGroups) {
        expect(group.title, isNotEmpty, reason: group.id);
        expect(group.blurb, isNotEmpty, reason: group.id);
        for (final ElCategory category in group.categories) {
          final String where = '${group.id}/${category.slug}';
          expect(category.title, isNotEmpty, reason: where);
          expect(category.slug, isNotEmpty, reason: group.id);
          expect(category.blurb, isNotEmpty, reason: category.slug);
          expect(category.contents, isNotEmpty, reason: category.slug);
        }
      }
    });
  });

  group('siblings', () {
    test('first category has no previous', () {
      final ElSiblings s = siblings('foundations', 'colors');
      expect(s.prev, isNull);
      expect(s.next?.title, 'Typography');
      expect(s.next?.href, '/design-system/typography');
    });

    test('a middle category sees both neighbours', () {
      final ElSiblings s = siblings('foundations', 'spacing');
      expect(s.prev?.title, 'Typography');
      expect(s.prev?.href, '/design-system/typography');
      expect(s.next?.title, 'Shadows');
      expect(s.next?.href, '/design-system/shadows');
    });

    test('last category has no next', () {
      final ElSiblings s = siblings('foundations', 'icons');
      expect(s.prev?.title, 'Motion');
      expect(s.next, isNull);
    });

    test('links resolve through categoryHref, so base nests', () {
      expect(
        siblings('base', 'inputs').prev?.href,
        '/design-system/components/base/buttons',
      );
    });

    // Both of these are the reference's behaviour, ported deliberately.
    test('unknown group degrades to nothing rather than throwing', () {
      final ElSiblings s = siblings('nope', 'colors');
      expect(s.prev, isNull);
      expect(s.next, isNull);
    });

    test('unknown slug points at the top of the group (findIndex −1)', () {
      final ElSiblings s = siblings('foundations', 'nope');
      expect(s.prev, isNull);
      expect(s.next?.title, 'Colors');
    });
  });

  group('lookup throws', () {
    test('findCategory rejects an unknown slug', () {
      expect(
        () => findCategory('foundations', 'nope'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('findCategory rejects an unknown group id', () {
      expect(
        () => findCategory('nope', 'colors'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('elGroupById rejects an unknown id', () {
      expect(() => elGroupById('nope'), throwsA(isA<ArgumentError>()));
      expect(elGroupById('site').title, 'Site Pages');
    });
  });

  group('copy is verbatim', () {
    test('colors blurb, character for character', () {
      expect(
        findCategory('foundations', 'colors').category.blurb,
        'Surfaces, the action and value ramps, text, hairlines, semantic states, '
        'and every contrast ratio measured live in both themes.',
      );
    });

    test('colors contents, in display order', () {
      expect(findCategory('foundations', 'colors').category.contents, <String>[
        'Surfaces',
        'Action ramp',
        'Value ramp',
        'Text',
        'Borders',
        'Semantic',
        'What is not a token',
        '70 / 20 / 10 balance',
      ]);
    });

    // The reference's blurb names Space Grotesk; its own comment records that
    // the line was already stale once, and this port renders Inter. The copy
    // still says Space Grotesk, and this test is why it stays that way.
    test('the typography blurb keeps the reference drift', () {
      expect(
        findCategory('foundations', 'typography').category.blurb,
        startsWith(
          'Two faces only: Space Grotesk for every word, Geist Mono '
          'for every number.',
        ),
      );
    });

    test('typographic characters survive the port', () {
      // En dash in a contents entry…
      expect(
        findCategory('foundations', 'shadows').category.contents.first,
        'Ambient e1–e4',
      );
      // …em dashes and an apostrophe in the group blurbs.
      expect(elGroupById('base').blurb, contains("this system's tokens"));
      expect(
        elGroupById('agent').blurb,
        contains('— transcript, composer, avatar and voice —'),
      );
    });
  });
}
