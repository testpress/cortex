import 'package:dio/dio.dart';

import '../data/config/app_config.dart';
import 'network_utils.dart';

/// Fetches all pages of a paginated endpoint in parallel.
///
/// Accepts the already-fetched [firstPageData] (to avoid a redundant request)
/// and the original [url] used to construct page-2..N URLs.
///
/// Returns a flat list of raw JSON maps across all pages.
/// Returns an empty list for unrecognized response shapes.
Future<List<Map<String, dynamic>>> fetchAllPaginatedPages({
  required Dio dio,
  required String url,
  required dynamic firstPageData,
}) async {
  final List<Map<String, dynamic>> allItems = [];

  final List<dynamic> firstPageList;
  String? nextUrl;
  int count = 0;
  int perPage = 0;

  if (firstPageData is List) {
    firstPageList = firstPageData;
  } else if (firstPageData is Map && firstPageData['results'] is List) {
    firstPageList = firstPageData['results'] as List<dynamic>;
    nextUrl = firstPageData['next'] as String?;
    count = (firstPageData['count'] as int?) ?? 0;
    perPage = (firstPageData['per_page'] as int?) ?? firstPageList.length;
  } else {
    firstPageList = [];
  }

  allItems.addAll(firstPageList.cast<Map<String, dynamic>>());

  if (nextUrl != null && nextUrl.isNotEmpty && count > 0 && perPage > 0) {
    final int totalPages = (count / perPage).ceil();
    if (totalPages > 1) {
      final uri = Uri.parse(url);
      final List<Future<dynamic>> futureRequests = [];

      for (int page = 2; page <= totalPages; page++) {
        final queryParams = Map<String, String>.from(uri.queryParameters);
        queryParams['page'] = page.toString();
        final pageUri = uri.replace(queryParameters: queryParams);
        futureRequests.add(
          performNetworkRequest(
            dio.get(pageUri.toString()),
            fromJson: (json) => json,
          ),
        );
      }

      final List<dynamic> pagesData = await Future.wait(futureRequests);
      for (final pageData in pagesData) {
        if (pageData is Map && pageData['results'] is List) {
          final list = pageData['results'] as List<dynamic>;
          allItems.addAll(list.cast<Map<String, dynamic>>());
        }
      }
    }
  }

  return allItems;
}

/// Resolves a relative `next` URL by prepending [AppConfig.apiBaseUrl].
String? resolveNextUrl(String? next) {
  if (next != null && !next.startsWith('http')) {
    return '${AppConfig.apiBaseUrl}$next';
  }
  return next;
}

/// Fetches all pages of a cursor-based paginated endpoint sequentially.
///
/// Starts from [initialUrl] and follows the `next` field in each response
/// until it is null. Each page's raw JSON map is yielded via [pageExtractor]
/// so callers can extract the items they need.
///
/// Returns a flat list of raw JSON maps across all pages.
Future<List<Map<String, dynamic>>> fetchAllCursorPages({
  required Dio dio,
  required String initialUrl,
  Map<String, dynamic>? queryParameters,
}) async {
  final List<Map<String, dynamic>> allItems = [];
  String? nextUrl = initialUrl;

  while (nextUrl != null) {
    final responseData = await performNetworkRequest(
      dio.get(
        nextUrl,
        queryParameters: nextUrl == initialUrl ? queryParameters : null,
      ),
      fromJson: (data) => data,
    );

    if (responseData is Map<String, dynamic>) {
      final results = responseData['results'];
      if (results is List) {
        allItems.addAll(results.cast<Map<String, dynamic>>());
      }
    }

    nextUrl = resolveNextUrl(responseData['next'] as String?);
  }

  return allItems;
}
