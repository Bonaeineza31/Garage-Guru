import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:garage_guru/core/theme/theme_provider.dart';
import 'package:garage_guru/core/theme/app_theme.dart';
import 'package:garage_guru/data/mock_data.dart';
import 'package:garage_guru/screens/auth/login_screen.dart';
import 'package:garage_guru/screens/customer/personal_information_screen.dart';
import 'package:garage_guru/screens/customer/security_screen.dart';
import 'package:garage_guru/screens/customer/notifications_screen.dart';
import 'package:garage_guru/screens/customer/privacy_policy_screen.dart';
import 'package:garage_guru/screens/customer/terms_of_service_screen.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  // These are placeholders — not yet implemented
  bool _darkModeEnabled = false;
  bool _biometricEnabled = false;

  @override
  Widget build(BuildContext context) {
    final user = MockData.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Account Settings',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User header card
            Container(
              color: Theme.of(context).cardColor,
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(
                      user.profileImageUrl ?? 'https://i.pravatar.cc/150?img=1',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.fullName,
                          style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user.email,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color ?? AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          user.phone,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color ?? AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Theme.of(context).cardColor,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PersonalInformationScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
                ),
                child: const Text('Edit Profile', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Account Settings section
            _buildSectionHeader('Account Settings'),
            _buildNavItem(
              icon: Icons.person_outline,
              title: 'Personal Information',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PersonalInformationScreen()),
              ),
            ),
            _buildNavItem(
              icon: Icons.shield_outlined,
              title: 'Security',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SecurityScreen()),
              ),
            ),
            _buildNavItem(
              icon: Icons.notifications_none_outlined,
              title: 'Notifications',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              ),
            ),
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, _) {
                return _buildToggleItem(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode',
                  value: themeProvider.isDarkMode,
                  onChanged: (v) {
                    themeProvider.toggleTheme(v);
                  },
                );
              },
            ),
            _buildToggleItem(
              icon: Icons.fingerprint,
              title: 'Biometric Login',
              value: _biometricEnabled,
              onChanged: (v) => setState(() => _biometricEnabled = v),
            ),
            const SizedBox(height: AppSpacing.md),

            // About & Legal section
            _buildSectionHeader('About & Legal'),
            _buildNavItem(
              icon: Icons.info_outline,
              title: 'About Pickovo',
              onTap: () {},
            ),
            _buildNavItem(
              icon: Icons.article_outlined,
              title: 'Terms of Service',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const TermsOfServiceScreen()),
              ),
            ),
            _buildNavItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Log Out button
            Container(
              color: Theme.of(context).cardColor,
              child: ListTile(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Log Out'),
                      content: const Text('Are you sure you want to log out?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => const LoginScreen()),
                              (route) => false,
                            );
                          },
                          child: Text('Log Out', style: TextStyle(color: AppColors.error)),
                        ),
                      ],
                    ),
                  );
                },
                leading: Icon(Icons.logout_rounded, color: AppColors.error),
                title: Text(
                  'Log Out',
                  style: AppTextStyles.body.copyWith(color: AppColors.error, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      child: Text(
        title,
        style: AppTextStyles.label.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required String title, required VoidCallback onTap}) {
    return Container(
      color: Theme.of(context).cardColor,
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary.withOpacity(0.7), size: 22),
        title: Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500)),
        trailing: Icon(Icons.chevron_right, color: Theme.of(context).textTheme.bodySmall?.color ?? AppColors.textSecondary, size: 20),
        shape: Border(bottom: BorderSide(color: AppColors.divider.withOpacity(0.2))),
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      color: Theme.of(context).cardColor,
      child: ListTile(
        leading: Icon(icon, color: AppColors.textSecondary, size: 22),
        title: Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500)),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
        shape: Border(bottom: BorderSide(color: AppColors.divider.withOpacity(0.5))),
      ),
    );
  }
}
