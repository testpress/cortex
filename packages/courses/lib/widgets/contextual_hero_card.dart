import 'package:flutter/material.dart';
import 'package:core/core.dart';

enum HeroActionType {
  joinClass,
  watchRecording,
  takeTest,
  continueStudy,
  prepareTest,
  exploreCourses,
  startTrial,
  upgradePrompt,
}

class HeroAction {
  final HeroActionType type;
  final String title;
  final String subject;
  final String metadata;
  final String? timeInfo;
  final double? progress; // 0.0 to 1.0
  final String? countdown;
  final String? testDuration;
  final bool isLocked;

  const HeroAction({
    required this.type,
    required this.title,
    required this.subject,
    required this.metadata,
    this.timeInfo,
    this.progress,
    this.countdown,
    this.testDuration,
    this.isLocked = false,
  });
}

/// A prominent "Next Step" card for the home dashboard.
class ContextualHeroCard extends StatefulWidget {
  const ContextualHeroCard({
    super.key,
    required this.action,
    this.onActionClick,
  });

  final HeroAction action;
  final VoidCallback? onActionClick;

  @override
  State<ContextualHeroCard> createState() => _ContextualHeroCardState();
}

class _ContextualHeroCardState extends State<ContextualHeroCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final isDark = design.isDark;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildIconContainer(context),
              const SizedBox(width: 8),
              AppText(
                _getStatusLabel().toUpperCase(),
                color: design.colors.textSecondary,
                style: const TextStyle(
                  fontSize: 12,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (widget.action.isLocked) ...[
                const Spacer(),
                Icon(
                  Icons.lock_outline_rounded,
                  size: 16,
                  color: design.colors.textTertiary,
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          AppText(
            widget.action.title,
            color: design.colors.textPrimary,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 4),
          AppText(
            widget.action.subject,
            color: design.colors.textSecondary,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          _buildMetadataRow(context),
          if (widget.action.progress != null) ...[
            const SizedBox(height: 16),
            _buildProgressSection(context),
          ],
          const SizedBox(height: 16),
          _buildActionButton(context),
        ],
      ),
    );
  }

  Widget _buildIconContainer(BuildContext context) {
    final design = Design.of(context);
    final isJoinClass = widget.action.type == HeroActionType.joinClass;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: design.colors.surfaceVariant,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                offset: const Offset(0, 1),
                blurRadius: 2,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Icon(
            _getIconData(),
            size: 20,
            color: design.colors.textSecondary,
          ),
        ),
        if (isJoinClass)
          Positioned(
            top: 0,
            right: 0,
            child: ScaleTransition(
              scale: Tween<double>(
                begin: 0.8,
                end: 1.2,
              ).animate(_pulseController),
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFFDC2626), // red-600
                  shape: BoxShape.circle,
                  border: Border.all(color: design.colors.card, width: 2.0),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMetadataRow(BuildContext context) {
    final design = Design.of(context);
    final metaColor = design.colors.textSecondary;

    final List<Widget> items = [];

    items.add(
      AppText(
        widget.action.metadata,
        color: metaColor,
        style: const TextStyle(fontSize: 14),
      ),
    );

    if (widget.action.timeInfo != null) {
      items.add(_buildDot(context));
      items.add(
        AppText(
          widget.action.timeInfo!,
          color: metaColor,
          style: const TextStyle(fontSize: 14),
        ),
      );
    }

    if (widget.action.countdown != null) {
      items.add(_buildDot(context));
      items.add(
        AppText(
          widget.action.countdown!,
          color: design.colors.textPrimary,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
      );
    }

    if (widget.action.testDuration != null) {
      items.add(_buildDot(context));
      items.add(
        AppText(
          widget.action.testDuration!,
          color: metaColor,
          style: const TextStyle(fontSize: 14),
        ),
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: items,
    );
  }

  Widget _buildDot(BuildContext context) {
    final design = Design.of(context);
    return Container(
      width: 3,
      height: 3,
      decoration: BoxDecoration(
        color: design.colors.textTertiary,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    final design = Design.of(context);
    // Assuming progress is 0.0 to 100.0 based on widget.action.progress
    final progressVal = widget.action.progress! / 100.0;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.caption('Progress', color: design.colors.textSecondary),
            AppText.caption(
              '${widget.action.progress!.toInt()}% Complete',
              color: design.colors.textSecondary,
            ),
          ],
        ),
        const SizedBox(height: 6),
        // Simplified progress bar if AppProgress doesn't exist or doesn't match
        Container(
          height: 6,
          width: double.infinity,
          decoration: BoxDecoration(
            color: design.colors.surfaceVariant,
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progressVal.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: _getAccentColor(),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    final design = Design.of(context);
    return AppButton(
      label: _getButtonText(),
      fullWidth: true,
      onPressed: widget.onActionClick,
      backgroundColor: _getAccentColor(),
      foregroundColor: design.colors.onPrimary,
      height: 44.0,
      padding: const EdgeInsets.symmetric(vertical: 8),
    );
  }

  Color _getAccentColor() {
    return switch (widget.action.type) {
      HeroActionType.joinClass => const Color(0xFF16A34A), // Tailwind green-600
      HeroActionType.watchRecording => const Color(0xFF4F46E5),
      HeroActionType.takeTest => const Color(0xFF059669),
      HeroActionType.continueStudy => const Color(0xFF2563EB),
      HeroActionType.prepareTest => const Color(0xFF7C3AED),
      HeroActionType.exploreCourses => const Color(0xFFD97706),
      HeroActionType.startTrial => const Color(0xFFDB2777),
      HeroActionType.upgradePrompt => const Color(0xFF9333EA),
    };
  }

  IconData _getIconData() {
    return switch (widget.action.type) {
      HeroActionType.joinClass => LucideIcons.video,
      HeroActionType.watchRecording => LucideIcons.play,
      HeroActionType.takeTest => LucideIcons.fileText,
      HeroActionType.prepareTest => LucideIcons.clock,
      HeroActionType.continueStudy => LucideIcons.bookOpen,
      HeroActionType.exploreCourses ||
      HeroActionType.startTrial => LucideIcons.sparkles,
      HeroActionType.upgradePrompt => LucideIcons.lock,
    };
  }

  String _getStatusLabel() {
    return switch (widget.action.type) {
      HeroActionType.joinClass => 'LIVE NOW',
      HeroActionType.takeTest => 'AVAILABLE NOW',
      HeroActionType.prepareTest => 'UPCOMING',
      HeroActionType.exploreCourses ||
      HeroActionType.startTrial => 'FREE ACCESS',
      HeroActionType.upgradePrompt => 'PREMIUM',
      _ => 'RECOMMENDED',
    };
  }

  String _getButtonText() {
    return switch (widget.action.type) {
      HeroActionType.joinClass => 'Join Now',
      HeroActionType.watchRecording => 'Watch Recording',
      HeroActionType.takeTest => 'Start Test',
      HeroActionType.prepareTest => 'Prepare for Test',
      HeroActionType.continueStudy => 'Continue Learning',
      HeroActionType.exploreCourses => 'Explore Courses',
      HeroActionType.startTrial => 'Start Free Trial',
      HeroActionType.upgradePrompt => 'Upgrade Now',
    };
  }
}
