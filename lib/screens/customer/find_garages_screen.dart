import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garage_guru/bloc/garage/garage_bloc.dart';
import 'package:garage_guru/core/theme/app_theme.dart';
import 'package:garage_guru/widgets/garage_card.dart';
import 'package:garage_guru/screens/customer/notifications_screen.dart';
import 'package:garage_guru/screens/customer/garage_detail_screen.dart';

class FindGaragesScreen extends StatefulWidget {
  final String initialQuery;

  const FindGaragesScreen({super.key, this.initialQuery = ''});

  @override
  State<FindGaragesScreen> createState() => _FindGaragesScreenState();
}

class _FindGaragesScreenState extends State<FindGaragesScreen> {
  final _filters = ['All Garages', 'Top Rated', 'Closest', 'Favorites'];
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    if (widget.initialQuery.isNotEmpty) {
      context.read<GarageBloc>().add(SearchGarages(widget.initialQuery));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GarageBloc, GarageState>(
      builder: (context, state) {
        final activeFilter = state is GarageLoaded ? state.activeFilter : 'All Garages';

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Find Garages', style: TextStyle(color: Colors.white)),
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                ),
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
                  onChanged: (value) => context.read<GarageBloc>().add(SearchGarages(value)),
                  decoration: InputDecoration(
                    hintText: 'Search garage or service...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.textHint),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: AppColors.textHint),
                            onPressed: () {
                              _searchController.clear();
                              context.read<GarageBloc>().add(SearchGarages(''));
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

              // Filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                child: Row(
                  children: _filters.map((filter) {
                    final isActive = activeFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: FilterChip(
                        label: Text(filter),
                        selected: isActive,
                        onSelected: (selected) {
                          if (selected) context.read<GarageBloc>().add(FilterGarages(filter));
                        },
                        backgroundColor: AppColors.surface,
                        selectedColor: AppColors.primary,
                        labelStyle: AppTextStyles.bodySmall.copyWith(
                          color: isActive ? Colors.white : AppColors.textPrimary,
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          side: BorderSide(color: isActive ? AppColors.primary : AppColors.divider),
                        ),
                        showCheckmark: false,
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Body
              Expanded(
                child: switch (state) {
                  GarageLoading() => const Center(child: CircularProgressIndicator()),
                  GarageError(:final message) => Center(child: Text('Error: $message')),
                  GarageLoaded(:final filteredGarages) => Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${filteredGarages.length} garage${filteredGarages.length == 1 ? '' : 's'} found',
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
                            ),
                          ),
                        ),
                        Expanded(
                          child: filteredGarages.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.search_off_rounded, size: 48, color: AppColors.textHint),
                                      const SizedBox(height: AppSpacing.sm),
                                      Text('No garages found',
                                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint)),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.all(AppSpacing.lg),
                                  itemCount: filteredGarages.length,
                                  itemBuilder: (context, index) {
                                    final garage = filteredGarages[index];
                                    return GarageCard(
                                      garage: garage,
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => GarageDetailScreen(garage: garage),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  _ => const SizedBox.shrink(),
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
