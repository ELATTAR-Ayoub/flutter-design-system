/// The home page's grid: live compositions built only from real `El*`
/// components, no screenshots and no descriptions.
///
/// Three of the six cards defined in this file started as
/// `example/lib/shots/`'s three installable compositions (settings, sign-in,
/// dashboard); that directory is gone, so their content lives on here, trimmed
/// to card size and stripped of the outer width cap a full-screen composition
/// wanted but a grid cell does not need. The other three are new, built the
/// same way: real state, real validation, real components.
///
/// The eight cards added after them live one-per-file under `home_cards/`,
/// because this file was already long enough that a fourteen-card wall would
/// have buried the three it inherited.
library;

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

import 'home_cards/analytics_card.dart';
import 'home_cards/balance_card.dart';
import 'home_cards/contribution_card.dart';
import 'home_cards/milestone_card.dart';
import 'home_cards/navigation_card.dart';
import 'home_cards/notifications_card.dart';
import 'home_cards/payout_card.dart';
import 'home_cards/release_card.dart';

/// The fourteen live cards, in grid order.
///
/// The order is the masonry's, not a reading order: [HomeMasonryGrid] deals
/// cards round-robin into its columns, so neighbours in this list land in
/// *different* columns. Tall and short cards therefore alternate here so no
/// one column ends up carrying every long composition.
List<Widget> homeShowcaseCards() => const <Widget>[
  _ComponentsCard(),
  ContributionCard(),
  MilestoneCard(),
  _ChartCard(),
  AnalyticsCard(),
  ReleaseCard(),
  PayoutCard(),
  NotificationsCard(),
  _DashboardCard(),
  _ChatCard(),
  BalanceCard(),
  _SignInCard(),
  NavigationCard(),
  _SettingsCard(),
];

/// A staggered card grid: [base] columns, widened at [sm] and [lg].
///
/// Unlike `kit.dart`'s `Grid`, a row here never stretches every cell to its
/// tallest neighbour — each column runs its own height, which is what lets
/// six differently sized live compositions sit together as a masonry wall
/// instead of a uniform table.
class HomeMasonryGrid extends StatelessWidget {
  const HomeMasonryGrid({
    super.key,
    required this.children,
    this.base = 1,
    this.sm,
    this.lg,
    this.gap,
  });

  final List<Widget> children;
  final int base;
  final int? sm;
  final int? lg;
  final double? gap;

  int _columns(double viewport) {
    int columns = base;
    if (sm != null && viewport >= Breakpoints.sm) columns = sm!;
    if (lg != null && viewport >= Breakpoints.lg) columns = lg!;
    return columns;
  }

  @override
  Widget build(BuildContext context) {
    final double layoutGap = gap ?? space(4);
    final int columns = _columns(MediaQuery.sizeOf(context).width);
    final List<List<Widget>> buckets = List<List<Widget>>.generate(
      columns,
      (_) => <Widget>[],
    );
    for (int i = 0; i < children.length; i++) {
      buckets[i % columns].add(children[i]);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (int c = 0; c < columns; c++) ...<Widget>[
          if (c > 0) SizedBox(width: layoutGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                for (int i = 0; i < buckets[c].length; i++) ...<Widget>[
                  if (i > 0) SizedBox(height: layoutGap),
                  buckets[c][i],
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/* ── Card 1: buttons, badges, inputs, toggles ───────────────────────────── */

class _ComponentsCard extends StatefulWidget {
  const _ComponentsCard();

  @override
  State<_ComponentsCard> createState() => _ComponentsCardState();
}

class _ComponentsCardState extends State<_ComponentsCard> {
  final TextEditingController _search = TextEditingController();
  bool _notify = true;
  int? _view = 0;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Card(
      children: <Widget>[
        const CardHeader(
          title: CardTitle('Building blocks'),
          description: CardDescription(
            'Buttons, badges, an input and a toggle group, wired up.',
          ),
        ),
        CardContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Wrap(
                spacing: space(2),
                runSpacing: space(2),
                children: <Widget>[
                  Button(
                    size: ButtonSize.sm,
                    onPressed: () {},
                    child: const Text('Primary'),
                  ),
                  Button(
                    size: ButtonSize.sm,
                    variant: ButtonVariant.outline,
                    onPressed: () {},
                    child: const Text('Outline'),
                  ),
                  Button(
                    size: ButtonSize.sm,
                    variant: ButtonVariant.ghost,
                    onPressed: () {},
                    child: const Text('Ghost'),
                  ),
                ],
              ),
              SizedBox(height: space(3)),
              Wrap(
                spacing: space(2),
                runSpacing: space(2),
                children: const <Widget>[
                  Badge(label: 'Stable'),
                  Badge(label: 'New', variant: BadgeVariant.action),
                  Badge(label: 'Shipped', variant: BadgeVariant.success),
                  Badge(label: 'Beta', variant: BadgeVariant.outline),
                ],
              ),
              SizedBox(height: space(3)),
              Input(
                key: const ValueKey<String>('home-components-search'),
                controller: _search,
                placeholder: 'Search components',
              ),
              SizedBox(height: space(3)),
              Row(
                children: <Widget>[
                  Switch(
                    key: const ValueKey<String>('home-components-switch'),
                    value: _notify,
                    onChanged: (bool value) => setState(() => _notify = value),
                  ),
                  SizedBox(width: space(2)),
                  Flexible(
                    child: StyledText(
                      'Notify on release',
                      TextStyles.small,
                      color: theme.mutedForeground,
                    ),
                  ),
                ],
              ),
              SizedBox(height: space(3)),
              ToggleGroup(
                key: const ValueKey<String>('home-components-toggle'),
                items: const <ToggleGroupItem>[
                  ToggleGroupItem(label: 'Grid'),
                  ToggleGroupItem(label: 'List'),
                ],
                selectedIndex: _view,
                onChanged: (int? next) => setState(() => _view = next ?? 0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/* ── Card 2: a chart ─────────────────────────────────────────────────────── */

class _ChartCard extends StatelessWidget {
  const _ChartCard();

  static const List<Map<String, Object?>> _data = <Map<String, Object?>>[
    <String, Object?>{'month': 'Jan', 'sessions': 186},
    <String, Object?>{'month': 'Feb', 'sessions': 205},
    <String, Object?>{'month': 'Mar', 'sessions': 237},
    <String, Object?>{'month': 'Apr', 'sessions': 273},
    <String, Object?>{'month': 'May', 'sessions': 229},
    <String, Object?>{'month': 'Jun', 'sessions': 314},
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Card(
      children: <Widget>[
        const CardHeader(
          title: CardTitle('Sessions'),
          description: CardDescription('Last 6 months, one real chart.'),
        ),
        CardContent(
          child: ChartContainer(
            height: space(48),
            config: ChartConfig(<String, ChartSeries>{
              'sessions': ChartSeries(label: 'Sessions', color: theme.chart1),
            }),
            child: CartesianChart(
              data: _data,
              grid: const ChartGrid(vertical: false),
              xAxis: const ChartAxis(
                dataKey: 'month',
                tickLine: false,
                axisLine: false,
              ),
              tooltip: const ChartTooltipSpec(
                cursor: false,
                indicator: ChartIndicator.line,
              ),
              series: <ChartSeriesSpec>[
                ChartSeriesSpec(
                  kind: ChartSeriesKind.area,
                  dataKey: 'sessions',
                  curve: CurveType.natural,
                  fill: theme.chart1,
                  fillOpacity: 0.35,
                  stroke: theme.chart1,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/* ── Card 3: a chat ──────────────────────────────────────────────────────── */

class _ChatCard extends StatefulWidget {
  const _ChatCard();

  @override
  State<_ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<_ChatCard> {
  final TextEditingController _draft = TextEditingController();
  final List<String> _sent = <String>[];

  @override
  void dispose() {
    _draft.dispose();
    super.dispose();
  }

  void _send() {
    final String text = _draft.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _sent.add(text);
      _draft.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      children: <Widget>[
        const CardHeader(
          title: CardTitle('Say something'),
          description: CardDescription('A real MessageGroup, typed below.'),
        ),
        CardContent(
          child: MessageGroup(
            children: <Widget>[
              const Message(
                content: MessageContent(
                  children: <Widget>[
                    Bubble(
                      variant: BubbleVariant.muted,
                      child: BubbleContent(
                        child: Text('What can this system do?'),
                      ),
                    ),
                  ],
                ),
              ),
              const Message(
                align: BubbleAlign.end,
                content: MessageContent(
                  children: <Widget>[
                    Bubble(
                      align: BubbleAlign.end,
                      child: BubbleContent(
                        child: Text('Copy a component in, keep every token.'),
                      ),
                    ),
                  ],
                ),
              ),
              for (final String text in _sent)
                Message(
                  align: BubbleAlign.end,
                  content: MessageContent(
                    children: <Widget>[
                      Bubble(
                        align: BubbleAlign.end,
                        child: BubbleContent(child: Text(text)),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        CardFooter(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Input(
                  key: const ValueKey<String>('home-chat-input'),
                  controller: _draft,
                  placeholder: 'Type a message',
                  onSubmitted: (_) => _send(),
                ),
              ),
              SizedBox(width: space(2)),
              Button(
                key: const ValueKey<String>('home-chat-send'),
                size: ButtonSize.icon,
                label: 'Send message',
                onPressed: _send,
                child: const Icon.lucide(Lucide.send, size: IconSize.sm),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/* ── Card 4: settings (from the deleted settings-profile composition) ──── */

@immutable
class _SettingsValues {
  const _SettingsValues({
    required this.displayName,
    required this.email,
    required this.timezone,
  });

  final String displayName;
  final String email;
  final String timezone;

  @override
  bool operator ==(Object other) =>
      other is _SettingsValues &&
      other.displayName == displayName &&
      other.email == email &&
      other.timezone == timezone;

  @override
  int get hashCode => Object.hash(displayName, email, timezone);
}

const _SettingsValues _settingsBaseline = _SettingsValues(
  displayName: 'Alex Rivera',
  email: 'alex.rivera@example.com',
  timezone: 'america-los-angeles',
);

class _SettingsCard extends StatefulWidget {
  const _SettingsCard();

  static final List<ValidationRule<String>> _nameRules =
      <ValidationRule<String>>[
        ValidationRule.minLength(2, 'Use at least 2 characters.'),
      ];

  static final List<ValidationRule<String>> _emailRules =
      <ValidationRule<String>>[
        ValidationRule.minLength(1, 'An email address is required.'),
        ValidationRule.email('That is not an email address.'),
      ];

  static const List<SelectOption<String>> _timezones = <SelectOption<String>>[
    SelectOption<String>(value: 'america-los-angeles', label: 'Los Angeles'),
    SelectOption<String>(value: 'america-new-york', label: 'New York'),
    SelectOption<String>(value: 'europe-lisbon', label: 'Lisbon'),
    SelectOption<String>(value: 'asia-tokyo', label: 'Tokyo'),
  ];

  @override
  State<_SettingsCard> createState() => _SettingsCardState();
}

class _SettingsCardState extends State<_SettingsCard> {
  late final TextEditingController _name = TextEditingController(
    text: _settingsBaseline.displayName,
  )..addListener(_onEdited);
  late final TextEditingController _email = TextEditingController(
    text: _settingsBaseline.email,
  )..addListener(_onEdited);
  String _timezone = _settingsBaseline.timezone;
  _SettingsValues _saved = _settingsBaseline;
  bool _submitted = false;
  bool _saving = false;
  bool _justSaved = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  void _onEdited() => setState(() => _justSaved = false);

  _SettingsValues get _current => _SettingsValues(
    displayName: _name.text,
    email: _email.text,
    timezone: _timezone,
  );

  bool get _dirty => _current != _saved;

  List<String> get _nameIssues =>
      Validators.check<String>(_name.text, _SettingsCard._nameRules);
  List<String> get _emailIssues =>
      Validators.check<String>(_email.text, _SettingsCard._emailRules);
  bool get _valid => _nameIssues.isEmpty && _emailIssues.isEmpty;

  void _restore() {
    _name.text = _saved.displayName;
    _email.text = _saved.email;
    setState(() {
      _timezone = _saved.timezone;
      _submitted = false;
      _justSaved = false;
    });
  }

  Future<void> _save() async {
    setState(() => _submitted = true);
    if (!_valid) return;
    final _SettingsValues pending = _current;
    setState(() => _saving = true);
    await Future<void>.delayed(MotionDurations.slow);
    if (!mounted) return;
    setState(() {
      _saving = false;
      _justSaved = true;
      _saved = pending;
    });
  }

  Widget _cancel() => AlertDialog(
    trigger: (BuildContext context, VoidCallback open) => Button(
      key: const ValueKey<String>('home-settings-cancel'),
      variant: ButtonVariant.ghost,
      onPressed: _dirty && !_saving ? open : null,
      child: const Text('Cancel'),
    ),
    content: (BuildContext context, VoidCallback close) => AlertDialogContent(
      header: const AlertDialogHeader(
        title: AlertDialogTitle('Discard your changes?'),
        description: AlertDialogDescription(
          'This restores the values this panel opened with.',
        ),
      ),
      footer: AlertDialogFooter(
        cancel: AlertDialogCancel(label: 'Keep editing', onPressed: close),
        action: AlertDialogAction(
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
    final ThemeTokens theme = ThemeScope.of(context);
    final bool show = _submitted;
    final String status = _saving
        ? 'Saving…'
        : _justSaved
        ? 'All changes saved.'
        : _dirty
        ? 'You have unsaved changes.'
        : 'Up to date.';

    return Card(
      children: <Widget>[
        const CardHeader(
          title: CardTitle('Profile'),
          description: CardDescription(
            'How this account is addressed, edited live.',
          ),
        ),
        CardContent(
          child: FieldSet(
            children: <Widget>[
              Field(
                label: 'Display name',
                errors: show ? _nameIssues : const <String>[],
                enabled: !_saving,
                child: Input(
                  key: const ValueKey<String>('home-settings-name'),
                  controller: _name,
                  placeholder: 'Your name',
                ),
              ),
              Field(
                label: 'Email address',
                errors: show ? _emailIssues : const <String>[],
                enabled: !_saving,
                child: Input(
                  key: const ValueKey<String>('home-settings-email'),
                  controller: _email,
                  placeholder: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              Field(
                label: 'Time zone',
                enabled: !_saving,
                child: Select<String>(
                  key: const ValueKey<String>('home-settings-timezone'),
                  options: _SettingsCard._timezones,
                  value: _timezone,
                  expand: true,
                  placeholder: 'Pick a time zone',
                  onChanged: (String value) => setState(() {
                    _timezone = value;
                    _justSaved = false;
                  }),
                ),
              ),
            ],
          ),
        ),
        CardFooter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              StyledText(
                status,
                TextStyles.small,
                color: theme.mutedForeground,
              ),
              SizedBox(height: space(3)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _cancel(),
                  SizedBox(width: space(2)),
                  Button(
                    key: const ValueKey<String>('home-settings-save'),
                    loading: _saving,
                    onPressed: _dirty && !_saving ? _save : null,
                    child: const Text('Save changes'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/* ── Card 5: a form, sign in (from the deleted sign-in-flow composition) ── */

class _SignInCard extends StatefulWidget {
  const _SignInCard();

  static final List<ValidationRule<String>> _emailRules =
      <ValidationRule<String>>[
        ValidationRule.minLength(1, 'An email address is required.'),
        ValidationRule.email('That is not an email address.'),
      ];
  static final List<ValidationRule<String>> _passwordRules =
      <ValidationRule<String>>[
        ValidationRule.minLength(1, 'A password is required.'),
      ];
  static const String _refusal =
      'That email and password do not match an account.';

  @override
  State<_SignInCard> createState() => _SignInCardState();
}

class _SignInCardState extends State<_SignInCard> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final FocusNode _passwordFocus = FocusNode(
    debugLabel: 'home-signin-password',
  );
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
    _passwordFocus.dispose();
    super.dispose();
  }

  void _onEdited() {
    if (_authError == null) return;
    setState(() => _authError = null);
  }

  List<String> get _emailIssues =>
      Validators.check<String>(_email.text, _SignInCard._emailRules);
  List<String> get _passwordIssues =>
      Validators.check<String>(_password.text, _SignInCard._passwordRules);
  bool get _valid => _emailIssues.isEmpty && _passwordIssues.isEmpty;

  Future<void> _submit() async {
    setState(() {
      _submitted = true;
      _authError = null;
    });
    if (!_valid) return;
    setState(() => _submitting = true);
    await Future<void>.delayed(MotionDurations.drawerOpen);
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _authError = _SignInCard._refusal;
    });
  }

  Widget _passwordRow(BuildContext context) => FieldVisibility(
    focusNode: _passwordFocus,
    child: Row(
      children: <Widget>[
        Expanded(
          child: Input(
            key: const ValueKey<String>('home-signin-password'),
            controller: _password,
            placeholder: 'Your password',
            obscureText: !_revealed,
            enabled: !_submitting,
          ),
        ),
        SizedBox(width: space(2)),
        Button(
          key: const ValueKey<String>('home-signin-reveal'),
          variant: ButtonVariant.ghost,
          size: ButtonSize.icon,
          label: _revealed ? 'Hide password' : 'Show password',
          onPressed: _submitting
              ? null
              : () => setState(() => _revealed = !_revealed),
          child: Icon(
            _revealed ? IconGlyph.eyeOff : IconGlyph.eye,
            size: IconSize.sm,
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final String? authError = _authError;
    final double gap = FieldSet.gap;

    return Card(
      children: <Widget>[
        const CardHeader(
          title: CardTitle('Sign in'),
          description: CardDescription(
            'A real form: validated fields and a submit.',
          ),
        ),
        CardContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (authError != null) ...<Widget>[
                Row(
                  key: const ValueKey<String>('home-signin-auth-error'),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Icon(
                      IconGlyph.alertTriangle,
                      size: IconSize.sm,
                      tone: IconTone.error,
                    ),
                    SizedBox(width: space(2)),
                    Expanded(
                      child: StyledText(
                        authError,
                        TextStyles.bodySmall,
                        color: theme.destructiveText,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: gap),
              ],
              Field(
                label: 'Email address',
                errors: _submitted ? _emailIssues : const <String>[],
                enabled: !_submitting,
                child: Input(
                  key: const ValueKey<String>('home-signin-email'),
                  controller: _email,
                  placeholder: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              SizedBox(height: gap),
              Field(
                label: 'Password',
                errors: _submitted ? _passwordIssues : const <String>[],
                enabled: !_submitting,
                focusNode: _passwordFocus,
                child: _passwordRow(context),
              ),
              SizedBox(height: gap),
              Button(
                key: const ValueKey<String>('home-signin-submit'),
                loading: _submitting,
                contentAlignment: AlignmentDirectional.center,
                onPressed: _submitting ? null : _submit,
                child: const Text('Sign in'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/* ── Card 6: stats, dashboard (from the deleted dashboard-overview shot) ── */

@immutable
class _DashStat {
  const _DashStat({
    required this.label,
    required this.value,
    required this.delta,
    required this.rising,
  });

  final String label;
  final String value;
  final String delta;
  final bool rising;
}

@immutable
class _DashActivity {
  const _DashActivity({
    required this.title,
    required this.meta,
    required this.amount,
    required this.glyph,
  });

  final String title;
  final String meta;
  final String amount;
  final IconGlyph glyph;
}

const List<_DashStat> _dashStats = <_DashStat>[
  _DashStat(label: 'Revenue', value: '48,120', delta: '+12.4%', rising: true),
  _DashStat(
    label: 'Active users',
    value: '9,431',
    delta: '+4.1%',
    rising: true,
  ),
  _DashStat(label: 'Conversion', value: '3.8%', delta: '+0.6pt', rising: true),
  _DashStat(label: 'Churn', value: '1.9%', delta: '-0.3pt', rising: false),
];

const List<_DashActivity> _dashActivity = <_DashActivity>[
  _DashActivity(
    title: 'Plan upgraded',
    meta: 'Team workspace',
    amount: '+240',
    glyph: IconGlyph.arrowUpRight,
  ),
  _DashActivity(
    title: 'Refund issued',
    meta: 'Order 4471',
    amount: '-96',
    glyph: IconGlyph.arrowDownLeft,
  ),
  _DashActivity(
    title: 'Invoice settled',
    meta: 'Annual contract',
    amount: '+1,880',
    glyph: IconGlyph.creditCard,
  ),
];

class _DashboardCard extends StatefulWidget {
  const _DashboardCard();

  @override
  State<_DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<_DashboardCard> {
  static const List<SelectOption<String>> _ranges = <SelectOption<String>>[
    SelectOption<String>(value: 'last-7-days', label: 'Last 7 days'),
    SelectOption<String>(value: 'last-30-days', label: 'Last 30 days'),
    SelectOption<String>(value: 'last-90-days', label: 'Last 90 days'),
  ];

  String _range = 'last-30-days';

  Widget _tile(BuildContext context, _DashStat stat) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Card(
      children: <Widget>[
        CardHeader(
          title: CardTitle(stat.label),
          action: Icon(
            stat.rising ? IconGlyph.trendingUp : IconGlyph.trendingDown,
            size: IconSize.sm,
            tone: stat.rising ? IconTone.success : IconTone.warning,
          ),
        ),
        CardContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              StyledText(stat.value, TextStyles.numberLg),
              SizedBox(height: space(1)),
              StyledText(
                stat.delta,
                TextStyles.caption,
                color: theme.mutedForeground,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Two tiles abreast once the card has room for them, one otherwise. Read
  /// off this card's own constraints, never the window: a masonry cell can be
  /// narrow on a wide screen just as easily as on a phone.
  Widget _tiles(BuildContext context) => LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      final int columns = constraints.maxWidth >= space(70) ? 2 : 1;
      final double gap = Card.spacing;
      final List<Widget> rows = <Widget>[];
      for (int start = 0; start < _dashStats.length; start += columns) {
        final List<Widget> cells = <Widget>[];
        for (int c = 0; c < columns; c++) {
          if (cells.isNotEmpty) cells.add(SizedBox(width: gap));
          final int index = start + c;
          cells.add(
            Expanded(
              child: index < _dashStats.length
                  ? _tile(context, _dashStats[index])
                  : const SizedBox.shrink(),
            ),
          );
        }
        if (rows.isNotEmpty) rows.add(SizedBox(height: gap));
        rows.add(
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: cells),
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: rows,
      );
    },
  );

  Widget _activityRow(BuildContext context, _DashActivity entry) {
    return Dialog(
      trigger: (BuildContext context, VoidCallback open) => Button(
        variant: ButtonVariant.ghost,
        autoHeight: true,
        contentAlignment: AlignmentDirectional.centerStart,
        padding: EdgeInsets.symmetric(horizontal: space(2), vertical: space(1)),
        onPressed: open,
        child: Row(
          children: <Widget>[
            Icon(entry.glyph, size: IconSize.sm, tone: IconTone.muted),
            SizedBox(width: space(2)),
            Expanded(
              child: StyledText(
                entry.title,
                TextStyles.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: space(2)),
            StyledText(entry.amount, TextStyles.numberSm),
          ],
        ),
      ),
      content: (BuildContext context, VoidCallback close) => DialogContent(
        onClose: close,
        children: <Widget>[
          DialogHeader(
            children: <Widget>[
              DialogTitle(entry.title),
              DialogDescription('${entry.meta}. Net change ${entry.amount}.'),
            ],
          ),
          DialogFooter(
            children: <Widget>[
              Button(
                variant: ButtonVariant.outline,
                onPressed: close,
                child: const Text('Close'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double gap = Card.spacing;
    return Card(
      children: <Widget>[
        const CardHeader(
          title: CardTitle('Overview'),
          description: CardDescription(
            'How the account moved, with a drill-in on every row.',
          ),
        ),
        CardContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Select<String>(
                key: const ValueKey<String>('home-dashboard-range'),
                options: _ranges,
                value: _range,
                expand: true,
                onChanged: (String value) => setState(() => _range = value),
              ),
              SizedBox(height: gap),
              _tiles(context),
              SizedBox(height: gap),
              StyledText('Recent activity', TextStyles.h4),
              SizedBox(height: space(2)),
              for (final _DashActivity entry in _dashActivity)
                _activityRow(context, entry),
            ],
          ),
        ),
      ],
    );
  }
}
