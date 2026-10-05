import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/courses.dart';
import '../dashboard_lessons_list_screen.dart';
import 'lesson_cards_section.dart';

class LessonCardsSectionWrapper extends ConsumerWidget {
  const LessonCardsSectionWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final whatsNewAsync = ref.watch(whatsNewFeedProvider);
    final resumeLearningAsync = ref.watch(resumeLearningFeedProvider);
    final recentlyCompletedAsync = ref.watch(recentlyCompletedFeedProvider);
    final isInitialLoading = ref.watch(isDashboardInitialLoadingProvider);
    final whatsNewLessons = whatsNewAsync.valueOrNull ?? [];
    final resumeLessons = resumeLearningAsync.valueOrNull ?? [];
    final recentlyCompletedLessons = recentlyCompletedAsync.valueOrNull ?? [];

    return LessonCardsSectionWidget(
      resumeLessons: resumeLessons,
      whatsNewLessons: whatsNewLessons,
      recentlyCompletedLessons: recentlyCompletedLessons,
      isLoading: isInitialLoading,
      onResumeViewAll: () {
        Navigator.of(context, rootNavigator: true).push(
          AppRoute(
            page: DashboardLessonsListScreen(
              title: l10n.dashboardResumeTitle,
              sectionType: DashboardSectionType.resumeLearning,
              initialLessons: resumeLessons,
            ),
          ),
        );
      },
      onWhatsNewViewAll: () {
        Navigator.of(context, rootNavigator: true).push(
          AppRoute(
            page: DashboardLessonsListScreen(
              title: l10n.dashboardWhatsNewTitle,
              sectionType: DashboardSectionType.whatsNew,
              initialLessons: whatsNewLessons,
            ),
          ),
        );
      },
      onRecentlyCompletedViewAll: () {
        Navigator.of(context, rootNavigator: true).push(
          AppRoute(
            page: DashboardLessonsListScreen(
              title: l10n.dashboardRecentlyCompletedTitle,
              sectionType: DashboardSectionType.completedLearning,
              initialLessons: recentlyCompletedLessons,
              isCompleted: true,
            ),
          ),
        );
      },
    );
  }
}
