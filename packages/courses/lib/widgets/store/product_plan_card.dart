import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'store_formatters.dart';

/// Card representing a subscription plan tier with radio selection.
class ProductPlanCard extends StatelessWidget {
  final SubscriptionPlanDto plan;
  final PlanDetailDto? activePlanDetail;
  final int? selectedDurationInDays;
  final int totalBenefitsCount;
  final bool isSelected;
  final VoidCallback onSelect;

  const ProductPlanCard({
    super.key,
    required this.plan,
    required this.activePlanDetail,
    this.selectedDurationInDays,
    required this.totalBenefitsCount,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    final isAvailable = activePlanDetail != null;

    final durationText = isAvailable
        ? formatPlanDuration(l10n, activePlanDetail!.durationInDays)
        : '';

    final selectedDurationText = selectedDurationInDays != null
        ? formatPlanDuration(l10n, selectedDurationInDays!)
        : '';

    final availableDurations =
        plan.planDetails.map((d) => d.durationInDays).toSet().toList()..sort();
    final availableDurationsText =
        availableDurations.map((d) => formatPlanDuration(l10n, d)).join(', ');

    final priceStr = isAvailable ? activePlanDetail!.price : '';
    final strikeStr = activePlanDetail?.strikeThroughPrice;

    final semanticLabel = !isAvailable
        ? '${plan.name}: ${l10n.storePlanNotAvailableForDuration(selectedDurationText)}'
        : (isSelected
            ? l10n.storePlanSelected(plan.name, priceStr)
            : l10n.storePlanUnselected(plan.name, priceStr));

    return AppSemantics.button(
      label: semanticLabel,
      onTap: isAvailable ? onSelect : null,
      enabled: isAvailable,
      child: AppFocusable(
        onTap: isAvailable ? onSelect : null,
        borderRadius: BorderRadius.circular(design.radius.lg),
        child: Container(
          margin: EdgeInsets.only(bottom: design.spacing.sm),
          padding: EdgeInsets.all(design.spacing.md),
          decoration: BoxDecoration(
            color: design.colors.card,
            borderRadius: BorderRadius.circular(design.radius.lg),
            border: Border.all(
              color: (isAvailable && isSelected)
                  ? design.colors.accent2
                  : design.colors.border,
              width: (isAvailable && isSelected) ? 1.5 : 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppText.body(
                      plan.name,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(width: design.spacing.xs),
                  _buildRadioIndicator(design, isAvailable),
                ],
              ),
              if (plan.description.isNotEmpty) ...[
                SizedBox(height: design.spacing.xs),
                AppText.bodySmall(
                  plan.description,
                  color: design.colors.textSecondary,
                  style: const TextStyle(height: 1.35),
                ),
              ],
              SizedBox(height: design.spacing.sm),
              if (isAvailable) ...[
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      if (priceStr.isNotEmpty)
                        AppText.body(
                          '₹$priceStr',
                          color: design.colors.textPrimary,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      if (durationText.isNotEmpty) ...[
                        SizedBox(width: design.spacing.xs),
                        AppText.caption(
                          '/ $durationText',
                          color: design.colors.textSecondary,
                        ),
                      ],
                      if (strikeStr != null && strikeStr.isNotEmpty) ...[
                        SizedBox(width: design.spacing.sm),
                        AppText.caption(
                          '₹$strikeStr',
                          color: design.colors.textSecondary,
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ] else ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.bodySmall(
                      l10n.storePlanNotAvailableForDuration(
                          selectedDurationText),
                      color: design.colors.textSecondary,
                    ),
                    if (availableDurationsText.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      AppText.bodySmall(
                        l10n.storePlanAvailableForDuration(
                            availableDurationsText),
                        color: design.colors.textSecondary,
                      ),
                    ],
                  ],
                ),
              ],
              SizedBox(height: design.spacing.sm),
              Wrap(
                spacing: design.spacing.md,
                runSpacing: design.spacing.xs / 2,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.bookOpen,
                        size: 16.0,
                        color: design.colors.textSecondary,
                      ),
                      SizedBox(width: design.spacing.xs),
                      AppText.bodySmall(
                        l10n.storeCourseCount(plan.courseIds.length),
                        color: design.colors.textSecondary,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  if (totalBenefitsCount > 0)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.checkCircle2,
                          size: 16.0,
                          color: design.colors.textSecondary,
                        ),
                        SizedBox(width: design.spacing.xs),
                        AppText.bodySmall(
                          l10n.storeBenefitCount(
                            plan.benefitIds.length,
                            totalBenefitsCount,
                          ),
                          color: design.colors.textSecondary,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioIndicator(DesignConfig design, bool isAvailable) {
    const size = 20.0;
    final showSelected = isAvailable && isSelected;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: showSelected
              ? design.colors.accent2
              : design.colors.textSecondary
                  .withValues(alpha: isAvailable ? 0.5 : 0.25),
          width: 2.0,
        ),
      ),
      child: showSelected
          ? Center(
              child: Container(
                width: 10.0,
                height: 10.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: design.colors.accent2,
                ),
              ),
            )
          : null,
    );
  }
}
