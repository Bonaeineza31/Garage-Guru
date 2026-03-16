import 'package:flutter/material.dart';
import 'package:garage_guru/core/theme/app_theme.dart';
import 'package:garage_guru/data/mock_data.dart';
import 'package:garage_guru/models/models.dart';
import 'package:garage_guru/widgets/widgets.dart';
import 'package:garage_guru/screens/customer/booking_screen.dart';

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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Icon(Icons.favorite_border_rounded, color: Colors.white, size: 18),
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Icon(Icons.share_rounded, color: Colors.white, size: 18),
                ),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    garage.coverImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                      ),
                      child: const Icon(Icons.garage_rounded, size: 64, color: Colors.white38),
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: AppSpacing.lg,
                    left: AppSpacing.lg,
                    right: AppSpacing.lg,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                garage.name,
                                style: AppTextStyles.heading2.copyWith(color: Colors.white),
                              ),
                            ),
                            if (garage.isVerified)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(AppRadius.pill),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.verified, color: Colors.white, size: 14),
                                    SizedBox(width: 2),
                                    Text(
                                      'Verified',
                                      style: TextStyle(color: Colors.white, fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: AppColors.starFilled, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${garage.rating} (${garage.reviewCount} reviews)',
                              style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: garage.isOpen ? AppColors.success : AppColors.error,
                                borderRadius: BorderRadius.circular(AppRadius.pill),
                              ),
                              child: Text(
                                garage.isOpen ? 'Open' : 'Closed',
                                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                indicatorWeight: 2.5,
                labelStyle: AppTextStyles.subtitle.copyWith(fontSize: 14),
                tabs: const [
                  Tab(text: 'About'),
                  Tab(text: 'Services'),
                  Tab(text: 'Reviews'),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _AboutTab(garage: garage),
            _ServicesTab(garage: garage),
            _ReviewsTab(garage: garage),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: AppShadows.bottomNav,
        ),
        child: SafeArea(
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: IconButton(
                  icon: const Icon(Icons.phone_rounded, color: AppColors.primary),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: IconButton(
                  icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.primary),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: GgButton(
                  label: 'Book Now',
                  useGradient: true,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BookingScreen(garage: garage),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
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
          Text('Contact Information', style: AppTextStyles.heading3),
          const SizedBox(height: AppSpacing.md),
          InfoRow(
            icon: Icons.location_on_rounded,
            label: 'Address',
            value: garage.address,
            iconColor: AppColors.error,
            onTap: () {},
          ),
          InfoRow(
            icon: Icons.phone_rounded,
            label: 'Phone',
            value: garage.phone,
            iconColor: AppColors.success,
            onTap: () {},
          ),
          if (garage.email != null)
            InfoRow(
              icon: Icons.email_rounded,
              label: 'Email',
              value: garage.email!,
              iconColor: AppColors.info,
              onTap: () {},
            ),
          if (garage.website != null)
            InfoRow(
              icon: Icons.language_rounded,
              label: 'Website',
              value: garage.website!,
              iconColor: AppColors.accent,
              onTap: () {},
            ),
          const SizedBox(height: AppSpacing.xxl),
          Text('Working Hours', style: AppTextStyles.heading3),
          const SizedBox(height: AppSpacing.md),
          ...garage.workingHours.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      _capitalize(entry.key),
                      style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      entry.value.isClosed
                          ? 'Closed'
                          : '${entry.value.open} - ${entry.value.close}',
                      style: AppTextStyles.body.copyWith(
                        color: entry.value.isClosed ? AppColors.error : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: AppSpacing.xxl),
          if (garage.galleryImages.isNotEmpty) ...[
            Text('Gallery', style: AppTextStyles.heading3),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: garage.galleryImages.length,
                separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    child: Image.network(
                      garage.galleryImages[index],
                      width: 160,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 160,
                        color: AppColors.background,
                        child: const Icon(Icons.image, color: AppColors.textHint, size: 32),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xxl),
          Text('Specializations', style: AppTextStyles.heading3),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: garage.specializations
                .map((s) => Chip(
                      label: Text(s),
                      backgroundColor: AppColors.primaryLight.withOpacity(0.5),
                      labelStyle: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primaryDark,
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: AppSpacing.xxxl),
        ],
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...categories.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.sm),
                ...entry.value.map((service) => ServiceCard(service: service)),
                const SizedBox(height: AppSpacing.md),
              ],
            );
          }),
        ],
      ),
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
          GgButton(
            label: 'Write a Review',
            icon: Icons.rate_review_rounded,
            isOutlined: true,
            onPressed: () {},
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
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.surface,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}