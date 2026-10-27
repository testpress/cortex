import 'dart:async' show unawaited;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:profile/profile.dart';

part 'student_notes_screen.g.dart';

const String _studentNotesPath = '/student-diary/my-notes/';
const String _themeStorageKey = 'tp_theme_preference';

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

/// Keeps student notes routes on the institute domain inside the WebView,
/// delegating external links and file attachments to the system browser.
bool isAllowedStudentNotesInAppNavigation(Uri uri, String? domainHost) {
  if (uri.scheme != 'http' && uri.scheme != 'https') {
    return false;
  }

  if (domainHost != null &&
      domainHost.isNotEmpty &&
      uri.host.isNotEmpty &&
      uri.host != domainHost) {
    return false;
  }

  final path = uri.path.toLowerCase();
  if (path.endsWith('.pdf')) {
    return false;
  }

  return path == '/student-diary' ||
      path.startsWith('/student-diary/') ||
      path.startsWith('/sso/') ||
      path.startsWith('/api/');
}

/// A dedicated screen for displaying student personal notes.
///
/// Wraps [AppWebView] to load the student notes web view via presigned SSO,
/// handling in-webview history on back gestures and providing a refresh action.
class StudentNotesScreen extends ConsumerStatefulWidget {
  const StudentNotesScreen({super.key});

  @override
  ConsumerState<StudentNotesScreen> createState() => _StudentNotesScreenState();
}

class _StudentNotesScreenState extends ConsumerState<StudentNotesScreen> {
  WebViewController? _controller;

  Future<void> _syncTheme(bool isDark) async {
    final controller = _controller;
    if (controller == null) return;

    final theme = isDark ? 'dark' : 'light';
    final script =
        '''
      (function() {
        try {
          var theme = '$theme';
          localStorage.setItem('$_themeStorageKey', theme);
          document.documentElement.setAttribute('data-theme', theme);
          if (theme === 'dark') {
            document.documentElement.classList.add('dark');
          } else {
            document.documentElement.classList.remove('dark');
          }
        } catch(e) {
          console.error('Failed to sync theme in WebView:', e);
        }
      })();
    ''';
    try {
      await controller.runJavaScript(script);
    } catch (e, st) {
      ref
          .read(sentryServiceProvider)
          .captureException(
            e,
            stackTrace: st,
            tags: const {'feature': 'student_notes_theme_sync'},
          );
    }
  }

  Future<void> _handleBack() async {
    final controller = _controller;
    if (controller != null && await controller.canGoBack()) {
      await controller.goBack();
      return;
    }

    if (!mounted) return;
    context.pop();
  }

  Future<void> _launchExternalUrl(Uri uri) async {
    bool launched = false;
    try {
      launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e, st) {
      ref
          .read(sentryServiceProvider)
          .captureException(
            e,
            stackTrace: st,
            tags: const {'feature': 'student_notes_external_launch'},
          );
      launched = false;
    }

    if (!launched && mounted) {
      AppToast.show(
        context,
        message: L10n.of(context).couldNotOpenLink,
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final notesUrlAsync = ref.watch(studentNotesUrlProvider);
    final settings = ref.watch(instituteSettingsProvider);
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final customLabel = settings?.studentNotesLabel?.trim();
    final title = (customLabel != null && customLabel.isNotEmpty)
        ? customLabel
        : l10n.notes;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    // Listen to theme mode changes without rebuilding the WebView provider
    ref.listen(designModeProvider, (previous, next) {
      final isDark = switch (next) {
        DesignMode.dark => true,
        DesignMode.light => false,
        DesignMode.system =>
          MediaQuery.maybePlatformBrightnessOf(context) == Brightness.dark,
      };
      _syncTheme(isDark);
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handleBack();
      },
      child: AppShell(
        backgroundColor: design.colors.surface,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Column(
            children: [
              AppHeader(
                title: title,
                leading: AppBackButton(onTap: _handleBack),
              ),
              Expanded(
                child: notesUrlAsync.when(
                  data: (notesUrl) {
                    final domainHost = Uri.tryParse(notesUrl)?.host;
                    return AppWebView(
                      url: notesUrl,
                      onWebViewCreated: (controller) {
                        _controller = controller;
                      },
                      onPageFinished: (url) {
                        _syncTheme(Design.of(context).isDark);
                      },
                      onNavigationRequest: (request) {
                        final uri = Uri.tryParse(request.url);
                        if (uri != null &&
                            !isAllowedStudentNotesInAppNavigation(
                              uri,
                              domainHost,
                            )) {
                          unawaited(_launchExternalUrl(uri));
                          return NavigationDecision.prevent;
                        }
                        return NavigationDecision.navigate;
                      },
                    );
                  },
                  loading: () => const Center(child: AppLoadingIndicator()),
                  error: (err, st) => AppErrorView(
                    onRetry: () => ref.invalidate(studentNotesUrlProvider),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
