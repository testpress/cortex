import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

/// Renders a single comment card and recursively renders any threaded child replies.
class CommentItemView extends ConsumerWidget {
  final CommentDto comment;
  final ValueChanged<CommentDto> onReply;
  final ValueChanged<int> onDelete;
  final int depth;

  const CommentItemView({
    super.key,
    required this.comment,
    required this.onReply,
    required this.onDelete,
    this.depth = 0,
  });

  String _formatTimeAgo(DateTime? dateTime) {
    if (dateTime == null) return '';
    final diff = DateTime.now().difference(dateTime);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM d, yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    final currentUser = ref.watch(userProvider).valueOrNull;
    final isAuthor = currentUser != null && currentUser.id == comment.user.id.toString();

    final avatarUrl = comment.user.smallImage ??
        comment.user.mediumImage ??
        comment.user.photo;

    final displayName = comment.user.displayName.isNotEmpty
        ? comment.user.displayName
        : comment.user.username;

    final initial = displayName.isNotEmpty
        ? displayName[0].toUpperCase()
        : '?';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCard(
          padding: EdgeInsets.all(design.spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Avatar, Name, Time, and Delete Action
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(design.radius.pill.topLeft.x),
                    child: Container(
                      width: 32,
                      height: 32,
                      color: design.colors.surfaceVariant,
                      child: avatarUrl != null && avatarUrl.isNotEmpty
                          ? Image.network(
                              avatarUrl,
                              width: 32,
                              height: 32,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Center(
                                child: AppText.labelBold(
                                  initial,
                                  color: design.colors.primary,
                                ),
                              ),
                            )
                          : Center(
                              child: AppText.labelBold(
                                initial,
                                color: design.colors.primary,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(width: design.spacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: AppText.labelBold(
                                displayName,
                                color: design.colors.textPrimary,
                                maxLines: 1,
                              ),
                            ),
                            if (!comment.isPublic) ...[
                              SizedBox(width: design.spacing.xs),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: design.spacing.xs,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: design.colors.warning.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(design.radius.sm),
                                ),
                                child: AppText.caption(
                                  'Pending Moderation',
                                  color: design.colors.warning,
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (comment.created != null)
                          AppText.caption(
                            _formatTimeAgo(comment.created),
                            color: design.colors.textTertiary,
                          ),
                      ],
                    ),
                  ),
                  if (isAuthor)
                    AppSemantics.button(
                      label: 'Delete comment',
                      onTap: () => _handleDelete(context),
                      child: AppFocusable(
                        onTap: () => _handleDelete(context),
                        borderRadius: design.radius.button,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minWidth: 48,
                            minHeight: 48,
                          ),
                          child: Center(
                            child: Icon(
                              LucideIcons.trash2,
                              size: 16,
                              color: design.colors.error,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: design.spacing.xs),
              // Body: Sanitized HTML Content
              AppHtmlV2(
                data: comment.comment,
                fontSize: 14,
                textColor: design.colors.textPrimary,
              ),
              SizedBox(height: design.spacing.xs),
              // Footer: Reply Action
              Align(
                alignment: Alignment.centerLeft,
                child: AppSemantics.button(
                  label: 'Reply to ${comment.user.displayName}',
                  onTap: () => onReply(comment),
                  child: AppFocusable(
                    onTap: () => onReply(comment),
                    borderRadius: design.radius.button,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: 48,
                        minWidth: 48,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: design.spacing.xs,
                          horizontal: design.spacing.xs,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              LucideIcons.reply,
                              size: 14,
                              color: design.colors.primary,
                            ),
                            SizedBox(width: design.spacing.xs),
                            AppText.labelBold(
                              'Reply',
                              color: design.colors.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Nested Threaded Replies
        if (comment.children != null && comment.children!.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(
              left: depth < 2 ? design.spacing.md : design.spacing.xs,
              top: design.spacing.xs,
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 2,
                    margin: EdgeInsets.only(
                      left: design.spacing.xs,
                      right: design.spacing.sm,
                      top: design.spacing.xs,
                      bottom: design.spacing.xs,
                    ),
                    color: design.colors.divider,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final child in comment.children!)
                          Padding(
                            padding: EdgeInsets.only(bottom: design.spacing.xs),
                            child: CommentItemView(
                              comment: child,
                              onReply: onReply,
                              onDelete: onDelete,
                              depth: depth + 1,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _handleDelete(BuildContext context) async {
    final confirmed = await showConfirmationDialog(
      context,
      title: 'Delete Comment',
      content: 'Are you sure you want to delete this comment?',
      confirmText: 'Delete',
      cancelText: 'Cancel',
    );

    if (confirmed) {
      onDelete(comment.id);
    }
  }
}
