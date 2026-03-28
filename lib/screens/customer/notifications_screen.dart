import 'package:flutter/material.dart';
import 'package:garage_guru/core/theme/app_theme.dart';
import 'package:garage_guru/screens/customer/request_repair_form_screen.dart';
import 'package:garage_guru/widgets/widgets.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock notifications
    final notifications = [
      _NotificationItem(
        icon: Icons.calendar_today_outlined,
        title: 'Oil Change Due',
        date: 'May 15, 2025',
        description: 'Your Toyota Camry is due for an oil change in 2 days.',
        showScheduleAction: true,
      ),
      _NotificationItem(
        icon: Icons.build_outlined,
        title: 'Repair Completed',
        date: 'May 10, 2025',
        description: 'Your brake pad replacement has been completed.',
        showScheduleAction: false,
      ),
      _NotificationItem(
        icon: Icons.check_circle_outline,
        title: 'Payment Successful',
        date: 'May 10, 2025',
        description: 'Your payment of FRw 35,000 to Auto Finit was successful.',
        showScheduleAction: false,
      ),
      _NotificationItem(
        icon: Icons.notifications_none_outlined,
        title: 'Welcome to Fix My Ride',
        date: 'May 1, 2025',
        description: 'Thank you for joining Fix My Ride. Explore our services!',
        showScheduleAction: false,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GgAppBar(
        title: 'Notifications',
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.divider.withOpacity(0.5)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(item.icon, size: 20, color: AppColors.primary),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.title,
                            style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            item.date,
                            style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                      ),
                      if (item.showScheduleAction) ...[
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const RequestRepairFormScreen(
                                      initialRepairType: 'Oil Change',
                                    ),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.primary),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                minimumSize: const Size(0, 32),
                              ),
                              child: Text(
                                'Schedule Now',
                                style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _NotificationItem {
  final IconData icon;
  final String title;
  final String date;
  final String description;
  final bool showScheduleAction;

  const _NotificationItem({
    required this.icon,
    required this.title,
    required this.date,
    required this.description,
    required this.showScheduleAction,
  });
}
