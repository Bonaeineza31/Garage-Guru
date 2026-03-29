import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garage_guru/theme/app_theme.dart';
import 'package:garage_guru/data/mock_data.dart';
import 'package:garage_guru/models/models.dart';
import 'package:garage_guru/widgets/widgets.dart';
import 'package:garage_guru/screens/customer/booking_screen.dart';
import 'package:garage_guru/screens/customer/garage_message_screen.dart';
import 'package:garage_guru/blocs/garage_bloc.dart';

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
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          BlocBuilder<GarageBloc, GarageState>(
            builder: (context, state) {
              final currentGarage = state.allGarages.firstWhere(
                (g) => g.id == garage.id,
                orElse: () => garage,
              );
              bool isFavorite = currentGarage.isFavorite;
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white70,
                ),
                onPressed: () {
                  context.read<GarageBloc>().add(ToggleFavorite(currentGarage));
                },
              );
            },
          ),
          const SizedBox(width: 8),
        ],
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
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  garage.coverImageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 80,
                    height: 80,
                    color: AppColors.primaryLight,
                    child: const Icon(Icons.garage, color: AppColors.primary, size: 40),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      garage.name,
                      style: AppTextStyles.heading2,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: AppColors.starFilled, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '${garage.rating.toStringAsFixed(2)} (${garage.reviewCount} reviews)',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          '${garage.distanceKm}km away • ${garage.address.split(',').last.trim()}',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.phone_outlined, size: 18),
                  label: const Text('Call'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => GarageMessageScreen(garage: garage)),
                    );
                  },
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                  label: const Text('Message'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
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
                  icon: const Icon(Icons.calendar_today_rounded, size: 18),
                  label: const Text('Book'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('About', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text(garage.description, style: AppTextStyles.bodySmall),
          const SizedBox(height: 24),
          const Text('Contact & Location', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.location_on_outlined, 'Address', garage.address),
          _buildInfoRow(Icons.phone_outlined, 'Phone', garage.phone),
          _buildInfoRow(Icons.access_time_outlined, 'Hours', 'Mon-Sat: 8:00 AM - 6:00 PM'),
          const SizedBox(height: 24),
          const Text('Gallery', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: garage.galleryImages.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  garage.galleryImages[index],
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
                Text(value, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
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
    final serviceCategories = [
      'Engine Services',
      'Battery Service',
      'Tire Services',
      'Maintenance',
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: serviceCategories.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.divider),
          ),
          child: ExpansionTile(
            title: Text(
              serviceCategories[index],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            shape: const RoundedRectangleBorder(side: BorderSide.none),
            collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
            iconColor: AppColors.textSecondary,
            collapsedIconColor: AppColors.textSecondary,
            childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              _buildServiceItem('Full computer diagnostics', 'Frw 25,000'),
              _buildServiceItem('Oil Change', 'Frw 30,000'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildServiceItem(String name, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: AppTextStyles.bodySmall),
          Text(
            price,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                children: [
                   Text(
                    garage.rating.toStringAsFixed(2),
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  Row(
                    children: List.generate(5, (index) => const Icon(Icons.star_rounded, color: AppColors.starFilled, size: 20)),
                  ),
                  const SizedBox(height: 4),
                  Text('${garage.reviewCount} reviews', style: AppTextStyles.caption),
                ],
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  children: [
                    _buildRatingBar(5, 0.9),
                    _buildRatingBar(4, 0.1),
                    _buildRatingBar(3, 0.0),
                    _buildRatingBar(2, 0.0),
                    _buildRatingBar(1, 0.0),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildReviewCard('Jean Pierre', 'May 15, 2023', 'Excellent service! They fixed my car quickly and at a reasonable price.', 5),
          _buildReviewCard('Marie Claire', 'May 5, 2023', 'Good service but I had to wait a bit longer than expected. The mechanics are very professional though.', 4),
          _buildReviewCard('Emmanuel', 'April 20, 2023', 'Best garage in Kigali! They diagnosed and fixed my engine problem that other garages couldn\'t figure out.', 5),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int stars, double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$stars', style: AppTextStyles.caption),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.divider,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.starFilled),
                minHeight: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(String user, String date, String content, int rating) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(user, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(date, style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: List.generate(5, (index) => Icon(Icons.star_rounded, color: index < rating ? AppColors.starFilled : AppColors.divider, size: 16)),
          ),
          const SizedBox(height: 8),
          Text(content, style: AppTextStyles.bodySmall),
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
