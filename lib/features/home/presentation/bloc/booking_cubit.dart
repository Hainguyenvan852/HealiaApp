import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:healio_app/features/explore/data/models/store_model.dart';
import 'package:healio_app/features/home/data/models/service_model.dart';
import 'package:healio_app/features/home/data/models/team_member_model.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState>{
  BookingCubit() : super(BookingState.initialState());

  void selectStore(StoreModel store){
    emit(state.copyWith(currentStore: store));
  }

  void selectServices(List<ServiceModel> services){
    emit(state.copyWith(services: services));
  }

  void selectProfessional(TeamMemberModel professional){
    emit(state.copyWith(currentProfessional: professional));
  }

  void selectDateTime(DateTime date, TimeOfDay startTime){
    emit(state.copyWith(date: date, startTime: startTime));
  }

  void clearState() => emit(BookingState.initialState());

  void clearServices() => emit(state.clearServices());

  void clearProfessional() => emit(state.clearProfessional());

  void clearDateTime() => emit(state.clearDateTime());

  void clearAllExpectStore() => emit(state.clearAllExpectStore());
}