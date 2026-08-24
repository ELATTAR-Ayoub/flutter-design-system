import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import 'showcase_share_dialog.dart';
import 'showcase_shell_scope.dart';

/// Identity-led creator profile for the Signal Studio showcase.
///
/// The shell owns the [toasts] host. This page only emits intentional feedback
/// for profile editing and refresh work.
class SignalStudioProfilePage extends StatefulWidget {
  const SignalStudioProfilePage({super.key, required this.toasts});

  final ElToastController toasts;

  @override
  State<SignalStudioProfilePage> createState() =>
      _SignalStudioProfilePageState();
}

class _SignalStudioProfilePageState extends State<SignalStudioProfilePage> {
  int _tabIndex = 0;
  bool _refreshing = false;
  _ProfileData _profile = const _ProfileData(
    displayName: 'Ari Rocha',
    handle: '@arirocha',
    location: 'Taipei',
    bio:
        'Creative director translating quiet observations into useful visual systems and short-form stories.',
    category: 'Design & culture',
    visibility: 'Public',
    status: 'On air',
    avatarAsset: 'assets/imgs/sample-card.png',
    coverAsset: 'assets/imgs/sample-pack.jpg',
  );

  Future<void> _refresh() async {
    setState(() => _refreshing = true);
    final int toast = widget.toasts.loading(
      'Refreshing profile',
      description: 'Syncing your studio activity.',
    );
    await Future<void>.delayed(ElDurations.slow);
    if (!mounted) return;
    setState(() => _refreshing = false);
    widget.toasts.settle(
      toast,
      const ElToastMessage(
        title: 'Profile is current',
        description: 'Your creator signals are up to date.',
        type: ElToastType.success,
        promise: true,
      ),
    );
  }

  Future<void> _saveProfile(_ProfileData profile) async {
    setState(() => _profile = profile);
    widget.toasts.success(
      'Profile updated',
      description: 'Your public creator details are now current.',
      glyph: ElIconGlyph.circleCheck,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool wide = constraints.maxWidth >= ElBreakpoints.md;
        final double bottomClearance =
            ShowcaseShellScope.bottomOverlayClearanceOf(context);
        return SingleChildScrollView(
          padding: ElSafeArea.scrollPaddingOf(
            context,
            base: EdgeInsets.fromLTRB(
              el(5),
              el(5),
              el(5),
              el(5) + bottomClearance,
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: ElWidths.page),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _ProfileHero(
                    profile: _profile,
                    wide: wide,
                    refreshing: _refreshing,
                    onSave: _saveProfile,
                    toasts: widget.toasts,
                    onRefresh: _refresh,
                  ),
                  SizedBox(height: el(6)),
                  _ProfileStats(wide: wide),
                  SizedBox(height: el(6)),
                  _ProfileDetails(profile: _profile, wide: wide),
                  SizedBox(height: el(6)),
                  ElTabs(
                    selectedIndex: _tabIndex,
                    onChanged: (int index) => setState(() => _tabIndex = index),
                    variant: ElTabsVariant.line,
                    items: <ElTabItem>[
                      ElTabItem(
                        label: wide ? 'Highlights' : 'Work',
                        content: _Highlights(wide: wide),
                      ),
                      const ElTabItem(label: 'Drafts', content: _DraftsEmpty()),
                      ElTabItem(
                        label: wide ? 'Collections' : 'Saved',
                        content: _CollectionsError(
                          onRetry: () => setState(() => _tabIndex = 0),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: el(8)),
                  ElText(
                    'PROFILE SIGNAL',
                    ElType.label,
                    color: theme.mutedForeground,
                  ),
                  SizedBox(height: el(2)),
                  ElAlert(
                    title: 'Your next release has room to grow.',
                    description:
                        'A concise studio note keeps the strongest work visible without asking followers to hunt for it.',
                    variant: ElAlertVariant.info,
                    icon: const ElIcon(
                      ElIconGlyph.sparkles,
                      tone: ElIconTone.inherit,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({
    required this.profile,
    required this.wide,
    required this.refreshing,
    required this.onSave,
    required this.toasts,
    required this.onRefresh,
  });

  final _ProfileData profile;
  final bool wide;
  final bool refreshing;
  final Future<void> Function(_ProfileData profile) onSave;
  final ElToastController toasts;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final Widget identity = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ElAvatar(
          fallback: _initials(profile.displayName),
          image: AssetImage(profile.avatarAsset),
          size: ElAvatarSize.lg,
          badge: ElAvatarBadge(fill: theme.successInk),
        ),
        SizedBox(width: el(4)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ElText(profile.displayName, ElType.h2),
              SizedBox(height: el(1)),
              ElText(
                '${profile.handle} · ${profile.location}',
                ElType.small,
                color: theme.mutedForeground,
              ),
              SizedBox(height: el(3)),
              Wrap(
                spacing: el(2),
                runSpacing: el(2),
                children: <Widget>[
                  ElBadge(
                    label: profile.category.toUpperCase(),
                    variant: ElBadgeVariant.action,
                  ),
                  ElBadge(
                    label: profile.status.toUpperCase(),
                    variant: profile.status == 'On air'
                        ? ElBadgeVariant.success
                        : ElBadgeVariant.secondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
    final Widget actions = Wrap(
      spacing: el(2),
      runSpacing: el(2),
      children: <Widget>[
        ElDialog(
          trigger: (BuildContext context, VoidCallback open) => ElButton(
            key: const Key('profile-edit'),
            variant: ElButtonVariant.primary,
            onPressed: open,
            child: ElText('Edit profile', ElComponentType.buttonLabel),
          ),
          content: (BuildContext context, VoidCallback close) =>
              _ProfileEditor(profile: profile, close: close, onSave: onSave),
        ),
        ShowcaseShareDialog(
          dialogTitle: 'Share profile',
          description:
              'Copy ${profile.displayName}’s public profile link or prepare it for a social post.',
          subject: profile.displayName,
          link: 'https://signal.studio/${profile.handle.substring(1)}',
          toasts: toasts,
          trigger: (BuildContext context, VoidCallback open) => ElButton(
            key: const Key('profile-share'),
            variant: ElButtonVariant.secondary,
            label: 'Share profile',
            onPressed: open,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const ElIcon(ElIconGlyph.share2, size: ElIconSize.sm),
                const _ActionGap(),
                ElText('Share profile', ElComponentType.buttonLabel),
              ],
            ),
          ),
        ),
        ElButton(
          variant: ElButtonVariant.outline,
          loading: refreshing,
          onPressed: refreshing ? null : onRefresh,
          child: ElText('Refresh', ElComponentType.buttonLabel),
        ),
      ],
    );

    return ElGlassPanelDeep(
      radius: BorderRadius.circular(ElRadii.xl2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(ElRadii.xl2),
            ),
            child: SizedBox(
              height: wide ? el(36) : el(28),
              child: Image(
                image: AssetImage(profile.coverAsset),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(el(5)),
            child: wide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(child: identity),
                      SizedBox(width: el(5)),
                      Flexible(child: actions),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      identity,
                      SizedBox(height: el(5)),
                      actions,
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _ActionGap extends StatelessWidget {
  const _ActionGap();

  @override
  Widget build(BuildContext context) => SizedBox(width: el(2));
}

class _ProfileEditor extends StatefulWidget {
  const _ProfileEditor({
    required this.profile,
    required this.close,
    required this.onSave,
  });

  final _ProfileData profile;
  final VoidCallback close;
  final Future<void> Function(_ProfileData profile) onSave;

  @override
  State<_ProfileEditor> createState() => _ProfileEditorState();
}

class _ProfileEditorState extends State<_ProfileEditor> {
  static const List<ElSelectOption<String>> _categories =
      <ElSelectOption<String>>[
        ElSelectOption<String>(
          value: 'Design & culture',
          label: 'Design & culture',
        ),
        ElSelectOption<String>(value: 'Photography', label: 'Photography'),
        ElSelectOption<String>(
          value: 'Creative technology',
          label: 'Creative technology',
        ),
      ];
  static const List<ElSelectOption<String>> _visibilityOptions =
      <ElSelectOption<String>>[
        ElSelectOption<String>(value: 'Public', label: 'Public'),
        ElSelectOption<String>(
          value: 'Followers only',
          label: 'Followers only',
        ),
        ElSelectOption<String>(value: 'Private', label: 'Private'),
      ];
  static const List<ElSelectOption<String>> _statusOptions =
      <ElSelectOption<String>>[
        ElSelectOption<String>(value: 'On air', label: 'On air'),
        ElSelectOption<String>(value: 'Planning', label: 'Planning'),
        ElSelectOption<String>(value: 'Away', label: 'Away'),
      ];

  late final TextEditingController _displayName;
  late final TextEditingController _handle;
  late final TextEditingController _location;
  late final TextEditingController _bio;
  late final FocusNode _displayNameFocus;
  late final FocusNode _handleFocus;
  late final FocusNode _locationFocus;
  late final FocusNode _bioFocus;
  late final FocusNode _categoryFocus;
  late final FocusNode _visibilityFocus;
  late final FocusNode _statusFocus;
  late String _category;
  late String _visibility;
  late String _status;
  late String _avatarAsset;
  late String _coverAsset;
  String? _displayNameError;
  String? _handleError;
  String? _locationError;
  String? _bioError;
  String? _mediaNote;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _displayName = TextEditingController(text: widget.profile.displayName);
    _handle = TextEditingController(text: widget.profile.handle);
    _location = TextEditingController(text: widget.profile.location);
    _bio = TextEditingController(text: widget.profile.bio);
    _displayNameFocus = FocusNode();
    _handleFocus = FocusNode();
    _locationFocus = FocusNode();
    _bioFocus = FocusNode();
    _categoryFocus = FocusNode();
    _visibilityFocus = FocusNode();
    _statusFocus = FocusNode();
    _category = widget.profile.category;
    _visibility = widget.profile.visibility;
    _status = widget.profile.status;
    _avatarAsset = widget.profile.avatarAsset;
    _coverAsset = widget.profile.coverAsset;
  }

  @override
  void dispose() {
    _displayName.dispose();
    _handle.dispose();
    _location.dispose();
    _bio.dispose();
    _displayNameFocus.dispose();
    _handleFocus.dispose();
    _locationFocus.dispose();
    _bioFocus.dispose();
    _categoryFocus.dispose();
    _visibilityFocus.dispose();
    _statusFocus.dispose();
    super.dispose();
  }

  void _selectAvatar() {
    setState(() {
      _avatarAsset = _avatarAsset == 'assets/imgs/sample-card.png'
          ? 'assets/imgs/sample-pack.jpg'
          : 'assets/imgs/sample-card.png';
      _mediaNote = 'A new avatar is selected and ready to save.';
    });
  }

  void _selectCover() {
    setState(() {
      _coverAsset = _coverAsset == 'assets/imgs/sample-pack.jpg'
          ? 'assets/imgs/sample-card.png'
          : 'assets/imgs/sample-pack.jpg';
      _mediaNote = 'A new cover is selected and ready to save.';
    });
  }

  void _clearError(String field) {
    setState(() {
      switch (field) {
        case 'displayName':
          _displayNameError = null;
        case 'handle':
          _handleError = null;
        case 'location':
          _locationError = null;
        case 'bio':
          _bioError = null;
      }
    });
  }

  bool _validate() {
    final String displayName = _displayName.text.trim();
    final String handle = _handle.text.trim();
    final String location = _location.text.trim();
    final String bio = _bio.text.trim();
    final RegExp handlePattern = RegExp(r'^@[A-Za-z0-9_]{3,24}$');

    setState(() {
      _displayNameError = displayName.length < 2
          ? 'Enter a display name with at least 2 characters.'
          : null;
      _handleError = !handlePattern.hasMatch(handle)
          ? 'Use @ followed by 3–24 letters, numbers, or underscores.'
          : null;
      _locationError = location.isEmpty
          ? 'Add the city you create from.'
          : null;
      _bioError = bio.length < 24
          ? 'Tell your audience a little more in at least 24 characters.'
          : bio.length > 160
          ? 'Keep your bio to 160 characters or fewer.'
          : null;
    });

    final FocusNode? firstInvalid = switch ((
      _displayNameError,
      _handleError,
      _locationError,
      _bioError,
    )) {
      (String(), _, _, _) => _displayNameFocus,
      (_, String(), _, _) => _handleFocus,
      (_, _, String(), _) => _locationFocus,
      (_, _, _, String()) => _bioFocus,
      _ => null,
    };
    firstInvalid?.requestFocus();
    return firstInvalid == null;
  }

  Future<void> _save() async {
    if (_saving || !_validate()) return;
    setState(() => _saving = true);
    await Future<void>.delayed(ElDurations.base);
    if (!mounted) return;
    await widget.onSave(
      _ProfileData(
        displayName: _displayName.text.trim(),
        handle: _handle.text.trim(),
        location: _location.text.trim(),
        bio: _bio.text.trim(),
        category: _category,
        visibility: _visibility,
        status: _status,
        avatarAsset: _avatarAsset,
        coverAsset: _coverAsset,
      ),
    );
    if (!mounted) return;
    widget.close();
  }

  List<String> _errors(String? message) =>
      message == null ? const <String>[] : <String>[message];

  @override
  Widget build(BuildContext context) {
    return ElDialogContent(
      onClose: _saving ? null : widget.close,
      children: <Widget>[
        const ElDialogHeader(
          children: <Widget>[
            ElDialogTitle('Edit creator profile'),
            ElDialogDescription(
              'Shape the identity and publishing signals your audience sees.',
            ),
          ],
        ),
        ElFieldGroup(
          children: <Widget>[
            _ProfileMediaEditor(
              profile: widget.profile,
              avatarAsset: _avatarAsset,
              coverAsset: _coverAsset,
              note: _mediaNote,
              enabled: !_saving,
              onAvatar: _selectAvatar,
              onCover: _selectCover,
            ),
            ElField(
              label: 'Display name',
              errors: _errors(_displayNameError),
              focusNode: _displayNameFocus,
              enabled: !_saving,
              child: ElInput(
                key: const Key('profile-display-name'),
                controller: _displayName,
                focusNode: _displayNameFocus,
                enabled: !_saving,
                autofillHints: const <String>[AutofillHints.name],
                onChanged: (_) => _clearError('displayName'),
              ),
            ),
            ElField(
              label: 'Handle',
              description:
                  'Starts with @ and becomes part of your public link.',
              errors: _errors(_handleError),
              focusNode: _handleFocus,
              enabled: !_saving,
              child: ElInput(
                key: const Key('profile-handle'),
                controller: _handle,
                focusNode: _handleFocus,
                enabled: !_saving,
                onChanged: (_) => _clearError('handle'),
              ),
            ),
            ElField(
              label: 'Location',
              errors: _errors(_locationError),
              focusNode: _locationFocus,
              enabled: !_saving,
              child: ElInput(
                key: const Key('profile-location'),
                controller: _location,
                focusNode: _locationFocus,
                enabled: !_saving,
                autofillHints: const <String>[AutofillHints.addressCity],
                onChanged: (_) => _clearError('location'),
              ),
            ),
            ElField(
              label: 'Bio',
              description: '24–160 characters. Keep it useful and specific.',
              errors: _errors(_bioError),
              focusNode: _bioFocus,
              enabled: !_saving,
              child: ElTextarea(
                key: const Key('profile-bio'),
                controller: _bio,
                focusNode: _bioFocus,
                enabled: !_saving,
                onChanged: (_) => _clearError('bio'),
              ),
            ),
            ElField(
              label: 'Category',
              focusNode: _categoryFocus,
              enabled: !_saving,
              child: ElSelect<String>(
                key: const Key('profile-category'),
                options: _categories,
                value: _category,
                onChanged: _saving
                    ? null
                    : (String value) => setState(() => _category = value),
                enabled: !_saving,
                expand: true,
                focusNode: _categoryFocus,
              ),
            ),
            ElField(
              label: 'Profile visibility',
              description: 'Choose who can discover this creator profile.',
              focusNode: _visibilityFocus,
              enabled: !_saving,
              child: ElSelect<String>(
                key: const Key('profile-visibility'),
                options: _visibilityOptions,
                value: _visibility,
                onChanged: _saving
                    ? null
                    : (String value) => setState(() => _visibility = value),
                enabled: !_saving,
                expand: true,
                focusNode: _visibilityFocus,
              ),
            ),
            ElField(
              label: 'Studio status',
              description: 'A short availability signal shown near your name.',
              focusNode: _statusFocus,
              enabled: !_saving,
              child: ElSelect<String>(
                key: const Key('profile-status'),
                options: _statusOptions,
                value: _status,
                onChanged: _saving
                    ? null
                    : (String value) => setState(() => _status = value),
                enabled: !_saving,
                expand: true,
                focusNode: _statusFocus,
              ),
            ),
          ],
        ),
        ElDialogFooter(
          children: <Widget>[
            ElButton(
              key: const Key('profile-cancel'),
              variant: ElButtonVariant.ghost,
              onPressed: _saving ? null : widget.close,
              child: ElText('Cancel', ElComponentType.buttonLabel),
            ),
            ElButton(
              key: const Key('profile-save'),
              loading: _saving,
              onPressed: _saving ? null : _save,
              child: ElText('Save changes', ElComponentType.buttonLabel),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProfileMediaEditor extends StatelessWidget {
  const _ProfileMediaEditor({
    required this.profile,
    required this.avatarAsset,
    required this.coverAsset,
    required this.note,
    required this.enabled,
    required this.onAvatar,
    required this.onCover,
  });

  final _ProfileData profile;
  final String avatarAsset;
  final String coverAsset;
  final String? note;
  final bool enabled;
  final VoidCallback onAvatar;
  final VoidCallback onCover;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return ElCard(
      children: <Widget>[
        const ElCardHeader(
          title: ElCardTitle('Profile media'),
          description: ElCardDescription(
            'Preview a supplied studio image before committing it.',
          ),
        ),
        ElCardContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(ElRadii.lg),
                child: SizedBox(
                  height: el(20),
                  child: Image(
                    image: AssetImage(coverAsset),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: el(3)),
              Row(
                children: <Widget>[
                  ElAvatar(
                    fallback: _initials(profile.displayName),
                    image: AssetImage(avatarAsset),
                    size: ElAvatarSize.md,
                  ),
                  SizedBox(width: el(3)),
                  Expanded(
                    child: ElText(
                      'Avatar and cover preview',
                      ElType.small,
                      color: theme.mutedForeground,
                    ),
                  ),
                ],
              ),
              SizedBox(height: el(3)),
              Wrap(
                spacing: el(2),
                runSpacing: el(2),
                children: <Widget>[
                  ElButton(
                    key: const Key('profile-change-avatar'),
                    size: ElButtonSize.sm,
                    variant: ElButtonVariant.outline,
                    onPressed: enabled ? onAvatar : null,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const ElIcon.lucide(
                          ElLucide.camera,
                          size: ElIconSize.sm,
                        ),
                        const _ActionGap(),
                        ElText('Change avatar', ElComponentType.buttonLabelSm),
                      ],
                    ),
                  ),
                  ElButton(
                    key: const Key('profile-change-cover'),
                    size: ElButtonSize.sm,
                    variant: ElButtonVariant.outline,
                    onPressed: enabled ? onCover : null,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const ElIcon.lucide(
                          ElLucide.image,
                          size: ElIconSize.sm,
                        ),
                        const _ActionGap(),
                        ElText('Change cover', ElComponentType.buttonLabelSm),
                      ],
                    ),
                  ),
                ],
              ),
              if (note != null) ...<Widget>[
                SizedBox(height: el(3)),
                ElAlert(
                  title: 'Media selection ready',
                  description: note!,
                  variant: ElAlertVariant.info,
                  icon: const ElIcon(
                    ElIconGlyph.info,
                    tone: ElIconTone.inherit,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileDetails extends StatelessWidget {
  const _ProfileDetails({required this.profile, required this.wide});

  final _ProfileData profile;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final List<Widget> facts = <Widget>[
      _ProfileFact(
        glyph: ElLucide.mapPin,
        label: 'Based in',
        value: profile.location,
      ),
      _ProfileFact(
        glyph: ElLucide.palette,
        label: 'Category',
        value: profile.category,
      ),
      _ProfileFact(
        glyph: profile.visibility == 'Public' ? ElLucide.globe : ElLucide.lock,
        label: 'Visibility',
        value: profile.visibility,
      ),
      _ProfileFact(
        glyph: ElLucide.activity,
        label: 'Studio status',
        value: profile.status,
      ),
    ];
    final Widget factGrid = wide
        ? Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(child: facts[0]),
                  SizedBox(width: el(3)),
                  Expanded(child: facts[1]),
                ],
              ),
              SizedBox(height: el(3)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(child: facts[2]),
                  SizedBox(width: el(3)),
                  Expanded(child: facts[3]),
                ],
              ),
            ],
          )
        : Column(
            children: <Widget>[
              for (int index = 0; index < facts.length; index++) ...<Widget>[
                facts[index],
                if (index < facts.length - 1) SizedBox(height: el(3)),
              ],
            ],
          );
    return ElCard(
      children: <Widget>[
        const ElCardHeader(
          title: ElCardTitle('About the creator'),
          description: ElCardDescription(
            'The public context behind the work and its availability.',
          ),
        ),
        ElCardContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElText(profile.bio, ElType.body),
              SizedBox(height: el(4)),
              factGrid,
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileFact extends StatelessWidget {
  const _ProfileFact({
    required this.glyph,
    required this.label,
    required this.value,
  });

  final ElLucideGlyph glyph;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => ElItem(
    variant: ElItemVariant.outline,
    media: ElItemMedia(child: ElIcon.lucide(glyph, tone: ElIconTone.muted)),
    content: ElItemContent(
      children: <Widget>[ElItemTitle(label), ElItemDescription(value)],
    ),
  );
}

class _ProfileData {
  const _ProfileData({
    required this.displayName,
    required this.handle,
    required this.location,
    required this.bio,
    required this.category,
    required this.visibility,
    required this.status,
    required this.avatarAsset,
    required this.coverAsset,
  });

  final String displayName;
  final String handle;
  final String location;
  final String bio;
  final String category;
  final String visibility;
  final String status;
  final String avatarAsset;
  final String coverAsset;
}

String _initials(String displayName) {
  final List<String> words = displayName
      .trim()
      .split(RegExp(r'\s+'))
      .where((String word) => word.isNotEmpty)
      .toList();
  if (words.isEmpty) return 'SS';
  if (words.length == 1) return words.first.substring(0, 1).toUpperCase();
  return '${words.first.substring(0, 1)}${words.last.substring(0, 1)}'
      .toUpperCase();
}

class _ProfileStats extends StatelessWidget {
  const _ProfileStats({required this.wide});

  final bool wide;

  @override
  Widget build(BuildContext context) {
    const List<ElStat> stats = <ElStat>[
      ElStat(
        label: 'FOLLOWERS',
        value: '84.2K',
        delta: (value: '12.8%', direction: ElStatDirection.up),
      ),
      ElStat(
        label: 'REACH',
        value: '1.8M',
        delta: (value: '8.4%', direction: ElStatDirection.up),
      ),
      ElStat(
        label: 'SAVES',
        value: '14.6K',
        delta: (value: '2.1%', direction: ElStatDirection.up),
      ),
    ];
    return ElCard(
      children: <Widget>[
        const ElCardHeader(
          title: ElCardTitle('Studio pulse'),
          description: ElCardDescription(
            'A compact read on the audience you are building.',
          ),
        ),
        ElCardContent(
          child: wide
              ? Row(
                  children: <Widget>[
                    for (
                      int index = 0;
                      index < stats.length;
                      index++
                    ) ...<Widget>[
                      Expanded(child: stats[index]),
                      if (index < stats.length - 1) SizedBox(width: el(5)),
                    ],
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    for (
                      int index = 0;
                      index < stats.length;
                      index++
                    ) ...<Widget>[
                      stats[index],
                      if (index < stats.length - 1) SizedBox(height: el(5)),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}

class _Highlights extends StatelessWidget {
  const _Highlights({required this.wide});

  final bool wide;

  @override
  Widget build(BuildContext context) {
    final List<Widget> cards = <Widget>[
      const _HighlightCard(
        asset: AssetImage('assets/imgs/sample-card.png'),
        eyebrow: 'LATEST REEL',
        title: 'A quiet system for louder work',
        meta: '28.6K plays · 4.3K saves',
      ),
      const _HighlightCard(
        asset: AssetImage('assets/imgs/sample-pack.jpg'),
        eyebrow: 'COLLECTION',
        title: 'Field notes from the night desk',
        meta: '12 objects · Updated today',
      ),
    ];
    return wide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(child: cards[0]),
              SizedBox(width: el(4)),
              Expanded(child: cards[1]),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              cards[0],
              SizedBox(height: el(4)),
              cards[1],
            ],
          );
  }
}

class _HighlightCard extends StatelessWidget {
  const _HighlightCard({
    required this.asset,
    required this.eyebrow,
    required this.title,
    required this.meta,
  });

  final ImageProvider<Object> asset;
  final String eyebrow;
  final String title;
  final String meta;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return ElCard(
      children: <Widget>[
        ElCardContent(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(ElRadii.lg),
            child: SizedBox(
              height: el(32),
              child: Image(image: asset, fit: BoxFit.cover),
            ),
          ),
        ),
        ElCardContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ElText(eyebrow, ElType.label, color: theme.mutedForeground),
              SizedBox(height: el(2)),
              ElText(title, ElType.h4),
              SizedBox(height: el(2)),
              ElText(meta, ElType.small, color: theme.mutedForeground),
            ],
          ),
        ),
      ],
    );
  }
}

class _DraftsEmpty extends StatelessWidget {
  const _DraftsEmpty();

  @override
  Widget build(BuildContext context) => ElCard(
    children: const <Widget>[
      ElCardContent(
        child: ElEmpty(
          children: <Widget>[
            ElEmptyHeader(
              children: <Widget>[
                ElEmptyMedia(glyph: ElIconGlyph.packageOpen),
                ElEmptyTitle('No drafts are waiting.'),
                ElEmptyDescription(
                  'Your next idea can begin as a short note or a saved reel.',
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

class _CollectionsError extends StatelessWidget {
  const _CollectionsError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => ElAlert(
    title: 'Collections could not load.',
    description:
        'Your saved work is safe. Try reconnecting to your studio feed.',
    variant: ElAlertVariant.destructive,
    icon: const ElIcon(ElIconGlyph.circleX, tone: ElIconTone.inherit),
    action: ElButton(
      size: ElButtonSize.sm,
      variant: ElButtonVariant.secondary,
      onPressed: onRetry,
      child: ElText('Retry', ElComponentType.buttonLabelSm),
    ),
  );
}
