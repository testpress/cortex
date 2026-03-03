import 'package:flutter/material.dart';
import 'package:core/core.dart';
import '../../models/course_content.dart';
import 'continue_button.dart';

class DoubtTab extends StatefulWidget {
  final Lesson lesson;
  final VoidCallback onNext;

  const DoubtTab({super.key, required this.lesson, required this.onNext});

  @override
  State<DoubtTab> createState() => _DoubtTabState();
}

class _DoubtTabState extends State<DoubtTab>
    with AutomaticKeepAliveClientMixin {
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
        Row(
          children: [
            Icon(
              LucideIcons.messageCircle,
              color: design.colors.accent2,
              size: 20,
            ),
            SizedBox(width: design.spacing.sm),
            AppText.subtitle(
              l10n.videoLessonAskYourDoubt,
              color: design.colors.textPrimary,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        SizedBox(height: design.spacing.sm),
        AppText.body(
          l10n.videoLessonDoubtDescription,
          color: design.colors.textSecondary,
          style: const TextStyle(fontSize: 13, height: 1.5),
        ),
        SizedBox(height: design.spacing.lg),
        AppText.label(
          l10n.videoLessonRecentDoubts,
          color: design.colors.textPrimary,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        SizedBox(height: design.spacing.sm),
        _buildDoubtCard(
          'AK',
          design.colors.accent1,
          'Aarav Kumar',
          '2h ago',
          'Can you explain the difference between heat and internal energy?',
          true,
          false,
          design,
        ),
        _buildDoubtCard(
          'PS',
          design.colors.accent4,
          'Priya Sharma',
          '5h ago',
          'How is the first law applied in adiabatic processes?',
          false,
          true,
          design,
        ),
        SizedBox(height: design.spacing.md),
        AppText.label(
          l10n.videoLessonPostYourDoubt,
          color: design.colors.textPrimary,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        SizedBox(height: design.spacing.sm),
        Material(
          type: MaterialType.transparency,
          child: TextField(
            controller: _controller,
            maxLines: 4,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: l10n.videoLessonDoubtHint,
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
            ),
          ),
        ),
        SizedBox(height: design.spacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _controller,
              builder: (context, value, _) {
                return AppText.caption(
                  l10n.videoLessonCharacterCount(value.text.length, 500),
                  color: design.colors.textTertiary,
                );
              },
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _controller,
              builder: (context, value, _) {
                final isDirty = value.text.trim().isNotEmpty;
                return AppButton.primary(
                  label: l10n.videoLessonSubmitDoubt,
                  leading: Icon(
                    LucideIcons.send,
                    color: design.colors.onPrimary,
                    size: 14,
                  ),
                  height: 36,
                  backgroundColor: isDirty
                      ? design.colors.accent2
                      : design.colors.accent2.withValues(alpha: 0.4),
                  onPressed: () {},
                  padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
                );
              },
            ),
          ],
        ),
        ContinueButton(onTap: widget.onNext),
      ],
    );
  }

  Widget _buildDoubtCard(
    String initials,
    Color avatarColor,
    String name,
    String timeAgo,
    String doubt,
    bool hasReply,
    bool isPending,
    DesignConfig design,
  ) {
    final l10n = L10n.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: design.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: avatarColor.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: AppText.caption(
                    initials,
                    color: design.colors.textInverse,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              SizedBox(width: design.spacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AppText.label(
                          name,
                          color: design.colors.textPrimary,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: design.spacing.xs),
                        AppText.caption(
                          timeAgo,
                          color: design.colors.textTertiary,
                        ),
                        if (isPending) ...[
                          SizedBox(width: design.spacing.sm),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: design.spacing.sm,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: design.colors.warning.withValues(
                                alpha: 0.15,
                              ),
                              borderRadius: BorderRadius.circular(
                                design.radius.sm,
                              ),
                            ),
                            child: AppText.caption(
                              l10n.videoLessonPending,
                              color: design.colors.warning,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    AppText.body(
                      doubt,
                      color: design.colors.textSecondary,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (hasReply) ...[
            SizedBox(height: design.spacing.sm),
            Container(
              margin: const EdgeInsets.only(left: 44),
              padding: EdgeInsets.all(design.spacing.md),
              decoration: BoxDecoration(
                color: design.colors.accent2.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(design.radius.md),
                border: Border.all(
                  color: design.colors.accent2.withValues(alpha: 0.15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        LucideIcons.user,
                        color: design.colors.accent2,
                        size: 16,
                      ),
                      SizedBox(width: design.spacing.xs),
                      AppText.caption(
                        'Dr. Rajesh Kumar',
                        color: design.colors.accent2,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  SizedBox(height: design.spacing.xs),
                  AppText.body(
                    'Great question! Heat (Q) is energy transfer due to temperature difference, while internal energy (U) is the total energy contained within the system. Heat is the process, internal energy is the state.',
                    color: design.isDark
                        ? design.colors.textPrimary
                        : design.colors.accent2,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: design.spacing.md),
          if (hasReply)
            Divider(
              color: design.colors.divider.withValues(alpha: 0.8),
              thickness: 1,
              height: 1,
            ),
        ],
      ),
    );
  }
}
