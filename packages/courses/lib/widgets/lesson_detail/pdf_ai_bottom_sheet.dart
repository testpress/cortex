import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'ai_tab.dart';

/// Modal bottom sheet hosting the AI study companion for PDF lessons.
class PdfAiBottomSheet extends StatelessWidget {
  final LessonDto lesson;
  final VoidCallback onClose;

  const PdfAiBottomSheet({
    super.key,
    required this.lesson,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final screenHeight = MediaQuery.sizeOf(context).height;
    final sheetHeight = (screenHeight * 0.75).clamp(380.0, 1000.0);

    return Container(
      height: sheetHeight,
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(design.radius.xxl),
        ),
        boxShadow: design.shadows.floating,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(design.radius.xxl),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top drag handle
              Padding(
                padding: EdgeInsets.only(top: design.spacing.md),
                child: Align(
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
              ),

              // Header with title and close button
              Padding(
                padding: EdgeInsets.fromLTRB(
                  design.spacing.lg,
                  design.spacing.sm,
                  design.spacing.sm,
                  design.spacing.sm,
                ),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.sparkles,
                      color: design.colors.primary,
                      size: 20,
                    ),
                    SizedBox(width: design.spacing.sm),
                    Expanded(
                      child: AppSemantics.header(
                        label: l10n.pdfAiStudyAssistant,
                        child: AppText.title(
                          l10n.aiSupportTitle,
                          color: design.colors.textPrimary,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    AppSemantics.button(
                      label: l10n.commonCloseButton,
                      onTap: onClose,
                      child: AppFocusable(
                        onTap: onClose,
                        borderRadius: BorderRadius.circular(design.radius.full),
                        child: Container(
                          width: 48,
                          height: 48,
                          alignment: Alignment.center,
                          child: Icon(
                            LucideIcons.x,
                            color: design.colors.textSecondary,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Divider
              Container(
                height: 1,
                color: design.colors.divider.withValues(alpha: 0.5),
              ),

              // Embedded AI Chat
              Expanded(
                child: AITab(
                  lesson: lesson,
                  onSeek: null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
