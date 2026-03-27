import 'package:healio_app/features/explore/data/models/store_model.dart';
import 'package:healio_app/features/explore/domain/repositories/store_repository.dart';

class SearchByCategoryUseCase {
  final StoreRepository _storeRepository;

  SearchByCategoryUseCase(this._storeRepository);

  Future<List<StoreModel>> call(String category, double userLat, double userLng, double radiusKm) async{
    return _storeRepository.searchByCategory(category, userLat, userLng, radiusKm);
  }
}