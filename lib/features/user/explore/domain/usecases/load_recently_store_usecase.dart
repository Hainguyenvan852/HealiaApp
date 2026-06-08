import 'package:healio_app/features/user/explore/data/models/store_model.dart';
import 'package:healio_app/features/user/explore/domain/repositories/store_repository.dart';

class LoadRecentlyStoreUseCase {
  final StoreRepository _storeRepository;

  LoadRecentlyStoreUseCase(this._storeRepository);

  Future<List<StoreModel>> call(List<String> storeIdList) async{
    List<StoreModel> stores = [];
    StoreModel store;
    for (String i in storeIdList){
      store = await _storeRepository.getStoreWithId(int.parse(i));
      stores.add(store);
    }

    return stores;
  }
}