import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

/// Parameters identifying an assignment for SSO URL construction.
@immutable
class AssignmentUrlParams {
  final String chapterSlug;
  final String contentId;

  const AssignmentUrlParams({
    required this.chapterSlug,
    required this.contentId,
  });

  /// Factory resolving chapter slug from [LessonDto], falling back to URL regex
  /// extraction or [chapterId].
  factory AssignmentUrlParams.fromLesson(LessonDto lesson) {
    String slug = lesson.chapterSlug ?? '';
    if (slug.isEmpty && lesson.contentUrl != null) {
      final match =
          RegExp(r'/chapters/([^/]+)/').firstMatch(lesson.contentUrl!);
      if (match != null && match.group(1) != null) {
        slug = match.group(1)!;
      }
    }
    if (slug.isEmpty) {
      slug = lesson.chapterId;
    }
    return AssignmentUrlParams(
      chapterSlug: slug,
      contentId: lesson.id,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssignmentUrlParams &&
          runtimeType == other.runtimeType &&
          chapterSlug == other.chapterSlug &&
          contentId == other.contentId;

  @override
  int get hashCode => chapterSlug.hashCode ^ contentId.hashCode;
}

/// Constructs the presigned SSO URL pointing to an assignment.
///
/// Follows the same format as MyReportScreen, resolving `domainUrl` from
/// institute settings (falling back to `apiBaseUrl`), and appending
/// `next=/chapters/<chapterSlug>/<contentId>/`.
String buildAssignmentSsoUrl({
  required String ssoPath,
  required String chapterSlug,
  required String contentId,
  String? domainUrl,
  String? apiBaseUrl,
}) {
  final nextPath = '/chapters/$chapterSlug/$contentId/';
  final encodedNextPath = Uri.encodeComponent(nextPath);

  String? formattedDomainUrl = domainUrl;

  if (formattedDomainUrl != null && formattedDomainUrl.isNotEmpty) {
    if (!formattedDomainUrl.startsWith('http://') &&
        !formattedDomainUrl.startsWith('https://')) {
      formattedDomainUrl = 'https://$formattedDomainUrl';
    }
  } else {
    final apiUri = Uri.parse(apiBaseUrl ?? AppConfig.apiBaseUrl);
    formattedDomainUrl = Uri(
      scheme: apiUri.scheme.isNotEmpty ? apiUri.scheme : 'https',
      host: apiUri.host,
      port: apiUri.hasPort ? apiUri.port : null,
    ).toString();
  }

  if (formattedDomainUrl.endsWith('/')) {
    formattedDomainUrl = formattedDomainUrl.substring(
      0,
      formattedDomainUrl.length - 1,
    );
  }

  final normalizedSsoPath = ssoPath.startsWith('/') ? ssoPath : '/$ssoPath';
  final separator = normalizedSsoPath.contains('?') ? '&' : '?';

  return '$formattedDomainUrl$normalizedSsoPath${separator}next=$encodedNextPath';
}

/// Evaluates whether a navigation request URL should be permitted inside the assignment viewer.
///
/// Protects students from navigating out to general portal pages or external websites.
bool isAllowedAssignmentNavigation({
  required String requestUrl,
  required String allowedHost,
  required String chapterSlug,
  required String contentId,
}) {
  final uri = Uri.tryParse(requestUrl);
  if (uri == null) return false;

  if (uri.scheme != 'http' && uri.scheme != 'https') return false;

  // Restrict to the same host if host is available
  if (allowedHost.isNotEmpty &&
      uri.host.isNotEmpty &&
      uri.host.toLowerCase() != allowedHost.toLowerCase()) {
    return false;
  }

  final path = uri.path;

  // 1. Allow SSO entry point and redirects
  if (path.startsWith('/sso/')) return true;

  // 2. Allow target assignment content page and its sub-paths
  if (chapterSlug.isNotEmpty &&
      path.contains('/chapters/$chapterSlug/$contentId')) {
    return true;
  }

  // 3. Fallback matching content id in path
  if (path.contains('/$contentId/')) {
    return true;
  }

  // 4. Allow assignment-specific actions / submissions
  if (path.startsWith('/assignments/') || path.contains('/assignment/')) {
    return true;
  }

  return false;
}

/// Checks whether a given URI is a file download, media file, or external attachment.
bool isDownloadOrMediaUrl(Uri uri) {
  final path = uri.path.toLowerCase();
  const downloadExtensions = [
    '.pdf',
    '.zip',
    '.doc',
    '.docx',
    '.xls',
    '.xlsx',
    '.ppt',
    '.pptx',
    '.jpg',
    '.jpeg',
    '.png',
    '.mp4',
    '.csv',
    '.txt',
    '.rar',
    '.7z',
    '.apk',
    '.tar',
    '.gz',
  ];
  if (downloadExtensions.any((ext) => path.endsWith(ext))) {
    return true;
  }
  if (path.contains('/download') ||
      path.contains('/attachment') ||
      path.contains('/attachments/') ||
      path.contains('/media/')) {
    return true;
  }
  final query = uri.query.toLowerCase();
  if (query.contains('response-content-disposition') ||
      query.contains('download=true')) {
    return true;
  }
  return false;
}

/// FutureProvider resolving the full presigned SSO URL for an assignment.
final assignmentSsoUrlProvider =
    FutureProvider.autoDispose.family<String, AssignmentUrlParams>((
  ref,
  params,
) async {
  final settings = ref.watch(instituteSettingsProvider);
  final userRepo = await ref.watch(userRepositoryProvider.future);
  final ssoPath = await userRepo.getPresignedSsoUrl();

  return buildAssignmentSsoUrl(
    ssoPath: ssoPath,
    chapterSlug: params.chapterSlug,
    contentId: params.contentId,
    domainUrl: settings?.domainUrl,
    apiBaseUrl: AppConfig.apiBaseUrl,
  );
});
