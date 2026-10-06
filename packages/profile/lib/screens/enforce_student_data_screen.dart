import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

class EnforceStudentDataScreen extends ConsumerStatefulWidget {
  const EnforceStudentDataScreen({super.key, this.onCompleted});

  final VoidCallback? onCompleted;

  @override
  ConsumerState<EnforceStudentDataScreen> createState() =>
      _EnforceStudentDataScreenState();
}

class _EnforceStudentDataScreenState
    extends ConsumerState<EnforceStudentDataScreen> {
  bool _isSubmitting = false;
  int _pageLoadCount = 0;

  Future<void> _handleFormCompleted({bool silentIfNotCollected = false}) async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);

    try {
      // Verify with the backend if student data has been marked as collected
      final isCollected = await ref
          .read(authRepositoryProvider)
          .checkStudentDataCollected();

      if (!isCollected) {
        if (!silentIfNotCollected && mounted) {
          // W1: use L10n key
          AppToast.show(
            context,
            message: L10n.of(context).enforceStudentDataIncomplete,
            isError: true,
          );
        }
        return;
      }

      ref.read(enforceStudentDataRequiredProvider.notifier).state = false;
      ref.invalidate(studentDataCollectedProvider);

      if (widget.onCompleted != null) {
        widget.onCompleted!();
      } else if (mounted) {
        context.go('/home');
      }
    } catch (e, stack) {
      ref.read(sentryServiceProvider).captureException(e, stackTrace: stack);
      if (!silentIfNotCollected && mounted) {
        // W1: use L10n key
        AppToast.show(
          context,
          message: L10n.of(context).enforceStudentDataVerifyError,
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  // W3: only fire verification when redirected AWAY from the enforce form
  void _onPageFinished(String url) {
    _pageLoadCount++;
    if (_pageLoadCount > 1 && !url.contains('/settings/force/mobile')) {
      _handleFormCompleted(silentIfNotCollected: true);
    }
  }

  FutureOr<NavigationDecision> _onNavigationRequest(NavigationRequest request) {
    final uri = Uri.tryParse(request.url);
    if (uri != null) {
      final path = uri.path;
      // If server redirects away from /settings/force/mobile/ (e.g. to / or /home or /settings/profile/),
      // the form submission has completed successfully.
      if (!path.contains('/settings/force/mobile')) {
        _handleFormCompleted();
        return NavigationDecision.prevent;
      }
    }
    return NavigationDecision.navigate;
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final settings = ref.watch(instituteSettingsProvider);
    final url = _resolveEnforceStudentDataUrl(settings?.domainUrl);

    return AppShell(
      backgroundColor: design.colors.surface,
      child: Column(
        children: [
          AppHeader(
            // W1: use L10n key
            title: l10n.enforceStudentDataTitle,
            actions: [
              // W2: single onTap on AppSemantics.button; no inner GestureDetector
              AppSemantics.button(
                label: l10n.enforceStudentDataLogout,
                onTap: () => ref.read(authProvider.notifier).logout(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: design.spacing.sm,
                    // S2 from review: ensure 48dp min touch target via vertical padding
                    vertical: design.spacing.md,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.logOut,
                        size: 18,
                        color: design.colors.error,
                      ),
                      SizedBox(width: design.spacing.xs),
                      // W1: use L10n key
                      AppText.bodySmall(
                        l10n.enforceStudentDataLogout,
                        color: design.colors.error,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Stack(
              children: [
                if (url.isNotEmpty)
                  AppWebView(
                    url: url,
                    showHeader: false,
                    useSafeArea: false,
                    onNavigationRequest: _onNavigationRequest,
                    onPageFinished: _onPageFinished,
                  )
                else
                  const Center(child: AppLoadingIndicator()),
                if (_isSubmitting)
                  Container(
                    color: design.colors.surface.withValues(alpha: 0.8),
                    child: const Center(child: AppLoadingIndicator()),
                  ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: design.spacing.screenPadding,
              vertical: design.spacing.md,
            ),
            decoration: BoxDecoration(
              color: design.colors.card,
              border: Border(
                top: BorderSide(color: design.colors.divider, width: 1),
              ),
            ),
            child: SafeArea(
              top: false,
              child: AppButton.primary(
                // W1: use L10n key
                label: l10n.enforceStudentDataContinue,
                fullWidth: true,
                loading: _isSubmitting,
                onPressed: () => _handleFormCompleted(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Resolves the enforce student data web URL from domainUrl or falls back to apiBaseUrl.
String _resolveEnforceStudentDataUrl(String? domainUrl, {String? apiBaseUrl}) {
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

  return '$formattedDomainUrl/settings/force/mobile/';
}
