## Why

Courses configured with a price of ₹0 (zero-priced or free courses) currently render as `"₹0.00"` in the mobile application store product cards and product detail screens. This differs from the web platform standard which displays a clear `"Free"` label. Presenting `"Free"` provides an intuitive, user-friendly experience for learners exploring free courses.

## What Changes

- Add localized `free` translation key in `packages/core` for supported languages (English, Tamil, Malayalam).
- Update Store Product Card (`ProductCard`) to render the localized "FREE" label when the product price evaluates to zero (`== 0`).
- Update Store Product Detail Screen (`ProductDetailScreen`) header pricing row to display "FREE" when product price evaluates to zero (`== 0`).
- Suppress or hide strike-through price when the primary price is free.

## Capabilities

### Modified Capabilities
- `store-store`: Update product card and product detail presentation requirements to render "Free" for zero-priced products instead of currency amount "₹0.00".

## Impact

- `packages/core`: `app_en.arb`, `app_ta.arb`, `app_ml.arb`, and generated localization files.
- `packages/courses`: `ProductCard` widget, `ProductDetailScreen`, and associated widget tests.
