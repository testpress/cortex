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

  int? lastPlanDetailId;

  @override
  Future<OrderDto> createAndConfirmOrder(
    String productSlug, {
    int? planDetailId,
    int? installmentPlanId,
  }) async {
    lastPlanDetailId = planDetailId;
    return const OrderDto(
      id: 101,
      status: 'Completed',
      total: '300.00',
      subtotal: '300.00',
    );
  }

  @override
  Future<OrderDto> createOrder(
    String slug, {
    int? planDetailId,
    int? installmentPlanId,
  }) async {
    return const OrderDto(
      id: 1,
      status: 'Draft',
      total: '300.00',
      subtotal: '300.00',
    );
  }

  int removeCouponCalls = 0;

  @override
  Future<OrderDto> applyCoupon(int orderId, String couponCode) async {
    return const OrderDto(
      id: 1,
      status: 'Draft',
      total: '200.00',
      subtotal: '300.00',
    );
  }

  @override
  Future<OrderDto> removeCoupon(int orderId) async {
    removeCouponCalls++;
    return const OrderDto(
      id: 1,
      status: 'Draft',
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

    testWidgets('renders circle-x icon to remove coupon instead of text',
        (tester) async {
      final couponProduct = ProductDto(
        id: 524,
        title: 'Test Course Product',
        slug: 'test-course-product',
        price: '300.00',
        courses: const [372],
      );
      final fakeRepo = FakeStoreRepository(
        source: const MockDataSource(),
        product: couponProduct,
      );
      final fakeCourseRepo = FakeCourseRepository();

      await tester.pumpWidget(
        wrapRouter(
          ProductDetailScreen(product: couponProduct),
          overrides: [
            storeRepositoryProvider.overrideWithValue(fakeRepo),
            courseRepositoryProvider
                .overrideWith((ref) async => fakeCourseRepo),
            dataSourceProvider.overrideWithValue(const MockDataSource()),
          ],
        ),
      );

      await tester.pumpAndSettle();

      // Open discount sheet
      await tester.tap(find.text('Have a discount code?'));
      await tester.pumpAndSettle();

      // Enter coupon and apply
      await tester.enterText(find.byType(EditableText), 'SAVE100');
      await tester.pumpAndSettle();
      await tester.tap(find.text('APPLY'));
      await tester.pumpAndSettle();

      // Tap Done
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      // Applied coupon card should show code, savings, and circle-x icon, NOT 'Remove' text
      expect(find.text('SAVE100'), findsOneWidget);
      expect(find.text('You saved ₹100.00'), findsOneWidget);
      expect(find.byIcon(LucideIcons.xCircle), findsOneWidget);
      expect(find.text('Remove'), findsNothing);

      // Tap circle-x icon to remove coupon
      await tester.tap(find.byIcon(LucideIcons.xCircle));
      await tester.pumpAndSettle();

      // Should be removed and called backend removeCoupon
      expect(fakeRepo.removeCouponCalls, 1);
      expect(find.byIcon(LucideIcons.xCircle), findsNothing);
      expect(find.text('Have a discount code?'), findsOneWidget);
    });

    testWidgets(
        'plan-based product shows Subscribe, hides installments, selects plan in sheet, and switches to Proceed to Buy',
        (tester) async {
      final subProduct = ProductDto(
        id: 526,
        title: 'Subscription Test Course',
        slug: 'sub-test-course',
        price: '599.00',
        courses: const [372],
        plans: const [
          SubscriptionPlanDto(
            id: 201,
            productId: 526,
            name: 'Standard Tier',
            planDetails: [
              PlanDetailDto(
                id: 301,
                durationInDays: 180,
                price: '599.00',
              ),
              PlanDetailDto(
                id: 302,
                durationInDays: 365,
                price: '999.00',
              ),
            ],
          ),
        ],
      );

      final fakeRepo = FakeStoreRepository(
        source: const MockDataSource(),
        product: subProduct,
      );
      final fakeCourseRepo = FakeCourseRepository();

      await tester.pumpWidget(
        wrapRouter(
          ProductDetailScreen(product: subProduct),
          overrides: [
            storeRepositoryProvider.overrideWithValue(fakeRepo),
            courseRepositoryProvider
                .overrideWith((ref) async => fakeCourseRepo),
            dataSourceProvider.overrideWithValue(const MockDataSource()),
          ],
        ),
      );

      await tester.pumpAndSettle();

      // Verify "Subscribe" is displayed and "Pay in installments" is hidden
      expect(find.text('Subscribe'), findsOneWidget);
      expect(find.text('Proceed to Buy'), findsNothing);
      expect(find.text('Pay in installments'), findsNothing);

      // Tap Subscribe button
      await tester.tap(find.text('Subscribe'));
      await tester.pumpAndSettle();

      // Verify bottom sheet opened with title and plan options, and no option is pre-selected
      expect(find.text('Select a plan to proceed with your purchase'),
          findsOneWidget);
      expect(find.text('180 days. ₹599.00'), findsOneWidget);
      expect(find.text('1 year. ₹999.00'), findsOneWidget);
      expect(find.byIcon(LucideIcons.checkCircle), findsNothing);

      // Tap on the 365 days option -> sheet closes and selects plan 302
      await tester.tap(find.text('1 year. ₹999.00'));
      await tester.pumpAndSettle();

      // Sheet is closed, button is now "Proceed to Buy", and selected plan badge is shown
      expect(find.text('Select a plan to proceed with your purchase'),
          findsNothing);
      expect(find.text('Proceed to Buy'), findsOneWidget);
      expect(find.text('Subscribe'), findsNothing);
      expect(find.text('1 year. ₹999.00'), findsOneWidget);

      // Tap Proceed to Buy -> creates order with selected planDetailId 302
      await tester.tap(find.text('Proceed to Buy'));
      await tester.pumpAndSettle();

      expect(fakeRepo.lastPlanDetailId, 302);
    });
  });
}
