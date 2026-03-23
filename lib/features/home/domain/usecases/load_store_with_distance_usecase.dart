import 'package:healio_app/features/home/data/models/store_model.dart';
import 'package:healio_app/features/home/domain/repositories/store_repository.dart';

class LoadStoreWithDistanceUseCase {
  final StoreRepository _storeRepository;

  LoadStoreWithDistanceUseCase(this._storeRepository);

  Future<List<StoreModel>> call(double userLat, double userLng){
    return _storeRepository.getStoreWithDistance(userLat, userLng);
  }
}