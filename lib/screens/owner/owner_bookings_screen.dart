import 'package:flutter/material.dart';
import 'package:garage_guru/theme/app_theme.dart';
import 'package:garage_guru/data/mock_data.dart';
import 'package:garage_guru/models/models.dart';
import 'package:garage_guru/widgets/widgets.dart';

class OwnerBookingsScreen extends StatefulWidget {
  const OwnerBookingsScreen({super.key});

  @override
  State<OwnerBookingsScreen> createState() => _OwnerBookingsScreenState();
}

class _OwnerBookingsScreenState extends State<OwnerBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GgAppBar(
        title: 'Bookings',
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppColors.accent,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 13),
          tabAlignment: TabAlignment.start,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Confirmed'),
            Tab(text: 'In Progress'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTab(BookingStatus.pending),
          _buildTab(BookingStatus.confirmed),
          _buildTab(BookingStatus.inProgress),
          _buildTab(BookingStatus.completed),
        ],
      ),
    );
  }

  Widget _buildTab(BookingStatus status) {
    final bookings = MockData.bookings
        .where((b) => b.status == status)
        .toList();

    if (bookings.isEmpty) {
      return EmptyState(
        icon: Icons.inbox_rounded,
        title: 'No ${_statusLabel(status)} Bookings',
        subtitle: 'Bookings with this status will appear here',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return _OwnerBookingCard(
          booking: booking,
          onAccept: status == BookingStatus.pending
              ? () {}
              : null,
          onDecline: status == BookingStatus.pending
              ? () {}
              : null,
          onComplete: status == BookingStatus.inProgress
              ? () {}
              : null,
        );
      },
    );
  }

  String _statusLabel(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending: return 'Pending';
      case BookingStatus.confirmed: return 'Confirmed';
      case BookingStatus.inProgress: return 'In Progress';
      case BookingStatus.completed: return 'Completed';
      case BookingStatus.cancelled: return 'Cancelled';
    }
  }
}

class _OwnerBookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  final VoidCallback? onComplete;

  const _OwnerBookingCard({
    required this.booking,
    this.onAccept,
    this.onDecline,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
        boxShadow: Theme.of(context).brightness == Brightness.dark ? [] : AppShadows.card,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const UserAvatar(name: 'Customer', radius: 20),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Customer #${booking.customerId}', style: AppTextStyles.subtitle.copyWith(fontSize: 14)),
                      if (booking.vehicleInfo.isNotEmpty)
                        Text(booking.vehicleInfo, style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
                Text(
                  booking.scheduledTime,
                  style: AppTextStyles.subtitle.copyWith(color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const Divider(),
            const SizedBox(height: AppSpacing.sm),
            ...booking.services.map((s) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Icon(Icons.build_rounded, size: 14, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: Text(s.name, style: Theme.of(context).textTheme.bodyMedium)),
                  Text('\$${s.price.toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
            )),
            const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  Text(
                    '\$${booking.totalAmount.toStringAsFixed(2)}',
                    style: AppTextStyles.price.copyWith(fontSize: 18, color: AppColors.primary),
                  ),
                ],
              ),
            if (onAccept != null || onDecline != null || onComplete != null) ...[
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  if (onDecline != null)
                    Expanded(
                      child: GgButton(
                        label: 'Decline',
                        color: AppColors.error,
                        isOutlined: true,
                        onPressed: onDecline,
                      ),
                    ),
                  if (onDecline != null && onAccept != null)
                    const SizedBox(width: AppSpacing.sm),
                  if (onAccept != null)
                    Expanded(
                      child: GgButton(
                        label: 'Accept',
                        color: AppColors.success,
                        onPressed: onAccept,
                      ),
                    ),
                  if (onComplete != null)
                    Expanded(
                      child: GgButton(
                        label: 'Mark Complete',
                        color: AppColors.success,
                        onPressed: onComplete,
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
