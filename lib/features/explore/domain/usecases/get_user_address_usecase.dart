import 'package:healio_app/features/explore/data/models/address_model.dart';
import 'package:healio_app/features/explore/domain/repositories/user_address_repository.dart';

class GetUserAddressUseCase {
  final UserAddressRepository repository;

  GetUserAddressUseCase(this.repository);

  Future<List<AddressModel>> call(String userId){
    return repository.getUserAddresses(userId);
  }
}