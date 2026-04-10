import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healio_app/features/explore/data/models/store_model.dart';
import 'package:healio_app/features/explore/domain/usecases/delete_favorite_store_usecase.dart';
import 'package:healio_app/features/explore/domain/usecases/get_favorite_store_usecase.dart';
import 'package:healio_app/features/explore/domain/usecases/insert_favorite_store_usecase.dart';
import 'package:healio_app/features/explore/domain/usecases/search_store_around_location_usecase.dart';
import 'package:healio_app/features/home/data/models/category_model.dart';
import 'package:healio_app/features/home/data/models/review_model.dart';
import 'package:healio_app/features/home/data/models/store_working_hour_model.dart';
import 'package:healio_app/features/home/domain/usecases/get_categories_usecase.dart';
import 'package:healio_app/features/home/domain/usecases/get_opening_hours_usecase.dart';
import 'package:healio_app/features/home/domain/usecases/get_reviews_usecase.dart';
import 'package:healio_app/features/home/domain/usecases/get_services_usecase.dart';

part 'store_infomation_state.dart';

class StoreInfomationCubit extends Cubit<StoreInfomationState> {
  final GetCategoriesUsecase getCategoriesUsecase;
  final GetServicesUsecase getServicesUsecase;
  final GetReviewsUsecase getReviewsUsecase;
  final GetOpeningHoursUsecase getOpeningHoursUsecase;
  final SearchStoreAroundLocationUseCase searchStoreAroundLocationUseCase;
  final GetFavoriteStoreUsecase getFavoriteStoreUsecase;
  final InsertFavoriteStoreUsecase insertFavoriteStoreUsecase;
  final DeleteFavoriteStoreUsecase deleteFavoriteStoreUsecase;

  StoreInfomationCubit({
    required this.getCategoriesUsecase,
    required this.getServicesUsecase,
    required this.getReviewsUsecase,
    required this.getOpeningHoursUsecase,
    required this.searchStoreAroundLocationUseCase,
    required this.getFavoriteStoreUsecase,
    required this.insertFavoriteStoreUsecase,
    required this.deleteFavoriteStoreUsecase,
  }) : super(StoreInfomationState.initState());

  void loadInfomationStore(StoreModel currentStore, String? userId) async {
    try {
      emit(state.copyWith(isLoading: true));
      final categories = await getCategoriesUsecase.call(currentStore.id);

      for (var item in categories) {
        final services = await getServicesUsecase.call(item.id);
        int index = categories.indexOf(item);

        categories[index].services = services;
      }

      final reviews = await getReviewsUsecase.call(currentStore.id);
      final workingHours = await getOpeningHoursUsecase.call(currentStore.id);

      final nearbyStores = await searchStoreAroundLocationUseCase.call(
        currentStore.latitude,
        currentStore.longitude,
        10,
      );

      if (userId != null) {
        final favorite = await getFavoriteStoreUsecase.call(
          userId,
          currentStore.id,
        );

        bool isContained = favorite != null;

        emit(
          state.copyWith(
            isLoading: false,
            store: currentStore,
            categories: categories,
            reviews: reviews,
            workingHours: workingHours,
            nearbyStores: nearbyStores,
            isFavorite: isContained,
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            store: currentStore,
            categories: categories,
            reviews: reviews,
            workingHours: workingHours,
            nearbyStores: nearbyStores,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void reloadFavoriteStore(StoreModel currentStore, String userId) async {
    final favorite = await getFavoriteStoreUsecase.call(
      userId,
      currentStore.id,
    );

    bool isContained = favorite != null;

    emit(state.copyWith(isFavorite: isContained));
  }

  void addFavoriteStore(String userId, int storeId) {
    insertFavoriteStoreUsecase.call(userId, storeId);
    emit(state.copyWith(isFavorite: true));
  }

  void removeFavoriteStore(String userId, int storeId) {
    deleteFavoriteStoreUsecase.call(userId, storeId);
    emit(state.copyWith(isFavorite: false));
  }

  void clearState() {
    emit(state.copyWith(isLoading: true));

    emit(StoreInfomationState.initState());
  }
}
