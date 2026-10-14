import 'package:flutter/widgets.dart';
import '../core.dart';

class AiChatHeader extends StatelessWidget {
  const AiChatHeader({super.key, required this.onBack, required this.onMenu});

  final VoidCallback onBack;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Container(
      color: design.colors.card,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: design.spacing.md,
            vertical: design.spacing.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppSemantics.button(
                label: l10n.commonBackSemantic,
                onTap: onBack,
                child: GestureDetector(
                  onTap: onBack,
                  behavior: HitTestBehavior.opaque,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 48.0,
                      minHeight: 48.0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.arrowLeft,
                          color: design.colors.textPrimary,
                          size: 20.0,
                        ),
                        SizedBox(width: design.spacing.xs),
                        AppText.title(
                          l10n.commonBackSemantic,
                          color: design.colors.textPrimary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AppIconButton(
                icon: LucideIcons.menu,
                size: 22.0,
                color: design.colors.textPrimary,
                accessibilityLabel: l10n.aiChatHistoryTitle,
                onTap: onMenu,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
