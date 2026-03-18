import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _otpController = TextEditingController();
  bool _isBusy = false;
  String? _errorMessage;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Scaffold(
      backgroundColor: design.colors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft, color: design.colors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: design.spacing.xl, vertical: design.spacing.md),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - design.spacing.xl * 2),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppText.headline('Verify Your Number'),
                      SizedBox(height: design.spacing.xs),
                      AppText.body(
                        'Enter the 4-digit code we sent you.',
                        color: design.colors.textSecondary,
                      ),
                      SizedBox(height: design.spacing.xxl),
                      AppTextField(
                        label: 'OTP Code',
                        hintText: '----',
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        autofocus: true,
                      ),
                      if (_errorMessage != null) ...[
                        SizedBox(height: design.spacing.md),
                        AppText.bodySmall(_errorMessage!, color: design.colors.error),
                      ],
                      const Spacer(),
                      SizedBox(height: design.spacing.xxl),
                      if (_isBusy)
                        const Center(child: AppLoadingIndicator())
                      else
                        AppButton.primary(
                          label: 'Verify & Continue',
                          fullWidth: true,
                          onPressed: _handleVerifyOtp,
                        ),
                      SizedBox(height: design.spacing.xl),
                      Center(
                        child: GestureDetector(
                          onTap: () {},
                          child: AppText.body(
                            'Resend Code',
                            color: design.colors.primary,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleVerifyOtp() async {
    final l10n = L10n.of(context);
    final otp = _otpController.text.trim();

    if (otp.isEmpty) {
      setState(() { _errorMessage = l10n.loginErrorPhoneOtpRequired; });
      return;
    }

    if (_isBusy) return;
    setState(() {
      _isBusy = true;
      _errorMessage = null;
    });

    try {
      await ref.read(authProvider.notifier).verifyOtp(
        otp: otp,
        phoneNumber: widget.phoneNumber,
      );
      if (mounted) context.go('/home');
    } on AuthException catch (error) {
      if (mounted) setState(() => _errorMessage = error.message);
    } catch (_) {
      if (mounted) setState(() => _errorMessage = l10n.loginErrorGenericRequest);
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }
}
