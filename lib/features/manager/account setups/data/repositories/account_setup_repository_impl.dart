import 'package:healio_app/features/user/explore/data/models/store_model.dart';
import 'package:healio_app/features/user/home/data/models/category_model.dart';

import '../../domain/repositories/account_setup_repository.dart';
import '../datasources/account_setup_datasource.dart';

class AccountSetupRepositoryImpl implements AccountSetupRepository {
  final AccountSetupDatasource _datasource;

  AccountSetupRepositoryImpl(this._datasource);

  @override
  Future<StoreModel> addStore(Map<String, dynamic> storeData) async {
    return await _datasource.addStore(storeData);
  }

  @override
  Future<void> addStaff(Map<String, dynamic> staffData) async {
    return await _datasource.addStaff(staffData);
  }

  @override
  Future<CategoryModel> addCategory(Map<String, dynamic> categoryData) async{
    return await _datasource.addCategory(categoryData);
  }

  @override
  Future<void> addService(Map<String, dynamic> serviceData) async{
    return await _datasource.addService(serviceData);
  }
  
  @override
  Future<void> addStoreWorkingHour(Map<String, dynamic> workingHourData) {
    return _datasource.addStoreWorkingHour(workingHourData);
  }
}
