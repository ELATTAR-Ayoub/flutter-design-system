/// A file selector paired with a single-file code pane.
///
/// `docs_code.dart`'s `_ManualPane` stacks every `DocsCodeFile` vertically —
/// fine for a component with one or two install files, wrong for a Shot with
/// a real file tree. This widget keeps exactly one file's source visible at a
/// time, behind a real selector: a rail beside the code pane on a wide
/// viewport, a chip strip above it on a narrow one.
///
/// Built on top of `docs_code.dart`'s public [DocsCodeFile] and
/// [DocsSelectableCodeBlock] — imported, never modified; that file's
/// copy/clipboard seam already carries its own failure-recovery tests.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../kit.dart';
import 'docs_code.dart';

/// Selectable file tree over a list of [DocsCodeFile]s, showing the selected
/// file's source in a [DocsSelectableCodeBlock].
///
/// Selection is internal state; the first file is selected on first build.
class DocsFileTree extends StatefulWidget {
  DocsFileTree({super.key, required this.files, this.label = 'Files'})
      : assert(files.isNotEmpty, 'DocsFileTree needs at least one file.');

  /// Files to list, in tree order.
  final List<DocsCodeFile> files;

  /// The panel strip label.
  final String label;

  @override
  State<DocsFileTree> createState() => _DocsFileTreeState();
}

class _DocsFileTreeState extends State<DocsFileTree> {
  int _selected = 0;

  @override
  void didUpdateWidget(DocsFileTree oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_selected >= widget.files.length) {
      _selected = 0;
    }
  }

  void _select(int index) {
    if (index == _selected) return;
    setState(() => _selected = index);
  }

  @override
  Widget build(BuildContext context) {
    final List<DocsCodeFile> files = widget.files;
    final DocsCodeFile selectedFile = files[_selected];
    final bool wide = MediaQuery.sizeOf(context).width >= DsBreakpoints.sm;

    final Widget list = _FileList(
      files: files,
      selectedIndex: _selected,
      axis: wide ? Axis.vertical : Axis.horizontal,
      onSelect: _select,
    );

    final Widget pane = _SelectedFilePane(file: selectedFile);

    final Widget body = wide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: DsWidths.rail, child: list),
              SizedBox(width: ds(5)),
              Expanded(child: pane),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              list,
              SizedBox(height: ds(4)),
              pane,
            ],
          );

    // No umbrella `Semantics(label: …)` here: with a single file it would
    // merge with the lone file entry's own label into one concatenated
    // string ("File list\nSelected file x.dart"), breaking exact-label
    // lookups. `DsPanel`'s own strip already renders the file count as plain
    // text, which is discoverable on its own.
    return DsPanel(
      label: widget.label,
      note: '${files.length} ${files.length == 1 ? 'file' : 'files'}',
      child: body,
    );
  }
}

/// The header restating which file the pane below is currently showing, plus
/// the code itself.
class _SelectedFilePane extends StatelessWidget {
  const _SelectedFilePane({required this.file});

  final DocsCodeFile file;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    // `liveRegion` with no label of its own: the header and code below are
    // the content that changes on selection, and they already carry their
    // own text. Giving this node a label too would concatenate with them.
    return Semantics(
      liveRegion: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DsText(
            file.title ?? file.path,
            DsType.label,
            color: theme.foreground,
          ),
          if (file.description != null) ...<Widget>[
            SizedBox(height: ds(1)),
            DsText(file.description!, DsType.small, color: theme.mutedForeground),
          ],
          SizedBox(height: ds(3)),
          DocsSelectableCodeBlock(
            key: ValueKey<String>('docs-file-tree-code:${file.path}'),
            code: file.code,
          ),
        ],
      ),
    );
  }
}

/// The selector itself — a column of full-width rows on [Axis.vertical], a
/// wrap of chips on [Axis.horizontal].
class _FileList extends StatelessWidget {
  const _FileList({
    required this.files,
    required this.selectedIndex,
    required this.axis,
    required this.onSelect,
  });

  final List<DocsCodeFile> files;
  final int selectedIndex;
  final Axis axis;
  final ValueChanged<int> onSelect;

  static String _name(String path) {
    final int slash = path.lastIndexOf('/');
    return slash < 0 ? path : path.substring(slash + 1);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> entries = <Widget>[
      for (int i = 0; i < files.length; i++)
        _FileEntry(
          name: _name(files[i].path),
          path: files[i].path,
          selected: i == selectedIndex,
          expanded: axis == Axis.vertical,
          onTap: () => onSelect(i),
        ),
    ];

    final Widget content = axis == Axis.vertical
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              for (int i = 0; i < entries.length; i++) ...<Widget>[
                if (i > 0) SizedBox(height: ds(1.5)),
                entries[i],
              ],
            ],
          )
        : Wrap(spacing: ds(2), runSpacing: ds(2), children: entries);

    // No umbrella label here either — same merge hazard as `DocsFileTree`'s
    // own container: a lone entry would have its accessible name swallowed
    // into "File list\nSelected file x.dart".
    return content;
  }
}

class _FileEntry extends StatelessWidget {
  const _FileEntry({
    required this.name,
    required this.path,
    required this.selected,
    required this.expanded,
    required this.onTap,
  });

  final String name;
  final String path;
  final bool selected;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Widget button = DsButton(
      key: ValueKey<String>('docs-file-tree-entry:$path'),
      variant: selected ? DsButtonVariant.secondary : DsButtonVariant.outline,
      size: DsButtonSize.sm,
      label: selected ? 'Selected file $name' : 'Select file $name',
      expanded: expanded,
      contentAlignment: expanded ? Alignment.centerLeft : null,
      onPressed: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DsIcon.lucide(DsLucide.fileCode, size: DsIconSize.sm),
          SizedBox(width: DsButton.gapFor(DsButtonSize.sm)),
          // Flexible, not a bare child: the rail's row width is fixed
          // (DsWidths.rail less the button's own padding) and a long Shot
          // file name must ellipsize rather than overflow the button.
          Flexible(
            child: DsText(
              name,
              DsComponentType.buttonLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

    return Semantics(selected: selected, child: button);
  }
}
