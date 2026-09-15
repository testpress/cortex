## 1. Network & Data Layer

- [x] 1.1 Update `ApiEndpoints.refreshOrder(String orderId)` in `packages/core/lib/network/api_endpoints.dart` to accept a `String` parameter.
- [x] 1.2 Update `DataSource.refreshOrderStatus(String orderId)` interface in `packages/core/lib/data/sources/data_source.dart`.
- [x] 1.3 Update `HttpDataSource.refreshOrderStatus` implementation in `packages/core/lib/data/sources/http_data_source.dart`.
- [x] 1.4 Update `MockDataSource.refreshOrderStatus` implementation in `packages/core/lib/data/sources/mock_data_source.dart`.
- [x] 1.5 Update `OrderDto.fromJson` in `packages/core/lib/data/models/store_models.dart` to safely handle status-only responses where `id` is omitted.

## 2. Payment Gateway Factory

- [x] 2.1 Update `PaymentGatewayFactory._launchHandler` in `packages/core/lib/payment/payment_gateway_factory.dart` to pass `order.orderId ?? order.id.toString()` to `refreshOrderStatus`.

## 3. Verification & Tests

- [x] 3.1 Update unit tests and mocks in `packages/core` to reflect the `String` parameter.
- [x] 3.2 Add unit tests for `OrderDto.fromJson` to verify parsing of minimal refresh responses.
- [x] 3.3 Run test suite in `packages/core` to ensure all tests pass cleanly.
