import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';

import 'package:core/data/repositories/learnlens_repository.dart';

class _TestLearnLensRepository implements LearnLensRepository {
  Future<AiChatTurnResponseDto> Function(String requestId, String query)?
  onStartConversation;
  Future<AiChatTurnResponseDto> Function(
    String chatId,
    String requestId,
    String query,
  )?
  onSendFollowUp;

  bool shouldFailSend = true;

  /// When set, scripts the events of streamed submissions.
  Stream<AiChatStreamEvent> Function(
    String requestId,
    String query,
    String? chatId,
  )?
  streamFactory;

  @override
  AiChatPolicyDto? get policy =>
      const AiChatPolicyDto(maxMessageCharacters: 4000);

  @override
  Stream<AiChatStreamEvent> streamConversation({
    required String requestId,
    required String query,
    CancelToken? cancelToken,
  }) {
    if (streamFactory != null) return streamFactory!(requestId, query, null);
    return _synthesizeStream(
      () => startConversation(requestId: requestId, query: query),
    );
  }

  @override
  Stream<AiChatStreamEvent> streamFollowUpMessage({
    required String chatId,
    required String requestId,
    required String query,
    CancelToken? cancelToken,
  }) {
    if (streamFactory != null) return streamFactory!(requestId, query, chatId);
    return _synthesizeStream(
      () => sendFollowUpMessage(
        chatId: chatId,
        requestId: requestId,
        query: query,
      ),
    );
  }

  Stream<AiChatStreamEvent> _synthesizeStream(
    Future<AiChatTurnResponseDto> Function() call,
  ) async* {
    final turn = await call();
    final gen = turn.generation;
    yield AiChatStreamEvent.accepted(
      AiChatTurnResponseDto(
        answer: null,
        chatId: turn.chatId,
        title: turn.title,
        generation: AiGenerationDto(
          generationId: gen.generationId,
          requestId: gen.requestId,
          userMessageId: gen.userMessageId,
          status: 'processing',
          createdAt: gen.createdAt,
        ),
      ),
    );
    yield AiChatStreamEvent.done(turn);
  }

  bool failEnsureSession = false;

  @override
  Future<void> ensureGenericChatSession() async {
    if (failEnsureSession) {
      throw Exception('Session init failure');
    }
  }

  @override
  Future<AiChatTurnResponseDto> startConversation({
    required String requestId,
    required String query,
    CancelToken? cancelToken,
  }) async {
    if (onStartConversation != null) {
      return onStartConversation!(requestId, query);
    }

    await Future<void>.delayed(const Duration(milliseconds: 50));

    if (query == 'send error' && shouldFailSend) {
      shouldFailSend = false;
      throw const LearnLensException(
        message: "Couldn't send message. Tap to retry",
        code: 'network_error',
      );
    }
    if (query == 'fail') {
      return AiChatTurnResponseDto(
        chatId: 'chat-fail',
        title: 'fail',
        answer: null,
        generation: AiGenerationDto(
          generationId: 'gen-fail',
          requestId: requestId,
          userMessageId: 'usr-fail',
          status: 'failed',
          errorMessage: "Couldn't generate a response. Please try again.",
          createdAt: DateTime.now().toUtc(),
        ),
      );
    }
    return AiChatTurnResponseDto(
      chatId: 'chat-1',
      title: query,
      answer: 'I understand your question about "$query"',
      generation: AiGenerationDto(
        generationId: 'gen-1',
        requestId: requestId,
        userMessageId: 'usr-1',
        status: 'completed',
        createdAt: DateTime.now().toUtc(),
      ),
    );
  }

  @override
  Future<AiChatTurnResponseDto> sendFollowUpMessage({
    required String chatId,
    required String requestId,
    required String query,
    CancelToken? cancelToken,
  }) async {
    if (onSendFollowUp != null) {
      return onSendFollowUp!(chatId, requestId, query);
    }
    return AiChatTurnResponseDto(
      chatId: chatId,
      title: 'Follow-up',
      answer: 'I understand your question about "$query"',
      generation: AiGenerationDto(
        generationId: 'gen-2',
        requestId: requestId,
        userMessageId: 'usr-2',
        status: 'completed',
        createdAt: DateTime.now().toUtc(),
      ),
    );
  }

  @override
  Future<AiConversationDto> getConversationStatus({
    required String chatId,
    CancelToken? cancelToken,
  }) async {
    return AiConversationDto(
      chatId: chatId,
      title: 'Status',
      generation: AiGenerationDto(
        generationId: 'gen-s',
        requestId: 'req-s',
        userMessageId: 'usr-s',
        status: 'completed',
        createdAt: DateTime.now().toUtc(),
      ),
    );
  }

  bool failGetMessages = false;
  Object? getMessagesError;

  @override
  Future<AiMessagePageResult> getMessages({
    required String chatId,
    int limit = 20,
    String? before,
    CancelToken? cancelToken,
  }) async {
    if (failGetMessages) {
      throw getMessagesError ?? Exception('Failed to load messages');
    }
    return const AiMessagePageResult(items: []);
  }

  @override
  Future<AiConversationListDto> listConversations({
    int limit = 20,
    String? cursor,
  }) async {
    return const AiConversationListDto(items: []);
  }

  @override
  void validateMessage(String query) {}

  @override
  List<AiMessageDto> prependMessages({
    required List<AiMessageDto> olderMessages,
    required List<AiMessageDto> currentMessages,
  }) {
    return [...olderMessages, ...currentMessages];
  }

  @override
  Future<Map<String, dynamic>> createSession(int contentId) async => {};

  @override
  Future<LearnLensQuizResponseDto> fetchQuiz({
    required String orgUuid,
    required String assetId,
    String? sessionToken,
    int? contentId,
    String difficulty = 'medium',
    int questionCount = 5,
  }) async {
    return LearnLensQuizResponseDto(questions: []);
  }

  @override
  Future<LearnLensChatResponseDto> submitChat({
    required String orgUuid,
    required String assetId,
    String? sessionToken,
    int? contentId,
    required String query,
    required String conversationId,
  }) async {
    return LearnLensChatResponseDto(answer: '', conversationId: '');
  }
}

void main() {
  Widget buildSubject({
    List<AiChatMessageItem> initialMessages = const [],
    List<Override> overrides = const [],
    _TestLearnLensRepository? repository,
    VoidCallback? onBack,
    VoidCallback? onOpenHistory,
  }) {
    final testRepo = repository ?? _TestLearnLensRepository();
    return ProviderScope(
      overrides: [
        learnLensRepositoryProvider.overrideWithValue(testRepo),
        ...overrides,
      ],
      child: DesignProvider(
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
            initialMessages: initialMessages,
            onBack: onBack,
            onOpenHistory: onOpenHistory,
          ),
        ),
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
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

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
      buildSubject(
        onBack: () => backCalled = true,
        onOpenHistory: () => historyCalled = true,
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

  testWidgets('tapping menu button calls onOpenHistory callback', (
    tester,
  ) async {
    bool openedHistory = false;
    await tester.pumpWidget(
      buildSubject(
        onOpenHistory: () {
          openedHistory = true;
        },
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(LucideIcons.menu));
    await tester.pumpAndSettle();

    expect(openedHistory, isTrue);
  });

  testWidgets(
    'renders warning banner with retry when session initialization fails',
    (tester) async {
      final failingRepo = _TestLearnLensRepository()..failEnsureSession = true;
      await tester.pumpWidget(buildSubject(repository: failingRepo));
      await tester.pumpAndSettle();

      expect(
        find.text('Unable to connect to AI assistant. Check your connection.'),
        findsOneWidget,
      );
      expect(find.text('Retry'), findsOneWidget);

      // Tapping retry re-attempts initialization
      failingRepo.failEnsureSession = false;
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      expect(
        find.text('Unable to connect to AI assistant. Check your connection.'),
        findsNothing,
      );
    },
  );

  testWidgets('renders error view with retry when message loading fails', (
    tester,
  ) async {
    final repo = _TestLearnLensRepository()..failGetMessages = true;
    await tester.pumpWidget(buildSubject(repository: repo));
    await tester.pumpAndSettle();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(AiScreen)),
    );

    // Trigger selecting a conversation which will fail
    await container
        .read(genericAiChatProvider.notifier)
        .selectConversation('chat-err');
    await tester.pumpAndSettle();

    expect(find.byType(AppErrorView), findsOneWidget);

    // Now recover and tap retry
    repo.failGetMessages = false;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.byType(AppErrorView), findsNothing);
  });

  testWidgets(
    'renders specific rate limit error view when message loading is throttled (429)',
    (tester) async {
      final repo = _TestLearnLensRepository()
        ..failGetMessages = true
        ..getMessagesError = const LearnLensException(
          message: 'Request was throttled. Expected available in 3 seconds.',
          statusCode: 429,
          type: ApiErrorType.rateLimited,
        );
      await tester.pumpWidget(buildSubject(repository: repo));
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(AiScreen)),
      );

      await container
          .read(genericAiChatProvider.notifier)
          .selectConversation('chat-429');
      await tester.pumpAndSettle();

      expect(find.byType(AppErrorView), findsOneWidget);
      expect(find.text('Too Many Requests'), findsOneWidget);
      expect(
        find.text('Request was throttled. Expected available in 3 seconds.'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'does not render Session Expired when message loading fails with 401',
    (tester) async {
      final repo = _TestLearnLensRepository()
        ..failGetMessages = true
        ..getMessagesError = const LearnLensException(
          message: 'Unable to connect to AI assistant. Please try again.',
          statusCode: 401,
          type: ApiErrorType.serverError,
        );
      await tester.pumpWidget(buildSubject(repository: repo));
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(AiScreen)),
      );

      await container
          .read(genericAiChatProvider.notifier)
          .selectConversation('chat-401');
      await tester.pumpAndSettle();

      expect(find.byType(AppErrorView), findsOneWidget);
      expect(find.text('Session Expired'), findsNothing);
      expect(
        find.text('Unable to connect to AI assistant. Please try again.'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'assigns distinct ValueKey to ListView for each conversation to isolate scroll state',
    (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(AiScreen)),
      );

      // Seed message in new chat
      container.read(genericAiChatProvider.notifier).setInitialMessages([
        GenericAiChatMessage(
          id: 'msg-1',
          text: 'Hello world',
          isUser: true,
          timestamp: DateTime.now(),
        ),
      ]);
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('new_chat')), findsOneWidget);

      // Switch to a conversation thread
      await container
          .read(genericAiChatProvider.notifier)
          .selectConversation('chat-thread-1');
      await tester.pumpAndSettle();

      // Key should now reflect chat-thread-1
      expect(
        find.byKey(const ValueKey('chat-thread-1')),
        findsNothing, // because it's empty so SizedBox.expand() is shown
      );

      // Seed messages in thread
      container.read(genericAiChatProvider.notifier).setInitialMessages([
        GenericAiChatMessage(
          id: 'msg-2',
          text: 'Thread message',
          isUser: true,
          timestamp: DateTime.now(),
        ),
      ]);
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('chat-thread-1')), findsOneWidget);
    },
  );

  testWidgets(
    'composer retains focus and preserves EditableTextState across first char and clearing',
    (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      final editable = find.byType(EditableText);
      expect(editable, findsOneWidget);

      await tester.tap(editable);
      await tester.pump();

      final stateBefore = tester.state(editable);

      // Enter first letter (isEmpty: true -> false)
      await tester.enterText(editable, 'a');
      await tester.pump();
      expect(tester.state(editable), same(stateBefore));

      // Clear letter (isEmpty: false -> true)
      await tester.enterText(editable, '');
      await tester.pump();
      expect(tester.state(editable), same(stateBefore));
    },
  );

  testWidgets(
    'streams assistant answer progressively with a generating indicator and final replacement',
    (tester) async {
      final controller = StreamController<AiChatStreamEvent>();
      String? requestId;
      final repo = _TestLearnLensRepository()
        ..streamFactory = (id, query, chatId) {
          requestId = id;
          return controller.stream;
        };

      await tester.pumpWidget(buildSubject(repository: repo));
      await tester.pumpAndSettle();

      final editable = find.byKey(const ValueKey('ai_composer_editable_text'));
      await tester.enterText(editable, 'Explain gravity');
      await tester.pump();
      await tester.tap(find.byIcon(LucideIcons.arrowUp));
      await tester.pump();

      // The user's message is visible immediately while the stream opens.
      expect(find.text('Explain gravity'), findsOneWidget);
      expect(find.text('Sending...'), findsOneWidget);
      expect(find.byType(AiAssistantCard), findsNothing);

      AiGenerationDto generation(String status, {String? assistantId}) {
        return AiGenerationDto(
          generationId: 'gen-ui',
          requestId: requestId!,
          userMessageId: 'usr-ui',
          assistantMessageId: assistantId,
          status: status,
          createdAt: DateTime.now().toUtc(),
        );
      }

      controller.add(
        AiChatStreamEvent.accepted(
          AiChatTurnResponseDto(
            chatId: 'chat-ui',
            title: 'Gravity',
            generation: generation('processing'),
          ),
        ),
      );
      await tester.pump();

      // Provisional assistant card shows the generating indicator.
      expect(find.text('Sending...'), findsNothing);
      expect(find.byType(AiAssistantCard), findsOneWidget);
      expect(find.text('Generating response...'), findsOneWidget);
      expect(find.byType(AppMarkdown), findsNothing);
      expect(find.byIcon(LucideIcons.copy), findsNothing);

      controller.add(const AiChatStreamEvent.delta('Gravity pulls '));
      await tester.pump();
      expect(find.byType(AppMarkdown), findsOneWidget);
      expect(find.textContaining('Gravity pulls'), findsOneWidget);
      // Still generating: no copy action yet.
      expect(find.byIcon(LucideIcons.copy), findsNothing);

      controller.add(const AiChatStreamEvent.delta('objects together.'));
      await tester.pump();
      expect(
        find.textContaining('Gravity pulls objects together.'),
        findsOneWidget,
      );

      controller.add(
        AiChatStreamEvent.done(
          AiChatTurnResponseDto(
            chatId: 'chat-ui',
            title: 'Gravity',
            answer: 'Gravity pulls objects together.',
            generation: generation('completed', assistantId: 'ast-ui'),
          ),
        ),
      );
      await controller.close();
      await tester.pumpAndSettle();

      // Authoritative answer shown once, generating indicator gone, actions back.
      expect(find.byType(AiAssistantCard), findsOneWidget);
      expect(
        find.textContaining('Gravity pulls objects together.'),
        findsOneWidget,
      );
      expect(find.text('Generating response...'), findsNothing);
      expect(find.byIcon(LucideIcons.copy), findsOneWidget);

      // Composer is unlocked again.
      final composer = tester.widget<AiComposer>(find.byType(AiComposer));
      expect(composer.enabled, isTrue);
    },
  );

  testWidgets(
    'streamed generation failure shows the failure card and unlocks the composer',
    (tester) async {
      final controller = StreamController<AiChatStreamEvent>();
      String? requestId;
      final repo = _TestLearnLensRepository()
        ..streamFactory = (id, query, chatId) {
          requestId = id;
          return controller.stream;
        };

      await tester.pumpWidget(buildSubject(repository: repo));
      await tester.pumpAndSettle();

      final editable = find.byKey(const ValueKey('ai_composer_editable_text'));
      await tester.enterText(editable, 'Break it');
      await tester.pump();
      await tester.tap(find.byIcon(LucideIcons.arrowUp));
      await tester.pump();

      AiGenerationDto generation(String status) {
        return AiGenerationDto(
          generationId: 'gen-fail-ui',
          requestId: requestId!,
          userMessageId: 'usr-fail-ui',
          status: status,
          errorMessage: 'Unable to generate a response.',
          createdAt: DateTime.now().toUtc(),
        );
      }

      controller.add(
        AiChatStreamEvent.accepted(
          AiChatTurnResponseDto(
            chatId: 'chat-fail-ui',
            title: 'Break it',
            generation: generation('processing'),
          ),
        ),
      );
      controller.add(const AiChatStreamEvent.delta('partial text'));
      await tester.pump();
      expect(find.textContaining('partial text'), findsOneWidget);

      controller.add(
        AiChatStreamEvent.done(
          AiChatTurnResponseDto(
            chatId: 'chat-fail-ui',
            title: 'Break it',
            generation: generation('failed'),
          ),
        ),
      );
      await controller.close();
      await tester.pumpAndSettle();

      expect(find.textContaining('partial text'), findsNothing);
      expect(find.text('Break it'), findsOneWidget);
      expect(
        find.text("Couldn't generate a response. Please try again."),
        findsOneWidget,
      );
      expect(find.text('Try again'), findsOneWidget);
      expect(find.text('Generating response...'), findsNothing);

      final composer = tester.widget<AiComposer>(find.byType(AiComposer));
      expect(composer.enabled, isTrue);
    },
  );
}
