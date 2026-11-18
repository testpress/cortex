import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('buildHistorySections', () {
    final fixedNow = DateTime(2026, 11, 18, 14, 30);

    test('returns empty list when input is empty', () {
      final sections = buildHistorySections(conversations: [], now: fixedNow);
      expect(sections, isEmpty);
    });

    test(
      'correctly buckets conversations into Today, Yesterday, Previous 7 days, and Months',
      () {
        final conversations = [
          AiConversationDto(
            chatId: 'c1',
            title: 'Today 10 AM',
            updatedAt: DateTime(2026, 11, 18, 10, 0),
          ),
          AiConversationDto(
            chatId: 'c2',
            title: 'Today 1 AM',
            updatedAt: DateTime(2026, 11, 18, 1, 0),
          ),
          AiConversationDto(
            chatId: 'c3',
            title: 'Yesterday 11 PM',
            updatedAt: DateTime(2026, 11, 17, 23, 0),
          ),
          AiConversationDto(
            chatId: 'c4',
            title: 'Yesterday 8 AM',
            updatedAt: DateTime(2026, 11, 17, 8, 0),
          ),
          AiConversationDto(
            chatId: 'c5',
            title: '4 Days Ago',
            updatedAt: DateTime(2026, 11, 14, 12, 0),
          ),
          AiConversationDto(
            chatId: 'c6',
            title: '7 Days Ago Midnight',
            updatedAt: DateTime(2026, 11, 11, 0, 0),
          ),
          AiConversationDto(
            chatId: 'c7',
            title: '8 Days Ago',
            updatedAt: DateTime(2026, 11, 10, 15, 0),
          ),
          AiConversationDto(
            chatId: 'c8',
            title: 'October Chat',
            updatedAt: DateTime(2026, 10, 25, 9, 0),
          ),
          AiConversationDto(
            chatId: 'c9',
            title: 'Last Year Chat',
            updatedAt: DateTime(2025, 12, 1, 10, 0),
          ),
        ];

        final sections = buildHistorySections(
          conversations: conversations,
          now: fixedNow,
        );

        expect(sections.length, 6);

        expect(sections[0].type, HistorySectionType.today);
        expect(sections[0].items.map((e) => e.chatId), ['c1', 'c2']);

        expect(sections[1].type, HistorySectionType.yesterday);
        expect(sections[1].items.map((e) => e.chatId), ['c3', 'c4']);

        expect(sections[2].type, HistorySectionType.previous7Days);
        expect(sections[2].items.map((e) => e.chatId), ['c5', 'c6']);

        expect(sections[3].type, HistorySectionType.monthYear);
        expect(sections[3].year, 2026);
        expect(sections[3].month, 11);
        expect(sections[3].items.map((e) => e.chatId), ['c7']);

        expect(sections[4].type, HistorySectionType.monthYear);
        expect(sections[4].year, 2026);
        expect(sections[4].month, 10);
        expect(sections[4].items.map((e) => e.chatId), ['c8']);

        expect(sections[5].type, HistorySectionType.monthYear);
        expect(sections[5].year, 2025);
        expect(sections[5].month, 12);
        expect(sections[5].items.map((e) => e.chatId), ['c9']);
      },
    );

    test('suppresses empty section categories', () {
      final conversations = [
        AiConversationDto(
          chatId: 'c1',
          title: 'Only Yesterday Chat',
          updatedAt: DateTime(2026, 11, 17, 10, 0),
        ),
      ];

      final sections = buildHistorySections(
        conversations: conversations,
        now: fixedNow,
      );

      expect(sections.length, 1);
      expect(sections.first.type, HistorySectionType.yesterday);
      expect(sections.first.items.first.chatId, 'c1');
    });

    test(
      'treats null updatedAt as current moment and lands at top of Today',
      () {
        final conversations = [
          AiConversationDto(
            chatId: 'c-old',
            title: 'Older Today Chat',
            updatedAt: DateTime(2026, 11, 18, 9, 0),
          ),
          const AiConversationDto(
            chatId: 'c-draft',
            title: 'Draft with null updatedAt',
            updatedAt: null,
          ),
        ];

        final sections = buildHistorySections(
          conversations: conversations,
          now: fixedNow,
        );

        expect(sections.length, 1);
        expect(sections.first.type, HistorySectionType.today);
        expect(sections.first.items.first.chatId, 'c-draft');
        expect(sections.first.items.last.chatId, 'c-old');
      },
    );

    test('tie-breaks stably by chatId when timestamps are equal', () {
      final conversations = [
        const AiConversationDto(chatId: 'z-draft', updatedAt: null),
        const AiConversationDto(chatId: 'a-draft', updatedAt: null),
      ];

      final sections = buildHistorySections(
        conversations: conversations,
        now: fixedNow,
      );

      expect(sections.first.items.map((e) => e.chatId), ['a-draft', 'z-draft']);
    });

    test(
      'handles month and year rollover correctly around midnight and new year',
      () {
        final newYearNow = DateTime(2027, 1, 1, 0, 5);

        final conversations = [
          AiConversationDto(
            chatId: 'c-today',
            title: 'New Year Day',
            updatedAt: DateTime(2027, 1, 1, 0, 1),
          ),
          AiConversationDto(
            chatId: 'c-yest',
            title: 'New Year Eve',
            updatedAt: DateTime(2026, 12, 31, 23, 50),
          ),
          AiConversationDto(
            chatId: 'c-prev',
            title: 'Dec 28',
            updatedAt: DateTime(2026, 12, 28, 12, 0),
          ),
        ];

        final sections = buildHistorySections(
          conversations: conversations,
          now: newYearNow,
        );

        expect(sections.length, 3);
        expect(sections[0].type, HistorySectionType.today);
        expect(sections[1].type, HistorySectionType.yesterday);
        expect(sections[2].type, HistorySectionType.previous7Days);
      },
    );
  });
}
