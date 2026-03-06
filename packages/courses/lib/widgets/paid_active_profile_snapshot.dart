import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Divider;
import 'package:core/core.dart';

class ProfileLearningSnapshot extends StatelessWidget {
  const ProfileLearningSnapshot({
    super.key,
    required this.lessonsFinished,
    required this.testsAttempted,
    required this.assessmentsDone,
    this.strongestIn = 'Mathematics',
    this.focusNeededIn = 'Chemistry',
  });

  final int lessonsFinished;
  final int testsAttempted;
  final int assessmentsDone;
  final String strongestIn;
  final String focusNeededIn;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
          child: AppText.title(
            l10n.profileLearningSnapshotTitle,
            color: design.colors.textPrimary,
          ),
        ),
        SizedBox(height: design.spacing.md),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
          child: AppCard(
            padding: EdgeInsets.all(design.spacing.lg),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _StatItem(
                        label: l10n.lessonsFinishedLabel,
                        value: lessonsFinished.toString(),
                        valueColor: design.colors.accent2,
                      ),
                    ),
                    _VerticalDivider(),
                    Expanded(
                      child: _StatItem(
                        label: l10n.testsAttemptedLabel,
                        value: testsAttempted.toString(),
                        valueColor: design.colors.accent3,
                      ),
                    ),
                    _VerticalDivider(),
                    Expanded(
                      child: _StatItem(
                        label: l10n.assessmentsDoneLabel,
                        value: assessmentsDone.toString(),
                        valueColor: design.colors.success,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: design.spacing.lg),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: design.colors.divider.withValues(alpha: 0.5),
                ),
                SizedBox(height: design.spacing.lg),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: _InsightCard(
                          title: l10n.strongestSubjectLabel,
                          value: strongestIn,
                          colors: design.subjectPalette.atIndex(2), // Green
                        ),
                      ),
                      SizedBox(width: design.spacing.md),
                      Expanded(
                        child: _InsightCard(
                          title: l10n.weakSubjectLabel,
                          value: focusNeededIn,
                          colors: design.subjectPalette.atIndex(6), // Orange
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Column(
      children: [
        AppText.xl3(
          value,
          color: valueColor,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: design.spacing.xs),
        AppText.labelSmall(
          label,
          textAlign: TextAlign.center,
          color: design.colors.textSecondary,
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Container(
      height: 48,
      width: 1,
      color: design.colors.divider.withValues(alpha: 0.5),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.title,
    required this.value,
    required this.colors,
  });

  final String title;
  final String value;
  final SubjectColors colors;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Container(
      padding: EdgeInsets.all(design.spacing.md),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(design.radius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.labelSmall(
            title,
            color: colors.foreground,
            style: const TextStyle(
              fontSize: 10,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
          SizedBox(height: design.spacing.sm),
          AppText.label(
            value,
            color: colors.accent,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
