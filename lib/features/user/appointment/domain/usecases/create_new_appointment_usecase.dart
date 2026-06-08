import 'package:healio_app/features/user/appointment/data/irepositories/appointment_repository.dart';
import 'package:healio_app/features/user/appointment/data/models/appointment_model.dart';

class CreateNewAppointmentUseCase {
  final AppointmentRepository repository;

  CreateNewAppointmentUseCase({required this.repository});

  Future<int?> call(AppointmentModel newApm) {
    return repository.creatNewAppointment(newApm);
  }
}
