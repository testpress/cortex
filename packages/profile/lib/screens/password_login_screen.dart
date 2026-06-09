import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordLoginScreen extends ConsumerStatefulWidget {
  const PasswordLoginScreen({super.key});

  @override
  ConsumerState<PasswordLoginScreen> createState() =>
      _PasswordLoginScreenState();
}

class _PasswordLoginScreenState extends ConsumerState<PasswordLoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isBusy = false;
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

    final loginIdLabel = settings?.loginIdLabel;
    final displayLoginIdLabel =
        (loginIdLabel != null && loginIdLabel.isNotEmpty)
        ? loginIdLabel
        : l10n.loginUsernameLabel;
    final displayLoginIdHint = (loginIdLabel != null && loginIdLabel.isNotEmpty)
        ? "Enter $loginIdLabel"
        : l10n.loginUsernameHint;

    final loginPasswordLabel = settings?.loginPasswordLabel;
    final displayPasswordLabel =
        (loginPasswordLabel != null && loginPasswordLabel.isNotEmpty)
        ? loginPasswordLabel
        : l10n.loginPasswordLabel;
    final displayPasswordHint =
        (loginPasswordLabel != null && loginPasswordLabel.isNotEmpty)
        ? "Enter $loginPasswordLabel"
        : l10n.loginPasswordHint;

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: design.spacing.xl,
                vertical: design.spacing.md,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - design.spacing.xl * 2,
                ),
                child: IntrinsicHeight(
                  child: AutofillGroup(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppText.headline('Sign In'),
                        SizedBox(height: design.spacing.xxl),
                        AppTextField(
                          label: displayLoginIdLabel,
                          hintText: displayLoginIdHint,
                          controller: _usernameController,
                          autofocus: true,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.username],
                        ),
                        SizedBox(height: design.spacing.md),
                        AppTextField(
                          label: displayPasswordLabel,
                          hintText: displayPasswordHint,
                          controller: _passwordController,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.password],
                          onSubmitted: (_) => _handlePasswordLogin(),
                        ),
                        if (_errorMessage != null) ...[
                          SizedBox(height: design.spacing.md),
                          AppText.bodySmall(
                            _errorMessage!,
                            color: design.colors.error,
                          ),
                        ],
                        if (!disableForgotPassword) ...[
                          SizedBox(height: design.spacing.md),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () => context.push('/forgot-password'),
                              child: AppText.body(
                                'Forgot Password?',
                                color: design.colors.primary,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                        const Spacer(),
                        SizedBox(height: design.spacing.xxl),
                        if (_isBusy)
                          const Center(child: AppLoadingIndicator())
                        else
                          AppButton.primary(
                            label: l10n.loginButton,
                            fullWidth: true,
                            onPressed: _handlePasswordLogin,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
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

    if (_isBusy) return;
    setState(() {
      _isBusy = true;
      _errorMessage = null;
    });

    try {
      await ref
          .read(authProvider.notifier)
          .loginWithPassword(username: username, password: password);
      if (mounted) context.go('/home');
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
