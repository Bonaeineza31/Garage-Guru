import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garage_guru/core/theme/app_theme.dart';
import 'package:garage_guru/data/mock_data.dart';
import 'package:garage_guru/widgets/widgets.dart';
import 'package:garage_guru/screens/auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<Map<String, dynamic>?> _fetchUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      return doc.data();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _fetchUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final authUser = FirebaseAuth.instance.currentUser;
        final userData = snapshot.data;
        final name = userData?['name'] ?? authUser?.displayName ?? 'New User';
        final email = userData?['email'] ?? authUser?.email ?? 'No email connected';
        final profileImageUrl = userData?['profileImageUrl'] ?? 'https://i.pravatar.cc/150?img=12';

        return Scaffold(
          appBar: AppBar(
        title: Text('Profile', style: AppTextStyles.heading3.copyWith(color: Colors.white)),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xxl),
              decoration: BoxDecoration(
                gradient: AppColors.heroGradient,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(AppRadius.xxl),
                ),
              ),
              child: Column(
                children: [
                  UserAvatar(
                    imageUrl: profileImageUrl,
                    name: name,
                    radius: 44,
                    showBadge: true,
                    badgeColor: AppColors.success,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    name,
                    style: AppTextStyles.heading3.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStat('Bookings', '${MockData.bookings.length}'),
                      Container(width: 1, height: 30, color: Colors.white24),
                      _buildStat('Reviews', '12'),
                      Container(width: 1, height: 30, color: Colors.white24),
                      _buildStat('Saved', '4'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                children: [
                  _buildMenuItem(
                    context,
                    Icons.person_outline,
                    'Edit Profile',
                    'Update your personal information',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context,
                    Icons.directions_car_outlined,
                    'My Vehicles',
                    'Manage your registered vehicles',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context,
                    Icons.favorite_outline,
                    'Saved Garages',
                    'Your favorite garages',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context,
                    Icons.payment,
                    'Payment Methods',
                    'Manage cards and payment options',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context,
                    Icons.notifications_outlined,
                    'Notifications',
                    'Configure your notification preferences',
                    badge: '3',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context,
                    Icons.help_outline,
                    'Help & Support',
                    'FAQs, contact us, and feedback',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context,
                    Icons.info_outline,
                    'About',
                    'App version, terms, and privacy',
                    onTap: () {},
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  GgButton(
                    label: 'Sign Out',
                    color: AppColors.error,
                    icon: Icons.logout,
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      if (!context.mounted) return;
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
      },
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.heading3.copyWith(color: Colors.white),
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle, {
    String? badge,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.divider.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.subtitle.copyWith(fontSize: 15)),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
            const SizedBox(width: AppSpacing.sm),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}