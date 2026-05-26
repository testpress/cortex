import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../providers/forum_providers.dart';
import '../widgets/forum_header.dart';
import '../widgets/forum_composer.dart';

// ─────────────────────────────────────────────────────
// Screen Entry Point
// ─────────────────────────────────────────────────────

/// Forum Thread Detail Screen.
///
/// Displays the full thread content, replies, and the sticky reply input.
/// Follows neutral UI semantics using core Design tokens exclusively.
class ForumPostDetailScreen extends ConsumerWidget {
  final String slug;
  final ForumThreadDto? initialThread;

  const ForumPostDetailScreen({
    super.key,
    required this.slug,
    this.initialThread,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    var threadAsync = ref.watch(globalForumThreadDetailProvider(slug));
    if (threadAsync.valueOrNull == null && initialThread != null) {
      threadAsync = AsyncValue.data(initialThread!);
    }
    
    final thread = threadAsync.valueOrNull;

    return SkeletonizerConfig(
      data: SkeletonizerConfigData(
        effect: ShimmerEffect(
          baseColor: design.colors.skeleton,
          highlightColor: design.colors.onSkeleton,
          duration: MotionPreferences.duration(context, const Duration(milliseconds: 800)),
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(color: design.colors.card),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomInset),
            child: Column(
              children: [
                _buildHeader(design, l10n),
                _buildDivider(design),
                Expanded(child: _buildBody(context, ref, l10n, threadAsync)),
                if (thread != null)
                  _StickyReplyInput(threadId: thread.threadId.toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(DesignConfig design, AppLocalizations l10n) {
    return ForumHeader(
      title: l10n.forumDiscussion,
      showDivider: false,
      actions: [
        AppFocusable(
          onTap: () {
          },
          borderRadius: BorderRadius.circular(design.radius.full),
          child: Padding(
            padding: EdgeInsets.all(design.spacing.xs),
            child: Icon(
              LucideIcons.moreVertical,
              color: design.colors.textPrimary,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(DesignConfig design) {
    return Container(height: 1, color: design.colors.divider);
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    AsyncValue<ForumThreadDto?> threadAsync,
  ) {
    if (threadAsync.hasError) {
      return Center(child: AppText.body(l10n.errorGenericMessage));
    }

    final thread = threadAsync.valueOrNull ?? initialThread;
    final isLoading = threadAsync.isLoading && thread == null;

    if (thread == null && !isLoading) {
      return Center(
        child: AppText.body(
          l10n.forumErrorDiscussionNotFound,
          color: Design.of(context).colors.textSecondary,
        ),
      );
    }

    final displayThread = thread ?? _mockSkeletonThread;

    return Skeletonizer(
      enabled: isLoading,
      child: _ThreadDetailBody(thread: displayThread),
    );
  }
}

// ─────────────────────────────────────────────────────
// Thread Detail Body
// ─────────────────────────────────────────────────────

class _ThreadDetailBody extends ConsumerWidget {
  final ForumThreadDto thread;

  const _ThreadDetailBody({required this.thread});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentsAsync = thread.threadId == 0 
        ? const AsyncValue<List<ForumCommentDto>>.loading()
        : ref.watch(globalForumCommentsProvider(thread.threadId));

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _ThreadContentHeader(thread: thread),
        _buildCommentsSection(context, commentsAsync),
      ],
    );
  }

  Widget _buildCommentsSection(
    BuildContext context,
    AsyncValue<List<ForumCommentDto>> commentsAsync,
  ) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    if (commentsAsync.hasError) {
      return Padding(
        padding: EdgeInsets.all(design.spacing.xl),
        child: Center(child: AppText.body(l10n.forumErrorLoadingComments)),
      );
    }

    final comments = commentsAsync.valueOrNull ?? [];
    final isLoading = commentsAsync.isLoading && comments.isEmpty;
    final displayComments = isLoading ? _mockSkeletonComments : comments;

    return Skeletonizer(
      enabled: isLoading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CommentsHeader(count: displayComments.length),
          if (displayComments.isEmpty && !isLoading)
            _buildEmptyState(context, design)
          else
            _CommentList(comments: displayComments),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, DesignConfig design) {
    final l10n = L10n.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 150),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.messageSquare,
              size: 48,
              color: design.colors.textTertiary.withValues(alpha: 0.2),
            ),
            SizedBox(height: design.spacing.md),
            AppText.title(
              l10n.forumCommentsEmptyTitle,
              color: design.colors.textSecondary,
            ),
            SizedBox(height: design.spacing.xs),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: design.spacing.xl),
              child: AppText.body(
                l10n.forumCommentsEmptySubtitle,
                color: design.colors.textTertiary,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Thread Content Header
// ─────────────────────────────────────────────────────

class _ThreadContentHeader extends StatelessWidget {
  final ForumThreadDto thread;

  const _ThreadContentHeader({required this.thread});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      padding: EdgeInsets.all(design.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.title(thread.title, color: design.colors.textPrimary),
          SizedBox(height: design.spacing.md),
          _ThreadMeta(thread: thread),
          if (thread.categorySlug != null && thread.categorySlug!.isNotEmpty) ...[
            SizedBox(height: design.spacing.md),
            _CategoryBadge(slug: thread.categorySlug!),
          ],
          SizedBox(height: design.spacing.lg),
          if (thread.contentHtml != null && thread.contentHtml!.trim().isNotEmpty)
            AppHtml(
              data: thread.contentHtml!,
              placeholder: Skeletonizer(
                enabled: true,
                child: AppText.bodySmall(thread.summary),
              ),
            )
          else
            AppText.bodySmall(thread.summary),
          if (thread.imageUrl != null) ...[
            SizedBox(height: design.spacing.md),
            _ThreadImage(imageUrl: thread.imageUrl!),
          ],
          SizedBox(height: design.spacing.sm),
        ],
      ),
    );
  }
}

class _ThreadMeta extends StatelessWidget {
  final ForumThreadDto thread;

  const _ThreadMeta({required this.thread});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _AuthorAvatar(avatarUrl: thread.authorAvatar, size: 36),
        const SizedBox(width: 12),
        _AuthorInfo(name: thread.authorName, createdAt: thread.createdAt),
        const Spacer(),
        _StatusBadge(status: thread.status),
      ],
    );
  }
}

class _AuthorInfo extends StatelessWidget {
  final String name;
  final String createdAt;

  const _AuthorInfo({required this.name, required this.createdAt});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.labelBold(name, color: design.colors.textPrimary),
        AppText.caption(_formatDateSafe(createdAt), color: design.colors.textSecondary),
      ],
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final String slug;

  const _CategoryBadge({required this.slug});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final label = slug
        .split('-')
        .map((s) => s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : '')
        .join(' ');

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: design.spacing.sm,
        vertical: design.spacing.xs,
      ),
      decoration: BoxDecoration(
        color: design.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(design.radius.sm),
      ),
      child: AppText.caption(
        label,
        color: design.colors.textSecondary,
      ),
    );
  }
}

class _ThreadImage extends StatelessWidget {
  final String imageUrl;

  const _ThreadImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(design.radius.lg),
      ),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, _) => const SizedBox.shrink(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Comments Section
// ─────────────────────────────────────────────────────

class _CommentsHeader extends StatelessWidget {
  final int count;

  const _CommentsHeader({required this.count});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        design.spacing.md,
        design.spacing.md,
        design.spacing.md,
        design.spacing.sm,
      ),
      child: AppText.labelBold(
        l10n.forumRepliesCount(count),
        color: design.colors.textPrimary,
      ),
    );
  }
}

class _CommentList extends StatelessWidget {
  final List<ForumCommentDto> comments;

  const _CommentList({required this.comments});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    if (comments.isEmpty) {
      return _EmptyComments(l10n: l10n, design: design);
    }

    return Padding(
      padding: EdgeInsets.all(design.spacing.md),
      child: Column(
        children: [
          for (int i = 0; i < comments.length; i++) ...[
            _CommentItem(comment: comments[i]),
            if (i < comments.length - 1) SizedBox(height: design.spacing.md),
          ],
        ],
      ),
    );
  }
}

class _EmptyComments extends StatelessWidget {
  final AppLocalizations l10n;
  final DesignConfig design;

  const _EmptyComments({required this.l10n, required this.design});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: design.spacing.xl * 2),
      child: Center(
        child: AppText.caption(
          l10n.forumNoDiscussions,
          color: design.colors.textTertiary,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _CommentItem extends StatelessWidget {
  final ForumCommentDto comment;

  const _CommentItem({required this.comment});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      padding: EdgeInsets.all(design.spacing.md),
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: BorderRadius.circular(design.radius.lg),
        border: Border.all(color: design.colors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CommentHeader(comment: comment),
          SizedBox(height: design.spacing.md),
          AppText.bodySmall(_stripHtmlTags(comment.content), color: design.colors.textPrimary),
        ],
      ),
    );
  }

  String _stripHtmlTags(String htmlString) {
    // 1. Convert block tags to actual newlines
    String s = htmlString.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');
    s = s.replaceAll(RegExp(r'</p>', caseSensitive: false), '\n\n');
    s = s.replaceAll(RegExp(r'</div>', caseSensitive: false), '\n');

    // 2. Remove all remaining HTML tags
    s = s.replaceAll(RegExp(r'<[^>]*>', multiLine: true), '');

    // 3. Unescape basic entities
    s = s.replaceAll('&nbsp;', ' ')
         .replaceAll('&amp;', '&')
         .replaceAll('&lt;', '<')
         .replaceAll('&gt;', '>')
         .replaceAll('&quot;', '"')
         .replaceAll('&#39;', "'");

    // 4. Clean up multiple spaces (but preserve newlines)
    s = s.replaceAll(RegExp(r'[ \t]+'), ' ');

    // 5. Clean up excessive newlines
    s = s.replaceAll(RegExp(r'\n{3,}'), '\n\n');

    return s.trim();
  }
}

class _CommentHeader extends StatelessWidget {
  final ForumCommentDto comment;

  const _CommentHeader({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _AuthorAvatar(avatarUrl: comment.authorAvatar, size: 32),
        const SizedBox(width: 12),
        Expanded(child: _CommentAuthorInfo(comment: comment)),
      ],
    );
  }
}

class _CommentAuthorInfo extends StatelessWidget {
  final ForumCommentDto comment;

  const _CommentAuthorInfo({required this.comment});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppText.labelBold(comment.authorName, color: design.colors.textPrimary),
            if (comment.isInstructor) ...[
              SizedBox(width: design.spacing.sm),
              _RoleBadge(role: l10n.forumRoleInstructor),
            ],
          ],
        ),
        AppText.caption(_formatDateSafe(comment.createdAt), color: design.colors.textSecondary),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────
// Sticky Reply Input
// ─────────────────────────────────────────────────────

class _StickyReplyInput extends ConsumerStatefulWidget {
  final String threadId;

  const _StickyReplyInput({required this.threadId});

  @override
  ConsumerState<_StickyReplyInput> createState() => _StickyReplyInputState();
}

class _StickyReplyInputState extends ConsumerState<_StickyReplyInput> {
  static const _editorService = QuillEditorService();

  late final quill.QuillController _controller;
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();
  bool _showToolbar = true;
  final List<String> _attachments = [];
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _controller = quill.QuillController.basic();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  bool get _hasContent => _controller.document.length > 1;

  Future<void> _handleSend() async {
    if (!_hasContent && _attachments.isEmpty) return;
    
    final html = _editorService.toHtml(_controller.document);
    final l10n = L10n.of(context);
    
    try {
      final threadId = int.parse(widget.threadId);
      await ref.read(postForumCommentProvider.notifier).submit(
            threadId: threadId,
            content: html,
            attachments: _attachments,
          );
      
      _controller.clear();
      setState(() => _attachments.clear());
      if (mounted) FocusScope.of(context).unfocus();
    } catch (e) {
      if (mounted) AppToast.show(context, message: l10n.forumErrorFailedToPostReply);
    }
  }

  void _toggleToolbar() => setState(() => _showToolbar = !_showToolbar);

  Future<void> _pickImages() async {
    if (_attachments.length >= 3) return;
    
    final images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        final remaining = 3 - _attachments.length;
        _attachments.addAll(images.take(remaining).map((image) => image.path));
      });
    }
  }

  void _removeAttachment(int index) {
    setState(() => _attachments.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: design.colors.card,
        border: Border(top: BorderSide(color: design.colors.divider)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_attachments.isNotEmpty)
            ForumAttachmentPreview(
              imageUrls: _attachments,
              onRemove: _removeAttachment,
            ),
          if (_showToolbar)
            ForumEditorToolbar(
              controller: _controller,
              onImagePick: _pickImages,
              isImageLimitReached: _attachments.length >= 3,
            ),
          _ReplyInputRow(
            controller: _controller,
            scrollController: _scrollController,
            focusNode: _focusNode,
            showToolbar: _showToolbar,
            onToggleToolbar: _toggleToolbar,
            onSend: _handleSend,
            isLoading: ref.watch(postForumCommentProvider).isLoading,
            l10n: AppLocalizations.of(context)!,
          ),
        ],
      ),
    );
  }
}

class _ReplyInputRow extends StatelessWidget {
  final quill.QuillController controller;
  final ScrollController scrollController;
  final FocusNode focusNode;
  final bool showToolbar;
  final VoidCallback onToggleToolbar;
  final VoidCallback onSend;
  final bool isLoading;
  final AppLocalizations l10n;

  const _ReplyInputRow({
    required this.controller,
    required this.scrollController,
    required this.focusNode,
    required this.showToolbar,
    required this.onToggleToolbar,
    required this.onSend,
    this.isLoading = false,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        design.spacing.md,
        design.spacing.xs,
        design.spacing.md,
        design.spacing.md,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height: 44,
            child: Center(
              child: ForumToolbarToggle(isActive: showToolbar, onTap: onToggleToolbar),
            ),
          ),
          SizedBox(width: design.spacing.sm),
          Expanded(
            child: ForumEditorField(
              controller: controller,
              scrollController: scrollController,
              focusNode: focusNode,
              placeholder: l10n.forumReplyPlaceholder,
              showPlaceholder: true,
              minHeight: 24,
              maxHeight: 80,
              expands: false,
              backgroundColor: design.colors.surfaceVariant.withValues(alpha: 0.5),
            ),
          ),
          SizedBox(width: design.spacing.sm),
          SizedBox(
            height: 44,
            child: Center(
              child: ForumSendButton(
                onTap: onSend,
                isLoading: isLoading,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Shared Primitives
// ─────────────────────────────────────────────────────

class _AuthorAvatar extends StatelessWidget {
  final String? avatarUrl;
  final double size;

  const _AuthorAvatar({this.avatarUrl, required this.size});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: design.colors.surfaceVariant,
        shape: BoxShape.circle,
      ),
      child: avatarUrl != null
          ? Image.network(
              avatarUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _fallbackIcon(design),
            )
          : _fallbackIcon(design),
    );
  }

  Widget _fallbackIcon(DesignConfig design) {
    return Icon(
      LucideIcons.user,
      size: size * 0.6,
      color: design.colors.textTertiary,
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

    return Skeleton.leaf(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: design.spacing.sm,
          vertical: design.spacing.xs,
        ),
        decoration: BoxDecoration(
          color: isAnswered
              ? design.colors.accent2.withValues(alpha: 0.12)
              : design.colors.surfaceVariant,
          borderRadius: BorderRadius.circular(design.radius.sm),
        ),
        child: AppText.caption(
          isAnswered ? l10n.forumLabelAnswered : l10n.forumLabelUnanswered,
          color: isAnswered ? design.colors.accent2 : design.colors.textSecondary,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, height: 1.1),
        ),
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final String role;

  const _RoleBadge({required this.role});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: design.colors.accent2.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(design.radius.sm),
      ),
      child: AppText.caption(
        role,
        color: design.colors.accent2,
        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.2),
      ),
    );
  }
}

String _formatDateSafe(String dateStr) {
  if (dateStr.isEmpty) return '';
  final dt = DateTime.tryParse(dateStr);
  if (dt != null) {
    return DateFormatter.formatDateTime(dt.toLocal());
  }
  return dateStr;
}

final _mockSkeletonComments = List.generate(
  3,
  (index) => ForumCommentDto(
    id: '$index',
    threadId: 0,
    authorName: 'Author Name',
    content: 'Loading comment content placeholder that spans across multiple lines...',
    createdAt: '2026-05-25T11:43:37Z',
  ),
);

final _mockSkeletonThread = ForumThreadDto(
  threadId: 0,
  slug: 'skeleton',
  title: 'Loading thread title placeholder...',
  summary: 'Loading thread summary placeholder that spans across multiple lines...',
  authorName: 'Author Name',
  createdAt: '2026-05-25T11:43:37Z',
  replyCount: 0,
  upvotes: 0,
  downvotes: 0,
  status: ForumThreadStatus.unanswered,
);
