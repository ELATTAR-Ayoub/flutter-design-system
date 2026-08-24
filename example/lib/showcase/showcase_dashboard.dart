/// Signal Studio's performance dashboard.
library;

import 'dart:async';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../kit.dart';
import 'showcase_feedback.dart';
import 'showcase_shell_scope.dart';

class ShowcaseDashboard extends StatefulWidget {
  const ShowcaseDashboard({super.key});

  @override
  State<ShowcaseDashboard> createState() => _ShowcaseDashboardState();
}

class _ShowcaseDashboardState extends State<ShowcaseDashboard> {
  bool _loading = true;
  bool _failed = false;
  bool _hasLoaded = false;
  int _reloads = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _load() {
    _timer?.cancel();
    setState(() {
      _loading = true;
      _failed = false;
    });
    _timer = Timer(ElDurations.fast, () {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _reloads++;
      });
      if (_hasLoaded) {
        ShowcaseFeedback.of(context).success(
          'Studio data is current',
          description: 'Your latest creator signals are ready.',
        );
      }
      _hasLoaded = true;
    });
  }

  void _showUnavailable() {
    _timer?.cancel();
    setState(() {
      _loading = false;
      _failed = true;
    });
    ShowcaseFeedback.of(context).error(
      'Signal refresh paused',
      description: 'Retry when the connection is ready.',
      action: ElToastAction(label: 'Retry', onPressed: _load),
    );
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(el(5), el(2), el(5), 0),
    child: Semantics(
      label: 'Signal Studio dashboard',
      child: _loading
          ? const _DashboardSkeleton()
          : _failed
          ? _DashboardFailure(onRetry: _load)
          : ElSwapIn(
              replayKey: _reloads,
              child: _DashboardContent(
                onRefresh: _load,
                onShowUnavailable: _showUnavailable,
              ),
            ),
    ),
  );
}

class _DashboardContent extends StatefulWidget {
  const _DashboardContent({
    required this.onRefresh,
    required this.onShowUnavailable,
  });

  final VoidCallback onRefresh;
  final VoidCallback onShowUnavailable;

  @override
  State<_DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<_DashboardContent> {
  static const List<ElSelectOption<String>> _ranges = <ElSelectOption<String>>[
    ElSelectOption<String>(value: '7d', label: 'Last 7 days'),
    ElSelectOption<String>(value: '30d', label: 'Last 30 days'),
    ElSelectOption<String>(value: '90d', label: 'Last 3 months'),
  ];

  String _range = '7d';
  final Set<String> _scheduled = <String>{};

  String get _rangeLabel => switch (_range) {
    '30d' => 'Last 30 days',
    '90d' => 'Last 3 months',
    _ => 'Last 7 days',
  };

  String get _qualifiedPlays => switch (_range) {
    '30d' => '318.6K',
    '90d' => '914.2K',
    _ => '82.4K',
  };

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    key: const Key('dashboard-scroll'),
    padding: ElSafeArea.scrollPaddingOf(
      context,
      base: EdgeInsets.only(
        bottom: el(5) + ShowcaseShellScope.bottomOverlayClearanceOf(context),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Align(
          alignment: Alignment.centerRight,
          child: ElSelect<String>(
            width: el(40),
            label: 'Dashboard range',
            value: _range,
            onChanged: (String value) => setState(() => _range = value),
            options: _ranges,
          ),
        ),
        SizedBox(height: el(4)),
        _DashboardHero(
          onRefresh: widget.onRefresh,
          rangeLabel: _rangeLabel,
          qualifiedPlays: _qualifiedPlays,
        ),
        SizedBox(height: el(5)),
        _MetricsStrip(range: _range),
        SizedBox(height: el(5)),
        _MomentumFocus(rangeLabel: _rangeLabel),
        SizedBox(height: el(5)),
        ElGrid(
          lg: 2,
          gap: el(5),
          children: <Widget>[
            _ContentQueue(
              scheduled: _scheduled,
              onSchedule: (String id) => setState(() {
                if (!_scheduled.add(id)) _scheduled.remove(id);
              }),
            ),
            _StudioPulse(onShowUnavailable: widget.onShowUnavailable),
          ],
        ),
        SizedBox(height: el(5)),
        const _AudienceInsight(),
        SizedBox(height: el(5)),
        const _RecentActivity(),
        SizedBox(height: el(5)),
        const ElAlert(
          key: Key('dashboard-scroll-end'),
          title: 'Plan the next cut around the strongest signal.',
          description:
              'Behind-the-scenes retention is rising before the final reveal.',
          variant: ElAlertVariant.info,
          icon: ElIcon.lucide(ElLucide.sparkles, tone: ElIconTone.inherit),
        ),
      ],
    ),
  );
}

class _DashboardHero extends StatelessWidget {
  const _DashboardHero({
    required this.onRefresh,
    required this.rangeLabel,
    required this.qualifiedPlays,
  });

  final VoidCallback onRefresh;
  final String rangeLabel;
  final String qualifiedPlays;

  @override
  Widget build(BuildContext context) => ElGlassPanelDeep(
    key: const Key('dashboard-hero-surface'),
    radius: BorderRadius.circular(ElRadii.xl3),
    padding: EdgeInsets.all(el(5)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ElText('This week in motion', ElType.section),
                  SizedBox(height: el(1)),
                  ElText(
                    'One clear read on what your audience carried forward.',
                    ElType.small,
                  ),
                ],
              ),
            ),
            ElButton(
              variant: ElButtonVariant.primary,
              size: ElButtonSize.sm,
              label: 'Refresh dashboard',
              onPressed: onRefresh,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const ElIcon.lucide(ElLucide.refreshCw, size: ElIconSize.sm),
                  SizedBox(width: ElButton.gapFor(ElButtonSize.sm)),
                  ElText('Refresh', ElComponentType.buttonLabel),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: el(6)),
        ElText(qualifiedPlays, ElType.numXl),
        SizedBox(height: el(2)),
        ElText(
          'TOTAL QUALIFIED PLAYS · ${rangeLabel.toUpperCase()}',
          ElType.label,
        ),
        SizedBox(height: el(3)),
        const ElBadge(
          label: '+18.6% week over week',
          variant: ElBadgeVariant.success,
          glyph: ElIcon.lucide(ElLucide.trendingUp),
        ),
      ],
    ),
  );
}

class _MetricsStrip extends StatelessWidget {
  const _MetricsStrip({required this.range});

  final String range;

  @override
  Widget build(BuildContext context) {
    final bool extended = range != '7d';
    return ElGrid(
      sm: 2,
      xl: 4,
      gap: el(4),
      children: <Widget>[
        ElStat(
          label: 'Saves',
          value: extended ? '24,610' : '6,820',
          delta: const (value: '14.2%', direction: ElStatDirection.up),
          hint: 'vs last week',
        ),
        ElStat(
          label: 'Shares',
          value: extended ? '8,972' : '2,146',
          delta: const (value: '8.1%', direction: ElStatDirection.up),
          hint: 'vs last week',
        ),
        const ElStat(
          label: 'Completion',
          value: '71.8%',
          delta: (value: '4.4%', direction: ElStatDirection.up),
          hint: 'vs last week',
        ),
        ElStat(
          label: 'New followers',
          value: extended ? '5,408' : '1,284',
          delta: const (value: '2.6%', direction: ElStatDirection.up),
          hint: 'vs last week',
        ),
      ],
    );
  }
}

class _MomentumFocus extends StatelessWidget {
  const _MomentumFocus({required this.rangeLabel});

  final String rangeLabel;

  static const List<Map<String, Object?>> _data = <Map<String, Object?>>[
    <String, Object?>{'day': 'Mon', 'plays': 48},
    <String, Object?>{'day': 'Tue', 'plays': 63},
    <String, Object?>{'day': 'Wed', 'plays': 57},
    <String, Object?>{'day': 'Thu', 'plays': 79},
    <String, Object?>{'day': 'Fri', 'plays': 88},
    <String, Object?>{'day': 'Sat', 'plays': 96},
    <String, Object?>{'day': 'Sun', 'plays': 82},
  ];

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return ElGlassPanel(
      key: const Key('dashboard-chart-focus'),
      radius: BorderRadius.circular(ElRadii.xl),
      padding: EdgeInsets.all(el(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ElText('Momentum', ElType.section),
          SizedBox(height: el(1)),
          ElText('Qualified plays · $rangeLabel.', ElType.small),
          SizedBox(height: el(4)),
          ElChartContainer(
            height: el(52),
            config: ElChartConfig(<String, ElChartSeries>{
              'plays': ElChartSeries(
                label: 'Qualified plays',
                color: theme.chart1,
              ),
            }),
            child: ElCartesianChart(
              data: _data,
              grid: const ElChartGrid(vertical: false),
              xAxis: const ElChartAxis(
                dataKey: 'day',
                tickLine: false,
                axisLine: false,
              ),
              tooltip: const ElChartTooltipSpec(
                cursor: false,
                indicator: ElChartIndicator.line,
              ),
              series: <ElChartSeriesSpec>[
                ElChartSeriesSpec(
                  kind: ElChartSeriesKind.line,
                  dataKey: 'plays',
                  curve: ElCurveType.natural,
                  stroke: theme.chart1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContentQueue extends StatelessWidget {
  const _ContentQueue({required this.scheduled, required this.onSchedule});

  final Set<String> scheduled;
  final ValueChanged<String> onSchedule;

  @override
  Widget build(BuildContext context) => _OutlinedSection(
    title: 'Content queue',
    description: 'Cuts ready for a publish decision.',
    child: ElItemGroup(
      gapOverride: el(2),
      children: <Widget>[
        _QueueItem(
          id: 'night-desk',
          title: 'Night desk field notes',
          detail: 'Ready · Best window today at 8:40 PM',
          scheduled: scheduled.contains('night-desk'),
          onSchedule: onSchedule,
        ),
        _QueueItem(
          id: 'quiet-system',
          title: 'A quiet system for louder work',
          detail: 'Review passed · Caption needs approval',
          scheduled: scheduled.contains('quiet-system'),
          onSchedule: onSchedule,
        ),
        _QueueItem(
          id: 'materials',
          title: 'Materials in motion',
          detail: 'Ready · Audience overlap is low',
          scheduled: scheduled.contains('materials'),
          onSchedule: onSchedule,
        ),
      ],
    ),
  );
}

class _QueueItem extends StatelessWidget {
  const _QueueItem({
    required this.id,
    required this.title,
    required this.detail,
    required this.scheduled,
    required this.onSchedule,
  });

  final String id;
  final String title;
  final String detail;
  final bool scheduled;
  final ValueChanged<String> onSchedule;

  @override
  Widget build(BuildContext context) => ElItem(
    variant: ElItemVariant.outline,
    alignStart: true,
    media: ElItemMedia(
      child: ElIcon.lucide(
        scheduled ? ElLucide.calendarCheck : ElLucide.clapperboard,
        size: ElIconSize.sm,
        tone: scheduled ? ElIconTone.success : ElIconTone.muted,
      ),
    ),
    content: ElItemContent(
      children: <Widget>[
        ElItemTitle(title),
        ElItemDescription(detail),
        ElBadge(
          label: scheduled ? 'SCHEDULED' : 'READY',
          variant: scheduled
              ? ElBadgeVariant.success
              : ElBadgeVariant.secondary,
        ),
      ],
    ),
    actions: ElItemActions(
      children: <Widget>[
        ElButton(
          size: ElButtonSize.sm,
          variant: scheduled
              ? ElButtonVariant.ghost
              : ElButtonVariant.secondary,
          onPressed: () => onSchedule(id),
          child: ElText(
            scheduled ? 'Undo' : 'Schedule',
            ElComponentType.buttonLabel,
          ),
        ),
      ],
    ),
  );
}

class _StudioPulse extends StatelessWidget {
  const _StudioPulse({required this.onShowUnavailable});

  final VoidCallback onShowUnavailable;

  @override
  Widget build(BuildContext context) => _OutlinedSection(
    title: 'Studio pulse',
    description: 'What needs a decision today.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const _PulseItem(
          glyph: ElLucide.circleCheck,
          tone: ElIconTone.success,
          title: 'Edit approved',
          detail: 'Quiet architecture is ready to publish.',
        ),
        SizedBox(height: el(3)),
        const _PulseItem(
          glyph: ElLucide.bell,
          tone: ElIconTone.action,
          title: 'Audience peak ahead',
          detail: 'Your next publish window opens in 42 minutes.',
        ),
        SizedBox(height: el(4)),
        ElButton(
          variant: ElButtonVariant.outline,
          size: ElButtonSize.sm,
          onPressed: onShowUnavailable,
          child: ElText('Test recovery feedback', ElComponentType.buttonLabel),
        ),
      ],
    ),
  );
}

class _PulseItem extends StatelessWidget {
  const _PulseItem({
    required this.glyph,
    required this.tone,
    required this.title,
    required this.detail,
  });

  final ElLucideGlyph glyph;
  final ElIconTone tone;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => ElItem(
    media: ElItemMedia(
      child: ElIcon.lucide(glyph, size: ElIconSize.sm, tone: tone),
    ),
    content: ElItemContent(
      children: <Widget>[ElItemTitle(title), ElItemDescription(detail)],
    ),
  );
}

class _AudienceInsight extends StatelessWidget {
  const _AudienceInsight();

  @override
  Widget build(BuildContext context) => ElAlert(
    title: 'Audience insight',
    description:
        'Returning viewers are at 38.6%, the strongest result in 12 weeks.',
    variant: ElAlertVariant.info,
    icon: const ElIcon.lucide(ElLucide.usersRound, tone: ElIconTone.inherit),
    action: ElButton(
      variant: ElButtonVariant.secondary,
      size: ElButtonSize.sm,
      onPressed: () => ShowcaseFeedback.of(context).info(
        'Insight saved',
        description: 'A reminder is waiting in your next planning session.',
      ),
      child: ElText('Save insight', ElComponentType.buttonLabel),
    ),
  );
}

class _RecentActivity extends StatelessWidget {
  const _RecentActivity();

  @override
  Widget build(BuildContext context) => _OutlinedSection(
    title: 'Recent activity',
    description: 'Small events worth carrying into the next cut.',
    child: const ElItemGroup(
      children: <Widget>[
        _ActivityItem(
          title: 'Work in progress passed 10K saves',
          detail: 'Community signal · 18 minutes ago',
          glyph: ElLucide.bookmarkCheck,
        ),
        _ActivityItem(
          title: 'Three collaborators joined your review queue',
          detail: 'Workflow signal · 46 minutes ago',
          glyph: ElLucide.usersRound,
        ),
        _ActivityItem(
          title: 'A returning viewer finished your new sequence',
          detail: 'Retention signal · 1 hour ago',
          glyph: ElLucide.arrowUpRight,
        ),
      ],
    ),
  );
}

class _ActivityItem extends StatelessWidget {
  const _ActivityItem({
    required this.title,
    required this.detail,
    required this.glyph,
  });

  final String title;
  final String detail;
  final ElLucideGlyph glyph;

  @override
  Widget build(BuildContext context) => ElItem(
    media: ElItemMedia(
      child: ElIcon.lucide(glyph, size: ElIconSize.sm, tone: ElIconTone.muted),
    ),
    content: ElItemContent(
      children: <Widget>[ElItemTitle(title), ElItemDescription(detail)],
    ),
  );
}

class _OutlinedSection extends StatelessWidget {
  const _OutlinedSection({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      ElText(title, ElType.section),
      SizedBox(height: el(1)),
      ElText(description, ElType.small),
      SizedBox(height: el(3)),
      child,
    ],
  );
}

class _DashboardFailure extends StatelessWidget {
  const _DashboardFailure({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: ElAlert(
      title: 'The studio signals are temporarily unavailable.',
      description:
          'No dashboard data was changed. Retry when you are ready to reconnect.',
      variant: ElAlertVariant.destructive,
      icon: const ElIcon.lucide(ElLucide.circleAlert, tone: ElIconTone.inherit),
      action: ElButton(
        variant: ElButtonVariant.secondary,
        size: ElButtonSize.sm,
        onPressed: onRetry,
        child: ElText('Retry', ElComponentType.buttonLabel),
      ),
    ),
  );
}

class _DashboardSkeleton extends StatelessWidget {
  const _DashboardSkeleton();

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.only(
      bottom: ShowcaseShellScope.bottomOverlayClearanceOf(context),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ElSkeleton(height: ElChartContainer.plotHeight),
        SizedBox(height: el(5)),
        ElGrid(
          sm: 2,
          xl: 4,
          gap: el(4),
          children: <Widget>[
            ElSkeleton(height: el(20)),
            ElSkeleton(height: el(20)),
            ElSkeleton(height: el(20)),
            ElSkeleton(height: el(20)),
          ],
        ),
        SizedBox(height: el(5)),
        ElSkeleton(height: ElChartContainer.plotHeight),
      ],
    ),
  );
}
