import 'package:flutter/widgets.dart';
import '../core.dart';

class AiChatHeader extends StatelessWidget {
  static const double _maxContentWidth = 768.0;

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
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxContentWidth),
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                start: design.spacing.screenPadding,
                end:
                    design.spacing.screenPadding -
                    (design.spacing.sm + design.spacing.xs),
                top: design.spacing.sm,
                bottom: design.spacing.sm,
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
                            Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Icon(
                                LucideIcons.arrowLeft,
                                color: design.colors.textPrimary,
                                size: 20.0,
                              ),
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
        ),
      ),
    );
  }
}
