import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MobileLoginScreen extends ConsumerStatefulWidget {
  const MobileLoginScreen({super.key});

  @override
  ConsumerState<MobileLoginScreen> createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends ConsumerState<MobileLoginScreen> {
  final _phoneController = TextEditingController();
  final _countryCodeController = TextEditingController(text: '+91');

  bool _isBusy = false;
  String? _errorMessage;

  @override
  void dispose() {
    _phoneController.dispose();
    _countryCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

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
                      AppText.headline('Mobile Login'),
                      SizedBox(height: design.spacing.xxl),
                      Row(
                        children: [
                          SizedBox(
                            width: 80,
                            child: AppTextField(
                              label: 'Code',
                              hintText: '+91',
                              controller: _countryCodeController,
                            ),
                          ),
                          SizedBox(width: design.spacing.md),
                          Expanded(
                            child: AppTextField(
                              label: l10n.loginPhoneNumberLabel,
                              hintText: l10n.loginPhoneNumberHint,
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              autofocus: true,
                            ),
                          ),
                        ],
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
                          label: 'Continue',
                          fullWidth: true,
                          onPressed: _handleContinueToOtp,
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

  Future<void> _handleContinueToOtp() async {
    final l10n = L10n.of(context);
    final countryCode = _countryCodeController.text.trim();
    final phoneNumber = _phoneController.text.trim();

    if (countryCode.isEmpty || phoneNumber.isEmpty) {
      setState(() { _errorMessage = l10n.loginErrorOtpIdentityRequired; });
      return;
    }

    if (_isBusy) return;
    setState(() {
      _isBusy = true;
      _errorMessage = null;
    });

    try {
      await ref.read(authProvider.notifier).generateOtp(
        phoneNumber: phoneNumber,
        countryCode: countryCode,
      );
      if (mounted) context.push('/otp', extra: phoneNumber);
    } on AuthException catch (error) {
      if (mounted) setState(() => _errorMessage = error.message);
    } catch (_) {
      if (mounted) setState(() => _errorMessage = l10n.loginErrorGenericRequest);
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }
}
