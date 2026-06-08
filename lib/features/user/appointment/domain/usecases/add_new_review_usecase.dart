import 'package:healio_app/features/user/appointment/data/irepositories/appointment_repository.dart';
import 'package:healio_app/features/user/home/data/models/review_model.dart';

class AddNewReviewUsecase {
  final AppointmentRepository repository;

  AddNewReviewUsecase({required this.repository});

  Future<bool> call(ReviewModel review){
    return repository.addReview(review);
  }
}