import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:courses/courses.dart';
import 'package:exams/exams.dart';

class StudyRoutes {
  static List<RouteBase> routes(GlobalKey<NavigatorState> rootNavigatorKey) => [
        GoRoute(
          name: AppRouteNames.study,
          path: '/study',
          builder: (context, state) => const StudyScreen(),
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
                      onLessonClick: (lesson) => LessonRouter.navigateToLesson(
                        context,
                        id: lesson.id,
                        type: lesson.type,
                      ),
                    );
                  },
                ),
              ],
            ),
            GoRoute(
              name: AppRouteNames.lessonDetail,
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
                                  color: Color(0xFFEF4444),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  l10n.errorLessonLoad,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                AppButton.primary(
                                  label: l10n.labelRetry,
                                  onPressed: () =>
                                      ref.refresh(lessonDetailProvider(id)),
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
              name: AppRouteNames.videoDetail,
              path: 'video/:id',
              redirect: (context, state) =>
                  '/study/lesson/${state.pathParameters['id']}',
            ),
            GoRoute(
              name: AppRouteNames.testDetail,
              path: 'test/:id',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                final extra = state.extra;
                final lesson = extra is LessonDto
                    ? extra
                    : (extra is Lesson ? extra.toDto() : null);
                return ExamPrescreen(
                  testId: id,
                  lesson: lesson,
                  onClose: () => context.pop(),
                  onStartAttempt: () async {
                    context.pushReplacement('/study/test/$id/player',
                        extra: lesson);
                  },
                );
              },
              routes: [
                GoRoute(
                  path: 'player',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    final extra = state.extra;
                    final lesson = extra is LessonDto
                        ? extra
                        : (extra is Lesson ? extra.toDto() : null);
                    return TestDetailScreen(
                      testId: id,
                      lesson: lesson,
                      onClose: () => context.pop(),
                    );
                  },
                ),
                GoRoute(
                  path: 'review-analytics',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    final payload = state.extra as ReviewRoutePayload?;
                    return ReviewAnalyticsScreen(
                      testId: id,
                      assessmentTitle:
                          payload?.assessmentTitle ?? 'Assessment $id',
                      questions: payload?.questions ?? const <QuestionDto>[],
                      attemptStates:
                          payload?.attemptStates ?? const <String, AnswerDto>{},
                      onBack: () => context.pop(),
                    );
                  },
                ),
                GoRoute(
                  path: 'review-answers',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    final payload = state.extra as ReviewRoutePayload?;
                    return ReviewAnswerDetailScreen(
                      assessmentTitle:
                          payload?.assessmentTitle ?? 'Assessment $id',
                      questions: payload?.questions ?? const <QuestionDto>[],
                      attemptStates:
                          payload?.attemptStates ?? const <String, AnswerDto>{},
                      onBack: () => context.pop(),
                    );
                  },
                ),
              ],
            ),
            GoRoute(
              path: 'assessment/:id',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                final extra = state.extra;
                final lesson = extra is LessonDto
                    ? extra
                    : (extra is Lesson ? extra.toDto() : null);
                return AssessmentDetailScreen(
                  assessmentId: id,
                  lesson: lesson,
                  onClose: () => context.pop(),
                );
              },
            ),
          ],
        ),
      ];
}

/// A internal widget to handle redirects for specific lesson types.
class _LessonRedirector extends StatefulWidget {
  final Lesson lesson;
  final Widget child;

  const _LessonRedirector({
    required this.lesson,
    required this.child,
  });

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
    return widget.child;
  }
}
