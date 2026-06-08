import 'package:healio_app/features/user/appointment/data/irepositories/appointment_repository.dart';
import 'package:healio_app/features/user/home/data/models/review_model.dart';

class GetReviewByApmUsecase {
  final AppointmentRepository repository;

  GetReviewByApmUsecase({required this.repository});

  Future<ReviewModel?> call(int apmId){
    return repository.getReviewByApm(apmId);
  }
}