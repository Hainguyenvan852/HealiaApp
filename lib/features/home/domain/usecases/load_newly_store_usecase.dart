import 'package:healio_app/features/home/data/models/store_model.dart';
import 'package:healio_app/features/home/domain/repositories/store_repository.dart';

class LoadNewlyStoreUseCase {
  final StoreRepository _storeRepository;

  LoadNewlyStoreUseCase(this._storeRepository);

  Future<List<StoreModel>> call(double userLat, double userLng, double radiusKm) async{
    return _storeRepository.getNewlyStore(userLat, userLng, radiusKm);
  }
}