/// DTO representing a standard DRF paginated response from the Testpress API.
///
/// The API always returns:
/// ```json
/// {
///   "count": 42,
///   "next": "https://.../?page=2",
///   "previous": null,
///   "results": [ ... ]
/// }
/// ```
class PaginatedResponseDto<T> {
  final List<T> results;
  final String? next;
  final String? previous;
  final int count;

  PaginatedResponseDto({
    required this.results,
    this.next,
    this.previous,
    this.count = 0,
  });

  factory PaginatedResponseDto.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    var rawResults = json['results'];

    // Testpress Quirk: Sometimes 'results' is a Map with a nested List (e.g. 'courses') and a 'tags' list.
    if (rawResults is Map<String, dynamic>) {
      rawResults = _resolveTags(rawResults);
    }

    final rawList = rawResults is List ? rawResults : const <dynamic>[];
    final safeItems = rawList
        .whereType<Map>()
        .map((e) => e.map((k, v) => MapEntry(k.toString(), v)))
        .toList();

    return PaginatedResponseDto<T>(
      results: safeItems.map((e) => fromJsonT(e)).toList(),
      next: _asNullableString(json['next']),
      previous: _asNullableString(json['previous']),
      count: _asNullableInt(json['count']) ?? safeItems.length,
    );
  }

  static String? _asNullableString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }

  static int? _asNullableInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static List<dynamic> _resolveTags(Map<String, dynamic> results) {
    final tagsList = results['tags'] as List<dynamic>? ?? [];
    final tagMap = <int, String>{};
    for (final t in tagsList.whereType<Map>()) {
      final idRaw = t['id'];
      final nameRaw = t['name'];
      final id = idRaw is int
          ? idRaw
          : (idRaw is String ? int.tryParse(idRaw) : null);
      final name = nameRaw?.toString();
      if (id != null && name != null && name.isNotEmpty) {
        tagMap[id] = name;
      }
    }

    // Prefer the known Testpress payload key.
    List<dynamic> nestedList;
    final courses = results['courses'];
    if (courses is List<dynamic>) {
      nestedList = courses;
    } else {
      // Defensive fallback: pick a non-tags list that looks like a course list.
      nestedList = results.values.whereType<List<dynamic>>().firstWhere((list) {
        if (identical(list, tagsList) || list.isEmpty) return false;
        final first = list.first;
        if (first is! Map<String, dynamic>) return false;
        return first.containsKey('id') &&
            first.containsKey('title') &&
            first.containsKey('tag_ids');
      }, orElse: () => <dynamic>[]);
    }

    if (tagMap.isNotEmpty) {
      for (final item in nestedList.whereType<Map<String, dynamic>>()) {
        final tagIds = item['tag_ids'] as List<dynamic>? ?? [];
        item['tags'] = tagIds
            .map((id) => tagMap[id])
            .whereType<String>()
            .toList();
      }
    }
    return nestedList;
  }
}
