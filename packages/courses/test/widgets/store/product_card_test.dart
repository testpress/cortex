import 'package:core/data/data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:courses/widgets/store/product_card.dart';

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

  group('ProductCard Widget Tests', () {
    final testProductWithStrikethrough = ProductDto(
      id: 1,
      title: 'BrahMos (All SSC Exams - 2027)',
      slug: 'brahmos-all-ssc',
      price: '2500.00',
      strikeThroughPrice: '4999.00',
      courses: [],
      image: '',
    );

    final testProductWithoutStrikethrough = ProductDto(
      id: 2,
      title: 'Word Power Made Easy',
      slug: 'word-power',
      price: '99.00',
      courses: [],
      image: '',
    );

    testWidgets('renders product title and normal price correctly',
        (tester) async {
      await tester.pumpWidget(
          wrap(ProductCard(product: testProductWithoutStrikethrough)));
      await tester.pumpAndSettle();

      expect(find.text('Word Power Made Easy'), findsOneWidget);
      expect(find.text('₹99.00'), findsOneWidget);
    });

    testWidgets(
        'renders both current price and strikethrough price when available',
        (tester) async {
      await tester
          .pumpWidget(wrap(ProductCard(product: testProductWithStrikethrough)));
      await tester.pumpAndSettle();

      expect(find.text('BrahMos (All SSC Exams - 2027)'), findsOneWidget);
      expect(find.text('₹2500.00'), findsOneWidget);
      expect(find.text('₹4999.00'), findsOneWidget);
    });

    testWidgets(
        'prices are wrapped in a FittedBox to prevent RenderFlex overflow',
        (tester) async {
      await tester
          .pumpWidget(wrap(ProductCard(product: testProductWithStrikethrough)));
      await tester.pumpAndSettle();

      // Find the row containing the prices
      final priceText = find.text('₹2500.00');

      // Look for a FittedBox ancestor above the price text
      final fittedBoxFinder = find.ancestor(
        of: priceText,
        matching: find.byType(FittedBox),
      );

      expect(fittedBoxFinder,
          findsWidgets); // Should find the FittedBox wrapping the Row

      // Verify the FittedBox uses scaleDown
      final FittedBox fittedBox = tester.widget(fittedBoxFinder.first);
      expect(fittedBox.fit, BoxFit.scaleDown);
    });
  });
}
