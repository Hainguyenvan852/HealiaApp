class UserEntity {
  String id;
  String fullName;
  String email;
  String? avatarUrl;
  String? phoneNumber;
  DateTime? dateOfBirth;
  String? gender;

  UserEntity({required this.id, required this.fullName, required this.email, this.avatarUrl, this.phoneNumber, this.dateOfBirth, this.gender});
}