import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:exams/providers/exam_providers.dart';
import 'package:exams/widgets/offline_exam_action_button.dart';

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
  }) {
    return ProviderScope(
      overrides: [
        offlineExamDownloadProvider(
          'test_content_id',
        ).overrideWith((ref) => Stream.value(download)),
      ],
      child: WidgetsApp(
        color: const Color(0xFF000000),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, _) => Directionality(
          textDirection: TextDirection.ltr,
          child: DesignProvider(
            config: DesignConfig.light(),
            child: OfflineExamActionButton(
              examId: 'test_content_id',
              examData: examData,
              attemptsUrl: 'https://example.com/attempts',
              onStartOfflineAttempt: onStartOffline,
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

  testWidgets(
    'Renders nothing (SizedBox.shrink) when download status is PENDING_SYNC',
    (WidgetTester tester) async {
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

      expect(find.text('Start offline exam'), findsNothing);
      expect(find.text('Resume offline exam'), findsNothing);
      expect(find.text('Download Exam (Offline)'), findsNothing);
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
