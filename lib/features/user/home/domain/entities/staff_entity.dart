class StaffEntity {
  String fullName;
  String? notes, avatarUrl, jobTitle, email, phoneNumber;
  DateTime startDate;
  DateTime? birthDay, endDate;
  int id;
  bool isActive;

  StaffEntity({
    required this.id,
    required this.fullName,
    this.email,
    this.phoneNumber,
    this.jobTitle,
    this.birthDay,
    required this.startDate,
    required this.isActive,
    this.endDate,
    this.notes,
    this.avatarUrl,
  });
}
