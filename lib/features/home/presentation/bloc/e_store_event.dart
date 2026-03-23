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