import 'package:core/core.dart';
import 'package:courses/courses.dart';
import 'package:exams/exams.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testpress/navigation/routes/study_routes.dart';

void main() {
  Widget createTestApp({
    required GoRouter router,
    required List<Override> overrides,
  }) {
    return ProviderScope(
      overrides: overrides,
      child: DesignProvider(
        config: DesignConfig.defaults(),
        child: LocalizationProvider(
          child: Builder(
            builder: (context) {
              final locale = LocalizationProvider.of(context).locale;
              return WidgetsApp.router(
                color: const Color(0xFF000000),
                routerConfig: router,
                locale: locale,
                localizationsDelegates: LocalizationProvider.delegates,
              );
            },
          ),
        ),
      ),
    );
  }

  group('StudyRoutes _LessonRedirector', () {
    testWidgets('redirects LessonType.test to ExamPrescreen', (tester) async {
      final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
      final router = GoRouter(
        navigatorKey: rootNavigatorKey,
        initialLocation: '/study/lesson/123',
        routes: StudyRoutes.routes(rootNavigatorKey),
      );

      const testLesson = LessonDto(
        id: '123',
        chapterId: 'chap-1',
        title: 'Sample Test Lesson',
        type: LessonType.test,
        duration: '00:30:00',
        progressStatus: LessonProgressStatus.notStarted,
        isLocked: false,
        orderIndex: 0,
      );

      await tester.pumpWidget(
        createTestApp(
          router: router,
          overrides: [
            lessonDetailProvider(
              '123',
            ).overrideWith((ref) => Stream.value(testLesson)),
          ],
        ),
      );

      // Build initial frame to stream data and mount _LessonRedirector
      await tester.pump();
      // Allow post-frame callback (pushReplacement) to execute
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(ExamPrescreen), findsOneWidget);
    });

    testWidgets('redirects LessonType.assessment to ExamPrescreen', (
      tester,
    ) async {
      final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
      final router = GoRouter(
        navigatorKey: rootNavigatorKey,
        initialLocation: '/study/lesson/456',
        routes: StudyRoutes.routes(rootNavigatorKey),
      );

      const assessmentLesson = LessonDto(
        id: '456',
        chapterId: 'chap-1',
        title: 'Sample Assessment Lesson',
        type: LessonType.assessment,
        duration: '00:30:00',
        progressStatus: LessonProgressStatus.notStarted,
        isLocked: false,
        orderIndex: 1,
      );

      await tester.pumpWidget(
        createTestApp(
          router: router,
          overrides: [
            lessonDetailProvider(
              '456',
            ).overrideWith((ref) => Stream.value(assessmentLesson)),
          ],
        ),
      );

      // Build initial frame to stream data and mount _LessonRedirector
      await tester.pump();
      // Allow post-frame callback (pushReplacement) to execute
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(ExamPrescreen), findsOneWidget);
    });

    testWidgets(
      'renders AssessmentDetailScreen for /study/assessment/:id/player route',
      (tester) async {
        final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
        final router = GoRouter(
          navigatorKey: rootNavigatorKey,
          initialLocation: '/study/assessment/456/player',
          routes: StudyRoutes.routes(rootNavigatorKey),
        );

        await tester.pumpWidget(
          createTestApp(
            router: router,
            overrides: [
              lessonDetailProvider(
                '456',
              ).overrideWith((ref) => Stream.value(null)),
            ],
          ),
        );

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.byType(AssessmentDetailScreen), findsOneWidget);
      },
    );

    testWidgets(
      'renders ReviewAnalyticsScreen for /study/assessment/:id/review-analytics route',
      (tester) async {
        final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
        final router = GoRouter(
          navigatorKey: rootNavigatorKey,
          initialLocation: '/study/assessment/456/review-analytics',
          routes: StudyRoutes.routes(rootNavigatorKey),
        );

        await tester.pumpWidget(createTestApp(router: router, overrides: []));

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.byType(ReviewAnalyticsScreen), findsOneWidget);
      },
    );

    testWidgets(
      'renders ReviewAnswerDetailScreen for /study/assessment/:id/review-answers route',
      (tester) async {
        final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
        final router = GoRouter(
          navigatorKey: rootNavigatorKey,
          initialLocation: '/study/assessment/456/review-answers',
          routes: StudyRoutes.routes(rootNavigatorKey),
        );

        await tester.pumpWidget(createTestApp(router: router, overrides: []));

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.byType(ReviewAnswerDetailScreen), findsOneWidget);
      },
    );
  });
}
