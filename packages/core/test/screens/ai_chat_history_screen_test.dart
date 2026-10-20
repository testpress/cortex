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

  @override
  AiChatPolicyDto? get policy =>
      const AiChatPolicyDto(maxMessageCharacters: 4000);

  @override
  Future<void> ensureGenericChatSession() async {}

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
}

void main() {
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
              locale: const Locale('en'),
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

  testWidgets('lists each conversation with its title and relative time', (
    tester,
  ) async {
    final repository = _FakeLearnLensRepository(
      conversations: sampleConversations(),
    );
    await tester.pumpWidget(buildSubject(repository: repository));
    await tester.pumpAndSettle();

    expect(find.text("Explain Newton's Laws of Motion"), findsOneWidget);
    expect(find.text('2 hrs ago'), findsOneWidget);
    expect(find.text('Organic Chemistry Reactions'), findsOneWidget);
    expect(find.text('2 days ago'), findsOneWidget);

    // Subject chips are intentionally left out of the history rows.
    expect(find.byType(AppSubjectChip), findsNothing);
    expect(find.byType(AppChip), findsNothing);
    expect(find.byType(AppBadge), findsNothing);

    // The time sits under the title, and rows keep a 48dp touch target.
    final title = tester.getRect(find.text("Explain Newton's Laws of Motion"));
    final time = tester.getRect(find.text('2 hrs ago'));
    expect(time.top, greaterThanOrEqualTo(title.bottom));
    expect(time.left, title.left);

    final row = find
        .ancestor(
          of: find.text("Explain Newton's Laws of Motion"),
          matching: find.byType(GestureDetector),
        )
        .first;
    expect(tester.getSize(row).height, greaterThanOrEqualTo(48.0));
    expect(
      tester.getSize(row).width,
      tester.getSize(find.byKey(drawerKey)).width,
    );
  });

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
    expect(find.text('just now'), findsOneWidget);
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
}
