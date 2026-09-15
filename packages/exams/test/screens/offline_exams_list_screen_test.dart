import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:exams/screens/offline_exams_list_screen.dart';

class _FakeOfflineExams extends OfflineExams {
  final List<OfflineExamDownloadsTableData> _exams;
  _FakeOfflineExams(this._exams);

  @override
  Stream<List<OfflineExamDownloadsTableData>> build() async* {
    yield _exams;
  }
}

void main() {
  Widget createWidgetUnderTest(List<OfflineExamDownloadsTableData> exams) {
    return ProviderScope(
      overrides: [
        offlineExamsProvider.overrideWith(() => _FakeOfflineExams(exams)),
      ],
      child: WidgetsApp(
        color: const Color(0xFF000000),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => Directionality(
          textDirection: TextDirection.ltr,
          child: Builder(
            builder: (context) {
              return DesignProvider(
                config: DesignConfig.light(),
                child: const OfflineExamsListScreen(),
              );
            },
          ),
        ),
      ),
    );
  }

  final testExamPending = OfflineExamDownloadsTableData(
    id: 1,
    contentId: 'c1',
    examId: 'e1',
    title: 'Pending Sync Exam',
    duration: '01:00:00',
    questionCount: 10,
    status: 'PENDING_SYNC',
    downloadedAt: DateTime.now(),
    questionsJson: '[]',
    elapsedSeconds: 0,
  );

  final testExamDownloaded = OfflineExamDownloadsTableData(
    id: 2,
    contentId: 'c2',
    examId: 'e2',
    title: 'Downloaded Exam',
    duration: '01:00:00',
    questionCount: 10,
    status: 'DOWNLOADED',
    downloadedAt: DateTime.now(),
    questionsJson: '[]',
    elapsedSeconds: 0,
  );

  final testExamSynced = OfflineExamDownloadsTableData(
    id: 3,
    contentId: 'c3',
    examId: 'e3',
    title: 'Synced Exam',
    duration: '01:00:00',
    questionCount: 10,
    status: 'SYNCED',
    downloadedAt: DateTime.now(),
    questionsJson: '[]',
    elapsedSeconds: 0,
  );

  testWidgets('Renders Sync button when exam is PENDING_SYNC', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest([testExamPending]));
    await tester.pumpAndSettle();

    expect(find.text('Pending Sync Exam'), findsOneWidget);
    expect(find.text('Sync'), findsOneWidget);
    expect(find.text('Open'), findsNothing);
  });

  testWidgets('Renders Open button when exam is DOWNLOADED', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest([testExamDownloaded]));
    await tester.pumpAndSettle();

    expect(find.text('Downloaded Exam'), findsOneWidget);
    expect(find.text('Open'), findsOneWidget);
    expect(find.text('Sync'), findsNothing);
  });

  testWidgets('Hides Open and Sync buttons when exam is SYNCED', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest([testExamSynced]));
    await tester.pumpAndSettle();

    expect(find.text('Synced Exam'), findsOneWidget);
    expect(find.text('Open'), findsNothing);
    expect(find.text('Sync'), findsNothing);
    expect(find.text('Delete'), findsOneWidget);
  });
}
