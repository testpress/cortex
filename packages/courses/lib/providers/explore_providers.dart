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
class StoreProducts extends _$StoreProducts {
  @override
  Future<PaginatedResponseDto<ProductDto>> build() async {
    final query = ref.watch(exploreSearchQueryProvider);
    final category = ref.watch(selectedStoreCategoryProvider);
    final repo = ref.watch(exploreRepositoryProvider);

    return repo.fetchProducts(
      search: query.isNotEmpty ? query : null,
      category: category,
      page: 1,
    );
  }

  Future<void> fetchNextPage() async {
    if (state.isLoading || state.isRefreshing || state.hasError) return;

    final currentResponse = state.value;
    if (currentResponse == null || currentResponse.next == null) return;

    final query = ref.read(exploreSearchQueryProvider);
    final category = ref.read(selectedStoreCategoryProvider);
    final repo = ref.read(exploreRepositoryProvider);

    // Extract page number from the next URL
    int nextPage = 2;
    try {
      final uri = Uri.parse(currentResponse.next!);
      nextPage = int.tryParse(uri.queryParameters['page'] ?? '') ?? 2;
    } catch (_) {}

    state = AsyncValue<PaginatedResponseDto<ProductDto>>.loading()
        .copyWithPrevious(state);

    try {
      final response = await repo.fetchProducts(
        search: query.isNotEmpty ? query : null,
        category: category,
        page: nextPage,
      );

      state = AsyncData(PaginatedResponseDto(
        count: response.count,
        next: response.next,
        previous: response.previous,
        results: [...currentResponse.results, ...response.results],
      ));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
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
  int? _orderId;

  @override
  AsyncValue<OrderDto?> build(String slug) {
    ref.onDispose(() {
      _orderId = null;
    });
    return const AsyncValue.data(null);
  }

  Future<void> applyCoupon(String code) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(exploreRepositoryProvider);
      // Reuse existing draft order if available to avoid creating multiple orders
      final orderId = _orderId ?? (await repo.createOrder(slug)).id;
      _orderId = orderId;

      final updatedOrder = await repo.applyCoupon(orderId, code);
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
