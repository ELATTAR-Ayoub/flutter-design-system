import 'package:elattar_design_system/elattar_design_system.dart';
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

import 'showcase_share_dialog.dart';
import 'showcase_shell_scope.dart';

/// Identity-led creator profile for the Signal Studio showcase.
///
/// The shell owns the [toasts] host. This page only emits intentional feedback
/// for profile editing and refresh work.
class SignalStudioProfilePage extends StatefulWidget {
  const SignalStudioProfilePage({super.key, required this.toasts});

  final ToastController toasts;

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
    await Future<void>.delayed(MotionDurations.slow);
    if (!mounted) return;
    setState(() => _refreshing = false);
    widget.toasts.settle(
      toast,
      const ToastMessage(
        title: 'Profile is current',
        description: 'Your creator signals are up to date.',
        type: ToastType.success,
        promise: true,
      ),
    );
  }

  Future<void> _saveProfile(_ProfileData profile) async {
    setState(() => _profile = profile);
    widget.toasts.success(
      'Profile updated',
      description: 'Your public creator details are now current.',
      glyph: IconGlyph.circleCheck,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool wide = constraints.maxWidth >= Breakpoints.md;
        final double bottomClearance =
            ShowcaseShellScope.bottomOverlayClearanceOf(context);
        return SingleChildScrollView(
          padding: SafeArea.scrollPaddingOf(
            context,
            base: EdgeInsets.fromLTRB(
              space(5),
              space(5),
              space(5),
              space(5) + bottomClearance,
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: LayoutWidths.page),
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
                  SizedBox(height: space(6)),
                  _ProfileStats(wide: wide),
                  SizedBox(height: space(6)),
                  _ProfileDetails(profile: _profile, wide: wide),
                  SizedBox(height: space(6)),
                  Tabs(
                    selectedIndex: _tabIndex,
                    onChanged: (int index) => setState(() => _tabIndex = index),
                    variant: TabsVariant.line,
                    items: <TabItem>[
                      TabItem(
                        label: wide ? 'Highlights' : 'Work',
                        content: _Highlights(wide: wide),
                      ),
                      const TabItem(label: 'Drafts', content: _DraftsEmpty()),
                      TabItem(
                        label: wide ? 'Collections' : 'Saved',
                        content: _CollectionsError(
                          onRetry: () => setState(() => _tabIndex = 0),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: space(8)),
                  StyledText(
                    'PROFILE SIGNAL',
                    TextStyles.small,
                    color: theme.mutedForeground,
                  ),
                  SizedBox(height: space(2)),
                  Alert(
                    title: 'Your next release has room to grow.',
                    description:
                        'A concise studio note keeps the strongest work visible without asking followers to hunt for it.',
                    variant: AlertVariant.info,
                    icon: const Icon(
                      IconGlyph.sparkles,
                      tone: IconTone.inherit,
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
  final ToastController toasts;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final Widget identity = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Avatar(
          fallback: _initials(profile.displayName),
          image: AssetImage(profile.avatarAsset),
          size: AvatarSize.lg,
          badge: AvatarBadge(fill: theme.successText),
        ),
        SizedBox(width: space(4)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StyledText(profile.displayName, TextStyles.h2),
              SizedBox(height: space(1)),
              StyledText(
                '${profile.handle} · ${profile.location}',
                TextStyles.small,
                color: theme.mutedForeground,
              ),
              SizedBox(height: space(3)),
              Wrap(
                spacing: space(2),
                runSpacing: space(2),
                children: <Widget>[
                  Badge(
                    label: profile.category.toUpperCase(),
                    variant: BadgeVariant.action,
                  ),
                  Badge(
                    label: profile.status.toUpperCase(),
                    variant: profile.status == 'On air'
                        ? BadgeVariant.success
                        : BadgeVariant.secondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
    final Widget actions = Wrap(
      spacing: space(2),
      runSpacing: space(2),
      children: <Widget>[
        Dialog(
          trigger: (BuildContext context, VoidCallback open) => Button(
            key: const Key('profile-edit'),
            variant: ButtonVariant.primary,
            onPressed: open,
            child: StyledText('Edit profile', TextStyles.nav),
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
          trigger: (BuildContext context, VoidCallback open) => Button(
            key: const Key('profile-share'),
            variant: ButtonVariant.secondary,
            label: 'Share profile',
            onPressed: open,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(IconGlyph.share2, size: IconSize.sm),
                const _ActionGap(),
                StyledText('Share profile', TextStyles.nav),
              ],
            ),
          ),
        ),
        Button(
          variant: ButtonVariant.outline,
          loading: refreshing,
          onPressed: refreshing ? null : onRefresh,
          child: StyledText('Refresh', TextStyles.nav),
        ),
      ],
    );

    return Glass(
      variant: GlassVariant.prominent,
      radius: BorderRadius.circular(Radii.xl2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(Radii.xl2),
            ),
            child: SizedBox(
              height: wide ? space(36) : space(28),
              child: Image(
                image: AssetImage(profile.coverAsset),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(space(5)),
            child: wide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(child: identity),
                      SizedBox(width: space(5)),
                      Flexible(child: actions),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      identity,
                      SizedBox(height: space(5)),
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
  Widget build(BuildContext context) => SizedBox(width: space(2));
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
  static const List<SelectOption<String>> _categories = <SelectOption<String>>[
    SelectOption<String>(value: 'Design & culture', label: 'Design & culture'),
    SelectOption<String>(value: 'Photography', label: 'Photography'),
    SelectOption<String>(
      value: 'Creative technology',
      label: 'Creative technology',
    ),
  ];
  static const List<SelectOption<String>> _visibilityOptions =
      <SelectOption<String>>[
        SelectOption<String>(value: 'Public', label: 'Public'),
        SelectOption<String>(value: 'Followers only', label: 'Followers only'),
        SelectOption<String>(value: 'Private', label: 'Private'),
      ];
  static const List<SelectOption<String>> _statusOptions =
      <SelectOption<String>>[
        SelectOption<String>(value: 'On air', label: 'On air'),
        SelectOption<String>(value: 'Planning', label: 'Planning'),
        SelectOption<String>(value: 'Away', label: 'Away'),
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
    await Future<void>.delayed(MotionDurations.normal);
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
    return DialogContent(
      onClose: _saving ? null : widget.close,
      children: <Widget>[
        const DialogHeader(
          children: <Widget>[
            DialogTitle('Edit creator profile'),
            DialogDescription(
              'Shape the identity and publishing signals your audience sees.',
            ),
          ],
        ),
        FieldGroup(
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
            Field(
              label: 'Display name',
              errors: _errors(_displayNameError),
              focusNode: _displayNameFocus,
              enabled: !_saving,
              child: Input(
                key: const Key('profile-display-name'),
                controller: _displayName,
                focusNode: _displayNameFocus,
                enabled: !_saving,
                autofillHints: const <String>[AutofillHints.name],
                onChanged: (_) => _clearError('displayName'),
              ),
            ),
            Field(
              label: 'Handle',
              description:
                  'Starts with @ and becomes part of your public link.',
              errors: _errors(_handleError),
              focusNode: _handleFocus,
              enabled: !_saving,
              child: Input(
                key: const Key('profile-handle'),
                controller: _handle,
                focusNode: _handleFocus,
                enabled: !_saving,
                onChanged: (_) => _clearError('handle'),
              ),
            ),
            Field(
              label: 'Location',
              errors: _errors(_locationError),
              focusNode: _locationFocus,
              enabled: !_saving,
              child: Input(
                key: const Key('profile-location'),
                controller: _location,
                focusNode: _locationFocus,
                enabled: !_saving,
                autofillHints: const <String>[AutofillHints.addressCity],
                onChanged: (_) => _clearError('location'),
              ),
            ),
            Field(
              label: 'Bio',
              description: '24–160 characters. Keep it useful and specific.',
              errors: _errors(_bioError),
              focusNode: _bioFocus,
              enabled: !_saving,
              child: Textarea(
                key: const Key('profile-bio'),
                controller: _bio,
                focusNode: _bioFocus,
                enabled: !_saving,
                onChanged: (_) => _clearError('bio'),
              ),
            ),
            Field(
              label: 'Category',
              focusNode: _categoryFocus,
              enabled: !_saving,
              child: Select<String>(
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
            Field(
              label: 'Profile visibility',
              description: 'Choose who can discover this creator profile.',
              focusNode: _visibilityFocus,
              enabled: !_saving,
              child: Select<String>(
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
            Field(
              label: 'Studio status',
              description: 'A short availability signal shown near your name.',
              focusNode: _statusFocus,
              enabled: !_saving,
              child: Select<String>(
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
        DialogFooter(
          children: <Widget>[
            Button(
              key: const Key('profile-cancel'),
              variant: ButtonVariant.ghost,
              onPressed: _saving ? null : widget.close,
              child: StyledText('Cancel', TextStyles.nav),
            ),
            Button(
              key: const Key('profile-save'),
              loading: _saving,
              onPressed: _saving ? null : _save,
              child: StyledText('Save changes', TextStyles.nav),
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
    final ThemeTokens theme = ThemeScope.of(context);
    return Card(
      children: <Widget>[
        const CardHeader(
          title: CardTitle('Profile media'),
          description: CardDescription(
            'Preview a supplied studio image before committing it.',
          ),
        ),
        CardContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(Radii.lg),
                child: SizedBox(
                  height: space(20),
                  child: Image(
                    image: AssetImage(coverAsset),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: space(3)),
              Row(
                children: <Widget>[
                  Avatar(
                    fallback: _initials(profile.displayName),
                    image: AssetImage(avatarAsset),
                    size: AvatarSize.md,
                  ),
                  SizedBox(width: space(3)),
                  Expanded(
                    child: StyledText(
                      'Avatar and cover preview',
                      TextStyles.small,
                      color: theme.mutedForeground,
                    ),
                  ),
                ],
              ),
              SizedBox(height: space(3)),
              Wrap(
                spacing: space(2),
                runSpacing: space(2),
                children: <Widget>[
                  Button(
                    key: const Key('profile-change-avatar'),
                    size: ButtonSize.sm,
                    variant: ButtonVariant.outline,
                    onPressed: enabled ? onAvatar : null,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Icon.lucide(Lucide.camera, size: IconSize.sm),
                        const _ActionGap(),
                        StyledText('Change avatar', TextStyles.small),
                      ],
                    ),
                  ),
                  Button(
                    key: const Key('profile-change-cover'),
                    size: ButtonSize.sm,
                    variant: ButtonVariant.outline,
                    onPressed: enabled ? onCover : null,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Icon.lucide(Lucide.image, size: IconSize.sm),
                        const _ActionGap(),
                        StyledText('Change cover', TextStyles.small),
                      ],
                    ),
                  ),
                ],
              ),
              if (note != null) ...<Widget>[
                SizedBox(height: space(3)),
                Alert(
                  title: 'Media selection ready',
                  description: note!,
                  variant: AlertVariant.info,
                  icon: const Icon(IconGlyph.info, tone: IconTone.inherit),
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
        glyph: Lucide.mapPin,
        label: 'Based in',
        value: profile.location,
      ),
      _ProfileFact(
        glyph: Lucide.palette,
        label: 'Category',
        value: profile.category,
      ),
      _ProfileFact(
        glyph: profile.visibility == 'Public' ? Lucide.globe : Lucide.lock,
        label: 'Visibility',
        value: profile.visibility,
      ),
      _ProfileFact(
        glyph: Lucide.activity,
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
                  SizedBox(width: space(3)),
                  Expanded(child: facts[1]),
                ],
              ),
              SizedBox(height: space(3)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(child: facts[2]),
                  SizedBox(width: space(3)),
                  Expanded(child: facts[3]),
                ],
              ),
            ],
          )
        : Column(
            children: <Widget>[
              for (int index = 0; index < facts.length; index++) ...<Widget>[
                facts[index],
                if (index < facts.length - 1) SizedBox(height: space(3)),
              ],
            ],
          );
    return Card(
      children: <Widget>[
        const CardHeader(
          title: CardTitle('About the creator'),
          description: CardDescription(
            'The public context behind the work and its availability.',
          ),
        ),
        CardContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              StyledText(profile.bio, TextStyles.body),
              SizedBox(height: space(4)),
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

  final LucideGlyph glyph;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Item(
    variant: ItemVariant.outline,
    media: ItemMedia(child: Icon.lucide(glyph, tone: IconTone.muted)),
    content: ItemContent(
      children: <Widget>[ItemTitle(label), ItemDescription(value)],
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
    const List<Stat> stats = <Stat>[
      Stat(
        label: 'FOLLOWERS',
        value: '84.2K',
        delta: (value: '12.8%', direction: StatDirection.up),
      ),
      Stat(
        label: 'REACH',
        value: '1.8M',
        delta: (value: '8.4%', direction: StatDirection.up),
      ),
      Stat(
        label: 'SAVES',
        value: '14.6K',
        delta: (value: '2.1%', direction: StatDirection.up),
      ),
    ];
    return Card(
      children: <Widget>[
        const CardHeader(
          title: CardTitle('Studio pulse'),
          description: CardDescription(
            'A compact read on the audience you are building.',
          ),
        ),
        CardContent(
          child: wide
              ? Row(
                  children: <Widget>[
                    for (
                      int index = 0;
                      index < stats.length;
                      index++
                    ) ...<Widget>[
                      Expanded(child: stats[index]),
                      if (index < stats.length - 1) SizedBox(width: space(5)),
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
                      if (index < stats.length - 1) SizedBox(height: space(5)),
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
              SizedBox(width: space(4)),
              Expanded(child: cards[1]),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              cards[0],
              SizedBox(height: space(4)),
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
    final ThemeTokens theme = ThemeScope.of(context);
    return Card(
      children: <Widget>[
        CardContent(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Radii.lg),
            child: SizedBox(
              height: space(32),
              child: Image(image: asset, fit: BoxFit.cover),
            ),
          ),
        ),
        CardContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StyledText(
                eyebrow,
                TextStyles.small,
                color: theme.mutedForeground,
              ),
              SizedBox(height: space(2)),
              StyledText(title, TextStyles.h4),
              SizedBox(height: space(2)),
              StyledText(meta, TextStyles.small, color: theme.mutedForeground),
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
  Widget build(BuildContext context) => Card(
    children: const <Widget>[
      CardContent(
        child: Empty(
          children: <Widget>[
            EmptyHeader(
              children: <Widget>[
                EmptyMedia(glyph: IconGlyph.packageOpen),
                EmptyTitle('No drafts are waiting.'),
                EmptyDescription(
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
  Widget build(BuildContext context) => Alert(
    title: 'Collections could not load.',
    description:
        'Your saved work is safe. Try reconnecting to your studio feed.',
    variant: AlertVariant.destructive,
    icon: const Icon(IconGlyph.circleX, tone: IconTone.inherit),
    action: Button(
      size: ButtonSize.sm,
      variant: ButtonVariant.secondary,
      onPressed: onRetry,
      child: StyledText('Retry', TextStyles.small),
    ),
  );
}
