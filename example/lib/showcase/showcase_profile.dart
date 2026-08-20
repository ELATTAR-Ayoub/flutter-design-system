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

  final DsToastController toasts;

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
    await Future<void>.delayed(DsDurations.slow);
    if (!mounted) return;
    setState(() => _refreshing = false);
    widget.toasts.settle(
      toast,
      const DsToastMessage(
        title: 'Profile is current',
        description: 'Your creator signals are up to date.',
        type: DsToastType.success,
        promise: true,
      ),
    );
  }

  Future<void> _saveProfile(_ProfileData profile) async {
    setState(() => _profile = profile);
    widget.toasts.success(
      'Profile updated',
      description: 'Your public creator details are now current.',
      glyph: DsIconGlyph.circleCheck,
    );
  }

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool wide = constraints.maxWidth >= DsBreakpoints.md;
        final double bottomClearance =
            ShowcaseShellScope.bottomOverlayClearanceOf(context);
        return SingleChildScrollView(
          padding: DsSafeArea.scrollPaddingOf(
            context,
            base: EdgeInsets.fromLTRB(
              ds(5),
              ds(5),
              ds(5),
              ds(5) + bottomClearance,
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: DsWidths.page),
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
                  SizedBox(height: ds(6)),
                  _ProfileStats(wide: wide),
                  SizedBox(height: ds(6)),
                  _ProfileDetails(profile: _profile, wide: wide),
                  SizedBox(height: ds(6)),
                  DsTabs(
                    selectedIndex: _tabIndex,
                    onChanged: (int index) => setState(() => _tabIndex = index),
                    variant: DsTabsVariant.line,
                    items: <DsTabItem>[
                      DsTabItem(
                        label: wide ? 'Highlights' : 'Work',
                        content: _Highlights(wide: wide),
                      ),
                      const DsTabItem(label: 'Drafts', content: _DraftsEmpty()),
                      DsTabItem(
                        label: wide ? 'Collections' : 'Saved',
                        content: _CollectionsError(
                          onRetry: () => setState(() => _tabIndex = 0),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ds(8)),
                  DsText(
                    'PROFILE SIGNAL',
                    DsType.label,
                    color: theme.mutedForeground,
                  ),
                  SizedBox(height: ds(2)),
                  DsAlert(
                    title: 'Your next release has room to grow.',
                    description:
                        'A concise studio note keeps the strongest work visible without asking followers to hunt for it.',
                    variant: DsAlertVariant.info,
                    icon: const DsIcon(
                      DsIconGlyph.sparkles,
                      tone: DsIconTone.inherit,
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
  final DsToastController toasts;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final Widget identity = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DsAvatar(
          fallback: _initials(profile.displayName),
          image: AssetImage(profile.avatarAsset),
          size: DsAvatarSize.lg,
          badge: DsAvatarBadge(fill: theme.successInk),
        ),
        SizedBox(width: ds(4)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DsText(profile.displayName, DsType.h2),
              SizedBox(height: ds(1)),
              DsText(
                '${profile.handle} · ${profile.location}',
                DsType.small,
                color: theme.mutedForeground,
              ),
              SizedBox(height: ds(3)),
              Wrap(
                spacing: ds(2),
                runSpacing: ds(2),
                children: <Widget>[
                  DsBadge(
                    label: profile.category.toUpperCase(),
                    variant: DsBadgeVariant.action,
                  ),
                  DsBadge(
                    label: profile.status.toUpperCase(),
                    variant: profile.status == 'On air'
                        ? DsBadgeVariant.success
                        : DsBadgeVariant.secondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
    final Widget actions = Wrap(
      spacing: ds(2),
      runSpacing: ds(2),
      children: <Widget>[
        DsDialog(
          trigger: (BuildContext context, VoidCallback open) => DsButton(
            key: const Key('profile-edit'),
            variant: DsButtonVariant.primary,
            onPressed: open,
            child: DsText('Edit profile', DsComponentType.buttonLabel),
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
          trigger: (BuildContext context, VoidCallback open) => DsButton(
            key: const Key('profile-share'),
            variant: DsButtonVariant.secondary,
            label: 'Share profile',
            onPressed: open,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const DsIcon(DsIconGlyph.share2, size: DsIconSize.sm),
                const _ActionGap(),
                DsText('Share profile', DsComponentType.buttonLabel),
              ],
            ),
          ),
        ),
        DsButton(
          variant: DsButtonVariant.outline,
          loading: refreshing,
          onPressed: refreshing ? null : onRefresh,
          child: DsText('Refresh', DsComponentType.buttonLabel),
        ),
      ],
    );

    return DsGlassPanelDeep(
      radius: BorderRadius.circular(DsRadii.xl2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(DsRadii.xl2),
            ),
            child: SizedBox(
              height: wide ? ds(36) : ds(28),
              child: Image(
                image: AssetImage(profile.coverAsset),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(ds(5)),
            child: wide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(child: identity),
                      SizedBox(width: ds(5)),
                      Flexible(child: actions),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      identity,
                      SizedBox(height: ds(5)),
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
  Widget build(BuildContext context) => SizedBox(width: ds(2));
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
  static const List<DsSelectOption<String>> _categories =
      <DsSelectOption<String>>[
        DsSelectOption<String>(
          value: 'Design & culture',
          label: 'Design & culture',
        ),
        DsSelectOption<String>(value: 'Photography', label: 'Photography'),
        DsSelectOption<String>(
          value: 'Creative technology',
          label: 'Creative technology',
        ),
      ];
  static const List<DsSelectOption<String>> _visibilityOptions =
      <DsSelectOption<String>>[
        DsSelectOption<String>(value: 'Public', label: 'Public'),
        DsSelectOption<String>(
          value: 'Followers only',
          label: 'Followers only',
        ),
        DsSelectOption<String>(value: 'Private', label: 'Private'),
      ];
  static const List<DsSelectOption<String>> _statusOptions =
      <DsSelectOption<String>>[
        DsSelectOption<String>(value: 'On air', label: 'On air'),
        DsSelectOption<String>(value: 'Planning', label: 'Planning'),
        DsSelectOption<String>(value: 'Away', label: 'Away'),
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
    await Future<void>.delayed(DsDurations.base);
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
    return DsDialogContent(
      onClose: _saving ? null : widget.close,
      children: <Widget>[
        const DsDialogHeader(
          children: <Widget>[
            DsDialogTitle('Edit creator profile'),
            DsDialogDescription(
              'Shape the identity and publishing signals your audience sees.',
            ),
          ],
        ),
        DsFieldGroup(
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
            DsField(
              label: 'Display name',
              errors: _errors(_displayNameError),
              focusNode: _displayNameFocus,
              enabled: !_saving,
              child: DsInput(
                key: const Key('profile-display-name'),
                controller: _displayName,
                focusNode: _displayNameFocus,
                enabled: !_saving,
                autofillHints: const <String>[AutofillHints.name],
                onChanged: (_) => _clearError('displayName'),
              ),
            ),
            DsField(
              label: 'Handle',
              description:
                  'Starts with @ and becomes part of your public link.',
              errors: _errors(_handleError),
              focusNode: _handleFocus,
              enabled: !_saving,
              child: DsInput(
                key: const Key('profile-handle'),
                controller: _handle,
                focusNode: _handleFocus,
                enabled: !_saving,
                onChanged: (_) => _clearError('handle'),
              ),
            ),
            DsField(
              label: 'Location',
              errors: _errors(_locationError),
              focusNode: _locationFocus,
              enabled: !_saving,
              child: DsInput(
                key: const Key('profile-location'),
                controller: _location,
                focusNode: _locationFocus,
                enabled: !_saving,
                autofillHints: const <String>[AutofillHints.addressCity],
                onChanged: (_) => _clearError('location'),
              ),
            ),
            DsField(
              label: 'Bio',
              description: '24–160 characters. Keep it useful and specific.',
              errors: _errors(_bioError),
              focusNode: _bioFocus,
              enabled: !_saving,
              child: DsTextarea(
                key: const Key('profile-bio'),
                controller: _bio,
                focusNode: _bioFocus,
                enabled: !_saving,
                onChanged: (_) => _clearError('bio'),
              ),
            ),
            DsField(
              label: 'Category',
              focusNode: _categoryFocus,
              enabled: !_saving,
              child: DsSelect<String>(
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
            DsField(
              label: 'Profile visibility',
              description: 'Choose who can discover this creator profile.',
              focusNode: _visibilityFocus,
              enabled: !_saving,
              child: DsSelect<String>(
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
            DsField(
              label: 'Studio status',
              description: 'A short availability signal shown near your name.',
              focusNode: _statusFocus,
              enabled: !_saving,
              child: DsSelect<String>(
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
        DsDialogFooter(
          children: <Widget>[
            DsButton(
              key: const Key('profile-cancel'),
              variant: DsButtonVariant.ghost,
              onPressed: _saving ? null : widget.close,
              child: DsText('Cancel', DsComponentType.buttonLabel),
            ),
            DsButton(
              key: const Key('profile-save'),
              loading: _saving,
              onPressed: _saving ? null : _save,
              child: DsText('Save changes', DsComponentType.buttonLabel),
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
    final DsThemeData theme = DsTheme.of(context);
    return DsCard(
      children: <Widget>[
        const DsCardHeader(
          title: DsCardTitle('Profile media'),
          description: DsCardDescription(
            'Preview a supplied studio image before committing it.',
          ),
        ),
        DsCardContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(DsRadii.lg),
                child: SizedBox(
                  height: ds(20),
                  child: Image(
                    image: AssetImage(coverAsset),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: ds(3)),
              Row(
                children: <Widget>[
                  DsAvatar(
                    fallback: _initials(profile.displayName),
                    image: AssetImage(avatarAsset),
                    size: DsAvatarSize.md,
                  ),
                  SizedBox(width: ds(3)),
                  Expanded(
                    child: DsText(
                      'Avatar and cover preview',
                      DsType.small,
                      color: theme.mutedForeground,
                    ),
                  ),
                ],
              ),
              SizedBox(height: ds(3)),
              Wrap(
                spacing: ds(2),
                runSpacing: ds(2),
                children: <Widget>[
                  DsButton(
                    key: const Key('profile-change-avatar'),
                    size: DsButtonSize.sm,
                    variant: DsButtonVariant.outline,
                    onPressed: enabled ? onAvatar : null,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const DsIcon.lucide(
                          DsLucide.camera,
                          size: DsIconSize.sm,
                        ),
                        const _ActionGap(),
                        DsText('Change avatar', DsComponentType.buttonLabelSm),
                      ],
                    ),
                  ),
                  DsButton(
                    key: const Key('profile-change-cover'),
                    size: DsButtonSize.sm,
                    variant: DsButtonVariant.outline,
                    onPressed: enabled ? onCover : null,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const DsIcon.lucide(
                          DsLucide.image,
                          size: DsIconSize.sm,
                        ),
                        const _ActionGap(),
                        DsText('Change cover', DsComponentType.buttonLabelSm),
                      ],
                    ),
                  ),
                ],
              ),
              if (note != null) ...<Widget>[
                SizedBox(height: ds(3)),
                DsAlert(
                  title: 'Media selection ready',
                  description: note!,
                  variant: DsAlertVariant.info,
                  icon: const DsIcon(
                    DsIconGlyph.info,
                    tone: DsIconTone.inherit,
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
        glyph: DsLucide.mapPin,
        label: 'Based in',
        value: profile.location,
      ),
      _ProfileFact(
        glyph: DsLucide.palette,
        label: 'Category',
        value: profile.category,
      ),
      _ProfileFact(
        glyph: profile.visibility == 'Public' ? DsLucide.globe : DsLucide.lock,
        label: 'Visibility',
        value: profile.visibility,
      ),
      _ProfileFact(
        glyph: DsLucide.activity,
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
                  SizedBox(width: ds(3)),
                  Expanded(child: facts[1]),
                ],
              ),
              SizedBox(height: ds(3)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(child: facts[2]),
                  SizedBox(width: ds(3)),
                  Expanded(child: facts[3]),
                ],
              ),
            ],
          )
        : Column(
            children: <Widget>[
              for (int index = 0; index < facts.length; index++) ...<Widget>[
                facts[index],
                if (index < facts.length - 1) SizedBox(height: ds(3)),
              ],
            ],
          );
    return DsCard(
      children: <Widget>[
        const DsCardHeader(
          title: DsCardTitle('About the creator'),
          description: DsCardDescription(
            'The public context behind the work and its availability.',
          ),
        ),
        DsCardContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DsText(profile.bio, DsType.body),
              SizedBox(height: ds(4)),
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

  final DsLucideGlyph glyph;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => DsItem(
    variant: DsItemVariant.outline,
    media: DsItemMedia(child: DsIcon.lucide(glyph, tone: DsIconTone.muted)),
    content: DsItemContent(
      children: <Widget>[DsItemTitle(label), DsItemDescription(value)],
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
    const List<DsStat> stats = <DsStat>[
      DsStat(
        label: 'FOLLOWERS',
        value: '84.2K',
        delta: (value: '12.8%', direction: DsStatDirection.up),
      ),
      DsStat(
        label: 'REACH',
        value: '1.8M',
        delta: (value: '8.4%', direction: DsStatDirection.up),
      ),
      DsStat(
        label: 'SAVES',
        value: '14.6K',
        delta: (value: '2.1%', direction: DsStatDirection.up),
      ),
    ];
    return DsCard(
      children: <Widget>[
        const DsCardHeader(
          title: DsCardTitle('Studio pulse'),
          description: DsCardDescription(
            'A compact read on the audience you are building.',
          ),
        ),
        DsCardContent(
          child: wide
              ? Row(
                  children: <Widget>[
                    for (
                      int index = 0;
                      index < stats.length;
                      index++
                    ) ...<Widget>[
                      Expanded(child: stats[index]),
                      if (index < stats.length - 1) SizedBox(width: ds(5)),
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
                      if (index < stats.length - 1) SizedBox(height: ds(5)),
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
              SizedBox(width: ds(4)),
              Expanded(child: cards[1]),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              cards[0],
              SizedBox(height: ds(4)),
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
    final DsThemeData theme = DsTheme.of(context);
    return DsCard(
      children: <Widget>[
        DsCardContent(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(DsRadii.lg),
            child: SizedBox(
              height: ds(32),
              child: Image(image: asset, fit: BoxFit.cover),
            ),
          ),
        ),
        DsCardContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DsText(eyebrow, DsType.label, color: theme.mutedForeground),
              SizedBox(height: ds(2)),
              DsText(title, DsType.h4),
              SizedBox(height: ds(2)),
              DsText(meta, DsType.small, color: theme.mutedForeground),
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
  Widget build(BuildContext context) => DsCard(
    children: const <Widget>[
      DsCardContent(
        child: DsEmpty(
          children: <Widget>[
            DsEmptyHeader(
              children: <Widget>[
                DsEmptyMedia(glyph: DsIconGlyph.packageOpen),
                DsEmptyTitle('No drafts are waiting.'),
                DsEmptyDescription(
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
  Widget build(BuildContext context) => DsAlert(
    title: 'Collections could not load.',
    description:
        'Your saved work is safe. Try reconnecting to your studio feed.',
    variant: DsAlertVariant.destructive,
    icon: const DsIcon(DsIconGlyph.circleX, tone: DsIconTone.inherit),
    action: DsButton(
      size: DsButtonSize.sm,
      variant: DsButtonVariant.secondary,
      onPressed: onRetry,
      child: DsText('Retry', DsComponentType.buttonLabelSm),
    ),
  );
}
