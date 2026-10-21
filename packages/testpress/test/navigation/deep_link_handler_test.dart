import 'package:flutter_test/flutter_test.dart';
import 'package:testpress/navigation/deep_link_handler.dart';

void main() {
  group('DeepLinkHandler.resolve', () {
    test('returns /home for null, empty, or whitespace strings', () {
      expect(DeepLinkHandler.resolve(null), '/home');
      expect(DeepLinkHandler.resolve(''), '/home');
      expect(DeepLinkHandler.resolve('   '), '/home');
    });

    test('returns /home for root path or dashboard aliases', () {
      expect(DeepLinkHandler.resolve('/'), '/home');
      expect(DeepLinkHandler.resolve('https://staging.testpress.in'), '/home');
      expect(DeepLinkHandler.resolve('/dashboard'), '/home');
      expect(DeepLinkHandler.resolve('/dashboard/'), '/home');
      expect(DeepLinkHandler.resolve('/learn'), '/home');
      expect(DeepLinkHandler.resolve('/leaderboard'), '/home');
      expect(
        DeepLinkHandler.resolve(
          'https://staging.testpress.in/dashboard?ref=fcm',
        ),
        '/home',
      );
      expect(
        DeepLinkHandler.resolve('https://staging.testpress.in/learn/'),
        '/home',
      );
    });

    test('resolves authentication and registration URLs', () {
      expect(DeepLinkHandler.resolve('/login'), '/login');
      expect(
        DeepLinkHandler.resolve('https://staging.testpress.in/login'),
        '/login',
      );
      expect(DeepLinkHandler.resolve('/activate'), '/signup');
      expect(DeepLinkHandler.resolve('/register'), '/signup');
      expect(DeepLinkHandler.resolve('/signup'), '/signup');
    });

    test('resolves chapter content and lesson deep links', () {
      expect(
        DeepLinkHandler.resolve('/exams/chapter_content/2054'),
        '/study/lesson/2054',
      );
      expect(
        DeepLinkHandler.resolve(
          'https://staging.testpress.in/exams/chapter_content/2054/?content_detail_v2=true&use_htmx_for_partial_views=true',
        ),
        '/study/lesson/2054',
      );
      expect(
        DeepLinkHandler.resolve('/courses/12/contents/999'),
        '/study/lesson/999',
      );
      expect(
        DeepLinkHandler.resolve(
          'https://staging.testpress.in/courses/12/contents/999?preview=true',
        ),
        '/study/lesson/999',
      );
    });

    test('resolves course and chapter hierarchy links', () {
      expect(DeepLinkHandler.resolve('/courses'), '/study');
      expect(
        DeepLinkHandler.resolve('https://staging.testpress.in/courses/'),
        '/study',
      );
      expect(
        DeepLinkHandler.resolve('/courses/15'),
        '/study/course/15/chapters',
      );
      expect(
        DeepLinkHandler.resolve('/courses/15/chapters/22'),
        '/study/course/15/chapters/22',
      );
      expect(DeepLinkHandler.resolve('/courses/contents'), '/study');
      expect(DeepLinkHandler.resolve('/courses/chapters'), '/study');
      expect(DeepLinkHandler.resolve('/courses/chapters/5'), '/study');
    });

    test('resolves product and store deep links', () {
      expect(DeepLinkHandler.resolve('/products'), '/store');
      expect(DeepLinkHandler.resolve('/store'), '/store');
      expect(
        DeepLinkHandler.resolve('/products/upsc-test-series'),
        '/store/product/upsc-test-series',
      );
      expect(
        DeepLinkHandler.resolve(
          'https://staging.testpress.in/products/neet-crash-course?coupon=SAVE20',
        ),
        '/store/product/neet-crash-course',
      );
      expect(
        DeepLinkHandler.resolve('/store/product/neet-crash-course'),
        '/store/product/neet-crash-course',
      );
    });

    test('resolves forum and discussion post deep links', () {
      expect(
        DeepLinkHandler.resolve('/p/neet-2026-strategy-guide'),
        '/home/discussions/forum/posts/neet-2026-strategy-guide',
      );
      expect(
        DeepLinkHandler.resolve('/posts/physics-formula-cheatsheet'),
        '/home/discussions/forum/posts/physics-formula-cheatsheet',
      );
      expect(
        DeepLinkHandler.resolve(
          'https://staging.testpress.in/p/announcements-june-2026?utm_source=fcm',
        ),
        '/home/discussions/forum/posts/announcements-june-2026',
      );
      expect(DeepLinkHandler.resolve('/p'), '/home/discussions/forum');
      expect(DeepLinkHandler.resolve('/posts'), '/home/discussions/forum');
    });

    test('resolves exam list and sub-paths', () {
      expect(DeepLinkHandler.resolve('/exams'), '/exams');
      expect(DeepLinkHandler.resolve('/exams/available'), '/exams');
      expect(DeepLinkHandler.resolve('/exams/upcoming'), '/exams');
      expect(DeepLinkHandler.resolve('/exams/history'), '/exams');
      expect(
        DeepLinkHandler.resolve('https://staging.testpress.in/exams/'),
        '/exams',
      );
    });

    test('handles custom application schemes', () {
      expect(DeepLinkHandler.resolve('testpress://dashboard'), '/home');
      expect(
        DeepLinkHandler.resolve('testpress://study/lesson/1'),
        '/study/lesson/1',
      );
      expect(
        DeepLinkHandler.resolve('testpress://exams/chapter_content/2054'),
        '/study/lesson/2054',
      );
      expect(
        DeepLinkHandler.resolve('cortex://products/test-bundle'),
        '/store/product/test-bundle',
      );
    });

    test(
      'falls back safely to /home for unknown, malformed, or arbitrary URLs',
      () {
        expect(
          DeepLinkHandler.resolve(
            'https://staging.testpress.in/unknown/nonexistent/path',
          ),
          '/home',
        );
        expect(DeepLinkHandler.resolve('not-a-valid-known-path'), '/home');
        expect(DeepLinkHandler.resolve('/random/path/test'), '/home');
      },
    );

    test(
      'validates study paths and safely falls back on invalid sub-routes',
      () {
        expect(DeepLinkHandler.resolve('/study'), '/study');
        expect(
          DeepLinkHandler.resolve('/study/lesson/456'),
          '/study/lesson/456',
        );
        expect(
          DeepLinkHandler.resolve('/study/course/12/chapters/34'),
          '/study/course/12/chapters/34',
        );
        expect(
          DeepLinkHandler.resolve('/study/course/12/chapters'),
          '/study/course/12/chapters',
        );
        expect(DeepLinkHandler.resolve('/study/garbage'), '/study');
        expect(DeepLinkHandler.resolve('/study/lesson'), '/study');
        expect(
          DeepLinkHandler.resolve('testpress://study/lesson/123'),
          '/study/lesson/123',
        );
      },
    );

    test('validates discussions routes and maps sub-paths safely', () {
      expect(
        DeepLinkHandler.resolve('/discussions/doubts/12'),
        '/home/discussions/doubts/12',
      );
      expect(
        DeepLinkHandler.resolve('/discussions/doubts'),
        '/home/discussions/doubts',
      );
      expect(
        DeepLinkHandler.resolve('/discussions/forum/posts/test-slug'),
        '/home/discussions/forum/posts/test-slug',
      );
      expect(
        DeepLinkHandler.resolve('/discussions/forum'),
        '/home/discussions/forum',
      );
      expect(
        DeepLinkHandler.resolve('/discussions/unknown_subpath'),
        '/home/discussions/forum',
      );
    });

    test('validates profile and ai routes', () {
      expect(DeepLinkHandler.resolve('/profile'), '/profile');
      expect(
        DeepLinkHandler.resolve('/profile/notifications'),
        '/profile/notifications',
      );
      expect(DeepLinkHandler.resolve('/profile/settings'), '/profile/settings');
      expect(DeepLinkHandler.resolve('/profile/unknown'), '/profile');
      expect(DeepLinkHandler.resolve('/ai'), '/ai');
      expect(DeepLinkHandler.resolve('/ai/chat'), '/ai/chat');
      expect(DeepLinkHandler.resolve('/ai/history'), '/ai/history');
      expect(DeepLinkHandler.resolve('/ai/unknown'), '/ai');
    });
  });
}
