import 'package:core/core.dart';
import '../deep_link_handler.dart';

/// Top-level routes that intercept external web URLs / Android App Links and
/// redirect them to the appropriate internal destination using [DeepLinkHandler].
class DeepLinkRoutes {
  static const List<String> paths = [
    // 1. Lessons & Chapter contents (Lecture, Video, PDF, Notes, Exam content)
    '/courses/:courseId/contents/:id',
    '/exams/chapter_content/:id',
    '/chapters/:chapterId/:id',

    // 2. Course modules (Chapters) & Course hierarchy
    '/courses/:courseId/chapters/:chapterId',
    '/courses/:courseId/chapters',
    '/courses/:courseId',
    '/courses',
    '/chapters/:chapterId',

    // 3. Learn aliases for courses & hierarchy
    '/learn/:courseId/chapters/:chapterId',
    '/learn/:courseId/contents/:id',
    '/learn/:courseId/chapters',
    '/learn/:courseId',
    '/learn',

    // 4. Store & Products
    '/products/:slug',
    '/products',

    // 5. Posts & Announcements (Blog posts)
    '/posts/:slug',
    '/p/:slug',
    '/posts',
    '/p',

    // 6. Dashboard / Home aliases
    '/dashboard',
    '/leaderboard',

    // 7. Discussions & Forum
    '/discussions/forum/posts/:slug',
    '/discussions/doubts/:id',
    '/discussions/doubts',
    '/discussions/forum',
    '/discussions',
  ];

  static List<RouteBase> get routes => paths
      .map(
        (path) => GoRoute(
          path: path,
          redirect: (context, state) =>
              DeepLinkHandler.resolve(state.uri.toString()),
        ),
      )
      .toList();
}
