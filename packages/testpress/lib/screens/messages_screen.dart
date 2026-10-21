import 'dart:async' show unawaited;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

part 'messages_screen.g.dart';

/// Provider to fetch and resolve the presigned SSO URL for student messages.
@riverpod
Future<String> messagesUrl(Ref ref) async {
  final settings = ref.watch(instituteSettingsProvider);
  final userRepo = await ref.watch(userRepositoryProvider.future);

  return userRepo.getAuthenticatedSsoUrl(
    nextPath: '/messages/?testpress_app=1',
    domainUrl: settings?.domainUrl,
  );
}

/// Keeps messages routes on the institute domain inside the WebView,
/// delegating external links and file attachments to the system browser.
bool isAllowedMessagesInAppNavigation(Uri uri, String? domainHost) {
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

  return path == '/messages' ||
      path.startsWith('/messages/') ||
      path.startsWith('/api/');
}

/// A dedicated screen for displaying student-staff messages.
///
/// Wraps [AppWebView] to load the messages web view via presigned SSO,
/// handling in-webview history on back gestures and providing a refresh action.
class MessagesScreen extends ConsumerStatefulWidget {
  const MessagesScreen({super.key});

  @override
  ConsumerState<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends ConsumerState<MessagesScreen> {
  WebViewController? _controller;

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
    } catch (_) {
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
    final messagesUrlAsync = ref.watch(messagesUrlProvider);
    final settings = ref.watch(instituteSettingsProvider);
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final title = settings?.messagesLabel ?? l10n.messagesTitle;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

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
                child: messagesUrlAsync.when(
                  data: (messagesUrl) {
                    final domainHost = Uri.tryParse(messagesUrl)?.host;
                    return AppWebView(
                      url: messagesUrl,
                      onWebViewCreated: (controller) {
                        _controller = controller;
                      },
                      onNavigationRequest: (request) {
                        final uri = Uri.tryParse(request.url);
                        if (uri != null &&
                            !isAllowedMessagesInAppNavigation(
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
                    onRetry: () => ref.invalidate(messagesUrlProvider),
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
