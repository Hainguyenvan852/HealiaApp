import 'package:healio_app/features/user/explore/data/models/store_model.dart';
import 'package:healio_app/features/user/explore/domain/repositories/store_repository.dart';

class LoadTrendingStoreUseCase {
  final StoreRepository _storeRepository;

  LoadTrendingStoreUseCase(this._storeRepository);

  Future<List<StoreModel>> call() async{
    return _storeRepository.getTrendingStore();
  }
}