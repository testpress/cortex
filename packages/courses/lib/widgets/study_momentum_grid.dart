import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:data/models/study_momentum_dto.dart';

/// A heatmap and performance dashboard for study activity.
class StudyMomentumGrid extends StatelessWidget {
  const StudyMomentumGrid({super.key, required this.momentum});

  final StudyMomentumDto momentum;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
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
          AppText(
            'Learning Performance',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
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
                        Container(
                          height: 1,
                          color: design.isDark
                              ? const Color(0xFF1F2937)
                              : const Color(0xFFE2E8F0),
                        ),
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
                            color: design.isDark
                                ? const Color(0xFF1F2937)
                                : const Color(0xFFE2E8F0),
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
    final design = Design.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.caption('Latest Activity', color: design.colors.textSecondary),
        const SizedBox(height: 4),
        Text.rich(
          TextSpan(
            text: momentum.latestActivityTitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: design.colors.textPrimary,
              height: 1.5,
            ),
            children: [
              const TextSpan(text: '  '),
              TextSpan(
                text: '• ${momentum.latestActivityTimeAgo}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: design.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStreakAndHours(BuildContext context) {
    final design = Design.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (momentum.currentStreak >= 2)
          Row(
            children: [
              Icon(LucideIcons.flame, size: 18, color: design.colors.primary),
              const SizedBox(width: 8),
              AppText.label(
                '${momentum.currentStreak}-day momentum',
                color: design.colors.textPrimary,
              ),
            ],
          ),
        AppText.caption(
          '${momentum.weeklyHours}h this week',
          color: design.colors.textSecondary,
        ),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    return Row(
      children: [
        _buildStatItem(
          context,
          momentum.lessonsFinished,
          'Lessons\nfinished',
          const Color(0xFF2563EB),
        ),
        _buildDivider(context),
        _buildStatItem(
          context,
          momentum.testsAttempted,
          'Tests\nattempted',
          const Color(0xFFEA580C),
        ),
        _buildDivider(context),
        _buildStatItem(
          context,
          momentum.assessmentsDone,
          'Assessments\ndone',
          const Color(0xFF059669),
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
    return Expanded(
      child: Column(
        children: [
          AppText.headline(
            value.toString(),
            color: color,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          AppText.caption(
            label,
            textAlign: TextAlign.center,
            color: const Color(0xFF475569),
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final design = Design.of(context);
    return Container(
      width: 1,
      height: 48,
      color: design.isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
    );
  }

  Widget _buildSubjectCards(BuildContext context) {
    return Row(
      children: [
        if (momentum.strongestSubject != null)
          Expanded(
            child: _SubjectInsightCard(
              label: "YOU'RE STRONGEST IN",
              subject: momentum.strongestSubject!,
              backgroundColor: const Color(0xFFECFDF5),
              textColor: const Color(0xFF047857),
              subjectColor: const Color(0xFF064E3B),
            ),
          ),
        if (momentum.strongestSubject != null && momentum.weakSubject != null)
          const SizedBox(width: 12),
        if (momentum.weakSubject != null)
          Expanded(
            child: _SubjectInsightCard(
              label: "NEED FOCUS HERE",
              subject: momentum.weakSubject!,
              backgroundColor: const Color(0xFFFFFBEB),
              textColor: const Color(0xFFB45309),
              subjectColor: const Color(0xFF78350F),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final design = Design.of(context);
    return Center(
      child: Column(
        children: [
          AppText.title(
            'No study activity yet',
            color: design.colors.textPrimary,
          ),
          AppText.bodySmall(
            'Start with a session to build momentum',
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
    required this.backgroundColor,
    required this.textColor,
    required this.subjectColor,
  });

  final String label;
  final String subject;
  final Color backgroundColor;
  final Color textColor;
  final Color subjectColor;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final bgColor = design.isDark
        ? (label.contains("STRONGEST")
              ? const Color(0xFF1B3227)
              : const Color(0xFF422A1B))
        : backgroundColor;
    final txtColor = design.isDark
        ? (label.contains("STRONGEST")
              ? const Color(0xFF6EE7B7)
              : const Color(0xFFFCD34D))
        : textColor;
    final subjColor = design.isDark
        ? (label.contains("STRONGEST")
              ? const Color(0xFFD1FAE5)
              : const Color(0xFFFEF3C7))
        : subjectColor;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.caption(
            label,
            color: txtColor,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          AppText.label(
            subject,
            color: subjColor,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
