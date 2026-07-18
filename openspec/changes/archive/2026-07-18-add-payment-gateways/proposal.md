## Why

The application currently lacks a unified payment gateway integration in the Flutter client. To allow users to purchase store items and courses securely, we need to implement a dynamic payment architecture that supports Razorpay, Stripe, and PayU. The backend dynamically assigns which gateway to use via the Institute Settings API. This change will build the Flutter SDK wrappers and the factory pattern to handle this dynamic selection seamlessly and securely, ensuring no sensitive secrets are stored on the mobile device.

## What Changes

- Add a dynamic `PaymentGatewayFactory` to route to the correct payment SDK based on the `currentPaymentApp` institute setting.
- Integrate the Razorpay checkout flow (using `razorpay_flutter` or similar).
- Integrate the PayU checkout flow (using `payu_checkoutpro` or similar), including the custom dynamic hash generation step required by the backend.
- Update `api_endpoints.dart` to point to the correct order creation (`v3`), confirmation (`v2.4`), refresh (`v2.5`), and PayU hash (`v2.5`) endpoints.
- Update `OrderDto` to support parsing public `apiKey` and `productInfo` from the order creation response.
- Add payment verification logic post-checkout to ensure the app checks the true status with the backend before granting access.

## Capabilities

### New Capabilities
- `payment-gateways`: Covers the factory pattern, SDK initialization, and API interactions for Razorpay and PayU checkout flows.

### Modified Capabilities
- `store-checkout`: The existing store checkout process will now rely on this dynamic payment gateway flow rather than any hardcoded logic.

## Impact

- **Network Layer**: `ApiEndpoints`, `HttpDataSource` (or a new `PaymentDataSource`).
- **Models**: `OrderDto`, `InstituteSettings`.
- **Dependencies**: Addition of new Flutter plugins (`razorpay_flutter`, `payu_checkoutpro`).
- **User Flow**: The checkout confirmation screen will now hand off to a third-party UI before returning and verifying the purchase.
