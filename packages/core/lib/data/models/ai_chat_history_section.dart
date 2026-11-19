import 'learnlens_dto.dart';

enum HistorySectionType { today, yesterday, previous7Days, monthYear }

class AiChatHistorySection {
  const AiChatHistorySection({
    required this.type,
    required this.items,
    this.year,
    this.month,
  });

  final HistorySectionType type;
  final List<AiConversationDto> items;
  final int? year;
  final int? month;
}

List<AiChatHistorySection> buildHistorySections({
  required List<AiConversationDto> conversations,
  required DateTime now,
}) {
  if (conversations.isEmpty) return const [];

  final boundaries = _HistoryBoundaries(now.toLocal());
  final sorted = _sortConversations(conversations, boundaries.now);
  final buckets = _bucketConversations(sorted, boundaries);

  return _assembleSections(buckets);
}

class _HistoryBoundaries {
  _HistoryBoundaries(this.now)
    : today = DateTime(now.year, now.month, now.day),
      yesterday = DateTime(now.year, now.month, now.day - 1),
      sevenDaysCutoff = DateTime(now.year, now.month, now.day - 7);

  final DateTime now;
  final DateTime today;
  final DateTime yesterday;
  final DateTime sevenDaysCutoff;
}

class _HistoryBuckets {
  final List<AiConversationDto> today = [];
  final List<AiConversationDto> yesterday = [];
  final List<AiConversationDto> previous7Days = [];
  final Map<DateTime, List<AiConversationDto>> months = {};
}

List<AiConversationDto> _sortConversations(
  List<AiConversationDto> items,
  DateTime fallbackNow,
) {
  return List<AiConversationDto>.of(items)..sort((a, b) {
    final dateA = a.updatedAt?.toLocal() ?? fallbackNow;
    final dateB = b.updatedAt?.toLocal() ?? fallbackNow;
    final cmp = dateB.compareTo(dateA);
    if (cmp != 0) return cmp;
    return a.chatId.compareTo(b.chatId);
  });
}

_HistoryBuckets _bucketConversations(
  List<AiConversationDto> sorted,
  _HistoryBoundaries boundaries,
) {
  final buckets = _HistoryBuckets();

  for (final item in sorted) {
    final itemDate = item.updatedAt?.toLocal() ?? boundaries.now;

    if (!itemDate.isBefore(boundaries.today)) {
      buckets.today.add(item);
    } else if (!itemDate.isBefore(boundaries.yesterday)) {
      buckets.yesterday.add(item);
    } else if (!itemDate.isBefore(boundaries.sevenDaysCutoff)) {
      buckets.previous7Days.add(item);
    } else {
      final monthKey = DateTime(itemDate.year, itemDate.month);
      buckets.months.putIfAbsent(monthKey, () => []).add(item);
    }
  }

  return buckets;
}

List<AiChatHistorySection> _assembleSections(_HistoryBuckets buckets) {
  final sections = <AiChatHistorySection>[];

  if (buckets.today.isNotEmpty) {
    sections.add(
      AiChatHistorySection(
        type: HistorySectionType.today,
        items: List.unmodifiable(buckets.today),
      ),
    );
  }
  if (buckets.yesterday.isNotEmpty) {
    sections.add(
      AiChatHistorySection(
        type: HistorySectionType.yesterday,
        items: List.unmodifiable(buckets.yesterday),
      ),
    );
  }
  if (buckets.previous7Days.isNotEmpty) {
    sections.add(
      AiChatHistorySection(
        type: HistorySectionType.previous7Days,
        items: List.unmodifiable(buckets.previous7Days),
      ),
    );
  }

  final sortedMonths = buckets.months.keys.toList()
    ..sort((a, b) => b.compareTo(a));

  for (final monthKey in sortedMonths) {
    sections.add(
      AiChatHistorySection(
        type: HistorySectionType.monthYear,
        year: monthKey.year,
        month: monthKey.month,
        items: List.unmodifiable(buckets.months[monthKey]!),
      ),
    );
  }

  return List.unmodifiable(sections);
}
