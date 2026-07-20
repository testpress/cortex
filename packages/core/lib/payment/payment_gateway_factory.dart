import 'dart:async';
import 'package:flutter/foundation.dart';
import '../data/config/institute_settings.dart';
import '../data/models/store_models.dart';
import '../data/sources/data_source.dart';
import 'payment_handler.dart';
import 'payu_handler.dart';
import 'razorpay_handler.dart';

enum PaymentResultStatus { success, failed, pending, cancelled }

class PaymentResult {
  final PaymentResultStatus status;
  final String? message;

  PaymentResult({required this.status, this.message});
}

class PaymentGatewayFactory {
  final DataSource dataSource;
  PaymentHandler? _activeHandler;

  PaymentGatewayFactory({required this.dataSource});

  /// Dynamically select and start the payment flow
  Future<PaymentResult> startPayment(OrderDto order) async {
    final settings = InstituteSettings.current;
    final gateway = settings?.currentPaymentApp.toLowerCase() ?? '';

    if (gateway == 'razorpay') {
      _activeHandler = RazorpayHandler();
    } else if (gateway == 'stripe') {
      // TODO: Implement StripeHandler
      return PaymentResult(
        status: PaymentResultStatus.failed,
        message: 'Stripe is not currently supported in this version.',
      );
    } else {
      // Default to PayU
      _activeHandler = PayUHandler(
        generateHashCallback: (hashString) async {
          return await dataSource.generatePayUHash(hashString);
        },
      );
    }

    return _launchHandler(order);
  }

  Future<PaymentResult> _launchHandler(OrderDto order) async {
    if (_activeHandler == null) {
      return PaymentResult(
        status: PaymentResultStatus.failed,
        message: 'No handler initialized',
      );
    }

    final completer = Completer<PaymentResult>();
    final PaymentResult result;

    try {
      await _activeHandler!.startPayment(
        order: order,
        onResult: (status, message) {
          if (!completer.isCompleted) {
            if (status == 'Completed') {
              completer.complete(
                PaymentResult(
                  status: PaymentResultStatus.success,
                  message: message,
                ),
              );
            } else if (status == 'Cancelled') {
              completer.complete(
                PaymentResult(
                  status: PaymentResultStatus.cancelled,
                  message: message,
                ),
              );
            } else {
              completer.complete(
                PaymentResult(
                  status: PaymentResultStatus.failed,
                  message: message,
                ),
              );
            }
          }
        },
      );

      result = await completer.future;
    } finally {
      _activeHandler?.dispose();
      _activeHandler = null;
    }

    // Verify the payment status with our backend if the SDK reported success
    if (result.status == PaymentResultStatus.success) {
      try {
        final refreshedOrder = await dataSource.refreshOrderStatus(order.id);
        if (refreshedOrder.status == 'Completed') {
          return PaymentResult(
            status: PaymentResultStatus.success,
            message: 'Payment verified successfully',
          );
        } else {
          return PaymentResult(
            status: PaymentResultStatus.pending,
            message: 'Payment is processing: ${refreshedOrder.status}',
          );
        }
      } catch (e, stackTrace) {
        debugPrint('Payment verification error: $e\n$stackTrace');
        return PaymentResult(
          status: PaymentResultStatus.failed,
          message: 'Failed to verify payment with server',
        );
      }
    }

    return result;
  }
}
