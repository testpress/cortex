import 'dart:async';
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

      // TopCarousel should render the Carousel widget since it has banners
      expect(find.byType(HeroBannerCarousel), findsOneWidget);
    });

    testWidgets('shows skeleton during initial bootstrap load', (tester) async {
      final overrides = [
        dashboardBootstrapProvider.overrideWith(
          (ref) => Completer<void>().future,
        ),
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
      await tester.pump();

      // On initial fetch (!hasValue), TopCarousel shows HeroBannerCarousel skeleton
      expect(find.byType(HeroBannerCarousel), findsOneWidget);
    });

    testWidgets(
      'does not show banner skeleton when bootstrap has completed and banners are empty',
      (tester) async {
        final overrides = [
          // Completed bootstrap (hasValue == true)
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
        await tester.pump();

        // Empty banners after bootstrap completion should cleanly hide carousel
        expect(find.byType(HeroBannerCarousel), findsNothing);
      },
    );

    testWidgets(
      'does not show banner skeleton on app reopen when lessons are cached even if bootstrap is running',
      (tester) async {
        final overrides = [
          // Uncompleted bootstrap (running in background on reopen)
          dashboardBootstrapProvider.overrideWith(
            (ref) => Completer<void>().future,
          ),
          heroBannersProvider.overrideWith(
            (ref) => Stream.value(<DashboardBannerDto>[]),
          ),
          resumeLearningFeedProvider.overrideWith(
            (ref) => Stream.value([
              const DashboardContentDto(
                id: '1',
                title: 'Current Electricity',
                contentType: DashboardContentType.video,
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

        // TopCarousel should not show HeroBannerCarousel skeleton because cache is already present
        expect(find.byType(HeroBannerCarousel), findsNothing);
      },
    );
  });
}
