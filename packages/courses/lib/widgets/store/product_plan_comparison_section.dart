import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

/// Section rendering "Compare plans" as a side-by-side comparison matrix table.
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

    final plans = product.plans;
    final planCourseIds = {
      for (final plan in plans) ...plan.courseIds,
    };
    final allCourses = product.coursesDetails
        .where((c) => planCourseIds.contains(c.id))
        .toList();
    final allBenefits = product.benefits;

    if (allCourses.isEmpty && allBenefits.isEmpty) {
      return const SizedBox.shrink();
    }

    final activePlanId = selectedPlanId ?? plans.firstOrNull?.id;
    final dividerColor = design.colors.border.withValues(alpha: 0.5);

    final selectedColumnBg = design.isDark
        ? design.colors.accent2.withValues(alpha: 0.18)
        : design.colors.accent2.withValues(alpha: 0.10);

    final selectedHeaderTextColor =
        design.isDark ? design.colors.accent2 : const Color(0xFF1D4ED8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppSemantics.header(
          label: l10n.storeComparePlans,
          child: AppText.title(
            l10n.storeComparePlans,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(height: design.spacing.sm),
        LayoutBuilder(
          builder: (context, constraints) {
            final minFeatureWidth = 140.0;
            final minPlanWidth = 85.0;
            final minTableWidth =
                minFeatureWidth + (plans.length * minPlanWidth);
            final tableWidth = math.max(constraints.maxWidth, minTableWidth);

            // Column width distribution: Feature/Plans column is 1.6x flex of plan columns
            final columnWidths = <int, TableColumnWidth>{
              0: const FlexColumnWidth(1.6),
              for (int i = 0; i < plans.length; i++)
                i + 1: const FlexColumnWidth(1.0),
            };

            final headerTableBorder = TableBorder(
              verticalInside: BorderSide(color: dividerColor, width: 0.8),
            );

            final contentTableBorder = TableBorder(
              horizontalInside: BorderSide(color: dividerColor, width: 0.8),
              verticalInside: BorderSide(color: dividerColor, width: 0.8),
            );

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: tableWidth,
                child: Container(
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
                      // Header Table: Plans column header + plan name headers
                      Table(
                        columnWidths: columnWidths,
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        border: headerTableBorder,
                        children: [
                          _buildHeaderRow(
                            context,
                            design,
                            plans,
                            activePlanId: activePlanId,
                            selectedColumnBg: selectedColumnBg,
                            selectedHeaderTextColor: selectedHeaderTextColor,
                          ),
                        ],
                      ),
                      // Courses Section
                      if (allCourses.isNotEmpty) ...[
                        _buildSectionHeader(
                          design,
                          l10n.storeCourses,
                          dividerColor: dividerColor,
                        ),
                        Table(
                          columnWidths: columnWidths,
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          border: contentTableBorder,
                          children: [
                            ...allCourses.map(
                              (c) => _buildItemRow(
                                context,
                                design,
                                title: c.title,
                                plans: plans,
                                activePlanId: activePlanId,
                                selectedColumnBg: selectedColumnBg,
                                isIncluded: (p) => p.courseIds.contains(c.id),
                              ),
                            ),
                          ],
                        ),
                      ],
                      // "What you get" Benefits Section
                      if (allBenefits.isNotEmpty) ...[
                        _buildSectionHeader(
                          design,
                          l10n.storeWhatYouGet,
                          dividerColor: dividerColor,
                        ),
                        Table(
                          columnWidths: columnWidths,
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          border: contentTableBorder,
                          children: [
                            ...allBenefits.map(
                              (b) => _buildItemRow(
                                context,
                                design,
                                title: b.name,
                                plans: plans,
                                activePlanId: activePlanId,
                                selectedColumnBg: selectedColumnBg,
                                isIncluded: (p) => p.benefitIds.contains(b.id),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
    DesignConfig design,
    String title, {
    required Color dividerColor,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: design.spacing.md,
        vertical: 10.0,
      ),
      decoration: BoxDecoration(
        color: design.colors.surfaceVariant.withValues(alpha: 0.35),
        border: Border(
          top: BorderSide(color: dividerColor, width: 0.8),
          bottom: BorderSide(color: dividerColor, width: 0.8),
        ),
      ),
      child: AppSemantics.header(
        label: title,
        child: AppText.bodySmall(
          title,
          color: design.colors.textPrimary,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  TableRow _buildHeaderRow(
    BuildContext context,
    DesignConfig design,
    List<SubscriptionPlanDto> plans, {
    required int? activePlanId,
    required Color selectedColumnBg,
    required Color selectedHeaderTextColor,
  }) {
    final l10n = L10n.of(context);

    return TableRow(
      children: [
        // "Plans" header column
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: design.spacing.md,
            vertical: design.spacing.sm,
          ),
          child: AppText.bodySmall(
            l10n.storePlansLabel,
            color: design.colors.textPrimary,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        // Plan column headers
        ...plans.map((plan) {
          final isSelected = plan.id == activePlanId;
          final semanticLabel =
              isSelected ? '${plan.name}, selected' : plan.name;
          return TableCell(
            verticalAlignment: TableCellVerticalAlignment.fill,
            child: AppSemantics.button(
              label: semanticLabel,
              onTap: () => onSelectPlan(plan.id),
              child: AppFocusable(
                onTap: () => onSelectPlan(plan.id),
                child: Container(
                  color: isSelected ? selectedColumnBg : null,
                  padding: EdgeInsets.symmetric(
                    horizontal: design.spacing.xs,
                    vertical: design.spacing.sm,
                  ),
                  alignment: Alignment.center,
                  child: AppText.bodySmall(
                    plan.name,
                    color: isSelected
                        ? selectedHeaderTextColor
                        : design.colors.textPrimary,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  TableRow _buildItemRow(
    BuildContext context,
    DesignConfig design, {
    required String title,
    required List<SubscriptionPlanDto> plans,
    required int? activePlanId,
    required Color selectedColumnBg,
    required bool Function(SubscriptionPlanDto plan) isIncluded,
  }) {
    final l10n = L10n.of(context);

    return TableRow(
      children: [
        // Title cell (course or benefit)
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: design.spacing.md,
            vertical: design.spacing.sm,
          ),
          child: AppText.bodySmall(
            title,
            color: design.colors.textPrimary,
            style: const TextStyle(fontWeight: FontWeight.w500, height: 1.3),
          ),
        ),
        // Indicator cell per plan
        ...plans.map((plan) {
          final isSelected = plan.id == activePlanId;
          final included = isIncluded(plan);
          final statusText = included
              ? l10n.storeBenefitIncluded
              : l10n.storeBenefitNotIncluded;

          return TableCell(
            verticalAlignment: TableCellVerticalAlignment.fill,
            child: AppSemantics.container(
              label: '$title, ${plan.name}: $statusText',
              child: Container(
                color: isSelected ? selectedColumnBg : null,
                padding: EdgeInsets.symmetric(
                  horizontal: design.spacing.xs,
                  vertical: design.spacing.sm,
                ),
                alignment: Alignment.center,
                child: included
                    ? Icon(
                        LucideIcons.check,
                        size: 16.0,
                        color: design.colors.success,
                      )
                    : Icon(
                        LucideIcons.x,
                        size: 16.0,
                        color:
                            design.colors.textSecondary.withValues(alpha: 0.45),
                      ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
