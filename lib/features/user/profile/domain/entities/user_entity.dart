class UserEntity {
  String id;
  String fullName;
  String email;
  String? avatarUrl;
  String? phoneNumber;
  DateTime? dateOfBirth;
  int gender;
  String role;
  bool? verifyStore;

  UserEntity({required this.id, required this.fullName, required this.email, this.avatarUrl, this.phoneNumber, this.dateOfBirth, required this.gender, required this.role, this.verifyStore});
}