import 'package:healio_app/features/user/explore/data/models/store_model.dart';
import 'package:healio_app/features/user/explore/domain/repositories/store_repository.dart';

class LoadRecommendStoreUseCase {
  final StoreRepository _storeRepository;

  LoadRecommendStoreUseCase(this._storeRepository);

  Future<List<StoreModel>> call(String? userId) async{
    return _storeRepository.getRecommendStore(userId);
  }
}