import 'package:core/core.dart';
import 'package:profile/profile.dart';
import 'package:core/data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class MockAuth extends Auth {
  @override
  AuthState build() {
    return AuthState.authenticated(
      UserDto(
        id: 'u1',
        name: 'Alex',
        avatar: '',
        joinedDate: DateTime(2023, 1, 1),
      ),
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
        profileEnrollmentProvider.overrideWith(
          (ref) => Stream.value(<CourseDto>[]),
        ),
        profileRecentActivityProvider.overrideWith((ref) async => const []),
        // Certificates provider can stay as is if it uses local mock data
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

  group('CertificatesScreen', () {
    testWidgets('renders paid-active certificates list', (tester) async {
      await tester.pumpWidget(
        _wrap(CertificatesScreen(onBack: () {}, onOpenPreview: (_) {})),
      );
      await tester.pumpAndSettle();

      final l10n = L10n.of(tester.element(find.byType(CertificatesScreen)));

      expect(find.text(l10n.profileCertificates), findsOneWidget);
      expect(find.text(l10n.certificatesSubtitleAvailable), findsOneWidget);
      expect(find.text(l10n.certificatesUnlockedBadge), findsOneWidget);
      expect(find.text(l10n.certificatesLockedBadge), findsNWidgets(3));
    });

    testWidgets('opens preview callback from unlocked card', (tester) async {
      CourseCertificate? opened;

      await tester.pumpWidget(
        _wrap(
          CertificatesScreen(
            onBack: () {},
            onOpenPreview: (certificate) => opened = certificate,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final l10n = L10n.of(tester.element(find.byType(CertificatesScreen)));
      await tester.tap(find.text(l10n.certificatesViewCertificate));
      await tester.pumpAndSettle();

      expect(opened, isNotNull);
      expect(opened?.isLocked, isFalse);
    });

    testWidgets('navigates Profile -> Certificates -> Preview -> back', (
      tester,
    ) async {
      final router = GoRouter(
        initialLocation: '/profile',
        routes: [
          GoRoute(
            path: '/profile',
            builder: (context, state) => ProfilePage(
              onOpenCertificates: () =>
                  context.pushNamed('profile-certificates'),
            ),
            routes: [
              GoRoute(
                name: 'profile-certificates',
                path: 'certificates',
                builder: (context, state) {
                  return CertificatesScreen(
                    onBack: () => context.pop(),
                    onOpenPreview: (certificate) {
                      context.pushNamed(
                        'profile-certificate-preview',
                        extra: certificate,
                      );
                    },
                  );
                },
                routes: [
                  GoRoute(
                    name: 'profile-certificate-preview',
                    path: 'preview',
                    builder: (context, state) {
                      return CertificatePreviewScreen(
                        certificate: state.extra! as CourseCertificate,
                        onClose: () => context.pop(),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(_wrapRouter(router));
      await tester.pumpAndSettle();

      final profileL10n = L10n.of(tester.element(find.byType(ProfilePage)));
      final certificatesItem = find.text(profileL10n.profileCertificates);
      await tester.ensureVisible(certificatesItem);
      await tester.tap(certificatesItem, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.byType(CertificatesScreen), findsOneWidget);

      final certificatesL10n = L10n.of(
        tester.element(find.byType(CertificatesScreen)),
      );
      await tester.tap(find.text(certificatesL10n.certificatesViewCertificate));
      await tester.pumpAndSettle();

      expect(find.byType(CertificatePreviewScreen), findsOneWidget);

      final previewL10n = L10n.of(
        tester.element(find.byType(CertificatePreviewScreen)),
      );
      expect(find.text(previewL10n.certificatesPreviewTitle), findsOneWidget);

      await tester.tap(find.byIcon(LucideIcons.x));
      await tester.pumpAndSettle();
      expect(find.byType(CertificatesScreen), findsOneWidget);
    });
  });
}
