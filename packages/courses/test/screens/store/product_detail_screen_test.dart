import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/screens/store/product_detail_screen.dart';
import 'package:courses/providers/store_providers.dart';
import 'package:courses/providers/course_list_provider.dart';
import 'package:courses/repositories/store_repository.dart';
import 'package:courses/repositories/course_repository.dart';

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

class FakeCourseRepository extends CourseRepository {
  FakeCourseRepository()
      : super(AppDatabase(NativeDatabase.memory()), const MockDataSource(),
            MockSentryService());

  int refreshCoursesCalls = 0;

  @override
  Future<PaginatedResponseDto<CourseDto>> refreshCourses({
    int page = 1,
    dynamic tags,
  }) async {
    refreshCoursesCalls++;
    return PaginatedResponseDto(
      count: 0,
      next: null,
      previous: null,
      results: [],
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
        'clears store repository cache and refreshes study courses on successful purchase',
        (tester) async {
      final fakeRepo = FakeStoreRepository(
        source: const MockDataSource(),
        product: testProduct,
      );
      final fakeCourseRepo = FakeCourseRepository();

      await tester.pumpWidget(
        wrapRouter(
          ProductDetailScreen(product: testProduct),
          overrides: [
            storeRepositoryProvider.overrideWithValue(fakeRepo),
            courseRepositoryProvider
                .overrideWith((ref) async => fakeCourseRepo),
            dataSourceProvider.overrideWithValue(const MockDataSource()),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Test Course Product'), findsWidgets);
      expect(fakeRepo.clearAllCalled, isFalse);
      expect(fakeCourseRepo.refreshCoursesCalls, 0);

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

      // Verify payment processing screen completed and triggered both store cache clear and study course sync
      expect(fakeRepo.clearAllCalled, isTrue);
      expect(fakeCourseRepo.refreshCoursesCalls, 1);
    });

    testWidgets(
        'renders Free label and omits strikethrough for zero-priced product',
        (tester) async {
      final freeProduct = ProductDto(
        id: 525,
        title: 'Free Introductory Course',
        slug: 'free-intro-course',
        price: '0.00',
        strikeThroughPrice: '1000.00',
        courses: const [373],
        hasCoupons: false,
      );

      final fakeRepo = FakeStoreRepository(
        source: const MockDataSource(),
        product: freeProduct,
      );
      final fakeCourseRepo = FakeCourseRepository();

      await tester.pumpWidget(
        wrapRouter(
          ProductDetailScreen(product: freeProduct),
          overrides: [
            storeRepositoryProvider.overrideWithValue(fakeRepo),
            courseRepositoryProvider
                .overrideWith((ref) async => fakeCourseRepo),
            dataSourceProvider.overrideWithValue(const MockDataSource()),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Free Introductory Course'), findsWidgets);
      expect(find.text('FREE'), findsOneWidget);
      expect(find.text('₹0.00'), findsNothing);
      expect(find.text('₹1000.00'), findsNothing);
    });
  });
}
