import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:courses/courses.dart';
import 'lesson_cards_section.dart';

class LessonCardsSectionWrapper extends ConsumerWidget {
  const LessonCardsSectionWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final whatsNewAsync = ref.watch(whatsNewFeedProvider);
    final resumeLearningAsync = ref.watch(resumeLearningFeedProvider);
    final recentlyCompletedAsync = ref.watch(recentlyCompletedFeedProvider);
    final bootstrapState = ref.watch(dashboardBootstrapProvider);

    final whatsNewLessons = whatsNewAsync.valueOrNull ?? [];
    final resumeLessons = resumeLearningAsync.valueOrNull ?? [];
    final recentlyCompletedLessons = recentlyCompletedAsync.valueOrNull ?? [];

    final hasLessonsData =
        whatsNewLessons.isNotEmpty ||
        resumeLessons.isNotEmpty ||
        recentlyCompletedLessons.isNotEmpty;
    final isBootstrapping = bootstrapState.isLoading && !hasLessonsData;

    return LessonCardsSectionWidget(
      resumeLessons: resumeLessons,
      whatsNewLessons: whatsNewLessons,
      recentlyCompletedLessons: recentlyCompletedLessons,
      isLoading: isBootstrapping,
    );
  }
}
