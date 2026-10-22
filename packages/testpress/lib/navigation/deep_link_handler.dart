import 'package:core/data/config/app_config.dart';
import 'package:core/data/config/institute_settings.dart';
import 'app_router.dart';

/// A single declarative rule mapping an incoming URL pattern to an internal route.
class DeepLinkRule {
  final List<String> patternSegments;
  final String target;
  final bool matchPrefix;
  final Map<String, Set<String>>? allowedParams;
  final Map<String, Set<String>>? excludedParams;

  DeepLinkRule(
    String pattern,
    this.target, {
    this.matchPrefix = false,
    this.allowedParams,
    this.excludedParams,
  }) : patternSegments = pattern.split('/').where((s) => s.isNotEmpty).toList();

  /// Attempts to match [segments] against this rule's pattern.
  /// Returns the substituted target route if matched, or `null` otherwise.
  String? match(List<String> segments) {
    if (matchPrefix) {
      if (segments.length < patternSegments.length) return null;
    } else {
      if (segments.length != patternSegments.length) return null;
    }

    final params = <String, String>{};
    for (int i = 0; i < patternSegments.length; i++) {
      final pSeg = patternSegments[i];
      final uSeg = segments[i];

      if (pSeg.startsWith(':')) {
        final lower = uSeg.toLowerCase();
        final allowed = allowedParams?[pSeg];
        if (allowed != null && !allowed.contains(lower)) {
          return null;
        }
        final excluded = excludedParams?[pSeg];
        if (excluded != null && excluded.contains(lower)) {
          return null;
        }
        params[pSeg] = uSeg;
      } else if (pSeg.toLowerCase() != uSeg.toLowerCase()) {
        return null;
      }
    }

    String result = target;
    params.forEach((paramName, paramValue) {
      result = result.replaceAll(paramName, paramValue);
    });
    return result;
  }
}

/// Utility to normalize external URLs and push notification deep links
/// into valid internal GoRouter routes using a declarative rule table.
class DeepLinkHandler {
  const DeepLinkHandler._();

  /// Default fallback destination when a route cannot be resolved or is invalid.
  static const String defaultRoute = '/home';

  /// Declarative table of URL pattern to internal target route rules.
  static final List<DeepLinkRule> rules = [
    // Dashboard & Home aliases
    DeepLinkRule('/dashboard', '/home'),
    DeepLinkRule('/learn', '/home'),
    DeepLinkRule('/leaderboard', '/home'),

    // Authentication
    DeepLinkRule('/login', '/login'),
    DeepLinkRule('/activate', '/signup'),
    DeepLinkRule('/register', '/signup'),
    DeepLinkRule('/signup', '/signup'),

    // Lessons & Chapter content (legacy exam chapter content is unified into lesson player)
    DeepLinkRule('/exams/chapter_content/:id', '/study/lesson/:id'),
    DeepLinkRule('/courses/:courseId/contents/:id', '/study/lesson/:id'),
    DeepLinkRule('/study/lesson/:id', '/study/lesson/:id'),

    // Course & Chapter hierarchy
    DeepLinkRule(
      '/courses/:courseId/chapters/:chapterId',
      '/study/course/:courseId/chapters/:chapterId',
    ),
    DeepLinkRule(
      '/study/course/:courseId/chapters/:chapterId',
      '/study/course/:courseId/chapters/:chapterId',
    ),
    DeepLinkRule(
      '/courses/:courseId/chapters',
      '/study/course/:courseId/chapters',
    ),
    DeepLinkRule(
      '/study/course/:courseId/chapters',
      '/study/course/:courseId/chapters',
    ),
    DeepLinkRule(
      '/courses/:courseId',
      '/study/course/:courseId/chapters',
      excludedParams: {
        ':courseId': {'chapters', 'contents'},
      },
    ),
    DeepLinkRule(
      '/study/course/:courseId',
      '/study/course/:courseId/chapters',
      excludedParams: {
        ':courseId': {'chapters', 'lesson'},
      },
    ),
    DeepLinkRule('/courses', '/study', matchPrefix: true),
    DeepLinkRule('/study', '/study', matchPrefix: true),

    // Exams (prefix match handles /exams, /exams/available, /exams/upcoming, /exams/history)
    DeepLinkRule('/exams', '/exams', matchPrefix: true),

    // Store & Products
    DeepLinkRule('/products/:slug', '/store/product/:slug'),
    DeepLinkRule('/store/product/:slug', '/store/product/:slug'),
    DeepLinkRule('/products', '/store'),
    DeepLinkRule('/store', '/store', matchPrefix: true),

    // Discussions & Forum
    DeepLinkRule(
      '/discussions/forum/posts/:slug',
      '/home/discussions/forum/posts/:slug',
    ),
    DeepLinkRule('/p/:slug', '/home/discussions/forum/posts/:slug'),
    DeepLinkRule('/posts/:slug', '/home/discussions/forum/posts/:slug'),
    DeepLinkRule('/discussions/doubts/:id', '/home/discussions/doubts/:id'),
    DeepLinkRule('/discussions/doubts', '/home/discussions/doubts'),
    DeepLinkRule('/discussions/forum', '/home/discussions/forum'),
    DeepLinkRule('/discussions', '/home/discussions/forum', matchPrefix: true),
    DeepLinkRule('/p', '/home/discussions/forum'),
    DeepLinkRule('/posts', '/home/discussions/forum'),

    // Profile & User
    DeepLinkRule(
      '/profile/:sub',
      '/profile/:sub',
      allowedParams: {
        ':sub': {
          'notifications',
          'edit',
          'settings',
          'login-activity',
          'certificates',
        },
      },
    ),
    DeepLinkRule(
      '/user/:sub',
      '/profile/:sub',
      allowedParams: {
        ':sub': {
          'notifications',
          'edit',
          'settings',
          'login-activity',
          'certificates',
        },
      },
    ),
    DeepLinkRule('/profile', '/profile', matchPrefix: true),
    DeepLinkRule('/user', '/profile', matchPrefix: true),

    // AI Chatbot
    DeepLinkRule(
      '/ai/:sub',
      '/ai/:sub',
      allowedParams: {
        ':sub': {'chat', 'history'},
      },
    ),
    DeepLinkRule('/ai', '/ai', matchPrefix: true),
  ];

  /// Resolves an incoming [rawUrl] (absolute URL, relative path, or custom scheme)
  /// to a recognized internal GoRouter path using the declarative rule table.
  ///
  /// Automatically strips query parameters, fragments, and trailing slashes.
  /// If the URL is empty, invalid, or unrecognized, [defaultRoute] is returned.
  static String resolve(String? rawUrl) {
    if (rawUrl == null) return defaultRoute;

    final trimmed = rawUrl.trim();
    if (trimmed.isEmpty) return defaultRoute;

    final uri = Uri.tryParse(trimmed);
    if (uri == null) return defaultRoute;

    List<String> segments = uri.pathSegments
        .where((s) => s.trim().isNotEmpty)
        .toList();

    // Support custom schemes (e.g. testpress://dashboard) where host acts as the first segment
    if (uri.scheme.isNotEmpty &&
        uri.scheme != 'http' &&
        uri.scheme != 'https' &&
        uri.host.isNotEmpty &&
        !uri.host.contains('.')) {
      segments = [uri.host, ...segments];
    }

    if (segments.isEmpty) return defaultRoute;

    for (final rule in rules) {
      final matched = rule.match(segments);
      if (matched != null) {
        return matched;
      }
    }

    return defaultRoute;
  }

  /// Filters a resolved [route] based on active navigation tabs and feature flags.
  ///
  /// If the destination feature or tab is disabled for the current institute build or
  /// configuration, returns a safe fallback route (e.g., '/study' for disabled exam tab,
  /// '/profile' for disabled certificates, or [defaultRoute]).
  static String filterRouteByAvailability(
    String route, {
    InstituteSettings? settings,
    bool? showExamTab,
    bool? showCertificate,
  }) {
    final effectiveShowCert = showCertificate ?? AppConfig.showCertificate;
    if (route.startsWith('/profile/certificates')) {
      if (!effectiveShowCert) {
        return '/profile';
      }
    }

    final effectiveShowExam = showExamTab ?? AppConfig.showExamTab;
    final activeTabs = NavTab.active(settings);

    if (route == '/exams' || route.startsWith('/exams/')) {
      if (!effectiveShowExam) {
        return activeTabs.contains(NavTab.study) ? '/study' : defaultRoute;
      }
    }

    if (route == '/store' || route.startsWith('/store/')) {
      if (!activeTabs.contains(NavTab.store)) {
        return defaultRoute;
      }
    }

    if (route == '/ai' || route.startsWith('/ai/')) {
      if (!activeTabs.contains(NavTab.ai)) {
        return defaultRoute;
      }
    }

    if (route == '/info' || route.startsWith('/info/')) {
      if (!activeTabs.contains(NavTab.info)) {
        return defaultRoute;
      }
    }

    return route;
  }
}
