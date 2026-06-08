part of 'user_address_bloc.dart';

class UserAddressState {
  bool isLoading;
  Object? error;
  AddressModel? homeAddress;
  AddressModel? workAddress;
  List<AddressModel> anotherAddress;

  UserAddressState({this.homeAddress, this.workAddress, required this.anotherAddress, required this.isLoading, this.error});

  factory UserAddressState.initial() =>
      UserAddressState(
        anotherAddress: [],
        isLoading: false
      );

  UserAddressState copyWith({
    bool? isLoading,
    Object? error,
    List<AddressModel>? addresses,
    AddressModel? homeAddress,
    AddressModel? workAddress
  }){
    return UserAddressState(
        anotherAddress: addresses ?? anotherAddress,
        isLoading: isLoading ?? this.isLoading,
        error: error,
        homeAddress: homeAddress ?? this.homeAddress,
        workAddress: workAddress ?? this.workAddress
    );
  }

  UserAddressState update({
    required bool isLoading,
    required Object? error,
    required List<AddressModel> addresses,
    required AddressModel? homeAddress,
    required AddressModel? workAddress
  }){
    return UserAddressState(
        anotherAddress: addresses,
        isLoading: isLoading,
        error: error,
        homeAddress: homeAddress,
        workAddress: workAddress
    );
  }
}