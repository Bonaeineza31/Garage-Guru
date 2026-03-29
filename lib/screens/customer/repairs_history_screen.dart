import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garage_guru/theme/app_theme.dart';
import 'package:garage_guru/models/repair_model.dart';
import 'package:garage_guru/screens/customer/repair_detail_screen.dart';
import 'package:garage_guru/blocs/booking_bloc.dart';
import 'package:intl/intl.dart';

class RepairsHistoryScreen extends StatelessWidget {
  const RepairsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        if (state.status == BookingStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        final history = state.activeRepairs.where((r) => 
          r.status == RepairStatus.completed || r.status == RepairStatus.cancelled
        ).toList();

        if (history.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.history_rounded, size: 64, color: AppColors.textHint),
                const SizedBox(height: 16),
                Text(
                  'No repair history',
                  style: TextStyle(color: AppColors.textHint, fontSize: 16),
                ),
              ],
            ),
          );
        }

        return Container(
          color: AppColors.background,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: history.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _HistoryCard(item: history[index]),
          ),
        );
      },
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final RepairModel item;

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
                  color: (item.status == RepairStatus.cancelled ? AppColors.error : AppColors.success).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                        item.status == RepairStatus.cancelled ? Icons.cancel_outlined : Icons.check_circle_outline,
                        size: 12, 
                        color: item.status == RepairStatus.cancelled ? AppColors.error : AppColors.success),
                    const SizedBox(width: 4),
                    Text(
                      item.statusLabel,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: item.status == RepairStatus.cancelled ? AppColors.error : AppColors.success,
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
                  value: DateFormat('MMM dd, yyyy').format(item.startDate),
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
                      'FRw ${item.totalCost.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                  isBold: true,
                ),
              ),
            ],
          ),
          if (item.status != RepairStatus.cancelled) ...[
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
                  DateFormat('MMM dd, yyyy').format(item.startDate.add(const Duration(days: 90))),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.info,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RepairDetailScreen(repair: item),
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
