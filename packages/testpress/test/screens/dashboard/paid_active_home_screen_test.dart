import 'package:core/data/data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:courses/courses.dart';
import 'package:testpress/screens/dashboard/paid_active_home_screen.dart';

void main() {
  Widget wrap(Widget child, {List<Override> overrides = const []}) {
    return ProviderScope(
      overrides: overrides,
      child: DesignProvider(
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
      ),
    );
  }

  group('PaidActiveHomeScreen Layout', () {
    testWidgets(
      'renders successfully without empty gaps when banners and schedules are empty',
      (tester) async {
        final overrides = [
          dashboardBootstrapProvider.overrideWith((ref) => null),
          heroBannersProvider.overrideWith(
            (ref) => Stream.value(<DashboardBannerDto>[]),
          ),
          todayClassesProvider.overrideWith((ref) => <LiveClassDto>[]),
          pendingAssignmentsProvider.overrideWith((ref) => <AssignmentDto>[]),
          upcomingTestsProvider.overrideWith((ref) => <ScheduledTest>[]),
        ];

        await tester.pumpWidget(
          wrap(const PaidActiveHomeScreen(), overrides: overrides),
        );
        await tester.pump(); // Render first frame
        await tester.pump(
          const Duration(milliseconds: 100),
        ); // Advance animations slightly

        // Verify the home screen rendered
        expect(find.byType(PaidActiveHomeScreen), findsOneWidget);

        // TopCarousel should not be rendering the Carousel widget since it's empty
        expect(find.byType(HeroBannerCarousel), findsNothing);
      },
    );

    testWidgets('renders successfully with banners present', (tester) async {
      final overrides = [
        dashboardBootstrapProvider.overrideWith((ref) => null),
        heroBannersProvider.overrideWith(
          (ref) => Stream.value([
            const DashboardBannerDto(
              id: '1',
              imageUrl: 'https://test.com/banner.png',
              title: 'Test Banner',
              link: '#',
            ),
          ]),
        ),
        todayClassesProvider.overrideWith((ref) => <LiveClassDto>[]),
        pendingAssignmentsProvider.overrideWith((ref) => <AssignmentDto>[]),
        upcomingTestsProvider.overrideWith((ref) => <ScheduledTest>[]),
      ];

      await tester.pumpWidget(
        wrap(const PaidActiveHomeScreen(), overrides: overrides),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify the home screen rendered
      expect(find.byType(PaidActiveHomeScreen), findsOneWidget);

      // TopCarousel should render the Carousel widget since it has banners
      expect(find.byType(HeroBannerCarousel), findsOneWidget);
    });
  });
}
