import 'package:healio_app/features/home/data/models/store_model.dart';
import 'package:healio_app/features/home/domain/repositories/store_repository.dart';

class LoadStoreWithIdUseCase {
  final StoreRepository _storeRepository;

  LoadStoreWithIdUseCase(this._storeRepository);

  Future<StoreModel> call(int currentStoreId, double userLat, double userLng){
    return _storeRepository.getStoreWithId(currentStoreId, userLat, userLng);
  }
}