import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/courses.dart';
import '../widgets/forum_header.dart';
import '../widgets/forum_composer.dart';
import '../widgets/doubt_context_badge.dart';
import '../widgets/hierarchical_topic_picker.dart';

class AskDoubtFormScreen extends ConsumerStatefulWidget {
  final int? chapterContentId;
  final String? lessonTitle;
  final LessonType? lessonType;
  final int? questionId;
  final String? questionText;
  final String? assessmentTitle;

  const AskDoubtFormScreen({
    super.key,
    this.chapterContentId,
    this.lessonTitle,
    this.lessonType,
    this.questionId,
    this.questionText,
    this.assessmentTitle,
  }) : assert(
         (chapterContentId == null && lessonTitle == null) ||
             questionId == null,
         'Cannot provide both lesson context and questionId',
       );

  @override
  ConsumerState<AskDoubtFormScreen> createState() => _AskDoubtFormScreenState();
}

class _AskDoubtFormScreenState extends ConsumerState<AskDoubtFormScreen> {
  final TextEditingController _titleController = TextEditingController();
  late final quill.QuillController _quillController;
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  int? _finalizedTopicId;
  bool _isTopicFinalized = false;
  bool _isSubmitSheetOpen = false;
  bool _isSubmitting = false;

  Future<({String lessonTitle, String chapterTitle, String courseTitle})?>?
  _lessonDetailsFuture;

  @override
  void initState() {
    super.initState();
    _quillController = quill.QuillController.basic();
    _titleController.addListener(() => setState(() {}));
    _quillController.addListener(() => setState(() {}));

    if (widget.chapterContentId != null) {
      _lessonDetailsFuture = ref
          .read(courseRepositoryProvider.future)
          .then(
            (repo) =>
                repo.getLessonDetails(widget.chapterContentId!.toString()),
          );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _quillController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Stack(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(color: design.colors.card),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                ForumHeader(title: l10n.doubtsHeaderAskDoubt),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.all(design.spacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (widget.chapterContentId != null ||
                            widget.questionId != null) ...[
                          _contextLinkBadge(design, l10n),
                          const SizedBox(height: 16),
                        ],
                        _sectionLabel(l10n.doubtsFormTitleLabel),
                        const SizedBox(height: 8),
                        AppTextField(
                          label: '',
                          hintText: l10n.doubtsFormTitleHint,
                          controller: _titleController,
                          autofocus: true,
                          textStyle: design.typography.bodySmall,
                        ),
                        const SizedBox(height: 24),
                        _sectionLabel(l10n.doubtsFormDescriptionLabel),
                        const SizedBox(height: 8),
                        ForumEditorToolbar(controller: _quillController),
                        const SizedBox(height: 4),
                        ForumEditorField(
                          controller: _quillController,
                          scrollController: _scrollController,
                          focusNode: _focusNode,
                          placeholder: l10n.doubtsFormDescriptionLabel,
                          minHeight: 160,
                          maxHeight: 240,
                        ),
                        const SizedBox(height: 24),
                        _sectionLabel(l10n.doubtsFormCategoryLabel),
                        const SizedBox(height: 8),
                        HierarchicalTopicPicker(
                          onTopicFinalized: (topicId, {required isFinalized}) {
                            setState(() {
                              _finalizedTopicId = topicId;
                              _isTopicFinalized = isFinalized;
                            });
                          },
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
                _actionBar(design, l10n),
              ],
            ),
          ),
        ),
        AppBottomSheet(
          isOpen: _isSubmitSheetOpen,
          onClose: () => setState(() => _isSubmitSheetOpen = false),
          child: _SubmitOptionsSheet(
            design: design,
            l10n: l10n,
            onOptionSelected: (queryType) {
              setState(() => _isSubmitSheetOpen = false);
              _submitDoubt(queryType);
            },
          ),
        ),
        if (_isSubmitting)
          Positioned.fill(
            child: Container(
              color: design.colors.card.withValues(alpha: 0.7),
              child: const Center(child: AppLoadingIndicator()),
            ),
          ),
      ],
    );
  }

  // --- UI Components ---

  Widget _sectionLabel(String label) => AppText.labelBold(label);

  Widget _contextLinkBadge(DesignConfig design, AppLocalizations l10n) {
    final isQuestion = widget.questionId != null;
    final icon = isQuestion
        ? LucideIcons.helpCircle
        : widget.lessonType?.icon ?? LucideIcons.bookOpen;

    if (widget.chapterContentId != null && _lessonDetailsFuture != null) {
      return FutureBuilder(
        future: _lessonDetailsFuture,
        builder: (context, snapshot) {
          final data = snapshot.data;

          return DoubtContextBadge(
            icon: icon,
            text: isQuestion
                ? widget.questionText ?? 'Question ID: ${widget.questionId}'
                : data?.lessonTitle ?? widget.lessonTitle ?? 'Lesson Details',
            breadcrumbs: data != null
                ? [data.courseTitle, data.chapterTitle]
                : (isQuestion && widget.assessmentTitle != null
                      ? [widget.assessmentTitle!]
                      : null),
          );
        },
      );
    }

    return DoubtContextBadge(
      icon: icon,
      text: isQuestion
          ? widget.questionText ?? 'Question ID: ${widget.questionId}'
          : widget.lessonTitle ?? 'Lesson Details',
      breadcrumbs: isQuestion && widget.assessmentTitle != null
          ? [widget.assessmentTitle!]
          : null,
    );
  }

  Widget _actionBar(DesignConfig design, AppLocalizations l10n) {
    final canSubmit =
        _titleController.text.trim().isNotEmpty &&
        _quillController.document.toPlainText().trim().isNotEmpty &&
        _isTopicFinalized;

    return Container(
      padding: EdgeInsets.fromLTRB(
        design.spacing.md,
        8,
        design.spacing.md,
        design.spacing.md,
      ),
      decoration: BoxDecoration(
        color: design.colors.card,
        border: Border(top: BorderSide(color: design.colors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: AppButton.secondary(
              label: l10n.forumButtonCancel,
              fullWidth: true,
              onPressed: () => Navigator.pop(context),
              backgroundColor: design.colors.surfaceVariant,
              foregroundColor: design.colors.textPrimary,
              borderColor: const Color(0x00000000),
              height: 52,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: AppButton.primary(
              label: l10n.doubtsFormNextAction,
              trailing: Icon(
                LucideIcons.arrowRight,
                size: 18,
                color: canSubmit
                    ? design.colors.textInverse
                    : design.colors.textInverse.withValues(alpha: 0.9),
              ),
              fullWidth: true,
              onPressed: canSubmit
                  ? () => setState(() => _isSubmitSheetOpen = true)
                  : null,
              height: 52,
              backgroundColor: canSubmit
                  ? design.colors.accent2
                  : design.colors.accent2.withValues(alpha: 0.5),
              foregroundColor: canSubmit
                  ? design.colors.textInverse
                  : design.colors.textInverse.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  // --- Logic ---

  void _submitDoubt(DoubtQueryType queryType) {
    final title = _titleController.text.trim();
    final contentText = _quillController.document.toPlainText().trim();
    if (title.isEmpty || contentText.isEmpty || !_isTopicFinalized) {
      return;
    }

    setState(() => _isSubmitting = true);

    // Capture values needed for background task
    final descriptionHtml = const QuillEditorService().toHtml(
      _quillController.document,
    );
    final topicId = _finalizedTopicId;
    final chapterContentId = widget.chapterContentId;
    final questionId = widget.questionId;

    ref.read(doubtRepositoryProvider.future).then((repo) async {
      try {
        String finalHtml = descriptionHtml;

        final newDoubtId = await repo.createDoubt(
          title: title,
          description: finalHtml,
          topicId: topicId,
          chapterContentId: chapterContentId,
          questionId: questionId,
          queryType: queryType,
        );

        if (mounted) {
          AppToast.show(
            context,
            message: L10n.of(context).doubtsSubmitSuccessMessage,
          );
          Navigator.pop(context);
          context.push('/home/discussions/doubts/$newDoubtId');
        }
      } catch (e) {
        debugPrint('Doubt submit failed: $e');
        if (mounted) {
          setState(() => _isSubmitting = false);
          AppToast.show(
            context,
            message: L10n.of(context).doubtsSubmitErrorMessage,
          );
          Navigator.pop(context);
        }
      }
    });
  }
}

class _SubmitOptionsSheet extends StatelessWidget {
  final DesignConfig design;
  final AppLocalizations l10n;
  final void Function(DoubtQueryType) onOptionSelected;

  const _SubmitOptionsSheet({
    required this.design,
    required this.l10n,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            borderRadius: BorderRadius.all(Radius.circular(design.radius.xxl)),
            boxShadow: design.shadows.floating,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              AppText.subtitle(
                l10n.doubtsSubmitSheetTitle,
                color: design.colors.textPrimary,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: design.spacing.md),
              _OptionCard(
                design: design,
                icon: LucideIcons.bot,
                title: l10n.doubtsSubmitSheetAskAi,
                description: l10n.doubtsSubmitSheetAskAiDesc,
                onTap: () => onOptionSelected(DoubtQueryType.ai),
              ),
              _OptionCard(
                design: design,
                icon: LucideIcons.user,
                title: l10n.doubtsSubmitSheetAskMentor,
                description: l10n.doubtsSubmitSheetAskMentorDesc,
                onTap: () => onOptionSelected(DoubtQueryType.mentor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final DesignConfig design;
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _OptionCard({
    required this.design,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppFocusable(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: design.spacing.md),
        child: Row(
          children: [
            Icon(
              icon,
              color: design.colors.textPrimary,
              size: design.iconSize.lg,
            ),
            SizedBox(width: design.spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.body(title, color: design.colors.textPrimary),
                  SizedBox(height: 2),
                  AppText.caption(
                    description,
                    color: design.colors.textSecondary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
