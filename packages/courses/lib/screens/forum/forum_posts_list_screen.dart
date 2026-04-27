import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../../providers/forum_providers.dart';
import '../../widgets/forum/forum_header.dart';
import 'forum_post_create_screen.dart';

class ForumPostsListScreen extends ConsumerWidget {
  final String courseId;

  const ForumPostsListScreen({
    super.key,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(color: design.colors.card),
      child: Column(
        children: [
          ForumHeader(
            title: l10n.forumTitle,
            actions: [_CreatePostButton(courseId: courseId)],
          ),
          // Search bar — divider is AFTER the search bar
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: design.spacing.md,
              vertical: design.spacing.sm,
            ),
            child: AppSearchBar(
              hintText: l10n.forumSearchDiscussions,
              onChanged: (_) {},
              backgroundColor: design.colors.surfaceVariant,
            ),
          ),
          Container(height: 1, color: design.colors.divider),
          Expanded(child: _ForumPostsBody(courseId: courseId)),
        ],
      ),
    );
  }
}

class _CreatePostButton extends StatelessWidget {
  final String courseId;

  const _CreatePostButton({required this.courseId});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          AppRoute(page: ForumPostCreateScreen(courseId: courseId)),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: design.spacing.sm),
        child: AppText.labelSmall(
          l10n.forumCreatePost,
          // Use the accent/link colour — matches the blue "Create New Post" in design
          color: design.colors.accent2,
        ),
      ),
    );
  }
}

class _ForumPostsBody extends ConsumerWidget {
  final String courseId;

  const _ForumPostsBody({required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final threadsAsync = ref.watch(courseForumThreadsProvider(courseId));

    return threadsAsync.when(
      data: (threads) => _ThreadList(threads: threads),
      loading: () => const Center(child: AppLoadingIndicator()),
      error: (error, _) => Center(child: AppText.body('Error: $error')),
    );
  }
}

class _ThreadList extends StatelessWidget {
  final List<ForumThreadDto> threads;

  const _ThreadList({required this.threads});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    if (threads.isEmpty) {
      return Center(
        child: AppText.body(
          l10n.forumNoDiscussions,
          color: design.colors.textSecondary,
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: threads.length,
      separatorBuilder: (context, index) => Container(
        height: 1,
        color: design.colors.divider,
      ),
      itemBuilder: (context, index) => _ThreadItem(thread: threads[index]),
    );
  }
}

class _ThreadItem extends StatelessWidget {
  final ForumThreadDto thread;

  const _ThreadItem({required this.thread});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return GestureDetector(
      onTap: () => context.push('/home/forum/posts/${thread.courseId}/${thread.id}'),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: design.spacing.md,
          vertical: design.spacing.md,
        ),
        // Use card (pure white) throughout — no dark canvas gaps between items
        color: design.colors.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bold title wrapping to multiple lines — matches design
            AppText.cardTitle(
              thread.title,
              color: design.colors.textPrimary,
            ),
            const SizedBox(height: 6),
            AppText.cardSubtitle(
              thread.description,
              color: design.colors.textSecondary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            _ThreadFooter(thread: thread),
          ],
        ),
      ),
    );
  }
}

class _ThreadFooter extends StatelessWidget {
  final ForumThreadDto thread;

  const _ThreadFooter({required this.thread});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ThreadAuthorMeta(thread: thread),
        _ThreadStats(thread: thread),
      ],
    );
  }
}

class _ThreadAuthorMeta extends StatelessWidget {
  final ForumThreadDto thread;

  const _ThreadAuthorMeta({required this.thread});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Expanded(
      child: Row(
        children: [
          Flexible(
            child: AppText.caption(
              thread.authorName,
              color: design.colors.textSecondary,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: design.spacing.xs),
            child: AppText.caption('•', color: design.colors.textSecondary),
          ),
          AppText.caption(
            thread.timeAgo,
            color: design.colors.textSecondary,
          ),
        ],
      ),
    );
  }
}

class _ThreadStats extends StatelessWidget {
  final ForumThreadDto thread;

  const _ThreadStats({required this.thread});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Row(
      children: [
        Icon(
          LucideIcons.messageSquare,
          size: 14,
          color: design.colors.textSecondary,
        ),
        const SizedBox(width: 4),
        AppText.caption(
          '${thread.replyCount}',
          color: design.colors.textSecondary,
        ),
        const SizedBox(width: 10),
        _StatusBadge(status: thread.status),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final ForumThreadStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final isAnswered = status == ForumThreadStatus.answered;

    // Filled pill: Answered = blue, Unanswered = grey
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: isAnswered
            ? design.colors.accent2.withValues(alpha: 0.12)
            : design.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(4),
      ),
      child: AppText.caption(
        isAnswered ? l10n.forumLabelAnswered : l10n.forumLabelUnanswered,
        color: isAnswered ? design.colors.accent2 : design.colors.textSecondary,
        style: const TextStyle(fontSize: 10, height: 1.1, fontWeight: FontWeight.w600),
      ),
    );
  }
}
