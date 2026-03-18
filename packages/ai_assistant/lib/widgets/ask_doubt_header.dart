import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class AskDoubtHeader extends StatelessWidget {
  const AskDoubtHeader({
    super.key,
    required this.onBack,
    required this.onOpenMenu,
  });

  final VoidCallback onBack;
  final VoidCallback onOpenMenu;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return AppHeader(
      title: '',
      leftSafeArea: false,
      rightSafeArea: false,
      horizontalPadding: design.spacing.sm,
      leading: GestureDetector(
        onTap: onBack,
        child: AppSemantics.button(
          label: l10n.curriculumBackButton,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                LucideIcons.arrowLeft,
                color: design.colors.textPrimary,
                size: design.iconSize.action,
              ),
              SizedBox(width: design.spacing.xs),
              AppText.labelBold(
                l10n.curriculumBackButton,
                color: design.colors.textPrimary,
              ),
            ],
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: onOpenMenu,
          child: AppSemantics.button(
            label: l10n.drawerMenuTitle,
            child: Icon(
              LucideIcons.menu,
              color: design.colors.textPrimary,
              size: design.iconSize.action,
            ),
          ),
        ),
      ],
    );
  }
}
