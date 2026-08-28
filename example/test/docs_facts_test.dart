import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/docs/docs_facts.dart';
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
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) => ThemeScope(
  controller: ThemeController(mode: ColorMode.dark),
  child: MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SingleChildScrollView(child: child),
  ),
);

void main() {
  testWidgets('API table keeps long facts selectable and horizontally usable', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _harness(
        const DocsApiTable(
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'contentAlignment',
              type: 'AlignmentGeometry?',
              description:
                  'A deliberately long explanation remains available to keyboard and pointer readers without being clipped.',
            ),
          ],
        ),
      ),
    );

    expect(find.text('contentAlignment'), findsOneWidget);
    expect(find.byType(SelectableText), findsNWidgets(3));
    expect(find.byType(SingleChildScrollView), findsNWidgets(2));
  });

  testWidgets('state matrix and install facts render at phone width', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _harness(
        Column(
          children: <Widget>[
            const DocsStateMatrix(
              facts: <DocsStateFact>[
                DocsStateFact(
                  state: 'Error',
                  treatment: 'Explain the recovery path.',
                  userSignal: 'Specific message and retry action.',
                ),
              ],
            ),
            const DocsInstallFacts(
              facts: <DocsInstallFact>[
                DocsInstallFact(
                  label: 'Component destination',
                  value: 'lib/components/ui/',
                  description:
                      'Copied components remain local to the consumer.',
                ),
              ],
            ),
          ],
        ),
      ),
    );

    expect(find.text('State matrix'), findsOneWidget);
    expect(find.text('Install facts'), findsOneWidget);
    expect(find.text('lib/components/ui/'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
