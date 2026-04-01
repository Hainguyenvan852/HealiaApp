import 'package:healio_app/features/explore/data/models/store_model.dart';
import 'package:healio_app/features/explore/domain/repositories/store_repository.dart';

class LoadNewlyStoreUseCase {
  final StoreRepository _storeRepository;

  LoadNewlyStoreUseCase(this._storeRepository);

  Future<List<StoreModel>> call(double userLat, double userLng, double radiusKm) {
    return _storeRepository.getNewlyStore(userLat, userLng, radiusKm);
  }
}