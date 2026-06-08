import 'package:healio_app/features/user/profile/data/models/address_model.dart';
import 'package:healio_app/features/user/profile/domain/repositories/user_address_repository.dart';

class GetUserAddressUseCase {
  final UserAddressRepository repository;

  GetUserAddressUseCase(this.repository);

  Future<List<AddressModel>> call(String userId){
    return repository.getUserAddresses(userId);
  }
}