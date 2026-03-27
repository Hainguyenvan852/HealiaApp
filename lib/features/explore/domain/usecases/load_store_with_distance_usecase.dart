import 'package:healio_app/features/explore/data/models/store_model.dart';
import 'package:healio_app/features/explore/domain/repositories/store_repository.dart';

class LoadStoreWithDistanceUseCase {
  final StoreRepository _storeRepository;

  LoadStoreWithDistanceUseCase(this._storeRepository);

  Future<List<StoreModel>> call(double userLat, double userLng){
    return _storeRepository.getStoreWithDistance(userLat, userLng);
  }
}