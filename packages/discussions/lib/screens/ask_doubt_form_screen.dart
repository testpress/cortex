import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:image_picker/image_picker.dart';
import 'package:core/core.dart';
import '../providers/doubt_providers.dart';
import '../widgets/forum_header.dart';
import '../widgets/forum_composer.dart';

class AskDoubtFormScreen extends ConsumerStatefulWidget {
  const AskDoubtFormScreen({super.key});

  @override
  ConsumerState<AskDoubtFormScreen> createState() => _AskDoubtFormScreenState();
}

class _AskDoubtFormScreenState extends ConsumerState<AskDoubtFormScreen> {
  final TextEditingController _titleController = TextEditingController();
  late final quill.QuillController _quillController;
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final List<String> _attachments = [];
  final ImagePicker _picker = ImagePicker();
  
  bool _isSubmitting = false;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _quillController = quill.QuillController.basic();
    _titleController.addListener(() => setState(() {}));
    _quillController.addListener(() => setState(() {}));
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

    return DecoratedBox(
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
                    _sectionLabel(l10n.doubtsFormTitleLabel),
                    const SizedBox(height: 8),
                    AppTextField(
                      label: '',
                      hintText: l10n.doubtsFormTitleHint,
                      controller: _titleController,
                      autofocus: true,
                      textStyle: design.typography.bodySmall,
                      contentPadding: EdgeInsets.all(design.spacing.md),
                    ),
                    const SizedBox(height: 24),
                    _sectionLabel(l10n.doubtsFormDescriptionLabel),
                    const SizedBox(height: 8),
                    ForumEditorToolbar(
                      controller: _quillController,
                      onImagePick: _pickImages,
                      isImageLimitReached: _attachments.length >= 5,
                    ),
                    const SizedBox(height: 4),
                    ForumEditorField(
                      controller: _quillController,
                      scrollController: _scrollController,
                      focusNode: _focusNode,
                      placeholder: l10n.doubtsFormDescriptionLabel,
                      minHeight: 180,
                      maxHeight: 180,
                    ),
                    const SizedBox(height: 24),
                    _sectionLabel(l10n.doubtsFormCategoryLabel),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ref.watch(doubtCategoriesProvider).map((c) => _categoryChip(c)).toList(),
                    ),
                    const SizedBox(height: 32),
                    _sectionLabel(l10n.doubtsFormAttachmentsLabel),
                    const SizedBox(height: 8),
                    _uploadButton(l10n.doubtsFormUploadAction),
                    if (_attachments.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      ForumAttachmentPreview(
                        imageUrls: _attachments,
                        onRemove: (i) => setState(() => _attachments.removeAt(i)),
                      ),
                    ],
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            _actionBar(design, l10n),
          ],
        ),
      ),
    );
  }

  // --- UI Components ---

  Widget _sectionLabel(String label) => AppText.labelBold(label);

  Widget _categoryChip(String label) {
    final design = Design.of(context);
    final isSelected = _selectedCategory == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = isSelected ? null : label),
      child: AnimatedContainer(
        duration: design.motion.fast,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? design.colors.accent2 : design.colors.card,
          borderRadius: design.radius.pill,
          border: Border.all(color: isSelected ? design.colors.accent2 : design.colors.border),
        ),
        child: AppText.labelSmall(label, color: isSelected ? design.colors.textInverse : null),
      ),
    );
  }

  Widget _uploadButton(String label) {
    final design = Design.of(context);
    return AppFocusable(
      onTap: _pickImages,
      borderRadius: BorderRadius.circular(design.radius.lg),
      child: Container(
        padding: EdgeInsets.all(design.spacing.md),
        decoration: BoxDecoration(
          color: design.colors.surfaceVariant,
          borderRadius: BorderRadius.circular(design.radius.lg),
          border: Border.all(color: design.colors.divider),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.upload, size: 20, color: design.colors.textSecondary),
            const SizedBox(width: 8),
            AppText.bodySmall(label),
          ],
        ),
      ),
    );
  }

  Widget _actionBar(DesignConfig design, AppLocalizations l10n) {
    final canSubmit = _titleController.text.trim().isNotEmpty && 
                      _quillController.document.toPlainText().trim().isNotEmpty && 
                      _selectedCategory != null;
    final isEnabled = canSubmit && !_isSubmitting;

    return Container(
      padding: EdgeInsets.fromLTRB(design.spacing.md, 8, design.spacing.md, design.spacing.md),
      decoration: BoxDecoration(color: design.colors.card, border: Border(top: BorderSide(color: design.colors.divider))),
      child: Row(
        children: [
          Expanded(child: AppButton.secondary(
            label: l10n.forumButtonCancel, fullWidth: true, onPressed: () => Navigator.pop(context),
            backgroundColor: design.colors.surfaceVariant, foregroundColor: design.colors.textPrimary,
            borderColor: const Color(0x00000000), height: 52)),
          const SizedBox(width: 16),
          Expanded(child: AppButton.primary(
            label: l10n.doubtsFormSubmitAction, fullWidth: true, onPressed: isEnabled ? _handleSubmit : null,
            loading: _isSubmitting, height: 52,
            backgroundColor: isEnabled ? design.colors.accent2 : design.colors.accent2.withValues(alpha: 0.5),
            foregroundColor: isEnabled ? design.colors.textInverse : design.colors.textInverse.withValues(alpha: 0.9))),
        ],
      ),
    );
  }

  // --- Logic ---

  Future<void> _pickImages() async {
    if (_attachments.length >= 5) return;
    final images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _attachments.addAll(images.take(5 - _attachments.length).map((i) => i.path));
      });
    }
  }

  Future<void> _handleSubmit() async {
    setState(() => _isSubmitting = true);
    // TODO: Implement actual submission logic later
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) Navigator.pop(context);
  }
}
