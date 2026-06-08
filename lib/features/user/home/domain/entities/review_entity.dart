class ReviewEntity {
  int id, appointmentId, storeId;
  String customerId;
  String? customerName;
  double rating;
  String? comment, avatarUrl;
  DateTime createdAt;

  ReviewEntity({required this.id, required this.customerId, required this.customerName, required this.appointmentId, required this.rating, required this.comment, required this.createdAt, required this.storeId, this.avatarUrl});
}