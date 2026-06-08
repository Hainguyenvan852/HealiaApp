import 'package:healio_app/features/user/appointment/data/irepositories/appointment_repository.dart';

class UpdateAppointmentUseCase {
  final AppointmentRepository repository;

  UpdateAppointmentUseCase({required this.repository});

  Future<bool> call(int apmId, DateTime startTime, DateTime endTime, String? notes) {
    return repository.updateAppointmentTimeAndNotes(apmId, startTime, endTime, notes);
  }
}
