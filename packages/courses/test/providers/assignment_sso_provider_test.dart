import 'package:flutter_test/flutter_test.dart';
import 'package:core/data/data.dart';
import 'package:courses/providers/assignment_sso_provider.dart';

void main() {
  group('buildAssignmentSsoUrl', () {
    test('constructs SSO URL with custom domainUrl and encoded next path', () {
      final url = buildAssignmentSsoUrl(
        ssoPath: '/sso/auth/?token=xyz',
        chapterSlug: 'thermodynamics',
        contentId: '54321',
        domainUrl: 'https://custom.portal.com',
      );

      expect(
        url,
        'https://custom.portal.com/sso/auth/?token=xyz&next=%2Fchapters%2Fthermodynamics%2F54321%2F',
      );
    });

    test('adds https:// and strips trailing slash from domainUrl', () {
      final url = buildAssignmentSsoUrl(
        ssoPath: 'sso/token/',
        chapterSlug: 'algebra',
        contentId: '1001',
        domainUrl: 'portal.myinstitute.com/',
      );

      expect(
        url,
        'https://portal.myinstitute.com/sso/token/?next=%2Fchapters%2Falgebra%2F1001%2F',
      );
    });

    test('falls back to apiBaseUrl host when domainUrl is null or empty', () {
      final url = buildAssignmentSsoUrl(
        ssoPath: '/sso/token/',
        chapterSlug: 'chapter-1',
        contentId: '99',
        domainUrl: null,
        apiBaseUrl: 'https://api.testpress.in/api/v2.5/',
      );

      expect(
        url,
        'https://api.testpress.in/sso/token/?next=%2Fchapters%2Fchapter-1%2F99%2F',
      );
    });
  });

  group('AssignmentUrlParams.fromLesson', () {
    test('extracts chapterSlug directly from lesson', () {
      final lesson = LessonDto(
        id: '123',
        chapterId: '10',
        chapterSlug: 'organic-chemistry',
        title: 'Lab Report',
        type: LessonType.assignment,
        duration: '00:00:00',
        progressStatus: LessonProgressStatus.notStarted,
        isLocked: false,
        orderIndex: 1,
      );

      final params = AssignmentUrlParams.fromLesson(lesson);
      expect(params.chapterSlug, 'organic-chemistry');
      expect(params.contentId, '123');
    });

    test(
        'extracts chapterSlug from contentUrl regex fallback when chapterSlug is null',
        () {
      final lesson = LessonDto(
        id: '456',
        chapterId: '20',
        chapterSlug: null,
        contentUrl: 'https://portal.in/chapters/mechanics-101/456/',
        title: 'Mechanics Assignment',
        type: LessonType.assignment,
        duration: '00:00:00',
        progressStatus: LessonProgressStatus.notStarted,
        isLocked: false,
        orderIndex: 2,
      );

      final params = AssignmentUrlParams.fromLesson(lesson);
      expect(params.chapterSlug, 'mechanics-101');
      expect(params.contentId, '456');
    });

    test(
        'falls back to chapterId when neither chapterSlug nor contentUrl match',
        () {
      final lesson = LessonDto(
        id: '789',
        chapterId: 'chap-55',
        chapterSlug: null,
        contentUrl: null,
        title: 'Fallback Assignment',
        type: LessonType.assignment,
        duration: '00:00:00',
        progressStatus: LessonProgressStatus.notStarted,
        isLocked: false,
        orderIndex: 3,
      );

      final params = AssignmentUrlParams.fromLesson(lesson);
      expect(params.chapterSlug, 'chap-55');
      expect(params.contentId, '789');
    });
  });

  group('isAllowedAssignmentNavigation', () {
    const allowedHost = 'portal.myinstitute.com';
    const chapterSlug = 'kinematics';
    const contentId = '777';

    test('allows SSO authentication routes (/sso/ and /sso_login)', () {
      expect(
        isAllowedAssignmentNavigation(
          requestUrl: 'https://portal.myinstitute.com/sso/auth/?token=123',
          allowedHost: allowedHost,
          chapterSlug: chapterSlug,
          contentId: contentId,
        ),
        isTrue,
      );

      expect(
        isAllowedAssignmentNavigation(
          requestUrl:
              'https://portal.myinstitute.com/sso_login/?sig=abc123&sso=xyz',
          allowedHost: allowedHost,
          chapterSlug: chapterSlug,
          contentId: contentId,
        ),
        isTrue,
      );

      expect(
        isAllowedAssignmentNavigation(
          requestUrl:
              'https://portal.myinstitute.com/sso_login?sig=abc123&sso=xyz',
          allowedHost: allowedHost,
          chapterSlug: chapterSlug,
          contentId: contentId,
        ),
        isTrue,
      );
    });

    test('allows canonical assignment content url', () {
      final allowed = isAllowedAssignmentNavigation(
        requestUrl: 'https://portal.myinstitute.com/chapters/kinematics/777/',
        allowedHost: allowedHost,
        chapterSlug: chapterSlug,
        contentId: contentId,
      );
      expect(allowed, isTrue);
    });

    test('allows assignment submission endpoints', () {
      final allowed = isAllowedAssignmentNavigation(
        requestUrl:
            'https://portal.myinstitute.com/chapters/kinematics/777/submit/',
        allowedHost: allowedHost,
        chapterSlug: chapterSlug,
        contentId: contentId,
      );
      expect(allowed, isTrue);
    });

    test('allows generic /assignments/ routes', () {
      final allowed = isAllowedAssignmentNavigation(
        requestUrl: 'https://portal.myinstitute.com/assignments/attempts/save/',
        allowedHost: allowedHost,
        chapterSlug: chapterSlug,
        contentId: contentId,
      );
      expect(allowed, isTrue);
    });

    test(
        'blocks navigation away to other portal pages like /courses/ or /profile/',
        () {
      final coursesAllowed = isAllowedAssignmentNavigation(
        requestUrl: 'https://portal.myinstitute.com/courses/',
        allowedHost: allowedHost,
        chapterSlug: chapterSlug,
        contentId: contentId,
      );
      expect(coursesAllowed, isFalse);

      final profileAllowed = isAllowedAssignmentNavigation(
        requestUrl: 'https://portal.myinstitute.com/profile/settings/',
        allowedHost: allowedHost,
        chapterSlug: chapterSlug,
        contentId: contentId,
      );
      expect(profileAllowed, isFalse);

      final arbitrarySsoAllowed = isAllowedAssignmentNavigation(
        requestUrl: 'https://portal.myinstitute.com/ssoportal/',
        allowedHost: allowedHost,
        chapterSlug: chapterSlug,
        contentId: contentId,
      );
      expect(arbitrarySsoAllowed, isFalse);
    });

    test('blocks look-alike non-SSO routes', () {
      final lookAlikes = [
        'https://portal.myinstitute.com/ssomalicious/',
        'https://portal.myinstitute.com/sso_other/',
        'https://portal.myinstitute.com/sso-logout/',
        'https://portal.myinstitute.com/sso_login_fake/',
      ];

      for (final url in lookAlikes) {
        expect(
          isAllowedAssignmentNavigation(
            requestUrl: url,
            allowedHost: allowedHost,
            chapterSlug: chapterSlug,
            contentId: contentId,
          ),
          isFalse,
          reason: 'Expected $url to be blocked',
        );
      }
    });

    test('blocks navigation to external third-party domains', () {
      final externalAllowed = isAllowedAssignmentNavigation(
        requestUrl: 'https://www.google.com/search?q=test',
        allowedHost: allowedHost,
        chapterSlug: chapterSlug,
        contentId: contentId,
      );
      expect(externalAllowed, isFalse);
    });

    test('blocks non-http/https schemes', () {
      final schemeAllowed = isAllowedAssignmentNavigation(
        requestUrl: 'javascript:void(0)',
        allowedHost: allowedHost,
        chapterSlug: chapterSlug,
        contentId: contentId,
      );
      expect(schemeAllowed, isFalse);
    });
  });

  group('isDownloadOrMediaUrl', () {
    test('identifies typical attachment and media URLs as downloads', () {
      expect(
        isDownloadOrMediaUrl(
            Uri.parse('https://s3.amazonaws.com/bucket/doc.pdf')),
        isTrue,
      );
      expect(
        isDownloadOrMediaUrl(
            Uri.parse('https://portal.com/media/attachments/file.zip')),
        isTrue,
      );
      expect(
        isDownloadOrMediaUrl(
            Uri.parse('https://portal.com/download/assignment-template/')),
        isTrue,
      );
      expect(
        isDownloadOrMediaUrl(
            Uri.parse('https://portal.com/files/export?download=true')),
        isTrue,
      );
    });

    test('returns false for standard web pages', () {
      expect(
        isDownloadOrMediaUrl(
            Uri.parse('https://portal.com/chapters/slug/123/')),
        isFalse,
      );
      expect(
        isDownloadOrMediaUrl(Uri.parse('https://portal.com/sso/auth/')),
        isFalse,
      );
    });
  });
}
