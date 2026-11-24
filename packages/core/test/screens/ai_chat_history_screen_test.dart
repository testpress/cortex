import 'dart:async';

import 'package:core/core.dart';
import 'package:core/data/repositories/learnlens_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeLearnLensRepository extends Fake implements LearnLensRepository {
  _FakeLearnLensRepository({this.conversations = const []});

  List<AiConversationDto> conversations;
  bool failListConversations = false;
  final List<String> loadedChatIds = [];
  final List<String> deletedChatIds = [];

  @override
  AiChatPolicyDto? get policy =>
      const AiChatPolicyDto(maxMessageCharacters: 4000);

  @override
  Future<void> ensureGenericChatSession() async {}

  Completer<void>? deleteCompleter;

  @override
  Future<void> deleteConversation({
    required String chatId,
    CancelToken? cancelToken,
  }) async {
    if (deleteCompleter != null) {
      await deleteCompleter!.future;
    }
    deletedChatIds.add(chatId);
    conversations = conversations.where((c) => c.chatId != chatId).toList();
  }

  @override
  Future<AiConversationListDto> listConversations({
    int limit = 20,
    String? cursor,
  }) async {
    if (failListConversations) {
      throw Exception('Failed to load conversations');
    }
    return AiConversationListDto(items: conversations);
  }

  @override
  Future<AiMessagePageResult> getMessages({
    required String chatId,
    int limit = 20,
    String? before,
    CancelToken? cancelToken,
  }) async {
    loadedChatIds.add(chatId);
    return const AiMessagePageResult(items: []);
  }

  Completer<AiChatTurnResponseDto>? followUpCompleter;

  @override
  Stream<AiChatStreamEvent> streamFollowUpMessage({
    required String chatId,
    required String requestId,
    required String query,
    List<String>? attachmentIds,
    CancelToken? cancelToken,
  }) {
    return StreamController<AiChatStreamEvent>().stream;
  }

  @override
  Future<AiChatTurnResponseDto> sendFollowUpMessage({
    required String chatId,
    required String requestId,
    required String query,
    List<String>? attachmentIds,
    CancelToken? cancelToken,
  }) async {
    if (followUpCompleter != null) {
      return followUpCompleter!.future;
    }
    return Completer<AiChatTurnResponseDto>().future;
  }
}

void main() {
  setUpAll(() async {
    await LocalizationProvider.initializeDateFormatting();
  });

  const drawerKey = ValueKey('ai_chat_history_drawer');

  List<AiConversationDto> sampleConversations() => [
    AiConversationDto(
      chatId: 'chat-1',
      title: "Explain Newton's Laws of Motion",
      updatedAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 5)),
    ),
    AiConversationDto(
      chatId: 'chat-2',
      title: 'Organic Chemistry Reactions',
      updatedAt: DateTime.now().subtract(const Duration(days: 2, hours: 1)),
    ),
  ];

  GoRouter buildRouter({String initialLocation = '/ai/history'}) {
    final router = GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: '/ai',
          builder: (context, state) =>
              const Center(child: AppText.body('chat screen')),
          routes: [
            GoRoute(
              path: 'history',
              // Mirrors the app route: a non-opaque page over the chat.
              pageBuilder: (context, state) => CustomTransitionPage<void>(
                key: state.pageKey,
                opaque: false,
                transitionDuration: DesignConfig.defaults().motion.normal,
                reverseTransitionDuration:
                    DesignConfig.defaults().motion.normal,
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) => child,
                child: const AiChatHistoryScreen(),
              ),
            ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);
    return router;
  }

  Widget buildSubject({
    required _FakeLearnLensRepository repository,
    GoRouter? router,
    bool reducedMotion = false,
    Locale locale = const Locale('en'),
  }) {
    final routerConfig = router ?? buildRouter();
    return ProviderScope(
      overrides: [learnLensRepositoryProvider.overrideWithValue(repository)],
      child: MediaQuery(
        data: MediaQueryData.fromView(
          WidgetsBinding.instance.platformDispatcher.views.single,
        ).copyWith(disableAnimations: reducedMotion),
        child: Builder(
          builder: (context) => DesignProvider(
            config: DesignConfig.defaults(context: context),
            child: WidgetsApp.router(
              color: const Color(0xFF000000),
              routerConfig: routerConfig,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: locale,
            ),
          ),
        ),
      ),
    );
  }

  ProviderContainer containerOf(WidgetTester tester) {
    return ProviderScope.containerOf(
      tester.element(find.byType(AiChatHistoryScreen)),
    );
  }

  testWidgets('renders a start-side drawer over the dimmed chat', (
    tester,
  ) async {
    final repository = _FakeLearnLensRepository(
      conversations: sampleConversations(),
    );
    await tester.pumpWidget(buildSubject(repository: repository));
    await tester.pumpAndSettle();

    final layout = DesignConfig.defaults().layout;
    final drawer = tester.getRect(find.byKey(drawerKey));
    final screen = tester.getRect(find.byType(AiChatHistoryScreen));

    expect(drawer.left, 0.0);
    expect(drawer.width, layout.drawerWidth);
    expect(drawer.height, screen.height);
    expect(drawer.width, lessThan(screen.width));

    // The chat stays mounted behind the scrim.
    expect(find.text('chat screen'), findsOneWidget);

    expect(find.text('Chat History'), findsOneWidget);
    expect(find.byIcon(LucideIcons.x), findsOneWidget);
    expect(find.text('New Chat'), findsOneWidget);
  });

  testWidgets(
    'lists each conversation with its title without redundant relative time',
    (tester) async {
      final repository = _FakeLearnLensRepository(
        conversations: sampleConversations(),
      );
      await tester.pumpWidget(buildSubject(repository: repository));
      await tester.pumpAndSettle();

      expect(find.text("Explain Newton's Laws of Motion"), findsOneWidget);
      expect(find.text('Organic Chemistry Reactions'), findsOneWidget);

      // Redundant relative time captions are omitted since section headers provide temporal context.
      expect(find.text('2 hrs ago'), findsNothing);
      expect(find.text('2 days ago'), findsNothing);

      // Subject chips are intentionally left out of the history rows.
      expect(find.byType(AppSubjectChip), findsNothing);
      expect(find.byType(AppChip), findsNothing);
      expect(find.byType(AppBadge), findsNothing);

      final titleButton = find
          .ancestor(
            of: find.text("Explain Newton's Laws of Motion"),
            matching: find.byType(GestureDetector),
          )
          .first;
      expect(tester.getSize(titleButton).height, greaterThanOrEqualTo(48.0));

      final rowContainer = find
          .ancestor(of: titleButton, matching: find.byType(Container))
          .first;
      expect(tester.getSize(rowContainer).height, greaterThanOrEqualTo(48.0));
      expect(
        tester.getSize(rowContainer).width,
        lessThanOrEqualTo(tester.getSize(find.byKey(drawerKey)).width),
      );
    },
  );

  testWidgets('uses the New Chat label for untitled conversations', (
    tester,
  ) async {
    final repository = _FakeLearnLensRepository(
      conversations: [
        AiConversationDto(chatId: 'chat-untitled', updatedAt: DateTime.now()),
      ],
    );
    await tester.pumpWidget(buildSubject(repository: repository));
    await tester.pumpAndSettle();

    // Once for the button and once for the untitled row.
    expect(find.text('New Chat'), findsNWidgets(2));
    expect(find.text('just now'), findsNothing);
  });

  testWidgets('caps the drawer width on narrow screens', (tester) async {
    tester.view.physicalSize = const Size(300, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final repository = _FakeLearnLensRepository(
      conversations: sampleConversations(),
    );
    await tester.pumpWidget(buildSubject(repository: repository));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(
      tester.getSize(find.byKey(drawerKey)).width,
      moreOrLessEquals(300 * 0.85, epsilon: 0.5),
    );
  });

  testWidgets('selecting a conversation loads it and closes the drawer', (
    tester,
  ) async {
    final repository = _FakeLearnLensRepository(
      conversations: sampleConversations(),
    );
    await tester.pumpWidget(buildSubject(repository: repository));
    await tester.pumpAndSettle();
    final container = containerOf(tester);

    await tester.tap(find.text('Organic Chemistry Reactions'));
    await tester.pumpAndSettle();

    expect(repository.loadedChatIds, ['chat-2']);
    expect(container.read(genericAiChatProvider).currentChatId, 'chat-2');
    expect(find.byType(AiChatHistoryScreen), findsNothing);
    expect(find.text('chat screen'), findsOneWidget);
  });

  testWidgets('New Chat resets the conversation and closes the drawer', (
    tester,
  ) async {
    final repository = _FakeLearnLensRepository(
      conversations: sampleConversations(),
    );
    await tester.pumpWidget(buildSubject(repository: repository));
    await tester.pumpAndSettle();
    final container = containerOf(tester);

    await container
        .read(genericAiChatProvider.notifier)
        .selectConversation('chat-1');
    container.read(genericAiChatProvider.notifier).setInitialMessages([
      GenericAiChatMessage(
        id: 'msg-1',
        text: 'Hello',
        isUser: true,
        timestamp: DateTime.now(),
      ),
    ]);
    await tester.pump();

    final newChat = find
        .ancestor(
          of: find.text('New Chat'),
          matching: find.byType(GestureDetector),
        )
        .first;
    expect(tester.getSize(newChat).height, greaterThanOrEqualTo(48.0));

    await tester.tap(find.text('New Chat'));
    await tester.pumpAndSettle();

    final state = container.read(genericAiChatProvider);
    expect(state.currentChatId, isNull);
    expect(state.messages, isEmpty);
    expect(find.byType(AiChatHistoryScreen), findsNothing);
  });

  testWidgets('close button dismisses the drawer without changing the chat', (
    tester,
  ) async {
    final repository = _FakeLearnLensRepository(
      conversations: sampleConversations(),
    );
    await tester.pumpWidget(buildSubject(repository: repository));
    await tester.pumpAndSettle();
    final container = containerOf(tester);

    final close = find.ancestor(
      of: find.byIcon(LucideIcons.x),
      matching: find.byType(AppIconButton),
    );
    expect(tester.getSize(close), const Size(48.0, 48.0));

    await tester.tap(find.byIcon(LucideIcons.x));
    await tester.pumpAndSettle();

    expect(find.byType(AiChatHistoryScreen), findsNothing);
    expect(repository.loadedChatIds, isEmpty);
    expect(container.read(genericAiChatProvider).currentChatId, isNull);
  });

  testWidgets('tapping the scrim dismisses but tapping the drawer does not', (
    tester,
  ) async {
    final repository = _FakeLearnLensRepository(
      conversations: sampleConversations(),
    );
    await tester.pumpWidget(buildSubject(repository: repository));
    await tester.pumpAndSettle();

    final drawer = tester.getRect(find.byKey(drawerKey));

    // Empty space inside the drawer, below the last row.
    await tester.tapAt(Offset(drawer.center.dx, drawer.bottom - 24.0));
    await tester.pumpAndSettle();
    expect(find.byType(AiChatHistoryScreen), findsOneWidget);

    await tester.tapAt(Offset(drawer.right + 40.0, drawer.center.dy));
    await tester.pumpAndSettle();
    expect(find.byType(AiChatHistoryScreen), findsNothing);
  });

  testWidgets('shows the empty message when there are no conversations', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(repository: _FakeLearnLensRepository()),
    );
    await tester.pumpAndSettle();

    expect(find.text('No conversations yet'), findsOneWidget);
    expect(find.byIcon(LucideIcons.history), findsOneWidget);
    // The header actions stay available.
    expect(find.text('New Chat'), findsOneWidget);
    expect(find.byIcon(LucideIcons.x), findsOneWidget);
  });

  testWidgets('shows an error view and recovers on retry', (tester) async {
    final repository = _FakeLearnLensRepository(
      conversations: sampleConversations(),
    )..failListConversations = true;
    await tester.pumpWidget(buildSubject(repository: repository));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(AppErrorView), findsOneWidget);
    expect(find.text("Explain Newton's Laws of Motion"), findsNothing);

    repository.failListConversations = false;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.byType(AppErrorView), findsNothing);
    expect(find.text("Explain Newton's Laws of Motion"), findsOneWidget);
  });

  testWidgets('slides in from the start edge when opened', (tester) async {
    final router = buildRouter(initialLocation: '/ai');
    await tester.pumpWidget(
      buildSubject(
        repository: _FakeLearnLensRepository(
          conversations: sampleConversations(),
        ),
        router: router,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(AiChatHistoryScreen), findsNothing);

    unawaited(router.push('/ai/history'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1));

    // Mid-transition the drawer is still partly off-screen.
    expect(tester.getRect(find.byKey(drawerKey)).left, lessThan(0.0));

    await tester.pumpAndSettle();
    expect(tester.getRect(find.byKey(drawerKey)).left, 0.0);
  });

  testWidgets('appears in place without sliding when motion is reduced', (
    tester,
  ) async {
    final router = buildRouter(initialLocation: '/ai');
    await tester.pumpWidget(
      buildSubject(
        repository: _FakeLearnLensRepository(
          conversations: sampleConversations(),
        ),
        router: router,
        reducedMotion: true,
      ),
    );
    await tester.pumpAndSettle();

    unawaited(router.push('/ai/history'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1));

    expect(tester.getRect(find.byKey(drawerKey)).left, 0.0);

    await tester.pumpAndSettle();
  });

  group('Conversation deletion', () {
    testWidgets(
      'renders options icon (3-dots) for each history item with accessible semantics',
      (tester) async {
        await tester.pumpWidget(
          buildSubject(
            repository: _FakeLearnLensRepository(
              conversations: sampleConversations(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(LucideIcons.moreVertical), findsNWidgets(2));
        expect(
          find.bySemanticsLabel(
            "More actions: Explain Newton's Laws of Motion",
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'tapping options icon shows action sheet and cancelling keeps item',
      (tester) async {
        final repo = _FakeLearnLensRepository(
          conversations: sampleConversations(),
        );
        await tester.pumpWidget(buildSubject(repository: repo));
        await tester.pumpAndSettle();

        final firstOptionsButton = find.byIcon(LucideIcons.moreVertical).first;
        await tester.tap(firstOptionsButton);
        await tester.pumpAndSettle();

        expect(find.text('Delete'), findsOneWidget);

        // Tap Delete in options sheet
        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();

        expect(find.text('Delete conversation?'), findsOneWidget);
        expect(
          find.text(
            'Are you sure you want to delete "Explain Newton\'s Laws of Motion"? This action cannot be undone.',
          ),
          findsOneWidget,
        );

        // Tap Cancel
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(find.text('Delete conversation?'), findsNothing);
        expect(find.text("Explain Newton's Laws of Motion"), findsOneWidget);
        expect(repo.deletedChatIds, isEmpty);
      },
    );

    testWidgets(
      'confirming deletion via options sheet calls repository and removes conversation item',
      (tester) async {
        final repo = _FakeLearnLensRepository(
          conversations: sampleConversations(),
        );
        await tester.pumpWidget(buildSubject(repository: repo));
        await tester.pumpAndSettle();

        final firstOptionsButton = find.byIcon(LucideIcons.moreVertical).first;
        await tester.tap(firstOptionsButton);
        await tester.pumpAndSettle();

        // Tap Delete in options sheet
        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();

        // Tap Delete in confirmation dialog
        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();
        await tester.pump(const Duration(seconds: 3));

        expect(repo.deletedChatIds, ['chat-1']);
        expect(find.text("Explain Newton's Laws of Motion"), findsNothing);
        expect(find.text('Organic Chemistry Reactions'), findsOneWidget);
      },
    );

    testWidgets(
      'tapping delete when active conversation is generating does not show confirmation dialog',
      (tester) async {
        final repo = _FakeLearnLensRepository(
          conversations: sampleConversations(),
        );
        final followUpCompleter = Completer<AiChatTurnResponseDto>();
        repo.followUpCompleter = followUpCompleter;

        await tester.pumpWidget(buildSubject(repository: repo));
        await tester.pumpAndSettle();

        final container = containerOf(tester);
        final notifier = container.read(genericAiChatProvider.notifier);
        notifier.useStreaming = false;
        await notifier.selectConversation('chat-1');

        // Put active conversation into generating state
        unawaited(notifier.sendMessage('Explain Newton laws in detail'));
        await tester.pump();

        final firstOptionsButton = find.byIcon(LucideIcons.moreVertical).first;
        await tester.tap(firstOptionsButton);
        await tester.pumpAndSettle();

        await tester.tap(find.text('Delete'));
        await tester.pump();

        expect(find.text('Delete conversation?'), findsNothing);
        expect(repo.deletedChatIds, isEmpty);

        // Resolve in-flight turn and drain toast timers/animations
        followUpCompleter.complete(
          AiChatTurnResponseDto(
            chatId: 'chat-1',
            title: "Explain Newton's Laws of Motion",
            generation: AiGenerationDto(
              requestId: 'req-1',
              generationId: 'gen-1',
              userMessageId: 'user-msg-1',
              status: 'completed',
              createdAt: DateTime.now(),
            ),
          ),
        );
        await tester.pump(const Duration(seconds: 4));
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'options button is visually disabled and non-interactive while deletion is in flight',
      (tester) async {
        final repo = _FakeLearnLensRepository(
          conversations: sampleConversations(),
        );
        repo.deleteCompleter = Completer<void>();

        await tester.pumpWidget(buildSubject(repository: repo));
        await tester.pumpAndSettle();

        final firstOptionsButton = find.byIcon(LucideIcons.moreVertical).first;
        await tester.tap(firstOptionsButton);
        await tester.pumpAndSettle();

        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();

        // Tap Delete in confirmation dialog to start in-flight delete
        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();

        final opacityFinder = find.ancestor(
          of: find.byIcon(LucideIcons.moreVertical).first,
          matching: find.byType(Opacity),
        );
        expect(tester.widget<Opacity>(opacityFinder).opacity, 0.35);

        final secondOptionsButton = find.byIcon(LucideIcons.moreVertical).last;
        await tester.tap(secondOptionsButton);
        await tester.pump();
        expect(find.text('Delete'), findsNothing);

        repo.deleteCompleter!.complete();
        await tester.pumpAndSettle();
        await tester.pump(const Duration(seconds: 3));

        expect(repo.deletedChatIds, ['chat-1']);
      },
    );

    testWidgets(
      'renders month and year headers for older conversations across locales without throwing',
      (tester) async {
        final now = DateTime.now();
        final olderHistory = [
          AiConversationDto(
            chatId: 'chat-old-1',
            title: 'Chat from earlier this year',
            updatedAt: DateTime(now.year, now.month > 2 ? now.month - 2 : 1, 1),
          ),
          AiConversationDto(
            chatId: 'chat-old-2',
            title: 'Chat from previous year',
            updatedAt: DateTime(now.year - 1, 6, 15),
          ),
        ];

        for (final locale in const [
          Locale('en'),
          Locale('ar'),
          Locale('ta'),
          Locale('ml'),
        ]) {
          final repo = _FakeLearnLensRepository(conversations: olderHistory);
          await tester.pumpWidget(
            buildSubject(repository: repo, locale: locale),
          );
          await tester.pumpAndSettle();

          expect(find.byType(AiChatHistoryScreen), findsOneWidget);
          expect(find.text('Chat from earlier this year'), findsOneWidget);
          expect(find.text('Chat from previous year'), findsOneWidget);
        }
      },
    );

    testWidgets('marks active new chat button as selected in semantics', (
      tester,
    ) async {
      final repository = _FakeLearnLensRepository(
        conversations: sampleConversations(),
      );
      await tester.pumpWidget(buildSubject(repository: repository));
      await tester.pumpAndSettle();

      final newChatSemantics = find.bySemanticsLabel('Start new chat');
      expect(
        tester.getSemantics(newChatSemantics),
        matchesSemantics(
          label: 'Start new chat',
          isButton: true,
          hasEnabledState: true,
          isEnabled: true,
          hasSelectedState: true,
          isSelected: true,
          hasTapAction: true,
        ),
      );
    });

    testWidgets(
      'marks active history row as selected and new chat button as unselected in semantics',
      (tester) async {
        final conversations = sampleConversations();
        final repository = _FakeLearnLensRepository(
          conversations: conversations,
        );
        final router = buildRouter(initialLocation: '/ai/history');
        await tester.pumpWidget(
          buildSubject(repository: repository, router: router),
        );
        await tester.pumpAndSettle();

        // Select the first conversation, loading it and dismissing the drawer.
        await tester.tap(find.text("Explain Newton's Laws of Motion"));
        await tester.pumpAndSettle();

        // Reopen the drawer while chat-1 is active.
        router.go('/ai/history');
        await tester.pumpAndSettle();

        final newChatSemantics = find.bySemanticsLabel('Start new chat');
        final activeRowSemantics = find.bySemanticsLabel(
          "Open chat: Explain Newton's Laws of Motion",
        );
        final inactiveRowSemantics = find.bySemanticsLabel(
          'Open chat: Organic Chemistry Reactions',
        );

        expect(
          tester.getSemantics(newChatSemantics),
          matchesSemantics(
            label: 'Start new chat',
            isButton: true,
            hasEnabledState: true,
            isEnabled: true,
            hasSelectedState: true,
            isSelected: false,
            hasTapAction: true,
          ),
        );

        expect(
          tester.getSemantics(activeRowSemantics),
          matchesSemantics(
            label: "Open chat: Explain Newton's Laws of Motion",
            isButton: true,
            hasEnabledState: true,
            isEnabled: true,
            hasSelectedState: true,
            isSelected: true,
            hasTapAction: true,
          ),
        );

        expect(
          tester.getSemantics(inactiveRowSemantics),
          matchesSemantics(
            label: 'Open chat: Organic Chemistry Reactions',
            isButton: true,
            hasEnabledState: true,
            isEnabled: true,
            hasSelectedState: true,
            isSelected: false,
            hasTapAction: true,
          ),
        );
      },
    );
  });
}
