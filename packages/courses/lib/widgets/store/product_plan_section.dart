import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'product_plan_card.dart';
import 'store_formatters.dart';

/// Section rendering "Choose a plan", duration filters, and plan cards.
class ProductPlanSection extends StatelessWidget {
  final ProductDto product;
  final int? selectedPlanId;
  final int? selectedDurationInDays;
  final ValueChanged<int> onSelectPlan;
  final ValueChanged<int> onSelectDuration;

  const ProductPlanSection({
    super.key,
    required this.product,
    required this.selectedPlanId,
    required this.selectedDurationInDays,
    required this.onSelectPlan,
    required this.onSelectDuration,
  });

  @override
  Widget build(BuildContext context) {
    if (product.plans.isEmpty) return const SizedBox.shrink();

    final design = Design.of(context);
    final l10n = L10n.of(context);

    // Extract unique durations across all plan details, sorted ascending
    final allDurations = <int>{};
    for (final plan in product.plans) {
      for (final detail in plan.planDetails) {
        allDurations.add(detail.durationInDays);
      }
    }
    final sortedDurations = allDurations.toList()..sort();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSemantics.header(
                    label: l10n.storeChooseAPlan,
                    child: AppText.title(
                      l10n.storeChooseAPlan,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(height: design.spacing.xs),
                  AppText.bodySmall(
                    l10n.storePickPlanSubtitle,
                    color: design.colors.textSecondary,
                  ),
                ],
              ),
            ),
          ],
        ),
        if (sortedDurations.length > 1) ...[
          SizedBox(height: design.spacing.sm),
          _buildDurationSelector(context, design, sortedDurations),
        ],
        SizedBox(height: design.spacing.md),
        ...product.plans.map((plan) {
          final activeDetail = selectedDurationInDays != null
              ? plan.planDetails
                  .where((d) => d.durationInDays == selectedDurationInDays)
                  .firstOrNull
              : plan.planDetails.firstOrNull;
          final isSelected = activeDetail != null && plan.id == selectedPlanId;

          return ProductPlanCard(
            plan: plan,
            activePlanDetail: activeDetail,
            selectedDurationInDays: selectedDurationInDays,
            totalBenefitsCount: product.benefits.length,
            isSelected: isSelected,
            onSelect: () => onSelectPlan(plan.id),
          );
        }),
      ],
    );
  }

  Widget _buildDurationSelector(
    BuildContext context,
    DesignConfig design,
    List<int> durations,
  ) {
    final l10n = L10n.of(context);

    return Align(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            color: design.colors.surfaceVariant,
            borderRadius: BorderRadius.circular(design.radius.md),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: durations.map((duration) {
              final isSelected = duration == selectedDurationInDays;
              final label = formatPlanDuration(l10n, duration);

              final semanticLabel = isSelected ? '$label, selected' : label;

              return AppSemantics.button(
                label: semanticLabel,
                onTap: () => onSelectDuration(duration),
                child: AppFocusable(
                  onTap: () => onSelectDuration(duration),
                  borderRadius: BorderRadius.circular(design.radius.sm),
                  child: Container(
                    constraints:
                        const BoxConstraints(minHeight: 36.0, minWidth: 48.0),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 6.0,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? design.colors.card
                          : design.colors.transparent,
                      borderRadius: BorderRadius.circular(design.radius.sm),
                      boxShadow: isSelected ? design.shadows.surfaceSoft : null,
                    ),
                    child: AppText.bodySmall(
                      label,
                      color: isSelected
                          ? design.colors.textPrimary
                          : design.colors.textSecondary,
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
