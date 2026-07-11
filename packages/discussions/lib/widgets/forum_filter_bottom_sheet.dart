import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

class ForumFilterBottomSheet extends StatelessWidget {
  final ForumActivityFilter? initialActivityFilter;
  final ValueChanged<ForumActivityFilter?> onApply;
  final VoidCallback onClose;

  const ForumFilterBottomSheet({
    super.key,
    required this.initialActivityFilter,
    required this.onApply,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    void handleClearAll() {
      onApply(null);
      onClose();
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(
        design.spacing.sm,
        0,
        design.spacing.sm,
        design.spacing.lg,
      ),
      child: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: design.colors.card,
            borderRadius: BorderRadius.all(Radius.circular(design.radius.xxl)),
            boxShadow: design.shadows.floating,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: design.colors.textSecondary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: design.spacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText.title(
                          l10n.forumFilterByActivity,
                          color: design.colors.textPrimary,
                        ),
                        AppSemantics.button(
                          label: l10n.forumFilterClearAll,
                          onTap: handleClearAll,
                          child: AppFocusable(
                            onTap: handleClearAll,
                            child: AppText.labelBold(
                              l10n.forumFilterClearAll,
                              color: design.colors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildRadioOption(
                      context,
                      design,
                      l10n.forumFilterActivityPosted,
                      LucideIcons.edit2,
                      ForumActivityFilter.posted,
                    ),
                    _buildRadioOption(
                      context,
                      design,
                      l10n.forumFilterActivityCommented,
                      LucideIcons.messageSquare,
                      ForumActivityFilter.commented,
                    ),
                    _buildRadioOption(
                      context,
                      design,
                      l10n.forumFilterActivityLiked,
                      LucideIcons.heart,
                      ForumActivityFilter.liked,
                    ),
                    _buildRadioOption(
                      context,
                      design,
                      l10n.forumFilterActivityBookmarked,
                      LucideIcons.bookmark,
                      ForumActivityFilter.bookmarked,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioOption(
    BuildContext context,
    DesignConfig design,
    String label,
    IconData icon,
    ForumActivityFilter filter,
  ) {
    final isSelected = initialActivityFilter == filter;

    return AppSemantics.button(
      label: label,
      onTap: () {
        onApply(filter);
        onClose();
      },
      child: AppFocusable(
        onTap: () {
          onApply(filter);
          onClose();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 20, color: _getColorForActivity(design, filter)),
              const SizedBox(width: 12),
              Expanded(
                child: AppText.body(label, color: design.colors.textPrimary),
              ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? design.colors.primary
                        : design.colors.textSecondary.withValues(alpha: 0.4),
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: design.colors.primary,
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColorForActivity(DesignConfig design, ForumActivityFilter filter) {
    switch (filter) {
      case ForumActivityFilter.posted:
        return design.colors.primary;
      case ForumActivityFilter.commented:
        return design.colors.success;
      case ForumActivityFilter.liked:
        return design.colors.error;
      case ForumActivityFilter.bookmarked:
        return design.colors.warning;
    }
  }
}
