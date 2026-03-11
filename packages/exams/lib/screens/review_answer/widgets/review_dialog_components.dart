import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class BaseReviewDialog extends StatefulWidget {
  final String title;
  final Widget Function(TextEditingController) contentBuilder;
  final String submitLabel;
  final Color submitColor;
  final VoidCallback onCancel;
  final Function(String) onSubmit;
  final DesignConfig design;

  const BaseReviewDialog({
    super.key,
    required this.title,
    required this.contentBuilder,
    required this.submitLabel,
    required this.submitColor,
    required this.onCancel,
    required this.onSubmit,
    required this.design,
  });

  @override
  State<BaseReviewDialog> createState() => _BaseReviewDialogState();
}

class _BaseReviewDialogState extends State<BaseReviewDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: widget.design.spacing.md,
          vertical: widget.design.spacing.xl,
        ),
        decoration: BoxDecoration(
          color: widget.design.colors.card,
          borderRadius: BorderRadius.circular(16),
          border: widget.design.isDark
              ? Border.all(color: widget.design.colors.border)
              : null,
          boxShadow: [
            BoxShadow(
              color: widget.design.colors.shadow.withValues(
                alpha: widget.design.isDark ? 0.4 : 0.1,
              ),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 16,
                top: 24,
                bottom: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.headline(
                    widget.title,
                    color: widget.design.colors.textPrimary,
                  ),
                  GestureDetector(
                    onTap: widget.onCancel,
                    child: Icon(
                      LucideIcons.x,
                      color: widget.design.colors.textSecondary,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: widget.contentBuilder(_controller),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: L10n.of(context).labelCancel,
                      onPressed: widget.onCancel,
                      variant: AppButtonVariant.secondary,
                      borderColor: widget.design.colors.border,
                      foregroundColor: widget.design.colors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      label: widget.submitLabel,
                      onPressed: () => widget.onSubmit(_controller.text),
                      backgroundColor: widget.submitColor,
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
}

class ReportReviewDialog extends StatefulWidget {
  final int questionNumber;
  final DesignConfig design;
  final AppLocalizations l10n;
  final Function(int, String) onSubmit;

  const ReportReviewDialog({
    super.key,
    required this.questionNumber,
    required this.design,
    required this.l10n,
    required this.onSubmit,
  });

  @override
  State<ReportReviewDialog> createState() => _ReportReviewDialogState();
}

class _ReportReviewDialogState extends State<ReportReviewDialog> {
  int _selectedIndex = -1;
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final options = [
      widget.l10n.reviewReportOptionIncorrect,
      widget.l10n.reviewReportOptionUnclear,
      widget.l10n.reviewReportOptionWrongExplanation,
      widget.l10n.reviewReportOptionOther,
    ];

    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: widget.design.spacing.md,
          vertical: widget.design.spacing.xl,
        ),
        decoration: BoxDecoration(
          color: design.colors.card,
          borderRadius: BorderRadius.circular(16),
          border: design.isDark
              ? Border.all(color: design.colors.border)
              : null,
          boxShadow: [
            BoxShadow(
              color: design.colors.shadow.withValues(
                alpha: design.isDark ? 0.4 : 0.1,
              ),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 16,
                top: 24,
                bottom: 0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.headline(
                    widget.l10n.reviewReportIssueTitle,
                    color: design.colors.textPrimary,
                  ),
                  GestureDetector(
                    child: Icon(
                      LucideIcons.x,
                      color: design.colors.textSecondary,
                      size: 20,
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.body(
                      widget.l10n.reviewReportIssueWithQuestion(
                        widget.questionNumber,
                      ),
                      color: design.colors.textSecondary,
                    ),
                    const SizedBox(height: 20),
                    ...List.generate(options.length, (index) {
                      final isSelected = _selectedIndex == index;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedIndex = index),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? design.colors.accent5.withValues(
                                      alpha: design.isDark ? 0.2 : 0.08,
                                    )
                                  : design.colors.card,
                              border: Border.all(
                                color: isSelected
                                    ? design.colors.accent5
                                    : design.colors.border,
                                width: isSelected ? 1.5 : 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? design.colors.accent5
                                          : design.colors.textTertiary,
                                      width: 2,
                                    ),
                                    color: isSelected
                                        ? design.colors.accent5
                                        : design.colors.card,
                                  ),
                                  child: isSelected
                                      ? Center(
                                          child: Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: design.colors.onPrimary,
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: AppText.base(
                                    options[index],
                                    color: isSelected
                                        ? design.colors.textPrimary
                                        : design.colors.textSecondary,
                                    style: TextStyle(
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 8),
                    ReviewTextField(
                      hint: widget.l10n.reviewReportDetailsHint,
                      design: widget.design,
                      maxLines: 3,
                      controller: _controller,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: L10n.of(context).labelCancel,
                      onPressed: () => Navigator.pop(context),
                      variant: AppButtonVariant.secondary,
                      borderColor: design.colors.border,
                      foregroundColor: design.colors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      label: widget.l10n.reviewSubmitReport,
                      onPressed: () {
                        widget.onSubmit(_selectedIndex, _controller.text);
                      },
                      backgroundColor: design.colors.accent5,
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
}

class ReviewTextField extends StatefulWidget {
  final String hint;
  final DesignConfig design;
  final int maxLines;
  final TextEditingController? controller;

  const ReviewTextField({
    super.key,
    required this.hint,
    required this.design,
    this.maxLines = 4,
    this.controller,
  });

  @override
  State<ReviewTextField> createState() => _ReviewTextFieldState();
}

class _ReviewTextFieldState extends State<ReviewTextField> {
  late final TextEditingController _controller;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: widget.design.colors.card,
        border: Border.all(color: widget.design.colors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          if (_controller.text.isEmpty)
            AppText.body(widget.hint, color: widget.design.colors.textTertiary),
          EditableText(
            controller: _controller,
            focusNode: _focusNode,
            style: TextStyle(
              fontSize: 14,
              color: widget.design.colors.textPrimary,
              fontWeight: FontWeight.normal,
            ),
            cursorColor: widget.design.colors.primary,
            backgroundCursorColor: widget.design.colors.surfaceVariant,
            maxLines: widget.maxLines,
            minLines: widget.maxLines,
            selectionColor: widget.design.colors.primary.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}
