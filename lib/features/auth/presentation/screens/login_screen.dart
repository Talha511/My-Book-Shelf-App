import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:book_library_pro/presentation/viewmodels/auth_viewmodel.dart';
import 'package:book_library_pro/core/routes/app_routes.dart';
import 'package:book_library_pro/core/constants/app_colors.dart';
import 'package:book_library_pro/core/constants/app_text_styles.dart';
import 'package:book_library_pro/core/widgets/app_loader.dart';
import 'package:book_library_pro/generated/l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final LocalAuthentication _auth = LocalAuthentication();
  
  bool _rememberMe = false;
  bool _showPassword = false;
  bool _canCheckBiometrics = false;

  @override
  void initState() {
    super.initState();
    _loadRememberedEmail();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    final prefs = await SharedPreferences.getInstance();
    final bool useBiometrics = prefs.getBool('use_biometrics') ?? false;
    final bool useFaceLock = prefs.getBool('use_face_lock') ?? false;
    
    if (useBiometrics || useFaceLock) {
      bool canCheck = await _auth.canCheckBiometrics;
      if (canCheck) {
        setState(() => _canCheckBiometrics = true);
        // Automatically trigger biometric login if preferred
        _handleBiometricLogin();
      }
    }
  }

  Future<void> _handleBiometricLogin() async {
    try {
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Please authenticate to login',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (didAuthenticate && mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    } catch (e) {
      debugPrint('Biometric Error: $e');
    }
  }

  Future<void> _loadRememberedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('remember_me') ?? false) {
      setState(() {
        _rememberMe = true;
        _emailController.text = prefs.getString('saved_email') ?? '';
      });
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setBool('remember_me', true);
      await prefs.setString('saved_email', _emailController.text.trim());
    } else {
      await prefs.remove('remember_me');
      await prefs.remove('saved_email');
    }

    final success = await authViewModel.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (mounted) {
      if (success) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authViewModel.error ?? 'Login failed'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _handleSocialLogin(Future<bool> Function() socialMethod) async {
    final success = await socialMethod();
    if (mounted) {
      if (success) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authViewModel.error ?? 'Social Login failed'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authViewModel = Provider.of<AuthViewModel>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fieldFill = isDark ? const Color(0xFF252D18) : Colors.white;

    return Scaffold(
      body: AppLoader(
        isLoading: authViewModel.isLoading,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.auto_stories,
                            size: 60, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(l10n.welcomeBack, style: context.ts.h1),
                    const SizedBox(height: 8),
                    Text(l10n.signInSubtitle,
                        style: context.ts.bodyMedium
                            .copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 40),

                    Text(l10n.emailAddress, style: context.ts.labelMedium),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return l10n.emailRequired;
                        }
                        if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(v)) {
                          return l10n.emailInvalid;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: l10n.emailHint,
                        prefixIcon: const Icon(Icons.email_outlined,
                            color: AppColors.primary),
                        filled: true,
                        fillColor: fieldFill,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(l10n.password, style: context.ts.labelMedium),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_showPassword,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return l10n.passwordRequired;
                        }
                        if (v.length < 6) {
                          return l10n.passwordTooShort;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: l10n.passwordHint,
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
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (v) =>
                                  setState(() => _rememberMe = v ?? false),
                              activeColor: AppColors.primary,
                            ),
                            Text(l10n.rememberMe, style: context.ts.bodySmall),
                          ],
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(
                              context, AppRoutes.forgotPassword),
                          child: Text(l10n.forgotPassword,
                              style: context.ts.bodySmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: authViewModel.isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(l10n.login,
                                style: context.ts.labelMedium.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        if (_canCheckBiometrics) ...[
                          const SizedBox(width: 12),
                          InkWell(
                            onTap: _handleBiometricLogin,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.primary),
                              ),
                              child: const Icon(Icons.fingerprint, color: AppColors.primary, size: 30),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ── Social Login ─────────────────────────────────────────
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
                        _socialButton(
                          Icons.g_mobiledata, 
                          'Google', 
                          () => _handleSocialLogin(() => authViewModel.signInWithGoogle()),
                        ),
                        _socialButton(
                          Icons.facebook, 
                          'Facebook',
                          () => _handleSocialLogin(() => authViewModel.signInWithFacebook()),
                        ),
                        _socialButton(
                          Icons.apple, 
                          'Apple',
                          () => _handleSocialLogin(() => authViewModel.signInWithApple()),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    Center(
                      child: GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.signup),
                        child: Text.rich(TextSpan(
                          text: l10n.dontHaveAccount,
                          style: context.ts.bodySmall,
                          children: [
                            TextSpan(
                              text: l10n.signUp,
                              style: context.ts.labelMedium
                                  .copyWith(color: AppColors.primary),
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
      ),
    );
  }

  Widget _socialButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
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
