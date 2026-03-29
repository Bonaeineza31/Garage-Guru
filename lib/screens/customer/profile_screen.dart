import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garage_guru/theme/app_theme.dart';
import 'package:garage_guru/widgets/customer_header.dart';
import 'package:garage_guru/screens/auth/login_screen.dart';
import 'package:garage_guru/screens/customer/my_vehicles_screen.dart';
import 'package:garage_guru/screens/customer/notifications_screen.dart';
import 'package:garage_guru/screens/customer/edit_profile_screen.dart';
import 'package:garage_guru/screens/customer/account_settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _displayName = '';
  String _email = '';
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return;

    String name = firebaseUser.displayName ?? '';
    if (name.isEmpty) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();
      name = doc.data()?['name'] ?? firebaseUser.email?.split('@').first ?? 'User';
    }

    if (mounted) {
      setState(() {
        _displayName = name;
        _email = firebaseUser.email ?? '';
        _photoUrl = firebaseUser.photoURL;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayName = _displayName.isEmpty ? '...' : _displayName;
    final email = _email;
    final photoUrl = _photoUrl;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
          child: SafeArea(
          child: CustomerHeader(showSearch: false),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: const BoxDecoration(
                color: AppColors.primary,
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : const NetworkImage('https://i.pravatar.cc/150?img=1'),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                          ),
                          child: const Icon(Icons.camera_alt_outlined, color: AppColors.primary, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    displayName,
                    style: AppTextStyles.heading2.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => EditProfileScreen()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        border: Border.all(color: Colors.white30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.edit_note_rounded, color: Colors.white, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            'Edit Profile',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildProfileMenuItem(
              icon: Icons.directions_car_outlined,
              title: 'My Vehicles',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => MyVehiclesScreen()),
                );
              },
            ),
            _buildProfileMenuItem(
              icon: Icons.notifications_none_rounded,
              title: 'Notifications',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => NotificationsScreen()),
                );
              },
            ),
            _buildProfileMenuItem(
              icon: Icons.person_outline_rounded,
              title: 'Account Settings',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => AccountSettingsScreen()),
                );
              },
            ),
            _buildLogoutItem(context),
            const SizedBox(height: AppSpacing.xl),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('App Information', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text('Version: 1.0.0', style: Theme.of(context).textTheme.bodySmall),
                  Text('© 2026 GarageGuru', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenuItem({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.chevron_right, color: Theme.of(context).hintColor, size: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      shape: Border(bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1)),
    );
  }

  Widget _buildLogoutItem(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => LoginScreen()),
          (route) => false,
        );
      },
      leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
      title: Text('Logout', style: AppTextStyles.body.copyWith(color: Colors.redAccent, fontWeight: FontWeight.w500)),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
    );
  }
}
