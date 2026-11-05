import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/courses.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:courses/repositories/store_repository.dart';
import 'package:courses/repositories/course_repository.dart';
import 'package:courses/widgets/store/product_expandable_course_card.dart';

class MockSentryService extends SentryService {
  @override
  Future<void> captureException(dynamic exception,
      {Map<String, dynamic>? contexts,
      AppErrorLevel? level,
      dynamic stackTrace,
      Map<String, String>? tags,
      bool bypassFilter = false}) async {}
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
  setUp(() {
    WebViewPlatform.instance = _FakeWebViewPlatform();
  });

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
        'plan-based product shows inline Choose a plan, duration pills, plan cards, and Proceed to Buy',
        (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final subProduct = ProductDto(
        id: 526,
        title: 'Subscription Test Course',
        slug: 'sub-test-course',
        price: '599.00',
        courses: const [372],
        benefits: const [
          ProductBenefitDto(id: 1, name: 'Recorded lectures', order: 1),
          ProductBenefitDto(id: 2, name: 'Mentorship calls', order: 2),
        ],
        plans: const [
          SubscriptionPlanDto(
            id: 201,
            productId: 526,
            name: 'Basic Access',
            benefitIds: [1],
            planDetails: [
              PlanDetailDto(
                id: 301,
                durationInDays: 90,
                price: '2999.00',
              ),
              PlanDetailDto(
                id: 302,
                durationInDays: 180,
                price: '4999.00',
              ),
            ],
          ),
          SubscriptionPlanDto(
            id: 202,
            productId: 526,
            name: 'Premium Elite',
            benefitIds: [1, 2],
            planDetails: [
              PlanDetailDto(
                id: 303,
                durationInDays: 90,
                price: '5999.00',
              ),
              PlanDetailDto(
                id: 304,
                durationInDays: 180,
                price: '8999.00',
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

      // Verify inline "Choose a plan" and duration selector pills
      expect(find.text('Choose a plan'), findsOneWidget);
      expect(find.text('90 days'), findsWidgets);
      expect(find.text('180 days'), findsOneWidget);

      // Verify plan cards rendered inline
      expect(find.text('Basic Access'), findsWidgets);
      expect(find.text('Premium Elite'), findsWidgets);

      // Verify "Proceed to Buy" is displayed (since plan is pre-selected) and installments hidden
      expect(find.text('Proceed to Buy'), findsOneWidget);
      expect(find.text('Pay in installments'), findsNothing);

      // Verify Compare plans section
      expect(find.text('Compare plans'), findsOneWidget);
      expect(find.text('Recorded lectures'), findsOneWidget);
      expect(find.text('Mentorship calls'), findsOneWidget);

      // Tap on 180 days duration pill -> updates selection to duration 180
      await tester.tap(find.text('180 days'));
      await tester.pumpAndSettle();

      // Tap on Premium Elite tab in Compare plans -> two-way sync updates active plan to 202
      await tester.ensureVisible(find.text('Premium Elite').last);
      await tester.tap(find.text('Premium Elite').last);
      await tester.pumpAndSettle();

      // Tap Proceed to Buy -> creates order with selected planDetailId 304 (Premium Elite 180 days)
      await tester.tap(find.text('Proceed to Buy'));
      await tester.pumpAndSettle();

      expect(fakeRepo.lastPlanDetailId, 304);
    });

    testWidgets(
        'curriculum scopes to base course and excludes subscription-only courses',
        (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      const baseCourse = ProductCourseDto(
        id: 1200,
        title: 'Base Video Course',
        slug: 'base-video-course',
        chaptersCount: 10,
      );
      const planCourse = ProductCourseDto(
        id: 1861,
        title: 'Plan Tier Course',
        slug: 'plan-tier-course',
        chaptersCount: 2,
      );
      final product = ProductDto(
        id: 526,
        title: 'Multi-Course Product',
        slug: 'multi-course-product',
        price: '599.00',
        descriptionHtml: '<p>Description</p>',
        courses: const [1200, 1861],
        coursesDetails: const [baseCourse, planCourse],
        plans: const [
          SubscriptionPlanDto(
            id: 201,
            productId: 526,
            name: 'Tier Plan',
            courseIds: [1861],
            planDetails: [
              PlanDetailDto(
                id: 301,
                durationInDays: 30,
                price: '599.00',
              ),
            ],
          ),
        ],
      );

      final fakeRepo = FakeStoreRepository(
        source: const MockDataSource(),
        product: product,
      );
      final fakeCourseRepo = FakeCourseRepository();

      await tester.pumpWidget(
        wrapRouter(
          ProductDetailScreen(product: product),
          overrides: [
            storeRepositoryProvider.overrideWithValue(fakeRepo),
            courseRepositoryProvider
                .overrideWith((ref) async => fakeCourseRepo),
            dataSourceProvider.overrideWithValue(const MockDataSource()),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Scroll to Curriculum tab and tap it
      await tester.scrollUntilVisible(
        find.text('Curriculum'),
        100,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Curriculum'));
      await tester.pumpAndSettle();

      // Base course should be rendered in expandable course card, but plan course excluded
      expect(
        find.descendant(
          of: find.byType(ProductExpandableCourseCard),
          matching: find.text('Base Video Course'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(ProductExpandableCourseCard),
          matching: find.text('Plan Tier Course'),
        ),
        findsNothing,
      );
    });

    testWidgets(
        'renders faculty row and section, and opens faculty profile screen',
        (tester) async {
      WebViewPlatform.instance = _FakeWebViewPlatform();

      final facultyProduct = ProductDto(
        id: 999,
        title: 'UPSC Complete Course',
        slug: 'upsc-complete',
        price: '4999.00',
        courses: const [],
        faculty: const [
          ProductFacultyDto(
            id: 1,
            name: 'Dr. Ananya Rao',
            initials: 'AR',
            subjects: ['Polity', 'Governance'],
            shortDescription: 'Former civil servant teaching polity.',
            yearsOfExperience: 14,
            highlights: ['Author of Polity Simple'],
            qualifications: ['PhD JNU'],
            bio: 'Six years in civil service.',
            teaches: [
              FacultyTeachingDto(
                id: 101,
                course: 'Prelims GS',
                subject: 'Polity',
                videoUrl: 'https://example.com/prelims.mp4',
              ),
            ],
          ),
          ProductFacultyDto(
            id: 2,
            name: 'Rahul Mehta',
            initials: 'RM',
            subjects: ['History'],
          ),
        ],
      );

      final fakeRepo = FakeStoreRepository(
        source: const MockDataSource(),
        product: facultyProduct,
      );
      final fakeCourseRepo = FakeCourseRepository();

      await tester.pumpWidget(
        wrapRouter(
          ProductDetailScreen(product: facultyProduct),
          overrides: [
            storeRepositoryProvider.overrideWithValue(fakeRepo),
            courseRepositoryProvider
                .overrideWith((ref) async => fakeCourseRepo),
            dataSourceProvider.overrideWithValue(const MockDataSource()),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Verify faculty summary row
      expect(find.byType(ProductFacultySummary), findsOneWidget);
      expect(find.text('Taught by Dr. Ananya Rao and 1 more'), findsOneWidget);

      // Tap summary row to scroll to Meet your faculty section
      await tester.tap(find.byType(ProductFacultySummary));
      await tester.pumpAndSettle();

      // Verify Meet your faculty section
      expect(find.byType(ProductFacultySection), findsOneWidget);
      expect(find.text('Meet your faculty'), findsOneWidget);

      // Scroll to Meet your faculty card and tap it
      await tester.ensureVisible(find.text('Meet your faculty'));
      await tester.tap(find.text('Dr. Ananya Rao').last);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Verify Faculty profile screen opens
      expect(find.byType(FacultyProfileScreen), findsOneWidget);
      expect(find.text('Faculty profile'), findsOneWidget);
      expect(find.text('Author of Polity Simple'), findsOneWidget);

      // Tap back button on the screen
      await tester.tap(find.byType(AppBackButton));
      await tester.pumpAndSettle();

      // Screen should be closed
      expect(find.byType(FacultyProfileScreen), findsNothing);
    });

    testWidgets('tapping faculty summary row scrolls to faculty section',
        (tester) async {
      final facultyProduct = ProductDto(
        id: 701,
        title: 'Long Course with Faculty',
        slug: 'long-course-with-faculty',
        price: '500.00',
        courses: const [100],
        descriptionHtml: '<p>${'Long description content.<br/>' * 40}</p>',
        faculty: const [
          ProductFacultyDto(
            id: 1,
            name: 'Dr. Ananya Rao',
            initials: 'AR',
            subjects: ['Polity'],
            shortDescription: 'Author of Polity Simple',
          ),
        ],
      );

      final fakeRepo = FakeStoreRepository(
        source: const MockDataSource(),
        product: facultyProduct,
      );
      final fakeCourseRepo = FakeCourseRepository();

      await tester.pumpWidget(
        wrapRouter(
          ProductDetailScreen(product: facultyProduct),
          overrides: [
            storeRepositoryProvider.overrideWithValue(fakeRepo),
            courseRepositoryProvider
                .overrideWith((ref) async => fakeCourseRepo),
            dataSourceProvider.overrideWithValue(const MockDataSource()),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final scrollableFinder = find.byType(Scrollable).first;
      final scrollableState = tester.state<ScrollableState>(scrollableFinder);
      expect(scrollableState.position.pixels, 0.0);

      await tester.tap(find.byType(ProductFacultySummary));
      await tester.pumpAndSettle();

      expect(scrollableState.position.pixels, greaterThan(0.0));
    });

    testWidgets('renders "What you get" section when product has benefits',
        (tester) async {
      final productWithBenefits = ProductDto(
        id: 999,
        title: 'Masterclass with Perks',
        slug: 'masterclass-perks',
        price: '2999.00',
        courses: const [],
        benefits: const [
          ProductBenefitDto(id: 1, name: 'Live Doubt Clearing'),
          ProductBenefitDto(id: 2, name: '1-on-1 Faculty Mentorship'),
        ],
      );

      final fakeRepo = FakeStoreRepository(
        source: const MockDataSource(),
        product: productWithBenefits,
      );
      final fakeCourseRepo = FakeCourseRepository();

      await tester.pumpWidget(
        wrapRouter(
          ProductDetailScreen(product: productWithBenefits),
          overrides: [
            storeRepositoryProvider.overrideWithValue(fakeRepo),
            courseRepositoryProvider
                .overrideWith((ref) async => fakeCourseRepo),
            dataSourceProvider.overrideWithValue(const MockDataSource()),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('What you get'), findsOneWidget);
      expect(find.text('Live Doubt Clearing'), findsOneWidget);
      expect(find.text('1-on-1 Faculty Mentorship'), findsOneWidget);
      expect(find.byIcon(LucideIcons.sparkles), findsOneWidget);
      expect(find.byIcon(LucideIcons.checkCircle2), findsNWidgets(2));
    });

    testWidgets('omits "What you get" section when product has no benefits',
        (tester) async {
      final productWithoutBenefits = ProductDto(
        id: 998,
        title: 'Simple Course',
        slug: 'simple-course',
        price: '999.00',
        courses: const [],
        benefits: const [],
      );

      final fakeRepo = FakeStoreRepository(
        source: const MockDataSource(),
        product: productWithoutBenefits,
      );
      final fakeCourseRepo = FakeCourseRepository();

      await tester.pumpWidget(
        wrapRouter(
          ProductDetailScreen(product: productWithoutBenefits),
          overrides: [
            storeRepositoryProvider.overrideWithValue(fakeRepo),
            courseRepositoryProvider
                .overrideWith((ref) async => fakeCourseRepo),
            dataSourceProvider.overrideWithValue(const MockDataSource()),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('What you get'), findsNothing);
      expect(find.byIcon(LucideIcons.sparkles), findsNothing);
    });
  });
}

class _FakePlatformWebViewController extends PlatformWebViewController {
  _FakePlatformWebViewController(super.params) : super.implementation();

  JavaScriptChannelParams? _channelParams;

  @override
  Future<void> setPlatformNavigationDelegate(
    PlatformNavigationDelegate handler,
  ) async {}

  @override
  Future<void> setJavaScriptMode(JavaScriptMode javaScriptMode) async {}

  @override
  Future<void> addJavaScriptChannel(
    JavaScriptChannelParams javaScriptChannelParams,
  ) async {
    _channelParams = javaScriptChannelParams;
  }

  @override
  Future<void> setUserAgent(String? userAgent) async {}

  @override
  Future<String?> getUserAgent() async => 'MockUserAgent';

  @override
  Future<void> setOnConsoleMessage(
    void Function(JavaScriptConsoleMessage consoleMessage) onConsoleMessage,
  ) async {}

  @override
  Future<void> loadRequest(LoadRequestParams params) async {}

  @override
  Future<void> loadHtmlString(String html, {String? baseUrl}) async {
    if (_channelParams != null && _channelParams!.name == 'VideoChannel') {
      Future.microtask(() {
        _channelParams!.onMessageReceived(
          const JavaScriptMessage(message: 'ready'),
        );
      });
    }
  }

  @override
  Future<void> runJavaScript(String javaScript) async {}
}

class _FakePlatformWebViewWidget extends PlatformWebViewWidget {
  _FakePlatformWebViewWidget(super.params) : super.implementation();

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class _FakePlatformNavigationDelegate extends PlatformNavigationDelegate {
  _FakePlatformNavigationDelegate(super.params) : super.implementation();

  @override
  Future<void> setOnProgress(void Function(int progress) onProgress) async {}

  @override
  Future<void> setOnPageStarted(
    void Function(String url) onPageStarted,
  ) async {}

  @override
  Future<void> setOnPageFinished(
    void Function(String url) onPageFinished,
  ) async {}

  @override
  Future<void> setOnWebResourceError(
    void Function(WebResourceError error) onWebResourceError,
  ) async {}

  @override
  Future<void> setOnNavigationRequest(
    FutureOr<NavigationDecision> Function(NavigationRequest request)
        onNavigationRequest,
  ) async {}

  @override
  Future<void> setOnUrlChange(
    void Function(UrlChange change) onUrlChange,
  ) async {}

  @override
  Future<void> setOnHttpAuthRequest(
    void Function(HttpAuthRequest request) onHttpAuthRequest,
  ) async {}

  @override
  Future<void> setOnHttpError(
    void Function(HttpResponseError error) onHttpError,
  ) async {}
}

class _FakeWebViewPlatform extends WebViewPlatform {
  @override
  PlatformWebViewController createPlatformWebViewController(
    PlatformWebViewControllerCreationParams params,
  ) {
    return _FakePlatformWebViewController(params);
  }

  @override
  PlatformNavigationDelegate createPlatformNavigationDelegate(
    PlatformNavigationDelegateCreationParams params,
  ) {
    return _FakePlatformNavigationDelegate(params);
  }

  @override
  PlatformWebViewWidget createPlatformWebViewWidget(
    PlatformWebViewWidgetCreationParams params,
  ) {
    return _FakePlatformWebViewWidget(params);
  }
}
