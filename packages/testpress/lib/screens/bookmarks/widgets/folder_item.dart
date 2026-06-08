import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class FolderItem extends StatelessWidget {
  const FolderItem({
    super.key,
    required this.folder,
    required this.onTap,
    required this.onMoreTap,
  });

  final Map<String, dynamic> folder;
  final VoidCallback onTap;
  final VoidCallback onMoreTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return AppCard(
      showShadow: true,
      onTap: onTap,
      padding: EdgeInsets.all(design.spacing.md),
      child: Row(
        children: [
          Icon(
            LucideIcons.folder,
            color: design.colors.textSecondary,
            size: design.iconSize.xl,
          ),
          SizedBox(width: design.spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.cardTitle(folder['name']),
                SizedBox(height: design.spacing.xs),
                AppText.cardCaption(
                  L10n.of(
                    context,
                  ).bookmarkFolderItemsCount(folder['count'] as int),
                ),
              ],
            ),
          ),
          AppFocusable(
            onTap: onMoreTap,
            child: Padding(
              padding: EdgeInsets.only(left: design.spacing.sm),
              child: Icon(
                LucideIcons.moreVertical,
                size: 20,
                color: design.colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
