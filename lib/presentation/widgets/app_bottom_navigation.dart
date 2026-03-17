import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Reusable bottom navigation bar used across multiple screens
class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavigation({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                index: 0,
                route: '/home',
              ),
              _buildNavItem(
                context,
                icon: Icons.location_on_outlined,
                activeIcon: Icons.location_on,
                label: 'Garages',
                index: 1,
                route: '/garages',
              ),
              _buildNavItem(
                context,
                icon: Icons.build_outlined,
                activeIcon: Icons.build,
                label: 'Repairs',
                index: 2,
                route: '/repairs',
              ),
              _buildNavItem(
                context,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profile',
                index: 3,
                route: '/profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required String route,
  }) {
    final isActive = currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          if (!isActive) {
            Navigator.pushReplacementNamed(context, route);
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive ? activeIcon : icon,
                color: isActive ? AppTheme.primaryBlue : AppTheme.iconGray,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  color: isActive
                      ? AppTheme.primaryBlue
                      : AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
