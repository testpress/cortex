import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/widgets/store/product_plan_section.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) {
    return DesignProvider(
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
    );
  }

  final testProduct = ProductDto(
    id: 10,
    title: 'Test Course with Plans',
    slug: 'test-course-plans',
    price: '2999',
    courses: const [1, 2],
    benefits: const [
      ProductBenefitDto(id: 1, name: 'Benefit 1'),
      ProductBenefitDto(id: 2, name: 'Benefit 2'),
    ],
    plans: const [
      SubscriptionPlanDto(
        id: 101,
        productId: 10,
        name: 'Basic Access',
        courseIds: [1],
        benefitIds: [1],
        planDetails: [
          PlanDetailDto(id: 201, durationInDays: 90, price: '2999'),
          PlanDetailDto(id: 202, durationInDays: 180, price: '4999'),
        ],
      ),
      SubscriptionPlanDto(
        id: 102,
        productId: 10,
        name: 'Standard Access',
        courseIds: [1, 2],
        benefitIds: [1, 2],
        planDetails: [
          PlanDetailDto(id: 203, durationInDays: 90, price: '4999'),
          PlanDetailDto(id: 204, durationInDays: 180, price: '7999'),
        ],
      ),
    ],
  );

  group('ProductPlanSection Widget Tests', () {
    testWidgets('renders Choose a plan header and duration selector',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          ProductPlanSection(
            product: testProduct,
            selectedPlanId: 101,
            selectedDurationInDays: 90,
            onSelectPlan: (_) {},
            onSelectDuration: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Choose a plan'), findsOneWidget);
      expect(find.text('Pick the plan that fits you and how long you need it.'),
          findsOneWidget);
      expect(find.text('90 days'), findsWidgets);
      expect(find.text('180 days'), findsOneWidget);
      expect(find.text('Basic Access'), findsOneWidget);
      expect(find.text('Standard Access'), findsOneWidget);

      // Verify selected state on duration chips
      expect(
        find.byWidgetPredicate(
            (w) => w is Semantics && w.properties.label == '90 days, selected'),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
            (w) => w is Semantics && w.properties.label == '180 days'),
        findsOneWidget,
      );
    });

    testWidgets('triggers onSelectDuration when duration pill is tapped',
        (tester) async {
      int? selectedDuration;
      await tester.pumpWidget(
        wrap(
          ProductPlanSection(
            product: testProduct,
            selectedPlanId: 101,
            selectedDurationInDays: 90,
            onSelectPlan: (_) {},
            onSelectDuration: (d) => selectedDuration = d,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('180 days'));
      expect(selectedDuration, 180);
    });

    testWidgets('triggers onSelectPlan when a plan card is tapped',
        (tester) async {
      int? selectedPlanId;
      await tester.pumpWidget(
        wrap(
          ProductPlanSection(
            product: testProduct,
            selectedPlanId: 101,
            selectedDurationInDays: 90,
            onSelectPlan: (id) => selectedPlanId = id,
            onSelectDuration: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Standard Access'));
      expect(selectedPlanId, 102);
    });

    testWidgets(
        'hides duration selector when only 1 duration exists across plans',
        (tester) async {
      const singleDurationProduct = ProductDto(
        id: 11,
        title: 'Single Duration Course',
        slug: 'single-duration-course',
        price: '1.01',
        courses: [1],
        plans: [
          SubscriptionPlanDto(
            id: 101,
            productId: 11,
            name: 'Subscription',
            planDetails: [
              PlanDetailDto(id: 201, durationInDays: 10, price: '1.01'),
            ],
          ),
        ],
      );

      await tester.pumpWidget(
        wrap(
          ProductPlanSection(
            product: singleDurationProduct,
            selectedPlanId: 101,
            selectedDurationInDays: 10,
            onSelectPlan: (_) {},
            onSelectDuration: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Choose a plan'), findsOneWidget);
      expect(find.text('Subscription'), findsOneWidget);
      expect(find.text('10 days'), findsNothing);
    });

    testWidgets(
        'falls back to plan.planDetails.firstOrNull when selectedDurationInDays is null',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          ProductPlanSection(
            product: testProduct,
            selectedPlanId: 101,
            selectedDurationInDays: null,
            onSelectPlan: (_) {},
            onSelectDuration: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Basic Access active detail falls back to its first detail (₹2999 / 90 days)
      expect(find.text('Basic Access'), findsOneWidget);
      expect(find.text('₹2999'), findsOneWidget);

      // Standard Access active detail falls back to its first detail (₹4999 / 90 days)
      expect(find.text('Standard Access'), findsOneWidget);
      expect(find.text('₹4999'), findsOneWidget);

      // Both cards display their first detail duration
      expect(find.text('/ 90 days'), findsNWidgets(2));

      // Basic Access is selected using the fallback detail
      expect(
        find.byWidgetPredicate((w) =>
            w is Semantics &&
            w.properties.label == 'Basic Access, ₹2999, selected'),
        findsOneWidget,
      );
    });
  });
}
