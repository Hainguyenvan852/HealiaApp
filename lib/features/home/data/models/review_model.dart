import 'package:healio_app/features/home/domain/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  ReviewModel({
    required super.id,
    required super.customerId,
    required super.appointmentId,
    required super.rating,
    required super.comment,
    required super.createdAt,
    required super.storeId, 
    required super.customerName,
    required super.avatarUrl
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {

    final createdAt = DateTime.parse(json['created_at']);

    return ReviewModel(
      id: json['id'] as int,
      customerId: json['customer_id'] as String,
      appointmentId: json['appointment_id'] as int,
      rating: json['rating'] as double,
      comment: json['comment'] as String?,
      createdAt: createdAt.toLocal(),
      storeId: json['store_id'] as int, 
      customerName: json['full_name'] as String, 
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'customer_id': customerId,
    'appointment_id': appointmentId,
    'rating': rating,
    'comment': comment,
    'store_id' : storeId
  };
}
