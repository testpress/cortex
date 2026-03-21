/// DTO representing a paginated response from the Testpress API.
/// It understands the common structure containing results, next pointers, and counts.
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

  /// Factory to create a PaginatedResponseDto from JSON.
  /// [fromJsonT] is a mapper to convert individual list items.
  factory PaginatedResponseDto.fromJson(
    dynamic json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    // Determine where the list items are located (commonly under 'results')
    final dynamic rawData = (json is Map) ? json['results'] : null;
    List<dynamic> rawList = [];

    if (rawData is List) {
      rawList = rawData;
    } else if (rawData is Map && rawData['courses'] is List) {
      // Handle cases where 'results' contains a 'courses' key (common in some Testpress APIs)
      rawList = rawData['courses'] as List<dynamic>;
    } else if (json is Map && json['courses'] is List) {
      // Handle cases where the list is directly under a specific key (fallout for older APIs)
      rawList = json['courses'] as List<dynamic>;
    } else if (json is List) {
      // Handle cases where the response is a direct list
      rawList = json;
    }

    return PaginatedResponseDto<T>(
      results: rawList.map((e) => fromJsonT(e as Map<String, dynamic>)).toList(),
      next: (json is Map) ? json['next'] as String? : null,
      previous: (json is Map) ? json['previous'] as String? : null,
      count:
          (json is Map) ? (json['count'] ?? rawList.length) as int : rawList.length,
    );
  }
}
