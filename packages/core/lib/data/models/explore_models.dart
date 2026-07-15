import 'paginated_response_dto.dart';

/// DTO for product categories — from /api/v2.5/products/categories/.
class ProductCategoryDto {
  final int id;
  final String name;
  final String slug;

  const ProductCategoryDto({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory ProductCategoryDto.fromJson(Map<String, dynamic> json) {
    return ProductCategoryDto(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'slug': slug};
}

/// DTO for pricing tier (sideloaded in v2.4 API).
class PriceDto {
  final int id;
  final String name;
  final String price;
  final int? validity;
  final String? startDate;
  final String? endDate;

  const PriceDto({
    required this.id,
    required this.name,
    required this.price,
    this.validity,
    this.startDate,
    this.endDate,
  });

  factory PriceDto.fromJson(Map<String, dynamic> json) {
    return PriceDto(
      id: json['id'] as int,
      name: json['name'] as String,
      price: json['price'] as String,
      validity: json['validity'] as int?,
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'validity': validity,
    'start_date': startDate,
    'end_date': endDate,
  };
}

/// DTO for Products (Store items) — maps to /api/v2.4/products/.
class ProductDto {
  final int id;
  final String title;
  final String slug;
  final String descriptionHtml;
  final String price;
  final List<int> courses;
  final String? image;
  final String? strikeThroughPrice;
  final String? buyNowText;
  final String? category;
  final List<PriceDto> prices;

  const ProductDto({
    required this.id,
    required this.title,
    required this.slug,
    this.descriptionHtml = '',
    required this.price,
    required this.courses,
    this.image,
    this.strikeThroughPrice,
    this.buyNowText,
    this.category,
    this.prices = const [],
  });

  factory ProductDto.fromJson(
    Map<String, dynamic> json, {
    List<PriceDto> parsedPrices = const [],
  }) {
    return ProductDto(
      id: json['id'] as int,
      title: json['title'] as String,
      slug: json['slug'] as String? ?? '',
      descriptionHtml: json['description_html'] as String? ?? '',
      price:
          (json['current_price'] as String?) ??
          (json['price'] as String?) ??
          '',
      courses:
          (json['courses'] as List<dynamic>?)?.map((e) => e as int).toList() ??
          [],
      image: () {
        if (json['image'] is String) return json['image'] as String?;
        final images = json['images'] as List<dynamic>?;
        if (images != null && images.isNotEmpty) {
          final firstImg = images.first as Map<String, dynamic>?;
          return firstImg?['medium'] as String? ??
              firstImg?['original'] as String?;
        }
        return null;
      }(),
      strikeThroughPrice: json['strike_through_price'] as String?,
      buyNowText: json['buy_now_text'] as String? ?? 'Buy Now',
      category: json['category'] as String?,
      prices: parsedPrices.isNotEmpty
          ? parsedPrices
          : (json['prices'] as List<dynamic>?)
                    ?.whereType<Map<String, dynamic>>()
                    .map((e) => PriceDto.fromJson(e))
                    .toList() ??
                [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'slug': slug,
    'description_html': descriptionHtml,
    'current_price': price,
    'courses': courses,
    'image': image,
    'strike_through_price': strikeThroughPrice,
    'buy_now_text': buyNowText,
    'category': category,
    'prices': prices.map((p) => p.toJson()).toList(),
  };
}

/// Parses the sideloaded envelope from /api/v2.4/products/.
class StoreProductsResponseDto {
  final int count;
  final String? next;
  final String? previous;
  final List<ProductDto> products;

  const StoreProductsResponseDto({
    required this.count,
    this.next,
    this.previous,
    required this.products,
  });

  factory StoreProductsResponseDto.fromJson(Map<String, dynamic> json) {
    final results = json['results'] as Map<String, dynamic>? ?? {};

    // Parse sideloaded prices
    final pricesRaw = results['prices'] as List<dynamic>? ?? [];
    final allPrices = pricesRaw
        .map((e) => PriceDto.fromJson(e as Map<String, dynamic>))
        .toList();

    // Parse products and attach prices
    final productsRaw = results['products'] as List<dynamic>? ?? [];
    final parsedProducts = productsRaw.map((e) {
      final productMap = e as Map<String, dynamic>;
      final productPriceIds =
          (productMap['prices'] as List<dynamic>?)
              ?.map((id) => id as int)
              .toList() ??
          [];
      final productPrices = allPrices
          .where((p) => productPriceIds.contains(p.id))
          .toList();

      return ProductDto.fromJson(productMap, parsedPrices: productPrices);
    }).toList();

    return StoreProductsResponseDto(
      count: json['count'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      products: parsedProducts,
    );
  }

  PaginatedResponseDto<ProductDto> toPaginatedResponse() {
    return PaginatedResponseDto<ProductDto>(
      count: count,
      next: next,
      previous: previous,
      results: products,
    );
  }
}
