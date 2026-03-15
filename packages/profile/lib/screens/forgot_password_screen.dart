import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isBusy = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
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
          onPressed: () => context.go('/login'),
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
                      AppText.headline('Reset Password'),
                      SizedBox(height: design.spacing.xs),
                      AppText.body(
                        _emailSent
                            ? 'We have sent a password reset link to your email.'
                            : 'Enter your email to receive a password reset link.',
                        color: design.colors.textSecondary,
                      ),
                      SizedBox(height: design.spacing.xxl),
                      if (!_emailSent) ...[
                        AppTextField(
                          label: 'Email',
                          hintText: 'Enter your email',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          autofocus: true,
                        ),
                        const Spacer(),
                        SizedBox(height: design.spacing.xxl),
                        if (_isBusy)
                          const Center(child: AppLoadingIndicator())
                        else
                          AppButton.primary(
                            label: 'Send Reset Link',
                            fullWidth: true,
                            onPressed: () {
                              setState(() {
                                _emailSent = true;
                              });
                            },
                          ),
                      ] else ...[
                        const Spacer(),
                        AppButton.primary(
                          label: 'Back to Login',
                          fullWidth: true,
                          onPressed: () => context.go('/login'),
                        ),
                      ],
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
