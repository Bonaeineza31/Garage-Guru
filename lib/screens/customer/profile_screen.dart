import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garage_guru/core/auth/auth_service.dart';
import 'package:garage_guru/core/theme/app_theme.dart';
import 'package:garage_guru/widgets/widgets.dart';
import 'package:garage_guru/screens/customer/my_vehicles_screen.dart';
import 'package:garage_guru/screens/customer/notifications_screen.dart';
import 'package:garage_guru/screens/customer/edit_profile_screen.dart';
import 'package:garage_guru/screens/customer/account_settings_screen.dart';

<<<<<<< HEAD
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
=======
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser;
    if (authUser == null) {
      return const Scaffold(body: Center(child: Text('Not signed in.')));
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('users').doc(authUser.uid).snapshots(),
      builder: (context, docSnap) {
        final data = docSnap.data?.data();
        final displayName = (data?['name'] as String?)?.trim();
        final firestoreEmail = (data?['email'] as String?)?.trim();
        final fullName = (displayName != null && displayName.isNotEmpty)
            ? displayName
            : (authUser.displayName ?? 'User');
        final email = (firestoreEmail != null && firestoreEmail.isNotEmpty)
            ? firestoreEmail
            : (authUser.email ?? '');
        final photoUrl = authUser.photoURL;

        return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: const Text(
                'G',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'GarageGuru',
              style: AppTextStyles.subtitle.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined, color: AppColors.textSecondary),
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.divider, height: 1),
>>>>>>> 5d9c514 (firebase data)
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
<<<<<<< HEAD
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
=======
                        decoration: const BoxDecoration(
                          color: Colors.white,
>>>>>>> 5d9c514 (firebase data)
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 50,
<<<<<<< HEAD
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
=======
                          backgroundImage: NetworkImage(
                            photoUrl ?? 'https://i.pravatar.cc/150?img=1',
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                        ),
                        child: Icon(Icons.camera_alt_outlined, color: AppColors.primary, size: 20),
>>>>>>> 5d9c514 (firebase data)
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
<<<<<<< HEAD
                    displayName,
=======
                    fullName,
>>>>>>> 5d9c514 (firebase data)
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
<<<<<<< HEAD
                        MaterialPageRoute(builder: (_) => EditProfileScreen()),
=======
                        MaterialPageRoute(builder: (_) => const EditProfileScreen()),
>>>>>>> 5d9c514 (firebase data)
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
<<<<<<< HEAD
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 11),
=======
                            style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
>>>>>>> 5d9c514 (firebase data)
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
<<<<<<< HEAD
                  MaterialPageRoute(builder: (_) => MyVehiclesScreen()),
=======
                  MaterialPageRoute(builder: (_) => const MyVehiclesScreen()),
>>>>>>> 5d9c514 (firebase data)
                );
              },
            ),
            _buildProfileMenuItem(
              icon: Icons.notifications_none_rounded,
              title: 'Notifications',
              onTap: () {
                Navigator.of(context).push(
<<<<<<< HEAD
                  MaterialPageRoute(builder: (_) => NotificationsScreen()),
=======
                  MaterialPageRoute(builder: (_) => const NotificationsScreen()),
>>>>>>> 5d9c514 (firebase data)
                );
              },
            ),
            _buildProfileMenuItem(
              icon: Icons.person_outline_rounded,
              title: 'Account Settings',
              onTap: () {
                Navigator.of(context).push(
<<<<<<< HEAD
                  MaterialPageRoute(builder: (_) => AccountSettingsScreen()),
=======
                  MaterialPageRoute(builder: (_) => const AccountSettingsScreen()),
>>>>>>> 5d9c514 (firebase data)
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
<<<<<<< HEAD
                  Text('App Information', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text('Version: 1.0.0', style: Theme.of(context).textTheme.bodySmall),
                  Text('© 2026 GarageGuru', style: Theme.of(context).textTheme.bodySmall),
=======
                  Text('App Information', style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Version: 1.0.0', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                  Text('© 2026 GarageGuru', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
>>>>>>> 5d9c514 (firebase data)
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
<<<<<<< HEAD
=======
        );
      },
>>>>>>> 5d9c514 (firebase data)
    );
  }

  Widget _buildProfileMenuItem({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.primary),
<<<<<<< HEAD
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.chevron_right, color: Theme.of(context).hintColor, size: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      shape: Border(bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1)),
=======
      title: Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      shape: const Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
>>>>>>> 5d9c514 (firebase data)
    );
  }

  Widget _buildLogoutItem(BuildContext context) {
    return ListTile(
<<<<<<< HEAD
      onTap: () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => LoginScreen()),
          (route) => false,
        );
=======
      onTap: () async {
        await AuthService.signOut();
>>>>>>> 5d9c514 (firebase data)
      },
      leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
      title: Text('Logout', style: AppTextStyles.body.copyWith(color: Colors.redAccent, fontWeight: FontWeight.w500)),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
    );
  }
}
