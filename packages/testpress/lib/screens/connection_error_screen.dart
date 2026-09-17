import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import '../providers/initialization_provider.dart';

/// Screen displayed when the app fails to initialize institute settings on cold launch (offline).
class ConnectionErrorScreen extends ConsumerWidget {
  const ConnectionErrorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return AppShell(
      backgroundColor: design.colors.canvas,
      child: SafeArea(
        child: SizedBox.expand(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: design.spacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 3),
                const _NoInternetIllustration(),
                SizedBox(height: design.spacing.xl),
                AppText.headline(
                  l10n.errorSetupConnectionTitle,
                  color: design.colors.textPrimary,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: design.spacing.sm),
                SizedBox(
                  width: 300,
                  child: AppText.subtitle(
                    l10n.errorSetupConnectionMessage,
                    color: design.colors.textSecondary,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: design.spacing.xl),
                const _RetryButton(),
                const Spacer(flex: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RetryButton extends ConsumerStatefulWidget {
  const _RetryButton();

  @override
  ConsumerState<_RetryButton> createState() => _RetryButtonState();
}

class _RetryButtonState extends ConsumerState<_RetryButton> {
  bool _isRetrying = false;

  Future<void> _handleRetry() async {
    if (_isRetrying) return;
    setState(() {
      _isRetrying = true;
    });

    // Trigger settings retry and wait for network/cache to resolve
    ref.invalidate(settingsInitializationProvider);
    try {
      await Future.wait([
        ref.read(settingsInitializationProvider.future),
        Future.delayed(const Duration(milliseconds: 600)),
      ]);
    } catch (_) {
      // Allow loading feedback to be visible even on immediate network error
      await Future.delayed(const Duration(milliseconds: 400));
    } finally {
      if (mounted) {
        setState(() {
          _isRetrying = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return AppButton.primary(
      label: l10n.labelRetry,
      loading: _isRetrying,
      onPressed: _handleRetry,
    );
  }
}

class _NoInternetIllustration extends StatelessWidget {
  const _NoInternetIllustration();

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      width: 210,
      height: 210,
      decoration: BoxDecoration(
        color: design.colors.surface,
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(28),
      child: Image.asset(
        'assets/images/no_internet.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            LucideIcons.wifiOff,
            size: 72,
            color: design.colors.error,
          );
        },
      ),
    );
  }
}
