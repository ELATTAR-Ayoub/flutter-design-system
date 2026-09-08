// example/lib/site/pages/charts_gallery_page.dart
/// `/charts`: every chart this system draws, as cards a reader can copy.
///
/// The split this page exists for is the reference's own: a gallery answers
/// "give me this chart", the component pages under `/components/chart*`
/// answer "how does the engine work". Neither page does both well, which is
/// why four API pages used to be the only charts a reader could find.
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

import '../../charts/chart_card.dart';
import '../../charts/chart_ink.dart';
import '../../charts/chart_specimen.dart';
import '../../charts/specimens_area.dart';
import '../../charts/specimens_bar.dart';
import '../../charts/specimens_line.dart';
import '../../charts/specimens_pie.dart';
import '../../charts/specimens_radar.dart';
import '../../charts/specimens_radial.dart';
import '../../charts/specimens_tooltip.dart';
import '../../components_docs/catalog.dart';
import '../../docs/docs_copy_button.dart';
import '../../kit.dart';

/// One tab: its label and the specimens under it.
class _Family {
  const _Family(this.label, this.specimens);

  final String label;
  final List<ChartSpecimen> specimens;
}

const List<_Family> _families = <_Family>[
  _Family('Area', areaSpecimens),
  _Family('Bar', barSpecimens),
  _Family('Line', lineSpecimens),
  _Family('Pie', pieSpecimens),
  _Family('Radar', radarSpecimens),
  _Family('Radial', radialSpecimens),
  _Family('Tooltips', tooltipSpecimens),
];

/// The four `/components/chart*` pages, read out of the catalog rather than
/// retyped: their titles and descriptions are this page's foot reference.
const List<String> _componentDocNames = <String>[
  'chart',
  'chart_cartesian',
  'chart_geometry',
  'chart_polar',
];

class ChartsGalleryPage extends StatefulWidget {
  const ChartsGalleryPage({super.key, this.onNavigate, this.clipboardWriter});

  /// The site shell's navigator, passed by `main.dart`'s builder map.
  final void Function(String route)? onNavigate;

  /// Injected by tests so a copy can be observed without a platform channel.
  final DocsClipboardWriter? clipboardWriter;

  @override
  State<ChartsGalleryPage> createState() => _ChartsGalleryPageState();
}

class _ChartsGalleryPageState extends State<ChartsGalleryPage> {
  int _family = 0;

  /// The anchor `Browse Charts` scrolls to.
  final GlobalKey _tabsKey = GlobalKey();

  Future<void> _browse() async {
    final BuildContext? anchor = _tabsKey.currentContext;
    if (anchor == null) return;
    await Scrollable.ensureVisible(
      anchor,
      duration: MotionDurations.normal,
      curve: MotionCurves.enter,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final ChartInk ink = ChartInk(theme);
    final _Family family = _families[_family];

    final List<ChartSpecimen> wide = family.specimens
        .where((ChartSpecimen s) => s.fullWidth)
        .toList();
    final List<ChartSpecimen> rest = family.specimens
        .where((ChartSpecimen s) => !s.fullWidth)
        .toList();

    Widget card(ChartSpecimen specimen) => ChartSpecimenCard(
      specimen: specimen,
      ink: ink,
      writer: widget.clipboardWriter,
    );

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: space(6),
          vertical: space(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _Hero(onBrowse: _browse, onNavigate: widget.onNavigate),
            SizedBox(height: space(10)),
            KeyedSubtree(
              key: _tabsKey,
              child: Tabs(
                items: <TabItem>[
                  for (final _Family f in _families) TabItem(label: f.label),
                ],
                selectedIndex: _family,
                onChanged: (int next) => setState(() => _family = next),
              ),
            ),
            SizedBox(height: space(6)),
            for (final ChartSpecimen specimen in wide) ...<Widget>[
              card(specimen),
              SizedBox(height: space(6)),
            ],
            Grid(
              base: 1,
              md: 2,
              xl: 3,
              gap: space(6),
              matchHeights: false,
              children: <Widget>[for (final ChartSpecimen s in rest) card(s)],
            ),
            SizedBox(height: space(14)),
            _ComponentReference(onNavigate: widget.onNavigate),
          ],
        ),
      ),
    );
  }
}

/* ── Hero ─────────────────────────────────────────────────────────────────── */

class _Hero extends StatelessWidget {
  const _Hero({required this.onBrowse, required this.onNavigate});

  final VoidCallback onBrowse;
  final void Function(String route)? onNavigate;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        StyledText('Charts', TextStyles.h1, color: theme.foreground),
        SizedBox(height: space(4)),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Containers.xl2),
          child: StyledText(
            'Seventy charts across seven families, each one the exact source '
            'this system draws — copy it, or open the component pages to see '
            'how the engine underneath it works.',
            TextStyles.body,
            color: theme.mutedForeground,
          ),
        ),
        SizedBox(height: space(7)),
        Wrap(
          spacing: space(3),
          runSpacing: space(3),
          children: <Widget>[
            Button(
              onPressed: onBrowse,
              child: const Text('Browse Charts'),
            ),
            Button(
              variant: ButtonVariant.secondary,
              onPressed: onNavigate == null
                  ? null
                  : () => onNavigate!('/components/chart'),
              child: const Text('Documentation'),
            ),
          ],
        ),
      ],
    );
  }
}

/* ── Component reference ─────────────────────────────────────────────────── */

class _ComponentReference extends StatelessWidget {
  const _ComponentReference({required this.onNavigate});

  final void Function(String route)? onNavigate;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final List<ComponentDocEntry> entries = <ComponentDocEntry>[
      for (final String name in _componentDocNames) componentDoc(name),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CapsLabel('Component reference', color: theme.mutedForeground),
        SizedBox(height: space(4)),
        DividedList(
          children: <Widget>[
            for (final ComponentDocEntry entry in entries)
              _ComponentReferenceRow(entry: entry, onNavigate: onNavigate),
          ],
        ),
      ],
    );
  }
}

class _ComponentReferenceRow extends StatelessWidget {
  const _ComponentReferenceRow({required this.entry, required this.onNavigate});

  final ComponentDocEntry entry;
  final void Function(String route)? onNavigate;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Press(
      onTap: onNavigate == null ? null : () => onNavigate!(entry.route),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: space(4), vertical: space(4)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  StyledText(entry.title, TextStyles.h4, color: theme.foreground),
                  SizedBox(height: space(1)),
                  StyledText(
                    entry.description,
                    TextStyles.small,
                    color: theme.mutedForeground,
                  ),
                ],
              ),
            ),
            SizedBox(width: space(4)),
            Icon.lucide(Lucide.chevronRight, size: IconSize.sm),
          ],
        ),
      ),
    );
  }
}
