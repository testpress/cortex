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

  Future<void> _handleFormCompleted() async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);

    try {
      // Verify with the backend if student data has been marked as collected
      final isCollected = await ref
          .read(authRepositoryProvider)
          .checkStudentDataCollected(throwOnParallelLogin: true);

      if (!isCollected) {
        if (mounted) {
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
    } on ParallelLoginException catch (e) {
      ref.read(enforceStudentDataRequiredProvider.notifier).state = false;
      ref.read(parallelLoginRequiredProvider.notifier).state = e.message;
      if (mounted) context.go('/login-activity');
    } catch (e, stack) {
      ref.read(sentryServiceProvider).captureException(e, stackTrace: stack);
      if (mounted) {
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

  void _onPageFinished(String pageUrl, String initialUrl) {
    _pageLoadCount++;
    if (_pageLoadCount <= 1) return;

    final initialUri = Uri.tryParse(initialUrl);
    final currentUri = Uri.tryParse(pageUrl);

    if (initialUri == null || currentUri == null) return;

    final isSameHost =
        currentUri.host.isNotEmpty && currentUri.host == initialUri.host;

    if (isSameHost &&
        !currentUri.path.contains('/settings/force/mobile') &&
        !currentUri.path.contains('/login')) {
      _handleFormCompleted();
    }
  }

  FutureOr<NavigationDecision> _onNavigationRequest(
    NavigationRequest request,
    String initialUrl,
  ) {
    // 1. Only process main-frame navigations (allow subframes, iframes, etc.)
    if (!request.isMainFrame) {
      return NavigationDecision.navigate;
    }

    final initialUri = Uri.tryParse(initialUrl);
    final targetUri = Uri.tryParse(request.url);

    if (initialUri == null || targetUri == null) {
      return NavigationDecision.navigate;
    }

    // 2. Restrict to same-host navigations (ignore external links, about:blank, etc.)
    final isSameHost =
        targetUri.host.isNotEmpty && targetUri.host == initialUri.host;
    if (!isSameHost) {
      return NavigationDecision.navigate;
    }

    // 3. Exclude login / session-expiry redirects
    if (targetUri.path.contains('/login')) {
      return NavigationDecision.navigate;
    }

    // 4. Same-host navigation redirected away from /settings/force/mobile/ (e.g. to / or /home)
    // Verify with backend check_permission as source of truth.
    if (!targetUri.path.contains('/settings/force/mobile')) {
      _handleFormCompleted();
      return NavigationDecision.prevent;
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
            title: l10n.enforceStudentDataTitle,
            actions: [
              AppSemantics.button(
                label: l10n.enforceStudentDataLogout,
                onTap: () => ref.read(authProvider.notifier).logout(),
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: 48,
                    minWidth: 48,
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: design.spacing.sm),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.logOut,
                        size: 18,
                        color: design.colors.error,
                      ),
                      SizedBox(width: design.spacing.xs),
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
                    onNavigationRequest: (req) =>
                        _onNavigationRequest(req, url),
                    onPageFinished: (pageUrl) => _onPageFinished(pageUrl, url),
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
