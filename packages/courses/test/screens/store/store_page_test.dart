import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/screens/store/store_page.dart';
import 'package:courses/providers/store_providers.dart';
import 'package:courses/repositories/store_repository.dart';

class MockSentryService extends SentryService {
  @override
  Future<void> captureException(dynamic exception,
      {Map<String, dynamic>? contexts,
      AppErrorLevel? level,
      dynamic stackTrace,
      Map<String, String>? tags}) async {}
}

class FakeStoreRepository extends StoreRepository {
  FakeStoreRepository()
      : super(
            source: const MockDataSource(), sentryService: MockSentryService());

  int fetchCategoriesCalls = 0;
  int fetchProductsCalls = 0;

  @override
  Future<List<ProductCategoryDto>> fetchCategories({String? search}) async {
    fetchCategoriesCalls++;
    return [];
  }

  @override
  Future<PaginatedResponseDto<ProductDto>> fetchProducts({
    String? search,
    String? category,
    int? page,
  }) async {
    fetchProductsCalls++;
    return PaginatedResponseDto(
      count: 0,
      next: null,
      previous: null,
      results: [],
    );
  }
}

void main() {
  Widget wrap(Widget child, {List<Override> overrides = const []}) {
    return ProviderScope(
      overrides: overrides,
      child: DesignProvider(
        config: DesignConfig.defaults(),
        child: LocalizationProvider(
          child: Builder(
            builder: (context) {
              final locale = LocalizationProvider.of(context).locale;
              return Localizations(
                locale: locale,
                delegates: LocalizationProvider.delegates,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: child,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  group('StorePage Pull-to-Refresh', () {
    testWidgets('triggers refresh on store providers when pulled down',
        (tester) async {
      final fakeRepo = FakeStoreRepository();

      await tester.pumpWidget(
        wrap(
          const StorePage(),
          overrides: [
            storeRepositoryProvider.overrideWithValue(fakeRepo),
          ],
        ),
      );

      // Wait for initial load
      await tester.pumpAndSettle();

      // Initial loads
      expect(fakeRepo.fetchCategoriesCalls, 1);
      expect(fakeRepo.fetchProductsCalls, 1);

      // Verify refresh indicator semantics
      final refreshIndicator = find.byType(AppRefreshIndicator);
      expect(refreshIndicator, findsOneWidget);

      // Perform pull-to-refresh
      await tester.fling(
          find.byType(CustomScrollView), const Offset(0, 300), 1000);

      // Wait for the refresh indicator to appear, do the work, and disappear
      await tester.pumpAndSettle();

      // Ensure that both methods were called again during the refresh
      expect(fakeRepo.fetchCategoriesCalls, 2);
      expect(fakeRepo.fetchProductsCalls, 2);
    });
  });
}
