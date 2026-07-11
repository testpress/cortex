import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:discussions/discussions.dart';
import '../../screens/dashboard/paid_active_home_screen.dart';

class HomeRoutes {
  static List<RouteBase> routes(GlobalKey<NavigatorState> rootNavigatorKey) => [
    GoRoute(
      name: AppRouteNames.home,
      path: '/home',
      builder: (context, state) => const PaidActiveHomeScreen(),
      routes: [
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
          builder: (context, state) => const DoubtsListScreen(),
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
