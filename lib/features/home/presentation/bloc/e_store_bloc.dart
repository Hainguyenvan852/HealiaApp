import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:healio_app/core/utils/map_helper.dart';
import 'package:healio_app/features/home/domain/usecases/load_store_with_distance_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/recently_view_service.dart';
import '../../data/models/store_model.dart';

part 'e_store_state.dart';
part 'e_store_event.dart';


class EStoreBloc extends Bloc<EStoreEvent, EStoreState>{
  final LoadStoreWithDistanceUseCase loadStoreWithDistanceUseCase;

  EStoreBloc({
    required this.loadStoreWithDistanceUseCase,
  }) : super(EStoreState.initial()){

    on<LoadingStore>((event, emit) async{
      try{
        emit(state.copyWith(isLoading: true));

        MapHelper.checkPermission();

        Position position = await Geolocator.getCurrentPosition();

        final aroundStores = await loadStoreWithDistanceUseCase.call(position.latitude, position.longitude);

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

    add(LoadingStore());
  }
}