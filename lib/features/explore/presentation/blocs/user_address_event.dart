part of 'user_address_bloc.dart';

abstract class UserAddressEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class GetUserAddress extends UserAddressEvent{
  final String userId;

  GetUserAddress({required this.userId});

  @override
  List<Object> get props => [userId];
}

class AddUserAddress extends UserAddressEvent{
  final String userId;
  final AddressModel address;

  AddUserAddress({required this.userId, required this.address});

  @override
  List<Object> get props => [userId, address];
}

class ClearUserAddress extends UserAddressEvent {
  @override
  List<Object> get props => [];
}

class UpdateUserAddress extends UserAddressEvent {
  final AddressModel address;
  final String userId;

  UpdateUserAddress({required this.address, required this.userId});

  @override
  List<Object> get props => [address];
}

class DeleteUserAddress extends UserAddressEvent {
  final int addressId;
  final String userId;

  DeleteUserAddress({required this.addressId, required this.userId});

  @override
  List<Object> get props => [addressId, userId];
}

class ClearError extends UserAddressEvent{
  
}