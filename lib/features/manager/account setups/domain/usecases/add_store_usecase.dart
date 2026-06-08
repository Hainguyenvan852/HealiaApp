import 'package:healio_app/features/user/explore/data/models/store_model.dart';

import '../repositories/account_setup_repository.dart';

class AddStoreUsecase {
  final AccountSetupRepository repository;

  AddStoreUsecase(this.repository);

  Future<StoreModel> call(Map<String, dynamic> storeData) async {
    return await repository.addStore(storeData);
  }
}
