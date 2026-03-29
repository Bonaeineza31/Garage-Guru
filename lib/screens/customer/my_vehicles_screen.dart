import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:garage_guru/theme/app_theme.dart';
import 'package:garage_guru/models/vehicle_model.dart';
import 'package:garage_guru/widgets/widgets.dart';
import 'package:intl/intl.dart';

import 'package:garage_guru/screens/customer/scheduled_services_screen.dart';
import 'package:garage_guru/screens/customer/service_history_screen.dart';
import 'package:garage_guru/screens/customer/add_vehicle_screen.dart';

class MyVehiclesScreen extends StatelessWidget {
  const MyVehiclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const GgAppBar(
        title: 'My Vehicles',
      ),
      body: user == null
          ? const Center(child: Text('Please log in to see your vehicles'))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('vehicles')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data?.docs ?? [];
                
                if (docs.isEmpty) {
                  return Column(
                    children: [
                      const Expanded(
                        child: EmptyState(
                          icon: Icons.directions_car_outlined,
                          title: 'No Vehicles Added',
                          subtitle: 'Add your first vehicle to start scheduling services.',
                        ),
                      ),
                      _buildAddButton(context),
                    ],
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final vehicle = VehicleModel.fromFirestore(docs[index]);
                          return _VehicleCard(vehicle: vehicle, index: index);
                        },
                      ),
                    ),
                    _buildAddButton(context),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: GgButton(
        label: 'Add New Vehicle',
        icon: Icons.add,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddVehicleScreen()),
          );
        },
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  final VehicleModel vehicle;
  final int index;

  const _VehicleCard({required this.vehicle, required this.index});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: isDark ? [] : AppShadows.card,
        border: Border.all(color: isDark ? Colors.white10 : AppColors.divider.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: Image.network(
                    vehicle.imageUrl ?? 'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?w=200',
                    width: 100,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 100,
                      height: 80,
                      color: isDark ? const Color(0xFF1E293B) : AppColors.primaryLight,
                      child: Icon(Icons.directions_car, color: isDark ? Colors.white54 : AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              vehicle.fullName,
                              style: (isDark ? const TextStyle(color: Colors.white) : AppTextStyles.subtitle).copyWith(fontWeight: FontWeight.w700),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(Icons.settings_outlined, color: isDark ? Colors.white54 : AppColors.textSecondary, size: 18),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${vehicle.year} • ${vehicle.plateNumber ?? "N/A"}',
                        style: isDark ? const TextStyle(color: Colors.white70, fontSize: 12) : AppTextStyles.bodySmall,
                      ),
                      Text(
                        'Color: ${vehicle.color}',
                        style: isDark ? const TextStyle(color: Colors.white70, fontSize: 12) : AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: isDark ? Colors.white10 : null),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            child: Row(
              children: [
                Icon(Icons.calendar_today_outlined, size: 16, color: isDark ? Colors.white54 : AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  'Next service: ${vehicle.nextServiceDate != null ? DateFormat('MMMM d, yyyy').format(vehicle.nextServiceDate!) : 'Not scheduled'}',
                  style: (isDark ? const TextStyle(color: Colors.white70) : AppTextStyles.bodySmall).copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: isDark ? Colors.white10 : null),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => ServiceHistoryScreen(vehicle: vehicle)),
                      );
                    },
                    child: Text(
                      'View Service History',
                      style: (isDark ? const TextStyle(color: Color(0xFF0EA5E9)) : AppTextStyles.bodySmall).copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ScheduledServicesScreen()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Schedule Service',
                          style: (isDark ? const TextStyle(color: Color(0xFF0EA5E9)) : AppTextStyles.bodySmall).copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right, size: 16, color: Color(0xFF0EA5E9)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
