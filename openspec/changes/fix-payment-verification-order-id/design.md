## Context

In the payment checkout flow, when a user completes a transaction on a payment gateway (such as Razorpay), the client executes `refreshOrderStatus` to verify payment completion directly with the Testpress backend.

The backend endpoint `/api/v2.5/orders/<order_id>/refresh/` expects the payment gateway's order string identifier. Previously, the client passed the internal database integer ID, causing the backend to return `404 Not Found`. Additionally, the refresh endpoint returns a minimal status payload (`{"status": "Completed"}`), which previously caused deserialization errors when fields like `id` were treated as non-nullable integers without default values.

## Goals / Non-Goals

**Goals:**
- Update `ApiEndpoints.refreshOrder` to format endpoints with a `String orderId`.
- Update `DataSource.refreshOrderStatus` signature in `DataSource`, `HttpDataSource`, and `MockDataSource` to accept `String orderId`.
- Ensure `PaymentGatewayFactory` forwards `order.orderId ?? order.id.toString()` to `refreshOrderStatus`.
- Make `OrderDto.fromJson` resilient to minimal status payloads by providing a default fallback for omitted `id`.
- Update corresponding unit tests and mocks in `packages/core`.

**Non-Goals:**
- Modifying backend verification endpoints or Razorpay webhook architectures.
- Changing other order endpoints that legitimately use database PKs (e.g., `createOrder`, `confirmOrder`).

## Decisions

- **Decision 1: Accept `String orderId` in `refreshOrderStatus`**
  - *Rationale*: Gateway order identifiers (such as Razorpay's order ID or PayU's transaction ID) are strings. Accepting `String` accommodates both gateway string IDs and fallback stringified integer IDs without type coercion at call sites.
- **Decision 2: Fallback in `PaymentGatewayFactory`**
  - *Rationale*: Use `order.orderId ?? order.id.toString()` so that if `orderId` is present (the standard case after `confirmOrder`), the gateway ID is used; if absent, it falls back cleanly to the stringified integer ID.
- **Decision 3: Make `id` in `OrderDto.fromJson` optional with fallback**
  - *Rationale*: The backend `/refresh/` endpoint returns only `{"status": "Completed"}`. Safely defaulting `id` to `0` prevents deserialization runtime type exceptions when parsing status-only payloads.

## Risks / Trade-offs

- **[Risk]** Existing unit tests or mocks calling `refreshOrderStatus` with integers could break on type mismatch.
  - **Mitigation**: Update all mock implementations and test invocations across `packages/core` to pass `String` arguments.
