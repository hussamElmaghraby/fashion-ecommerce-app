import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/utils/s.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final s = context.s;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          s.account,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),

            // Profile Header
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    authState.user?.fullName ?? s.guestUser,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    authState.user?.email ?? s.notLoggedIn,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Menu Items
            _buildMenuSection(
              context,
              title: s.account,
              items: [
                _MenuItem(
                  icon: Icons.person_outline,
                  title: s.editProfile,
                  onTap: () {
                    // Navigate to edit profile
                  },
                ),
                _MenuItem(
                  icon: Icons.location_on_outlined,
                  title: s.addresses,
                  onTap: () => context.push('/address'),
                ),
                _MenuItem(
                  icon: Icons.credit_card_outlined,
                  title: s.paymentMethods,
                  onTap: () => context.push('/payment'),
                ),
              ],
            ),

            const Divider(height: 1),

            _buildMenuSection(
              context,
              title: s.preferences,
              items: [
                _MenuItem(
                  icon: Icons.notifications_outlined,
                  title: s.notifications,
                  onTap: () {
                    // Navigate to notifications settings
                  },
                ),
                _MenuItem(
                  icon: Icons.language_outlined,
                  title: s.language,
                  subtitle: ref.watch(localeProvider).languageCode == 'ar'
                      ? s.arabic
                      : s.english,
                  onTap: () {
                    _showLanguageDialog(context, ref);
                  },
                ),
                _MenuItem(
                  icon: Icons.dark_mode_outlined,
                  title: s.darkMode,
                  trailing: Switch(
                    value: false,
                    onChanged: (value) {
                      // Toggle dark mode
                    },
                  ),
                ),
              ],
            ),

            const Divider(height: 1),

            _buildMenuSection(
              context,
              title: s.support,
              items: [
                _MenuItem(
                  icon: Icons.help_outline,
                  title: s.helpCenter,
                  onTap: () {
                    // Navigate to help
                  },
                ),
                _MenuItem(
                  icon: Icons.privacy_tip_outlined,
                  title: s.privacyPolicy,
                  onTap: () {
                    // Navigate to privacy policy
                  },
                ),
                _MenuItem(
                  icon: Icons.description_outlined,
                  title: s.termsConditions,
                  onTap: () {
                    // Navigate to terms
                  },
                ),
              ],
            ),

            const Divider(height: 1),

            // Logout Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // Show logout confirmation
                    showDialog(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: Text(s.logout),
                        content: Text(s.logoutConfirm),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: Text(s.cancel),
                          ),
                          TextButton(
                            onPressed: () {
                              ref.read(authStateProvider.notifier).logout();
                              Navigator.pop(dialogContext);
                              context.go('/login');
                            },
                            child: Text(
                              s.logout,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    s.logout,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.read(localeProvider);
    final s = context.s;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(s.selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text(s.english),
              value: 'en',
              groupValue: currentLocale.languageCode,
              onChanged: (value) {
                if (value != null) {
                  ref.read(localeProvider.notifier).setLocale(Locale(value));
                  Navigator.pop(dialogContext);
                }
              },
            ),
            RadioListTile<String>(
              title: Text(s.arabic),
              value: 'ar',
              groupValue: currentLocale.languageCode,
              onChanged: (value) {
                if (value != null) {
                  ref.read(localeProvider.notifier).setLocale(Locale(value));
                  Navigator.pop(dialogContext);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(s.cancel),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(
    BuildContext context, {
    required String title,
    required List<_MenuItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        ...items.map((item) => _buildMenuItem(item)),
      ],
    );
  }

  Widget _buildMenuItem(_MenuItem item) {
    return ListTile(
      leading: Icon(item.icon, color: AppColors.textPrimary, size: 24),
      title: Text(
        item.title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: item.subtitle != null
          ? Text(
              item.subtitle!,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            )
          : null,
      trailing:
          item.trailing ??
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: item.onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  _MenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });
}
