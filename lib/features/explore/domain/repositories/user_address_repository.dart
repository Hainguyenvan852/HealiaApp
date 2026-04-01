import 'package:healio_app/features/explore/data/models/address_model.dart';

abstract class UserAddressRepository {
  Future<List<AddressModel>> getUserAddresses(String userId);
  Future<void> addUserAddress(String userId, AddressModel address);
  Future<void> deleteUserAddress(int addressId);
  Future<void> updateUserAddress(AddressModel address);
}