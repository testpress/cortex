import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:courses/courses.dart';
import 'package:exams/exams.dart';

class ExamsRoutes {
  static List<RouteBase> routes(GlobalKey<NavigatorState> rootNavigatorKey) => [
    GoRoute(
      path: '/exams',
      builder: (context, state) => const ExamsScreen(),
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
              showFilters: false,
              basePath: '/exams',
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
                  showFilters: false,
                  onLessonClick: (lesson) {
                    final String path = switch (lesson.type) {
                      LessonType.test => '/exams/test/${lesson.id}',
                      LessonType.assessment => '/exams/assessment/${lesson.id}',
                      _ => '/exams/lesson/${lesson.id}',
                    };
                    context.push(path, extra: lesson);
                  },
                );
              },
            ),
            GoRoute(
              path: 'test/:id',
              parentNavigatorKey: rootNavigatorKey,
              pageBuilder: (context, state) {
                final id = state.pathParameters['id']!;
                final extra = state.extra;
                final lesson = extra is LessonDto
                    ? extra
                    : (extra is Lesson ? extra.toDto() : null);
                return CustomTransitionPage(
                  key: state.pageKey,
                  opaque: false,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return child;
                      },
                  child: ExamPrescreen(
                    testId: id,
                    lesson: lesson,
                    onClose: () => context.pop(),
                    onStartAttempt: (isQuizMode) async {
                      context.pushReplacement(
                        '/exams/test/$id/player?isQuizMode=$isQuizMode',
                        extra: lesson,
                      );
                    },
                  ),
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
                    final isQuizMode =
                        state.uri.queryParameters['isQuizMode'] == 'true';
                    return TestDetailScreen(
                      testId: id,
                      lesson: lesson,
                      isQuizMode: isQuizMode,
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
                      attempt: payload?.attempt,
                      exam: payload?.exam,
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
                      attempt: payload?.attempt,
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
        GoRoute(
          path: 'test/:id',
          parentNavigatorKey: rootNavigatorKey,
          pageBuilder: (context, state) {
            final id = state.pathParameters['id']!;
            final extra = state.extra;
            final lesson = extra is LessonDto
                ? extra
                : (extra is Lesson ? extra.toDto() : null);
            return CustomTransitionPage(
              key: state.pageKey,
              opaque: false,
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return child;
                  },
              child: ExamPrescreen(
                testId: id,
                lesson: lesson,
                onClose: () => context.pop(),
                onStartAttempt: (isQuizMode) async {
                  context.pushReplacement(
                    '/exams/test/$id/player?isQuizMode=$isQuizMode',
                    extra: lesson,
                  );
                },
              ),
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
                final isQuizMode =
                    state.uri.queryParameters['isQuizMode'] == 'true';
                return TestDetailScreen(
                  testId: id,
                  lesson: lesson,
                  isQuizMode: isQuizMode,
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
                  assessmentTitle: payload?.assessmentTitle ?? 'Assessment $id',
                  questions: payload?.questions ?? const <QuestionDto>[],
                  attemptStates:
                      payload?.attemptStates ?? const <String, AnswerDto>{},
                  attempt: payload?.attempt,
                  exam: payload?.exam,
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
                  assessmentTitle: payload?.assessmentTitle ?? 'Assessment $id',
                  questions: payload?.questions ?? const <QuestionDto>[],
                  attemptStates:
                      payload?.attemptStates ?? const <String, AnswerDto>{},
                  attempt: payload?.attempt,
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
                      return const Center(child: Text('Lesson not found'));
                    }
                    return _ExamLessonRedirector(
                      lesson: lesson,
                      child: LessonDetailOrchestrator(
                        lesson: lesson,
                        onNext: lesson.nextContentId != null
                            ? () => context.pushReplacement(
                                '/exams/lesson/${lesson.nextContentId}',
                              )
                            : null,
                        onPrevious: lesson.previousContentId != null
                            ? () => context.pushReplacement(
                                '/exams/lesson/${lesson.previousContentId}',
                              )
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
                    final design = Design.of(context);
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(design.spacing.cardPadding),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              LucideIcons.alertCircle,
                              size: design.spacing.xxl,
                              color: design.colors.error,
                            ),
                            SizedBox(height: design.spacing.md),
                            Text(
                              l10n.errorLessonLoad,
                              textAlign: TextAlign.center,
                              style: design.typography.body.copyWith(
                                color: design.colors.textSecondary,
                              ),
                            ),
                            SizedBox(height: design.spacing.lg),
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
          path: 'analytics',
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) {
            return SubjectAnalyticsScreen(
              parentId: null,
              subjectName: null,
              onBack: () => context.pop(),
            );
          },
          routes: [
            GoRoute(
              path: 'topic/:id',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) {
                final topicId = state.pathParameters['id']!;
                final topic = state.extra as SubjectAnalyticsDto?;
                return TopicAnalyticsScreen(
                  topicId: topicId,
                  topic: topic,
                  onBack: () => context.pop(),
                );
              },
            ),
            GoRoute(
              path: ':parentId',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) {
                final parentId = state.pathParameters['parentId'];
                final extra = state.extra;
                final subjectName = extra is SubjectAnalyticsDto
                    ? extra.name
                    : null;
                return SubjectAnalyticsScreen(
                  parentId: parentId,
                  subjectName: subjectName,
                  onBack: () => context.pop(),
                );
              },
            ),
          ],
        ),
      ],
    ),
  ];
}

/// An internal widget to handle redirects for specific lesson types in exams.
class _ExamLessonRedirector extends StatefulWidget {
  final Lesson lesson;
  final Widget child;

  const _ExamLessonRedirector({required this.lesson, required this.child});

  @override
  State<_ExamLessonRedirector> createState() => _ExamLessonRedirectorState();
}

class _ExamLessonRedirectorState extends State<_ExamLessonRedirector> {
  @override
  void initState() {
    super.initState();
    _checkRedirect();
  }

  @override
  void didUpdateWidget(_ExamLessonRedirector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.lesson.id != oldWidget.lesson.id) {
      _checkRedirect();
    }
  }

  void _checkRedirect() {
    if (widget.lesson.type == LessonType.test) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.go('/exams/test/${widget.lesson.id}', extra: widget.lesson);
        }
      });
    } else if (widget.lesson.type == LessonType.assessment) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.go(
            '/exams/assessment/${widget.lesson.id}',
            extra: widget.lesson,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
