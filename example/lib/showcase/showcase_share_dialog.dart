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

/// Reusable sharing workflow for published Signal Studio content.
///
/// The caller supplies its context and trigger while this product-layer dialog
/// owns the consistent copy, social preparation feedback, and completion path.
class ShowcaseShareDialog extends StatelessWidget {
  const ShowcaseShareDialog({
    super.key,
    required this.dialogTitle,
    required this.description,
    required this.subject,
    required this.link,
    required this.toasts,
    required this.trigger,
  });

  final String dialogTitle;
  final String description;
  final String subject;
  final String link;
  final ToastController toasts;
  final ModalTriggerBuilder trigger;

  void _copy() {
    Clipboard.setData(ClipboardData(text: link));
    toasts.success(
      'Share link copied',
      description: '“$subject” is ready to send.',
      glyph: IconGlyph.copy,
    );
  }

  void _preparePost(String network) {
    toasts.success(
      'Ready for $network',
      description: '$subject and its public link are prepared for your post.',
      glyph: IconGlyph.externalLink,
    );
  }

  @override
  Widget build(BuildContext context) => Dialog(
    trigger: trigger,
    content: (BuildContext context, VoidCallback close) => DialogContent(
      onClose: close,
      children: <Widget>[
        DialogHeader(
          children: <Widget>[
            DialogTitle(dialogTitle),
            DialogDescription(description),
          ],
        ),
        FieldGroup(
          children: <Widget>[
            Field(
              label: 'Public link',
              description: 'Anyone with this link can view $subject.',
              child: Input(initialValue: link, readOnly: true),
            ),
            Button(
              key: const Key('share-copy-link'),
              variant: ButtonVariant.primary,
              label: 'Copy link',
              onPressed: _copy,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon.lucide(Lucide.copy, size: IconSize.sm),
                  SizedBox(width: Button.gapFor(ButtonSize.md)),
                  StyledText('Copy link', TextStyles.buttonLabel),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Button(
                    key: const Key('share-threads'),
                    variant: ButtonVariant.secondary,
                    label: 'Prepare for Threads',
                    onPressed: () => _preparePost('Threads'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Icon.lucide(Lucide.atSign, size: IconSize.sm),
                        SizedBox(width: Button.gapFor(ButtonSize.md)),
                        StyledText('Threads', TextStyles.buttonLabel),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: space(3)),
                Expanded(
                  child: Button(
                    key: const Key('share-x'),
                    variant: ButtonVariant.secondary,
                    label: 'Prepare for X',
                    onPressed: () => _preparePost('X'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Icon.lucide(Lucide.send, size: IconSize.sm),
                        SizedBox(width: Button.gapFor(ButtonSize.md)),
                        StyledText('X', TextStyles.buttonLabel),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        DialogFooter(
          children: <Widget>[
            Button(
              key: const Key('share-done'),
              variant: ButtonVariant.ghost,
              onPressed: close,
              child: StyledText('Done', TextStyles.buttonLabel),
            ),
          ],
        ),
      ],
    ),
  );
}
