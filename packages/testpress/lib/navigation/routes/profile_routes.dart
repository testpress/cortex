import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:profile/profile.dart';

class ProfileRoutes {
  static List<RouteBase> routes(GlobalKey<NavigatorState> rootNavigatorKey) => [
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfilePage(),
          routes: [
            GoRoute(
              name: 'profile-notifications',
              path: 'notifications',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) {
                return NotificationsScreen(onBack: () => context.pop());
              },
            ),
            GoRoute(
              name: 'profile-edit',
              path: 'edit',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) {
                return const EditProfileScreen();
              },
            ),
            GoRoute(
              name: 'profile-settings',
              path: 'settings',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) {
                return AppSettingsScreen(onBack: () => context.pop());
              },
            ),
            GoRoute(
              name: 'profile-certificates',
              path: 'certificates',
              parentNavigatorKey: rootNavigatorKey,
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
                  redirect: (context, state) {
                    if (state.extra is! CourseCertificate) {
                      return state.namedLocation('profile-certificates');
                    }
                    return null;
                  },
                  builder: (context, state) {
                    final certificate = state.extra as CourseCertificate;
                    return CertificatePreviewScreen(
                      certificate: certificate,
                      onClose: () => context.pop(),
                    );
                  },
                  parentNavigatorKey: rootNavigatorKey,
                ),
              ],
            ),
          ],
        ),
      ];
}
