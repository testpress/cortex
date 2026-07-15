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
