import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/widgets/store/product_plan_card.dart';
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

  const testPlan = SubscriptionPlanDto(
    id: 101,
    productId: 50,
    name: 'Basic Access',
    description: 'For self-learners who want the essentials.',
    courseIds: [1, 2],
    benefitIds: [10, 20],
    planDetails: [
      PlanDetailDto(
        id: 201,
        durationInDays: 90,
        price: '2999',
        strikeThroughPrice: '3999',
      ),
    ],
  );

  group('ProductPlanCard Widget Tests', () {
    testWidgets('renders all plan details correctly', (tester) async {
      await tester.pumpWidget(
        wrap(
          ProductPlanCard(
            plan: testPlan,
            activePlanDetail: testPlan.planDetails.first,
            totalBenefitsCount: 8,
            isSelected: true,
            onSelect: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Basic Access'), findsOneWidget);
      expect(find.text('For self-learners who want the essentials.'),
          findsOneWidget);
      expect(find.text('₹2999'), findsOneWidget);
      expect(find.text('/ 90 days'), findsOneWidget);
      expect(find.text('₹3999'), findsOneWidget);
      expect(find.text('2 courses'), findsOneWidget);
      expect(find.text('2 of 8 benefits'), findsOneWidget);
    });

    testWidgets('triggers onSelect callback when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        wrap(
          ProductPlanCard(
            plan: testPlan,
            activePlanDetail: testPlan.planDetails.first,
            totalBenefitsCount: 8,
            isSelected: false,
            onSelect: () => tapped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Basic Access'));
      expect(tapped, isTrue);
    });

    testWidgets('renders selected and unselected semantic labels',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          ProductPlanCard(
            plan: testPlan,
            activePlanDetail: testPlan.planDetails.first,
            totalBenefitsCount: 8,
            isSelected: true,
            onSelect: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate((w) =>
            w is Semantics &&
            w.properties.label == 'Basic Access, ₹2999, selected'),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders unavailable message and disables selection when activePlanDetail is null',
        (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        wrap(
          ProductPlanCard(
            plan: testPlan,
            activePlanDetail: null,
            selectedDurationInDays: 30,
            totalBenefitsCount: 8,
            isSelected: false,
            onSelect: () => tapped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Not available for 30 days.'), findsOneWidget);
      expect(find.text('Available for 90 days.'), findsOneWidget);
      expect(find.text('₹2999'), findsNothing);

      await tester.tap(find.text('Basic Access'));
      expect(tapped, isFalse);
    });
  });
}
