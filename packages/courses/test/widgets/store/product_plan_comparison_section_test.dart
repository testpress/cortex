import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/widgets/store/product_plan_comparison_section.dart';
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

  const course1 =
      ProductCourseDto(id: 1, title: 'Prelims GS', slug: 'prelims-gs');
  const course2 = ProductCourseDto(id: 2, title: 'CSAT', slug: 'csat');
  const benefit1 = ProductBenefitDto(id: 10, name: 'Video Lectures');
  const benefit2 = ProductBenefitDto(id: 20, name: 'Mentorship Calls');

  final testProduct = ProductDto(
    id: 10,
    title: 'Test Course with Plans',
    slug: 'test-course-plans',
    price: '2999',
    courses: const [1, 2],
    coursesDetails: const [course1, course2],
    benefits: const [benefit1, benefit2],
    plans: const [
      SubscriptionPlanDto(
        id: 101,
        productId: 10,
        name: 'Basic Access',
        courseIds: [1],
        benefitIds: [10],
      ),
      SubscriptionPlanDto(
        id: 102,
        productId: 10,
        name: 'Premium Elite',
        courseIds: [1, 2],
        benefitIds: [10, 20],
      ),
    ],
  );

  group('ProductPlanComparisonSection Widget Tests', () {
    testWidgets('renders Compare plans header and segmented tabs',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          ProductPlanComparisonSection(
            product: testProduct,
            selectedPlanId: 101,
            onSelectPlan: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Compare plans'), findsOneWidget);
      expect(find.text('Basic Access'), findsOneWidget);
      expect(find.text('Premium Elite'), findsOneWidget);
      expect(find.text('Courses'), findsOneWidget);
      expect(find.text('Prelims GS'), findsOneWidget);
      expect(find.text('CSAT'), findsOneWidget);
      expect(find.text('What you get'), findsOneWidget);
      expect(find.text('Video Lectures'), findsOneWidget);
      expect(find.text('Mentorship Calls'), findsOneWidget);
    });

    testWidgets('shows included and not included indicators for active plan',
        (tester) async {
      // Basic Access has course 1 and benefit 10, but not course 2 or benefit 20
      await tester.pumpWidget(
        wrap(
          ProductPlanComparisonSection(
            product: testProduct,
            selectedPlanId: 101,
            onSelectPlan: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check semantic accessibility labels
      expect(
        find.byWidgetPredicate((w) =>
            w is Semantics && w.properties.label == 'Prelims GS: Included'),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate((w) =>
            w is Semantics && w.properties.label == 'CSAT: Not included'),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate((w) =>
            w is Semantics && w.properties.label == 'Video Lectures: Included'),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate((w) =>
            w is Semantics &&
            w.properties.label == 'Mentorship Calls: Not included'),
        findsOneWidget,
      );
    });

    testWidgets('triggers onSelectPlan when tab is tapped', (tester) async {
      int? selectedPlanId;
      await tester.pumpWidget(
        wrap(
          ProductPlanComparisonSection(
            product: testProduct,
            selectedPlanId: 101,
            onSelectPlan: (id) => selectedPlanId = id,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Premium Elite'));
      expect(selectedPlanId, 102);
    });
  });
}
