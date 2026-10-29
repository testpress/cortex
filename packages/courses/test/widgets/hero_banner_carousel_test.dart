import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:courses/widgets/hero_banner_carousel.dart';

void main() {
  Widget wrap(Widget child) {
    return DesignProvider(
      config: DesignConfig.defaults(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: child,
      ),
    );
  }

  const banner1 = HeroBanner(
    id: '1',
    imageUrl: '',
    title: 'Banner 1',
    link: 'https://example.com/1',
  );

  const banner2 = HeroBanner(
    id: '2',
    imageUrl: '',
    title: 'Banner 2',
    link: 'https://example.com/2',
  );

  testWidgets('renders indicator capsule when multiple banners are present',
      (tester) async {
    await tester.pumpWidget(
      wrap(
        const HeroBannerCarousel(
          banners: [banner1, banner2],
        ),
      ),
    );
    await tester.pump();

    // Verify indicator capsule container exists
    final capsuleFinder = find.byWidgetPredicate((widget) {
      if (widget is Container && widget.decoration is BoxDecoration) {
        final decoration = widget.decoration as BoxDecoration;
        return decoration.color == const Color(0x59000000) &&
            decoration.borderRadius == BorderRadius.circular(12);
      }
      return false;
    });

    expect(capsuleFinder, findsOneWidget);

    // Verify dots are rendered (2 dots for 2 banners)
    final animatedContainerFinder = find.byType(AnimatedContainer);
    expect(animatedContainerFinder, findsNWidgets(2));
  });

  testWidgets('does not render indicators when only one banner is present',
      (tester) async {
    await tester.pumpWidget(
      wrap(
        const HeroBannerCarousel(
          banners: [banner1],
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(AnimatedContainer), findsNothing);
  });
}
