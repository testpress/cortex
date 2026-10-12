import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/widgets/store/store_content_tile.dart';

void main() {
  Widget buildTestWidget({
    required Widget child,
  }) {
    return ProviderScope(
      child: DesignProvider(
        config: DesignConfig.defaults(),
        child: LocalizationProvider(
          child: Builder(
            builder: (context) {
              final locale = LocalizationProvider.of(context).locale;
              return WidgetsApp(
                color: const Color(0xFF000000),
                locale: locale,
                localizationsDelegates: LocalizationProvider.delegates,
                pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
                  settings: settings,
                  pageBuilder: (context, _, __) => builder(context),
                ),
                home: child,
              );
            },
          ),
        ),
      ),
    );
  }

  const freeLesson = LessonDto(
    id: 'lesson-free-1',
    chapterId: 'ch-1',
    title: 'Free Introduction Video',
    type: LessonType.video,
    duration: '10 min',
    progressStatus: LessonProgressStatus.notStarted,
    isLocked: false,
    hasFreePreview: true,
    orderIndex: 0,
  );

  const lockedLessonWithPreview = LessonDto(
    id: 'lesson-preview-2',
    chapterId: 'ch-1',
    title: 'Preview Video with Lock Flag',
    type: LessonType.video,
    duration: '15 min',
    progressStatus: LessonProgressStatus.notStarted,
    isLocked: true,
    hasFreePreview: true,
    orderIndex: 1,
  );

  const lockedLesson = LessonDto(
    id: 'lesson-locked-3',
    chapterId: 'ch-1',
    title: 'Locked Premium Video',
    type: LessonType.video,
    duration: '30 min',
    progressStatus: LessonProgressStatus.notStarted,
    isLocked: true,
    orderIndex: 2,
  );

  group('StoreContentTile Rendering', () {
    testWidgets('renders "Free Preview" badge when isLocked is false',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: const StoreContentTile(
            content: freeLesson,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Free Introduction Video'), findsOneWidget);
      expect(find.text('Free Preview'), findsOneWidget);
      expect(find.text('Buy to Unlock'), findsNothing);
    });

    testWidgets('renders "Free Preview" badge when hasFreePreview is true',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: const StoreContentTile(
            content: lockedLessonWithPreview,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Preview Video with Lock Flag'), findsOneWidget);
      expect(find.text('Free Preview'), findsOneWidget);
      expect(find.text('Buy to Unlock'), findsNothing);
    });

    testWidgets(
        'renders "Buy to Unlock" badge when isLocked is true and not preview',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: const StoreContentTile(
            content: lockedLesson,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Locked Premium Video'), findsOneWidget);
      expect(find.text('Buy to Unlock'), findsOneWidget);
      expect(find.text('Free Preview'), findsNothing);
    });
  });

  group('StoreContentTile Callbacks & Interactions', () {
    testWidgets('tapping "Free Preview" triggers onPreviewTap with lesson',
        (tester) async {
      LessonDto? tappedLesson;
      await tester.pumpWidget(
        buildTestWidget(
          child: StoreContentTile(
            content: freeLesson,
            onPreviewTap: (lesson) {
              tappedLesson = lesson;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Free Preview'));
      await tester.pumpAndSettle();

      expect(tappedLesson, isNotNull);
      expect(tappedLesson!.id, 'lesson-free-1');
    });

    testWidgets('tapping "Buy to Unlock" triggers onBuyTap', (tester) async {
      bool buyTapped = false;
      await tester.pumpWidget(
        buildTestWidget(
          child: StoreContentTile(
            content: lockedLesson,
            onBuyTap: () {
              buyTapped = true;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Buy to Unlock'));
      await tester.pumpAndSettle();

      expect(buyTapped, isTrue);
    });
  });

  group('StoreContentTile Accessibility & Semantics', () {
    testWidgets(
        'renders semantics button for preview when onPreviewTap is provided',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: StoreContentTile(
            content: freeLesson,
            onPreviewTap: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.button == true &&
              widget.properties.label == 'Free Preview',
        ),
        findsOneWidget,
      );
    });

    testWidgets('maintains min 48dp touch target on interactive badge',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: StoreContentTile(
            content: freeLesson,
            onPreviewTap: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      final constrainedBox = tester.widget<ConstrainedBox>(
        find
            .ancestor(
              of: find.text('Free Preview'),
              matching: find.byType(ConstrainedBox),
            )
            .first,
      );

      expect(constrainedBox.constraints.minHeight, greaterThanOrEqualTo(48.0));
      expect(constrainedBox.constraints.minWidth, greaterThanOrEqualTo(48.0));
    });
  });
}
