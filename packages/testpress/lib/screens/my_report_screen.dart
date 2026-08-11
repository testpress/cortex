import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

/// A dedicated screen for displaying the student's report.
///
/// Wraps [AppWebView] to load the personalized report page,
/// automatically resolving schemes and white-labeled custom domains.
class MyReportScreen extends ConsumerWidget {
  const MyReportScreen({super.key});

  /// Normalizes and returns the absolute URL for the student's report page.
  String _getReportUrl(InstituteSettings? settings) {
    final apiUri = Uri.parse(AppConfig.apiBaseUrl);
    final domainUrl = settings?.domainUrl;
    String? formattedDomainUrl = domainUrl;

    if (formattedDomainUrl != null && formattedDomainUrl.isNotEmpty) {
      if (!formattedDomainUrl.startsWith('http://') &&
          !formattedDomainUrl.startsWith('https://')) {
        formattedDomainUrl = 'https://$formattedDomainUrl';
      }
    }

    return formattedDomainUrl != null && formattedDomainUrl.isNotEmpty
        ? (formattedDomainUrl.endsWith('/')
              ? '${formattedDomainUrl}report/'
              : '$formattedDomainUrl/report/')
        : Uri(
            scheme: apiUri.scheme,
            host: apiUri.host,
            port: apiUri.hasPort ? apiUri.port : null,
            path: '/report/',
          ).toString();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(instituteSettingsProvider);
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final reportUrl = _getReportUrl(settings);

    return AppShell(
      backgroundColor: design.colors.card,
      child: Column(
        children: [
          AppHeader(
            title: l10n.drawerMyReport,
            leading: AppBackButton(onTap: () => context.pop()),
          ),
          Expanded(child: AppWebView(url: reportUrl)),
        ],
      ),
    );
  }
}
