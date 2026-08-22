/// Settings profile — an installable account settings panel.
///
/// A Shot: product-neutral application composition, assembled only from
/// registry items. Nothing here restates a token, and every `Ds*` symbol
/// traces to one of this Shot's declared registry dependencies —
/// `source-foundation`, `card`, `field`, `input`, `select`, `button`,
/// `alert-dialog`, `dialog`, `icon`, `ds-rule`.
///
/// Six states, all reachable from the panel itself:
///
/// * **pristine** — the edited values equal [SettingsProfileValues] as
///   supplied; both actions are inert and the footer says so.
/// * **dirty** — any field differs; Save and Cancel come alive.
/// * **invalid** — a rule failed and the field carries its message. The
///   messages come from [DsRules], so the panel and the field agree on what
///   "invalid" means rather than each deciding for itself.
/// * **saving** — [onSave]'s future is pending; the primary button carries the
///   spinner and both actions are blocked.
/// * **saved** — the future completed; the edited values become the new
///   baseline, which is what returns the panel to pristine.
/// * **discard-confirm** — Cancel opens an alert dialog rather than throwing
///   the edits away, because unsaved work is exactly what an alert dialog is
///   for.
///
/// Responsive layout is hand-rolled against [DsBreakpoints]: the field pairs
/// sit side by side from `md` up and stack below it.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

/// The account record this panel edits.
///
/// Immutable and value-compared, because "dirty" is defined as *the edited
/// record differs from the baseline* — one comparison rather than a boolean
/// per field that has to be kept in step.
@immutable
class SettingsProfileValues {
  const SettingsProfileValues({
    required this.displayName,
    required this.email,
    required this.timezone,
    required this.language,
  });

  final String displayName;
  final String email;

  /// The value of one [DsSelectOption] in [SettingsProfileShot.timezones].
  final String timezone;

  /// The value of one [DsSelectOption] in [SettingsProfileShot.languages].
  final String language;

  SettingsProfileValues copyWith({
    String? displayName,
    String? email,
    String? timezone,
    String? language,
  }) => SettingsProfileValues(
    displayName: displayName ?? this.displayName,
    email: email ?? this.email,
    timezone: timezone ?? this.timezone,
    language: language ?? this.language,
  );

  @override
  bool operator ==(Object other) =>
      other is SettingsProfileValues &&
      other.displayName == displayName &&
      other.email == email &&
      other.timezone == timezone &&
      other.language == language;

  @override
  int get hashCode => Object.hash(displayName, email, timezone, language);
}

/// An account settings panel with validation, typed selection, and a
/// discard-confirmation flow.
class SettingsProfileShot extends StatefulWidget {
  const SettingsProfileShot({
    super.key,
    this.initialValues = const SettingsProfileValues(
      displayName: 'Alex Rivera',
      email: 'alex.rivera@example.com',
      timezone: 'america-los-angeles',
      language: 'en',
    ),
    this.onSave,
  });

  /// The baseline the panel opens on, and the record Cancel restores.
  final SettingsProfileValues initialValues;

  /// Persists the edited record.
  ///
  /// The panel is in its saving state for exactly as long as this future is
  /// pending, so an application supplies its own latency and the composition
  /// states no clock of its own. Null saves instantly, which is what the
  /// documentation preview renders.
  final Future<void> Function(SettingsProfileValues values)? onSave;

  /// `displayName`'s schema.
  static final List<DsRule<String>> displayNameRules = <DsRule<String>>[
    DsRule.minLength(2, 'Use at least 2 characters.'),
    DsRule.maxLength(40, 'Use at most 40 characters.'),
  ];

  /// `email`'s schema.
  static final List<DsRule<String>> emailRules = <DsRule<String>>[
    DsRule.minLength(1, 'An email address is required.'),
    DsRule.email('That is not an email address.'),
  ];

  /// Grouped, because a time-zone list is read by region before it is read by
  /// offset.
  static const List<DsSelectChild<String>> timezones = <DsSelectChild<String>>[
    DsSelectGroup<String>(
      label: 'Americas',
      children: <DsSelectOption<String>>[
        DsSelectOption<String>(
          value: 'america-los-angeles',
          label: 'Los Angeles',
        ),
        DsSelectOption<String>(value: 'america-new-york', label: 'New York'),
        DsSelectOption<String>(value: 'america-sao-paulo', label: 'Sao Paulo'),
      ],
    ),
    DsSelectSeparator(),
    DsSelectGroup<String>(
      label: 'Europe and Africa',
      children: <DsSelectOption<String>>[
        DsSelectOption<String>(value: 'europe-lisbon', label: 'Lisbon'),
        DsSelectOption<String>(value: 'europe-berlin', label: 'Berlin'),
        DsSelectOption<String>(value: 'africa-casablanca', label: 'Casablanca'),
      ],
    ),
    DsSelectSeparator(),
    DsSelectGroup<String>(
      label: 'Asia and Pacific',
      children: <DsSelectOption<String>>[
        DsSelectOption<String>(value: 'asia-singapore', label: 'Singapore'),
        DsSelectOption<String>(value: 'asia-tokyo', label: 'Tokyo'),
        DsSelectOption<String>(value: 'australia-sydney', label: 'Sydney'),
      ],
    ),
  ];

  /// Flat, because a language list has no grouping to read.
  static const List<DsSelectOption<String>> languages =
      <DsSelectOption<String>>[
        DsSelectOption<String>(value: 'en', label: 'English'),
        DsSelectOption<String>(value: 'fr', label: 'French'),
        DsSelectOption<String>(value: 'de', label: 'German'),
        DsSelectOption<String>(value: 'ja', label: 'Japanese'),
        DsSelectOption<String>(value: 'pt', label: 'Portuguese'),
      ];

  /// The measure a settings column is held to.
  static double get columnWidth => DsContainers.xl2;

  @override
  State<SettingsProfileShot> createState() => _SettingsProfileShotState();
}

class _SettingsProfileShotState extends State<SettingsProfileShot> {
  late TextEditingController _displayName;
  late TextEditingController _email;
  late SettingsProfileValues _baseline;
  late String _timezone;
  late String _language;

  /// Whether the reader has asked for the record to be checked.
  ///
  /// Rules run on every keystroke, but a field that has never been submitted
  /// shows nothing: an error on a value nobody has finished typing is noise,
  /// and the field family's own guidance is that an empty live region on every
  /// field is the anti-pattern.
  bool _submitted = false;

  bool _saving = false;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _baseline = widget.initialValues;
    _displayName = TextEditingController(text: _baseline.displayName)
      ..addListener(_onEdited);
    _email = TextEditingController(text: _baseline.email)
      ..addListener(_onEdited);
    _timezone = _baseline.timezone;
    _language = _baseline.language;
  }

  @override
  void dispose() {
    _displayName.dispose();
    _email.dispose();
    super.dispose();
  }

  void _onEdited() => setState(() => _saved = false);

  SettingsProfileValues get _values => SettingsProfileValues(
    displayName: _displayName.text,
    email: _email.text,
    timezone: _timezone,
    language: _language,
  );

  bool get _dirty => _values != _baseline;

  List<String> get _displayNameIssues => DsRules.check<String>(
    _displayName.text,
    SettingsProfileShot.displayNameRules,
  );

  List<String> get _emailIssues =>
      DsRules.check<String>(_email.text, SettingsProfileShot.emailRules);

  bool get _valid => _displayNameIssues.isEmpty && _emailIssues.isEmpty;

  void _restore() {
    _displayName.text = _baseline.displayName;
    _email.text = _baseline.email;
    setState(() {
      _timezone = _baseline.timezone;
      _language = _baseline.language;
      _submitted = false;
      _saved = false;
    });
  }

  Future<void> _save() async {
    setState(() => _submitted = true);
    if (!_valid) return;
    final SettingsProfileValues pending = _values;
    setState(() {
      _saving = true;
      _saved = false;
    });
    try {
      await widget.onSave?.call(pending);
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
          _saved = true;
          _baseline = pending;
        });
      }
    }
  }

  /// Two fields abreast from `md` up, stacked below it.
  ///
  /// Hand-rolled against [DsBreakpoints] rather than delegated to a grid: the
  /// registry ships no layout item, so a Shot that leaned on one would not
  /// compile once installed.
  Widget _pair(BuildContext context, Widget start, Widget end) {
    if (MediaQuery.sizeOf(context).width < DsBreakpoints.md) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[start, SizedBox(height: DsFieldSet.gap), end],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(child: start),
        SizedBox(width: DsFieldSet.gap),
        Expanded(child: end),
      ],
    );
  }

  Widget _status(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final (DsIconGlyph glyph, DsIconTone tone, String message) = switch ((
      _saving,
      _saved,
      _dirty,
    )) {
      (true, _, _) => (DsIconGlyph.hourglass, DsIconTone.muted, 'Saving…'),
      (_, true, _) => (
        DsIconGlyph.circleCheck,
        DsIconTone.success,
        'All changes saved.',
      ),
      (_, _, true) => (
        DsIconGlyph.info,
        DsIconTone.warning,
        'You have unsaved changes.',
      ),
      _ => (DsIconGlyph.shieldCheck, DsIconTone.muted, 'Up to date.'),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DsIcon(glyph, size: DsIconSize.sm, tone: tone),
        SizedBox(width: DsField.gap),
        Flexible(
          child: DsText(
            message,
            DsType.small,
            color: theme.mutedForeground,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// The decision band.
  ///
  /// The two actions and the status share a line from `sm` up and stack below
  /// it. Not cosmetic: a footer that keeps them on one line hands the status
  /// whatever the buttons leave over, and on a phone that is less than the
  /// glyph in front of it.
  Widget _footer(BuildContext context) {
    final Widget actions = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        _cancel(context),
        SizedBox(width: DsField.gap),
        DsButton(
          key: const ValueKey<String>('settings-profile-save'),
          loading: _saving,
          onPressed: _dirty && !_saving ? _save : null,
          child: DsText('Save changes', DsComponentType.buttonLabel),
        ),
      ],
    );

    if (MediaQuery.sizeOf(context).width < DsBreakpoints.sm) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Align(alignment: AlignmentDirectional.centerStart, child: _status(context)),
          SizedBox(height: DsFieldSet.gap),
          Align(alignment: AlignmentDirectional.centerEnd, child: actions),
        ],
      );
    }

    return Row(
      children: <Widget>[Expanded(child: _status(context)), actions],
    );
  }

  Widget _cancel(BuildContext context) => DsAlertDialog(
    trigger: (BuildContext context, VoidCallback open) => DsButton(
      key: const ValueKey<String>('settings-profile-cancel'),
      variant: DsButtonVariant.ghost,
      onPressed: _dirty && !_saving ? open : null,
      child: DsText('Cancel', DsComponentType.buttonLabel),
    ),
    content: (BuildContext context, VoidCallback close) => DsAlertDialogContent(
      header: const DsAlertDialogHeader(
        title: DsAlertDialogTitle('Discard your changes?'),
        description: DsAlertDialogDescription(
          'This account has edits that have not been saved. Discarding them '
          'restores the values this panel opened with.',
        ),
      ),
      footer: DsAlertDialogFooter(
        cancel: DsAlertDialogCancel(label: 'Keep editing', onPressed: close),
        action: DsAlertDialogAction(
          label: 'Discard changes',
          onPressed: () {
            close();
            _restore();
          },
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final bool showIssues = _submitted;

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: SettingsProfileShot.columnWidth),
        child: DsCard(
          key: const ValueKey<String>('settings-profile-card'),
          children: <Widget>[
            const DsCardHeader(
              title: DsCardTitle('Profile'),
              description: DsCardDescription(
                'How this account is addressed, and where its notices are '
                'delivered.',
              ),
            ),
            DsCardContent(
              child: DsFieldSet(
                children: <Widget>[
                  _pair(
                    context,
                    DsField(
                      label: 'Display name',
                      description: 'Shown wherever this account is credited.',
                      errors: showIssues ? _displayNameIssues : const <String>[],
                      enabled: !_saving,
                      child: DsInput(
                        key: const ValueKey<String>('settings-profile-name'),
                        controller: _displayName,
                        placeholder: 'Your name',
                      ),
                    ),
                    DsField(
                      label: 'Email address',
                      description: 'Used for sign-in and account notices.',
                      errors: showIssues ? _emailIssues : const <String>[],
                      enabled: !_saving,
                      child: DsInput(
                        key: const ValueKey<String>('settings-profile-email'),
                        controller: _email,
                        placeholder: 'you@example.com',
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const <String>[AutofillHints.email],
                      ),
                    ),
                  ),
                  _pair(
                    context,
                    DsField(
                      label: 'Time zone',
                      description: 'Dates and schedules are shown in this zone.',
                      enabled: !_saving,
                      child: DsSelect<String>(
                        key: const ValueKey<String>('settings-profile-timezone'),
                        options: SettingsProfileShot.timezones,
                        value: _timezone,
                        expand: true,
                        placeholder: 'Pick a time zone',
                        onChanged: (String value) => setState(() {
                          _timezone = value;
                          _saved = false;
                        }),
                      ),
                    ),
                    DsField(
                      label: 'Language',
                      description: 'The language this account is written in.',
                      enabled: !_saving,
                      child: DsSelect<String>(
                        key: const ValueKey<String>('settings-profile-language'),
                        options: SettingsProfileShot.languages,
                        value: _language,
                        expand: true,
                        placeholder: 'Pick a language',
                        onChanged: (String value) => setState(() {
                          _language = value;
                          _saved = false;
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            DsCardFooter(child: _footer(context)),
          ],
        ),
      ),
    );
  }
}
