import 'package:healio_app/features/home/data/models/store_model.dart';
import 'package:healio_app/features/home/domain/repositories/store_repository.dart';

class LoadRecentlyStoreUseCase {
  final StoreRepository _storeRepository;

  LoadRecentlyStoreUseCase(this._storeRepository);

  Future<List<StoreModel>> call(List<String> storeIdList, double userLat, double userLng) async{
    List<StoreModel> stores = [];
    StoreModel store;
    for (String i in storeIdList){
      store = await _storeRepository.getStoreWithId(int.parse(i), userLat, userLng);
      stores.add(store);
    }

    return stores;
  }
}