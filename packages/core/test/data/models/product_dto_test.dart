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
}
