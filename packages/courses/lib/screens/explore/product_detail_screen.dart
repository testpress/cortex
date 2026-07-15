import 'package:flutter/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  final ProductDto product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  PriceDto? _selectedPrice;

  @override
  void initState() {
    super.initState();
    if (widget.product.prices.isNotEmpty) {
      _selectedPrice = widget.product.prices.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final product = widget.product;

    return Container(
      color: design.colors.canvas,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: design.colors.card,
              border: Border(
                bottom: BorderSide(color: design.colors.divider),
              ),
            ),
            padding: EdgeInsetsDirectional.fromSTEB(
              design.spacing.screenPadding,
              MediaQuery.paddingOf(context).top + design.spacing.md,
              design.spacing.screenPadding,
              design.spacing.md,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppSemantics.button(
                  label: 'Back',
                  onTap: () => Navigator.pop(context),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 2,
                          right:
                              8), // Right padding added to increase touch target area without disrupting spacing
                      child: Icon(
                        LucideIcons.arrowLeft,
                        size: 22,
                        color: design.colors.textPrimary,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: design.spacing.sm),
                Expanded(
                  child: AppText.title(
                    product.title,
                    color: design.colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (product.image != null && product.image!.isNotEmpty)
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: CachedNetworkImage(
                        imageUrl: product.image!,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: design.colors.surfaceVariant,
                          child: Center(
                            child: Icon(LucideIcons.image,
                                color: design.colors.textSecondary),
                          ),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: design.colors.surfaceVariant,
                          child: Center(
                            child: Icon(LucideIcons.image,
                                color: design.colors.textSecondary),
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.all(design.spacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            AppText.title(
                              '₹ ${product.price}',
                              style: TextStyle(
                                color: design.colors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (product.strikeThroughPrice != null &&
                                product.strikeThroughPrice!.isNotEmpty) ...[
                              SizedBox(width: design.spacing.sm),
                              AppText.body(
                                '₹${product.strikeThroughPrice}',
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: design.colors.textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: design.spacing.md),
                        if (product.descriptionHtml.isNotEmpty)
                          AppHtmlV2(data: product.descriptionHtml),
                        SizedBox(height: design.spacing.xl),
                        if (product.prices.isNotEmpty) ...[
                          const AppText.title('Select Plan',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: design.spacing.sm),
                          ...product.prices.map((price) {
                            final isSelected = _selectedPrice == price;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedPrice = price),
                              child: Container(
                                margin:
                                    EdgeInsets.only(bottom: design.spacing.sm),
                                padding: EdgeInsets.all(design.spacing.md),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? design.colors.primary
                                          .withValues(alpha: 0.05)
                                      : design.colors.card,
                                  borderRadius: design.radius.card,
                                  border: Border.all(
                                    color: isSelected
                                        ? design.colors.primary
                                        : design.colors.border,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      margin: EdgeInsets.only(
                                          right: design.spacing.md),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected
                                              ? design.colors.primary
                                              : design.colors.border,
                                          width: 2,
                                        ),
                                      ),
                                      child: isSelected
                                          ? Center(
                                              child: Container(
                                                width: 10,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: design.colors.primary,
                                                ),
                                              ),
                                            )
                                          : null,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppText.title(price.name,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600)),
                                          if (price.validity != null)
                                            AppText.sm(
                                                'Validity: ${price.validity} days',
                                                color: design
                                                    .colors.textSecondary),
                                          if (price.startDate != null &&
                                              price.endDate != null)
                                            AppText.sm(
                                                'From ${price.startDate} to ${price.endDate}',
                                                color: design
                                                    .colors.textSecondary),
                                        ],
                                      ),
                                    ),
                                    AppText.title('₹${price.price}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.all(design.spacing.md),
              child: AppButton.primary(
                label: (product.buyNowText?.isNotEmpty == true)
                    ? product.buyNowText!
                    : 'Buy Now',
                onPressed: () {
                  AppToast.show(context, message: 'Checkout flow coming soon');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
