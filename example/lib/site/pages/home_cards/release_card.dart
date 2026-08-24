/// A live release-distribution card: an empty seed state that creates the
/// first release through a dialog, and a filled state that lists every
/// release with a per-row remove and a footer dialog for adding another —
/// built only from real `El*` components.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

/// One queued release: an id for removal and the title it was created with.
@immutable
class _Release {
  const _Release({required this.id, required this.title});

  final int id;
  final String title;
}

/// Distribute a track: seed one release, then manage the queue.
class ReleaseCard extends StatefulWidget {
  const ReleaseCard({super.key});

  @override
  State<ReleaseCard> createState() => _ReleaseCardState();
}

class _ReleaseCardState extends State<ReleaseCard> {
  final List<_Release> _releases = <_Release>[];
  int _nextId = 0;

  void _add(String title) {
    final String trimmed = title.trim();
    setState(() {
      _releases.add(
        _Release(
          id: _nextId,
          title: trimmed.isEmpty ? 'Untitled release' : trimmed,
        ),
      );
      _nextId += 1;
    });
  }

  void _remove(int id) {
    setState(() {
      _releases.removeWhere((_Release release) => release.id == id);
    });
  }

  /// The one dialog both states open, differing only by trigger.
  Widget _dialog({
    required Widget Function(BuildContext context, VoidCallback open) trigger,
  }) {
    return ElDialog(
      trigger: trigger,
      content: (BuildContext context, VoidCallback close) =>
          _ReleaseTitleDialog(onCreate: _add, onClose: close),
    );
  }

  Widget _emptyState() {
    return ElCardContent(
      child: ElEmpty(
        children: <Widget>[
          const ElEmptyHeader(
            children: <Widget>[
              ElEmptyMedia(glyph: ElIconGlyph.plus, tone: ElIconTone.action),
              ElEmptyTitle('Distribute your first track'),
              ElEmptyDescription(
                'Upload a master and we will start reaching listeners on '
                'the major stores.',
              ),
            ],
          ),
          ElEmptyContent(
            children: <Widget>[
              _dialog(
                trigger: (BuildContext context, VoidCallback open) => ElButton(
                  key: const ValueKey<String>('home-release-create'),
                  onPressed: open,
                  child: const Text('Create release'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(_Release release) {
    return ElItem(
      media: ElItemMedia(
        child: const ElIcon(
          ElIconGlyph.radio,
          size: ElIconSize.sm,
          tone: ElIconTone.muted,
        ),
      ),
      content: ElItemContent(
        children: <Widget>[
          ElItemTitle(release.title),
          const ElItemDescription('Queued for distribution'),
        ],
      ),
      actions: ElItemActions(
        children: <Widget>[
          const ElBadge(label: 'Pending'),
          ElButton(
            key: ValueKey<String>('home-release-remove-${release.id}'),
            variant: ElButtonVariant.ghost,
            size: ElButtonSize.iconSm,
            label: 'Remove ${release.title}',
            onPressed: () => _remove(release.id),
            child: const ElIcon(ElIconGlyph.x, size: ElIconSize.sm),
          ),
        ],
      ),
    );
  }

  List<Widget> _filledState() {
    final int count = _releases.length;
    return <Widget>[
      ElCardHeader(
        title: const ElCardTitle('Releases'),
        description: ElCardDescription(
          '$count release${count == 1 ? '' : 's'} queued for distribution.',
        ),
      ),
      ElCardContent(
        child: ElItemGroup(
          children: <Widget>[
            for (final _Release release in _releases) _row(release),
          ],
        ),
      ),
      ElCardFooter(
        child: _dialog(
          trigger: (BuildContext context, VoidCallback open) => ElButton(
            key: const ValueKey<String>('home-release-add-another'),
            variant: ElButtonVariant.outline,
            contentAlignment: AlignmentDirectional.center,
            onPressed: open,
            child: const Text('Add another release'),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ElCard(
      children: _releases.isEmpty ? <Widget>[_emptyState()] : _filledState(),
    );
  }
}

/// The create-release dialog body: one field, cancel, create.
///
/// A dedicated [StatefulWidget] rather than a controller built inline in the
/// content builder, so [_title] is created once in [initState] and disposed
/// once in [dispose] no matter how many times the surrounding portal rebuilds
/// its overlay while open.
class _ReleaseTitleDialog extends StatefulWidget {
  const _ReleaseTitleDialog({required this.onCreate, required this.onClose});

  final ValueChanged<String> onCreate;
  final VoidCallback onClose;

  @override
  State<_ReleaseTitleDialog> createState() => _ReleaseTitleDialogState();
}

class _ReleaseTitleDialogState extends State<_ReleaseTitleDialog> {
  final TextEditingController _title = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  void _create() {
    widget.onCreate(_title.text);
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return ElDialogContent(
      onClose: widget.onClose,
      children: <Widget>[
        const ElDialogHeader(
          children: <Widget>[ElDialogTitle('Create a release')],
        ),
        ElField(
          label: 'Release title',
          child: ElInput(
            key: const ValueKey<String>('home-release-title-input'),
            controller: _title,
            placeholder: 'My new single',
            onSubmitted: (_) => _create(),
          ),
        ),
        ElDialogFooter(
          children: <Widget>[
            ElButton(
              key: const ValueKey<String>('home-release-dialog-cancel'),
              variant: ElButtonVariant.ghost,
              onPressed: widget.onClose,
              child: const Text('Cancel'),
            ),
            ElButton(
              key: const ValueKey<String>('home-release-dialog-create'),
              onPressed: _create,
              child: const Text('Create'),
            ),
          ],
        ),
      ],
    );
  }
}
