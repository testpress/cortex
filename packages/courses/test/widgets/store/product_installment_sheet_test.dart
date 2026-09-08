import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/widgets/store/product_installment_sheet.dart';
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
  FakeStoreRepository({required super.source})
      : super(sentryService: MockSentryService());

  bool clearAllCalled = false;

  @override
  void clearAll() {
    clearAllCalled = true;
    super.clearAll();
  }

  @override
  Future<InstallmentPlansResponseDto> getInstallmentPlans(String slug) async {
    return const InstallmentPlansResponseDto(
      installmentPlans: [
        InstallmentPlanDto(
          id: 1,
          price: '300.00',
          numberOfInstallments: 2,
          period: 30,
          displayName: '2-Month Plan',
          installments: [
            InstallmentDto(
              id: 10,
              order: 1,
              price: '150.00',
              isPaid: false,
              isCurrentInstallment: true,
            ),
            InstallmentDto(
              id: 11,
              order: 2,
              price: '150.00',
              isPaid: false,
              isCurrentInstallment: false,
            ),
          ],
        ),
      ],
      userInstallmentPlans: [],
    );
  }

  @override
  Future<OrderDto> createAndConfirmOrder(String productSlug) async {
    return const OrderDto(
      id: 101,
      status: 'Completed',
      total: '150.00',
      subtotal: '150.00',
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

  group('ProductInstallmentSheet Payment & Store Refresh', () {
    testWidgets(
        'clears store repository cache and invalidates providers on successful installment payment',
        (tester) async {
      final fakeRepo = FakeStoreRepository(source: const MockDataSource());

      await tester.pumpWidget(
        wrapRouter(
          ProductInstallmentSheet(
            product: testProduct,
            onClose: () {},
          ),
          overrides: [
            storeRepositoryProvider.overrideWithValue(fakeRepo),
            dataSourceProvider.overrideWithValue(const MockDataSource()),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('2-Month Plan'), findsOneWidget);
      expect(fakeRepo.clearAllCalled, isFalse);

      // Tap on the plan to view plan details
      await tester.tap(find.text('2-Month Plan'));
      await tester.pumpAndSettle();

      // Find and tap Pay Amount Now button
      final payNowButton = find.byType(AppButton);
      expect(payNowButton, findsOneWidget);

      await tester.tap(payNowButton);
      await tester.pumpAndSettle();

      // Find Start Learning on PaymentProcessingScreen and tap it
      final startLearningButton = find.text('Start Learning');
      expect(startLearningButton, findsOneWidget);

      await tester.tap(startLearningButton);
      await tester.pumpAndSettle();

      // Verify payment processing completed and triggered clearAll
      expect(fakeRepo.clearAllCalled, isTrue);
    });
  });
}
