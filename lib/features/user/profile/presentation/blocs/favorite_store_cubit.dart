import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healio_app/features/user/explore/data/models/store_model.dart';
import 'package:healio_app/features/user/explore/domain/usecases/delete_favorite_store_usecase.dart';
import 'package:healio_app/features/user/explore/domain/usecases/get_favorite_stores_usecase.dart';
import 'package:healio_app/features/user/explore/domain/usecases/insert_favorite_store_usecase.dart';
import 'package:healio_app/features/user/explore/domain/usecases/load_store_with_id_usecase.dart';

part 'favorite_store_state.dart';

class FavoriteStoreCubit extends Cubit<FavoriteStoreState> {
  final GetFavoriteStoresUsecase getFavoriteStoresUsecase;
  final LoadStoreWithIdUseCase getStoreWithIdUsecase;
  final InsertFavoriteStoreUsecase insertFavoriteStoreUsecase;
  final DeleteFavoriteStoreUsecase deleteFavoriteStoreUsecase;

  FavoriteStoreCubit(
    this.getFavoriteStoresUsecase,
    this.getStoreWithIdUsecase,
    this.insertFavoriteStoreUsecase, this.deleteFavoriteStoreUsecase,
  ) : super(FavoriteStoreState.initialState());

  void loadData(String userId) async {
    try {
      emit(state.copyWith(isLoading: true));

      final favoriteStores = await getFavoriteStoresUsecase.call(userId);

      if (favoriteStores.isNotEmpty) {
        final futures = await Future.wait(
          favoriteStores.map(
            (item) => getStoreWithIdUsecase.call(item.storeId),
          ),
        );

        emit(state.copyWith(isLoading: false, stores: futures));
      } else{
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void addFavorite(String userId, StoreModel store) async{
    try {
      emit(state.copyWith(isLoading: true));

      var currentList = List<StoreModel>.from(state.stores);
      currentList.add(store);

      emit(state.copyWith(isLoading: false, stores: currentList));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void removeFavorite(String userId, StoreModel store) async{
    try {
      emit(state.copyWith(isLoading: true));

      var currentList = List<StoreModel>.from(state.stores);
      currentList.removeWhere((item) => item.id == store.id);

      emit(state.copyWith(isLoading: false, stores: currentList));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void clearState(){
    emit(FavoriteStoreState.initialState());
  }
}
