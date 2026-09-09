import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/data/data.dart';
import 'package:courses/courses.dart';

class TopLearnersSectionWidget extends ConsumerWidget {
  const TopLearnersSectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(instituteSettingsProvider);
    if (!(settings?.leaderboardEnabled ?? false)) {
      return const SizedBox.shrink();
    }

    final learnersState = ref.watch(
      learnersProvider(timeline: LeaderboardTimeline.allTime, limit: 10),
    );
    final isInitialLoading = ref.watch(isDashboardInitialLoadingProvider);
    final learners = learnersState.valueOrNull ?? const <LearnerDto>[];

    if (learners.isEmpty && !isInitialLoading) {
      return const SizedBox.shrink();
    }

    return TopLearnersSection(
      topLearners: learners.take(3).toList(),
      otherLearners: learners.skip(3).toList(),
      isLoading: isInitialLoading,
    );
  }
}
