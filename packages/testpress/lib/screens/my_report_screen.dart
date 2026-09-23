import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

/// Provider to fetch and resolve the presigned SSO URL for the student report.
final reportUrlProvider = FutureProvider.autoDispose<String>((ref) async {
  final settings = ref.watch(instituteSettingsProvider);
  final userRepo = await ref.watch(userRepositoryProvider.future);
  final ssoPath = await userRepo.getPresignedSsoUrl();

  const nextPath = '/report/';
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

/// A dedicated screen for displaying the student's report.
///
/// Wraps [AppWebView] to load the personalized report page via presigned SSO,
/// automatically authenticating with the mobile session and custom domains.
class MyReportScreen extends ConsumerWidget {
  const MyReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportUrlAsync = ref.watch(reportUrlProvider);
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return AppShell(
      backgroundColor: design.colors.card,
      child: Column(
        children: [
          AppHeader(
            title: l10n.drawerMyReport,
            leading: AppBackButton(onTap: () => context.pop()),
          ),
          Expanded(
            child: reportUrlAsync.when(
              data: (reportUrl) => AppWebView(url: reportUrl),
              loading: () => const Center(child: AppLoadingIndicator()),
              error: (err, st) =>
                  AppErrorView(onRetry: () => ref.refresh(reportUrlProvider)),
            ),
          ),
        ],
      ),
    );
  }
}
