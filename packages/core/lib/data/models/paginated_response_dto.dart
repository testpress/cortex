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
    // 1. Find the raw data (standard DRF or Testpress 'courses' key)
    var rawData = json['results'] ?? json['courses'] ?? json;

    // 2. Testpress Quirk: Sometimes 'results' is a Map that *contains* the list.
    // If we found a Map, look one level deeper for a List.
    if (rawData is Map<String, dynamic>) {
      rawData = rawData['courses'] ?? rawData['results'] ?? rawData;
    }

    // 3. Ensure we actually have a List before trying to map it
    final List<dynamic> rawList = rawData is List ? rawData : [];

    return PaginatedResponseDto<T>(
      results: rawList
          .map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList(),
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      count: (json['count'] as int?) ?? rawList.length,
    );
  }
}
