// example/lib/docs/docs_install.dart
/// The install block: the command, or the files it would have written.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

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
    final ElThemeData theme = ElTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          // The same toggle the showcase uses. One toggle pattern per page.
          child: ElToggleGroup(
            label: 'Installation method',
            items: const <ElToggleGroupItem>[
              ElToggleGroupItem(label: 'CLI'),
              ElToggleGroupItem(label: 'Manual'),
            ],
            selectedIndex: _selected,
            onChanged: (int? index) =>
                setState(() => _selected = index ?? _selected),
          ),
        ),
        SizedBox(height: el(3)),
        if (_selected == 0)
          DocsSnippet(code: widget.command, language: 'bash')
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              for (final DocsCodeFile file in widget.manualFiles) ...<Widget>[
                ElText(file.path, ElType.small, color: theme.mutedForeground),
                SizedBox(height: el(2)),
                DocsSnippet(code: file.code),
                SizedBox(height: el(4)),
              ],
            ],
          ),
      ],
    );
  }
}
