import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import '../../providers/explore_providers.dart';
import 'package:core/data/data.dart';

class ProductDiscountSheet extends ConsumerStatefulWidget {
  final VoidCallback onClose;
  final String productSlug;

  const ProductDiscountSheet({
    super.key,
    required this.onClose,
    required this.productSlug,
  });

  @override
  ConsumerState<ProductDiscountSheet> createState() =>
      _ProductDiscountSheetState();
}

class _ProductDiscountSheetState extends ConsumerState<ProductDiscountSheet> {
  final TextEditingController _couponController = TextEditingController();

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _applyCoupon() {
    final code = _couponController.text.trim();
    if (code.isEmpty) return;
    ref
        .read(productDiscountNotifierProvider(widget.productSlug).notifier)
        .applyCoupon(code);
  }

  String _getErrorMessage(Object error) {
    if (error is ApiException) {
      return ApiException.extractApiMessage(error.data) ?? error.message;
    }
    return error
        .toString()
        .replaceFirst(RegExp(r'^(?:Exception|Error):\s*'), '');
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final discountState =
        ref.watch(productDiscountNotifierProvider(widget.productSlug));

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
            design.spacing.lg,
            design.spacing.md,
            design.spacing.lg,
            design.spacing.lg,
          ),
          decoration: BoxDecoration(
            color: design.colors.card,
            borderRadius: BorderRadius.all(Radius.circular(design.radius.xxl)),
            boxShadow: design.shadows.floating,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle Bar
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
              AppText.title(L10n.of(context).exploreDiscountCoupon),
              SizedBox(height: design.spacing.md),
              if (discountState.hasError) ...[
                AppText.body(
                  _getErrorMessage(discountState.error!),
                  color: design.colors.error,
                ),
                SizedBox(height: design.spacing.md),
              ] else if (discountState.hasValue &&
                  discountState.value != null) ...[
                AppText.body(
                  L10n.of(context)
                      .exploreCouponAppliedSuccess(discountState.value!.total),
                  color: design.colors.success,
                ),
                SizedBox(height: design.spacing.md),
              ],
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: "",
                      hintText: L10n.of(context).exploreCouponHint,
                      controller: _couponController,
                    ),
                  ),
                  SizedBox(width: design.spacing.sm),
                  discountState.isLoading
                      ? const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: AppLoadingIndicator(),
                        )
                      : AppButton.primary(
                          label: L10n.of(context).exploreApplyCoupon,
                          backgroundColor: design.colors.accent2,
                          onPressed: _applyCoupon,
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
