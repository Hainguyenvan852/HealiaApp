import 'package:healio_app/features/user/appointment/data/irepositories/appointment_repository.dart';
import 'package:healio_app/features/user/appointment/data/models/appointment_model.dart';

class GetUserAppointmentByDayUsecase {
  final AppointmentRepository repository;

  GetUserAppointmentByDayUsecase({required this.repository});

  Future<List<AppointmentModel>> call(String userId, DateTime date){
    return repository.getAppointmentsByDay(userId, date);
  }
}