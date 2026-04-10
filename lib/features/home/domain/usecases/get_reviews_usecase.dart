import 'package:healio_app/features/explore/domain/repositories/store_repository.dart';
import 'package:healio_app/features/home/data/models/review_model.dart';

class GetReviewsUsecase {
  StoreRepository storeRepository;

  GetReviewsUsecase(this.storeRepository);

  Future<List<ReviewModel>> call(int storeId){
    return storeRepository.getReviewList(storeId);
  }
}