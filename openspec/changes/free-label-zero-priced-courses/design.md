## Context

On the mobile app, store products display prices as `'₹${product.price}'` unconditionally in `ProductCard` and `ProductDetailScreen`. When a product is configured with zero price (`0.00` or `0`), it displays "₹0.00", whereas the web platform displays "Free".

## Goals / Non-Goals

**Goals:**
- Provide a localized "Free" string across English, Tamil, and Malayalam.
- Introduce helper logic / check to identify zero-priced products (`isFree` or numeric check).
- Display "Free" instead of "₹0.00" on `ProductCard` and `ProductDetailScreen`.
- Hide strikethrough price when the product is free.
- Keep card heights and layout constraints intact.

**Non-Goals:**
- Changing payment gateway processing or zero-cost order flows (which already handle free/zero checkout).
- Modifying course detail screens outside of the store module.

## Decisions

1. **Localization in `core`:**
   - Add `"free": "Free"` to `packages/core/lib/l10n/app_en.arb`, `"இலவசம்"` to `app_ta.arb`, and `"സൗജന്യം"` to `app_ml.arb`.
   - Use `L10n.of(context).free` in the UI widgets.

2. **Price Formatting Helper or Extension on `ProductDto`:**
   - Add a getter `bool get isFree => double.tryParse(price.replaceAll(',', '')) == 0;` on `ProductDto` so widgets have a single source of truth for free vs paid evaluation.

3. **Strikethrough Price Handling:**
   - In `ProductCard` and `ProductDetailScreen`, check `!product.isFree` before displaying `product.strikeThroughPrice`.

## Risks / Trade-offs

- **[Risk]** Parsing string numbers with comma or unexpected formats.
  - **Mitigation**: Use `double.tryParse(price.replaceAll(',', ''))` or fallback gracefully to paid if unparseable.
