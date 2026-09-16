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
                  'No internet connection',
                  color: design.colors.textPrimary,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: design.spacing.sm),
                SizedBox(
                  width: 300,
                  child: AppText.subtitle(
                    'Connect to the internet to set up the app and try again.',
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

class _RetryButtonState extends ConsumerState<_RetryButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotationController;
  bool _isRetrying = false;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  Future<void> _handleRetry() async {
    if (_isRetrying) return;
    setState(() {
      _isRetrying = true;
    });
    _rotationController.repeat();

    // Trigger settings retry and wait for network/cache to resolve
    ref.invalidate(settingsInitializationProvider);
    try {
      await Future.wait([
        ref.read(settingsInitializationProvider.future),
        Future.delayed(const Duration(milliseconds: 600)),
      ]);
    } catch (_) {
      // Allow the rotation animation to be visible for at least 600ms on fast network errors
      await Future.delayed(const Duration(milliseconds: 400));
    } finally {
      if (mounted) {
        _rotationController.stop();
        _rotationController.reset();
        setState(() {
          _isRetrying = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return GestureDetector(
      onTap: _isRetrying ? null : _handleRetry,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 14),
        decoration: BoxDecoration(
          color: design.colors.primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: design.colors.primary.withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RotationTransition(
              turns: _rotationController,
              child: Icon(
                LucideIcons.rotateCcw,
                size: 18,
                color: design.colors.onPrimary,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Retry',
              style: TextStyle(
                color: design.colors.onPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoInternetIllustration extends StatelessWidget {
  const _NoInternetIllustration();

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final isDark = design.isDark;

    return Container(
      width: 210,
      height: 210,
      decoration: BoxDecoration(
        color: isDark ? design.colors.surface : const Color(0xFFF1F3FB),
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
