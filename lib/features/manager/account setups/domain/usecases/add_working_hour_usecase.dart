import '../repositories/account_setup_repository.dart';

class AddWorkingHourUsecase {
  final AccountSetupRepository repository;

  AddWorkingHourUsecase(this.repository);

  Future<void> call(Map<String, dynamic> workingHourData) async {
    return await repository.addStoreWorkingHour(workingHourData);
  }
}
