import 'package:healio_app/features/user/explore/domain/repositories/store_repository.dart';
import 'package:healio_app/features/user/home/data/models/service_model.dart';

class GetServicesUsecase {
  StoreRepository storeRepository;

  GetServicesUsecase(this.storeRepository);

  Future<List<ServiceModel>> call(int categoryId){
    return storeRepository.getServiceList(categoryId);
  }
}