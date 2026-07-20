import 'package:flutter/foundation.dart';
import 'package:payu_checkoutpro_flutter/payu_checkoutpro_flutter.dart';
import 'package:payu_checkoutpro_flutter/PayUConstantKeys.dart';
import '../data/models/store_models.dart';
import 'payment_handler.dart';

class PayUHandler implements PaymentHandler, PayUCheckoutProProtocol {
  late PayUCheckoutProFlutter _checkoutPro;
  Function(String status, String? message)? _onResult;
  final Future<String> Function(String hashString) generateHashCallback;

  PayUHandler({required this.generateHashCallback}) {
    _checkoutPro = PayUCheckoutProFlutter(this);
  }

  @override
  Future<void> startPayment({
    required OrderDto order,
    required Function(String status, String? message) onResult,
  }) async {
    _onResult = onResult;

    final apiKey = order.apiKey;
    final orderId = order.orderId;
    final amount = order.total; // e.g. "500.00"
    final productInfo = order.productInfo ?? 'product';

    if (apiKey == null || orderId == null) {
      _onResult?.call('Failed', 'Missing API Key or Order ID for PayU');
      return;
    }

    final Map<String, Object> payUPaymentParams = {
      PayUPaymentParamKey.key: apiKey,
      PayUPaymentParamKey.transactionId: orderId,
      PayUPaymentParamKey.amount: amount,
      PayUPaymentParamKey.productInfo: productInfo,
      PayUPaymentParamKey.firstName: order.name ?? 'User',
      PayUPaymentParamKey.email: order.email ?? 'user@example.com',
      PayUPaymentParamKey.phone: order.phone ?? '9999999999',
      PayUPaymentParamKey.ios_surl: 'https://payu.herokuapp.com/ios_success',
      PayUPaymentParamKey.ios_furl: 'https://payu.herokuapp.com/ios_failure',
      PayUPaymentParamKey.android_surl: 'https://payu.herokuapp.com/success',
      PayUPaymentParamKey.android_furl: 'https://payu.herokuapp.com/failure',
      PayUPaymentParamKey.environment: (order.pgUrl?.contains('test') ?? false)
          ? "1"
          : "0",
    };

    try {
      _checkoutPro.openCheckoutScreen(
        payUPaymentParams: payUPaymentParams,
        payUCheckoutProConfig: <String, dynamic>{},
      );
    } catch (e, stackTrace) {
      debugPrint('PayU openCheckoutScreen error: $e\n$stackTrace');
      _onResult?.call('Failed', 'Failed to open PayU');
    }
  }

  @override
  void generateHash(Map response) async {
    final hashName = response[PayUHashConstantsKeys.hashName];
    final hashString = response[PayUHashConstantsKeys.hashString];

    try {
      final generatedHash = await generateHashCallback(hashString.toString());
      _checkoutPro.hashGenerated(
        hash: <String, String>{hashName.toString(): generatedHash},
      );
    } catch (e, stackTrace) {
      debugPrint('PayU generateHash error: $e\n$stackTrace');
      _checkoutPro.hashGenerated(
        hash: <String, String>{hashName.toString(): ''},
      );
    }
  }

  @override
  void onPaymentSuccess(dynamic response) {
    _onResult?.call('Completed', 'Success');
  }

  @override
  void onPaymentFailure(dynamic response) {
    debugPrint('PayU onPaymentFailure: $response');
    _onResult?.call('Failed', 'Payment failed');
  }

  @override
  void onPaymentCancel(Map? isCancel) {
    _onResult?.call('Cancelled', 'Payment cancelled');
  }

  @override
  void onError(Map? errorResponse) {
    debugPrint('PayU onError: $errorResponse');
    _onResult?.call('Failed', 'Payment error');
  }

  @override
  void dispose() {
    _onResult = null;
  }
}
