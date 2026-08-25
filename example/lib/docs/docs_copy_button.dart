// example/lib/docs/docs_copy_button.dart
/// The copy control every documentation snippet and command carries.
///
/// Secondary rather than ghost: on a code surface a ghost control is nearly
/// invisible against the block it sits on, and this is the only affordance
/// the block has.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Writes [text] to the clipboard.
typedef DocsClipboardWriter = Future<void> Function(String text);

Future<void> _systemWrite(String text) =>
    Clipboard.setData(ClipboardData(text: text));

class DocsCopyButton extends StatefulWidget {
  const DocsCopyButton({
    super.key,
    required this.text,
    this.writer,
    this.copyLabel = 'Copy code',
    this.copiedLabel = 'Copied',
  });

  /// The exact characters the clipboard receives. Never a re-rendering of the
  /// displayed code: what a reader copies must be what a compiler accepts.
  final String text;

  /// Injected so a test can observe the write without a platform channel.
  final DocsClipboardWriter? writer;

  /// The accessible name at rest. Nothing but the glyph distinguishes a copy
  /// from a mis-tap, so the name carries the state.
  final String copyLabel;

  /// The accessible name while confirming.
  final String copiedLabel;

  /// How long the confirmation holds before reverting.
  static const Duration confirmation = Duration(seconds: 2);

  @override
  State<DocsCopyButton> createState() => _DocsCopyButtonState();
}

class _DocsCopyButtonState extends State<DocsCopyButton> {
  bool _pending = false;
  bool _copied = false;

  Future<void> _copy() async {
    if (_pending) return;
    setState(() => _pending = true);
    await (widget.writer ?? _systemWrite)(widget.text);
    if (!mounted) return;
    setState(() {
      _pending = false;
      _copied = true;
    });
    await Future<void>.delayed(DocsCopyButton.confirmation);
    if (!mounted) return;
    setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    final ElLucideGlyph glyph = switch ((_pending, _copied)) {
      (true, _) => ElLucide.loaderCircle,
      (_, true) => ElLucide.check,
      _ => ElLucide.copy,
    };
    return ElButton(
      variant: ElButtonVariant.secondary,
      size: ElButtonSize.iconSm,
      label: _copied ? widget.copiedLabel : widget.copyLabel,
      onPressed: _pending ? null : _copy,
      child: ElIcon.lucide(glyph, size: ElIconSize.sm),
    );
  }
}
