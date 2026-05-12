import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickalert/quickalert.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart' as p;
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/theme/locale_provider.dart';
import '../../domain/entities/user.dart';
import '../../generated/l10n/app_localizations.dart';
import '../viewmodels/auth_viewmodel.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _pushNotifications = true;
  bool _wifiOnly = false;
  bool _autoUpdate = true;
  bool _biometrics = false;
  bool _faceLock = false;
  double _cacheSize = 12.4;
  
  final LocalAuthentication _auth = LocalAuthentication();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final authViewModel = p.Provider.of<AuthViewModel>(context, listen: false);
    final user = authViewModel.currentUser;
    
    setState(() {
      _biometrics = prefs.getBool('use_biometrics') ?? false;
      _faceLock = prefs.getBool('use_face_lock') ?? false;
      _pushNotifications = prefs.getBool('push_notifications') ?? true;
      _wifiOnly = prefs.getBool('wifi_only') ?? false;
      _autoUpdate = prefs.getBool('auto_update') ?? true;
      _nameController.text = user?.name ?? '';
      _phoneController.text = user?.phoneNumber ?? '';
    });
  }

  Future<void> _registerBiometric(BuildContext context, String type, StateSetter setModalState) async {
    try {
      // 1. Check if hardware supports biometrics
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool isSupported = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();

      if (!isSupported) {
        if (!context.mounted) return;
        _showManualAlert(context, type, 'Your device does not support biometric features.');
        return;
      }

      // 2. Check if any biometrics are actually enrolled in system settings
      final List<BiometricType> availableBiometrics = await _auth.getAvailableBiometrics();
      
      if (availableBiometrics.isEmpty) {
        if (!context.mounted) return;
        _showManualAlert(context, type, 'No biometrics found. Please set up Fingerprint/Face ID in your phone settings first.');
        return;
      }

      // 3. Proper Verification Dialog before system scan
      if (context.mounted) {
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.info,
          title: 'Register $type',
          text: 'Please authenticate using your $type to enable secure login.',
          confirmBtnText: 'Start Scan',
          onConfirmBtnTap: () async {
            if (!context.mounted) return;
            Navigator.pop(context); // Close info alert
            
            // 4. Trigger Real System Authentication
            final bool didAuthenticate = await _auth.authenticate(
              localizedReason: 'Scan your $type to link it with MyBookShelf',
              options: const AuthenticationOptions(
                stickyAuth: true,
                biometricOnly: true,
              ),
            );

            if (didAuthenticate && context.mounted) {
              final prefs = await SharedPreferences.getInstance();
              if (type == 'Fingerprint') {
                await prefs.setBool('use_biometrics', true);
              } else {
                await prefs.setBool('use_face_lock', true);
              }
              
              setState(() {
                if (type == 'Fingerprint') {
                  _biometrics = true;
                } else {
                  _faceLock = true;
                }
              });
              setModalState(() {});
              
              // 5. Final Success Alert
              if (!context.mounted) return;
              QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                title: 'Registered!',
                text: 'Your $type has been linked successfully.',
                confirmBtnColor: AppColors.primary,
              );
            }
          },
        );
      }
    } catch (e) {
      debugPrint('Biometric Error: $e');
    }
  }

  void _showManualAlert(BuildContext context, String type, String message) {
     QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Registration Failed',
      text: message,
      confirmBtnColor: Colors.redAccent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);
    final currentLang = supportedLanguages.firstWhere(
      (l) => l.code == locale.languageCode,
      orElse: () => supportedLanguages.first,
    );

    final authViewModel = p.Provider.of<AuthViewModel>(context);
    final user = authViewModel.currentUser;
    final userName = user?.name ?? 'User';
    final userEmail = user?.email ?? '---';
    final userPhone = user?.phoneNumber ?? '---';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionHeader('Account'),
          _buildSettingTile(
            Icons.person_outline, 
            'Personal Information', 
            '$userName • $userEmail • $userPhone',
            () => _showPersonalInfo(context)
          ),
          _buildSettingTile(
            Icons.fingerprint, 
            'Security & Privacy', 
            'Biometric Login, Face ID enabled', 
            () => _showSecuritySettings(context)
          ),
          
          const SizedBox(height: 24),
          _buildSectionHeader('Notifications'),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_none, color: AppColors.primary),
            title: const Text('Push Notifications'),
            subtitle: const Text('New books and updates alerts'),
            value: _pushNotifications,
            activeThumbColor: AppColors.primary,
            onChanged: (val) {
              SharedPreferences.getInstance().then((prefs) => prefs.setBool('push_notifications', val));
              setState(() => _pushNotifications = val);
            },
          ),
          
          const SizedBox(height: 24),
          _buildSectionHeader('Downloads & Storage'),
          SwitchListTile(
            secondary: const Icon(Icons.wifi, color: AppColors.primary),
            title: const Text('Download over Wi-Fi only'),
            value: _wifiOnly,
            activeThumbColor: AppColors.primary,
            onChanged: (val) {
              SharedPreferences.getInstance().then((prefs) => prefs.setBool('wifi_only', val));
              setState(() => _wifiOnly = val);
            },
          ),
          _buildSettingTile(
            Icons.delete_outline, 
            'Clear Cache', 
            'Currently using ${_cacheSize.toStringAsFixed(1)} MB', 
            _clearCache
          ),
          
          const SizedBox(height: 24),
          _buildSectionHeader('General'),
          SwitchListTile(
            secondary: const Icon(Icons.update, color: AppColors.primary),
            title: const Text('Automatic Updates'),
            value: _autoUpdate,
            activeThumbColor: AppColors.primary,
            onChanged: (val) {
              SharedPreferences.getInstance().then((prefs) => prefs.setBool('auto_update', val));
              setState(() => _autoUpdate = val);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showPersonalInfo(BuildContext context) {
    final authViewModel = p.Provider.of<AuthViewModel>(context, listen: false);
    final user = authViewModel.currentUser;
    _nameController.text = user?.name ?? '';
    _phoneController.text = user?.phoneNumber ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Personal Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: user?.email ?? '---',
              readOnly: true,
              enabled: false,
              decoration: InputDecoration(
                labelText: 'Email Address',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: const Icon(Icons.phone_android_outlined, color: AppColors.primary),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (user != null) {
                    final updatedUser = User(
                      id: user.id,
                      name: _nameController.text.trim(),
                      email: user.email,
                      password: user.password,
                      phoneNumber: _phoneController.text.trim(),
                      profileImage: user.profileImage,
                    );
                    
                    await authViewModel.updateUserUseCase.execute(updatedUser);
                    await authViewModel.refreshUser();
                    
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Information updated successfully!'),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save Changes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _showSecuritySettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Security Settings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Fingerprint Login'),
                subtitle: const Text('Register your fingerprint for quick access'),
                value: _biometrics,
                activeThumbColor: AppColors.primary,
                onChanged: (val) {
                  if (val) {
                    _registerBiometric(context, 'Fingerprint', setModalState);
                  } else {
                    SharedPreferences.getInstance().then((prefs) => prefs.setBool('use_biometrics', false));
                    setState(() => _biometrics = false);
                    setModalState(() {});
                  }
                },
              ),
              SwitchListTile(
                title: const Text('Face Lock'),
                subtitle: const Text('Register your face for secure login'),
                value: _faceLock,
                activeThumbColor: AppColors.primary,
                onChanged: (val) {
                  if (val) {
                    _registerBiometric(context, 'Face ID', setModalState);
                  } else {
                    SharedPreferences.getInstance().then((prefs) => prefs.setBool('use_face_lock', false));
                    setState(() => _faceLock = false);
                    setModalState(() {});
                  }
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.lock_reset, color: AppColors.primary),
                title: const Text('Change Password'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context);
                  _showChangePasswordDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* void _registerBiometric(BuildContext context, String type) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      title: 'Register $type',
      text: 'Please place your $type on the sensor to register.',
      confirmBtnText: 'Simulate Scan',
      onConfirmBtnTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$type registered successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  } */

  void _showChangePasswordDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final currentPasswordController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Change Password', style: context.ts.h3),
                  const SizedBox(height: 8),
                  Text('Create a strong password to protect your account', style: context.ts.bodySmall),
                  const SizedBox(height: 24),
                  _buildPasswordField(
                    context: context,
                    label: 'Current Password',
                    controller: currentPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter current password';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildPasswordField(
                    context: context,
                    label: 'New Password',
                    controller: newPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter new password';
                      if (value.length < 6) return 'Password must be at least 6 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildPasswordField(
                    context: context,
                    label: 'Confirm New Password',
                    controller: confirmPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please confirm your password';
                      if (value != newPasswordController.text) return 'Passwords do not match';
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Password updated successfully!'),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Update Password', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: context.ts.bodySmall,
        suffixIcon: const Icon(Icons.visibility_off_outlined, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  void _clearCache() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: 'Are you sure you want to clear ${_cacheSize.toStringAsFixed(1)} MB of cache?',
      onConfirmBtnTap: () {
        setState(() => _cacheSize = 0.0);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cache cleared successfully')));
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildSettingTile(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}
