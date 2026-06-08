import 'package:healio_app/features/user/explore/data/models/store_model.dart';
import 'package:healio_app/features/user/explore/domain/repositories/store_repository.dart';

class LoadStoreWithIdUseCase {
  final StoreRepository _storeRepository;

  LoadStoreWithIdUseCase(this._storeRepository);

  Future<StoreModel> call(int currentStoreId){
    return _storeRepository.getStoreWithId(currentStoreId);
  }
}