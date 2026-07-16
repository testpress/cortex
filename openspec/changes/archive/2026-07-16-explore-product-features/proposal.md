## Why

The Explore section is being expanded to support a complete checkout and product discovery experience. This requires introducing new API surfaces to handle order creation, coupon application, and installment plans, as well as updating the UI to display the curriculum and support these new payment capabilities.

## What Changes

- Add API surface for `createOrder`, `applyCoupon`, `getInstallmentPlans`, and `getProduct`.
- Introduce a new "Curriculum" tab on the product detail screen to list included courses and their statistics.
- Introduce a new Coupon application flow (BottomSheet UI) that creates a draft order and applies a discount code.
- Introduce an Installment Plans flow (BottomSheet UI) that allows users to view and select payment installment options for a product.
- **BREAKING**: Product detail view is no longer a static presentation; it now has stateful tabs and payment action sheets.

## Capabilities

### New Capabilities
- `explore-checkout`: Capability covering the order creation and coupon application flow.
- `explore-installments`: Capability covering the installment plans presentation and selection.
- `explore-curriculum`: Capability covering the display of course curriculum and product statistics.

### Modified Capabilities
- `explore-store`: Updating the product detail view requirements to accommodate tabs and checkout CTAs.

## Impact

- **Code**: Adds stateful UI components (`ProductDiscountSheet`, `ProductInstallmentSheet`, `ProductExpandableCourseCard`) to `packages/courses`.
- **APIs**: Extends `DataSource` and `ExploreRepository` with checkout-related endpoints.
- **Systems**: Modifies Riverpod providers to manage draft order caching and asynchronous checkout states.
