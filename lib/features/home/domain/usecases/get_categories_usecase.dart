import 'package:healio_app/features/explore/domain/repositories/store_repository.dart';
import 'package:healio_app/features/home/data/models/category_model.dart';

class GetCategoriesUsecase {
  StoreRepository storeRepository;

  GetCategoriesUsecase(this.storeRepository);

  Future<List<CategoryModel>> call(int storeId){
    return storeRepository.getCategoryList(storeId);
  }
}