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
      AppRoute(
        page: PaymentProcessingScreen(
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

    return PopScope(
      canPop: _result != null && _result!.status != PaymentResultStatus.success,
      child: Material(
        color: design.colors.canvas,
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(design.spacing.xl),
              child: _buildContent(context, design),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, DesignConfig design) {
    if (_result == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AppLoadingIndicator(),
          const SizedBox(height: 24),
          AppText.body(
            L10n.of(context).paymentProcessing,
            color: design.colors.textSecondary,
          ),
        ],
      );
    }

    final status = _result!.status;
    final isSuccess = status == PaymentResultStatus.success;
    final isPending = status == PaymentResultStatus.pending;
    final isCancelled = status == PaymentResultStatus.cancelled;

    IconData icon;
    Color iconColor;
    String title;
    String description;

    if (isSuccess) {
      icon = LucideIcons.checkCircle2;
      iconColor = design.colors.success;
      title = L10n.of(context).paymentSuccessful;
      description = L10n.of(context).paymentSuccessDescription;
    } else if (isPending) {
      icon = LucideIcons.clock;
      iconColor = design.colors.warning;
      title = L10n.of(context).paymentPending;
      description =
          _result!.message ?? L10n.of(context).paymentPendingDescription;
    } else if (isCancelled) {
      icon = LucideIcons.minusCircle;
      iconColor = design.colors.textSecondary;
      title = L10n.of(context).paymentCancelled;
      description =
          _result!.message ?? L10n.of(context).paymentCancelledDescription;
    } else {
      icon = LucideIcons.xCircle;
      iconColor = design.colors.error;
      title = L10n.of(context).paymentFailed;
      description =
          _result!.message ?? L10n.of(context).paymentFailedDescription;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 80, color: iconColor),
        SizedBox(height: design.spacing.xl),
        AppSemantics.header(label: title, child: AppText.title(title)),
        SizedBox(height: design.spacing.sm),
        AppText.body(
          description,
          color: design.colors.textSecondary,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: design.spacing.xxl),
        if (isSuccess) ...[
          AppButton(
            label: L10n.of(context).paymentStartLearning,
            fullWidth: true,
            onPressed: () => context.go('/study'),
          ),
          SizedBox(height: design.spacing.md),
          AppButton.secondary(
            label: L10n.of(context).paymentBackToHome,
            fullWidth: true,
            onPressed: () => context.go('/home'),
          ),
        ] else ...[
          AppButton(
            label: L10n.of(context).paymentTryAgain,
            fullWidth: true,
            onPressed: () => Navigator.of(context).pop(_result),
          ),
          SizedBox(height: design.spacing.md),
          AppButton.secondary(
            label: L10n.of(context).paymentCancel,
            fullWidth: true,
            onPressed: () => Navigator.of(context).pop(_result),
          ),
        ],
      ],
    );
  }
}
