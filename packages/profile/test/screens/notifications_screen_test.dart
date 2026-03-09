import 'package:core/core.dart';
import 'package:profile/profile.dart';
import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class MockAuth extends Auth {
  @override
  UserDto build() {
    return UserDto(
      id: 'u1',
      name: 'Alex',
      avatar: '',
      joinedDate: DateTime(2023, 1, 1),
    );
  }
}

void main() {
  ProviderScope _buildScope({required Widget child}) {
    return ProviderScope(
      overrides: [
        authProvider.overrideWith(MockAuth.new),
        studyMomentumProvider.overrideWith(
          (ref) async => const StudyMomentumDto(
            weekDays: [],
            weeklyHours: 0,
            currentStreak: 0,
            lessonsFinished: 0,
            testsAttempted: 0,
            assessmentsDone: 0,
            strongestSubject: '',
            weakSubject: '',
          ),
        ),
        enrollmentProvider.overrideWith((ref) => Stream.value(<CourseDto>[])),
        profileRecentActivityProvider.overrideWith((ref) async => const []),
      ],
      child: child,
    );
  }

  Widget _wrap(Widget child) {
    return _buildScope(
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

  Widget _wrapRouter(GoRouter router) {
    return _buildScope(
      child: DesignProvider(
        config: DesignConfig.defaults(),
        child: LocalizationProvider(
          child: Builder(
            builder: (context) {
              final locale = LocalizationProvider.of(context).locale;
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                routerConfig: router,
                locale: locale,
                localizationsDelegates: LocalizationProvider.delegates,
                supportedLocales: LocalizationProvider.supportedLocales,
              );
            },
          ),
        ),
      ),
    );
  }

  group('NotificationsScreen', () {
    testWidgets('renders header, subtitle and four preference rows', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const NotificationsScreen(onBack: _dummyBack)),
      );
      await tester.pumpAndSettle();

      final l10n = L10n.of(tester.element(find.byType(NotificationsScreen)));

      expect(find.text(l10n.profileNotifications), findsOneWidget);
      expect(find.text(l10n.notificationsManagePreferences), findsOneWidget);
      expect(find.text(l10n.notificationsLiveClassReminders), findsOneWidget);
      expect(find.text(l10n.notificationsTestAssessmentAlerts), findsOneWidget);
      expect(find.text(l10n.notificationsAnnouncementsUpdates), findsOneWidget);
      expect(find.text(l10n.notificationsAchievementsBadges), findsOneWidget);
    });

    testWidgets(
      'uses expected default toggle states and updates independently',
      (tester) async {
        await tester.pumpWidget(
          _wrap(const NotificationsScreen(onBack: _dummyBack)),
        );
        await tester.pumpAndSettle();

        final container = ProviderScope.containerOf(
          tester.element(find.byType(NotificationsScreen)),
        );

        final defaults = container.read(notificationPreferencesProvider);
        expect(defaults.liveClassReminders, isTrue);
        expect(defaults.testAssessmentAlerts, isTrue);
        expect(defaults.announcementsUpdates, isFalse);
        expect(defaults.achievementsBadges, isTrue);

        await tester.tap(find.byKey(const ValueKey('notifications-row-live')));
        await tester.pumpAndSettle();

        final afterLiveToggle = container.read(notificationPreferencesProvider);
        expect(afterLiveToggle.liveClassReminders, isFalse);
        expect(afterLiveToggle.testAssessmentAlerts, isTrue);
        expect(afterLiveToggle.announcementsUpdates, isFalse);
        expect(afterLiveToggle.achievementsBadges, isTrue);

        await tester.tap(
          find.byKey(const ValueKey('notifications-row-achievements')),
        );
        await tester.pumpAndSettle();

        final afterAchievementToggle = container.read(
          notificationPreferencesProvider,
        );
        expect(afterAchievementToggle.liveClassReminders, isFalse);
        expect(afterAchievementToggle.testAssessmentAlerts, isTrue);
        expect(afterAchievementToggle.announcementsUpdates, isFalse);
        expect(afterAchievementToggle.achievementsBadges, isFalse);
      },
    );

    testWidgets('navigates Profile -> Notifications and back to Profile', (
      tester,
    ) async {
      final router = GoRouter(
        initialLocation: '/profile',
        routes: [
          GoRoute(
            path: '/profile',
            builder: (context, state) => ProfilePage(
              onOpenNotifications: () => context.push('/profile/notifications'),
            ),
            routes: [
              GoRoute(
                path: 'notifications',
                builder: (context, state) {
                  return NotificationsScreen(onBack: () => context.pop());
                },
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(_wrapRouter(router));
      await tester.pumpAndSettle();

      final profileL10n = L10n.of(tester.element(find.byType(ProfilePage)));
      expect(
        find.text(profileL10n.profileAccountSettingsTitle),
        findsOneWidget,
      );

      final notificationsEntry = find.text(profileL10n.profileNotifications);
      await tester.ensureVisible(notificationsEntry);
      await tester.tap(notificationsEntry, warnIfMissed: false);
      await tester.pumpAndSettle();

      final notificationsL10n = L10n.of(
        tester.element(find.byType(NotificationsScreen)),
      );
      expect(
        find.text(notificationsL10n.notificationsManagePreferences),
        findsOneWidget,
      );

      await tester.tap(find.text(notificationsL10n.curriculumBackButton));
      await tester.pumpAndSettle();
      expect(
        find.text(profileL10n.profileAccountSettingsTitle),
        findsOneWidget,
      );
    });
  });
}

void _dummyBack() {}
