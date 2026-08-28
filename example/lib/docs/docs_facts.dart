/// Reusable fact compositions for component and CLI documentation.
///
/// The facts are intentionally data-first: pages can reuse the same API rows,
/// state descriptions and install destinations without copying prose between
/// component pages.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/material.dart'
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
        TableColumnWidth,
        ActionChip,
        AlertDialog,
        Badge,
        Card,
        CarouselController,
        Checkbox,
        Dialog,
        DropdownMenu,
        Drawer,
        DrawerHeader,
        Slider,
        Switch,
        TextFormField,
        Tooltip;

import 'docs_table.dart' show DocsTable, DocsTableColumn;

class DocsApiFact {
  const DocsApiFact({
    required this.name,
    required this.type,
    required this.description,
  });

  final String name;
  final String type;
  final String description;
}

class DocsStateFact {
  const DocsStateFact({
    required this.state,
    required this.treatment,
    required this.userSignal,
  });

  final String state;
  final String treatment;
  final String userSignal;
}

class DocsInstallFact {
  const DocsInstallFact({
    required this.label,
    required this.value,
    required this.description,
  });

  final String label;
  final String value;
  final String description;
}

/// [DocsTable] configured for an API reference, in the same titled panel
/// chrome ([_DocsFactPanel]) as [DocsStateMatrix] and [DocsInstallFacts].
///
/// The panel is what 64 existing component pages call this for — some
/// passing [title] — so it stays; only the rows underneath moved onto
/// `Table` (see `docs_table.dart`).
class DocsApiTable extends StatelessWidget {
  const DocsApiTable({super.key, required this.facts, this.title = 'API'});

  final List<DocsApiFact> facts;
  final String title;

  @override
  Widget build(BuildContext context) => _DocsFactPanel(
    title: title,
    child: DocsTable(
      columns: const <DocsTableColumn>[
        DocsTableColumn(header: 'Property', flex: 0.25),
        DocsTableColumn(header: 'Type', flex: 0.3),
        DocsTableColumn(header: 'Purpose', flex: 0.45),
      ],
      rows: <List<String>>[
        for (final DocsApiFact fact in facts)
          <String>[fact.name, fact.type, fact.description],
      ],
    ),
  );
}

class DocsStateMatrix extends StatelessWidget {
  const DocsStateMatrix({
    super.key,
    required this.facts,
    this.title = 'State matrix',
  });

  final List<DocsStateFact> facts;
  final String title;

  @override
  Widget build(BuildContext context) => _DocsFactPanel(
    title: title,
    child: _FactScroll(
      minWidth: space(132),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const _TableHeader(
            cells: <String>['State', 'Treatment', 'User signal'],
          ),
          for (final DocsStateFact fact in facts)
            _FactRow(
              cells: <String>[fact.state, fact.treatment, fact.userSignal],
            ),
        ],
      ),
    ),
  );
}

class DocsInstallFacts extends StatelessWidget {
  const DocsInstallFacts({
    super.key,
    required this.facts,
    this.title = 'Install facts',
  });

  final List<DocsInstallFact> facts;
  final String title;

  @override
  Widget build(BuildContext context) => _DocsFactPanel(
    title: title,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (final DocsInstallFact fact in facts)
          Padding(
            padding: EdgeInsets.only(bottom: space(4)),
            child: _InstallRow(fact: fact),
          ),
      ],
    ),
  );
}

class _DocsFactPanel extends StatelessWidget {
  const _DocsFactPanel({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Semantics(
      container: true,
      label: title,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.card,
          borderRadius: BorderRadius.circular(Radii.xl),
          border: Border.all(color: theme.border, width: BorderWidths.hairline),
        ),
        child: Padding(
          padding: EdgeInsets.all(space(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              StyledText(title, TextStyles.h4, color: theme.foreground),
              SizedBox(height: space(4)),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _FactScroll extends StatelessWidget {
  const _FactScroll({required this.minWidth, required this.child});

  final double minWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: minWidth),
      child: child,
    ),
  );
}

class _TableHeader extends StatelessWidget {
  const _TableHeader({required this.cells});

  final List<String> cells;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Container(
      padding: EdgeInsets.only(bottom: space(2)),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.border, width: BorderWidths.hairline),
        ),
      ),
      child: Row(
        children: <Widget>[
          for (final String cell in cells)
            SizedBox(
              width: space(44),
              child: StyledText(
                cell,
                TextStyles.section,
                color: theme.mutedForeground,
              ),
            ),
        ],
      ),
    );
  }
}

class _FactRow extends StatelessWidget {
  const _FactRow({required this.cells});

  final List<String> cells;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Semantics(
      container: true,
      label: cells.join(', '),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: space(3)),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.border,
              width: BorderWidths.hairline,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (int index = 0; index < cells.length; index++)
              SizedBox(
                width: space(44),
                child: Padding(
                  padding: EdgeInsets.only(right: space(3)),
                  child: _SelectableFactText(
                    text: cells[index],
                    spec: index == 0 ? TextStyles.body : TextStyles.small,
                    color: index == 0
                        ? theme.foreground
                        : theme.mutedForeground,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _InstallRow extends StatelessWidget {
  const _InstallRow({required this.fact});

  final DocsInstallFact fact;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Semantics(
      container: true,
      label: '${fact.label}: ${fact.value}. ${fact.description}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          StyledText(fact.label, TextStyles.section, color: theme.actionText),
          SizedBox(height: space(1)),
          _SelectableFactText(
            text: fact.value,
            spec: TextStyles.code,
            color: theme.foreground,
          ),
          SizedBox(height: space(1)),
          StyledText(fact.description, TextStyles.small),
        ],
      ),
    );
  }
}

class _SelectableFactText extends StatelessWidget {
  const _SelectableFactText({
    required this.text,
    required this.spec,
    required this.color,
  });

  final String text;
  final TextStyleToken spec;
  final Color color;

  @override
  Widget build(BuildContext context) => SelectableText(
    text,
    style: StyledText.styleOf(context, spec, color: color),
  );
}
