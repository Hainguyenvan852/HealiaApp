part of 'store_bloc.dart';

class StoreState {
  bool isLoading;
  Object? error;
  List<StoreModel> recentlyStores;
  List<StoreModel> recommendStores;
  List<StoreModel> newlyStores;
  List<StoreModel> trendingStores;

  StoreState({required this.recentlyStores, required this.recommendStores, required this.newlyStores, required this.trendingStores, required this.isLoading, this.error});

  factory StoreState.initial() => StoreState(
      recentlyStores: [],
      recommendStores: [],
      newlyStores: [],
      trendingStores: [],
      isLoading: false,
  );

  StoreState copyWith({
    bool? isLoading,
    List<StoreModel>?
    recentlyStores,
    List<StoreModel>? recommendStores,
    List<StoreModel>? newlyStores,
    List<StoreModel>? trendingStores,
    Object? error
  }){
    return StoreState(
        recentlyStores: recentlyStores ?? this.recentlyStores,
        recommendStores: recommendStores ?? this.recommendStores,
        newlyStores: newlyStores ?? this.newlyStores,
        trendingStores: trendingStores ?? this.trendingStores,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error
    );
  }
}