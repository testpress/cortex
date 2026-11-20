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

  testWidgets(
      'renders correct dot count with active dot expanded for multiple banners',
      (tester) async {
    await tester.pumpWidget(
      wrap(
        const HeroBannerCarousel(
          banners: [banner1, banner2],
        ),
      ),
    );
    await tester.pump();

    // Verify indicator dots count and dimensions (decoupled from styling colors)
    final dotFinders = find.byType(AnimatedContainer);
    expect(dotFinders, findsNWidgets(2));

    final containers =
        tester.widgetList<AnimatedContainer>(dotFinders).toList();

    // First dot is active (expanded width 20dp)
    expect(containers[0].constraints?.maxWidth, 20.0);
    expect(containers[0].constraints?.maxHeight, 6.0);

    // Second dot is inactive (compact width 6dp)
    expect(containers[1].constraints?.maxWidth, 6.0);
    expect(containers[1].constraints?.maxHeight, 6.0);
  });

  testWidgets('does not render dark gradient overlay over banner images',
      (tester) async {
    await tester.pumpWidget(
      wrap(
        const HeroBannerCarousel(
          banners: [banner1, banner2],
        ),
      ),
    );
    await tester.pump();

    // Regression check: ensure no gradient overlay exists over the banner
    final gradientFinder = find.byWidgetPredicate((widget) {
      if (widget is DecoratedBox && widget.decoration is BoxDecoration) {
        final decoration = widget.decoration as BoxDecoration;
        return decoration.gradient is LinearGradient;
      }
      return false;
    });

    expect(gradientFinder, findsNothing);
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

  testWidgets('renders accessibility semantics for banner items and indicator',
      (tester) async {
    await tester.pumpWidget(
      wrap(
        const HeroBannerCarousel(
          banners: [banner1, banner2],
        ),
      ),
    );
    await tester.pump();

    // Verify banner title semantics
    expect(find.bySemanticsLabel('Banner 1'), findsOneWidget);
    // Verify indicator page semantics
    expect(find.bySemanticsLabel('Page 1 of 2'), findsOneWidget);
  });
}
