import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:core/navigation/lesson_router.dart';
import 'package:core/navigation/route_names.dart';

enum CustomLessonType { video, test, assessment, unknown }

void main() {
  group('LessonRouter', () {
    testWidgets('navigates to lessonDetail for video string type with extra', (
      tester,
    ) async {
      String? pushedLocation;
      Object? receivedExtra;

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const SizedBox.shrink(),
          ),
          GoRoute(
            name: AppRouteNames.lessonDetail,
            path: '/lesson/:id',
            builder: (context, state) {
              pushedLocation = state.matchedLocation;
              receivedExtra = state.extra;
              return const SizedBox.shrink();
            },
          ),
        ],
      );

      await tester.pumpWidget(
        WidgetsApp.router(routerConfig: router, color: const Color(0xFF000000)),
      );

      final BuildContext context = tester.element(find.byType(SizedBox));
      LessonRouter.navigateToLesson(
        context,
        id: '123',
        type: 'video',
        extra: {'title': 'Sample Video'},
      );

      await tester.pumpAndSettle();

      expect(pushedLocation, '/lesson/123');
      expect(receivedExtra, {'title': 'Sample Video'});
    });

    testWidgets('navigates to testDetail for enum test type with extra', (
      tester,
    ) async {
      String? pushedLocation;
      Object? receivedExtra;

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const SizedBox.shrink(),
          ),
          GoRoute(
            name: AppRouteNames.testDetail,
            path: '/test/:id',
            builder: (context, state) {
              pushedLocation = state.matchedLocation;
              receivedExtra = state.extra;
              return const SizedBox.shrink();
            },
          ),
        ],
      );

      await tester.pumpWidget(
        WidgetsApp.router(routerConfig: router, color: const Color(0xFF000000)),
      );

      final BuildContext context = tester.element(find.byType(SizedBox));
      LessonRouter.navigateToLesson(
        context,
        id: '8856',
        type: CustomLessonType.test,
        extra: 'custom_payload',
      );

      await tester.pumpAndSettle();

      expect(pushedLocation, '/test/8856');
      expect(receivedExtra, 'custom_payload');
    });

    testWidgets('navigates to assessmentDetail for assessment type', (
      tester,
    ) async {
      String? pushedLocation;

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const SizedBox.shrink(),
          ),
          GoRoute(
            name: AppRouteNames.assessmentDetail,
            path: '/assessment/:id',
            builder: (context, state) {
              pushedLocation = state.matchedLocation;
              return const SizedBox.shrink();
            },
          ),
        ],
      );

      await tester.pumpWidget(
        WidgetsApp.router(routerConfig: router, color: const Color(0xFF000000)),
      );

      final BuildContext context = tester.element(find.byType(SizedBox));
      LessonRouter.navigateToLesson(context, id: '999', type: 'assessment');

      await tester.pumpAndSettle();

      expect(pushedLocation, '/assessment/999');
    });

    testWidgets('does not navigate for unknown content type', (tester) async {
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const SizedBox.shrink(),
          ),
        ],
      );

      await tester.pumpWidget(
        WidgetsApp.router(routerConfig: router, color: const Color(0xFF000000)),
      );

      final BuildContext context = tester.element(find.byType(SizedBox));
      LessonRouter.navigateToLesson(
        context,
        id: '999',
        type: 'unknown_unsupported_type',
      );

      await tester.pumpAndSettle();

      // Location remains root
      expect(router.state.matchedLocation, '/');
    });
  });
}
