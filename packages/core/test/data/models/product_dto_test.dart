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
  });
}
