import 'package:flutter/cupertino.dart' show CupertinoSliverRefreshControl;
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:file_picker/file_picker.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/courses.dart';
import '../widgets/doubt_context_badge.dart';
import '../widgets/forum_header.dart';
import '../widgets/forum_composer.dart';

// ─────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────

class DoubtDetailScreen extends ConsumerStatefulWidget {
  final String doubtId;

  const DoubtDetailScreen({super.key, required this.doubtId});

  @override
  ConsumerState<DoubtDetailScreen> createState() => _DoubtDetailScreenState();
}

class _DoubtDetailScreenState extends ConsumerState<DoubtDetailScreen> {
  bool _isMenuOpen = false;

  void _openMenu() => setState(() => _isMenuOpen = true);
  void _closeMenu() => setState(() => _isMenuOpen = false);

  @override
  Widget build(BuildContext context) {
    // Watch this at the ROOT of the screen so it NEVER loses its listener
    // when the widget tree changes below (e.g. between loading and data states).
    // This entirely prevents the auto-dispose infinite API loop.
    final repliesAsync = ref.watch(doubtRepliesProvider(widget.doubtId));

    final detailAsync = ref.watch(doubtDetailProvider(widget.doubtId));
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final postReplyState = ref.watch(postDoubtReplyNotifierProvider);
    final isResolving = postReplyState.isLoading;

    return AppShell(
      backgroundColor: design.colors.card,
      bottomSheet: _buildActionSheet(design, l10n, detailAsync.valueOrNull),
      child: detailAsync.when(
        skipLoadingOnReload: true,
        data: (doubt) => _buildContent(
          context,
          ref,
          design,
          l10n,
          isResolving,
          doubt,
          widget.doubtId,
          repliesAsync,
          false,
        ),
        loading: () => Skeletonizer(
          enabled: true,
          child: _buildContent(
            context,
            ref,
            design,
            l10n,
            isResolving,
            _dummyDoubt,
            widget.doubtId,
            repliesAsync,
            true,
          ),
        ),
        error: (_, _) => AppErrorView(
          message: l10n.errorFailedToLoadDoubtDetails,
          onRetry: () => ref.invalidate(doubtDetailProvider(widget.doubtId)),
        ),
      ),
    );
  }

  Widget _buildActionSheet(
    DesignConfig design,
    AppLocalizations l10n,
    DoubtDto? doubt,
  ) {
    return AppBottomSheet(
      isOpen: _isMenuOpen,
      onClose: _closeMenu,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          design.spacing.sm,
          0,
          design.spacing.sm,
          design.spacing.md,
        ),
        child: SafeArea(
          top: false,
          child: Container(
            padding: EdgeInsets.fromLTRB(
              design.spacing.lg,
              design.spacing.md,
              design.spacing.lg,
              design.spacing.lg,
            ),
            decoration: BoxDecoration(
              color: design.colors.card,
              borderRadius: BorderRadius.all(
                Radius.circular(design.radius.xxl),
              ),
              boxShadow: design.shadows.floating,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Handle Bar
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: design.spacing.xl * 1.5,
                    height: 4,
                    decoration: BoxDecoration(
                      color: design.colors.border,
                      borderRadius: BorderRadius.circular(design.radius.full),
                    ),
                  ),
                ),
                SizedBox(height: design.spacing.lg),

                if (doubt != null && doubt.status != DoubtStatus.resolved)
                  AppFocusable(
                    onTap: () {
                      _closeMenu();
                      ref
                          .read(postDoubtReplyNotifierProvider.notifier)
                          .submit(doubtId: widget.doubtId, shouldResolve: true);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: design.spacing.md,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            LucideIcons.checkCircle,
                            size: design.iconSize.md,
                            color: design.colors.textPrimary,
                          ),
                          SizedBox(width: design.spacing.md),
                          AppText.body(
                            l10n.actionMarkAsResolved,
                            color: design.colors.textPrimary,
                          ),
                        ],
                      ),
                    ),
                  ),

                AppFocusable(
                  onTap: () {
                    _closeMenu();
                    ref
                        .read(postDoubtReplyNotifierProvider.notifier)
                        .submit(doubtId: widget.doubtId, shouldClose: true);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: design.spacing.md),
                    child: Row(
                      children: [
                        Icon(
                          LucideIcons.xCircle,
                          size: design.iconSize.md,
                          color: design.colors.error,
                        ),
                        SizedBox(width: design.spacing.md),
                        AppText.body(
                          l10n.actionCloseDoubt,
                          color: design.colors.error,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    DesignConfig design,
    AppLocalizations l10n,
    bool isResolving,
    DoubtDto doubt,
    String doubtId,
    AsyncValue<List<DoubtReplyDto>> repliesAsync,
    bool isLoading,
  ) {
    // If the doubt is loading, pretend replies are loading too
    final effectiveRepliesAsync = isLoading
        ? const AsyncValue<List<DoubtReplyDto>>.loading()
        : repliesAsync;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        children: [
          ForumHeader(
            title: l10n.doubtDetailTitle,
            actions: [
              if (doubt.status != DoubtStatus.closed)
                AppFocusable(
                  onTap: _openMenu,
                  child: Icon(
                    LucideIcons.moreVertical,
                    color: design.colors.textPrimary,
                    size: design.iconSize.md,
                  ),
                ),
            ],
          ),
          Expanded(
            child: _DoubtScrollBody(
              doubt: doubt,
              repliesAsync: effectiveRepliesAsync,
              doubtId: doubtId,
            ),
          ),
          if (!isLoading)
            _DoubtReplyComposer(doubtId: doubtId, status: doubt.status),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Scrollable body
// ─────────────────────────────────────────────────────

class _DoubtScrollBody extends ConsumerStatefulWidget {
  final DoubtDto doubt;
  final AsyncValue<List<DoubtReplyDto>> repliesAsync;
  final String doubtId;

  const _DoubtScrollBody({
    required this.doubt,
    required this.repliesAsync,
    required this.doubtId,
  });

  @override
  ConsumerState<_DoubtScrollBody> createState() => _DoubtScrollBodyState();
}

class _DoubtScrollBodyState extends ConsumerState<_DoubtScrollBody> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    return CustomScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            final repo = await ref.read(doubtRepositoryProvider.future);
            await repo.syncReplies(widget.doubtId);
          },
          builder:
              (
                context,
                refreshState,
                pulledExtent,
                refreshTriggerPullDistance,
                refreshIndicatorExtent,
              ) {
                return Opacity(
                  opacity: (pulledExtent / refreshTriggerPullDistance).clamp(
                    0.0,
                    1.0,
                  ),
                  child: Center(
                    child: AppLoadingIndicator(color: design.colors.primary),
                  ),
                );
              },
        ),
        if (widget.doubt.status == DoubtStatus.resolved)
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.fromLTRB(
                design.spacing.md,
                design.spacing.md,
                design.spacing.md,
                0,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: design.spacing.md,
                vertical: design.spacing.sm,
              ),
              decoration: BoxDecoration(
                color: design.colors.accent2.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(design.radius.md),
                border: Border.all(
                  color: design.colors.accent2.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.checkCircle,
                    color: design.colors.accent2,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppText.bodySmall(
                      l10n.messageDoubtResolved,
                      color: design.colors.accent2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (widget.doubt.status == DoubtStatus.closed)
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.fromLTRB(
                design.spacing.md,
                design.spacing.md,
                design.spacing.md,
                0,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: design.spacing.md,
                vertical: design.spacing.sm,
              ),
              decoration: BoxDecoration(
                color: design.colors.textTertiary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(design.radius.md),
                border: Border.all(color: design.colors.divider),
              ),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.lock,
                    color: design.colors.textTertiary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppText.bodySmall(
                      l10n.messageDiscussionClosed,
                      color: design.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        SliverToBoxAdapter(child: _DoubtHeaderCard(doubt: widget.doubt)),
        const SliverToBoxAdapter(child: SizedBox(height: 8)),
        _RepliesList(
          repliesAsync: widget.repliesAsync,
          doubtId: widget.doubtId,
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────
// Replies List
// ─────────────────────────────────────────────────────

class _RepliesList extends ConsumerWidget {
  final AsyncValue<List<DoubtReplyDto>> repliesAsync;
  final String doubtId;

  const _RepliesList({required this.repliesAsync, required this.doubtId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);

    return repliesAsync.when(
      data: (replies) => SliverList.builder(
        itemCount: replies.length,
        itemBuilder: (context, index) => _ReplyCard(reply: replies[index]),
      ),
      loading: () => SliverSkeletonizer(
        enabled: true,
        child: SliverList.builder(
          itemCount: 2,
          itemBuilder: (context, index) => _ReplyCard(reply: _dummyReply),
        ),
      ),
      error: (_, _) => SliverToBoxAdapter(
        child: AppErrorView(
          message: l10n.errorFailedToLoadReplies,
          onRetry: () => ref.invalidate(doubtRepliesProvider(doubtId)),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Doubt Header Card
// ─────────────────────────────────────────────────────

class _DoubtHeaderCard extends StatelessWidget {
  final DoubtDto doubt;

  const _DoubtHeaderCard({required this.doubt});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Padding(
      padding: EdgeInsets.all(design.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (doubt.lessonId != null)
            _LessonContextBadge(lessonId: doubt.lessonId!),
          if (doubt.topicName != null) ...[
            _SubjectBadge(subject: doubt.topicName!),
            const SizedBox(height: 12),
          ],
          AppText.headline(doubt.title),
          const SizedBox(height: 12),
          if (doubt.id == 'dummy')
            const _HtmlSkeletonPlaceholder()
          else
            AppHtmlV2(data: doubt.content),
          if (doubt.attachmentUrls.isNotEmpty)
            _AttachmentStrip(urls: doubt.attachmentUrls),
          const SizedBox(height: 16),
          _DoubtMeta(doubt: doubt),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Lesson Context Badge
// ─────────────────────────────────────────────────────

class _LessonContextBadge extends ConsumerStatefulWidget {
  final String lessonId;

  const _LessonContextBadge({required this.lessonId});

  @override
  ConsumerState<_LessonContextBadge> createState() =>
      _LessonContextBadgeState();
}

class _LessonContextBadgeState extends ConsumerState<_LessonContextBadge> {
  Future<({String lessonTitle, String chapterTitle, String courseTitle})?>?
  _detailsFuture;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  @override
  void didUpdateWidget(covariant _LessonContextBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lessonId != widget.lessonId) {
      setState(() {
        _fetchDetails();
      });
    }
  }

  void _fetchDetails() {
    _detailsFuture = ref
        .read(courseRepositoryProvider.future)
        .then((repo) => repo.getLessonDetails(widget.lessonId));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _detailsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox.shrink();
        }

        final data = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: DoubtContextBadge(
            icon: LucideIcons.bookOpen,
            text: data.lessonTitle,
            breadcrumbs: [data.courseTitle, data.chapterTitle],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────
// Doubt Meta (author + time)
// ─────────────────────────────────────────────────────

class _DoubtMeta extends StatelessWidget {
  final DoubtDto doubt;

  const _DoubtMeta({required this.doubt});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Row(
      children: [
        Skeleton.ignore(child: AppText.labelBold(doubt.studentName)),
        SizedBox(width: design.spacing.sm),
        Skeleton.ignore(child: AppText.caption('•')),
        SizedBox(width: design.spacing.sm),
        Skeleton.ignore(
          child: AppText.caption(
            doubt.createdHumanized ??
                DateFormatter.formatTimeAgo(doubt.createdAt),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────
// Reply Card
// ─────────────────────────────────────────────────────

class _ReplyCard extends StatelessWidget {
  final DoubtReplyDto reply;

  const _ReplyCard({required this.reply});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      margin: EdgeInsets.fromLTRB(
        design.spacing.md,
        0,
        design.spacing.md,
        design.spacing.md,
      ),
      padding: EdgeInsets.all(design.spacing.md),
      decoration: _replyDecoration(design),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ReplyHeader(reply: reply),
          const SizedBox(height: 12),
          if (reply.id == 'dummy')
            const _HtmlSkeletonPlaceholder()
          else
            AppHtmlV2(data: reply.content),
          if (reply.attachmentUrls.isNotEmpty)
            _AttachmentStrip(urls: reply.attachmentUrls),
        ],
      ),
    );
  }

  BoxDecoration _replyDecoration(DesignConfig design) {
    return BoxDecoration(
      color: reply.isMentor
          ? design.colors.accent2.withValues(alpha: 0.05)
          : design.colors.card,
      borderRadius: BorderRadius.circular(design.radius.lg),
      border: Border.all(
        color: reply.isMentor
            ? design.colors.accent2.withValues(alpha: 0.1)
            : design.colors.divider,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Reply Header (author + badge + time)
// ─────────────────────────────────────────────────────

class _ReplyHeader extends StatelessWidget {
  final DoubtReplyDto reply;

  const _ReplyHeader({required this.reply});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final displayName = reply.isBot ? 'AI Bot Response' : reply.authorName;

    return Row(
      children: [
        Skeleton.ignore(
          child: AppText.labelBold(
            displayName,
            color: reply.isMentor ? design.colors.accent2 : null,
          ),
        ),
        if (reply.isMentor) ...[
          SizedBox(width: design.spacing.sm),
          Skeleton.ignore(child: _MentorBadge(isBot: reply.isBot)),
        ],
        const Spacer(),
        Skeleton.ignore(
          child: AppText.caption(
            reply.createdHumanized ??
                DateFormatter.formatTimeAgo(reply.createdAt),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────
// Reply Composer
// ─────────────────────────────────────────────────────

class _DoubtReplyComposer extends ConsumerStatefulWidget {
  final String doubtId;
  final DoubtStatus status;

  const _DoubtReplyComposer({required this.doubtId, required this.status});

  @override
  ConsumerState<_DoubtReplyComposer> createState() =>
      _DoubtReplyComposerState();
}

class _DoubtReplyComposerState extends ConsumerState<_DoubtReplyComposer> {
  final _controller = quill.QuillController.basic();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();
  bool _showToolbar = true;
  bool _isSubmitting = false;
  final List<String> _attachments = [];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    if (widget.status == DoubtStatus.closed) {
      return Container(
        color: design.colors.surfaceVariant,
        padding: EdgeInsets.all(design.spacing.md),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.lock,
                size: 18,
                color: design.colors.textTertiary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppText.bodySmall(
                  l10n.messageDiscussionClosed,
                  color: design.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: design.colors.card,
        border: Border(top: BorderSide(color: design.colors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_attachments.isNotEmpty)
              ForumAttachmentPreview(
                imageUrls: _attachments,
                onRemove: (idx) => setState(() => _attachments.removeAt(idx)),
              ),
            if (_showToolbar) ...[
              ForumEditorToolbar(
                controller: _controller,
                onImagePick: _pickAttachments,
                isImageLimitReached: _attachments.length >= 3,
              ),
              const SizedBox(height: 8),
            ],
            Padding(
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
                      child: ForumToolbarToggle(
                        isActive: _showToolbar,
                        onTap: () =>
                            setState(() => _showToolbar = !_showToolbar),
                      ),
                    ),
                  ),
                  SizedBox(width: design.spacing.sm),
                  Expanded(
                    child: ForumEditorField(
                      controller: _controller,
                      scrollController: _scrollController,
                      focusNode: _focusNode,
                      placeholder: l10n.forumReplyPlaceholder,
                      minHeight: 24,
                      maxHeight: 80,
                      expands: false,
                      backgroundColor: design.colors.surfaceVariant.withValues(
                        alpha: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(width: design.spacing.sm),
                  SizedBox(
                    height: 44,
                    child: Center(
                      child: ForumSendButton(
                        onTap: _isSubmitting ? () {} : _handleSubmit,
                        isLoading: _isSubmitting,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAttachments() async {
    if (_attachments.length >= 3) return;

    final result = await FilePicker.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null && result.paths.isNotEmpty) {
      setState(() {
        final remaining = 3 - _attachments.length;
        _attachments.addAll(result.paths.whereType<String>().take(remaining));
      });
    }
  }

  Future<void> _handleSubmit() async {
    final text = _controller.document.toPlainText().trim();
    if (text.isEmpty && _attachments.isEmpty) return;

    setState(() => _isSubmitting = true);

    try {
      String finalHtml = const QuillEditorService().toHtml(
        _controller.document,
      );
      final repo = await ref.read(doubtRepositoryProvider.future);

      if (_attachments.isNotEmpty) {
        final uploadFutures = _attachments.map(
          (path) => repo.uploadDoubtImage(
            path,
            ticketId: int.tryParse(widget.doubtId),
          ),
        );
        final urls = await Future.wait(uploadFutures);
        for (final url in urls) {
          finalHtml += '<br><img src="$url" />';
        }
      }

      await ref
          .read(postDoubtReplyNotifierProvider.notifier)
          .submit(doubtId: widget.doubtId, comment: finalHtml);

      _controller.clear();
      _attachments.clear();
      _focusNode.unfocus();
    } catch (e) {
      debugPrint('Error posting reply: $e');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}

// ─────────────────────────────────────────────────────
// Badges
// ─────────────────────────────────────────────────────

class _SubjectBadge extends StatelessWidget {
  final String subject;

  const _SubjectBadge({required this.subject});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: design.spacing.sm,
        vertical: design.spacing.xs,
      ),
      decoration: BoxDecoration(
        color: design.colors.accent2.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(design.radius.sm),
      ),
      child: AppText.labelSmall(
        subject.toUpperCase(),
        color: design.colors.accent2,
        style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
    );
  }
}

class _MentorBadge extends StatelessWidget {
  final bool isBot;

  const _MentorBadge({this.isBot = false});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: design.spacing.sm - 2,
        vertical: design.spacing.xs - 2,
      ),
      decoration: BoxDecoration(
        color: design.colors.accent2,
        borderRadius: BorderRadius.circular(design.radius.sm),
      ),
      child: AppText.labelSmall(
        isBot ? 'Bot' : l10n.labelMentor,
        color: design.colors.textInverse,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Attachment Strip
// ─────────────────────────────────────────────────────

class _AttachmentStrip extends StatelessWidget {
  final List<String> urls;

  const _AttachmentStrip({required this.urls});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      height: design.spacing.xxxl,
      margin: EdgeInsets.only(top: design.spacing.sm + 4),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: urls.length,
        separatorBuilder: (_, _) => SizedBox(width: design.spacing.sm),
        itemBuilder: (context, index) => _AttachmentThumbnail(url: urls[index]),
      ),
    );
  }
}

class _AttachmentThumbnail extends StatelessWidget {
  final String url;

  const _AttachmentThumbnail({required this.url});

  bool get _isPdf => url.toLowerCase().endsWith('.pdf');

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      width: design.spacing.xxxl,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(design.radius.md),
        border: Border.all(color: design.colors.divider),
        color: design.colors.surfaceVariant,
      ),
      child: _isPdf
          ? Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.fileText,
                    size: 24,
                    color: design.colors.accent2,
                  ),
                  const SizedBox(height: 2),
                  AppText.labelSmall(
                    url.split('/').last,
                    color: design.colors.textSecondary,
                    style: const TextStyle(fontSize: 8),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(design.radius.md),
              child: Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Icon(
                  LucideIcons.image,
                  size: 24,
                  color: design.colors.textSecondary,
                ),
              ),
            ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Skeleton dummy data
// ─────────────────────────────────────────────────────

final _dummyReply = DoubtReplyDto(
  id: 'dummy',
  doubtId: 'dummy',
  content: 'This is a dummy reply content for skeleton loading purposes.',
  authorName: 'Mentor Name',
  isMentor: false,
  createdAt: DateTime.now(),
);

final _dummyDoubt = DoubtDto(
  id: 'dummy',
  title: 'This is a dummy doubt title for skeleton loading',
  content:
      'Dummy content to show while the doubt details are still being fetched from the server...',
  studentName: 'Student Name',
  status: DoubtStatus.active,
  createdAt: DateTime.now(),
);

// ─────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────

class _HtmlSkeletonPlaceholder extends StatelessWidget {
  const _HtmlSkeletonPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.body('This is a placeholder line that will be skeletonized.'),
        const SizedBox(height: 4),
        AppText.body(
          'Another placeholder line that is slightly longer for variation.',
        ),
        const SizedBox(height: 4),
        AppText.body('Short line.'),
      ],
    );
  }
}
