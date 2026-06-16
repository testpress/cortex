import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/models/review_models.dart';
import '../../providers/analytics_providers.dart';
import 'subject_analytics_screen.dart'; // For SubjectAnalyticsColors extension
import 'widgets/bar_chart.dart'; // For BarRow
import 'package:skeletonizer/skeletonizer.dart';

class TopicAnalyticsScreen extends ConsumerWidget {
  const TopicAnalyticsScreen({
    super.key,
    required this.topicId,
    required this.topic,
    required this.onBack,
  });

  final String topicId;
  final SubjectAnalyticsDto? topic;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    if (topic != null) {
      return _TopicAnalyticsScreenContent(
        topicId: topicId,
        topic: topic!,
        onBack: onBack,
      );
    }

    final parsedTopicId = int.tryParse(topicId);
    if (parsedTopicId == null) {
      return _FullScreenMessage(
        child: AppText.body(
          l10n.analyticsInvalidTopicId,
          color: Design.of(context).colors.textSecondary,
        ),
      );
    }

    final asyncTopic = ref.watch(subjectAnalyticsByIdProvider(parsedTopicId));
    final design = Design.of(context);
    return SkeletonizerConfig(
      data: SkeletonizerConfigData(
        effect: ShimmerEffect(
          baseColor: design.colors.skeleton,
          highlightColor: design.colors.onSkeleton,
          duration: MotionPreferences.duration(
            context,
            const Duration(milliseconds: 800),
          ),
        ),
        ignoreContainers: false,
      ),
      child: asyncTopic.when(
        data: (loadedTopic) {
          if (loadedTopic == null) {
            return _FullScreenMessage(
              child: AppText.body(
                l10n.analyticsTopicNotFound,
                color: design.colors.textSecondary,
              ),
            );
          }
          return _TopicAnalyticsScreenContent(
            topicId: topicId,
            topic: loadedTopic,
            onBack: onBack,
          );
        },
        loading: () => Skeletonizer(
          enabled: true,
          child: _TopicAnalyticsScreenContent(
            topicId: topicId,
            topic: _skeletonSubject,
            onBack: onBack,
          ),
        ),
        error: (error, stack) => _FullScreenMessage(
          child: AppText.body(
            l10n.analyticsErrorLoadingTopic(error.toString()),
            color: design.colors.error,
          ),
        ),
      ),
    );
  }
}

class _FullScreenMessage extends StatelessWidget {
  const _FullScreenMessage({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Design.of(context).colors.canvas,
      child: Center(child: child),
    );
  }
}

class _TopicAnalyticsScreenContent extends StatelessWidget {
  const _TopicAnalyticsScreenContent({
    required this.topicId,
    required this.topic,
    required this.onBack,
  });

  final String topicId;
  final SubjectAnalyticsDto topic;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Container(
      color: design.colors.canvas,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              color: design.colors.card,
              border: Border(
                bottom: BorderSide(color: design.colors.divider, width: 1.0),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Container(
                height: 56,
                padding: EdgeInsets.symmetric(horizontal: design.spacing.xs),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppFocusable(
                      onTap: onBack,
                      child: Container(
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Icon(
                            LucideIcons.arrowLeft,
                            color: design.colors.textPrimary,
                            size: design.iconSize.md,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: design.spacing.sm),
                    Expanded(
                      child: AppText.title(
                        l10n.analyticsSubCategory,
                        color: design.colors.textPrimary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Body
          Expanded(
            child: AppScroll(
              padding: EdgeInsets.zero,
              children: [
                // Legend Row
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: design.spacing.md,
                    vertical: design.spacing.sm + design.spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: design.colors.card,
                    border: Border(
                      bottom: BorderSide(
                        color: design.colors.divider,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      _LegendItem(
                        label: l10n.analyticsStrength,
                        color: design.correctColor,
                      ),
                      SizedBox(width: design.spacing.md),
                      _LegendItem(
                        label: l10n.analyticsWeakness,
                        color: design.incorrectColor,
                      ),
                      SizedBox(width: design.spacing.md),
                      _LegendItem(
                        label: l10n.analyticsUnanswered,
                        color: design.unansweredColor,
                      ),
                    ],
                  ),
                ),

                // Subject Name Above Bar
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    design.spacing.md,
                    design.spacing.xl,
                    design.spacing.md,
                    design.spacing.xs,
                  ),
                  child: AppText.body(
                    topic.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    color: design.colors.textPrimary,
                  ),
                ),

                // BarRow
                Padding(
                  padding: EdgeInsets.only(bottom: design.spacing.xl),
                  child: BarRow(
                    subjectAnalytics: topic,
                    activeFilter: 'All',
                    showLabel: false,
                    height: design.spacing.xl,
                    isLargeText: true,
                  ),
                ),

                // Stats Card
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
                  child: AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _StatRow(
                          label: l10n.analyticsCorrect,
                          value: '${topic.correctAnswerCount}',
                          color: design.correctColor,
                        ),
                        _StatRow(
                          label: l10n.analyticsIncorrect,
                          value: '${topic.incorrectAnswerCount}',
                          color: design.incorrectColor,
                        ),
                        _StatRow(
                          label: l10n.analyticsUnanswered,
                          value: '${topic.unansweredCount}',
                          color: design.unansweredColor,
                        ),
                        Container(height: 1, color: design.colors.border),
                        _StatRow(
                          label: l10n.analyticsAccuracy,
                          value: '${topic.accuracy.toStringAsFixed(2)}%',
                          color: design.colors.primary,
                          isBoldValue: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: design.spacing.sm,
          height: design.spacing.sm,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: design.spacing.sm),
        AppText.xs(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            letterSpacing: -0.08,
          ),
          color: design.colors.textPrimary,
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    required this.color,
    this.isBoldValue = false,
  });

  final String label;
  final String value;
  final Color color;
  final bool isBoldValue;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: design.spacing.md,
        vertical: design.spacing.sm + design.spacing.xs,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText.body(label, color: design.colors.textPrimary),
          if (isBoldValue)
            AppText.body(
              value,
              color: color,
              style: const TextStyle(fontWeight: FontWeight.w800),
            )
          else
            AppText.body(
              value,
              color: color,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
        ],
      ),
    );
  }
}

final _skeletonSubject = const SubjectAnalyticsDto(
  id: 0,
  name: 'Loading Topic Details...',
  totalQuestionCount: 100,
  correctAnswerCount: 40,
  incorrectAnswerCount: 40,
  unansweredCount: 20,
  correctPercentage: 40.0,
  isLeaf: true,
);
