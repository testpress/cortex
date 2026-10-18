import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../../providers/lesson_comments_provider.dart';
import 'comment_item_view.dart';
import 'comment_input_bar.dart';

/// Tab view that displays threaded comments, handles pagination,
/// and includes a sticky comment input bar.
class CommentsTab extends ConsumerStatefulWidget {
  final String commentsUrl;
  final LessonDto lesson;
  final WidgetBuilder? footerBuilder;

  const CommentsTab({
    super.key,
    required this.commentsUrl,
    required this.lesson,
    this.footerBuilder,
  });

  @override
  ConsumerState<CommentsTab> createState() => _CommentsTabState();
}

class _CommentsTabState extends ConsumerState<CommentsTab> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= 200) {
      ref.read(lessonCommentsProvider(widget.commentsUrl).notifier).loadMore();
    }
  }

  Future<void> _handleSubmit(String text) async {
    final notifier = ref.read(lessonCommentsProvider(widget.commentsUrl).notifier);
    try {
      final comment = await notifier.postComment(text);
      if (!mounted) return;

      final settings = ref.read(instituteSettingsProvider);
      if (settings?.moderateComments == true && !comment.isPublic) {
        AppToast.show(
          context,
          message: 'Your comment has been submitted and is awaiting moderation.',
        );
      }
    } catch (_) {
      if (mounted) {
        AppToast.show(
          context,
          message: 'Failed to post comment. Please try again.',
          isError: true,
        );
      }
    }
  }

  Future<void> _handleDelete(int commentId) async {
    final notifier = ref.read(lessonCommentsProvider(widget.commentsUrl).notifier);
    try {
      await notifier.deleteComment(commentId);
      if (mounted) {
        AppToast.show(context, message: 'Comment deleted');
      }
    } catch (_) {
      if (mounted) {
        AppToast.show(
          context,
          message: 'Failed to delete comment. Please try again.',
          isError: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final commentsAsync = ref.watch(lessonCommentsProvider(widget.commentsUrl));
    final notifier = ref.read(lessonCommentsProvider(widget.commentsUrl).notifier);

    return Column(
      children: [
        Expanded(
          child: commentsAsync.when(
            data: (state) {
              if (state.treeComments.isEmpty) {
                return _buildEmptyState(design);
              }

              return AppRefreshIndicator(
                onRefresh: notifier.refresh,
                child: ListView.separated(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: ClampingScrollPhysics(),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: design.spacing.md,
                    vertical: design.spacing.md,
                  ),
                  itemCount: state.treeComments.length + (state.isLoadingMore ? 1 : 0),
                  separatorBuilder: (context, index) =>
                      SizedBox(height: design.spacing.sm),
                  itemBuilder: (context, index) {
                    if (index >= state.treeComments.length) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: design.spacing.md),
                        child: Center(
                          child: SizedBox(
                            width: design.iconSize.md,
                            height: design.iconSize.md,
                            child: AppLoadingIndicator(size: design.iconSize.md),
                          ),
                        ),
                      );
                    }

                    final comment = state.treeComments[index];
                    return CommentItemView(
                      comment: comment,
                      onReply: (target) => notifier.setReplyTarget(target),
                      onDelete: _handleDelete,
                    );
                  },
                ),
              );
            },
            loading: () => _buildSkeletonState(design),
            error: (err, _) => Center(
              child: AppErrorView(
                error: err,
                onRetry: notifier.fetchInitial,
              ),
            ),
          ),
        ),

        // Sticky Input Bar
        CommentInputBar(
          replyingTo: commentsAsync.valueOrNull?.replyingToTarget,
          isSubmitting: commentsAsync.valueOrNull?.isSubmitting ?? false,
          onSubmit: _handleSubmit,
          onCancelReply: () => notifier.setReplyTarget(null),
        ),

        if (widget.footerBuilder != null) ...[
          widget.footerBuilder!(context),
          SizedBox(height: design.spacing.sm),
        ],
      ],
    );
  }

  Widget _buildEmptyState(DesignConfig design) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.messageSquare,
            size: 56,
            color: design.colors.textTertiary.withValues(alpha: 0.3),
          ),
          SizedBox(height: design.spacing.md),
          AppText.title(
            'No Comments Yet',
            color: design.colors.textPrimary,
          ),
          SizedBox(height: design.spacing.xs),
          AppText.bodySmall(
            'Be the first to start the discussion for this lesson!',
            color: design.colors.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonState(DesignConfig design) {
    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.all(design.spacing.md),
      itemCount: 3,
      separatorBuilder: (_, __) => SizedBox(height: design.spacing.sm),
      itemBuilder: (_, __) {
        return Skeletonizer(
          enabled: true,
          child: AppCard(
            padding: EdgeInsets.all(design.spacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: design.colors.surfaceVariant,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: design.spacing.sm),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.labelBold('Alex Smith'),
                        AppText.caption('2 hours ago'),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: design.spacing.sm),
                AppText.body('Loading comment content placeholder text here...'),
              ],
            ),
          ),
        );
      },
    );
  }
}
