import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/login_branding.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  final _countryCodeController = TextEditingController(text: '+91');
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final bool _isBusy = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _countryCodeController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
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
            Center(
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
                              label: l10n.loginSignUpTitle,
                              child: AppText.display(
                                l10n.loginSignUpTitle,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(height: design.spacing.sm),
                            Row(
                              children: [
                                AppText.cardTitle(
                                  l10n.loginAlreadyHaveAccount,
                                  color: design.colors.textSecondary,
                                ),
                                AppSemantics.button(
                                  label: l10n.loginButton,
                                  onTap: () => context.pop(),
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () => context.pop(),
                                    child: AppText.cardTitle(
                                      l10n.loginButton,
                                      color: design.colors.primary,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: design.spacing.xl),

                            AppText.cardTitle(
                              l10n.loginFullNameLabel,
                              color: design.colors.textSecondary,
                            ),
                            SizedBox(height: design.spacing.xs),
                            AppTextField(
                              label: '',
                              hintText: l10n.loginFullNameHint,
                              controller: _nameController,
                              textStyle: design.typography.labelBold,
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(height: design.spacing.md),

                            AppText.cardTitle(
                              l10n.loginEmailLabel,
                              color: design.colors.textSecondary,
                            ),
                            SizedBox(height: design.spacing.xs),
                            AppTextField(
                              label: '',
                              hintText: l10n.loginEmailHintId,
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              textStyle: design.typography.labelBold,
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(height: design.spacing.md),

                            AppText.cardTitle(
                              l10n.loginDateOfBirthLabel,
                              color: design.colors.textSecondary,
                            ),
                            SizedBox(height: design.spacing.xs),
                            AppTextField(
                              label: '',
                              hintText: l10n.loginDateOfBirthHint,
                              controller: _dobController,
                              textStyle: design.typography.labelBold,
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(height: design.spacing.md),

                            AppText.cardTitle(
                              l10n.loginPhoneNumberLabel,
                              color: design.colors.textSecondary,
                            ),
                            SizedBox(height: design.spacing.xs),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: AppTextField(
                                    label: '',
                                    hintText: l10n.loginCountryCodeHint,
                                    controller: _countryCodeController,
                                    textStyle: design.typography.labelBold,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.phone,
                                  ),
                                ),
                                SizedBox(width: design.spacing.sm),
                                Expanded(
                                  flex: 5,
                                  child: AppTextField(
                                    label: '',
                                    hintText: l10n.loginPhoneNumberShortHint,
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    textStyle: design.typography.labelBold,
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: design.spacing.md),

                            AppText.cardTitle(
                              l10n.loginSetPasswordLabel,
                              color: design.colors.textSecondary,
                            ),
                            SizedBox(height: design.spacing.xs),
                            AppTextField(
                              label: '',
                              hintText: l10n.loginPasswordHint,
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              textStyle: design.typography.labelBold,
                              textInputAction: TextInputAction.done,
                              suffixIcon: AppSemantics.button(
                                label: _obscurePassword
                                    ? l10n.loginShowPassword
                                    : l10n.loginHidePassword,
                                onTap: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                  child: SizedBox(
                                    width: 48,
                                    height: 48,
                                    child: Center(
                                      child: Icon(
                                        _obscurePassword
                                            ? LucideIcons.eye
                                            : LucideIcons.eyeOff,
                                        color: design.colors.textSecondary,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: design.spacing.xxl),
                            if (_isBusy)
                              const Center(child: AppLoadingIndicator())
                            else
                              AppButton.primary(
                                label: l10n.loginRegister,
                                fullWidth: true,
                                // TODO: Implement registration API call via auth provider
                                onPressed: () => context.go('/home'),
                              ),
                          ],
                        ),
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
                  label: l10n.loginGoBack,
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
}
