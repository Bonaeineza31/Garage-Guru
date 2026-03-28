import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garage_guru/core/theme/app_theme.dart';
import 'package:garage_guru/data/mock_data.dart';
import 'package:garage_guru/models/models.dart';
import 'package:garage_guru/services/favorite_garages_service.dart';
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
    FavoriteGaragesService.instance.ensureLoaded();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final garage = widget.garage;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
        ),
        title: Text(
          'Garage Details',
          style: theme.textTheme.titleLarge?.copyWith(
                color: cs.onPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ) ??
              TextStyle(
                color: cs.onPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 18,
                fontFamily: 'Poppins',
              ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: cs.onPrimary),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: cs.onPrimary),
          onPressed: () => Navigator.of(context).maybePop(),
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
                labelColor: cs.primary,
                unselectedLabelColor: cs.onSurfaceVariant,
                indicatorColor: cs.primary,
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
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final onSurface = cs.onSurface;
    final muted = cs.onSurfaceVariant;

    return Material(
      color: cs.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      color: cs.primaryContainer,
                      child: Icon(Icons.garage, color: cs.primary),
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
                        style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: onSurface,
                            ) ??
                            AppTextStyles.heading3.copyWith(color: onSurface),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star_rounded, color: AppColors.starFilled, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${garage.rating} (${garage.reviewCount} reviews)',
                            style: theme.textTheme.bodySmall?.copyWith(
                                  color: muted,
                                  fontWeight: FontWeight.w600,
                                ) ??
                                AppTextStyles.caption.copyWith(color: muted, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 14, color: muted),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${garage.distanceKm.toStringAsFixed(1)}km away • ${garage.address.split(',').last.trim()}',
                              style: theme.textTheme.bodySmall?.copyWith(color: muted) ??
                                  AppTextStyles.caption.copyWith(color: muted),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ListenableBuilder(
                  listenable: FavoriteGaragesService.instance,
                  builder: (context, _) {
                    final fav = FavoriteGaragesService.instance.isFavorite(garage.id);
                    return IconButton(
                      onPressed: () => FavoriteGaragesService.instance.toggle(garage.id),
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                      icon: Icon(
                        fav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        size: 26,
                        color: fav ? cs.error : muted,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.phone_outlined, size: 16, color: cs.primary),
                    label: Text('Call', style: TextStyle(color: cs.primary)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm,
                        horizontal: 0,
                      ),
                      foregroundColor: cs.primary,
                      side: BorderSide(color: cs.primary, width: 1.5),
                      backgroundColor: cs.primaryContainer.withValues(alpha: 0.35),
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
                    icon: Icon(Icons.chat_bubble_outline_rounded, size: 16, color: cs.primary),
                    label: Text('Message', style: TextStyle(color: cs.primary)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm,
                        horizontal: 0,
                      ),
                      foregroundColor: cs.primary,
                      side: BorderSide(color: cs.primary, width: 1.5),
                      backgroundColor: cs.primaryContainer.withValues(alpha: 0.35),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => BookingScreen(garage: garage)),
                      );
                    },
                    icon: Icon(Icons.calendar_today_rounded, size: 16, color: cs.onPrimary),
                    label: const Text('Book'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: 0),
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
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
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: AppTextStyles.heading3.copyWith(color: cs.onSurface),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            garage.description,
            style: AppTextStyles.body.copyWith(color: cs.onSurface),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            'Contact & Location',
            style: AppTextStyles.heading3.copyWith(color: cs.onSurface),
          ),
          const SizedBox(height: AppSpacing.md),
          InfoRow(
            icon: Icons.location_on_rounded,
            label: 'Address',
            value: garage.address,
            iconColor: cs.onSurfaceVariant,
            onTap: () {},
          ),
          InfoRow(
            icon: Icons.phone_rounded,
            label: 'Phone',
            value: garage.phone,
            iconColor: cs.onSurfaceVariant,
            onTap: () {},
          ),
          InfoRow(
            icon: Icons.access_time_rounded,
            label: 'Hours',
            value: 'Mon-Sat: 8:00 AM - 6:00 PM',
            iconColor: cs.onSurfaceVariant,
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.xxl),
          if (garage.galleryImages.isNotEmpty) ...[
            Text(
              'Gallery',
              style: AppTextStyles.heading3.copyWith(color: cs.onSurface),
            ),
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
                      color: cs.surfaceContainerHighest,
                      child: Icon(Icons.image, color: cs.onSurfaceVariant, size: 32),
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
    final cs = Theme.of(context).colorScheme;
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
              color: cs.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: ExpansionTile(
              title: Text(
                category,
                style: AppTextStyles.subtitle.copyWith(color: cs.onSurface),
              ),
              iconColor: cs.primary,
              collapsedIconColor: cs.onSurfaceVariant,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
              childrenPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              children: categoryServices.map((service) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: ServiceCard(service: service),
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
    final cs = Theme.of(context).colorScheme;
    return Container(
      color: cs.surface,
      child: Column(
        children: [
          tabBar,
          Divider(height: 1, color: cs.outlineVariant),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => oldDelegate.tabBar != tabBar;
}
