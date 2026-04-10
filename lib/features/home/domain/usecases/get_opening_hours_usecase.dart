import 'package:healio_app/features/explore/domain/repositories/store_repository.dart';
import 'package:healio_app/features/home/data/models/store_working_hour_model.dart';

class GetOpeningHoursUsecase {
  StoreRepository storeRepository;

  GetOpeningHoursUsecase(this.storeRepository);

  Future<List<StoreWorkingHourModel>> call(int storeId){
    return storeRepository.getOpeningHourList(storeId);
  }
}