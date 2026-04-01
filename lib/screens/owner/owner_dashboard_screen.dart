import 'package:flutter/material.dart';
import 'package:garage_guru/theme/app_theme.dart';
import 'package:garage_guru/data/mock_data.dart';
import 'package:garage_guru/models/models.dart';
import 'package:garage_guru/widgets/widgets.dart';
import 'package:garage_guru/screens/owner/add_garage_screen.dart';

class OwnerDashboardScreen extends StatelessWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddGarageScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_business_rounded, color: Colors.white),
        label: const Text('Add Garage', style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: CustomScrollView(
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
                    Row(
                      children: [
                        const UserAvatar(
                          imageUrl: 'https://i.pravatar.cc/150?img=3',
                          name: 'Garage Owner',
                          radius: 22,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Premier Auto Care',
                                style: AppTextStyles.heading3.copyWith(
                                  color: AppColors.textOnPrimary,
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppColors.success,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.xs),
                                  Text(
                                    'Open for business',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
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
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.4,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                ),
                delegate: SliverChildListDelegate([
                  const StatCard(
                    title: 'Total Bookings',
                    value: '156',
                    icon: Icons.calendar_month_rounded,
                    color: AppColors.primary,
                    change: '12%',
                    isPositive: true,
                  ),
                  const StatCard(
                    title: 'Revenue',
                    value: '\$8,420',
                    icon: Icons.attach_money_rounded,
                    color: AppColors.success,
                    change: '8%',
                    isPositive: true,
                  ),
                  const StatCard(
                    title: 'Rating',
                    value: '4.8',
                    icon: Icons.star_rounded,
                    color: AppColors.starFilled,
                    change: '0.2',
                    isPositive: true,
                  ),
                  const StatCard(
                    title: 'Customers',
                    value: '89',
                    icon: Icons.people_rounded,
                    color: AppColors.accent,
                    change: '5%',
                    isPositive: true,
                  ),
                ]),
              ),
            ),
            const SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Today\'s Appointments',
                actionText: 'View All',
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _AppointmentCard(
                      customerName: ['John Smith', 'Sarah Johnson', 'Mike Davis'][index],
                      service: ['Oil Change', 'Brake Inspection', 'Engine Diagnostics'][index],
                      time: ['9:00 AM', '11:30 AM', '2:00 PM'][index],
                      status: [BookingStatus.confirmed, BookingStatus.inProgress, BookingStatus.pending][index],
                      vehicleInfo: ['2022 Toyota Camry', '2023 Honda Civic', '2021 BMW 3 Series'][index],
                    );
                  },
                  childCount: 3,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.lg),
            ),
            const SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Recent Reviews',
                actionText: 'See All',
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return ReviewCard(review: MockData.reviews[index]);
                  },
                  childCount: 2,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxxl)),
          ],
        ),
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final String customerName;
  final String service;
  final String time;
  final BookingStatus status;
  final String vehicleInfo;

  const _AppointmentCard({
    required this.customerName,
    required this.service,
    required this.time,
    required this.status,
    required this.vehicleInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
        boxShadow: Theme.of(context).brightness == Brightness.dark ? [] : AppShadows.card,
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Center(
              child: Text(
                time,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(customerName, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                    const Spacer(),
                    _buildStatusBadge(context),
                  ],
                ),
                const SizedBox(height: 2),
                Text(service, style: AppTextStyles.body.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
                Text(vehicleInfo, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    Color color;
    String label;
    switch (status) {
      case BookingStatus.confirmed:
        color = AppColors.info;
        label = 'Confirmed';
        break;
      case BookingStatus.inProgress:
        color = AppColors.accent;
        label = 'In Progress';
        break;
      case BookingStatus.pending:
        color = AppColors.warning;
        label = 'Pending';
        break;
      default:
        color = AppColors.textSecondary;
        label = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
