import 'package:flutter/material.dart';
import 'package:garage_guru/core/theme/app_theme.dart';
import 'package:garage_guru/models/repair_model.dart';
import 'package:garage_guru/screens/customer/repair_detail_screen.dart';
import 'package:intl/intl.dart';

class RepairsHistoryScreen extends StatelessWidget {
  const RepairsHistoryScreen({super.key});

  static final List<RepairHistoryModel> _history = [
    RepairHistoryModel(
      id: 'h1',
      serviceName: 'Oil Change',
      vehicleMake: 'Toyota',
      vehicleModel: 'Camry',
      vehiclePlate: 'BA01234',
      date: DateTime(2025, 5, 5),
      mechanicName: 'Jean Claude',
      location: 'Auto Finit',
      cost: 30000,
      nextServiceDue: DateTime(2025, 8, 5),
    ),
    RepairHistoryModel(
      id: 'h2',
      serviceName: 'Tire Rotation',
      vehicleMake: 'Toyota',
      vehicleModel: 'Camry',
      vehiclePlate: 'BA01234',
      date: DateTime(2025, 4, 20),
      mechanicName: 'Marie Claire',
      location: 'Kigali Motors',
      cost: 15000,
      nextServiceDue: DateTime(2025, 10, 20),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _history.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _HistoryCard(item: _history[index]),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final RepairHistoryModel item;

  const _HistoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.serviceName,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.vehicleInfo,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.check_circle_outline,
                        size: 12, color: AppColors.success),
                    SizedBox(width: 4),
                    Text(
                      'Completed',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _DetailItem(
                  label: 'Date',
                  value: DateFormat('MMM dd, yyyy').format(item.date),
                  icon: Icons.calendar_today_outlined,
                ),
              ),
              Expanded(
                child: _DetailItem(
                  label: 'Mechanic',
                  value: item.mechanicName,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _DetailItem(
                  label: 'Location',
                  value: item.location,
                ),
              ),
              Expanded(
                child: _DetailItem(
                  label: 'Cost',
                  value:
                      'FRw ${item.cost.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                  isBold: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text(
                'Next service due: ',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                DateFormat('MMM dd, yyyy').format(item.nextServiceDue),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.info,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RepairDetailScreen(
                      repair: RepairModel(
                        id: item.id,
                        serviceName: item.serviceName,
                        vehicleMake: item.vehicleMake,
                        vehicleModel: item.vehicleModel,
                        vehiclePlate: item.vehiclePlate,
                        progressPercent: 1.0,
                        status: RepairStatus.completed,
                        mechanicName: item.mechanicName,
                        mechanicSpecialty: 'General Mechanic',
                        mechanicRating: 4.8,
                        location: item.location,
                        startDate: item.date,
                        estimatedCompletion: 'Completed',
                        repairDescription: 'Service completed successfully.',
                        partsCost: item.cost * 0.6,
                        laborCost: item.cost * 0.4,
                        updates: [
                          RepairUpdate(
                            timestamp: item.date,
                            message: 'Service completed successfully.',
                          ),
                        ],
                        isPaid: true,
                      ),
                    ),
                  ),
                );
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View Details',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.info,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 14, color: AppColors.info),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final bool isBold;

  const _DetailItem({
    required this.label,
    required this.value,
    this.icon,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 12, color: AppColors.textSecondary),
              const SizedBox(width: 4),
            ],
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
