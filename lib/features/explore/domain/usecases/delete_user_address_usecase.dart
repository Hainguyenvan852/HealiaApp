import 'package:healio_app/features/explore/domain/repositories/user_address_repository.dart';

class DeleteUserAddressUseCase {
  final UserAddressRepository repository;

  DeleteUserAddressUseCase(this.repository);

  Future<void> call(int userId){
    return repository.deleteUserAddress(userId);
  }
}