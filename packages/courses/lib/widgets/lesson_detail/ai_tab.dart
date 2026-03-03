import 'package:flutter/material.dart';
import 'package:core/core.dart';
import '../../models/course_content.dart';
import 'continue_button.dart';

class AITab extends StatefulWidget {
  final Lesson lesson;
  final VoidCallback onNext;

  const AITab({super.key, required this.lesson, required this.onNext});

  @override
  State<AITab> createState() => _AITabState();
}

class _AITabState extends State<AITab> with AutomaticKeepAliveClientMixin {
  final _controller = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final design = Design.of(context);
    final l10n = L10n.of(context);
    return ListView(
      padding: EdgeInsets.all(design.spacing.md),
      children: [
        Container(
          padding: EdgeInsets.all(design.spacing.md),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                design.colors.accent2.withValues(alpha: 0.15),
                design.colors.accent2.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(design.radius.md),
            border: Border.all(
              color: design.colors.accent2.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Icon(
                LucideIcons.sparkles,
                color: design.colors.accent2,
                size: 24,
              ),
              SizedBox(width: design.spacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.subtitle(
                      l10n.videoLessonAiAssistant,
                      color: design.colors.textPrimary,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    AppText.caption(
                      l10n.videoLessonAiHelp,
                      color: design.colors.textSecondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: design.spacing.md),
        _buildChatBubble(
          'Hello! I\'m your AI study assistant. I can help you understand the First Law of Thermodynamics better. Feel free to ask me anything about this lecture!',
          true,
          design,
        ),
        _buildChatBubble(
          'Can you explain with a practical example?',
          false,
          design,
        ),
        _buildChatBubble(
          'Sure! Think of a pressure cooker: When you heat it, you add energy (Q) to the system. The steam inside does work (W) by pushing the pressure valve. The remaining energy increases the internal energy (U). This perfectly demonstrates ΔU = Q - W!',
          true,
          design,
        ),
        SizedBox(height: design.spacing.sm),
        Row(
          children: [
            Expanded(
              child: Material(
                type: MaterialType.transparency,
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: l10n.videoLessonAiHint,
                    hintStyle: TextStyle(
                      color: design.colors.textTertiary,
                      fontSize: 13,
                    ),
                    filled: true,
                    fillColor: design.colors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(design.radius.md),
                      borderSide: BorderSide(color: design.colors.divider),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(design.radius.md),
                      borderSide: BorderSide(color: design.colors.divider),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: design.spacing.md,
                      vertical: design.spacing.sm,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: design.spacing.sm),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _controller,
              builder: (context, value, _) {
                final isDirty = value.text.trim().isNotEmpty;
                return AppFocusable(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.all(design.spacing.sm),
                    decoration: BoxDecoration(
                      color: isDirty
                          ? design.colors.accent2
                          : design.colors.accent2.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(design.radius.sm),
                    ),
                    child: Icon(
                      LucideIcons.send,
                      color: design.colors.textInverse,
                      size: 18,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        SizedBox(height: design.spacing.xs),
        AppText.caption(
          l10n.videoLessonAiDisclaimer,
          color: design.colors.textTertiary,
          style: const TextStyle(fontSize: 11, height: 1.4),
        ),
        ContinueButton(onTap: widget.onNext),
      ],
    );
  }

  Widget _buildChatBubble(String text, bool isAI, DesignConfig design) {
    return Padding(
      padding: EdgeInsets.only(bottom: design.spacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isAI
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          if (isAI)
            Container(
              width: 28,
              height: 28,
              margin: EdgeInsets.only(right: design.spacing.sm, top: 2),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [design.colors.accent2, design.colors.accent1],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(design.radius.sm),
              ),
              child: Center(
                child: Icon(
                  LucideIcons.sparkles,
                  size: 14,
                  color: design.colors.textInverse,
                ),
              ),
            ),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(design.spacing.sm),
              decoration: BoxDecoration(
                color: isAI ? design.colors.card : design.colors.accent2,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isAI ? 0 : design.radius.md),
                  topRight: Radius.circular(isAI ? design.radius.md : 0),
                  bottomLeft: Radius.circular(design.radius.md),
                  bottomRight: Radius.circular(design.radius.md),
                ),
                border: isAI ? Border.all(color: design.colors.divider) : null,
              ),
              child: AppText.body(
                text,
                color: isAI
                    ? design.colors.textPrimary
                    : design.colors.textInverse,
                style: const TextStyle(fontSize: 13, height: 1.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
