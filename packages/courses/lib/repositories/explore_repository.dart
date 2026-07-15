import 'package:core/data/data.dart';
import 'package:flutter/foundation.dart';

/// Repository for the Explore / Store feature.
///
/// Owns the single source of truth for products and categories.
/// Uses in-memory caching with a clean wipe-and-upsert strategy:
/// if the backend returns fewer items than cached (e.g. items were deleted),
/// the cache is fully replaced so stale entries never linger.
class ExploreRepository {
  final DataSource _source;

  ExploreRepository({required DataSource source}) : _source = source;

  // ── In-memory caches ──────────────────────────────────────────────────────

  final Map<String, List<ProductDto>> _productCache = {};
  final Map<String, List<ProductCategoryDto>> _categoryCache = {};

  // ── Products ──────────────────────────────────────────────────────────────

  /// Returns cached products for the given [cacheKey] if available,
  /// otherwise fetches from the network and updates the cache.
  List<ProductDto>? getCachedProducts(String cacheKey) =>
      _productCache[cacheKey];

  /// Fetches a fresh page of products from the network and updates cache.
  ///
  /// Cache strategy:
  /// - Wipes the cache key entirely before writing.
  /// - Upserts the new results (replace-all).
  /// This ensures that if the backend returns fewer items than last time,
  /// no stale entries remain.
  Future<List<ProductDto>> fetchProducts({
    String? category,
    String? search,
    int page = 1,
  }) async {
    final cacheKey = _productCacheKey(
      category: category,
      search: search,
      page: page,
    );

    try {
      final response = await _source.getProducts(
        category: category,
        search: search,
        page: page,
      );

      // Wipe stale cache then write the fresh results.
      _productCache[cacheKey] = response.results;
      return response.results;
    } catch (e) {
      // Return cached data on error if available, otherwise rethrow.
      final cached = _productCache[cacheKey];
      if (cached != null && cached.isNotEmpty) {
        debugPrint(
            '[ExploreRepository] Network error, returning cached products: $e');
        return cached;
      }
      rethrow;
    }
  }

  // ── Categories ────────────────────────────────────────────────────────────

  List<ProductCategoryDto>? getCachedCategories(String cacheKey) =>
      _categoryCache[cacheKey];

  /// Fetches categories and applies the same wipe-and-upsert strategy.
  Future<List<ProductCategoryDto>> fetchCategories({String? search}) async {
    final cacheKey = _categoryCacheKey(search: search);

    try {
      final response = await _source.getProductCategories(search: search);
      _categoryCache[cacheKey] = response.results;
      return response.results;
    } catch (e) {
      final cached = _categoryCache[cacheKey];
      if (cached != null && cached.isNotEmpty) {
        debugPrint(
            '[ExploreRepository] Network error, returning cached categories: $e');
        return cached;
      }
      rethrow;
    }
  }

  // ── Cache management ──────────────────────────────────────────────────────

  /// Clears all cached products and categories.
  void clearAll() {
    _productCache.clear();
    _categoryCache.clear();
  }

  /// Clears cached products for a specific query.
  void clearProducts({String? category, String? search, int page = 1}) {
    _productCache.remove(_productCacheKey(
      category: category,
      search: search,
      page: page,
    ));
  }

  // ── Key builders ──────────────────────────────────────────────────────────

  String _productCacheKey({String? category, String? search, int page = 1}) =>
      'products:${category ?? ''}:${search ?? ''}:$page';

  String _categoryCacheKey({String? search}) => 'categories:${search ?? ''}';
}
