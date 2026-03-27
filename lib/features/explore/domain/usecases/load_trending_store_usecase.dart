import 'package:healio_app/features/explore/data/models/store_model.dart';
import 'package:healio_app/features/explore/domain/repositories/store_repository.dart';

class LoadTrendingStoreUseCase {
  final StoreRepository _storeRepository;

  LoadTrendingStoreUseCase(this._storeRepository);

  Future<List<StoreModel>> call(double userLat, double userLng, double radiusKm) async{
    return _storeRepository.getTrendingStore(userLat, userLng, radiusKm);
  }
}