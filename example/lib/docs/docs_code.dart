/// Reusable documentation code/preview composition for public docs pages.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/material.dart' show SelectionArea;
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
import 'docs_theme_syntax.dart';

/// Writes [text] to the clipboard.
typedef DocsClipboardWriter = Future<void> Function(String text);

/// Emits a feedback message after a docs-code action completes.
typedef DocsCodeFeedback = void Function(ToastMessage message);

Future<void> _systemClipboardWrite(String text) =>
    Clipboard.setData(ClipboardData(text: text));

/// One manual-install source file.
class DocsCodeFile {
  const DocsCodeFile({
    required this.path,
    required this.code,
    this.title,
    this.description,
    this.language,
  });

  final String path;
  final String code;
  final String? title;
  final String? description;

  /// A language [tokeniseThemedCode] recognises. Null defers to
  /// [docsCodeFileLanguage], which reads it off [path]'s extension.
  final String? language;
}

/// [file]'s highlighting language: [DocsCodeFile.language] when the caller
/// set one, otherwise a guess from [DocsCodeFile.path]'s extension. Only
/// `.dart` is guessed as `dart` — every other extension (`.yaml`, `.md`, an
/// extensionless name) comes back `text`, a language `tokeniseThemedCode`
/// does not know, so it renders intact and uncoloured rather than being
/// mis-read as Dart.
String docsCodeFileLanguage(DocsCodeFile file) {
  final String? explicit = file.language;
  if (explicit != null) return explicit;
  return file.path.endsWith('.dart') ? 'dart' : 'text';
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
  /// [MotionDurations.attachmentSaving].
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
  /// [MotionDurations.attachmentSaving] is the token, not a number of its own:
  /// it is already this system's answer to "how long does a control's glyph
  /// stay on the check after the action it confirms".
  late final AnimationController _confirmation;

  @override
  void initState() {
    super.initState();
    _confirmation =
        AnimationController(
          vsync: this,
          duration: MotionDurations.attachmentSaving,
        )..addStatusListener((AnimationStatus status) {
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
        ToastMessage(
          title: successTitle,
          description: successDescription,
          type: ToastType.success,
          glyph: IconGlyph.copy,
        ),
      );
    } catch (_) {
      widget.onFeedback?.call(
        const ToastMessage(
          title: 'Copy failed',
          description: 'Try selecting and copying the code manually.',
          type: ToastType.error,
          glyph: IconGlyph.copy,
        ),
      );
    } finally {
      if (mounted) setState(() => _pendingCopyId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
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

    final List<TabItem> items = <TabItem>[
      for (final ({String label, _DocsCodeTab tab, Widget content}) row in tabs)
        TabItem(
          label: row.label,
          content: KeyedSubtree(
            key: ValueKey<_DocsCodeTab>(row.tab),
            child: row.content,
          ),
        ),
    ];

    if (items.length == 1) {
      return Panel(
        label: widget.title,
        note: tabs.first.label,
        child: tabs.first.content,
      );
    }

    return Panel(
      label: widget.title,
      note: 'Preview and source',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          StyledText(
            'Choose the live preview, the CLI command, or the source files you want to install.',
            TextStyles.small,
            color: theme.mutedForeground,
          ),
          SizedBox(height: space(4)),
          _DocsCodeTabs(items: items),
        ],
      ),
    );
  }
}

class _DocsCodeTabs extends StatefulWidget {
  const _DocsCodeTabs({required this.items});

  final List<TabItem> items;

  @override
  State<_DocsCodeTabs> createState() => _DocsCodeTabsState();
}

class _DocsCodeTabsState extends State<_DocsCodeTabs> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Tabs(
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
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (description != null) ...<Widget>[
          StyledText(
            description!,
            TextStyles.small,
            color: theme.mutedForeground,
          ),
          SizedBox(height: space(4)),
        ],
        Container(
          padding: EdgeInsets.all(space(5)),
          decoration: BoxDecoration(
            color: theme.background,
            borderRadius: BorderRadius.circular(Radii.lg),
            border: Border.all(
              color: theme.border,
              width: BorderWidths.hairline,
            ),
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
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (command.description != null) ...<Widget>[
          StyledText(
            command.description!,
            TextStyles.small,
            color: theme.mutedForeground,
          ),
          SizedBox(height: space(3)),
        ],
        _CopyableCodeBlock(
          codeKey: const ValueKey<String>('docs-command-code'),
          code: command.command,
          // Every `DocsCodeCommand` is a shell line — `dart install …`,
          // `elattar init …` — never Dart.
          language: 'bash',
          pending: pending,
          copied: copied,
          onCopy: onCopy,
          copyLabel: 'Copy command',
          copiedLabel: 'Copied command',
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
          if (i > 0) SizedBox(height: space(5)),
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
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // A quiet filename caption in the code's own type, the way the
        // reference names a file above its card instead of boxing the name
        // and a labelled button into a panel strip of their own.
        StyledText(
          file.title ?? file.path,
          TextStyles.code,
          color: theme.mutedForeground,
        ),
        if (file.description != null) ...<Widget>[
          SizedBox(height: space(1)),
          StyledText(
            file.description!,
            TextStyles.small,
            color: theme.mutedForeground,
          ),
        ],
        SizedBox(height: space(2)),
        _CopyableCodeBlock(
          codeKey: ValueKey<String>('docs-file:${file.path}'),
          code: file.code,
          language: docsCodeFileLanguage(file),
          pending: pending,
          copied: copied,
          onCopy: onCopy,
          copyLabel: 'Copy ${file.path}',
          copiedLabel: 'Copied ${file.path}',
        ),
      ],
    );
  }
}

/// A [DocsSelectableCodeBlock] with a small, icon-only copy control pinned to
/// its own top-right corner: the reference never sets a labelled button
/// beside its code, only a glyph that swaps to a check mark over the block
/// itself.
class _CopyableCodeBlock extends StatelessWidget {
  const _CopyableCodeBlock({
    required this.code,
    required this.pending,
    required this.copied,
    required this.onCopy,
    required this.copyLabel,
    required this.copiedLabel,
    this.language = 'dart',
    this.codeKey,
  });

  final String code;
  final bool pending;
  final bool copied;
  final VoidCallback onCopy;
  final String copyLabel;
  final String copiedLabel;

  /// Forwarded onto the [DocsSelectableCodeBlock] itself.
  final String language;

  /// Forwarded onto the [DocsSelectableCodeBlock] itself, not this wrapper,
  /// so every existing lookup by that key still finds the same block.
  final Key? codeKey;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        DocsSelectableCodeBlock(key: codeKey, code: code, language: language),
        Positioned(
          top: space(2),
          right: space(2),
          child: _DocsCodeCopyButton(
            pending: pending,
            copied: copied,
            onCopy: onCopy,
            copyLabel: copyLabel,
            copiedLabel: copiedLabel,
          ),
        ),
      ],
    );
  }
}

/// `absolute top-2 right-2`, icon-only, ghost: the reference's own copy
/// control, never a labelled button competing with the code for attention.
class _DocsCodeCopyButton extends StatelessWidget {
  const _DocsCodeCopyButton({
    required this.pending,
    required this.copied,
    required this.onCopy,
    required this.copyLabel,
    required this.copiedLabel,
  });

  final bool pending;
  final bool copied;
  final VoidCallback onCopy;

  /// The accessible name at rest — a press state alone tells neither a
  /// sighted nor an assisted reader that anything copied.
  final String copyLabel;

  /// The accessible name while the control is confirming.
  final String copiedLabel;

  @override
  Widget build(BuildContext context) {
    // Nothing on screen but the glyph distinguishes a copy from a mis-tap, so
    // the accessible name carries that state instead of a visible label.
    final LucideGlyph glyph = switch ((pending, copied)) {
      (true, _) => Lucide.loaderCircle,
      (_, true) => Lucide.check,
      _ => Lucide.copy,
    };
    return Button(
      variant: ButtonVariant.ghost,
      size: ButtonSize.iconSm,
      label: copied ? copiedLabel : copyLabel,
      onPressed: pending ? null : onCopy,
      child: Icon.lucide(glyph, size: IconSize.sm),
    );
  }
}

/// Selectable, horizontally scrollable code block for docs and install guides.
class DocsSelectableCodeBlock extends StatefulWidget {
  const DocsSelectableCodeBlock({
    super.key,
    required this.code,
    this.language = 'dart',
    this.maxHeight,
  });

  final String code;

  /// A language [tokeniseThemedCode] recognises. `dart` (the default) and
  /// `bash`/`sh`/`shell` are highlighted; anything else renders intact but
  /// uncoloured rather than failing.
  final String language;

  /// Caps the block's height, making it its own vertical viewport.
  ///
  /// Null — the default, and what every command block uses — lets the block
  /// grow to its content, which for one or two lines is the right shape.
  ///
  /// A **source listing** is a different animal, and leaving it uncapped is
  /// what made the Files viewer on `/skills` unreadable at desktop width. The
  /// block scrolls horizontally, and it always did — but the only affordance
  /// that scroll has is the scrollbar, which a horizontal viewport paints
  /// along the *bottom of its own box*. Uncapped, that box is as tall as the
  /// whole file, so the thumb sat hundreds of pixels below the fold while the
  /// reader looked at line 1 seeing the file's first, unfinished line and
  /// nothing to suggest the rest existed. A mouse wheel
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
  static double get sourceMaxHeight => space(140);

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
    final ThemeTokens theme = ThemeScope.of(context);
    final TextStyle style = StyledText.styleOf(
      context,
      TextStyles.code,
      color: theme.foreground,
    ).copyWith(height: TextStyles.body.step.ratio);

    final List<String> sourceLines = widget.code.split('\n');
    final bool multiline = sourceLines.length > 1;

    // A small, honest tokeniser (`tokeniseThemedCode`, `docs_theme_syntax.
    // dart`): it covers keywords, strings, line comments, numbers,
    // annotations and `PascalCase` type names for Dart, and command names,
    // flags, strings and comments for shell — nothing else. Every colour
    // comes from this system's own semantic palette (`Palette.action/.value/
    // .success/.warning/.info`, `--foreground`, `--muted-foreground`) rather
    // than a fixed third-party theme, so the block stays correct under a
    // rebrand and flips with light/dark the way the rest of the page does.
    // Concatenated back into one paragraph (a plain `'\n'` span between
    // lines) rather than a Column of lines, so `widget.code` is still what a
    // reader selects and copies, matching a plain [Text] exactly as before.
    final List<List<CodeToken>> tokenisedLines = tokeniseThemedCode(
      widget.code,
      widget.language,
      theme,
    );
    final List<InlineSpan> spans = <InlineSpan>[];
    for (int i = 0; i < tokenisedLines.length; i++) {
      if (i > 0) spans.add(const TextSpan(text: '\n'));
      for (final CodeToken token in tokenisedLines[i]) {
        spans.add(
          TextSpan(
            text: token.text,
            style: style.copyWith(color: token.color),
          ),
        );
      }
    }
    final Widget text = Text.rich(
      TextSpan(children: spans),
      style: style,
      softWrap: false,
    );

    // [LineBox] restores the half-pixel per line the engine rounds away, but
    // it does so by growing the *paragraph* and centring the difference — half
    // above the first line, half below the last. On one line that is the whole
    // truth and the correction is invisible. On a 300-line source listing it is
    // 300 half-pixels landing as one lump: roughly 100px of dead air above
    // `import 'package:flutter/…'`, which is what every Shot source viewer was
    // opening on. CSS spreads that leading per line, not per paragraph, so a
    // multi-line listing is laid out as the engine gives it.
    final Widget paragraph = multiline
        ? text
        : LineBox(style: style, child: text);

    // Multi-line only: a single command reads fine bare, and the reference
    // itself shows no gutter on its one-line install commands either.
    final EdgeInsets contentPadding = multiline
        ? EdgeInsets.fromLTRB(space(3), space(5), space(5), space(5))
        : EdgeInsets.all(space(5));

    Widget block = SingleChildScrollView(
      key: const ValueKey<String>('docs-code-scroll'),
      controller: _scroller,
      scrollDirection: Axis.horizontal,
      padding: contentPadding,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: Containers.sm),
        child: SelectionArea(child: paragraph),
      ),
    );

    if (multiline) {
      // Right-aligned, muted, and outside the [SelectionArea] above entirely
      // — a drag that selects the code can never pull a line number into the
      // clipboard, the same outcome the reference gets from generating its
      // numbers as a `::before` pseudo-element, which carries no real text
      // node to copy. `engineLineHeight` is the exact per-line height the
      // paragraph above already renders at (same style, same engine), so the
      // numbers land beside their own line and nowhere else.
      final TextStyle numberStyle = style.copyWith(
        color: theme.mutedForeground,
      );
      final double lineHeight = engineLineHeight(style);
      block = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: space(5),
              bottom: space(5),
              left: space(5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                for (int n = 1; n <= sourceLines.length; n++)
                  SizedBox(
                    height: lineHeight,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text('$n', style: numberStyle, softWrap: false),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(child: block),
        ],
      );
    }

    final double? cap = widget.maxHeight;
    if (cap != null) {
      block = ConstrainedBox(
        constraints: BoxConstraints(maxHeight: cap),
        child: RawScrollbar(
          controller: _vertical,
          thumbColor: theme.border,
          thickness: space(2),
          radius: Radius.circular(Radii.full),
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
        color: theme.muted,
        borderRadius: BorderRadius.circular(Radii.xl2),
        border: Border.all(color: theme.border, width: BorderWidths.hairline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(BorderWidths.hairline),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            Radii.xl2 - BorderWidths.hairline,
          ),
          // Outside the vertical viewport, so the horizontal thumb rides the
          // bottom edge of what the reader can see rather than the bottom edge
          // of the file. Same reason its predicate has to name the axis: once
          // capped, the horizontal scroll is a nested one.
          child: RawScrollbar(
            controller: _scroller,
            thumbColor: theme.border,
            thickness: space(2),
            radius: Radius.circular(Radii.full),
            thumbVisibility: true,
            notificationPredicate: _isHorizontal,
            child: block,
          ),
        ),
      ),
    );
  }
}
