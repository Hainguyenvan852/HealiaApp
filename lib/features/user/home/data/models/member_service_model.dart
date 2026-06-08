import 'package:healio_app/features/user/home/domain/entities/member_service_entity.dart';

class MemberServiceModel extends MemberServiceEntity {
  MemberServiceModel({
    required super.id,
    required super.memberId,
    required super.serviceId,
  });

  factory MemberServiceModel.fromJson(Map<String, dynamic> json) {
    return MemberServiceModel(
      id: json['id'] as int,
      memberId: json['member_id'] as int,
      serviceId: json['service_id'] as int,
    );
  }
}
