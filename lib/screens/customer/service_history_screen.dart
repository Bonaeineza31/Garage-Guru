import 'package:flutter/material.dart';
import 'package:garage_guru/core/theme/app_theme.dart';
import 'package:garage_guru/models/models.dart';
import 'package:garage_guru/widgets/widgets.dart';

class ServiceHistoryScreen extends StatelessWidget {
  final VehicleModel vehicle;

  const ServiceHistoryScreen({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final history = [
      _ServiceHistoryItem(
        serviceName: 'Oil Change',
        date: 'March 15, 2025',
        garageName: 'AutoFix Garage',
        price: r'$45.00',
        mileage: '25,000 km',
      ),
      _ServiceHistoryItem(
        serviceName: 'Tire Rotation',
        date: 'December 10, 2024',
        garageName: 'QuickFix Motors',
        price: r'$30.00',
        mileage: '20,000 km',
      ),
      _ServiceHistoryItem(
        serviceName: 'Brake Service',
        date: 'August 5, 2024',
        garageName: 'AutoFix Garage',
        price: r'$120.00',
        mileage: '15,000 km',
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GgAppBar(
        title: 'Service History',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Text(
              vehicle.fullName,
              style: AppTextStyles.heading3.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              itemCount: history.length,
              separatorBuilder: (context, index) => Divider(height: 1),
              itemBuilder: (context, index) {
                final item = history[index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.serviceName,
                              style: AppTextStyles.subtitle.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              item.date,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              item.garageName,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            item.price,
                            style: AppTextStyles.subtitle.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            item.mileage,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceHistoryItem {
  final String serviceName;
  final String date;
  final String garageName;
  final String price;
  final String mileage;

  const _ServiceHistoryItem({
    required this.serviceName,
    required this.date,
    required this.garageName,
    required this.price,
    required this.mileage,
  });
}
