part of 'e_store_bloc.dart';

abstract class EStoreEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadingStore extends EStoreEvent{

  @override
  List<Object?> get props => [];
}

class AddRecentlyStore extends EStoreEvent{
  final String storeId;

  AddRecentlyStore(this.storeId);

  @override
  List<Object?> get props => [storeId];
}

class SearchByFilter extends EStoreEvent{
  final String? filter;
  final String? category;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final DateTime? date;
  final double userLat;
  final double userLng;
  final double radiusKm;

  SearchByFilter({this.filter, this.startTime, this.date, required this.userLat, required this.userLng, required this.radiusKm, this.category, this.endTime});

  @override
  List<Object?> get props => [filter, startTime, date, userLat, userLng, radiusKm, category];
}

class ClearSearch extends EStoreEvent{}