import 'package:healio_app/features/user/appointment/data/irepositories/appointment_repository.dart';
import 'package:healio_app/features/user/appointment/data/models/appointment_model.dart';

class GetUserAppointmentUsecase {
  final AppointmentRepository repository;

  GetUserAppointmentUsecase({required this.repository});

  Future<List<AppointmentModel>> call(String userId){
    return repository.getAppointments(userId);
  }
}