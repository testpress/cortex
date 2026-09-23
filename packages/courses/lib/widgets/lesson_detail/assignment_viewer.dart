import 'dart:async' show unawaited;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../../providers/assignment_sso_provider.dart';
import 'lesson_detail_skeleton.dart';

/// A protected WebView-based viewer for Assignment lessons.
///
/// Authenticates the student via presigned SSO and opens
/// `/chapters/<chapter_slug>/<content_id>/`, while restricting navigation
/// to prevent navigating away to other web portal pages.
class AssignmentLessonViewer extends ConsumerWidget {
  const AssignmentLessonViewer({
    super.key,
    required this.lesson,
    this.onComplete,
  });

  final LessonDto lesson;
  final VoidCallback? onComplete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = AssignmentUrlParams.fromLesson(lesson);
    final ssoUrlAsync = ref.watch(assignmentSsoUrlProvider(params));

    return ssoUrlAsync.when(
      data: (ssoUrl) {
        final allowedHost = Uri.tryParse(ssoUrl)?.host ?? '';
        return AppWebView(
          key: ValueKey('assignment_webview_${lesson.id}'),
          url: ssoUrl,
          showHeader: false,
          mediaMode: true,
          onNavigationRequest: (request) {
            final uri = Uri.tryParse(request.url);
            if (uri != null && isDownloadOrMediaUrl(uri)) {
              unawaited(launchUrl(uri, mode: LaunchMode.externalApplication));
              return NavigationDecision.prevent;
            }
            final allowed = isAllowedAssignmentNavigation(
              requestUrl: request.url,
              allowedHost: allowedHost,
              chapterSlug: params.chapterSlug,
              contentId: params.contentId,
            );
            if (!allowed &&
                uri != null &&
                (uri.scheme == 'http' || uri.scheme == 'https')) {
              unawaited(launchUrl(uri, mode: LaunchMode.externalApplication));
              return NavigationDecision.prevent;
            }
            return allowed
                ? NavigationDecision.navigate
                : NavigationDecision.prevent;
          },
        );
      },
      loading: () =>
          const LessonDetailSkeleton(lessonType: LessonType.assignment),
      error: (error, stack) => AppErrorView(
        error: error,
        onRetry: () => ref.refresh(assignmentSsoUrlProvider(params)),
      ),
    );
  }
}
