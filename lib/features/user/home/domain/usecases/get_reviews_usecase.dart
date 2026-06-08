import 'package:healio_app/features/user/explore/domain/repositories/store_repository.dart';
import 'package:healio_app/features/user/home/data/models/review_model.dart';

class GetReviewsByStoreUsecase {
  StoreRepository storeRepository;

  GetReviewsByStoreUsecase(this.storeRepository);

  Future<List<ReviewModel>> call(int storeId){
    return storeRepository.getReviewList(storeId);
  }
}