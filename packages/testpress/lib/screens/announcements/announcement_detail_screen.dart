import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

class AnnouncementDetailScreen extends StatelessWidget {
  const AnnouncementDetailScreen({super.key, required this.post});

  final PostDto post;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    DateTime? date;
    try {
      date = DateTime.parse(post.publishedDate);
    } catch (_) {}
    final formattedDate = date != null ? DateFormatter.formatFullDate(date) : '';

    return AppShell(
      backgroundColor: design.colors.card,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: design.colors.card,
              border: Border(bottom: BorderSide(color: design.colors.divider)),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                  design.spacing.screenPadding,
                  design.spacing.md,
                  design.spacing.screenPadding,
                  design.spacing.md,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2), // Optical alignment
                        child: Icon(
                          LucideIcons.arrowLeft,
                          color: design.colors.textPrimary,
                          size: 22,
                        ),
                      ),
                    ),
                    SizedBox(width: design.spacing.sm),
                    Expanded(
                      child: AppText.title(
                        l10n.drawerPosts,
                        color: design.colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                vertical: design.spacing.xl,
                horizontal: design.spacing.screenPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (formattedDate.isNotEmpty) ...[
                        AppText.labelSmall(
                          formattedDate,
                          color: design.colors.textSecondary,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: design.spacing.xs),
                          child: AppText.caption('•', color: design.colors.textTertiary),
                        ),
                      ],
                      if (post.categoryName != null && post.categoryName!.isNotEmpty)
                        AppBadge(
                          label: post.categoryName!,
                          isPill: true,
                          backgroundColor: design.colors.surfaceVariant,
                        ),
                    ],
                  ),
                  SizedBox(height: design.spacing.md),
                  
                  AppText.headline(
                    post.title,
                    color: design.colors.textPrimary,
                  ),
                  SizedBox(height: design.spacing.xl),
                  
                  AppHtmlV2(
                    data: post.contentHtml,
                  ),
                  
                  SizedBox(height: design.spacing.xxl),
                ],
              ),
            ),
          ),
          
          if (!post.allowComments)
            Container(
              decoration: BoxDecoration(
                color: design.colors.surface,
                border: Border(top: BorderSide(color: design.colors.divider)),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.all(design.spacing.md),
                  child: Row(
                    children: [
                      Icon(LucideIcons.messageSquareOff, size: 20, color: design.colors.textSecondary),
                      SizedBox(width: design.spacing.md),
                      Expanded(
                        child: AppText.bodySmall(
                          l10n.commentsDisabledByAdmin,
                          color: design.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
