## Why

When a user completes a course purchase through a payment gateway (such as Razorpay), the mobile app verifies the transaction status with the backend before unlocking access. Previously, the client passed the internal database integer ID instead of the payment gateway's order string identifier, and the data model required full order fields when parsing minimal refresh responses. This caused successful payments to mistakenly display a "Payment Failed" screen.

## What Changes

- Update `ApiEndpoints.refreshOrder` and `DataSource.refreshOrderStatus` to accept a string order identifier instead of an integer.
- Pass the gateway order identifier (`order.orderId`) in `PaymentGatewayFactory` when verifying order status with the backend.
- Ensure `OrderDto.fromJson` gracefully handles minimal status-only responses where full order fields (such as database ID) are omitted.
- Update tests and mocks to cover string identifiers and minimal refresh response payloads.

## Capabilities

### Modified Capabilities
- `payment-gateways`: Server-side payment verification uses the payment gateway's order string identifier and handles status refresh responses.

## Impact

- Affected packages: `packages/core` (`ApiEndpoints`, `DataSource`, `HttpDataSource`, `MockDataSource`, `OrderDto`, `PaymentGatewayFactory`).
- Affected tests: `packages/core` unit tests, mocks, and model tests.
