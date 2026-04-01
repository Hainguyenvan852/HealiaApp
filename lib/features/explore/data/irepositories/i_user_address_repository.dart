import 'package:healio_app/features/explore/data/datasources/user_address_datasource.dart';
import 'package:healio_app/features/explore/data/models/address_model.dart';
import 'package:healio_app/features/explore/domain/repositories/user_address_repository.dart';

class IUserAddressRepository extends UserAddressRepository{
  final UserAddressDatasource datasource;

  IUserAddressRepository(this.datasource);

  @override
  Future<void> addUserAddress(String userId, AddressModel address) async {
    await datasource.insertUserAddress(userId, address);
  }

  @override
  Future<List<AddressModel>> getUserAddresses(String userId) {
    return datasource.fetchUserAddress(userId);
  }

  @override
  Future<void> deleteUserAddress(int addressId) async{
    await datasource.deleteUserAddress(addressId);
  }

  @override
  Future<void> updateUserAddress(AddressModel address) async{
    await datasource.updateUserAddress(address);
  }

}