// example/lib/docs/component_doc_page.dart
/// A component documentation page, as a component.
///
/// A page file declares its content and nothing else. Presentation lives in
/// the kit, so every component page is the same page — and so the forty-nine
/// registry items with no page today cost a declaration.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import 'docs_code.dart' show DocsCodeFile;
import 'docs_disclosure.dart';
import 'docs_install.dart';
import 'docs_layout.dart' show DocsTocEntry;
import 'docs_section.dart';
import 'docs_showcase.dart';
import 'docs_snippet.dart';

export 'docs_code.dart' show DocsCodeFile;
export 'docs_layout.dart' show DocsTocEntry;

/// One section of a page. Four kinds, and no escape hatch: a fifth need is a
/// fifth case, reviewed as one.
sealed class DocsPageSection {
  const DocsPageSection({
    required this.id,
    required this.title,
    this.description,
  });

  /// The anchor the table of contents scrolls to.
  final String id;
  final String title;
  final String? description;
}

/// A live specimen with its source behind a toggle.
class ShowcaseSection extends DocsPageSection {
  const ShowcaseSection({
    required super.id,
    required super.title,
    super.description,
    required this.specimen,
    required this.code,
    this.alignment = Alignment.center,
    this.label,
  });

  final Widget specimen;
  final String code;
  final Alignment alignment;

  /// [DocsShowcase.label]. Defaults to null, which lets [DocsShowcase] fall
  /// back to `'Specimen view'`. A page with more than one showcase should
  /// give each its own, so its toggle group announces which section it
  /// belongs to rather than repeating the same name for every one.
  final String? label;
}

/// Prose plus one uncapped code block. Usage is the only one Button needs.
class SnippetSection extends DocsPageSection {
  const SnippetSection({
    required super.id,
    required super.title,
    super.description,
    required this.code,
  });

  final String code;
}

/// The install command and its manual equivalent.
class InstallSection extends DocsPageSection {
  const InstallSection({
    required super.id,
    required super.title,
    super.description,
    required this.command,
    required this.manualFiles,
  });

  final String command;
  final List<DocsCodeFile> manualFiles;
}

/// A text-or-table section, collapsed by default.
class DisclosureSection extends DocsPageSection {
  const DisclosureSection({
    required super.id,
    required super.title,
    super.description,
    required this.child,
  });

  final Widget child;
}

/// Everything a component page is.
class ComponentDocSpec {
  const ComponentDocSpec({
    required this.name,
    required this.title,
    required this.description,
    required this.sections,
  });

  /// The registry item name, e.g. `button`.
  final String name;
  final String title;
  final String description;
  final List<DocsPageSection> sections;

  /// Derived, never written twice: a section cannot exist without a rail
  /// entry, and a rail entry cannot point at nothing.
  List<DocsTocEntry> get toc => <DocsTocEntry>[
    for (final DocsPageSection section in sections)
      DocsTocEntry(title: section.title, anchor: section.id),
  ];
}

/// The page's title block.
class DocsPageHeader extends StatelessWidget {
  const DocsPageHeader({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: el(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ElText(
            title,
            ElType.h1,
            color: theme.foreground,
            fontSize: ElFluid.h1(context),
          ),
          SizedBox(height: el(3)),
          ElText(description, ElType.lead),
        ],
      ),
    );
  }
}

class ComponentDocPage extends StatelessWidget {
  const ComponentDocPage({super.key, required this.spec, this.header = true});

  final ComponentDocSpec spec;

  /// Whether to render [DocsPageHeader] above the sections.
  ///
  /// `DocsLayout` already renders an eyebrow, title and description from its
  /// own required `intro`, so a page hosted inside one passes `false` here
  /// to avoid showing the title twice. Defaults to `true` for a page rendered
  /// on its own, or hosted somewhere that does not already carry a header.
  final bool header;

  Widget _body(DocsPageSection section) => switch (section) {
    ShowcaseSection(:final Widget specimen, :final String code,
        :final Alignment alignment, :final String? label) =>
      DocsShowcase(
        specimen: specimen,
        code: code,
        alignment: alignment,
        label: label,
      ),
    SnippetSection(:final String code) => DocsSnippet(code: code),
    InstallSection(:final String command, :final List<DocsCodeFile> manualFiles) =>
      DocsInstall(command: command, manualFiles: manualFiles),
    DisclosureSection(:final Widget child, :final String title) =>
      DocsDisclosure(title: title, child: child),
  };

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      if (header) DocsPageHeader(title: spec.title, description: spec.description),
      for (final DocsPageSection section in spec.sections)
        DocsSection(
          id: section.id,
          title: section.title,
          description: section.description,
          child: _body(section),
        ),
    ],
  );
}
