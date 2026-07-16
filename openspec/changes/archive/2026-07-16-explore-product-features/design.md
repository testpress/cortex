## Context

The Explore screen currently presents static product information. We need to introduce checkout flows, including coupon application and installment plan viewing, along with dynamic curriculum data. These changes span both the network layer (new APIs) and the presentation layer (complex stateful widgets in BottomSheets).

## Goals / Non-Goals

**Goals:**
- Implement stateful UI sheets for Coupons and Installments without breaking the existing static layout.
- Decouple the UI completely from the raw `core/data/data.dart` package by exclusively using DTOs exported from `core/core.dart`.
- Ensure checkout operations (like creating draft orders) are cached correctly during the user session to prevent duplicate network calls.

**Non-Goals:**
- Completing the actual final payment gateway integration (this design stops at the "Checkout Coming Soon" stage for the final step).
- Major visual overhaul of the rest of the application outside the product detail screen.

## Decisions

1. **State Management via Riverpod**:
   - We will use `StateNotifierProvider` (e.g. `productDiscountNotifierProvider`) to manage asynchronous checkout processes (like applying a coupon).
   - *Rationale*: Allows easy error handling (loading, success, failure) and caching of the draft `orderId`.

2. **Strict SDK Boundary Enforcement**:
   - `packages/courses` will only import `package:core/core.dart`.
   - *Rationale*: Prevents leaking `DataSource` and `AppDatabase` implementations into the domain/UI layer.

3. **BottomSheet Architecture for Actions**:
   - Coupons and Installment Plans will be presented as modal bottom sheets (`ProductDiscountSheet`, `ProductInstallmentSheet`).
   - *Rationale*: Keeps the main `ProductDetailScreen` clean and focuses the user on a single checkout action at a time without navigating away.

4. **Localization Strategy**:
   - All text must be extracted to `.arb` files. Instead of complex ICU ordinal formatting for things like "1st Installment", we will use language-neutral strings like "Installment {installment}" to simplify translations across Arabic, Malayalam, and Tamil.

## Risks / Trade-offs

- **Risk: Duplicate Order Creation** → *Mitigation*: The `ProductDiscountNotifier` will aggressively cache the `_orderId` once a draft order is successfully created by `createOrder`.
- **Risk: UI State Desync** → *Mitigation*: By lifting state into scoped Riverpod providers keyed by `productSlug`, we ensure the bottom sheets always read the latest, correct state.
