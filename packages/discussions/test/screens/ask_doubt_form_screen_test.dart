import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:discussions/screens/ask_doubt_form_screen.dart';
import 'package:discussions/widgets/forum_composer.dart';

class _FakeDoubtRepository implements DoubtRepository {
  DoubtQueryType? lastCreatedQueryType;

  @override
  Future<String> createDoubt({
    required String title,
    required String description,
    int? topicId,
    int? chapterContentId,
    int? questionId,
    DoubtQueryType? queryType,
  }) async {
    lastCreatedQueryType = queryType;
    return 'doubt_1';
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late _FakeDoubtRepository fakeRepo;

  setUp(() {
    fakeRepo = _FakeDoubtRepository();
  });

  tearDown(() {
    AppConfig.enableAiDoubtOverride = null;
  });

  Widget buildScreen() {
    return ProviderScope(
      overrides: [
        doubtRepositoryProvider.overrideWith((ref) async => fakeRepo),
        doubtSubtopicsProvider(null).overrideWith(
          (ref) => Stream.value([
            const DoubtTopicDto(id: 1, title: 'General', hasChildren: false),
          ]),
        ),
      ],
      child: DesignProvider(
        config: DesignConfig.defaults(),
        child: LocalizationProvider(
          child: MaterialApp(
            locale: const Locale('en'),
            localizationsDelegates: LocalizationProvider.delegates,
            home: Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AskDoubtFormScreen(),
                      ),
                    ),
                    child: const Text('Open Form'),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  group('AskDoubtFormScreen submission routing', () {
    testWidgets('opens submit options sheet when enableAiDoubt is true', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      AppConfig.enableAiDoubtOverride = true;

      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      // Open screen
      await tester.tap(find.text('Open Form'));
      await tester.pumpAndSettle();

      // Enter title
      await tester.enterText(find.byType(AppTextField), 'Sample Doubt Title');
      await tester.pumpAndSettle();

      // Enter quill description
      final editorField = tester.widget<ForumEditorField>(
        find.byType(ForumEditorField),
      );
      editorField.controller.document.insert(0, 'Detailed question text');
      await tester.pumpAndSettle();

      // Select topic
      final topicChip = find.text('General');
      expect(topicChip, findsOneWidget);
      await tester.tap(topicChip);
      await tester.pumpAndSettle();

      // Tap Next button
      final nextButton = find.widgetWithText(AppButton, 'Next');
      expect(nextButton, findsOneWidget);
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      // When enableAiDoubt is true, sheet should open with AI and Mentor options
      expect(find.text('How would you like to ask?'), findsOneWidget);
      expect(find.text('Ask AI'), findsOneWidget);
      expect(find.text('Ask Mentor'), findsOneWidget);
    });

    testWidgets('submits directly to mentor when enableAiDoubt is false', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      AppConfig.enableAiDoubtOverride = false;

      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      // Open screen
      await tester.tap(find.text('Open Form'));
      await tester.pumpAndSettle();

      // Enter title
      await tester.enterText(find.byType(AppTextField), 'Direct Mentor Doubt');
      await tester.pumpAndSettle();

      // Enter quill description
      final editorField = tester.widget<ForumEditorField>(
        find.byType(ForumEditorField),
      );
      editorField.controller.document.insert(0, 'Detailed question text');
      await tester.pumpAndSettle();

      // Select topic
      final topicChip = find.text('General');
      expect(topicChip, findsOneWidget);
      await tester.tap(topicChip);
      await tester.pumpAndSettle();

      // Tap Next button
      final nextButton = find.widgetWithText(AppButton, 'Next');
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      // Options sheet should NOT be shown
      expect(find.text('How would you like to ask?'), findsNothing);
      expect(find.text('Ask AI'), findsNothing);

      // Verify direct submission to mentor
      expect(fakeRepo.lastCreatedQueryType, DoubtQueryType.mentor);

      // Flush toast timer
      await tester.pump(const Duration(seconds: 3));
    });
  });
}
