import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:country_code_picker/country_code_picker.dart';
import '../widgets/login_branding.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _countryCodeController = TextEditingController(text: 'IN');
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isBusy = false;
  String? _errorMessage;
  bool _obscurePassword = true;
  String? _usernameError;
  String? _emailError;
  String? _phoneError;
  String? _passwordError;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
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

                            if (_errorMessage != null) ...[
                              Container(
                                padding: EdgeInsets.all(design.spacing.sm),
                                decoration: BoxDecoration(
                                  color: design.colors.error.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    design.radius.sm,
                                  ),
                                ),
                                child: AppText.label(
                                  _errorMessage!,
                                  color: design.colors.error,
                                ),
                              ),
                              SizedBox(height: design.spacing.md),
                            ],
                            AppText.cardTitle(
                              l10n.loginSignupUsernameLabel,
                              color: design.colors.textSecondary,
                            ),
                            SizedBox(height: design.spacing.xs),
                            AppTextField(
                              label: '',
                              hintText: l10n.loginSignupUsernameHint,
                              controller: _usernameController,
                              errorText: _usernameError,
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
                              errorText: _emailError,
                              keyboardType: TextInputType.emailAddress,
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
                                  flex: 3,
                                  child: Container(
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: design.colors.card,
                                      borderRadius: BorderRadius.circular(
                                        design.radius.lg,
                                      ),
                                      border: Border.all(
                                        color: design.colors.border,
                                      ),
                                    ),
                                    child: Localizations.override(
                                      context: context,
                                      locale: const Locale('en'),
                                      delegates: const [
                                        CountryLocalizations.delegate,
                                      ],
                                      child: CountryCodePicker(
                                        onChanged: (code) {
                                          _countryCodeController.text =
                                              code.code ?? 'IN';
                                        },
                                        initialSelection: 'IN',
                                        showCountryOnly: false,
                                        showOnlyCountryWhenClosed: false,
                                        alignLeft: false,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 2.0,
                                        ),
                                        textStyle: design.typography.labelBold
                                            .copyWith(
                                              color: design.colors.textPrimary,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: design.spacing.sm),
                                Expanded(
                                  flex: 6,
                                  child: AppTextField(
                                    label: '',
                                    hintText: l10n.loginPhoneNumberShortHint,
                                    controller: _phoneController,
                                    errorText: _phoneError,
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
                              errorText: _passwordError,
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
                                onPressed: () async {
                                  final username = _usernameController.text
                                      .trim();
                                  final email = _emailController.text.trim();
                                  final phone = _phoneController.text.trim();
                                  final password = _passwordController.text;

                                  setState(() {
                                    _usernameError = username.isEmpty
                                        ? l10n.loginRequiredError
                                        : null;
                                    _emailError = email.isEmpty
                                        ? l10n.loginRequiredError
                                        : null;
                                    _phoneError = phone.isEmpty
                                        ? l10n.loginRequiredError
                                        : null;
                                    _passwordError = password.isEmpty
                                        ? l10n.loginRequiredError
                                        : null;
                                  });

                                  if (_usernameError != null ||
                                      _emailError != null ||
                                      _phoneError != null ||
                                      _passwordError != null) {
                                    return;
                                  }

                                  setState(() {
                                    _isBusy = true;
                                    _errorMessage = null;
                                  });
                                  try {
                                    await ref
                                        .read(authProvider.notifier)
                                        .register(
                                          username: username,
                                          email: email,
                                          password: password,
                                          phone: phone,
                                          countryCode: _countryCodeController
                                              .text
                                              .trim(),
                                        );
                                    if (!context.mounted) return;
                                    context.go('/home');
                                  } catch (e) {
                                    if (mounted) {
                                      setState(() {
                                        if (e is ApiException) {
                                          _errorMessage = e.message;
                                        } else {
                                          _errorMessage = e.toString();
                                        }
                                        _isBusy = false;
                                      });
                                    }
                                  }
                                },
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
