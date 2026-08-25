/// Every component page is the same page.
///
/// A rollout written by many hands drifts unless the shape is checked
/// mechanically — a missing Accessibility disclosure here, a hand-written
/// table of contents there, an install command typed as a literal. This is
/// that check, and it is what makes 99 pages reviewable at all.
///
/// It reads `componentDocSpecs` (`components_docs/specs.dart`), which lists
/// the pages actually on the kit. A page not yet migrated is absent from that
/// map and is not checked; a page that is on the kit has no way to opt out.
library;

import 'package:example/components_docs/catalog.dart';
import 'package:example/components_docs/specs.dart';
import 'package:example/docs/component_doc_page.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// The eight disclosures every component page carries, in order.
const List<String> _requiredDisclosures = <String>[
  'API Reference',
  'States',
  'Accessibility',
  'Keyboard',
  'Responsive',
  'Dependencies',
  'Theming',
  'Source',
];

void main() {
  test('every migrated page declares the house shape', () {
    expect(
      componentDocSpecs,
      isNotEmpty,
      reason: 'the guard checks nothing if nothing is registered',
    );

    componentDocSpecs.forEach((String name, ComponentDocSpec spec) {
      final ComponentDocEntry entry = componentDoc(name.replaceAll('-', '_'));

      final List<String> titles = spec.sections
          .map((DocsPageSection s) => s.title)
          .toList();

      expect(
        titles.length,
        greaterThanOrEqualTo(3 + _requiredDisclosures.length),
        reason: '$name: too few sections to be the house shape',
      );
      expect(titles.first, 'Preview', reason: '$name: first section');
      expect(titles[1], 'Installation', reason: '$name: second section');
      expect(titles[2], 'Usage', reason: '$name: third section');
      expect(
        titles.sublist(titles.length - _requiredDisclosures.length),
        _requiredDisclosures,
        reason: '$name: the trailing disclosures, in order',
      );

      expect(
        spec.sections.whereType<InstallSection>().length,
        1,
        reason: '$name: exactly one install section',
      );
      expect(
        spec.sections.whereType<InstallSection>().single.command,
        entry.command,
        reason: '$name: the command must come from the catalog entry',
      );
      expect(
        spec.name,
        entry.name.replaceAll('_', '-'),
        reason: '$name: the spec and the entry must name the same item',
      );

      final Set<String> ids = <String>{};
      for (final DocsPageSection section in spec.sections) {
        expect(
          ids.add(section.id),
          isTrue,
          reason: '$name: duplicate section id "${section.id}"',
        );
      }

      // A rail entry that points at nothing is worse than no rail entry, so
      // the derived toc must cover every section and only sections.
      expect(
        spec.toc.map((DocsTocEntry e) => e.anchor).toList(),
        spec.sections.map((DocsPageSection s) => s.id).toList(),
        reason: '$name: the toc is derived, never written twice',
      );
    });
  });

  test('a disclosure section contributes its children to the toc', () {
    const ComponentDocSpec spec = ComponentDocSpec(
      name: 'x',
      title: 'X',
      description: 'd',
      sections: <DocsPageSection>[
        DisclosureSection(
          id: 'api',
          title: 'API Reference',
          child: SizedBox.shrink(),
          children: <DocsTocEntry>[
            DocsTocEntry(title: 'ElX', anchor: 'api-elx'),
            DocsTocEntry(title: 'ElXSize', anchor: 'api-elx-size'),
          ],
        ),
      ],
    );

    expect(spec.toc.single.anchor, 'api');
    expect(
      spec.toc.single.children.map((DocsTocEntry e) => e.anchor).toList(),
      <String>['api-elx', 'api-elx-size'],
    );
  });

  test('a non-disclosure section contributes no children', () {
    const ComponentDocSpec spec = ComponentDocSpec(
      name: 'x',
      title: 'X',
      description: 'd',
      sections: <DocsPageSection>[
        SnippetSection(id: 'usage', title: 'Usage', code: 'x'),
      ],
    );

    expect(spec.toc.single.children, isEmpty);
  });
}
