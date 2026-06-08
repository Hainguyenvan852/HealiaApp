import 'package:healio_app/features/user/explore/domain/repositories/store_repository.dart';

class InsertFavoriteStoreUsecase {
  final StoreRepository repository;

  InsertFavoriteStoreUsecase(this.repository);

  Future<void> call(String userId, int storeId){
    return repository.insertFavoriteStores(userId, storeId);
  }
}