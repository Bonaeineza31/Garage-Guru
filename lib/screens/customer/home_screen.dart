import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garage_guru/core/theme/app_theme.dart';
import 'package:garage_guru/data/mock_data.dart';
import 'package:garage_guru/models/models.dart';
import 'package:garage_guru/widgets/widgets.dart';
import 'package:garage_guru/screens/customer/garage_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'All';

  Future<Map<String, dynamic>?> _fetchUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      return doc.data();
    }
    return null;
  }

  final List<Map<String, dynamic>> _categories = [
    {'label': 'All', 'icon': Icons.apps_rounded},
    {'label': 'Engine', 'icon': Icons.engineering_rounded},
    {'label': 'Brakes', 'icon': Icons.disc_full_rounded},
    {'label': 'Tires', 'icon': Icons.tire_repair_rounded},
    {'label': 'Electrical', 'icon': Icons.electrical_services_rounded},
    {'label': 'AC', 'icon': Icons.ac_unit_rounded},
    {'label': 'Body', 'icon': Icons.car_repair_rounded},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('garages').snapshots(),
          builder: (context, garageSnapshot) {
            final garages = garageSnapshot.data?.docs
                    .map((doc) => GarageModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
                    .toList() ??
                [];
            
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  gradient: AppColors.heroGradient,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(AppRadius.xxl),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<Map<String, dynamic>?>(
                      future: _fetchUserProfile(),
                      builder: (context, snapshot) {
                        final authUser = FirebaseAuth.instance.currentUser;
                        final name = snapshot.data?['name'] ?? authUser?.displayName ?? 'New User';
                        final imageUrl = snapshot.data?['profileImageUrl'] ?? 'https://i.pravatar.cc/150?img=12';
                        
                        return Row(
                          children: [
                            UserAvatar(
                              imageUrl: imageUrl,
                              name: name,
                              radius: 22,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hello, $name!',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Text(
                                    'Find a garage near you',
                                    style: AppTextStyles.heading3.copyWith(
                                      color: AppColors.textOnPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(AppRadius.md),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        );
                      }
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    GgSearchBar(
                      controller: _searchController,
                      hint: 'Search garages, services...',
                      onFilterTap: () => _showFilterSheet(context),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 60,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    return GgChipButton(
                      label: cat['label'] as String,
                      icon: cat['icon'] as IconData,
                      isSelected: _selectedCategory == cat['label'],
                      onTap: () => setState(() => _selectedCategory = cat['label'] as String),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Nearby Garages',
                actionText: 'View Map',
                onAction: () {},
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  itemCount: garages.length,
                  separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
                  itemBuilder: (context, index) {
                    return GarageMapCard(
                      garage: garages[index],
                      onTap: () => _navigateToGarage(garages[index]),
                    );
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
            const SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Top Rated',
                actionText: 'See All',
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return GarageCard(
                      garage: garages[index],
                      onTap: () => _navigateToGarage(garages[index]),
                    );
                  },
                  childCount: garages.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
          ],
        );
        },
      ),
      ),
    );
  }

  void _navigateToGarage(GarageModel garage) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GarageDetailScreen(garage: garage),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) => const _FilterSheet(),
    );
  }
}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet();

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  double _maxDistance = 10;
  double _minRating = 3;
  bool _openNow = false;
  bool _verified = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Filter Garages', style: AppTextStyles.heading2.copyWith(letterSpacing: -0.3)),
          const SizedBox(height: AppSpacing.xxl),
          Text('Max Distance: ${_maxDistance.toStringAsFixed(0)} km', style: AppTextStyles.subtitle),
          Slider(
            value: _maxDistance,
            min: 1,
            max: 50,
            divisions: 49,
            activeColor: AppColors.primary,
            onChanged: (v) => setState(() => _maxDistance = v),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Min Rating: ${_minRating.toStringAsFixed(1)}', style: AppTextStyles.subtitle),
          Slider(
            value: _minRating,
            min: 1,
            max: 5,
            divisions: 8,
            activeColor: AppColors.starFilled,
            onChanged: (v) => setState(() => _minRating = v),
          ),
          const SizedBox(height: AppSpacing.lg),
          SwitchListTile(
            title: const Text('Open Now'),
            value: _openNow,
            activeThumbColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
            onChanged: (v) => setState(() => _openNow = v),
          ),
          SwitchListTile(
            title: const Text('Verified Only'),
            value: _verified,
            activeThumbColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
            onChanged: (v) => setState(() => _verified = v),
          ),
          const SizedBox(height: AppSpacing.xxl),
          GgButton(
            label: 'Apply Filters',
            onPressed: () => Navigator.pop(context),
            useGradient: true,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}