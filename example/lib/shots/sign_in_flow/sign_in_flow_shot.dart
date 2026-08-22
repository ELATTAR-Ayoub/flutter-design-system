/// Sign-in flow — an installable authentication card.
///
/// A Shot: product-neutral application composition, assembled only from
/// registry items. Every `Ds*` symbol traces to one of this Shot's declared
/// registry dependencies — `source-foundation`, `card`, `field`, `input`,
/// `button`, `dialog`, `icon`, `spinner`, `ds-rule`.
///
/// Six states, all reachable from the card itself:
///
/// * **empty** — nothing typed, the primary action inert.
/// * **focus** — the field family's own focus ring; nothing here overrides it.
/// * **invalid** — a rule failed and the field carries its message, which
///   comes from [DsRules] rather than from a second opinion held here.
/// * **submitting** — [onSubmit]'s future is pending. [DsButton.loading]
///   prepends a [DsSpinner] and blocks a second press, which is the whole of
///   the busy state.
/// * **auth-error** — the credentials were refused. Not a field error: it is a
///   statement about the pair, so it is announced above both fields rather
///   than under either one.
/// * **reset-dialog-open** — "Forgot password?" opens a [DsDialog] rather than
///   navigating away, so a half-typed email is not thrown out to read one
///   sentence.
///
/// The card is centred and capped; the provider rule is hand-rolled from
/// [DsWidths.hairline], because the registry ships no separator item.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

/// The credentials the card collects.
@immutable
class SignInCredentials {
  const SignInCredentials({required this.email, required this.password});

  final String email;
  final String password;
}

/// A centred authentication card with password reveal, a submitting state, and
/// a reset-password dialog.
class SignInFlowShot extends StatefulWidget {
  const SignInFlowShot({
    super.key,
    this.onSubmit,
    this.onResetRequested,
    this.onProviderSelected,
    this.onCreateAccount,
  });

  /// Authenticates the credentials.
  ///
  /// The card is in its submitting state for exactly as long as this future is
  /// pending, and the string it completes with — if any — becomes the
  /// auth-error message. Null accepts nothing and reports the refusal, which
  /// is what the documentation preview renders: a Shot with no back end
  /// behind it should demonstrate the failure path rather than pretend to a
  /// session it cannot have.
  final Future<String?> Function(SignInCredentials credentials)? onSubmit;

  /// Requests a reset link for [email]. Null does nothing.
  final Future<void> Function(String email)? onResetRequested;

  /// Hands off to a federated provider, identified by the id the card labels
  /// it with. Product-neutral on purpose: a Shot names no vendor.
  final void Function(String provider)? onProviderSelected;

  /// Leaves for the registration flow. Null leaves the link inert.
  final VoidCallback? onCreateAccount;

  /// `email`'s schema.
  static final List<DsRule<String>> emailRules = <DsRule<String>>[
    DsRule.minLength(1, 'An email address is required.'),
    DsRule.email('That is not an email address.'),
  ];

  /// `password`'s schema.
  ///
  /// A sign-in form checks presence, never strength: the account's password
  /// was accepted when it was chosen, and re-litigating it at the door only
  /// tells an attacker what the rules are.
  static final List<DsRule<String>> passwordRules = <DsRule<String>>[
    DsRule.minLength(1, 'A password is required.'),
  ];

  /// What the card is refused with when no [onSubmit] is supplied.
  static const String defaultRefusal =
      'That email and password do not match an account.';

  /// The measure the card is held to — the system's small centred panel.
  static double get cardWidth => DsContainers.sm;

  @override
  State<SignInFlowShot> createState() => _SignInFlowShotState();
}

class _SignInFlowShotState extends State<SignInFlowShot> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final FocusNode _emailFocus = FocusNode(debugLabel: 'sign-in-email');
  final FocusNode _passwordFocus = FocusNode(debugLabel: 'sign-in-password');

  bool _submitted = false;
  bool _submitting = false;
  bool _revealed = false;
  String? _authError;

  @override
  void initState() {
    super.initState();
    _email.addListener(_onEdited);
    _password.addListener(_onEdited);
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  /// Any edit retires the refusal: the pair being judged is no longer the pair
  /// that was refused.
  void _onEdited() {
    if (_authError == null) return;
    setState(() => _authError = null);
  }

  List<String> get _emailIssues =>
      DsRules.check<String>(_email.text, SignInFlowShot.emailRules);

  List<String> get _passwordIssues =>
      DsRules.check<String>(_password.text, SignInFlowShot.passwordRules);

  bool get _valid => _emailIssues.isEmpty && _passwordIssues.isEmpty;

  Future<void> _submit() async {
    setState(() {
      _submitted = true;
      _authError = null;
    });
    if (!_valid) return;
    setState(() => _submitting = true);
    String? refusal = SignInFlowShot.defaultRefusal;
    try {
      final Future<String?> Function(SignInCredentials)? submit =
          widget.onSubmit;
      if (submit != null) {
        refusal = await submit(
          SignInCredentials(email: _email.text, password: _password.text),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
          _authError = refusal;
        });
      }
    }
  }

  Widget _banner(BuildContext context, String message) {
    final DsThemeData theme = DsTheme.of(context);
    return Row(
      key: const ValueKey<String>('sign-in-auth-error'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const DsIcon(
          DsIconGlyph.alertTriangle,
          size: DsIconSize.sm,
          tone: DsIconTone.error,
        ),
        SizedBox(width: DsField.gap),
        Expanded(
          child: DsText(
            message,
            DsComponentType.textSm,
            color: theme.destructiveInk,
          ),
        ),
      ],
    );
  }

  /// `or` between two hairlines.
  ///
  /// Hand-rolled: a separator is not a registry item, so an installed Shot
  /// that reached for one would not compile. [DsWidths.hairline] is the
  /// measure Tailwind's bare `border` utility gives an element, and
  /// `theme.border` is the colour it gives it.
  Widget _rule(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    Widget line() => Expanded(
      child: SizedBox(
        height: DsWidths.hairline,
        child: ColoredBox(color: theme.border),
      ),
    );
    return Row(
      children: <Widget>[
        line(),
        SizedBox(width: DsField.gap),
        DsText('or', DsType.caption, color: theme.mutedForeground),
        SizedBox(width: DsField.gap),
        line(),
      ],
    );
  }

  Widget _provider(
    BuildContext context,
    String provider,
    DsIconGlyph glyph,
    String label,
  ) => DsButton(
        variant: DsButtonVariant.outline,
        contentAlignment: AlignmentDirectional.center,
        onPressed: _submitting
            ? null
            : () => widget.onProviderSelected?.call(provider),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DsIcon(glyph, size: DsIconSize.sm),
            SizedBox(width: DsField.gap),
            Flexible(
              child: DsText(
                label,
                DsComponentType.buttonLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );

  /// The password row: the field, and the control that unmasks it.
  ///
  /// [DsInput] has no reveal of its own — the component's own API note says to
  /// *"compose a visibility toggle outside the base input"* — so the toggle is
  /// a ghost icon button beside it, sharing the field's focus node so the
  /// label, the caret and the reveal all address the same control.
  ///
  /// [DsFieldVisibility] wraps the **row** rather than the input. [DsInput]
  /// already wraps itself, which lifts the field clear of a software keyboard;
  /// wrapping the row lifts the toggle with it, so the control that unmasks a
  /// password is never the thing left under the keyboard.
  Widget _passwordRow(BuildContext context) => DsFieldVisibility(
    focusNode: _passwordFocus,
    child: Row(
      children: <Widget>[
        Expanded(
          child: DsInput(
            key: const ValueKey<String>('sign-in-password'),
            controller: _password,
            placeholder: 'Your password',
            obscureText: !_revealed,
            enabled: !_submitting,
            autofillHints: const <String>[AutofillHints.password],
          ),
        ),
        SizedBox(width: DsField.gap),
        DsButton(
          key: const ValueKey<String>('sign-in-reveal'),
          variant: DsButtonVariant.ghost,
          size: DsButtonSize.icon,
          label: _revealed ? 'Hide password' : 'Show password',
          onPressed: _submitting
              ? null
              : () => setState(() => _revealed = !_revealed),
          child: DsIcon(
            _revealed ? DsIconGlyph.eyeOff : DsIconGlyph.eye,
            size: DsIconSize.sm,
          ),
        ),
      ],
    ),
  );

  Widget _resetDialog(BuildContext context) => DsDialog(
    trigger: (BuildContext context, VoidCallback open) => DsButton(
      key: const ValueKey<String>('sign-in-forgot'),
      variant: DsButtonVariant.link,
      size: DsButtonSize.sm,
      suppressPressScale: true,
      onPressed: _submitting ? null : open,
      child: DsText('Forgot password?', DsComponentType.buttonLabelSm),
    ),
    content: (BuildContext context, VoidCallback close) => DsDialogContent(
      key: const ValueKey<String>('sign-in-reset-dialog'),
      onClose: close,
      children: <Widget>[
        const DsDialogHeader(
          children: <Widget>[
            DsDialogTitle('Reset password'),
            DsDialogDescription(
              'Enter the address on the account and a single-use link will be '
              'sent to it.',
            ),
          ],
        ),
        DsField(
          label: 'Email address',
          description: 'The link expires an hour after it is sent.',
          child: DsInput(
            key: const ValueKey<String>('sign-in-reset-email'),
            initialValue: _email.text,
            placeholder: 'you@example.com',
            keyboardType: TextInputType.emailAddress,
            onSubmitted: (String value) {
              widget.onResetRequested?.call(value);
              close();
            },
          ),
        ),
        DsDialogFooter(
          children: <Widget>[
            DsButton(
              variant: DsButtonVariant.ghost,
              onPressed: close,
              child: DsText('Cancel', DsComponentType.buttonLabel),
            ),
            DsButton(
              onPressed: () {
                widget.onResetRequested?.call(_email.text);
                close();
              },
              child: DsText('Send reset link', DsComponentType.buttonLabel),
            ),
          ],
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final String? authError = _authError;
    final double gap = DsFieldSet.gap;

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: SignInFlowShot.cardWidth),
        child: DsCard(
          key: const ValueKey<String>('sign-in-card'),
          children: <Widget>[
            const DsCardHeader(
              title: DsCardTitle('Sign in'),
              description: DsCardDescription(
                'Use the email address this account was opened with.',
              ),
            ),
            DsCardContent(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (authError != null) ...<Widget>[
                    _banner(context, authError),
                    SizedBox(height: gap),
                  ],
                  DsField(
                    label: 'Email address',
                    errors: _submitted ? _emailIssues : const <String>[],
                    enabled: !_submitting,
                    focusNode: _emailFocus,
                    child: DsInput(
                      key: const ValueKey<String>('sign-in-email'),
                      controller: _email,
                      placeholder: 'you@example.com',
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const <String>[AutofillHints.email],
                    ),
                  ),
                  SizedBox(height: gap),
                  DsField(
                    label: 'Password',
                    errors: _submitted ? _passwordIssues : const <String>[],
                    enabled: !_submitting,
                    focusNode: _passwordFocus,
                    child: _passwordRow(context),
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: _resetDialog(context),
                  ),
                  SizedBox(height: gap),
                  DsButton(
                    key: const ValueKey<String>('sign-in-submit'),
                    loading: _submitting,
                    contentAlignment: AlignmentDirectional.center,
                    onPressed: _submitting ? null : _submit,
                    child: DsText('Sign in', DsComponentType.buttonLabel),
                  ),
                  SizedBox(height: gap),
                  _rule(context),
                  SizedBox(height: gap),
                  _provider(
                    context,
                    'sso',
                    DsIconGlyph.shield,
                    'Continue with SSO',
                  ),
                  SizedBox(height: DsField.gap),
                  _provider(
                    context,
                    'email-link',
                    DsIconGlyph.atSign,
                    'Email me a sign-in link',
                  ),
                ],
              ),
            ),
            DsCardFooter(
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: DsText(
                      'No account yet?',
                      DsType.small,
                      color: theme.mutedForeground,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DsButton(
                    key: const ValueKey<String>('sign-in-create-account'),
                    variant: DsButtonVariant.link,
                    size: DsButtonSize.sm,
                    onPressed: widget.onCreateAccount,
                    child: DsText('Create one', DsComponentType.buttonLabelSm),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
