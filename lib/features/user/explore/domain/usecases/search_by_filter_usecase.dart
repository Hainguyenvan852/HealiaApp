import 'package:healio_app/features/user/explore/data/models/store_model.dart';
import 'package:healio_app/features/user/explore/domain/repositories/store_repository.dart';

class SearchByFilterUseCase {
  final StoreRepository _storeRepository;

  SearchByFilterUseCase(this._storeRepository);

  Future<List<StoreModel>> call(String filter, double userLat, double userLng, double radiusKm) async{
    return _storeRepository.searchByFilter(filter,userLat, userLng, radiusKm);
  }
}