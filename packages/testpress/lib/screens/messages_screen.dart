import 'dart:async' show unawaited;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

/// Provider to fetch and resolve the presigned SSO URL for student messages.
final messagesUrlProvider = FutureProvider.autoDispose<String>((ref) async {
  final settings = ref.watch(instituteSettingsProvider);
  final userRepo = await ref.watch(userRepositoryProvider.future);
  final ssoPath = await userRepo.getPresignedSsoUrl();

  const nextPath = '/messages/?testpress_app=1';
  final encodedNextPath = Uri.encodeComponent(nextPath);

  final apiUri = Uri.parse(AppConfig.apiBaseUrl);
  final domainUrl = settings?.domainUrl;
  String? formattedDomainUrl = domainUrl;

  if (formattedDomainUrl != null && formattedDomainUrl.isNotEmpty) {
    if (!formattedDomainUrl.startsWith('http://') &&
        !formattedDomainUrl.startsWith('https://')) {
      formattedDomainUrl = 'https://$formattedDomainUrl';
    }
  } else {
    formattedDomainUrl = Uri(
      scheme: apiUri.scheme,
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
});

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
  if (path.endsWith('.pdf') || path.contains('/media/')) {
    return false;
  }

  return path.startsWith('/messages') || path.startsWith('/api/');
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
  bool _canPop = false;

  Future<void> _handleBack() async {
    final controller = _controller;
    if (controller != null && await controller.canGoBack()) {
      await controller.goBack();
      return;
    }

    if (!mounted) return;
    setState(() => _canPop = true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messagesUrlAsync = ref.watch(messagesUrlProvider);
    final settings = ref.watch(instituteSettingsProvider);
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final title = settings?.messagesLabel ?? l10n.messagesTitle;

    return PopScope(
      canPop: _canPop,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handleBack();
      },
      child: AppShell(
        backgroundColor: design.colors.surface,
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
                          !isAllowedMessagesInAppNavigation(uri, domainHost)) {
                        unawaited(
                          launchUrl(uri, mode: LaunchMode.externalApplication),
                        );
                        return NavigationDecision.prevent;
                      }
                      return NavigationDecision.navigate;
                    },
                  );
                },
                loading: () => const Center(child: AppLoadingIndicator()),
                error: (err, st) => AppErrorView(
                  onRetry: () => ref.refresh(messagesUrlProvider),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
