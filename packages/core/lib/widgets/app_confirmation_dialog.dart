import 'package:flutter/widgets.dart';
import 'app_button.dart';
import 'app_text.dart';
import '../design/design_provider.dart';
import '../localization/l10n_helper.dart';
import '../accessibility/app_semantics.dart';

Future<bool> showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String content,
  String? confirmText,
  String? cancelText,
}) async {
  final l10n = L10n.of(context);
  final design = Design.of(context);
  final result = await showGeneralDialog<bool>(
    context: context,
    barrierDismissible: false,
    barrierLabel: title,
    barrierColor: design.colors.shadow.withValues(alpha: 0.6),
    pageBuilder: (context, anim1, anim2) {
      return Center(
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 480),
          margin: EdgeInsets.all(design.spacing.xl),
          padding: EdgeInsets.all(design.spacing.lg),
          decoration: BoxDecoration(
            color: design.colors.surface,
            borderRadius: design.radius.card,
            border: design.isDark
                ? Border.all(color: design.colors.border)
                : null,
            boxShadow: [
              BoxShadow(
                color: design.colors.shadow.withValues(
                  alpha: design.isDark ? 0.4 : 0.1,
                ),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSemantics.header(label: title, child: AppText.title(title)),
              SizedBox(height: design.spacing.sm),
              AppText.body(content, color: design.colors.textSecondary),
              SizedBox(height: design.spacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton.secondary(
                    label: cancelText ?? l10n.labelCancel,
                    padding: EdgeInsets.symmetric(
                      horizontal: design.spacing.md,
                      vertical: design.spacing.sm,
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  SizedBox(width: design.spacing.sm),
                  AppButton.primary(
                    label: confirmText ?? l10n.labelConfirm,
                    padding: EdgeInsets.symmetric(
                      horizontal: design.spacing.md,
                      vertical: design.spacing.sm,
                    ),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
  return result ?? false;
}
