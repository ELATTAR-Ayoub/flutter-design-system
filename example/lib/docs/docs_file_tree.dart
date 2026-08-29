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
/// copy/clipboard seam already carries its own failure-recovery tests. The
/// copy affordance below reuses the same public [DocsClipboardWriter] seam —
/// `docs_code.dart`'s own copy header (`_DocsCodeHeader`) is private to that
/// library, so an equivalent is composed here from public `El*` parts instead
/// of duplicating its file.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/services.dart';
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

import '../kit.dart';
import 'docs_code.dart';

Future<void> _systemClipboardWrite(String text) =>
    Clipboard.setData(ClipboardData(text: text));

/// Selectable file tree over a list of [DocsCodeFile]s, showing the selected
/// file's source in a [DocsSelectableCodeBlock].
///
/// Selection is internal state; the first file is selected on first build.
///
/// Callers that swap in a wholly different logical file list for the same
/// tree slot (e.g. a documentation page that renders one [DocsFileTree] per
/// catalog entry and swaps entries in place) should give each instance a
/// distinct [key] — otherwise the framework reuses this widget's [State]
/// across the swap and the newly-selected index carries over from whichever
/// file was selected before.
class DocsFileTree extends StatefulWidget {
  const DocsFileTree({
    super.key,
    required this.files,
    this.label = 'Files',
    this.clipboardWriter = _systemClipboardWrite,
  });

  /// Files to list, in tree order. May be empty — an empty list renders a
  /// placeholder panel rather than indexing into nothing.
  final List<DocsCodeFile> files;

  /// The panel strip label.
  final String label;

  /// Writes the selected file's source to the clipboard when its copy
  /// control is pressed.
  final DocsClipboardWriter clipboardWriter;

  @override
  State<DocsFileTree> createState() => _DocsFileTreeState();
}

class _DocsFileTreeState extends State<DocsFileTree> {
  int _selected = 0;

  @override
  void didUpdateWidget(DocsFileTree oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Guards a shrinking list under the *same* widget identity (e.g. a
    // caller mutating its own `files` in place). Cross-entry reuse — a
    // wholly different logical file list landing in this same tree slot —
    // is the widget identity problem documented on [DocsFileTree] itself and
    // is a caller's [key] concern, not this bounds check's.
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

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (files.isEmpty) {
          return Panel(
            key: const ValueKey<String>('docs-file-tree-empty'),
            label: widget.label,
            note: '0 files',
            child: StyledText(
              'No files to show.',
              TextStyles.small,
              color: ThemeScope.of(context).mutedForeground,
            ),
          );
        }

        // `_selected` is kept in range by `didUpdateWidget` above — indexing
        // directly here (rather than re-clamping) is deliberate: it is what
        // makes a shrinking `files` list without that override a genuine,
        // catchable `RangeError` instead of a silently-absorbed one.
        final DocsCodeFile selectedFile = files[_selected];

        // The primitive's own available width, not the window's — so it
        // reflows correctly nested inside a narrower column on an otherwise
        // wide viewport instead of forcing the wide row's fixed rail width.
        final bool wide = constraints.maxWidth >= Breakpoints.sm;

        final Widget list = _FileList(
          files: files,
          selectedIndex: _selected,
          axis: wide ? Axis.vertical : Axis.horizontal,
          onSelect: _select,
        );

        final Widget pane = _SelectedFilePane(
          file: selectedFile,
          clipboardWriter: widget.clipboardWriter,
        );

        final Widget body = wide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: LayoutWidths.rail, child: list),
                  SizedBox(width: space(5)),
                  Expanded(child: pane),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  list,
                  SizedBox(height: space(4)),
                  pane,
                ],
              );

        // No umbrella `Semantics(label: …)` here: with a single file it
        // would merge with the lone file entry's own label into one
        // concatenated string ("File list\nSelected file x.dart"), breaking
        // exact-label lookups. `Panel`'s own strip already renders the
        // file count as plain text, which is discoverable on its own.
        return Panel(
          label: widget.label,
          note: '${files.length} ${files.length == 1 ? 'file' : 'files'}',
          child: body,
        );
      },
    );
  }
}

/// The header restating which file the pane below is currently showing, a
/// copy control for its source, and the code itself.
class _SelectedFilePane extends StatelessWidget {
  const _SelectedFilePane({required this.file, required this.clipboardWriter});

  final DocsCodeFile file;
  final DocsClipboardWriter clipboardWriter;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    // `liveRegion` with no label of its own: the header and code below are
    // the content that changes on selection, and they already carry their
    // own text. Giving this node a label too would concatenate with them.
    return Semantics(
      liveRegion: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: space(3),
            spacing: space(3),
            children: <Widget>[
              // `container: true`: this plain text has no boundary of its
              // own, and its only sibling here — the copy button — does.
              // Without one, neither of them is a container either, so the
              // title text has nowhere of its own to land and merges into
              // the button's node instead, producing a label like
              // "LIB/COMPONENTS/UI/A.DART\nCopy lib/components/ui/a.dart".
              Semantics(
                container: true,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: LayoutWidths.prose,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      StyledText(
                        file.title ?? file.path,
                        TextStyles.section,
                        color: theme.foreground,
                      ),
                      if (file.description != null) ...<Widget>[
                        SizedBox(height: space(1)),
                        StyledText(
                          file.description!,
                          TextStyles.small,
                          color: theme.mutedForeground,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              // `container: true` again, for the same reason as the title
              // block above: this pane's outer `Semantics(liveRegion: true)`
              // has no boundary of its own, and without one here the button
              // doesn't just lose its label to a neighbour — it loses its
              // own *geometry* too, inheriting the whole pane's bounding
              // rect instead of its own small tap target, so a tap on it
              // lands on whatever the pane's centre happens to be instead.
              Semantics(
                container: true,
                child: _CopyFileButton(
                  key: ValueKey<String>('docs-file-tree-copy:${file.path}'),
                  file: file,
                  clipboardWriter: clipboardWriter,
                ),
              ),
            ],
          ),
          SizedBox(height: space(3)),
          DocsSelectableCodeBlock(
            key: ValueKey<String>('docs-file-tree-code:${file.path}'),
            code: file.code,
            // A whole source file, not a command: capped, so its horizontal
            // scrollbar sits on the bottom edge of the visible pane instead of
            // hundreds of pixels below the fold. See the field's own note for
            // what an uncapped listing did to the Files viewer.
            maxHeight: DocsSelectableCodeBlock.sourceMaxHeight,
          ),
        ],
      ),
    );
  }
}

/// Copies [file]'s source to the clipboard — the same affordance
/// `docs_code.dart`'s `_ManualFileCard` pairs with every install file, kept
/// here as its own small state machine since that file's header is private.
class _CopyFileButton extends StatefulWidget {
  const _CopyFileButton({
    super.key,
    required this.file,
    required this.clipboardWriter,
  });

  final DocsCodeFile file;
  final DocsClipboardWriter clipboardWriter;

  @override
  State<_CopyFileButton> createState() => _CopyFileButtonState();
}

class _CopyFileButtonState extends State<_CopyFileButton>
    with SingleTickerProviderStateMixin {
  bool _pending = false;

  /// Holds the "Copied" state on screen after a successful write.
  ///
  /// An [AnimationController] rather than a [Future.delayed], for two reasons
  /// that are the same reason: it is driven by the scheduler, so it is torn
  /// down with the widget and it advances under a widget test's own clock —
  /// a bare timer would outlive a disposed tree and fail the test that copied.
  ///
  /// Built in [initState], not lazily: a `late final` initialiser that nothing
  /// ever touched would first run inside [dispose], where creating a [Ticker]
  /// means an inherited-widget lookup on a deactivated element.
  ///
  /// [MotionDurations.attachmentSaving] is the token, not a number of its own:
  /// it is already this system's answer to "how long does a control's glyph
  /// stay on the check after the action it confirms".
  late final AnimationController _confirmation;

  bool get _copied => _confirmation.isAnimating;

  @override
  void initState() {
    super.initState();
    _confirmation =
        AnimationController(
          vsync: this,
          duration: MotionDurations.attachmentSaving,
        )..addStatusListener((AnimationStatus status) {
          if (status == AnimationStatus.completed && mounted) setState(() {});
        });
  }

  @override
  void dispose() {
    _confirmation.dispose();
    super.dispose();
  }

  Future<void> _copy() async {
    if (_pending) return;
    setState(() => _pending = true);
    try {
      await widget.clipboardWriter(widget.file.code);
      if (mounted) _confirmation.forward(from: 0);
    } finally {
      if (mounted) setState(() => _pending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // A press state alone said nothing: the button dipped and came back, and
    // the reader had no way to tell a copy from a mis-tap. The label and the
    // glyph both change, so the confirmation survives a colour-blind reader
    // and a screen reader alike — `label` is what the latter announces.
    final (String text, LucideGlyph glyph) = switch ((_pending, _copied)) {
      (true, _) => ('Copying', Lucide.loaderCircle),
      (_, true) => ('Copied', Lucide.check),
      _ => ('Copy', Lucide.copy),
    };

    return Button(
      variant: ButtonVariant.secondary,
      size: ButtonSize.sm,
      label: _copied
          ? 'Copied ${widget.file.path}'
          : 'Copy ${widget.file.path}',
      onPressed: _pending ? null : _copy,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon.lucide(glyph, size: IconSize.sm),
          SizedBox(width: Button.gapFor(ButtonSize.sm)),
          StyledText(text, TextStyles.buttonLabelSm),
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

  static String _basename(String path) {
    final int slash = path.lastIndexOf('/');
    return slash < 0 ? path : path.substring(slash + 1);
  }

  /// The label shown for [path] — its basename alone, unless that basename
  /// is shared with another file in this tree, in which case the full path
  /// is shown so the two remain tellable apart (both in the rendered text
  /// and in the row's accessible name).
  static String _displayName(String path, Map<String, int> basenameCounts) {
    final String name = _basename(path);
    return (basenameCounts[name] ?? 0) > 1 ? path : name;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, int> basenameCounts = <String, int>{};
    for (final DocsCodeFile file in files) {
      final String name = _basename(file.path);
      basenameCounts[name] = (basenameCounts[name] ?? 0) + 1;
    }

    final List<Widget> entries = <Widget>[
      for (int i = 0; i < files.length; i++)
        _FileEntry(
          name: _displayName(files[i].path, basenameCounts),
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
                if (i > 0) SizedBox(height: space(1.5)),
                entries[i],
              ],
            ],
          )
        : Wrap(spacing: space(2), runSpacing: space(2), children: entries);

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
    final Widget button = Button(
      key: ValueKey<String>('docs-file-tree-entry:$path'),
      variant: selected ? ButtonVariant.secondary : ButtonVariant.outline,
      size: ButtonSize.sm,
      label: selected ? 'Selected file $name' : 'Select file $name',
      expanded: expanded,
      contentAlignment: expanded ? Alignment.centerLeft : null,
      onPressed: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon.lucide(Lucide.fileCode, size: IconSize.sm),
          SizedBox(width: Button.gapFor(ButtonSize.sm)),
          // Flexible, not a bare child: the rail's row width is fixed
          // (LayoutWidths.rail less the button's own padding) and a long Shot
          // file name must ellipsize rather than overflow the button.
          Flexible(
            child: StyledText(
              name,
              // `sm` is this button's own rung — `buttonLabel` is the `md`
              // rung and, substituted into an auto-height left-aligned row
              // like this one, comes out short (typography.dart documents
              // the measured gap).
              TextStyles.buttonLabelSm,
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
