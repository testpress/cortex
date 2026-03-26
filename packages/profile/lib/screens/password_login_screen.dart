import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordLoginScreen extends ConsumerStatefulWidget {
  const PasswordLoginScreen({super.key});

  @override
  ConsumerState<PasswordLoginScreen> createState() => _PasswordLoginScreenState();
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
                      AppText.headline('Sign In'),
                      SizedBox(height: design.spacing.xxl),
                      AppTextField(
                        label: l10n.loginUsernameLabel,
                        hintText: l10n.loginUsernameHint,
                        controller: _usernameController,
                        autofocus: true,
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(height: design.spacing.md),
                      AppTextField(
                        label: l10n.loginPasswordLabel,
                        hintText: l10n.loginPasswordHint,
                        controller: _passwordController,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _handlePasswordLogin(),
                      ),
                      if (_errorMessage != null) ...[
                        SizedBox(height: design.spacing.md),
                        AppText.bodySmall(_errorMessage!, color: design.colors.error),
                      ],
                      SizedBox(height: design.spacing.md),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => context.push('/forgot-password'),
                          child: AppText.body(
                            'Forgot Password?',
                            color: design.colors.primary,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
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
      setState(() { _errorMessage = l10n.loginErrorUsernamePasswordRequired; });
      return;
    }

    if (_isBusy) return;
    setState(() {
      _isBusy = true;
      _errorMessage = null;
    });

    try {
      await ref.read(authProvider.notifier).loginWithPassword(
            username: username,
            password: password,
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
