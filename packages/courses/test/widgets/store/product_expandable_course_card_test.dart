import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/providers/store_providers.dart';
import 'package:courses/repositories/store_repository.dart';
import 'package:courses/widgets/store/product_expandable_course_card.dart';

class _MockSentryService extends SentryService {
  @override
  Future<void> captureException(
    dynamic exception, {
    Map<String, dynamic>? contexts,
    AppErrorLevel? level,
    dynamic stackTrace,
    Map<String, String>? tags,
    bool bypassFilter = false,
  }) async {}
}

class _TrackingDataSource extends MockDataSource {
  int getCourseChaptersCallCount = 0;

  @override
  Future<List<ChapterDto>> getCourseChapters(String courseId) async {
    getCourseChaptersCallCount++;
    return const [
      ChapterDto(
        id: 'ch-1',
        courseId: '101',
        title: 'Introduction to Physics',
        lessonCount: 2,
        assessmentCount: 0,
        orderIndex: 0,
        isLeaf: true,
      ),
    ];
  }
}

void main() {
  Widget buildTestWidget({
    required Widget child,
    required StoreRepository repository,
  }) {
    return ProviderScope(
      overrides: [
        storeRepositoryProvider.overrideWithValue(repository),
      ],
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

  group('ProductExpandableCourseCard', () {
    testWidgets(
      'second expand does not refetch course chapters from data source',
      (tester) async {
        final dataSource = _TrackingDataSource();
        final repository = StoreRepository(
          source: dataSource,
          sentryService: _MockSentryService(),
        );

        const course = ProductCourseDto(
          id: 101,
          title: 'Physics 101',
          slug: 'physics-101',
          chaptersCount: 1,
        );

        await tester.pumpWidget(
          buildTestWidget(
            child: const ProductExpandableCourseCard(course: course),
            repository: repository,
          ),
        );

        // Before expansion: no network call
        expect(dataSource.getCourseChaptersCallCount, 0);
        expect(find.text('Introduction to Physics'), findsNothing);

        // First expansion
        await tester.tap(find.text('Physics 101'));
        await tester.pumpAndSettle();

        expect(find.text('Introduction to Physics'), findsOneWidget);
        expect(dataSource.getCourseChaptersCallCount, 1);

        // Collapse card
        await tester.tap(find.text('Physics 101'));
        await tester.pumpAndSettle();

        expect(find.text('Introduction to Physics'), findsNothing);

        // Second expansion
        await tester.tap(find.text('Physics 101'));
        await tester.pumpAndSettle();

        expect(find.text('Introduction to Physics'), findsOneWidget);
        // Call count MUST remain 1 because StoreRepository cached chapters in memory
        expect(dataSource.getCourseChaptersCallCount, 1);
      },
    );
  });
}
