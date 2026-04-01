import 'package:healio_app/features/explore/data/models/address_model.dart';
import 'package:healio_app/features/explore/domain/repositories/user_address_repository.dart';

class UpdateUserAddressUseCase {
  final UserAddressRepository repository;

  UpdateUserAddressUseCase(this.repository);

  Future<void> call(AddressModel address){
    return repository.updateUserAddress(address);
  }
}