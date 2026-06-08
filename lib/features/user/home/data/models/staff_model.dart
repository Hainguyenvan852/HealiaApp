import 'package:healio_app/features/user/home/domain/entities/staff_entity.dart';

class StaffModel extends StaffEntity {
  StaffModel({
    required super.id,
    required super.fullName,
    super.email,
    super.phoneNumber,
    super.jobTitle,
    super.birthDay,
    required super.startDate,
    required super.isActive,
    super.endDate,
    super.notes,
    super.avatarUrl,
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    final birthDay = json['birth_day'] != null
        ? DateTime.parse(json['birth_day'] as String)
        : null;
    final startDate = DateTime.parse(json['start_date'] as String);
    final endDate = json['end_date'] != null
        ? DateTime.parse(json['end_date'])
        : null;

    return StaffModel(
      id: json['id'] as int,
      fullName: json['full_name'] as String,
      email: json['email'] as String?,
      phoneNumber: json['phone_number'] as String?,
      jobTitle: json['job_title'] as String?,
      birthDay: birthDay,
      startDate: startDate,
      endDate: endDate,
      notes: json['notes'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      isActive: json['is_active'] as bool,
    );
  }
}
