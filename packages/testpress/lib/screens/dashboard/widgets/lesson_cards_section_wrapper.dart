import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/courses.dart';
import 'lesson_cards_section.dart';

class LessonCardsSectionWrapper extends ConsumerWidget {
  const LessonCardsSectionWrapper({super.key});

  void _openLessonsList(
    BuildContext context, {
    required DashboardSectionType sectionType,
    required String title,
    List<DashboardContentDto>? initialLessons,
    bool isCompleted = false,
  }) {
    context.push(
      Uri(
        path: '/home/lessons',
        queryParameters: {
          'type': sectionType.name,
          'title': title,
          if (isCompleted) 'isCompleted': 'true',
        },
      ).toString(),
      extra: initialLessons,
    );
  }

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
      onResumeViewAll: () => _openLessonsList(
        context,
        sectionType: DashboardSectionType.resumeLearning,
        title: l10n.dashboardResumeTitle,
        initialLessons: resumeLessons,
      ),
      onWhatsNewViewAll: () => _openLessonsList(
        context,
        sectionType: DashboardSectionType.whatsNew,
        title: l10n.dashboardWhatsNewTitle,
        initialLessons: whatsNewLessons,
      ),
      onRecentlyCompletedViewAll: () => _openLessonsList(
        context,
        sectionType: DashboardSectionType.completedLearning,
        title: l10n.dashboardRecentlyCompletedTitle,
        initialLessons: recentlyCompletedLessons,
        isCompleted: true,
      ),
    );
  }
}
