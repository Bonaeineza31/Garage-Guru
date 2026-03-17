import 'package:flutter/material.dart';
import 'package:garage_guru/core/theme/app_theme.dart';
import 'package:garage_guru/widgets/widgets.dart';

class ScheduledServicesScreen extends StatelessWidget {
  const ScheduledServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GgAppBar(
        title: 'Scheduled Services',
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Service Type',
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: AppSpacing.lg),
            _ServiceSelectionCard(
              title: 'Oil Change',
              subtitle: 'Replace engine oil and filter',
              estCost: r'$45 - $80',
              estTime: '30 min',
            ),
            _ServiceSelectionCard(
              title: 'Tire Rotation',
              subtitle: 'Rotate tires to ensure even wear',
              estCost: r'$30 - $50',
              estTime: '30 min',
            ),
            _ServiceSelectionCard(
              title: 'Brake Service',
              subtitle: 'Inspect and service brake system',
              estCost: r'$100 - $300',
              estTime: '1-2 hours',
            ),
            _ServiceSelectionCard(
              title: 'Full Inspection',
              subtitle: 'Complete vehicle inspection',
              estCost: r'$80 - $150',
              estTime: '1 hour',
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceSelectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String estCost;
  final String estTime;

  const _ServiceSelectionCard({
    required this.title,
    required this.subtitle,
    required this.estCost,
    required this.estTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.divider.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.subtitle.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  minimumSize: Size(80, 40),
                ),
                child: Text(
                  'Select',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Est. cost: $estCost',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Est. time: $estTime',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
