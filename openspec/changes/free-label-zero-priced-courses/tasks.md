## 1. Localization & Model Helper

- [x] 1.1 Add `free` translation key to `packages/core/lib/l10n/app_en.arb`, `app_ta.arb`, and `app_ml.arb`, and run `flutter gen-l10n`
- [x] 1.2 Add `isFree` getter to `ProductDto` in `packages/core/lib/data/models/store_models.dart`

## 2. UI Updates

- [x] 2.1 Update `ProductCard` in `packages/courses/lib/widgets/store/product_card.dart` to display `L10n.of(context).free` and omit strikethrough price when `product.isFree`
- [x] 2.2 Update `ProductDetailScreen` in `packages/courses/lib/screens/store/product_detail_screen.dart` to display `L10n.of(context).free` and omit strikethrough price when `product.isFree`

## 3. Testing & Verification

- [x] 3.1 Update and add test cases in `packages/courses/test/widgets/store/product_card_test.dart` for free and paid products
- [x] 3.2 Update and add test cases in `packages/courses/test/screens/store/product_detail_screen_test.dart` for free products
- [x] 3.3 Run Flutter analyzer and test suite to ensure all tests pass
