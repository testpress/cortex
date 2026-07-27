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
      learnersProvider(timeline: LeaderboardTimeline.thisWeek, limit: 10),
    );
    final bootstrapState = ref.watch(dashboardBootstrapProvider);

    final isBootstrapping =
        bootstrapState.isLoading && (learnersState.valueOrNull == null);
    final learners = learnersState.valueOrNull ?? const <LearnerDto>[];

    return TopLearnersSection(
      topLearners: learners.take(3).toList(),
      otherLearners: learners.skip(3).toList(),
      isLoading: isBootstrapping,
    );
  }
}
