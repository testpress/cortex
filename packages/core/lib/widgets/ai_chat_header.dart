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
      color: aiChatCanvasColor(design),
      child: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxContentWidth),
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                start: design.spacing.md,
                // The menu icon sits in a 48dp touch target; trim the inset so
                // the glyph itself lands on the content edge.
                end: design.spacing.md - design.spacing.xs,
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
                            Icon(
                              LucideIcons.arrowLeft,
                              color: design.colors.onSurface,
                              size: design.iconSize.md,
                            ),
                            SizedBox(width: design.spacing.sm),
                            AppText.base(
                              l10n.commonBackSemantic,
                              color: design.colors.onSurface,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AppIconButton(
                    icon: LucideIcons.menu,
                    size: 22.0,
                    color: design.colors.onSurface,
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
