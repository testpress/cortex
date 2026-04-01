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

    // Testpress Quirk: Sometimes 'results' is a Map with a nested List (e.g. 'courses').
    if (rawResults is Map<String, dynamic>) {
      final nestedList = rawResults.values.firstWhere(
        (v) => v is List,
        orElse: () => <dynamic>[],
      );
      rawResults = nestedList;
    }

    final rawList = rawResults as List<dynamic>? ?? [];

    return PaginatedResponseDto<T>(
      results: rawList.map((e) => fromJsonT(e as Map<String, dynamic>)).toList(),
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      count: (json['count'] as int?) ?? rawList.length,
    );
  }
}
