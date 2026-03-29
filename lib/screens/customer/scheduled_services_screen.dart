import 'package:flutter/material.dart';
import 'package:garage_guru/theme/app_theme.dart';
import 'package:garage_guru/screens/customer/request_repair_form_screen.dart';
import 'package:garage_guru/widgets/widgets.dart';

class ScheduledServicesScreen extends StatelessWidget {
  const ScheduledServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.lg),
            _ServiceSelectionCard(
              title: 'Oil Change',
              subtitle: 'Replace engine oil and filter',
              estCost: r'$45 - $80',
              estTime: '30 min',
              repairTypeForRequest: 'Oil Change',
            ),
            _ServiceSelectionCard(
              title: 'Tire Rotation',
              subtitle: 'Rotate tires to ensure even wear',
              estCost: r'$30 - $50',
              estTime: '30 min',
              repairTypeForRequest: 'Tire Rotation',
            ),
            _ServiceSelectionCard(
              title: 'Brake Service',
              subtitle: 'Inspect and service brake system',
              estCost: r'$100 - $300',
              estTime: '1-2 hours',
              repairTypeForRequest: 'Brake Service',
            ),
            _ServiceSelectionCard(
              title: 'Full Inspection',
              subtitle: 'Complete vehicle inspection',
              estCost: r'$80 - $150',
              estTime: '1 hour',
              repairTypeForRequest: 'Full Inspection',
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
  final String repairTypeForRequest;

  const _ServiceSelectionCard({
    required this.title,
    required this.subtitle,
    required this.estCost,
    required this.estTime,
    required this.repairTypeForRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
        boxShadow: Theme.of(context).brightness == Brightness.dark ? [] : [
           const BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
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
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RequestRepairFormScreen(
                        initialRepairType: repairTypeForRequest,
                      ),
                    ),
                  );
                },
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
