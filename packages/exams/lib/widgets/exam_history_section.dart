import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../models/review_route_payload.dart';
import '../screens/components/exam_history_table.dart';

/// Section widget for rendering the exam attempt history table and navigating to review analytics.
class ExamHistorySection extends StatelessWidget {
  final AsyncValue<List<AttemptDto>> attemptsAsync;
  final ExamDto? exam;
  final LessonDto? lesson;
  final bool isMetadataLoading;
  final bool isOfflineOnly;

  const ExamHistorySection({
    super.key,
    required this.attemptsAsync,
    required this.exam,
    required this.lesson,
    this.isMetadataLoading = false,
    this.isOfflineOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isOfflineOnly) {
      return const SizedBox.shrink();
    }

    if (isMetadataLoading || attemptsAsync.isLoading) {
      return ExamHistoryTable(
        isLoading: true,
        attempts: const [],
        onReviewTapped: (_) {},
      );
    }

    return attemptsAsync.when(
      data: (attempts) {
        final completedAttempts = attempts
            .where((a) => a.state?.toLowerCase() == 'completed')
            .toList();
        if (completedAttempts.isEmpty) {
          return const SizedBox.shrink();
        }
        return ExamHistoryTable(
          attempts: completedAttempts,
          onReviewTapped: (attempt) {
            final payload = ReviewRoutePayload(
              attempt: attempt,
              exam: exam,
              assessmentTitle: exam?.title ?? lesson?.title ?? '',
              questions: const [],
              attemptStates: const {},
            );
            context.push(
              '${GoRouterState.of(context).matchedLocation}/review-analytics',
              extra: payload,
            );
          },
        );
      },
      loading: () => ExamHistoryTable(
        isLoading: true,
        attempts: const [],
        onReviewTapped: (_) {},
      ),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
