import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnnouncementDetailScreen extends ConsumerWidget {
  const AnnouncementDetailScreen({super.key, this.post, this.slug})
    : assert(
        post != null || slug != null,
        'Either post or slug must be provided',
      );

  final PostDto? post;
  final String? slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    if (post != null) {
      return _buildContent(context, design, l10n, post!);
    }

    final postAsync = ref.watch(postDetailProvider(slug!));

    return postAsync.when(
      data: (loadedPost) {
        if (loadedPost == null) {
          return AppShell(
            backgroundColor: design.colors.card,
            child: Column(
              children: [
                _buildAppBar(context, design, l10n),
                Expanded(
                  child: Center(
                    child: AppErrorView(
                      title: l10n.errorNotFoundTitle,
                      message: l10n.errorGenericMessage,
                      onRetry: () => ref.invalidate(postDetailProvider(slug!)),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return _buildContent(context, design, l10n, loadedPost);
      },
      loading: () => AppShell(
        backgroundColor: design.colors.card,
        child: Column(
          children: [
            _buildAppBar(context, design, l10n),
            const Expanded(child: Center(child: AppLoadingIndicator())),
          ],
        ),
      ),
      error: (error, _) => AppShell(
        backgroundColor: design.colors.card,
        child: Column(
          children: [
            _buildAppBar(context, design, l10n),
            Expanded(
              child: Center(
                child: AppErrorView(
                  error: error,
                  onRetry: () => ref.invalidate(postDetailProvider(slug!)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(
    BuildContext context,
    DesignConfig design,
    AppLocalizations l10n,
  ) {
    return Container(
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
              AppBackButton(
                onTap: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    context.go('/home');
                  }
                },
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
    );
  }

  Widget _buildContent(
    BuildContext context,
    DesignConfig design,
    AppLocalizations l10n,
    PostDto post,
  ) {
    DateTime? date;
    try {
      date = DateTime.parse(post.publishedDate);
    } catch (_) {}
    final formattedDate = date != null
        ? DateFormatter.formatFullDate(date)
        : '';

    return AppShell(
      backgroundColor: design.colors.card,
      child: Column(
        children: [
          _buildAppBar(context, design, l10n),
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
                          padding: EdgeInsets.symmetric(
                            horizontal: design.spacing.xs,
                          ),
                          child: AppText.caption(
                            '•',
                            color: design.colors.textTertiary,
                          ),
                        ),
                      ],
                      if (post.categoryName != null &&
                          post.categoryName!.isNotEmpty)
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

                  AppHtmlV2(data: post.contentHtml),

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
                      Icon(
                        LucideIcons.messageSquareOff,
                        size: 20,
                        color: design.colors.textSecondary,
                      ),
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
