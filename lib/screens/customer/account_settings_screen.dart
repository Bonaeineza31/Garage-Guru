import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:garage_guru/theme/app_theme.dart';
import 'package:garage_guru/data/mock_data.dart';
import 'package:garage_guru/main.dart';
import 'package:garage_guru/screens/auth/login_screen.dart';
import 'package:garage_guru/screens/customer/personal_information_screen.dart';
import 'package:garage_guru/screens/customer/security_screen.dart';
import 'package:garage_guru/screens/customer/notifications_screen.dart';
import 'package:garage_guru/screens/customer/privacy_policy_screen.dart';
import 'package:garage_guru/screens/customer/terms_of_service_screen.dart';
import 'package:garage_guru/screens/customer/favorite_garages_screen.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  // Shared Preferences variables
  bool _darkModeEnabled = false;
  bool _emailNotifications = true;
  bool _locationServices = true;

  String _userName = 'Loading...';
  String _userEmail = 'Loading...';
  String _profileImageUrl = 'https://i.pravatar.cc/150?img=1';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _loadUserData();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkModeEnabled = prefs.getBool('dark_mode') ?? false;
      _emailNotifications = prefs.getBool('email_notifications') ?? true;
      _locationServices = prefs.getBool('location_services') ?? true;
    });
  }

  Future<void> _savePreference(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _loadUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        _userEmail = currentUser.email ?? 'No email';
        _userName = currentUser.displayName ?? 'Loading...';
        if (currentUser.photoURL != null) {
          _profileImageUrl = currentUser.photoURL!;
        }
      });
      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
        if (doc.exists && mounted) {
          final data = doc.data()!;
          setState(() {
            _userName = data['name'] ?? _userName;
          });
        }
      } catch (e) {
        // ignore
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
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
              color: Colors.white,
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(_profileImageUrl),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userName,
                          style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _userEmail,
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
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
            _buildToggleItem(
              icon: Icons.dark_mode_outlined,
              title: 'Dark Mode',
              value: _darkModeEnabled,
              onChanged: (v) {
                setState(() => _darkModeEnabled = v);
                _savePreference('dark_mode', v);
                // Update global themeNotifier
                themeNotifier.value = v ? ThemeMode.dark : ThemeMode.light;
              },
            ),
            _buildToggleItem(
              icon: Icons.email_outlined,
              title: 'Email Notifications',
              value: _emailNotifications,
              onChanged: (v) {
                setState(() => _emailNotifications = v);
                _savePreference('email_notifications', v);
              },
            ),
            _buildToggleItem(
              icon: Icons.location_on_outlined,
              title: 'Location Services',
              value: _locationServices,
              onChanged: (v) {
                setState(() => _locationServices = v);
                _savePreference('location_services', v);
              },
            ),
            _buildNavItem(
              icon: Icons.favorite_border_rounded,
              title: 'Favorited Garages',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const FavoriteGaragesScreen()),
              ),
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
              color: Colors.white,
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
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required String title, required VoidCallback onTap}) {
    return Container(
      color: Colors.white,
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppColors.textSecondary, size: 22),
        title: Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
        shape: Border(bottom: BorderSide(color: AppColors.divider.withOpacity(0.5))),
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
      color: Colors.white,
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
