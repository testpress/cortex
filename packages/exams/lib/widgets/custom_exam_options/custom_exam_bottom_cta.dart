import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class CustomExamBottomCTA extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onConfirm;

  const CustomExamBottomCTA({
    super.key,
    required this.isEnabled,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final padding = MediaQuery.paddingOf(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: design.colors.surface,
        border: Border(top: BorderSide(color: design.colors.border)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          design.spacing.md,
          design.spacing.md,
          design.spacing.md,
          padding.bottom + design.spacing.md,
        ),
        child: SizedBox(
          width: double.infinity,
          child: AppButton.primary(
            label: context.l10n.customExamBtnCreate,
            fullWidth: true,
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            onPressed: isEnabled ? onConfirm : null,
          ),
        ),
      ),
    );
  }
}
