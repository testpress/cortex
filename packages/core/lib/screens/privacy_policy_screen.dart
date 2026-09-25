import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../core.dart';
import '../data/data.dart';

/// Resolves the privacy policy URL from domainUrl or falls back to apiBaseUrl.
String resolvePrivacyPolicyUrl(String? domainUrl, {String? apiBaseUrl}) {
  String? formattedDomainUrl = domainUrl?.trim();

  if (formattedDomainUrl != null && formattedDomainUrl.isNotEmpty) {
    if (!formattedDomainUrl.startsWith('http://') &&
        !formattedDomainUrl.startsWith('https://')) {
      formattedDomainUrl = 'https://$formattedDomainUrl';
    }
  } else {
    final effectiveApiBase = (apiBaseUrl ?? AppConfig.apiBaseUrl).trim();
    final apiUri = Uri.tryParse(effectiveApiBase);
    if (apiUri != null && apiUri.host.isNotEmpty) {
      formattedDomainUrl = Uri(
        scheme: apiUri.scheme.isNotEmpty ? apiUri.scheme : 'https',
        host: apiUri.host,
        port: apiUri.hasPort ? apiUri.port : null,
      ).toString();
    } else {
      formattedDomainUrl = effectiveApiBase;
    }
  }

  if (formattedDomainUrl.endsWith('/')) {
    formattedDomainUrl = formattedDomainUrl.substring(
      0,
      formattedDomainUrl.length - 1,
    );
  }

  return '$formattedDomainUrl/privacy/';
}

/// A platform-neutral screen that resolves and renders the organization's privacy policy in an [AppWebView].
class PrivacyPolicyScreen extends ConsumerWidget {
  const PrivacyPolicyScreen({super.key, this.customUrl, this.title});

  final String? customUrl;
  final String? title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final settings = ref.watch(instituteSettingsProvider);
    final url = customUrl ?? resolvePrivacyPolicyUrl(settings?.domainUrl);

    return AppWebView(
      url: url,
      title: title ?? l10n.drawerPrivacy,
      showHeader: true,
      useSafeArea: false,
      mediaMode: true,
      onNavigationRequest: (request) {
        if (request.url != url) {
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    );
  }
}
