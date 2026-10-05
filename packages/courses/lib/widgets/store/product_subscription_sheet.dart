import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

class ProductSubscriptionSheet extends ConsumerStatefulWidget {
  final ProductDto product;
  final int? initialSelectedPlanDetailId;
  final ValueChanged<int>? onPlanSelected;
  final VoidCallback onClose;

  const ProductSubscriptionSheet({
    super.key,
    required this.product,
    this.initialSelectedPlanDetailId,
    this.onPlanSelected,
    required this.onClose,
  });

  @override
  ConsumerState<ProductSubscriptionSheet> createState() =>
      _ProductSubscriptionSheetState();
}

class _ProductSubscriptionSheetState
    extends ConsumerState<ProductSubscriptionSheet> {
  late int? _selectedPlanDetailId;

  @override
  void initState() {
    super.initState();
    _selectedPlanDetailId = widget.initialSelectedPlanDetailId;
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final allPlanDetails = [
      for (final p in widget.product.plans) ...p.planDetails
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(
        design.spacing.sm,
        0,
        design.spacing.sm,
        design.spacing.md + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.fromLTRB(
            0,
            design.spacing.md,
            0,
            design.spacing.lg,
          ),
          decoration: BoxDecoration(
            color: design.colors.card,
            borderRadius: BorderRadius.all(Radius.circular(design.radius.xxl)),
            boxShadow: design.shadows.floating,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
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
              SizedBox(height: design.spacing.lg),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: design.spacing.lg),
                child: Row(
                  children: [
                    Expanded(
                      child: AppText.title(
                        'Select a plan to proceed with your purchase',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    AppSemantics.button(
                      label: L10n.of(context).labelClose,
                      child: GestureDetector(
                        onTap: widget.onClose,
                        behavior: HitTestBehavior.opaque,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minWidth: 48,
                            minHeight: 48,
                          ),
                          child: Center(
                            child: Icon(
                              LucideIcons.x,
                              size: design.iconSize.md,
                              color: design.colors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: design.spacing.md),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: allPlanDetails.map((detail) {
                      final isSelected = detail.id == _selectedPlanDetailId;
                      final durationText = detail.durationInDays >= 365 &&
                              detail.durationInDays % 365 == 0
                          ? '${detail.durationInDays ~/ 365} year${detail.durationInDays > 365 ? 's' : ''}'
                          : '${detail.durationInDays} days';

                      return AppSemantics.button(
                        label: '$durationText. ₹${detail.price}',
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedPlanDetailId = detail.id;
                            });
                            widget.onPlanSelected?.call(detail.id);
                            widget.onClose();
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: design.spacing.md,
                              horizontal: design.spacing.lg,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? design.colors.accent2
                                      .withValues(alpha: 0.08)
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected
                                      ? LucideIcons.checkCircle
                                      : LucideIcons.circle,
                                  size: design.iconSize.md,
                                  color: isSelected
                                      ? design.colors.accent2
                                      : design.colors.textSecondary,
                                ),
                                SizedBox(width: design.spacing.md),
                                Expanded(
                                  child: AppText.body(
                                    '$durationText. ₹${detail.price}',
                                    style: TextStyle(
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? design.colors.accent2
                                          : design.colors.textPrimary,
                                    ),
                                  ),
                                ),
                                if (detail.strikeThroughPrice != null &&
                                    detail.strikeThroughPrice!.isNotEmpty)
                                  AppText.bodySmall(
                                    '₹${detail.strikeThroughPrice}',
                                    style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: design.colors.textSecondary,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
