import 'package:core/core.dart';
import 'package:core/data/repositories/learnlens_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testpress/navigation/routes/ai_routes.dart';

class _FakeLearnLensRepository extends Fake implements LearnLensRepository {
  @override
  AiChatPolicyDto? get policy =>
      const AiChatPolicyDto(maxMessageCharacters: 4000);

  @override
  Future<AiConversationListDto> listConversations({
    int limit = 20,
    String? cursor,
  }) async => const AiConversationListDto(items: []);
}

void main() {
  setUpAll(() async {
    await LocalizationProvider.initializeDateFormatting();
  });

  Widget buildTestApp({required GoRouter router}) {
    return ProviderScope(
      overrides: [
        learnLensRepositoryProvider.overrideWithValue(
          _FakeLearnLensRepository(),
        ),
      ],
      child: DesignProvider(
        config: DesignConfig.defaults(),
        child: LocalizationProvider(
          child: Builder(
            builder: (context) {
              final locale = LocalizationProvider.of(context).locale;
              return WidgetsApp.router(
                color: const Color(0xFF000000),
                routerConfig: router,
                locale: locale,
                localizationsDelegates: LocalizationProvider.delegates,
              );
            },
          ),
        ),
      ),
    );
  }

  group('AiRoutes /ai/history extra parameter handling', () {
    testWidgets('handles non-String Map extra safely without TypeError', (
      tester,
    ) async {
      final rootNavigatorKey = GlobalKey<NavigatorState>();
      final router = GoRouter(
        navigatorKey: rootNavigatorKey,
        initialLocation: '/ai',
        routes: AiRoutes.routes(rootNavigatorKey),
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(buildTestApp(router: router));
      await tester.pumpAndSettle();

      router.push('/ai/history', extra: {'some': 'object'});
      await tester.pumpAndSettle();

      expect(find.byType(AiChatHistoryScreen), findsOneWidget);
      final screen = tester.widget<AiChatHistoryScreen>(
        find.byType(AiChatHistoryScreen),
      );
      expect(screen.initialRenamingChatId, isNull);
    });

    testWidgets('handles non-String int extra safely without TypeError', (
      tester,
    ) async {
      final rootNavigatorKey = GlobalKey<NavigatorState>();
      final router = GoRouter(
        navigatorKey: rootNavigatorKey,
        initialLocation: '/ai',
        routes: AiRoutes.routes(rootNavigatorKey),
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(buildTestApp(router: router));
      await tester.pumpAndSettle();

      router.push('/ai/history', extra: 12345);
      await tester.pumpAndSettle();

      expect(find.byType(AiChatHistoryScreen), findsOneWidget);
      final screen = tester.widget<AiChatHistoryScreen>(
        find.byType(AiChatHistoryScreen),
      );
      expect(screen.initialRenamingChatId, isNull);
    });

    testWidgets('passes String extra as initialRenamingChatId', (tester) async {
      final rootNavigatorKey = GlobalKey<NavigatorState>();
      final router = GoRouter(
        navigatorKey: rootNavigatorKey,
        initialLocation: '/ai',
        routes: AiRoutes.routes(rootNavigatorKey),
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(buildTestApp(router: router));
      await tester.pumpAndSettle();

      router.push('/ai/history', extra: 'chat-456');
      await tester.pumpAndSettle();

      expect(find.byType(AiChatHistoryScreen), findsOneWidget);
      final screen = tester.widget<AiChatHistoryScreen>(
        find.byType(AiChatHistoryScreen),
      );
      expect(screen.initialRenamingChatId, 'chat-456');
    });

    testWidgets('query parameter takes precedence over null extra', (
      tester,
    ) async {
      final rootNavigatorKey = GlobalKey<NavigatorState>();
      final router = GoRouter(
        navigatorKey: rootNavigatorKey,
        initialLocation: '/ai',
        routes: AiRoutes.routes(rootNavigatorKey),
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(buildTestApp(router: router));
      await tester.pumpAndSettle();

      router.push('/ai/history?rename=chat-789');
      await tester.pumpAndSettle();

      expect(find.byType(AiChatHistoryScreen), findsOneWidget);
      final screen = tester.widget<AiChatHistoryScreen>(
        find.byType(AiChatHistoryScreen),
      );
      expect(screen.initialRenamingChatId, 'chat-789');
    });
  });
}
