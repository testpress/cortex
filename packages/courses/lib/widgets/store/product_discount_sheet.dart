import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../../providers/store_providers.dart';

class ProductDiscountSheet extends ConsumerStatefulWidget {
  final VoidCallback onClose;
  final String productSlug;
  final ProductDto? product;
  final String? originalPrice;

  const ProductDiscountSheet({
    super.key,
    required this.onClose,
    required this.productSlug,
    this.product,
    this.originalPrice,
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
    Future.microtask(() {
      if (mounted) {
        ref
            .read(productDiscountNotifierProvider(widget.productSlug).notifier)
            .clearError();
      }
    });
    final currentCode = ref
        .read(productDiscountNotifierProvider(widget.productSlug).notifier)
        .appliedCouponCode;
    if (currentCode != null && currentCode.isNotEmpty) {
      _couponController.text = currentCode;
    }
    _couponController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final discountState =
        ref.read(productDiscountNotifierProvider(widget.productSlug));
    if (discountState.hasError) {
      ref
          .read(productDiscountNotifierProvider(widget.productSlug).notifier)
          .clearError();
    }
  }

  void _handleClose() {
    ref
        .read(productDiscountNotifierProvider(widget.productSlug).notifier)
        .clearError();
    widget.onClose();
  }

  @override
  void dispose() {
    _couponController.removeListener(_onTextChanged);
    _couponController.dispose();
    super.dispose();
  }

  void _applyCoupon() async {
    final code = _couponController.text.trim();
    if (code.isEmpty) return;
    await ref
        .read(productDiscountNotifierProvider(widget.productSlug).notifier)
        .applyCoupon(code);
  }

  String _getErrorMessage(Object error) {
    String msg;
    if (error is ApiException) {
      msg = ApiException.extractApiMessage(error.data) ?? error.message;
    } else {
      msg = error
          .toString()
          .replaceFirst(RegExp(r'^(?:Exception|Error):\s*'), '');
    }
    final match =
        RegExp(r"^\[['" r'"](.*?)' r"['" r'"]\]$').firstMatch(msg.trim());
    if (match != null) {
      final inner = match.group(1)?.trim();
      if (inner != null && inner.isNotEmpty) return inner;
    }
    return msg;
  }

  Widget _buildCelebrationCard(
    BuildContext context,
    DesignConfig design,
    double? savedAmount,
  ) {
    final l10n = L10n.of(context);
    final savedText = savedAmount != null && savedAmount > 0
        ? l10n.storeAmountSaved(savedAmount.toStringAsFixed(2))
        : l10n.storeCouponApplied;
    final semanticLabel = '$savedText ${l10n.storeCouponAppliedSuccessfully}.';

    return AppSemantics.container(
      label: semanticLabel,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: design.colors.success.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(design.radius.xl),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Positioned.fill(
              child: CustomPaint(
                painter: _ConfettiPainter(),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: design.spacing.xl,
                horizontal: design.spacing.lg,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: design.colors.success,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        LucideIcons.check,
                        size: 28,
                        color: design.colors.onSuccess,
                      ),
                    ),
                  ),
                  SizedBox(height: design.spacing.md),
                  AppText.headline(
                    savedText,
                    color: design.colors.success,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: design.spacing.xs),
                  AppText.caption(
                    l10n.storeCouponAppliedSuccessfully,
                    color: design.colors.textSecondary,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final discountState =
        ref.watch(productDiscountNotifierProvider(widget.productSlug));
    final discountOrder = discountState.valueOrNull;
    final isSuccess = discountOrder != null;

    final detailAsync = ref.watch(productDetailProvider(widget.productSlug));
    final product = widget.product ?? detailAsync.valueOrNull;
    final originalPriceStr = widget.originalPrice ?? product?.price;

    final originalPriceVal = originalPriceStr != null
        ? double.tryParse(originalPriceStr.replaceAll(',', ''))
        : (discountOrder != null
            ? double.tryParse(discountOrder.subtotal.replaceAll(',', ''))
            : null);
    final discountedVal = discountOrder != null
        ? double.tryParse(discountOrder.total.replaceAll(',', ''))
        : null;
    final savedAmount = (originalPriceVal != null &&
            discountedVal != null &&
            originalPriceVal > discountedVal)
        ? (originalPriceVal - discountedVal)
        : null;

    final shouldAnimate = MotionPreferences.shouldAnimate(context);
    final duration = shouldAnimate
        ? MotionPreferences.duration(context, design.motion.normal)
        : Duration.zero;

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
              AnimatedSwitcher(
                duration: duration,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: isSuccess
                    ? KeyedSubtree(
                        key: const ValueKey('coupon_success_view'),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildCelebrationCard(context, design, savedAmount),
                            SizedBox(height: design.spacing.lg),
                            AppButton.primary(
                              label: L10n.of(context).labelDone,
                              fullWidth: true,
                              backgroundColor: design.colors.accent2,
                              onPressed: _handleClose,
                            ),
                          ],
                        ),
                      )
                    : KeyedSubtree(
                        key: const ValueKey('coupon_input_view'),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText.title(
                                    L10n.of(context).storeDiscountCoupon),
                                AppSemantics.button(
                                  label: L10n.of(context).labelClose,
                                  child: GestureDetector(
                                    onTap: _handleClose,
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: AppLoadingIndicator(),
                                      )
                                    : AppButton.primary(
                                        label:
                                            L10n.of(context).storeApplyCoupon,
                                        backgroundColor: design.colors.accent2,
                                        onPressed: _applyCoupon,
                                      ),
                              ],
                            ),
                          ],
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

class _ConfettiParticle {
  final double x;
  final double y;
  final double width;
  final double height;
  final double rotation;
  final Color color;
  final bool isCircle;

  const _ConfettiParticle({
    required this.x,
    required this.y,
    this.width = 4,
    this.height = 8,
    this.rotation = 0,
    required this.color,
    this.isCircle = false,
  });
}

class _ConfettiPainter extends CustomPainter {
  const _ConfettiPainter();

  static const List<_ConfettiParticle> _particles = [
    // Top-left
    _ConfettiParticle(
        x: -60,
        y: -26,
        width: 4.5,
        height: 9,
        rotation: -0.5,
        color: Color(0xFFF87171)),
    _ConfettiParticle(
        x: -36,
        y: -18,
        width: 3.5,
        height: 7,
        rotation: 0.3,
        color: Color(0xFFF472B6)),
    _ConfettiParticle(
        x: -46,
        y: 0,
        width: 4,
        height: 7,
        rotation: 0.6,
        color: Color(0xFFA855F7)),
    _ConfettiParticle(
        x: -64,
        y: 16,
        width: 4,
        height: 8,
        rotation: 0.8,
        color: Color(0xFF38BDF8)),
    _ConfettiParticle(
        x: -38,
        y: 24,
        width: 4,
        height: 4,
        isCircle: true,
        color: Color(0xFFFBBF24)),
    // Top-right
    _ConfettiParticle(
        x: 36,
        y: -30,
        width: 4.5,
        height: 8.5,
        rotation: 0.6,
        color: Color(0xFFF87171)),
    _ConfettiParticle(
        x: 64,
        y: -14,
        width: 4,
        height: 9,
        rotation: -0.4,
        color: Color(0xFFEF4444)),
    _ConfettiParticle(
        x: 48,
        y: 2,
        width: 4.5,
        height: 4.5,
        isCircle: true,
        color: Color(0xFF60A5FA)),
    _ConfettiParticle(
        x: 68,
        y: 16,
        width: 4,
        height: 8,
        rotation: 0.5,
        color: Color(0xFFA855F7)),
    _ConfettiParticle(
        x: 34,
        y: 22,
        width: 3.5,
        height: 3.5,
        isCircle: true,
        color: Color(0xFF34D399)),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final badgeCenterX = size.width / 2;
    const badgeCenterY = 50.0;

    for (final p in _particles) {
      final paint = Paint()
        ..color = p.color
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(badgeCenterX + p.x, badgeCenterY + p.y);
      if (p.rotation != 0) {
        canvas.rotate(p.rotation);
      }

      if (p.isCircle) {
        canvas.drawCircle(Offset.zero, p.width / 2, paint);
      } else {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: Offset.zero, width: p.width, height: p.height),
            const Radius.circular(1.5),
          ),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
