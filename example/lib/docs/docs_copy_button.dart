// example/lib/docs/docs_copy_button.dart
/// The copy control every documentation snippet and command carries.
///
/// Secondary rather than ghost: on a code surface a ghost control is nearly
/// invisible against the block it sits on, and this is the only affordance
/// the block has.
///
/// The glyph rolls through [ElIconSwap] (`lib/src/components/icon_swap.dart`)
/// rather than swapping instantly. That component's own docstring states the
/// system's rule plainly: *"every control that alternates between icons swaps
/// them through this... No crossfades, no instant swaps — a control that
/// changes meaning should show you it changed."* Idle, pending and copied are
/// three meanings, so they are three cells on the wheel, in that order.
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

  /// The wheel's three cells, in wheel order.
  static const int idleIndex = 0;
  static const int pendingIndex = 1;
  static const int copiedIndex = 2;

  @override
  State<DocsCopyButton> createState() => _DocsCopyButtonState();
}

class _DocsCopyButtonState extends State<DocsCopyButton> {
  int _state = DocsCopyButton.idleIndex;

  Future<void> _copy() async {
    if (_state == DocsCopyButton.pendingIndex) return;
    setState(() => _state = DocsCopyButton.pendingIndex);
    await (widget.writer ?? _systemWrite)(widget.text);
    if (!mounted) return;
    setState(() => _state = DocsCopyButton.copiedIndex);
    await Future<void>.delayed(DocsCopyButton.confirmation);
    if (!mounted) return;
    setState(() => _state = DocsCopyButton.idleIndex);
  }

  @override
  Widget build(BuildContext context) {
    // The glyph's own box — `ElButtonSize.iconSm`'s rung is 14px
    // (`ElButton.iconPxFor`), matching `ElIconSize.sm`. The clip window is
    // 4px wider than the glyph in every ElIconSwap demo in the package
    // (`example/lib/pages/buttons.dart`), so the window is derived from the
    // cell rather than stated as a second number of its own.
    final double cell = ElButton.iconPxFor(ElButtonSize.iconSm);
    final double window = cell + el(1);

    return ElButton(
      variant: ElButtonVariant.secondary,
      size: ElButtonSize.iconSm,
      label: _state == DocsCopyButton.copiedIndex
          ? widget.copiedLabel
          : widget.copyLabel,
      onPressed: _state == DocsCopyButton.pendingIndex ? null : _copy,
      child: ElIconSwap(
        activeIndex: _state,
        window: window,
        cell: cell,
        icons: <Widget>[
          ElIcon.lucide(ElLucide.copy, size: ElIconSize.sm),
          ElIcon.lucide(ElLucide.loaderCircle, size: ElIconSize.sm),
          ElIcon.lucide(ElLucide.check, size: ElIconSize.sm),
        ],
      ),
    );
  }
}
