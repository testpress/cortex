import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:exams/providers/exam_providers.dart';
import 'package:exams/widgets/offline_exam_action_button.dart';

class _FakeOfflineExams extends OfflineExams {
  final Future<bool> Function(int id)? onSync;

  _FakeOfflineExams({this.onSync});

  @override
  Stream<List<OfflineExamDownloadsTableData>> build() async* {
    yield [];
  }

  @override
  Future<bool> syncExam(int id) async {
    if (onSync != null) {
      return onSync!(id);
    }
    return true;
  }
}

void main() {
  final examData = ExamDto(
    id: '1',
    title: 'Sample Offline Exam',
    duration: '01:00:00',
    questionCount: 10,
    attemptsUrl: 'https://example.com/attempts',
  );

  Widget buildWidget({
    required VoidCallback onStartOffline,
    OfflineExamDownloadsTableData? download,
    OfflineExams Function()? offlineExamsBuilder,
  }) {
    return ProviderScope(
      overrides: [
        offlineExamDownloadProvider(
          'test_content_id',
        ).overrideWith((ref) => Stream.value(download)),
        if (offlineExamsBuilder != null)
          offlineExamsProvider.overrideWith(offlineExamsBuilder),
      ],
      child: WidgetsApp(
        color: const Color(0xFF000000),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, _) => Directionality(
          textDirection: TextDirection.ltr,
          child: DesignProvider(
            config: DesignConfig.light(),
            child: Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) => OfflineExamActionButton(
                    examId: 'test_content_id',
                    examData: examData,
                    attemptsUrl: 'https://example.com/attempts',
                    onStartOfflineAttempt: onStartOffline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  testWidgets(
    'Renders nothing (SizedBox.shrink) when download status is SYNCED',
    (WidgetTester tester) async {
      final syncedData = OfflineExamDownloadsTableData(
        id: 1,
        contentId: 'test_content_id',
        examId: '1',
        title: 'Sample Offline Exam',
        duration: '01:00:00',
        questionCount: 10,
        status: 'SYNCED',
        downloadedAt: DateTime.now(),
        questionsJson: '[]',
        elapsedSeconds: 0,
      );

      await tester.pumpWidget(
        buildWidget(onStartOffline: () {}, download: syncedData),
      );
      await tester.pumpAndSettle();

      expect(find.text('Start offline exam'), findsNothing);
      expect(find.text('Resume offline exam'), findsNothing);
      expect(find.text('Download Exam (Offline)'), findsNothing);
    },
  );

  testWidgets('Renders Sync button when download status is PENDING_SYNC', (
    WidgetTester tester,
  ) async {
    final pendingData = OfflineExamDownloadsTableData(
      id: 1,
      contentId: 'test_content_id',
      examId: '1',
      title: 'Sample Offline Exam',
      duration: '01:00:00',
      questionCount: 10,
      status: 'PENDING_SYNC',
      downloadedAt: DateTime.now(),
      questionsJson: '[]',
      elapsedSeconds: 100,
    );

    await tester.pumpWidget(
      buildWidget(onStartOffline: () {}, download: pendingData),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sync'), findsOneWidget);
    expect(find.text('Start offline exam'), findsNothing);
    expect(find.text('Resume offline exam'), findsNothing);
    expect(find.text('Download Exam (Offline)'), findsNothing);
  });

  testWidgets('Renders loading indicator when download status is SYNCING', (
    WidgetTester tester,
  ) async {
    final syncingData = OfflineExamDownloadsTableData(
      id: 1,
      contentId: 'test_content_id',
      examId: '1',
      title: 'Sample Offline Exam',
      duration: '01:00:00',
      questionCount: 10,
      status: 'SYNCING',
      downloadedAt: DateTime.now(),
      questionsJson: '[]',
      elapsedSeconds: 100,
    );

    await tester.pumpWidget(
      buildWidget(onStartOffline: () {}, download: syncingData),
    );
    await tester.pump();

    expect(find.byType(AppLoadingIndicator), findsOneWidget);
    final button = tester.widget<AppButton>(find.byType(AppButton));
    expect(button.loading, isTrue);
    expect(button.onPressed, isNull);
    expect(find.text('Start offline exam'), findsNothing);
    expect(find.text('Resume offline exam'), findsNothing);
    expect(find.text('Download Exam (Offline)'), findsNothing);
  });

  testWidgets(
    'Tap path: triggers sync and shows success toast on successful sync',
    (WidgetTester tester) async {
      int? syncedId;
      final pendingData = OfflineExamDownloadsTableData(
        id: 42,
        contentId: 'test_content_id',
        examId: '1',
        title: 'Sample Offline Exam',
        duration: '01:00:00',
        questionCount: 10,
        status: 'PENDING_SYNC',
        downloadedAt: DateTime.now(),
        questionsJson: '[]',
        elapsedSeconds: 100,
      );

      await tester.pumpWidget(
        buildWidget(
          onStartOffline: () {},
          download: pendingData,
          offlineExamsBuilder: () => _FakeOfflineExams(
            onSync: (id) async {
              syncedId = id;
              return true;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sync'), findsOneWidget);
      await tester.tap(find.text('Sync'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(syncedId, equals(42));
      expect(find.text('Exam synced successfully.'), findsOneWidget);

      await tester.pump(const Duration(seconds: 4));
    },
  );

  testWidgets(
    'Tap path: shows failure toast and resets loading state when sync returns false',
    (WidgetTester tester) async {
      final pendingData = OfflineExamDownloadsTableData(
        id: 42,
        contentId: 'test_content_id',
        examId: '1',
        title: 'Sample Offline Exam',
        duration: '01:00:00',
        questionCount: 10,
        status: 'PENDING_SYNC',
        downloadedAt: DateTime.now(),
        questionsJson: '[]',
        elapsedSeconds: 100,
      );

      await tester.pumpWidget(
        buildWidget(
          onStartOffline: () {},
          download: pendingData,
          offlineExamsBuilder: () =>
              _FakeOfflineExams(onSync: (id) async => false),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sync'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(
        find.text(
          'Failed to sync exam. Please check your internet connection.',
        ),
        findsOneWidget,
      );

      final button = tester.widget<AppButton>(find.byType(AppButton));
      expect(button.loading, isFalse);
      expect(button.onPressed, isNotNull);

      await tester.pump(const Duration(seconds: 4));
    },
  );

  testWidgets(
    'Tap path: shows failure toast and resets loading state on exception',
    (WidgetTester tester) async {
      final pendingData = OfflineExamDownloadsTableData(
        id: 42,
        contentId: 'test_content_id',
        examId: '1',
        title: 'Sample Offline Exam',
        duration: '01:00:00',
        questionCount: 10,
        status: 'PENDING_SYNC',
        downloadedAt: DateTime.now(),
        questionsJson: '[]',
        elapsedSeconds: 100,
      );

      await tester.pumpWidget(
        buildWidget(
          onStartOffline: () {},
          download: pendingData,
          offlineExamsBuilder: () => _FakeOfflineExams(
            onSync: (id) async => throw Exception('Unexpected sync crash'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sync'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(
        find.text(
          'Failed to sync exam. Please check your internet connection.',
        ),
        findsOneWidget,
      );

      final button = tester.widget<AppButton>(find.byType(AppButton));
      expect(button.loading, isFalse);
      expect(button.onPressed, isNotNull);

      await tester.pump(const Duration(seconds: 4));
    },
  );

  testWidgets(
    'Renders Start offline exam button when download status is DOWNLOADED',
    (WidgetTester tester) async {
      final downloadedData = OfflineExamDownloadsTableData(
        id: 1,
        contentId: 'test_content_id',
        examId: '1',
        title: 'Sample Offline Exam',
        duration: '01:00:00',
        questionCount: 10,
        status: 'DOWNLOADED',
        downloadedAt: DateTime.now(),
        questionsJson: '[]',
        elapsedSeconds: 0,
      );

      await tester.pumpWidget(
        buildWidget(onStartOffline: () {}, download: downloadedData),
      );
      await tester.pumpAndSettle();

      expect(find.text('Start offline exam'), findsOneWidget);
    },
  );

  testWidgets(
    'Renders Resume offline exam button when download status is IN_PROGRESS',
    (WidgetTester tester) async {
      final inProgressData = OfflineExamDownloadsTableData(
        id: 1,
        contentId: 'test_content_id',
        examId: '1',
        title: 'Sample Offline Exam',
        duration: '01:00:00',
        questionCount: 10,
        status: 'IN_PROGRESS',
        downloadedAt: DateTime.now(),
        questionsJson: '[]',
        elapsedSeconds: 100,
      );

      await tester.pumpWidget(
        buildWidget(onStartOffline: () {}, download: inProgressData),
      );
      await tester.pumpAndSettle();

      expect(find.text('Resume offline exam'), findsOneWidget);
    },
  );

  testWidgets('Renders Download button when no download exists', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildWidget(onStartOffline: () {}, download: null));
    await tester.pumpAndSettle();

    expect(find.text('Download Exam (Offline)'), findsOneWidget);
  });
}
