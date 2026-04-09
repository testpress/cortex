import 'package:core/data/models/paginated_response_dto.dart';

/// Represents the progress of a paginated session.
class PaginationState {
  final int nextPage;
  final bool hasMore;

  const PaginationState({
    this.nextPage = 1,
    this.hasMore = true,
  });

  PaginationState copyWith({
    int? nextPage,
    bool? hasMore,
  }) {
    return PaginationState(
      nextPage: nextPage ?? this.nextPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

/// A stateless service that handles the common logic for paginated APIs.
///
/// It follows the DRF standard where a 'next' URL provides the link
/// to the subsequent page.
class PaginationService {
  const PaginationService();

  /// Calculates the next [PaginationState] from an API response.
  PaginationState calculateNextState<T>({
    required PaginatedResponseDto<T> response,
    required int currentPage,
  }) {
    final nextUrl = response.next;
    final hasMore = nextUrl != null;

    if (!hasMore) {
      return PaginationState(nextPage: currentPage, hasMore: false);
    }

    // Attempt to extract the page number from the URL
    final nextPage = _extractPageFromUrl(nextUrl);

    return PaginationState(
      nextPage: nextPage ?? currentPage, // Stay on current page if parsing fails
      hasMore: nextPage != null, // Treat as no more if we can't parse the URL
    );
  }

  int? _extractPageFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final pageStr = uri.queryParameters['page'];
      return pageStr != null ? int.tryParse(pageStr) : null;
    } catch (_) {
      return null;
    }
  }
}
