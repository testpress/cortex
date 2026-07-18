## Context

The Flutter application (cortex) needs to integrate payment gateways to support the store checkout flow. The backend dictates which payment gateway should be used (Razorpay, Stripe, or PayU) based on the `currentPaymentApp` field in the Institute Settings API. The application must not store any secret keys locally. The client is responsible for initiating the correct third-party SDK and subsequently confirming the payment status with the backend.

## Goals / Non-Goals

**Goals:**
- Implement a `PaymentGatewayFactory` that decides which SDK to launch at runtime based on `currentPaymentApp`.
- Support PayU checkout including the required dynamic hash generation via the backend `/api/v2.5/payu/dynamic_hash/` endpoint.
- Support Razorpay checkout using the order ID and API key.
- Verify the final order status using the `/api/v2.5/orders/{order_id}/refresh/` endpoint to prevent client-side spoofing.

**Non-Goals:**
- Handling actual Stripe integration in this change (placeholder will be added, as the backend does not currently expose `stripe_client_secret` in the root JSON).
- Re-architecting the cart or checkout summary UI. This design focuses purely on the payment delegation and SDK invocation.

## Decisions

- **Gateway Delegation via Factory**: A `PaymentManager` or `PaymentGatewayFactory` class will take the `OrderDto` and launch the corresponding gateway handler. This decouples the UI from the specific payment SDK implementation.
- **PayU Hash Delegation**: To keep secrets off the client, the PayU handler will format the transaction data into a pipe-separated string (`key|txnid|amount|...`) and call the backend to generate the SHA-512 hash before launching the PayU SDK.
- **Server-Side Verification**: We will not trust the success callback from Razorpay or PayU. Instead, the final step for all successful gateway callbacks will be an HTTP POST to `/refresh/`. The UI will only show a success screen if this endpoint returns `{"status": "Completed"}`.

## Risks / Trade-offs

- **Risk**: The pipe-separated string for PayU hash generation is strict. Any mismatch in formatting will result in an invalid hash and failed checkout.
  **Mitigation**: We will ensure the `PayUHandler` precisely matches the order of fields expected by the backend and writes unit tests or manual verification specifically for this payload generation.
- **Risk**: Adding multiple payment SDKs (Razorpay, PayU) increases the app size.
  **Mitigation**: This is an acceptable trade-off for a multi-tenant platform that requires dynamic gateway support.
