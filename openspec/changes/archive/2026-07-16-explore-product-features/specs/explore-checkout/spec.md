## ADDED Requirements

### Requirement: Apply Coupon to Draft Order
The system SHALL allow users to apply a coupon code to a product by creating a draft order and verifying the coupon.

#### Scenario: Coupon Applied
- **WHEN** user enters a valid coupon code and taps apply
- **THEN** system creates a draft order and applies the coupon

#### Scenario: Cached Order ID
- **WHEN** user applies a second coupon
- **THEN** system reuses the existing draft order ID rather than creating a new order
