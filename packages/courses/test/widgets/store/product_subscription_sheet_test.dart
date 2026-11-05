import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/widgets/store/product_subscription_sheet.dart';

void main() {
  Widget buildTestWidget({
    required ProductDto product,
    int? initialSelectedPlanDetailId,
    ValueChanged<int>? onPlanSelected,
    VoidCallback? onClose,
  }) {
    return ProviderScope(
      child: DesignProvider(
        config: DesignConfig.defaults(),
        child: LocalizationProvider(
          child: Builder(
            builder: (context) {
              final locale = LocalizationProvider.of(context).locale;
              return WidgetsApp(
                color: const Color(0xFF000000),
                locale: locale,
                localizationsDelegates: LocalizationProvider.delegates,
                pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
                  settings: settings,
                  pageBuilder: (context, _, __) => builder(context),
                ),
                home: ProductSubscriptionSheet(
                  product: product,
                  initialSelectedPlanDetailId: initialSelectedPlanDetailId,
                  onPlanSelected: onPlanSelected,
                  onClose: onClose ?? () {},
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  final testProductWithPlans = ProductDto(
    id: 101,
    title: 'Comprehensive Pass',
    slug: 'comprehensive-pass',
    price: '2500.00',
    courses: const [201, 202],
    coursesDetails: const [
      ProductCourseDto(
        id: 201,
        title: 'Physics Advanced',
        slug: 'physics-adv',
      ),
      ProductCourseDto(
        id: 202,
        title: 'Chemistry Advanced',
        slug: 'chem-adv',
      ),
    ],
    plans: const [
      SubscriptionPlanDto(
        id: 1,
        productId: 101,
        name: 'Diamond Plan',
        description: 'Access to Physics & Chemistry',
        courseIds: [201, 202],
        planDetails: [
          PlanDetailDto(
            id: 11,
            price: '5000.00',
            durationInDays: 365,
          ),
        ],
      ),
      SubscriptionPlanDto(
        id: 2,
        productId: 101,
        name: 'Silver Plan',
        description: 'Access to Physics only',
        courseIds: [201],
        planDetails: [
          PlanDetailDto(
            id: 21,
            price: '2500.00',
            durationInDays: 180,
          ),
        ],
      ),
    ],
  );

  testWidgets('renders distinct plan cards with names and bundled course chips',
      (tester) async {
    await tester.pumpWidget(buildTestWidget(product: testProductWithPlans));
    await tester.pumpAndSettle();

    expect(find.text('Diamond Plan'), findsOneWidget);
    expect(find.text('Silver Plan'), findsOneWidget);
    expect(find.text('Physics Advanced'), findsWidgets);
    expect(find.text('Chemistry Advanced'), findsOneWidget);
    expect(find.textContaining('1 year'), findsOneWidget);
    expect(find.textContaining('180 days'), findsOneWidget);
  });

  testWidgets('selecting a duration tier invokes onPlanSelected callback',
      (tester) async {
    int? selectedId;
    await tester.pumpWidget(
      buildTestWidget(
        product: testProductWithPlans,
        onPlanSelected: (id) => selectedId = id,
      ),
    );
    await tester.pumpAndSettle();

    // Tap the 1 year duration option
    await tester.tap(find.textContaining('1 year'));
    await tester.pumpAndSettle();

    expect(selectedId, 11);
  });

  testWidgets('exposes selected state in semantic label for active plan',
      (tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        product: testProductWithPlans,
        initialSelectedPlanDetailId: 11,
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byWidgetPredicate(
        (w) =>
            w is Semantics &&
            (w.properties.label?.contains('selected') ?? false),
      ),
      findsOneWidget,
    );
  });

  testWidgets(
      'renders plan benefits with included and excluded indicators for comparison',
      (tester) async {
    final productWithBenefits = ProductDto(
      id: 102,
      title: 'Course with Benefits',
      slug: 'course-with-benefits',
      price: '1000.00',
      courses: const [],
      benefits: const [
        ProductBenefitDto(id: 1, name: 'Live Doubt Clearing'),
        ProductBenefitDto(id: 2, name: '1-on-1 Mentorship'),
      ],
      plans: const [
        SubscriptionPlanDto(
          id: 1,
          productId: 102,
          name: 'Premium Plan',
          benefitIds: [1, 2],
          planDetails: [
            PlanDetailDto(id: 1, price: '1000.00', durationInDays: 30),
          ],
        ),
        SubscriptionPlanDto(
          id: 2,
          productId: 102,
          name: 'Basic Plan',
          benefitIds: [1],
          planDetails: [
            PlanDetailDto(id: 2, price: '500.00', durationInDays: 30),
          ],
        ),
      ],
    );

    await tester.pumpWidget(buildTestWidget(product: productWithBenefits));
    await tester.pumpAndSettle();

    expect(find.text('Plan Benefits'), findsNWidgets(2));
    expect(find.text('Live Doubt Clearing'), findsNWidgets(2));
    expect(find.text('1-on-1 Mentorship'), findsNWidgets(2));

    // Premium plan includes both (2 checks), Basic plan includes 1 (1 check)
    expect(find.byIcon(LucideIcons.check), findsNWidgets(3));
    // 1 close button in sheet header + 1 excluded benefit icon
    expect(find.byIcon(LucideIcons.x), findsNWidgets(2));
  });
}
