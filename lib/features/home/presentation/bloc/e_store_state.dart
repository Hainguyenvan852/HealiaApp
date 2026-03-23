part of 'e_store_bloc.dart';

class EStoreState {
  bool isLoading;
  Object? error;
  List<StoreModel> aroundStores;

  EStoreState({required this.aroundStores, required this.isLoading, this.error});

  factory EStoreState.initial() => EStoreState(
    aroundStores: [],
    isLoading: false,
  );

  EStoreState copyWith({
    bool? isLoading,
    List<StoreModel>? aroundStores,
    Object? error
  }){
    return EStoreState(
        aroundStores: aroundStores ?? this.aroundStores,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error
    );
  }
}