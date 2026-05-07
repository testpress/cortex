import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';
import 'package:core/core.dart';

// ─────────────────────────────────────────────────────
// Service Layer
// ─────────────────────────────────────────────────────

/// Converts a Quill Delta document to HTML for API submission.
class QuillEditorService {
  const QuillEditorService();

  String toHtml(quill.Document document) {
    final delta = document.toDelta();
    final converter = QuillDeltaToHtmlConverter(delta.toJson());
    return converter.convert();
  }
}

// ─────────────────────────────────────────────────────
// Shared Composer Components
// ─────────────────────────────────────────────────────

class ForumEditorToolbar extends StatelessWidget {
  final quill.QuillController controller;
  final VoidCallback onImagePick;
  final bool isImageLimitReached;

  const ForumEditorToolbar({
    super.key,
    required this.controller,
    required this.onImagePick,
    required this.isImageLimitReached,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: design.spacing.xs),
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) => _ToolbarButtons(
          controller: controller,
          onImagePick: onImagePick,
          isImageLimitReached: isImageLimitReached,
        ),
      ),
    );
  }
}

class ForumEditorField extends StatelessWidget {
  final quill.QuillController controller;
  final ScrollController scrollController;
  final FocusNode focusNode;
  final String placeholder;
  final bool showPlaceholder;
  final double minHeight;
  final double maxHeight;
  final bool expands;
  final Color? backgroundColor;

  const ForumEditorField({
    super.key,
    required this.controller,
    required this.scrollController,
    required this.focusNode,
    required this.placeholder,
    this.showPlaceholder = true,
    this.minHeight = 36,
    this.maxHeight = 120,
    this.expands = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return GestureDetector(
      onTap: () {
        if (!focusNode.hasFocus) {
          focusNode.requestFocus();
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? design.colors.card,
          borderRadius: BorderRadius.circular(design.radius.lg),
          border: Border.all(color: design.colors.border),
        ),
        clipBehavior: Clip.hardEdge,
        padding: EdgeInsets.symmetric(
          horizontal: design.spacing.md,
          vertical: design.spacing.sm,
        ),
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) => ClipRect(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: minHeight, maxHeight: maxHeight),
              child: RawScrollbar(
                controller: scrollController,
                thumbColor: design.colors.textTertiary.withValues(alpha: 0.3),
                radius: const Radius.circular(2),
                thickness: 3,
                thumbVisibility: true,
                padding: EdgeInsets.zero,
                child: quill.QuillEditor.basic(
                  controller: controller,
                  focusNode: focusNode,
                  scrollController: scrollController,
                  config: quill.QuillEditorConfig(
                    autoFocus: false,
                    expands: expands,
                    padding: const EdgeInsets.only(right: 6),
                    placeholder: showPlaceholder ? placeholder : '',
                    customStyles: _buildEditorStyles(design),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  quill.DefaultStyles _buildEditorStyles(DesignConfig design) {
    final baseStyle = design.typography.bodySmall;

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

class ForumAttachmentPreview extends StatelessWidget {
  final List<String> imageUrls;
  final Function(int) onRemove;

  const ForumAttachmentPreview({
    super.key,
    required this.imageUrls,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      padding: EdgeInsets.only(
        bottom: design.spacing.sm,
      ),
      child: Row(
        children: [
          for (int i = 0; i < imageUrls.length; i++) ...[
            Padding(
              padding: const EdgeInsets.only(top: 12, right: 12),
              child: _AttachmentItem(
                imageUrl: imageUrls[i],
                onRemove: () => onRemove(i),
              ),
            ),
            if (i < imageUrls.length - 1) SizedBox(width: design.spacing.xs),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Private Helper Widgets
// ─────────────────────────────────────────────────────

class _ToolbarButtons extends StatelessWidget {
  final quill.QuillController controller;
  final VoidCallback onImagePick;
  final bool isImageLimitReached;

  const _ToolbarButtons({
    required this.controller,
    required this.onImagePick,
    required this.isImageLimitReached,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final style = controller.getSelectionStyle();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: design.spacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ForumToolbarButton(
            icon: LucideIcons.bold,
            isActive: _isAttributeActive(style, quill.Attribute.bold),
            onTap: () => _toggleAttribute(quill.Attribute.bold),
          ),
          ForumToolbarButton(
            icon: LucideIcons.italic,
            isActive: _isAttributeActive(style, quill.Attribute.italic),
            onTap: () => _toggleAttribute(quill.Attribute.italic),
          ),
          const ForumToolbarDivider(),
          ForumToolbarButton(
            icon: LucideIcons.code,
            isActive: _isAttributeActive(style, quill.Attribute.codeBlock),
            onTap: () => _toggleAttribute(quill.Attribute.codeBlock),
          ),
          const ForumToolbarDivider(),
          ForumToolbarButton(
            icon: LucideIcons.list,
            isActive: _isListActive(style, quill.Attribute.ul),
            onTap: () => _toggleAttribute(quill.Attribute.ul),
          ),
          ForumToolbarButton(
            icon: LucideIcons.listOrdered,
            isActive: _isListActive(style, quill.Attribute.ol),
            onTap: () => _toggleAttribute(quill.Attribute.ol),
          ),
          const ForumToolbarDivider(),
          ForumToolbarButton(
            icon: LucideIcons.image,
            onTap: isImageLimitReached ? () {} : onImagePick,
            isDisabled: isImageLimitReached,
          ),
        ],
      ),
    );
  }

  bool _isAttributeActive(quill.Style style, quill.Attribute attribute) {
    final value = style.attributes[attribute.key];
    if (value == null || value.value == null) return false;
    if (attribute.value != null) return value.value == attribute.value;
    return true;
  }

  bool _isListActive(quill.Style style, quill.Attribute attribute) {
    final current = style.attributes[quill.Attribute.list.key];
    return current?.value == attribute.value;
  }

  void _toggleAttribute(quill.Attribute attribute) {
    final style = controller.getSelectionStyle();
    final isApplied = _isAttributeActive(style, attribute) ||
        _isListActive(style, attribute);
    controller.formatSelection(
      isApplied ? quill.Attribute.clone(attribute, null) : attribute,
    );
  }
}

class ForumToolbarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;
  final bool isDisabled;

  const ForumToolbarButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.isActive = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      behavior: HitTestBehavior.opaque,
      child: Opacity(
        opacity: isDisabled ? 0.4 : 1.0,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: design.spacing.xs),
          padding: EdgeInsets.all(design.spacing.sm),
          decoration: BoxDecoration(
            color: isActive ? design.colors.accent2.withValues(alpha: 0.12) : null,
            borderRadius: BorderRadius.circular(design.radius.sm),
          ),
          child: Icon(
            icon,
            size: 18,
            color: isActive ? design.colors.accent2 : design.colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class ForumToolbarDivider extends StatelessWidget {
  const ForumToolbarDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return SizedBox(
      height: 18,
      width: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(color: design.colors.divider),
      ),
    );
  }
}

class ForumToolbarToggle extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;

  const ForumToolbarToggle({super.key, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(design.spacing.xs),
        decoration: BoxDecoration(
          color: isActive
              ? design.colors.accent2.withValues(alpha: 0.1)
              : design.colors.transparent,
          borderRadius: BorderRadius.circular(design.radius.sm),
        ),
        child: Icon(
          LucideIcons.type,
          size: 18,
          color: isActive ? design.colors.accent2 : design.colors.textSecondary,
        ),
      ),
    );
  }
}

class ForumSendButton extends StatelessWidget {
  final VoidCallback onTap;

  const ForumSendButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return AppFocusable(
      onTap: onTap,
      borderRadius: BorderRadius.circular(design.radius.full),
      child: Container(
        padding: EdgeInsets.all(design.spacing.sm),
        decoration: BoxDecoration(
          color: design.colors.accent2,
          shape: BoxShape.circle,
        ),
        child: Icon(
          LucideIcons.send,
          color: design.colors.textInverse,
          size: 18,
        ),
      ),
    );
  }
}

class _AttachmentItem extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onRemove;

  const _AttachmentItem({
    required this.imageUrl,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    const size = 64.0;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(design.radius.md),
            border: Border.all(color: design.colors.divider),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.file(
            File(imageUrl),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Center(
              child: Icon(
                LucideIcons.imageOff,
                size: 20,
                color: design.colors.textSecondary,
              ),
            ),
          ),
        ),
        Positioned(
          top: -10,
          right: -10,
          child: GestureDetector(
            onTap: onRemove,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: design.colors.textPrimary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.x,
                  size: 14,
                  color: design.colors.card,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
