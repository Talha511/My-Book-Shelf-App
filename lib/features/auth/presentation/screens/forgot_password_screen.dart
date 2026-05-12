import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/app_loader.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fieldFill = isDark ? const Color(0xFF252D18) : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password',
            style: context.ts.h3.copyWith(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: AppLoader(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.lock_reset_outlined,
                        size: 48, color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  _emailSent ? 'Reset Your Password' : 'Recover Your Account',
                  style: context.ts.h2,
                ),
                const SizedBox(height: 8),
                Text(
                  _emailSent
                      ? 'Enter the verification code sent to your email and create a new password'
                      : 'Enter your email address and we\'ll send you a code to reset your password',
                  style: context.ts.bodyMedium
                      .copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 40),

                if (!_emailSent) ...[
                  Text('Email Address', style: context.ts.labelMedium),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'you@example.com',
                      prefixIcon: const Icon(Icons.email_outlined,
                          color: AppColors.primary),
                      filled: true,
                      fillColor: fieldFill,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => _isLoading = true);
                        Future.delayed(const Duration(seconds: 2), () {
                          if (mounted) {
                            setState(() {
                              _isLoading = false;
                              _emailSent = true;
                            });
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Send Recovery Code',
                          style: context.ts.labelMedium
                              .copyWith(color: Colors.white)),
                    ),
                  ),
                ] else ...[
                  // Verification Code
                  Text('Verification Code', style: context.ts.labelMedium),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    style: context.ts.h3.copyWith(letterSpacing: 4),
                    decoration: InputDecoration(
                      hintText: '000000',
                      hintStyle: context.ts.h3.copyWith(
                          color: AppColors.textLigth, letterSpacing: 4),
                      filled: true,
                      fillColor: fieldFill,
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: 24),

                  // New Password
                  Text('New Password', style: context.ts.labelMedium),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passwordController,
                    obscureText: !_showPassword,
                    decoration: InputDecoration(
                      hintText: 'Enter new password',
                      prefixIcon: const Icon(Icons.lock_outline,
                          color: AppColors.primary),
                      suffixIcon: GestureDetector(
                        onTap: () =>
                            setState(() => _showPassword = !_showPassword),
                        child: Icon(
                          _showPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      filled: true,
                      fillColor: fieldFill,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password
                  Text('Confirm Password', style: context.ts.labelMedium),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: !_showConfirmPassword,
                    decoration: InputDecoration(
                      hintText: 'Confirm new password',
                      prefixIcon: const Icon(Icons.lock_outline,
                          color: AppColors.primary),
                      suffixIcon: GestureDetector(
                        onTap: () => setState(
                            () => _showConfirmPassword = !_showConfirmPassword),
                        child: Icon(
                          _showConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      filled: true,
                      fillColor: fieldFill,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                    ),
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => _isLoading = true);
                        Future.delayed(const Duration(seconds: 2), () {
                          if (mounted) {
                            setState(() => _isLoading = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Password reset successfully!'),
                                backgroundColor: AppColors.success,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            Future.delayed(const Duration(seconds: 1), () {
                              if (mounted) {
                                Navigator.pushReplacementNamed(
                                  context, AppRoutes.login);
                              }
                            });
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Reset Password',
                          style: context.ts.labelMedium
                              .copyWith(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () => setState(() => _emailSent = false),
                      child: Text('Back to Email',
                          style: context.ts.bodyMedium
                              .copyWith(color: AppColors.primary)),
                    ),
                  ),
                ],

                const SizedBox(height: 24),
                if (!_emailSent)
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Back to Login',
                          style: context.ts.bodyMedium
                              .copyWith(color: AppColors.primary)),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
