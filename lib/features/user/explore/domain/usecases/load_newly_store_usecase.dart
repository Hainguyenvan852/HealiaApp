import 'package:healio_app/features/user/explore/data/models/store_model.dart';
import 'package:healio_app/features/user/explore/domain/repositories/store_repository.dart';

class LoadNewlyStoreUseCase {
  final StoreRepository _storeRepository;

  LoadNewlyStoreUseCase(this._storeRepository);

  Future<List<StoreModel>> call() {
    return _storeRepository.getNewlyStore();
  }
}