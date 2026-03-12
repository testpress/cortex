import 'dart:ui';

import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _countryCodeController = TextEditingController(text: '+91');
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();

  // Reusing the MockAuthClient from the core mock data repository
  final _authClient = MockAuthClient();

  bool _isOtpMode = false;
  bool _isBusy = false;
  bool _otpRequested = false;
  String? _errorMessage;
  String? _infoMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _countryCodeController.dispose();
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            design.colors.primary.withValues(alpha: 0.90),
            design.colors.surface,
            design.colors.accent2.withValues(alpha: 0.35),
          ],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(design.spacing.screenPadding),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(design.radius.xl),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                  child: Container(
                    padding: EdgeInsets.all(design.spacing.xl),
                    decoration: BoxDecoration(
                      color: design.colors.surface.withValues(alpha: 0.84),
                      border: Border.all(
                        color: design.colors.border.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(design.spacing.md),
                                decoration: BoxDecoration(
                                  color: design.colors.primary.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  LucideIcons.graduationCap,
                                  size: 48,
                                  color: design.colors.primary,
                                ),
                              ),
                              SizedBox(height: design.spacing.md),
                              AppText.headline(
                                l10n.loginWelcomeBack,
                                color: design.colors.textPrimary,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: design.spacing.xs),
                        Center(
                          child: AppText.body(
                            _isOtpMode
                                ? l10n.loginOtpSubtitle
                                : l10n.loginPasswordSubtitle,
                            color: design.colors.textSecondary,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        if (_isBusy) ...[
                          SizedBox(height: design.spacing.lg),
                          const Center(child: AppLoadingIndicator()),
                        ],
                        SizedBox(height: design.spacing.xl),
                        _buildModeSwitch(design, l10n),
                        SizedBox(height: design.spacing.lg),
                        AnimatedCrossFade(
                          firstChild: _buildPasswordForm(l10n),
                          secondChild: _buildOtpForm(l10n),
                          crossFadeState: _isOtpMode
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 300),
                        ),
                        if (_errorMessage != null) ...[
                          SizedBox(height: design.spacing.md),
                          AppText.bodySmall(
                            _errorMessage!,
                            color: design.colors.error,
                          ),
                        ],
                        if (_infoMessage != null) ...[
                          SizedBox(height: design.spacing.sm),
                          AppText.bodySmall(
                            _infoMessage!,
                            color: design.colors.textSecondary,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModeSwitch(DesignConfig design, AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.all(design.spacing.xs),
      decoration: BoxDecoration(
        color: design.colors.card.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(design.radius.xl),
        border: Border.all(color: design.colors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: AppButton(
              label: l10n.loginModePassword,
              fullWidth: true,
              variant: _isOtpMode
                  ? AppButtonVariant.secondary
                  : AppButtonVariant.primary,
              onPressed: _isBusy
                  ? null
                  : () {
                      setState(() {
                        _isOtpMode = false;
                        _otpRequested = false;
                        _errorMessage = null;
                        _infoMessage = null;
                      });
                    },
            ),
          ),
          SizedBox(width: design.spacing.sm),
          Expanded(
            child: AppButton(
              label: l10n.loginModeOtp,
              fullWidth: true,
              variant: _isOtpMode
                  ? AppButtonVariant.primary
                  : AppButtonVariant.secondary,
              onPressed: _isBusy
                  ? null
                  : () {
                      setState(() {
                        _isOtpMode = true;
                        _errorMessage = null;
                        _infoMessage = null;
                      });
                    },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordForm(AppLocalizations l10n) {
    final design = Design.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          label: l10n.loginUsernameLabel,
          hintText: l10n.loginUsernameHint,
          controller: _usernameController,
        ),
        SizedBox(height: design.spacing.md),
        AppTextField(
          label: l10n.loginPasswordLabel,
          hintText: l10n.loginPasswordHint,
          controller: _passwordController,
          obscureText: true,
        ),
        SizedBox(height: design.spacing.lg),
        AppButton.primary(
          label: l10n.loginButton,
          fullWidth: true,
          onPressed: _isBusy ? null : _handlePasswordLogin,
        ),
      ],
    );
  }

  Widget _buildOtpForm(AppLocalizations l10n) {
    final design = Design.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          label: l10n.loginCountryCodeLabel,
          hintText: l10n.loginCountryCodeHint,
          controller: _countryCodeController,
        ),
        SizedBox(height: design.spacing.md),
        AppTextField(
          label: l10n.loginPhoneNumberLabel,
          hintText: l10n.loginPhoneNumberHint,
          controller: _phoneController,
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: design.spacing.md),
        AppTextField(
          label: l10n.loginEmailOptionalLabel,
          hintText: l10n.loginEmailHint,
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: design.spacing.md),
        AppButton.secondary(
          label: l10n.loginGenerateOtp,
          fullWidth: true,
          onPressed: _isBusy ? null : _handleGenerateOtp,
        ),
        SizedBox(height: design.spacing.md),
        AppTextField(
          label: l10n.loginOtpCodeLabel,
          hintText: l10n.loginOtpCodeHint,
          controller: _otpController,
          keyboardType: TextInputType.number,
          readOnly: !_otpRequested,
        ),
        SizedBox(height: design.spacing.lg),
        AppButton.primary(
          label: l10n.loginVerifyOtp,
          fullWidth: true,
          onPressed: (_isBusy || !_otpRequested) ? null : _handleVerifyOtp,
        ),
      ],
    );
  }

  Future<void> _handlePasswordLogin() async {
    final l10n = L10n.of(context);
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = l10n.loginErrorUsernamePasswordRequired;
        _infoMessage = null;
      });
      return;
    }

    await _runAuthAction(() async {
      await _authClient.login(username: username, password: password);
      await _finalizeSuccess();
    });
  }

  Future<void> _handleGenerateOtp() async {
    final l10n = L10n.of(context);
    final countryCode = _countryCodeController.text.trim();
    final phoneNumber = _phoneController.text.trim();
    final email = _emailController.text.trim();

    if (countryCode.isEmpty || phoneNumber.isEmpty) {
      setState(() {
        _errorMessage = l10n.loginErrorOtpIdentityRequired;
        _infoMessage = null;
      });
      return;
    }

    await _runAuthAction(() async {
      await _authClient.generateOtp(
        phoneNumber: phoneNumber,
        countryCode: countryCode,
        email: email.isEmpty ? null : email,
      );

      if (!mounted) return;
      setState(() {
        _otpRequested = true;
        _errorMessage = null;
        _infoMessage = l10n.loginOtpSentInfo;
      });
    });
  }

  Future<void> _handleVerifyOtp() async {
    final l10n = L10n.of(context);
    final otp = _otpController.text.trim();
    final phoneNumber = _phoneController.text.trim();
    final email = _emailController.text.trim();

    if (otp.isEmpty || phoneNumber.isEmpty) {
      setState(() {
        _errorMessage = l10n.loginErrorPhoneOtpRequired;
        _infoMessage = null;
      });
      return;
    }

    await _runAuthAction(() async {
      await _authClient.verifyOtp(
        otp: otp,
        phoneNumber: phoneNumber,
        email: email.isEmpty ? null : email,
      );
      await _finalizeSuccess();
    });
  }

  Future<void> _runAuthAction(Future<void> Function() action) async {
    final l10n = L10n.of(context);
    if (_isBusy) return;
    setState(() {
      _isBusy = true;
      _errorMessage = null;
    });

    try {
      await action();
    } on AuthException catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.message;
      });
    } catch (_) {
      if (!mounted) return;
        setState(() {
        _errorMessage = l10n.loginErrorGenericRequest;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isBusy = false;
        });
      }
    }
  }

  Future<void> _finalizeSuccess() async {
    final user = await _authClient.resolveCurrentUser(forceRefresh: true);
    ref.read(authProvider.notifier).updateProfile(user);
    if (!mounted) return;
    context.go('/home');
  }
}
