import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/models/review_models.dart';
import '../../providers/analytics_providers.dart';
import 'subject_analytics_screen.dart'; // For SubjectAnalyticsColors extension
import 'widgets/bar_chart.dart'; // For BarRow

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
    if (topic != null) {
      return _TopicAnalyticsScreenContent(
        topicId: topicId,
        topic: topic!,
        onBack: onBack,
      );
    }

    final parsedTopicId = int.tryParse(topicId);
    if (parsedTopicId == null) {
      return const _FullScreenMessage(child: Text('Invalid Topic ID'));
    }

    final asyncTopic = ref.watch(subjectAnalyticsByIdProvider(parsedTopicId));
    return asyncTopic.when(
      data: (loadedTopic) {
        if (loadedTopic == null) {
          return const _FullScreenMessage(child: Text('Topic not found'));
        }
        return _TopicAnalyticsScreenContent(
          topicId: topicId,
          topic: loadedTopic,
          onBack: onBack,
        );
      },
      loading: () => const _FullScreenMessage(child: AppLoadingIndicator()),
      error: (error, stack) => _FullScreenMessage(
        child: Text('Error loading topic analytics: $error'),
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
                        'Sub Category',
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
                        label: 'Strength',
                        color: design.correctColor,
                      ),
                      SizedBox(width: design.spacing.md),
                      _LegendItem(
                        label: 'Weakness',
                        color: design.incorrectColor,
                      ),
                      SizedBox(width: design.spacing.md),
                      _LegendItem(
                        label: 'Unanswered',
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
                          label: 'Correct',
                          value: '${topic.correctAnswerCount}',
                          color: design.correctColor,
                        ),
                        _StatRow(
                          label: 'Incorrect',
                          value: '${topic.incorrectAnswerCount}',
                          color: design.incorrectColor,
                        ),
                        _StatRow(
                          label: 'Unanswered',
                          value: '${topic.unansweredCount}',
                          color: design.unansweredColor,
                        ),
                        Container(height: 1, color: design.colors.border),
                        _StatRow(
                          label: 'Accuracy',
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
