import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../design/design_provider.dart';
import '../accessibility/app_semantics.dart';
import '../localization/l10n_helper.dart';
import 'app_text.dart';
import 'app_button.dart';

/// A non-dismissible blocking overlay shown when the user's session has expired.
///
/// Displays the backend-provided [message] and a single "Login Again" action.
/// Cannot be dismissed by tapping outside or pressing back.
class SessionExpiredDialog extends StatelessWidget {
  const SessionExpiredDialog({
    super.key,
    required this.message,
    required this.onSignIn,
  });

  final String message;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return PopScope(
      // Prevent back button from dismissing the dialog
      canPop: false,
      child: ColoredBox(
        color: design.colors.overlay,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: design.spacing.xl),
            child: _DialogCard(message: message, onSignIn: onSignIn),
          ),
        ),
      ),
    );
  }
}

class _DialogCard extends StatelessWidget {
  const _DialogCard({required this.message, required this.onSignIn});

  final String message;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    // Icon container size: 2 × xl icon + padding on all sides
    final iconContainerSize = design.iconSize.xl * 2;

    return Container(
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: design.radius.card,
        boxShadow: design.shadows.floating,
      ),
      padding: EdgeInsets.all(design.spacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Lock icon container
          Semantics(
            image: true,
            label: l10n.sessionExpiredIconSemantics,
            child: Container(
              width: iconContainerSize,
              height: iconContainerSize,
              decoration: BoxDecoration(
                color: design.colors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.lock,
                size: design.iconSize.xl,
                color: design.colors.error,
              ),
            ),
          ),

          SizedBox(height: design.spacing.lg),

          // Title
          AppSemantics.header(
            label: l10n.sessionExpiredTitle,
            child: AppText.title(
              l10n.sessionExpiredTitle,
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: design.spacing.sm),

          // Backend API message — fall back to localized string if empty
          AppText.body(
            message.isNotEmpty ? message : l10n.sessionExpiredFallbackMessage,
            color: design.colors.textSecondary,
            textAlign: TextAlign.center,
          ),

          SizedBox(height: design.spacing.xl),

          // Login Again button
          AppButton.primary(
            label: l10n.sessionExpiredLoginButton,
            onPressed: onSignIn,
            fullWidth: true,
          ),
        ],
      ),
    );
  }
}
