import 'package:flutter/material.dart';
import 'package:garage_guru/core/theme/app_theme.dart';
import 'package:garage_guru/data/mock_data.dart';
import 'package:garage_guru/models/models.dart';
import 'package:garage_guru/widgets/widgets.dart';
import 'package:garage_guru/screens/customer/booking_screen.dart';
import 'package:garage_guru/screens/customer/garage_message_screen.dart';

class GarageDetailScreen extends StatefulWidget {
  final GarageModel garage;

  const GarageDetailScreen({super.key, required this.garage});

  @override
  State<GarageDetailScreen> createState() => _GarageDetailScreenState();
}

class _GarageDetailScreenState extends State<GarageDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final garage = widget.garage;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Garage Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: _buildHeader(context, garage),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelStyle: AppTextStyles.subtitle.copyWith(fontSize: 14),
                tabs: const [
                  Tab(text: 'Services'),
                  Tab(text: 'Reviews'),
                  Tab(text: 'Info'),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _ServicesTab(garage: garage),
            _ReviewsTab(garage: garage),
            _AboutTab(garage: garage),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, GarageModel garage) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: Image.network(
                  garage.coverImageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 60,
                    height: 60,
                    color: AppColors.primaryLight,
                    child: const Icon(Icons.garage, color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      garage.name,
                      style: AppTextStyles.heading3,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: AppColors.starFilled, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${garage.rating} (${garage.reviewCount} reviews)',
                          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          '${garage.distanceKm.toStringAsFixed(1)}km away • ${garage.address.split(',').last.trim()}',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.phone_outlined, size: 16),
                  label: const Text('Call'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                      horizontal: 0,
                    ),
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary, width: 1.5),
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                     Navigator.push(
                       context,
                       MaterialPageRoute(builder: (_) => GarageMessageScreen(garage: garage)),
                     );
                  },
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                  label: const Text('Message'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                      horizontal: 0,
                    ),
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary, width: 1.5),
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookingScreen(garage: garage),
                      ),
                    );
                  },
                  icon: const Icon(Icons.calendar_today_rounded, size: 16),
                  label: const Text('Book'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: 0),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AboutTab extends StatelessWidget {
  final GarageModel garage;
  const _AboutTab({required this.garage});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('About', style: AppTextStyles.heading3),
          const SizedBox(height: AppSpacing.sm),
          Text(garage.description, style: AppTextStyles.body),
          const SizedBox(height: AppSpacing.xxl),
          Text('Contact & Location', style: AppTextStyles.heading3),
          const SizedBox(height: AppSpacing.md),
          InfoRow(
            icon: Icons.location_on_rounded,
            label: 'Address',
            value: garage.address,
            iconColor: AppColors.textSecondary,
            onTap: () {},
          ),
          InfoRow(
            icon: Icons.phone_rounded,
            label: 'Phone',
            value: garage.phone,
            iconColor: AppColors.textSecondary,
            onTap: () {},
          ),
          InfoRow(
            icon: Icons.access_time_rounded,
            label: 'Hours',
            value: 'Mon-Sat: 8:00 AM - 6:00 PM',
            iconColor: AppColors.textSecondary,
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.xxl),
          if (garage.galleryImages.isNotEmpty) ...[
            Text('Gallery', style: AppTextStyles.heading3),
            const SizedBox(height: AppSpacing.md),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: AppSpacing.sm,
                mainAxisSpacing: AppSpacing.sm,
              ),
              itemCount: garage.galleryImages.length,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: Image.network(
                    garage.galleryImages[index],
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.background,
                      child: const Icon(Icons.image, color: AppColors.textHint, size: 32),
                    ),
                  ),
                );
              },
            ),
          ],
          const SizedBox(height: AppSpacing.xxxl),
        ],
      ),
    );
  }
}

class _ServicesTab extends StatelessWidget {
  final GarageModel garage;
  const _ServicesTab({required this.garage});

  @override
  Widget build(BuildContext context) {
    final services = MockData.services
        .where((s) => s.garageId == garage.id)
        .toList();

    if (services.isEmpty) {
      return const EmptyState(
        icon: Icons.build,
        title: 'No Services Listed',
        subtitle: 'This garage hasn\'t listed their services yet.',
      );
    }
    final categories = <String, List<ServiceModel>>{};
    for (final service in services) {
      categories.putIfAbsent(service.category, () => []).add(service);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: categories.keys.length,
      itemBuilder: (context, index) {
        final category = categories.keys.elementAt(index);
        final categoryServices = categories[category]!;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.divider.withOpacity(0.5)),
            ),
            child: ExpansionTile(
              title: Text(category, style: AppTextStyles.subtitle),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
              childrenPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              children: categoryServices.map((service) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: ServiceCard(
                  service: service,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookingScreen(
                          garage: garage,
                          initialServiceType: service.name,
                        ),
                      ),
                    );
                  },
                ),
              )).toList(),
            ),
          ),
        );
      },
    );
  }
}

class _ReviewsTab extends StatelessWidget {
  final GarageModel garage;
  const _ReviewsTab({required this.garage});

  @override
  Widget build(BuildContext context) {
    final reviews = MockData.reviews
        .where((r) => r.garageId == garage.id)
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RatingSummary(
            averageRating: garage.rating,
            totalReviews: garage.reviewCount,
          ),
          const SizedBox(height: AppSpacing.xxl),
          ...reviews.map((review) => ReviewCard(review: review)),
          if (reviews.isEmpty)
            const EmptyState(
              icon: Icons.reviews,
              title: 'No Reviews Yet',
              subtitle: 'Be the first to review this garage!',
            ),
        ],
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  const _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height + 1; // plus border
  @override
  double get maxExtent => tabBar.preferredSize.height + 1;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          tabBar,
          const Divider(height: 1),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}
