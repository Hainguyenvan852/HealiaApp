part of 'favorite_store_cubit.dart';

class FavoriteStoreState {
  bool isLoading;
  Object? error;
  List<StoreModel> stores;

  FavoriteStoreState({
    required this.isLoading,
    required this.stores,
    this.error,
  });

  factory FavoriteStoreState.initialState() =>
      FavoriteStoreState(isLoading: false, stores: []);

  FavoriteStoreState copyWith({
    bool? isLoading,
    Object? error,
    List<StoreModel>? stores
  }) => FavoriteStoreState(isLoading: isLoading ?? this.isLoading, stores: stores ?? this.stores, error: error);
}
