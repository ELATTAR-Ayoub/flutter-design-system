/// Public documentation page for `/docs/typeset`.
///
/// The job is narrow and worth stating: a Flutter developer arrives knowing
/// what they are about to write — a section heading, a stat, a caveat — and
/// leaves with the right `TextStyles` role and a line they can paste. Everything
/// on the page serves that, and the page teaches no raw `TextStyle` value,
/// because a reader who copies a font size has taken the system apart.
///
/// Two rules hold the content together.
///
/// **Every specimen is the real token.** Nothing here restates a size or a
/// weight in prose. The metadata beside each role is read out of its
/// `TextStyleToken` at build time, so a token that moves moves this page with it,
/// and a page that disagrees with the system becomes impossible rather than
/// merely unlikely.
///
/// **Names come from the catalog, values from the spec.** `TextStyleToken` has no
/// name, and two roles can hold identical values, so nothing here tries to
/// recover a name by matching on values — see `typeset_catalog.dart`.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Form,
        FormField,
        Icon,
        OverlayPortal,
        RadioGroup,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;

import '../docs/docs_facts.dart';
import '../docs/docs_layout.dart';
import '../docs/docs_section.dart';
import '../docs/docs_snippet.dart';
import 'catalog.dart';
import 'typeset_catalog.dart';

class TypesetDocsPage extends StatelessWidget {
  const TypesetDocsPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: docsTypesetRoute,
    intro: const DocsPageIntro(
      eyebrow: 'DOCS',
      title: 'Typeset',
      description:
          'Twenty-seven named roles across five faces. Choose the one that '
          'matches what you are writing, and the size, weight and leading '
          'follow from it.',
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Docs'),
      BreadcrumbEntry.page('Typeset'),
    ],
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Choosing a role', anchor: 'choosing'),
      DocsTocEntry(title: 'The five faces', anchor: 'faces'),
      DocsTocEntry(title: 'What a spec records', anchor: 'anatomy'),
      DocsTocEntry(title: 'Words', anchor: 'words'),
      DocsTocEntry(title: 'Labels and furniture', anchor: 'labels'),
      DocsTocEntry(title: 'Code and serials', anchor: 'code'),
      DocsTocEntry(title: 'Numerics', anchor: 'numerics'),
      DocsTocEntry(title: 'Accent', anchor: 'accent'),
      DocsTocEntry(title: 'Sizes that are not fixed', anchor: 'fluid'),
      DocsTocEntry(title: 'Component typography', anchor: 'component-type'),
    ],
    previous: const DocsPageLink(title: 'CLI', route: docsCliRoute),
    next: const DocsPageLink(title: 'Registry', route: docsRegistryRoute),
    onNavigate: onNavigate,
    child: const _TypesetArticle(),
  );
}

class _TypesetArticle extends StatelessWidget {
  const _TypesetArticle();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      key: const ValueKey<String>('typeset-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _choosing(theme),
        _faces(theme),
        _anatomy(theme),
        for (final TypesetGroup group in TypesetGroup.values)
          _groupSection(group),
        _fluid(theme),
        _componentType(theme),
      ],
    );
  }

  Widget _prose(String text, {TextStyleToken? spec}) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
    child: StyledText(text, spec ?? TextStyles.body),
  );

  Widget _choosing(ThemeTokens theme) => DocsSection(
    id: 'choosing',
    title: 'Choosing a role',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'A role is a statement about meaning, not about size. h4 and lead '
          'are the same size and are never interchangeable: one titles what '
          'follows, the other introduces it. Pick by what the text is doing, '
          'and let the scale decide how big it is.',
        ),
        SizedBox(height: space(4)),
        _prose(
          'Every role is used the same way. StyledText takes the string and the '
          'role, and nothing else is required:',
        ),
        SizedBox(height: space(4)),
        const DocsSnippet(
          language: 'dart',
          code:
              "StyledText('Section heading', TextStyles.h2)\n"
              "StyledText('1,510', TextStyles.numberLg)\n"
              "StyledText('Foundations', TextStyles.eyebrow)",
        ),
        SizedBox(height: space(4)),
        _prose(
          'The role carries family, size, leading, weight, tracking, casing, '
          'tabular figures, and the colour it sets on itself. A call site '
          'passes a colour only when the surface overrides it, and a size '
          'only for the roles whose size is not fixed.',
          spec: TextStyles.small,
        ),
      ],
    ),
  );

  Widget _faces(ThemeTokens theme) => DocsSection(
    id: 'faces',
    title: 'The five faces',
    description:
        'Three font files, five named roles in Fonts. sans and heading '
        'resolve to the same face deliberately: they are separate tokens so '
        'the two can diverge later without a rename.',
    child: DocsApiTable(
      title: 'Fonts',
      facts: <DocsApiFact>[
        DocsApiFact(
          name: 'Fonts.sans',
          type: Fonts.sans,
          description:
              'The word face. Every prose and heading role except display '
              'and accent.',
        ),
        DocsApiFact(
          name: 'Fonts.heading',
          type: Fonts.heading,
          description:
              'A separate token that resolves to the same face as sans '
              'today. display is the only role that uses it.',
        ),
        DocsApiFact(
          name: 'Fonts.mono',
          type: Fonts.mono,
          description:
              'Code, serials, and all six numeric steps. Tabular figures '
              'come from the numeric roles, not from the face.',
        ),
        DocsApiFact(
          name: 'Fonts.accent',
          type: Fonts.accent,
          description: 'The italic serif. One role uses it.',
        ),
        const DocsApiFact(
          name: 'Fonts.package',
          type: 'elattar_design_system',
          description:
              'Threaded into every TextStyle so the bundled faces resolve. '
              'The CLI rewrites it away when it installs the foundation into '
              'a project, because there the fonts are that project\'s own.',
        ),
      ],
    ),
  );

  Widget _anatomy(ThemeTokens theme) => DocsSection(
    id: 'anatomy',
    title: 'What a spec records',
    description:
        'TextStyleToken is a record of declared values, not a style. StyledText '
        'resolves it against the theme and the size in play.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsApiTable(
          title: 'TextStyleToken',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'family',
              type: 'String',
              description:
                  'The bare family name. The package prefix is added at '
                  'resolve time, so call sites never think about it.',
            ),
            DocsApiFact(
              name: 'size',
              type: 'double?',
              description:
                  'Fixed px, or null for the three roles whose size is '
                  'decided elsewhere — see Sizes that are not fixed.',
            ),
            DocsApiFact(
              name: 'height',
              type: 'double?',
              description:
                  'Leading as a unitless ratio, or null where the role '
                  'inherits it.',
            ),
            DocsApiFact(
              name: 'variations / weight',
              type: 'List<FontVariation>, FontWeight?',
              description:
                  'The exact wght axis value, plus the nearest static step '
                  'below it as a fallback. h2 asks for 650, which no '
                  'FontWeight names.',
            ),
            DocsApiFact(
              name: 'tracking',
              type: 'double?',
              description:
                  'Letter spacing in em. Converted to px against the '
                  'resolved size, which is what a browser does.',
            ),
            DocsApiFact(
              name: 'uppercase',
              type: 'bool',
              description:
                  'A flag. The foundation performs no string transform; '
                  'StyledText does, so the value you pass stays the value you '
                  'wrote.',
            ),
            DocsApiFact(
              name: 'tabular',
              type: 'bool',
              description:
                  'Tabular figures, so a column of numbers aligns on the '
                  'digit. True for all six numeric roles.',
            ),
            DocsApiFact(
              name: 'defaultColor',
              type: 'TextColorRole',
              description:
                  'The colour the role sets on itself. Five roles are muted; '
                  'every other role inherits from the surface it sits on.',
            ),
          ],
        ),
        SizedBox(height: space(5)),
        _prose(
          'StyledText resolves colour in the order a cascade would: an explicit '
          'color wins, then the role\'s own defaultColor, then whatever the '
          'surrounding DefaultTextStyle provides. Pass inline: true where the '
          'text is a chip inside a sentence rather than a line of its own — '
          'that drops the leading, which is what an inline box does.',
          spec: TextStyles.small,
        ),
      ],
    ),
  );

  Widget _groupSection(TypesetGroup group) => DocsSection(
    id: _anchorFor(group),
    title: group.title,
    description: group.description,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (final TypesetRole role in typesetRolesIn(group)) ...<Widget>[
          _RoleEntry(role: role),
          SizedBox(height: space(6)),
        ],
      ],
    ),
  );

  static String _anchorFor(TypesetGroup group) => switch (group) {
    TypesetGroup.words => 'words',
    TypesetGroup.labels => 'labels',
    TypesetGroup.code => 'code',
    TypesetGroup.numerics => 'numerics',
    TypesetGroup.accent => 'accent',
  };

  Widget _fluid(ThemeTokens theme) => DocsSection(
    id: 'fluid',
    title: 'Sizes that are not fixed',
    description:
        'Three roles carry no px size, for three different reasons. Each '
        'needs an explicit fontSize at the call site, and the foundation '
        'provides the value.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsSnippet(
          language: 'dart',
          code:
              "// Grows with the viewport, clamped at both ends.\n"
              "StyledText('Build the interface you mean.', TextStyles.display,\n"
              "    fontSize: Fluid.display(context))\n\n"
              "StyledText('Typeset', TextStyles.h1, fontSize: Fluid.h1(context))\n\n"
              "// Relative to whatever it sits inside.\n"
              "StyledText('mean', TextStyles.accent,\n"
              "    fontSize: TextStyles.accentSize(TextStyles.body.size!))",
        ),
        SizedBox(height: space(5)),
        _prose(
          'Fluid reads the viewport width from MediaQuery and applies the '
          'clamp, so a hero stays proportionate without a breakpoint. accent '
          'is different: it is a multiple of its context, which is why an '
          'accent word inside a fluid display rides that clamp for free. It '
          'inherits its leading for the same reason.',
        ),
      ],
    ),
  );

  Widget _componentType(ThemeTokens theme) => DocsSection(
    id: 'component-type',
    title: 'Component typography',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'A button label, a dialog title and a table header each have a type '
          'contract too, and none of them is on this page. They live in '
          'ComponentTextStyles, and the components that own them apply them '
          'themselves.',
        ),
        SizedBox(height: space(4)),
        _prose(
          'The split is deliberate. TextStyles is the vocabulary you compose a '
          'screen from; ComponentTextStyles is internal detail of components you '
          'do not restyle. If you find yourself reaching for a component '
          'role to set some text, the answer is almost always the component '
          'itself.',
        ),
        SizedBox(height: space(4)),
        const DocsSnippet(
          language: 'dart',
          code:
              "// Not this.\n"
              "StyledText('Continue', TextStyles.buttonLabel)\n\n"
              "// This.\n"
              "Button(onPressed: onPressed, child: const Text('Continue'))",
        ),
      ],
    ),
  );
}

/// One role: specimen, name, derived metadata, and what it is for.
///
/// The specimen comes first and at full size, because the question a reader
/// arrives with is "which of these looks like the thing I am about to write".
/// Prose about the role is only useful once they have seen it.
class _RoleEntry extends StatelessWidget {
  const _RoleEntry({required this.role});

  final TypesetRole role;

  @override
  Widget build(BuildContext context) {
    final bool wide = MediaQuery.sizeOf(context).width >= Breakpoints.md;

    final Widget specimen = _Specimen(role: role);
    final Widget metadata = _Metadata(role: role);

    return Column(
      key: ValueKey<String>('typeset-role-${role.name}'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Semantics(
          header: true,
          child: StyledText(
            'TextStyles.${role.name}',
            TextStyles.code,
            inline: true,
          ),
        ),
        SizedBox(height: space(3)),
        // A neutral card, not a code panel: a specimen is content being
        // shown, not source being quoted. `CardContent` supplies the
        // horizontal inset `Card` leaves to its children.
        Card(children: <Widget>[CardContent(child: specimen)]),
        SizedBox(height: space(3)),
        // Wide: metadata beside the usage sentence, each in its own column.
        // Narrow: stacked, metadata last. The metadata is a list of short
        // pairs rather than a table, so it stays readable at any width — a
        // nine-column table squeezed into 390px is why the reflow is a
        // restructure rather than a shrink.
        if (wide)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(flex: 3, child: _prose(role.usage)),
              SizedBox(width: space(6)),
              Expanded(flex: 2, child: metadata),
            ],
          )
        else ...<Widget>[
          _prose(role.usage),
          SizedBox(height: space(4)),
          metadata,
        ],
        SizedBox(height: space(3)),
        DocsSnippet(language: 'dart', code: _callSite(role)),
      ],
    );
  }

  Widget _prose(String text) => StyledText(text, TextStyles.body);

  /// The line a reader copies. Real, and pasteable as written.
  static String _callSite(TypesetRole role) {
    final String escaped = role.sample.replaceAll("'", r"\'");
    if (identical(role.spec, TextStyles.display)) {
      return "StyledText('$escaped', TextStyles.display,\n"
          '    fontSize: Fluid.display(context))';
    }
    if (identical(role.spec, TextStyles.h1)) {
      return "StyledText('$escaped', TextStyles.h1, fontSize: Fluid.h1(context))";
    }
    if (identical(role.spec, TextStyles.accent)) {
      return "StyledText('$escaped', TextStyles.accent,\n"
          '    fontSize: TextStyles.accentSize(TextStyles.body.size!))';
    }
    return "StyledText('$escaped', TextStyles.${role.name})";
  }
}

/// The role, rendered at its real size.
class _Specimen extends StatelessWidget {
  const _Specimen({required this.role});

  final TypesetRole role;

  @override
  Widget build(BuildContext context) =>
      StyledText(role.sample, role.spec, fontSize: _size(context, role));

  /// The three roles with no intrinsic size get theirs from the foundation.
  static double? _size(BuildContext context, TypesetRole role) {
    if (identical(role.spec, TextStyles.display)) return Fluid.display(context);
    if (identical(role.spec, TextStyles.h1)) return Fluid.h1(context);
    if (identical(role.spec, TextStyles.accent)) {
      return TextStyles.accentSize(TextStyles.body.size!);
    }
    return null;
  }
}

/// Everything measurable about a role, read out of its spec.
///
/// Nothing here is typed out by hand. That is the point: a metadata column
/// written in prose is a second source of truth, and this page's whole claim
/// is to be the first one.
class _Metadata extends StatelessWidget {
  const _Metadata({required this.role});

  final TypesetRole role;

  @override
  Widget build(BuildContext context) {
    final TextStyleToken spec = role.spec;

    final List<(String, String)> rows = <(String, String)>[
      ('Family', _familyName(spec.family)),
      ('Size', role.sizeRule ?? '${_number(spec.size)} px'),
      ('Leading', spec.height == null ? 'inherits' : _number(spec.height)),
      ('Weight', _weight(spec)),
      (
        'Tracking',
        spec.tracking == null ? 'none' : '${_number(spec.tracking)} em',
      ),
      ('Case', spec.uppercase ? 'uppercase' : 'as written'),
      ('Figures', spec.tabular ? 'tabular' : 'proportional'),
      ('Colour', _colour(spec.defaultColor)),
    ];

    return Semantics(
      label: 'Token values for TextStyles.${role.name}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (final (String label, String value) row in rows) ...<Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // From the spacing scale, not a new foundation token: one
                // page does not earn a width in `LayoutWidths`, and `space(18)`
                // clears the longest label at micro's tracking.
                SizedBox(
                  width: space(18),
                  child: StyledText(row.$1, TextStyles.eyebrowSmall),
                ),
                SizedBox(width: space(3)),
                Expanded(child: StyledText(row.$2, TextStyles.small)),
              ],
            ),
            SizedBox(height: space(2)),
          ],
        ],
      ),
    );
  }

  /// `InterLocal` is the file; "Inter" is what a person calls it.
  static String _familyName(String family) {
    if (family == Fonts.mono) return 'Geist Mono';
    if (family == Fonts.accent) return 'Redaction 35';
    return 'Inter';
  }

  /// The declared axis value where there is one, because that is the number
  /// the role actually asks for — h2's 650 is invisible in `FontWeight`.
  static String _weight(TextStyleToken spec) {
    if (spec.variations.isEmpty) return 'inherits';
    final double wght = spec.variations.first.value;
    final FontWeight? fallback = spec.weight;
    final String step = fallback == null
        ? ''
        : ' (w${fallback.value} fallback)';
    return '${_number(wght)}$step';
  }

  static String _colour(TextColorRole colour) => switch (colour) {
    TextColorRole.none => 'inherits',
    TextColorRole.foreground => 'foreground',
    TextColorRole.muted => 'muted foreground',
  };

  /// `15.0` is a value; `15` is a number a person reads.
  static String _number(double? value) {
    if (value == null) return '—';
    if (value == value.roundToDouble()) return value.toStringAsFixed(0);
    return value.toString();
  }
}
