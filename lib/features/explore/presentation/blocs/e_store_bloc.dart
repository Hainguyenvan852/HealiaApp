import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:healio_app/core/utils/map_helper.dart';
import 'package:healio_app/features/explore/domain/usecases/load_store_with_distance_usecase.dart';
import 'package:healio_app/features/explore/domain/usecases/search_by_all_filter_usecase.dart';
import 'package:healio_app/features/explore/domain/usecases/search_by_category_usecase.dart';
import 'package:healio_app/features/explore/domain/usecases/search_by_date_usecase.dart';
import 'package:healio_app/features/explore/domain/usecases/search_by_datetime_usecase.dart';
import 'package:healio_app/features/explore/domain/usecases/search_by_filter_usecase.dart';
import 'package:healio_app/features/explore/domain/usecases/search_by_time_usecase.dart';
import 'package:healio_app/features/explore/domain/usecases/search_store_around_location_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/recently_view_service.dart';
import '../../data/models/store_model.dart';

part 'e_store_state.dart';
part 'e_store_event.dart';


class EStoreBloc extends Bloc<EStoreEvent, EStoreState>{
  final LoadStoreWithDistanceUseCase loadStoreWithDistanceUseCase;
  final SearchByAllFilterUseCase searchByAllFilterUseCase;
  final SearchByCategoryUseCase searchByCategoryUseCase;
  final SearchByFilterUseCase searchByFilterUseCase;
  final SearchByDateTimeUseCase searchByDateTimeUseCase;
  final SearchByDateUseCase searchByDateUseCase;
  final SearchByTimeUseCase searchByTimeUseCase;
  final SearchStoreAroundLocationUseCase searchStoreAroundLocationUseCase;

  EStoreBloc({
    required this.loadStoreWithDistanceUseCase,
    required this.searchByAllFilterUseCase,
    required this.searchByCategoryUseCase,
    required this.searchByFilterUseCase,
    required this.searchByDateTimeUseCase,
    required this.searchByDateUseCase,
    required this.searchByTimeUseCase,
    required this.searchStoreAroundLocationUseCase,
  }) : super(EStoreState.initial()){

    on<LoadingStore>((event, emit) async{
      try{
        emit(state.copyWith(isLoading: true));

        MapHelper.checkPermission();

        Position position = await Geolocator.getCurrentPosition();

        final aroundStores = await searchStoreAroundLocationUseCase.call(position.latitude, position.longitude, 100);

        emit(state.copyWith(isLoading: false, aroundStores: aroundStores,));
      } on PostgrestException catch (e){
        emit(state.copyWith(isLoading: false, error: e.message));
      } catch (e){
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    });

    on<AddRecentlyStore>((event, emit) async{
      try{
        RecentlyViewedService.addRecentlyViewed(event.storeId);
      } catch (e){
        emit(state.copyWith(error: e.toString()));
      }
    });

    on<SearchByFilter>((event, emit) async{
      try{
        emit(state.copyWith(isSearching: true));

        List<StoreModel> searchStores = [];

        if(event.category != null && event.startTime != null && event.date != null && event.endTime != null){
          searchStores = await searchByAllFilterUseCase.call(event.category!, event.startTime!, event.endTime!, event.date!, event.userLat, event.userLng, event.radiusKm);
        } else if(event.filter != null && event.startTime == null && event.endTime == null && event.date == null && event.category == null){
          searchStores = await searchByFilterUseCase.call(event.filter!, event.userLat, event.userLng, event.radiusKm);
        } else if(event.filter == null && event.startTime != null && event.endTime != null && event.date != null && event.category == null){
          searchStores = await searchByDateTimeUseCase.call(event.startTime!, event.endTime!, event.date!, event.userLat, event.userLng, event.radiusKm);
        } else if(event.filter == null && event.startTime == null && event.endTime == null && event.date != null && event.category == null){
          searchStores = await searchByDateUseCase.call(event.date!, event.userLat, event.userLng, event.radiusKm);
        } else if(event.category != null && event.startTime == null && event.endTime == null && event.date == null && event.filter == null){
          searchStores = await searchByCategoryUseCase.call(event.category!, event.userLat, event.userLng, event.radiusKm);
        } else if(event.category == null && event.startTime != null && event.endTime != null && event.date == null && event.filter == null){
          searchStores = await searchByTimeUseCase.call(event.startTime!, event.endTime!, event.userLat, event.userLng, event.radiusKm);
        } else if(event.category == null && event.startTime == null && event.endTime == null && event.date == null && event.filter == null){
          searchStores = await searchStoreAroundLocationUseCase.call(event.userLat, event.userLng, event.radiusKm);
        }

        emit(state.copyWith(isSearching: false, searchStores: searchStores,));
      } on PostgrestException catch (e){
        emit(state.copyWith(isSearching: false, error: e.message));
      } catch (e){
        emit(state.copyWith(isSearching: false, error: e.toString()));
      }
    });

    on<ClearSearch>((event, emit) async{
      emit(state.copyWith(isSearching: true));

      await Future.delayed(Duration(milliseconds: 1000));

      emit(state.copyWith(isSearching: false, searchStores: null));
    });

    add(LoadingStore());
  }
}