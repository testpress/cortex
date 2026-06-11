import 'package:flutter/widgets.dart';
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
                    final String? path = switch (lesson.type) {
                      LessonType.test => '/exams/test/${lesson.id}',
                      LessonType.assessment => '/exams/assessment/${lesson.id}',
                      _ => null,
                    };
                    if (path != null) {
                      context.push(path, extra: lesson);
                    }
                  },
                );
              },
            ),
            GoRoute(
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
                  onStartAttempt: (isQuizMode) async {
                    context.pushReplacement(
                      '/exams/test/$id/player?isQuizMode=$isQuizMode',
                      extra: lesson,
                    );
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
              onStartAttempt: (isQuizMode) async {
                context.pushReplacement(
                  '/exams/test/$id/player?isQuizMode=$isQuizMode',
                  extra: lesson,
                );
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
