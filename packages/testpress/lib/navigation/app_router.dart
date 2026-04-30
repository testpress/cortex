import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:courses/courses.dart';
import 'package:courses/models/course_content.dart';
import 'package:core/data/data.dart';
import 'package:profile/profile.dart';
import 'package:exams/exams.dart';

import '../screens/dashboard/paid_active_home_screen.dart';
import '../widgets/dashboard_drawer.dart';
import 'package:forum/forum.dart';

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


/// Provider that exposes the application router.
final goRouterProvider = Provider<GoRouter>((ref) {
  // Only watch the boolean login status to prevent the router from rebuilding
  // on every loading state change or refresh.
  final isLoggedIn = ref.watch(authProvider).valueOrNull ?? false;
  final config = ref.watch(clientConfigProvider);
  final isInfoEnabled = config.useRestrictedNavigation || 
                        ref.watch(infoPageEnabledProvider);


  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/onboarding',
    redirect: (context, state) {
      final path = state.uri.path;
      final isAuthRoute = path == '/login' || 
                          path == '/password-login' ||
                          path == '/mobile-login' ||
                          path == '/signup' || 
                          path == '/forgot-password' || 
                          path == '/otp' || 
                          path == '/onboarding';

      if (!isLoggedIn && !isAuthRoute) return '/onboarding';
      if (isLoggedIn && isAuthRoute) return '/home';
      return null;
    },
    routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/password-login',
      builder: (context, state) => const PasswordLoginScreen(),
    ),
    GoRoute(
      path: '/mobile-login',
      builder: (context, state) => const MobileLoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return OtpScreen(
          phoneNumber: (extra['phoneNumber'] as String?) ?? '',
          countryCode: (extra['countryCode'] as String?) ?? '',
        );
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        final items = buildPrimaryNavigationItems(
          config: config,
          isInfoEnabled: isInfoEnabled,
        );

        return Consumer(
          builder: (context, ref, _) {
            final isLogoutSheetOpen = ref.watch(isLogoutSheetOpenProvider);
            final activeTabId = _getCurrentTabId(
              navigationShell.currentIndex,
              config: config,
              isInfoEnabled: isInfoEnabled,
            );

            void closeSheet() {
              ref.read(isLogoutSheetOpenProvider.notifier).state = false;
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                final isLandscape =
                    constraints.maxWidth > constraints.maxHeight;

                return AppShell(
                  bottomNavigationBar: AppTabBar(
                    items: items,
                    activeItemId: activeTabId,
                    onTabChange: (id) => 
                        _onTabItemTapped(navigationShell, id, config: config, isInfoEnabled: isInfoEnabled),
                  ),
                  navigationRail: AppNavigationRail(
                    items: items,
                    activeItemId: activeTabId,
                    onTabChange: (id) => 
                        _onTabItemTapped(navigationShell, id, config: config, isInfoEnabled: isInfoEnabled),
                  ),

                  drawer: DashboardDrawer(isLandscape: isLandscape),
                  bottomSheet: AppBottomSheet(
                    isOpen: isLogoutSheetOpen,
                    onClose: closeSheet,
                    child: LogoutConfirmationSheet(
                      onConfirm: () {
                        closeSheet();
                        ref.read(authProvider.notifier).logout();
                      },
                      onCancel: closeSheet,
                    ),
                  ),
                  child: navigationShell,
                );
              },
            );
          },
        );
      },
      branches: [
        // Home Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const PaidActiveHomeScreen(),
              routes: [
                GoRoute(
                  path: 'forum',
                  builder: (context, state) =>
                      const ForumCourseSelectionScreen(),
                  routes: [
                    GoRoute(
                      path: 'posts/:courseId',
                      builder: (context, state) {
                        final courseId = state.pathParameters['courseId']!;
                        return ForumPostsListScreen(courseId: courseId);
                      },
                      routes: [
                        GoRoute(
                          path: ':threadId',
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
              ],
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
                    final parentId = state.uri.queryParameters['parentId'];
                    return ChaptersListPage(
                      courseId: courseId,
                      parentId: parentId,
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
                            final String? path = switch (lesson.type) {
                              LessonType.video ||
                              LessonType.pdf ||
                              LessonType.attachment ||
                              LessonType.notes ||
                              LessonType.embedContent ||
                              LessonType.liveStream =>
                                '/study/lesson/${lesson.id}',
                              LessonType.test => '/study/test/${lesson.id}',
                              LessonType.assessment =>
                                '/study/assessment/${lesson.id}',
                              LessonType.unknown => null,
                            };
                            if (path != null) {
                              context.push(path, extra: lesson);
                            }
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
                            return _LessonRedirector(
                              lesson: lesson,
                              child: LessonDetailOrchestrator(
                                lesson: lesson,
                                onNext: lesson.nextContentId != null
                                    ? () => context.pushReplacement(
                                        '/study/lesson/${lesson.nextContentId}')
                                    : null,
                                onPrevious: lesson.previousContentId != null
                                    ? () => context.pushReplacement(
                                        '/study/lesson/${lesson.previousContentId}')
                                    : null,
                              ),
                            );
                          },
                          loading: () => Container(
                            color: Design.of(context).colors.surface,
                            child: const Center(child: AppLoadingIndicator()),
                          ),
                          error: (error, _) {
                            final l10n = L10n.of(context);
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      LucideIcons.alertCircle,
                                      size: 48,
                                      color: Color(0xFFEF4444), // Error red
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      l10n.errorLessonLoad,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF6B7280), // Text gray
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    AppButton.primary(
                                      label: l10n.labelRetry,
                                      onPressed: () => ref.refresh(lessonDetailProvider(id)),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
                GoRoute(
                  path: 'video/:id',
                  redirect: (context, state) =>
                      '/study/lesson/${state.pathParameters['id']}',
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
        // Exams Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/exams',
              builder: (context, state) => const ExamsScreen(),
            ),
          ],
        ),
        // Explore Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/explore',
              builder: (context, state) => const ExplorePage(),
            ),
          ],
        ),
        // Info Branch (Optional 5th Tab)
        if (isInfoEnabled)
          StatefulShellBranch(
            routes: [
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
                GoRoute(
                  name: 'profile-edit',
                  path: 'edit',
                  builder: (context, state) {
                    return const EditProfileScreen();
                  },
                ),
                GoRoute(
                  name: 'profile-settings',
                  path: 'settings',
                  builder: (context, state) {
                    return AppSettingsScreen(onBack: () => context.pop());
                  },
                ),
                GoRoute(
                  name: 'profile-certificates',
                  path: 'certificates',
                  builder: (context, state) {
                    return CertificatesScreen(
                      onBack: () => context.pop(),
                      onOpenPreview: (certificate) {
                        context.pushNamed(
                          'profile-certificate-preview',
                          extra: certificate,
                        );
                      },
                    );
                  },
                  routes: [
                    GoRoute(
                      name: 'profile-certificate-preview',
                      path: 'preview',
                      redirect: (context, state) {
                        if (state.extra is! CourseCertificate) {
                          return state.namedLocation('profile-certificates');
                        }
                        return null;
                      },
                      builder: (context, state) {
                        final certificate = state.extra as CourseCertificate;
                        return CertificatePreviewScreen(
                          certificate: certificate,
                          onClose: () => context.pop(),
                        );
                      },
                    ),
                  ],
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
});

List<String> _tabPaths({
  required ClientConfig config,
  required bool isInfoEnabled,
}) {
  if (config.useRestrictedNavigation) {
    return ['/home', '/study', '/exams', '/info'];
  }

  return [
    '/home',
    '/study',
    if (config.showExamTab) '/exams',
    '/explore',
    if (isInfoEnabled) '/info',
    '/profile',
  ];
}

List<AppTabItem> buildPrimaryNavigationItems({
  required ClientConfig config,
  required bool isInfoEnabled,
}) {
  if (config.useRestrictedNavigation) {
    return [
      const AppTabItem(id: '/home', label: 'Home', icon: LucideIcons.home),
      const AppTabItem(id: '/study', label: 'Study', icon: LucideIcons.bookOpen),
      const AppTabItem(id: '/exams', label: 'Exam', icon: LucideIcons.fileText),
      const AppTabItem(id: '/info', label: 'Info', icon: LucideIcons.youtube),
    ];
  }

  return [
    const AppTabItem(id: '/home', label: 'Home', icon: LucideIcons.home),
    const AppTabItem(id: '/study', label: 'Study', icon: LucideIcons.bookOpen),
    if (config.showExamTab)
      const AppTabItem(id: '/exams', label: 'Exam', icon: LucideIcons.fileText),
    const AppTabItem(
      id: '/explore',
      label: 'Explore',
      icon: LucideIcons.compass,
    ),
    if (isInfoEnabled)
      const AppTabItem(
        id: '/info',
        label: 'Info',
        icon: LucideIcons.youtube,
      ),
    const AppTabItem(id: '/profile', label: 'Profile', icon: LucideIcons.user),
  ];
}

String _getCurrentTabId(
  int index, {
  required ClientConfig config,
  required bool isInfoEnabled,
}) {
  final allBranchPaths = [
    '/home',
    '/study',
    '/exams',
    '/explore',
    if (isInfoEnabled) '/info',
    '/profile',
  ];
  return allBranchPaths[index];
}

void _onTabItemTapped(
  StatefulNavigationShell navigationShell,
  String id, {
  required ClientConfig config,
  required bool isInfoEnabled,
}) {
  final allBranchPaths = [
    '/home',
    '/study',
    '/exams',
    '/explore',
    if (isInfoEnabled) '/info',
    '/profile',
  ];
  final index = allBranchPaths.indexOf(id);

  navigationShell.goBranch(
    index != -1 ? index : 0,
  );
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

class _LessonRedirector extends StatefulWidget {
  final Lesson lesson;
  final Widget child;

  const _LessonRedirector({required this.lesson, required this.child});

  @override
  State<_LessonRedirector> createState() => _LessonRedirectorState();
}

class _LessonRedirectorState extends State<_LessonRedirector> {
  @override
  void initState() {
    super.initState();
    _checkRedirect();
  }

  @override
  void didUpdateWidget(_LessonRedirector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.lesson.id != oldWidget.lesson.id) {
      _checkRedirect();
    }
  }

  void _checkRedirect() {
    if (widget.lesson.type == LessonType.test) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.go('/study/test/${widget.lesson.id}', extra: widget.lesson);
        }
      });
    } else if (widget.lesson.type == LessonType.assessment) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.go('/study/assessment/${widget.lesson.id}',
              extra: widget.lesson);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // While redirecting, we show the child (orchestrator) but it will be immediately
    // replaced by the new route after the first frame.
    return widget.child;
  }
}
