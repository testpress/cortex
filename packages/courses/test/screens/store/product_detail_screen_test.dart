import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/screens/store/product_detail_screen.dart';
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
  FakeStoreRepository({required super.source, required this.product})
      : super(sentryService: MockSentryService());

  final ProductDto product;
  bool clearAllCalled = false;
  int fetchProductsCalls = 0;

  @override
  void clearAll() {
    clearAllCalled = true;
    super.clearAll();
  }

  @override
  Future<ProductDto> fetchProductDetail(String slug) async {
    return product;
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

  @override
  Future<OrderDto> createAndConfirmOrder(String productSlug) async {
    return const OrderDto(
      id: 101,
      status: 'Completed',
      total: '300.00',
      subtotal: '300.00',
    );
  }
}

void main() {
  Widget wrapRouter(Widget child, {List<Override> overrides = const []}) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => child,
        ),
        GoRoute(
          path: '/study',
          builder: (context, state) => const SizedBox(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const SizedBox(),
        ),
      ],
    );

    return ProviderScope(
      overrides: overrides,
      child: DesignProvider(
        config: DesignConfig.defaults(),
        child: LocalizationProvider(
          child: Builder(
            builder: (context) {
              final locale = LocalizationProvider.of(context).locale;
              return WidgetsApp.router(
                color: const Color(0xFF000000),
                routerConfig: router,
                locale: locale,
                localizationsDelegates: LocalizationProvider.delegates,
              );
            },
          ),
        ),
      ),
    );
  }

  final testProduct = ProductDto(
    id: 524,
    title: 'Test Course Product',
    slug: 'test-course-product',
    price: '300.00',
    courses: const [372],
    hasCoupons: false,
  );

  group('ProductDetailScreen Payment & Store Refresh', () {
    testWidgets(
        'clears store repository cache and invalidates providers on successful purchase',
        (tester) async {
      final fakeRepo = FakeStoreRepository(
        source: const MockDataSource(),
        product: testProduct,
      );

      await tester.pumpWidget(
        wrapRouter(
          ProductDetailScreen(product: testProduct),
          overrides: [
            storeRepositoryProvider.overrideWithValue(fakeRepo),
            dataSourceProvider.overrideWithValue(const MockDataSource()),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Test Course Product'), findsWidgets);
      expect(fakeRepo.clearAllCalled, isFalse);

      // Find and tap Buy Now button
      final buyNowFinder = find.byType(AppButton);
      expect(buyNowFinder, findsOneWidget);

      await tester.tap(buyNowFinder);
      await tester.pumpAndSettle();

      // Find Start Learning on PaymentProcessingScreen and tap it
      final startLearningButton = find.text('Start Learning');
      expect(startLearningButton, findsOneWidget);

      await tester.tap(startLearningButton);
      await tester.pumpAndSettle();

      // Verify payment processing screen completed and triggered clearAll
      expect(fakeRepo.clearAllCalled, isTrue);
    });
  });
}
