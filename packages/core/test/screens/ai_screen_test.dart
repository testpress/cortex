import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';

void main() {
  Widget buildSubject({List<AiChatMessageItem> initialMessages = const []}) {
    return DesignProvider(
      config: DesignConfig.defaults(),
      child: WidgetsApp(
        color: const Color(0xFF000000),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, _, _) => builder(context),
        ),
        home: AiScreen(initialMessages: initialMessages),
      ),
    );
  }

  testWidgets('renders header with Back navigation and Menu icon', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('Back'), findsOneWidget);
    expect(find.byIcon(LucideIcons.arrowLeft), findsOneWidget);
    expect(find.byIcon(LucideIcons.menu), findsOneWidget);
  });

  testWidgets('renders empty canvas with pinned bottom composer initially', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.byType(AiComposer), findsOneWidget);
    expect(find.text('Ask AI support'), findsOneWidget);
  });

  testWidgets('renders user message bubble with timestamp', (tester) async {
    final fixedTime = DateTime(2026, 10, 13, 14, 36);
    await tester.pumpWidget(
      buildSubject(
        initialMessages: [
          AiChatMessageItem(
            id: '1',
            text: 'Show me similar practice questions',
            isUser: true,
            timestamp: fixedTime,
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Show me similar practice questions'), findsOneWidget);
    expect(find.text('14:36'), findsOneWidget);
    expect(find.text("Couldn't send message. "), findsNothing);
  });

  testWidgets(
    'renders send error indicator with retry when hasSendError is true',
    (tester) async {
      final fixedTime = DateTime(2026, 10, 13, 14, 36);
      await tester.pumpWidget(
        buildSubject(
          initialMessages: [
            AiChatMessageItem(
              id: '2',
              text: 'Explain the relevant formula or principle.',
              isUser: true,
              timestamp: fixedTime,
              hasSendError: true,
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Explain the relevant formula or principle.'),
        findsOneWidget,
      );
      expect(find.text("Couldn't send message. "), findsOneWidget);
      expect(find.text('Tap to retry'), findsOneWidget);
      expect(find.byIcon(LucideIcons.alertCircle), findsOneWidget);

      final retryFinder = find.ancestor(
        of: find.text('Tap to retry'),
        matching: find.byType(GestureDetector),
      );
      expect(retryFinder, findsOneWidget);
      final retrySize = tester.getSize(retryFinder);
      expect(retrySize.width, greaterThanOrEqualTo(48.0));
      expect(retrySize.height, greaterThanOrEqualTo(48.0));
    },
  );

  testWidgets(
    'renders assistant response card with Markdown and action controls',
    (tester) async {
      final fixedTime = DateTime(2026, 10, 13, 14, 36);
      await tester.pumpWidget(
        buildSubject(
          initialMessages: [
            AiChatMessageItem(
              id: '3',
              text: 'Let me explain **Step 1** in detail.',
              isUser: false,
              timestamp: fixedTime,
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppMarkdown), findsOneWidget);
      expect(find.byIcon(LucideIcons.copy), findsOneWidget);
      expect(find.byIcon(LucideIcons.moreHorizontal), findsNothing);
      expect(find.text('14:36'), findsOneWidget);

      final cardButtons = find.descendant(
        of: find.byType(AiAssistantCard),
        matching: find.byType(AppIconButton),
      );
      expect(cardButtons, findsNWidgets(1));
      for (final button in tester.widgetList(cardButtons)) {
        final buttonFinder = find.byWidget(button);
        final size = tester.getSize(buttonFinder);
        expect(size.width, greaterThanOrEqualTo(48.0));
        expect(size.height, greaterThanOrEqualTo(48.0));
      }
    },
  );

  testWidgets('renders generation failure state with Try again action', (
    tester,
  ) async {
    final fixedTime = DateTime(2026, 10, 13, 14, 36);
    await tester.pumpWidget(
      buildSubject(
        initialMessages: [
          AiChatMessageItem(
            id: '4',
            text: '',
            isUser: false,
            timestamp: fixedTime,
            hasGenerationError: true,
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('AI Assistant'), findsOneWidget);
    expect(
      find.text("Couldn't generate a response. Please try again."),
      findsOneWidget,
    );
    expect(find.text('Try again'), findsOneWidget);
    expect(find.byIcon(LucideIcons.refreshCw), findsOneWidget);

    final errorTextPos = tester.getTopLeft(
      find.text("Couldn't generate a response. Please try again."),
    );
    final tryAgainFinder = find.ancestor(
      of: find.text('Try again'),
      matching: find.byType(GestureDetector),
    );
    expect(tryAgainFinder, findsOneWidget);
    final tryAgainPos = tester.getTopLeft(tryAgainFinder);
    expect(tryAgainPos.dy, greaterThan(errorTextPos.dy));

    final tryAgainSize = tester.getSize(tryAgainFinder);
    expect(tryAgainSize.width, greaterThanOrEqualTo(48.0));
    expect(tryAgainSize.height, greaterThanOrEqualTo(48.0));
  });

  testWidgets('sending message dynamically triggers mock AI response', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    final editable = find.byType(EditableText);
    await tester.enterText(editable, 'What is Newton second law?');
    await tester.pump();

    // Tap send button
    await tester.tap(find.byIcon(LucideIcons.arrowUp));
    await tester.pump();

    // User message is visible immediately in sending state
    expect(find.text('What is Newton second law?'), findsOneWidget);
    expect(find.text('Sending...'), findsOneWidget);

    // Fast-forward delay to receive mock AI response
    await tester.pump(const Duration(milliseconds: 1300));
    await tester.pumpAndSettle();

    // In-flight Sending... transitions to delivered and AI response is rendered
    expect(find.text('Sending...'), findsNothing);
    expect(find.byType(AppMarkdown), findsOneWidget);
    expect(find.byIcon(LucideIcons.copy), findsOneWidget);
  });

  testWidgets(
    'sending send error trigger shows retry action and retrying delivers message',
    (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      final editable = find.byType(EditableText);
      await tester.enterText(editable, 'send error');
      await tester.pump();

      await tester.tap(find.byIcon(LucideIcons.arrowUp));
      await tester.pump();

      expect(find.text("Couldn't send message. "), findsOneWidget);
      expect(find.text('Tap to retry'), findsOneWidget);

      // Tap retry
      await tester.tap(find.text('Tap to retry'));
      await tester.pump();

      // Error cleared and message being processed
      expect(find.text("Couldn't send message. "), findsNothing);

      await tester.pump(const Duration(milliseconds: 1300));
      await tester.pumpAndSettle();

      expect(find.byType(AppMarkdown), findsOneWidget);
    },
  );

  testWidgets(
    'retrying generation error recovers preceding user prompt and generates response',
    (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      final editable = find.byType(EditableText);
      await tester.enterText(editable, 'fail');
      await tester.pump();

      await tester.tap(find.byIcon(LucideIcons.arrowUp));
      await tester.pump();

      await tester.pump(const Duration(milliseconds: 1300));
      await tester.pumpAndSettle();

      expect(
        find.text("Couldn't generate a response. Please try again."),
        findsOneWidget,
      );
      expect(find.text('Try again'), findsOneWidget);

      await tester.tap(find.text('Try again'));
      await tester.pump();

      await tester.pump(const Duration(milliseconds: 1300));
      await tester.pumpAndSettle();

      expect(
        find.text("Couldn't generate a response. Please try again."),
        findsNothing,
      );
      expect(find.byType(AppMarkdown), findsOneWidget);
      expect(
        find.textContaining('I understand your question about "fail"'),
        findsOneWidget,
      );
    },
  );

  testWidgets('retry is ignored while another generation is in flight', (
    tester,
  ) async {
    final fixedTime = DateTime(2026, 10, 13, 14, 36);
    await tester.pumpWidget(
      buildSubject(
        initialMessages: [
          AiChatMessageItem(
            id: '1',
            text: 'First question',
            isUser: true,
            timestamp: fixedTime,
          ),
          AiChatMessageItem(
            id: '2',
            text: '',
            isUser: false,
            timestamp: fixedTime,
            hasGenerationError: true,
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    final editable = find.byType(EditableText);
    await tester.enterText(editable, 'Second question');
    await tester.pump();
    await tester.tap(find.byIcon(LucideIcons.arrowUp));
    await tester.pump();

    expect(find.text('Sending...'), findsOneWidget);

    // Tap retry on the existing error card while generation is in-flight
    await tester.tap(find.text('Try again'));
    await tester.pump();

    // Fast-forward second message completion
    await tester.pump(const Duration(milliseconds: 1300));
    await tester.pumpAndSettle();

    // First message error card was NOT retried concurrently
    expect(
      find.text("Couldn't generate a response. Please try again."),
      findsOneWidget,
    );
    expect(
      find.textContaining('I understand your question about "Second question"'),
      findsOneWidget,
    );
  });

  testWidgets('invokes custom onBack and onOpenHistory navigation callbacks', (
    tester,
  ) async {
    var backCalled = false;
    var historyCalled = false;

    await tester.pumpWidget(
      DesignProvider(
        config: DesignConfig.defaults(),
        child: WidgetsApp(
          color: const Color(0xFF000000),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
            settings: settings,
            pageBuilder: (context, _, _) => builder(context),
          ),
          home: AiScreen(
            onBack: () => backCalled = true,
            onOpenHistory: () => historyCalled = true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Back'));
    await tester.pump();
    expect(backCalled, isTrue);

    await tester.tap(find.byIcon(LucideIcons.menu));
    await tester.pump();
    expect(historyCalled, isTrue);
  });

  testWidgets('assistant card places copy button and timestamp inline in a row', (
    tester,
  ) async {
    final fixedTime = DateTime(2026, 10, 13, 14, 36);
    await tester.pumpWidget(
      buildSubject(
        initialMessages: [
          AiChatMessageItem(
            id: '5',
            text: 'Here is the response content.',
            isUser: false,
            timestamp: fixedTime,
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    final copyPos = tester.getTopLeft(find.byIcon(LucideIcons.copy));
    final timestampPos = tester.getTopLeft(find.text('14:36'));
    // Vertically aligned within the footer row (within touch target bounds)
    expect((copyPos.dy - timestampPos.dy).abs(), lessThan(30.0));
    // Timestamp sits horizontally to the right of the copy/more action controls
    expect(timestampPos.dx, greaterThan(copyPos.dx));
  });

  testWidgets('constrains chat column on wide tablet viewport', (tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      buildSubject(
        initialMessages: [
          AiChatMessageItem(
            id: '6',
            text: 'Test message for wide viewport.',
            isUser: true,
            timestamp: DateTime(2026, 10, 13, 14, 36),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    final listViewFinder = find.byType(ListView);
    expect(listViewFinder, findsOneWidget);
    final listSize = tester.getSize(listViewFinder);
    expect(listSize.width, lessThanOrEqualTo(768.0));
  });

  testWidgets(
    'wraps message list in AppSemantics.scrollableList with item count',
    (tester) async {
      final fixedTime = DateTime(2026, 10, 13, 14, 36);
      await tester.pumpWidget(
        buildSubject(
          initialMessages: [
            AiChatMessageItem(
              id: '1',
              text: 'Hello',
              isUser: true,
              timestamp: fixedTime,
            ),
            AiChatMessageItem(
              id: '2',
              text: 'World',
              isUser: false,
              timestamp: fixedTime,
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('AI Chat, 2 items'), findsOneWidget);
    },
  );
}
