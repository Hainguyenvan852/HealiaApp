import 'package:healio_app/features/explore/domain/repositories/store_repository.dart';
import 'package:healio_app/features/home/data/models/favorite_store_model.dart';

class GetFavoriteStoresUsecase {
  final StoreRepository repository;

  GetFavoriteStoresUsecase(this.repository);

  Future<List<FavoriteStoreModel>> call(String userId){
    return repository.getFavoriteStores(userId);
  }
}