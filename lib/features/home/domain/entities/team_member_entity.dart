class TeamMemberEntity {
  String fullName, email, phoneNumber, jobTitle;
  String? notes, avatarUrl;
  DateTime birthDay, startDate;
  DateTime? endDate;
  int id;

  TeamMemberEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.jobTitle,
    required this.birthDay,
    required this.startDate,
    this.endDate,
    this.notes, 
    this.avatarUrl
  });
}
