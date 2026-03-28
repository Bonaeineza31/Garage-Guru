import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garage_guru/theme/app_theme.dart';
import 'package:garage_guru/models/models.dart';
import 'package:garage_guru/widgets/garage_card.dart';
import 'package:garage_guru/screens/customer/notifications_screen.dart';
import 'package:garage_guru/screens/customer/garage_detail_screen.dart';
import 'package:garage_guru/blocs/garage_bloc.dart';
import 'package:garage_guru/blocs/auth_bloc.dart';

class FindGaragesScreen extends StatefulWidget {
  const FindGaragesScreen({super.key});

  @override
  State<FindGaragesScreen> createState() => _FindGaragesScreenState();
}

class _FindGaragesScreenState extends State<FindGaragesScreen> {
  final _filters = ['All Garages', 'Top Rated', 'Closest'];
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  GarageSort _mapFilterToSort(String filter) {
    switch (filter) {
      case 'Top Rated':
        return GarageSort.topRated;
      case 'Closest':
        return GarageSort.closest;
      default:
        return GarageSort.topRated;
    }
  }

  String _mapSortToFilter(GarageSort sort) {
    switch (sort) {
      case GarageSort.topRated:
        return 'Top Rated';
      case GarageSort.closest:
        return 'Closest';
      default:
        return 'All Garages';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GarageBloc, GarageState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            elevation: 0,
            centerTitle: false,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.garage, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 8),
                const Text(
                  'GarageGuru',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                  );
                },
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Find Garages',
                  style: AppTextStyles.heading2,
                ),
              ),
              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    context.read<GarageBloc>().add(SearchGarages(value));
                  },
                  decoration: InputDecoration(
                    hintText: 'Search garage or service...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.textHint),
                    filled: true,
                    fillColor: AppColors.divider.withOpacity(0.2),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: _filters.map((filter) {
                    final isActive = _mapSortToFilter(state.sortBy) == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(filter),
                        selected: isActive,
                        onSelected: (selected) {
                          if (selected) {
                            context.read<GarageBloc>().add(SortGarages(_mapFilterToSort(filter)));
                          }
                        },
                        backgroundColor: AppColors.divider.withOpacity(0.3),
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: isActive ? Colors.white : AppColors.textPrimary,
                          fontSize: 12,
                          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        side: BorderSide.none,
                        showCheckmark: false,
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Garage List
              Expanded(
                child: state.status == GarageStatus.loading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${state.filteredGarages.length} garage${state.filteredGarages.length == 1 ? '' : 's'} found',
                                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
                              ),
                            ),
                          ),
                          Expanded(
                            child: state.filteredGarages.isEmpty
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
                                    itemCount: state.filteredGarages.length,
                                    itemBuilder: (context, index) {
                                      final garage = state.filteredGarages[index];
                                      return GarageCard(
                                        garage: garage,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => GarageDetailScreen(garage: garage),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
