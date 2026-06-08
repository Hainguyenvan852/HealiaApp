import 'package:healio_app/features/user/explore/data/models/store_model.dart';
import 'package:healio_app/features/user/explore/domain/repositories/store_repository.dart';

class SearchByDateUseCase {
  final StoreRepository _storeRepository;

  SearchByDateUseCase(this._storeRepository);

  Future<List<StoreModel>> call(DateTime date, double userLat, double userLng, double radiusKm) async{
    return _storeRepository.searchByDate(date, userLat, userLng, radiusKm);
  }
}