# store-checkout Specification

## Purpose
TBD - created by archiving change store-product-features. Update Purpose after archive.
## Requirements
### Requirement: Apply Coupon to Draft Order
The system SHALL always display a coupon / promo code input field during checkout, regardless of any product flag. The system SHALL apply the coupon via `PUT /api/v3/orders/{order_id}/apply-discount/` with `{"code": "<code>"}`.

#### Scenario: Coupon Applied
- **WHEN** user enters a valid coupon code and taps apply
- **THEN** system creates a draft order (or reuses the existing one) and applies the coupon via PUT

#### Scenario: Cached Order ID
- **WHEN** user applies a coupon while a draft order already exists
- **THEN** system reuses the existing draft order ID rather than creating a new order

#### Scenario: Invalid coupon code
- **WHEN** user enters an invalid or expired coupon code
- **THEN** system displays an error message and the order total remains unchanged

### Requirement: Show Auto-Applied Discount Savings
The system SHALL display a savings banner when an automatic discount (user-specific or repeat-purchase) has been applied at order creation time.

#### Scenario: User has an automatic discount
- **WHEN** an order is created and `order_items[0].price_before_discounts > order_items[0].price`
- **THEN** the checkout screen SHALL show a strikethrough original price and a highlighted discounted price with a savings message

#### Scenario: No automatic discount
- **WHEN** `order_items[0].price_before_discounts == order_items[0].price`
- **THEN** the checkout screen SHALL show only the standard price with no savings banner

