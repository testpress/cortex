import 'dart:async';
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/login_branding.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({
    super.key,
    required this.phoneNumber,
    required this.countryCode,
  });

  final String phoneNumber;
  final String countryCode;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _otpController = TextEditingController();
  bool _isBusy = false;
  String? _errorMessage;
  String? _successMessage;

  Timer? _timer;
  int _timerSeconds = 30;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _timerSeconds = 30;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        setState(() {
          _timerSeconds--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  String get _formattedTime {
    final minutes = (_timerSeconds / 60).floor().toString().padLeft(2, '0');
    final seconds = (_timerSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String get _maskedPhoneNumber {
    final num = widget.phoneNumber;
    if (num.length <= 5) return num;
    final stars = '*' * (num.length - 5);
    return '${num.substring(0, 2)}$stars${num.substring(num.length - 3)}';
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Scaffold(
      backgroundColor: design.colors.surface,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: const Alignment(0, -0.2),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const LoginBranding(),
                    SizedBox(height: design.spacing.xxl),
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxWidth: 400),
                      padding: EdgeInsets.all(design.spacing.lg),
                      decoration: BoxDecoration(
                        color: design.colors.card,
                        borderRadius: design.radius.card,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppSemantics.header(
                            label: l10n.loginVerifyOtpTitle,
                            child: AppText.display(
                              l10n.loginVerifyOtpTitle,
                              textAlign: TextAlign.left,
                            ),
                          ),
                          SizedBox(height: design.spacing.sm),
                          AppText.cardTitle(
                            l10n.loginOtpVerifySubtitle(_maskedPhoneNumber),
                            color: design.colors.textSecondary,
                          ),
                          SizedBox(height: design.spacing.xl),
                          AppOtpInput(
                            controller: _otpController,
                            length: 4,
                            onCompleted: (_) => _handleVerifyOtp(),
                          ),
                          if (_errorMessage != null) ...[
                            SizedBox(height: design.spacing.md),
                            AppText.bodySmall(
                              _errorMessage!,
                              color: design.colors.error,
                              textAlign: TextAlign.center,
                            ),
                          ],
                          if (_successMessage != null) ...[
                            SizedBox(height: design.spacing.md),
                            AppText.bodySmall(
                              _successMessage!,
                              color: design.colors.success,
                              textAlign: TextAlign.center,
                            ),
                          ],
                          SizedBox(height: design.spacing.xxl),
                          if (_isBusy)
                            const Center(child: AppLoadingIndicator())
                          else
                            AppButton.primary(
                              label: l10n.loginVerify,
                              fullWidth: true,
                              onPressed: _handleVerifyOtp,
                            ),
                          SizedBox(height: design.spacing.md),
                          Center(
                            child: _timerSeconds > 0
                                ? AppText.cardTitle(
                                    l10n.loginResendCodeIn(_formattedTime),
                                    color: design.colors.textSecondary,
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      AppText.labelBold(
                                        l10n.loginDidntReceiveCode,
                                        color: design.colors.textSecondary,
                                      ),
                                      AppSemantics.button(
                                        label: l10n.loginResend,
                                        onTap: _handleResendOtp,
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: _handleResendOtp,
                                          child: AppText.labelBold(
                                            l10n.loginResend,
                                            color: design.colors.primary,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (context.canPop())
              Positioned(
                top: design.spacing.md,
                left: design.spacing.md,
                child: AppSemantics.button(
                  label: 'Go back',
                  onTap: () => context.pop(),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => context.pop(),
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: Center(
                        child: Icon(
                          LucideIcons.arrowLeft,
                          color: design.colors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleResendOtp() async {
    if (_isBusy) return;

    setState(() {
      _errorMessage = null;
      _successMessage = null;
      _isBusy = true;
    });

    try {
      await ref
          .read(authProvider.notifier)
          .generateOtp(
            phoneNumber: widget.phoneNumber,
            countryCode: widget.countryCode,
          );
      if (mounted) {
        setState(() => _successMessage = L10n.of(context).loginResendSuccess);
        _startTimer();
      }
    } catch (_) {
      if (mounted) {
        setState(() => _errorMessage = L10n.of(context).loginResendFailed);
      }
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _handleVerifyOtp() async {
    final l10n = L10n.of(context);
    final otp = _otpController.text.trim();

    if (otp.isEmpty || otp.length < 4) {
      setState(() {
        _errorMessage = l10n.loginOtpError;
      });
      return;
    }

    if (_isBusy) return;
    setState(() {
      _isBusy = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      await ref
          .read(authProvider.notifier)
          .verifyOtp(otp: otp, phoneNumber: widget.phoneNumber);
      if (mounted) context.go('/home');
    } on ParallelLoginException catch (e) {
      if (mounted) {
        final success = await context.push<bool>(
          '/login-activity',
          extra: {'message': e.message},
        );
        if (mounted) {
          if (success == true) {
            context.go('/home');
          } else {
            await ref.read(authProvider.notifier).logout();
          }
        }
      }
    } on AuthException catch (error) {
      if (mounted) setState(() => _errorMessage = error.message);
    } catch (_) {
      if (mounted) {
        setState(() => _errorMessage = l10n.loginErrorGenericRequest);
      }
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }
}
