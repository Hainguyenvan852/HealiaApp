part of 'store_bloc.dart';

abstract class StoreEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadingStore extends StoreEvent{

  @override
  List<Object?> get props => [];
}

class AddRecentlyStore extends StoreEvent{
  final String storeId;

  AddRecentlyStore(this.storeId);

  @override
  List<Object?> get props => [storeId];
}