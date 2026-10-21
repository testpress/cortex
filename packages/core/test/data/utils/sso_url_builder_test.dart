import 'package:flutter_test/flutter_test.dart';
import 'package:core/data/data.dart';

void main() {
  group('buildAuthenticatedSsoUrl', () {
    test('constructs SSO URL with custom domainUrl and encoded next path', () {
      final url = buildAuthenticatedSsoUrl(
        ssoPath: '/sso/auth/?token=xyz',
        nextPath: '/messages/?testpress_app=1',
        domainUrl: 'https://custom.portal.com',
      );

      expect(
        url,
        'https://custom.portal.com/sso/auth/?token=xyz&next=%2Fmessages%2F%3Ftestpress_app%3D1',
      );
    });

    test('adds https:// and strips trailing slash from domainUrl', () {
      final url = buildAuthenticatedSsoUrl(
        ssoPath: 'sso/token/',
        nextPath: '/messages/?testpress_app=1',
        domainUrl: 'portal.myinstitute.com/',
      );

      expect(
        url,
        'https://portal.myinstitute.com/sso/token/?next=%2Fmessages%2F%3Ftestpress_app%3D1',
      );
    });

    test(
      'normalizes ssoPath without leading slash and appends query parameter',
      () {
        final url = buildAuthenticatedSsoUrl(
          ssoPath: 'sso/token',
          nextPath: '/report/',
          domainUrl: 'https://test.testpress.in',
        );

        expect(url, 'https://test.testpress.in/sso/token?next=%2Freport%2F');
      },
    );

    test(
      'handles ssoPath with existing query parameters using ampersand separator',
      () {
        final url = buildAuthenticatedSsoUrl(
          ssoPath: '/sso/token/?token=abc',
          nextPath: '/report/',
          domainUrl: 'https://test.testpress.in',
        );

        expect(
          url,
          'https://test.testpress.in/sso/token/?token=abc&next=%2Freport%2F',
        );
      },
    );

    test('falls back to apiBaseUrl when domainUrl is null or empty', () {
      final url = buildAuthenticatedSsoUrl(
        ssoPath: '/sso/token/',
        nextPath: '/messages/?testpress_app=1',
        domainUrl: null,
        apiBaseUrl: 'https://api.testpress.in/api/v2.5/',
      );

      expect(
        url,
        'https://api.testpress.in/sso/token/?next=%2Fmessages%2F%3Ftestpress_app%3D1',
      );
    });

    test('falls back to apiBaseUrl with port when domainUrl is empty', () {
      final url = buildAuthenticatedSsoUrl(
        ssoPath: '/sso/token/',
        nextPath: '/messages/?testpress_app=1',
        domainUrl: '',
        apiBaseUrl: 'http://localhost:8000/api/v2.5/',
      );

      expect(
        url,
        'http://localhost:8000/sso/token/?next=%2Fmessages%2F%3Ftestpress_app%3D1',
      );
    });
  });
}
