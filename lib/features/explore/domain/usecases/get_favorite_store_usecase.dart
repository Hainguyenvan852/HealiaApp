import 'package:healio_app/features/explore/domain/repositories/store_repository.dart';
import 'package:healio_app/features/home/data/models/favorite_store_model.dart';

class GetFavoriteStoreUsecase {
  final StoreRepository repository;

  GetFavoriteStoreUsecase(this.repository);

  Future<FavoriteStoreModel?> call(String userId, int storeId){
    return repository.getFavoriteStore(userId, storeId);
  }
}