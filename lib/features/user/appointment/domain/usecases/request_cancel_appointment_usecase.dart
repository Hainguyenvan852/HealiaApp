import 'package:healio_app/features/user/appointment/data/irepositories/appointment_repository.dart';

class RequestCancelAppointmentUseCase {
  final AppointmentRepository repository;

  RequestCancelAppointmentUseCase({required this.repository});

  Future<bool> call(int apmId, String reason) {
    return repository.requestCancelAppointment(apmId, reason);
  }
}
