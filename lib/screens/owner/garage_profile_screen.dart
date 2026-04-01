import 'package:flutter/material.dart';
import 'package:garage_guru/theme/app_theme.dart';
import 'package:garage_guru/widgets/widgets.dart';
<<<<<<< HEAD
import 'package:garage_guru/screens/auth/login_screen.dart';
import 'package:garage_guru/screens/garage/add_garage_screen.dart';
=======
import 'package:garage_guru/core/auth/auth_service.dart';
>>>>>>> origin/main

class GarageProfileScreen extends StatelessWidget {
  const GarageProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Garage Profile', style: AppTextStyles.heading3.copyWith(color: Colors.white)),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AddGarageScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1625047509248-ec889cbff17f?w=800',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.garage_rounded,
                      size: 48,
                      color: Colors.white38,
                    ),
                  ),
                ),
                Positioned(
                  bottom: AppSpacing.md,
                  right: AppSpacing.md,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Change Cover',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text('Premier Auto Care', style: AppTextStyles.heading2),
                      ),
                      const Icon(Icons.verified, color: AppColors.primary, size: 24),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.starFilled, size: 18),
                      const SizedBox(width: 4),
                      Text('4.8', style: AppTextStyles.subtitle),
                      Text(' (342 reviews)', style: AppTextStyles.bodySmall),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Text('Contact Information', style: AppTextStyles.heading3),
                  const SizedBox(height: AppSpacing.md),
                  const InfoRow(
                    icon: Icons.location_on_rounded,
                    label: 'Address',
                    value: '123 Main Street, Downtown',
                    iconColor: AppColors.error,
                  ),
                  const InfoRow(
                    icon: Icons.phone_rounded,
                    label: 'Phone',
                    value: '+1 (555) 123-4567',
                    iconColor: AppColors.success,
                  ),
                  const InfoRow(
                    icon: Icons.email_rounded,
                    label: 'Email',
                    value: 'info@premierautocare.com',
                    iconColor: AppColors.info,
                  ),
                  const InfoRow(
                    icon: Icons.language_rounded,
                    label: 'Website',
                    value: 'www.premierautocare.com',
                    iconColor: AppColors.accent,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Text('Working Hours', style: AppTextStyles.heading3),
                  const SizedBox(height: AppSpacing.md),
                  _buildHoursRow('Monday - Thursday', '8:00 AM - 6:00 PM'),
                  _buildHoursRow('Friday', '8:00 AM - 5:00 PM'),
                  _buildHoursRow('Saturday', '9:00 AM - 2:00 PM'),
                  _buildHoursRow('Sunday', 'Closed', isClosed: true),
                  const SizedBox(height: AppSpacing.xxl),
                  Text('Gallery', style: AppTextStyles.heading3),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildGalleryImage('https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=200'),
                        _buildGalleryImage('https://images.unsplash.com/photo-1580273916550-e323be2ae537?w=200'),
                        _buildGalleryImage('https://images.unsplash.com/photo-1487754180451-c456f719a1fc?w=200'),
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(right: AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(color: AppColors.divider, style: BorderStyle.solid),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo, color: AppColors.primary, size: 28),
                              SizedBox(height: 4),
                              Text('Add', style: TextStyle(fontSize: 11, color: AppColors.primary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  GgButton(
                    label: 'Sign Out',
                    color: AppColors.error,
                    icon: Icons.logout,
                    onPressed: () async {
                      await AuthService.signOut();
                    },
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHoursRow(String day, String hours, {bool isClosed = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          SizedBox(
            width: 160,
            child: Text(day, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500)),
          ),
          Text(
            hours,
            style: AppTextStyles.body.copyWith(
              color: isClosed ? AppColors.error : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryImage(String url) {
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.only(right: AppSpacing.sm),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: AppColors.background,
            child: const Icon(Icons.image, color: AppColors.textHint),
          ),
        ),
      ),
    );
  }
}
