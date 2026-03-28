part of 'garage_bloc.dart';

abstract class GarageState {}

class GarageInitial extends GarageState {}

class GarageLoading extends GarageState {}

class GarageLoaded extends GarageState {
  final List<GarageModel> allGarages;
  final List<GarageModel> filteredGarages;
  final String searchQuery;
  final String activeFilter;

  GarageLoaded({
    required this.allGarages,
    required this.filteredGarages,
    this.searchQuery = '',
    this.activeFilter = 'All Garages',
  });

  GarageLoaded copyWith({
    List<GarageModel>? allGarages,
    List<GarageModel>? filteredGarages,
    String? searchQuery,
    String? activeFilter,
  }) {
    return GarageLoaded(
      allGarages: allGarages ?? this.allGarages,
      filteredGarages: filteredGarages ?? this.filteredGarages,
      searchQuery: searchQuery ?? this.searchQuery,
      activeFilter: activeFilter ?? this.activeFilter,
    );
  }
}

class GarageError extends GarageState {
  final String message;
  GarageError(this.message);
}
