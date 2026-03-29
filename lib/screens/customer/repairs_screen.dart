import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garage_guru/theme/app_theme.dart';
import 'package:garage_guru/models/repair_model.dart';
import 'package:garage_guru/screens/customer/repair_detail_screen.dart';
import 'package:garage_guru/screens/customer/repairs_history_screen.dart';
import 'package:garage_guru/widgets/customer_header.dart';
import 'package:garage_guru/blocs/booking_bloc.dart';
import 'package:garage_guru/blocs/auth_bloc.dart';
import 'package:garage_guru/widgets/cancel_repair_dialog.dart';

class RepairsScreen extends StatefulWidget {
  const RepairsScreen({super.key});

  @override
  State<RepairsScreen> createState() => _RepairsScreenState();
}

class _RepairsScreenState extends State<RepairsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    final userId = context.read<AuthBloc>().state.user?.uid;
    if (userId != null) {
      context.read<BookingBloc>().add(LoadRepairs(userId));
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: CustomerHeader(showSearch: false),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: AppColors.primary,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TabBar(
                      controller: _tabController,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white.withOpacity(0.7),
                      indicatorColor: Colors.white,
                      dividerColor: Colors.transparent,
                      indicatorWeight: 3,
                      labelStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                      tabs: const [
                        Tab(text: 'Current'),
                        Tab(text: 'History'),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildCurrentTab(state),
                    RepairsHistoryScreen(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrentTab(BookingState state) {
    if (state.status == BookingStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final currentRepairs = state.activeRepairs.where((r) => 
      r.status != RepairStatus.completed && 
      r.status != RepairStatus.cancelled
    ).toList();

    if (currentRepairs.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.build_circle_outlined, size: 64, color: AppColors.textHint),
            const SizedBox(height: 16),
            Text(
              'No active repairs',
              style: TextStyle(color: AppColors.textHint, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: currentRepairs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _RepairCard(
        repair: currentRepairs[index],
        onViewDetails: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RepairDetailScreen(repair: currentRepairs[index]),
            ),
          );
        },
        onCancel: () => _showCancelDialog(context, currentRepairs[index]),
      ),
    );
  }

  void _showCancelDialog(BuildContext context, RepairModel repair) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (_) => CancelRepairDialog(repair: repair),
    );
  }
}

class _RepairCard extends StatelessWidget {
  final RepairModel repair;
  final VoidCallback onViewDetails;
  final VoidCallback onCancel;

  const _RepairCard({
    required this.repair,
    required this.onViewDetails,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final canCancel = repair.status == RepairStatus.mechanicOnWay || repair.status == RepairStatus.booked;
    final isBooked = repair.status == RepairStatus.booked;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF0F172A) : AppColors.background,
                        shape: BoxShape.circle,
                        border: Border.all(color: Theme.of(context).dividerColor),
                      ),
                      child: Icon(
                          isBooked ? Icons.calendar_today_rounded : Icons.build_rounded,
                          color: AppColors.primary, 
                          size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            repair.serviceName,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            repair.vehicleInfo,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: isBooked ? AppColors.info : AppColors.success,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                repair.statusLabel,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: isBooked ? AppColors.info : AppColors.success,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (!isBooked) ...[
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Progress',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        '${(repair.progressPercent * 100).round()}%',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: repair.progressPercent,
                      backgroundColor: AppColors.divider,
                      color: AppColors.info,
                      minHeight: 6,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isBooked ? 'Location:' : 'Assigned to:',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          isBooked ? repair.location : repair.mechanicName,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    if (!isBooked)
                      Row(
                        children: [
                          _ActionIcon(
                            icon: Icons.phone_outlined,
                            color: AppColors.info,
                            onTap: () {},
                          ),
                          const SizedBox(width: 8),
                          _ActionIcon(
                            icon: Icons.chat_bubble_outline_rounded,
                            color: AppColors.info,
                            onTap: () {},
                          ),
                        ],
                      ),
                  ],
                ),
                if (repair.status == RepairStatus.inProgress) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                      SizedBox(width: 4),
                      Text(
                        'Estimated completion: 2 hours',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
                if (isBooked) ...[
                   const SizedBox(height: 8),
                   Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        'Scheduled for: ${repair.estimatedCompletion}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (repair.status == RepairStatus.mechanicOnWay) ...[
            ClipRRect(
              borderRadius: BorderRadius.zero,
              child: Container(
                height: 140,
                width: double.infinity,
                color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF0F172A) : AppColors.background,
                child: const Icon(Icons.garage_rounded,
                    color: AppColors.primary, size: 60),
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (canCancel)
                  GestureDetector(
                    onTap: onCancel,
                    child: const Text(
                      'Cancel Request',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.error,
                      ),
                    ),
                  )
                else
                  const SizedBox(),
                GestureDetector(
                  onTap: onViewDetails,
                  child: const Row(
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionIcon({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}

