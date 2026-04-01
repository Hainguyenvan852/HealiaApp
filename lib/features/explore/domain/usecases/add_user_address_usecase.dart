import 'package:healio_app/features/explore/data/models/address_model.dart';
import 'package:healio_app/features/explore/domain/repositories/user_address_repository.dart';

class AddUserAddressUseCase {
  final UserAddressRepository repository;

  AddUserAddressUseCase(this.repository);

  Future<void> call(String userId, AddressModel address){
    return repository.addUserAddress(userId, address);
  }
}