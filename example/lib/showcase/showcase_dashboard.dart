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
    _timer = Timer(DsDurations.fast, () {
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
      action: DsToastAction(label: 'Retry', onPressed: _load),
    );
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(ds(5), ds(2), ds(5), 0),
    child: Semantics(
      label: 'Signal Studio dashboard',
      child: _loading
          ? const _DashboardSkeleton()
          : _failed
          ? _DashboardFailure(onRetry: _load)
          : DsSwapIn(
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
  static const List<DsSelectOption<String>> _ranges = <DsSelectOption<String>>[
    DsSelectOption<String>(value: '7d', label: 'Last 7 days'),
    DsSelectOption<String>(value: '30d', label: 'Last 30 days'),
    DsSelectOption<String>(value: '90d', label: 'Last 3 months'),
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
    padding: DsSafeArea.scrollPaddingOf(
      context,
      base: EdgeInsets.only(
        bottom: ds(5) + ShowcaseShellScope.bottomOverlayClearanceOf(context),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Align(
          alignment: Alignment.centerRight,
          child: DsSelect<String>(
            width: ds(40),
            label: 'Dashboard range',
            value: _range,
            onChanged: (String value) => setState(() => _range = value),
            options: _ranges,
          ),
        ),
        SizedBox(height: ds(4)),
        _DashboardHero(
          onRefresh: widget.onRefresh,
          rangeLabel: _rangeLabel,
          qualifiedPlays: _qualifiedPlays,
        ),
        SizedBox(height: ds(5)),
        _MetricsStrip(range: _range),
        SizedBox(height: ds(5)),
        _MomentumFocus(rangeLabel: _rangeLabel),
        SizedBox(height: ds(5)),
        DsGrid(
          lg: 2,
          gap: ds(5),
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
        SizedBox(height: ds(5)),
        const _AudienceInsight(),
        SizedBox(height: ds(5)),
        const _RecentActivity(),
        SizedBox(height: ds(5)),
        const DsAlert(
          key: Key('dashboard-scroll-end'),
          title: 'Plan the next cut around the strongest signal.',
          description:
              'Behind-the-scenes retention is rising before the final reveal.',
          variant: DsAlertVariant.info,
          icon: DsIcon.lucide(DsLucide.sparkles, tone: DsIconTone.inherit),
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
  Widget build(BuildContext context) => DsGlassPanelDeep(
    key: const Key('dashboard-hero-surface'),
    radius: BorderRadius.circular(DsRadii.xl3),
    padding: EdgeInsets.all(ds(5)),
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
                  DsText('This week in motion', DsType.section),
                  SizedBox(height: ds(1)),
                  DsText(
                    'One clear read on what your audience carried forward.',
                    DsType.small,
                  ),
                ],
              ),
            ),
            DsButton(
              variant: DsButtonVariant.primary,
              size: DsButtonSize.sm,
              label: 'Refresh dashboard',
              onPressed: onRefresh,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const DsIcon.lucide(DsLucide.refreshCw, size: DsIconSize.sm),
                  SizedBox(width: DsButton.gapFor(DsButtonSize.sm)),
                  DsText('Refresh', DsComponentType.buttonLabel),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        DsText(qualifiedPlays, DsType.numXl),
        SizedBox(height: ds(2)),
        DsText(
          'TOTAL QUALIFIED PLAYS · ${rangeLabel.toUpperCase()}',
          DsType.label,
        ),
        SizedBox(height: ds(3)),
        const DsBadge(
          label: '+18.6% week over week',
          variant: DsBadgeVariant.success,
          glyph: DsIcon.lucide(DsLucide.trendingUp),
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
    return DsGrid(
      sm: 2,
      xl: 4,
      gap: ds(4),
      children: <Widget>[
        DsStat(
          label: 'Saves',
          value: extended ? '24,610' : '6,820',
          delta: const (value: '14.2%', direction: DsStatDirection.up),
          hint: 'vs last week',
        ),
        DsStat(
          label: 'Shares',
          value: extended ? '8,972' : '2,146',
          delta: const (value: '8.1%', direction: DsStatDirection.up),
          hint: 'vs last week',
        ),
        const DsStat(
          label: 'Completion',
          value: '71.8%',
          delta: (value: '4.4%', direction: DsStatDirection.up),
          hint: 'vs last week',
        ),
        DsStat(
          label: 'New followers',
          value: extended ? '5,408' : '1,284',
          delta: const (value: '2.6%', direction: DsStatDirection.up),
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
    final DsThemeData theme = DsTheme.of(context);
    return DsGlassPanel(
      key: const Key('dashboard-chart-focus'),
      radius: BorderRadius.circular(DsRadii.xl),
      padding: EdgeInsets.all(ds(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText('Momentum', DsType.section),
          SizedBox(height: ds(1)),
          DsText('Qualified plays · $rangeLabel.', DsType.small),
          SizedBox(height: ds(4)),
          DsChartContainer(
            height: ds(52),
            config: DsChartConfig(<String, DsChartSeries>{
              'plays': DsChartSeries(
                label: 'Qualified plays',
                color: theme.chart1,
              ),
            }),
            child: DsCartesianChart(
              data: _data,
              grid: const DsChartGrid(vertical: false),
              xAxis: const DsChartAxis(
                dataKey: 'day',
                tickLine: false,
                axisLine: false,
              ),
              tooltip: const DsChartTooltipSpec(
                cursor: false,
                indicator: DsChartIndicator.line,
              ),
              series: <DsChartSeriesSpec>[
                DsChartSeriesSpec(
                  kind: DsChartSeriesKind.line,
                  dataKey: 'plays',
                  curve: DsCurveType.natural,
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
    child: DsItemGroup(
      gapOverride: ds(2),
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
  Widget build(BuildContext context) => DsItem(
    variant: DsItemVariant.outline,
    alignStart: true,
    media: DsItemMedia(
      child: DsIcon.lucide(
        scheduled ? DsLucide.calendarCheck : DsLucide.clapperboard,
        size: DsIconSize.sm,
        tone: scheduled ? DsIconTone.success : DsIconTone.muted,
      ),
    ),
    content: DsItemContent(
      children: <Widget>[
        DsItemTitle(title),
        DsItemDescription(detail),
        DsBadge(
          label: scheduled ? 'SCHEDULED' : 'READY',
          variant: scheduled
              ? DsBadgeVariant.success
              : DsBadgeVariant.secondary,
        ),
      ],
    ),
    actions: DsItemActions(
      children: <Widget>[
        DsButton(
          size: DsButtonSize.sm,
          variant: scheduled
              ? DsButtonVariant.ghost
              : DsButtonVariant.secondary,
          onPressed: () => onSchedule(id),
          child: DsText(
            scheduled ? 'Undo' : 'Schedule',
            DsComponentType.buttonLabel,
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
          glyph: DsLucide.circleCheck,
          tone: DsIconTone.success,
          title: 'Edit approved',
          detail: 'Quiet architecture is ready to publish.',
        ),
        SizedBox(height: ds(3)),
        const _PulseItem(
          glyph: DsLucide.bell,
          tone: DsIconTone.action,
          title: 'Audience peak ahead',
          detail: 'Your next publish window opens in 42 minutes.',
        ),
        SizedBox(height: ds(4)),
        DsButton(
          variant: DsButtonVariant.outline,
          size: DsButtonSize.sm,
          onPressed: onShowUnavailable,
          child: DsText('Test recovery feedback', DsComponentType.buttonLabel),
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

  final DsLucideGlyph glyph;
  final DsIconTone tone;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => DsItem(
    media: DsItemMedia(
      child: DsIcon.lucide(glyph, size: DsIconSize.sm, tone: tone),
    ),
    content: DsItemContent(
      children: <Widget>[DsItemTitle(title), DsItemDescription(detail)],
    ),
  );
}

class _AudienceInsight extends StatelessWidget {
  const _AudienceInsight();

  @override
  Widget build(BuildContext context) => DsAlert(
    title: 'Audience insight',
    description:
        'Returning viewers are at 38.6%, the strongest result in 12 weeks.',
    variant: DsAlertVariant.info,
    icon: const DsIcon.lucide(DsLucide.usersRound, tone: DsIconTone.inherit),
    action: DsButton(
      variant: DsButtonVariant.secondary,
      size: DsButtonSize.sm,
      onPressed: () => ShowcaseFeedback.of(context).info(
        'Insight saved',
        description: 'A reminder is waiting in your next planning session.',
      ),
      child: DsText('Save insight', DsComponentType.buttonLabel),
    ),
  );
}

class _RecentActivity extends StatelessWidget {
  const _RecentActivity();

  @override
  Widget build(BuildContext context) => _OutlinedSection(
    title: 'Recent activity',
    description: 'Small events worth carrying into the next cut.',
    child: const DsItemGroup(
      children: <Widget>[
        _ActivityItem(
          title: 'Work in progress passed 10K saves',
          detail: 'Community signal · 18 minutes ago',
          glyph: DsLucide.bookmarkCheck,
        ),
        _ActivityItem(
          title: 'Three collaborators joined your review queue',
          detail: 'Workflow signal · 46 minutes ago',
          glyph: DsLucide.usersRound,
        ),
        _ActivityItem(
          title: 'A returning viewer finished your new sequence',
          detail: 'Retention signal · 1 hour ago',
          glyph: DsLucide.arrowUpRight,
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
  final DsLucideGlyph glyph;

  @override
  Widget build(BuildContext context) => DsItem(
    media: DsItemMedia(
      child: DsIcon.lucide(glyph, size: DsIconSize.sm, tone: DsIconTone.muted),
    ),
    content: DsItemContent(
      children: <Widget>[DsItemTitle(title), DsItemDescription(detail)],
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
      DsText(title, DsType.section),
      SizedBox(height: ds(1)),
      DsText(description, DsType.small),
      SizedBox(height: ds(3)),
      child,
    ],
  );
}

class _DashboardFailure extends StatelessWidget {
  const _DashboardFailure({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: DsAlert(
      title: 'The studio signals are temporarily unavailable.',
      description:
          'No dashboard data was changed. Retry when you are ready to reconnect.',
      variant: DsAlertVariant.destructive,
      icon: const DsIcon.lucide(DsLucide.circleAlert, tone: DsIconTone.inherit),
      action: DsButton(
        variant: DsButtonVariant.secondary,
        size: DsButtonSize.sm,
        onPressed: onRetry,
        child: DsText('Retry', DsComponentType.buttonLabel),
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
        DsSkeleton(height: DsChartContainer.plotHeight),
        SizedBox(height: ds(5)),
        DsGrid(
          sm: 2,
          xl: 4,
          gap: ds(4),
          children: <Widget>[
            DsSkeleton(height: ds(20)),
            DsSkeleton(height: ds(20)),
            DsSkeleton(height: ds(20)),
            DsSkeleton(height: ds(20)),
          ],
        ),
        SizedBox(height: ds(5)),
        DsSkeleton(height: DsChartContainer.plotHeight),
      ],
    ),
  );
}
