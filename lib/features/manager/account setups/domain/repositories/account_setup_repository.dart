import 'package:healio_app/features/user/explore/data/models/store_model.dart';
import 'package:healio_app/features/user/home/data/models/category_model.dart';

abstract class AccountSetupRepository {
  Future<StoreModel> addStore(Map<String, dynamic> storeData);
  Future<void> addStaff(Map<String, dynamic> staffData);
  Future<CategoryModel> addCategory(Map<String, dynamic> categoryData);
  Future<void> addService(Map<String, dynamic> serviceData);
  Future<void> addStoreWorkingHour(Map<String, dynamic> workingHourData);
}
