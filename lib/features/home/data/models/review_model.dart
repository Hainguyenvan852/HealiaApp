import 'package:healio_app/features/home/domain/entities/review_entity.dart';

class ReviewModel extends ReviewEntity{
  ReviewModel({required super.id, required super.customerId, required super.staffId, required super.appointmentId, required super.rating, required super.comment, required super.createdAt});

  factory ReviewModel.fromJson(Map<String, dynamic> json){
    return ReviewModel(
      id: json['id'] as int,
      customerId: json['customer_id'] as String,
      staffId: json['staff_id'] as String,
      appointmentId: json['appointment_id'] as String,
      rating: json['rating'] as double,
      comment: json['comment'] as String?,
      createdAt: json['created_at'] as DateTime
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'customer_id': customerId,
    'staff_id': staffId,
    'appointment_id': appointmentId,
    'rating': rating,
    'comment': comment,
    'created_at': createdAt
  };
}