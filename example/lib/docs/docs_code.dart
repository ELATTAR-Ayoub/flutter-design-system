/// Reusable documentation code/preview composition for public docs pages.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/material.dart' show SelectionArea;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../kit.dart';

/// Writes [text] to the clipboard.
typedef DocsClipboardWriter = Future<void> Function(String text);

/// Emits a feedback message after a docs-code action completes.
typedef DocsCodeFeedback = void Function(DsToastMessage message);

Future<void> _systemClipboardWrite(String text) =>
    Clipboard.setData(ClipboardData(text: text));

/// One manual-install source file.
class DocsCodeFile {
  const DocsCodeFile({
    required this.path,
    required this.code,
    this.title,
    this.description,
  });

  final String path;
  final String code;
  final String? title;
  final String? description;
}

/// One copyable command line.
class DocsCodeCommand {
  const DocsCodeCommand({
    required this.command,
    this.label = 'CLI command',
    this.description,
  });

  final String command;
  final String label;
  final String? description;
}

enum _DocsCodeTab { preview, cli, manual }

/// A preview/code block with optional tabs for preview, command, and manual
/// source installation.
class DocsCodeExample extends StatefulWidget {
  const DocsCodeExample({
    super.key,
    required this.title,
    this.description,
    this.preview,
    this.command,
    this.manualFiles = const <DocsCodeFile>[],
    this.clipboardWriter = _systemClipboardWrite,
    this.onFeedback,
  });

  final String title;
  final String? description;
  final Widget? preview;
  final DocsCodeCommand? command;
  final List<DocsCodeFile> manualFiles;
  final DocsClipboardWriter clipboardWriter;
  final DocsCodeFeedback? onFeedback;

  bool get hasPreview => preview != null;
  bool get hasCommand => command != null;
  bool get hasManual => manualFiles.isNotEmpty;

  @override
  State<DocsCodeExample> createState() => _DocsCodeExampleState();
}

class _DocsCodeExampleState extends State<DocsCodeExample> {
  String? _pendingCopyId;

  static String _copyIdForCommand(DocsCodeCommand command) =>
      'command:${command.command}';

  static String _copyIdForFile(DocsCodeFile file) => 'file:${file.path}';

  Future<void> _copyText({
    required String id,
    required String text,
    required String successTitle,
    required String successDescription,
  }) async {
    if (_pendingCopyId != null) return;
    setState(() => _pendingCopyId = id);
    try {
      await widget.clipboardWriter(text);
      widget.onFeedback?.call(
        DsToastMessage(
          title: successTitle,
          description: successDescription,
          type: DsToastType.success,
          glyph: DsIconGlyph.copy,
        ),
      );
    } catch (_) {
      widget.onFeedback?.call(
        const DsToastMessage(
          title: 'Copy failed',
          description: 'Try selecting and copying the code manually.',
          type: DsToastType.error,
          glyph: DsIconGlyph.copy,
        ),
      );
    } finally {
      if (mounted) setState(() => _pendingCopyId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final List<({String label, _DocsCodeTab tab, Widget content})> tabs =
        <({String label, _DocsCodeTab tab, Widget content})>[
          if (widget.hasPreview)
            (
              label: 'Preview',
              tab: _DocsCodeTab.preview,
              content: _PreviewPane(
                description: widget.description,
                preview: widget.preview!,
              ),
            ),
          if (widget.hasCommand)
            (
              label: 'CLI',
              tab: _DocsCodeTab.cli,
              content: _CommandPane(
                command: widget.command!,
                pending: _pendingCopyId == _copyIdForCommand(widget.command!),
                onCopy: () => _copyText(
                  id: _copyIdForCommand(widget.command!),
                  text: widget.command!.command,
                  successTitle: 'Command copied',
                  successDescription: widget.command!.label,
                ),
              ),
            ),
          if (widget.hasManual)
            (
              label: 'Manual',
              tab: _DocsCodeTab.manual,
              content: _ManualPane(
                files: widget.manualFiles,
                pendingId: _pendingCopyId,
                onCopy: (DocsCodeFile file) => _copyText(
                  id: _copyIdForFile(file),
                  text: file.code,
                  successTitle: 'Source copied',
                  successDescription: file.path,
                ),
              ),
            ),
        ];

    final List<DsTabItem> items = <DsTabItem>[
      for (final ({String label, _DocsCodeTab tab, Widget content}) row in tabs)
        DsTabItem(
          label: row.label,
          content: KeyedSubtree(
            key: ValueKey<_DocsCodeTab>(row.tab),
            child: row.content,
          ),
        ),
    ];

    if (items.length == 1) {
      return DsPanel(
        label: widget.title,
        note: tabs.first.label,
        child: tabs.first.content,
      );
    }

    return DsPanel(
      label: widget.title,
      note: 'Preview and source',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DsText(
            'Choose the live preview, the CLI command, or the source files you want to install.',
            DsType.small,
            color: theme.mutedForeground,
          ),
          SizedBox(height: ds(4)),
          _DocsCodeTabs(items: items),
        ],
      ),
    );
  }
}

class _DocsCodeTabs extends StatefulWidget {
  const _DocsCodeTabs({required this.items});

  final List<DsTabItem> items;

  @override
  State<_DocsCodeTabs> createState() => _DocsCodeTabsState();
}

class _DocsCodeTabsState extends State<_DocsCodeTabs> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DsTabs(
      items: widget.items,
      selectedIndex: _selectedIndex,
      onChanged: (int index) => setState(() => _selectedIndex = index),
    );
  }
}

class _PreviewPane extends StatelessWidget {
  const _PreviewPane({required this.description, required this.preview});

  final String? description;
  final Widget preview;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (description != null) ...<Widget>[
          DsText(description!, DsType.small, color: theme.mutedForeground),
          SizedBox(height: ds(4)),
        ],
        Container(
          padding: EdgeInsets.all(ds(5)),
          decoration: BoxDecoration(
            color: theme.background,
            borderRadius: BorderRadius.circular(DsRadii.lg),
            border: Border.all(color: theme.border, width: DsWidths.hairline),
          ),
          child: preview,
        ),
      ],
    );
  }
}

class _CommandPane extends StatelessWidget {
  const _CommandPane({
    required this.command,
    required this.pending,
    required this.onCopy,
  });

  final DocsCodeCommand command;
  final bool pending;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (command.description != null) ...<Widget>[
          DsText(
            command.description!,
            DsType.small,
            color: theme.mutedForeground,
          ),
          SizedBox(height: ds(4)),
        ],
        _DocsCodeHeader(
          title: command.label,
          subtitle: 'Copy the exact command for this component.',
          copyLabel: 'Copy command',
          pending: pending,
          onCopy: onCopy,
        ),
        SizedBox(height: ds(3)),
        DocsSelectableCodeBlock(
          key: const ValueKey<String>('docs-command-code'),
          code: command.command,
        ),
      ],
    );
  }
}

class _ManualPane extends StatelessWidget {
  const _ManualPane({
    required this.files,
    required this.pendingId,
    required this.onCopy,
  });

  final List<DocsCodeFile> files;
  final String? pendingId;
  final ValueChanged<DocsCodeFile> onCopy;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (int i = 0; i < files.length; i++) ...<Widget>[
          if (i > 0) SizedBox(height: ds(5)),
          _ManualFileCard(
            file: files[i],
            pending:
                pendingId == _DocsCodeExampleState._copyIdForFile(files[i]),
            onCopy: () => onCopy(files[i]),
          ),
        ],
      ],
    );
  }
}

class _ManualFileCard extends StatelessWidget {
  const _ManualFileCard({
    required this.file,
    required this.pending,
    required this.onCopy,
  });

  final DocsCodeFile file;
  final bool pending;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Container(
      padding: EdgeInsets.all(ds(4)),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(DsRadii.lg),
        border: Border.all(color: theme.border, width: DsWidths.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _DocsCodeHeader(
            title: file.title ?? file.path,
            subtitle: file.description ?? file.path,
            copyLabel: 'Copy ${file.path}',
            pending: pending,
            onCopy: onCopy,
          ),
          SizedBox(height: ds(3)),
          DocsSelectableCodeBlock(
            key: ValueKey<String>('docs-file:${file.path}'),
            code: file.code,
          ),
        ],
      ),
    );
  }
}

class _DocsCodeHeader extends StatelessWidget {
  const _DocsCodeHeader({
    required this.title,
    required this.subtitle,
    required this.copyLabel,
    required this.pending,
    required this.onCopy,
  });

  final String title;
  final String subtitle;
  final String copyLabel;
  final bool pending;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: ds(3),
      spacing: ds(3),
      children: <Widget>[
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: DsWidths.prose),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DsText(title, DsType.label, color: theme.foreground),
              SizedBox(height: ds(1)),
              DsText(subtitle, DsType.small, color: theme.mutedForeground),
            ],
          ),
        ),
        DsButton(
          variant: DsButtonVariant.secondary,
          size: DsButtonSize.sm,
          label: copyLabel,
          onPressed: pending ? null : onCopy,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DsIcon.lucide(
                pending ? DsLucide.loaderCircle : DsLucide.copy,
                size: DsIconSize.sm,
              ),
              SizedBox(width: DsButton.gapFor(DsButtonSize.sm)),
              DsText(pending ? 'Copying' : 'Copy', DsComponentType.buttonLabel),
            ],
          ),
        ),
      ],
    );
  }
}

/// Selectable, horizontally scrollable code block for docs and install guides.
class DocsSelectableCodeBlock extends StatefulWidget {
  const DocsSelectableCodeBlock({super.key, required this.code});

  final String code;

  @override
  State<DocsSelectableCodeBlock> createState() =>
      _DocsSelectableCodeBlockState();
}

class _DocsSelectableCodeBlockState extends State<DocsSelectableCodeBlock> {
  final ScrollController _scroller = ScrollController();

  @override
  void dispose() {
    _scroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final TextStyle style = DsText.styleOf(
      context,
      DsType.code,
      color: theme.mutedForeground,
    ).copyWith(height: DsComponentType.textareaBody.height);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.background,
        borderRadius: BorderRadius.circular(DsRadii.lg),
        border: Border.all(color: theme.border, width: DsWidths.hairline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(DsWidths.hairline),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(DsRadii.lg - DsWidths.hairline),
          child: RawScrollbar(
            controller: _scroller,
            thumbColor: theme.border,
            thickness: ds(2),
            radius: Radius.circular(DsRadii.pill),
            thumbVisibility: true,
            child: SingleChildScrollView(
              key: const ValueKey<String>('docs-code-scroll'),
              controller: _scroller,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.all(ds(5)),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: DsContainers.sm),
                child: SelectionArea(
                  child: DsLineBox(
                    style: style,
                    child: Text(widget.code, style: style, softWrap: false),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
