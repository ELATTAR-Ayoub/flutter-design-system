// example/lib/docs/docs_install.dart
/// The install block: the command, or the files it would have written.
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

import 'docs_code.dart' show DocsCodeFile;
import 'docs_snippet.dart';

class DocsInstall extends StatefulWidget {
  const DocsInstall({
    super.key,
    required this.command,
    required this.manualFiles,
  });

  /// The exact shell line. Derived from the registry item's own name by
  /// `ComponentDocEntry.command`, never retyped on the page.
  final String command;

  /// What an install would write, for a project not using the CLI.
  final List<DocsCodeFile> manualFiles;

  @override
  State<DocsInstall> createState() => _DocsInstallState();
}

class _DocsInstallState extends State<DocsInstall> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          // The same toggle the showcase uses. One toggle pattern per page.
          child: ToggleGroup(
            label: 'Installation method',
            items: const <ToggleGroupItem>[
              ToggleGroupItem(label: 'CLI'),
              ToggleGroupItem(label: 'Manual'),
            ],
            selectedIndex: _selected,
            onChanged: (int? index) =>
                setState(() => _selected = index ?? _selected),
          ),
        ),
        SizedBox(height: space(3)),
        if (_selected == 0)
          DocsSnippet(code: widget.command, language: 'bash')
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              for (final DocsCodeFile file in widget.manualFiles) ...<Widget>[
                // The heading the replaced page carried: a numbered step
                // when one is given, falling back to the bare path.
                StyledText(
                  file.title ?? file.path,
                  TextStyles.small,
                  color: theme.mutedForeground,
                ),
                // A title reads as a step, not a location, so the path still
                // needs to be on screen somewhere — it is where the file
                // goes.
                if (file.title != null) ...<Widget>[
                  SizedBox(height: space(1)),
                  StyledText(
                    file.path,
                    TextStyles.code,
                    color: theme.mutedForeground,
                  ),
                ],
                if (file.description != null) ...<Widget>[
                  SizedBox(height: space(1)),
                  StyledText(
                    file.description!,
                    TextStyles.small,
                    color: theme.mutedForeground,
                  ),
                ],
                SizedBox(height: space(2)),
                DocsSnippet(code: file.code),
                SizedBox(height: space(4)),
              ],
            ],
          ),
      ],
    );
  }
}
