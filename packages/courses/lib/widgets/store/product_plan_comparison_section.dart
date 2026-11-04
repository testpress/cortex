import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

/// Section rendering "Compare plans", segmented plan tabs, and feature checklists.
class ProductPlanComparisonSection extends StatelessWidget {
  final ProductDto product;
  final int? selectedPlanId;
  final ValueChanged<int> onSelectPlan;

  const ProductPlanComparisonSection({
    super.key,
    required this.product,
    required this.selectedPlanId,
    required this.onSelectPlan,
  });

  @override
  Widget build(BuildContext context) {
    if (product.plans.isEmpty) return const SizedBox.shrink();

    final design = Design.of(context);
    final l10n = L10n.of(context);

    final activePlan =
        product.plans.where((p) => p.id == selectedPlanId).firstOrNull ??
            product.plans.first;

    final allCourses = product.coursesDetails;
    final allBenefits = product.benefits;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText.title(
          l10n.storeComparePlans,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        SizedBox(height: design.spacing.sm),
        _buildSegmentedTabBar(context, design),
        SizedBox(height: design.spacing.md),
        Container(
          decoration: BoxDecoration(
            color: design.colors.card,
            borderRadius: BorderRadius.circular(design.radius.lg),
            border: Border.all(color: design.colors.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (allCourses.isNotEmpty) ...[
                _buildSectionHeader(design, l10n.storeCourses),
                ...allCourses.asMap().entries.map((entry) {
                  final course = entry.value;
                  final isLast =
                      entry.key == allCourses.length - 1 && allBenefits.isEmpty;
                  final isIncluded = activePlan.courseIds.contains(course.id);
                  return _buildComparisonRow(
                    context,
                    design,
                    title: course.title,
                    isIncluded: isIncluded,
                    isLast: isLast,
                  );
                }),
              ],
              if (allBenefits.isNotEmpty) ...[
                _buildSectionHeader(
                  design,
                  l10n.storeWhatYouGet,
                  hasTopBorder: allCourses.isNotEmpty,
                ),
                ...allBenefits.asMap().entries.map((entry) {
                  final benefit = entry.value;
                  final isLast = entry.key == allBenefits.length - 1;
                  final isIncluded = activePlan.benefitIds.contains(benefit.id);
                  return _buildComparisonRow(
                    context,
                    design,
                    title: benefit.name,
                    isIncluded: isIncluded,
                    isLast: isLast,
                  );
                }),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
    DesignConfig design,
    String title, {
    bool hasTopBorder = false,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: design.spacing.md,
        vertical: 10.0,
      ),
      decoration: BoxDecoration(
        color: design.colors.surfaceVariant.withValues(alpha: 0.4),
        border: Border(
          top: hasTopBorder
              ? BorderSide(color: design.colors.border, width: 0.8)
              : BorderSide.none,
          bottom: BorderSide(color: design.colors.border, width: 0.8),
        ),
      ),
      child: AppText.body(
        title,
        color: design.colors.textPrimary,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildSegmentedTabBar(BuildContext context, DesignConfig design) {
    final isFit = product.plans.length <= 3;

    Widget buildTab(SubscriptionPlanDto plan) {
      final isSelected = plan.id == selectedPlanId;
      return AppSemantics.button(
        label: plan.name,
        onTap: () => onSelectPlan(plan.id),
        child: AppFocusable(
          onTap: () => onSelectPlan(plan.id),
          borderRadius: BorderRadius.circular(design.radius.sm),
          child: Container(
            constraints: const BoxConstraints(minHeight: 48.0, minWidth: 48.0),
            padding: EdgeInsets.symmetric(
              horizontal: design.spacing.xs,
              vertical: 6.0,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color:
                  isSelected ? design.colors.card : design.colors.transparent,
              borderRadius: BorderRadius.circular(design.radius.sm),
              boxShadow: isSelected ? design.shadows.surfaceSoft : null,
            ),
            child: AppText.bodySmall(
              plan.name,
              color: isSelected
                  ? design.colors.textPrimary
                  : design.colors.textSecondary,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }

    final children = product.plans.map((plan) {
      return isFit ? Expanded(child: buildTab(plan)) : buildTab(plan);
    }).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        color: design.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(design.radius.md),
      ),
      child: isFit
          ? IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: children,
                ),
              ),
            ),
    );
  }

  Widget _buildComparisonRow(
    BuildContext context,
    DesignConfig design, {
    required String title,
    required bool isIncluded,
    bool isLast = false,
  }) {
    final l10n = L10n.of(context);
    final statusText =
        isIncluded ? l10n.storeBenefitIncluded : l10n.storeBenefitNotIncluded;

    return Container(
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: design.colors.border.withValues(alpha: 0.6),
                  width: 0.8,
                ),
              ),
            ),
      padding: EdgeInsets.symmetric(
        horizontal: design.spacing.md,
        vertical: 12.0,
      ),
      child: AppSemantics.container(
        label: '$title: $statusText',
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: AppText.body(
                title,
                color: isIncluded
                    ? design.colors.textPrimary
                    : design.colors.textSecondary,
                style: TextStyle(
                  fontWeight: isIncluded ? FontWeight.w500 : FontWeight.w400,
                  height: 1.4,
                ),
              ),
            ),
            SizedBox(width: design.spacing.sm),
            Icon(
              isIncluded ? LucideIcons.check : LucideIcons.x,
              size: 16.0,
              color: isIncluded
                  ? design.colors.success
                  : design.colors.textSecondary.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }
}
