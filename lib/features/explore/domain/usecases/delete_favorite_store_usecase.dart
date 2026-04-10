import 'package:healio_app/features/explore/domain/repositories/store_repository.dart';

class DeleteFavoriteStoreUsecase {
  final StoreRepository repository;

  DeleteFavoriteStoreUsecase(this.repository);

  Future<void> call(String userId, int storeId){
    return repository.deleteFavoriteStores(userId, storeId);
  }
}