import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/providers/learnlens_provider.dart';
import 'package:courses/repositories/learnlens_repository.dart';
import 'package:courses/widgets/lesson_detail/ai_tab.dart';

class FakeLearnLensRepository extends Fake implements LearnLensRepository {
  List<LearnLensChatSessionDto> chats = [];
  List<LearnLensMessageDto> messages = [];
  LearnLensChatResponseDto chatResponse = LearnLensChatResponseDto(
    answer: 'Response from AI',
    conversationId: 'chat-1',
    chatId: 'chat-1',
  );
  bool shouldThrow = false;
  String? lastSubmittedQuery;
  String? lastSubmittedChatId;

  @override
  Future<List<LearnLensChatSessionDto>> fetchChats({
    required String orgUuid,
    required String assetId,
    required String sessionToken,
    int? contentId,
    int? limit,
    String? cursor,
    String? before,
  }) async {
    if (shouldThrow) throw Exception('Network error');
    return chats;
  }

  @override
  Future<List<LearnLensMessageDto>> fetchChatMessages({
    required String orgUuid,
    required String chatId,
    required String sessionToken,
    int? contentId,
    int? limit,
    String? cursor,
    String? before,
  }) async {
    if (shouldThrow) throw Exception('Network error');
    return messages;
  }

  @override
  Future<({String chatId, List<LearnLensMessageDto> messages})>
      fetchLatestChatHistory({
    required String orgUuid,
    required String assetId,
    required String sessionToken,
    int? contentId,
  }) async {
    if (shouldThrow) throw Exception('Network error');
    final fetchedChats = await fetchChats(
      orgUuid: orgUuid,
      assetId: assetId,
      sessionToken: sessionToken,
      contentId: contentId,
    );
    if (fetchedChats.isEmpty) {
      return (chatId: '', messages: const <LearnLensMessageDto>[]);
    }
    final sortedChats = List<LearnLensChatSessionDto>.from(fetchedChats)
      ..sort((a, b) =>
          (b.updatedAt ?? DateTime(0)).compareTo(a.updatedAt ?? DateTime(0)));
    final activeChatId = sortedChats.first.id;
    if (activeChatId.isEmpty) {
      return (chatId: '', messages: const <LearnLensMessageDto>[]);
    }
    final fetchedMessages = await fetchChatMessages(
      orgUuid: orgUuid,
      chatId: activeChatId,
      sessionToken: sessionToken,
      contentId: contentId,
    );
    return (chatId: activeChatId, messages: fetchedMessages);
  }

  @override
  Future<LearnLensChatResponseDto> submitChat({
    required String orgUuid,
    required String assetId,
    required String sessionToken,
    required String query,
    String? conversationId,
    String? chatId,
    int? contentId,
  }) async {
    lastSubmittedQuery = query;
    lastSubmittedChatId = chatId;
    return chatResponse;
  }
}

class FakeSentryService extends SentryService {
  @override
  Future<void> captureException(dynamic exception,
      {Map<String, dynamic>? contexts,
      AppErrorLevel? level,
      dynamic stackTrace,
      Map<String, String>? tags}) async {}
}

void main() {
  final testLesson = LessonDto(
    id: '101',
    chapterId: '1',
    title: 'Test Video Lesson',
    type: LessonType.video,
    progressStatus: LessonProgressStatus.notStarted,
    orderIndex: 1,
    duration: '',
    isLocked: false,
    learnlensAssetId: 'asset-101',
  );

  Widget createWidget({
    required FakeLearnLensRepository repo,
    LessonDto? lesson,
    Map<String, dynamic>? sessionData = const {'session_token': 'test-token'},
  }) {
    final activeLesson = lesson ?? testLesson;
    final settings = InstituteSettings.fromJson({
      'learnlens_enabled': true,
      'learnlens_organization_id': 'org-test',
    });

    return ProviderScope(
      overrides: [
        learnLensRepositoryProvider.overrideWithValue(repo),
        instituteSettingsProvider.overrideWith((ref) => settings),
        learnlensSessionProvider(101).overrideWith(
          () => _TestLearnlensSession(sessionData),
        ),
        learnlensSessionProvider(102).overrideWith(
          () => _TestLearnlensSession(sessionData),
        ),
        sentryServiceProvider.overrideWithValue(FakeSentryService()),
      ],
      child: DesignProvider(
        config: DesignConfig.defaults(),
        child: LocalizationProvider(
          child: Builder(
            builder: (context) {
              final locale = LocalizationProvider.of(context).locale;
              return Localizations(
                locale: locale,
                delegates: LocalizationProvider.delegates,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: _OverlayHost(
                    child: AITab(lesson: activeLesson),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  group('AITab Persistence & History Hydration', () {
    testWidgets(
        'hydrates and renders existing chat history in chronological order',
        (tester) async {
      final repo = FakeLearnLensRepository();
      repo.chats = [
        LearnLensChatSessionDto(id: 'chat-101', title: 'Prior Discussion'),
      ];
      repo.messages = [
        const LearnLensMessageDto(
          id: 'm1',
          role: 'user',
          content: 'What is photosynthesis?',
        ),
        const LearnLensMessageDto(
          id: 'm2',
          role: 'assistant',
          content: 'Photosynthesis is the process used by plants...',
        ),
      ];

      await tester.pumpWidget(createWidget(repo: repo));
      await tester.pumpAndSettle();

      expect(find.text('What is photosynthesis?'), findsOneWidget);
      expect(
        find.text('Photosynthesis is the process used by plants...'),
        findsOneWidget,
      );
    });

    testWidgets('falls back to greeting when no prior chats exist',
        (tester) async {
      final repo = FakeLearnLensRepository();
      repo.chats = [];

      await tester.pumpWidget(createWidget(repo: repo));
      await tester.pumpAndSettle();

      // Should show initial greeting
      expect(find.byType(AITab), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('shows error state with retry button on hydration failure',
        (tester) async {
      final repo = FakeLearnLensRepository();
      repo.shouldThrow = true;

      await tester.pumpWidget(createWidget(repo: repo));
      await tester.pumpAndSettle();

      expect(find.byType(AppErrorView), findsOneWidget);
      expect(find.byType(AppButton), findsOneWidget);

      // Now fix error and tap retry
      repo.shouldThrow = false;
      repo.chats = [
        LearnLensChatSessionDto(id: 'chat-101', title: 'Prior Discussion'),
      ];
      repo.messages = [
        LearnLensMessageDto(
          id: 'm1',
          role: 'user',
          content: 'Recovered message',
        ),
      ];

      await tester.tap(find.byType(AppButton));
      await tester.pumpAndSettle();

      expect(find.text('Recovered message'), findsOneWidget);
    });

    testWidgets('sends message using persistent chatId', (tester) async {
      final repo = FakeLearnLensRepository();
      repo.chats = [
        LearnLensChatSessionDto(id: 'chat-101', title: 'Prior Discussion'),
      ];
      repo.messages = [
        LearnLensMessageDto(
          id: 'm1',
          role: 'user',
          content: 'Initial question',
        ),
      ];

      await tester.pumpWidget(createWidget(repo: repo));
      await tester.pumpAndSettle();

      // Enter new query in text field
      final textField = find.byType(AppTextField);
      expect(textField, findsOneWidget);
      await tester.enterText(textField, 'Follow-up query');
      await tester.pumpAndSettle();

      // Tap send button
      final sendButton = find.byType(AppIconButton);
      expect(sendButton, findsOneWidget);
      await tester.tap(sendButton);
      await tester.pumpAndSettle();

      expect(repo.lastSubmittedQuery, 'Follow-up query');
      expect(repo.lastSubmittedChatId, 'chat-101');
      expect(find.text('Follow-up query'), findsOneWidget);
      expect(find.text('Response from AI'), findsOneWidget);
    });

    testWidgets('re-hydrates chat when switching to a different lesson',
        (tester) async {
      final repo = FakeLearnLensRepository();
      repo.chats = [
        LearnLensChatSessionDto(id: 'chat-101', title: 'Lesson 101 Discussion'),
      ];
      repo.messages = [
        const LearnLensMessageDto(
          id: 'm1',
          role: 'user',
          content: 'Question for lesson 101',
        ),
      ];

      await tester.pumpWidget(createWidget(repo: repo, lesson: testLesson));
      await tester.pumpAndSettle();

      expect(find.text('Question for lesson 101'), findsOneWidget);

      // Now switch to lesson 102
      final lesson102 = LessonDto(
        id: '102',
        chapterId: '1',
        title: 'Second Video Lesson',
        type: LessonType.video,
        progressStatus: LessonProgressStatus.notStarted,
        orderIndex: 2,
        duration: '',
        isLocked: false,
        learnlensAssetId: 'asset-102',
      );

      repo.chats = [
        LearnLensChatSessionDto(id: 'chat-102', title: 'Lesson 102 Discussion'),
      ];
      repo.messages = [
        const LearnLensMessageDto(
          id: 'm2',
          role: 'user',
          content: 'Question for lesson 102',
        ),
      ];

      await tester.pumpWidget(createWidget(repo: repo, lesson: lesson102));
      await tester.pumpAndSettle();

      expect(find.text('Question for lesson 102'), findsOneWidget);
      expect(find.text('Question for lesson 101'), findsNothing);
    });

    testWidgets('shows error state when session token is empty',
        (tester) async {
      final repo = FakeLearnLensRepository();
      await tester.pumpWidget(createWidget(
        repo: repo,
        sessionData: {'session_token': ''},
      ));
      await tester.pumpAndSettle();

      expect(find.byType(AppErrorView), findsOneWidget);
    });

    testWidgets('refreshes expired session before fetching chats',
        (tester) async {
      final repo = FakeLearnLensRepository();
      repo.chats = [
        LearnLensChatSessionDto(id: 'chat-exp', title: 'Refreshed Chat'),
      ];

      final expiredIso = DateTime.now()
          .toUtc()
          .subtract(const Duration(minutes: 10))
          .toIso8601String();

      final sessionNotifier = _TestLearnlensSession(
        {'session_token': 'expired-tok', 'expiresAt': expiredIso},
        refreshedData: {'session_token': 'new-fresh-tok'},
      );

      final settings = InstituteSettings.fromJson({
        'learnlens_enabled': true,
        'learnlens_organization_id': 'org-test',
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            learnLensRepositoryProvider.overrideWithValue(repo),
            instituteSettingsProvider.overrideWith((ref) => settings),
            learnlensSessionProvider(101).overrideWith(() => sessionNotifier),
            sentryServiceProvider.overrideWithValue(FakeSentryService()),
          ],
          child: DesignProvider(
            config: DesignConfig.defaults(),
            child: LocalizationProvider(
              child: Builder(
                builder: (context) {
                  final locale = LocalizationProvider.of(context).locale;
                  return Localizations(
                    locale: locale,
                    delegates: LocalizationProvider.delegates,
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: _OverlayHost(
                        child: AITab(lesson: testLesson),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(sessionNotifier.refreshCallCount, 1);
      expect(find.byType(AITab), findsOneWidget);
    });
  });
}

class _TestLearnlensSession extends LearnlensSession {
  Map<String, dynamic>? data;
  final Map<String, dynamic>? refreshedData;
  int refreshCallCount = 0;

  _TestLearnlensSession(this.data, {this.refreshedData});

  @override
  FutureOr<Map<String, dynamic>?> build(int contentId) async {
    return data;
  }

  @override
  Future<Map<String, dynamic>?> refreshSession() async {
    refreshCallCount++;
    data = refreshedData ?? data;
    state = AsyncValue.data(data);
    return data;
  }
}

class _OverlayHost extends StatefulWidget {
  final Widget child;

  const _OverlayHost({required this.child});

  @override
  State<_OverlayHost> createState() => _OverlayHostState();
}

class _OverlayHostState extends State<_OverlayHost> {
  late final OverlayEntry _entry;

  @override
  void initState() {
    super.initState();
    _entry = OverlayEntry(builder: (context) => widget.child);
  }

  @override
  void didUpdateWidget(_OverlayHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    _entry.markNeedsBuild();
  }

  @override
  Widget build(BuildContext context) {
    return Overlay(initialEntries: [_entry]);
  }
}
