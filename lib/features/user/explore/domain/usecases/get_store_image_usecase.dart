import 'package:healio_app/features/user/explore/domain/repositories/store_repository.dart';
import 'package:healio_app/features/user/home/data/models/image_model.dart';

class GetStoreImageUseCase {
  final StoreRepository repository;

  GetStoreImageUseCase(this.repository);

  Future<List<ImageModel>> call(int storeId) {
    return repository.getStoreImages(storeId);
  }
}