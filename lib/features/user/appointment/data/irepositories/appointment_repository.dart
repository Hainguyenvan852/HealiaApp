import 'package:healio_app/features/user/appointment/data/datasource/appointment_datasource.dart';
import 'package:healio_app/features/user/appointment/data/models/appointment_model.dart';
import 'package:healio_app/features/user/home/data/models/review_model.dart';

class AppointmentRepository {
  final AppointmentDatasource dataSource;

  AppointmentRepository({required this.dataSource});

  Future<List<AppointmentModel>> getAppointments(String userId) {
    return dataSource.fetchCustomerAppointments(userId);
  }

  Future<List<AppointmentModel>> getAppointmentsByDay(
    String userId,
    DateTime date,
  ) {
    return dataSource.fetchAppointmentsByDay(userId, date);
  }

  Future<int?> creatNewAppointment(AppointmentModel newApm) {
    return dataSource.createNewAppointment(newApm);
  }

  Future<ReviewModel?> getReviewByApm(int apmId) async {
    return dataSource.getReviewByApm(apmId);
  }

  Future<bool> addReview(ReviewModel newReview) {
    return dataSource.addReview(newReview);
  }

  Future<bool> cancelAppointment(int apmId) {
    return dataSource.cancelAppointment(apmId);
  }

  Future<bool> requestCancelAppointment(int apmId, String reason) {
    return dataSource.requestCancelAppointment(apmId, reason);
  }

  Future<bool> updateAppointmentTimeAndNotes(
    int apmId,
    DateTime startTime,
    DateTime endTime,
    String? notes,
  ) {
    return dataSource.updateAppointmentTimeAndNotes(
      apmId,
      startTime,
      endTime,
      notes,
    );
  }
}
