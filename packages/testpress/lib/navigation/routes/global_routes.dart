import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:courses/courses.dart';
import '../../screens/bookmarks/bookmarks_screen.dart';

class GlobalRoutes {
  static List<RouteBase> get exploreRoutes => [
        GoRoute(
          path: '/explore',
          builder: (context, state) => const ExplorePage(),
        ),
      ];

  static List<RouteBase> infoRoutes(GlobalKey<NavigatorState> rootNavigatorKey) => [
        GoRoute(
          path: '/info',
          builder: (context, state) => const InfoPage(),
          routes: [
            GoRoute(
              path: 'course/:courseId/chapters',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) {
                final courseId = state.pathParameters['courseId']!;
                final parentId = state.uri.queryParameters['parentId'];
                return ChaptersListPage(
                  courseId: courseId,
                  parentId: parentId,
                  onBack: () => context.pop(),
                  basePath: '/info',
                  showFilters: false,
                );
              },
              routes: [
                GoRoute(
                  path: ':chapterId',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) {
                    final courseId = state.pathParameters['courseId']!;
                    final chapterId = state.pathParameters['chapterId']!;
                    return ChapterDetailPage(
                      courseId: courseId,
                      chapterId: chapterId,
                      onBack: () => context.pop(),
                      onLessonClick: (lesson) =>
                          context.push('/info/lesson/${lesson.id}'),
                      showFilters: false,
                    );
                  },
                ),
              ],
            ),
            GoRoute(
              path: 'lesson/:id',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return Consumer(
                  builder: (context, ref, child) {
                    final lessonAsync = ref.watch(lessonDetailProvider(id));
                    return lessonAsync.when(
                      data: (lesson) {
                        if (lesson == null) {
                          final l10n = L10n.of(context);
                          return AppErrorView(
                            title: l10n.errorGenericTitle,
                            message: l10n.chapterNotFound,
                          );
                        }
                        return LessonDetailOrchestrator(
                          lesson: lesson,
                          onNext: lesson.nextContentId != null
                              ? () => context.pushReplacement(
                                  '/info/lesson/${lesson.nextContentId}')
                              : null,
                          onPrevious: lesson.previousContentId != null
                              ? () => context.pushReplacement(
                                  '/info/lesson/${lesson.previousContentId}')
                              : null,
                        );
                      },
                      loading: () => Container(
                        color: Design.of(context).colors.surface,
                        child: const Center(child: AppLoadingIndicator()),
                      ),
                      error: (e, _) {
                        final l10n = L10n.of(context);
                        return AppErrorView(
                          title: l10n.errorGenericTitle,
                          message: l10n.errorLessonLoad,
                        );
                      },
                    );
                  },
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
        GoRoute(
          path: '/bookmarks',
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => const BookmarksScreen(),
        ),
      ];
}
