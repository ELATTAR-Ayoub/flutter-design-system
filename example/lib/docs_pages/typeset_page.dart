/// Public documentation page for `/docs/typeset`.
///
/// The job is narrow and worth stating: a Flutter developer arrives knowing
/// what they are about to write — a section heading, a stat, a caveat — and
/// leaves with the right `TextStyles` role and a line they can paste. Everything
/// on the page serves that, and the page teaches no raw `TextStyle` value,
/// because a reader who copies a font size has taken the system apart.
///
/// Three rules hold the content together.
///
/// **The scale comes before the reference.** The whole catalog renders once,
/// in order, at real size, above the per-role blocks. Choosing between two
/// neighbours is a comparison, and a reader cannot make it from seventeen
/// separate cards.
///
/// **Every specimen is the real role.** Nothing here restates a size or a
/// weight in prose. The metadata beside each role is read out of its
/// `TextStyleToken` at build time, so a role that moves moves this page with
/// it, and a page that disagrees with the system becomes impossible rather
/// than merely unlikely.
///
/// **One ink for the whole preview.** No role owns a colour, so nothing on
/// this page uses colour to separate one role from another: the hierarchy a
/// reader sees is the hierarchy the scale actually provides.
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
import '../docs/docs_showcase.dart';
import '../docs/docs_snippet.dart';
import 'catalog.dart';
import 'typeset_catalog.dart';

class TypesetDocsPage extends StatelessWidget {
  const TypesetDocsPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: docsTypesetRoute,
    intro: DocsPageIntro(
      eyebrow: 'DOCS',
      title: 'Typeset',
      description:
          '${typesetRoles.length} named roles. Choose the one that matches '
          'what you are writing; size, weight and leading follow from it. '
          'The whole scale is rendered below.',
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Docs'),
      BreadcrumbEntry.page('Typeset'),
    ],
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Full type scale', anchor: 'scale'),
      DocsTocEntry(title: 'Choosing a role', anchor: 'choosing'),
      DocsTocEntry(title: 'Type shape, component ink', anchor: 'ink'),
      DocsTocEntry(title: 'The two faces', anchor: 'faces'),
      DocsTocEntry(title: 'What a role records', anchor: 'anatomy'),
      DocsTocEntry(title: 'Words', anchor: 'words'),
      DocsTocEntry(title: 'Code and identifiers', anchor: 'code'),
      DocsTocEntry(title: 'Numerics', anchor: 'numerics'),
      DocsTocEntry(title: 'Responsive steps', anchor: 'responsive'),
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
        _fullScale(),
        _choosing(theme),
        _ink(theme),
        _faces(theme),
        _anatomy(theme),
        for (final TypeGroup group in TypeGroup.values) _groupSection(group),
        _responsive(theme),
        _componentType(theme),
      ],
    );
  }

  Widget _prose(String text, {TextStyleToken? spec}) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
    child: StyledText(text, spec ?? TextStyles.body),
  );

  /// The whole scale, once, in catalog order: the comparison surface a
  /// reader needs before any single role's reference block is useful.
  ///
  /// One continuous vertical run inside one stage, not a card per role.
  /// Every line is [_Specimen], the same widget the reference blocks below
  /// use, so a size, weight, family or tracking cannot be written down here
  /// even by accident. Group titles are dividers, not headings: they help a
  /// reader find where the numerics start without breaking the run.
  Widget _fullScale() => DocsSection(
    id: 'scale',
    title: 'Full type scale',
    description:
        'Every role, once, in reading order, at its real size and in one ink. '
        'Read down it before you read about any single role: the choice '
        'between two neighbours is easier to see than to describe.',
    child: DocsShowcaseFrame(
      alignment: Alignment.topLeft,
      minHeight: space(96),
      child: Column(
        key: const ValueKey<String>('typeset-full-scale'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          for (int i = 0; i < typesetRoles.length; i++) ...<Widget>[
            if (i == 0 || typesetRoles[i].group != typesetRoles[i - 1].group)
              _ScaleDivider(group: typesetRoles[i].group, first: i == 0),
            _ScaleLine(role: typesetRoles[i]),
          ],
        ],
      ),
    ),
  );

  Widget _choosing(ThemeTokens theme) => DocsSection(
    id: 'choosing',
    title: 'Choosing a role',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'A role is a statement about meaning, not about size. h4 titles what '
          'follows it and lead introduces it; they are never interchangeable, '
          'whatever their sizes happen to be at the width you are looking at. '
          'Pick by what the text is doing, and let the scale decide how big '
          'it is.',
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
              "StyledText('Foundations', TextStyles.small)",
        ),
        SizedBox(height: space(4)),
        _prose(
          'The role carries family, size, line height, weight, tracking and '
          'numeric features, and resolves the size for the width it renders '
          'at. A call site passes a colour when the surface calls for one, and '
          'a size only for the rare anatomy that must match a container it '
          'shares.',
        ),
      ],
    ),
  );

  Widget _ink(ThemeTokens theme) => DocsSection(
    id: 'ink',
    title: 'Type shape, component ink',
    description:
        'Typography defines shape and rhythm. The component or the semantic '
        'surface defines the ink.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'No role sets a colour on itself. small is a size, not a grey; lead '
          'is a size, not a subtitle colour. Text inherits the foreground of '
          'the surface it sits on, and a call site that means "secondary" says '
          'so:',
        ),
        SizedBox(height: space(4)),
        const DocsSnippet(
          language: 'dart',
          code:
              "final ThemeTokens theme = ThemeScope.of(context);\n\n"
              "StyledText('Order total', TextStyles.small)\n"
              "StyledText('Includes tax', TextStyles.small,\n"
              "    color: theme.mutedForeground)",
        ),
        SizedBox(height: space(4)),
        _prose(
          'This is why the scale above renders in one ink. Colour is a second '
          'axis of meaning — muted, destructive, success, link — and using it '
          'to tell two type roles apart would teach the wrong lesson twice.',
        ),
      ],
    ),
  );

  Widget _faces(ThemeTokens theme) => DocsSection(
    id: 'faces',
    title: 'The two faces',
    description:
        'Two font files. Words are set in Inter; anything read character by '
        'character is set in Geist Mono.',
    child: DocsApiTable(
      title: 'Fonts',
      facts: <DocsApiFact>[
        DocsApiFact(
          name: 'Fonts.sans',
          type: Fonts.sans,
          description:
              'The word face: every heading, every reading role, and the '
              'interface words.',
        ),
        DocsApiFact(
          name: 'Fonts.mono',
          type: Fonts.mono,
          description:
              'Code, identifiers, and all five numeric roles — the text whose '
              'characters must line up column to column. Tabular figures come '
              'from the numeric roles, not from the face.',
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
    title: 'What a role records',
    description:
        'TextStyleToken is a record of declared values, not a style. StyledText '
        'resolves it against the width in scope and the ink in play.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsApiTable(
          title: 'TextStyleToken',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'name / group',
              type: 'String, TypeGroup',
              description:
                  'The published name and the catalog group. This page reads '
                  'both rather than restating them.',
            ),
            DocsApiFact(
              name: 'family',
              type: 'String',
              description:
                  'The bare family name. The package prefix is added at '
                  'resolve time, so call sites never think about it.',
            ),
            DocsApiFact(
              name: 'mobile / tablet / desktop',
              type: 'TypeStep',
              description:
                  'A size and a line height, both in logical pixels, for each '
                  'band. A role that reads the same at every width holds the '
                  'same step three times.',
            ),
            DocsApiFact(
              name: 'wght / weight',
              type: 'double, FontWeight',
              description:
                  'The exact wght axis value, plus the nearest static step '
                  'below it as a fallback. h2 asks for 650, which no '
                  'FontWeight names.',
            ),
            DocsApiFact(
              name: 'tracking',
              type: 'double?',
              description:
                  'Letter spacing in em, converted to logical pixels against '
                  'the resolved size so it stays proportionate at every step.',
            ),
            DocsApiFact(
              name: 'tabular',
              type: 'bool',
              description:
                  'Tabular figures, so a column of numbers aligns on the '
                  'digit. True for all five numeric roles.',
            ),
            DocsApiFact(
              name: 'derive(...)',
              type: 'TextStyleToken',
              description:
                  'A component-internal variation — a button label at medium '
                  'weight, a cell with tabular figures. It keeps the role\'s '
                  'steps and publishes nothing new.',
            ),
          ],
        ),
        SizedBox(height: space(5)),
        _prose(
          'Pass inline: true where the text is a chip inside a sentence rather '
          'than a line of its own. That drops the line height, which is what '
          'an inline box does: the sentence around it keeps owning the line.',
          spec: TextStyles.small,
        ),
      ],
    ),
  );

  Widget _groupSection(TypeGroup group) => DocsSection(
    id: _anchorFor(group),
    title: group.label,
    description: _descriptionFor(group),
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

  static String _anchorFor(TypeGroup group) => switch (group) {
    TypeGroup.words => 'words',
    TypeGroup.code => 'code',
    TypeGroup.numerics => 'numerics',
  };

  static String _descriptionFor(TypeGroup group) => switch (group) {
    TypeGroup.words =>
      'Headings, reading copy, and the interface words a person taps. Ten '
          'roles, six of which step up as the window widens.',
    TypeGroup.code =>
      'Monospace. Code that is skimmed, and identifiers that are compared '
          'character by character.',
    TypeGroup.numerics =>
      'Five steps of tabular monospace, so a column of figures aligns on the '
          'digit rather than on the glyph. All five share face, weight and '
          'tabular figures; the three largest step with the window.',
  };

  Widget _responsive(ThemeTokens theme) => DocsSection(
    id: 'responsive',
    title: 'Responsive steps',
    description:
        'Headings and the large metrics step up at 768 and again at 1024. '
        'Reading and interface text does not move.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _prose(
          'A role resolves its own size, so a call site never does viewport '
          'arithmetic. display is 44px on a phone, 52 on a tablet and 64 on a '
          'desktop, and the line that renders it is the same line at all '
          'three widths.',
        ),
        SizedBox(height: space(4)),
        const DocsSnippet(
          language: 'dart',
          code:
              "// Resolves against the viewport.\n"
              "StyledText('Build the interface you mean.', TextStyles.display)\n\n"
              "// Resolves against a region instead, for a heading inside a\n"
              "// narrow panel on a wide window.\n"
              "TypeWidthScope(\n"
              "  width: constraints.maxWidth,\n"
              "  child: StyledText('Filters', TextStyles.h3),\n"
              ")",
        ),
        SizedBox(height: space(5)),
        _prose(
          'Width steps are a layout decision and never a substitute for '
          'accessibility. Flutter\'s text scaler applies on top of whichever '
          'step is resolved, and every component in the system is built to '
          'grow with text at 200% rather than clip it.',
          spec: TextStyles.small,
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
          'contract too, and none of them is a role on this page. Each is '
          'derived from the role closest to its meaning by the component that '
          'owns it — a Button label is TextStyles.body at medium weight — so '
          'the catalog stays seventeen entries long however much anatomy the '
          'system grows.',
        ),
        SizedBox(height: space(4)),
        _prose(
          'If you find yourself wanting a component\'s internal type to set '
          'some text, the answer is almost always the component itself.',
        ),
        SizedBox(height: space(4)),
        const DocsSnippet(
          language: 'dart',
          code:
              "// Not this.\n"
              "StyledText('Continue', TextStyles.nav)\n\n"
              "// This.\n"
              "Button(onPressed: onPressed, child: const Text('Continue'))",
        ),
      ],
    ),
  );
}

/// The rule and title that mark where one reading group ends and the next
/// begins, inside the continuous scale.
class _ScaleDivider extends StatelessWidget {
  const _ScaleDivider({required this.group, required this.first});

  final TypeGroup group;

  /// The first group opens the stage, so it takes the title without the rule
  /// above it.
  final bool first;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(top: first ? 0 : space(4), bottom: space(5)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (!first) ...<Widget>[const Separator(), SizedBox(height: space(4))],
        StyledText(group.label, TextStyles.small),
      ],
    ),
  );
}

/// One line of the scale: the role's name, small and quiet, above the role
/// rendered at its own size.
///
/// The name is a scanning cue, not a heading. The reference blocks below own
/// the heading semantics, and repeating them here would give a screen-reader
/// user seventeen duplicate landmarks to walk past.
class _ScaleLine extends StatelessWidget {
  const _ScaleLine({required this.role});

  final TypesetRole role;

  @override
  Widget build(BuildContext context) => Padding(
    key: ValueKey<String>('typeset-preview-${role.name}'),
    padding: EdgeInsets.only(bottom: space(6)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        StyledText('TextStyles.${role.name}', TextStyles.small),
        SizedBox(height: space(2)),
        _Specimen(role: role),
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
        // table squeezed into 390px is why the reflow is a restructure rather
        // than a shrink.
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
    return "StyledText('$escaped', TextStyles.${role.name})";
  }
}

/// The role, rendered at its real size for the width it is in.
class _Specimen extends StatelessWidget {
  const _Specimen({required this.role});

  final TypesetRole role;

  @override
  Widget build(BuildContext context) => StyledText(role.sample, role.spec);
}

/// Everything measurable about a role, read out of the role itself.
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
    final TypeStep here = StyledText.stepOf(context, spec);

    final List<(String, String)> rows = <(String, String)>[
      ('Family', _familyName(spec.family)),
      ('Here', _step(here)),
      ('Mobile', _step(spec.mobile)),
      ('Tablet', _step(spec.tablet)),
      ('Desktop', _step(spec.desktop)),
      ('Weight', _weight(spec)),
      (
        'Tracking',
        spec.tracking == null ? 'none' : '${_number(spec.tracking)} em',
      ),
      ('Figures', spec.tabular ? 'tabular' : 'proportional'),
      ('Ink', 'inherits'),
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
                // page does not earn a width in `LayoutWidths`.
                SizedBox(
                  width: space(18),
                  child: StyledText(row.$1, TextStyles.small),
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

  /// Size over line height, both in logical pixels — the way the contract
  /// table states them.
  static String _step(TypeStep step) =>
      '${_number(step.size)} / ${_number(step.leading)}';

  /// `InterLocal` is the file; "Inter" is what a person calls it.
  static String _familyName(String family) =>
      family == Fonts.mono ? 'Geist Mono' : 'Inter';

  /// The declared axis value, because that is the number the role actually
  /// asks for — h2's 650 is invisible in `FontWeight`.
  static String _weight(TextStyleToken spec) {
    final String step = ' (w${spec.weight.value} fallback)';
    return '${_number(spec.wght)}$step';
  }

  /// `16.0` is a value; `16` is a number a person reads.
  static String _number(double? value) {
    if (value == null) return '—';
    if (value == value.roundToDouble()) return value.toStringAsFixed(0);
    return value.toString();
  }
}
