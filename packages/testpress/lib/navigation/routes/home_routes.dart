import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
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
              builder: (context, state) => const ForumCourseSelectionScreen(),
              routes: [
                GoRoute(
                  path: 'posts/:courseId',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) {
                    final courseId = state.pathParameters['courseId']!;
                    return ForumPostsListScreen(courseId: courseId);
                  },
                  routes: [
                    GoRoute(
                      path: ':threadId',
                      parentNavigatorKey: rootNavigatorKey,
                      builder: (context, state) {
                        final courseId = state.pathParameters['courseId']!;
                        final threadId = state.pathParameters['threadId']!;
                        return ForumPostDetailScreen(
                          courseId: courseId,
                          threadId: threadId,
                        );
                      },
                    ),
                  ],
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
                  builder: (context, state) => const AskDoubtFormScreen(),
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
