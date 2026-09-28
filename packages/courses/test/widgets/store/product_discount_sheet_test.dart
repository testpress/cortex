import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/widgets/store/product_discount_sheet.dart';
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
          source: const MockDataSource(),
          sentryService: MockSentryService(),
        );

  @override
  Future<OrderDto> createOrder(String slug) async {
    return const OrderDto(
      id: 1,
      status: 'Draft',
      total: '100.00',
      subtotal: '100.00',
    );
  }

  @override
  Future<OrderDto> applyCoupon(int orderId, String couponCode) async {
    if (couponCode == 'SAVE74') {
      return const OrderDto(
        id: 1,
        status: 'Draft',
        total: '25.65',
        subtotal: '100.00',
      );
    }
    throw const ApiException(
      "['Invalid discount code']",
      statusCode: 400,
      data: {'detail': "['Invalid discount code']"},
    );
  }

  @override
  Future<OrderDto> removeCoupon(int orderId) async {
    return const OrderDto(
      id: 1,
      status: 'Draft',
      total: '100.00',
      subtotal: '100.00',
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

  const testProduct = ProductDto(
    id: 524,
    title: 'Test Course Product',
    slug: 'test-course-product',
    price: '100.00',
    courses: [372],
    descriptionHtml: 'Description',
    prices: [],
    coursesDetails: [],
    hasCoupons: true,
  );

  testWidgets('renders input view initially', (tester) async {
    final fakeRepo = FakeStoreRepository();

    await tester.pumpWidget(
      wrapRouter(
        ProductDiscountSheet(
          product: testProduct,
          productSlug: testProduct.slug,
          originalPrice: testProduct.price,
          onClose: () {},
        ),
        overrides: [
          storeRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Discount Coupon'), findsOneWidget);
    expect(find.text('APPLY'), findsOneWidget);
    expect(find.byType(AppTextField), findsOneWidget);
    expect(find.text('Done'), findsNothing);
  });

  testWidgets(
      'shows celebratory success card and Done button when coupon is applied',
      (tester) async {
    final fakeRepo = FakeStoreRepository();
    bool closed = false;

    await tester.pumpWidget(
      wrapRouter(
        ProductDiscountSheet(
          product: testProduct,
          productSlug: testProduct.slug,
          originalPrice: testProduct.price,
          onClose: () => closed = true,
        ),
        overrides: [
          storeRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      ),
    );
    await tester.pumpAndSettle();

    // Enter valid coupon code
    await tester.enterText(find.byType(EditableText), 'SAVE74');
    await tester.pumpAndSettle();

    // Tap APPLY button
    await tester.tap(find.text('APPLY'));
    await tester.pumpAndSettle();

    // Celebration state should be visible
    expect(find.text('₹74.35 saved!'), findsOneWidget);
    expect(find.text('Coupon applied successfully'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);
    expect(find.byIcon(LucideIcons.check), findsOneWidget);

    // Initial input elements should not be visible
    expect(find.text('APPLY'), findsNothing);

    // Tap Done button
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(closed, isTrue);
  });

  testWidgets(
      'displays error message on invalid coupon and stays on input view',
      (tester) async {
    final fakeRepo = FakeStoreRepository();

    await tester.pumpWidget(
      wrapRouter(
        ProductDiscountSheet(
          product: testProduct,
          productSlug: testProduct.slug,
          originalPrice: testProduct.price,
          onClose: () {},
        ),
        overrides: [
          storeRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      ),
    );
    await tester.pumpAndSettle();

    // Enter invalid coupon code
    await tester.enterText(find.byType(EditableText), 'WRONGCODE');
    await tester.pumpAndSettle();

    // Tap APPLY button
    await tester.tap(find.text('APPLY'));
    await tester.pumpAndSettle();

    // Should display cleanly parsed error message
    expect(find.text('Invalid discount code'), findsOneWidget);
    // Should remain on input view
    expect(find.text('APPLY'), findsOneWidget);
    expect(find.text('Done'), findsNothing);

    // Typing changes clears the error immediately
    await tester.enterText(find.byType(EditableText), 'WRONGCODE2');
    await tester.pumpAndSettle();
    expect(find.text('Invalid discount code'), findsNothing);
  });

  testWidgets('closing the sheet clears error so reopening starts fresh',
      (tester) async {
    final fakeRepo = FakeStoreRepository();

    await tester.pumpWidget(
      wrapRouter(
        ProductDiscountSheet(
          product: testProduct,
          productSlug: testProduct.slug,
          originalPrice: testProduct.price,
          onClose: () {},
        ),
        overrides: [
          storeRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      ),
    );
    await tester.pumpAndSettle();

    // Trigger error
    await tester.enterText(find.byType(EditableText), 'INVALID');
    await tester.pumpAndSettle();
    await tester.tap(find.text('APPLY'));
    await tester.pumpAndSettle();
    expect(find.text('Invalid discount code'), findsOneWidget);

    // Tap Close 'X' button
    await tester.tap(find.byIcon(LucideIcons.x));
    await tester.pumpAndSettle();

    // Reopen sheet with the same container/state
    await tester.pumpWidget(
      wrapRouter(
        ProductDiscountSheet(
          product: testProduct,
          productSlug: testProduct.slug,
          originalPrice: testProduct.price,
          onClose: () {},
        ),
        overrides: [
          storeRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      ),
    );
    await tester.pumpAndSettle();

    // Error should not be present
    expect(find.text('Invalid discount code'), findsNothing);
  });
}
