import 'package:healio_app/features/home/domain/entities/team_member_entity.dart';

class TeamMemberModel extends TeamMemberEntity {
  TeamMemberModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.phoneNumber,
    required super.jobTitle,
    required super.birthDay,
    required super.startDate,
    super.endDate,
    super.notes,
    super.avatarUrl
  });

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) {
    final birthDay = DateTime.parse(json['birth_day'] as String);
    final startDate = DateTime.parse(json['start_date'] as String);
    final endDate = json['start_date'] != null ? DateTime.parse(json['start_date']) : null;

    return TeamMemberModel(
      id: json['id'] as int,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String,
      jobTitle: json['job_title'] as String,
      birthDay:  birthDay,
      startDate: startDate,
      endDate: endDate,
      notes: json['notes'] as String?,
      avatarUrl: json['avatar_url'] as String?
    );
  }
}
