import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:core/core.dart';

/// Shows a dialog prompting the user for the password to unlock a PDF.
///
/// Returns the entered password string if submitted, or `null` if cancelled.
Future<String?> showPdfPasswordDialog(
  BuildContext context, {
  bool isRetry = false,
}) async {
  final l10n = L10n.of(context);
  final design = Design.of(context);

  return showGeneralDialog<String?>(
    context: context,
    barrierDismissible: false,
    barrierLabel: l10n.pdfPasswordProtectedTitle,
    barrierColor: design.colors.shadow.withValues(alpha: 0.6),
    pageBuilder: (dialogContext, anim1, anim2) {
      return Center(
        child: PdfPasswordDialog(isRetry: isRetry),
      );
    },
  );
}

class PdfPasswordDialog extends StatefulWidget {
  final bool isRetry;

  const PdfPasswordDialog({
    super.key,
    this.isRetry = false,
  });

  @override
  State<PdfPasswordDialog> createState() => _PdfPasswordDialogState();
}

class _PdfPasswordDialogState extends State<PdfPasswordDialog> {
  late final TextEditingController _controller;
  bool _obscureText = true;
  String? _localError;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text;
    if (text.isEmpty) {
      setState(() {
        _localError = L10n.of(context).loginPasswordHint;
      });
      return;
    }
    Navigator.of(context).pop(text);
  }

  void _cancel() {
    Navigator.of(context).pop(null);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final design = Design.of(context);

    final errorMessage =
        _localError ?? (widget.isRetry ? l10n.pdfPasswordIncorrect : null);

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 440),
      margin: EdgeInsets.all(design.spacing.xl),
      padding: EdgeInsets.all(design.spacing.lg),
      decoration: BoxDecoration(
        color: design.colors.surface,
        borderRadius: design.radius.card,
        border: design.isDark ? Border.all(color: design.colors.border) : null,
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
          AppSemantics.header(
            label: l10n.pdfPasswordProtectedTitle,
            child: AppText.title(l10n.pdfPasswordProtectedTitle),
          ),
          SizedBox(height: design.spacing.sm),
          AppText.body(
            l10n.pdfPasswordProtectedMessage,
            color: design.colors.textSecondary,
          ),
          SizedBox(height: design.spacing.md),
          AppTextField(
            label: l10n.loginPasswordLabel,
            hintText: l10n.loginPasswordHint,
            controller: _controller,
            obscureText: _obscureText,
            autofocus: true,
            errorText: errorMessage,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
            onChanged: (_) {
              if (_localError != null) {
                setState(() => _localError = null);
              }
            },
            suffixIcon: AppSemantics.button(
              label: _obscureText
                  ? l10n.loginShowPassword
                  : l10n.loginHidePassword,
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  _obscureText ? LucideIcons.eye : LucideIcons.eyeOff,
                  color: design.colors.textSecondary,
                  size: design.iconSize.md,
                ),
              ),
            ),
          ),
          SizedBox(height: design.spacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton.secondary(
                label: l10n.labelCancel,
                padding: EdgeInsets.symmetric(
                  horizontal: design.spacing.md,
                  vertical: design.spacing.sm,
                ),
                onPressed: _cancel,
              ),
              SizedBox(width: design.spacing.sm),
              AppButton.primary(
                label: l10n.pdfPasswordActionOpen,
                padding: EdgeInsets.symmetric(
                  horizontal: design.spacing.md,
                  vertical: design.spacing.sm,
                ),
                onPressed: _submit,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
