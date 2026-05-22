import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../design/design_provider.dart';
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
  static void show(
    BuildContext context, {
    required String message,
    bool isError = false,
  }) {
    final fToast = FToast();
    fToast.init(context);

    final design = Design.of(context);

    fToast.showToast(
      child: _buildCapsule(design, message, isError),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(milliseconds: 2500),
    );
  }

  static Widget _buildCapsule(
    dynamic design,
    String message,
    bool isError,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: design.spacing.md as double,
        vertical: (design.spacing.sm as double) * 1.5,
      ),
      decoration: BoxDecoration(
        color: design.colors.textPrimary as Color,
        borderRadius: BorderRadius.circular(design.radius.xl as double),
        boxShadow: design.shadows.floating as List<BoxShadow>,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isError ? LucideIcons.alertTriangle : LucideIcons.check,
            size: 20,
            color: isError
                ? design.colors.error as Color
                : design.colors.success as Color,
          ),
          SizedBox(width: design.spacing.sm as double),
          Flexible(
            child: AppText.labelBold(
              message,
              color: design.colors.textInverse as Color,
            ),
          ),
        ],
      ),
    );
  }
}
