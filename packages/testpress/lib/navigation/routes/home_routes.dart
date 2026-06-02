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
                    final questionId = int.tryParse(state.uri.queryParameters['question_id'] ?? '');
                    final extra = state.extra is Map<String, dynamic> ? state.extra as Map<String, dynamic> : null;
                    
                    return AskDoubtFormScreen(
                      chapterContentId: extra?['chapterContentId'] as int?,
                      lessonTitle: extra?['lessonTitle'] as String?,
                      lessonType: extra?['lessonType'] as LessonType?,
                      questionId: questionId,
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
