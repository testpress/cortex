import '../data/models/explore_models.dart';

/// Abstract base class for payment gateway handlers
abstract class PaymentHandler {
  /// Initialize the payment gateway with necessary options
  Future<void> startPayment({
    required OrderDto order,
    required Function(String status, String? message) onResult,
  });

  /// Dispose any resources or listeners
  void dispose();
}
