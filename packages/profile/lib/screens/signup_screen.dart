import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final bool _isBusy = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

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
                      AppText.headline('Create an Account'),
                      SizedBox(height: design.spacing.xs),
                      AppText.body(
                        'Sign up to start learning today',
                        color: design.colors.textSecondary,
                      ),
                      SizedBox(height: design.spacing.xxl),
                      AppTextField(
                        label: 'Full Name',
                        hintText: 'Enter your full name',
                        controller: _nameController,
                        autofocus: true,
                      ),
                      SizedBox(height: design.spacing.md),
                      AppTextField(
                        label: 'Email',
                        hintText: 'Enter your email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                        SizedBox(height: design.spacing.md),
                      AppTextField(
                        label: 'Password',
                        hintText: 'Create a password',
                        controller: _passwordController,
                        obscureText: true,
                      ),
                      const Spacer(),
                      SizedBox(height: design.spacing.xxl),
                      if (_isBusy)
                        const Center(child: AppLoadingIndicator())
                      else ...[
                        AppButton.primary(
                          label: 'Sign Up',
                          fullWidth: true,
                          onPressed: () {
                            context.go('/home');
                          },
                        ),
                        SizedBox(height: design.spacing.md),
                        AppButton.secondary(
                          label: 'Continue with Google',
                          fullWidth: true,
                          leading: const Icon(LucideIcons.chrome),
                          onPressed: () => context.go('/home'),
                        ),
                      ],
                      SizedBox(height: design.spacing.xl),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText.body('Already have an account? '),
                          GestureDetector(
                            child: AppText.body(
                              'Log in',
                              color: design.colors.primary,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onTap: () => context.go('/login'),
                          ),
                        ],
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
}
