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
  final String courseId;

  const ForumPostCreateScreen({super.key, required this.courseId});

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
  String? _selectedCategoryId;
  bool _isCategorySheetOpen = false;

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
    final categories = ref.read(forumCategoriesProvider(widget.courseId)).valueOrNull ??
        const <ForumCategoryDto>[];
    final effectiveSelectedCategoryId = _selectedCategoryId ??
        (categories.isNotEmpty ? categories.first.id : null);
    final isValid = _titleController.text.trim().isNotEmpty &&
        _hasDescription &&
        effectiveSelectedCategoryId != null;

    if (!isValid || _isSubmitting) return;

    setState(() => _isSubmitting = true);

    // Mock delay for "submission"
    await Future.delayed(const Duration(milliseconds: 1000));

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _toggleCategorySheet() {
    setState(() => _isCategorySheetOpen = !_isCategorySheetOpen);
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final categoriesAsync = ref.watch(forumCategoriesProvider(widget.courseId));
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
                          contentPadding: EdgeInsets.symmetric(
                            vertical: design.spacing.sm,
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
                _buildBottomActionBar(design, l10n, isValid),
              ],
            ),
          ),
        ),
        _buildCategoryBottomSheet(design, categoriesAsync, effectiveSelectedCategoryId),
      ],
    );
  }

  Widget _buildCategoryPicker(
    DesignConfig design,
    AsyncValue<List<ForumCategoryDto>> categoriesAsync,
  ) {
    final l10n = L10n.of(context);
    final categories = categoriesAsync.valueOrNull ?? const <ForumCategoryDto>[];
    final selectedCategory = _resolveSelectedCategory(categories);
    final hasCategories = categories.isNotEmpty;

    final displayText = categoriesAsync.when(
      data: (_) => selectedCategory?.name ?? l10n.labelLoading,
      loading: () => l10n.labelLoading,
      error: (error, stackTrace) => l10n.errorGenericTitle,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.labelBold(l10n.forumPostCategoryLabel, color: design.colors.textPrimary),
        SizedBox(height: design.spacing.xs),
        AppFocusable(
          onTap: hasCategories ? _toggleCategorySheet : null,
          borderRadius: BorderRadius.circular(design.radius.lg),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: design.spacing.md,
              vertical: design.spacing.sm,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(design.radius.lg),
              border: Border.all(color: design.colors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText.bodySmall(
                  displayText,
                  color: design.colors.textPrimary,
                ),
                Icon(LucideIcons.chevronDown, size: 16, color: design.colors.textSecondary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryBottomSheet(
    DesignConfig design,
    AsyncValue<List<ForumCategoryDto>> categoriesAsync,
    String? effectiveSelectedCategoryId,
  ) {
    final l10n = L10n.of(context);
    final categories = categoriesAsync.valueOrNull ?? const <ForumCategoryDto>[];
    return AppBottomSheet(
      isOpen: _isCategorySheetOpen,
      onClose: _toggleCategorySheet,
      child: Container(
        decoration: BoxDecoration(
          color: design.colors.card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(design.radius.xl)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(design.spacing.md),
              child: AppText.title(l10n.forumPostSelectCategoryTitle),
            ),
            Container(height: 1, color: design.colors.divider),
            ...categoriesAsync.when(
              data: (_) => categories.map(
                (category) => AppFocusable(
                  onTap: () {
                    setState(() => _selectedCategoryId = category.id);
                    _toggleCategorySheet();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: design.spacing.xl,
                      vertical: design.spacing.md,
                    ),
                    child: AppText.body(
                      category.name,
                      color: category.id == effectiveSelectedCategoryId
                          ? design.colors.accent2
                          : design.colors.textPrimary,
                    ),
                  ),
                ),
              ),
              loading: () => [
                Padding(
                  padding: EdgeInsets.all(design.spacing.lg),
                  child: AppText.body(l10n.labelLoading),
                ),
              ],
              error: (error, stackTrace) => [
                Padding(
                  padding: EdgeInsets.all(design.spacing.lg),
                  child: AppText.body(l10n.errorGenericMessage),
                ),
              ],
            ),
            SizedBox(height: design.spacing.sm),
          ],
        ),
      ),
    );
  }

  ForumCategoryDto? _resolveSelectedCategory(List<ForumCategoryDto> categories) {
    if (categories.isEmpty) return null;
    if (_selectedCategoryId == null) return categories.first;
    for (final category in categories) {
      if (category.id == _selectedCategoryId) return category;
    }
    return categories.first;
  }

  Widget _buildBottomActionBar(
    DesignConfig design,
    AppLocalizations l10n,
    bool isValid,
  ) {
    final isSubmitEnabled = isValid && !_isSubmitting;

    return Container(
      padding: EdgeInsets.fromLTRB(
        design.spacing.md,
        design.spacing.xs,
        design.spacing.md,
        MediaQuery.of(context).padding.bottom,
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
              loading: _isSubmitting,
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
