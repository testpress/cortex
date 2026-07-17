import 'package:flutter/material.dart';

import '../core.dart';
import '../data/data.dart';

class PaymentProcessingScreen extends StatefulWidget {
  final Future<OrderDto> Function() createOrder;
  final DataSource dataSource;

  const PaymentProcessingScreen({
    super.key,
    required this.createOrder,
    required this.dataSource,
  });

  static Future<PaymentResult?> start(
    BuildContext context,
    Future<OrderDto> Function() createOrder,
    DataSource dataSource,
  ) {
    return Navigator.of(context).push<PaymentResult>(
      MaterialPageRoute(
        builder: (_) => PaymentProcessingScreen(
          createOrder: createOrder,
          dataSource: dataSource,
        ),
      ),
    );
  }

  @override
  State<PaymentProcessingScreen> createState() =>
      _PaymentProcessingScreenState();
}

class _PaymentProcessingScreenState extends State<PaymentProcessingScreen> {
  late PaymentGatewayFactory _factory;
  bool _hasStartedPayment = false;
  PaymentResult? _result;

  @override
  void initState() {
    super.initState();
    _factory = PaymentGatewayFactory(dataSource: widget.dataSource);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startPayment();
    });
  }

  Future<void> _startPayment() async {
    if (_hasStartedPayment) return;
    _hasStartedPayment = true;

    try {
      final order = await widget.createOrder();

      if (order.status == 'Completed') {
        if (mounted) {
          setState(() {
            _result = PaymentResult(
              status: PaymentResultStatus.success,
              message: 'Successfully enrolled!',
            );
          });
        }
        return;
      }

      final result = await _factory.startPayment(order);
      if (mounted) {
        setState(() {
          _result = result;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _result = PaymentResult(
            status: PaymentResultStatus.failed,
            message: e.toString(),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(design.spacing.xl),
            child: _buildContent(context, design),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, DesignConfig design) {
    if (_result == null) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppLoadingIndicator(),
          SizedBox(height: 24),
          Text(
            'Processing your payment...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        ],
      );
    }

    final isSuccess = _result!.status == PaymentResultStatus.success;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          isSuccess ? Icons.check_circle : Icons.cancel,
          size: 80,
          color: isSuccess ? design.colors.success : design.colors.error,
        ),
        SizedBox(height: design.spacing.xl),
        AppText.title(isSuccess ? 'Payment Successful!' : 'Payment Failed'),
        SizedBox(height: design.spacing.sm),
        AppText.body(
          isSuccess
              ? 'Your enrollment has been confirmed successfully.'
              : (_result!.message ?? 'Something went wrong. Please try again.'),
          color: design.colors.textSecondary,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: design.spacing.xxl),
        if (isSuccess) ...[
          AppButton(
            label: 'Start Learning',
            fullWidth: true,
            onPressed: () => context.go('/study'),
          ),
          SizedBox(height: design.spacing.md),
          AppButton.secondary(
            label: 'Back to Home',
            fullWidth: true,
            onPressed: () => context.go('/home'),
          ),
        ] else ...[
          AppButton(
            label: 'Try Again',
            fullWidth: true,
            onPressed: () => Navigator.of(context).pop(_result),
          ),
          SizedBox(height: design.spacing.md),
          AppButton.secondary(
            label: 'Cancel',
            fullWidth: true,
            onPressed: () => Navigator.of(context).pop(_result),
          ),
        ],
      ],
    );
  }
}
