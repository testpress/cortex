import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../design/design_provider.dart';
import '../design/design_config.dart';
import 'app_text.dart';

/// A premium, platform-neutral toast notification utility powered by [FToast].
///
/// Callers must pass a [BuildContext] that remains mounted after the toast
/// is triggered (e.g. the parent screen's context, NOT a bottom-sheet context
/// that is about to be dismissed).
class AppToast {
  AppToast._();

  /// Show a premium dark-capsule toast notification.
  ///
  /// [context] must belong to a widget that stays alive (e.g. the
  /// orchestrator/screen that owns the bottom sheet, not the sheet itself).
  ///
  /// When [actionLabel] and [onAction] are provided, the toast renders an
  /// inline action button instead of the default success/error icon.
  static void show(
    BuildContext context, {
    required String message,
    bool isError = false,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final fToast = FToast();
    fToast.init(context);

    final design = Design.of(context);

    fToast.showToast(
      child: _buildCapsule(
        design,
        message,
        isError,
        actionLabel: actionLabel,
        onAction: onAction == null
            ? null
            : () {
                onAction();
                fToast.removeCustomToast();
              },
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: actionLabel != null
          ? const Duration(seconds: 4)
          : const Duration(milliseconds: 2500),
    );
  }

  static Widget _buildCapsule(
    DesignConfig design,
    String message,
    bool isError, {
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: design.spacing.md,
        vertical: design.spacing.sm * 1.5,
      ),
      decoration: BoxDecoration(
        color: design.colors.textPrimary,
        borderRadius: BorderRadius.circular(design.radius.xl),
        boxShadow: design.shadows.floating,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (actionLabel == null) ...[
            Icon(
              isError ? LucideIcons.alertTriangle : LucideIcons.check,
              size: 20,
              color: isError ? design.colors.error : design.colors.success,
            ),
            SizedBox(width: design.spacing.sm),
          ],
          Flexible(
            child: AppText.labelBold(message, color: design.colors.textInverse),
          ),
          if (actionLabel != null && onAction != null) ...[
            SizedBox(width: design.spacing.md),
            GestureDetector(
              onTap: onAction,
              behavior: HitTestBehavior.opaque,
              child: AppText.labelBold(
                actionLabel,
                color: design.colors.accent2,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
