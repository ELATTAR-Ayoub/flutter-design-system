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
  final ElToastController toasts;
  final ElModalTriggerBuilder trigger;

  void _copy() {
    Clipboard.setData(ClipboardData(text: link));
    toasts.success(
      'Share link copied',
      description: '“$subject” is ready to send.',
      glyph: ElIconGlyph.copy,
    );
  }

  void _preparePost(String network) {
    toasts.success(
      'Ready for $network',
      description: '$subject and its public link are prepared for your post.',
      glyph: ElIconGlyph.externalLink,
    );
  }

  @override
  Widget build(BuildContext context) => ElDialog(
    trigger: trigger,
    content: (BuildContext context, VoidCallback close) => ElDialogContent(
      onClose: close,
      children: <Widget>[
        ElDialogHeader(
          children: <Widget>[
            ElDialogTitle(dialogTitle),
            ElDialogDescription(description),
          ],
        ),
        ElFieldGroup(
          children: <Widget>[
            ElField(
              label: 'Public link',
              description: 'Anyone with this link can view $subject.',
              child: ElInput(initialValue: link, readOnly: true),
            ),
            ElButton(
              key: const Key('share-copy-link'),
              variant: ElButtonVariant.primary,
              label: 'Copy link',
              onPressed: _copy,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const ElIcon.lucide(ElLucide.copy, size: ElIconSize.sm),
                  SizedBox(width: ElButton.gapFor(ElButtonSize.md)),
                  ElText('Copy link', ElComponentType.buttonLabel),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: ElButton(
                    key: const Key('share-threads'),
                    variant: ElButtonVariant.secondary,
                    label: 'Prepare for Threads',
                    onPressed: () => _preparePost('Threads'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const ElIcon.lucide(
                          ElLucide.atSign,
                          size: ElIconSize.sm,
                        ),
                        SizedBox(width: ElButton.gapFor(ElButtonSize.md)),
                        ElText('Threads', ElComponentType.buttonLabel),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: el(3)),
                Expanded(
                  child: ElButton(
                    key: const Key('share-x'),
                    variant: ElButtonVariant.secondary,
                    label: 'Prepare for X',
                    onPressed: () => _preparePost('X'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const ElIcon.lucide(ElLucide.send, size: ElIconSize.sm),
                        SizedBox(width: ElButton.gapFor(ElButtonSize.md)),
                        ElText('X', ElComponentType.buttonLabel),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        ElDialogFooter(
          children: <Widget>[
            ElButton(
              key: const Key('share-done'),
              variant: ElButtonVariant.ghost,
              onPressed: close,
              child: ElText('Done', ElComponentType.buttonLabel),
            ),
          ],
        ),
      ],
    ),
  );
}
