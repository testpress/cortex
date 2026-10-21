/// Utility to normalize external URLs and push notification deep links
/// into valid internal GoRouter routes.
class DeepLinkHandler {
  const DeepLinkHandler._();

  /// Default fallback destination when a route cannot be resolved or is invalid.
  static const String defaultRoute = '/home';

  /// Resolves an incoming [rawUrl] (absolute URL, relative path, or custom scheme)
  /// to a recognized internal GoRouter path.
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
        .where((s) => s.isNotEmpty)
        .toList();

    // Support custom schemes (e.g. testpress://dashboard) where host acts as the first segment
    if (uri.scheme.isNotEmpty &&
        uri.scheme != 'http' &&
        uri.scheme != 'https' &&
        uri.host.isNotEmpty &&
        !uri.host.contains('.')) {
      segments = [uri.host, ...segments];
    }

    if (segments.isEmpty) {
      return defaultRoute;
    }

    final first = segments[0].toLowerCase();

    switch (first) {
      case 'home':
      case 'dashboard':
      case 'learn':
      case 'leaderboard':
        return '/home';

      case 'login':
        return '/login';

      case 'activate':
      case 'register':
      case 'signup':
        return '/signup';

      case 'exams':
        if (segments.length >= 3 &&
            segments[1].toLowerCase() == 'chapter_content') {
          final contentId = segments[2];
          return '/study/lesson/$contentId';
        }
        return '/exams';

      case 'courses':
        if (segments.length >= 4 && segments[2].toLowerCase() == 'contents') {
          // /courses/:courseId/contents/:contentId
          final contentId = segments[3];
          return '/study/lesson/$contentId';
        }
        if (segments.length >= 4 && segments[2].toLowerCase() == 'chapters') {
          // /courses/:courseId/chapters/:chapterId
          final courseId = segments[1];
          final chapterId = segments[3];
          return '/study/course/$courseId/chapters/$chapterId';
        }
        if (segments.length >= 2 && segments[1].toLowerCase() != 'chapters') {
          // /courses/:courseId
          final courseId = segments[1];
          return '/study/course/$courseId/chapters';
        }
        return '/study';

      case 'chapters':
        if (segments.length >= 3) {
          // /chapters/:chapterId/:contentId
          final contentId = segments[2];
          return '/study/lesson/$contentId';
        }
        return '/study';

      case 'products':
        if (segments.length >= 2) {
          final slug = segments[1];
          return '/store/product/$slug';
        }
        return '/store';

      case 'store':
        if (segments.length >= 3 && segments[1].toLowerCase() == 'product') {
          final slug = segments[2];
          return '/store/product/$slug';
        }
        return '/store';

      case 'p':
      case 'posts':
        if (segments.length >= 2) {
          final slug = segments[1];
          return '/home/discussions/forum/posts/$slug';
        }
        return '/home/discussions/forum';

      case 'study':
        // Already an internal study route path (e.g. /study, /study/lesson/:id)
        final path = uri.path.startsWith('/') ? uri.path : '/${uri.path}';
        return (path.length > 1 && path.endsWith('/'))
            ? path.substring(0, path.length - 1)
            : path;

      case 'discussions':
        return '/home/${segments.join('/')}';

      case 'profile':
      case 'ai':
        return '/$first';

      default:
        return defaultRoute;
    }
  }
}
