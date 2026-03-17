import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import '../models/ai_models.dart';

class AIActivityItem extends StatefulWidget {
  final AIActivity activity;
  final VoidCallback? onTap;

  const AIActivityItem({super.key, required this.activity, this.onTap});

  @override
  State<AIActivityItem> createState() => _AIActivityItemState();
}

class _AIActivityItemState extends State<AIActivityItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    if (widget.activity.status == AIActivityStatus.processing) {
      _rotationController.repeat();
    }
  }

  @override
  void didUpdateWidget(AIActivityItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.activity.status == AIActivityStatus.processing) {
      if (!_rotationController.isAnimating) {
        _rotationController.repeat();
      }
    } else {
      _rotationController.stop();
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  IconData _getIcon() {
    switch (widget.activity.type) {
      case AIActivityType.doubt:
        return LucideIcons.helpCircle;
      case AIActivityType.exam:
        return LucideIcons.fileText;
      case AIActivityType.concept:
        return LucideIcons.lightbulb;
    }
  }

  Color _getIconColor(DesignConfig design) {
    switch (widget.activity.type) {
      case AIActivityType.doubt:
        return design.colors.accent2; // Blue
      case AIActivityType.exam:
        return design.colors.accent1; // Purple
      case AIActivityType.concept:
        return design.subjectPalette.atIndex(6).accent; // Amber
    }
  }

  Color _getIconBgColor(DesignConfig design) {
    switch (widget.activity.type) {
      case AIActivityType.doubt:
        return design.colors.accent2.withValues(alpha: 0.1);
      case AIActivityType.exam:
        return design.colors.accent1.withValues(alpha: 0.1);
      case AIActivityType.concept:
        return design.subjectPalette.atIndex(6).background; // Amber bg
    }
  }

  Widget _buildStatusBadge(DesignConfig design, AppLocalizations l10n) {
    if (widget.activity.status == null) return const SizedBox.shrink();

    String text = '';
    StatusColors statusStyle;
    IconData iconData = LucideIcons.checkCircle;

    switch (widget.activity.status!) {
      case AIActivityStatus.answered:
        text = l10n.aiAssistantStatusAnswered;
        statusStyle = design.statusColors.completed;
        iconData = LucideIcons.checkCircle;
        break;
      case AIActivityStatus.processing:
        text = l10n.aiAssistantStatusProcessing;
        statusStyle = design.statusColors.upcoming;
        iconData = LucideIcons.loader2;
        break;
      case AIActivityStatus.revisit:
        text = l10n.aiAssistantStatusRevisit;
        statusStyle = design.statusColors.live;
        iconData = LucideIcons.star;
        break;
    }

    Color bgColor;
    Color textColor;

    if (widget.activity.type == AIActivityType.concept &&
        widget.activity.status == AIActivityStatus.revisit) {
      final amber = design.subjectPalette.atIndex(6);
      bgColor = amber.background;
      textColor = amber.accent;
    } else {
      bgColor = statusStyle.background;
      textColor = statusStyle.foreground;
    }

    Widget icon = Icon(iconData, size: 10, color: textColor);

    if (widget.activity.status == AIActivityStatus.processing) {
      icon = RotationTransition(turns: _rotationController, child: icon);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: textColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 4),
          AppText.labelSmall(
            text,
            color: textColor,
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return AppCard(
      onTap: widget.onTap,
      padding: EdgeInsets.all(design.spacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getIconBgColor(design),
              borderRadius: BorderRadius.circular(design.radius.md),
            ),
            child: Center(
              child: Icon(_getIcon(), color: _getIconColor(design), size: 20),
            ),
          ),
          SizedBox(width: design.spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: AppText.cardTitle(
                        widget.activity.title,
                        color: design.colors.textPrimary,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildStatusBadge(design, l10n),
                  ],
                ),
                SizedBox(height: design.spacing.xs),
                AppText.caption(
                  widget.activity.description,
                  color: design.colors.textSecondary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: design.spacing.sm),
                Row(
                  children: [
                    Icon(
                      LucideIcons.clock,
                      size: 14,
                      color: design.colors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    AppText.caption(
                      widget.activity.timeAgo,
                      color: design.colors.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
