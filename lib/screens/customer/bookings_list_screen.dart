import 'package:flutter/material.dart';
import 'package:garage_guru/theme/app_theme.dart';
import 'package:garage_guru/data/mock_data.dart';
import 'package:garage_guru/models/models.dart';
import 'package:garage_guru/widgets/widgets.dart';

class BookingsListScreen extends StatefulWidget {
  const BookingsListScreen({super.key});

  @override
  State<BookingsListScreen> createState() => _BookingsListScreenState();
}

class _BookingsListScreenState extends State<BookingsListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final upcoming = MockData.bookings
        .where((b) =>
            b.status == BookingStatus.pending ||
            b.status == BookingStatus.confirmed ||
            b.status == BookingStatus.inProgress)
        .toList();

    final past = MockData.bookings
        .where((b) =>
            b.status == BookingStatus.completed ||
            b.status == BookingStatus.cancelled)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.accent,
          indicatorWeight: 2.5,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: AppTextStyles.subtitle.copyWith(fontSize: 14),
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingsList(upcoming, isUpcoming: true),
          _buildBookingsList(past, isUpcoming: false),
        ],
      ),
    );
  }

  Widget _buildBookingsList(List<BookingModel> bookings, {required bool isUpcoming}) {
    if (bookings.isEmpty) {
      return EmptyState(
        icon: isUpcoming ? Icons.calendar_month_rounded : Icons.history_rounded,
        title: isUpcoming ? 'No Upcoming Bookings' : 'No Past Bookings',
        subtitle: isUpcoming
            ? 'Book a service to see your upcoming appointments here'
            : 'Your completed bookings will appear here',
        buttonText: isUpcoming ? 'Find a Garage' : null,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return BookingCard(
          booking: bookings[index],
          onTap: () => _showBookingDetail(bookings[index]),
        );
      },
    );
  }

  void _showBookingDetail(BookingModel booking) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).cardColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text('Booking Details', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: AppSpacing.xxl),
                BookingCard(booking: booking),
                const SizedBox(height: AppSpacing.lg),
                if (booking.status == BookingStatus.pending ||
                    booking.status == BookingStatus.confirmed) ...[
                  GgButton(
                    label: 'Cancel Booking',
                    color: AppColors.error,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
                if (booking.status == BookingStatus.completed) ...[
                  GgButton(
                    label: 'Rebook Service',
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  GgButton(
                    label: 'Write a Review',
                    isOutlined: true,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
