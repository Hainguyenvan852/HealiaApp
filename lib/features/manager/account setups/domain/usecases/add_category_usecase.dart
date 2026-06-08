import 'package:healio_app/features/user/home/data/models/category_model.dart';

import '../repositories/account_setup_repository.dart';

class AddCategoryUsecase {
  final AccountSetupRepository repository;

  AddCategoryUsecase(this.repository);

  Future<CategoryModel> call(Map<String, dynamic> categoryData) async {
    return await repository.addCategory(categoryData);
  }
}
