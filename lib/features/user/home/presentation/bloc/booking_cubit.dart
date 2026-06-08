import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healio_app/features/user/explore/data/models/store_model.dart';
import 'package:healio_app/features/user/home/data/models/service_model.dart';
import 'package:healio_app/features/user/home/data/models/staff_model.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(BookingState.initialState());

  void selectStore(StoreModel store) {
    emit(state.copyWith(currentStore: store));
  }

  void selectServices(List<ServiceModel> services) {
    emit(state.copyWith(services: services));
  }

  void selectProfessional(StaffModel professional) {
    emit(state.copyWith(currentProfessional: professional));
  }

  void selectDateTime(DateTime date, DateTime startTime) {
    emit(state.copyWith(date: date, startTime: startTime));
  }

  void clearState() => emit(BookingState.initialState());

  void clearServices() => emit(state.clearServices());

  void clearProfessional() => emit(state.clearProfessional());

  void clearDateTime() => emit(state.clearDateTime());

  void clearAllExpectStore() => emit(state.clearAllExpectStore());
}
