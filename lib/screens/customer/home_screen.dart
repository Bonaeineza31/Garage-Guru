import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/app_bottom_navigation.dart';

/// Main home screen displaying map, quick services, nearby garages, and maintenance
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            // App header with logo and notification
            _buildHeader(context),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search bar
                    _buildSearchBar(),

                    // Map section
                    _buildMapSection(context),

                    // Quick action buttons
                    _buildQuickActions(context),

                    // Quick Services section
                    _buildQuickServices(context),

                    // Nearby Garages section
                    _buildNearbyGarages(context),

                    // Upcoming Maintenance section
                    _buildUpcomingMaintenance(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 0),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo and app name
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.build, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              const Text(
                'GarageGuru',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),

          // Notification icon
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                color: AppTheme.iconGray,
                onPressed: () {
                  // Navigate to notifications (future implementation)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Notifications will be implemented with backend',
                      ),
                    ),
                  );
                },
              ),
              // Notification badge
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppTheme.errorRed,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.dividerColor),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              color: AppTheme.iconGray,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              'Find nearby repair shops',
              style: TextStyle(color: AppTheme.textHint, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/map');
        },
        child: Container(
          height: 280,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.dividerColor),
            image: const DecorationImage(
              image: NetworkImage(
                'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/-0.1276,51.5074,11/600x400@2x?access_token=pk.eyJ1IjoiZXhhbXBsZSIsImEiOiJja2x2ZGFuYW8wMDFjMm5xbzFxZGc4Ym0yIn0.example',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              // Google Maps logo in bottom right (like in design)
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Google',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
              ),

              // User location indicator
              Center(
                child: Icon(
                  Icons.my_location,
                  color: AppTheme.primaryBlue,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              context,
              label: 'Emergency Repair',
              color: AppTheme.emergencyOrange,
              icon: Icons.warning_amber_rounded,
              onTap: () {
                Navigator.pushNamed(context, '/emergency-repair');
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              context,
              label: 'Schedule Repair',
              color: AppTheme.scheduleBlue,
              icon: Icons.calendar_today,
              onTap: () {
                Navigator.pushNamed(context, '/request-repair');
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              context,
              label: 'Repair Updates',
              color: AppTheme.repairGreen,
              icon: Icons.update,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Repair updates will load from backend'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickServices(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Services',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildServiceIcon(
                context,
                icon: Icons.oil_barrel_outlined,
                label: 'Oil Change',
                onTap: () {
                  Navigator.pushNamed(context, '/request-repair');
                },
              ),
              _buildServiceIcon(
                context,
                icon: Icons.tire_repair,
                label: 'Tire Service',
                onTap: () {
                  Navigator.pushNamed(context, '/tire-service');
                },
              ),
              _buildServiceIcon(
                context,
                icon: Icons.battery_charging_full,
                label: 'Battery',
                onTap: () {
                  Navigator.pushNamed(context, '/battery-service');
                },
              ),
              _buildServiceIcon(
                context,
                icon: Icons.add_circle_outline,
                label: 'Add Vehicle',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Vehicle management coming with backend'),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceIcon(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.primaryBlue, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyGarages(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Nearby Garages',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/garages');
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildGarageCard(
            context,
            name: 'Auto Finit',
            distance: '0.6km',
            rating: 5,
            image:
                'https://images.unsplash.com/photo-1625047509168-a7026f36de04?w=200&h=200&fit=crop',
            isFavorite: true,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Garage details coming with backend'),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildGarageCard(
            context,
            name: 'Kigali Motors',
            distance: '1.2km',
            rating: 4,
            image:
                'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=200&h=200&fit=crop',
            isFavorite: false,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Garage details coming with backend'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGarageCard(
    BuildContext context, {
    required String name,
    required String distance,
    required int rating,
    required String image,
    required bool isFavorite,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.dividerColor),
        ),
        child: Row(
          children: [
            // Garage image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    color: AppTheme.dividerColor,
                    child: const Icon(Icons.garage, color: AppTheme.iconGray),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),

            // Garage info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        distance,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '~${distance.replaceAll('km', '')}0.${distance.replaceAll('km', '')}km',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            Icons.star,
                            size: 14,
                            color: index < rating
                                ? Colors.amber
                                : AppTheme.dividerColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Favorite icon and Details button
            Column(
              children: [
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? AppTheme.errorRed : AppTheme.iconGray,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isFavorite
                              ? 'Removed from favorites'
                              : 'Added to favorites',
                        ),
                      ),
                    );
                  },
                ),
                TextButton(onPressed: onTap, child: const Text('Details')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingMaintenance(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upcoming Maintenance',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.dividerColor),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.infoBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.oil_barrel,
                    color: AppTheme.infoBlue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Oil Change Due',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Toyota Camry • RAC 881C',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Due in 2 days or 300km',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.warningYellow,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/request-repair');
                  },
                  child: const Text('Schedule Now'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}