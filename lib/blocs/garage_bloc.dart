import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garage_guru/models/garage_model.dart';

// Events
abstract class GarageEvent extends Equatable {
  const GarageEvent();
  @override
  List<Object?> get props => [];
}

class LoadGarages extends GarageEvent {}

class GaragesUpdated extends GarageEvent {
  final List<GarageModel> garages;
  const GaragesUpdated(this.garages);
  @override
  List<Object?> get props => [garages];
}

class SearchGarages extends GarageEvent {
  final String query;
  const SearchGarages(this.query);
  @override
  List<Object?> get props => [query];
}

class FilterGarages extends GarageEvent {
  final String category;
  const FilterGarages(this.category);
  @override
  List<Object?> get props => [category];
}

enum GarageSort { all, topRated, closest }

class SortGarages extends GarageEvent {
  final GarageSort sortBy;
  const SortGarages(this.sortBy);
  @override
  List<Object?> get props => [sortBy];
}

class ToggleFavorite extends GarageEvent {
  final GarageModel garage;
  const ToggleFavorite(this.garage);
  @override
  List<Object?> get props => [garage];
}

// States
enum GarageStatus { initial, loading, success, failure }

class GarageState extends Equatable {
  final GarageStatus status;
  final List<GarageModel> allGarages;
  final List<GarageModel> filteredGarages;
  final String searchQuery;
  final String selectedCategory;
  final GarageSort sortBy;

  const GarageState({
    this.status = GarageStatus.initial,
    this.allGarages = const [],
    this.filteredGarages = const [],
    this.searchQuery = '',
    this.selectedCategory = 'All',
    this.sortBy = GarageSort.all,
  });

  GarageState copyWith({
    GarageStatus? status,
    List<GarageModel>? allGarages,
    List<GarageModel>? filteredGarages,
    String? searchQuery,
    String? selectedCategory,
    GarageSort? sortBy,
  }) {
    return GarageState(
      status: status ?? this.status,
      allGarages: allGarages ?? this.allGarages,
      filteredGarages: filteredGarages ?? this.filteredGarages,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  @override
  List<Object?> get props => [status, allGarages, filteredGarages, searchQuery, selectedCategory, sortBy];
}

// BLoC
class GarageBloc extends Bloc<GarageEvent, GarageState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  GarageBloc() : super(const GarageState()) {
    on<LoadGarages>(_onLoadGarages);
    on<GaragesUpdated>(_onGaragesUpdated);
    on<SearchGarages>(_onSearchGarages);
    on<FilterGarages>(_onFilterGarages);
    on<SortGarages>(_onSortGarages);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  final List<StreamSubscription> _subscriptions = [];

  Future<void> _onLoadGarages(LoadGarages event, Emitter<GarageState> emit) async {
    emit(state.copyWith(status: GarageStatus.loading));
    
    for (var sub in _subscriptions) sub.cancel();
    _subscriptions.clear();

    final sub = _firestore.collection('garages').snapshots().listen((snapshot) {
      final garages = snapshot.docs
          .map((doc) => GarageModel.fromMap(doc.data(), doc.id))
          .toList();
      add(GaragesUpdated(garages));
    });
    
    _subscriptions.add(sub);
  }

  void _onGaragesUpdated(GaragesUpdated event, Emitter<GarageState> emit) {
    emit(state.copyWith(
      status: GarageStatus.success,
      allGarages: event.garages,
      filteredGarages: _applyFilters(event.garages, state.searchQuery, state.selectedCategory, state.sortBy),
    ));
  }

  void _onSearchGarages(SearchGarages event, Emitter<GarageState> emit) {
    emit(state.copyWith(
      searchQuery: event.query,
      filteredGarages: _applyFilters(state.allGarages, event.query, state.selectedCategory, state.sortBy),
    ));
  }

  void _onFilterGarages(FilterGarages event, Emitter<GarageState> emit) {
    emit(state.copyWith(
      selectedCategory: event.category,
      filteredGarages: _applyFilters(state.allGarages, state.searchQuery, event.category, state.sortBy),
    ));
  }

  void _onSortGarages(SortGarages event, Emitter<GarageState> emit) {
    emit(state.copyWith(
      sortBy: event.sortBy,
      filteredGarages: _applyFilters(state.allGarages, state.searchQuery, state.selectedCategory, event.sortBy),
    ));
  }

  List<GarageModel> _applyFilters(List<GarageModel> garages, String query, String category, GarageSort sortBy) {
    var filtered = garages.where((garage) {
      final matchesSearch = garage.name.toLowerCase().contains(query.toLowerCase()) ||
          garage.description.toLowerCase().contains(query.toLowerCase());
      final matchesCategory = category == 'All' || garage.services.contains(category);
      return matchesSearch && matchesCategory;
    }).toList();

    if (sortBy == GarageSort.topRated) {
      filtered.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (sortBy == GarageSort.closest) {
      filtered.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    }

    return filtered;
  }

  Future<void> _onToggleFavorite(ToggleFavorite event, Emitter<GarageState> emit) async {
    final updatedIsFavorite = !event.garage.isFavorite;
    
    // Optimistically update local state
    final updatedAllGarages = state.allGarages.map((g) {
      if (g.id == event.garage.id) {
        return g.copyWith(isFavorite: updatedIsFavorite);
      }
      return g;
    }).toList();

    emit(state.copyWith(
      allGarages: updatedAllGarages,
      filteredGarages: _applyFilters(updatedAllGarages, state.searchQuery, state.selectedCategory, state.sortBy),
    ));

    try {
      await _firestore.collection('garages').doc(event.garage.id).update({
        'isFavorite': updatedIsFavorite,
      });
    } catch (e) {
      // Revert if failed
      final revertedAllGarages = state.allGarages.map((g) {
        if (g.id == event.garage.id) {
          return g.copyWith(isFavorite: event.garage.isFavorite);
        }
        return g;
      }).toList();
      
      emit(state.copyWith(
        allGarages: revertedAllGarages,
        filteredGarages: _applyFilters(revertedAllGarages, state.searchQuery, state.selectedCategory, state.sortBy),
      ));
    }
  }

  @override
  Future<void> close() {
    for (var sub in _subscriptions) sub.cancel();
    return super.close();
  }
}
