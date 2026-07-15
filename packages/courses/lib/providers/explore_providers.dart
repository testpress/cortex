import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';
import '../repositories/explore_repository.dart';

part 'explore_providers.g.dart';

@riverpod
class ExploreSearchQuery extends _$ExploreSearchQuery {
  @override
  String build() => '';

  void update(String query) => state = query;
}

@riverpod
class SelectedStoreCategory extends _$SelectedStoreCategory {
  @override
  String? build() => null;

  void select(String? categoryId) => state = categoryId;
}

// ── Repository provider ───────────────────────────────────────────────────

@Riverpod(keepAlive: true)
ExploreRepository exploreRepository(ExploreRepositoryRef ref) {
  return ExploreRepository(source: ref.watch(dataSourceProvider));
}

// ── Data providers ────────────────────────────────────────────────────────

@riverpod
Future<List<ProductCategoryDto>> storeCategories(StoreCategoriesRef ref) {
  final query = ref.watch(exploreSearchQueryProvider);
  final repo = ref.watch(exploreRepositoryProvider);
  return repo.fetchCategories(
    search: query.isNotEmpty ? query : null,
  );
}

@riverpod
Future<List<ProductDto>> storeProducts(StoreProductsRef ref) {
  final query = ref.watch(exploreSearchQueryProvider);
  final category = ref.watch(selectedStoreCategoryProvider);
  final repo = ref.watch(exploreRepositoryProvider);
  return repo.fetchProducts(
    search: query.isNotEmpty ? query : null,
    category: category,
  );
}

@riverpod
Future<ProductDto> productDetail(
  ProductDetailRef ref,
  String slug,
) {
  final repo = ref.watch(exploreRepositoryProvider);
  return repo.fetchProductDetail(slug);
}

@riverpod
Future<InstallmentPlansResponseDto> productInstallmentPlans(
  ProductInstallmentPlansRef ref,
  String slug,
) {
  final repo = ref.watch(exploreRepositoryProvider);
  return repo.getInstallmentPlans(slug);
}

@riverpod
class ProductDiscountNotifier extends _$ProductDiscountNotifier {
  @override
  AsyncValue<OrderDto?> build(String slug) {
    return const AsyncValue.data(null);
  }

  Future<void> applyCoupon(String code) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(exploreRepositoryProvider);
      // Create a draft order first
      final order = await repo.createOrder(slug);
      // Then apply coupon
      final updatedOrder = await repo.applyCoupon(order.id, code);
      state = AsyncValue.data(updatedOrder);
    } catch (e, st) {
      if (e is ApiException) {
        state = AsyncValue.error(
            ApiException.extractApiMessage(e.data) ?? e.message, st);
      } else {
        state = AsyncValue.error(e, st);
      }
    }
  }
}
