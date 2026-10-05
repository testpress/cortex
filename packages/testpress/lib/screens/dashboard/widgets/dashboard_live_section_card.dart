import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/courses.dart';

// ── State config ─────────────────────────────────────────────────────────────
// Only what changes per status lives here. The card layout is always the same.

/// Action config — either a tappable button or a static info bar.
sealed class _ActionConfig {
  const _ActionConfig();
}

final class _ButtonAction extends _ActionConfig {
  const _ButtonAction({
    required this.label,
    this.icon,
    required this.bg,
    required this.fg,
  });
  final String label;
  final IconData? icon;
  final Color bg;
  final Color fg;
}

final class _InfoAction extends _ActionConfig {
  const _InfoAction({
    required this.icon,
    required this.label,
    required this.bg,
    required this.fg,
  });
  final IconData icon;
  final String label;
  final Color bg;
  final Color fg;
}

// ── Widget ───────────────────────────────────────────────────────────────────

/// Renders the single most relevant live class for today.
/// Hides itself (SizedBox.shrink) while loading or when there is nothing to show.
class DashboardLiveSectionCard extends ConsumerWidget {
  const DashboardLiveSectionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final heroAsync = ref.watch(dashboardLiveClassProvider);

    return heroAsync.when(
      skipLoadingOnReload: true,
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (liveClass) {
        if (liveClass == null) return const SizedBox.shrink();

        final design = Design.of(context);
        final l10n = L10n.of(context);
        final status = liveClass.status;

        // ── Time & Metadata ──────────────────────────────────────────────────
        final start = liveClass.startDateTime?.toLocal();
        final startStr = start != null ? DateFormat.jm().format(start) : '';
        final endStr = liveClass.endDateTime?.toLocal() != null
            ? DateFormat.jm().format(liveClass.endDateTime!.toLocal())
            : null;
        final timeRange = (startStr.isNotEmpty && endStr != null)
            ? '$startStr – $endStr'
            : startStr;
        final todayTimeText = timeRange.isNotEmpty
            ? l10n.dashboardLiveClassTodayTime(timeRange)
            : '';

        // ── Per-status config ─────────────────────────────────────────────────
        final statusLabel = _labelFor(status, l10n);
        final action = _actionFor(
          status,
          design,
          l10n,
          startsAtText: startStr.isNotEmpty
              ? l10n.dashboardLiveClassStartsAt(startStr)
              : '',
        );

        // ── Semantics ────────────────────────────────────────────────────────
        final semanticsElements = [
          statusLabel,
          liveClass.title,
          liveClass.courseName,
          if (liveClass.faculty != null && liveClass.faculty!.trim().isNotEmpty)
            liveClass.faculty!.trim(),
          if (todayTimeText.isNotEmpty) todayTimeText,
        ];
        final cardSemanticsLabel = semanticsElements.join('. ');

        // ── Card ─────────────────────────────────────────────────────────────
        return Padding(
          padding: EdgeInsets.only(
            left: design.spacing.md,
            right: design.spacing.md,
            bottom: design.spacing.md,
          ),
          child: AppSemantics.container(
            label: cardSemanticsLabel,
            child: AppCard(
              showFloatingShadow: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ExcludeSemantics(child: _buildVideoIcon(design, status)),
                      SizedBox(width: design.spacing.sm),
                      AppText.cardTitle(
                        statusLabel,
                        color: design.colors.textSecondary,
                      ),
                    ],
                  ),
                  SizedBox(height: design.spacing.sm),
                  AppSemantics.header(
                    label: liveClass.title,
                    child: AppText.title(liveClass.title),
                  ),
                  SizedBox(height: design.spacing.xs),
                  AppText.subtitle(liveClass.courseName),
                  if (liveClass.faculty != null &&
                      liveClass.faculty!.trim().isNotEmpty) ...[
                    SizedBox(height: design.spacing.xs),
                    AppText.caption(liveClass.faculty!.trim()),
                  ],
                  if (todayTimeText.isNotEmpty) ...[
                    SizedBox(height: design.spacing.sm),
                    Row(
                      children: [
                        ExcludeSemantics(
                          child: Icon(
                            LucideIcons.calendar,
                            size: design.iconSize.sm,
                            color: design.colors.textPrimary,
                          ),
                        ),
                        SizedBox(width: design.spacing.sm),
                        AppText.bodySmall(
                          todayTimeText,
                          color: design.colors.textPrimary,
                        ),
                      ],
                    ),
                  ],
                  SizedBox(height: design.spacing.md),
                  _buildAction(
                    design,
                    action,
                    onTap: () => context.push('/live-classes/${liveClass.id}'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  String _labelFor(LiveClassStatus status, AppLocalizations l10n) =>
      switch (status) {
        LiveClassStatus.live => l10n.dashboardLiveClassStatusLiveNow,
        LiveClassStatus.upcoming => l10n.dashboardLiveClassStatusUpcoming,
        LiveClassStatus.completed => l10n.dashboardLiveClassStatusCompleted,
        LiveClassStatus.cancelled => l10n.dashboardLiveClassStatusCancelled,
      };

  _ActionConfig _actionFor(
    LiveClassStatus status,
    DesignConfig d,
    AppLocalizations l10n, {
    required String startsAtText,
  }) => switch (status) {
    LiveClassStatus.live => _ButtonAction(
      label: l10n.dashboardLiveClassJoinNow,
      bg: d.colors.success,
      fg: d.colors.onSuccess,
    ),
    LiveClassStatus.upcoming => _InfoAction(
      icon: LucideIcons.clock,
      label: startsAtText,
      bg: d.colors.surfaceVariant,
      fg: d.colors.textSecondary,
    ),
    LiveClassStatus.completed => _ButtonAction(
      label: l10n.dashboardLiveClassWatchRecording,
      icon: LucideIcons.play,
      bg: d.colors.primary,
      fg: d.colors.onPrimary,
    ),
    LiveClassStatus.cancelled => _InfoAction(
      icon: LucideIcons.xCircle,
      label: l10n.dashboardLiveClassCancelled,
      bg: d.statusColors.liveClassCancelled.background,
      fg: d.statusColors.liveClassCancelled.foreground,
    ),
  };

  // ── Build helpers ────────────────────────────────────────────────────────────

  Widget _buildVideoIcon(DesignConfig d, LiveClassStatus status) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            color: d.colors.surfaceVariant,
            shape: BoxShape.circle,
            boxShadow: d.shadows.surfaceSoft,
          ),
          child: Icon(
            LucideIcons.video,
            size: d.iconSize.md,
            color: d.colors.textSecondary,
          ),
        ),
        Positioned(
          top: -2,
          right: -2,
          child: switch (status) {
            LiveClassStatus.live => _LivePulseDot(design: d),
            LiveClassStatus.upcoming => _buildClockBadge(
              color: d.colors.accent2,
              clockColor: d.colors.card,
            ),
            LiveClassStatus.completed => _buildIndicatorBadge(
              color: d.colors.success,
              child: Icon(
                LucideIcons.check,
                size: 10.5,
                color: d.colors.onSuccess,
              ),
            ),
            LiveClassStatus.cancelled => _buildIndicatorBadge(
              color: d.colors.error,
              child: Icon(LucideIcons.x, size: 10.5, color: d.colors.onError),
            ),
          },
        ),
      ],
    );
  }

  Widget _buildIndicatorBadge({required Color color, required Widget child}) =>
      Container(
        width: 16.0,
        height: 16.0,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Center(child: child),
      );

  Widget _buildClockBadge({required Color color, required Color clockColor}) =>
      Container(
        width: 16.0,
        height: 16.0,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: CustomPaint(
          size: const Size(16.0, 16.0),
          painter: _ClockPainter(color: clockColor),
        ),
      );

  Widget _buildAction(
    DesignConfig d,
    _ActionConfig action, {
    required VoidCallback onTap,
  }) => switch (action) {
    _ButtonAction a => AppButton(
      label: a.label,
      leading: a.icon != null
          ? ExcludeSemantics(
              child: Icon(a.icon, size: d.iconSize.sm, color: a.fg),
            )
          : null,
      fullWidth: true,
      onPressed: onTap,
      backgroundColor: a.bg,
      foregroundColor: a.fg,
    ),
    _InfoAction a => Container(
      height: 48.0,
      decoration: BoxDecoration(color: a.bg, borderRadius: d.radius.button),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ExcludeSemantics(
            child: Icon(a.icon, size: d.iconSize.sm, color: a.fg),
          ),
          SizedBox(width: d.spacing.sm),
          AppText.cardTitle(a.label, color: a.fg),
        ],
      ),
    ),
  };
}

class _ClockPainter extends CustomPainter {
  const _ClockPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.33;

    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round;

    // Outer clock circle centered precisely
    canvas.drawCircle(center, radius, stroke);

    // Hour hand (pointing to 12)
    canvas.drawLine(center, center + Offset(0, -radius * 0.55), stroke);

    // Minute hand (pointing to 3)
    canvas.drawLine(center, center + Offset(radius * 0.5, 0), stroke);
  }

  @override
  bool shouldRepaint(_ClockPainter old) => old.color != color;
}

class _LivePulseDot extends StatefulWidget {
  const _LivePulseDot({required this.design});

  final DesignConfig design;

  @override
  State<_LivePulseDot> createState() => _LivePulseDotState();
}

class _LivePulseDotState extends State<_LivePulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    final cycleDuration = widget.design.motion.slow * 2;
    _controller = AnimationController(vsync: this, duration: cycleDuration);
    _animation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.design.motion.easeInOut,
      ),
    );
    if (widget.design.motion.shouldAnimate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dot = Container(
      width: 14.0,
      height: 14.0,
      decoration: BoxDecoration(
        color: widget.design.colors.error,
        shape: BoxShape.circle,
      ),
    );

    if (!MotionPreferences.shouldAnimate(context)) {
      return dot;
    }

    return ScaleTransition(scale: _animation, child: dot);
  }
}
