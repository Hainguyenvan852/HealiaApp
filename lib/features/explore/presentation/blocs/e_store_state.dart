part of 'e_store_bloc.dart';

class EStoreState {
  bool isLoading;
  bool isSearching;
  Object? error;
  List<StoreModel> aroundStores;
  List<StoreModel>? searchStores;


  EStoreState({required this.aroundStores, required this.isLoading, this.error, this.searchStores, required this.isSearching});

  factory EStoreState.initial() => EStoreState(
    aroundStores: [],
    isLoading: false,
    isSearching: false,
  );

  EStoreState copyWith({
    bool? isLoading,
    bool? isSearching,
    List<StoreModel>? aroundStores,
    List<StoreModel>? searchStores,
    Object? error
  }){
    return EStoreState(
        aroundStores: aroundStores ?? this.aroundStores,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        searchStores: searchStores,
        isSearching: isSearching ?? this.isSearching
    );
  }
}