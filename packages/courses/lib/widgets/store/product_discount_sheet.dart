import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import '../../providers/store_providers.dart';

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
  void initState() {
    super.initState();
    final currentCode = ref
        .read(productDiscountNotifierProvider(widget.productSlug).notifier)
        .appliedCouponCode;
    if (currentCode != null && currentCode.isNotEmpty) {
      _couponController.text = currentCode;
    }
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _applyCoupon() async {
    final code = _couponController.text.trim();
    if (code.isEmpty) return;
    await ref
        .read(productDiscountNotifierProvider(widget.productSlug).notifier)
        .applyCoupon(code);
    final state = ref.read(productDiscountNotifierProvider(widget.productSlug));
    if (state.hasValue && state.value != null && mounted) {
      widget.onClose();
    }
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.title(L10n.of(context).storeDiscountCoupon),
                  AppSemantics.button(
                    label: L10n.of(context).labelClose,
                    child: GestureDetector(
                      onTap: widget.onClose,
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: EdgeInsets.all(design.spacing.xs),
                        child: Icon(
                          LucideIcons.x,
                          size: design.iconSize.md,
                          color: design.colors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: design.spacing.md),
              if (discountState.hasError) ...[
                AppText.body(
                  _getErrorMessage(discountState.error!),
                  color: design.colors.error,
                ),
                SizedBox(height: design.spacing.md),
              ],
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: "",
                      hintText: L10n.of(context).storeCouponHint,
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
                          label: L10n.of(context).storeApplyCoupon,
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
