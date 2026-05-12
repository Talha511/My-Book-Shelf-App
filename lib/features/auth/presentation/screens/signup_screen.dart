import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../../generated/l10n/app_localizations.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../domain/entities/user.dart';
import '../../../../presentation/viewmodels/auth_viewmodel.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _agreedToTerms = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  bool _phoneValid = false;
  String _completePhoneNumber = '';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    final l10n = AppLocalizations.of(context)!;
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    if (!_formKey.currentState!.validate()) return;
    
    // Check for phone validation if you have a way to get the full number
    // For now, let's assume we collect it or it's optional

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.agreeToTermsError),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final newUser = User(
      id: const Uuid().v4(),
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      phoneNumber: _completePhoneNumber,
    );

    setState(() => _isLoading = true);
    final success = await authViewModel.signup(newUser);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.accountCreated),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authViewModel.error ?? 'Signup failed'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fieldFill = isDark ? const Color(0xFF252D18) : Colors.white;
    final borderColor = isDark ? AppColors.secondary.withValues(alpha: 0.4) : AppColors.accent;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createAccount, style: AppTextStyles.h3.copyWith(color: Colors.white)),
        centerTitle: true,
      ),
      body: AppLoader(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.joinMyBookShelf, style: context.ts.h2),
                  const SizedBox(height: 8),
                  Text(l10n.createAccountSubtitle,
                      style: context.ts.bodyMedium.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 32),

                  Text(l10n.fullName, style: context.ts.labelMedium),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return l10n.nameRequired;
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: l10n.fullNameHint,
                      prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary),
                      filled: true,
                      fillColor: fieldFill,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(l10n.emailAddress, style: context.ts.labelMedium),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.isEmpty) return l10n.emailRequired;
                      if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) {
                        return l10n.emailInvalid;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: l10n.emailHint,
                      prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primary),
                      filled: true,
                      fillColor: fieldFill,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(l10n.phoneNumber, style: context.ts.labelMedium),
                  const SizedBox(height: 4),
                  IntlPhoneField(
                    initialCountryCode: 'PK',
                    dropdownTextStyle: context.ts.bodyMedium,
                    style: context.ts.bodyMedium,
                    decoration: InputDecoration(
                      hintText: '300 1234567',
                      filled: true,
                      fillColor: fieldFill,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onChanged: (phone) {
                      setState(() {
                        _phoneValid = phone.completeNumber.length > 10;
                        _completePhoneNumber = phone.completeNumber;
                      });
                    },
                  ),
                  const SizedBox(height: 8),

                  Text(l10n.password, style: context.ts.labelMedium),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_showPassword,
                    validator: (v) {
                      if (v == null || v.isEmpty) return l10n.passwordRequired;
                      if (v.length < 6) return l10n.passwordTooShort;
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: l10n.passwordHint,
                      prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
                      suffixIcon: IconButton(
                        icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => _showPassword = !_showPassword),
                      ),
                      filled: true,
                      fillColor: fieldFill,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(l10n.confirmPassword, style: context.ts.labelMedium),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_showConfirmPassword,
                    validator: (v) {
                      if (v == null || v.isEmpty) return l10n.confirmPasswordRequired;
                      if (v != _passwordController.text) return l10n.passwordsDoNotMatch;
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: l10n.confirmPasswordHint,
                      prefixIcon: const Icon(Icons.lock_reset, color: AppColors.primary),
                      suffixIcon: IconButton(
                        icon: Icon(_showConfirmPassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => _showConfirmPassword = !_showConfirmPassword),
                      ),
                      filled: true,
                      fillColor: fieldFill,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Terms and Conditions Checkbox
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          value: _agreedToTerms,
                          onChanged: (v) => setState(() => _agreedToTerms = v ?? false),
                          activeColor: AppColors.primary,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: l10n.agreeTerms,
                            style: context.ts.bodySmall,
                            children: [
                              TextSpan(
                                text: l10n.termsConditions,
                                style: context.ts.bodySmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Navigator.pushNamed(context, AppRoutes.termsConditions),
                              ),
                              TextSpan(text: l10n.and, style: context.ts.bodySmall),
                              TextSpan(
                                text: l10n.privacyPolicy,
                                style: context.ts.bodySmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Navigator.pushNamed(context, AppRoutes.privacyPolicy),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSignup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(l10n.createAccount),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(l10n.orContinueWith, style: context.ts.bodySmall),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _socialButton(Icons.g_mobiledata, 'Google'),
                      _socialButton(Icons.facebook, 'Facebook'),
                      _socialButton(Icons.apple, 'Apple'),
                    ],
                  ),
                  const SizedBox(height: 32),

                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text.rich(TextSpan(
                        text: l10n.alreadyHaveAccount,
                        style: context.ts.bodySmall,
                        children: [
                          TextSpan(
                            text: l10n.login,
                            style: context.ts.labelMedium.copyWith(color: AppColors.primary),
                          ),
                        ],
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialButton(IconData icon, String label) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(label, style: context.ts.bodySmall.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
