import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sign_in_button/sign_in_button.dart';
import '../widgets/login_branding.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isFormBusy = false;
  bool _isGoogleBusy = false;
  bool _obscurePassword = true;

  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final settings = ref.watch(instituteSettingsProvider);
    final disableForgotPassword = settings?.disableForgotPassword ?? true;
    final allowSignup = settings?.allowSignup ?? false;

    final loginIdLabel = settings?.loginIdLabel;
    final displayLoginIdLabel =
        (loginIdLabel != null && loginIdLabel.isNotEmpty)
        ? loginIdLabel
        : l10n.loginUsernameLabel;
    final displayLoginIdHint = (loginIdLabel != null && loginIdLabel.isNotEmpty)
        ? l10n.loginEnterFieldHint(loginIdLabel)
        : l10n.loginUsernameHint;

    final loginPasswordLabel = settings?.loginPasswordLabel;
    final displayPasswordLabel =
        (loginPasswordLabel != null && loginPasswordLabel.isNotEmpty)
        ? loginPasswordLabel
        : l10n.loginPasswordLabel;
    final displayPasswordHint =
        (loginPasswordLabel != null && loginPasswordLabel.isNotEmpty)
        ? l10n.loginEnterFieldHint(loginPasswordLabel)
        : l10n.loginPasswordHint;

    final allowedMethods =
        settings?.allowedLoginMethods ?? const [LoginMethod.formLogin];
    final googleLoginEnabled = settings?.googleLoginEnabled ?? false;
    final showOtp = allowedMethods.contains(LoginMethod.otpLogin);
    final showSocial =
        allowedMethods.contains(LoginMethod.socialLogin) && googleLoginEnabled;

    return Scaffold(
      backgroundColor: design.colors.surface,
      body: SafeArea(
        child: Center(
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
                          label: l10n.loginSignIn,
                          child: AppText.display(
                            l10n.loginSignIn,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        if (allowSignup) ...[
                          SizedBox(height: design.spacing.sm),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppText.cardTitle(
                                l10n.loginSignUpPrompt,
                                color: design.colors.textSecondary,
                              ),
                              AppSemantics.button(
                                label: l10n.loginSignUp,
                                onTap: () => context.push('/signup'),
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => context.push('/signup'),
                                  child: AppText.cardTitle(
                                    l10n.loginSignUp,
                                    color: design.colors.primary,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        SizedBox(height: design.spacing.xl),
                        AppText.cardTitle(
                          displayLoginIdLabel,
                          color: design.colors.textSecondary,
                        ),
                        SizedBox(height: design.spacing.xs),
                        AppTextField(
                          label: '',
                          hintText: displayLoginIdHint,
                          controller: _usernameController,
                          autofocus: true,
                          textStyle: design.typography.labelBold,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.username],
                        ),
                        SizedBox(height: design.spacing.lg),
                        AppText.cardTitle(
                          displayPasswordLabel,
                          color: design.colors.textSecondary,
                        ),
                        SizedBox(height: design.spacing.xs),
                        AppTextField(
                          label: '',
                          hintText: displayPasswordHint,
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textStyle: design.typography.labelBold,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.password],
                          onSubmitted: (_) => _handlePasswordLogin(),
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
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: design.spacing.md),
                        if (!disableForgotPassword)
                          Align(
                            alignment: Alignment.centerRight,
                            child: AppSemantics.button(
                              label: l10n.loginForgotPassword,
                              onTap: () => context.push('/forgot-password'),
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => context.push('/forgot-password'),
                                child: AppText.cardTitle(
                                  l10n.loginForgotPassword,
                                  color: design.colors.primary,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (_errorMessage != null) ...[
                          SizedBox(height: design.spacing.md),
                          AppText.bodySmall(
                            _errorMessage!,
                            color: design.colors.error,
                            textAlign: TextAlign.center,
                          ),
                        ],
                        SizedBox(height: design.spacing.xl),
                        if (_isFormBusy)
                          const Center(child: AppLoadingIndicator())
                        else
                          AppButton.primary(
                            label: l10n.loginButton,
                            fullWidth: true,
                            onPressed: _handlePasswordLogin,
                          ),

                        // Optional Alternative Logins (Or divider)
                        if (showSocial || showOtp) ...[
                          SizedBox(height: design.spacing.lg),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: design.colors.border,
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: design.spacing.md,
                                ),
                                child: AppText.cardTitle(
                                  l10n.loginOr,
                                  color: design.colors.textSecondary,
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: design.colors.border,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: design.spacing.lg),
                          if (showOtp) ...[
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: SignInButtonBuilder(
                                text: l10n.loginContinueWithMobile,
                                icon: LucideIcons.smartphone,
                                backgroundColor: const Color(0xFFFFFFFF),
                                textColor: Colors.black87,
                                iconColor: Colors.black87,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: design.radius.button,
                                  side: BorderSide(color: design.colors.border),
                                ),
                                onPressed: () => context.push('/mobile-login'),
                              ),
                            ),
                            SizedBox(height: design.spacing.md),
                          ],
                          if (showSocial) ...[
                            if (_isGoogleBusy)
                              const SizedBox(
                                height: 48,
                                child: Center(child: AppLoadingIndicator()),
                              )
                            else
                              AppSemantics.button(
                                label: l10n.loginContinueWithGoogle,
                                onTap: _handleGoogleLogin,
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: SignInButton(
                                    Buttons.google,
                                    text: l10n.loginContinueWithGoogle,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: design.radius.button,
                                      side: BorderSide(
                                        color: design.colors.border,
                                      ),
                                    ),
                                    onPressed: _handleGoogleLogin,
                                  ),
                                ),
                              ),
                          ],
                        ],
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

  Future<void> _handlePasswordLogin() async {
    final l10n = L10n.of(context);
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = l10n.loginErrorUsernamePasswordRequired;
      });
      return;
    }

    if (_isFormBusy || _isGoogleBusy) return;
    setState(() {
      _isFormBusy = true;
      _errorMessage = null;
    });

    try {
      await ref
          .read(authProvider.notifier)
          .loginWithPassword(username: username, password: password);
      if (mounted) context.go('/home');
    } on ParallelLoginException catch (e) {
      await _handleParallelLogin(e);
    } on AuthException catch (error) {
      if (mounted) setState(() => _errorMessage = error.message);
    } catch (_) {
      if (mounted) {
        setState(() => _errorMessage = l10n.loginErrorGenericRequest);
      }
    } finally {
      if (mounted) setState(() => _isFormBusy = false);
    }
  }

  Future<void> _handleGoogleLogin() async {
    final l10n = L10n.of(context);

    if (_isFormBusy || _isGoogleBusy) return;
    setState(() {
      _isGoogleBusy = true;
      _errorMessage = null;
    });

    try {
      await ref.read(authProvider.notifier).loginWithGoogle();
      if (mounted) context.go('/home');
    } on ParallelLoginException catch (e) {
      await _handleParallelLogin(e);
    } on GoogleSignInCancelledException {
      if (mounted) setState(() => _errorMessage = null);
    } on GoogleSignInTokenFailedException {
      if (mounted) {
        setState(() => _errorMessage = l10n.loginErrorGoogleTokenFailed);
      }
    } on AuthException catch (error) {
      if (mounted) setState(() => _errorMessage = error.message);
    } catch (e, _) {
      if (mounted) {
        setState(() => _errorMessage = l10n.loginErrorGenericRequest);
      }
    } finally {
      if (mounted) setState(() => _isGoogleBusy = false);
    }
  }

  Future<void> _handleParallelLogin(ParallelLoginException e) async {
    if (!mounted) return;
    final success = await context.push<bool>(
      '/login-activity',
      extra: {'message': e.message},
    );
    if (!mounted) return;
    if (success == true) {
      context.go('/home');
    } else {
      await ref.read(authProvider.notifier).logout();
    }
  }
}
