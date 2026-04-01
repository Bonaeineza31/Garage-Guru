import 'package:garage_guru/screens/customer/my_vehicles_screen.dart';
import 'package:garage_guru/screens/customer/notifications_screen.dart';
import 'package:garage_guru/screens/customer/edit_profile_screen.dart';
import 'package:garage_guru/screens/customer/account_settings_screen.dart';

<<<<<<< HEAD
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
          ),
        ),
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
=======
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
>>>>>>> 4022811fcd9f3b11667f026fa510b591aedd21d2
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
                        decoration: const BoxDecoration(
                          color: Colors.white,
=======
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
>>>>>>> 4022811fcd9f3b11667f026fa510b591aedd21d2
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 50,
<<<<<<< HEAD
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
=======
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
>>>>>>> 4022811fcd9f3b11667f026fa510b591aedd21d2
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
<<<<<<< HEAD
                    fullName,
=======
                    displayName,
>>>>>>> 4022811fcd9f3b11667f026fa510b591aedd21d2
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
                        MaterialPageRoute(builder: (_) => const EditProfileScreen()),
=======
                        MaterialPageRoute(builder: (_) => EditProfileScreen()),
>>>>>>> 4022811fcd9f3b11667f026fa510b591aedd21d2
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
                            style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
=======
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 11),
>>>>>>> 4022811fcd9f3b11667f026fa510b591aedd21d2
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
                  MaterialPageRoute(builder: (_) => const MyVehiclesScreen()),
=======
                  MaterialPageRoute(builder: (_) => MyVehiclesScreen()),
>>>>>>> 4022811fcd9f3b11667f026fa510b591aedd21d2
                );
              },
            ),
            _buildProfileMenuItem(
              icon: Icons.notifications_none_rounded,
              title: 'Notifications',
              onTap: () {
                Navigator.of(context).push(
<<<<<<< HEAD
                  MaterialPageRoute(builder: (_) => const NotificationsScreen()),
=======
                  MaterialPageRoute(builder: (_) => NotificationsScreen()),
>>>>>>> 4022811fcd9f3b11667f026fa510b591aedd21d2
                );
              },
            ),
            _buildProfileMenuItem(
              icon: Icons.person_outline_rounded,
              title: 'Account Settings',
              onTap: () {
                Navigator.of(context).push(
<<<<<<< HEAD
                  MaterialPageRoute(builder: (_) => const AccountSettingsScreen()),
=======
                  MaterialPageRoute(builder: (_) => AccountSettingsScreen()),
>>>>>>> 4022811fcd9f3b11667f026fa510b591aedd21d2
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
                  Text('App Information', style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Version: 1.0.0', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
<<<<<<< HEAD
                  Text('\u00a9 2026 GarageGuru', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
=======
                  Text('© 2026 GarageGuru', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
=======
                  Text('App Information', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text('Version: 1.0.0', style: Theme.of(context).textTheme.bodySmall),
                  Text('© 2026 GarageGuru', style: Theme.of(context).textTheme.bodySmall),
>>>>>>> 4022811fcd9f3b11667f026fa510b591aedd21d2
>>>>>>> d15190b (refactor(customer): migrate remaining customer screens to new theme system)
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
<<<<<<< HEAD
      );
    },
=======
<<<<<<< HEAD
        );
      },
=======
>>>>>>> 4022811fcd9f3b11667f026fa510b591aedd21d2
>>>>>>> d15190b (refactor(customer): migrate remaining customer screens to new theme system)
    );
  }

  Widget _buildProfileMenuItem({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.primary),
<<<<<<< HEAD
      title: Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      shape: const Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
=======
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.chevron_right, color: Theme.of(context).hintColor, size: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      shape: Border(bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1)),
>>>>>>> 4022811fcd9f3b11667f026fa510b591aedd21d2
    );
  }

  Widget _buildLogoutItem(BuildContext context) {
    return ListTile(
      },
      leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
      title: Text('Logout', style: AppTextStyles.body.copyWith(color: Colors.redAccent, fontWeight: FontWeight.w500)),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
    );
  }
}
      },
>>>>>>> 5d9c514 (firebase data)
    );
  }

  Widget _buildProfileMenuItem({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      shape: const Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
    );
  }

  Widget _buildLogoutItem(BuildContext context) {
    return ListTile(
      onTap: () async {
        await AuthService.signOut();
      onTap: () async {
        await AuthService.signOut();
      },
      },
      leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
      title: Text('Logout', style: AppTextStyles.body.copyWith(color: Colors.redAccent, fontWeight: FontWeight.w500)),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
    );
  }
}
