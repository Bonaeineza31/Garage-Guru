import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garage_guru/models/garage_model.dart';

part 'garage_event.dart';
part 'garage_state.dart';

class GarageBloc extends Bloc<GarageEvent, GarageState> {
  StreamSubscription<QuerySnapshot>? _garagesSubscription;

  GarageBloc() : super(GarageInitial()) {
    on<LoadGarages>(_onLoadGarages);
    on<SearchGarages>(_onSearchGarages);
    on<FilterGarages>(_onFilterGarages);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  void _onLoadGarages(LoadGarages event, Emitter<GarageState> emit) async {
    emit(GarageLoading());
    await emit.forEach<QuerySnapshot>(
      FirebaseFirestore.instance.collection('garages').snapshots(),
      onData: (snapshot) {
        final current = state is GarageLoaded ? state as GarageLoaded : null;

        // Preserve favorite state across reloads
        final favoriteIds = current?.allGarages
            .where((g) => g.isFavorite)
            .map((g) => g.id)
            .toSet() ?? {};

        final garages = snapshot.docs.map((doc) {
          final g = GarageModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          return favoriteIds.contains(g.id) ? g.copyWith(isFavorite: true) : g;
        }).toList();

        final filtered = _applyFilters(
          garages,
          query: current?.searchQuery ?? '',
          filter: current?.activeFilter ?? 'All Garages',
        );

        return GarageLoaded(
          allGarages: garages,
          filteredGarages: filtered,
          searchQuery: current?.searchQuery ?? '',
          activeFilter: current?.activeFilter ?? 'All Garages',
        );
      },
      onError: (_, __) => GarageError('Failed to load garages'),
    );
  }

  void _onSearchGarages(SearchGarages event, Emitter<GarageState> emit) {
    if (state is! GarageLoaded) return;
    final current = state as GarageLoaded;
    emit(current.copyWith(
      searchQuery: event.query,
      filteredGarages: _applyFilters(
        current.allGarages,
        query: event.query,
        filter: current.activeFilter,
      ),
    ));
  }

  void _onFilterGarages(FilterGarages event, Emitter<GarageState> emit) {
    if (state is! GarageLoaded) return;
    final current = state as GarageLoaded;
    emit(current.copyWith(
      activeFilter: event.filter,
      filteredGarages: _applyFilters(
        current.allGarages,
        query: current.searchQuery,
        filter: event.filter,
      ),
    ));
  }

  void _onToggleFavorite(ToggleFavorite event, Emitter<GarageState> emit) {
    if (state is! GarageLoaded) return;
    final current = state as GarageLoaded;

    final updatedAll = current.allGarages.map((g) {
      return g.id == event.garageId ? g.copyWith(isFavorite: !g.isFavorite) : g;
    }).toList();

    emit(current.copyWith(
      allGarages: updatedAll,
      filteredGarages: _applyFilters(
        updatedAll,
        query: current.searchQuery,
        filter: current.activeFilter,
      ),
    ));
  }

  List<GarageModel> _applyFilters(
    List<GarageModel> garages, {
    required String query,
    required String filter,
  }) {
    var result = garages.toList();

    if (query.isNotEmpty) {
      final q = query.toLowerCase();
      result = result.where((g) {
        return g.name.toLowerCase().contains(q) ||
            g.services.any((s) => s.toLowerCase().contains(q));
      }).toList();
    }

    if (filter == 'Top Rated') {
      result.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (filter == 'Closest') {
      result.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    } else if (filter == 'Favorites') {
      result = result.where((g) => g.isFavorite).toList();
    }

    return result;
  }

  @override
  Future<void> close() {
    _garagesSubscription?.cancel();
    return super.close();
  }
}
