import 'package:core/data/data.dart';
import 'package:flutter/foundation.dart';

/// Repository for the Store / Store feature.
///
/// Owns the single source of truth for products and categories.
/// Uses in-memory caching with a clean wipe-and-upsert strategy:
/// if the backend returns fewer items than cached (e.g. items were deleted),
/// the cache is fully replaced so stale entries never linger.
class StoreRepository {
  final DataSource _source;

  StoreRepository({required DataSource source}) : _source = source;

  // ── In-memory caches ──────────────────────────────────────────────────────

  static const int _maxCacheSize = 20;
  final Map<String, PaginatedResponseDto<ProductDto>> _productCache = {};
  final Map<String, List<ProductCategoryDto>> _categoryCache = {};

  void _evictCache<T>(Map<String, T> cache) {
    if (cache.length > _maxCacheSize) {
      final keysToRemove =
          cache.keys.take(cache.length - _maxCacheSize).toList();
      for (final key in keysToRemove) {
        cache.remove(key);
      }
    }
  }

  // ── Products ──────────────────────────────────────────────────────────────

  /// Returns cached products for the given [cacheKey] if available,
  /// otherwise fetches from the network and updates the cache.
  PaginatedResponseDto<ProductDto>? getCachedProducts(String cacheKey) =>
      _productCache[cacheKey];

  /// Fetches a fresh page of products from the network and updates cache.
  ///
  /// Cache strategy:
  /// - Wipes the cache key entirely before writing.
  /// - Upserts the new results (replace-all).
  /// This ensures that if the backend returns fewer items than last time,
  /// no stale entries remain.
  Future<PaginatedResponseDto<ProductDto>> fetchProducts({
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
      _productCache[cacheKey] = response;
      _evictCache(_productCache);
      return response;
    } catch (e) {
      // Return cached data on error if available, otherwise rethrow.
      final cached = _productCache[cacheKey];
      if (cached != null) {
        debugPrint(
            '[StoreRepository] Network error, returning cached products: $e');
        return cached;
      }
      rethrow;
    }
  }

  Future<ProductDto> fetchProductDetail(String slug) async {
    final response = await _source.getProduct(slug);
    // Optionally update the cache with this detail. Since this returns more detail
    // (like hasCoupons), we can update the specific product in the cache.
    // For now we just return it.
    return response;
  }

  Future<OrderDto> createOrder(String productSlug) async {
    return _source.createOrder(productSlug);
  }

  Future<OrderDto> createAndConfirmOrder(String productSlug) async {
    final createdOrder = await _source.createOrder(productSlug);
    if (createdOrder.status == 'Completed') {
      return createdOrder;
    }
    return await _source.confirmOrder(createdOrder.id, {});
  }

  Future<OrderDto> applyCoupon(int orderId, String couponCode) async {
    return _source.applyCoupon(orderId, couponCode);
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
      _evictCache(_categoryCache);
      return response.results;
    } catch (e) {
      final cached = _categoryCache[cacheKey];
      if (cached != null && cached.isNotEmpty) {
        debugPrint(
            '[StoreRepository] Network error, returning cached categories: $e');
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

  Future<InstallmentPlansResponseDto> getInstallmentPlans(String slug) async {
    return _source.getInstallmentPlans(slug);
  }

  // ── Key builders ──────────────────────────────────────────────────────────

  String _productCacheKey({String? category, String? search, int page = 1}) =>
      'products:${category ?? ''}:${search ?? ''}:$page';

  String _categoryCacheKey({String? search}) => 'categories:${search ?? ''}';
}
