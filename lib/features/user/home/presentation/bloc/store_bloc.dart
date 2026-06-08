import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:healio_app/core/services/recently_view_service.dart';
import 'package:healio_app/core/utils/map_helper.dart';
import 'package:healio_app/features/user/auth/domain/usecases/check_user_session_usecase.dart';
import 'package:healio_app/features/user/explore/data/models/store_model.dart';
import 'package:equatable/equatable.dart';
import 'package:healio_app/features/user/explore/domain/usecases/load_newly_store_usecase.dart';
import 'package:healio_app/features/user/explore/domain/usecases/load_recently_store_usecase.dart';
import 'package:healio_app/features/user/explore/domain/usecases/load_recommend_store_usecase.dart';
import 'package:healio_app/features/user/explore/domain/usecases/load_store_with_distance_usecase.dart';
import 'package:healio_app/features/user/explore/domain/usecases/load_trending_store_usecase.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'store_event.dart';
part 'store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  final LoadRecommendStoreUseCase loadRecommendStoreUseCase;
  final LoadNewlyStoreUseCase loadNewlyStoreUseCase;
  final LoadStoreWithDistanceUseCase loadStoreWithDistanceUseCase;
  final LoadRecentlyStoreUseCase loadRecentlyStoreUseCase;
  final LoadTrendingStoreUseCase loadTrendingStoreUseCase;
  final CheckUserSessionUseCase checkUserSessionUseCase;

  StoreBloc({
    required this.loadRecommendStoreUseCase,
    required this.loadNewlyStoreUseCase,
    required this.loadStoreWithDistanceUseCase,
    required this.loadRecentlyStoreUseCase,
    required this.loadTrendingStoreUseCase,
    required this.checkUserSessionUseCase,
  }) : super(StoreState.initial()) {
    on<LoadingStore>((event, emit) async {
      try {
        emit(state.copyWith(isLoading: true));
        Position? position;
        final status = await MapHelper.checkPermission();
        if (status == PermissionStatus.granted) {
          position = await Geolocator.getCurrentPosition();
        }

        final recentlyStoreIds =
            await RecentlyViewedService.getRecentlyViewedIds();
        final session = await checkUserSessionUseCase.call();

        if (recentlyStoreIds.isEmpty) {
          final result = await Future.wait([
            loadTrendingStoreUseCase.call(),
            loadRecommendStoreUseCase.call(
              session != null ? session.user.id : null,
            ),
            loadNewlyStoreUseCase.call(),
          ]);

          final trendingStores = result[0];
          final recommendStores = result[1];
          final newlyStores = result[2];

          emit(
            state.copyWith(
              isLoading: false,
              trendingStores: trendingStores,
              recommendStores: recommendStores,
              newlyStores: newlyStores,
            ),
          );
        } else {
          final result = await Future.wait([
            loadTrendingStoreUseCase.call(),
            loadRecommendStoreUseCase.call(
              session != null ? session.user.id : null,
            ),
            loadNewlyStoreUseCase.call(),
            loadRecentlyStoreUseCase.call(recentlyStoreIds),
          ]);

          List<StoreModel> trendingStores;
          List<StoreModel> recommendStores;
          List<StoreModel> newlyStores;
          List<StoreModel> recentlyStores;

          if (position != null) {
            trendingStores = result[0].map((store) {
              double distance = Geolocator.distanceBetween(
                position!.latitude,
                position.longitude,
                store.latitude,
                store.longitude,
              );
              return store.updateDistance(distance/1000);
            }).toList();
            recommendStores = result[1].map((store) {
              double distance = Geolocator.distanceBetween(
                position!.latitude,
                position.longitude,
                store.latitude,
                store.longitude,
              );
              return store.updateDistance(distance/1000);
            }).toList();
            newlyStores = result[2].map((store) {
              double distance = Geolocator.distanceBetween(
                position!.latitude,
                position.longitude,
                store.latitude,
                store.longitude,
              );
              return store.updateDistance(distance/1000);
            }).toList();
            recentlyStores = result[3].map((store) {
              double distance = Geolocator.distanceBetween(
                position!.latitude,
                position.longitude,
                store.latitude,
                store.longitude,
              );
              return store.updateDistance(distance/1000);
            }).toList();
          } else {
            trendingStores = result[0];
            recommendStores = result[1];
            newlyStores = result[2];
            recentlyStores = result[3];
          }

          emit(
            state.copyWith(
              isLoading: false,
              trendingStores: trendingStores,
              recommendStores: recommendStores,
              newlyStores: newlyStores,
              recentlyStores: recentlyStores,
            ),
          );
        }
      } on PostgrestException catch (e) {
        emit(state.copyWith(isLoading: false, error: e.message));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    });

    on<AddRecentlyStore>((event, emit) async {
      try {
        RecentlyViewedService.addRecentlyViewed(event.storeId);

        final recentlyStoreIds =
            await RecentlyViewedService.getRecentlyViewedIds();
        final recentlyStores = await loadRecentlyStoreUseCase.call(
          recentlyStoreIds,
        );

        emit(state.copyWith(recentlyStores: recentlyStores));
      } catch (e) {
        emit(state.copyWith(error: e.toString()));
      }
    });

    add(LoadingStore());
  }
}
