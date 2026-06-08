import '../repositories/account_setup_repository.dart';

class AddStaffUsecase {
  final AccountSetupRepository repository;

  AddStaffUsecase(this.repository);

  Future<void> call(Map<String, dynamic> staffData) async {
    return await repository.addStaff(staffData);
  }
}
