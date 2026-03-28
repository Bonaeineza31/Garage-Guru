part of 'garage_bloc.dart';

abstract class GarageEvent {}

class LoadGarages extends GarageEvent {}

class SearchGarages extends GarageEvent {
  final String query;
  SearchGarages(this.query);
}

class FilterGarages extends GarageEvent {
  final String filter;
  FilterGarages(this.filter);
}

class ToggleFavorite extends GarageEvent {
  final String garageId;
  ToggleFavorite(this.garageId);
}
