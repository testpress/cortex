import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import '../models/study_momentum_dto.dart';

/// A heatmap and performance dashboard for study activity.
class StudyMomentumGrid extends StatelessWidget {
  const StudyMomentumGrid({super.key, required this.momentum});

  final StudyMomentumDto momentum;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final hasActivity = momentum.weekDays.any((d) => d.hasActivity);

    return Padding(
      padding: EdgeInsets.only(
        left: design.spacing.md,
        right: design.spacing.md,
        top: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.title(
            l10n.learningPerformanceTitle,
            color: design.colors.textPrimary,
          ),
          const SizedBox(height: 16),
          AppCard(
            padding: EdgeInsets.all(design.spacing.md),
            child: hasActivity
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeatmap(context),
                      if (momentum.latestActivityTitle != null) ...[
                        const SizedBox(height: 24),
                        _buildLatestActivity(context),
                        const SizedBox(height: 12),
                        Container(height: 1, color: design.colors.divider),
                        const SizedBox(height: 12),
                      ] else
                        const SizedBox(height: 24),
                      _buildStreakAndHours(context),
                      const SizedBox(height: 16),
                      _buildStatsGrid(context),
                      if (momentum.strongestSubject != null ||
                          momentum.weakSubject != null) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Container(
                            height: 1,
                            color: design.colors.divider,
                          ),
                        ),
                        _buildSubjectCards(context),
                      ],
                    ],
                  )
                : _buildEmptyState(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeatmap(BuildContext context) {
    final design = Design.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: momentum.weekDays.map((day) {
        final intensity = _getIntensityLevel(day.minutes);
        return Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: _getActivityColor(context, intensity),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 8),
            AppText.caption(day.dayLabel, color: design.colors.textSecondary),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildLatestActivity(BuildContext context) {
    final l10n = L10n.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.caption(l10n.latestActivityLabel),
        const SizedBox(height: 4),
        Row(
          children: [
            AppText.cardTitle(momentum.latestActivityTitle!),
            const SizedBox(width: 8),
            AppText.cardCaption('· ${momentum.latestActivityTimeAgo}'),
          ],
        ),
      ],
    );
  }

  Widget _buildStreakAndHours(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (momentum.currentStreak >= 2)
          Row(
            children: [
              Icon(LucideIcons.flame, size: 18, color: design.colors.primary),
              const SizedBox(width: 8),
              AppText.label(l10n.streakMomentumLabel(momentum.currentStreak)),
            ],
          ),
        AppText.caption(l10n.weeklyHoursLabel(momentum.weeklyHours.toString())),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    return Row(
      children: [
        _buildStatItem(
          context,
          momentum.lessonsFinished,
          l10n.lessonsFinishedLabel,
          design.colors.primary,
        ),
        _buildDivider(context),
        _buildStatItem(
          context,
          momentum.testsAttempted,
          l10n.testsAttemptedLabel,
          design.colors.warning,
        ),
        _buildDivider(context),
        _buildStatItem(
          context,
          momentum.assessmentsDone,
          l10n.assessmentsDoneLabel,
          design.colors.success,
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    int value,
    String label,
    Color color,
  ) {
    final design = Design.of(context);
    return Expanded(
      child: Column(
        children: [
          AppText.xl3(
            value.toString(),
            color: color,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          AppText.labelSmall(
            label,
            textAlign: TextAlign.center,
            color: design.colors.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final design = Design.of(context);
    return Container(width: 1, height: 48, color: design.colors.divider);
  }

  Widget _buildSubjectCards(BuildContext context) {
    final l10n = L10n.of(context);
    final design = Design.of(context);

    // Using DesignSubjectPalette indices:
    // 2: Emerald (Green) for strongest
    // 6: Amber (Orange) for focus
    final strongestColors = design.subjectPalette.atIndex(2);
    final weakColors = design.subjectPalette.atIndex(6);

    return Row(
      children: [
        if (momentum.strongestSubject != null)
          Expanded(
            child: _SubjectInsightCard(
              label: l10n.strongestSubjectLabel,
              subject: momentum.strongestSubject!,
              colors: strongestColors,
            ),
          ),
        if (momentum.strongestSubject != null && momentum.weakSubject != null)
          const SizedBox(width: 12),
        if (momentum.weakSubject != null)
          Expanded(
            child: _SubjectInsightCard(
              label: l10n.weakSubjectLabel,
              subject: momentum.weakSubject!,
              colors: weakColors,
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    return Center(
      child: Column(
        children: [
          AppText.title(l10n.noActivityTitle, color: design.colors.textPrimary),
          AppText.bodySmall(
            l10n.noActivitySubtitle,
            color: design.colors.textSecondary,
          ),
        ],
      ),
    );
  }

  int _getIntensityLevel(int minutes) {
    if (minutes == 0) return 0;
    if (minutes < 60) return 1;
    if (minutes < 120) return 2;
    return 3;
  }

  Color _getActivityColor(BuildContext context, int level) {
    final design = Design.of(context);
    if (level == 0) return design.colors.surfaceVariant;

    final factor = level / 3.0;
    return Color.lerp(
      design.colors.primary.withValues(alpha: 0.3),
      design.colors.primary,
      factor,
    )!;
  }
}

class _SubjectInsightCard extends StatelessWidget {
  const _SubjectInsightCard({
    required this.label,
    required this.subject,
    required this.colors,
  });

  final String label;
  final String subject;
  final SubjectColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.labelSmall(
            label,
            color: colors.foreground,
            style: const TextStyle(
              fontSize: 10,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          AppText.label(
            subject,
            color: colors.accent,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
