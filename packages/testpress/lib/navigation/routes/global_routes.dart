import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:courses/courses.dart';

class GlobalRoutes {
  static List<RouteBase> get exploreRoutes => [
        GoRoute(
          path: '/explore',
          builder: (context, state) => const ExplorePage(),
        ),
      ];

  static List<RouteBase> get infoRoutes => [
        GoRoute(
          path: '/info',
          builder: (context, state) => const InfoPage(),
          routes: [
            GoRoute(
              path: 'course/:courseId',
              builder: (context, state) {
                final courseId = state.pathParameters['courseId']!;
                return InfoCourseDetailScreen(
                  courseId: courseId,
                  onBack: () => context.pop(),
                );
              },
            ),
          ],
        ),
      ];

  static List<RouteBase> immersiveRoutes(
          GlobalKey<NavigatorState> rootNavigatorKey) =>
      [
        GoRoute(
          path: '/typography-gallery',
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => const TypographyGalleryScreen(),
        ),
        GoRoute(
          path: '/downloads',
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => const DownloadsScreen(),
        ),
      ];
}
