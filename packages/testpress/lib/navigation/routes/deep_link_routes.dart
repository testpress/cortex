import 'package:core/core.dart';
import '../deep_link_handler.dart';

/// Top-level routes that intercept external web URLs / Android App Links and
/// redirect them to the appropriate internal destination using [DeepLinkHandler].
class DeepLinkRoutes {
  static List<RouteBase> get routes => [
    // 1. Lessons & Chapter contents (Lecture, Video, PDF, Notes, Exam content)
    GoRoute(
      path: '/courses/:courseId/contents/:id',
      redirect: (context, state) =>
          DeepLinkHandler.resolve(state.uri.toString()),
    ),
    GoRoute(
      path: '/exams/chapter_content/:id',
      redirect: (context, state) =>
          DeepLinkHandler.resolve(state.uri.toString()),
    ),
    GoRoute(
      path: '/chapters/:chapterId/:id',
      redirect: (context, state) =>
          DeepLinkHandler.resolve(state.uri.toString()),
    ),

    // 2. Course modules (Chapters) & Course hierarchy
    GoRoute(
      path: '/courses/:courseId/chapters/:chapterId',
      redirect: (context, state) =>
          DeepLinkHandler.resolve(state.uri.toString()),
    ),
    GoRoute(
      path: '/courses/:courseId/chapters',
      redirect: (context, state) =>
          DeepLinkHandler.resolve(state.uri.toString()),
    ),
    GoRoute(
      path: '/courses/:courseId',
      redirect: (context, state) =>
          DeepLinkHandler.resolve(state.uri.toString()),
    ),
    GoRoute(
      path: '/courses',
      redirect: (context, state) =>
          DeepLinkHandler.resolve(state.uri.toString()),
    ),
    GoRoute(
      path: '/chapters/:chapterId',
      redirect: (context, state) =>
          DeepLinkHandler.resolve(state.uri.toString()),
    ),

    // 3. Store & Products
    GoRoute(
      path: '/products/:slug',
      redirect: (context, state) =>
          DeepLinkHandler.resolve(state.uri.toString()),
    ),
    GoRoute(
      path: '/products',
      redirect: (context, state) =>
          DeepLinkHandler.resolve(state.uri.toString()),
    ),

    // 4. Posts & Announcements (Blog posts)
    GoRoute(
      path: '/posts/:slug',
      redirect: (context, state) =>
          DeepLinkHandler.resolve(state.uri.toString()),
    ),
    GoRoute(
      path: '/p/:slug',
      redirect: (context, state) =>
          DeepLinkHandler.resolve(state.uri.toString()),
    ),
    GoRoute(
      path: '/posts',
      redirect: (context, state) =>
          DeepLinkHandler.resolve(state.uri.toString()),
    ),
    GoRoute(
      path: '/p',
      redirect: (context, state) =>
          DeepLinkHandler.resolve(state.uri.toString()),
    ),

    // 5. Dashboard / Home aliases & Learn course links
    GoRoute(
      path: '/learn/:courseId/chapters/:chapterId',
      redirect: (context, state) =>
          DeepLinkHandler.resolve(state.uri.toString()),
    ),
    GoRoute(
      path: '/learn/:courseId/contents/:id',
      redirect: (context, state) =>
          DeepLinkHandler.resolve(state.uri.toString()),
    ),
    GoRoute(
      path: '/learn/:courseId/chapters',
      redirect: (context, state) =>
          DeepLinkHandler.resolve(state.uri.toString()),
    ),
    GoRoute(
      path: '/learn/:courseId',
      redirect: (context, state) =>
          DeepLinkHandler.resolve(state.uri.toString()),
    ),
    GoRoute(
      path: '/learn',
      redirect: (context, state) =>
          DeepLinkHandler.resolve(state.uri.toString()),
    ),
    GoRoute(
      path: '/dashboard',
      redirect: (context, state) =>
          DeepLinkHandler.resolve(state.uri.toString()),
    ),
    GoRoute(
      path: '/leaderboard',
      redirect: (context, state) =>
          DeepLinkHandler.resolve(state.uri.toString()),
    ),

    // 6. Registration & Account activation
    GoRoute(
      path: '/register',
      redirect: (context, state) =>
          DeepLinkHandler.resolve(state.uri.toString()),
    ),
    GoRoute(
      path: '/activate',
      redirect: (context, state) =>
          DeepLinkHandler.resolve(state.uri.toString()),
    ),

    // 7. Discussions & Forum
    GoRoute(
      path: '/discussions/forum/posts/:slug',
      redirect: (context, state) =>
          DeepLinkHandler.resolve(state.uri.toString()),
    ),
    GoRoute(
      path: '/discussions/doubts/:id',
      redirect: (context, state) =>
          DeepLinkHandler.resolve(state.uri.toString()),
    ),
    GoRoute(
      path: '/discussions/doubts',
      redirect: (context, state) =>
          DeepLinkHandler.resolve(state.uri.toString()),
    ),
    GoRoute(
      path: '/discussions/forum',
      redirect: (context, state) =>
          DeepLinkHandler.resolve(state.uri.toString()),
    ),
    GoRoute(
      path: '/discussions',
      redirect: (context, state) =>
          DeepLinkHandler.resolve(state.uri.toString()),
    ),
  ];
}
