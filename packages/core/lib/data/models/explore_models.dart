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

class ProductCourseDto {
  final int id;
  final String title;
  final String slug;
  final String image;
  final int chaptersCount;
  final int contentsCount;
  final int examsCount;
  final int videosCount;
  final int attachmentsCount;
  final int htmlContentsCount;

  const ProductCourseDto({
    required this.id,
    required this.title,
    required this.slug,
    this.image = '',
    this.chaptersCount = 0,
    this.contentsCount = 0,
    this.examsCount = 0,
    this.videosCount = 0,
    this.attachmentsCount = 0,
    this.htmlContentsCount = 0,
  });

  factory ProductCourseDto.fromJson(Map<String, dynamic> json) {
    return ProductCourseDto(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      image: json['image'] as String? ?? '',
      chaptersCount: json['chapters_count'] as int? ?? 0,
      contentsCount: json['contents_count'] as int? ?? 0,
      examsCount: json['exams_count'] as int? ?? 0,
      videosCount: json['videos_count'] as int? ?? 0,
      attachmentsCount: json['attachments_count'] as int? ?? 0,
      htmlContentsCount: json['html_contents_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'slug': slug,
    'image': image,
    'chapters_count': chaptersCount,
    'contents_count': contentsCount,
    'exams_count': examsCount,
    'videos_count': videosCount,
    'attachments_count': attachmentsCount,
    'html_contents_count': htmlContentsCount,
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
  final List<ProductCourseDto> coursesDetails;
  final bool hasCoupons;

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
    this.coursesDetails = const [],
    this.hasCoupons = false,
  });

  factory ProductDto.fromJson(
    Map<String, dynamic> json, {
    List<PriceDto> parsedPrices = const [],
    List<ProductCourseDto> parsedCourses = const [],
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
      courses: () {
        final rawCourses = json['courses'] as List<dynamic>? ?? [];
        return rawCourses
            .map((e) {
              if (e is int) return e;
              if (e is Map<String, dynamic> && e['id'] is int) {
                return e['id'] as int;
              }
              return -1;
            })
            .where((id) => id != -1)
            .toList();
      }(),
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
      coursesDetails: () {
        if (parsedCourses.isNotEmpty) {
          return parsedCourses;
        }
        final List<ProductCourseDto> details = [];
        if (json['course'] != null && json['course'] is Map) {
          details.add(
            ProductCourseDto.fromJson(json['course'] as Map<String, dynamic>),
          );
        }
        if (json['courses'] != null && json['courses'] is List) {
          final coursesList = json['courses'] as List<dynamic>;
          for (final item in coursesList) {
            if (item is Map<String, dynamic>) {
              details.add(ProductCourseDto.fromJson(item));
            }
          }
        }
        return details;
      }(),
      hasCoupons: json['has_coupons'] as bool? ?? false,
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
    'courses_details': coursesDetails.map((c) => c.toJson()).toList(),
    'has_coupons': hasCoupons,
  };
}

class OrderDto {
  final int id;
  final String status;
  final String total;
  final String subtotal;

  const OrderDto({
    required this.id,
    required this.status,
    required this.total,
    required this.subtotal,
  });

  factory OrderDto.fromJson(Map<String, dynamic> json) {
    return OrderDto(
      id: json['id'] as int,
      status: json['status'] as String? ?? '',
      total: json['total'] as String? ?? '0.00',
      subtotal: json['subtotal'] as String? ?? '0.00',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'status': status,
    'total': total,
    'subtotal': subtotal,
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

    // Parse sideloaded courses
    final coursesRaw = results['courses'] as List<dynamic>? ?? [];
    final allCourses = coursesRaw
        .map((e) => ProductCourseDto.fromJson(e as Map<String, dynamic>))
        .toList();

    // Parse products and attach prices & courses
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

      final productCourseIds =
          (productMap['courses'] as List<dynamic>?)
              ?.map((e) {
                if (e is int) return e;
                if (e is Map<String, dynamic> && e['id'] is int) {
                  return e['id'] as int;
                }
                return -1;
              })
              .where((id) => id != -1)
              .toList() ??
          [];
      final productCourses = allCourses
          .where((c) => productCourseIds.contains(c.id))
          .toList();

      return ProductDto.fromJson(
        productMap,
        parsedPrices: productPrices,
        parsedCourses: productCourses,
      );
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

class InstallmentDto {
  final int id;
  final int order;
  final String price;
  final bool isPaid;
  final String? paidOn;
  final bool isCurrentInstallment;
  final String? dueDate;

  const InstallmentDto({
    required this.id,
    required this.order,
    required this.price,
    required this.isPaid,
    this.paidOn,
    required this.isCurrentInstallment,
    this.dueDate,
  });

  factory InstallmentDto.fromJson(Map<String, dynamic> json) {
    return InstallmentDto(
      id: json['id'] as int,
      order: json['order'] as int,
      price: json['price'] as String,
      isPaid: json['is_paid'] as bool,
      paidOn: json['paid_on'] as String?,
      isCurrentInstallment: json['is_current_installment'] as bool,
      dueDate: json['due_date'] as String?,
    );
  }
}

class InstallmentPlanDto {
  final int id;
  final String price;
  final int numberOfInstallments;
  final int period;
  final String displayName;
  final List<InstallmentDto> installments;

  const InstallmentPlanDto({
    required this.id,
    required this.price,
    required this.numberOfInstallments,
    required this.period,
    required this.displayName,
    required this.installments,
  });

  factory InstallmentPlanDto.fromJson(Map<String, dynamic> json) {
    return InstallmentPlanDto(
      id: json['id'] as int,
      price: json['price'] as String,
      numberOfInstallments: json['number_of_installments'] as int,
      period: json['period'] as int,
      displayName: json['display_name'] as String,
      installments:
          (json['installments'] as List<dynamic>?)
              ?.map((e) => InstallmentDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class InstallmentPlansResponseDto {
  final List<InstallmentPlanDto> installmentPlans;
  final List<dynamic> userInstallmentPlans;

  const InstallmentPlansResponseDto({
    required this.installmentPlans,
    required this.userInstallmentPlans,
  });

  factory InstallmentPlansResponseDto.fromJson(Map<String, dynamic> json) {
    return InstallmentPlansResponseDto(
      installmentPlans:
          (json['installment_plans'] as List<dynamic>?)
              ?.map(
                (e) => InstallmentPlanDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      userInstallmentPlans:
          json['user_installment_plans'] as List<dynamic>? ?? [],
    );
  }
}
