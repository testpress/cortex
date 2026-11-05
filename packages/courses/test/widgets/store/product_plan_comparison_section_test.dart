import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/widgets/store/product_plan_comparison_section.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child, {bool isDark = false}) {
    return DesignProvider(
      config: isDark ? DesignConfig.dark() : DesignConfig.defaults(),
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

  group('ProductPlanComparisonSection Matrix Table Tests', () {
    testWidgets(
        'renders Plans header, section headers, plan column headers, and rows',
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
      expect(find.text('Plans'), findsOneWidget);
      expect(find.text('Basic Access'), findsOneWidget);
      expect(find.text('Premium Elite'), findsOneWidget);
      expect(find.text('Courses'), findsOneWidget);
      expect(find.text('Prelims GS'), findsOneWidget);
      expect(find.text('CSAT'), findsOneWidget);
      expect(find.text('What you get'), findsOneWidget);
      expect(find.text('Video Lectures'), findsOneWidget);
      expect(find.text('Mentorship Calls'), findsOneWidget);

      // Verify check and x icons are rendered
      expect(find.byIcon(LucideIcons.check), findsWidgets);
      expect(find.byIcon(LucideIcons.x), findsWidgets);

      // Verify selected state on plan headers (plan 101 is selected)
      expect(
        find.byWidgetPredicate((w) =>
            w is Semantics && w.properties.label == 'Basic Access, selected'),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
            (w) => w is Semantics && w.properties.label == 'Premium Elite'),
        findsOneWidget,
      );
    });

    testWidgets('shows included and not included indicators across plans',
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

      // Check semantic accessibility labels for each plan column
      expect(
        find.byWidgetPredicate((w) =>
            w is Semantics &&
            w.properties.label == 'Prelims GS, Basic Access: Included'),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate((w) =>
            w is Semantics &&
            w.properties.label == 'Prelims GS, Premium Elite: Included'),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate((w) =>
            w is Semantics &&
            w.properties.label == 'CSAT, Basic Access: Not included'),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate((w) =>
            w is Semantics &&
            w.properties.label == 'CSAT, Premium Elite: Included'),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate((w) =>
            w is Semantics &&
            w.properties.label == 'Video Lectures, Basic Access: Included'),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate((w) =>
            w is Semantics &&
            w.properties.label == 'Video Lectures, Premium Elite: Included'),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate((w) =>
            w is Semantics &&
            w.properties.label ==
                'Mentorship Calls, Basic Access: Not included'),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate((w) =>
            w is Semantics &&
            w.properties.label == 'Mentorship Calls, Premium Elite: Included'),
        findsOneWidget,
      );
    });

    testWidgets(
        'highlights selected plan column with tint in light and dark mode',
        (tester) async {
      // Light mode test
      await tester.pumpWidget(
        wrap(
          ProductPlanComparisonSection(
            product: testProduct,
            selectedPlanId: 102,
            onSelectPlan: (_) {},
          ),
          isDark: false,
        ),
      );
      await tester.pumpAndSettle();

      // Header text for Premium Elite should have the accent blue color
      final textWidgetLight = tester.widget<AppText>(
        find.descendant(
          of: find.bySemanticsLabel('Premium Elite, selected'),
          matching: find.byType(AppText),
        ),
      );
      expect(textWidgetLight.color, const Color(0xFF1D4ED8));

      // Dark mode test
      await tester.pumpWidget(
        wrap(
          ProductPlanComparisonSection(
            product: testProduct,
            selectedPlanId: 102,
            onSelectPlan: (_) {},
          ),
          isDark: true,
        ),
      );
      await tester.pumpAndSettle();

      final textWidgetDark = tester.widget<AppText>(
        find.descendant(
          of: find.bySemanticsLabel('Premium Elite, selected'),
          matching: find.byType(AppText),
        ),
      );
      expect(textWidgetDark.color, DesignColors.dark().accent2);
    });

    testWidgets('triggers onSelectPlan when plan column header is tapped',
        (tester) async {
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
