import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/network/auth_interceptor.dart';
import 'package:core/network/api_endpoints.dart';

void main() {
  group('AuthInterceptor', () {
    late List<String> sessionExpiredCalls;
    bool isLoggingOut = false;
    String? storedToken;

    setUp(() {
      sessionExpiredCalls = [];
      isLoggingOut = false;
      storedToken = 'valid_test_token';
    });

    AuthInterceptor createInterceptor({
      Future<String?> Function()? getToken,
      void Function(String message)? onSessionExpired,
      bool Function()? loggingOutCallback,
      bool Function()? isAuthenticatedCallback,
    }) {
      return AuthInterceptor(
        getToken: getToken ?? () async => storedToken,
        onSessionExpired:
            onSessionExpired ?? (msg) => sessionExpiredCalls.add(msg),
        isLoggingOut: loggingOutCallback ?? () => isLoggingOut,
        isAuthenticated: isAuthenticatedCallback,
      );
    }

    group('onRequest', () {
      test('attaches Authorization header for protected endpoints', () async {
        final interceptor = createInterceptor();
        final options = RequestOptions(path: '/api/v3/courses/');
        final handler = RequestInterceptorHandler();

        interceptor.onRequest(options, handler);
        await Future<void>.delayed(Duration.zero);

        expect(options.headers['Authorization'], 'JWT valid_test_token');
      });

      test(
        'does not attach Authorization header for auth flow endpoints',
        () async {
          final interceptor = createInterceptor();
          final options = RequestOptions(path: ApiEndpoints.login);
          final handler = RequestInterceptorHandler();

          interceptor.onRequest(options, handler);
          await Future<void>.delayed(Duration.zero);

          expect(options.headers['Authorization'], isNull);
        },
      );

      test('does not attach header when token is null or empty', () async {
        storedToken = null;
        final interceptor = createInterceptor();
        final options = RequestOptions(path: '/api/v3/courses/');
        final handler = RequestInterceptorHandler();

        interceptor.onRequest(options, handler);
        await Future<void>.delayed(Duration.zero);

        expect(options.headers['Authorization'], isNull);
      });
    });

    group('onError - 401 Session Expiry', () {
      DioException create401Exception({
        required String path,
        bool withAuthHeader = true,
        dynamic data,
      }) {
        final options = RequestOptions(
          path: path,
          headers: withAuthHeader ? {'Authorization': 'JWT test_token'} : {},
        );
        return DioException(
          requestOptions: options,
          response: Response(
            requestOptions: options,
            statusCode: 401,
            data: data ?? {'detail': 'Your session has expired.'},
          ),
          type: DioExceptionType.badResponse,
        );
      }

      ErrorInterceptorHandler createHandler() => _TestErrorHandler();

      test(
        'triggers onSessionExpired once when protected endpoint returns 401',
        () {
          final interceptor = createInterceptor();
          final err = create401Exception(path: '/api/v3/dashboard/');

          interceptor.onError(err, createHandler());

          expect(sessionExpiredCalls.length, 1);
          expect(sessionExpiredCalls.first, 'Your session has expired.');
        },
      );

      test(
        'ignores subsequent 401s while session expiry has already fired',
        () {
          final interceptor = createInterceptor();
          final err1 = create401Exception(path: '/api/v3/dashboard/');
          final err2 = create401Exception(path: '/api/v3/courses/');

          interceptor.onError(err1, createHandler());
          interceptor.onError(err2, createHandler());

          expect(sessionExpiredCalls.length, 1);
        },
      );

      test(
        'does NOT trigger onSessionExpired if request had no Authorization header',
        () {
          final interceptor = createInterceptor();
          // Request made with no token (e.g. after local token was cleared)
          final err = create401Exception(
            path: '/api/v3/dashboard/',
            withAuthHeader: false,
          );

          interceptor.onError(err, createHandler());

          expect(sessionExpiredCalls, isEmpty);
        },
      );

      test(
        'does NOT trigger onSessionExpired when manual logout is in progress',
        () {
          isLoggingOut = true;
          final interceptor = createInterceptor();
          final err = create401Exception(path: '/api/v3/dashboard/');

          interceptor.onError(err, createHandler());

          expect(sessionExpiredCalls, isEmpty);
        },
      );

      test('does NOT trigger onSessionExpired for logout endpoints', () {
        final interceptor = createInterceptor();
        final errLogout = create401Exception(path: ApiEndpoints.logout);
        final errLogoutDevices = create401Exception(
          path: ApiEndpoints.logoutDevices,
        );

        interceptor.onError(errLogout, createHandler());
        interceptor.onError(errLogoutDevices, createHandler());

        expect(sessionExpiredCalls, isEmpty);
      });

      test('does NOT trigger onSessionExpired for auth flow endpoints', () {
        final interceptor = createInterceptor();
        final errLogin = create401Exception(path: ApiEndpoints.login);
        final errVerifyOtp = create401Exception(path: ApiEndpoints.verifyOtp);
        final errSocialAuth = create401Exception(path: ApiEndpoints.socialAuth);

        interceptor.onError(errLogin, createHandler());
        interceptor.onError(errVerifyOtp, createHandler());
        interceptor.onError(errSocialAuth, createHandler());

        expect(sessionExpiredCalls, isEmpty);
      });

      test(
        'resetSessionExpiry allows future session expiry to trigger after re-login',
        () {
          final interceptor = createInterceptor();
          final err1 = create401Exception(path: '/api/v3/dashboard/');

          interceptor.onError(err1, createHandler());
          expect(sessionExpiredCalls.length, 1);

          // Simulate login / reset
          interceptor.resetSessionExpiry();

          // New session gets revoked later
          final err2 = create401Exception(path: '/api/v3/courses/');
          interceptor.onError(err2, createHandler());

          expect(sessionExpiredCalls.length, 2);
        },
      );

      test(
        'does NOT trigger onSessionExpired when user is unauthenticated (lingering post-logout request)',
        () {
          final interceptor = createInterceptor(
            isAuthenticatedCallback: () => false,
          );
          final err = create401Exception(path: '/api/v3/dashboard/');

          interceptor.onError(err, createHandler());

          expect(sessionExpiredCalls, isEmpty);
        },
      );

      test('racing 401s remain suppressed until explicit reset on login', () {
        final interceptor = createInterceptor();
        final err1 = create401Exception(path: '/api/v3/dashboard/');

        interceptor.onError(err1, createHandler());
        expect(sessionExpiredCalls.length, 1);

        // Subsequent 401s during the same session expiry remain suppressed
        final err2 = create401Exception(path: '/api/v3/courses/');
        interceptor.onError(err2, createHandler());
        expect(sessionExpiredCalls.length, 1);

        // Once re-authenticated / new login starts, guard is reset
        interceptor.resetSessionExpiry();
        final err3 = create401Exception(path: '/api/v3/courses/');
        interceptor.onError(err3, createHandler());
        expect(sessionExpiredCalls.length, 2);
      });
    });
  });
}

class _TestErrorHandler extends ErrorInterceptorHandler {
  _TestErrorHandler() {
    future.ignore();
  }
}
