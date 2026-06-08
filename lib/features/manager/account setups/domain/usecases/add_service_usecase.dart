import '../repositories/account_setup_repository.dart';

class AddServiceUsecase {
  final AccountSetupRepository repository;

  AddServiceUsecase(this.repository);

  Future<void> call(Map<String, dynamic> serviceData) async {
    return await repository.addService(serviceData);
  }
}
