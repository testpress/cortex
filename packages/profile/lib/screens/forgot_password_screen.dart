import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/login_branding.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isBusy = false;
  bool _emailSent = false;

  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Container(
      color: design.colors.surface,
      child: SafeArea(
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
                            label: l10n.loginForgotPasswordTitle,
                            child: AppText.display(
                              l10n.loginForgotPasswordTitle,
                              textAlign: TextAlign.left,
                            ),
                          ),
                          SizedBox(height: design.spacing.sm),
                          AppText.cardTitle(
                            _emailSent
                                ? l10n.loginForgotPasswordSent
                                : l10n.loginForgotPasswordSubtitle,
                            color: design.colors.textSecondary,
                          ),
                          SizedBox(height: design.spacing.xl),
                          if (!_emailSent) ...[
                            AppText.cardTitle(
                              l10n.loginEmailLabel,
                              color: design.colors.textSecondary,
                            ),
                            SizedBox(height: design.spacing.xs),
                            AppTextField(
                              label: '',
                              hintText: l10n.loginEmailHintFull,
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              textStyle: design.typography.labelBold,
                              textInputAction: TextInputAction.done,
                              autofocus: true,
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
                                label: l10n.loginSendResetLink,
                                fullWidth: true,
                                onPressed: _handleResetPassword,
                              ),
                          ] else ...[
                            AppButton.primary(
                              label: l10n.loginBackToLogin,
                              fullWidth: true,
                              onPressed: () => context.go('/login'),
                            ),
                          ],
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

  Future<void> _handleResetPassword() async {
    final l10n = L10n.of(context);
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() => _errorMessage = l10n.loginEmailRequired);
      return;
    }

    if (_isBusy) return;
    setState(() {
      _isBusy = true;
      _errorMessage = null;
    });

    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.resetPassword(email: email);

      if (mounted) {
        setState(() {
          _emailSent = true;
        });
      }
    } on AuthException catch (e) {
      if (mounted) setState(() => _errorMessage = e.message);
    } catch (_) {
      if (mounted) {
        setState(() => _errorMessage = l10n.loginErrorGenericRequest);
      }
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }
}
