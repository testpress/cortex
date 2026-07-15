import 'package:flutter/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final ProductDto product;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return AppSemantics.button(
        label: product.title,
        onTap: () {
          context.push('/explore/product/${product.slug}', extra: product);
        },
        child: AppCard(
          padding: EdgeInsets.zero,
          onTap: () {
            context.push('/explore/product/${product.slug}', extra: product);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover image
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: design.radius.card.topLeft,
                    topRight: design.radius.card.topRight,
                  ),
                  child: product.image != null && product.image!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: product.image!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const _ImagePlaceholder(),
                          errorWidget: (context, url, error) =>
                              const _ImagePlaceholder(),
                        )
                      : const _ImagePlaceholder(),
                ),
              ),

              // Title & price
              Padding(
                padding: EdgeInsets.all(design.spacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.cardTitle(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: design.spacing.xs),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        AppText.title(
                          '₹${product.price}',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        if (product.strikeThroughPrice != null &&
                            product.strikeThroughPrice!.isNotEmpty) ...[
                          SizedBox(width: design.spacing.xs),
                          AppText.sm(
                            '₹${product.strikeThroughPrice}',
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: design.colors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      color: design.colors.surfaceVariant,
      child: Center(
        child: Icon(
          LucideIcons.image,
          color: design.colors.textSecondary,
        ),
      ),
    );
  }
}
