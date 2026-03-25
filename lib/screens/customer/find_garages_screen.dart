import 'package:flutter/material.dart';
import 'package:garage_guru/core/theme/app_theme.dart';
import 'package:garage_guru/data/mock_data.dart';
import 'package:garage_guru/widgets/garage_card.dart';
import 'package:garage_guru/screens/customer/notifications_screen.dart';
import 'package:garage_guru/screens/customer/garage_detail_screen.dart';

class FindGaragesScreen extends StatefulWidget {
  const FindGaragesScreen({super.key});

  @override
  State<FindGaragesScreen> createState() => _FindGaragesScreenState();
}

class _FindGaragesScreenState extends State<FindGaragesScreen> {
  String _activeFilter = 'All Garages';
  final _filters = ['All Garages', 'Top Rated', 'Closest'];
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List get _filteredGarages {
    var garages = MockData.garages.toList();

    // Apply search
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      garages = garages.where((garage) {
        final nameMatch = (garage.name ?? '').toLowerCase().contains(query);
        final servicesMatch = garage.services
            .any((service) => (service ?? '').toLowerCase().contains(query));
        return nameMatch || servicesMatch;
      }).toList();
    }

    // Apply filter
    if (_activeFilter == 'Top Rated') {
      garages.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (_activeFilter == 'Closest') {
      garages.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    }

    return garages;
  }

  @override
  Widget build(BuildContext context) {
    final garages = _filteredGarages;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Find Garages',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search garage or service...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textHint),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.textHint),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: AppSpacing.lg),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
          ),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            child: Row(
              children: _filters.map((filter) {
                final isActive = _activeFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isActive,
                    onSelected: (selected) {
                      if (selected) setState(() => _activeFilter = filter);
                    },
                    backgroundColor: AppColors.surface,
                    selectedColor: AppColors.primary,
                    labelStyle: AppTextStyles.bodySmall.copyWith(
                      color: isActive ? Colors.white : AppColors.textPrimary,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      side: BorderSide(
                        color: isActive ? AppColors.primary : AppColors.divider,
                      ),
                    ),
                    showCheckmark: false,
                  ),
                );
              }).toList(),
            ),
          ),

          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${garages.length} garage${garages.length == 1 ? '' : 's'} found',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
              ),
            ),
          ),

          // Garage List
          Expanded(
            child: garages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.search_off_rounded, size: 48, color: AppColors.textHint),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'No garages found',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: garages.length,
                    itemBuilder: (context, index) {
                      return GarageCard(
                        garage: garages[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GarageDetailScreen(garage: garages[index]),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}