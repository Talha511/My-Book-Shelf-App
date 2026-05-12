import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quickalert/quickalert.dart';
import 'package:provider/provider.dart' as p;
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/zoom_drawer_wrapper.dart';
import '../../generated/l10n/app_localizations.dart';
import '../viewmodels/auth_viewmodel.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final LocalAuthentication _auth = LocalAuthentication();
  bool _isBiometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadBiometricStatus();
  }

  Future<void> _loadBiometricStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isBiometricEnabled = (prefs.getBool('use_biometrics') ?? false) || 
                            (prefs.getBool('use_face_lock') ?? false);
    });
  }

  Future<void> _toggleBiometrics(bool value) async {
    if (!value) {
      // Disabling biometrics
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('use_biometrics', false);
      await prefs.setBool('use_face_lock', false);
      setState(() => _isBiometricEnabled = false);
      return;
    }

    // Enabling biometrics - Registration required
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool isSupported = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();

      if (!isSupported) {
        if (!mounted) return;
        _showErrorAlert('Your device does not support biometric features.');
        return;
      }

      final List<BiometricType> availableBiometrics = await _auth.getAvailableBiometrics();
      if (availableBiometrics.isEmpty) {
        if (!mounted) return;
        _showErrorAlert('No biometrics found. Please set up Fingerprint/Face ID in your phone settings first.');
        return;
      }

      // Trigger authentication to verify before enabling
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Please authenticate to enable biometric login',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (didAuthenticate && mounted) {
        final prefs = await SharedPreferences.getInstance();
        // Default to 'use_biometrics' if any are available
        await prefs.setBool('use_biometrics', true);
        setState(() => _isBiometricEnabled = true);
        
        if (!mounted) return;
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Enabled!',
          text: 'Biometric login has been activated.',
          confirmBtnColor: AppColors.primary,
        );
      }
    } catch (e) {
      debugPrint('Biometric Error: $e');
    }
  }

  void _showErrorAlert(String message) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Failed',
      text: message,
      confirmBtnColor: Colors.redAccent,
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        
        // Save to ViewModel
        if (mounted) {
          p.Provider.of<AuthViewModel>(context, listen: false).updateProfileImage(pickedFile.path);
        }
        
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Text(l10n.profileImageUpdated),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _showImageSourceSheet() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Text(l10n.profilePhoto, style: context.ts.h3),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.primary),
              title: Text(l10n.pickFromCamera),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.primary),
              title: Text(l10n.pickFromGallery),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authViewModel = p.Provider.of<AuthViewModel>(context);
    final user = authViewModel.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.accountDetails),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => ZoomDrawerWrapper.of(context)?.toggle(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildLargeAvatar(context, user?.name ?? 'User'),
            const SizedBox(height: 24),
            Text(user?.name ?? 'User', style: context.ts.h2),
            Text('${l10n.memberSince} Oct 2023', style: context.ts.bodySmall),
            const SizedBox(height: 40),
            
            _buildProfileCard(context, [
              _profileTile(Icons.person_outline, l10n.fullName, user?.name ?? '---'),
              _profileTile(Icons.email_outlined, l10n.emailAddress, user?.email ?? '---'),
              _profileTile(Icons.phone_android_outlined, l10n.phoneNumber, user?.phoneNumber ?? '---'),
            ]),
            
            const SizedBox(height: 24),
            
            _buildProfileCard(context, [
              _profileTile(
                Icons.lock_outline, 
                l10n.password, 
                '••••••••', 
                trailing: 'Change',
                onTap: () => _showChangePasswordDialog(context),
              ),
              _profileTile(
                Icons.fingerprint, 
                l10n.biometricLogin, 
                _isBiometricEnabled ? 'Enabled' : 'Disabled', 
                isSwitch: true,
                switchValue: _isBiometricEnabled,
                onSwitchChanged: _toggleBiometrics,
              ),
            ]),
            
            const SizedBox(height: 32),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(l10n.editAccountSettings),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                  Text(l10n.changePassword, style: context.ts.h3),
                  const SizedBox(height: 8),
                  Text(l10n.passwordProtectionHint, style: context.ts.bodySmall),
                  const SizedBox(height: 24),
                  _buildPasswordField(
                    context: context,
                    label: l10n.currentPassword,
                    controller: currentPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) return l10n.passwordRequired;
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildPasswordField(
                    context: context,
                    label: l10n.newPassword,
                    controller: newPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) return l10n.passwordRequired;
                      if (value.length < 6) return l10n.passwordTooShort;
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildPasswordField(
                    context: context,
                    label: l10n.confirmPassword,
                    controller: confirmPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) return l10n.confirmPasswordRequired;
                      if (value != newPasswordController.text) return l10n.passwordsDoNotMatch;
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
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.success),
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
                      child: Text(l10n.updatePassword, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

  Widget _buildLargeAvatar(BuildContext context, String name) {
    final authViewModel = p.Provider.of<AuthViewModel>(context);
    final user = authViewModel.currentUser;

    return Center(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary, width: 2),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[200],
              backgroundImage: user?.profileImage != null 
                  ? FileImage(File(user!.profileImage!))
                  : NetworkImage('https://ui-avatars.com/api/?name=${name.replaceAll(' ', '+')}&size=200&background=384325&color=fff') as ImageProvider,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 4,
            child: GestureDetector(
              onTap: _showImageSourceSheet,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(children: children),
    );
  }

  Widget _profileTile(
    IconData icon, 
    String label, 
    String value, {
    String? trailing, 
    bool isSwitch = false, 
    bool switchValue = false,
    ValueChanged<bool>? onSwitchChanged,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
      title: Text(label, style: context.ts.bodySmall.copyWith(color: AppColors.textSecondary)),
      subtitle: Text(value, style: context.ts.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
      trailing: isSwitch 
          ? Switch(
              value: switchValue, 
              onChanged: onSwitchChanged, 
              activeThumbColor: AppColors.primary,
            )
          : (trailing != null 
              ? TextButton(
                  onPressed: onTap,
                  child: Text(trailing, style: context.ts.labelMedium.copyWith(color: AppColors.primary)),
                ) 
              : Icon(Icons.chevron_right, color: AppColors.textSecondary.withValues(alpha: 0.5))),
    );
  }
}
