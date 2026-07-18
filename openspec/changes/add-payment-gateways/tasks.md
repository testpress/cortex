## 1. Network Layer & Models

- [x] 1.1 Update `ApiEndpoints` class with `/api/v3/orders/`, `/api/v2.4/orders/{id}/confirm/`, `/api/v2.5/orders/{id}/refresh/`, and `/api/v2.5/payu/dynamic_hash/`
- [x] 1.2 Update `OrderDto` model to deserialize `apiKey` and `productInfo`
- [x] 1.3 Add `currentPaymentApp` field to `InstituteSettings` model

## 2. API Data Source

- [x] 2.1 Add `confirmOrder(orderId, details)` to `HttpDataSource`
- [x] 2.2 Add `refreshOrderStatus(orderId)` to `HttpDataSource`
- [x] 2.3 Add `generatePayUHash(hashString)` to `HttpDataSource`

## 3. Payment Handlers Setup

- [x] 3.1 Create `PaymentGatewayFactory` logic to determine gateway from `InstituteSettings`
- [x] 3.2 Implement `RazorpayHandler` to launch Razorpay UI with API key and Order ID
- [x] 3.3 Implement `PayUHandler` to format transaction string, request hash, and launch PayU UI
- [x] 3.4 Wire gateway callbacks to call `refreshOrderStatus` on completion
