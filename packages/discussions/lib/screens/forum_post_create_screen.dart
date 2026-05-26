import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:image_picker/image_picker.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../providers/forum_providers.dart';
import '../widgets/forum_header.dart';
import '../widgets/forum_composer.dart';

class ForumPostCreateScreen extends ConsumerStatefulWidget {
  final String? courseId;

  const ForumPostCreateScreen({super.key, this.courseId});

  @override
  ConsumerState<ForumPostCreateScreen> createState() =>
      _ForumPostCreateScreenState();
}

class _ForumPostCreateScreenState extends ConsumerState<ForumPostCreateScreen> {
  final TextEditingController _titleController = TextEditingController();
  late final quill.QuillController _quillController;
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final List<String> _attachments = [];
  final ImagePicker _picker = ImagePicker();
  
  bool _isSubmitting = false;
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _quillController = quill.QuillController.basic();
    
    // Refresh UI on changes to enable/disable submit button
    _titleController.addListener(_onInputChanged);
    _quillController.addListener(_onInputChanged);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _quillController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onInputChanged() {
    setState(() {});
  }

  bool get _hasDescription =>
      _quillController.document.toPlainText().trim().isNotEmpty;

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

  Future<void> _handleSubmit() async {
    final categories = ref.read(globalForumCategoriesProvider).valueOrNull ??
        const <ForumCategoryDto>[];
    final effectiveSelectedCategoryId = _selectedCategoryId ??
        (categories.isNotEmpty ? categories.first.id : null);
    final isValid = _titleController.text.trim().isNotEmpty &&
        _hasDescription &&
        effectiveSelectedCategoryId != null;

    if (!isValid || _isSubmitting) return;

    setState(() => _isSubmitting = true);

    final category = categories.firstWhere((c) => c.id == effectiveSelectedCategoryId);
    
    final html = QuillEditorService().toHtml(_quillController.document);

    try {
      final notifier = ref.read(createForumThreadProvider.notifier);
      await notifier.submit(
        title: _titleController.text.trim(),
        content: html,
        categorySlug: category.slug,
        courseId: widget.courseId,
        attachments: _attachments,
      );
      
      final state = ref.read(createForumThreadProvider);
      if (state.hasError) {
        throw state.error!;
      }
      
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        AppToast.show(context, message: L10n.of(context).forumErrorFailedToCreatePost);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final categoriesAsync = ref.watch(globalForumCategoriesProvider);
    final createPostState = ref.watch(createForumThreadProvider);
    
    final categories = categoriesAsync.valueOrNull ?? const <ForumCategoryDto>[];
    final effectiveSelectedCategoryId = _selectedCategoryId ??
        (categories.isNotEmpty ? categories.first.id : null);
    final isValid = _titleController.text.trim().isNotEmpty &&
        _hasDescription &&
        effectiveSelectedCategoryId != null;

    return Stack(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(color: design.colors.card),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                ForumHeader(
                  title: l10n.forumCreateNewPost,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(design.spacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppText.labelBold(l10n.forumPostSubjectLabel, color: design.colors.textPrimary),
                        SizedBox(height: design.spacing.xs),
                        AppTextField(
                          label: '', // Empty because we manual label above
                          hintText: l10n.forumPostTitleHint,
                          controller: _titleController,
                          autofocus: true,
                          textStyle: design.typography.bodySmall,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: design.spacing.sm,
                            horizontal: 0,
                          ),
                        ),
                        SizedBox(height: design.spacing.lg),
                        _buildCategoryPicker(design, categoriesAsync),
                        SizedBox(height: design.spacing.lg),
                        AppText.labelBold(l10n.forumPostDescriptionLabel, color: design.colors.textPrimary),
                        SizedBox(height: design.spacing.xs),
                        ForumEditorToolbar(
                          controller: _quillController,
                          onImagePick: _pickImages,
                          isImageLimitReached: _attachments.length >= 3,
                        ),
                        const SizedBox(height: 4),
                        ForumEditorField(
                          controller: _quillController,
                          scrollController: _scrollController,
                          focusNode: _focusNode,
                          placeholder: l10n.forumPostDescriptionHint,
                          minHeight: 180,
                          maxHeight: 180,
                          expands: false,
                        ),
                        if (_attachments.isNotEmpty) ...[
                          SizedBox(height: design.spacing.sm),
                          ForumAttachmentPreview(
                            imageUrls: _attachments,
                            onRemove: _removeAttachment,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                _buildBottomActionBar(design, l10n, isValid, createPostState),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryPicker(
    DesignConfig design,
    AsyncValue<List<ForumCategoryDto>> categoriesAsync,
  ) {
    final l10n = L10n.of(context);
    final categories = categoriesAsync.valueOrNull ?? const <ForumCategoryDto>[];
    
    // Resolve selection
    final selectedCategoryId = _selectedCategoryId ?? 
        (categories.isNotEmpty ? categories.first.id : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.labelBold(l10n.forumPostCategoryLabel, color: design.colors.textPrimary),
        SizedBox(height: design.spacing.xs),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((c) {
            final isSelected = selectedCategoryId == c.id;
            return GestureDetector(
              onTap: () => setState(() => _selectedCategoryId = c.id),
              child: AnimatedContainer(
                duration: design.motion.fast,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? design.colors.accent2 : design.colors.card,
                  borderRadius: design.radius.pill,
                  border: Border.all(color: isSelected ? design.colors.accent2 : design.colors.border),
                ),
                child: AppText.labelSmall(c.name, color: isSelected ? design.colors.textInverse : null),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBottomActionBar(
    DesignConfig design,
    AppLocalizations l10n,
    bool isValid,
    AsyncValue<void> createPostState,
  ) {
    final isSubmitting = createPostState.isLoading;
    final isSubmitEnabled = isValid && !isSubmitting;

    return Container(
      padding: EdgeInsets.fromLTRB(
        design.spacing.md,
        design.spacing.sm,
        design.spacing.md,
        design.spacing.md,
      ),
      decoration: BoxDecoration(
        color: design.colors.card,
      ),
      child: Row(
        children: [
          Expanded(
            child: AppButton.secondary(
              label: l10n.forumButtonCancel,
              fullWidth: true,
              onPressed: () => Navigator.of(context).pop(),
              backgroundColor: design.colors.surfaceVariant,
              foregroundColor: design.colors.textPrimary,
              borderColor: const Color(0x00000000),
              height: 52,
              padding: EdgeInsets.symmetric(
                horizontal: design.spacing.xl,
                vertical: design.spacing.sm,
              ),
            ),
          ),
          SizedBox(width: design.spacing.md),
          Expanded(
            child: AppButton.primary(
              label: l10n.forumButtonSubmit,
              fullWidth: true,
              onPressed: isSubmitEnabled ? _handleSubmit : null,
              loading: isSubmitting,
              backgroundColor: isSubmitEnabled
                  ? design.colors.accent2
                  : design.colors.accent2.withValues(alpha: 0.5),
              foregroundColor: isSubmitEnabled
                  ? design.colors.textInverse
                  : design.colors.textInverse.withValues(alpha: 0.9),
              height: 52,
              padding: EdgeInsets.symmetric(
                horizontal: design.spacing.xl,
                vertical: design.spacing.sm,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
