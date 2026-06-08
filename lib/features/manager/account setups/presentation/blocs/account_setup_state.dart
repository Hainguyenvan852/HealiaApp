import 'package:equatable/equatable.dart';

class AccountSetupState extends Equatable {
  final String? businessName;
  final String? primaryCategory;
  final String? secondaryCategory;
  final int? accountType;
  final int? teamSize;
  final String? address;
  final double? lat;
  final double? lng;
  final String? province;

  const AccountSetupState({
    this.businessName,
    this.primaryCategory,
    this.secondaryCategory,
    this.accountType,
    this.teamSize,
    this.address,
    this.lat,
    this.lng,
    this.province
  });

  AccountSetupState copyWith({
    String? businessName,
    String? primaryCategory,
    String? secondaryCategory,
    int? accountType,
    int? teamSize,
    String? address,
    double? lat,
    double? lng,
    String? province
  }) {
    return AccountSetupState(
      businessName: businessName ?? this.businessName,
      primaryCategory: primaryCategory ?? this.primaryCategory,
      secondaryCategory: secondaryCategory ?? this.secondaryCategory,
      accountType: accountType ?? this.accountType,
      teamSize: teamSize ?? this.teamSize,
      address: address ?? this.address,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      province: province ?? this.province
    );
  }

  @override
  List<Object?> get props => [
    businessName,
    primaryCategory,
    secondaryCategory,
    accountType,
    teamSize,
    address,
    lat,
    lng,
    province
  ];
}
