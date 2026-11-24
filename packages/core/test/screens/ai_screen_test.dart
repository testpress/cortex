import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
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

  AiChatPolicyDto? customPolicy;

  @override
  AiChatPolicyDto? get policy =>
      customPolicy ??
      const AiChatPolicyDto(
        maxMessageCharacters: 4000,
        imageAttachmentsEnabled: true,
      );

  @override
  Stream<AiChatStreamEvent> streamConversation({
    required String requestId,
    required String query,
    List<String>? attachmentIds,
    CancelToken? cancelToken,
  }) {
    if (streamFactory != null) return streamFactory!(requestId, query, null);
    return _synthesizeStream(
      () => startConversation(
        requestId: requestId,
        query: query,
        attachmentIds: attachmentIds,
      ),
    );
  }

  @override
  Stream<AiChatStreamEvent> streamFollowUpMessage({
    required String chatId,
    required String requestId,
    required String query,
    List<String>? attachmentIds,
    CancelToken? cancelToken,
  }) {
    if (streamFactory != null) return streamFactory!(requestId, query, chatId);
    return _synthesizeStream(
      () => sendFollowUpMessage(
        chatId: chatId,
        requestId: requestId,
        query: query,
        attachmentIds: attachmentIds,
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
    List<String>? attachmentIds,
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
    List<String>? attachmentIds,
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
  Future<AiAttachmentUploadResponseDto> uploadAttachments({
    required List<MultipartFile> files,
    CancelToken? cancelToken,
  }) async {
    return AiAttachmentUploadResponseDto(
      items: List.generate(
        files.length,
        (i) => AiAttachmentDto(
          attachmentId: 'att-$i',
          url: 'https://cdn.example.com/att-$i.png',
        ),
      ),
    );
  }

  @override
  Future<void> deleteAttachment({
    required String attachmentId,
    CancelToken? cancelToken,
  }) async {}

  int getConversationStatusCalls = 0;

  @override
  Future<AiConversationDto> getConversationStatus({
    required String chatId,
    CancelToken? cancelToken,
  }) async {
    getConversationStatusCalls++;
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

  List<AiConversationDto> conversations = const [];

  @override
  Future<AiConversationListDto> listConversations({
    int limit = 20,
    String? cursor,
  }) async {
    return AiConversationListDto(items: conversations);
  }

  int deleteConversationCalls = 0;
  bool failDeleteConversation = false;
  Object? deleteConversationError;
  Completer<void>? deleteConversationCompleter;

  @override
  Future<void> deleteConversation({
    required String chatId,
    CancelToken? cancelToken,
  }) async {
    deleteConversationCalls++;
    if (deleteConversationCompleter != null) {
      await deleteConversationCompleter!.future;
    }
    if (failDeleteConversation) {
      throw deleteConversationError ?? Exception('Delete failed');
    }
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

const _plainText = TextStyle();
final _testScale = DesignTypographyScale(
  xxs: _plainText.copyWith(fontSize: 10),
  xs: _plainText.copyWith(fontSize: 12),
  sm: _plainText.copyWith(fontSize: 14),
  base: _plainText.copyWith(fontSize: 16),
  lg: _plainText.copyWith(fontSize: 18),
  xl: _plainText.copyWith(fontSize: 20),
  xl2: _plainText.copyWith(fontSize: 24),
  xl3: _plainText.copyWith(fontSize: 30),
  xl4: _plainText.copyWith(fontSize: 36),
  xl5: _plainText.copyWith(fontSize: 48),
);
final _testTypography = DesignTypography(
  display: _plainText.copyWith(fontSize: 30, fontWeight: FontWeight.w700),
  headline: _plainText.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
  title: _plainText.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
  subtitle: _plainText.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
  body: _plainText.copyWith(fontSize: 16, fontWeight: FontWeight.w400),
  bodySmall: _plainText.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
  label: _plainText.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
  labelSmall: _plainText.copyWith(fontSize: 11, fontWeight: FontWeight.w500),
  labelBold: _plainText.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
  caption: _plainText.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
  cardTitle: _plainText.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
  cardSubtitle: _plainText.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
  cardCaption: _plainText.copyWith(fontSize: 10, fontWeight: FontWeight.w400),
);

final _testColors = DesignColors.light();
final _testConfig = DesignConfig(
  colors: _testColors,
  spacing: DesignSpacing.defaults(),
  typography: _testTypography,
  typographyScale: _testScale,
  motion: DesignMotion.defaults(),
  radius: DesignRadius.defaults(),
  iconSize: DesignIconSize.defaults(),
  shadows: DesignShadows.light(),
  layout: DesignLayout.defaults(),
  subjectPalette: DesignSubjectPalette.light(),
  statusColors: DesignStatusColors.light(),
  shortcutPalette: DesignShortcutPalette.light(),
  study: DesignStudyTheme.light(),
);

void main() {
  Widget buildSubject({
    List<AiChatMessageItem> initialMessages = const [],
    List<Override> overrides = const [],
    _TestLearnLensRepository? repository,
    VoidCallback? onOpenHistory,
    ImagePicker? imagePicker,
    AppImageCropper? imageCropper,
  }) {
    final testRepo = repository ?? _TestLearnLensRepository();
    return ProviderScope(
      overrides: [
        learnLensRepositoryProvider.overrideWithValue(testRepo),
        ...overrides,
      ],
      child: DesignProvider(
        mode: DesignMode.light,
        config: _testConfig,
        darkConfig: _testConfig,
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
            onOpenHistory: onOpenHistory,
            imagePicker: imagePicker,
            imageCropper: imageCropper,
          ),
        ),
      ),
    );
  }

  testWidgets('renders landing header with only Menu icon and default title', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('Back'), findsNothing);
    expect(find.byIcon(LucideIcons.arrowLeft), findsNothing);
    expect(find.byIcon(LucideIcons.menu), findsOneWidget);
    expect(find.text('AI Chat'), findsOneWidget);
    expect(find.byIcon(LucideIcons.squarePen), findsNothing);
    expect(find.byIcon(LucideIcons.moreVertical), findsNothing);
  });

  testWidgets(
    'renders guided empty state with heading, suggestions, and composer',
    (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('What can I help with?'), findsOneWidget);
      expect(find.byType(AiSuggestionCard), findsNWidgets(4));
      expect(find.text('Explain concept'), findsOneWidget);
      expect(find.text('Solve problem'), findsOneWidget);
      expect(find.text('Practice questions'), findsOneWidget);
      expect(find.text('Study tips'), findsOneWidget);
      expect(find.byIcon(LucideIcons.bookOpen), findsOneWidget);
      expect(find.byIcon(LucideIcons.calculator), findsOneWidget);
      expect(find.byIcon(LucideIcons.fileQuestionMark), findsOneWidget);
      expect(find.byIcon(LucideIcons.lightbulb), findsOneWidget);

      expect(find.byType(AiComposer), findsOneWidget);
      expect(find.text('Message'), findsOneWidget);
      // The new-chat action only appears once a conversation exists.
      expect(find.bySemanticsLabel('Start new chat'), findsNothing);
      expect(
        find.byKey(const ValueKey('ai_composer_attach_button')),
        findsOneWidget,
      );

      // The composer sits directly below the suggestion cards.
      final lastCardBottom = tester
          .getBottomLeft(find.byType(AiSuggestionCard).last)
          .dy;
      final composerTop = tester.getTopLeft(find.byType(AiComposer)).dy;
      expect(composerTop, greaterThan(lastCardBottom));
      expect(composerTop - lastCardBottom, lessThan(48.0));

      for (final card in tester.widgetList(find.byType(AiSuggestionCard))) {
        final size = tester.getSize(find.byWidget(card));
        expect(size.height, greaterThanOrEqualTo(48.0));
      }
    },
  );

  testWidgets(
    'all suggestion cards share the same height on narrow viewport with large text scale',
    (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      tester.platformDispatcher.textScaleFactorTestValue = 1.3;
      addTearDown(() {
        tester.view.reset();
        tester.platformDispatcher.clearTextScaleFactorTestValue();
      });

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      final cards = find.byType(AiSuggestionCard);
      expect(cards, findsNWidgets(4));

      final firstCardHeight = tester.getSize(cards.at(0)).height;
      for (var i = 1; i < 4; i++) {
        expect(tester.getSize(cards.at(i)).height, equals(firstCardHeight));
      }
    },
  );

  testWidgets(
    'tapping a suggestion prefills and focuses the composer without sending',
    (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Explain concept'));
      await tester.pump();

      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.controller.text, 'Explain the concept of ');
      expect(
        editable.controller.selection,
        const TextSelection.collapsed(offset: 23),
      );
      expect(editable.focusNode.hasFocus, isTrue);

      // Nothing was sent: the empty state is still showing.
      expect(find.text('What can I help with?'), findsOneWidget);
      expect(find.byType(AiUserMessageBubble), findsNothing);
      expect(find.text('Message'), findsNothing);

      // The student can finish the prompt and send it.
      await tester.enterText(
        find.byType(EditableText),
        'Explain the concept of inertia',
      );
      await tester.pump();
      await tester.tap(find.byIcon(LucideIcons.arrowUp));
      await tester.pump();

      expect(find.text('Explain the concept of inertia'), findsOneWidget);
      expect(find.text('What can I help with?'), findsNothing);

      await tester.pump(const Duration(milliseconds: 1300));
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    'empty state keeps the composer above the keyboard on a small screen',
    (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      addTearDown(tester.view.reset);

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      final composerRect = tester.getRect(find.byType(AiComposer));
      expect(composerRect.bottom, lessThanOrEqualTo(568.0 - 300.0));
      expect(composerRect.top, greaterThan(0.0));
    },
  );

  testWidgets(
    'docks the composer without plus and resets via New Chat button',
    (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(AiScreen)),
      );
      container.read(genericAiChatProvider.notifier).setInitialMessages([
        GenericAiChatMessage(
          id: 'msg-1',
          text: 'Hello world',
          isUser: true,
          timestamp: DateTime(2026, 10, 13, 14, 36),
        ),
      ]);
      await tester.pumpAndSettle();

      expect(find.text('What can I help with?'), findsNothing);
      expect(find.byType(AiSuggestionCard), findsNothing);
      expect(find.byType(AiComposer), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AiComposer),
          matching: find.bySemanticsLabel('Start new chat'),
        ),
        findsNothing,
      );
      expect(find.byIcon(LucideIcons.squarePen), findsOneWidget);

      // The composer is pinned below the message list.
      final listBottom = tester.getBottomLeft(find.byType(ListView)).dy;
      final composerTop = tester.getTopLeft(find.byType(AiComposer)).dy;
      expect(composerTop, greaterThanOrEqualTo(listBottom));

      await tester.tap(find.byIcon(LucideIcons.squarePen));
      await tester.pumpAndSettle();

      expect(find.text('Hello world'), findsNothing);
      expect(find.text('What can I help with?'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AiComposer),
          matching: find.bySemanticsLabel('Start new chat'),
        ),
        findsNothing,
      );
      expect(container.read(genericAiChatProvider).currentChatId, isNull);
    },
  );

  testWidgets('opening history dismisses the keyboard', (tester) async {
    await tester.pumpWidget(buildSubject(onOpenHistory: () {}));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(EditableText));
    await tester.pump();
    final editable = tester.widget<EditableText>(find.byType(EditableText));
    expect(editable.focusNode.hasFocus, isTrue);

    await tester.tap(find.byIcon(LucideIcons.menu));
    await tester.pump();
    expect(editable.focusNode.hasFocus, isFalse);
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
      // Copy is the only assistant action.
      expect(find.byIcon(LucideIcons.thumbsUp), findsNothing);
      expect(find.byIcon(LucideIcons.thumbsDown), findsNothing);
      expect(find.byIcon(LucideIcons.volume2), findsNothing);
      expect(find.byIcon(LucideIcons.share2), findsNothing);
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

  testWidgets('hides landing Back and invokes onOpenHistory callback', (
    tester,
  ) async {
    var historyCalled = false;

    await tester.pumpWidget(
      buildSubject(onOpenHistory: () => historyCalled = true),
    );
    await tester.pumpAndSettle();

    expect(find.text('Back'), findsNothing);

    await tester.tap(find.byIcon(LucideIcons.menu));
    await tester.pump();
    expect(historyCalled, isTrue);
  });

  testWidgets('assistant card places the timestamp below the copy button', (
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

    final markdownRect = tester.getRect(find.byType(AppMarkdown));
    final copyRect = tester.getRect(find.byIcon(LucideIcons.copy));
    final timestampRect = tester.getRect(find.text('14:36'));
    // Copy sits under the card, and the timestamp on its own line under copy.
    expect(copyRect.top, greaterThan(markdownRect.bottom));
    expect(timestampRect.top, greaterThanOrEqualTo(copyRect.bottom));
    // Both hug the start edge of the card instead of sitting side by side.
    expect(timestampRect.left, lessThan(copyRect.left));
    expect(copyRect.left, lessThan(markdownRect.left + 16.0));
  });

  testWidgets('spans chat column full width on wide tablet viewport', (
    tester,
  ) async {
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
    expect(listSize.width, equals(1200.0));

    final context = tester.element(find.byType(AiScreen));
    final design = Design.of(context);

    final menuFinder = find.byIcon(LucideIcons.menu);
    expect(menuFinder, findsOneWidget);
    // Menu icon sits near the leading edge
    expect(tester.getTopLeft(menuFinder).dx, lessThan(design.spacing.md * 2));

    // New Chat icon sits near the trailing edge of the 1200dp screen
    final newChatFinder = find.byIcon(LucideIcons.squarePen);
    expect(newChatFinder, findsOneWidget);
    expect(
      tester.getTopRight(newChatFinder).dx,
      greaterThan(1200.0 - (design.spacing.md * 6)),
    );
  });

  testWidgets(
    'constrains empty state within tabletBreakpoint on wide viewports',
    (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(AiScreen));
      final design = Design.of(context);

      final composerFinder = find.byType(AiComposer);
      expect(composerFinder, findsOneWidget);
      final composerSize = tester.getSize(composerFinder);
      final expectedWidth =
          design.layout.tabletBreakpoint - (design.spacing.md * 2);
      expect(composerSize.width, equals(expectedWidth));
    },
  );

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
        findsNothing, // because it's empty so the empty state is shown
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
      expect(
        find.descendant(
          of: find.byType(AiChatHeader),
          matching: find.text('Break it'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(ListView),
          matching: find.text('Break it'),
        ),
        findsOneWidget,
      );
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

  testWidgets(
    'displays access restricted banner and disables composer when canGenerate is false',
    (tester) async {
      final testRepo = _TestLearnLensRepository()
        ..customPolicy = const AiChatPolicyDto(canGenerate: false);

      await tester.pumpWidget(buildSubject(repository: testRepo));
      await tester.pumpAndSettle();

      expect(find.text('AI chat not available'), findsOneWidget);
      expect(
        find.textContaining('AI chat is not enabled for your account'),
        findsOneWidget,
      );
      expect(find.byIcon(LucideIcons.lock), findsOneWidget);

      final composer = tester.widget<AiComposer>(find.byType(AiComposer));
      expect(composer.enabled, isFalse);
    },
  );

  testWidgets('triggers canonical state sync on AppLifecycleState.resumed', (
    tester,
  ) async {
    final testRepo = _TestLearnLensRepository();
    final initialMessages = [
      GenericAiChatMessage(
        id: 'u-sync',
        text: 'Sync me',
        isUser: true,
        timestamp: DateTime.now(),
      ),
    ];

    await tester.pumpWidget(
      buildSubject(repository: testRepo, initialMessages: initialMessages),
    );
    await tester.pumpAndSettle();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(AiScreen)),
    );
    container.read(genericAiChatProvider.notifier).state = container
        .read(genericAiChatProvider)
        .copyWith(currentChatId: 'chat-active-resume');

    final callsBefore = testRepo.getConversationStatusCalls;

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();

    expect(testRepo.getConversationStatusCalls, greaterThan(callsBefore));
  });

  testWidgets(
    'deleting active conversation via header 3-dot overflow menu resets canvas',
    (tester) async {
      final testRepo = _TestLearnLensRepository();
      testRepo.conversations = [
        const AiConversationDto(
          chatId: 'chat-delete-header',
          title: 'Active Solar System',
        ),
      ];
      await tester.pumpWidget(buildSubject(repository: testRepo));
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(AiScreen)),
      );
      final notifier = container.read(genericAiChatProvider.notifier);

      notifier.state = notifier.state.copyWith(
        conversationHistory: testRepo.conversations,
      );
      await notifier.selectConversation('chat-delete-header');
      await tester.pumpAndSettle();

      // Title and 3-dot menu are visible
      expect(find.text('Active Solar System'), findsOneWidget);
      final moreFinder = find.byIcon(LucideIcons.moreVertical);
      expect(moreFinder, findsOneWidget);

      // Tap 3-dot menu
      await tester.tap(moreFinder);
      await tester.pumpAndSettle();

      expect(find.text('Delete'), findsOneWidget);
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Confirmation dialog appears with title
      expect(find.text('Delete conversation?'), findsOneWidget);
      expect(
        find.text(
          'Are you sure you want to delete "Active Solar System"? This action cannot be undone.',
        ),
        findsOneWidget,
      );

      // Confirm deletion
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Deleted via repo and reset to landing state
      expect(testRepo.deleteConversationCalls, equals(1));
      expect(container.read(genericAiChatProvider).currentChatId, isNull);
      expect(find.text('What can I help with?'), findsOneWidget);
      expect(find.text('Conversation deleted'), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
    },
  );

  testWidgets(
    'cannot delete active conversation from header while generation is in flight',
    (tester) async {
      final testRepo = _TestLearnLensRepository();
      testRepo.conversations = [
        const AiConversationDto(
          chatId: 'chat-generating-1',
          title: 'Active Generating Chat',
        ),
      ];
      await tester.pumpWidget(buildSubject(repository: testRepo));
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(AiScreen)),
      );
      final notifier = container.read(genericAiChatProvider.notifier);

      notifier.state = notifier.state.copyWith(
        conversationHistory: testRepo.conversations,
      );
      await notifier.selectConversation('chat-generating-1');
      await tester.pumpAndSettle();

      // Put into generating state
      notifier.state = notifier.state.copyWith(isGenerating: true);
      await tester.pumpAndSettle();

      // Tap 3-dot menu
      await tester.tap(find.byIcon(LucideIcons.moreVertical));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete'));
      await tester.pump();

      // Warning toast appears and confirmation dialog is NOT shown
      expect(find.text('Delete conversation?'), findsNothing);
      expect(
        find.text('Cannot delete conversation while a response is generating.'),
        findsOneWidget,
      );
      expect(testRepo.deleteConversationCalls, equals(0));

      await tester.pump(const Duration(seconds: 3));
    },
  );

  testWidgets(
    'shows failure toast and preserves active chat when deletion fails from header',
    (tester) async {
      final testRepo = _TestLearnLensRepository();
      testRepo.conversations = [
        const AiConversationDto(
          chatId: 'chat-fail-1',
          title: 'Quantum Mechanics Discussion',
        ),
      ];
      testRepo.failDeleteConversation = true;

      await tester.pumpWidget(buildSubject(repository: testRepo));
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(AiScreen)),
      );
      final notifier = container.read(genericAiChatProvider.notifier);

      notifier.state = notifier.state.copyWith(
        conversationHistory: testRepo.conversations,
      );
      await notifier.selectConversation('chat-fail-1');
      await tester.pumpAndSettle();

      notifier.state = notifier.state.copyWith(
        messages: [
          GenericAiChatMessage(
            id: 'm-1',
            text: 'Tell me about quantum mechanics',
            isUser: true,
            timestamp: DateTime.now().toUtc(),
          ),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.text('Quantum Mechanics Discussion'), findsOneWidget);
      expect(find.text('Tell me about quantum mechanics'), findsOneWidget);

      // Open header 3-dot overflow menu
      await tester.tap(find.byIcon(LucideIcons.moreVertical));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(find.text('Delete conversation?'), findsOneWidget);

      // Confirm deletion in dialog
      await tester.tap(find.text('Delete'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Delete was called on repo, but failed
      expect(testRepo.deleteConversationCalls, equals(1));

      // Failure toast shown
      expect(
        find.text('Failed to delete conversation. Please try again.'),
        findsOneWidget,
      );

      // Active chat stays loaded (not reset to landing empty state)
      expect(
        container.read(genericAiChatProvider).currentChatId,
        equals('chat-fail-1'),
      );
      expect(find.text('Quantum Mechanics Discussion'), findsOneWidget);
      expect(find.text('Tell me about quantum mechanics'), findsOneWidget);
      expect(find.text('What can I help with?'), findsNothing);

      await tester.pump(const Duration(seconds: 3));
    },
  );

  testWidgets(
    'aborts deletion if generation starts while confirmation dialog is open',
    (tester) async {
      final testRepo = _TestLearnLensRepository();
      testRepo.conversations = [
        const AiConversationDto(
          chatId: 'chat-generating-2',
          title: 'Active Solar Systems',
        ),
      ];
      await tester.pumpWidget(buildSubject(repository: testRepo));
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(AiScreen)),
      );
      final notifier = container.read(genericAiChatProvider.notifier);

      notifier.state = notifier.state.copyWith(
        conversationHistory: testRepo.conversations,
      );
      await notifier.selectConversation('chat-generating-2');
      await tester.pumpAndSettle();

      // Tap 3-dot menu and select Delete while not generating
      await tester.tap(find.byIcon(LucideIcons.moreVertical));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Dialog is open
      expect(find.text('Delete conversation?'), findsOneWidget);

      // Background generation starts while dialog is waiting for user
      notifier.state = notifier.state.copyWith(isGenerating: true);

      // User confirms delete
      await tester.tap(find.text('Delete'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Deletion is blocked by post-confirm guard
      expect(testRepo.deleteConversationCalls, equals(0));
      expect(
        find.text('Cannot delete conversation while a response is generating.'),
        findsOneWidget,
      );

      // Chat remains active
      expect(
        container.read(genericAiChatProvider).currentChatId,
        equals('chat-generating-2'),
      );

      await tester.pump(const Duration(seconds: 3));
    },
  );

  testWidgets(
    'does not show toast or throw error if screen is unmounted during deletion',
    (tester) async {
      final deleteCompleter = Completer<void>();
      final testRepo = _TestLearnLensRepository();
      testRepo.deleteConversationCompleter = deleteCompleter;
      testRepo.conversations = [
        const AiConversationDto(
          chatId: 'chat-unmount-1',
          title: 'Unmount Test Chat',
        ),
      ];

      await tester.pumpWidget(buildSubject(repository: testRepo));
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(AiScreen)),
      );
      final notifier = container.read(genericAiChatProvider.notifier);

      notifier.state = notifier.state.copyWith(
        conversationHistory: testRepo.conversations,
      );
      await notifier.selectConversation('chat-unmount-1');
      await tester.pumpAndSettle();

      // Open header 3-dot overflow menu
      await tester.tap(find.byIcon(LucideIcons.moreVertical));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Confirm deletion in dialog
      await tester.tap(find.text('Delete'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(testRepo.deleteConversationCalls, equals(1));

      // Unmount the screen while delete is in flight
      await tester.pumpWidget(const SizedBox.shrink());

      // Complete delete request after unmount
      deleteCompleter.complete();
      await tester.pumpAndSettle();

      // Context check (!context.mounted) safely suppressed toast and prevented lifecycle crash
      expect(find.text('Conversation deleted'), findsNothing);
    },
  );

  testWidgets(
    'tapping attachment button opens popover with Gallery top and Camera bottom',
    (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      final attachButton = find.byKey(
        const ValueKey('ai_composer_attach_button'),
      );
      expect(attachButton, findsOneWidget);

      await tester.tap(attachButton);
      await tester.pumpAndSettle();

      final cameraOption = find.byKey(
        const ValueKey('ai_attach_camera_option'),
      );
      final galleryOption = find.byKey(
        const ValueKey('ai_attach_gallery_option'),
      );

      expect(cameraOption, findsOneWidget);
      expect(galleryOption, findsOneWidget);

      expect(find.text('Upload an image'), findsOneWidget);
      expect(find.text('Take a photo'), findsOneWidget);
      expect(find.byIcon(LucideIcons.image), findsOneWidget);
      expect(find.byIcon(LucideIcons.camera), findsOneWidget);

      // Verify Gallery is above Camera vertically
      final galleryY = tester.getTopLeft(galleryOption).dy;
      final cameraY = tester.getTopLeft(cameraOption).dy;
      expect(galleryY, lessThan(cameraY));

      // Tapping an option dismisses the popover
      await tester.tap(cameraOption);
      await tester.pumpAndSettle();

      expect(find.byType(AiAttachmentPickerSheet), findsOneWidget);
      final sheet = tester.widget<AiAttachmentPickerSheet>(
        find.byType(AiAttachmentPickerSheet),
      );
      expect(sheet.isOpen, isFalse);
    },
  );

  testWidgets(
    'delegates picked image to AppImageCropper and stages cropped file',
    (tester) async {
      final tempDir = Directory.systemTemp.createTempSync('ai_crop_test');
      addTearDown(() => tempDir.deleteSync(recursive: true));
      const validPng = [
        0x89,
        0x50,
        0x4E,
        0x47,
        0x0D,
        0x0A,
        0x1A,
        0x0A,
        0x00,
        0x00,
        0x00,
        0x0D,
        0x49,
        0x48,
        0x44,
        0x52,
        0x00,
        0x00,
        0x00,
        0x01,
        0x00,
        0x00,
        0x00,
        0x01,
        0x08,
        0x06,
        0x00,
        0x00,
        0x00,
        0x1F,
        0x15,
        0xC4,
        0x89,
        0x00,
        0x00,
        0x00,
        0x0A,
        0x49,
        0x44,
        0x41,
        0x54,
        0x78,
        0x9C,
        0x63,
        0x00,
        0x01,
        0x00,
        0x00,
        0x05,
        0x00,
        0x01,
        0x0D,
        0x0A,
        0x2D,
        0xB4,
        0x00,
        0x00,
        0x00,
        0x00,
        0x49,
        0x45,
        0x4E,
        0x44,
        0xAE,
        0x42,
        0x60,
        0x82,
      ];
      final sourceFile = File('${tempDir.path}/raw.png')
        ..writeAsBytesSync(validPng);
      final croppedFile = File('${tempDir.path}/cropped.png')
        ..writeAsBytesSync(validPng);

      final fakePicker = _FakeImagePicker()
        ..pickedFile = XFile(sourceFile.path);
      final fakeCropper = _FakeAppImageCropper()..cropResult = croppedFile.path;

      await tester.pumpWidget(
        buildSubject(imagePicker: fakePicker, imageCropper: fakeCropper),
      );
      await tester.pumpAndSettle();

      // Tap attach button
      await tester.tap(find.byKey(const ValueKey('ai_composer_attach_button')));
      await tester.pumpAndSettle();

      // Tap camera option
      await tester.runAsync(() async {
        await tester.tap(find.byKey(const ValueKey('ai_attach_camera_option')));
        await Future.delayed(const Duration(milliseconds: 100));
      });
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pump();

      expect(fakePicker.pickCalls, 1);
      expect(fakePicker.lastMaxWidth, 1920);
      expect(fakePicker.lastMaxHeight, 1920);
      expect(fakePicker.lastImageQuality, 85);
      expect(fakeCropper.cropCalls, 1);

      // Verify staged thumbnail is displayed
      final container = ProviderScope.containerOf(
        tester.element(find.byType(AiScreen)),
      );
      final staged = container.read(genericAiChatProvider).stagedAttachments;
      expect(staged.length, 1);
      expect(staged.first.fileName, 'cropped.png');
    },
  );

  testWidgets(
    'displays AppLoadingIndicator overlay while image cropping is in progress',
    (tester) async {
      final tempDir = Directory.systemTemp.createTempSync('ai_crop_loading');
      addTearDown(() => tempDir.deleteSync(recursive: true));
      final pickedFile = File('${tempDir.path}/picked.png')
        ..writeAsBytesSync(_validPng);

      final fakePicker = _FakeImagePicker()
        ..pickedFile = XFile(pickedFile.path);
      final completer = Completer<String?>();
      final fakeCropper = _FakeAppImageCropper()..cropCompleter = completer;

      await tester.pumpWidget(
        buildSubject(imagePicker: fakePicker, imageCropper: fakeCropper),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('ai_composer_attach_button')));
      await tester.pumpAndSettle();

      await tester.runAsync(() async {
        await tester.tap(find.byKey(const ValueKey('ai_attach_camera_option')));
        await Future.delayed(const Duration(milliseconds: 100));
      });
      await tester.pump();

      expect(fakeCropper.cropCalls, 1);
      expect(
        find.byKey(const ValueKey('ai_crop_loading_overlay')),
        findsOneWidget,
      );

      await tester.runAsync(() async {
        completer.complete(pickedFile.path);
        await Future.delayed(const Duration(milliseconds: 100));
      });
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pump();

      expect(
        find.byKey(const ValueKey('ai_crop_loading_overlay')),
        findsNothing,
      );
    },
  );

  testWidgets('does not stage attachment when user cancels cropping', (
    tester,
  ) async {
    final tempDir = Directory.systemTemp.createTempSync('ai_crop_cancel');
    addTearDown(() => tempDir.deleteSync(recursive: true));
    const validPng = [
      0x89,
      0x50,
      0x4E,
      0x47,
      0x0D,
      0x0A,
      0x1A,
      0x0A,
      0x00,
      0x00,
      0x00,
      0x0D,
      0x49,
      0x48,
      0x44,
      0x52,
      0x00,
      0x00,
      0x00,
      0x01,
      0x00,
      0x00,
      0x00,
      0x01,
      0x08,
      0x06,
      0x00,
      0x00,
      0x00,
      0x1F,
      0x15,
      0xC4,
      0x89,
      0x00,
      0x00,
      0x00,
      0x0A,
      0x49,
      0x44,
      0x41,
      0x54,
      0x78,
      0x9C,
      0x63,
      0x00,
      0x01,
      0x00,
      0x00,
      0x05,
      0x00,
      0x01,
      0x0D,
      0x0A,
      0x2D,
      0xB4,
      0x00,
      0x00,
      0x00,
      0x00,
      0x49,
      0x45,
      0x4E,
      0x44,
      0xAE,
      0x42,
      0x60,
      0x82,
    ];
    final sourceFile = File('${tempDir.path}/raw.png')
      ..writeAsBytesSync(validPng);

    final fakePicker = _FakeImagePicker()..pickedFile = XFile(sourceFile.path);
    final fakeCropper = _FakeAppImageCropper()
      ..cropResult = null; // user cancelled crop

    await tester.pumpWidget(
      buildSubject(imagePicker: fakePicker, imageCropper: fakeCropper),
    );
    await tester.pumpAndSettle();

    // Tap attach button
    await tester.tap(find.byKey(const ValueKey('ai_composer_attach_button')));
    await tester.pumpAndSettle();

    // Tap gallery option
    await tester.tap(find.byKey(const ValueKey('ai_attach_gallery_option')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pump();

    expect(fakePicker.pickCalls, 1);
    expect(fakeCropper.cropCalls, 1);

    // Verify nothing is staged
    final container = ProviderScope.containerOf(
      tester.element(find.byType(AiScreen)),
    );
    final staged = container.read(genericAiChatProvider).stagedAttachments;
    expect(staged, isEmpty);
  });

  testWidgets(
    'shows permission toast when picker throws permission denial PlatformException',
    (tester) async {
      final fakePicker = _FakeImagePicker()
        ..pickError = PlatformException(code: 'camera_access_denied');

      await tester.pumpWidget(buildSubject(imagePicker: fakePicker));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('ai_composer_attach_button')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('ai_attach_camera_option')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(fakePicker.pickCalls, 1);
      expect(
        find.text(
          'Permission is required to attach images. Please enable it in Settings.',
        ),
        findsOneWidget,
      );
      await tester.pump(const Duration(seconds: 4));
    },
  );

  testWidgets('shows error toast when picker throws unexpected exception', (
    tester,
  ) async {
    final fakePicker = _FakeImagePicker()
      ..pickError = Exception('Storage read failure');

    await tester.pumpWidget(buildSubject(imagePicker: fakePicker));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('ai_composer_attach_button')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('ai_attach_gallery_option')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(fakePicker.pickCalls, 1);
    expect(find.text('Failed to upload image'), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('shows size exceeded toast when cropped file exceeds 5MB', (
    tester,
  ) async {
    final tempDir = Directory.systemTemp.createTempSync('ai_size_exceeded');
    addTearDown(() => tempDir.deleteSync(recursive: true));
    final largeFile = File('${tempDir.path}/large.jpg')
      ..writeAsBytesSync(Uint8List(AiScreen.maxAttachmentSizeBytes + 1));

    final fakePicker = _FakeImagePicker()..pickedFile = XFile(largeFile.path);
    final fakeCropper = _FakeAppImageCropper()..cropResult = largeFile.path;

    await tester.pumpWidget(
      buildSubject(imagePicker: fakePicker, imageCropper: fakeCropper),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('ai_composer_attach_button')));
    await tester.pumpAndSettle();

    await tester.runAsync(() async {
      await tester.tap(find.byKey(const ValueKey('ai_attach_camera_option')));
      await Future.delayed(const Duration(milliseconds: 100));
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Image size exceeds the 5 MB limit.'), findsOneWidget);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(AiScreen)),
    );
    expect(container.read(genericAiChatProvider).stagedAttachments, isEmpty);

    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets(
    'hides attachment trigger when imageAttachmentsEnabled is false',
    (tester) async {
      final testRepo = _TestLearnLensRepository()
        ..customPolicy = const AiChatPolicyDto(imageAttachmentsEnabled: false);

      await tester.pumpWidget(buildSubject(repository: testRepo));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('ai_composer_attach_button')),
        findsNothing,
      );
    },
  );

  testWidgets(
    'shows unsupported format toast when image format is not JPEG, PNG, or WebP',
    (tester) async {
      final tempDir = Directory.systemTemp.createTempSync(
        'ai_unsupported_format',
      );
      addTearDown(() => tempDir.deleteSync(recursive: true));
      final unsupportedFile = File('${tempDir.path}/test.gif')
        ..writeAsBytesSync(_validPng);

      final fakePicker = _FakeImagePicker()
        ..pickedFile = XFile(unsupportedFile.path);
      final fakeCropper = _FakeAppImageCropper()
        ..cropResult = unsupportedFile.path;

      await tester.pumpWidget(
        buildSubject(imagePicker: fakePicker, imageCropper: fakeCropper),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('ai_composer_attach_button')));
      await tester.pumpAndSettle();

      await tester.runAsync(() async {
        await tester.tap(find.byKey(const ValueKey('ai_attach_camera_option')));
        await Future.delayed(const Duration(milliseconds: 250));
      });
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(fakePicker.pickCalls, 1);
      expect(
        find.text('Only JPEG, PNG, and WebP images are supported.'),
        findsOneWidget,
      );

      final container = ProviderScope.containerOf(
        tester.element(find.byType(AiScreen)),
      );
      expect(container.read(genericAiChatProvider).stagedAttachments, isEmpty);

      await tester.pump(const Duration(seconds: 4));
    },
  );

  testWidgets('stages PNG attachment with derived image/png mimeType', (
    tester,
  ) async {
    final tempDir = Directory.systemTemp.createTempSync('ai_png_format');
    addTearDown(() => tempDir.deleteSync(recursive: true));
    final pngFile = File('${tempDir.path}/test.png')
      ..writeAsBytesSync(_validPng);

    final fakePicker = _FakeImagePicker()..pickedFile = XFile(pngFile.path);
    final fakeCropper = _FakeAppImageCropper()..cropResult = pngFile.path;

    await tester.pumpWidget(
      buildSubject(imagePicker: fakePicker, imageCropper: fakeCropper),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('ai_composer_attach_button')));
    await tester.pumpAndSettle();

    await tester.runAsync(() async {
      await tester.tap(find.byKey(const ValueKey('ai_attach_camera_option')));
      await Future.delayed(const Duration(milliseconds: 100));
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pump();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(AiScreen)),
    );
    expect(
      container.read(genericAiChatProvider).stagedAttachments,
      hasLength(1),
    );
    expect(
      container.read(genericAiChatProvider).stagedAttachments.first.mimeType,
      'image/png',
    );
  });
}

const _validPng = [
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
];

class _FakeImagePicker extends Fake implements ImagePicker {
  XFile? pickedFile;
  Object? pickError;
  int pickCalls = 0;
  double? lastMaxWidth;
  double? lastMaxHeight;
  int? lastImageQuality;

  @override
  Future<XFile?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) async {
    pickCalls++;
    lastMaxWidth = maxWidth;
    lastMaxHeight = maxHeight;
    lastImageQuality = imageQuality;
    if (pickError != null) {
      throw pickError!;
    }
    return pickedFile;
  }
}

class _FakeAppImageCropper extends Fake implements AppImageCropper {
  String? cropResult;
  int cropCalls = 0;
  Completer<String?>? cropCompleter;

  @override
  Future<String?> crop(
    BuildContext context, {
    required String imagePath,
  }) async {
    cropCalls++;
    if (cropCompleter != null) {
      return cropCompleter!.future;
    }
    return cropResult;
  }
}
