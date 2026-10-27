import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profile/profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'student_notes_provider.g.dart';

const String _studentNotesPath = '/student-diary/my-notes/';

/// Provider to fetch and resolve the presigned SSO URL for student notes.
@riverpod
Future<String> studentNotesUrl(Ref ref) async {
  final settings = ref.watch(instituteSettingsProvider);
  final userRepo = await ref.watch(userRepositoryProvider.future);
  // Read once at initial URL creation time to avoid rebuilding the provider
  // and reloading the entire WebView when the theme changes.
  final designMode = ref.read(designModeProvider);

  final themeParam = switch (designMode) {
    DesignMode.dark => 'dark',
    DesignMode.light => 'light',
    _ => null,
  };

  final queryParams = <String, String>{'testpress_app': '1'};
  if (themeParam != null) {
    queryParams['theme'] = themeParam;
  }
  final nextUri = Uri(path: _studentNotesPath, queryParameters: queryParams);

  return userRepo.getAuthenticatedSsoUrl(
    nextPath: nextUri.toString(),
    domainUrl: settings?.domainUrl,
  );
}
