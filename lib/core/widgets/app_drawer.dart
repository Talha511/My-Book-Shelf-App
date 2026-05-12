import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickalert/quickalert.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/routes/app_routes.dart';
import 'package:provider/provider.dart' as p;
import '../theme/theme_provider.dart';
import '../theme/locale_provider.dart';
import 'zoom_drawer_wrapper.dart';
import '../../presentation/viewmodels/auth_viewmodel.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final locale = ref.watch(localeProvider);
    final currentLang = supportedLanguages.firstWhere(
      (l) => l.code == locale.languageCode,
      orElse: () => supportedLanguages.first,
    );
    final currentRoute = ModalRoute.of(context)?.settings.name;
    
    // AuthViewModel se user data lena
    final authViewModel = p.Provider.of<AuthViewModel>(context);
    final user = authViewModel.currentUser;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 280,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 70),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Profile Header ---
                    _buildProfileHeader(context),
                    
                    const SizedBox(height: 24),
                    // --- User Stats ---
                    _buildDrawerStats(context),

                    const SizedBox(height: 32),
                    // --- Navigation Items ---
                    _MenuItem(
                      icon: Icons.home_rounded,
                      label: 'Home',
                      isSelected: currentRoute == AppRoutes.home,
                      onTap: () => _navigate(context, AppRoutes.home),
                    ),
                    _MenuItem(
                      icon: Icons.favorite_rounded,
                      label: 'My Favorites',
                      isSelected: currentRoute == AppRoutes.favorites,
                      onTap: () => _navigate(context, AppRoutes.favorites),
                    ),
                    _MenuItem(
                      icon: Icons.download_for_offline_rounded,
                      label: 'Downloads',
                      isSelected: currentRoute == AppRoutes.downloads,
                      onTap: () => _navigate(context, AppRoutes.downloads),
                    ),
                    _MenuItem(
                      icon: Icons.history_rounded,
                      label: 'Reading History',
                      isSelected: currentRoute == AppRoutes.readingHistory,
                      onTap: () => _navigate(context, AppRoutes.readingHistory),
                    ),
                    
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: Colors.white24, indent: 8, endIndent: 32),
                    ),

                    // --- Quick Controls ---
                    _buildQuickToggle(
                      icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                      label: l10n.darkMode,
                      value: isDark,
                      onChanged: (val) => ref.read(themeProvider.notifier).state = val ? ThemeMode.dark : ThemeMode.light,
                    ),
                    
                    _MenuItem(
                      icon: Icons.language_rounded,
                      label: '${currentLang.flag} Language',
                      onTap: () => _showLanguageSheet(context, ref, currentLang),
                    ),

                    _MenuItem(
                      icon: Icons.help_outline_rounded,
                      label: 'Help Center',
                      onTap: () => _navigate(context, AppRoutes.helpCenter),
                    ),

                    _MenuItem(
                      icon: Icons.privacy_tip_outlined,
                      label: 'Privacy Policy',
                      onTap: () => _navigate(context, AppRoutes.privacyPolicy),
                    ),
                  ],
                ),
              ),
            ),
            
            const Divider(color: Colors.white10),
            
            // --- Logout & Delete ---
            _MenuItem(
              icon: Icons.logout_rounded,
              label: 'Logout',
              isDestructive: true,
              onTap: () => _handleLogout(context, l10n),
            ),
            _MenuItem(
              icon: Icons.delete_forever_rounded,
              label: 'Delete Account',
              isDestructive: true,
              onTap: () => _handleDeleteAccount(context),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final authViewModel = p.Provider.of<AuthViewModel>(context);
    final user = authViewModel.currentUser;
    final userName = user?.name ?? 'User';
    final userEmail = user?.email ?? 'guest@example.com';
    final profileImage = user?.profileImage;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
          child: CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primary,
            backgroundImage: profileImage != null 
              ? FileImage(File(profileImage)) 
              : NetworkImage('https://ui-avatars.com/api/?name=${userName.replaceAll(' ', '+')}&background=384325&color=fff') as ImageProvider,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: context.ts.h3.copyWith(color: Colors.white, fontSize: 18)),
              Text(userEmail, style: const TextStyle(color: Colors.white60, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDrawerStats(BuildContext context) {
    return Row(
      children: [
        _statItem('12', 'Read'),
        _statDivider(),
        _statItem('5', 'Reading'),
        _statDivider(),
        _statItem('20', 'Favs'),
      ],
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10)),
      ],
    );
  }

  Widget _statDivider() => Container(
    margin: const EdgeInsets.symmetric(horizontal: 15),
    height: 20, width: 1, color: Colors.white12,
  );

  Widget _buildQuickToggle({required IconData icon, required String label, required bool value, required ValueChanged<bool> onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 22),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const Spacer(),
          Transform.scale(
            scale: 0.7,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: Colors.white,
              activeTrackColor: Colors.white24,
            ),
          ),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, String route) {
    ZoomDrawerWrapper.of(context)?.toggle();
    if (ModalRoute.of(context)?.settings.name != route) {
      Navigator.pushNamed(context, route);
    }
  }

  void _handleLogout(BuildContext context, AppLocalizations l10n) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: l10n.logout,
      text: l10n.logoutConfirm,
      onConfirmBtnTap: () {
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
      },
    );
  }

  void _handleDeleteAccount(BuildContext context) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      title: 'Delete Account?',
      text: 'This action is permanent and cannot be undone.',
      confirmBtnText: 'Delete',
      confirmBtnColor: Colors.red,
      onConfirmBtnTap: () {
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
      },
    );
  }

  void _showLanguageSheet(BuildContext context, WidgetRef ref, AppLanguage current) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          ...supportedLanguages.map((lang) => ListTile(
            leading: Text(lang.flag, style: const TextStyle(fontSize: 24)),
            title: Text(lang.nativeName),
            trailing: lang.code == current.code ? const Icon(Icons.check, color: AppColors.primary) : null,
            onTap: () {
              ref.read(localeProvider.notifier).state = Locale(lang.code);
              Navigator.pop(ctx);
            },
          )),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isDestructive;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isSelected = false,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      leading: Icon(icon, color: isDestructive ? Colors.redAccent : (isSelected ? Colors.white : Colors.white70), size: 22),
      title: Text(
        label,
        style: TextStyle(
          color: isDestructive ? Colors.redAccent : (isSelected ? Colors.white : Colors.white70),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
        ),
      ),
    );
  }
}
