import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:discussions/discussions.dart';
import '../../screens/dashboard/dashboard_lessons_list_screen.dart';
import '../../screens/dashboard/paid_active_home_screen.dart';

class HomeRoutes {
  static List<RouteBase> routes(GlobalKey<NavigatorState> rootNavigatorKey) => [
    GoRoute(
      name: AppRouteNames.home,
      path: '/home',
      builder: (context, state) => const PaidActiveHomeScreen(),
      routes: [
        GoRoute(
          path: 'lessons',
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) {
            final typeParam = state.uri.queryParameters['type'];
            final sectionType = DashboardSectionType.values.firstWhere(
              (e) => e.name == typeParam,
              orElse: () => DashboardSectionType.resumeLearning,
            );
            final l10n = L10n.of(context);
            final titleParam = state.uri.queryParameters['title'];
            final title = (titleParam != null && titleParam.isNotEmpty)
                ? titleParam
                : switch (sectionType) {
                    DashboardSectionType.resumeLearning =>
                      l10n.dashboardResumeTitle,
                    DashboardSectionType.whatsNew =>
                      l10n.dashboardWhatsNewTitle,
                    DashboardSectionType.completedLearning =>
                      l10n.dashboardRecentlyCompletedTitle,
                  };
            final isCompleted =
                state.uri.queryParameters['isCompleted'] == 'true' ||
                sectionType == DashboardSectionType.completedLearning;
            final initialLessons = state.extra is List<DashboardContentDto>
                ? state.extra as List<DashboardContentDto>
                : null;

            return DashboardLessonsListScreen(
              title: title,
              sectionType: sectionType,
              initialLessons: initialLessons,
              isCompleted: isCompleted,
            );
          },
        ),
        GoRoute(
          path: 'discussions/forum',
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => const ForumPostsListScreen(),
          routes: [
            GoRoute(
              path: 'create',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) => const ForumPostCreateScreen(),
            ),
            GoRoute(
              path: 'posts/:slug',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) {
                final slug = state.pathParameters['slug']!;
                final initialThread = state.extra is ForumThreadDto
                    ? state.extra as ForumThreadDto
                    : null;
                return ForumPostDetailScreen(
                  slug: slug,
                  initialThread: initialThread,
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: 'discussions/doubts',
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) {
            final filterQuery = state.uri.queryParameters['filter'];
            DoubtQueryType? initialFilter;
            if (filterQuery == 'ai') {
              initialFilter = DoubtQueryType.ai;
            } else if (filterQuery == 'mentor') {
              initialFilter = DoubtQueryType.mentor;
            }
            return DoubtsListScreen(initialFilter: initialFilter);
          },
          routes: [
            GoRoute(
              path: 'ask',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) {
                final questionId = int.tryParse(
                  state.uri.queryParameters['question_id'] ?? '',
                );
                final chapterContentId = int.tryParse(
                  state.uri.queryParameters['chapterContentId'] ?? '',
                );
                final lessonTitle = state.uri.queryParameters['lessonTitle'];
                final lessonTypeStr = state.uri.queryParameters['lessonType'];
                final lessonType = lessonTypeStr != null
                    ? LessonType.values.firstWhere(
                        (e) => e.name == lessonTypeStr,
                        orElse: () => LessonType.unknown,
                      )
                    : null;
                final isAskAi = state.uri.queryParameters['isAskAi'] == 'true';

                final extra = state.extra;
                final extraMap = extra is Map ? extra : null;
                final breadcrumbs =
                    (extraMap?['breadcrumbs'] as List<dynamic>?)
                        ?.whereType<String>()
                        .toList() ??
                    const [];
                final questionHtml = extraMap?['questionHtml'] as String?;

                return AskDoubtFormScreen(
                  chapterContentId: chapterContentId,
                  lessonTitle: lessonTitle,
                  lessonType: lessonType,
                  questionId: questionId,
                  breadcrumbs: breadcrumbs,
                  questionHtml: questionHtml,
                  isAskAi: isAskAi,
                );
              },
            ),
            GoRoute(
              path: ':doubtId',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) {
                final doubtId = state.pathParameters['doubtId']!;
                return DoubtDetailScreen(doubtId: doubtId);
              },
            ),
          ],
        ),
      ],
    ),
  ];
}
