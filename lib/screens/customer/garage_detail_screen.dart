import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garage_guru/theme/app_theme.dart';
import 'package:garage_guru/data/mock_data.dart';
import 'package:garage_guru/models/models.dart';
import 'package:garage_guru/widgets/widgets.dart';
import 'package:intl/intl.dart';
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                unselectedLabelColor: Theme.of(context).hintColor,
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
      color: Theme.of(context).scaffoldBackgroundColor,
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
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: AppColors.starFilled, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '${garage.rating.toStringAsFixed(2)} (${garage.reviewCount} reviews)',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
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
                          style: Theme.of(context).textTheme.bodySmall,
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
          Text('About', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(garage.description, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 24),
          Text('Contact & Location', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          _buildInfoRow(context, Icons.location_on_outlined, 'Address', garage.address),
          _buildInfoRow(context, Icons.phone_outlined, 'Phone', garage.phone),
          _buildInfoRow(context, Icons.access_time_outlined, 'Hours', 'Mon-Sat: 8:00 AM - 6:00 PM'),
          const SizedBox(height: 24),
          Text('Gallery', style: Theme.of(context).textTheme.titleLarge),
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

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).iconTheme.color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold)),
                Text(value, style: Theme.of(context).textTheme.bodySmall),
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
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: ExpansionTile(
            title: Text(
              serviceCategories[index],
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            shape: const RoundedRectangleBorder(side: BorderSide.none),
            collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
            iconColor: Theme.of(context).iconTheme.color,
            collapsedIconColor: Theme.of(context).iconTheme.color,
            childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              _buildServiceItem(context, 'Full computer diagnostics', 'Frw 25,000'),
              _buildServiceItem(context, 'Oil Change', 'Frw 30,000'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildServiceItem(BuildContext context, String name, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: Theme.of(context).textTheme.bodySmall),
          Text(
            price,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewsTab extends StatefulWidget {
  final GarageModel garage;
  const _ReviewsTab({required this.garage});

  @override
  State<_ReviewsTab> createState() => _ReviewsTabState();
}

class _ReviewsTabState extends State<_ReviewsTab> {
  late Stream<QuerySnapshot> _reviewsStream;

  @override
  void initState() {
    super.initState();
    _reviewsStream = FirebaseFirestore.instance
        .collection('reviews')
        .where('garageId', isEqualTo: widget.garage.id)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _reviewsStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        
        if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final reviews = (snapshot.data?.docs ?? []).toList();
        // In-memory sorting to avoid composite index requirements
        reviews.sort((a, b) {
          final aData = a.data() as Map<String, dynamic>;
          final bData = b.data() as Map<String, dynamic>;
          final aTime = aData['createdAt'] as Timestamp?;
          final bTime = bData['createdAt'] as Timestamp?;
          if (aTime == null) return 1;
          if (bTime == null) return -1;
          return bTime.compareTo(aTime);
        });

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                   Text(
                    garage.rating.toStringAsFixed(2),
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 48, fontWeight: FontWeight.bold),
                  Column(
                    children: [
                      Text(
                        widget.garage.rating.toStringAsFixed(2),
                        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      Row(
                        children: List.generate(5, (index) => const Icon(Icons.star_rounded, color: AppColors.starFilled, size: 20)),
                      ),
                      const SizedBox(height: 4),
                      Text('${widget.garage.reviewCount} reviews', style: AppTextStyles.caption),
                    ],
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: Column(
                      children: [
                        _buildRatingBar(5, reviews.where((r) => (r.data() as Map)['rating'] == 5).length / (reviews.isEmpty ? 1 : reviews.length)),
                        _buildRatingBar(4, reviews.where((r) => (r.data() as Map)['rating'] == 4).length / (reviews.isEmpty ? 1 : reviews.length)),
                        _buildRatingBar(3, reviews.where((r) => (r.data() as Map)['rating'] == 3).length / (reviews.isEmpty ? 1 : reviews.length)),
                        _buildRatingBar(2, reviews.where((r) => (r.data() as Map)['rating'] == 2).length / (reviews.isEmpty ? 1 : reviews.length)),
                        _buildRatingBar(1, reviews.where((r) => (r.data() as Map)['rating'] == 1).length / (reviews.isEmpty ? 1 : reviews.length)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              if (reviews.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text('No reviews yet. Be the first to review!', style: TextStyle(color: AppColors.textSecondary)),
                  ),
                )
              else
                ...reviews.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final date = (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
                  return _buildReviewCard(
                    data['userName'] ?? 'User',
                    data['userPhoto'],
                    DateFormat('MMM dd, yyyy').format(date),
                    data['comment'] ?? '',
                    (data['rating'] ?? 0).toInt(),
                  );
                }).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRatingBar(BuildContext context, int stars, double progress) {
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
                backgroundColor: Theme.of(context).dividerColor.withOpacity(0.1),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.starFilled),
                minHeight: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(String user, String? userPhoto, String date, String content, int rating) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primaryLight,
                backgroundImage: userPhoto != null ? NetworkImage(userPhoto) : null,
                child: userPhoto == null ? const Icon(Icons.person, size: 18, color: AppColors.primary) : null,
              ),
              const SizedBox(width: 12),
              Expanded(
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
                    const SizedBox(height: 2),
                    Row(
                      children: List.generate(5, (index) => Icon(Icons.star_rounded, color: index < rating ? AppColors.starFilled : AppColors.divider, size: 16)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(content, style: Theme.of(context).textTheme.bodySmall),
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
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          tabBar,
          Divider(height: 1, color: Theme.of(context).dividerColor),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}
