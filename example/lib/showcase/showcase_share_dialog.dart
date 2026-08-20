import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

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
  final DsToastController toasts;
  final DsModalTriggerBuilder trigger;

  void _copy() {
    Clipboard.setData(ClipboardData(text: link));
    toasts.success(
      'Share link copied',
      description: '“$subject” is ready to send.',
      glyph: DsIconGlyph.copy,
    );
  }

  void _preparePost(String network) {
    toasts.success(
      'Ready for $network',
      description: '$subject and its public link are prepared for your post.',
      glyph: DsIconGlyph.externalLink,
    );
  }

  @override
  Widget build(BuildContext context) => DsDialog(
    trigger: trigger,
    content: (BuildContext context, VoidCallback close) => DsDialogContent(
      onClose: close,
      children: <Widget>[
        DsDialogHeader(
          children: <Widget>[
            DsDialogTitle(dialogTitle),
            DsDialogDescription(description),
          ],
        ),
        DsFieldGroup(
          children: <Widget>[
            DsField(
              label: 'Public link',
              description: 'Anyone with this link can view $subject.',
              child: DsInput(initialValue: link, readOnly: true),
            ),
            DsButton(
              key: const Key('share-copy-link'),
              variant: DsButtonVariant.primary,
              label: 'Copy link',
              onPressed: _copy,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const DsIcon.lucide(DsLucide.copy, size: DsIconSize.sm),
                  SizedBox(width: DsButton.gapFor(DsButtonSize.md)),
                  DsText('Copy link', DsComponentType.buttonLabel),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: DsButton(
                    key: const Key('share-threads'),
                    variant: DsButtonVariant.secondary,
                    label: 'Prepare for Threads',
                    onPressed: () => _preparePost('Threads'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const DsIcon.lucide(
                          DsLucide.atSign,
                          size: DsIconSize.sm,
                        ),
                        SizedBox(width: DsButton.gapFor(DsButtonSize.md)),
                        DsText('Threads', DsComponentType.buttonLabel),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: ds(3)),
                Expanded(
                  child: DsButton(
                    key: const Key('share-x'),
                    variant: DsButtonVariant.secondary,
                    label: 'Prepare for X',
                    onPressed: () => _preparePost('X'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const DsIcon.lucide(DsLucide.send, size: DsIconSize.sm),
                        SizedBox(width: DsButton.gapFor(DsButtonSize.md)),
                        DsText('X', DsComponentType.buttonLabel),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        DsDialogFooter(
          children: <Widget>[
            DsButton(
              key: const Key('share-done'),
              variant: DsButtonVariant.ghost,
              onPressed: close,
              child: DsText('Done', DsComponentType.buttonLabel),
            ),
          ],
        ),
      ],
    ),
  );
}
