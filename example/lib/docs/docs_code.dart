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

class _DocsCodeExampleState extends State<DocsCodeExample>
    with SingleTickerProviderStateMixin {
  String? _pendingCopyId;

  /// Which control last copied successfully, held on screen for
  /// [DsDurations.attachmentSaving].
  String? _copiedId;

  /// Holds that "Copied" state on screen.
  ///
  /// An [AnimationController] rather than a [Future.delayed], for two reasons
  /// that are the same reason: it is driven by the scheduler, so it is torn
  /// down with the widget and it advances under a widget test's own clock — a
  /// bare timer would outlive a disposed tree and fail the test that copied.
  ///
  /// Built in [initState], not lazily: a `late final` initialiser that nothing
  /// ever touched would first run inside [dispose], where creating a [Ticker]
  /// means an inherited-widget lookup on a deactivated element.
  ///
  /// [DsDurations.attachmentSaving] is the token, not a number of its own:
  /// it is already this system's answer to "how long does a control's glyph
  /// stay on the check after the action it confirms".
  late final AnimationController _confirmation;

  @override
  void initState() {
    super.initState();
    _confirmation =
        AnimationController(vsync: this, duration: DsDurations.attachmentSaving)
          ..addStatusListener((AnimationStatus status) {
            if (status == AnimationStatus.completed && mounted) {
              setState(() => _copiedId = null);
            }
          });
  }

  @override
  void dispose() {
    _confirmation.dispose();
    super.dispose();
  }

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
      if (mounted) {
        setState(() => _copiedId = id);
        _confirmation.forward(from: 0);
      }
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
                copied: _copiedId == _copyIdForCommand(widget.command!),
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
                copiedId: _copiedId,
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
    required this.copied,
    required this.onCopy,
  });

  final DocsCodeCommand command;
  final bool pending;
  final bool copied;
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
          copiedLabel: 'Copied command',
          pending: pending,
          copied: copied,
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
    required this.copiedId,
    required this.onCopy,
  });

  final List<DocsCodeFile> files;
  final String? pendingId;
  final String? copiedId;
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
            copied: copiedId == _DocsCodeExampleState._copyIdForFile(files[i]),
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
    required this.copied,
    required this.onCopy,
  });

  final DocsCodeFile file;
  final bool pending;
  final bool copied;
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
            copiedLabel: 'Copied ${file.path}',
            pending: pending,
            copied: copied,
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
    required this.copiedLabel,
    required this.pending,
    required this.copied,
    required this.onCopy,
  });

  final String title;
  final String subtitle;
  final String copyLabel;

  /// The accessible name while the control is confirming — a press state alone
  /// told neither a sighted nor an assisted reader that anything was copied.
  final String copiedLabel;

  final bool pending;
  final bool copied;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    // A press state alone said nothing — the button dipped and came back, and
    // nothing on screen distinguished a copy from a mis-tap. Both the rendered
    // label and the glyph change, and so does the accessible name above.
    final (String label, DsLucideGlyph glyph) = switch ((pending, copied)) {
      (true, _) => ('Copying', DsLucide.loaderCircle),
      (_, true) => ('Copied', DsLucide.check),
      _ => ('Copy', DsLucide.copy),
    };
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
          label: copied ? copiedLabel : copyLabel,
          onPressed: pending ? null : onCopy,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DsIcon.lucide(glyph, size: DsIconSize.sm),
              SizedBox(width: DsButton.gapFor(DsButtonSize.sm)),
              DsText(label, DsComponentType.buttonLabel),
            ],
          ),
        ),
      ],
    );
  }
}

/// Selectable, horizontally scrollable code block for docs and install guides.
class DocsSelectableCodeBlock extends StatefulWidget {
  const DocsSelectableCodeBlock({
    super.key,
    required this.code,
    this.maxHeight,
  });

  final String code;

  /// Caps the block's height, making it its own vertical viewport.
  ///
  /// Null — the default, and what every command block uses — lets the block
  /// grow to its content, which for one or two lines is the right shape.
  ///
  /// A **source listing** is a different animal, and leaving it uncapped is
  /// what made the Files viewer on `/shots/<slug>` and `/skills` unreadable at
  /// desktop width. The block scrolls horizontally, and it always did — but the
  /// only affordance that scroll has is the scrollbar, which a horizontal
  /// viewport paints along the *bottom of its own box*. Uncapped, that box is
  /// as tall as the whole file, so the thumb sat hundreds of pixels below the
  /// fold while the reader looked at line 1 seeing `class DashboardOverviewShot
  /// extends Statefu` and nothing to suggest the rest existed. A mouse wheel
  /// could not reach it either: a wheel reports `dy`, which a horizontal
  /// [Scrollable] ignores, and Flutter's default [ScrollBehavior] does not let
  /// a mouse drag a viewport.
  ///
  /// Capping the height fixes exactly that: the horizontal thumb comes back to
  /// the bottom edge of the visible box where it can be seen and dragged, and
  /// the wheel gets a vertical viewport of its own to scroll.
  final double? maxHeight;

  /// The default cap for a source listing — 140 steps, ~28 lines of
  /// `.type-code`, enough to read a file's shape without the page becoming the
  /// file.
  static double get sourceMaxHeight => ds(140);

  @override
  State<DocsSelectableCodeBlock> createState() =>
      _DocsSelectableCodeBlockState();
}

class _DocsSelectableCodeBlockState extends State<DocsSelectableCodeBlock> {
  final ScrollController _scroller = ScrollController();
  final ScrollController _vertical = ScrollController();

  @override
  void dispose() {
    _scroller.dispose();
    _vertical.dispose();
    super.dispose();
  }

  static bool _isHorizontal(ScrollNotification notification) =>
      notification.metrics.axis == Axis.horizontal;

  static bool _isVertical(ScrollNotification notification) =>
      notification.metrics.axis == Axis.vertical;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final TextStyle style = DsText.styleOf(
      context,
      DsType.code,
      color: theme.mutedForeground,
    ).copyWith(height: DsComponentType.textareaBody.height);

    final Widget text = Text(widget.code, style: style, softWrap: false);

    // [DsLineBox] restores the half-pixel per line the engine rounds away, but
    // it does so by growing the *paragraph* and centring the difference — half
    // above the first line, half below the last. On one line that is the whole
    // truth and the correction is invisible. On a 300-line source listing it is
    // 300 half-pixels landing as one lump: roughly 100px of dead air above
    // `import 'package:flutter/…'`, which is what every Shot source viewer was
    // opening on. CSS spreads that leading per line, not per paragraph, so a
    // multi-line listing is laid out as the engine gives it.
    final Widget paragraph = widget.code.contains('\n')
        ? text
        : DsLineBox(style: style, child: text);

    Widget block = SingleChildScrollView(
      key: const ValueKey<String>('docs-code-scroll'),
      controller: _scroller,
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.all(ds(5)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: DsContainers.sm),
        child: SelectionArea(child: paragraph),
      ),
    );

    final double? cap = widget.maxHeight;
    if (cap != null) {
      block = ConstrainedBox(
        constraints: BoxConstraints(maxHeight: cap),
        child: RawScrollbar(
          controller: _vertical,
          thumbColor: theme.border,
          thickness: ds(2),
          radius: Radius.circular(DsRadii.pill),
          thumbVisibility: true,
          // The horizontal view nested below reports at depth 1; without an
          // axis test the default depth-0 predicate would let its notifications
          // drive this vertical thumb.
          notificationPredicate: _isVertical,
          child: SingleChildScrollView(
            key: const ValueKey<String>('docs-code-scroll-vertical'),
            controller: _vertical,
            child: block,
          ),
        ),
      );
    }

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
          // Outside the vertical viewport, so the horizontal thumb rides the
          // bottom edge of what the reader can see rather than the bottom edge
          // of the file. Same reason its predicate has to name the axis: once
          // capped, the horizontal scroll is a nested one.
          child: RawScrollbar(
            controller: _scroller,
            thumbColor: theme.border,
            thickness: ds(2),
            radius: Radius.circular(DsRadii.pill),
            thumbVisibility: true,
            notificationPredicate: _isHorizontal,
            child: block,
          ),
        ),
      ),
    );
  }
}
