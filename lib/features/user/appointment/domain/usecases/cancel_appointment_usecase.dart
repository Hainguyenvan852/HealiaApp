import 'package:healio_app/features/user/appointment/data/irepositories/appointment_repository.dart';

class CancelAppointmentUsecase {
  final AppointmentRepository repository;

  CancelAppointmentUsecase({required this.repository});

  Future<bool> call(int apmId){
    return repository.cancelAppointment(apmId);
  }
}