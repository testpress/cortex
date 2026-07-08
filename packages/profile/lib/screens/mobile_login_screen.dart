import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/login_branding.dart';

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
        leading: context.canPop()
            ? IconButton(
                icon: Icon(
                  LucideIcons.arrowLeft,
                  color: design.colors.textPrimary,
                ),
                onPressed: () => context.pop(),
              )
            : null,
      ),
      body: SafeArea(
        child: Align(
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
                  child: AutofillGroup(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppSemantics.header(
                          label: l10n.loginMobileLoginTitle,
                          child: AppText.display(
                            l10n.loginMobileLoginTitle,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: design.spacing.sm),
                        AppText.cardTitle(
                          l10n.loginMobileLoginSubtitle,
                          color: design.colors.textSecondary,
                        ),
                        SizedBox(height: design.spacing.xl),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 80,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText.cardTitle(
                                    l10n.loginCountryCodeShortLabel,
                                    color: design.colors.textSecondary,
                                  ),
                                  SizedBox(height: design.spacing.xs),
                                  AppTextField(
                                    label: '',
                                    hintText: l10n.loginCountryCodeHint,
                                    controller: _countryCodeController,
                                    textStyle: design.typography.labelBold,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: design.spacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText.cardTitle(
                                    l10n.loginPhoneNumberLabel,
                                    color: design.colors.textSecondary,
                                  ),
                                  SizedBox(height: design.spacing.xs),
                                  AppTextField(
                                    label: '',
                                    hintText: l10n.loginPhoneNumberHint,
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    autofocus: true,
                                    textStyle: design.typography.labelBold,
                                    textInputAction: TextInputAction.done,
                                    onSubmitted: (_) => _handleContinueToOtp(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (_errorMessage != null) ...[
                          SizedBox(height: design.spacing.md),
                          AppText.bodySmall(
                            _errorMessage!,
                            color: design.colors.error,
                          ),
                        ],
                        SizedBox(height: design.spacing.xxl),
                        if (_isBusy)
                          const Center(child: AppLoadingIndicator())
                        else
                          AppButton.primary(
                            label: l10n.loginContinue,
                            fullWidth: true,
                            onPressed: _handleContinueToOtp,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleContinueToOtp() async {
    final l10n = L10n.of(context);
    final countryCode = _countryCodeController.text.trim();
    final phoneNumber = _phoneController.text.trim();

    if (countryCode.isEmpty || phoneNumber.isEmpty) {
      setState(() {
        _errorMessage = l10n.loginErrorOtpIdentityRequired;
      });
      return;
    }

    if (_isBusy) return;
    setState(() {
      _isBusy = true;
      _errorMessage = null;
    });

    try {
      await ref
          .read(authProvider.notifier)
          .generateOtp(phoneNumber: phoneNumber, countryCode: countryCode);
      if (mounted) {
        context.push(
          '/otp',
          extra: {
            'phoneNumber': phoneNumber,
            'countryCode': countryCode.trim(),
          },
        );
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
