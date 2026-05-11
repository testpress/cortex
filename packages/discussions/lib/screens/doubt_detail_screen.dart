import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:file_picker/file_picker.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../providers/doubt_providers.dart';
import '../widgets/forum_header.dart';
import '../widgets/forum_composer.dart';

// ─────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────

class DoubtDetailScreen extends ConsumerWidget {
  final String doubtId;

  const DoubtDetailScreen({super.key, required this.doubtId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(doubtDetailProvider(doubtId));
    final repliesAsync = ref.watch(doubtRepliesProvider(doubtId));
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return AppShell(
      backgroundColor: design.colors.card,
      child: detailAsync.when(
        data: (doubt) => Column(
          children: [
            ForumHeader(title: l10n.doubtDetailTitle),
            Expanded(
              child: Skeletonizer(
                enabled: repliesAsync.isLoading,
                child: _DoubtScrollBody(doubt: doubt, repliesAsync: repliesAsync, doubtId: doubtId),
              ),
            ),
            _DoubtReplyComposer(doubtId: doubtId),
          ],
        ),
        loading: () => const Center(child: AppLoadingIndicator()),
        error: (_, _) => AppErrorView(
          message: l10n.errorFailedToLoadDoubtDetails,
          onRetry: () => ref.invalidate(doubtDetailProvider(doubtId)),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Scrollable body
// ─────────────────────────────────────────────────────

class _DoubtScrollBody extends StatefulWidget {
  final DoubtDto doubt;
  final AsyncValue<List<DoubtReplyDto>> repliesAsync;
  final String doubtId;

  const _DoubtScrollBody({
    required this.doubt,
    required this.repliesAsync,
    required this.doubtId,
  });

  @override
  State<_DoubtScrollBody> createState() => _DoubtScrollBodyState();
}

class _DoubtScrollBodyState extends State<_DoubtScrollBody> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DoubtHeaderCard(doubt: widget.doubt),
          const SizedBox(height: 8),
          _RepliesList(repliesAsync: widget.repliesAsync, doubtId: widget.doubtId),
          const SizedBox(height: 100),
        ],
      ),
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
      data: (replies) => Column(
        children: replies.map((r) => _ReplyCard(reply: r)).toList(),
      ),
      loading: () => Column(
        children: List.generate(2, (_) => _ReplyCard(reply: _dummyReply)),
      ),
      error: (_, _) => AppErrorView(
        message: l10n.errorFailedToLoadReplies,
        onRetry: () => ref.invalidate(doubtRepliesProvider(doubtId)),
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
          if (doubt.courseName != null) ...[
            _SubjectBadge(subject: doubt.courseName!),
            const SizedBox(height: 12),
          ],
          AppText.headline(doubt.title),
          const SizedBox(height: 12),
          AppText.bodySmall(doubt.content),
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
        Skeleton.ignore(child: AppText.caption(DateFormatter.formatTimeAgo(doubt.createdAt))),
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
      margin: EdgeInsets.fromLTRB(design.spacing.md, 0, design.spacing.md, design.spacing.md),
      padding: EdgeInsets.all(design.spacing.md),
      decoration: _replyDecoration(design),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ReplyHeader(reply: reply),
          const SizedBox(height: 12),
          AppText.bodySmall(reply.content),
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

    return Row(
      children: [
        Skeleton.ignore(
          child: AppText.labelBold(
            reply.authorName,
            color: reply.isMentor ? design.colors.accent2 : null,
          ),
        ),
        if (reply.isMentor) ...[
          SizedBox(width: design.spacing.sm),
          Skeleton.ignore(child: _MentorBadge()),
        ],
        const Spacer(),
        Skeleton.ignore(
          child: AppText.caption(DateFormatter.formatTimeAgo(reply.createdAt)),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────
// Reply Composer
// ─────────────────────────────────────────────────────

class _DoubtReplyComposer extends StatefulWidget {
  final String doubtId;

  const _DoubtReplyComposer({required this.doubtId});

  @override
  State<_DoubtReplyComposer> createState() => _DoubtReplyComposerState();
}

class _DoubtReplyComposerState extends State<_DoubtReplyComposer> {
  final _controller = quill.QuillController.basic();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();
  final _attachments = <String>[];
  bool _showToolbar = true;
  bool _isSubmitting = false;

  static const _maxAttachments = 5;

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

    return Container(
      decoration: BoxDecoration(
        color: design.colors.card,
        border: Border(top: BorderSide(color: design.colors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_attachments.isNotEmpty) ...[
              ForumAttachmentPreview(
                imageUrls: _attachments,
                onRemove: (i) => setState(() => _attachments.removeAt(i)),
              ),
              const SizedBox(height: 8),
            ],
            if (_showToolbar) ...[
              ForumEditorToolbar(
                controller: _controller,
                onImagePick: _pickAttachments,
                isImageLimitReached: _attachments.length >= _maxAttachments,
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
                        onTap: () => setState(() => _showToolbar = !_showToolbar),
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
                      backgroundColor: design.colors.surfaceVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  SizedBox(width: design.spacing.sm),
                  SizedBox(
                    height: 44,
                    child: Center(
                      child: ForumSendButton(
                        onTap: _isSubmitting ? () {} : _handleSubmit,
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
    if (_attachments.length >= _maxAttachments) return;

    final result = await FilePicker.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result == null || result.paths.isEmpty) return;

    setState(() {
      final remaining = _maxAttachments - _attachments.length;
      _attachments.addAll(result.paths.take(remaining).whereType<String>());
    });
  }

  Future<void> _handleSubmit() async {
    final text = _controller.document.toPlainText().trim();
    if (text.isEmpty && _attachments.isEmpty) return;

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    _controller.clear();
    _focusNode.unfocus();
    setState(() {
      _isSubmitting = false;
      _attachments.clear();
    });
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
        l10n.labelMentor,
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
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.fileText, size: 24, color: design.colors.accent2),
                  const SizedBox(height: 2),
                  AppText.labelSmall(
                    'PDF',
                    color: design.colors.textSecondary,
                    style: const TextStyle(fontSize: 8),
                  ),
                ],
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(design.radius.md),
              child: Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    Icon(LucideIcons.image, size: 24, color: design.colors.textSecondary),
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
