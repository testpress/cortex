import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:courses/courses.dart';
import 'package:data/data.dart';
import 'package:exams/exams.dart';

// Placeholder empty screens for the routes that don't exist yet
class ExplorePlaceholderScreen extends StatelessWidget {
  const ExplorePlaceholderScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Explore Tab Content'));
}

class ProfilePlaceholderScreen extends StatelessWidget {
  const ProfilePlaceholderScreen({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Profile Tab Content'),
        const SizedBox(height: 16),
        AppButton.secondary(
          label: 'View Typography Gallery',
          onPressed: () => context.push('/typography-gallery'),
        ),
      ],
    ),
  );
}

class HomePlaceholderScreen extends StatelessWidget {
  const HomePlaceholderScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Home Tab Content'));
}

/// The root navigator key for the whole app
final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Defines the global router for the application using GoRouter.
///
/// We use `StatefulShellRoute` to maintain the state (e.g. scroll position)
/// of each bottom navigation tab independently.
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // AppTabBar items matching the routes exactly
        final items = [
          const AppTabItem(id: '/home', label: 'Home', icon: LucideIcons.home),
          const AppTabItem(
            id: '/study',
            label: 'Study',
            icon: LucideIcons.bookOpen,
          ),
          const AppTabItem(
            id: '/explore',
            label: 'Explore',
            icon: LucideIcons.compass,
          ),
          const AppTabItem(
            id: '/profile',
            label: 'Profile',
            icon: LucideIcons.user,
          ),
        ];

        final activeTabId = _getCurrentTabId(navigationShell.currentIndex);

        return AppShell(
          bottomNavigationBar: AppTabBar(
            items: items,
            activeItemId: activeTabId,
            onTabChange: (id) => _onTabItemTapped(navigationShell, id),
          ),
          navigationRail: AppNavigationRail(
            items: items,
            activeItemId: activeTabId,
            onTabChange: (id) => _onTabItemTapped(navigationShell, id),
          ),
          drawer: const DashboardDrawer(),
          child: navigationShell,
        );
      },
      branches: [
        // Home Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const PaidActiveHomeScreen(),
            ),
          ],
        ),
        // Study Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/study',
              builder: (context, state) => const StudyScreen(),
              routes: [
                GoRoute(
                  path: 'course/:courseId/chapters',
                  builder: (context, state) {
                    final courseId = state.pathParameters['courseId']!;
                    return ChaptersListPage(
                      courseId: courseId,
                      onBack: () => context.pop(),
                    );
                  },
                  routes: [
                    GoRoute(
                      path: ':chapterId',
                      builder: (context, state) {
                        final courseId = state.pathParameters['courseId']!;
                        final chapterId = state.pathParameters['chapterId']!;
                        return ChapterDetailPage(
                          courseId: courseId,
                          chapterId: chapterId,
                          onBack: () => context.pop(),
                          onLessonClick: (lesson) {
                            final path = switch (lesson.type) {
                              LessonType.video => '/study/video/${lesson.id}',
                              LessonType.pdf => '/study/lesson/${lesson.id}',
                              LessonType.test => '/study/test/${lesson.id}',
                              LessonType.assessment =>
                                '/study/assessment/${lesson.id}',
                            };
                            context.push(path, extra: lesson);
                          },
                        );
                      },
                    ),
                  ],
                ),
                // Lesson and Placeholder routes inside Chapter branch to stay within the shell
                GoRoute(
                  path: 'lesson/:id',
                  builder: (context, state) {
                    final lessonArg = state.extra as Lesson?;
                    if (lessonArg != null) {
                      return LessonDetailScreen(lesson: lessonArg);
                    }

                    final id = state.pathParameters['id']!;
                    return Consumer(
                      builder: (context, ref, child) {
                        final lessonAsync = ref.watch(lessonDetailProvider(id));
                        return lessonAsync.when(
                          data: (lesson) {
                            if (lesson == null) {
                              return const Center(
                                child: Text('Lesson not found'),
                              );
                            }
                            return LessonDetailScreen(lesson: lesson);
                          },
                          loading: () => Container(
                            color: const Color(0xFFFFFFFF),
                            child: const Center(child: AppLoadingIndicator()),
                          ),
                          error: (e, __) => Center(child: Text('Error: $e')),
                        );
                      },
                    );
                  },
                ),
                GoRoute(
                  path: 'video/:id',
                  builder: (context, state) {
                    final lessonArg = state.extra as Lesson?;
                    if (lessonArg != null) {
                      return VideoLessonDetailScreen(lesson: lessonArg);
                    }

                    final id = state.pathParameters['id']!;
                    return Consumer(
                      builder: (context, ref, child) {
                        final lessonAsync = ref.watch(lessonDetailProvider(id));
                        return lessonAsync.when(
                          data: (lesson) {
                            if (lesson == null) {
                              return const Center(
                                child: Text('Lesson not found'),
                              );
                            }
                            return VideoLessonDetailScreen(lesson: lesson);
                          },
                          loading: () => Container(
                            color: const Color(0xFFFFFFFF),
                            child: const Center(child: AppLoadingIndicator()),
                          ),
                          error: (e, __) => Center(child: Text('Error: $e')),
                        );
                      },
                    );
                  },
                ),
                GoRoute(
                  path: 'test/:id',
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return TestDetailScreen(
                      testId: id,
                      onClose: () => context.pop(),
                    );
                  },
                  routes: [
                    GoRoute(
                      path: 'review-analytics',
                      builder: (context, state) {
                        final id = state.pathParameters['id']!;
                        final payload = state.extra as ReviewRoutePayload?;
                        return ReviewAnalyticsScreen(
                          testId: id,
                          assessmentTitle:
                              payload?.assessmentTitle ?? 'Assessment $id',
                          questions: payload?.questions ?? const [],
                          attemptStates: payload?.attemptStates ?? const {},
                          onBack: () => context.pop(),
                        );
                      },
                    ),
                    GoRoute(
                      path: 'review-answers',
                      builder: (context, state) {
                        final id = state.pathParameters['id']!;
                        final payload = state.extra as ReviewRoutePayload?;
                        return ReviewAnswerDetailScreen(
                          assessmentTitle:
                              payload?.assessmentTitle ?? 'Assessment $id',
                          questions: payload?.questions ?? const [],
                          attemptStates: payload?.attemptStates ?? const {},
                          onBack: () => context.pop(),
                        );
                      },
                    ),
                  ],
                ),
                GoRoute(
                  path: 'assessment/:id',
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return AssessmentDetailScreen(
                      assessmentId: id,
                      onClose: () => context.pop(),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        // Explore Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/explore',
              builder: (context, state) => const ExplorePlaceholderScreen(),
            ),
          ],
        ),
        // Profile Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfilePage(),
              routes: [
                GoRoute(
                  name: 'profile-notifications',
                  path: 'notifications',
                  builder: (context, state) {
                    return NotificationsScreen(onBack: () => context.pop());
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    // Add immersive full screen routes here outside of the StatefulShellRoute
    // They will navigate over the entire AppShell and hide the bottom bar
    GoRoute(
      path: '/typography-gallery',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const TypographyGalleryScreen(),
    ),
  ],
);

const _tabPaths = ['/home', '/study', '/explore', '/profile'];

String _getCurrentTabId(int index) => _tabPaths[index];

void _onTabItemTapped(StatefulNavigationShell navigationShell, String id) {
  final index = _tabPaths.indexOf(id);

  // Navigate to the chosen branch, safely preserving state
  navigationShell.goBranch(
    index != -1 ? index : 0, // Fallback to 'home' branch as default
    // Provide true if you want clicking an active tab to reset its stack to root
    initialLocation: index == navigationShell.currentIndex,
  );
}
