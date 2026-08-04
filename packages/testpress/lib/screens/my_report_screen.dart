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

    return ColoredBox(
      color: design.colors.card,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(design.spacing.md),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: design.colors.border, width: 1),
                ),
                boxShadow: design.shadows.surfaceSoft,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: design.spacing.xs,
                  horizontal: design.spacing.xs,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSemantics.button(
                      label: l10n.actionGoBack,
                      child: AppFocusable(
                        onTap: () => context.pop(),
                        borderRadius: BorderRadius.circular(design.radius.md),
                        child: Padding(
                          padding: EdgeInsets.all(design.spacing.xs),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Icon(
                              LucideIcons.arrowLeft,
                              color: design.colors.textPrimary,
                              size: design.iconSize.md,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: design.spacing.sm),
                    Expanded(
                      child: AppSemantics.header(
                        label: l10n.drawerMyReport,
                        child: AppText.title(
                          l10n.drawerMyReport,
                          color: design.colors.textPrimary,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: AppWebView(url: reportUrl)),
          ],
        ),
      ),
    );
  }
}
