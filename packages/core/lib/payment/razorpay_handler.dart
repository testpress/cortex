import 'package:flutter/foundation.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../data/models/explore_models.dart';
import 'payment_handler.dart';

class RazorpayHandler implements PaymentHandler {
  late Razorpay _razorpay;
  Function(String status, String? message)? _onResult;

  RazorpayHandler() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Future<void> startPayment({
    required OrderDto order,
    required Function(String status, String? message) onResult,
  }) async {
    _onResult = onResult;

    final apiKey = order.apiKey;
    final orderId = order.orderId;

    if (apiKey == null || orderId == null) {
      _onResult?.call('Failed', 'Missing API Key or Order ID for Razorpay');
      return;
    }

    // Convert total from string (e.g. "500.00") to integer paise (50000)
    int amountInPaise = 0;
    try {
      final double total = double.parse(order.total);
      amountInPaise = (total * 100).toInt();
    } catch (e) {
      debugPrint('Error parsing order total: $e');
      _onResult?.call('Failed', 'Invalid order amount');
      return;
    }

    var options = {
      'key': apiKey,
      'amount': amountInPaise,
      'order_id': orderId,
      'name': order.name ?? 'Store Purchase',
      'description': order.productInfo ?? '',
      'prefill': {
        'contact': order.phone ?? '',
        'email': order.email ?? '',
        'name': order.name ?? '',
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error opening Razorpay checkout: $e');
      _onResult?.call('Failed', 'Failed to open Razorpay');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint("Razorpay Success: ${response.paymentId}");
    _onResult?.call('Completed', response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint("Razorpay Error: ${response.code} - ${response.message}");
    _onResult?.call('Failed', response.message ?? 'Payment failed');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint("Razorpay External Wallet: ${response.walletName}");
    // Handling external wallets is usually similar to success, but requires careful verification
    _onResult?.call('Completed', response.walletName);
  }

  @override
  void dispose() {
    _razorpay.clear();
    _onResult = null;
  }
}
