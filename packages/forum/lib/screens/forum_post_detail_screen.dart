import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:image_picker/image_picker.dart';
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
  final String courseId;
  final String threadId;

  const ForumPostDetailScreen({
    super.key,
    required this.courseId,
    required this.threadId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final threadAsync = ref.watch(
      forumThreadDetailProvider(courseId: courseId, threadId: threadId),
    );
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return DecoratedBox(
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
              _StickyReplyInput(threadId: threadId),
            ],
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
            // TODO: Show options menu (Report, Share, etc.)
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
    return threadAsync.when(
      data: (thread) => thread == null
          ? Center(child: AppText.body(l10n.errorGenericTitle))
          : _ThreadDetailBody(thread: thread),
      loading: () => const Center(child: AppLoadingIndicator()),
      error: (error, stackTrace) => Center(child: AppText.body('Error: $error')),
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
    final commentsAsync = ref.watch(threadCommentsProvider(thread.id));

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

    return commentsAsync.when(
      data: (comments) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CommentsHeader(count: comments.length),
          _CommentList(comments: comments),
        ],
      ),
      loading: () => Padding(
        padding: EdgeInsets.all(design.spacing.xl),
        child: const Center(child: AppLoadingIndicator()),
      ),
      error: (error, stackTrace) => Padding(
        padding: EdgeInsets.all(design.spacing.xl),
        child: const Center(child: AppText.body('Error loading comments')),
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
          SizedBox(height: design.spacing.lg),
          AppText.bodySmall(thread.description),
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
        _AuthorInfo(name: thread.authorName, timeAgo: thread.timeAgo),
        const Spacer(),
        _StatusBadge(status: thread.status),
      ],
    );
  }
}

class _AuthorInfo extends StatelessWidget {
  final String name;
  final String timeAgo;

  const _AuthorInfo({required this.name, required this.timeAgo});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.labelBold(name, color: design.colors.textPrimary),
        AppText.caption(timeAgo, color: design.colors.textSecondary),
      ],
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

    return Padding(
      padding: EdgeInsets.fromLTRB(
        design.spacing.md,
        design.spacing.md,
        design.spacing.md,
        design.spacing.sm,
      ),
      child: AppText.labelBold(
        '$count Replies',
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
          AppText.bodySmall(comment.content, color: design.colors.textPrimary),
        ],
      ),
    );
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppText.labelBold(comment.authorName, color: design.colors.textPrimary),
            if (comment.isInstructor) ...[
              SizedBox(width: design.spacing.sm),
              const _RoleBadge(role: 'Instructor'),
            ],
          ],
        ),
        AppText.caption(comment.timeAgo, color: design.colors.textSecondary),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────
// Sticky Reply Input
// ─────────────────────────────────────────────────────

class _StickyReplyInput extends StatefulWidget {
  final String threadId;

  const _StickyReplyInput({required this.threadId});

  @override
  State<_StickyReplyInput> createState() => _StickyReplyInputState();
}

class _StickyReplyInputState extends State<_StickyReplyInput> {
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

  void _handleSend() {
    if (!_hasContent && _attachments.isEmpty) return;
    // ignore: unused_local_variable
    final html = _editorService.toHtml(_controller.document);
    _controller.clear();
    setState(() => _attachments.clear());
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
  final AppLocalizations l10n;

  const _ReplyInputRow({
    required this.controller,
    required this.scrollController,
    required this.focusNode,
    required this.showToolbar,
    required this.onToggleToolbar,
    required this.onSend,
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
              child: ForumSendButton(onTap: onSend),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Editor Container
// ─────────────────────────────────────────────────────

class _EditorContainer extends StatelessWidget {
  final quill.QuillController controller;
  final ScrollController scrollController;
  final FocusNode focusNode;
  final AppLocalizations l10n;

  const _EditorContainer({
    required this.controller,
    required this.scrollController,
    required this.focusNode,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      decoration: BoxDecoration(
        color: design.colors.surfaceVariant.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(design.radius.xl),
      ),
      clipBehavior: Clip.hardEdge,
      padding: EdgeInsets.symmetric(
        horizontal: design.spacing.md,
        vertical: design.spacing.sm,
      ),
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) => _EditorContent(
          controller: controller,
          scrollController: scrollController,
          focusNode: focusNode,
          l10n: l10n,
        ),
      ),
    );
  }
}

class _EditorContent extends StatelessWidget {
  final quill.QuillController controller;
  final ScrollController scrollController;
  final FocusNode focusNode;
  final AppLocalizations l10n;

  const _EditorContent({
    required this.controller,
    required this.scrollController,
    required this.focusNode,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return ClipRect(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 36, maxHeight: 120),
        child: RawScrollbar(
          controller: scrollController,
          thumbColor: design.colors.textTertiary.withValues(alpha: 0.3),
          radius: const Radius.circular(2),
          thickness: 3,
          thumbVisibility: true,
          padding: EdgeInsets.zero,
          child: _buildEditor(design),
        ),
      ),
    );
  }

  Widget _buildEditor(DesignConfig design) {
    return quill.QuillEditor.basic(
      controller: controller,
      focusNode: focusNode,
      scrollController: scrollController,
      config: quill.QuillEditorConfig(
        autoFocus: false,
        expands: false,
        padding: const EdgeInsets.only(right: 6),
        placeholder: l10n.forumReplyPlaceholder,
        customStyles: _buildEditorStyles(design),
      ),
    );
  }

  quill.DefaultStyles _buildEditorStyles(DesignConfig design) {
    final baseStyle = design.typography.body.copyWith(
      fontSize: 14,
      height: 1.3,
    );

    return quill.DefaultStyles(
      placeHolder: quill.DefaultTextBlockStyle(
        baseStyle.copyWith(color: design.colors.textTertiary),
        const quill.HorizontalSpacing(0, 0),
        const quill.VerticalSpacing(0, 0),
        const quill.VerticalSpacing(0, 0),
        null,
      ),
      paragraph: quill.DefaultTextBlockStyle(
        baseStyle.copyWith(color: design.colors.textPrimary),
        const quill.HorizontalSpacing(0, 0),
        const quill.VerticalSpacing(0, 0),
        const quill.VerticalSpacing(0, 0),
        null,
      ),
      lists: quill.DefaultListBlockStyle(
        baseStyle.copyWith(color: design.colors.textPrimary),
        const quill.HorizontalSpacing(0, 0),
        const quill.VerticalSpacing(0, 0),
        const quill.VerticalSpacing(0, 0),
        null,
        null,
      ),
    );
  }
}
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

    return Container(
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
