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
import 'package:flutter/widgets.dart';

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
/// Unlike `kit.dart`'s `ElGrid`, a row here never stretches every cell to its
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
    if (sm != null && viewport >= ElBreakpoints.sm) columns = sm!;
    if (lg != null && viewport >= ElBreakpoints.lg) columns = lg!;
    return columns;
  }

  @override
  Widget build(BuildContext context) {
    final double space = gap ?? el(4);
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
          if (c > 0) SizedBox(width: space),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                for (int i = 0; i < buckets[c].length; i++) ...<Widget>[
                  if (i > 0) SizedBox(height: space),
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
    final ElThemeData theme = ElTheme.of(context);
    return ElCard(
      children: <Widget>[
        const ElCardHeader(
          title: ElCardTitle('Building blocks'),
          description: ElCardDescription(
            'Buttons, badges, an input and a toggle group, wired up.',
          ),
        ),
        ElCardContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Wrap(
                spacing: el(2),
                runSpacing: el(2),
                children: <Widget>[
                  ElButton(
                    size: ElButtonSize.sm,
                    onPressed: () {},
                    child: const Text('Primary'),
                  ),
                  ElButton(
                    size: ElButtonSize.sm,
                    variant: ElButtonVariant.outline,
                    onPressed: () {},
                    child: const Text('Outline'),
                  ),
                  ElButton(
                    size: ElButtonSize.sm,
                    variant: ElButtonVariant.ghost,
                    onPressed: () {},
                    child: const Text('Ghost'),
                  ),
                ],
              ),
              SizedBox(height: el(3)),
              Wrap(
                spacing: el(2),
                runSpacing: el(2),
                children: const <Widget>[
                  ElBadge(label: 'Stable'),
                  ElBadge(label: 'New', variant: ElBadgeVariant.action),
                  ElBadge(label: 'Shipped', variant: ElBadgeVariant.success),
                  ElBadge(label: 'Beta', variant: ElBadgeVariant.outline),
                ],
              ),
              SizedBox(height: el(3)),
              ElInput(
                key: const ValueKey<String>('home-components-search'),
                controller: _search,
                placeholder: 'Search components',
              ),
              SizedBox(height: el(3)),
              Row(
                children: <Widget>[
                  ElSwitch(
                    key: const ValueKey<String>('home-components-switch'),
                    value: _notify,
                    onChanged: (bool value) => setState(() => _notify = value),
                  ),
                  SizedBox(width: el(2)),
                  Flexible(
                    child: ElText(
                      'Notify on release',
                      ElType.small,
                      color: theme.mutedForeground,
                    ),
                  ),
                ],
              ),
              SizedBox(height: el(3)),
              ElToggleGroup(
                key: const ValueKey<String>('home-components-toggle'),
                items: const <ElToggleGroupItem>[
                  ElToggleGroupItem(label: 'Grid'),
                  ElToggleGroupItem(label: 'List'),
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
    final ElThemeData theme = ElTheme.of(context);
    return ElCard(
      children: <Widget>[
        const ElCardHeader(
          title: ElCardTitle('Sessions'),
          description: ElCardDescription('Last 6 months, one real chart.'),
        ),
        ElCardContent(
          child: ElChartContainer(
            height: el(48),
            config: ElChartConfig(<String, ElChartSeries>{
              'sessions': ElChartSeries(label: 'Sessions', color: theme.chart1),
            }),
            child: ElCartesianChart(
              data: _data,
              grid: const ElChartGrid(vertical: false),
              xAxis: const ElChartAxis(
                dataKey: 'month',
                tickLine: false,
                axisLine: false,
              ),
              tooltip: const ElChartTooltipSpec(
                cursor: false,
                indicator: ElChartIndicator.line,
              ),
              series: <ElChartSeriesSpec>[
                ElChartSeriesSpec(
                  kind: ElChartSeriesKind.area,
                  dataKey: 'sessions',
                  curve: ElCurveType.natural,
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
    return ElCard(
      children: <Widget>[
        const ElCardHeader(
          title: ElCardTitle('Say something'),
          description: ElCardDescription('A real ElMessageGroup, typed below.'),
        ),
        ElCardContent(
          child: ElMessageGroup(
            children: <Widget>[
              const ElMessage(
                content: ElMessageContent(
                  children: <Widget>[
                    ElBubble(
                      variant: ElBubbleVariant.muted,
                      child: ElBubbleContent(
                        child: Text('What can this system do?'),
                      ),
                    ),
                  ],
                ),
              ),
              const ElMessage(
                align: ElBubbleAlign.end,
                content: ElMessageContent(
                  children: <Widget>[
                    ElBubble(
                      align: ElBubbleAlign.end,
                      child: ElBubbleContent(
                        child: Text('Copy a component in, keep every token.'),
                      ),
                    ),
                  ],
                ),
              ),
              for (final String text in _sent)
                ElMessage(
                  align: ElBubbleAlign.end,
                  content: ElMessageContent(
                    children: <Widget>[
                      ElBubble(
                        align: ElBubbleAlign.end,
                        child: ElBubbleContent(child: Text(text)),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        ElCardFooter(
          child: Row(
            children: <Widget>[
              Expanded(
                child: ElInput(
                  key: const ValueKey<String>('home-chat-input'),
                  controller: _draft,
                  placeholder: 'Type a message',
                  onSubmitted: (_) => _send(),
                ),
              ),
              SizedBox(width: el(2)),
              ElButton(
                key: const ValueKey<String>('home-chat-send'),
                size: ElButtonSize.icon,
                label: 'Send message',
                onPressed: _send,
                child: const ElIcon.lucide(ElLucide.send, size: ElIconSize.sm),
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

  static final List<ElRule<String>> _nameRules = <ElRule<String>>[
    ElRule.minLength(2, 'Use at least 2 characters.'),
  ];

  static final List<ElRule<String>> _emailRules = <ElRule<String>>[
    ElRule.minLength(1, 'An email address is required.'),
    ElRule.email('That is not an email address.'),
  ];

  static const List<ElSelectOption<String>> _timezones =
      <ElSelectOption<String>>[
        ElSelectOption<String>(
          value: 'america-los-angeles',
          label: 'Los Angeles',
        ),
        ElSelectOption<String>(value: 'america-new-york', label: 'New York'),
        ElSelectOption<String>(value: 'europe-lisbon', label: 'Lisbon'),
        ElSelectOption<String>(value: 'asia-tokyo', label: 'Tokyo'),
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
      ElRules.check<String>(_name.text, _SettingsCard._nameRules);
  List<String> get _emailIssues =>
      ElRules.check<String>(_email.text, _SettingsCard._emailRules);
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
    await Future<void>.delayed(ElDurations.slow);
    if (!mounted) return;
    setState(() {
      _saving = false;
      _justSaved = true;
      _saved = pending;
    });
  }

  Widget _cancel() => ElAlertDialog(
    trigger: (BuildContext context, VoidCallback open) => ElButton(
      key: const ValueKey<String>('home-settings-cancel'),
      variant: ElButtonVariant.ghost,
      onPressed: _dirty && !_saving ? open : null,
      child: const Text('Cancel'),
    ),
    content: (BuildContext context, VoidCallback close) => ElAlertDialogContent(
      header: const ElAlertDialogHeader(
        title: ElAlertDialogTitle('Discard your changes?'),
        description: ElAlertDialogDescription(
          'This restores the values this panel opened with.',
        ),
      ),
      footer: ElAlertDialogFooter(
        cancel: ElAlertDialogCancel(label: 'Keep editing', onPressed: close),
        action: ElAlertDialogAction(
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
    final ElThemeData theme = ElTheme.of(context);
    final bool show = _submitted;
    final String status = _saving
        ? 'Saving…'
        : _justSaved
        ? 'All changes saved.'
        : _dirty
        ? 'You have unsaved changes.'
        : 'Up to date.';

    return ElCard(
      children: <Widget>[
        const ElCardHeader(
          title: ElCardTitle('Profile'),
          description: ElCardDescription(
            'How this account is addressed, edited live.',
          ),
        ),
        ElCardContent(
          child: ElFieldSet(
            children: <Widget>[
              ElField(
                label: 'Display name',
                errors: show ? _nameIssues : const <String>[],
                enabled: !_saving,
                child: ElInput(
                  key: const ValueKey<String>('home-settings-name'),
                  controller: _name,
                  placeholder: 'Your name',
                ),
              ),
              ElField(
                label: 'Email address',
                errors: show ? _emailIssues : const <String>[],
                enabled: !_saving,
                child: ElInput(
                  key: const ValueKey<String>('home-settings-email'),
                  controller: _email,
                  placeholder: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              ElField(
                label: 'Time zone',
                enabled: !_saving,
                child: ElSelect<String>(
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
        ElCardFooter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElText(status, ElType.small, color: theme.mutedForeground),
              SizedBox(height: el(3)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _cancel(),
                  SizedBox(width: el(2)),
                  ElButton(
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

  static final List<ElRule<String>> _emailRules = <ElRule<String>>[
    ElRule.minLength(1, 'An email address is required.'),
    ElRule.email('That is not an email address.'),
  ];
  static final List<ElRule<String>> _passwordRules = <ElRule<String>>[
    ElRule.minLength(1, 'A password is required.'),
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
      ElRules.check<String>(_email.text, _SignInCard._emailRules);
  List<String> get _passwordIssues =>
      ElRules.check<String>(_password.text, _SignInCard._passwordRules);
  bool get _valid => _emailIssues.isEmpty && _passwordIssues.isEmpty;

  Future<void> _submit() async {
    setState(() {
      _submitted = true;
      _authError = null;
    });
    if (!_valid) return;
    setState(() => _submitting = true);
    await Future<void>.delayed(ElDurations.drawer);
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _authError = _SignInCard._refusal;
    });
  }

  Widget _passwordRow(BuildContext context) => ElFieldVisibility(
    focusNode: _passwordFocus,
    child: Row(
      children: <Widget>[
        Expanded(
          child: ElInput(
            key: const ValueKey<String>('home-signin-password'),
            controller: _password,
            placeholder: 'Your password',
            obscureText: !_revealed,
            enabled: !_submitting,
          ),
        ),
        SizedBox(width: el(2)),
        ElButton(
          key: const ValueKey<String>('home-signin-reveal'),
          variant: ElButtonVariant.ghost,
          size: ElButtonSize.icon,
          label: _revealed ? 'Hide password' : 'Show password',
          onPressed: _submitting
              ? null
              : () => setState(() => _revealed = !_revealed),
          child: ElIcon(
            _revealed ? ElIconGlyph.eyeOff : ElIconGlyph.eye,
            size: ElIconSize.sm,
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final String? authError = _authError;
    final double gap = ElFieldSet.gap;

    return ElCard(
      children: <Widget>[
        const ElCardHeader(
          title: ElCardTitle('Sign in'),
          description: ElCardDescription(
            'A real form: validated fields and a submit.',
          ),
        ),
        ElCardContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (authError != null) ...<Widget>[
                Row(
                  key: const ValueKey<String>('home-signin-auth-error'),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const ElIcon(
                      ElIconGlyph.alertTriangle,
                      size: ElIconSize.sm,
                      tone: ElIconTone.error,
                    ),
                    SizedBox(width: el(2)),
                    Expanded(
                      child: ElText(
                        authError,
                        ElComponentType.textSm,
                        color: theme.destructiveInk,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: gap),
              ],
              ElField(
                label: 'Email address',
                errors: _submitted ? _emailIssues : const <String>[],
                enabled: !_submitting,
                child: ElInput(
                  key: const ValueKey<String>('home-signin-email'),
                  controller: _email,
                  placeholder: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              SizedBox(height: gap),
              ElField(
                label: 'Password',
                errors: _submitted ? _passwordIssues : const <String>[],
                enabled: !_submitting,
                focusNode: _passwordFocus,
                child: _passwordRow(context),
              ),
              SizedBox(height: gap),
              ElButton(
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
  final ElIconGlyph glyph;
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
    glyph: ElIconGlyph.arrowUpRight,
  ),
  _DashActivity(
    title: 'Refund issued',
    meta: 'Order 4471',
    amount: '-96',
    glyph: ElIconGlyph.arrowDownLeft,
  ),
  _DashActivity(
    title: 'Invoice settled',
    meta: 'Annual contract',
    amount: '+1,880',
    glyph: ElIconGlyph.creditCard,
  ),
];

class _DashboardCard extends StatefulWidget {
  const _DashboardCard();

  @override
  State<_DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<_DashboardCard> {
  static const List<ElSelectOption<String>> _ranges = <ElSelectOption<String>>[
    ElSelectOption<String>(value: 'last-7-days', label: 'Last 7 days'),
    ElSelectOption<String>(value: 'last-30-days', label: 'Last 30 days'),
    ElSelectOption<String>(value: 'last-90-days', label: 'Last 90 days'),
  ];

  String _range = 'last-30-days';

  Widget _tile(BuildContext context, _DashStat stat) {
    final ElThemeData theme = ElTheme.of(context);
    return ElCard(
      children: <Widget>[
        ElCardHeader(
          title: ElCardTitle(stat.label),
          action: ElIcon(
            stat.rising ? ElIconGlyph.trendingUp : ElIconGlyph.trendingDown,
            size: ElIconSize.sm,
            tone: stat.rising ? ElIconTone.success : ElIconTone.warning,
          ),
        ),
        ElCardContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElText(stat.value, ElType.numLg),
              SizedBox(height: el(1)),
              ElText(stat.delta, ElType.caption, color: theme.mutedForeground),
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
      final int columns = constraints.maxWidth >= el(70) ? 2 : 1;
      final double gap = ElCard.spacing;
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
    return ElDialog(
      trigger: (BuildContext context, VoidCallback open) => ElButton(
        variant: ElButtonVariant.ghost,
        autoHeight: true,
        contentAlignment: AlignmentDirectional.centerStart,
        padding: EdgeInsets.symmetric(horizontal: el(2), vertical: el(1)),
        onPressed: open,
        child: Row(
          children: <Widget>[
            ElIcon(entry.glyph, size: ElIconSize.sm, tone: ElIconTone.muted),
            SizedBox(width: el(2)),
            Expanded(
              child: ElText(
                entry.title,
                ElComponentType.textSm,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: el(2)),
            ElText(entry.amount, ElType.numSm),
          ],
        ),
      ),
      content: (BuildContext context, VoidCallback close) => ElDialogContent(
        onClose: close,
        children: <Widget>[
          ElDialogHeader(
            children: <Widget>[
              ElDialogTitle(entry.title),
              ElDialogDescription('${entry.meta}. Net change ${entry.amount}.'),
            ],
          ),
          ElDialogFooter(
            children: <Widget>[
              ElButton(
                variant: ElButtonVariant.outline,
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
    final double gap = ElCard.spacing;
    return ElCard(
      children: <Widget>[
        const ElCardHeader(
          title: ElCardTitle('Overview'),
          description: ElCardDescription(
            'How the account moved, with a drill-in on every row.',
          ),
        ),
        ElCardContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElSelect<String>(
                key: const ValueKey<String>('home-dashboard-range'),
                options: _ranges,
                value: _range,
                expand: true,
                onChanged: (String value) => setState(() => _range = value),
              ),
              SizedBox(height: gap),
              _tiles(context),
              SizedBox(height: gap),
              ElText('Recent activity', ElType.h4),
              SizedBox(height: el(2)),
              for (final _DashActivity entry in _dashActivity)
                _activityRow(context, entry),
            ],
          ),
        ),
      ],
    );
  }
}
