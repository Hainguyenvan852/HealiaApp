import 'package:healio_app/features/home/data/models/store_model.dart';
import 'package:healio_app/features/home/domain/repositories/store_repository.dart';

class LoadRecommendStoreUseCase {
  final StoreRepository _storeRepository;

  LoadRecommendStoreUseCase(this._storeRepository);

  Future<List<StoreModel>> call(String? userId, double userLat, double userLng, double radiusKm) async{
    return _storeRepository.getRecommendStore(userId, userLat, userLng, radiusKm);
  }
}