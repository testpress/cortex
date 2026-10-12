import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/widgets/store/store_chapter_tile.dart';

class FakeTestDataSource extends MockDataSource {
  FakeTestDataSource();

  int getChapterContentsCallCount = 0;

  @override
  Future<List<LessonDto>> getChapterContents(
    String courseId,
    String chapterId,
  ) async {
    getChapterContentsCallCount++;
    if (chapterId == 'ch-1-sub') {
      return const [
        LessonDto(
          id: '101',
          chapterId: 'ch-1-sub',
          title: 'REP.MED26-WAVES-PART-1',
          type: LessonType.video,
          duration: '45 min',
          progressStatus: LessonProgressStatus.notStarted,
          isLocked: true,
          orderIndex: 0,
        ),
        LessonDto(
          id: '102',
          chapterId: 'ch-1-sub',
          title: 'Waves Intro Demo',
          type: LessonType.video,
          duration: '10 min',
          progressStatus: LessonProgressStatus.notStarted,
          isLocked: false,
          orderIndex: 1,
        ),
      ];
    }
    return [];
  }
}

void main() {
  Widget buildTestWidget({
    required Widget child,
    List<Override> overrides = const [],
  }) {
    return ProviderScope(
      overrides: overrides,
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

  const rootChapter = ChapterDto(
    id: 'ch-1',
    courseId: '372',
    title: 'Chapter 1: Physics',
    lessonCount: 2,
    assessmentCount: 0,
    orderIndex: 0,
    isLeaf: false,
  );

  const subFolder = ChapterDto(
    id: 'ch-1-sub',
    parentId: 'ch-1',
    courseId: '372',
    title: 'Videos',
    lessonCount: 2,
    assessmentCount: 0,
    orderIndex: 0,
    isLeaf: true,
  );

  final allChapters = [rootChapter, subFolder];

  testWidgets('expands parent chapter to reveal sub-folder', (tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        child: SingleChildScrollView(
          child: StoreChapterTile(
            courseId: '372',
            chapter: rootChapter,
            allChapters: allChapters,
          ),
        ),
        overrides: [
          dataSourceProvider.overrideWithValue(FakeTestDataSource()),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Chapter 1: Physics'), findsOneWidget);
    // Sub-folder not visible yet
    expect(find.text('Videos'), findsNothing);

    // Tap root chapter to expand
    await tester.tap(find.text('Chapter 1: Physics'));
    await tester.pumpAndSettle();

    // Now sub-folder Videos should be visible
    expect(find.text('Videos'), findsOneWidget);
  });

  testWidgets(
      'expands leaf sub-folder to fetch and render contents with lock badges',
      (tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        child: SingleChildScrollView(
          child: StoreChapterTile(
            courseId: '372',
            chapter: rootChapter,
            allChapters: allChapters,
          ),
        ),
        overrides: [
          dataSourceProvider.overrideWithValue(FakeTestDataSource()),
        ],
      ),
    );
    await tester.pumpAndSettle();

    // Tap root chapter
    await tester.tap(find.text('Chapter 1: Physics'));
    await tester.pumpAndSettle();

    // Tap sub-folder Videos
    await tester.tap(find.text('Videos'));
    await tester.pumpAndSettle();

    // Verify contents are rendered
    expect(find.text('REP.MED26-WAVES-PART-1'), findsOneWidget);
    expect(find.text('Waves Intro Demo'), findsOneWidget);
    expect(find.text('Buy to Unlock'), findsNWidgets(2));

    // Verify AppSemantics.container wraps content tiles
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.container == true &&
            widget.properties.label == 'REP.MED26-WAVES-PART-1, Buy to Unlock',
      ),
      findsOneWidget,
    );
  });

  testWidgets(
      'collapsing and re-expanding a chapter does not trigger another network call',
      (tester) async {
    final fakeDataSource = FakeTestDataSource();
    await tester.pumpWidget(
      buildTestWidget(
        child: SingleChildScrollView(
          child: StoreChapterTile(
            courseId: '372',
            chapter: rootChapter,
            allChapters: allChapters,
          ),
        ),
        overrides: [
          dataSourceProvider.overrideWithValue(fakeDataSource),
        ],
      ),
    );
    await tester.pumpAndSettle();

    // Expand root chapter
    await tester.tap(find.text('Chapter 1: Physics'));
    await tester.pumpAndSettle();

    // Expand Videos
    await tester.tap(find.text('Videos'));
    await tester.pumpAndSettle();

    expect(find.text('REP.MED26-WAVES-PART-1'), findsOneWidget);
    expect(fakeDataSource.getChapterContentsCallCount, 1);

    // Collapse Videos
    await tester.tap(find.text('Videos'));
    await tester.pumpAndSettle();
    expect(find.text('REP.MED26-WAVES-PART-1'), findsNothing);

    // Re-expand Videos - verify instant frame-0 render without waiting for microtasks
    await tester.tap(find.text('Videos'));
    await tester.pump(); // Single frame pump - proves ZERO skeleton flash
    expect(find.text('REP.MED26-WAVES-PART-1'), findsOneWidget);

    // Network call count must STILL be 1 because cached in StoreRepository
    expect(fakeDataSource.getChapterContentsCallCount, 1);
  });

  testWidgets('tapping Buy to Unlock triggers onBuyTap callback',
      (tester) async {
    bool buyTapped = false;
    await tester.pumpWidget(
      buildTestWidget(
        child: SingleChildScrollView(
          child: StoreChapterTile(
            courseId: '372',
            chapter: rootChapter,
            allChapters: allChapters,
            onBuyTap: () => buyTapped = true,
          ),
        ),
        overrides: [
          dataSourceProvider.overrideWithValue(FakeTestDataSource()),
        ],
      ),
    );
    await tester.pumpAndSettle();

    // Expand root chapter
    await tester.tap(find.text('Chapter 1: Physics'));
    await tester.pumpAndSettle();

    // Expand Videos
    await tester.tap(find.text('Videos'));
    await tester.pumpAndSettle();

    // Tap Buy to Unlock
    await tester.tap(find.text('Buy to Unlock').first);
    await tester.pumpAndSettle();

    expect(buyTapped, isTrue);
  });
}
