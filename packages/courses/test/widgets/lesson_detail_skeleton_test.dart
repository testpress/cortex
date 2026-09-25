import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/widgets/lesson_detail/lesson_detail_skeleton.dart';

void main() {
  Widget createTestWidget(Widget child,
      {Size surfaceSize = const Size(1006.6, 441.8)}) {
    return DesignProvider(
      config: DesignConfig.defaults(),
      child: LocalizationProvider(
        child: MediaQuery(
          data: MediaQueryData(size: surfaceSize),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              width: surfaceSize.width,
              height: surfaceSize.height,
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  group('LessonDetailSkeleton', () {
    testWidgets('renders video skeleton without overflow on tablet landscape',
        (tester) async {
      // Dimensions from the user's tablet landscape crash
      tester.view.physicalSize = const Size(1006.6, 441.8);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        createTestWidget(
          const LessonDetailSkeleton(lessonType: LessonType.video),
          surfaceSize: const Size(1006.6, 441.8),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byType(LessonDetailSkeleton), findsOneWidget);
    });

    testWidgets('renders pdf skeleton without overflow on tablet landscape',
        (tester) async {
      tester.view.physicalSize = const Size(1006.6, 441.8);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        createTestWidget(
          const LessonDetailSkeleton(lessonType: LessonType.pdf),
          surfaceSize: const Size(1006.6, 441.8),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byType(LessonDetailSkeleton), findsOneWidget);
    });

    testWidgets(
        'renders fallback notes skeleton without overflow on constrained height',
        (tester) async {
      tester.view.physicalSize = const Size(1006.6, 441.8);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        createTestWidget(
          const LessonDetailSkeleton(lessonType: null),
          surfaceSize: const Size(1006.6, 441.8),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byType(LessonDetailSkeleton), findsOneWidget);
    });
  });
}
