import 'package:flutter_test/flutter_test.dart';
import 'package:core/data/models/store_models.dart';

void main() {
  group('ProductDto.isFree', () {
    ProductDto createProductWithPrice(String price) {
      return ProductDto(
        id: 1,
        title: 'Test Course',
        slug: 'test-course',
        price: price,
        courses: const [],
      );
    }

    test('returns true for genuine zero values', () {
      expect(createProductWithPrice('0').isFree, isTrue);
      expect(createProductWithPrice('0.0').isFree, isTrue);
      expect(createProductWithPrice('0.00').isFree, isTrue);
      expect(createProductWithPrice(' 0.00 ').isFree, isTrue);
    });

    test('returns false for paid prices', () {
      expect(createProductWithPrice('99.00').isFree, isFalse);
      expect(createProductWithPrice('2,500.00').isFree, isFalse);
      expect(createProductWithPrice('0.01').isFree, isFalse);
    });

    test('returns false for unparseable, negative, or empty values', () {
      expect(createProductWithPrice('').isFree, isFalse);
      expect(createProductWithPrice('   ').isFree, isFalse);
      expect(createProductWithPrice('invalid').isFree, isFalse);
      expect(createProductWithPrice('N/A').isFree, isFalse);
      expect(createProductWithPrice('-5').isFree, isFalse);
    });
  });

  group('OrderDto.fromJson', () {
    test('parses full payload successfully', () {
      final json = {
        'id': 2851,
        'status': 'Completed',
        'amount': '1.00',
        'subtotal': '1.00',
        'order_id': 'order_TcGbg41840aK0X',
        'apikey': 'rzp_live_TakS5vVbuY6Zbt',
        'product_info': 'test purchase',
        'name': 'Testuser',
        'email': 'test@example.com',
        'phone': '9999999999',
        'pg_url': 'https://api.razorpay.com/v1/checkout/embedded',
      };

      final order = OrderDto.fromJson(json);
      expect(order.id, 2851);
      expect(order.status, 'Completed');
      expect(order.total, '1.00');
      expect(order.orderId, 'order_TcGbg41840aK0X');
    });

    test('parses minimal refresh status payload without id', () {
      final json = {'status': 'Completed'};

      final order = OrderDto.fromJson(json);
      expect(order.id, 0);
      expect(order.status, 'Completed');
      expect(order.total, '0.00');
      expect(order.orderId, isNull);
    });

    test('parses payload with order_items and price_before_discounts', () {
      final json = {
        'id': 10482,
        'order_id': 'ORD-2026-10482',
        'status': 'Pending',
        'amount': '499.00',
        'subtotal': '999.00',
        'product_info': 'UPSC Prelims Masterclass',
        'order_items': [
          {
            'id': 8921,
            'product': 'upsc-prelims-masterclass',
            'price': '499.00',
            'price_before_discounts': '999.00',
          },
        ],
      };

      final order = OrderDto.fromJson(json);
      expect(order.id, 10482);
      expect(order.status, 'Pending');
      expect(order.total, '499.00');
      expect(order.orderItems, hasLength(1));

      final item = order.orderItems.first;
      expect(item.id, 8921);
      expect(item.product, 'upsc-prelims-masterclass');
      expect(item.price, '499.00');
      expect(item.priceBeforeDiscounts, '999.00');
    });
  });

  group('ProductDto v3 parsing', () {
    test('resolves medium image from v3 images array', () {
      final json = {
        'id': 101,
        'title': 'Test Course',
        'slug': 'test-course',
        'price': '999.00',
        'images': [
          {
            'original': 'https://example.com/orig.png',
            'medium': 'https://example.com/med.png',
            'small': 'https://example.com/sm.png',
          },
        ],
      };

      final product = ProductDto.fromJson(json);
      expect(product.image, 'https://example.com/med.png');
      expect(product.thumbnailUrl, 'https://example.com/med.png');
    });

    test('falls back to original if medium is missing in images array', () {
      final json = {
        'id': 101,
        'title': 'Test Course',
        'slug': 'test-course',
        'price': '999.00',
        'images': [
          {'original': 'https://example.com/orig.png'},
        ],
      };

      final product = ProductDto.fromJson(json);
      expect(product.image, 'https://example.com/orig.png');
    });

    test('parses plans and plan_details in product detail payload', () {
      final json = {
        'id': 101,
        'title': 'Comprehensive Bundle',
        'slug': 'bundle',
        'price': '999.00',
        'plans': [
          {
            'id': 201,
            'product_id': 101,
            'name': 'Standard Access',
            'plan_detail_ids': [301, 302],
          },
        ],
        'plan_details': [
          {
            'id': 301,
            'duration_in_days': 180,
            'price': '599.00',
            'strike_through_price': '799.00',
          },
          {
            'id': 302,
            'duration_in_days': 365,
            'price': '999.00',
            'strike_through_price': '1499.00',
          },
        ],
      };

      final product = ProductDto.fromJson(json);
      expect(product.plans, hasLength(1));
      expect(product.plans.first.id, 201);
      expect(product.plans.first.planDetails, hasLength(2));
      expect(product.plans.first.planDetails[0].durationInDays, 180);
      expect(product.plans.first.planDetails[0].price, '599.00');
      expect(product.plans.first.planDetails[1].durationInDays, 365);
      expect(product.plans.first.planDetails[1].price, '999.00');
    });
  });

  group('UserInstallmentPlanDto', () {
    test('parses active installment plans response', () {
      final json = {
        'installment_plans': [
          {
            'id': 12,
            'price': '1500.00',
            'number_of_installments': 3,
            'period': 30,
            'display_name': '3-Part Plan',
            'installments': [],
          },
        ],
        'user_installment_plans': [
          {
            'id': 1,
            'installment_plan_id': 12,
            'paid_installment_count': 1,
            'next_due_amount': '500.00',
            'status': 'active',
          },
        ],
      };

      final res = InstallmentPlansResponseDto.fromJson(json);
      expect(res.installmentPlans, hasLength(1));
      expect(res.userInstallmentPlans, hasLength(1));

      final active = res.userInstallmentPlans.first;
      expect(active.id, 1);
      expect(active.installmentPlanId, 12);
      expect(active.paidInstallmentCount, 1);
      expect(active.nextDueAmount, '500.00');
      expect(active.status, 'active');
    });
  });

  group('StoreProductsResponseDto.fromJson v3', () {
    test(
      'parses and resolves sideloaded categories, plans, and plan details',
      () {
        final json = {
          'count': 1,
          'next': null,
          'previous': null,
          'results': {
            'products': [
              {
                'id': 101,
                'title': 'Test Course',
                'slug': 'test-course',
                'price': '999.00',
                'category_id': 4,
                'plan_ids': [201],
                'courses': [501],
              },
            ],
            'categories': [
              {'id': 4, 'name': 'General Studies', 'slug': 'general-studies'},
            ],
            'plans': [
              {
                'id': 201,
                'product_id': 101,
                'name': 'Annual Plan',
                'plan_detail_ids': [301],
              },
            ],
            'plan_details': [
              {'id': 301, 'duration_in_days': 365, 'price': '999.00'},
            ],
            'courses': [
              {'id': 501, 'title': 'Polity', 'slug': 'polity'},
            ],
          },
        };

        final response = StoreProductsResponseDto.fromJson(json);
        expect(response.products, hasLength(1));

        final product = response.products.first;
        expect(product.id, 101);
        expect(product.category, 'General Studies');
        expect(product.plans, hasLength(1));
        expect(product.plans.first.name, 'Annual Plan');
        expect(product.plans.first.planDetails, hasLength(1));
        expect(product.plans.first.planDetails.first.durationInDays, 365);
        expect(product.coursesDetails, hasLength(1));
        expect(product.coursesDetails.first.title, 'Polity');
      },
    );
  });
}
