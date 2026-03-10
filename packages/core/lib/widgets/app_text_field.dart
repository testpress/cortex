import 'package:flutter/material.dart'
    show TextField, InputDecoration, InputBorder, Material, MaterialType;
import 'package:flutter/widgets.dart';
import '../design/design_provider.dart';
import 'app_text.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.onChanged,
    this.keyboardType,
    this.errorText,
    this.readOnly = false,
    this.helperText,
  });

  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final String? errorText;
  final bool readOnly;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.label(label, color: design.colors.textPrimary),
        SizedBox(height: design.spacing.xs),
        Container(
          decoration: BoxDecoration(
            color: readOnly ? design.colors.surface : design.colors.card,
            borderRadius: BorderRadius.circular(design.radius.lg),
            border: Border.all(
              color: errorText != null
                  ? design.colors.error
                  : design.colors.border,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
          child: Material(
            type: MaterialType.transparency,
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              keyboardType: keyboardType,
              readOnly: readOnly,
              style: design.typography.body.copyWith(
                color: readOnly ? design.colors.textSecondary : design.colors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: design.typography.body.copyWith(
                  color: design.colors.textTertiary,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: design.spacing.md,
                ),
              ),
            ),
          ),
        ),
        if (errorText != null) ...[
          SizedBox(height: design.spacing.xs),
          AppText.labelSmall(errorText!, color: design.colors.error),
        ] else if (helperText != null) ...[
          SizedBox(height: design.spacing.xs),
          AppText.caption(helperText!),
        ],
      ],
    );
  }
}
