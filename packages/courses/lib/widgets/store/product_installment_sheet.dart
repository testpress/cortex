import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import '../../providers/store_providers.dart';
import 'package:core/data/data.dart';

class ProductInstallmentSheet extends ConsumerStatefulWidget {
  final ProductDto product;
  final VoidCallback onClose;

  const ProductInstallmentSheet({
    super.key,
    required this.product,
    required this.onClose,
  });

  @override
  ConsumerState<ProductInstallmentSheet> createState() =>
      _ProductInstallmentSheetState();
}

class _ProductInstallmentSheetState
    extends ConsumerState<ProductInstallmentSheet> {
  InstallmentPlanDto? _selectedInstallmentPlan;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        0, // Edge-to-edge
        0,
        0,
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
              Consumer(
                builder: (context, ref, child) {
                  final plansAsync = ref.watch(
                      productInstallmentPlansProvider(widget.product.slug));

                  return plansAsync.when(
                    data: (res) {
                      if (res.installmentPlans.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.all(design.spacing.lg),
                          child: Center(
                              child: AppText.body(
                                  L10n.of(context).storeNoInstallmentPlans)),
                        );
                      }
                      if (_selectedInstallmentPlan != null) {
                        return _buildPlanDetails(
                            context, _selectedInstallmentPlan!, design);
                      }
                      return _buildPlanList(context, res, design);
                    },
                    loading: () => Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Center(
                          child: AppText.body(L10n.of(context).storeLoading,
                              color: design.colors.textSecondary)),
                    ),
                    error: (e, st) => Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Center(
                          child: AppText.body(
                              L10n.of(context).storeFailedToLoadPlans,
                              color: design.colors.error)),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanList(BuildContext context, InstallmentPlansResponseDto res,
      DesignConfig design) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: design.spacing.lg),
          child: AppText.title(L10n.of(context).storeChoosePlan),
        ),
        SizedBox(height: design.spacing.xs),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: design.spacing.lg),
          child: AppText.bodySmall(
            L10n.of(context)
                .storeInstallmentPlansCalculationBase(widget.product.price),
            color: design.colors.textSecondary,
          ),
        ),
        SizedBox(height: design.spacing.lg),
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: res.installmentPlans.map((plan) {
                return Column(
                  children: [
                    Container(height: 1, color: design.colors.border),
                    AppSemantics.button(
                      label: plan.displayName,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedInstallmentPlan = plan;
                          });
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: design.spacing.md,
                            horizontal: design.spacing.lg,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText.labelBold(plan.displayName),
                                  ],
                                ),
                              ),
                              Icon(LucideIcons.chevronRight,
                                  color: design.colors.textSecondary),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanDetails(
      BuildContext context, InstallmentPlanDto plan, DesignConfig design) {
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: design.spacing.sm),
            child: Row(
              children: [
                AppSemantics.button(
                  label: L10n.of(context).storeProductBack,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedInstallmentPlan = null;
                      });
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: EdgeInsets.all(design.spacing.sm),
                      child: Row(
                        children: [
                          Icon(LucideIcons.arrowLeft,
                              size: 20, color: design.colors.textSecondary),
                          SizedBox(width: design.spacing.xs),
                          AppText.body(L10n.of(context).storeProductBack,
                              color: design.colors.textSecondary),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: AppText.labelBold(plan.displayName),
                  ),
                ),
                Opacity(
                  opacity: 0,
                  child: IgnorePointer(
                    child: Padding(
                      padding: EdgeInsets.all(design.spacing.sm),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(LucideIcons.arrowLeft, size: 18),
                          const SizedBox(width: 4),
                          AppText.body(L10n.of(context).storeProductBack),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: design.spacing.sm),
          Container(height: 1, color: design.colors.border),
          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(design.spacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...plan.installments.map((inst) {
                      final isLast = plan.installments.last == inst;
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: inst.isPaid
                                      ? design.colors.success
                                      : design.colors.border,
                                ),
                                child: Icon(LucideIcons.check,
                                    size: 16, color: design.colors.surface),
                              ),
                              if (!isLast)
                                Container(
                                  width: 2,
                                  height: 48,
                                  color: design.colors.border,
                                ),
                            ],
                          ),
                          SizedBox(width: design.spacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppText.labelBold(
                                      L10n.of(context).storeInstallmentOrdinal(
                                          inst.order.toString()),
                                      color: inst.isPaid
                                          ? design.colors.success
                                          : design.colors.textSecondary,
                                    ),
                                    AppText.labelBold("₹${inst.price}"),
                                  ],
                                ),
                                SizedBox(height: design.spacing.xs),
                                AppText.bodySmall(
                                  inst.dueDate ?? '',
                                  color: design.colors.textSecondary,
                                ),
                                if (inst.isPaid && inst.paidOn != null) ...[
                                  SizedBox(height: design.spacing.xs),
                                  AppText.bodySmall(
                                    L10n.of(context).storePaidOn(inst.paidOn!),
                                    color: design.colors.success,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
          Container(height: 1, color: design.colors.border),
          if (plan.installments.isNotEmpty)
            Padding(
              padding: EdgeInsets.fromLTRB(design.spacing.lg, design.spacing.lg,
                  design.spacing.lg, design.spacing.sm),
              child: AppButton.primary(
                label: L10n.of(context).storePayAmountNow(plan.installments
                    .firstWhere((i) => !i.isPaid,
                        orElse: () => plan.installments.first)
                    .price),
                fullWidth: true,
                backgroundColor: design.colors.accent2,
                loading: false,
                onPressed: () async {
                  final dataSource = ref.read(dataSourceProvider);

                  if (!context.mounted) return;
                  final result = await PaymentProcessingScreen.start(
                    context,
                    () => ref
                        .read(storeRepositoryProvider)
                        .createAndConfirmOrder(widget.product.slug),
                    dataSource,
                  );

                  if (!context.mounted) return;
                  if (result?.status == PaymentResultStatus.success) {
                    ref.invalidate(productDetailProvider(widget.product.slug));
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}
